Return-Path: <linux-kernel-owner+w=401wt.eu-S1758802AbYGaVpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802AbYGaVpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbYGaVpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:45:07 -0400
Received: from mx1.wp.pl ([212.77.101.5]:57799 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527AbYGaVpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:45:06 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jul 2008 17:45:06 EDT
Date: Thu, 31 Jul 2008 23:43:44 +0200
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: hpa@zytor.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: fdiv bug detection fix
Message-Id: <20080731234344.eb3c4ed2.krzysztof.h1@wp.pl>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [YdM1]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Helt <krzysztof.h1@wp.pl>

The fdiv detection code writes s32 integer into
the boot_cpu_data.fdiv_bug. 
However, the boot_cpu_data.fdiv_bug is only char (s8)
field so the detection overwrites already set fields for
other bugs, e.g. the f00f bug field.

Use local s32 variable to receive result.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---

This is a partial fix to Bugzilla #9928  - fixes wrong 
information about the f00f bug (tested) and probably
for coma bug (I have no cpu to test this).

diff -urp linux-alsa/arch/x86/kernel/cpu/bugs.c linux-new/arch/x86/kernel/cpu/bugs.c
--- linux-alsa/arch/x86/kernel/cpu/bugs.c	2008-07-31 12:40:31.000000000 +0200
+++ linux-new/arch/x86/kernel/cpu/bugs.c	2008-07-31 23:24:07.722657435 +0200
@@ -50,6 +50,8 @@ static double __initdata y = 3145727.0;
  */
 static void __init check_fpu(void)
 {
+	s32 fdiv_bug;
+
 	if (!boot_cpu_data.hard_math) {
 #ifndef CONFIG_MATH_EMULATION
 		printk(KERN_EMERG "No coprocessor found and no math emulation present.\n");
@@ -74,8 +76,10 @@ static void __init check_fpu(void)
 		"fistpl %0\n\t"
 		"fwait\n\t"
 		"fninit"
-		: "=m" (*&boot_cpu_data.fdiv_bug)
+		: "=m" (*&fdiv_bug)
 		: "m" (*&x), "m" (*&y));
+
+	boot_cpu_data.fdiv_bug = fdiv_bug;
 	if (boot_cpu_data.fdiv_bug)
 		printk("Hmm, FPU with FDIV bug.\n");
 }
