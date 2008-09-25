Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbYIYWCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbYIYWCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 18:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbYIYWCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 18:02:47 -0400
Received: from smtp-out.google.com ([216.239.33.17]:14390 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbYIYWCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 18:02:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=to:subject:cc:message-id:date:from;
	b=P8kfYH8uUb0thQ6Yb/CaakkJUPlttikMVWeVJ5I7B8DUpv5fHlnVfniWNOy7c/02Z
	oBx3YHMIQCZU0Fg2WJHlg==
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: TSC resync
Cc: mbligh@google.com, tglx@linutronix.de
Message-Id: <20080925220212.45B0029683@localhost>
Date: Thu, 25 Sep 2008 15:02:12 -0700 (PDT)
From: md@google.com (Michael Davidson)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a slightly cleaned up version of one which has
been in use at for some time now at Google.

It uses an HPET based time source to resynchronize the TSC on
systems where it would otherwise be unsynchronized - eg early
AMD Opteron based systems where the TSC rate drifts when going
in and out of the C1E halt state.

While the approach is quite crude it has been effective for systems
where user space code relies on the TSC advancing at a constant rate
and being reasonably well synchronized between CPUs. The skew between
TSC's on different processors as seen from user space is typically
less than +/- 1000 clock cycles which has proved to be sufficient for
the applications that we care about.

I don't expect this patch to be of much general interest, but if you
happen to be unlucky enough to have a system where the TSC is not
synchronized across CPUs and user space code which relies on the
assumption that it is, then this patch may be useful.

Signed-off-by: Michael Davidson <md@google.com>

---

Index: linux-2.6.26.5/arch/x86/kernel/tsc_resync.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.26.5/arch/x86/kernel/tsc_resync.c	2008-09-25 12:19:40.826853000 -0700
@@ -0,0 +1,419 @@
+/*
+ *	TSC resynchronization
+ *
+ *	Copyright 2006-2008 Google Inc.
+ *	All Rights Reserved
+ *
+ *	Author: md@google.com
+ */
+#include <linux/init.h>
+#include <linux/smp.h>
+#include <linux/notifier.h>
+
+#include <asm/uaccess.h>
+#include <asm/hpet.h>
+#include <asm/idle.h>
+#include <asm/proto.h>
+
+static int	tsc_resync_enabled = -1;
+static int	tsc_lazy_resync = 0;
+
+/*
+ * TSC is synchronized to a reference clock which is provide by the HPET.
+ * Since the HPET counter is only 32 bits we have to synthesize a 64 bit
+ * value and do periodic updates to deal with 32 bit overflow.
+ */
+static DEFINE_SEQLOCK(ref_clock_lock);
+
+static uint64_t		ref_clock_base;
+static uint32_t		ref_clock_last;
+static uint64_t		ref_clock_frequency;
+static unsigned long	ref_clock_update_interval;
+static uint64_t		ref2cyc_scale;
+
+/*
+ * return a 64 bit HPET based clock value
+ */
+static uint64_t ref_clock(void)
+{
+	unsigned long	seq;
+	uint64_t	base;
+	uint32_t	offset;
+
+	do {
+		seq = read_seqbegin(&ref_clock_lock);
+		base = ref_clock_base;
+		offset = (uint32_t)hpet_readl(HPET_COUNTER) - ref_clock_last;
+	} while (read_seqretry(&ref_clock_lock, seq));
+
+	return base + offset;
+}
+
+static void ref_clock_update(struct work_struct *);
+static DECLARE_DELAYED_WORK(ref_clock_work, ref_clock_update);
+/*
+ * periodic update of the reference clock to deal with 32 bit overflow
+ */
+static void ref_clock_update(struct work_struct *unused)
+{
+	uint32_t	ref_clock_now;
+
+	write_seqlock(&ref_clock_lock);
+
+	ref_clock_now = (uint32_t)hpet_readl(HPET_COUNTER);
+	ref_clock_base += (ref_clock_now - ref_clock_last);
+	ref_clock_last = ref_clock_now;
+
+	write_sequnlock(&ref_clock_lock);
+
+	schedule_delayed_work(&ref_clock_work, ref_clock_update_interval);
+}
+
+#define MAX_RETRIES	5
+#define	SMI_THRESHOLD	50000
+/*
+ * get corresponding TSC and reference clock time stamps
+ * while attempting to make sure that we have not taken
+ * and IRQ, NMI or SMI (based on tsc_read_refs in tsc_64.c)
+ */
+static int ref_clock_tsc_read(uint64_t *tsc, uint64_t *ref)
+{
+	unsigned long	flags;
+	int		i;
+	unsigned	n1, n2;
+	uint64_t	r;
+	uint64_t	t1, t2;
+
+	for (i = 0; i < MAX_RETRIES; i++) {
+
+		local_irq_save(flags);
+		n1 = read_pda(__nmi_count);
+		rmb();
+
+		t1 = get_cycles();
+		r  = ref_clock();
+		t2 = get_cycles();
+
+		rmb();
+		n2 = read_pda(__nmi_count);
+		local_irq_restore(flags);
+
+		if ((t2 - t1) < SMI_THRESHOLD && n1 == n2) {
+			*ref = r;
+			*tsc = t2;
+			return 0;
+		}
+	}
+
+	return -1;
+}
+
+/*
+ * calibrate the reference clock against the TSC
+ *
+ * we use the reference clock frequency to control the length
+ * of the calibration loop which is currently set to 1 second
+ */
+static int __init ref_clock_calibrate(void)
+{
+	uint64_t	ref_start, ref_now;
+	cycles_t	tsc_start, tsc_now;
+	uint64_t	loop_count = ref_clock_frequency;	/* 1 sec */
+
+	if (ref_clock_tsc_read(&tsc_start, &ref_start) != 0)
+		return -1;
+
+	do {
+		ref_now = ref_clock();
+	} while ((ref_now - ref_start) < loop_count);
+
+	if (ref_clock_tsc_read(&tsc_now, &ref_now) != 0)
+		return -1;
+
+	ref2cyc_scale = ((tsc_now - tsc_start) << 32) / (ref_now - ref_start);
+
+	return 0;
+}
+
+/*
+ * convert reference clock to TSC cycles
+ */
+uint64_t ref2cycles(uint64_t ref)
+{
+	uint64_t	cycles;
+
+	asm __volatile__ (
+		"mulq	ref2cyc_scale\n\t"
+		"shrq	$32, %%rax\n\t"
+		"shlq	$32, %%rdx\n\t"
+		"orq	%%rdx, %%rax\n\t"
+		: "=a" (cycles)
+		: "0" (ref)
+		: "dx", "cc"
+	);
+
+	return cycles;
+}
+
+/*
+ * ref_clock_early_init() and ref_clock_init()
+ *
+ * tsc_resync_init() is called from time_init() very early in
+ * system startup so that the TSC resync code is intialized as
+ * early as possible.
+ *
+ * Unfortunately this is long before workqueue initialization takes
+ * place which means that we need to do the initialization of the
+ * reference clock in two stages:
+ *
+ *   ref_clock_early_init() is called from tsc_resync_init() and
+ *   does the basic setup
+ *
+ *   ref_clock_init() is called at normal initcall time and calls
+ *   ref_clock_update() to start the periodic update of the clock
+ */
+
+#define FEMPTOSECONDS_PER_SECOND	1000000000000000ULL	/* 10^15 */
+
+/*
+ * ref_clock_early_init()
+ */
+static int __init ref_clock_early_init(void)
+{
+	uint32_t	hpet_period;
+	uint32_t	hpet_counter;
+
+	if (!is_hpet_enabled())
+		return -1;
+
+	hpet_period = (uint32_t)hpet_readl(HPET_PERIOD);
+	ref_clock_frequency = FEMPTOSECONDS_PER_SECOND / hpet_period;
+
+	hpet_counter = (uint32_t)hpet_readl(HPET_COUNTER);
+	ref_clock_base = hpet_counter;
+	ref_clock_last = hpet_counter;
+
+	/*
+	 * Set the update interval to an eighth of the time needed
+	 * for the  32 bit HPET counter to wrap. For a 25MHz HPET
+	 * this will be approximately 20 seconds.
+	 */
+	ref_clock_update_interval = ((uint64_t)HZ << 32) / ref_clock_frequency;
+	ref_clock_update_interval /= 8;
+
+	return 0;
+}
+
+/*
+ * ref_clock_init()
+ */
+static int __init ref_clock_init(void)
+{
+	if (tsc_resync_enabled <= 0)
+		return 0;
+
+	ref_clock_update(NULL);
+	return 0;
+}
+core_initcall(ref_clock_init);
+
+/*
+ * disable user mode access to RDTSC
+ */
+static inline void rdtsc_disable(void)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	write_cr4(read_cr4() | X86_CR4_TSD);
+	local_irq_restore(flags);
+}
+
+/*
+ * enable user mode access to RDTSC
+ */
+static inline void rdtsc_enable(void)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	write_cr4(read_cr4() & ~X86_CR4_TSD);
+	local_irq_restore(flags);
+}
+
+/*
+ * update the TSC by delta clock cycles
+ *
+ * The update is protected against interrupts and NMIs
+ * but could still be disrupted by an SMI. Unfortunately
+ * the cost of attempting to detect an SMI is high since
+ * it would require an additional HPET read so, for now, we
+ * just live with that possibility while trying to keep
+ * the window of vulnerability as small as possible.
+ */
+static void tsc_resync_update_tsc(int64_t delta)
+{
+	unsigned long flags;
+	unsigned nmi_before, nmi_after;
+
+	do {
+		local_irq_save(flags);
+		nmi_before = read_pda(__nmi_count);
+		rmb();
+
+		asm __volatile__ (
+		 	"xorl %%eax, %%eax\n\t"
+		 	"cpuid\n\t"
+		 	"movl $0x10, %%ecx\n\t"
+		 	"rdmsr\n\t"
+		 	"addl %%edi, %%eax\n\t"
+		 	"adcl %%esi, %%edx\n\t"
+		 	"wrmsr\n"
+		 	: /* no outputs */
+		 	: "D" ((u32)delta), "S" ((u32)(delta >> 32))
+		 	: "ax", "bx", "cx", "dx", "cc"
+	 	);
+
+		rmb();
+		nmi_after = read_pda(__nmi_count);
+		local_irq_restore(flags);
+	} while (nmi_before != nmi_after);
+}
+
+/*
+ * resync the TSC to ref_clock() scaled to CPU cycles
+ *
+ * The actual TSC update is protected against interrsupts
+ * and NMIs but could still be disrupted by an SMI.
+ */
+static inline void tsc_resync(void)
+{
+	uint64_t	ref;
+	uint64_t	tsc;
+
+
+	if (ref_clock_tsc_read(&tsc, &ref) != 0) {
+		return;
+	}
+
+	tsc_resync_update_tsc(ref2cycles(ref) - tsc);
+}
+
+#define	IS_RDTSC(op)	((op & 0xffff) == 0x310f)
+#define IS_RDTSCP(op)	((op & 0xffffff) == 0xf9010f)
+/*
+ * Called from do_general_protection() to handle
+ * faults caused by attempts to execute RDTSC from
+ * user space while it is disabled.
+ */
+int tsc_resync_handle_rdtsc(struct pt_regs *regs)
+{
+	u32	opcode;
+
+	if (tsc_resync_enabled <= 0)
+		return 0;
+
+	if (__get_user(opcode, (u32 __user *)regs->ip))
+		return 0;
+
+	if (!IS_RDTSC(opcode) && !IS_RDTSCP(opcode))
+		return 0;
+
+	preempt_disable();
+	tsc_resync();
+	rdtsc_enable();
+	preempt_enable();
+
+	return 1;
+}
+
+/*
+ * Called from default_idle() immediately before calling safe_halt()
+ *
+ * If we are doing "lazy" TSC resynchronization we disable user space
+ * access to the TSC as soon as we enter idle. The next user space
+ * access to the TSC will trap into tsc_resync_handle_rdtsc() which
+ * will resync the TSC and re-enable user space access to it.
+ *
+ * If we are not doing "lazy" resynchronization then we just resync
+ * the TSC every time we come out of idle.
+ */
+static int tsc_resync_idle_notifier(struct notifier_block *nb, unsigned long event, void *data)
+{
+	if (! tsc_resync_enabled)
+		return NOTIFY_DONE;
+
+	switch (event) {
+		case IDLE_START:
+			if (tsc_lazy_resync)
+				rdtsc_disable();
+			break;
+
+		case IDLE_END:
+			if (!tsc_lazy_resync)
+				tsc_resync();
+			break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block tsc_resync_idle_notifier_block = {
+	.notifier_call = tsc_resync_idle_notifier,
+};
+
+/*
+ * called from time_init()
+ */
+void __init tsc_resync_init(void)
+{
+	/*
+	 * If nothing was explicitly specified on the command line
+	 * enable TSC resynchronization if we think that we have
+	 * an unsynchronized TSC.
+	 */
+	if (tsc_resync_enabled < 0)
+		tsc_resync_enabled = unsynchronized_tsc();
+
+	if (!tsc_resync_enabled) {
+		printk("TSC resynchronization disabled\n");
+		return;
+	}
+
+	if (ref_clock_early_init() != 0) {
+		tsc_resync_enabled = 0;
+		printk("TSC resynchronization not enabled: no HPET\n");
+		return;
+	}
+
+	if (ref_clock_calibrate() != 0) {
+		tsc_resync_enabled = 0;
+		printk("TSC resynchronization not enabled: "
+			"reference clock calibration failed\n");
+		return;
+	}
+
+	idle_notifier_register(&tsc_resync_idle_notifier_block);
+
+	tsc_resync();
+
+	if (tsc_lazy_resync)
+		printk("TSC lazy resynchronization enabled\n");
+	else
+		printk("TSC resynchronization enabled\n");
+}
+
+static int __init tsc_resync_setup(char *str)
+{
+	if (str) {
+		if (!strncmp("enable", str, 6))
+			tsc_resync_enabled = 1;
+		else if (!strncmp("lazy", str, 4))
+			tsc_lazy_resync = tsc_resync_enabled = 1;
+		else if (!strncmp("disable", str, 7))
+			tsc_resync_enabled = 0;
+	}
+	return 1;
+}
+
+__setup("tsc_resync=", tsc_resync_setup);
Index: linux-2.6.26.5/arch/x86/Kconfig
===================================================================
--- linux-2.6.26.5.orig/arch/x86/Kconfig	2008-09-08 10:40:20.000000000 -0700
+++ linux-2.6.26.5/arch/x86/Kconfig	2008-09-25 12:48:44.244530000 -0700
@@ -492,6 +492,25 @@
 	def_bool y
 	depends on HPET_TIMER && (RTC=y || RTC=m || RTC_DRV_CMOS=m || RTC_DRV_CMOS=y)
 
+config TSC_RESYNC
+	bool "Attempt to keep TSC synchronized across CPUs"
+	depends on X86_64 && SMP && HPET_TIMER && !PARAVIRT
+	default y
+	help
+	  Attempts to keep TSC synchronized across CPUs on systems
+	  which would otherwise lose TSC synchronization when a CPU
+	  goes idle and enters the C1E halt state. By default TSC
+	  resync is only enabled for systems on which the TSC appears
+	  to be unsynchronized. The default behaviour is to attempt to
+	  resynchronize the TSC to a reference clock derived from the
+	  HPET every time the CPU comes out of idle. The tsc_resync
+	  command line option can be used to change this behavior.
+	  tsc_resync=disable will force TSC resync to be disabled.
+	  tsc_resync=enable will force TSC resync to be enabled.
+	  tsc_resync=lazy will force TSC resync to be enabled but will
+	  only attempt to resync the TSC on the first user space
+	  access to it.
+
 # Mark as embedded because too many people got it wrong.
 # The code disables itself when not needed.
 config DMI
Index: linux-2.6.26.5/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.26.5.orig/arch/x86/kernel/Makefile	2008-09-08 10:40:20.000000000 -0700
+++ linux-2.6.26.5/arch/x86/kernel/Makefile	2008-09-25 12:37:01.428772000 -0700
@@ -72,6 +72,7 @@
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
+obj-$(CONFIG_TSC_RESYNC) 	+= tsc_resync.o
 
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_MGEODE_LX)		+= geode_32.o mfgpt_32.o
Index: linux-2.6.26.5/arch/x86/kernel/time_64.c
===================================================================
--- linux-2.6.26.5.orig/arch/x86/kernel/time_64.c	2008-09-08 10:40:20.000000000 -0700
+++ linux-2.6.26.5/arch/x86/kernel/time_64.c	2008-09-25 12:51:55.348240000 -0700
@@ -23,6 +23,7 @@
 #include <asm/vgtod.h>
 #include <asm/time.h>
 #include <asm/timer.h>
+#include <asm/proto.h>
 
 volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
 
@@ -116,6 +117,9 @@
 
 void __init time_init(void)
 {
+#ifndef CONFIG_PARAVIRT
+	hpet_time_init();
+#endif
 	tsc_calibrate();
 
 	cpu_khz = tsc_khz;
@@ -134,5 +138,8 @@
 	printk(KERN_INFO "time.c: Detected %d.%03d MHz processor.\n",
 		cpu_khz / 1000, cpu_khz % 1000);
 	init_tsc_clocksource();
+#ifdef CONFIG_PARAVIRT
 	late_time_init = choose_time_init();
+#endif
+	tsc_resync_init();
 }
Index: linux-2.6.26.5/arch/x86/kernel/traps_64.c
===================================================================
--- linux-2.6.26.5.orig/arch/x86/kernel/traps_64.c	2008-09-08 10:40:20.000000000 -0700
+++ linux-2.6.26.5/arch/x86/kernel/traps_64.c	2008-09-25 12:45:22.522496000 -0700
@@ -748,6 +748,9 @@
 		tsk->thread.error_code = error_code;
 		tsk->thread.trap_no = 13;
 
+		if (tsc_resync_handle_rdtsc(regs))
+			return;
+
 		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
 		    printk_ratelimit()) {
 			printk(KERN_INFO
Index: linux-2.6.26.5/include/asm-x86/proto.h
===================================================================
--- linux-2.6.26.5.orig/include/asm-x86/proto.h	2008-09-08 10:40:20.000000000 -0700
+++ linux-2.6.26.5/include/asm-x86/proto.h	2008-09-25 12:43:10.424406000 -0700
@@ -31,4 +31,12 @@
 #define round_up(x, y) (((x) + (y) - 1) & ~((y) - 1))
 #define round_down(x, y) ((x) & ~((y) - 1))
 
+#ifdef CONFIG_TSC_RESYNC
+extern void tsc_resync_init(void);
+extern int tsc_resync_handle_rdtsc(struct pt_regs *regs);
+#else
+#define tsc_resync_init()
+#define tsc_resync_handle_rdtsc(regs)	(0)
+#endif
+
 #endif
