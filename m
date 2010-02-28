Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030320Ab0B1QSg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 11:18:36 -0500
Received: from www.tglx.de ([62.245.132.106]:45805 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964812Ab0B1QSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 11:18:35 -0500
Date: Sun, 28 Feb 2010 17:18:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] timers for 2.6.34
Message-ID: <alpine.LFD.2.00.1002281717350.4245@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus

Thanks,

	tglx

------------------>
H Hartley Sweeten (1):
      posix-timers.c: Don't export local functions

John Stultz (2):
      ntp: Make time_esterror and time_maxerror static
      ntp: Cleanup xtime references in ntp.c

Magnus Damm (3):
      clocksource: add argument to resume callback
      clocksource: add suspend callback
      clocksource: start CMT at clocksource resume


 arch/ia64/kernel/time.c      |    2 +-
 arch/x86/kernel/hpet.c       |    2 +-
 arch/x86/kernel/tsc.c        |    2 +-
 drivers/clocksource/sh_cmt.c |   35 +++++++----------------------------
 include/linux/clocksource.h  |    5 ++++-
 include/linux/timex.h        |    3 ---
 kernel/posix-timers.c        |    2 +-
 kernel/time/clocksource.c    |   14 +++++++++++++-
 kernel/time/ntp.c            |   10 +++++-----
 kernel/time/timekeeping.c    |    1 +
 10 files changed, 34 insertions(+), 42 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index a35c661..47a1927 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -61,7 +61,7 @@ unsigned long long sched_clock(void)
 
 #ifdef CONFIG_PARAVIRT
 static void
-paravirt_clocksource_resume(void)
+paravirt_clocksource_resume(struct clocksource *cs)
 {
 	if (pv_time_ops.clocksource_resume)
 		pv_time_ops.clocksource_resume();
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index ad80a1c..ee4fa1b 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -266,7 +266,7 @@ static void hpet_resume_device(void)
 	force_hpet_resume();
 }
 
-static void hpet_resume_counter(void)
+static void hpet_resume_counter(struct clocksource *cs)
 {
 	hpet_resume_device();
 	hpet_restart_counter();
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 597683a..9eeb9be 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -740,7 +740,7 @@ static cycle_t __vsyscall_fn vread_tsc(void)
 }
 #endif
 
-static void resume_tsc(void)
+static void resume_tsc(struct clocksource *cs)
 {
 	clocksource_tsc.cycle_last = 0;
 }
diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 6b3e0c2..27efe08 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -40,7 +40,6 @@ struct sh_cmt_priv {
 	struct platform_device *pdev;
 
 	unsigned long flags;
-	unsigned long flags_suspend;
 	unsigned long match_value;
 	unsigned long next_match_value;
 	unsigned long max_match_value;
@@ -432,6 +431,11 @@ static void sh_cmt_clocksource_disable(struct clocksource *cs)
 	sh_cmt_stop(cs_to_sh_cmt(cs), FLAG_CLOCKSOURCE);
 }
 
