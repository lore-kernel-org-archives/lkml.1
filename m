Return-Path: <linux-kernel-owner+w=401wt.eu-S1759615AbZBLMsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615AbZBLMsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:48:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759815AbZBLMo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:44:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34503 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760334AbZBLMo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:44:27 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20090212143.515129156@firstfloor.org>
In-Reply-To: <20090212143.515129156@firstfloor.org>
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/4] x86: MCE: Factor out duplicated struct mce setup code into a single function
Message-Id: <20090212124322.8FAE43E666E@basil.firstfloor.org>
Date: Thu, 12 Feb 2009 13:43:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

This merely factors out duplicated code to set up
the initial struct mce state into a single function.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/mce.h                |    3 ++-
 arch/x86/kernel/cpu/mcheck/mce_64.c       |   23 ++++++++++++++---------
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c   |    4 +---
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |    2 +-
 4 files changed, 18 insertions(+), 14 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 12:10:19.000000000 +0100
@@ -65,6 +65,14 @@
 
 static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
 
+/* Do initial initialization of a struct mce */
+void mce_setup(struct mce *m)
+{
+	memset(m, 0, sizeof(struct mce));
+	m->cpu = smp_processor_id();
+	rdtscll(m->tsc);
+}
+
 /*
  * Lockless MCE logging infrastructure.
  * This avoids deadlocks on printk locks without having to break locks. Also
@@ -208,8 +216,8 @@
 	    || !banks)
 		goto out2;
 
-	memset(&m, 0, sizeof(struct mce));
-	m.cpu = smp_processor_id();
+	mce_setup(&m);
+
 	rdmsrl(MSR_IA32_MCG_STATUS, m.mcgstatus);
 	/* if the restart IP is not valid, we're done for */
 	if (!(m.mcgstatus & MCG_STATUS_RIPV))
@@ -225,7 +233,6 @@
 		m.misc = 0;
 		m.addr = 0;
 		m.bank = i;
-		m.tsc = 0;
 
 		rdmsrl(MSR_IA32_MC0_STATUS + i*4, m.status);
 		if ((m.status & MCI_STATUS_VAL) == 0)
@@ -252,8 +259,8 @@
 			rdmsrl(MSR_IA32_MC0_ADDR + i*4, m.addr);
 
 		mce_get_rip(&m, regs);
-		if (error_code >= 0)
-			rdtscll(m.tsc);
+		if (error_code < 0)
+			m.tsc = 0;
 		if (error_code != -2)
 			mce_log(&m);
 
@@ -341,15 +348,13 @@
  * and historically has been the register value of the
  * MSR_IA32_THERMAL_STATUS (Intel) msr.
  */
-void mce_log_therm_throt_event(unsigned int cpu, __u64 status)
+void mce_log_therm_throt_event(__u64 status)
 {
 	struct mce m;
 
-	memset(&m, 0, sizeof(m));
-	m.cpu = cpu;
+	mce_setup(&m);
 	m.bank = MCE_THERMAL_BANK;
 	m.status = status;
-	rdtscll(m.tsc);
 	mce_log(&m);
 }
 #endif /* CONFIG_X86_MCE_INTEL */
Index: linux/arch/x86/include/asm/mce.h
===================================================================
--- linux.orig/arch/x86/include/asm/mce.h	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/include/asm/mce.h	2009-02-12 12:10:19.000000000 +0100
@@ -90,6 +90,7 @@
 
 #include <asm/atomic.h>
 
+void mce_setup(struct mce *m);
 void mce_log(struct mce *m);
 DECLARE_PER_CPU(struct sys_device, device_mce);
 extern void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu);
@@ -106,7 +107,7 @@
 static inline void mce_amd_feature_init(struct cpuinfo_x86 *c) { }
 #endif
 
-void mce_log_therm_throt_event(unsigned int cpu, __u64 status);
+void mce_log_therm_throt_event(__u64 status);
 
 extern atomic_t mce_entry;
 
Index: linux/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_intel_64.c	2009-02-12 11:30:48.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/mce_intel_64.c	2009-02-12 12:10:17.000000000 +0100
@@ -24,7 +24,7 @@
 
 	rdmsrl(MSR_IA32_THERM_STATUS, msr_val);
 	if (therm_throt_process(msr_val & 1))
-		mce_log_therm_throt_event(smp_processor_id(), msr_val);
+		mce_log_therm_throt_event(msr_val);
 
 	inc_irq_stat(irq_thermal_count);
 	irq_exit();
Index: linux/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_amd_64.c	2009-02-12 11:30:48.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/mce_amd_64.c	2009-02-12 12:10:19.000000000 +0100
@@ -197,9 +197,7 @@
 	exit_idle();
 	irq_enter();
 
-	memset(&m, 0, sizeof(m));
-	rdtscll(m.tsc);
-	m.cpu = smp_processor_id();
+	mce_setup(&m);
 
 	/* assume first bank caused it */
 	for (bank = 0; bank < NR_BANKS; ++bank) {
