Return-Path: <linux-kernel-owner+w=401wt.eu-S1761294AbZEZX7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761294AbZEZX7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756125AbZEZXy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:54:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38610 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117AbZEZXys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:48 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 17/31] x86: MCE: Switch x86 machine check handler to Monarch election. v2
Date: Wed, 27 May 2009 01:54:19 +0200
Message-Id: <b55d8c3d2842ee10f4b06f17cc2658f81b4f7b4e.1243381848.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <abfc8311c5aff38314860d82db449c6c62e9e34d.1243381848.git.ak@linux.intel.com>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
 <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
 <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
 <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com>
 <1623cd9a1c77d35fc2044d72c4bfa1246e67a1c0.1243381848.git.ak@linux.intel.com>
 <723b3fe4e35063b123cee9658c24267287eeac07.1243381848.git.ak@linux.intel.com>
 <0301db6d6dabb8bcfaffe76a907a5036646c207d.1243381848.git.ak@linux.intel.com>
 <abf61c300dec40b8e93bb5ae7154a0633c682799.1243381848.git.ak@linux.intel.com>
 <23417423c34ad949f53ebc947af8d18672a79a40.1243381848.git.ak@linux.intel.com>
 <347567c2ace55b336b1a43a67323ff8b86b80243.1243381848.git.ak@linux.intel.com>
 <3e29698799ad2c02429613323897a6e61a0a7d01.1243381848.git.ak@linux.intel.com>
 <34082fc262bae2f910f1a940622173445aea72cd.1243381848.git.ak@linux.intel.com>
 <c3a768c37edad55939c6f9391001fb95e658ffe6.1243381848.git.ak@linux.intel.com>
 <37501061dc5d5581fefcaff92c2606e39cc61913.1243381848.git.ak@linux.intel.com>
 <10e478c24139e29e7e74529edd694858ec2fb7ea.1243381848.git.ak@linux.intel.com>
 <a541b2bc620d04dd777acd27a37f564ec757fe8b.1243381848.git.ak@linux.intel.com>
 <abfc8311c5aff38314860d82db449c6c62e9e34d.1243381848.git.ak@linux.intel.com>
In-Reply-To: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
References: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

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
Fixed a "ecception" in a comment (H.Seto)
Moved global_nwo reset later based on suggestion from H.Seto
v2: Avoid duplicate messages

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Documentation/x86/x86_64/boot-options.txt |    6 +-
 Documentation/x86/x86_64/machinecheck     |    4 +
 arch/x86/kernel/cpu/mcheck/mce.c          |  360 ++++++++++++++++++++++++++---
 3 files changed, 340 insertions(+), 30 deletions(-)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index 34c1304..e97ebe4 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -13,13 +13,17 @@ Machine check
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
 
diff --git a/Documentation/x86/x86_64/machinecheck b/Documentation/x86/x86_64/machinecheck
index a05e58e..bec2af3 100644
--- a/Documentation/x86/x86_64/machinecheck
+++ b/Documentation/x86/x86_64/machinecheck
@@ -67,6 +67,10 @@ trigger
 	Program to run when a machine check event is detected.
 	This is an alternative to running mcelog regularly from cron
 	and allows to detect events faster.
+monarch_timeout
+	How long to wait for the other CPUs to machine check too on a
+	exception. 0 to disable waiting for other CPUs.
+	Unit: us
 
 TBD document entries for AMD threshold interrupt configuration
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 65c62d1..d87f46f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -20,6 +20,7 @@
 #include <linux/percpu.h>
 #include <linux/string.h>
 #include <linux/sysdev.h>
+#include <linux/delay.h>
 #include <linux/ctype.h>
 #include <linux/sched.h>
 #include <linux/sysfs.h>
@@ -27,6 +28,7 @@
 #include <linux/init.h>
 #include <linux/kmod.h>
 #include <linux/poll.h>
+#include <linux/nmi.h>
 #include <linux/cpu.h>
 #include <linux/fs.h>
 
@@ -60,6 +62,8 @@ int				mce_disabled;
 
 #define MISC_MCELOG_MINOR	227
 
+#define SPINUNIT 100	/* 100ns */
+
 atomic_t mce_entry;
 
 DEFINE_PER_CPU(unsigned, mce_exception_count);
@@ -77,6 +81,7 @@ static u64			*bank;
 static unsigned long		notify_user;
 static int			rip_msr;
 static int			mce_bootlog = -1;
+static int			monarch_timeout = -1;
 
 static char			trigger[128];
 static char			*trigger_argv[2] = { trigger, NULL };
@@ -84,6 +89,9 @@ static char			*trigger_argv[2] = { trigger, NULL };
 static unsigned long		dont_init_banks;
 
 static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
+static DEFINE_PER_CPU(struct mce, mces_seen);
+static int			cpu_missing;
+
 
 /* MCA banks polled by the period polling timer for corrected events */
 DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
@@ -227,6 +235,8 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 	}
 	if (final)
 		print_mce(final);
+	if (cpu_missing)
+		printk(KERN_EMERG "Some CPUs didn't answer in synchronization\n");
 	if (exp)
 		printk(KERN_EMERG "Machine check: %s\n", exp);
 	panic(msg);
