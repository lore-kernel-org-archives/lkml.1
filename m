Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbYL2O1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbYL2O1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 09:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbYL2O1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 09:27:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48708 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510AbYL2O1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 09:27:11 -0500
Date: Mon, 29 Dec 2008 15:26:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] timer updates for v2.6.29, #2
Message-ID: <20081229142653.GA6730@elte.hu>
References: <20081225171410.GA3871@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081225171410.GA3871@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> Linus,
> 
> Please pull the latest timers-core-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-core-for-linus
> 
> 7 timer topics were active in this cycle:
> 
>    timers/clocksource       timers/hpet        timers/hrtimers 
>    timers/nohz              timers/ntp         timers/posixtimers 
>    timers/rtc
> 
> The most significant change is the hrtimer cleanups/simplifications done 
> by Peter Zijlstra.

Linus, the timer tree grew a trivial contextual and a non-trivial semantic 
conflict with your latest tree yesterday (due to the sound tree changing 
its hrtimers usage), so i've created a second branch with the conflict 
resolution included too:

Please pull the latest timers-core-for-linus-2 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-core-for-linus-2

[ can be pulled in any order with timers-core-for-linus. Shortlog is 
  relative to -git. ]

 Thanks,

	Ingo

------------------>
Bjorn Helgaas (1):
      clocksource, acpi_pm.c: put acpi_pm_read_slow() under CONFIG_PCI

David Brownell (1):
      rtc-cmos: export second NVRAM bank

Denis V. Lunev (1):
      x86: correct link to HPET timer specification

Frederic Weisbecker (1):
      hrtimers: increase clock min delta threshold while interrupt hanging

Heiko Carstens (1):
      nohz: no softirq pending warnings for offline cpus

Ingo Molnar (1):
      hrtimers: fix warning in kernel/hrtimer.c

Janne Kulmala (1):
      x86: enable HPET on Fujitsu u9200

Jeremy Fitzhardinge (1):
      x86: make sure we really have an hpet mapping before using it

Mike Frysinger (1):
      linux/timex.h: cleanup for userspace

Oleg Nesterov (3):
      posix-timers: use "struct pid*" instead of "struct task_struct*"
      posix-timers: check ->it_signal instead of ->it_pid to validate the timer
      posix-timers: simplify de_thread()->exit_itimers() path

Peter Zijlstra (3):
      hrtimer: removing all ur callback modes
      hrtimer: removing all ur callback modes, fix hotplug
      hrtimer: removing all ur callback modes, fix

Woodruff, Richard (1):
      nohz: suppress needless timer reprogramming


 arch/x86/Kconfig                    |    2 +-
 arch/x86/kernel/hpet.c              |    7 +-
 arch/x86/kernel/quirks.c            |    2 +
 drivers/char/hpet.c                 |    2 +-
 drivers/clocksource/acpi_pm.c       |   10 +-
 drivers/input/touchscreen/ads7846.c |    4 +-
 fs/exec.c                           |    8 +-
 include/linux/hrtimer.h             |   34 +---
 include/linux/interrupt.h           |    3 -
 include/linux/posix-timers.h        |    6 +-
 include/linux/timex.h               |   73 ++++----
 kernel/hrtimer.c                    |  361 +++++++++--------------------------
 kernel/posix-timers.c               |   40 ++--
 kernel/sched.c                      |    2 -
 kernel/time/ntp.c                   |    4 +-
 kernel/time/tick-sched.c            |   44 +++--
 kernel/trace/trace_sysprof.c        |    1 -
 sound/core/hrtimer.c                |    1 -
 sound/drivers/pcsp/pcsp.c           |    1 -
 19 files changed, 198 insertions(+), 407 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 98a0ed5..66c1496 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -479,7 +479,7 @@ config HPET_TIMER
          The HPET provides a stable time base on SMP
          systems, unlike the TSC, but it is more expensive to access,
          as it is off-chip.  You can find the HPET spec at
-         <http://www.intel.com/hardwaredesign/hpetspec.htm>.
+         <http://www.intel.com/hardwaredesign/hpetspec_1.pdf>.
 
          You can safely choose Y here.  However, HPET will only be
          activated if the platform and the BIOS support this feature.
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 3f0a3ed..845ea09 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -813,7 +813,7 @@ int __init hpet_enable(void)
 
 out_nohpet:
 	hpet_clear_mapping();
-	boot_hpet_disable = 1;
+	hpet_address = 0;
 	return 0;
 }
 
@@ -836,10 +836,11 @@ static __init int hpet_late_init(void)
 
 		hpet_address = force_hpet_address;
 		hpet_enable();
-		if (!hpet_virt_address)
-			return -ENODEV;
 	}
 
+	if (!hpet_virt_address)
+		return -ENODEV;
+
 	hpet_reserve_platform_timers(hpet_readl(HPET_ID));
 
 	for_each_online_cpu(cpu) {
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 67465ed..309949e 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -168,6 +168,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_31,
 			 ich_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_1,
 			 ich_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_4,
+			 ich_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH9_7,
 			 ich_force_enable_hpet);
 
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 53fdc7f..32b8bbf 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -46,7 +46,7 @@
 /*
  * The High Precision Event Timer driver.
  * This driver is closely modelled after the rtc.c driver.
- * http://www.intel.com/hardwaredesign/hpetspec.htm
+ * http://www.intel.com/hardwaredesign/hpetspec_1.pdf
  */
 #define	HPET_USER_FREQ	(64)
 #define	HPET_DRIFT	(500)
diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index c201710..e1129fa 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -57,11 +57,6 @@ u32 acpi_pm_read_verified(void)
 	return v2;
 }
 
-static cycle_t acpi_pm_read_slow(void)
-{
-	return (cycle_t)acpi_pm_read_verified();
-}
-
 static cycle_t acpi_pm_read(void)
 {
 	return (cycle_t)read_pmtmr();
@@ -88,6 +83,11 @@ static int __init acpi_pm_good_setup(char *__str)
 }
 __setup("acpi_pm_good", acpi_pm_good_setup);
 
