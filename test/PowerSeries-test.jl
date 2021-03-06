function test_series_constructors()
   print("PowerSeries.constructors...")

   R, x = PowerSeriesRing(ZZ, "x")

   @test R <: PowerSeries

   a = x^3 + 2x + 1
   b = x^2 + 3x + O(x^4)

   @test isa(R(a), PowerSeries)

   @test isa(PowerSeries(R, [ZZ(1), ZZ(2), ZZ(3)], 5), PowerSeries)

   @test isa(PowerSeries(R, [ZZ(1), ZZ(2), ZZ(3)], nothing), PowerSeries)

   @test isa(R(1), PowerSeries)

   @test isa(R(ZZ(2)), PowerSeries)

   @test isa(R(), PowerSeries)

   println("PASS")
end

function test_series_manipulation()
   print("PowerSeries.manipulation...")

   R, x = PowerSeriesRing(ZZ, "x")

   a = 2x + x^3
   b = O(x^4)

   @test isgen(gen(R))

   @test iszero(zero(R))

   @test isone(one(R))

   @test isunit(-1 + x + 2x^2)

   @test valuation(a) == 1

   @test valuation(b) == 4

   println("PASS")
end

function test_series_unary_ops()
   print("PowerSeries.unary_ops...")

   R, x = PowerSeriesRing(ZZ, "x")

   a = 2x + x^3
   b = 1 + 2x + x^2 + O(x^3)

   @test -a == -2x - x^3
   
   @test -b == -1 - 2x - x^2 + O(x^3)

   println("PASS")
end

function test_series_binary_ops()
   print("PowerSeries.binary_ops...")

   R, x = PowerSeriesRing(ZZ, "x")

   a = 2x + x^3
   b = O(x^4)
   c = 1 + x + 3x^2 + O(x^5)
   d = x^2 + 3x^3 - x^4

   @test a + b == x^3+2*x+O(x^4)

   @test a - c == x^3-3*x^2+x-1+O(x^5)

   @test b*c == O(x^4)

   @test a*c == 3*x^5+x^4+7*x^3+2*x^2+2*x+O(x^6)

   @test a*d == -x^7+3*x^6-x^5+6*x^4+2*x^3

   println("PASS")
end

function test_series_adhoc_binary_ops()
   print("PowerSeries.adhoc_binary_ops...")

   R, x = PowerSeriesRing(ZZ, "x")

   a = 2x + x^3
   b = O(x^4)
   c = 1 + x + 3x^2 + O(x^5)
   d = x^2 + 3x^3 - x^4

   @test 2a == 4x + 2x^3

   @test ZZ(3)*b == O(x^4)

   @test c*2 == 2 + 2*x + 6*x^2 + O(x^5)

   @test d*ZZ(3) == 3x^2 + 9x^3 - 3x^4

   println("PASS")
end

function test_series_comparison()
   print("PowerSeries.comparison...")

   R, x = PowerSeriesRing(ZZ, "x")

   a = 2x + x^3
   b = O(x^3)
   c = 1 + x + 3x^2 + O(x^5)
   d = 3x^3 - x^4

   @test a == 2x + x^3

   @test b == d

   @test c != d

   println("PASS")
end

function test_series_adhoc_comparison()
   print("PowerSeries.adhoc_comparison...")

   R, x = PowerSeriesRing(ZZ, "x")

   a = 2x + x^3
   b = O(x^0)
   c = 1 + O(x^5)
   d = R(3)

   @test d == 3

   @test c == ZZ(1)

   @test ZZ(0) != a

   @test 2 == b

   @test ZZ(1) == c

   println("PASS")
end

function test_series_powering()
   print("PowerSeries.powering...")

   R, x = PowerSeriesRing(ZZ, "x")

   a = 2x + x^3
   b = O(x^4)
   c = 1 + x + 2x^2 + O(x^5)
   d = 2x + x^3 + O(x^4)

   @test a^12 == x^36+24*x^34+264*x^32+1760*x^30+7920*x^28+25344*x^26+59136*x^24+101376*x^22+126720*x^20+112640*x^18+67584*x^16+24576*x^14+4096*x^12

   @test b^12 == O(x^48)

   @test c^12 == 2079*x^4+484*x^3+90*x^2+12*x+1+O(x^5)

   @test d^12 == 4096*x^12+24576*x^14+O(x^15)

   println("PASS")
end

function test_series_shift()
   print("PowerSeries.shift...")

   R, x = PowerSeriesRing(ZZ, "x")

   a = 2x + x^3
   b = O(x^4)
   c = 1 + x + 2x^2 + O(x^5)
   d = 2x + x^3 + O(x^4)

   @test shift_left(a, 2) == 2*x^3+x^5

   @test shift_left(b, 2) == O(x^6)

   @test shift_right(c, 1) == 1+2*x+O(x^4)

   @test shift_right(d, 3) == 1+O(x^1)

   println("PASS")
end

function test_series_truncation()
   print("PowerSeries.truncation...")

   R, x = PowerSeriesRing(ZZ, "x")

   a = 2x + x^3
   b = O(x^4)
   c = 1 + x + 2x^2 + O(x^5)
   d = 2x + x^3 + O(x^4)

   @test truncate(a, 3) == 2*x + O(x^3)

   @test truncate(b, 2) == O(x^2)

   @test truncate(c, nothing) == 2*x^2+x+1+O(x^5)

   @test truncate(d, 5) == x^3+2*x+O(x^4)

   println("PASS")
end

function test_series_exact_division()
   print("PowerSeries.exact_division...")

   R, x = PowerSeriesRing(ZZ, "x")

   a = x + x^3
   b = O(x^4)
   c = 1 + x + 2x^2 + O(x^5)
   d = x + x^3 + O(x^6)

   @test divexact(a, d) == 1+O(x^5)

   @test divexact(d, a) == 1+O(x^5)

   @test divexact(b, c) == O(x^4)

   @test divexact(d, c) == -2*x^5+2*x^4-x^2+x+O(x^6)

   println("PASS")
end

function test_series_inversion()
   print("PowerSeries.inversion...")

   R, x = PowerSeriesRing(ZZ, "x")

   a = 1 + x + 2x^2 + O(x^5)
   b = R(-1)

   @test inv(a) == -x^4+3*x^3-x^2-x+1+O(x^5)

   @test inv(b) == -1

   println("PASS")
end

function test_series_special_functions()
   print("PowerSeries.special_functions...")

   R = ResidueRing(ZZ, 17)
   S, x = PowerSeriesRing(R, "x")

   @test exp(x + O(x^10)) == 8*x^9+4*x^8+15*x^7+3*x^6+x^5+5*x^4+3*x^3+9*x^2+x+1+O(x^10)

   @test divexact(x, exp(x + O(x^10)) - 1) == x^8+11*x^6+14*x^4+10*x^2+8*x+1+O(x^9)

   println("PASS")
end

function test_series()
   test_series_constructors()
   test_series_manipulation()
   test_series_unary_ops()
   test_series_binary_ops()
   test_series_adhoc_binary_ops()
   test_series_comparison()
   test_series_adhoc_comparison()
   test_series_powering()
   test_series_shift()
   test_series_truncation()
   test_series_exact_division()
   test_series_inversion()
   test_series_special_functions()

   println("")
end
