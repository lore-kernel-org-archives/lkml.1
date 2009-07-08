Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbZGHX7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbZGHX7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 19:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbZGHX7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 19:59:43 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34418 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754972AbZGHX7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 19:59:41 -0400
Date: Wed, 8 Jul 2009 16:59:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: tridge@samba.org
Cc: Pavel Machek <pavel@ucw.cz>, Rusty Russell <rusty@rustcorp.com.au>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090708235937.GA20837@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090702214646.GD1485@ucw.cz> <19021.12158.915384.574218@samba.org> <20090702223349.GA30840@elf.ucw.cz> <19021.14217.587592.808935@samba.org> <20090702224446.GD30840@elf.ucw.cz> <19021.18919.560478.630755@samba.org> <20090708092133.GC24385@elf.ucw.cz> <20090708142520.GA7817@linux.vnet.ibm.com> <19029.4803.604820.157625@samba.org> <20090708221413.GH15111@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <20090708221413.GH15111@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 08, 2009 at 03:14:13PM -0700, Paul E. McKenney wrote:
> On Thu, Jul 09, 2009 at 07:42:27AM +1000, tridge@samba.org wrote:
> > Hi Paul,
> > 
> > These probabilities are way off. They assume that whatever interaction
> > happens in XP has infinite memory. The testing I've done indicates
> > that the memory for this interaction is very small (maybe 3 or 4? it's
> > hard to know precisely).
> 
> Good to know!  I will rework assuming that the memory is 4, let me
> know if you learn more.
> 
> > I've also confirmed this with lots of testing. If the probability was
> > 39% for any directory size then I would have found it.
> 
> This new information will likely reduce the predicted probability of
> bluescreen by several orders of magnitude for large directories.  Not
> that much effect for small directories, but not a real issue given
> how low the probabilities are to begin with.
> 
> > In all my testing I did not once produce a XP crash with the full
> > patch. To produce the XP crash I needed to have a reduced version of
> > the patch with less randomness.
> 
> Well, let's see if I can produce a reasonably realistic model.  :-)
> (I knew I should have gotten more sleep last night!!!)

This model assumes a finite memory, so that at least two files out of
a group of "l" recently opened files have to collide to result in a
bluescreen.  I don't trust it yet, but thought I should give people a
chance to poke holes in it.

							Thanx, Paul

------------------------------------------------------------------------

Results

Assuming the worst case where the user opens each file in the directory
of interest, the probability depends on the number of long-named files
in the given directory as follows (derivation at EOM):

Files	Probability		Odds
-----	--------------------	-------
32767	9.15401625433259b-5	(1 in 11,000)
16384	4.576973184985319b-5	(1 in 22,000)
 8192	2.288233388567135b-5	(1 in 44,000)
 4096	1.143843845796893b-5	(1 in 87,000)
 2048	5.716441632059139b-6	(1 in 170,000)
 1024	2.855430941007629b-6	(1 in 350,000)
  512	1.424922525947476b-6	(1 in 700,000)
  256	7.096675510325187b-7	(1 in 1,400,000)
  128	3.520398717286601b-7	(1 in 2,800,000)
   64	1.732259841151157b-7	(1 in 5,800,000)
   32	8.381902831793723b-8	(1 in 12,000,000)
   16	3.911554742174612b-8	(1 in 26,000,000)
    8	1.676380622425006b-8	(1 in 60,000,000)
    4	5.587935438151892b-9	(1 in 179,000,000)
    2	9.313225746154785b-10	(1 in 1,000,000,000)
    1	0.0b0

This is for 2^32 random values per entry and a WinXP "memory" of four
entries.

------------------------------------------------------------------------

Derivation:

o	The patch uses 6 random bytes, with 6 bits each, for
	32^6 = 1,073,741,824 possible combinations.  (Based on code
	in vfat_build_dummy_83_buffer() in the patch Tridge posted on
	June 27th.)

o	There are a maximum of 32,767 entries in a VFAT directory.

o	In the worst case, the user application will open each and
	every file in the directory.  WinXP seems to have a limited
	memory for recently opened files, and we assume that once this
	memory is full, opening a new file causes one of the recently
	opened files to be forgotten.  The size of its memory appears
	to be in the range of 3-4 based on Tridge's testing, so we
	will assume the worst case (4) and parameterize with l=4.

