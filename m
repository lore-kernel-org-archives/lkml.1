Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbZEZX43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbZEZX43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbZEZXyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:54:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38593 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884AbZEZXym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:42 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 05/31] x86: MCE: Add machine check exception count in /proc/interrupts
Date: Wed, 27 May 2009 01:54:07 +0200
Message-Id: <723b3fe4e35063b123cee9658c24267287eeac07.1243381848.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1623cd9a1c77d35fc2044d72c4bfa1246e67a1c0.1243381848.git.ak@linux.intel.com>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
 <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
 <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
 <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com>
 <1623cd9a1c77d35fc2044d72c4bfa1246e67a1c0.1243381848.git.ak@linux.intel.com>
In-Reply-To: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
References: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Impact: feature, debugging tool

Useful for debugging, but it's also good general policy
to have a counter for all special interrupts there. This makes it easier
to diagnose where a CPU is spending its time.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/mce.h       |    3 +++
 arch/x86/kernel/cpu/mcheck/mce.c |    4 ++++
 arch/x86/kernel/irq.c            |   10 ++++++++++
 3 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 8ad67bf..1ff437f 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -89,6 +89,7 @@ struct mce_log {
 extern int mce_disabled;
 
 #include <asm/atomic.h>
+#include <linux/percpu.h>
 
 void mce_setup(struct mce *m);
 void mce_log(struct mce *m);
@@ -123,6 +124,8 @@ static inline void mce_amd_feature_init(struct cpuinfo_x86 *c) { }
 
 extern int mce_available(struct cpuinfo_x86 *c);
 
+DECLARE_PER_CPU(unsigned, mce_exception_count);
+
 void mce_log_therm_throt_event(__u64 status);
 
 extern atomic_t mce_entry;
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 8a8af56..d2d7a68 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -58,6 +58,8 @@ int				mce_disabled;
 
 atomic_t mce_entry;
 
+DEFINE_PER_CPU(unsigned, mce_exception_count);
+
 /*
  * Tolerant levels:
  *   0: always panic on uncorrected errors, log corrected errors
@@ -362,6 +364,8 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 
 	atomic_inc(&mce_entry);
 
+	__get_cpu_var(mce_exception_count)++;
+
 	if (notify_die(DIE_NMI, "machine check", regs, error_code,
 			   18, SIGKILL) == NOTIFY_STOP)
 		goto out2;
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 35eddc9..14047b9 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -12,6 +12,7 @@
 #include <asm/io_apic.h>
 #include <asm/irq.h>
 #include <asm/idle.h>
+#include <asm/mce.h>
 
 atomic_t irq_err_count;
 
@@ -96,6 +97,12 @@ static int show_other_interrupts(struct seq_file *p, int prec)
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
@@ -163,6 +170,9 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 {
 	u64 sum = irq_stats(cpu)->__nmi_count;
 
+#if defined(CONFIG_X86_MCE) && defined(CONFIG_X86_64)
+	sum += per_cpu(mce_exception_count, cpu);
+#endif
 #ifdef CONFIG_X86_LOCAL_APIC
 	sum += irq_stats(cpu)->apic_timer_irqs;
 	sum += irq_stats(cpu)->irq_spurious_count;
-- 
1.6.0.2

