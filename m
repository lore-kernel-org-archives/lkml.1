Return-Path: <linux-kernel-owner+w=401wt.eu-S1753621AbYGDVVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbYGDVVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 17:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYGDVVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 17:21:30 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:52819 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbYGDVV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 17:21:29 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200807041120.678642023@firstfloor.org>
In-Reply-To: <200807041120.678642023@firstfloor.org>
To: masbock@linux.vnet.ibm.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [4/9] MCE: Call 64bit machine check through a call vector
Message-Id: <20080704212028.BCCA91B431F@basil.firstfloor.org>
Date: Fri,  4 Jul 2008 23:20:28 +0200 (CEST)
X-OriginalArrivalTime: 04 Jul 2008 21:13:06.0345 (UTC) FILETIME=[C0B1C190:01C8DE1A]
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
