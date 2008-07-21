Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbYGUPLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbYGUPLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbYGUPL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:11:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46928 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849AbYGUPL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:11:27 -0400
Date: Mon, 21 Jul 2008 17:11:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] softlockup detector updates for v2.6.27
Message-ID: <20080721151113.GA13457@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core/softlockup-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/softlockup-for-linus

Thanks,

	Ingo

------------------>
Arjan van de Ven (1):
      softlockup: print a module list on being stuck

Dimitri Sivanich (1):
      softlockup: fix softlockup_thresh unaligned access and disable detection at runtime

Hiroshi Shimamoto (1):
      softlockup: fix invalid proc_handler for softlockup_panic

Ingo Molnar (3):
      softlockup: allow panic on lockup
      softlockup: fix softlockup_thresh fix
      softlockup: fix false positives on nohz if CPU is 100% idle for more than 60 seconds

Jason Wessel (1):
      softlockup: fix NMI hangs due to lock race - 2.6.26-rc regression

Johannes Weiner (2):
      softlockup: fix watchdog task wakeup frequency
      softlockup: fix watchdog task wakeup frequency

Vegard Nossum (1):
      softlockup: show irqtrace


 Documentation/kernel-parameters.txt |    3 ++
 include/linux/sched.h               |    3 +-
 kernel/softlockup.c                 |   45 +++++++++++++++++++++++++++++-----
 kernel/sysctl.c                     |   20 ++++++++++++---
 kernel/time/tick-sched.c            |    4 +-
 lib/Kconfig.debug                   |   26 +++++++++++++++++++-
 6 files changed, 86 insertions(+), 15 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 312fe77..b8451f7 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2017,6 +2017,9 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	snd-ymfpci=	[HW,ALSA]
 
+	softlockup_panic=
+			[KNL] Should the soft-lockup detector generate panics.
+
 	sonypi.*=	[HW] Sony Programmable I/O Control Device driver
 			See Documentation/sonypi.txt
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2134917..7b2a356 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -295,10 +295,11 @@ extern void softlockup_tick(void);
 extern void spawn_softlockup_task(void);
 extern void touch_softlockup_watchdog(void);
 extern void touch_all_softlockup_watchdogs(void);
-extern unsigned long  softlockup_thresh;
+extern unsigned int  softlockup_panic;
 extern unsigned long sysctl_hung_task_check_count;
 extern unsigned long sysctl_hung_task_timeout_secs;
 extern unsigned long sysctl_hung_task_warnings;
