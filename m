Return-Path: <linux-kernel-owner+w=401wt.eu-S1759557AbZDGPLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557AbZDGPLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758099AbZDGPHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:07:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48843 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147AbZDGPHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:07:49 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [6/28] x86: MCE: Add machine check exception count in /proc/interrupts
Message-Id: <20090407150747.21C711D046E@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:07:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: feature, debugging tool

Useful for debugging, but it's also good general policy
to have a counter for all special interrupts there. This makes it easier
to diagnose where a CPU is spending its time.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/mce.h          |    3 +++
 arch/x86/kernel/cpu/mcheck/mce_64.c |    4 ++++
 arch/x86/kernel/irq.c               |   10 ++++++++++
 3 files changed, 17 insertions(+)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:14.000000000 +0200
@@ -75,6 +75,8 @@
 	rdtscll(m->tsc);
 }
 
+DEFINE_PER_CPU(unsigned, mce_exception_count);
+
 /*
  * Lockless MCE logging infrastructure.
  * This avoids deadlocks on printk locks without having to break locks. Also
@@ -285,6 +287,8 @@
 
 	atomic_inc(&mce_entry);
 
+	__get_cpu_var(mce_exception_count)++;
+
 	if (notify_die(DIE_NMI, "machine check", regs, error_code,
 			   18, SIGKILL) == NOTIFY_STOP)
 		goto out2;
Index: linux/arch/x86/include/asm/mce.h
===================================================================
--- linux.orig/arch/x86/include/asm/mce.h	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/include/asm/mce.h	2009-04-07 16:43:10.000000000 +0200
@@ -93,6 +93,7 @@
 #else /* CONFIG_X86_32 */
 
 #include <asm/atomic.h>
+#include <linux/percpu.h>
 
 void mce_setup(struct mce *m);
 void mce_log(struct mce *m);
@@ -127,6 +128,8 @@
 
 extern int mce_available(struct cpuinfo_x86 *c);
 
+DECLARE_PER_CPU(unsigned, mce_exception_count);
+
 void mce_log_therm_throt_event(__u64 status);
 
 extern atomic_t mce_entry;
Index: linux/arch/x86/kernel/irq.c
===================================================================
--- linux.orig/arch/x86/kernel/irq.c	2009-04-07 16:09:56.000000000 +0200
+++ linux/arch/x86/kernel/irq.c	2009-04-07 16:09:59.000000000 +0200
@@ -12,6 +12,7 @@
 #include <asm/io_apic.h>
 #include <asm/irq.h>
 #include <asm/idle.h>
+#include <asm/mce.h>
 
 atomic_t irq_err_count;
 
@@ -96,6 +97,12 @@
 	seq_printf(p, "  Threshold APIC interrupts\n");
 # endif
 #endif
+#if defined(CONFIG_X86_MCE) && defined(CONFIG_X86_64)
+	seq_printf(p, "%*s: ", prec, "MCE");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ", per_cpu(mce_exception_count, j));
+	seq_printf(p, "  Machine check exceptions\n");
+#endif
 	seq_printf(p, "%*s: %10u\n", prec, "ERR", atomic_read(&irq_err_count));
 #if defined(CONFIG_X86_IO_APIC)
 	seq_printf(p, "%*s: %10u\n", prec, "MIS", atomic_read(&irq_mis_count));
@@ -163,6 +170,9 @@
 {
 	u64 sum = irq_stats(cpu)->__nmi_count;
 
+#if defined(CONFIG_X86_MCE) && defined(CONFIG_X86_64)
+	sum += per_cpu(mce_exception_count, cpu);
+#endif
 #ifdef CONFIG_X86_LOCAL_APIC
 	sum += irq_stats(cpu)->apic_timer_irqs;
 	sum += irq_stats(cpu)->irq_spurious_count;
