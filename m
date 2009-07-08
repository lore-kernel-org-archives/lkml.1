Return-Path: <linux-kernel-owner+w=401wt.eu-S1757388AbZGHOZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbZGHOZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 10:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757035AbZGHOZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 10:25:27 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44281 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757051AbZGHOZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 10:25:25 -0400
Date: Wed, 8 Jul 2009 07:25:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: tridge@samba.org, Rusty Russell <rusty@rustcorp.com.au>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090708142520.GA7817@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <19013.8005.541836.436991@samba.org> <20090630063102.GB1351@ucw.cz> <200907012019.53932.rusty@rustcorp.com.au> <20090702214646.GD1485@ucw.cz> <19021.12158.915384.574218@samba.org> <20090702223349.GA30840@elf.ucw.cz> <19021.14217.587592.808935@samba.org> <20090702224446.GD30840@elf.ucw.cz> <19021.18919.560478.630755@samba.org> <20090708092133.GC24385@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090708092133.GC24385@elf.ucw.cz>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 11:21:33AM +0200, Pavel Machek wrote:
> On Fri 2009-07-03 09:59:35, tridge@samba.org wrote:
> > Hi Pavel,
> > 
> >  > That's why we have ethernet checksums. 
> > 
> > which of course just changes the number of bits. The argument remains
> > the same. 
> 
> Ok, so what is your estimate of XP crash probability?

Assuming the worst case where the user opens each file in the directory
of interest, the probability depends on the number of long-named files
in the given directory as follows (derivation at EOM):

Files	Probability		Odds
-----	--------------------	-------
32767	3.934446601778345b-1	(39.3%)
16384	1.174969255061134b-1	(11.7%)
 8192	3.076314519945223b-2	( 3.1%)
 4096	7.780179085651447b-3	( 0.8%)
 2048	1.950268317016874b-3	( 0.2%)
 1024	4.87685610530225b-4	(1 in 2,000)
  512	1.218244920604881b-4	(1 in 8,000)
  256	3.039790922077076b-5	(1 in 30,000)
  128	7.569761535306629b-6	(1 in 100,000)
   64	1.877544584847826b-6	(1 in 500,000)
   32	4.61935894834079b-7	(1 in 2,000,000)
   16	1.117587032466174b-7	(1 in 9,000,000)
    8	2.607703180994292b-8	(1 in 38,000,000)
    4	5.587935438151892b-9	(1 in 180,000,000)
    2	9.313225746154785b-10	(1 in 1,000,000,000)
    1	0.0b0

The number of files that people keep in a given directory will vary,
but in my admittedly limited experience, most people tend towards the
low end of this range.  What number of files per directory do you see
on embedded-device memory sticks?

Furthermore, this assumes that the user actually opens each and every file
in the directory.  If the user keeps (say) 1024 files in the directory,
but only opens two of them on any given memory-stick insertion, then
the odds are one in a billion rather than one in two thousand.

[Tridge -- isn't this only for subdirectories?  Or can collisions in
the root directory also result in WinXP bluescreens?]

> >  > It already _was_ perfect before you started patching it.
> > 
> > wow, I really didn't expect the objection to my patch to be that VFAT
> > is perfect!
> 
> But ... it was, and there is still possibility of just using position
> in directory to avoid collisions completely.

Almost.  The imperfection comes from the fact that storage media are not
totally reliable, so that given enough uses of large enough numbers of
memory sticks, there will eventually be a WinXP bluescreen.  Please note
that people really have reported this WinXP bug.

							Thanx, Paul

------------------------------------------------------------------------

Derivation:

o	The patch uses 6 random bytes, with 6 bits each, for
	32^6 = 1,073,741,824 possible combinations.  (Based on code
	in vfat_build_dummy_83_buffer() in the patch Tridge posted on
	June 27th.)

o	There are a maximum of 32,767 entries in a VFAT directory.

o	In the worst case, the user application will open each and
	every file in the directory.  I don't have any information on
	whether WinXP has a limited memory for recently open files.
	I therefore assume the worst case, namely that WinXP remembers
	every file that it has opened.

o	As noted in this thread, the probability of bluescreen is
	given by the infamous Birthday Paradox:

		P(n, m) = (n-1)! / ((n-m)! * n^(m-1))

	Here "n" is the number of possible birthdays (1,073,741,824 in
	this case) and "m" is the number of people (32,767 in this case).
	P(n, m) is the probability of -no- common birthday, so the
	probability of WinXP bluescreen is 1-P(n,m).

	Because I don't want to worry about round-off error, I use the
	arbitrary-precision arithmetic in the "maxima" symbolic-math
	package, which is related to the fabled Macsyma project.  However,
	computing the factorials without cancellation takes too long,
	so we transform the factorials into the binomial function, which
	has a highly optimized maxima implementation.  The equivalent
	but more efficient representation is as follows:

		b(n,m):=binomial(n,m)*m!/n^m;

	Then 1-b(32^6,32767) gives the exact probability of bluescreen
	on a maximal-sized directory, which is the ratio of a pair of
	extremely large integers.  More usefully, bfloat(1-b(32^6,32767))
	gives an approximation in scientific notation.  (Don't forget
	the trailing semicolon that maxima requires.)

	Computing bfloat(1-b(32^6,32767)) takes about 70 seconds on my
	2GHz x86 laptop.

	See below for the actual maxima output, typos and all.

------------------------------------------------------------------------

maxima

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
(%i2) bfloat(1-b(32^6,32767));
(%o2)                        3.934446601778345b-1
(%i3) bfloat(1-b(32^6,2^14));
(%o3)                        1.174969255061134b-1
(%i4) bfloat(1-b(32^6,2^13));
(%o4)                        3.076314519945223b-2
(%i5) bfloat(1-b(32^6,2^12));
(%o5)                        7.780179085651447b-3
(%i6) bfloat(1-b(32^6,2^11));
(%o6)                        1.950268317016874b-3
(%i7) bfloat(1-b(32^6,2^10));
(%o7)                         4.87685610530225b-4
(%i8) bfloat(1-b(32^6,2^9));
(%o8)                        1.218244920604881b-4
(%i9) bfloat(1-b(32^6,2^8));
(%o9)                        3.039790922077076b-5
(%i10) bfloat(1-b(32^6,2^7));
(%o10)                       7.569761535306629b-6
(%i11) bfloat(1-b(32^6,2^6));
(%o11)                       1.877544584847826b-6
(%i12) bfloat(1-b(32^6,2^));
Incorrect syntax: Illegal use of delimiter )
bfloat(1-b(32^6,2^)
                 ^
(%i12) bfloat(1-b(32^6,2^5));
(%o12)                        4.61935894834079b-7
(%i13) bfloat(1-b(32^6,2^4));
(%o13)                       1.117587032466174b-7
(%i14) bfloat(1-b(32^6,2^3));
(%o14)                       2.607703180994292b-8
(%i15) bfloat(1-b(32^6,2^2));
(%o15)                       5.587935438151892b-9
(%i16) bfloat(1-b(32^6,2^1));
(%o16)                       9.313225746154785b-10
(%i17) bfloat(1-b(32^6,2^0));
(%o17)                               0.0b0
(%i18)