+static cycle_t acpi_pm_read_slow(void)
+{
+	return (cycle_t)acpi_pm_read_verified();
+}
+
 static inline void acpi_pm_need_workaround(void)
 {
 	clocksource_acpi_pm.read = acpi_pm_read_slow;
diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index b9b7fc6..e1ece89 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -697,7 +697,7 @@ static enum hrtimer_restart ads7846_timer(struct hrtimer *handle)
 	struct ads7846	*ts = container_of(handle, struct ads7846, timer);
 	int		status = 0;
 
-	spin_lock_irq(&ts->lock);
+	spin_lock(&ts->lock);
 
 	if (unlikely(!get_pendown_state(ts) ||
 		     device_suspended(&ts->spi->dev))) {
@@ -728,7 +728,7 @@ static enum hrtimer_restart ads7846_timer(struct hrtimer *handle)
 			dev_err(&ts->spi->dev, "spi_async --> %d\n", status);
 	}
 
-	spin_unlock_irq(&ts->lock);
+	spin_unlock(&ts->lock);
 	return HRTIMER_NORESTART;
 }
 
diff --git a/fs/exec.c b/fs/exec.c
index 1f59ea0..02d2e12 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -773,7 +773,6 @@ static int de_thread(struct task_struct *tsk)
 	struct signal_struct *sig = tsk->signal;
 	struct sighand_struct *oldsighand = tsk->sighand;
 	spinlock_t *lock = &oldsighand->siglock;
-	struct task_struct *leader = NULL;
 	int count;
 
 	if (thread_group_empty(tsk))