+extern int softlockup_thresh;
 #else
 static inline void softlockup_tick(void)
 {
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index a272d78..7bd8d1a 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -13,6 +13,7 @@
 #include <linux/delay.h>
 #include <linux/freezer.h>
 #include <linux/kthread.h>
+#include <linux/lockdep.h>
 #include <linux/notifier.h>
 #include <linux/module.h>
 
@@ -25,7 +26,22 @@ static DEFINE_PER_CPU(unsigned long, print_timestamp);
 static DEFINE_PER_CPU(struct task_struct *, watchdog_task);
 
 static int __read_mostly did_panic;
-unsigned long __read_mostly softlockup_thresh = 60;
+int __read_mostly softlockup_thresh = 60;
+
+/*
+ * Should we panic (and reboot, if panic_timeout= is set) when a
+ * soft-lockup occurs:
+ */
+unsigned int __read_mostly softlockup_panic =
+				CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE;
+
+static int __init softlockup_panic_setup(char *str)
+{
+	softlockup_panic = simple_strtoul(str, NULL, 0);
+
+	return 1;
+}
+__setup("softlockup_panic=", softlockup_panic_setup);
 
 static int
 softlock_panic(struct notifier_block *this, unsigned long event, void *ptr)
@@ -84,6 +100,14 @@ void softlockup_tick(void)
 	struct pt_regs *regs = get_irq_regs();
 	unsigned long now;
 
+	/* Is detection switched off? */
+	if (!per_cpu(watchdog_task, this_cpu) || softlockup_thresh <= 0) {
+		/* Be sure we don't false trigger if switched back on */
+		if (touch_timestamp)
+			per_cpu(touch_timestamp, this_cpu) = 0;
+		return;
+	}
+
 	if (touch_timestamp == 0) {
 		__touch_softlockup_watchdog();
 		return;
@@ -92,11 +116,8 @@ void softlockup_tick(void)
 	print_timestamp = per_cpu(print_timestamp, this_cpu);
 
 	/* report at most once a second */
-	if ((print_timestamp >= touch_timestamp &&
-			print_timestamp < (touch_timestamp + 1)) ||
-			did_panic || !per_cpu(watchdog_task, this_cpu)) {
+	if (print_timestamp == touch_timestamp || did_panic)
 		return;
-	}
 
 	/* do not print during early bootup: */
 	if (unlikely(system_state != SYSTEM_RUNNING)) {
@@ -106,8 +127,11 @@ void softlockup_tick(void)
 
 	now = get_timestamp(this_cpu);
 
-	/* Wake up the high-prio watchdog task every second: */
-	if (now > (touch_timestamp + 1))
+	/*
+	 * Wake up the high-prio watchdog task twice per
+	 * threshold timespan.
+	 */
+	if (now > touch_timestamp + softlockup_thresh/2)
 		wake_up_process(per_cpu(watchdog_task, this_cpu));
 
 	/* Warn about unreasonable delays: */
@@ -121,11 +145,15 @@ void softlockup_tick(void)
 			this_cpu, now - touch_timestamp,
 			current->comm, task_pid_nr(current));
 	print_modules();
+	print_irqtrace_events(current);
 	if (regs)
 		show_regs(regs);
 	else
 		dump_stack();
 	spin_unlock(&print_lock);
+
+	if (softlockup_panic)
+		panic("softlockup: hung tasks");
 }
 
 /*
@@ -178,6 +206,9 @@ static void check_hung_task(struct task_struct *t, unsigned long now)
 
 	t->last_switch_timestamp = now;
 	touch_nmi_watchdog();
+
+	if (softlockup_panic)
+		panic("softlockup: blocked tasks");
 }
 
 /*
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0d562d6..ab59ac0 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -85,12 +85,13 @@ extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
 
 /* Constants used for minimum and  maximum */
-#if defined(CONFIG_DETECT_SOFTLOCKUP) || defined(CONFIG_HIGHMEM)
+#if defined(CONFIG_HIGHMEM) || defined(CONFIG_DETECT_SOFTLOCKUP)
 static int one = 1;
 #endif
 
 #ifdef CONFIG_DETECT_SOFTLOCKUP
 static int sixty = 60;
+static int neg_one = -1;
 #endif
 
 #ifdef CONFIG_MMU
@@ -736,13 +737,24 @@ static struct ctl_table kern_table[] = {
 #ifdef CONFIG_DETECT_SOFTLOCKUP
 	{
 		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "softlockup_panic",
+		.data		= &softlockup_panic,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "softlockup_thresh",
 		.data		= &softlockup_thresh,
-		.maxlen		= sizeof(unsigned long),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
+		.proc_handler	= &proc_dointvec_minmax,
 		.strategy	= &sysctl_intvec,
-		.extra1		= &one,
+		.extra1		= &neg_one,
 		.extra2		= &sixty,
 	},
 	{
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index beef7cc..942fc7c 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -140,8 +140,6 @@ void tick_nohz_update_jiffies(void)
 	if (!ts->tick_stopped)
 		return;
 
-	touch_softlockup_watchdog();
-
 	cpu_clear(cpu, nohz_cpu_mask);
 	now = ktime_get();
 	ts->idle_waketime = now;
@@ -149,6 +147,8 @@ void tick_nohz_update_jiffies(void)
 	local_irq_save(flags);
 	tick_do_update_jiffies64(now);
 	local_irq_restore(flags);
+
+	touch_softlockup_watchdog();
 }
 
 void tick_nohz_stop_idle(int cpu)
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c459e85..011e00b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -147,7 +147,7 @@ config DETECT_SOFTLOCKUP
 	help
 	  Say Y here to enable the kernel to detect "soft lockups",
 	  which are bugs that cause the kernel to loop in kernel
-	  mode for more than 10 seconds, without giving other tasks a
+	  mode for more than 60 seconds, without giving other tasks a
 	  chance to run.
 
 	  When a soft-lockup is detected, the kernel will print the
@@ -159,6 +159,30 @@ config DETECT_SOFTLOCKUP
 	   can be detected via the NMI-watchdog, on platforms that
 	   support it.)
 
+config BOOTPARAM_SOFTLOCKUP_PANIC
+	bool "Panic (Reboot) On Soft Lockups"
+	depends on DETECT_SOFTLOCKUP
+	help
+	  Say Y here to enable the kernel to panic on "soft lockups",
+	  which are bugs that cause the kernel to loop in kernel
+	  mode for more than 60 seconds, without giving other tasks a
+	  chance to run.
+
+	  The panic can be used in combination with panic_timeout,
+	  to cause the system to reboot automatically after a
+	  lockup has been detected. This feature is useful for
+	  high-availability systems that have uptime guarantees and
+	  where a lockup must be resolved ASAP.
+
+	  Say N if unsure.
+
+config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
+	int
+	depends on DETECT_SOFTLOCKUP
+	range 0 1
+	default 0 if !BOOTPARAM_SOFTLOCKUP_PANIC
+	default 1 if BOOTPARAM_SOFTLOCKUP_PANIC
+
 config SCHED_DEBUG
 	bool "Collect scheduler debugging info"
 	depends on DEBUG_KERNEL && PROC_FS
