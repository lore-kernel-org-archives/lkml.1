Return-Path: <linux-kernel-owner+w=401wt.eu-S1760460AbZDGPQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760460AbZDGPQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758767AbZDGPIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:08:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48877 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758623AbZDGPII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:08:08 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [20/28] x86: MCE: Switch x86 machine check handler to Monarch election.
Message-Id: <20090407150803.1AF0C1D046E@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:08:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: feature, fixes long standing problems.

On Intel platforms machine check exceptions are always broadcast to all CPUs.
This patch makes the machine check handler synchronize all these machine
checks, elect a Monarch to handle the event and collect the worst event from 
all CPUs and then process it first.

This has some advantages:
- When there is a truly data corrupting error the system panics as 
quickly as possible. This improves containment of corrupted
data and makes sure the corrupted data never hits stable storage.
- The panics are synchronized and do not reenter the panic code
on multiple CPUs (which currently does not handle this well).
- All the errors are reported. Currently it often happens that
another CPU happens to do the panic first, but reports useless
information (empty machine check) because the real error
happened on another CPU which came in later.
This is a big advantage on Nehalem where the 8 threads per CPU
lead to often the wrong CPU winning the race and dumping
useless information on a machine check.  The problem also occurs
in a less severe form on older CPUs.
- The system can detect when no CPUs detected a machine check
and shut down the system. This can happen when one CPU is so
badly hung that that it cannot process a machine check anymore
or when some external agent wants to stop the system by
asserting the machine check pin. This follows Intel hardware
recommendations.
- This matches the recommended error model by the CPU designers.
- The events can be output in true severity order
- When a panic happens on another CPU it makes sure to be actually
be able to process the stop IPI by enabling interrupts.

The code is extremly careful to handle timeouts while waiting
for other CPUs. It can't rely on the normal timing mechanisms
(jiffies, ktime_get) because of its asynchronous/lockless nature,
so it uses own timeouts using ndelay() and a "SPINUNIT"

The timeout is configurable. By default it waits for upto one 
second for the other CPUs.  This can be also disabled.

>From some informal testing AMD systems do not see to broadcast 
machine checks, so right now it's always disabled by default on
non Intel CPUs or also on very old Intel systems.

Includes fixes from Ying Huang

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 Documentation/x86/x86_64/boot-options.txt |    6 
 Documentation/x86/x86_64/machinecheck     |    4 
 arch/x86/kernel/cpu/mcheck/mce_64.c       |  358 +++++++++++++++++++++++++++---
 3 files changed, 340 insertions(+), 28 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:10.000000000 +0200
@@ -29,6 +29,8 @@
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
 #include <linux/ratelimit.h>
+#include <linux/nmi.h>
+#include <linux/delay.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
 #include <asm/mce.h>
@@ -42,6 +44,8 @@
 
 #define MISC_MCELOG_MINOR 227
 
+#define SPINUNIT 100	/* 100ns */
+
 atomic_t mce_entry;
 
 static int mce_dont_init;
@@ -59,11 +63,14 @@
 static unsigned long notify_user;
 static int rip_msr;
 static int mce_bootlog = -1;
+static int monarch_timeout = -1;
 
 static char trigger[128];
 static char *trigger_argv[2] = { trigger, NULL };
 
 static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
+static DEFINE_PER_CPU(struct mce, mces_seen);
+static int cpu_missing;
 
 /* MCA banks polled by the period polling timer for corrected events */
 DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
@@ -196,6 +203,8 @@
 	}
 	if (final)
 		print_mce(final);
+	if (cpu_missing)
+		printk(KERN_EMERG "Some CPUs didn't answer in synchronization\n");
 	if (exp)
 		printk(KERN_EMERG "Machine check: %s\n", exp);
 	panic(msg);
