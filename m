Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbYGGGaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbYGGGaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 02:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbYGGG25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 02:28:57 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:56828 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbYGGG2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 02:28:55 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080707828.405203787@firstfloor.org>
In-Reply-To: <20080707828.405203787@firstfloor.org>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [4/9] MCE: Call 64bit machine check through a call vector
Message-Id: <20080707062836.A22581B4315@basil.firstfloor.org>
Date: Mon,  7 Jul 2008 08:28:36 +0200 (CEST)
X-OriginalArrivalTime: 07 Jul 2008 06:21:12.0875 (UTC) FILETIME=[A76B7FB0:01C8DFF9]
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
