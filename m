Return-Path: <linux-kernel-owner+w=401wt.eu-S1762151AbYENPsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762151AbYENPsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759312AbYENPsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:48:18 -0400
Received: from gw.goop.org ([64.81.55.164]:49791 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758354AbYENPsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:48:17 -0400
Message-ID: <482B09B5.8090408@goop.org>
Date: Wed, 14 May 2008 16:48:05 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 2/3] add an inlined version of iter_div_u64_rem
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iter_div_u64_rem is used in the x86-64 vdso, which cannot call other
kernel code.  For this case, provide the always_inlined version,
__iter_div_u64_rem.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/linux/math64.h |   19 +++++++++++++++++++
 lib/div64.c            |   15 +--------------
 2 files changed, 20 insertions(+), 14 deletions(-)

===================================================================
--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -83,4 +83,23 @@
 
 u32 iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder);
 
+static __always_inline u32
+__iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder)
+{
+	u32 ret = 0;
+
+	while (dividend >= divisor) {
+		/* The following asm() prevents the compiler from
+		   optimising this loop into a modulo operation.  */
+		asm("" : "+rm"(dividend));
+
+		dividend -= divisor;
+		ret++;
+	}
+
+	*remainder = dividend;
+
+	return ret;
+}
+
 #endif /* _LINUX_MATH64_H */
===================================================================
--- a/lib/div64.c
+++ b/lib/div64.c
@@ -105,19 +105,6 @@
  */
 u32 iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder)
 {
-	u32 ret = 0;
-
-	while (dividend >= divisor) {
-		/* The following asm() prevents the compiler from
-		   optimising this loop into a modulo operation.  */
-		asm("" : "+rm"(dividend));
-
-		dividend -= divisor;
-		ret++;
-	}
-
-	*remainder = dividend;
-
-	return ret;
+	return __iter_div_u64_rem(dividend, divisor, remainder);
 }
 EXPORT_SYMBOL(iter_div_u64_rem);