@@ -811,7 +810,7 @@ static int de_thread(struct task_struct *tsk)
 	 * and to assume its PID:
 	 */
 	if (!thread_group_leader(tsk)) {
-		leader = tsk->group_leader;
+		struct task_struct *leader = tsk->group_leader;
 
 		sig->notify_count = -1;	/* for exit_notify() */
 		for (;;) {
@@ -863,8 +862,9 @@ static int de_thread(struct task_struct *tsk)
 
 		BUG_ON(leader->exit_state != EXIT_ZOMBIE);
 		leader->exit_state = EXIT_DEAD;
-
 		write_unlock_irq(&tasklist_lock);
+
+		release_task(leader);
 	}
 
 	sig->group_exit_task = NULL;
@@ -873,8 +873,6 @@ static int de_thread(struct task_struct *tsk)
 no_thread_group:
 	exit_itimers(sig);
 	flush_itimer_signals();
-	if (leader)
-		release_task(leader);
 
 	if (atomic_read(&oldsighand->count) != 1) {
 		struct sighand_struct *newsighand;
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 3eba438..bd37078 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -43,26 +43,6 @@ enum hrtimer_restart {
 };
 
 /*
- * hrtimer callback modes:
- *
- *	HRTIMER_CB_SOFTIRQ:		Callback must run in softirq context
- *	HRTIMER_CB_IRQSAFE_PERCPU:	Callback must run in hardirq context
- *					Special mode for tick emulation and
- *					scheduler timer. Such timers are per
- *					cpu and not allowed to be migrated on
- *					cpu unplug.
- *	HRTIMER_CB_IRQSAFE_UNLOCKED:	Callback should run in hardirq context
- *					with timer->base lock unlocked
- *					used for timers which call wakeup to
- *					avoid lock order problems with rq->lock
- */
-enum hrtimer_cb_mode {
-	HRTIMER_CB_SOFTIRQ,
-	HRTIMER_CB_IRQSAFE_PERCPU,
-	HRTIMER_CB_IRQSAFE_UNLOCKED,
-};
-
-/*
  * Values to track state of the timer
  *
  * Possible states:
@@ -70,7 +50,6 @@ enum hrtimer_cb_mode {
  * 0x00		inactive
  * 0x01		enqueued into rbtree
  * 0x02		callback function running
- * 0x04		callback pending (high resolution mode)
  *
  * Special cases:
  * 0x03		callback function running and enqueued
@@ -92,8 +71,7 @@ enum hrtimer_cb_mode {
 #define HRTIMER_STATE_INACTIVE	0x00
 #define HRTIMER_STATE_ENQUEUED	0x01
 #define HRTIMER_STATE_CALLBACK	0x02
-#define HRTIMER_STATE_PENDING	0x04
-#define HRTIMER_STATE_MIGRATE	0x08
+#define HRTIMER_STATE_MIGRATE	0x04
 
 /**
  * struct hrtimer - the basic hrtimer structure
@@ -109,8 +87,6 @@ enum hrtimer_cb_mode {
  * @function:	timer expiry callback function
  * @base:	pointer to the timer base (per cpu and per clock)
  * @state:	state information (See bit values above)
- * @cb_mode:	high resolution timer feature to select the callback execution
- *		 mode
  * @cb_entry:	list head to enqueue an expired timer into the callback list
  * @start_site:	timer statistics field to store the site where the timer
  *		was started
@@ -129,7 +105,6 @@ struct hrtimer {
 	struct hrtimer_clock_base	*base;
 	unsigned long			state;
 	struct list_head		cb_entry;
-	enum hrtimer_cb_mode		cb_mode;
 #ifdef CONFIG_TIMER_STATS
 	int				start_pid;
 	void				*start_site;
@@ -188,15 +163,11 @@ struct hrtimer_clock_base {
  * @check_clocks:	Indictator, when set evaluate time source and clock
  *			event devices whether high resolution mode can be
  *			activated.
- * @cb_pending:		Expired timers are moved from the rbtree to this
- *			list in the timer interrupt. The list is processed
- *			in the softirq.
  * @nr_events:		Total number of timer interrupt events
  */
 struct hrtimer_cpu_base {
 	spinlock_t			lock;
 	struct hrtimer_clock_base	clock_base[HRTIMER_MAX_CLOCK_BASES];
-	struct list_head		cb_pending;
 #ifdef CONFIG_HIGH_RES_TIMERS
 	ktime_t				expires_next;
 	int				hres_active;
@@ -404,8 +375,7 @@ static inline int hrtimer_active(const struct hrtimer *timer)
  */
 static inline int hrtimer_is_queued(struct hrtimer *timer)
 {
-	return timer->state &
-		(HRTIMER_STATE_ENQUEUED | HRTIMER_STATE_PENDING);
+	return timer->state & HRTIMER_STATE_ENQUEUED;
 }
 
 /*
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index f58a0cf..d6210a9 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -251,9 +251,6 @@ enum
 	BLOCK_SOFTIRQ,
 	TASKLET_SOFTIRQ,
 	SCHED_SOFTIRQ,
-#ifdef CONFIG_HIGH_RES_TIMERS
-	HRTIMER_SOFTIRQ,
-#endif
 	RCU_SOFTIRQ, 	/* Preferable RCU should always be the last softirq */
 
 	NR_SOFTIRQS
diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index a7c7213..4f71bf4 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -45,7 +45,11 @@ struct k_itimer {
 	int it_requeue_pending;		/* waiting to requeue this timer */
 #define REQUEUE_PENDING 1
 	int it_sigev_notify;		/* notify word of sigevent struct */
-	struct task_struct *it_process;	/* process to send signal to */
+	struct signal_struct *it_signal;
+	union {
+		struct pid *it_pid;	/* pid of process to send signal to */
+		struct task_struct *it_process;	/* for clock_nanosleep */
+	};
 	struct sigqueue *sigq;		/* signal queue entry. */
 	union {
 		struct {
diff --git a/include/linux/timex.h b/include/linux/timex.h
index 9007313..998a55d 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -53,47 +53,11 @@
 #ifndef _LINUX_TIMEX_H
 #define _LINUX_TIMEX_H
 
-#include <linux/compiler.h>
 #include <linux/time.h>
 
-#include <asm/param.h>
-
 #define NTP_API		4	/* NTP API version */
 
 /*
- * SHIFT_KG and SHIFT_KF establish the damping of the PLL and are chosen
- * for a slightly underdamped convergence characteristic. SHIFT_KH
- * establishes the damping of the FLL and is chosen by wisdom and black
- * art.
- *
- * MAXTC establishes the maximum time constant of the PLL. With the
- * SHIFT_KG and SHIFT_KF values given and a time constant range from
- * zero to MAXTC, the PLL will converge in 15 minutes to 16 hours,
- * respectively.
- */
-#define SHIFT_PLL	4	/* PLL frequency factor (shift) */
-#define SHIFT_FLL	2	/* FLL frequency factor (shift) */
-#define MAXTC		10	/* maximum time constant (shift) */
-
-/*
- * SHIFT_USEC defines the scaling (shift) of the time_freq and
- * time_tolerance variables, which represent the current frequency
- * offset and maximum frequency tolerance.
- */
-#define SHIFT_USEC 16		/* frequency offset scale (shift) */
-#define PPM_SCALE (NSEC_PER_USEC << (NTP_SCALE_SHIFT - SHIFT_USEC))
-#define PPM_SCALE_INV_SHIFT 19
-#define PPM_SCALE_INV ((1ll << (PPM_SCALE_INV_SHIFT + NTP_SCALE_SHIFT)) / \
-		       PPM_SCALE + 1)
-
-#define MAXPHASE 500000000l	/* max phase error (ns) */
-#define MAXFREQ 500000		/* max frequency error (ns/s) */
-#define MAXFREQ_SCALED ((s64)MAXFREQ << NTP_SCALE_SHIFT)
-#define MINSEC 256		/* min interval between updates (s) */
-#define MAXSEC 2048		/* max interval between updates (s) */
-#define NTP_PHASE_LIMIT ((MAXPHASE / NSEC_PER_USEC) << 5) /* beyond max. dispersion */
-
-/*
  * syscall interface - used (mainly by NTP daemon)
  * to discipline kernel clock oscillator
  */
@@ -199,9 +163,46 @@ struct timex {
 #define TIME_BAD	TIME_ERROR /* bw compat */
 
 #ifdef __KERNEL__
+#include <linux/compiler.h>
+#include <linux/types.h>
+#include <linux/param.h>
+
 #include <asm/timex.h>
 
 /*
+ * SHIFT_KG and SHIFT_KF establish the damping of the PLL and are chosen
+ * for a slightly underdamped convergence characteristic. SHIFT_KH
+ * establishes the damping of the FLL and is chosen by wisdom and black
+ * art.
+ *
+ * MAXTC establishes the maximum time constant of the PLL. With the
+ * SHIFT_KG and SHIFT_KF values given and a time constant range from
+ * zero to MAXTC, the PLL will converge in 15 minutes to 16 hours,
+ * respectively.
+ */
+#define SHIFT_PLL	4	/* PLL frequency factor (shift) */
+#define SHIFT_FLL	2	/* FLL frequency factor (shift) */
+#define MAXTC		10	/* maximum time constant (shift) */
+
+/*
+ * SHIFT_USEC defines the scaling (shift) of the time_freq and
+ * time_tolerance variables, which represent the current frequency
+ * offset and maximum frequency tolerance.
+ */
+#define SHIFT_USEC 16		/* frequency offset scale (shift) */
+#define PPM_SCALE (NSEC_PER_USEC << (NTP_SCALE_SHIFT - SHIFT_USEC))
+#define PPM_SCALE_INV_SHIFT 19
+#define PPM_SCALE_INV ((1ll << (PPM_SCALE_INV_SHIFT + NTP_SCALE_SHIFT)) / \
+		       PPM_SCALE + 1)
+
+#define MAXPHASE 500000000l	/* max phase error (ns) */
+#define MAXFREQ 500000		/* max frequency error (ns/s) */
+#define MAXFREQ_SCALED ((s64)MAXFREQ << NTP_SCALE_SHIFT)
+#define MINSEC 256		/* min interval between updates (s) */
+#define MAXSEC 2048		/* max interval between updates (s) */
+#define NTP_PHASE_LIMIT ((MAXPHASE / NSEC_PER_USEC) << 5) /* beyond max. dispersion */
+
+/*
  * kernel variables
  * Note: maximum error = NTP synch distance = dispersion + delay / 2;
  * estimated error = NTP dispersion.
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 47e6334..c2a69b8 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -442,22 +442,6 @@ static inline void debug_hrtimer_activate(struct hrtimer *timer) { }
 static inline void debug_hrtimer_deactivate(struct hrtimer *timer) { }
 #endif
 
-/*
- * Check, whether the timer is on the callback pending list
- */
-static inline int hrtimer_cb_pending(const struct hrtimer *timer)
-{
-	return timer->state & HRTIMER_STATE_PENDING;
-}
-
-/*
- * Remove a timer from the callback pending list
- */
-static inline void hrtimer_remove_cb_pending(struct hrtimer *timer)
-{
-	list_del_init(&timer->cb_entry);
-}
-
 /* High resolution timer related functions */
 #ifdef CONFIG_HIGH_RES_TIMERS
 
@@ -651,6 +635,8 @@ static inline void hrtimer_init_timer_hres(struct hrtimer *timer)
 {
 }
 
+static void __run_hrtimer(struct hrtimer *timer);
+
 /*
  * When High resolution timers are active, try to reprogram. Note, that in case
  * the state has HRTIMER_STATE_CALLBACK set, no reprogramming and no expiry
@@ -661,31 +647,14 @@ static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
 					    struct hrtimer_clock_base *base)
 {
 	if (base->cpu_base->hres_active && hrtimer_reprogram(timer, base)) {
-
-		/* Timer is expired, act upon the callback mode */
-		switch(timer->cb_mode) {
-		case HRTIMER_CB_IRQSAFE_PERCPU:
-		case HRTIMER_CB_IRQSAFE_UNLOCKED:
-			/*
-			 * This is solely for the sched tick emulation with
-			 * dynamic tick support to ensure that we do not
-			 * restart the tick right on the edge and end up with
-			 * the tick timer in the softirq ! The calling site
-			 * takes care of this. Also used for hrtimer sleeper !
-			 */
-			debug_hrtimer_deactivate(timer);
-			return 1;
-		case HRTIMER_CB_SOFTIRQ:
-			/*
-			 * Move everything else into the softirq pending list !
-			 */
-			list_add_tail(&timer->cb_entry,
-				      &base->cpu_base->cb_pending);
-			timer->state = HRTIMER_STATE_PENDING;
-			return 1;
-		default:
-			BUG();
-		}
+		/*
+		 * XXX: recursion check?
+		 * hrtimer_forward() should round up with timer granularity
+		 * so that we never get into inf recursion here,
+		 * it doesn't do that though
+		 */
+		__run_hrtimer(timer);
+		return 1;
 	}
 	return 0;
 }
@@ -724,11 +693,6 @@ static int hrtimer_switch_to_hres(void)
 	return 1;
 }
 
-static inline void hrtimer_raise_softirq(void)
-{
-	raise_softirq(HRTIMER_SOFTIRQ);
-}
-
 #else
 
 static inline int hrtimer_hres_active(void) { return 0; }
@@ -747,7 +711,6 @@ static inline int hrtimer_reprogram(struct hrtimer *timer,
 {
 	return 0;
 }
-static inline void hrtimer_raise_softirq(void) { }
 
 #endif /* CONFIG_HIGH_RES_TIMERS */
 
@@ -890,10 +853,7 @@ static void __remove_hrtimer(struct hrtimer *timer,
 			     struct hrtimer_clock_base *base,
 			     unsigned long newstate, int reprogram)
 {
-	/* High res. callback list. NOP for !HIGHRES */
-	if (hrtimer_cb_pending(timer))
-		hrtimer_remove_cb_pending(timer);
-	else {
+	if (timer->state & HRTIMER_STATE_ENQUEUED) {
 		/*
 		 * Remove the timer from the rbtree and replace the
 		 * first entry pointer if necessary.
@@ -953,7 +913,7 @@ hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim, unsigned long delta_n
 {
 	struct hrtimer_clock_base *base, *new_base;
 	unsigned long flags;
-	int ret, raise;
+	int ret;
 
 	base = lock_hrtimer_base(timer, &flags);
 
@@ -988,26 +948,8 @@ hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim, unsigned long delta_n
 	enqueue_hrtimer(timer, new_base,
 			new_base->cpu_base == &__get_cpu_var(hrtimer_bases));
 
-	/*
-	 * The timer may be expired and moved to the cb_pending
-	 * list. We can not raise the softirq with base lock held due
-	 * to a possible deadlock with runqueue lock.
-	 */
-	raise = timer->state == HRTIMER_STATE_PENDING;
-
-	/*
-	 * We use preempt_disable to prevent this task from migrating after
-	 * setting up the softirq and raising it. Otherwise, if me migrate
-	 * we will raise the softirq on the wrong CPU.
-	 */
-	preempt_disable();
-
 	unlock_hrtimer_base(timer, &flags);
 
-	if (raise)
-		hrtimer_raise_softirq();
-	preempt_enable();
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(hrtimer_start_range_ns);
@@ -1192,75 +1134,6 @@ int hrtimer_get_res(const clockid_t which_clock, struct timespec *tp)
 }
 EXPORT_SYMBOL_GPL(hrtimer_get_res);
 
-static void run_hrtimer_pending(struct hrtimer_cpu_base *cpu_base)
-{
-	spin_lock_irq(&cpu_base->lock);
-
-	while (!list_empty(&cpu_base->cb_pending)) {
-		enum hrtimer_restart (*fn)(struct hrtimer *);
-		struct hrtimer *timer;
-		int restart;
-		int emulate_hardirq_ctx = 0;
-
-		timer = list_entry(cpu_base->cb_pending.next,
-				   struct hrtimer, cb_entry);
-
-		debug_hrtimer_deactivate(timer);
-		timer_stats_account_hrtimer(timer);
-
-		fn = timer->function;
-		/*
-		 * A timer might have been added to the cb_pending list
-		 * when it was migrated during a cpu-offline operation.
-		 * Emulate hardirq context for such timers.
-		 */
-		if (timer->cb_mode == HRTIMER_CB_IRQSAFE_PERCPU ||
-		    timer->cb_mode == HRTIMER_CB_IRQSAFE_UNLOCKED)
-			emulate_hardirq_ctx = 1;
-
-		__remove_hrtimer(timer, timer->base, HRTIMER_STATE_CALLBACK, 0);
-		spin_unlock_irq(&cpu_base->lock);
-
-		if (unlikely(emulate_hardirq_ctx)) {
-			local_irq_disable();
-			restart = fn(timer);
-			local_irq_enable();
-		} else
-			restart = fn(timer);
-
-		spin_lock_irq(&cpu_base->lock);
-
-		timer->state &= ~HRTIMER_STATE_CALLBACK;
-		if (restart == HRTIMER_RESTART) {
-			BUG_ON(hrtimer_active(timer));
-			/*
-			 * Enqueue the timer, allow reprogramming of the event
-			 * device
-			 */
-			enqueue_hrtimer(timer, timer->base, 1);
-		} else if (hrtimer_active(timer)) {
-			/*
-			 * If the timer was rearmed on another CPU, reprogram
-			 * the event device.
-			 */
-			struct hrtimer_clock_base *base = timer->base;
-
-			if (base->first == &timer->node &&
-			    hrtimer_reprogram(timer, base)) {
-				/*
-				 * Timer is expired. Thus move it from tree to
-				 * pending list again.
-				 */
-				__remove_hrtimer(timer, base,
-						 HRTIMER_STATE_PENDING, 0);
-				list_add_tail(&timer->cb_entry,
-					      &base->cpu_base->cb_pending);
-			}
-		}
-	}
-	spin_unlock_irq(&cpu_base->lock);
-}
-
 static void __run_hrtimer(struct hrtimer *timer)
 {
 	struct hrtimer_clock_base *base = timer->base;
@@ -1268,25 +1141,21 @@ static void __run_hrtimer(struct hrtimer *timer)
 	enum hrtimer_restart (*fn)(struct hrtimer *);
 	int restart;
 
+	WARN_ON(!irqs_disabled());
+
 	debug_hrtimer_deactivate(timer);
 	__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK, 0);
 	timer_stats_account_hrtimer(timer);
-
 	fn = timer->function;
-	if (timer->cb_mode == HRTIMER_CB_IRQSAFE_PERCPU ||
-	    timer->cb_mode == HRTIMER_CB_IRQSAFE_UNLOCKED) {
-		/*
-		 * Used for scheduler timers, avoid lock inversion with
-		 * rq->lock and tasklist_lock.
-		 *
-		 * These timers are required to deal with enqueue expiry
-		 * themselves and are not allowed to migrate.
-		 */
-		spin_unlock(&cpu_base->lock);
-		restart = fn(timer);
-		spin_lock(&cpu_base->lock);
-	} else
-		restart = fn(timer);
+
+	/*
+	 * Because we run timers from hardirq context, there is no chance
+	 * they get migrated to another cpu, therefore its safe to unlock
+	 * the timer base.
+	 */
+	spin_unlock(&cpu_base->lock);
+	restart = fn(timer);
+	spin_lock(&cpu_base->lock);
 
 	/*
 	 * Note: We clear the CALLBACK bit after enqueue_hrtimer to avoid
@@ -1302,6 +1171,29 @@ static void __run_hrtimer(struct hrtimer *timer)
 
 #ifdef CONFIG_HIGH_RES_TIMERS
 
+static int force_clock_reprogram;
+
+/*
+ * After 5 iteration's attempts, we consider that hrtimer_interrupt()
+ * is hanging, which could happen with something that slows the interrupt
+ * such as the tracing. Then we force the clock reprogramming for each future
+ * hrtimer interrupts to avoid infinite loops and use the min_delta_ns
+ * threshold that we will overwrite.
+ * The next tick event will be scheduled to 3 times we currently spend on
+ * hrtimer_interrupt(). This gives a good compromise, the cpus will spend
+ * 1/4 of their time to process the hrtimer interrupts. This is enough to
+ * let it running without serious starvation.
+ */
+
+static inline void
+hrtimer_interrupt_hanging(struct clock_event_device *dev,
+			ktime_t try_time)
+{
+	force_clock_reprogram = 1;
+	dev->min_delta_ns = (unsigned long)try_time.tv64 * 3;
+	printk(KERN_WARNING "hrtimer: interrupt too slow, "
+		"forcing clock min delta to %lu ns\n", dev->min_delta_ns);
+}
 /*
  * High resolution timer interrupt
  * Called with interrupts disabled
@@ -1311,13 +1203,18 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
 	struct hrtimer_clock_base *base;
 	ktime_t expires_next, now;
-	int i, raise = 0;
+	int nr_retries = 0;
+	int i;
 
 	BUG_ON(!cpu_base->hres_active);
 	cpu_base->nr_events++;
 	dev->next_event.tv64 = KTIME_MAX;
 
  retry:
+	/* 5 retries is enough to notice a hang */
+	if (!(++nr_retries % 5))
+		hrtimer_interrupt_hanging(dev, ktime_sub(ktime_get(), now));
+
 	now = ktime_get();
 
 	expires_next.tv64 = KTIME_MAX;
@@ -1360,16 +1257,6 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 				break;
 			}
 
-			/* Move softirq callbacks to the pending list */
-			if (timer->cb_mode == HRTIMER_CB_SOFTIRQ) {
-				__remove_hrtimer(timer, base,
-						 HRTIMER_STATE_PENDING, 0);
-				list_add_tail(&timer->cb_entry,
-					      &base->cpu_base->cb_pending);
-				raise = 1;
-				continue;
-			}
-
 			__run_hrtimer(timer);
 		}
 		spin_unlock(&cpu_base->lock);
@@ -1380,13 +1267,9 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 
 	/* Reprogramming necessary ? */
 	if (expires_next.tv64 != KTIME_MAX) {
-		if (tick_program_event(expires_next, 0))
+		if (tick_program_event(expires_next, force_clock_reprogram))
 			goto retry;
 	}
-
-	/* Raise softirq ? */
-	if (raise)
-		raise_softirq(HRTIMER_SOFTIRQ);
 }
 
 /**
@@ -1413,11 +1296,6 @@ void hrtimer_peek_ahead_timers(void)
 	local_irq_restore(flags);
 }
 
-static void run_hrtimer_softirq(struct softirq_action *h)
-{
-	run_hrtimer_pending(&__get_cpu_var(hrtimer_bases));
-}
-
 #endif	/* CONFIG_HIGH_RES_TIMERS */
 
 /*
@@ -1429,8 +1307,6 @@ static void run_hrtimer_softirq(struct softirq_action *h)
  */
 void hrtimer_run_pending(void)
 {
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
-
 	if (hrtimer_hres_active())
 		return;
 
@@ -1444,8 +1320,6 @@ void hrtimer_run_pending(void)
 	 */
 	if (tick_check_oneshot_change(!hrtimer_is_hres_enabled()))
 		hrtimer_switch_to_hres();
-
-	run_hrtimer_pending(cpu_base);
 }
 
 /*
@@ -1482,14 +1356,6 @@ void hrtimer_run_queues(void)
 					hrtimer_get_expires_tv64(timer))
 				break;
 
-			if (timer->cb_mode == HRTIMER_CB_SOFTIRQ) {
-				__remove_hrtimer(timer, base,
-					HRTIMER_STATE_PENDING, 0);
-				list_add_tail(&timer->cb_entry,
-					&base->cpu_base->cb_pending);
-				continue;
-			}
-
 			__run_hrtimer(timer);
 		}
 		spin_unlock(&cpu_base->lock);
@@ -1516,9 +1382,6 @@ void hrtimer_init_sleeper(struct hrtimer_sleeper *sl, struct task_struct *task)
 {
 	sl->timer.function = hrtimer_wakeup;
 	sl->task = task;
-#ifdef CONFIG_HIGH_RES_TIMERS
-	sl->timer.cb_mode = HRTIMER_CB_IRQSAFE_UNLOCKED;
-#endif
 }
 
 static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mode)
@@ -1655,18 +1518,16 @@ static void __cpuinit init_hrtimers_cpu(int cpu)
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++)
 		cpu_base->clock_base[i].cpu_base = cpu_base;
 
-	INIT_LIST_HEAD(&cpu_base->cb_pending);
 	hrtimer_init_hres(cpu_base);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
 
-static int migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
-				struct hrtimer_clock_base *new_base, int dcpu)
+static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
+				struct hrtimer_clock_base *new_base)
 {
 	struct hrtimer *timer;
 	struct rb_node *node;
-	int raise = 0;
 
 	while ((node = rb_first(&old_base->active))) {
 		timer = rb_entry(node, struct hrtimer, node);
@@ -1674,18 +1535,6 @@ static int migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 		debug_hrtimer_deactivate(timer);
 
 		/*
-		 * Should not happen. Per CPU timers should be
-		 * canceled _before_ the migration code is called
-		 */
-		if (timer->cb_mode == HRTIMER_CB_IRQSAFE_PERCPU) {
-			__remove_hrtimer(timer, old_base,
-					 HRTIMER_STATE_INACTIVE, 0);
-			WARN(1, "hrtimer (%p %p)active but cpu %d dead\n",
-			     timer, timer->function, dcpu);
-			continue;
-		}
-
-		/*
 		 * Mark it as STATE_MIGRATE not INACTIVE otherwise the
 		 * timer could be seen as !active and just vanish away
 		 * under us on another CPU
@@ -1693,69 +1542,34 @@ static int migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 		__remove_hrtimer(timer, old_base, HRTIMER_STATE_MIGRATE, 0);
 		timer->base = new_base;
 		/*
-		 * Enqueue the timer. Allow reprogramming of the event device
+		 * Enqueue the timers on the new cpu, but do not reprogram 
+		 * the timer as that would enable a deadlock between
+		 * hrtimer_enqueue_reprogramm() running the timer and us still
+		 * holding a nested base lock.
+		 *
+		 * Instead we tickle the hrtimer interrupt after the migration
+		 * is done, which will run all expired timers and re-programm
+		 * the timer device.
 		 */
-		enqueue_hrtimer(timer, new_base, 1);
+		enqueue_hrtimer(timer, new_base, 0);
 
-#ifdef CONFIG_HIGH_RES_TIMERS
-		/*
-		 * Happens with high res enabled when the timer was
-		 * already expired and the callback mode is
-		 * HRTIMER_CB_IRQSAFE_UNLOCKED (hrtimer_sleeper). The
-		 * enqueue code does not move them to the soft irq
-		 * pending list for performance/latency reasons, but
-		 * in the migration state, we need to do that
-		 * otherwise we end up with a stale timer.
-		 */
-		if (timer->state == HRTIMER_STATE_MIGRATE) {
-			timer->state = HRTIMER_STATE_PENDING;
-			list_add_tail(&timer->cb_entry,
-				      &new_base->cpu_base->cb_pending);
-			raise = 1;
-		}
-#endif
 		/* Clear the migration state bit */
 		timer->state &= ~HRTIMER_STATE_MIGRATE;
 	}
-	return raise;
-}
-
-#ifdef CONFIG_HIGH_RES_TIMERS
-static int migrate_hrtimer_pending(struct hrtimer_cpu_base *old_base,
-				   struct hrtimer_cpu_base *new_base)
-{
-	struct hrtimer *timer;
-	int raise = 0;
-
-	while (!list_empty(&old_base->cb_pending)) {
-		timer = list_entry(old_base->cb_pending.next,
-				   struct hrtimer, cb_entry);
-
-		__remove_hrtimer(timer, timer->base, HRTIMER_STATE_PENDING, 0);
-		timer->base = &new_base->clock_base[timer->base->index];
-		list_add_tail(&timer->cb_entry, &new_base->cb_pending);
-		raise = 1;
-	}
-	return raise;
-}
-#else
-static int migrate_hrtimer_pending(struct hrtimer_cpu_base *old_base,
-				   struct hrtimer_cpu_base *new_base)
-{
-	return 0;
 }
