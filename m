Return-Path: <linux-kernel-owner+w=401wt.eu-S1758269AbZJEAzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbZJEAzY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 20:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758246AbZJEAzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 20:55:22 -0400
Received: from mail.perches.com ([173.55.12.10]:1723 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758243AbZJEAzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 20:55:18 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 08/21] mcheck/: use pr_<level> and add pr_fmt(fmt)
Date: Sun,  4 Oct 2009 17:53:35 -0700
Message-Id: <faf453e9e7ba4bfab737f59cbcaed1c313821bde.1254701151.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
Converted printk(KERN_<level> to pr_<level>(

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kernel/cpu/mcheck/mce-inject.c  |   20 ++++++-----
 arch/x86/kernel/cpu/mcheck/mce.c         |   59 +++++++++++++++---------------
 arch/x86/kernel/cpu/mcheck/mce_intel.c   |    8 +++--
 arch/x86/kernel/cpu/mcheck/p5.c          |   21 +++++------
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   21 ++++++-----
 arch/x86/kernel/cpu/mcheck/threshold.c   |    7 +++-
 arch/x86/kernel/cpu/mcheck/winchip.c     |    8 +++--
 7 files changed, 76 insertions(+), 68 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 472763d..e757355 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -11,6 +11,9 @@
  * Andi Kleen
  * Ying Huang
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/timer.h>
@@ -106,7 +109,7 @@ static int raise_local(void)
 	int cpu = m->extcpu;
 
 	if (m->inject_flags & MCJ_EXCEPTION) {
-		printk(KERN_INFO "Triggering MCE exception on CPU %d\n", cpu);
+		pr_info("Triggering MCE exception on CPU %d\n", cpu);
 		switch (context) {
 		case MCJ_CTX_IRQ:
 			/*
@@ -119,15 +122,15 @@ static int raise_local(void)
 			raise_exception(m, NULL);
 			break;
 		default:
-			printk(KERN_INFO "Invalid MCE context\n");
+			pr_info("Invalid MCE context\n");
 			ret = -EINVAL;
 		}
-		printk(KERN_INFO "MCE exception done on CPU %d\n", cpu);
+		pr_info("MCE exception done on CPU %d\n", cpu);
 	} else if (m->status) {
-		printk(KERN_INFO "Starting machine check poll CPU %d\n", cpu);
+		pr_info("Starting machine check poll CPU %d\n", cpu);
 		raise_poll(m);
 		mce_notify_irq();
-		printk(KERN_INFO "Machine check poll done on CPU %d\n", cpu);
+		pr_info("Machine check poll done on CPU %d\n", cpu);
 	} else
 		m->finished = 0;
 
@@ -161,9 +164,8 @@ static void raise_mce(struct mce *m)
 		start = jiffies;
 		while (!cpus_empty(mce_inject_cpumask)) {
 			if (!time_before(jiffies, start + 2*HZ)) {
-				printk(KERN_ERR
-				"Timeout waiting for mce inject NMI %lx\n",
-					*cpus_addr(mce_inject_cpumask));
+				pr_err("Timeout waiting for mce inject NMI %lx\n",
+				       *cpus_addr(mce_inject_cpumask));
 				break;
 			}
 			cpu_relax();
@@ -210,7 +212,7 @@ static ssize_t mce_write(struct file *filp, const char __user *ubuf,
 
 static int inject_init(void)
 {
-	printk(KERN_INFO "Machine check injector initialized\n");
+	pr_info("Machine check injector initialized\n");
 	mce_chrdev_ops.write = mce_write;
 	register_die_notifier(&mce_raise_nb);
 	return 0;
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 183c345..a63b934 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -7,6 +7,9 @@
  * Copyright 2008 Intel Corporation
  * Author: Andi Kleen
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/thread_info.h>
 #include <linux/capability.h>
 #include <linux/miscdevice.h>
@@ -172,39 +175,37 @@ void __weak decode_mce(struct mce *m)
 
 static void print_mce(struct mce *m)
 {
-	printk(KERN_EMERG
-	       "CPU %d: Machine Check Exception: %16Lx Bank %d: %016Lx\n",
-	       m->extcpu, m->mcgstatus, m->bank, m->status);
+	pr_emerg("CPU %d: Machine Check Exception: %16Lx Bank %d: %016Lx\n",
+		 m->extcpu, m->mcgstatus, m->bank, m->status);
 	if (m->ip) {
-		printk(KERN_EMERG "RIP%s %02x:<%016Lx> ",
-		       !(m->mcgstatus & MCG_STATUS_EIPV) ? " !INEXACT!" : "",
-		       m->cs, m->ip);
+		pr_emerg("RIP%s %02x:<%016Lx> ",
+			 !(m->mcgstatus & MCG_STATUS_EIPV) ? " !INEXACT!" : "",
+			 m->cs, m->ip);
 		if (m->cs == __KERNEL_CS)
 			print_symbol("{%s}", m->ip);
-		printk(KERN_CONT "\n");
+		pr_cont("\n");
 	}
-	printk(KERN_EMERG "TSC %llx ", m->tsc);
+	pr_emerg("TSC %llx ", m->tsc);
 	if (m->addr)
-		printk(KERN_CONT "ADDR %llx ", m->addr);
+		pr_cont("ADDR %llx ", m->addr);
 	if (m->misc)
-		printk(KERN_CONT "MISC %llx ", m->misc);
-	printk(KERN_CONT "\n");
-	printk(KERN_EMERG "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
-			m->cpuvendor, m->cpuid, m->time, m->socketid,
-			m->apicid);
+		pr_cont("MISC %llx ", m->misc);
+	pr_cont("\n");
+	pr_emerg("PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
+		 m->cpuvendor, m->cpuid, m->time, m->socketid, m->apicid);
 
 	decode_mce(m);
 }
 
 static void print_mce_head(void)
 {
-	printk(KERN_EMERG "\nHARDWARE ERROR\n");
+	pr_emerg("\nHARDWARE ERROR\n");
 }
 
 static void print_mce_tail(void)
 {
-	printk(KERN_EMERG "This is not a software problem!\n"
-	       "Run through mcelog --ascii to decode and contact your hardware vendor\n");
+	pr_emerg("This is not a software problem!\n"
+		 "Run through mcelog --ascii to decode and contact your hardware vendor\n");
 }
 
 #define PANIC_TIMEOUT 5 /* 5 seconds */
@@ -268,16 +269,16 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 	if (final)
 		print_mce(final);
 	if (cpu_missing)
-		printk(KERN_EMERG "Some CPUs didn't answer in synchronization\n");
+		pr_emerg("Some CPUs didn't answer in synchronization\n");
 	print_mce_tail();
 	if (exp)
-		printk(KERN_EMERG "Machine check: %s\n", exp);
+		pr_emerg("Machine check: %s\n", exp);
 	if (!fake_panic) {
 		if (panic_timeout == 0)
 			panic_timeout = mce_panic_timeout;
 		panic(msg);
 	} else
-		printk(KERN_EMERG "Fake kernel panic: %s\n", msg);
+		pr_emerg("Fake kernel panic: %s\n", msg);
 }
 
 /* Support code for software error injection */
@@ -1046,7 +1047,7 @@ EXPORT_SYMBOL_GPL(do_machine_check);
 /* dummy to break dependency. actual code is in mm/memory-failure.c */
 void __attribute__((weak)) memory_failure(unsigned long pfn, int vector)
 {
-	printk(KERN_ERR "Action optional memory failure at %lx ignored\n", pfn);
+	pr_err("Action optional memory failure at %lx ignored\n", pfn);
 }
 
 /*
@@ -1165,7 +1166,7 @@ int mce_notify_irq(void)
 			schedule_work(&mce_trigger_work);
 
 		if (__ratelimit(&ratelimit))
-			printk(KERN_INFO "Machine check events logged\n");
+			pr_info("Machine check events logged\n");
 
 		return 1;
 	}
@@ -1200,12 +1201,11 @@ static int __cpuinit mce_cap_init(void)
 	rdmsrl(MSR_IA32_MCG_CAP, cap);
 
 	b = cap & MCG_BANKCNT_MASK;
-	printk(KERN_INFO "mce: CPU supports %d MCE banks\n", b);
+	pr_info("CPU supports %d MCE banks\n", b);
 
 	if (b > MAX_NR_BANKS) {
-		printk(KERN_WARNING
-		       "MCE: Using only %u machine check banks out of %u\n",
-			MAX_NR_BANKS, b);
+		pr_warning("Using only %u machine check banks out of %u\n",
+			   MAX_NR_BANKS, b);
 		b = MAX_NR_BANKS;
 	}
 
@@ -1261,7 +1261,7 @@ static void mce_init(void)
 static int __cpuinit mce_cpu_quirks(struct cpuinfo_x86 *c)
 {
 	if (c->x86_vendor == X86_VENDOR_UNKNOWN) {
-		pr_info("MCE: unknown CPU type - not enabling MCE support.\n");
+		pr_info("unknown CPU type - not enabling MCE support.\n");
 		return -EOPNOTSUPP;
 	}
 
@@ -1373,7 +1373,7 @@ static void mce_init_timer(void)
 /* Handle unconfigured int18 (should never happen) */
 static void unexpected_machine_check(struct pt_regs *regs, long error_code)
 {
-	printk(KERN_ERR "CPU#%d: Unexpected int18 (Machine Check).\n",
+	pr_err("CPU#%d: Unexpected int18 (Machine Check).\n",
 	       smp_processor_id());
 }
 
@@ -1617,8 +1617,7 @@ static int __init mcheck_enable(char *str)
 			get_option(&str, &monarch_timeout);
 		}
 	} else {
-		printk(KERN_INFO "mce argument %s ignored. Please use /sys\n",
-		       str);
+		pr_info("argument %s ignored. Please use /sys\n", str);
 		return 0;
 	}
 	return 1;
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 889f665..174ab47 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -5,6 +5,8 @@
  * Author: Andi Kleen
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/percpu.h>
@@ -66,9 +68,9 @@ static void intel_threshold_interrupt(void)
 static void print_update(char *type, int *hdr, int num)
 {
 	if (*hdr == 0)
-		printk(KERN_INFO "CPU %d MCA banks", smp_processor_id());
+		pr_info("CPU %d MCA banks", smp_processor_id());
 	*hdr = 1;
-	printk(KERN_CONT " %s:%d", type, num);
+	pr_cont(" %s:%d", type, num);
 }
 
 /*
@@ -115,7 +117,7 @@ static void cmci_discover(int banks, int boot)
 	}
 	spin_unlock_irqrestore(&cmci_discover_lock, flags);
 	if (hdr)
-		printk(KERN_CONT "\n");
+		pr_cont("\n");
 }
 
 /*
diff --git a/arch/x86/kernel/cpu/mcheck/p5.c b/arch/x86/kernel/cpu/mcheck/p5.c
index 5c0e653..413f0d1 100644
--- a/arch/x86/kernel/cpu/mcheck/p5.c
+++ b/arch/x86/kernel/cpu/mcheck/p5.c
@@ -2,6 +2,9 @@
  * P5 specific Machine Check Exception Reporting
  * (C) Copyright 2002 Alan Cox <alan@lxorguk.ukuu.org.uk>
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
@@ -24,14 +27,12 @@ static void pentium_machine_check(struct pt_regs *regs, long error_code)
 	rdmsr(MSR_IA32_P5_MC_ADDR, loaddr, hi);
 	rdmsr(MSR_IA32_P5_MC_TYPE, lotype, hi);
 
-	printk(KERN_EMERG
-		"CPU#%d: Machine Check Exception:  0x%8X (type 0x%8X).\n",
-		smp_processor_id(), loaddr, lotype);
+	pr_emerg("CPU#%d: Machine Check Exception:  0x%8X (type 0x%8X).\n",
+		 smp_processor_id(), loaddr, lotype);
 
 	if (lotype & (1<<5)) {
-		printk(KERN_EMERG
-			"CPU#%d: Possible thermal failure (CPU on fire ?).\n",
-			smp_processor_id());
+		pr_emerg("CPU#%d: Possible thermal failure (CPU on fire ?).\n",
+			 smp_processor_id());
 	}
 
 	add_taint(TAINT_MACHINE_CHECK);
@@ -57,12 +58,10 @@ void intel_p5_mcheck_init(struct cpuinfo_x86 *c)
 	/* Read registers before enabling: */
 	rdmsr(MSR_IA32_P5_MC_ADDR, l, h);
 	rdmsr(MSR_IA32_P5_MC_TYPE, l, h);
-	printk(KERN_INFO
-	       "Intel old style machine check architecture supported.\n");
+	pr_info("Intel old style machine check architecture supported.\n");
 
 	/* Enable MCE: */
 	set_in_cr4(X86_CR4_MCE);
-	printk(KERN_INFO
-	       "Intel old style machine check reporting enabled on CPU#%d.\n",
-	       smp_processor_id());
+	pr_info("Intel old style machine check reporting enabled on CPU#%d.\n",
+		smp_processor_id());
 }
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index b3a1dba..ca47290 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -13,6 +13,9 @@
  * Credits: Adapted from Zwane Mwaikambo's original code in mce_intel.c.
  *          Inspired by Ross Biro's and Al Borchers' counter code.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/interrupt.h>
 #include <linux/notifier.h>
 #include <linux/jiffies.h>
@@ -130,13 +133,14 @@ static int therm_throt_process(bool is_throttled)
 
 	/* if we just entered the thermal event */
 	if (is_throttled) {
-		printk(KERN_CRIT "CPU%d: Temperature above threshold, cpu clock throttled (total events = %lu)\n", this_cpu, state->throttle_count);
+		pr_crit("CPU%d: Temperature above threshold, cpu clock throttled (total events = %lu)\n",
+			this_cpu, state->throttle_count);
 
 		add_taint(TAINT_MACHINE_CHECK);
 		return 1;
 	}
 	if (was_throttled) {
-		printk(KERN_INFO "CPU%d: Temperature/speed normal\n", this_cpu);
+		pr_info("CPU%d: Temperature/speed normal\n", this_cpu);
 		return 1;
 	}
 
@@ -236,8 +240,7 @@ static void intel_thermal_interrupt(void)
 
 static void unexpected_thermal_interrupt(void)
 {
-	printk(KERN_ERR "CPU%d: Unexpected LVT TMR interrupt!\n",
-			smp_processor_id());
+	pr_err("CPU%d: Unexpected LVT TMR interrupt!\n", smp_processor_id());
 	add_taint(TAINT_MACHINE_CHECK);
 }
 
@@ -272,15 +275,13 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
 	h = apic_read(APIC_LVTTHMR);
 	if ((l & MSR_IA32_MISC_ENABLE_TM1) && (h & APIC_DM_SMI)) {
-		printk(KERN_DEBUG
-		       "CPU%d: Thermal monitoring handled by SMI\n", cpu);
+		pr_dbg("CPU%d: Thermal monitoring handled by SMI\n", cpu);
 		return;
 	}
 
 	/* Check whether a vector already exists */
 	if (h & APIC_VECTOR_MASK) {
-		printk(KERN_DEBUG
-		       "CPU%d: Thermal LVT vector (%#x) already installed\n",
+		pr_dbg("CPU%d: Thermal LVT vector (%#x) already installed\n",
 		       cpu, (h & APIC_VECTOR_MASK));
 		return;
 	}
@@ -312,8 +313,8 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 	l = apic_read(APIC_LVTTHMR);
 	apic_write(APIC_LVTTHMR, l & ~APIC_LVT_MASKED);
 
-	printk(KERN_INFO "CPU%d: Thermal monitoring enabled (%s)\n",
-	       cpu, tm2 ? "TM2" : "TM1");
+	pr_info("CPU%d: Thermal monitoring enabled (%s)\n",
+		cpu, tm2 ? "TM2" : "TM1");
 
 	/* enable thermal throttle processing */
 	atomic_set(&therm_throt_en, 1);
diff --git a/arch/x86/kernel/cpu/mcheck/threshold.c b/arch/x86/kernel/cpu/mcheck/threshold.c
index d746df2..733280a 100644
--- a/arch/x86/kernel/cpu/mcheck/threshold.c
+++ b/arch/x86/kernel/cpu/mcheck/threshold.c
@@ -1,6 +1,9 @@
 /*
  * Common corrected MCE threshold handler code:
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 
@@ -11,8 +14,8 @@
 
 static void default_threshold_interrupt(void)
 {
-	printk(KERN_ERR "Unexpected threshold interrupt at vector %x\n",
-			 THRESHOLD_APIC_VECTOR);
+	pr_err("Unexpected threshold interrupt at vector %x\n",
+	       THRESHOLD_APIC_VECTOR);
 }
 
 void (*mce_threshold_vector)(void) = default_threshold_interrupt;
diff --git a/arch/x86/kernel/cpu/mcheck/winchip.c b/arch/x86/kernel/cpu/mcheck/winchip.c
index 54060f5..06d27f2 100644
--- a/arch/x86/kernel/cpu/mcheck/winchip.c
+++ b/arch/x86/kernel/cpu/mcheck/winchip.c
@@ -2,6 +2,9 @@
  * IDT Winchip specific Machine Check Exception Reporting
  * (C) Copyright 2002 Alan Cox <alan@lxorguk.ukuu.org.uk>
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
@@ -15,7 +18,7 @@
 /* Machine check handler for WinChip C6: */
 static void winchip_machine_check(struct pt_regs *regs, long error_code)
 {
-	printk(KERN_EMERG "CPU0: Machine Check Exception.\n");
+	pr_emerg("CPU0: Machine Check Exception.\n");
 	add_taint(TAINT_MACHINE_CHECK);
 }
 
@@ -35,6 +38,5 @@ void winchip_mcheck_init(struct cpuinfo_x86 *c)
 
 	set_in_cr4(X86_CR4_MCE);
 
-	printk(KERN_INFO
-	       "Winchip machine check reporting enabled on CPU#0.\n");
+	pr_info("Winchip machine check reporting enabled on CPU#0.\n");
 }
-- 
1.6.3.1.10.g659a0.dirty

