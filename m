Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbZBLMjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbZBLMjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757390AbZBLMi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:38:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35208 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825AbZBLMi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:38:27 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20090212137.750180365@firstfloor.org>
In-Reply-To: <20090212137.750180365@firstfloor.org>
To: akpm@linux-foundation.org, x86@firstfloor.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [2/10] x86: MCE: Don't disable machine checks during code patching
Message-Id: <20090212123721.461763E666D@basil.firstfloor.org>
Date: Thu, 12 Feb 2009 13:37:21 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: low priority bug fix

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
 arch/x86/include/asm/mce.h          |    2 --
 arch/x86/kernel/alternative.c       |   17 +++++++++++------
 arch/x86/kernel/cpu/mcheck/mce_32.c |   14 --------------
 arch/x86/kernel/cpu/mcheck/mce_64.c |   14 --------------
 4 files changed, 11 insertions(+), 36 deletions(-)

Index: linux/arch/x86/kernel/alternative.c
===================================================================
--- linux.orig/arch/x86/kernel/alternative.c	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/kernel/alternative.c	2009-02-12 11:30:51.000000000 +0100
@@ -414,9 +414,17 @@
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
 
@@ -456,9 +464,6 @@
 				(unsigned long)__smp_locks_end);
 
 	restart_nmi();
-#ifdef CONFIG_X86_MCE
-	restart_mce();
-#endif
 }
 
 /**
Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 12:10:22.000000000 +0100
@@ -680,20 +680,6 @@
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
Index: linux/arch/x86/include/asm/mce.h
===================================================================
--- linux.orig/arch/x86/include/asm/mce.h	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/include/asm/mce.h	2009-02-12 12:10:19.000000000 +0100
@@ -120,8 +120,6 @@
 #else
 #define mcheck_init(c) do { } while (0)
 #endif
-extern void stop_mce(void);
-extern void restart_mce(void);
 
 #endif /* __KERNEL__ */
 #endif /* _ASM_X86_MCE_H */
Index: linux/arch/x86/kernel/cpu/mcheck/mce_32.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_32.c	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/mce_32.c	2009-02-12 11:30:51.000000000 +0100
@@ -60,20 +60,6 @@
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