-#endif
 
-static void migrate_hrtimers(int cpu)
+static int migrate_hrtimers(int scpu)
 {
 	struct hrtimer_cpu_base *old_base, *new_base;
-	int i, raise = 0;
+	int dcpu, i;
 
-	BUG_ON(cpu_online(cpu));
-	old_base = &per_cpu(hrtimer_bases, cpu);
+	BUG_ON(cpu_online(scpu));
+	old_base = &per_cpu(hrtimer_bases, scpu);
 	new_base = &get_cpu_var(hrtimer_bases);
 
-	tick_cancel_sched_timer(cpu);
+	dcpu = smp_processor_id();
+
+	tick_cancel_sched_timer(scpu);
 	/*
 	 * The caller is globally serialized and nobody else
 	 * takes two locks at once, deadlock is not possible.
@@ -1764,41 +1578,47 @@ static void migrate_hrtimers(int cpu)
 	spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
-		if (migrate_hrtimer_list(&old_base->clock_base[i],
-					 &new_base->clock_base[i], cpu))
-			raise = 1;
+		migrate_hrtimer_list(&old_base->clock_base[i],
+				     &new_base->clock_base[i]);
 	}
 
-	if (migrate_hrtimer_pending(old_base, new_base))
-		raise = 1;
-
 	spin_unlock(&old_base->lock);
 	spin_unlock_irq(&new_base->lock);
 	put_cpu_var(hrtimer_bases);
 
-	if (raise)
-		hrtimer_raise_softirq();
+	return dcpu;
 }
+
+static void tickle_timers(void *arg)
+{
+	hrtimer_peek_ahead_timers();
+}
+
 #endif /* CONFIG_HOTPLUG_CPU */
 
 static int __cpuinit hrtimer_cpu_notify(struct notifier_block *self,
 					unsigned long action, void *hcpu)
 {
-	unsigned int cpu = (long)hcpu;
+	int scpu = (long)hcpu;
 
 	switch (action) {
 
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		init_hrtimers_cpu(cpu);
+		init_hrtimers_cpu(scpu);
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD, &cpu);
-		migrate_hrtimers(cpu);
+	{
+		int dcpu;
+
+		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD, &scpu);
+		dcpu = migrate_hrtimers(scpu);
+		smp_call_function_single(dcpu, tickle_timers, NULL, 0);
 		break;
+	}
 #endif
 
 	default:
@@ -1817,9 +1637,6 @@ void __init hrtimers_init(void)
 	hrtimer_cpu_notify(&hrtimers_nb, (unsigned long)CPU_UP_PREPARE,
 			  (void *)(long)smp_processor_id());
 	register_cpu_notifier(&hrtimers_nb);
-#ifdef CONFIG_HIGH_RES_TIMERS
-	open_softirq(HRTIMER_SOFTIRQ, run_hrtimer_softirq);
-#endif
 }
 
 /**
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index a140e44..887c637 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -116,7 +116,7 @@ static DEFINE_SPINLOCK(idr_lock);
  *	    must supply functions here, even if the function just returns
  *	    ENOSYS.  The standard POSIX timer management code assumes the
  *	    following: 1.) The k_itimer struct (sched.h) is used for the
- *	    timer.  2.) The list, it_lock, it_clock, it_id and it_process
+ *	    timer.  2.) The list, it_lock, it_clock, it_id and it_pid
  *	    fields are not modified by timer code.
  *
  *          At this time all functions EXCEPT clock_nanosleep can be
@@ -319,7 +319,8 @@ void do_schedule_next_timer(struct siginfo *info)
 
 int posix_timer_event(struct k_itimer *timr, int si_private)
 {
-	int shared, ret;
+	struct task_struct *task;
+	int shared, ret = -1;
 	/*
 	 * FIXME: if ->sigq is queued we can race with
 	 * dequeue_signal()->do_schedule_next_timer().
@@ -333,8 +334,13 @@ int posix_timer_event(struct k_itimer *timr, int si_private)
 	 */
 	timr->sigq->info.si_sys_private = si_private;
 
