Return-Path: <linux-kernel-owner+w=401wt.eu-S1760866AbYACAyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760866AbYACAyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbYACAuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:50:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58351 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759756AbYACAuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:50:11 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103149.088038000@suse.de>
In-Reply-To: <20080103149.088038000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [14/20] x86: Add per cpu counters for machine check polls / machine check events 
Message-Id: <20080103005009.EB0BC14D40@wotan.suse.de>
Date: Thu,  3 Jan 2008 01:50:09 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


.. and report them in /proc/interrupts

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    6 ++++++
 arch/x86/kernel/irq_32.c            |   10 ++++++++++
 arch/x86/kernel/irq_64.c            |    9 +++++++++
 include/asm-x86/mce.h               |    3 +++
 4 files changed, 28 insertions(+)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -23,6 +23,7 @@
 #include <linux/ctype.h>
 #include <linux/kmod.h>
 #include <linux/kdebug.h>
+#include <linux/percpu.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
 #include <asm/mce.h>
@@ -57,6 +58,9 @@ static char *trigger_argv[2] = { trigger
 
 static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
 
+DEFINE_PER_CPU(unsigned, mce_checks);
+DEFINE_PER_CPU(unsigned, mce_events);
+
 /*
  * Lockless MCE logging infrastructure.
  * This avoids deadlocks on printk locks without having to break locks. Also
@@ -208,6 +212,7 @@ void do_machine_check(struct pt_regs * r
 
 	memset(&m, 0, sizeof(struct mce));
 	m.cpu = smp_processor_id();
+	__get_cpu_var(mce_checks)++;
 	rdmsrl(MSR_IA32_MCG_STATUS, m.mcgstatus);
 	/* if the restart IP is not valid, we're done for */
 	if (!(m.mcgstatus & MCG_STATUS_RIPV))
@@ -263,6 +268,7 @@ void do_machine_check(struct pt_regs * r
 			panicm_found = 1;
 		}
 
+		__get_cpu_var(mce_checks)++;
 		add_taint(TAINT_MACHINE_CHECK);
 	}
 
Index: linux/arch/x86/kernel/irq_32.c
===================================================================
--- linux.orig/arch/x86/kernel/irq_32.c
+++ linux/arch/x86/kernel/irq_32.c
@@ -18,6 +18,7 @@
 
 #include <asm/apic.h>
 #include <asm/uaccess.h>
+#include <asm/mce.h>
 
 DEFINE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
 EXPORT_PER_CPU_SYMBOL(irq_stat);
@@ -329,6 +330,15 @@ skip:
 #if defined(CONFIG_X86_IO_APIC)
 		seq_printf(p, "MIS: %10u\n", atomic_read(&irq_mis_count));
 #endif
+		seq_printf(p, "MCE: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", per_cpu(mce_events, j));
+		seq_printf(p, "  Machine check events\n");
+		seq_printf(p, "MCP: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", per_cpu(mce_checks, j));
+		seq_printf(p, "  Machine check state polls\n");
+
 	}
 	return 0;
 }
Index: linux/include/asm-x86/mce.h
===================================================================
--- linux.orig/include/asm-x86/mce.h
+++ linux/include/asm-x86/mce.h
@@ -115,6 +115,9 @@ extern void mcheck_init(struct cpuinfo_x
 extern void stop_mce(void);
 extern void restart_mce(void);
 
+DECLARE_PER_CPU(unsigned, mce_events);
+DECLARE_PER_CPU(unsigned, mce_checks);
+
 #endif /* __KERNEL__ */
 
 #endif
Index: linux/arch/x86/kernel/irq_64.c
===================================================================
--- linux.orig/arch/x86/kernel/irq_64.c
+++ linux/arch/x86/kernel/irq_64.c
@@ -17,6 +17,7 @@
 #include <asm/io_apic.h>
 #include <asm/idle.h>
 #include <asm/smp.h>
+#include <asm/mce.h>
 
 DEFINE_PER_CPU(irq_cpustat_t, irq_stat);
 
@@ -151,6 +152,14 @@ skip:
 			seq_printf(p, "%10u ", cpu_pda(j)->irq_spurious_count);
 		seq_printf(p, "  Spurious interrupts\n");
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
+		seq_printf(p, "MCE: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", per_cpu(mce_events, j));
+		seq_printf(p, "  Machine check events\n");
+		seq_printf(p, "MCP: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", per_cpu(mce_checks, j));
+		seq_printf(p, "  Machine check state polls\n");
 	}
 	return 0;
 }
