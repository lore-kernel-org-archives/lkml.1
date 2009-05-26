Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbZEZXTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbZEZXTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758708AbZEZXSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:18:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53156 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759128AbZEZXSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:18:31 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 04/17] x86: MCE: Use a call vector to call the 64bit mce handler
Date: Wed, 27 May 2009 01:18:03 +0200
Message-Id: <4010bb177562589d0fd54043bb7bc6ea4d7998fd.1243377662.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <5a2337a03ce794fe7cf69e338ffacacb3770797c.1243377662.git.ak@linux.intel.com>
References: <1243379896-26869-1-git-send-email-andi@firstfloor.org>
 <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
 <86b35f6b0b17e1edc38fb5c3178967ffc4d1fa0a.1243377662.git.ak@linux.intel.com>
 <5a2337a03ce794fe7cf69e338ffacacb3770797c.1243377662.git.ak@linux.intel.com>
In-Reply-To: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
References: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Allows to call different machine check handlers from the low
level machine check entry vector.

This is needed for later when it will be used for 32bit too.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   23 ++++++++++++-----------
 arch/x86/kernel/cpu/mcheck/mce.h |    3 ++-
 arch/x86/kernel/entry_64.S       |    2 +-
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 26048b5..13ba422 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -39,6 +39,16 @@
 
 #include "mce.h"
 
+/* Handle unconfigured int18 (should never happen) */
+static void unexpected_machine_check(struct pt_regs *regs, long error_code)
+{
+	printk(KERN_ERR "CPU#%d: Unexpected int18 (Machine Check).\n",
+	       smp_processor_id());
+}
+
+/* Call the installed machine check handler for this CPU setup. */
+void (*machine_check_vector)(struct pt_regs *, long error_code) =
+						unexpected_machine_check;
 #ifdef CONFIG_X86_64
 
 #define MISC_MCELOG_MINOR	227
@@ -716,6 +726,8 @@ void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
 	}
 	mce_cpu_quirks(c);
 
+	machine_check_vector = do_machine_check;
+
 	mce_init(NULL);
 	mce_cpu_features(c);
 	mce_init_timer();
@@ -1290,17 +1302,6 @@ int mce_disabled;
 int nr_mce_banks;
 EXPORT_SYMBOL_GPL(nr_mce_banks);	/* non-fatal.o */
 
-/* Handle unconfigured int18 (should never happen) */
-static void unexpected_machine_check(struct pt_regs *regs, long error_code)
-{
-	printk(KERN_ERR "CPU#%d: Unexpected int18 (Machine Check).\n",
-	       smp_processor_id());
-}
-
-/* Call the installed machine check handler for this CPU setup. */
-void (*machine_check_vector)(struct pt_regs *, long error_code) =
-						unexpected_machine_check;
-
 /* This has to be run for each processor */
 void mcheck_init(struct cpuinfo_x86 *c)
 {
diff --git a/arch/x86/kernel/cpu/mcheck/mce.h b/arch/x86/kernel/cpu/mcheck/mce.h
index 6c763de..def7e34 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.h
+++ b/arch/x86/kernel/cpu/mcheck/mce.h
@@ -7,11 +7,12 @@ extern void intel_p5_mcheck_init(struct cpuinfo_x86 *c);
 extern void intel_p6_mcheck_init(struct cpuinfo_x86 *c);
 extern void winchip_mcheck_init(struct cpuinfo_x86 *c);
 
-#ifdef CONFIG_X86_32
 
 /* Call the installed machine check handler for this CPU setup. */
 extern void (*machine_check_vector)(struct pt_regs *, long error_code);
 
+#ifdef CONFIG_X86_32
+
 extern int nr_mce_banks;
 
 extern void intel_set_thermal_handler(void);
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 38946c6..63276c4 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1382,7 +1382,7 @@ paranoiderrorentry stack_segment do_stack_segment
 errorentry general_protection do_general_protection
 errorentry page_fault do_page_fault
 #ifdef CONFIG_X86_MCE
-paranoidzeroentry machine_check do_machine_check
+paranoidzeroentry machine_check *machine_check_vector(%rip)
 #endif
 
 	/*
-- 
1.6.0.2

