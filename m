Return-Path: <linux-kernel-owner+w=401wt.eu-S1763560AbYHERSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763560AbYHERSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761981AbYHERRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:17:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37704 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758092AbYHERRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:17:05 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080805717.971524000@firstfloor.org>
In-Reply-To: <20080805717.971524000@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [4/4] MCE: Don't disable machine checks during code patching
Message-Id: <20080805171738.9E2F01B90086@one.firstfloor.org>
Date: Tue,  5 Aug 2008 19:17:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This removes part of a a patch I added myself some time ago. After some 
consideration the patch was a bad idea. In particular it stopped machine check
exceptions during code patching.

To quote the comment:

        * MCEs only happen when something got corrupted and in this
        * case we must do something about the corruption.
        * Ignoring it is worse than a unlikely patching race.
        * Also machine checks tend to be broadcast and if one CPU
        * goes into machine check the others follow quickly, so we don't
        * expect a machine check to cause undue problems during to code
        * patching.

So undo the machine check related parts of 
8f4e956b313dcccbc7be6f10808952345e3b638c NMIs are still disabled.

This only removes code, the only additions are a new comment.


Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/alternative.c       |   17 +++++++++++------
 arch/x86/kernel/cpu/mcheck/mce_32.c |   14 --------------
 arch/x86/kernel/cpu/mcheck/mce_64.c |   14 --------------
 include/asm-x86/mce.h               |    2 --
 4 files changed, 11 insertions(+), 36 deletions(-)

Index: linux/arch/x86/kernel/alternative.c
===================================================================
--- linux.orig/arch/x86/kernel/alternative.c
+++ linux/arch/x86/kernel/alternative.c
@@ -424,9 +424,17 @@ void __init alternative_instructions(voi
 	   that might execute the to be patched code.
 	   Other CPUs are not running. */
 	stop_nmi();
-#ifdef CONFIG_X86_MCE
-	stop_mce();
-#endif
+
+	/*
+	 * Don't stop machine check exceptions while patching.
+	 * MCEs only happen when something got corrupted and in this
+	 * case we must do something about the corruption.
+	 * Ignoring it is worse than a unlikely patching race.
+	 * Also machine checks tend to be broadcast and if one CPU
+	 * goes into machine check the others follow quickly, so we don't
+	 * expect a machine check to cause undue problems during to code
+	 * patching.
+	 */
 
 	apply_alternatives(__alt_instructions, __alt_instructions_end);
 
@@ -466,9 +474,6 @@ void __init alternative_instructions(voi
 				(unsigned long)__smp_locks_end);
 
 	restart_nmi();
-#ifdef CONFIG_X86_MCE
-	restart_mce();
-#endif
 }
 
 /**
Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -699,20 +699,6 @@ static struct miscdevice mce_log_device 
 	&mce_chrdev_ops,
 };
 
-static unsigned long old_cr4 __initdata;
-
-void __init stop_mce(void)
-{
-	old_cr4 = read_cr4();
-	clear_in_cr4(X86_CR4_MCE);
-}
-
-void __init restart_mce(void)
-{
-	if (old_cr4 & X86_CR4_MCE)
-		set_in_cr4(X86_CR4_MCE);
-}
-
 /*
  * Old style boot options parsing. Only for compatibility.
  */
Index: linux/include/asm-x86/mce.h
===================================================================
--- linux.orig/include/asm-x86/mce.h
+++ linux/include/asm-x86/mce.h
@@ -113,8 +113,6 @@ extern void mcheck_init(struct cpuinfo_x
 #else
 #define mcheck_init(c) do { } while (0)
 #endif
-extern void stop_mce(void);
-extern void restart_mce(void);
 
 #endif /* __KERNEL__ */
 
Index: linux/arch/x86/kernel/cpu/mcheck/mce_32.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_32.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_32.c
@@ -61,20 +61,6 @@ void mcheck_init(struct cpuinfo_x86 *c)
 	}
 }
 
-static unsigned long old_cr4 __initdata;
-
-void __init stop_mce(void)
-{
-	old_cr4 = read_cr4();
-	clear_in_cr4(X86_CR4_MCE);
-}
-
-void __init restart_mce(void)
-{
-	if (old_cr4 & X86_CR4_MCE)
-		set_in_cr4(X86_CR4_MCE);
-}
-
 static int __init mcheck_disable(char *str)
 {
 	mce_disabled = 1;