@@ -432,18 +442,287 @@ static int mce_no_way_out(struct mce *m, char **msg)
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
+	char *nmsg = NULL;
+
+	/*
+	 * This CPU is the Monarch and the other CPUs have run
+	 * through their handlers.
+	 * Grade the severity of the errors of all the CPUs.
+	 */
+	for_each_possible_cpu (cpu) {
+		int severity = mce_severity(&per_cpu(mces_seen, cpu), tolerant,
+					    &nmsg);
+		if (severity > global_worst) {
+			msg = nmsg;
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
+static atomic_t global_nwo;
+
+/*
+ * Start of Monarch synchronization. This waits until all CPUs have
+ * entered the exception handler and then determines if any of them
+ * saw a fatal event that requires panic. Then it executes them
+ * in the entry order.
+ * TBD double check parallel CPU hotunplug
+ */
+static int mce_start(int no_way_out, int *order)
+{
+	int nwo;
+	int cpus = num_online_cpus();
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
+	atomic_set(&global_nwo, 0);
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
 void do_machine_check(struct pt_regs *regs, long error_code)
 {
-	struct mce m, panicm;
-	int panicm_found = 0;
+	struct mce m, *final;
 	int i;
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
@@ -467,13 +746,23 @@ void do_machine_check(struct pt_regs *regs, long error_code)
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
@@ -525,32 +814,32 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		mce_get_rip(&m, regs);
 		mce_log(&m);
 
-		/*
-		 * Did this bank cause the exception?
-		 *
-		 * Assume that the bank with uncorrectable errors did it,
-		 * and that there is only a single one:
-		 */
-		if ((m.status & MCI_STATUS_UC) &&
-					(m.status & MCI_STATUS_EN)) {
-			panicm = m;
-			panicm_found = 1;
+		severity = mce_severity(&m, tolerant, NULL);
+		if (severity > worst) {
+			*final = m;
+			worst = severity;
 		}
 	}
 
+	if (!no_way_out)
+		mce_clear_state(toclear);
+
 	/*
-	 * If we didn't find an uncorrectable error, pick
-	 * the last one (shouldn't happen, just being safe).
+	 * Do most of the synchronization with other CPUs.
+	 * When there's any problem use only local no_way_out state.
 	 */
-	if (!panicm_found)
-		panicm = m;
+	if (mce_end(order) < 0)
+		no_way_out = worst >= MCE_PANIC_SEVERITY;
 
 	/*
 	 * If we have decided that we just CAN'T continue, and the user
 	 * has not set tolerant to an insane level, give up and die.
+	 *
+	 * This is mainly used in the case when the system doesn't
+	 * support MCE broadcasting or it has been disabled.
 	 */
 	if (no_way_out && tolerant < 3)
-		mce_panic("Machine check", &panicm, msg);
+		mce_panic("Machine check", final, msg);
 
 	/*
 	 * If the error seems to be unrecoverable, something should be
@@ -566,7 +855,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		 * instruction which caused the MCE.
 		 */
 		if (m.mcgstatus & MCG_STATUS_EIPV)
-			user_space = panicm.ip && (panicm.cs & 3);
+			user_space = final->ip && (final->cs & 3);
 
 		/*
 		 * If we know that the error was in user space, send a
@@ -578,20 +867,15 @@ void do_machine_check(struct pt_regs *regs, long error_code)
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
@@ -804,7 +1088,17 @@ static void mce_cpu_quirks(struct cpuinfo_x86 *c)
 
 		if (c->x86 == 6 && c->x86_model < 0x1A)
 			__set_bit(0, &dont_init_banks);
+
+		/*
+		 * All newer Intel systems support MCE broadcasting. Enable
+		 * synchronization with a one second timeout.
+		 */
+		if ((c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xe)) &&
+			monarch_timeout < 0)
+			monarch_timeout = USEC_PER_SEC;
 	}
+	if (monarch_timeout < 0)
+		monarch_timeout = 0;
 }
 
 static void __cpuinit mce_ancient_init(struct cpuinfo_x86 *c)
@@ -1050,7 +1344,9 @@ static struct miscdevice mce_log_device = {
 
 /*
  * mce=off disables machine check
- * mce=TOLERANCELEVEL (number, see above)
+ * mce=TOLERANCELEVEL[,monarchtimeout] (number, see above)
+ *	monarchtimeout is how long to wait for other CPUs on machine
+ *      check, or 0 to not wait
  * mce=bootlog Log MCEs from before booting. Disabled by default on AMD.
  * mce=nobootlog Don't log MCEs from before booting.
  */
@@ -1064,9 +1360,13 @@ static int __init mcheck_enable(char *str)
 		mce_disabled = 1;
 	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
 		mce_bootlog = (str[0] == 'b');
-	else if (isdigit(str[0]))
+	else if (isdigit(str[0])) {
 		get_option(&str, &tolerant);
-	else {
+		if (*str == ',') {
+			++str;
+			get_option(&str, &monarch_timeout);
+		}
+	} else {
 		printk(KERN_INFO "mce argument %s ignored. Please use /sys\n",
 		       str);
 		return 0;
@@ -1204,6 +1504,7 @@ static ssize_t store_int_with_restart(struct sys_device *s,
 
 static SYSDEV_ATTR(trigger, 0644, show_trigger, set_trigger);
 static SYSDEV_INT_ATTR(tolerant, 0644, tolerant);
+static SYSDEV_INT_ATTR(monarch_timeout, 0644, monarch_timeout);
 
 static struct sysdev_ext_attribute attr_check_interval = {
 	_SYSDEV_ATTR(check_interval, 0644, sysdev_show_int,
@@ -1213,6 +1514,7 @@ static struct sysdev_ext_attribute attr_check_interval = {
 
 static struct sysdev_attribute *mce_attr[] = {
 	&attr_tolerant.attr, &attr_check_interval.attr, &attr_trigger,
+	&attr_monarch_timeout.attr,
 	NULL
 };
 
-- 
1.6.0.2

