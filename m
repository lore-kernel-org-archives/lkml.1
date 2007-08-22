Return-Path: <linux-kernel-owner+w=401wt.eu-S1759580AbXHVIyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580AbXHVIyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757680AbXHVIwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:52:39 -0400
Received: from 1wt.eu ([62.212.114.60]:1911 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757563AbXHVIwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:52:37 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822083949.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:38:55 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Mark Fortescue <mark@mtfhpc.demon.co.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 11/58] Fix sparc32 udelay() rounding errors.
Content-Disposition: inline; filename=0011-Fix-sparc32-udelay-rounding-errors.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[SPARC32]: Fix rounding errors in ndelay/udelay implementation.

__ndelay and __udelay have not been delayung >= specified time.
The problem with __ndelay has been tacked down to the rounding of the
multiplier constant. By changing this, delays > app 18us are correctly
calculated.
The problem with __udelay has also been tracked down to rounding issues.
Changing the multiplier constant (to match that used in sparc64) corrects
for large delays and adding in a rounding constant corrects for trunctaion
errors in the claculations.
Many short delays will return without looping. This is not an error as there
is the fixed delay of doing all the maths to calculate the loop count.

Signed-off-by: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/sparc/kernel/entry.S |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/kernel/entry.S b/arch/sparc/kernel/entry.S
index 831f540..eac3838 100644
--- a/arch/sparc/kernel/entry.S
+++ b/arch/sparc/kernel/entry.S
@@ -1749,8 +1749,8 @@ fpload:
 __ndelay:
 	save	%sp, -STACKFRAME_SZ, %sp
 	mov	%i0, %o0
-	call	.umul
-	 mov	0x1ad, %o1		! 2**32 / (1 000 000 000 / HZ)
+	call	.umul			! round multiplier up so large ns ok
+	 mov	0x1ae, %o1		! 2**32 / (1 000 000 000 / HZ)
 	call	.umul
 	 mov	%i1, %o1		! udelay_val
 	ba	delay_continue
@@ -1760,11 +1760,17 @@ __ndelay:
 __udelay:
 	save	%sp, -STACKFRAME_SZ, %sp
 	mov	%i0, %o0
-	sethi	%hi(0x10c6), %o1
+	sethi	%hi(0x10c7), %o1	! round multiplier up so large us ok
 	call	.umul
-	 or	%o1, %lo(0x10c6), %o1	! 2**32 / 1 000 000
+	 or	%o1, %lo(0x10c7), %o1	! 2**32 / 1 000 000
 	call	.umul
 	 mov	%i1, %o1		! udelay_val
+	sethi	%hi(0x028f4b62), %l0	! Add in rounding constant * 2**32,
+	or	%g0, %lo(0x028f4b62), %l0
+	addcc	%o0, %l0, %o0		! 2**32 * 0.009 999
+	bcs,a	3f
+	 add	%o1, 0x01, %o1
+3:
 	call	.umul
 	 mov	HZ, %o0			! >>32 earlier for wider range
 
-- 
1.5.2.5

-- 
