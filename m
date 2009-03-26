Return-Path: <linux-kernel-owner+w=401wt.eu-S1758830AbZCZPPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830AbZCZPPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 11:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbZCZPPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 11:15:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40016 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbZCZPPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 11:15:19 -0400
Date: Thu, 26 Mar 2009 16:15:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] timer updates for v2.6.30
Message-ID: <20090326151501.GA31093@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus

Highlights:

 - New mod_timer_pending() timer_list API requested by the 
   networking folks.

 - HPET ICH10 enablement and general debuggability improvements and 
   fixlets.

 - NTP code cleanups and fixlets.

Risks:

 - There were no unusual trouble spots during development and there
   are no open regressions.

 - The ICH10 force-enable hpet change brings regression risks on
   such systems and the NTP changes have regression risks too.

 Thanks,

	Ingo

------------------>
Andi Kleen (1):
      x86: hpet: allow force enable on ICH10 HPET

Andreas Herrmann (3):
      x86: hpet: print HPET registers during setup (if hpet=verbose is used)
      x86: hpet: provide separate functions to stop and start the counter
      x86: hpet: stop HPET_COUNTER when programming periodic mode

Frederic Weisbecker (1):
      hrtimers: increase clock min delta threshold while interrupt hanging

Ingo Molnar (15):
      timers: add mod_timer_pending()
      time: ntp: clean up kernel/time/ntp.c
      time: ntp: simplify the second_overflow() code flow
      time: ntp: simplify the MAX_TICKADJ_SCALED definition
      time: ntp: clean up ntp_update_frequency()
      time: ntp: refactor up ntp_update_frequency()
      time: ntp: refactor and clean up ntp_update_offset()
      time: ntp: simplify ntp_update_offset_fll()
      time: ntp: micro-optimize ntp_update_offset()
      time: ntp: fix bug in ntp_update_offset() & do_adjtimex()
      time: ntp: refactor do_adjtimex()
      time: ntp: refactor do_adjtimex() some more
      time: ntp: make 64-bit constants more robust
      time: ntp: simplify ntp_tick_adj calculations
      time: ntp: clean up second_overflow()

John Stultz (2):
      time: apply NTP frequency/tick changes immediately
      time: ntp: fix bug in ntp_update_offset() & do_adjtimex(), fix

Magnus Damm (1):
      clockevents: let set_mode() setup delta information

Oleg Nesterov (1):
      posix timers: fix RLIMIT_CPU && fork()

Sebastien Dugue (1):
      hrtimers: allow the hot-unplugging of all cpus

Thomas Gleixner (1):
      hrtimer: prevent negative expiry value after clock_was_set()


 Documentation/kernel-parameters.txt        |    4 +-
 arch/powerpc/platforms/cell/spufs/sched.c  |    2 +-
 arch/x86/kernel/hpet.c                     |   80 ++++-
 arch/x86/kernel/quirks.c                   |    3 +-
 drivers/infiniband/hw/ipath/ipath_driver.c |    6 +-
 include/linux/timer.h                      |   22 +--
 include/linux/timex.h                      |    2 +-
 kernel/posix-cpu-timers.c                  |    3 +-
 kernel/relay.c                             |    2 +-
 kernel/time/clockevents.c                  |   20 +-
 kernel/time/ntp.c                          |  444 +++++++++++++++++-----------
 kernel/timer.c                             |  110 +++++---
 12 files changed, 437 insertions(+), 261 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 54f21a5..46d11a9 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -492,10 +492,12 @@ and is between 256 and 4096 characters. It is defined in the file
 			Default: 64
 
 	hpet=		[X86-32,HPET] option to control HPET usage
-			Format: { enable (default) | disable | force }
+			Format: { enable (default) | disable | force |
+				verbose }
 			disable: disable HPET and use PIT instead
 			force: allow force enabled of undocumented chips (ICH4,
 			VIA, nVidia)
+			verbose: show contents of HPET registers during setup
 
 	com20020=	[HW,NET] ARCnet - COM20020 chipset
 			Format:
diff --git a/arch/powerpc/platforms/cell/spufs/sched.c b/arch/powerpc/platforms/cell/spufs/sched.c
index 6a0ad19..f085369 100644
--- a/arch/powerpc/platforms/cell/spufs/sched.c
+++ b/arch/powerpc/platforms/cell/spufs/sched.c
@@ -508,7 +508,7 @@ static void __spu_add_to_rq(struct spu_context *ctx)
 		list_add_tail(&ctx->rq, &spu_prio->runq[ctx->prio]);
 		set_bit(ctx->prio, spu_prio->bitmap);
 		if (!spu_prio->nr_waiting++)
-			__mod_timer(&spusched_timer, jiffies + SPUSCHED_TICK);
+			mod_timer(&spusched_timer, jiffies + SPUSCHED_TICK);
 	}
 }
 
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index a00545f..648b3a2 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -80,6 +80,7 @@ static inline void hpet_clear_mapping(void)
  */
 static int boot_hpet_disable;
 int hpet_force_user;
+static int hpet_verbose;
 
 static int __init hpet_setup(char *str)
 {
@@ -88,6 +89,8 @@ static int __init hpet_setup(char *str)
 			boot_hpet_disable = 1;
 		if (!strncmp("force", str, 5))
 			hpet_force_user = 1;
+		if (!strncmp("verbose", str, 7))
+			hpet_verbose = 1;
 	}
 	return 1;
 }
@@ -119,6 +122,43 @@ int is_hpet_enabled(void)
 }
 EXPORT_SYMBOL_GPL(is_hpet_enabled);
 
