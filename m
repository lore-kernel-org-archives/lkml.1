Return-Path: <linux-kernel-owner+w=401wt.eu-S1759213AbYGGXLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213AbYGGXLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 19:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830AbYGGXLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 19:11:10 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:2565 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218AbYGGXLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 19:11:08 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080708110.487722491@firstfloor.org>
In-Reply-To: <20080708110.487722491@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [4/10] MCE: Call 64bit machine check through a call vector
Message-Id: <20080707231006.951C71B4315@basil.firstfloor.org>
Date: Tue,  8 Jul 2008 01:10:06 +0200 (CEST)
X-OriginalArrivalTime: 07 Jul 2008 23:02:42.0495 (UTC) FILETIME=[8F9FDCF0:01C8E085]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The 32bit mce code still needs that to interface to the WinChip
and P5 machine check handlers. On 64bit it's not strictly needed, but 
also doesn't really hurt.

This way avoids some special cases for 32bit.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    9 +++++++++
 arch/x86/kernel/entry_64.S          |    2 +-
 include/asm-x86/mce.h               |    2 ++
 3 files changed, 12 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -317,6 +317,13 @@ void do_machine_check(struct pt_regs * r
 	atomic_dec(&mce_entry);
 }
 
+static void ignore_machine_check(struct pt_regs *regs, long error_code)
+{
+}
+
+void (*machine_check_vector)(struct pt_regs *regs, long error_code) =
+	ignore_machine_check;
+
 #ifdef CONFIG_X86_MCE_INTEL
 /***
  * mce_log_therm_throt_event - Logs the thermal throttling event to mcelog
@@ -533,6 +540,8 @@ void __cpuinit mcheck_init(struct cpuinf
 	    !mce_available(c))
 		return;
 
+	machine_check_vector = do_machine_check;
+
 	mce_init(NULL);
 	mce_cpu_features(c);
 }
Index: linux/arch/x86/kernel/entry_64.S
===================================================================
--- linux.orig/arch/x86/kernel/entry_64.S
+++ linux/arch/x86/kernel/entry_64.S
@@ -1170,7 +1170,7 @@ ENTRY(machine_check)
 	INTR_FRAME
 	pushq $0
 	CFI_ADJUST_CFA_OFFSET 8	
-	paranoidentry do_machine_check
+	paranoidentry *machine_check_vector(%rip)
 	jmp paranoid_exit1
 	CFI_ENDPROC
 END(machine_check)
Index: linux/include/asm-x86/mce.h
===================================================================
--- linux.orig/include/asm-x86/mce.h
+++ linux/include/asm-x86/mce.h
@@ -107,6 +107,8 @@ static inline void mce_amd_feature_init(
 
 void mce_log_therm_throt_event(unsigned int cpu, __u64 status);
 
+extern void (*machine_check_vector)(struct pt_regs *, long error_code);
+
 extern atomic_t mce_entry;
 
 extern void do_machine_check(struct pt_regs *, long);
