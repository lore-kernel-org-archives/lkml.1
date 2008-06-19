Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbYFSPli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbYFSPli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 11:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYFSPlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 11:41:31 -0400
Received: from chihiro.randombit.net ([69.48.226.76]:46764 "EHLO
	mail.randombit.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbYFSPla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 11:41:30 -0400
X-Greylist: delayed 643 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jun 2008 11:41:30 EDT
Date: Thu, 19 Jun 2008 11:30:45 -0400
From: Jack Lloyd <lloyd@randombit.net>
To: linux-kernel@vger.kernel.org
Subject: Bug in random32.c: all-zero outputs with probability 1/2^32, other
	seeding bugs
Message-ID: <20080619153045.GC1455@randombit.net>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
X-PGP-Fingerprint: 3F69 2E64 6D92 3BBE E7AE 9258 5C0F 96E8 4EC1 6D6B
X-PGP-Key: http://www.randombit.net/pgpkey.html
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

There appears to be an error in how random seeding is done in the
random32.c RNG. I am looking at 2.6.25.7.

For background, that file contains this comment:

"""
        ... the k_j most significant bits of z_j must be non-
        zero, for each j. (Note: this restriction also applies to the
        computer code given in [4], but was mistakenly not mentioned in
        that paper.)

   This affects the seeding procedure by imposing the requirement
   s1 > 1, s2 > 7, s3 > 15.
"""

The function random32_reseed takes an unsigned long's worth of entropy
=66rom the entropy pool (get_random_bytes) and passes it to
__set_random32.  That function (seemingly attempts) to impose the
requirement mentioned above by first checking if the seed is =3D=3D 0, and
if so setting it to one, then setting s2 to s*69069 and s3 to s2*69069

However this will allow bad seeds. On 64-bit systems, if the low order
32 bits of the seed are zero, then the check for s =3D=3D 0 will pass, but
s1, s2, and s3 will all be initialized to zero due to truncation. This
will, since there are no additive factors in the RNG sequence, cause
the RNG to output nothing but zero values. Assuming get_random_bytes
returns uniform random numbers, this will occur with probability
around 1/2^32.

An easy and straightforward fix for this that doesn't require changing
any interfaces is to add
  s &=3D 0xFFFFFFFF;
before the check in __set_random32, which ensures this condition will
be caught by the check. Alternately, you could replace the check for
s =3D=3D 0 with some logic like:
  if((s & 0xFFFFFFFF) =3D=3D 0)
     s +=3D 1;
since just chopping the seed to 32 bits does throw away some of your
seed input (with sizeof(long) =3D=3D 8, at least; doesn't make any
difference for sizeof(long) =3D=3D 4)

There are also many other seeds which will cause some (but not all) of
the seeding requirements to be violated. Which seeds will cause this
problem depend on the size of unsigned long, since the multiplications
by 69069 are done in that size.

For instance on 32-bit systems, a seed of 0x4BC54E0A will generate
the state:
  s1 =3D 0x4BC54E0A
  s2 =3D (s1 * 69069) % 2^32 =3D 2
  s3 =3D 2*69069 =3D 138138

In general, there seem to be large numbers of seeds that cause at
least one of the restrictions on s1, s2, s3 to be false. The paper
referenced in the source is not clear exactly how badly the generator
fails when only one of the restrictions is violated. Certainly it
seems much less serious than the 64-bit specific bug described above;
which is fortunate since it seems to occur much more often. A trivial
patch for both problems is attached.

Please Cc: me on any replies as I am not subscribed to the list.

Jack

--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="random32.c.diff"

--- random32.c.orig     2008-06-19 11:21:57.000000000 -0400
+++ random32.c  2008-06-19 11:23:05.000000000 -0400
@@ -58,13 +58,17 @@
 
 static void __set_random32(struct rnd_state *state, unsigned long s)
 {
+       s &= 0xFFFFFFFF;
        if (s == 0)
                s = 1;      /* default seed is 1 */
 
 #define LCG(n) (69069 * n)
        state->s1 = LCG(s);
+       if(state->s1 < 2) state->s1 += 2;
        state->s2 = LCG(state->s1);
+       if(state->s2 < 8) state->s2 += 8;
        state->s3 = LCG(state->s2);
+       if(state->s3 < 16) state->s3 += 16;
 
        /* "warm it up" */
        __random32(state);

--xHFwDpU9dbj6ez1V--