+static void _hpet_print_config(const char *function, int line)
+{
+	u32 i, timers, l, h;
+	printk(KERN_INFO "hpet: %s(%d):\n", function, line);
+	l = hpet_readl(HPET_ID);
+	h = hpet_readl(HPET_PERIOD);
+	timers = ((l & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT) + 1;
+	printk(KERN_INFO "hpet: ID: 0x%x, PERIOD: 0x%x\n", l, h);
+	l = hpet_readl(HPET_CFG);
+	h = hpet_readl(HPET_STATUS);
+	printk(KERN_INFO "hpet: CFG: 0x%x, STATUS: 0x%x\n", l, h);
+	l = hpet_readl(HPET_COUNTER);
+	h = hpet_readl(HPET_COUNTER+4);
+	printk(KERN_INFO "hpet: COUNTER_l: 0x%x, COUNTER_h: 0x%x\n", l, h);
+
+	for (i = 0; i < timers; i++) {
+		l = hpet_readl(HPET_Tn_CFG(i));
+		h = hpet_readl(HPET_Tn_CFG(i)+4);
+		printk(KERN_INFO "hpet: T%d: CFG_l: 0x%x, CFG_h: 0x%x\n",
+		       i, l, h);
+		l = hpet_readl(HPET_Tn_CMP(i));
+		h = hpet_readl(HPET_Tn_CMP(i)+4);
+		printk(KERN_INFO "hpet: T%d: CMP_l: 0x%x, CMP_h: 0x%x\n",
+		       i, l, h);
+		l = hpet_readl(HPET_Tn_ROUTE(i));
+		h = hpet_readl(HPET_Tn_ROUTE(i)+4);
+		printk(KERN_INFO "hpet: T%d ROUTE_l: 0x%x, ROUTE_h: 0x%x\n",
+		       i, l, h);
+	}
+}
+
+#define hpet_print_config()					\
+do {								\
+	if (hpet_verbose)					\
+		_hpet_print_config(__FUNCTION__, __LINE__);	\
+} while (0)
+
 /*
  * When the hpet driver (/dev/hpet) is enabled, we need to reserve
  * timer 0 and timer 1 in case of RTC emulation.
@@ -191,27 +231,37 @@ static struct clock_event_device hpet_clockevent = {
 	.rating		= 50,
 };
 
-static void hpet_start_counter(void)
+static void hpet_stop_counter(void)
 {
 	unsigned long cfg = hpet_readl(HPET_CFG);
-
 	cfg &= ~HPET_CFG_ENABLE;
 	hpet_writel(cfg, HPET_CFG);
 	hpet_writel(0, HPET_COUNTER);
 	hpet_writel(0, HPET_COUNTER + 4);
+}
+
+static void hpet_start_counter(void)
+{
+	unsigned long cfg = hpet_readl(HPET_CFG);
 	cfg |= HPET_CFG_ENABLE;
 	hpet_writel(cfg, HPET_CFG);
 }
 
+static void hpet_restart_counter(void)
+{
+	hpet_stop_counter();
+	hpet_start_counter();
+}
+
 static void hpet_resume_device(void)
 {
 	force_hpet_resume();
 }
 
-static void hpet_restart_counter(void)
+static void hpet_resume_counter(void)
 {
 	hpet_resume_device();
-	hpet_start_counter();
+	hpet_restart_counter();
 }
 
 static void hpet_enable_legacy_int(void)
@@ -259,29 +309,23 @@ static int hpet_setup_msi_irq(unsigned int irq);
 static void hpet_set_mode(enum clock_event_mode mode,
 			  struct clock_event_device *evt, int timer)
 {
-	unsigned long cfg, cmp, now;
+	unsigned long cfg;
 	uint64_t delta;
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
+		hpet_stop_counter();
 		delta = ((uint64_t)(NSEC_PER_SEC/HZ)) * evt->mult;
 		delta >>= evt->shift;
-		now = hpet_readl(HPET_COUNTER);
-		cmp = now + (unsigned long) delta;
 		cfg = hpet_readl(HPET_Tn_CFG(timer));
 		/* Make sure we use edge triggered interrupts */
 		cfg &= ~HPET_TN_LEVEL;
 		cfg |= HPET_TN_ENABLE | HPET_TN_PERIODIC |
 		       HPET_TN_SETVAL | HPET_TN_32BIT;
 		hpet_writel(cfg, HPET_Tn_CFG(timer));
-		/*
-		 * The first write after writing TN_SETVAL to the
-		 * config register sets the counter value, the second
-		 * write sets the period.
-		 */
-		hpet_writel(cmp, HPET_Tn_CMP(timer));
-		udelay(1);
 		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
+		hpet_start_counter();
+		hpet_print_config();
 		break;
 
 	case CLOCK_EVT_MODE_ONESHOT:
@@ -308,6 +352,7 @@ static void hpet_set_mode(enum clock_event_mode mode,
 			irq_set_affinity(hdev->irq, cpumask_of(hdev->cpu));
 			enable_irq(hdev->irq);
 		}
+		hpet_print_config();
 		break;
 	}
 }
@@ -526,6 +571,7 @@ static void hpet_msi_capability_lookup(unsigned int start_timer)
 
 	num_timers = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT);
 	num_timers++; /* Value read out starts from 0 */
+	hpet_print_config();
 
 	hpet_devs = kzalloc(sizeof(struct hpet_dev) * num_timers, GFP_KERNEL);
 	if (!hpet_devs)
