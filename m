Return-Path: <linux-kernel-owner+w=401wt.eu-S1759635AbZFOOHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635AbZFOOHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbZFOOHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:07:09 -0400
Received: from www.tglx.de ([62.245.132.106]:50184 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757262AbZFOOHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:07:08 -0400
Date: Mon, 15 Jun 2009 16:06:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] clocksource updates for 2.6.31
Message-ID: <alpine.LFD.2.00.0906151453310.2800@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-for-linus-clocksource git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus-clocksource

Thanks,

	tglx

------------------>
John Stultz (1):
      clocksource: sanity check sysfs clocksource changes

Thomas Gleixner (1):
      clocksource: prevent selection of low resolution clocksourse also for nohz=on


 include/linux/tick.h       |    3 +++
 kernel/time/clocksource.c  |   20 +++++++++++++++++++-
 kernel/time/tick-oneshot.c |   17 +++++++++++++++++
 3 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 469b82d..0482229 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -97,10 +97,12 @@ extern void tick_clock_notify(void);
 extern int tick_check_oneshot_change(int allow_nohz);
 extern struct tick_sched *tick_get_tick_sched(int cpu);
 extern void tick_check_idle(int cpu);
+extern int tick_oneshot_mode_active(void);
 # else
 static inline void tick_clock_notify(void) { }
 static inline int tick_check_oneshot_change(int allow_nohz) { return 0; }
 static inline void tick_check_idle(int cpu) { }
+static inline int tick_oneshot_mode_active(void) { return 0; }
 # endif
 
 #else /* CONFIG_GENERIC_CLOCKEVENTS */
@@ -109,6 +111,7 @@ static inline void tick_cancel_sched_timer(int cpu) { }
 static inline void tick_clock_notify(void) { }
 static inline int tick_check_oneshot_change(int allow_nohz) { return 0; }
 static inline void tick_check_idle(int cpu) { }
+static inline int tick_oneshot_mode_active(void) { return 0; }
 #endif /* !CONFIG_GENERIC_CLOCKEVENTS */
 
 # ifdef CONFIG_NO_HZ
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 80189f6..592bf58 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -509,6 +509,18 @@ static ssize_t sysfs_override_clocksource(struct sys_device *dev,
 		}
 	}
 
+	/*
+	 * Check to make sure we don't switch to a non-highres capable
+	 * clocksource if the tick code is in oneshot mode (highres or nohz)
+	 */
+	if (tick_oneshot_mode_active() &&
+	    !(ovr->flags & CLOCK_SOURCE_VALID_FOR_HRES)) {
+		printk(KERN_WARNING "%s clocksource is not HRT compatible. "
+			"Cannot switch while in HRT/NOHZ mode\n", ovr->name);
+		ovr = NULL;
+		override_name[0] = 0;
+	}
+
 	/* Reselect, when the override name has changed */
 	if (ovr != clocksource_override) {
 		clocksource_override = ovr;
@@ -537,7 +549,13 @@ sysfs_show_available_clocksources(struct sys_device *dev,
 
 	spin_lock_irq(&clocksource_lock);
 	list_for_each_entry(src, &clocksource_list, list) {
-		count += snprintf(buf + count,
+		/*
+		 * Don't show non-HRES clocksource if the tick code is
+		 * in one shot mode (highres=on or nohz=on)
+		 */
+		if (!tick_oneshot_mode_active() ||
+		    (src->flags & CLOCK_SOURCE_VALID_FOR_HRES))
+			count += snprintf(buf + count,
 				  max((ssize_t)PAGE_SIZE - count, (ssize_t)0),
 				  "%s ", src->name);
 	}
diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
index 2e8de67..a96c0e2 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -128,6 +128,23 @@ int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *))
 	return 0;
 }
 
+/**
+ * tick_check_oneshot_mode - check whether the system is in oneshot mode
+ *
+ * returns 1 when either nohz or highres are enabled. otherwise 0.
+ */
+int tick_oneshot_mode_active(void)
+{
+	unsigned long flags;
+	int ret;
+
+	local_irq_save(flags);
+	ret = __get_cpu_var(tick_cpu_device).mode == TICKDEV_MODE_ONESHOT;
+	local_irq_restore(flags);
+
+	return ret;
+}
+
 #ifdef CONFIG_HIGH_RES_TIMERS
 /**
  * tick_init_highres - switch to high resolution mode