o	As noted earlier, the probability the infamous Birthday Paradox
	is given by:

		P(n, m) = (n-1)! / ((n-m)! * n^(m-1))

	Here "n" is the number of possible birthdays (1,073,741,824 in
	this case) and "m" is the number of people (32,767 in this case).
	P(n, m) is the probability of -no- common birthday.  This is not
	the probability of no bluescreen, but we will use this result
	to calculate this probability while initially filling WinXP's
	memory.  I again use maxima, and again use the optimized form
	based on the binomial function:

		b(n,m):=binomial(n,m)*m!/n^m;

o	See the attached .eps...

o	The probability of no bluescreen while opening the first "l"
	files is given by b(n,l), just as before.

o	Given no bluescreen while opening the first "l" files, the
	probability of no bluescreen while opening the "l+1"st file
	is the probability of missing the "l-1" files that remain
	after ejecting one of them to make room is "(n-l+1)/n".

	The cumulative probability of no bluescreen is thus:

		P(n,m,l) = b(n,l)*(n-l+1)/n

o	We have the same situation when opening the "l+2"nd file,
	the probability of no bluescreen is again "(n-l+1)/n".

o	This situation will repeat "m-l" times, so that we have:

		P(n,m,l) = b(n,l)*((n-l+1)/n)^(m-l)

	In maxima-speak:

		b(n,m):=binomial(n,m)*m!/n^m;
		nbs(n,m,l):=b(n,l)*((n-l+1)/n)^(m-l);

	The probability of bluescreening when faced with 32767 files
	in a directory, 32^6 possible random values, and the capacity
	to remember four files is then:

		1-nbs(32^6,32767,4);

	For floating-point results instead of a massive fraction:

		bfloat(1-nbs(32^6,32767,4));

	See below for the actual maxima output, typos and all.

------------------------------------------------------------------------

maxima

paulmck@paulmck-laptop:~$ maxima

Maxima 5.12.0 http://maxima.sourceforge.net
Using Lisp GNU Common Lisp (GCL) GCL 2.6.7 (aka GCL)
Distributed under the GNU Public License. See the file COPYING.
Dedicated to the memory of William Schelter.
This is a development version of Maxima. The function bug_report()
provides bug reporting information.
(%i1) b(n,m):=binomial(n,m)*m!/n^m;
                                    binomial(n, m) m!
(%o1)                    b(n, m) := -----------------
                                            m
                                           n
(%i2) nbs(n,m,l):=b(n,l)*((n-l+1)/n)^(m-l);
                                            n - l + 1 m - l
(%o2)              nbs(n, m, l) := b(n, l) (---------)
                                                n
(%i3) bfloat(1-nbs(32^6,32767,4));
(%o3)                         9.15401625433259b-5
(%i4) bfloat(1-nbs(32^6,2^14,4));
(%o4)                        4.576973184985319b-5
(%i5) bfloat(1-nbs(32^6,2^13,4));
(%o5)                        2.288233388567135b-5
(%i6) bfloat(1-nbs(32^6,2^12,4));
(%o6)                        1.143843845796893b-5
(%i7) bfloat(1-nbs(32^6,2^11,4));
(%o7)                        5.716441632059139b-6
(%i8) bfloat(1-nbs(32^6,2^10,4));
(%o8)                        2.855430941007629b-6
(%i9) bfloat(1-nbs(32^6,2^9,4));
(%o9)                        1.424922525947476b-6
(%i10) bfloat(1-nbs(32^6,2^8,4));
(%o10)                       7.096675510325187b-7
(%i11) bfloat(1-nbs(32^6,2^7,4));
(%o11)                       3.520398717286601b-7
(%i12) bfloat(1-nbs(32^6,2^6,4));
(%o12)                       1.732259841151157b-7
(%i13) bfloat(1-nbs(32^6,2^5,4));
(%o13)                       8.381902831793723b-8
(%i14) bfloat(1-nbs(32^6,2^4,4));
(%o14)                       3.911554742174612b-8
(%i15) bfloat(1-nbs(32^6,2^3,4));
(%o15)                       1.676380622425006b-8
(%i16) bfloat(1-nbs(32^6,2^2,4));
(%o16)                       5.587935438151892b-9
(%i17) bfloat(1-nbs(32^6,2^1,4));
(%o17)                      - 1.734723480823569b-18
(%i18) bfloat(1-b(32^6,2));
(%o18)                       9.313225746154785b-10
(%i19) bfloat(1-b(32^6,1));
(%o19)                               0.0b0

