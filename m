Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbXLKRHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbXLKRHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 12:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbXLKRHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 12:07:20 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:46524 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbXLKRHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 12:07:18 -0500
Date: Tue, 11 Dec 2007 20:07:20 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, Bob Tracy <rct@frus.com>,
       Michael Cree <mcree@orcon.net.nz>, Kay Sievers <kay.sievers@vrfy.org>,
       mingo@elte.hu, rjw@sisk.pl, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: [patch] alpha: strncpy/strncat fixes
Message-ID: <20071211200720.A23822@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First of all, thanks to Bob Tracy <rct@frus.com> and 
Michael Cree <mcree@orcon.net.nz> for testing.
Especially to Bob, as he has done titanic multi-day git-bisect
work that finally helped to reproduce and nail down the bug
(http://bugzilla.kernel.org/show_bug.cgi?id=9457).

[ev6-]stxncpy.S: it's t12, not t2 register that is supposed to contain
the last byte offset upon return. As a result of wrong register use
(which was my fault back in 2003, IIRC), under some circumstances extra
terminating zero bytes were added to destination string. This particularly
led to incorrect DEVPATH strings generated in uevent and therefore to udev
problems.

strncpy.S: unrelated bug I found while testing the above fix - destination
is not properly zero-padded then a byte count exceeds source length. 
Actually this is addition to strncpy fix from last year.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Ivan.

--- 2.6.24-rc3/arch/alpha/lib/ev6-stxncpy.S	Wed Oct 10 00:31:38 2007
+++ linux/arch/alpha/lib/ev6-stxncpy.S	Tue Dec 11 02:28:57 2007
@@ -362,10 +362,10 @@ $unaligned:
 
 	extql	t2, a1, t2	# U :
 	cmpbge	zero, t1, t8	# E : is there a zero?
-	andnot	t2, t6, t12	# E : dest mask for a single word copy
+	andnot	t2, t6, t2	# E : dest mask for a single word copy
 	or	t8, t10, t5	# E : test for end-of-count too
 
-	cmpbge	zero, t12, t3	# E :
+	cmpbge	zero, t2, t3	# E :
 	cmoveq	a2, t5, t8	# E : Latency=2, extra map slot
 	nop			# E : keep with cmoveq
 	andnot	t8, t3, t8	# E : (stall)
@@ -379,13 +379,13 @@ $unaligned:
 	negq	t8, t6		# E : build bitmask of bytes <= zero
 	mskqh	t1, t4, t1	# U :
 
-	and	t6, t8, t2	# E :
-	subq	t2, 1, t6	# E : (stall)
-	or	t6, t2, t8	# E : (stall)
-	zapnot	t12, t8, t12	# U : prepare source word; mirror changes (stall)
+	and	t6, t8, t12	# E :
+	subq	t12, 1, t6	# E : (stall)
+	or	t6, t12, t8	# E : (stall)
+	zapnot	t2, t8, t2	# U : prepare source word; mirror changes (stall)
 
 	zapnot	t1, t8, t1	# U : to source validity mask
-	andnot	t0, t12, t0	# E : zero place for source to reside
+	andnot	t0, t2, t0	# E : zero place for source to reside
 	or	t0, t1, t0	# E : and put it there (stall both t0, t1)
 	stq_u	t0, 0(a0)	# L : (stall)
 
--- 2.6.24-rc3/arch/alpha/lib/stxncpy.S	Wed Oct 10 00:31:38 2007
+++ linux/arch/alpha/lib/stxncpy.S	Tue Dec 11 02:28:57 2007
@@ -315,9 +315,9 @@ $unaligned:
 
 	extql	t2, a1, t2	# e0    :
 	cmpbge	zero, t1, t8	# .. e1 : is there a zero?
-	andnot	t2, t6, t12	# e0    : dest mask for a single word copy
+	andnot	t2, t6, t2	# e0    : dest mask for a single word copy
 	or	t8, t10, t5	# .. e1 : test for end-of-count too
-	cmpbge	zero, t12, t3	# e0    :
+	cmpbge	zero, t2, t3	# e0    :
 	cmoveq	a2, t5, t8	# .. e1 :
 	andnot	t8, t3, t8	# e0    :
 	beq	t8, $u_head	# .. e1 (zdb)
@@ -330,14 +330,14 @@ $unaligned:
 	ldq_u	t0, 0(a0)	# e0    :
 	negq	t8, t6		# .. e1 : build bitmask of bytes <= zero
 	mskqh	t1, t4, t1	# e0    :
-	and	t6, t8, t2	# .. e1 :
-	subq	t2, 1, t6	# e0    :
-	or	t6, t2, t8	# e1    :
+	and	t6, t8, t12	# .. e1 :
+	subq	t12, 1, t6	# e0    :
+	or	t6, t12, t8	# e1    :
 
-	zapnot	t12, t8, t12	# e0    : prepare source word; mirror changes
+	zapnot	t2, t8, t2	# e0    : prepare source word; mirror changes
 	zapnot	t1, t8, t1	# .. e1 : to source validity mask
 
-	andnot	t0, t12, t0	# e0    : zero place for source to reside
+	andnot	t0, t2, t0	# e0    : zero place for source to reside
 	or	t0, t1, t0	# e1    : and put it there
 	stq_u	t0, 0(a0)	# e0    :
 	ret	(t9)		# .. e1 :
--- 2.6.24-rc3/arch/alpha/lib/strncpy.S	Wed Oct 10 00:31:38 2007
+++ linux/arch/alpha/lib/strncpy.S	Tue Dec 11 02:28:57 2007
@@ -35,7 +35,7 @@ strncpy:
 
 	or	$3, $24, $3	# clear the bits between the last
 	or	$4, $27, $4	# written byte and the last byte in COUNT
-	andnot	$4, $3, $4
+	andnot	$3, $4, $4
 	zap	$1, $4, $1
 
 	stq_u	$1, 0($16)
