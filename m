Return-Path: <linux-kernel-owner+w=401wt.eu-S1753063AbYI3VQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbYI3VQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 17:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbYI3VQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 17:16:32 -0400
Received: from mx1.wp.pl ([212.77.101.5]:61205 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbYI3VQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 17:16:31 -0400
Date: Tue, 30 Sep 2008 23:17:51 +0200
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH] x86: do not allow to optimize flag_is_changeable_p() (rev.
 2)
Message-Id: <20080930231751.58db0fff.krzysztof.h1@wp.pl>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [UQPU]                               
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

Cyrix cpus have the CPUID instruction enabled before
the second call to the have_cpuid_p() but
it is not detected due to the gcc optimization.
Thus the ARR registers (mtrr like) are not detected
on such a cpu.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---

The second revision of this patch adds comment
after request from Jeremy Fitzhardinge.

I have tested the 6x86MX cpu with the CPUID
disabled. I have used linux-next tree (20080919)
and Yinghai Lu's patch:

x86: identify_cpu_without_cpuid v2

http://marc.info/?l=linux-kernel&m=122138380004347&w=2

The patch below is required to make the patch
above working correctly.

diff -urp linux-ref/arch/x86/kernel/cpu/common.c linux-mm/arch/x86/kernel/cpu/common.c
--- linux-ref/arch/x86/kernel/cpu/common.c	2008-09-30 23:07:08.000000000 +0200
+++ linux-mm/arch/x86/kernel/cpu/common.c	2008-09-30 23:12:19.098190815 +0200
@@ -124,18 +124,25 @@ static inline int flag_is_changeable_p(u
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
+	/*
+	 * Cyrix and IDT cpus allow disabling of CPUID
+	 * so the code below may return different results
+	 * when it is executed before and after enabling
+	 * the CPUID. Add "volatile" to not allow gcc to
+	 * optimize the subsequent calls to this function.
+	 */
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
