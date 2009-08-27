Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbZH0V4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbZH0V4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 17:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZH0V4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 17:56:18 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46467 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbZH0V4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 17:56:17 -0400
X-IronPort-AV: E=McAfee;i="5300,2777,5722"; a="22757647"
Message-ID: <4A970103.7010804@codeaurora.org>
Date: Thu, 27 Aug 2009 17:56:19 -0400
From: Ashwin Chaugule <ashwinc@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
Subject: Re: [RFC] [PATCH 1/1] hrtimers: Cache next hrtimer
References: <4A96FFE9.6060105@codeaurora.org>
In-Reply-To: <4A96FFE9.6060105@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending. This time with patch inlined.

 From 6558900969ef1f4492aad4d9a2a87cd8900dee92 Mon Sep 17 00:00:00 2001
From: Ashwin Chaugule <ashwinc@quicinc.com>
Date: Thu, 27 Aug 2009 10:42:48 -0400
Subject: [PATCH][hrtimers]  Cache next hrtimer

    Cached the hrtimer which causes the expire_next
    value to change. This is to avoid unnecessary re-programming
    of the clock events device.

    modified:   include/linux/hrtimer.h
    modified:   kernel/hrtimer.c

    Signed-off-by: Ashwin Chaugule <ashwinc@quicinc.com>
---
 include/linux/hrtimer.h |    5 ++-
 kernel/hrtimer.c        |   81 
+++++++++++++++++++++++++++++++---------------
 2 files changed, 58 insertions(+), 28 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index bd37078..dd8fa9b 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -4,7 +4,8 @@
  *  hrtimers - High-resolution kernel timers
  *
  *   Copyright(C) 2005, Thomas Gleixner <tglx@linutronix.de>
- *   Copyright(C) 2005, Red Hat, Inc., Ingo Molnar
+ *   Copyright(C) 2005, Red Hat, Inc., Ingo Molnar
+ *   Copyright(C) 2009, Code Aurora Forum. All rights reserved.
  *
  *  data type definitions, declarations, prototypes
  *