@@ -695,7 +741,7 @@ static struct clocksource clocksource_hpet = {
 	.mask		= HPET_MASK,
 	.shift		= HPET_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
-	.resume		= hpet_restart_counter,
+	.resume		= hpet_resume_counter,
 #ifdef CONFIG_X86_64
 	.vread		= vread_hpet,
 #endif
@@ -707,7 +753,7 @@ static int hpet_clocksource_register(void)
 	cycle_t t1;
 
 	/* Start the counter */
-	hpet_start_counter();
+	hpet_restart_counter();
 
 	/* Verify whether hpet counter works */
 	t1 = read_hpet();
@@ -793,6 +839,7 @@ int __init hpet_enable(void)
 	 * information and the number of channels
 	 */
 	id = hpet_readl(HPET_ID);
+	hpet_print_config();
 
 #ifdef CONFIG_HPET_EMULATE_RTC
 	/*
@@ -845,6 +892,7 @@ static __init int hpet_late_init(void)
 		return -ENODEV;
 
 	hpet_reserve_platform_timers(hpet_readl(HPET_ID));
+	hpet_print_config();
 
 	for_each_online_cpu(cpu) {
 		hpet_cpuhp_notify(NULL, CPU_ONLINE, (void *)(long)cpu);
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 309949e..697d1b7 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -172,7 +172,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_4,
 			 ich_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH9_7,
 			 ich_force_enable_hpet);
-
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x3a16,	/* ICH10 */
+			 ich_force_enable_hpet);
 
 static struct pci_dev *cached_dev;
 
diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index 69c0ce3..cb9daa6 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -2715,7 +2715,7 @@ static void ipath_hol_signal_up(struct ipath_devdata *dd)
  * to prevent HoL blocking, then start the HoL timer that
  * periodically continues, then stop procs, so they can detect
  * link down if they want, and do something about it.
- * Timer may already be running, so use __mod_timer, not add_timer.
+ * Timer may already be running, so use mod_timer, not add_timer.
  */
 void ipath_hol_down(struct ipath_devdata *dd)
 {
@@ -2724,7 +2724,7 @@ void ipath_hol_down(struct ipath_devdata *dd)
 	dd->ipath_hol_next = IPATH_HOL_DOWNCONT;
 	dd->ipath_hol_timer.expires = jiffies +
 		msecs_to_jiffies(ipath_hol_timeout_ms);
-	__mod_timer(&dd->ipath_hol_timer, dd->ipath_hol_timer.expires);
+	mod_timer(&dd->ipath_hol_timer, dd->ipath_hol_timer.expires);
 }
 
 /*
@@ -2763,7 +2763,7 @@ void ipath_hol_event(unsigned long opaque)
 	else {
 		dd->ipath_hol_timer.expires = jiffies +
 			msecs_to_jiffies(ipath_hol_timeout_ms);
-		__mod_timer(&dd->ipath_hol_timer,
+		mod_timer(&dd->ipath_hol_timer,
 			dd->ipath_hol_timer.expires);
 	}
 }
diff --git a/include/linux/timer.h b/include/linux/timer.h
index daf9685..e2d662e 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -86,8 +86,8 @@ static inline int timer_pending(const struct timer_list * timer)
 
 extern void add_timer_on(struct timer_list *timer, int cpu);
 extern int del_timer(struct timer_list * timer);
-extern int __mod_timer(struct timer_list *timer, unsigned long expires);
 extern int mod_timer(struct timer_list *timer, unsigned long expires);
+extern int mod_timer_pending(struct timer_list *timer, unsigned long expires);
 
 /*
  * The jiffies value which is added to now, when there is no timer
@@ -146,25 +146,7 @@ static inline void timer_stats_timer_clear_start_info(struct timer_list *timer)
 }
 #endif
 
-/**
- * add_timer - start a timer
- * @timer: the timer to be added
- *
- * The kernel will do a ->function(->data) callback from the
- * timer interrupt at the ->expires point in the future. The
- * current time is 'jiffies'.
- *
- * The timer's ->expires, ->function (and if the handler uses it, ->data)
- * fields must be set prior calling this function.
- *
- * Timers with an ->expires field in the past will be executed in the next
- * timer tick.
- */
-static inline void add_timer(struct timer_list *timer)
-{
-	BUG_ON(timer_pending(timer));
-	__mod_timer(timer, timer->expires);
-}
+extern void add_timer(struct timer_list *timer);
 
 #ifdef CONFIG_SMP
   extern int try_to_del_timer_sync(struct timer_list *timer);
diff --git a/include/linux/timex.h b/include/linux/timex.h
index 998a55d..aa3475f 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -190,7 +190,7 @@ struct timex {
  * offset and maximum frequency tolerance.
  */
 #define SHIFT_USEC 16		/* frequency offset scale (shift) */
-#define PPM_SCALE (NSEC_PER_USEC << (NTP_SCALE_SHIFT - SHIFT_USEC))
+#define PPM_SCALE ((s64)NSEC_PER_USEC << (NTP_SCALE_SHIFT - SHIFT_USEC))
 #define PPM_SCALE_INV_SHIFT 19
 #define PPM_SCALE_INV ((1ll << (PPM_SCALE_INV_SHIFT + NTP_SCALE_SHIFT)) / \
 		       PPM_SCALE + 1)
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index e976e50..8e5d9a6 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1370,7 +1370,8 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
 		if (task_cputime_expired(&group_sample, &sig->cputime_expires))
 			return 1;
 	}
-	return 0;
+
+	return sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY;
 }
 
 /*
diff --git a/kernel/relay.c b/kernel/relay.c
index 9d79b78..8f2179c 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -750,7 +750,7 @@ size_t relay_switch_subbuf(struct rchan_buf *buf, size_t length)
 			 * from the scheduler (trying to re-grab
 			 * rq->lock), so defer it.
 			 */
-			__mod_timer(&buf->timer, jiffies + 1);
+			mod_timer(&buf->timer, jiffies + 1);
 	}
 
 	old = buf->data;
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index ea2f48a..d13be21 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -68,6 +68,17 @@ void clockevents_set_mode(struct clock_event_device *dev,
 	if (dev->mode != mode) {
 		dev->set_mode(mode, dev);
 		dev->mode = mode;
+
+		/*
+		 * A nsec2cyc multiplicator of 0 is invalid and we'd crash
+		 * on it, so fix it up and emit a warning:
+		 */
+		if (mode == CLOCK_EVT_MODE_ONESHOT) {
+			if (unlikely(!dev->mult)) {
+				dev->mult = 1;
+				WARN_ON(1);
+			}
+		}
 	}
 }
 