-	shared = !(timr->it_sigev_notify & SIGEV_THREAD_ID);
-	ret = send_sigqueue(timr->sigq, timr->it_process, shared);
+	rcu_read_lock();
+	task = pid_task(timr->it_pid, PIDTYPE_PID);
+	if (task) {
+		shared = !(timr->it_sigev_notify & SIGEV_THREAD_ID);
+		ret = send_sigqueue(timr->sigq, task, shared);
+	}
+	rcu_read_unlock();
 	/* If we failed to send the signal the timer stops. */
 	return ret > 0;
 }
@@ -411,7 +417,7 @@ static enum hrtimer_restart posix_timer_fn(struct hrtimer *timer)
 	return ret;
 }
 
-static struct task_struct * good_sigevent(sigevent_t * event)
+static struct pid *good_sigevent(sigevent_t * event)
 {
 	struct task_struct *rtn = current->group_leader;
 
@@ -425,7 +431,7 @@ static struct task_struct * good_sigevent(sigevent_t * event)
 	    ((event->sigev_signo <= 0) || (event->sigev_signo > SIGRTMAX)))
 		return NULL;
 
-	return rtn;
+	return task_pid(rtn);
 }
 
 void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock)
@@ -464,6 +470,7 @@ static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
 		idr_remove(&posix_timers_id, tmr->it_id);
 		spin_unlock_irqrestore(&idr_lock, flags);
 	}