--XsQoSWH+UP9D9v3l
Content-Type: application/postscript
Content-Description: WinXPmodel.eps
Content-Disposition: attachment; filename="WinXPmodel.eps"
Content-Transfer-Encoding: quoted-printable

%!PS-Adobe-2.0 EPSF-2.0=0A%%Title: WinXPmodel.fig=0A%%Creator: fig2dev Vers=
ion 3.2 Patchlevel 5=0A%%CreationDate: Wed Jul  8 16:14:19 2009=0A%%For: pa=
ulmck@paulmck-laptop (Paul E. McKenney,,,)=0A%%BoundingBox: 0 0 362 75=0A%M=
agnification: 1.0000=0A%%EndComments=0A%%BeginProlog=0A/$F2psDict 200 dict =
def=0A$F2psDict begin=0A$F2psDict /mtrx matrix put=0A/col-1 {0 setgray} bin=
d def=0A/col0 {0.000 0.000 0.000 srgb} bind def=0A/col1 {0.000 0.000 1.000 =
srgb} bind def=0A/col2 {0.000 1.000 0.000 srgb} bind def=0A/col3 {0.000 1.0=
00 1.000 srgb} bind def=0A/col4 {1.000 0.000 0.000 srgb} bind def=0A/col5 {=
1.000 0.000 1.000 srgb} bind def=0A/col6 {1.000 1.000 0.000 srgb} bind def=
=0A/col7 {1.000 1.000 1.000 srgb} bind def=0A/col8 {0.000 0.000 0.560 srgb}=
 bind def=0A/col9 {0.000 0.000 0.690 srgb} bind def=0A/col10 {0.000 0.000 0=
=2E820 srgb} bind def=0A/col11 {0.530 0.810 1.000 srgb} bind def=0A/col12 {=
0.000 0.560 0.000 srgb} bind def=0A/col13 {0.000 0.690 0.000 srgb} bind def=
=0A/col14 {0.000 0.820 0.000 srgb} bind def=0A/col15 {0.000 0.560 0.560 srg=
b} bind def=0A/col16 {0.000 0.690 0.690 srgb} bind def=0A/col17 {0.000 0.82=
0 0.820 srgb} bind def=0A/col18 {0.560 0.000 0.000 srgb} bind def=0A/col19 =
{0.690 0.000 0.000 srgb} bind def=0A/col20 {0.820 0.000 0.000 srgb} bind de=
f=0A/col21 {0.560 0.000 0.560 srgb} bind def=0A/col22 {0.690 0.000 0.690 sr=
gb} bind def=0A/col23 {0.820 0.000 0.820 srgb} bind def=0A/col24 {0.500 0.1=
90 0.000 srgb} bind def=0A/col25 {0.630 0.250 0.000 srgb} bind def=0A/col26=
 {0.750 0.380 0.000 srgb} bind def=0A/col27 {1.000 0.500 0.500 srgb} bind d=
ef=0A/col28 {1.000 0.630 0.630 srgb} bind def=0A/col29 {1.000 0.750 0.750 s=
rgb} bind def=0A/col30 {1.000 0.880 0.880 srgb} bind def=0A/col31 {1.000 0.=
840 0.000 srgb} bind def=0A=0Aend=0A=0A/cp {closepath} bind def=0A/ef {eofi=
ll} bind def=0A/gr {grestore} bind def=0A/gs {gsave} bind def=0A/sa {save} =
bind def=0A/rs {restore} bind def=0A/l {lineto} bind def=0A/m {moveto} bind=
 def=0A/rm {rmoveto} bind def=0A/n {newpath} bind def=0A/s {stroke} bind de=