@@ -168,15 +179,6 @@ void clockevents_register_device(struct clock_event_device *dev)
 	BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
 	BUG_ON(!dev->cpumask);
 
-	/*
-	 * A nsec2cyc multiplicator of 0 is invalid and we'd crash
-	 * on it, so fix it up and emit a warning:
-	 */
-	if (unlikely(!dev->mult)) {
-		dev->mult = 1;
-		WARN_ON(1);
-	}
-
 	spin_lock(&clockevents_lock);
 
 	list_add(&dev->list, &clockevent_devices);
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index f5f793d..7fc6437 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -1,71 +1,129 @@
 /*
- * linux/kernel/time/ntp.c
- *
  * NTP state machine interfaces and logic.
  *
  * This code was mainly moved from kernel/timer.c and kernel/time.c
  * Please see those files for relevant copyright info and historical
  * changelogs.
  */
-
-#include <linux/mm.h>
-#include <linux/time.h>
-#include <linux/timex.h>
-#include <linux/jiffies.h>
-#include <linux/hrtimer.h>
 #include <linux/capability.h>
-#include <linux/math64.h>
 #include <linux/clocksource.h>
 #include <linux/workqueue.h>
-#include <asm/timex.h>
+#include <linux/hrtimer.h>
+#include <linux/jiffies.h>
+#include <linux/math64.h>
+#include <linux/timex.h>
+#include <linux/time.h>
+#include <linux/mm.h>
 
 /*
- * Timekeeping variables
+ * NTP timekeeping variables:
  */
-unsigned long tick_usec = TICK_USEC; 		/* USER_HZ period (usec) */
-unsigned long tick_nsec;			/* ACTHZ period (nsec) */
-u64 tick_length;
-static u64 tick_length_base;
 
-static struct hrtimer leap_timer;
+/* USER_HZ period (usecs): */
+unsigned long			tick_usec = TICK_USEC;
 
-#define MAX_TICKADJ		500		/* microsecs */
-#define MAX_TICKADJ_SCALED	(((u64)(MAX_TICKADJ * NSEC_PER_USEC) << \
-				  NTP_SCALE_SHIFT) / NTP_INTERVAL_FREQ)
+/* ACTHZ period (nsecs): */
+unsigned long			tick_nsec;
+
+u64				tick_length;
+static u64			tick_length_base;
+
+static struct hrtimer		leap_timer;
+
+#define MAX_TICKADJ		500LL		/* usecs */
+#define MAX_TICKADJ_SCALED \
+	(((MAX_TICKADJ * NSEC_PER_USEC) << NTP_SCALE_SHIFT) / NTP_INTERVAL_FREQ)
 
 /*
  * phase-lock loop variables
  */
-/* TIME_ERROR prevents overwriting the CMOS clock */
-static int time_state = TIME_OK;	/* clock synchronization status	*/
-int time_status = STA_UNSYNC;		/* clock status bits		*/
-static long time_tai;			/* TAI offset (s)		*/
-static s64 time_offset;			/* time adjustment (ns)		*/
-static long time_constant = 2;		/* pll time constant		*/
-long time_maxerror = NTP_PHASE_LIMIT;	/* maximum error (us)		*/
-long time_esterror = NTP_PHASE_LIMIT;	/* estimated error (us)		*/
-static s64 time_freq;			/* frequency offset (scaled ns/s)*/
-static long time_reftime;		/* time at last adjustment (s)	*/
-long time_adjust;
-static long ntp_tick_adj;
 