@@ -157,6 +158,7 @@ struct hrtimer_clock_base {
  *            and timers
  * @clock_base:        array of clock bases for this cpu
  * @curr_timer:        the timer which is executing a callback right now
+ * @next_hrtimer:    the hrtimer that caused expires_next to change
  * @expires_next:    absolute time of the next event which was scheduled
  *            via clock_set_next_event()
  * @hres_active:    State of high resolution mode
@@ -169,6 +171,7 @@ struct hrtimer_cpu_base {
     spinlock_t            lock;
     struct hrtimer_clock_base    clock_base[HRTIMER_MAX_CLOCK_BASES];
 #ifdef CONFIG_HIGH_RES_TIMERS
+    struct hrtimer             *next_hrtimer;
     ktime_t                expires_next;
     int                hres_active;
     unsigned long            nr_events;
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index f394d2a..d823987 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -4,6 +4,8 @@
  *  Copyright(C) 2005-2006, Thomas Gleixner <tglx@linutronix.de>
  *  Copyright(C) 2005-2007, Red Hat, Inc., Ingo Molnar
  *  Copyright(C) 2006-2007  Timesys Corp., Thomas Gleixner
+ *  Copyright(C) 2009, Code Aurora Forum. All rights reserved.
+ *
  *
  *  High-resolution kernel timers
  *
@@ -508,8 +510,10 @@ static void hrtimer_force_reprogram(struct 
hrtimer_cpu_base *cpu_base)
          */
         if (expires.tv64 < 0)
             expires.tv64 = 0;
-        if (expires.tv64 < cpu_base->expires_next.tv64)
+        if (expires.tv64 < cpu_base->expires_next.tv64) {
             cpu_base->expires_next = expires;
+            cpu_base->next_hrtimer = timer;
+        }
     }
 
     if (cpu_base->expires_next.tv64 != KTIME_MAX)
@@ -529,6 +533,7 @@ static int hrtimer_reprogram(struct hrtimer *timer,
                  struct hrtimer_clock_base *base)
 {
     ktime_t *expires_next = &__get_cpu_var(hrtimer_bases).expires_next;
+    struct hrtimer *next_hrtimer = 
__get_cpu_var(hrtimer_bases).next_hrtimer;
     ktime_t expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
     int res;
 
@@ -560,8 +565,10 @@ static int hrtimer_reprogram(struct hrtimer *timer,
      * Clockevents returns -ETIME, when the event was in the past.
      */
     res = tick_program_event(expires, 0);
-    if (!IS_ERR_VALUE(res))
+    if (!IS_ERR_VALUE(res)) {
         *expires_next = expires;
+        next_hrtimer = timer;
+    }
     return res;
 }
 
@@ -634,6 +641,7 @@ static inline void hrtimer_init_hres(struct 
hrtimer_cpu_base *base)
 {
     base->expires_next.tv64 = KTIME_MAX;
     base->hres_active = 0;
+    base->next_hrtimer = NULL;
 }
 
 /*
@@ -843,16 +851,20 @@ static void __remove_hrtimer(struct hrtimer *timer,
                  struct hrtimer_clock_base *base,
                  unsigned long newstate, int reprogram)
 {
-    if (timer->state & HRTIMER_STATE_ENQUEUED) {
+    struct hrtimer *next_hrtimer = 
__get_cpu_var(hrtimer_bases).next_hrtimer;
+
+    if (hrtimer_is_queued(timer)) {
         /*
          * Remove the timer from the rbtree and replace the
          * first entry pointer if necessary.
          */
         if (base->first == &timer->node) {
             base->first = rb_next(&timer->node);
-            /* Reprogram the clock event device. if enabled */
-            if (reprogram && hrtimer_hres_active())
-                hrtimer_force_reprogram(base->cpu_base);
+            if (next_hrtimer == timer) {
+                /* Reprogram the clock event device. if enabled */
+                if (reprogram && hrtimer_hres_active())
+                    hrtimer_force_reprogram(base->cpu_base);
+            }
         }
         rb_erase(&timer->node, &base->active);
     }
@@ -865,25 +877,22 @@ static void __remove_hrtimer(struct hrtimer *timer,
 static inline int
 remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
 {
-    if (hrtimer_is_queued(timer)) {
-        int reprogram;
+    int reprogram;
 
-        /*
-         * Remove the timer and force reprogramming when high
-         * resolution mode is active and the timer is on the current
-         * CPU. If we remove a timer on another CPU, reprogramming is
-         * skipped. The interrupt event on this CPU is fired and
-         * reprogramming happens in the interrupt handler. This is a
-         * rare case and less expensive than a smp call.
-         */
-        debug_hrtimer_deactivate(timer);
-        timer_stats_hrtimer_clear_start_info(timer);
-        reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
-        __remove_hrtimer(timer, base, HRTIMER_STATE_INACTIVE,
-                 reprogram);
-        return 1;
-    }
-    return 0;
+    /*
+     * Remove the timer and force reprogramming when high
+     * resolution mode is active and the timer is on the current
+     * CPU. If we remove a timer on another CPU, reprogramming is
+     * skipped. The interrupt event on this CPU is fired and
+     * reprogramming happens in the interrupt handler. This is a
+     * rare case and less expensive than a smp call.
+     */
+    debug_hrtimer_deactivate(timer);
+    timer_stats_hrtimer_clear_start_info(timer);
+    reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
+    __remove_hrtimer(timer, base, HRTIMER_STATE_INACTIVE,
+            reprogram);
+    return 1;
 }
 
 /**
@@ -903,12 +912,26 @@ hrtimer_start_range_ns(struct hrtimer *timer, 
ktime_t tim, unsigned long delta_n
 {
     struct hrtimer_clock_base *base, *new_base;
     unsigned long flags;
-    int ret, leftmost;
+    int ret = 0;
+        int leftmost;
 
     base = lock_hrtimer_base(timer, &flags);
 
     /* Remove an active timer from the queue: */
-    ret = remove_hrtimer(timer, base);
+    if (hrtimer_is_queued(timer)) {
+        if (timer == __get_cpu_var(hrtimer_bases).next_hrtimer)
+            ret = remove_hrtimer(timer, base);
+        else {
+            debug_hrtimer_deactivate(timer);
+            timer_stats_hrtimer_clear_start_info(timer);
+            if (base->first == &timer->node) {
+                base->first = rb_next(&timer->node);
+            }
+            rb_erase(&timer->node, &base->active);
+            timer->state = HRTIMER_STATE_INACTIVE;
+            ret = 1;
+        }
+    }
 
     /* Switch the timer base, if necessary: */
     new_base = switch_hrtimer_base(timer, base);
@@ -1196,6 +1219,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 {
     struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
     struct hrtimer_clock_base *base;
+    struct hrtimer *next_hrtimer = NULL;
     ktime_t expires_next, now;
     int nr_retries = 0;
     int i;
@@ -1246,8 +1270,10 @@ void hrtimer_interrupt(struct clock_event_device 
*dev)
 
                 expires = ktime_sub(hrtimer_get_expires(timer),
                             base->offset);
-                if (expires.tv64 < expires_next.tv64)
+                if (expires.tv64 < expires_next.tv64) {
                     expires_next = expires;
+                    next_hrtimer = timer;
+                }
                 break;
             }
 
@@ -1258,6 +1284,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
     }
 
     cpu_base->expires_next = expires_next;
+    cpu_base->next_hrtimer = next_hrtimer;
 
     /* Reprogramming necessary ? */
     if (expires_next.tv64 != KTIME_MAX) {
-- 
1.5.6.3