@@ -365,18 +374,284 @@
 }
 
 /*
+ * Variable to establish order between CPUs while scanning.
+ * Each CPU spins initially until executing is equal its number.
+ */
+static atomic_t mce_executing;
+
+/*
+ * Defines order of CPUs on entry. First CPU becomes Monarch.
+ */
+static atomic_t mce_callin;
+
+/*
+ * Check if a timeout waiting for other CPUs happened.
+ */
+static int mce_timed_out(u64 *t)
+{
+	/*
+	 * The others already did panic for some reason.
+	 * Bail out like in a timeout.
+	 * rmb() to tell the compiler that system_state
+	 * might have been modified by someone else.
+	 */
+	rmb();
+	if (atomic_read(&mce_paniced))
+		wait_for_panic();
+	if (!monarch_timeout)
+		goto out;
+	if ((s64)*t < SPINUNIT) {
+		/* CHECKME: Make panic default for 1 too? */
+		if (tolerant < 1)
+			mce_panic("Timeout synchronizing machine check over CPUs",
+				  NULL, NULL);
+		cpu_missing = 1;
+		return 1;
+	}
+	*t -= SPINUNIT;
+out:
+	touch_nmi_watchdog();
+	return 0;
+}
+
+/*
+ * The Monarch's reign.  The Monarch is the CPU who entered
+ * the machine check handler first. It waits for the others to
+ * raise the exception too and then grades them. When any
+ * error is fatal panic. Only then let the others continue.
+ *
+ * The other CPUs entering the MCE handler will be controlled by the
+ * Monarch. They are called Subjects.
+ *
+ * This way we prevent any potential data corruption in a unrecoverable case
+ * and also makes sure always all CPU's errors are examined.
+ *
+ * Also this detects the case of an machine check event coming from outer
+ * space (not detected by any CPUs) In this case some external agent wants
+ * us to shut down, so panic too.
+ *
+ * The other CPUs might still decide to panic if the handler happens
+ * in a unrecoverable place, but in this case the system is in a semi-stable
+ * state and won't corrupt anything by itself. It's ok to let the others
+ * continue for a bit first.
+ *
+ * All the spin loops have timeouts; when a timeout happens a CPU
+ * typically elects itself to be Monarch.
+ */
+static void mce_reign(void)
+{
+	int cpu;
+	struct mce *m = NULL;
+	int global_worst = 0;
+	char *msg = NULL;
+
+	/*
+	 * This CPU is the Monarch and the other CPUs have run
+	 * through their handlers.
+	 * Grade the severity of the errors of all the CPUs.
+	 */
+	for_each_possible_cpu (cpu) {
+		int severity = mce_severity(&per_cpu(mces_seen, cpu), tolerant,
+					    &msg);
+		if (severity > global_worst) {
+			global_worst = severity;
+			m = &per_cpu(mces_seen, cpu);
+		}
+	}
+
+	/*
+	 * Cannot recover? Panic here then.
+	 * This dumps all the mces in the log buffer and stops the
+	 * other CPUs.
+	 */
+	if (m && global_worst >= MCE_PANIC_SEVERITY && tolerant < 3)
+		mce_panic("Fatal machine check", m, msg);
+
+	/*
+	 * For UC somewhere we let the CPU who detects it handle it.
+	 * Also must let continue the others, otherwise the handling
+	 * CPU could deadlock on a lock.
+	 */
+
+	/*
+	 * No machine check event found. Must be some external
+	 * source or one CPU is hung. Panic.
+	 */
+	if (!m && tolerant < 3)
+		mce_panic("Machine check from unknown source", NULL, NULL);
+
+	/*
+	 * Now clear all the mces_seen so that they don't reappear on
+	 * the next mce.
+	 */
+	for_each_possible_cpu (cpu)
+		memset(&per_cpu(mces_seen, cpu), 0, sizeof(struct mce));
+}
+
+/*
+ * Start of Monarch synchronization. This waits until all CPUs have
+ * entered the ecception handler and then determines if any of them
+ * saw a fatal event that requires panic. Then it executes them
+ * in the entry order.
+ * TBD double check parallel CPU hotunplug
+ */
+static int mce_start(int no_way_out, int *order)
+{
+	int nwo;
+	int cpus = num_online_cpus();
+	static atomic_t global_nwo;
+	u64 timeout = (u64)monarch_timeout * NSEC_PER_USEC;
+
+	if (!timeout) {
+		*order = -1;
+		return no_way_out;
+	}
+
+	atomic_add(no_way_out, &global_nwo);
+
+	/*
+	 * Wait for everyone.
+	 */
+	while (atomic_read(&mce_callin) != cpus) {
+		if (mce_timed_out(&timeout)) {
+			atomic_set(&global_nwo, 0);
+			*order = -1;
+			return no_way_out;
+		}
+		ndelay(SPINUNIT);
+	}
+
+	/*
+	 * Cache the global no_way_out state.
+	 */
+	nwo = atomic_read(&global_nwo);
+
+	/*
+	 * Monarch starts executing now, the others wait.
+	 */
+	if (*order == 1) {
+		atomic_set(&global_nwo, 0);
+		atomic_set(&mce_executing, 1);
+		return nwo;
+	}
+
+	/*
+	 * Now start the scanning loop one by one
+	 * in the original callin order.
+	 * This way when there are any shared banks it will
+	 * be only seen by one CPU before cleared, avoiding duplicates.
+	 */
+	while (atomic_read(&mce_executing) < *order) {
+		if (mce_timed_out(&timeout)) {
+			atomic_set(&global_nwo, 0);
+			*order = -1;
+			return no_way_out;
+		}
+		ndelay(SPINUNIT);
+	}
+	return nwo;
+}
+
+/*
+ * Synchronize between CPUs after main scanning loop.
+ * This invokes the bulk of the Monarch processing.
+ */
+static int mce_end(int order)
+{
+	int ret = -1;
+	u64 timeout = (u64)monarch_timeout * NSEC_PER_USEC;
+
+	if (!timeout)
+		goto reset;
+	if (order < 0)
+		goto reset;
+
+	/*
+	 * Allow others to run.
+	 */
+	atomic_inc(&mce_executing);
+
+	if (order == 1) {
+		/* CHECKME: Can this race with a parallel hotplug? */
+		int cpus = num_online_cpus();
+
+		/*
+		 * Monarch: Wait for everyone to go through their scanning
+		 * loops.
+		 */
+		while (atomic_read(&mce_executing) <= cpus) {
+			if (mce_timed_out(&timeout))
+				goto reset;
+			ndelay(SPINUNIT);
+		}
+
+		mce_reign();
+		barrier();
+		ret = 0;
+	} else {
+		/*
+		 * Subject: Wait for Monarch to finish.
+		 */
+		while (atomic_read(&mce_executing) != 0) {
+			if (mce_timed_out(&timeout))
+				goto reset;
+			ndelay(SPINUNIT);
+		}
+
+		/*
+		 * Don't reset anything. That's done by the Monarch.
+		 */
+		return 0;
+	}
+
+	/*
+	 * Reset all global state.
+	 */
+reset:
+	atomic_set(&mce_callin, 0);
+	barrier();
+
+	/*
+	 * Let others run again.
+	 */
+	atomic_set(&mce_executing, 0);
+	return ret;
+}
+
+static void mce_clear_state(unsigned long *toclear)
+{
+	int i;
+
+	for (i = 0; i < banks; i++) {
+		if (test_bit(i, toclear))
+			mce_wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
+	}
+}
+
+/*
  * The actual machine check handler. This only handles real
  * exceptions when something got corrupted coming in through int 18.
  *
  * This is executed in NMI context not subject to normal locking rules. This
  * implies that most kernel services cannot be safely used. Don't even
  * think about putting a printk in there!
+ *
+ * On Intel systems this is entered on all CPUs in parallel through
+ * MCE broadcast. However some CPUs might be broken beyond repair,
+ * so be always careful when synchronizing with others.
  */
 void do_machine_check(struct pt_regs * regs, long error_code)
 {
-	struct mce m, panicm;
+	struct mce m, *final;
 	int i;
-	int panicm_found = 0;
+	int worst = 0;
+	int severity;
+	/*
+	 * Establish sequential order between the CPUs entering the machine
+	 * check handler.
+	 */
+	int order;
+
 	/*
 	 * If no_way_out gets set, there is no safe way to recover from this
 	 * MCE.  If tolerant is cranked up, we'll try anyway.
@@ -400,12 +675,22 @@
 	if (!banks)
 		goto out;
 
+	order = atomic_add_return(1, &mce_callin);
 	mce_setup(&m);
 	m.mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
 	no_way_out = mce_no_way_out(&m, &msg);
 
+	final = &__get_cpu_var(mces_seen);
+	*final = m;
+
 	barrier();
 
+	/*
+	 * Go through all the banks in exclusion of the other CPUs.
+	 * This way we don't report duplicated events on shared banks
+	 * because the first one to see it will clear it.
+	 */
+	no_way_out = mce_start(no_way_out, &order);
 	for (i = 0; i < banks; i++) {
 		__clear_bit(i, toclear);
 		if (!bank[i])
@@ -457,26 +742,32 @@
 		mce_get_rip(&m, regs);
 		mce_log(&m);
 
-		/* Did this bank cause the exception? */
-		/* Assume that the bank with uncorrectable errors did it,
-		   and that there is only a single one. */
-		if ((m.status & MCI_STATUS_UC) && (m.status & MCI_STATUS_EN)) {
-			panicm = m;
-			panicm_found = 1;
+		severity = mce_severity(&m, tolerant, NULL);
+		if (severity > worst) {
+			*final = m;
+			worst = severity;
 		}
 	}
 
-	/* If we didn't find an uncorrectable error, pick
-	   the last one (shouldn't happen, just being safe). */
-	if (!panicm_found)
-		panicm = m;
+	if (!no_way_out)
+		mce_clear_state(toclear);
+
+	/*
+	 * Do most of the synchronization with other CPUs.
+	 * When there's any problem use only local no_way_out state.
+	 */
+	if (mce_end(order) < 0)
+		no_way_out = worst >= MCE_PANIC_SEVERITY;
 
 	/*
 	 * If we have decided that we just CAN'T continue, and the user
-	 *  has not set tolerant to an insane level, give up and die.
+	 * has not set tolerant to an insane level, give up and die.
+	 *
+	 * This is mainly used in the case when the system doesn't
+	 * support MCE broadcasting or it has been disabled.
 	 */
 	if (no_way_out && tolerant < 3)
-		mce_panic("Machine check", &panicm, msg);
+		mce_panic("Machine check", final, msg);
 
 	/*
 	 * If the error seems to be unrecoverable, something should be
@@ -492,7 +783,7 @@
 		 * instruction which caused the MCE.
 		 */
 		if (m.mcgstatus & MCG_STATUS_EIPV)
-			user_space = panicm.ip && (panicm.cs & 3);
+			user_space = final->ip && (final->cs & 3);
 
 		/*
 		 * If we know that the error was in user space, send a
@@ -504,20 +795,15 @@
 		if (user_space && tolerant > 0) {
 			force_sig(SIGBUS, current);
 		} else if (panic_on_oops || tolerant < 2) {
-			mce_panic("Uncorrected machine check", &panicm, msg);
+			mce_panic("Uncorrected machine check", final, msg);
 		}
 	}
 
 	/* notify userspace ASAP */
 	set_thread_flag(TIF_MCE_NOTIFY);
 
-	mce_report_event(regs);
-
-	/* the last thing we do is clear state */
-	for (i = 0; i < banks; i++) {
-		if (test_bit(i, toclear))
-			mce_wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
-	}
+	if (worst > 0)
+		mce_report_event(regs);
 	mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
 out:
 	atomic_dec(&mce_entry);
@@ -695,7 +981,17 @@
 			   by default and leave crap in there. Don't log. */
 			mce_bootlog = 0;
 	}
-
+	if (c->x86_vendor == X86_VENDOR_INTEL) {
+		/*
+		 * All newer Intel systems support MCE broadcasting. Enable
+		 * synchronization with a one second timeout.
+		 */
+		if ((c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xe)) &&
+			monarch_timeout < 0)
+			monarch_timeout = USEC_PER_SEC;
+	}
+	if (monarch_timeout < 0)
+		monarch_timeout = 0;
 }
 
 static void mce_cpu_features(struct cpuinfo_x86 *c)