f=0A/sh {show} bind def=0A/slc {setlinecap} bind def=0A/slj {setlinejoin} b=
ind def=0A/slw {setlinewidth} bind def=0A/srgb {setrgbcolor} bind def=0A/ro=
t {rotate} bind def=0A/sc {scale} bind def=0A/sd {setdash} bind def=0A/ff {=
findfont} bind def=0A/sf {setfont} bind def=0A/scf {scalefont} bind def=0A/=
sw {stringwidth} bind def=0A/tr {translate} bind def=0A/tnt {dup dup curren=
trgbcolor=0A  4 -2 roll dup 1 exch sub 3 -1 roll mul add=0A  4 -2 roll dup =
1 exch sub 3 -1 roll mul add=0A  4 -2 roll dup 1 exch sub 3 -1 roll mul add=
 srgb}=0A  bind def=0A/shd {dup dup currentrgbcolor 4 -2 roll mul 4 -2 roll=
 mul=0A  4 -2 roll mul srgb} bind def=0A/$F2psBegin {$F2psDict begin /$F2ps=
EnteredState save def} def=0A/$F2psEnd {$F2psEnteredState restore end} def=
=0A=0A/pageheader {=0Asave=0Anewpath 0 75 moveto 0 0 lineto 362 0 lineto 36=
2 75 lineto closepath clip newpath=0A0.7 84.6 translate=0A1 -1 scale=0A$F2p=
sBegin=0A10 setmiterlimit=0A0 slj 0 slc=0A 0.06000 0.06000 sc=0A} bind def=
=0A/pagefooter {=0A$F2psEnd=0Arestore=0A} bind def=0A%%EndProlog=0Apagehead=
er=0A%=0A% Fig objects follow=0A%=0A% =0A% here starts figure with depth 50=
=0A% Polyline=0A0 slj=0A0 slc=0A7.500 slw=0An 0 900 m=0A 6000 900 l gs col0=
 s gr =0A% Polyline=0An 0 600 m=0A 0 1200 l gs col0 s gr =0A% Polyline=0An =
75 825 m=0A 75 975 l gs col0 s gr =0A% Polyline=0An 150 825 m=0A 150 975 l =
gs col0 s gr =0A% Polyline=0An 225 825 m=0A 225 975 l gs col0 s gr =0A% Pol=
yline=0An 300 825 m=0A 300 975 l gs col0 s gr =0A% Polyline=0An 375 825 m=
=0A 375 975 l gs col0 s gr =0A% Polyline=0An 450 825 m=0A 450 975 l gs col0=
 s gr =0A% Polyline=0An 525 825 m=0A 525 975 l gs col0 s gr =0A% Polyline=
=0An 600 600 m=0A 600 975 l gs col0 s gr =0A% Polyline=0An 675 825 m=0A 675=
 975 l gs col0 s gr =0A% Polyline=0An 750 825 m=0A 750 975 l gs col0 s gr =
=0A% Polyline=0An 825 825 m=0A 825 975 l gs col0 s gr =0A% Polyline=0An 900=
 825 m=0A 900 975 l gs col0 s gr =0A% Polyline=0An 975 825 m=0A 975 975 l g=
s col0 s gr =0A% Polyline=0An 1050 825 m=0A 1050 975 l gs col0 s gr =0A% Po=
lyline=0An 1125 825 m=0A 1125 975 l gs col0 s gr =0A% Polyline=0An 1200 825=
 m=0A 1200 975 l gs col0 s gr =0A% Polyline=0An 1275 825 m=0A 1275 975 l gs=
 col0 s gr =0A% Polyline=0An 1350 825 m=0A 1350 975 l gs col0 s gr =0A% Pol=
