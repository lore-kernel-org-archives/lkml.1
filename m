Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbZEEDOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbZEEDOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 23:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbZEEDOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 23:14:09 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40695 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbZEEDOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 23:14:06 -0400
Subject: [PATCH] Sanity check sysfs clocksource changes
From: john stultz <johnstul@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090501131006.fa631417.akpm@linux-foundation.org>
References: <1239759163.6064.25.camel@localhost>
	 <1239759251.6064.27.camel@localhost> <1239759393.6064.30.camel@localhost>
	 <20090501131006.fa631417.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 04 May 2009 20:10:35 -0700
Message-Id: <1241493035.7444.115.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-01 at 13:10 -0700, Andrew Morton wrote:
> What's the status of
> clocksource-sanity-check-sysfs-clocksource-changes.patch, btw?  I have
> it marked as "still an RFC", but it's been sitting here since January?

Thanks for reminding me! I lost track of that one. Still waiting on
feedback from Thomas.

Thomas? What do you think? Original patch below, applies with fuzz and
builds.

-john


Hey all,
	Thomas, Andrew and Ingo pointed out that we don't have any safety
checks in the clocksource sysfs entries to make sure sysadmins don't try
to change the clocksource to a non high-res timer capable clocksource
(such as jiffies) when high-res timers (HRT) is enabled. Doing so will
likely hang a system.

This patch tries to correct this by filtering non HRT clocksources from
available_clocksources and not accepting non HRT clocksources with HRT
is is enabled.

This has been lightly tested, and seems to work, but there may be some
drawbacks.

One issue I realized was that when TSCs disqualified, they are marked as
not CLOCK_SOURCE_VALID_FOR_HRES. This means on boxes with unsycned TSCs,
the only available clocksource may be the slower acpi_pm and the user
will not be able to override it with the TSC as is currently possible.
(even if that seems ill-advised).

So Thomas, what do you think? Should we just use
CLOCK_SOURCE_IS_CONTINUOUS flag or is CLOCK_SOURCE_VALID_FOR_HRES really
what we want?

Signed-off-by: John Stultz <johnstul@us.ibm.com>


diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index bd37078..05f67f0 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -305,7 +305,7 @@ static inline int hrtimer_is_hres_active(struct hrtimer *timer)
 
 extern ktime_t ktime_get(void);
 extern ktime_t ktime_get_real(void);
-
+extern int hrtimer_hres_active(void);
 
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 2dc30c5..fa4abdc 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -476,7 +476,7 @@ static inline int hrtimer_is_hres_enabled(void)
 /*
  * Is the high resolution mode active ?
  */
-static inline int hrtimer_hres_active(void)
+int hrtimer_hres_active(void)
 {
 	return __get_cpu_var(hrtimer_bases).hres_active;
 }
@@ -689,7 +689,7 @@ static int hrtimer_switch_to_hres(void)
 
 #else
 
-static inline int hrtimer_hres_active(void) { return 0; }
+int hrtimer_hres_active(void) { return 0; }
 static inline int hrtimer_is_hres_enabled(void) { return 0; }
 static inline int hrtimer_switch_to_hres(void) { return 0; }
 static inline void hrtimer_force_reprogram(struct hrtimer_cpu_base *base) { }
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index ca89e15..1bb1161 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/sched.h> /* for spin_unlock_irq() using preempt_count() m68k */
 #include <linux/tick.h>
+#include <linux/hrtimer.h>
 
 /* XXX - Would like a better way for initializing curr_clocksource */
 extern struct clocksource clocksource_jiffies;
@@ -436,6 +437,17 @@ static ssize_t sysfs_override_clocksource(struct sys_device *dev,
 		}
 	}
 
+	/* Check to make sure we don't switch to a non-HRT usable
+	 * clocksource if HRT is enabled and running
+	 */
+	if (hrtimer_hres_active() &&
+	    !(ovr->flags & CLOCK_SOURCE_VALID_FOR_HRES)) {
+		printk(KERN_WARNING "%s clocksource is not HRT compatible. "
+			"Cannot switch while in HRT mode\n", ovr->name);
+		ovr = NULL;
+		override_name[0] = 0;
+	}
+
 	/* Reselect, when the override name has changed */
 	if (ovr != clocksource_override) {
 		clocksource_override = ovr;
@@ -464,7 +476,10 @@ sysfs_show_available_clocksources(struct sys_device *dev,
 
 	spin_lock_irq(&clocksource_lock);
 	list_for_each_entry(src, &clocksource_list, list) {
-		count += snprintf(buf + count,
+		/* Don't show non-HRES clocksource if HRES is enabled */
+		if (!hrtimer_hres_active() ||
+				(src->flags & CLOCK_SOURCE_VALID_FOR_HRES))
+			count += snprintf(buf + count,
 				  max((ssize_t)PAGE_SIZE - count, (ssize_t)0),
 				  "%s ", src->name);
 	}