@@ -920,7 +1216,9 @@
 }
 
 /* mce=off disables machine check.
-   mce=TOLERANCELEVEL (number, see above)
+   mce=TOLERANCELEVEL[,monarchtimeout] (number, see above)
+	monarchtimeout is how long to wait for other CPUs on machine check, or 0
+	to not wait
    mce=bootlog Log MCEs from before booting. Disabled by default on AMD.
    mce=nobootlog Don't log MCEs from before booting. */
 static int __init mcheck_enable(char *str)
@@ -929,9 +1227,13 @@
 		mce_dont_init = 1;
 	else if (!strcmp(str, "bootlog") || !strcmp(str,"nobootlog"))
 		mce_bootlog = str[0] == 'b';
-	else if (isdigit(str[0]))
+	else if (isdigit(str[0])) {
 		get_option(&str, &tolerant);
-	else
+		if (*str == ',') {
+			++str;
+			get_option(&str, &monarch_timeout);
+		}
+	} else
 		printk("mce= argument %s ignored. Please use /sys", str);
 	return 1;
 }
@@ -1057,9 +1359,11 @@
 		     store_int_with_restart),
 	&check_interval
 };
+static SYSDEV_INT_ATTR(monarch_timeout, 0644, monarch_timeout);
 
 static struct sysdev_attribute *mce_attributes[] = {
 	&attr_tolerant.attr, &attr_check_interval.attr, &attr_trigger,
+	&attr_monarch_timeout.attr,
 	NULL
 };
 