+/*
+ * clock synchronization status
+ *
+ * (TIME_ERROR prevents overwriting the CMOS clock)
+ */
+static int			time_state = TIME_OK;
+
+/* clock status bits:							*/
+int				time_status = STA_UNSYNC;
+
+/* TAI offset (secs):							*/
+static long			time_tai;
+
+/* time adjustment (nsecs):						*/
+static s64			time_offset;
+
+/* pll time constant:							*/
+static long			time_constant = 2;
+
+/* maximum error (usecs):						*/
+long				time_maxerror = NTP_PHASE_LIMIT;
+
+/* estimated error (usecs):						*/
+long				time_esterror = NTP_PHASE_LIMIT;
+
+/* frequency offset (scaled nsecs/secs):				*/
+static s64			time_freq;
+
+/* time at last adjustment (secs):					*/
+static long			time_reftime;
+
+long				time_adjust;
+
+/* constant (boot-param configurable) NTP tick adjustment (upscaled)	*/
+static s64			ntp_tick_adj;
+
+/*
+ * NTP methods:
+ */
+
+/*
+ * Update (tick_length, tick_length_base, tick_nsec), based
+ * on (tick_usec, ntp_tick_adj, time_freq):
+ */
 static void ntp_update_frequency(void)
 {
-	u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
-				<< NTP_SCALE_SHIFT;
-	second_length += (s64)ntp_tick_adj << NTP_SCALE_SHIFT;
-	second_length += time_freq;
+	u64 second_length;
+	u64 new_base;
+
+	second_length		 = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
+						<< NTP_SCALE_SHIFT;
+
+	second_length		+= ntp_tick_adj;
+	second_length		+= time_freq;
 
-	tick_length_base = second_length;
+	tick_nsec		 = div_u64(second_length, HZ) >> NTP_SCALE_SHIFT;
+	new_base		 = div_u64(second_length, NTP_INTERVAL_FREQ);
 
-	tick_nsec = div_u64(second_length, HZ) >> NTP_SCALE_SHIFT;
-	tick_length_base = div_u64(tick_length_base, NTP_INTERVAL_FREQ);
+	/*
+	 * Don't wait for the next second_overflow, apply
+	 * the change to the tick length immediately:
+	 */
+	tick_length		+= new_base - tick_length_base;
+	tick_length_base	 = new_base;
+}
+
+static inline s64 ntp_update_offset_fll(s64 offset64, long secs)
+{
+	time_status &= ~STA_MODE;
+
+	if (secs < MINSEC)
+		return 0;
+
+	if (!(time_status & STA_FLL) && (secs <= MAXSEC))
+		return 0;
+
+	time_status |= STA_MODE;
+
+	return div_s64(offset64 << (NTP_SCALE_SHIFT - SHIFT_FLL), secs);
 }
 
 static void ntp_update_offset(long offset)
 {
-	long mtemp;
 	s64 freq_adj;
+	s64 offset64;
+	long secs;
 
 	if (!(time_status & STA_PLL))
 		return;
@@ -84,24 +142,23 @@ static void ntp_update_offset(long offset)
 	 * Select how the frequency is to be controlled
 	 * and in which mode (PLL or FLL).
 	 */
-	if (time_status & STA_FREQHOLD || time_reftime == 0)
-		time_reftime = xtime.tv_sec;
-	mtemp = xtime.tv_sec - time_reftime;
+	secs = xtime.tv_sec - time_reftime;
+	if (unlikely(time_status & STA_FREQHOLD))
+		secs = 0;
+
 	time_reftime = xtime.tv_sec;
 
-	freq_adj = (s64)offset * mtemp;
-	freq_adj <<= NTP_SCALE_SHIFT - 2 * (SHIFT_PLL + 2 + time_constant);
-	time_status &= ~STA_MODE;
-	if (mtemp >= MINSEC && (time_status & STA_FLL || mtemp > MAXSEC)) {
-		freq_adj += div_s64((s64)offset << (NTP_SCALE_SHIFT - SHIFT_FLL),
-				    mtemp);
-		time_status |= STA_MODE;
-	}
-	freq_adj += time_freq;
-	freq_adj = min(freq_adj, MAXFREQ_SCALED);
-	time_freq = max(freq_adj, -MAXFREQ_SCALED);
+	offset64    = offset;
+	freq_adj    = (offset64 * secs) <<
+			(NTP_SCALE_SHIFT - 2 * (SHIFT_PLL + 2 + time_constant));
 
-	time_offset = div_s64((s64)offset << NTP_SCALE_SHIFT, NTP_INTERVAL_FREQ);
+	freq_adj    += ntp_update_offset_fll(offset64, secs);
+
+	freq_adj    = min(freq_adj + time_freq, MAXFREQ_SCALED);
+
+	time_freq   = max(freq_adj, -MAXFREQ_SCALED);
+
+	time_offset = div_s64(offset64 << NTP_SCALE_SHIFT, NTP_INTERVAL_FREQ);
 }
 
 /**
@@ -111,15 +168,15 @@ static void ntp_update_offset(long offset)
  */
 void ntp_clear(void)
 {
-	time_adjust = 0;		/* stop active adjtime() */
-	time_status |= STA_UNSYNC;
-	time_maxerror = NTP_PHASE_LIMIT;
-	time_esterror = NTP_PHASE_LIMIT;
+	time_adjust	= 0;		/* stop active adjtime() */
+	time_status	|= STA_UNSYNC;
+	time_maxerror	= NTP_PHASE_LIMIT;
+	time_esterror	= NTP_PHASE_LIMIT;
 
 	ntp_update_frequency();
 
-	tick_length = tick_length_base;
-	time_offset = 0;
+	tick_length	= tick_length_base;
+	time_offset	= 0;
 }
 
 /*
@@ -140,8 +197,8 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 		xtime.tv_sec--;
 		wall_to_monotonic.tv_sec++;
 		time_state = TIME_OOP;
-		printk(KERN_NOTICE "Clock: "
-		       "inserting leap second 23:59:60 UTC\n");
+		printk(KERN_NOTICE
+			"Clock: inserting leap second 23:59:60 UTC\n");
 		hrtimer_add_expires_ns(&leap_timer, NSEC_PER_SEC);
 		res = HRTIMER_RESTART;
 		break;
@@ -150,8 +207,8 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 		time_tai--;
 		wall_to_monotonic.tv_sec--;
 		time_state = TIME_WAIT;
-		printk(KERN_NOTICE "Clock: "
-		       "deleting leap second 23:59:59 UTC\n");
+		printk(KERN_NOTICE
+			"Clock: deleting leap second 23:59:59 UTC\n");
 		break;
 	case TIME_OOP:
 		time_tai++;
@@ -179,7 +236,7 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
  */
 void second_overflow(void)
 {
-	s64 time_adj;
+	s64 delta;
 
 	/* Bump the maxerror field */
 	time_maxerror += MAXFREQ / NSEC_PER_USEC;
@@ -192,24 +249,30 @@ void second_overflow(void)
 	 * Compute the phase adjustment for the next second. The offset is
 	 * reduced by a fixed factor times the time constant.
 	 */
-	tick_length = tick_length_base;
-	time_adj = shift_right(time_offset, SHIFT_PLL + time_constant);
-	time_offset -= time_adj;
-	tick_length += time_adj;
-
-	if (unlikely(time_adjust)) {
-		if (time_adjust > MAX_TICKADJ) {
-			time_adjust -= MAX_TICKADJ;
-			tick_length += MAX_TICKADJ_SCALED;
-		} else if (time_adjust < -MAX_TICKADJ) {
-			time_adjust += MAX_TICKADJ;
-			tick_length -= MAX_TICKADJ_SCALED;
-		} else {
-			tick_length += (s64)(time_adjust * NSEC_PER_USEC /
-					NTP_INTERVAL_FREQ) << NTP_SCALE_SHIFT;
-			time_adjust = 0;
-		}
+	tick_length	 = tick_length_base;
+
+	delta		 = shift_right(time_offset, SHIFT_PLL + time_constant);
+	time_offset	-= delta;
+	tick_length	+= delta;
+
+	if (!time_adjust)
+		return;
+
+	if (time_adjust > MAX_TICKADJ) {
+		time_adjust -= MAX_TICKADJ;
+		tick_length += MAX_TICKADJ_SCALED;
+		return;
 	}
+
+	if (time_adjust < -MAX_TICKADJ) {
+		time_adjust += MAX_TICKADJ;
+		tick_length -= MAX_TICKADJ_SCALED;
+		return;
+	}
+
+	tick_length += (s64)(time_adjust * NSEC_PER_USEC / NTP_INTERVAL_FREQ)
+							 << NTP_SCALE_SHIFT;
+	time_adjust = 0;
 }
 
 #ifdef CONFIG_GENERIC_CMOS_UPDATE
@@ -233,12 +296,13 @@ static void sync_cmos_clock(struct work_struct *work)
 	 * This code is run on a timer.  If the clock is set, that timer
 	 * may not expire at the correct time.  Thus, we adjust...
 	 */
-	if (!ntp_synced())
+	if (!ntp_synced()) {
 		/*
 		 * Not synced, exit, do not restart a timer (if one is
 		 * running, let it run out).
 		 */
 		return;
+	}
 
 	getnstimeofday(&now);
 	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2)
