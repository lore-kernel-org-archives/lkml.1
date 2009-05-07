Return-Path: <linux-kernel-owner+w=401wt.eu-S1760486AbZEGArb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760486AbZEGArb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 20:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbZEGArV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 20:47:21 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:42549 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbZEGArU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 20:47:20 -0400
Subject: Re: [PATCH] Sanity check sysfs clocksource changes
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0905050839560.3375@localhost.localdomain>
References: <1239759163.6064.25.camel@localhost>
	 <1239759251.6064.27.camel@localhost> <1239759393.6064.30.camel@localhost>
	 <20090501131006.fa631417.akpm@linux-foundation.org>
	 <1241493035.7444.115.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0905050839560.3375@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 06 May 2009 17:47:10 -0700
Message-Id: <1241657230.7396.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-05 at 08:48 +0200, Thomas Gleixner wrote:
> On Mon, 4 May 2009, john stultz wrote:
> >  
> > -static inline int hrtimer_hres_active(void) { return 0; }
> > +int hrtimer_hres_active(void) { return 0; }
> 
> We want to keep that static inline and move it to hrtimer.h to allow
> gcc to optimize stuff out.


Ok. I'm assuming you just wanted the return 0 case moved to hrtimer.h,
as moving the other would require moving the hrtimer_base defines out as
well.

Let me know if this works for you.

thanks
-john




Hey all,
        Thomas, Andrew and Ingo pointed out that we don't have any
safety checks in the clocksource sysfs entries to make sure sysadmins
don't try to change the clocksource to a non high-res timer capable
clocksource (such as jiffies) when high-res timers (HRT) is enabled.
Doing so will likely hang a system.

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

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 0d2f7c8..88c7578 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -260,6 +260,7 @@ static inline int hrtimer_is_hres_active(struct hrtimer *timer)
 	return timer->base->cpu_base->hres_active;
 }
 
+extern int hrtimer_hres_active(void);
 extern void hrtimer_peek_ahead_timers(void);
 
 /*
@@ -301,6 +302,11 @@ static inline int hrtimer_is_hres_active(struct hrtimer *timer)
 {
 	return 0;
 }
+
+static inline int hrtimer_hres_active(void)
+{
+	return 0;
+}
 #endif
 
 extern ktime_t ktime_get(void);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index cb8a15c..2f83247 100644
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
@@ -704,7 +704,6 @@ static int hrtimer_switch_to_hres(void)
 
 #else
 
-static inline int hrtimer_hres_active(void) { return 0; }
 static inline int hrtimer_is_hres_enabled(void) { return 0; }
 static inline int hrtimer_switch_to_hres(void) { return 0; }
 static inline void hrtimer_force_reprogram(struct hrtimer_cpu_base *base) { }
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index ecfd7b5..27dff34 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/sched.h> /* for spin_unlock_irq() using preempt_count() m68k */
 #include <linux/tick.h>
+#include <linux/hrtimer.h>
 
 void timecounter_init(struct timecounter *tc,
 		      const struct cyclecounter *cc,
@@ -512,6 +513,17 @@ static ssize_t sysfs_override_clocksource(struct sys_device *dev,
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
@@ -540,7 +552,10 @@ sysfs_show_available_clocksources(struct sys_device *dev,
 
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


