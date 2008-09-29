Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbYI2SOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbYI2SOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbYI2SE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:04:56 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:28548 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbYI2SEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:04:55 -0400
Date: Mon, 29 Sep 2008 20:06:03 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: do not allow to optimize flag_is_changeable_p()
Message-Id: <20080929200603.dcdc5b71.krzysztof.h1@poczta.fm>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: c8c0b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Helt <krzysztof.h1@wp.pl>

The flag_is_changeable_p() is used by
has_cpuid_p() which can return different results
in the code sequence below:

 if (!have_cpuid_p())
      identify_cpu_without_cpuid(c);

  /* cyrix could have cpuid enabled via c_identify()*/
  if (!have_cpuid_p())
      return;

Otherwise, the gcc 3.4.6 optimizes these two calls
into one which make the code not working correctly.
Cyrix cpus have the CPUID instruction enabled but
it is not detected due to the gcc optimization.
Thus the ARR registers (mtrr like) are not detected
on such a cpu.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---

I have tested the 6x86MX cpu with the CPUID
disabled. I have used linux-next tree (20080819)
and Yinghai Lu's patch:

x86: identify_cpu_without_cpuid v2

http://marc.info/?l=linux-kernel&m=122138380004347&w=2

The patch below is required to make the patch
above working correctly.

diff -urp linux-orig/arch/x86/kernel/cpu/common.c linux-2.6.27/arch/x86/kernel/cpu/common.c
--- linux-orig/arch/x86/kernel/cpu/common.c	2008-09-29 07:11:54.000000000 +0200
+++ linux-2.6.27/arch/x86/kernel/cpu/common.c	2008-09-29 18:07:27.667392725 +0200
@@ -124,18 +124,18 @@ static inline int flag_is_changeable_p(u
 {
 	u32 f1, f2;
 
-	asm("pushfl\n\t"
-	    "pushfl\n\t"
-	    "popl %0\n\t"
-	    "movl %0,%1\n\t"
-	    "xorl %2,%0\n\t"
-	    "pushl %0\n\t"
-	    "popfl\n\t"
-	    "pushfl\n\t"
-	    "popl %0\n\t"
-	    "popfl\n\t"
-	    : "=&r" (f1), "=&r" (f2)
-	    : "ir" (flag));
+	asm volatile ("pushfl\n\t"
+		      "pushfl\n\t"
+		      "popl %0\n\t"
+		      "movl %0,%1\n\t"
+		      "xorl %2,%0\n\t"
+		      "pushl %0\n\t"
+		      "popfl\n\t"
+		      "pushfl\n\t"
+		      "popl %0\n\t"
+		      "popfl\n\t"
+		      : "=&r" (f1), "=&r" (f2)
+		      : "ir" (flag));
 
 	return ((f1^f2) & flag) != 0;
 }

----------------------------------------------------------------------
Dzwon taniej na zagraniczne komorki!
Sprawdz >> http://link.interia.pl/f1f26 