@@ -270,7 +334,116 @@ static void notify_cmos_timer(void)
 static inline void notify_cmos_timer(void) { }
 #endif
 
-/* adjtimex mainly allows reading (and writing, if superuser) of
+/*
+ * Start the leap seconds timer:
+ */
+static inline void ntp_start_leap_timer(struct timespec *ts)
+{
+	long now = ts->tv_sec;
+
+	if (time_status & STA_INS) {
+		time_state = TIME_INS;
+		now += 86400 - now % 86400;
+		hrtimer_start(&leap_timer, ktime_set(now, 0), HRTIMER_MODE_ABS);
+
+		return;
+	}
+
+	if (time_status & STA_DEL) {
+		time_state = TIME_DEL;
+		now += 86400 - (now + 1) % 86400;
+		hrtimer_start(&leap_timer, ktime_set(now, 0), HRTIMER_MODE_ABS);
+	}
+}
+
+/*
+ * Propagate a new txc->status value into the NTP state:
+ */
+static inline void process_adj_status(struct timex *txc, struct timespec *ts)
+{
+	if ((time_status & STA_PLL) && !(txc->status & STA_PLL)) {
+		time_state = TIME_OK;
+		time_status = STA_UNSYNC;
+	}
+
+	/*
+	 * If we turn on PLL adjustments then reset the
+	 * reference time to current time.
+	 */
+	if (!(time_status & STA_PLL) && (txc->status & STA_PLL))
+		time_reftime = xtime.tv_sec;
+
+	/* only set allowed bits */
+	time_status &= STA_RONLY;
+	time_status |= txc->status & ~STA_RONLY;
+
+	switch (time_state) {
+	case TIME_OK:
+		ntp_start_leap_timer(ts);
+		break;
+	case TIME_INS:
+	case TIME_DEL:
+		time_state = TIME_OK;
+		ntp_start_leap_timer(ts);
+	case TIME_WAIT:
+		if (!(time_status & (STA_INS | STA_DEL)))
+			time_state = TIME_OK;
+		break;
+	case TIME_OOP:
+		hrtimer_restart(&leap_timer);
+		break;
+	}
+}
+/*
+ * Called with the xtime lock held, so we can access and modify
+ * all the global NTP state:
+ */
+static inline void process_adjtimex_modes(struct timex *txc, struct timespec *ts)
+{
+	if (txc->modes & ADJ_STATUS)
+		process_adj_status(txc, ts);
+
+	if (txc->modes & ADJ_NANO)
+		time_status |= STA_NANO;
+
+	if (txc->modes & ADJ_MICRO)
+		time_status &= ~STA_NANO;
+
+	if (txc->modes & ADJ_FREQUENCY) {
+		time_freq = txc->freq * PPM_SCALE;
+		time_freq = min(time_freq, MAXFREQ_SCALED);
+		time_freq = max(time_freq, -MAXFREQ_SCALED);
+	}
+
+	if (txc->modes & ADJ_MAXERROR)
+		time_maxerror = txc->maxerror;
+
+	if (txc->modes & ADJ_ESTERROR)
+		time_esterror = txc->esterror;
+
+	if (txc->modes & ADJ_TIMECONST) {
+		time_constant = txc->constant;
+		if (!(time_status & STA_NANO))
+			time_constant += 4;
+		time_constant = min(time_constant, (long)MAXTC);
+		time_constant = max(time_constant, 0l);
+	}
+
+	if (txc->modes & ADJ_TAI && txc->constant > 0)
+		time_tai = txc->constant;
+
+	if (txc->modes & ADJ_OFFSET)
+		ntp_update_offset(txc->offset);
+
+	if (txc->modes & ADJ_TICK)
+		tick_usec = txc->tick;
+
+	if (txc->modes & (ADJ_TICK|ADJ_FREQUENCY|ADJ_OFFSET))
+		ntp_update_frequency();
+}
+
+/*
+ * adjtimex mainly allows reading (and writing, if superuser) of
  * kernel time-keeping variables. used by xntpd.
  */
 int do_adjtimex(struct timex *txc)
@@ -291,11 +464,14 @@ int do_adjtimex(struct timex *txc)
 		 if (txc->modes && !capable(CAP_SYS_TIME))
 			return -EPERM;
 
-		/* if the quartz is off by more than 10% something is VERY wrong! */
+		/*
+		 * if the quartz is off by more than 10% then
+		 * something is VERY wrong!
+		 */
 		if (txc->modes & ADJ_TICK &&
 		    (txc->tick <  900000/USER_HZ ||
 		     txc->tick > 1100000/USER_HZ))
-				return -EINVAL;
+			return -EINVAL;
 
 		if (txc->modes & ADJ_STATUS && time_state != TIME_OK)
 			hrtimer_cancel(&leap_timer);