Index: linux/Documentation/x86/x86_64/boot-options.txt
===================================================================
--- linux.orig/Documentation/x86/x86_64/boot-options.txt	2009-04-07 16:09:52.000000000 +0200
+++ linux/Documentation/x86/x86_64/boot-options.txt	2009-04-07 16:43:10.000000000 +0200
@@ -13,13 +13,17 @@
                in a reboot. On Intel systems it is enabled by default.
    mce=nobootlog
 		Disable boot machine check logging.
-   mce=tolerancelevel (number)
+   mce=tolerancelevel[,monarchtimeout] (number,number)
+		tolerance levels:
 		0: always panic on uncorrected errors, log corrected errors
 		1: panic or SIGBUS on uncorrected errors, log corrected errors
 		2: SIGBUS or log uncorrected errors, log corrected errors
 		3: never panic or SIGBUS, log all errors (for testing only)
 		Default is 1
 		Can be also set using sysfs which is preferable.
+		monarchtimout:
+		Sets the time in us to wait for other CPUs on machine checks. 0
+		to disable.
 
    nomce (for compatibility with i386): same as mce=off
 
Index: linux/Documentation/x86/x86_64/machinecheck
===================================================================
--- linux.orig/Documentation/x86/x86_64/machinecheck	2009-04-07 16:09:52.000000000 +0200
+++ linux/Documentation/x86/x86_64/machinecheck	2009-04-07 16:43:10.000000000 +0200
@@ -67,6 +67,10 @@
 	Program to run when a machine check event is detected.
 	This is an alternative to running mcelog regularly from cron
 	and allows to detect events faster.
+monarch_timeout
+	How long to wait for the other CPUs to machine check too on a
+	exception. 0 to disable waiting for other CPUs.
+	Unit: us
 
 TBD document entries for AMD threshold interrupt configuration
 