yline=0An 1425 825 m=0A 1425 975 l gs col0 s gr =0A% Polyline=0An 1500 825 =
m=0A 1500 975 l gs col0 s gr =0A% Polyline=0An 1575 825 m=0A 1575 975 l gs =
col0 s gr =0A% Polyline=0An 1650 825 m=0A 1650 975 l gs col0 s gr =0A% Poly=
line=0An 1725 825 m=0A 1725 975 l gs col0 s gr =0A% Polyline=0An 1800 825 m=
=0A 1800 975 l gs col0 s gr =0A% Polyline=0An 1875 825 m=0A 1875 975 l gs c=
ol0 s gr =0A% Polyline=0An 1950 825 m=0A 1950 975 l gs col0 s gr =0A% Polyl=
ine=0An 2025 825 m=0A 2025 975 l gs col0 s gr =0A% Polyline=0An 2100 825 m=
=0A 2100 975 l gs col0 s gr =0A% Polyline=0An 2175 825 m=0A 2175 975 l gs c=
ol0 s gr =0A% Polyline=0An 2250 825 m=0A 2250 975 l gs col0 s gr =0A% Polyl=
ine=0An 2325 825 m=0A 2325 975 l gs col0 s gr =0A% Polyline=0An 2400 825 m=
=0A 2400 975 l gs col0 s gr =0A% Polyline=0An 2475 825 m=0A 2475 975 l gs c=
ol0 s gr =0A% Polyline=0An 2550 825 m=0A 2550 975 l gs col0 s gr =0A% Polyl=
ine=0An 2625 825 m=0A 2625 975 l gs col0 s gr =0A% Polyline=0An 2700 825 m=
=0A 2700 975 l gs col0 s gr =0A% Polyline=0An 2775 825 m=0A 2775 975 l gs c=
ol0 s gr =0A% Polyline=0An 2850 825 m=0A 2850 975 l gs col0 s gr =0A% Polyl=
ine=0An 2925 825 m=0A 2925 975 l gs col0 s gr =0A% Polyline=0An 3000 825 m=
=0A 3000 975 l gs col0 s gr =0A% Polyline=0An 3075 825 m=0A 3075 975 l gs c=
ol0 s gr =0A% Polyline=0An 3150 825 m=0A 3150 975 l gs col0 s gr =0A% Polyl=
ine=0An 3225 825 m=0A 3225 975 l gs col0 s gr =0A% Polyline=0An 3300 825 m=
=0A 3300 975 l gs col0 s gr =0A% Polyline=0An 3375 825 m=0A 3375 975 l gs c=
ol0 s gr =0A% Polyline=0An 3450 825 m=0A 3450 975 l gs col0 s gr =0A% Polyl=
ine=0An 3525 825 m=0A 3525 975 l gs col0 s gr =0A% Polyline=0An 3600 825 m=
=0A 3600 975 l gs col0 s gr =0A% Polyline=0An 3675 825 m=0A 3675 975 l gs c=
ol0 s gr =0A% Polyline=0An 3750 825 m=0A 3750 975 l gs col0 s gr =0A% Polyl=
ine=0An 3825 825 m=0A 3825 975 l gs col0 s gr =0A% Polyline=0An 3900 825 m=
=0A 3900 975 l gs col0 s gr =0A% Polyline=0An 3975 825 m=0A 3975 975 l gs c=
ol0 s gr =0A% Polyline=0An 4050 825 m=0A 4050 975 l gs col0 s gr =0A% Polyl=
ine=0An 4125 825 m=0A 4125 975 l gs col0 s gr =0A% Polyline=0An 4200 825 m=
=0A 4200 975 l gs col0 s gr =0A% Polyline=0An 4275 825 m=0A 4275 975 l gs c=
ol0 s gr =0A% Polyline=0An 4350 825 m=0A 4350 975 l gs col0 s gr =0A% Polyl=
ine=0An 4425 825 m=0A 4425 975 l gs col0 s gr =0A% Polyline=0An 4500 825 m=
=0A 4500 975 l gs col0 s gr =0A% Polyline=0An 4575 825 m=0A 4575 975 l gs c=
ol0 s gr =0A% Polyline=0An 4650 825 m=0A 4650 975 l gs col0 s gr =0A% Polyl=
ine=0An 4725 825 m=0A 4725 975 l gs col0 s gr =0A% Polyline=0An 4800 825 m=
=0A 4800 975 l gs col0 s gr =0A% Polyline=0An 4875 825 m=0A 4875 975 l gs c=
ol0 s gr =0A% Polyline=0An 4950 825 m=0A 4950 975 l gs col0 s gr =0A% Polyl=
ine=0An 5025 825 m=0A 5025 975 l gs col0 s gr =0A% Polyline=0An 5100 825 m=
=0A 5100 975 l gs col0 s gr =0A% Polyline=0An 5175 825 m=0A 5175 975 l gs c=
ol0 s gr =0A% Polyline=0An 5250 825 m=0A 5250 975 l gs col0 s gr =0A% Polyl=
ine=0An 5325 825 m=0A 5325 975 l gs col0 s gr =0A% Polyline=0An 5400 825 m=
=0A 5400 975 l gs col0 s gr =0A% Polyline=0An 5475 825 m=0A 5475 975 l gs c=
ol0 s gr =0A% Polyline=0An 5550 825 m=0A 5550 975 l gs col0 s gr =0A% Polyl=
ine=0An 5625 825 m=0A 5625 975 l gs col0 s gr =0A% Polyline=0An 5700 825 m=
=0A 5700 975 l gs col0 s gr =0A% Polyline=0An 5775 825 m=0A 5775 975 l gs c=
ol0 s gr =0A% Polyline=0An 5850 825 m=0A 5850 975 l gs col0 s gr =0A% Polyl=
ine=0An 5925 825 m=0A 5925 975 l gs col0 s gr =0A% Polyline=0An 6000 825 m=
=0A 6000 1200 l gs col0 s gr =0A% Polyline=0Ags  clippath=0A5863 1155 m 601=
5 1155 l 6015 1095 l 5863 1095 l 5863 1095 l 5983 1125 l 5863 1155 l cp=0A1=
37 1095 m -15 1095 l -15 1155 l 137 1155 l 137 1155 l 17 1125 l 137 1095 l =
cp=0Aeoclip=0An 0 1125 m=0A 6000 1125 l gs col0 s gr gr=0A=0A% arrowhead=0A=
n 137 1095 m 17 1125 l 137 1155 l  col0 s=0A% arrowhead=0An 5863 1155 m 598=
3 1125 l 5863 1095 l  col0 s=0A% Polyline=0Ags  clippath=0A463 705 m 615 70=
5 l 615 645 l 463 645 l 463 645 l 583 675 l 463 705 l cp=0A137 645 m -15 64=
5 l -15 705 l 137 705 l 137 705 l 17 675 l 137 645 l cp=0Aeoclip=0An 0 675 =
m=0A 600 675 l gs col0 s gr gr=0A=0A% arrowhead=0An 137 645 m 17 675 l 137 =
705 l  col0 s=0A% arrowhead=0An 463 705 m 583 675 l 463 645 l  col0 s=0A% P=
olyline=0Ags  clippath=0A375 481 m 268 589 l 310 631 l 418 524 l 418 524 l =
312 588 l 375 481 l cp=0Aeoclip=0An 600 300 m=0A 300 600 l gs col0 s gr gr=
=0A=0A% arrowhead=0An 375 481 m 312 588 l 418 524 l  col0 s=0A% Polyline=0A=
gs  clippath=0A2775 631 m 2668 739 l 2710 781 l 2818 674 l 2818 674 l 2712 =
738 l 2775 631 l cp=0Aeoclip=0An 2925 525 m=0A 2700 750 l gs col0 s gr gr=
=0A=0A% arrowhead=0An 2775 631 m 2712 738 l 2818 674 l  col0 s=0A/Helvetica=
 ff 150.00 scf sf=0A3000 1350 m=0Ags 1 -1 sc (Number of directory entries =
=3D m) dup sw pop 2 div neg 0 rm  col0 sh gr=0A/Helvetica ff 150.00 scf sf=
=0A600 300 m=0Ags 1 -1 sc (Capacity =3D l) col0 sh gr=0A/Helvetica ff 150.0=
0 scf sf=0A3000 525 m=0Ags 1 -1 sc (Number of possible random values =3D n)=
 col0 sh gr=0A% here ends figure;=0Apagefooter=0Ashowpage=0A%%Trailer=0A%EO=
F=0A
--XsQoSWH+UP9D9v3l--