@@ -305,7 +481,6 @@ int do_adjtimex(struct timex *txc)
 
 	write_seqlock_irq(&xtime_lock);
 
-	/* If there are input parameters, then process them */
 	if (txc->modes & ADJ_ADJTIME) {
 		long save_adjust = time_adjust;
 
@@ -315,98 +490,24 @@ int do_adjtimex(struct timex *txc)
 			ntp_update_frequency();
 		}
 		txc->offset = save_adjust;
-		goto adj_done;
-	}
-	if (txc->modes) {
-		long sec;
-
-		if (txc->modes & ADJ_STATUS) {
-			if ((time_status & STA_PLL) &&
-			    !(txc->status & STA_PLL)) {
-				time_state = TIME_OK;
-				time_status = STA_UNSYNC;
-			}
-			/* only set allowed bits */
-			time_status &= STA_RONLY;
-			time_status |= txc->status & ~STA_RONLY;
-
-			switch (time_state) {
-			case TIME_OK:
-			start_timer:
-				sec = ts.tv_sec;
-				if (time_status & STA_INS) {
-					time_state = TIME_INS;
-					sec += 86400 - sec % 86400;
-					hrtimer_start(&leap_timer, ktime_set(sec, 0), HRTIMER_MODE_ABS);
-				} else if (time_status & STA_DEL) {
-					time_state = TIME_DEL;
-					sec += 86400 - (sec + 1) % 86400;
-					hrtimer_start(&leap_timer, ktime_set(sec, 0), HRTIMER_MODE_ABS);
-				}
-				break;
-			case TIME_INS:
-			case TIME_DEL:
-				time_state = TIME_OK;
-				goto start_timer;
-				break;
-			case TIME_WAIT:
-				if (!(time_status & (STA_INS | STA_DEL)))
-					time_state = TIME_OK;
-				break;
-			case TIME_OOP:
-				hrtimer_restart(&leap_timer);
-				break;
-			}
-		}
-
-		if (txc->modes & ADJ_NANO)
-			time_status |= STA_NANO;
-		if (txc->modes & ADJ_MICRO)
-			time_status &= ~STA_NANO;
-
-		if (txc->modes & ADJ_FREQUENCY) {
-			time_freq = (s64)txc->freq * PPM_SCALE;
-			time_freq = min(time_freq, MAXFREQ_SCALED);
-			time_freq = max(time_freq, -MAXFREQ_SCALED);
-		}
-
-		if (txc->modes & ADJ_MAXERROR)
-			time_maxerror = txc->maxerror;
-		if (txc->modes & ADJ_ESTERROR)
-			time_esterror = txc->esterror;
-
-		if (txc->modes & ADJ_TIMECONST) {
-			time_constant = txc->constant;
-			if (!(time_status & STA_NANO))
-				time_constant += 4;
-			time_constant = min(time_constant, (long)MAXTC);
-			time_constant = max(time_constant, 0l);
-		}
-
-		if (txc->modes & ADJ_TAI && txc->constant > 0)
-			time_tai = txc->constant;
-
-		if (txc->modes & ADJ_OFFSET)
-			ntp_update_offset(txc->offset);
-		if (txc->modes & ADJ_TICK)
-			tick_usec = txc->tick;
+	} else {
 
-		if (txc->modes & (ADJ_TICK|ADJ_FREQUENCY|ADJ_OFFSET))
-			ntp_update_frequency();
-	}
+		/* If there are input parameters, then process them: */
+		if (txc->modes)
+			process_adjtimex_modes(txc, &ts);
 
-	txc->offset = shift_right(time_offset * NTP_INTERVAL_FREQ,
+		txc->offset = shift_right(time_offset * NTP_INTERVAL_FREQ,
 				  NTP_SCALE_SHIFT);
-	if (!(time_status & STA_NANO))
-		txc->offset /= NSEC_PER_USEC;
+		if (!(time_status & STA_NANO))
+			txc->offset /= NSEC_PER_USEC;
+	}
 
-adj_done:
 	result = time_state;	/* mostly `TIME_OK' */
 	if (time_status & (STA_UNSYNC|STA_CLOCKERR))
 		result = TIME_ERROR;
 
 	txc->freq	   = shift_right((time_freq >> PPM_SCALE_INV_SHIFT) *
-					 (s64)PPM_SCALE_INV, NTP_SCALE_SHIFT);
+					 PPM_SCALE_INV, NTP_SCALE_SHIFT);
 	txc->maxerror	   = time_maxerror;
 	txc->esterror	   = time_esterror;
 	txc->status	   = time_status;
@@ -425,6 +526,7 @@ adj_done:
 	txc->calcnt	   = 0;
 	txc->errcnt	   = 0;
 	txc->stbcnt	   = 0;
+
 	write_sequnlock_irq(&xtime_lock);
 
 	txc->time.tv_sec = ts.tv_sec;
@@ -440,6 +542,8 @@ adj_done:
 static int __init ntp_tick_adj_setup(char *str)
 {
 	ntp_tick_adj = simple_strtol(str, NULL, 0);
+	ntp_tick_adj <<= NTP_SCALE_SHIFT;
+
 	return 1;
 }
 
diff --git a/kernel/timer.c b/kernel/timer.c
index 13dd64f..9b77fc9 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -589,11 +589,14 @@ static struct tvec_base *lock_timer_base(struct timer_list *timer,
 	}
 }
 
-int __mod_timer(struct timer_list *timer, unsigned long expires)
+static inline int
+__mod_timer(struct timer_list *timer, unsigned long expires, bool pending_only)
 {
 	struct tvec_base *base, *new_base;
 	unsigned long flags;
-	int ret = 0;
+	int ret;
+
+	ret = 0;
 
 	timer_stats_timer_set_start_info(timer);
 	BUG_ON(!timer->function);
@@ -603,6 +606,9 @@ int __mod_timer(struct timer_list *timer, unsigned long expires)
 	if (timer_pending(timer)) {
 		detach_timer(timer, 0);
 		ret = 1;
+	} else {
+		if (pending_only)
+			goto out_unlock;
 	}
 
 	debug_timer_activate(timer);
@@ -629,42 +635,28 @@ int __mod_timer(struct timer_list *timer, unsigned long expires)
 
 	timer->expires = expires;
 	internal_add_timer(base, timer);
+
+out_unlock:
 	spin_unlock_irqrestore(&base->lock, flags);
 
 	return ret;
 }
 