+static void sh_cmt_clocksource_resume(struct clocksource *cs)
+{
+	sh_cmt_start(cs_to_sh_cmt(cs), FLAG_CLOCKSOURCE);
+}
+
 static int sh_cmt_register_clocksource(struct sh_cmt_priv *p,
 				       char *name, unsigned long rating)
 {
@@ -442,6 +446,8 @@ static int sh_cmt_register_clocksource(struct sh_cmt_priv *p,
 	cs->read = sh_cmt_clocksource_read;
 	cs->enable = sh_cmt_clocksource_enable;
 	cs->disable = sh_cmt_clocksource_disable;
+	cs->suspend = sh_cmt_clocksource_disable;
+	cs->resume = sh_cmt_clocksource_resume;
 	cs->mask = CLOCKSOURCE_MASK(sizeof(unsigned long) * 8);
 	cs->flags = CLOCK_SOURCE_IS_CONTINUOUS;
 	pr_info("sh_cmt: %s used as clock source\n", cs->name);
@@ -668,38 +674,11 @@ static int __devexit sh_cmt_remove(struct platform_device *pdev)
 	return -EBUSY; /* cannot unregister clockevent and clocksource */
 }
 
-static int sh_cmt_suspend(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct sh_cmt_priv *p = platform_get_drvdata(pdev);
-
-	/* save flag state and stop CMT channel */
-	p->flags_suspend = p->flags;
-	sh_cmt_stop(p, p->flags);
-	return 0;
-}
-
-static int sh_cmt_resume(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct sh_cmt_priv *p = platform_get_drvdata(pdev);
-
-	/* start CMT channel from saved state */
-	sh_cmt_start(p, p->flags_suspend);
-	return 0;
-}
-
-static struct dev_pm_ops sh_cmt_dev_pm_ops = {
-	.suspend = sh_cmt_suspend,
-	.resume = sh_cmt_resume,
-};
-
 static struct platform_driver sh_cmt_device_driver = {
 	.probe		= sh_cmt_probe,
 	.remove		= __devexit_p(sh_cmt_remove),
 	.driver		= {
 		.name	= "sh_cmt",
-		.pm	= &sh_cmt_dev_pm_ops,
 	}
 };
 
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 8a4a130..4bca8b6 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -154,6 +154,7 @@ extern u64 timecounter_cyc2time(struct timecounter *tc,
  * @max_idle_ns:	max idle time permitted by the clocksource (nsecs)
  * @flags:		flags describing special properties
  * @vread:		vsyscall based read
+ * @suspend:		suspend function for the clocksource, if necessary
  * @resume:		resume function for the clocksource, if necessary
  */
 struct clocksource {
@@ -172,7 +173,8 @@ struct clocksource {
 	u64 max_idle_ns;
 	unsigned long flags;
 	cycle_t (*vread)(void);
-	void (*resume)(void);
+	void (*suspend)(struct clocksource *cs);
+	void (*resume)(struct clocksource *cs);
 #ifdef CONFIG_IA64
 	void *fsys_mmio;        /* used by fsyscall asm code */
 #define CLKSRC_FSYS_MMIO_SET(mmio, addr)      ((mmio) = (addr))
@@ -277,6 +279,7 @@ extern void clocksource_unregister(struct clocksource*);
 extern void clocksource_touch_watchdog(void);
 extern struct clocksource* clocksource_get_next(void);
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
+extern void clocksource_suspend(void);
 extern void clocksource_resume(void);
 extern struct clocksource * __init __weak clocksource_default_clock(void);
 extern void clocksource_mark_unstable(struct clocksource *cs);
diff --git a/include/linux/timex.h b/include/linux/timex.h
index 94f8fae..7a082b3 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -238,9 +238,6 @@ extern int tickadj;			/* amount of adjustment per tick */
  * phase-lock loop variables
  */
 extern int time_status;		/* clock synchronization status bits */
-extern long time_maxerror;	/* maximum error */
-extern long time_esterror;	/* estimated error */
-
 extern long time_adjust;	/* The amount of adjtime left */
 
 extern void ntp_init(void);
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 4954407..00d1fda 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -256,7 +256,7 @@ static int posix_get_monotonic_coarse(clockid_t which_clock,
 	return 0;
 }
 
-int posix_get_coarse_res(const clockid_t which_clock, struct timespec *tp)
+static int posix_get_coarse_res(const clockid_t which_clock, struct timespec *tp)
 {
 	*tp = ktime_to_timespec(KTIME_LOW_RES);
 	return 0;
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index e85c234..bd24666 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -441,6 +441,18 @@ static inline int clocksource_watchdog_kthread(void *data) { return 0; }
 #endif /* CONFIG_CLOCKSOURCE_WATCHDOG */
 
 /**
+ * clocksource_suspend - suspend the clocksource(s)
+ */
+void clocksource_suspend(void)
+{
+	struct clocksource *cs;
+
+	list_for_each_entry_reverse(cs, &clocksource_list, list)
+		if (cs->suspend)
+			cs->suspend(cs);
+}
+
+/**
  * clocksource_resume - resume the clocksource(s)
  */
 void clocksource_resume(void)
@@ -449,7 +461,7 @@ void clocksource_resume(void)
 
 	list_for_each_entry(cs, &clocksource_list, list)
 		if (cs->resume)
-			cs->resume();
+			cs->resume(cs);
 
 	clocksource_resume_watchdog();
 }
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 4800f93..7c0f180 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -58,10 +58,10 @@ static s64			time_offset;
 static long			time_constant = 2;
 
 /* maximum error (usecs):						*/
-long				time_maxerror = NTP_PHASE_LIMIT;
+static long			time_maxerror = NTP_PHASE_LIMIT;
 
 /* estimated error (usecs):						*/
-long				time_esterror = NTP_PHASE_LIMIT;
+static long			time_esterror = NTP_PHASE_LIMIT;
 
 /* frequency offset (scaled nsecs/secs):				*/
 static s64			time_freq;
@@ -142,11 +142,11 @@ static void ntp_update_offset(long offset)
 	 * Select how the frequency is to be controlled
 	 * and in which mode (PLL or FLL).
 	 */
-	secs = xtime.tv_sec - time_reftime;
+	secs = get_seconds() - time_reftime;
 	if (unlikely(time_status & STA_FREQHOLD))
 		secs = 0;
 
-	time_reftime = xtime.tv_sec;
+	time_reftime = get_seconds();
 
 	offset64    = offset;
 	freq_adj    = (offset64 * secs) <<
@@ -368,7 +368,7 @@ static inline void process_adj_status(struct timex *txc, struct timespec *ts)
 	 * reference time to current time.
 	 */
 	if (!(time_status & STA_PLL) && (txc->status & STA_PLL))
-		time_reftime = xtime.tv_sec;
+		time_reftime = get_seconds();
 
 	/* only set allowed bits */
 	time_status &= STA_RONLY;
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 7faaa32..843d8a7 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -622,6 +622,7 @@ static int timekeeping_suspend(struct sys_device *dev, pm_message_t state)
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
+	clocksource_suspend();
 
 	return 0;
 }