+	put_pid(tmr->it_pid);
 	sigqueue_free(tmr->sigq);
 	kmem_cache_free(posix_timers_cache, tmr);
 }
@@ -477,7 +484,6 @@ sys_timer_create(const clockid_t which_clock,
 {
 	struct k_itimer *new_timer;
 	int error, new_timer_id;
-	struct task_struct *process;
 	sigevent_t event;
 	int it_id_set = IT_ID_NOT_SET;
 
@@ -531,11 +537,9 @@ sys_timer_create(const clockid_t which_clock,
 			goto out;
 		}
 		rcu_read_lock();
-		process = good_sigevent(&event);
-		if (process)
-			get_task_struct(process);
+		new_timer->it_pid = get_pid(good_sigevent(&event));
 		rcu_read_unlock();
-		if (!process) {
+		if (!new_timer->it_pid) {
 			error = -EINVAL;
 			goto out;
 		}
@@ -543,8 +547,7 @@ sys_timer_create(const clockid_t which_clock,
 		event.sigev_notify = SIGEV_SIGNAL;
 		event.sigev_signo = SIGALRM;
 		event.sigev_value.sival_int = new_timer->it_id;
-		process = current->group_leader;
-		get_task_struct(process);
+		new_timer->it_pid = get_pid(task_tgid(current));
 	}
 
 	new_timer->it_sigev_notify     = event.sigev_notify;
@@ -554,7 +557,7 @@ sys_timer_create(const clockid_t which_clock,
 	new_timer->sigq->info.si_code  = SI_TIMER;
 
 	spin_lock_irq(&current->sighand->siglock);
-	new_timer->it_process = process;
+	new_timer->it_signal = current->signal;
 	list_add(&new_timer->list, &current->signal->posix_timers);
 	spin_unlock_irq(&current->sighand->siglock);
 
@@ -589,8 +592,7 @@ static struct k_itimer *lock_timer(timer_t timer_id, unsigned long *flags)
 	timr = idr_find(&posix_timers_id, (int)timer_id);
 	if (timr) {
 		spin_lock(&timr->it_lock);
-		if (timr->it_process &&
-		    same_thread_group(timr->it_process, current)) {
+		if (timr->it_signal == current->signal) {
 			spin_unlock(&idr_lock);
 			return timr;
 		}
@@ -837,8 +839,7 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	put_task_struct(timer->it_process);
-	timer->it_process = NULL;
+	timer->it_signal = NULL;
 
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);
@@ -864,8 +865,7 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	put_task_struct(timer->it_process);
-	timer->it_process = NULL;
+	timer->it_signal = NULL;
 
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);
diff --git a/kernel/sched.c b/kernel/sched.c
index 748ff92..355eda2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -209,7 +209,6 @@ void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime)
 	hrtimer_init(&rt_b->rt_period_timer,
 			CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	rt_b->rt_period_timer.function = sched_rt_period_timer;
-	rt_b->rt_period_timer.cb_mode = HRTIMER_CB_IRQSAFE_UNLOCKED;
 }
 
 static inline int rt_bandwidth_enabled(void)
@@ -1139,7 +1138,6 @@ static void init_rq_hrtick(struct rq *rq)
 
 	hrtimer_init(&rq->hrtick_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	rq->hrtick_timer.function = hrtick;
-	rq->hrtick_timer.cb_mode = HRTIMER_CB_IRQSAFE_PERCPU;
 }
 #else	/* CONFIG_SCHED_HRTICK */
 static inline void hrtick_clear(struct rq *rq)
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 8ff15e5..f5f793d 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -131,7 +131,7 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 {
 	enum hrtimer_restart res = HRTIMER_NORESTART;
 
-	write_seqlock_irq(&xtime_lock);
+	write_seqlock(&xtime_lock);
 
 	switch (time_state) {
 	case TIME_OK:
@@ -164,7 +164,7 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 	}
 	update_vsyscall(&xtime, clock);
 
-	write_sequnlock_irq(&xtime_lock);
+	write_sequnlock(&xtime_lock);
 
 	return res;
 }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 342fc9c..8f3fc25 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -247,7 +247,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 	if (need_resched())
 		goto end;
 
-	if (unlikely(local_softirq_pending())) {
+	if (unlikely(local_softirq_pending() && cpu_online(cpu))) {
 		static int ratelimit;
 
 		if (ratelimit < 10) {
@@ -282,8 +282,31 @@ void tick_nohz_stop_sched_tick(int inidle)
 	/* Schedule the tick, if we are at least one jiffie off */
 	if ((long)delta_jiffies >= 1) {
 
+		/*
+		* calculate the expiry time for the next timer wheel
+		* timer
+		*/
+		expires = ktime_add_ns(last_update, tick_period.tv64 *
+				   delta_jiffies);
+
+		/*
+		 * If this cpu is the one which updates jiffies, then
+		 * give up the assignment and let it be taken by the
+		 * cpu which runs the tick timer next, which might be
+		 * this cpu as well. If we don't drop this here the
+		 * jiffies might be stale and do_timer() never
+		 * invoked.
+		 */
+		if (cpu == tick_do_timer_cpu)
+			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
+
 		if (delta_jiffies > 1)
 			cpu_set(cpu, nohz_cpu_mask);
+
+		/* Skip reprogram of event if its not changed */
+		if (ts->tick_stopped && ktime_equal(expires, dev->next_event))
+			goto out;
+
 		/*
 		 * nohz_stop_sched_tick can be called several times before
 		 * the nohz_restart_sched_tick is called. This happens when
@@ -306,17 +329,6 @@ void tick_nohz_stop_sched_tick(int inidle)
 			rcu_enter_nohz();
 		}
 
-		/*
-		 * If this cpu is the one which updates jiffies, then
-		 * give up the assignment and let it be taken by the
-		 * cpu which runs the tick timer next, which might be
-		 * this cpu as well. If we don't drop this here the
-		 * jiffies might be stale and do_timer() never
-		 * invoked.
-		 */
-		if (cpu == tick_do_timer_cpu)
-			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
-
 		ts->idle_sleeps++;
 
 		/*
@@ -332,12 +344,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 			goto out;
 		}
 
-		/*
-		 * calculate the expiry time for the next timer wheel
-		 * timer
-		 */
-		expires = ktime_add_ns(last_update, tick_period.tv64 *
-				       delta_jiffies);
+		/* Mark expiries */
 		ts->idle_expires = expires;
 
 		if (ts->nohz_mode == NOHZ_MODE_HIGHRES) {
@@ -681,7 +688,6 @@ void tick_setup_sched_timer(void)
 	 */
 	hrtimer_init(&ts->sched_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 	ts->sched_timer.function = tick_sched_timer;
-	ts->sched_timer.cb_mode = HRTIMER_CB_IRQSAFE_PERCPU;
 
 	/* Get the next period (per cpu) */
 	hrtimer_set_expires(&ts->sched_timer, tick_init_jiffy_update());
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index 01becf1..a5779bd 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -202,7 +202,6 @@ static void start_stack_timer(int cpu)
 
 	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hrtimer->function = stack_trace_timer_fn;
-	hrtimer->cb_mode = HRTIMER_CB_IRQSAFE_PERCPU;
 
 	hrtimer_start(hrtimer, ns_to_ktime(sample_period), HRTIMER_MODE_REL);
 }
diff --git a/sound/core/hrtimer.c b/sound/core/hrtimer.c
index c1d2859..34c7d48 100644
--- a/sound/core/hrtimer.c
+++ b/sound/core/hrtimer.c
@@ -57,7 +57,6 @@ static int snd_hrtimer_open(struct snd_timer *t)
 		return -ENOMEM;
 	hrtimer_init(&stime->hrt, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	stime->timer = t;
-	stime->hrt.cb_mode = HRTIMER_CB_IRQSAFE_UNLOCKED;
 	stime->hrt.function = snd_hrtimer_callback;
 	t->private_data = stime;
 	return 0;
diff --git a/sound/drivers/pcsp/pcsp.c b/sound/drivers/pcsp/pcsp.c
index 2a02f70..a4049eb 100644
--- a/sound/drivers/pcsp/pcsp.c
+++ b/sound/drivers/pcsp/pcsp.c
@@ -96,7 +96,6 @@ static int __devinit snd_card_pcsp_probe(int devnum, struct device *dev)
 		return -EINVAL;
 
 	hrtimer_init(&pcsp_chip.timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	pcsp_chip.timer.cb_mode = HRTIMER_CB_IRQSAFE_UNLOCKED;
 	pcsp_chip.timer.function = pcsp_do_timer;
 
 	card = snd_card_new(index, id, THIS_MODULE, 0);