-EXPORT_SYMBOL(__mod_timer);
-
 /**
- * add_timer_on - start a timer on a particular CPU
- * @timer: the timer to be added
- * @cpu: the CPU to start it on
+ * mod_timer_pending - modify a pending timer's timeout
+ * @timer: the pending timer to be modified
+ * @expires: new timeout in jiffies
  *
- * This is not very scalable on SMP. Double adds are not possible.
+ * mod_timer_pending() is the same for pending timers as mod_timer(),
+ * but will not re-activate and modify already deleted timers.
+ *
+ * It is useful for unserialized use of timers.
  */
-void add_timer_on(struct timer_list *timer, int cpu)
+int mod_timer_pending(struct timer_list *timer, unsigned long expires)
 {
-	struct tvec_base *base = per_cpu(tvec_bases, cpu);
-	unsigned long flags;
-
-	timer_stats_timer_set_start_info(timer);
-	BUG_ON(timer_pending(timer) || !timer->function);
-	spin_lock_irqsave(&base->lock, flags);
-	timer_set_base(timer, base);
-	debug_timer_activate(timer);
-	internal_add_timer(base, timer);
-	/*
-	 * Check whether the other CPU is idle and needs to be
-	 * triggered to reevaluate the timer wheel when nohz is
-	 * active. We are protected against the other CPU fiddling
-	 * with the timer by holding the timer base lock. This also
-	 * makes sure that a CPU on the way to idle can not evaluate
-	 * the timer wheel.
-	 */
-	wake_up_idle_cpu(cpu);
-	spin_unlock_irqrestore(&base->lock, flags);
+	return __mod_timer(timer, expires, true);
 }
+EXPORT_SYMBOL(mod_timer_pending);
 
 /**
  * mod_timer - modify a timer's timeout
@@ -688,9 +680,6 @@ void add_timer_on(struct timer_list *timer, int cpu)
  */
 int mod_timer(struct timer_list *timer, unsigned long expires)
 {
-	BUG_ON(!timer->function);
-
-	timer_stats_timer_set_start_info(timer);
 	/*
 	 * This is a common optimization triggered by the
 	 * networking code - if the timer is re-modified
@@ -699,12 +688,62 @@ int mod_timer(struct timer_list *timer, unsigned long expires)
 	if (timer->expires == expires && timer_pending(timer))
 		return 1;
 
-	return __mod_timer(timer, expires);
+	return __mod_timer(timer, expires, false);
 }
-
 EXPORT_SYMBOL(mod_timer);
 
 /**
+ * add_timer - start a timer
+ * @timer: the timer to be added
+ *
+ * The kernel will do a ->function(->data) callback from the
+ * timer interrupt at the ->expires point in the future. The
+ * current time is 'jiffies'.
+ *
+ * The timer's ->expires, ->function (and if the handler uses it, ->data)
+ * fields must be set prior calling this function.
+ *
+ * Timers with an ->expires field in the past will be executed in the next
+ * timer tick.
+ */
+void add_timer(struct timer_list *timer)
+{
+	BUG_ON(timer_pending(timer));
+	mod_timer(timer, timer->expires);
+}
+EXPORT_SYMBOL(add_timer);
+
+/**
+ * add_timer_on - start a timer on a particular CPU
+ * @timer: the timer to be added
+ * @cpu: the CPU to start it on
+ *
+ * This is not very scalable on SMP. Double adds are not possible.
+ */
+void add_timer_on(struct timer_list *timer, int cpu)
+{
+	struct tvec_base *base = per_cpu(tvec_bases, cpu);
+	unsigned long flags;
+
+	timer_stats_timer_set_start_info(timer);
+	BUG_ON(timer_pending(timer) || !timer->function);
+	spin_lock_irqsave(&base->lock, flags);
+	timer_set_base(timer, base);
+	debug_timer_activate(timer);
+	internal_add_timer(base, timer);
+	/*
+	 * Check whether the other CPU is idle and needs to be
+	 * triggered to reevaluate the timer wheel when nohz is
+	 * active. We are protected against the other CPU fiddling
+	 * with the timer by holding the timer base lock. This also
+	 * makes sure that a CPU on the way to idle can not evaluate
+	 * the timer wheel.
+	 */
+	wake_up_idle_cpu(cpu);
+	spin_unlock_irqrestore(&base->lock, flags);
+}
+
+/**
  * del_timer - deactive a timer.
  * @timer: the timer to be deactivated
  *
@@ -733,7 +772,6 @@ int del_timer(struct timer_list *timer)
 
 	return ret;
 }
-
 EXPORT_SYMBOL(del_timer);
 
 #ifdef CONFIG_SMP
@@ -767,7 +805,6 @@ out:
 
 	return ret;
 }
-
 EXPORT_SYMBOL(try_to_del_timer_sync);
 
 /**
@@ -796,7 +833,6 @@ int del_timer_sync(struct timer_list *timer)
 		cpu_relax();
 	}
 }
-
 EXPORT_SYMBOL(del_timer_sync);
 #endif
 
@@ -1268,7 +1304,7 @@ signed long __sched schedule_timeout(signed long timeout)
 	expire = timeout + jiffies;
 
 	setup_timer_on_stack(&timer, process_timeout, (unsigned long)current);
-	__mod_timer(&timer, expire);
+	__mod_timer(&timer, expire, false);
 	schedule();
 	del_singleshot_timer_sync(&timer);
 
