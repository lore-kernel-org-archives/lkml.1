Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbXLFMwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbXLFMwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbXLFMoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:44:00 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:53759 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbXLFMn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:43:57 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <4ee86e3bbe8494a2162c7d8c0fc0b109b5e37086.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2007 17:46:11 +0100
Subject: [PATCH 39/47] Update and improve CRISv32 fasttimer.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Change include path to machine dependent header files.
- Remove __INLINE__, it expands to inline anyway.
- Don't initialize static variables.
- Change timers to use fasttimer_t instead of timevals.
- Change name of timeval_cmp to fasttime_cmp to highlight this.
- Register name for first timer is regi_timer0, not regi_timer.
- Whitespace and formatting changes.
- Don't return if we're blocking interrupts, goto done and restore interrupts.
- Disable interrupts while walking the fasttimer list, only restore
  while doing the callback.
- Remove #ifdef DECLARE_WAITQUEUE, this code won't be used in another OS.
- Remove CVS log.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/kernel/fasttimer.c |  519 ++++++++++++--------------------
 1 files changed, 195 insertions(+), 324 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/fasttimer.c b/arch/cris/arch-v32/kernel/fasttimer.c
index b40551f..3051462 100644
--- a/arch/cris/arch-v32/kernel/fasttimer.c
+++ b/arch/cris/arch-v32/kernel/fasttimer.c
@@ -1,110 +1,9 @@
-/* $Id: fasttimer.c,v 1.11 2005/01/04 11:15:46 starvik Exp $
+/*
  * linux/arch/cris/kernel/fasttimer.c
  *
  * Fast timers for ETRAX FS
- * This may be useful in other OS than Linux so use 2 space indentation...
- *
- * $Log: fasttimer.c,v $
- * Revision 1.11  2005/01/04 11:15:46  starvik
- * Don't share timer IRQ.
- *
- * Revision 1.10  2004/12/07 09:19:38  starvik
- * Corrected includes.
- * Use correct interrupt macros.
- *
- * Revision 1.9  2004/05/14 10:18:58  starvik
- * Export fast_timer_list
- *
- * Revision 1.8  2004/05/14 07:58:03  starvik
- * Merge of changes from 2.4
- *
- * Revision 1.7  2003/07/10 12:06:14  starvik
- * Return IRQ_NONE if irq wasn't handled
- *
- * Revision 1.6  2003/07/04 08:27:49  starvik
- * Merge of Linux 2.5.74
- *
- * Revision 1.5  2003/06/05 10:16:22  johana
- * New INTR_VECT macros.
- *
- * Revision 1.4  2003/06/03 08:49:45  johana
- * Fixed typo.
- *
- * Revision 1.3  2003/06/02 12:51:27  johana
- * Now compiles.
- * Commented some include files that probably can be removed.
- *
- * Revision 1.2  2003/06/02 12:09:41  johana
- * Ported to ETRAX FS using the trig interrupt instead of timer1.
- *
- * Revision 1.3  2002/12/12 08:26:32  starvik
- * Don't use C-comments inside CVS comments
- *
- * Revision 1.2  2002/12/11 15:42:02  starvik
- * Extracted v10 (ETRAX 100LX) specific stuff from arch/cris/kernel/
- *
- * Revision 1.1  2002/11/18 07:58:06  starvik
- * Fast timers (from Linux 2.4)
  *
- * Revision 1.5  2002/10/15 06:21:39  starvik
- * Added call to init_waitqueue_head
- *
- * Revision 1.4  2002/05/28 17:47:59  johana
- * Added del_fast_timer()
- *
- * Revision 1.3  2002/05/28 16:16:07  johana
- * Handle empty fast_timer_list
- *
- * Revision 1.2  2002/05/27 15:38:42  johana
- * Made it compile without warnings on Linux 2.4.
- * (includes, wait_queue, PROC_FS and snprintf)
- *
- * Revision 1.1  2002/05/27 15:32:25  johana
- * arch/etrax100/kernel/fasttimer.c v1.8 from the elinux tree.
- *
- * Revision 1.8  2001/11/27 13:50:40  pkj
- * Disable interrupts while stopping the timer and while modifying the
- * list of active timers in timer1_handler() as it may be interrupted
- * by other interrupts (e.g., the serial interrupt) which may add fast
- * timers.
- *
- * Revision 1.7  2001/11/22 11:50:32  pkj
- * * Only store information about the last 16 timers.
- * * proc_fasttimer_read() now uses an allocated buffer, since it
- *   requires more space than just a page even for only writing the
- *   last 16 timers. The buffer is only allocated on request, so
- *   unless /proc/fasttimer is read, it is never allocated.
- * * Renamed fast_timer_started to fast_timers_started to match
- *   fast_timers_added and fast_timers_expired.
- * * Some clean-up.
- *
- * Revision 1.6  2000/12/13 14:02:08  johana
- * Removed volatile for fast_timer_list
- *
- * Revision 1.5  2000/12/13 13:55:35  johana
- * Added DEBUG_LOG, added som cli() and cleanup
- *
- * Revision 1.4  2000/12/05 13:48:50  johana
- * Added range check when writing proc file, modified timer int handling
- *
- * Revision 1.3  2000/11/23 10:10:20  johana
- * More debug/logging possibilities.
- * Moved GET_JIFFIES_USEC() to timex.h and time.c
- *
- * Revision 1.2  2000/11/01 13:41:04  johana
- * Clean up and bugfixes.
- * Created new do_gettimeofday_fast() that gets a timeval struct
- * with time based on jiffies and *R_TIMER0_DATA, uses a table
- * for fast conversion of timer value to microseconds.
- * (Much faster the standard do_gettimeofday() and we don't really
- * want to use the true time - we want the "uptime" so timers don't screw up
- * when we change the time.
- * TODO: Add efficient support for continuous timers as well.
- *
- * Revision 1.1  2000/10/26 15:49:16  johana
- * Added fasttimer, highresolution timers.
- *
- * Copyright (C) 2000,2001 2002, 2003 Axis Communications AB, Lund, Sweden
+ * Copyright (C) 2000-2006 Axis Communications AB, Lund, Sweden
  */
 
 #include <linux/errno.h>
@@ -122,9 +21,9 @@
 
 #include <linux/version.h>
 
-#include <asm/arch/hwregs/reg_map.h>
-#include <asm/arch/hwregs/reg_rdwr.h>
-#include <asm/arch/hwregs/timer_defs.h>
+#include <hwregs/reg_map.h>
+#include <hwregs/reg_rdwr.h>
+#include <hwregs/timer_defs.h>
 #include <asm/fasttimer.h>
 #include <linux/proc_fs.h>
 
@@ -140,7 +39,7 @@
 
 #define DEBUG_LOG_INCLUDED
 #define FAST_TIMER_LOG
-//#define FAST_TIMER_TEST
+/* #define FAST_TIMER_TEST */
 
 #define FAST_TIMER_SANITY_CHECKS
 
@@ -155,15 +54,13 @@ static int sanity_failed = 0;
 #define D2(x)
 #define DP(x)
 
-#define __INLINE__ inline
-
-static int fast_timer_running = 0;
-static int fast_timers_added = 0;
-static int fast_timers_started = 0;
-static int fast_timers_expired = 0;
-static int fast_timers_deleted = 0;
-static int fast_timer_is_init = 0;
-static int fast_timer_ints = 0;
+static unsigned int fast_timer_running;
+static unsigned int fast_timers_added;
+static unsigned int fast_timers_started;
+static unsigned int fast_timers_expired;
+static unsigned int fast_timers_deleted;
+static unsigned int fast_timer_is_init;
+static unsigned int fast_timer_ints;
 
 struct fast_timer *fast_timer_list = NULL;
 
@@ -171,8 +68,8 @@ struct fast_timer *fast_timer_list = NULL;
 #define DEBUG_LOG_MAX 128
 static const char * debug_log_string[DEBUG_LOG_MAX];
 static unsigned long debug_log_value[DEBUG_LOG_MAX];
-static int debug_log_cnt = 0;
-static int debug_log_cnt_wrapped = 0;
+static unsigned int debug_log_cnt;
+static unsigned int debug_log_cnt_wrapped;
 
 #define DEBUG_LOG(string, value) \
 { \
@@ -202,103 +99,92 @@ struct fast_timer timer_expired_log[NUM_TIMER_STATS];
 int timer_div_settings[NUM_TIMER_STATS];
 int timer_delay_settings[NUM_TIMER_STATS];
 
+struct work_struct fast_work;
 
 static void
-timer_trig_handler(void);
+timer_trig_handler(struct work_struct *work);
 
 
 
 /* Not true gettimeofday, only checks the jiffies (uptime) + useconds */
-void __INLINE__ do_gettimeofday_fast(struct timeval *tv)
+inline void do_gettimeofday_fast(struct fasttime_t *tv)
 {
-  unsigned long sec = jiffies;
-  unsigned long usec = GET_JIFFIES_USEC();
-
-  usec += (sec % HZ) * (1000000 / HZ);
-  sec = sec / HZ;
-
-  if (usec > 1000000)
-  {
-    usec -= 1000000;
-    sec++;
-  }
-  tv->tv_sec = sec;
-  tv->tv_usec = usec;
+	tv->tv_jiff = jiffies;
+	tv->tv_usec = GET_JIFFIES_USEC();
 }
 
-int __INLINE__ timeval_cmp(struct timeval *t0, struct timeval *t1)
+inline int fasttime_cmp(struct fasttime_t *t0, struct fasttime_t *t1)
 {
-  if (t0->tv_sec < t1->tv_sec)
-  {
-    return -1;
-  }
-  else if (t0->tv_sec > t1->tv_sec)
-  {
-    return 1;
-  }
-  if (t0->tv_usec < t1->tv_usec)
-  {
-    return -1;
-  }
-  else if (t0->tv_usec > t1->tv_usec)
-  {
-    return 1;
-  }
-  return 0;
+	/* Compare jiffies. Takes care of wrapping */
+	if (time_before(t0->tv_jiff, t1->tv_jiff))
+		return -1;
+	else if (time_after(t0->tv_jiff, t1->tv_jiff))
+		return 1;
+
+	/* Compare us */
+	if (t0->tv_usec < t1->tv_usec)
+		return -1;
+	else if (t0->tv_usec > t1->tv_usec)
+		return 1;
+	return 0;
 }
 
 /* Called with ints off */
-void __INLINE__ start_timer_trig(unsigned long delay_us)
+inline void start_timer_trig(unsigned long delay_us)
 {
   reg_timer_rw_ack_intr ack_intr = { 0 };
   reg_timer_rw_intr_mask intr_mask;
   reg_timer_rw_trig trig;
   reg_timer_rw_trig_cfg trig_cfg = { 0 };
-  reg_timer_r_time r_time;
+	reg_timer_r_time r_time0;
+	reg_timer_r_time r_time1;
+	unsigned char trig_wrap;
+	unsigned char time_wrap;
 
-  r_time = REG_RD(timer, regi_timer, r_time);
+	r_time0 = REG_RD(timer, regi_timer0, r_time);
 
   D1(printk("start_timer_trig : %d us freq: %i div: %i\n",
             delay_us, freq_index, div));
   /* Clear trig irq */
-  intr_mask = REG_RD(timer, regi_timer, rw_intr_mask);
+	intr_mask = REG_RD(timer, regi_timer0, rw_intr_mask);
   intr_mask.trig = 0;
-  REG_WR(timer, regi_timer, rw_intr_mask, intr_mask);
+	REG_WR(timer, regi_timer0, rw_intr_mask, intr_mask);
 
-  /* Set timer values */
-  /* r_time is 100MHz (10 ns resolution) */
-  trig = r_time + delay_us*(1000/10);
+	/* Set timer values and check if trigger wraps. */
+	/* r_time is 100MHz (10 ns resolution) */
+	trig_wrap = (trig = r_time0 + delay_us*(1000/10)) < r_time0;
 
   timer_div_settings[fast_timers_started % NUM_TIMER_STATS] = trig;
   timer_delay_settings[fast_timers_started % NUM_TIMER_STATS] = delay_us;
 
   /* Ack interrupt */
   ack_intr.trig = 1;
-  REG_WR(timer, regi_timer, rw_ack_intr, ack_intr);
+	REG_WR(timer, regi_timer0, rw_ack_intr, ack_intr);
 
   /* Start timer */
-  REG_WR(timer, regi_timer, rw_trig, trig);
+	REG_WR(timer, regi_timer0, rw_trig, trig);
   trig_cfg.tmr = regk_timer_time;
-  REG_WR(timer, regi_timer, rw_trig_cfg, trig_cfg);
+	REG_WR(timer, regi_timer0, rw_trig_cfg, trig_cfg);
 
   /* Check if we have already passed the trig time */
-  r_time = REG_RD(timer, regi_timer, r_time);
-  if (r_time < trig) {
+	r_time1 = REG_RD(timer, regi_timer0, r_time);
+	time_wrap = r_time1 < r_time0;
+
+	if ((trig_wrap && !time_wrap) || (r_time1 < trig)) {
     /* No, Enable trig irq */
-    intr_mask = REG_RD(timer, regi_timer, rw_intr_mask);
+		intr_mask = REG_RD(timer, regi_timer0, rw_intr_mask);
     intr_mask.trig = 1;
-    REG_WR(timer, regi_timer, rw_intr_mask, intr_mask);
+		REG_WR(timer, regi_timer0, rw_intr_mask, intr_mask);
     fast_timers_started++;
     fast_timer_running = 1;
-  }
-  else
-  {
+	} else {
     /* We have passed the time, disable trig point, ack intr */
     trig_cfg.tmr = regk_timer_off;
-    REG_WR(timer, regi_timer, rw_trig_cfg, trig_cfg);
-    REG_WR(timer, regi_timer, rw_ack_intr, ack_intr);
-    /* call the int routine directly */
-    timer_trig_handler();
+		REG_WR(timer, regi_timer0, rw_trig_cfg, trig_cfg);
+		REG_WR(timer, regi_timer0, rw_ack_intr, ack_intr);
+		/* call the int routine */
+		INIT_WORK(&fast_work, timer_trig_handler);
+		schedule_work(&fast_work);
   }
 
 }
@@ -321,18 +207,15 @@ void start_one_shot_timer(struct fast_timer *t,
   tmp = fast_timer_list;
 
   SANITYCHECK({ /* Check so this is not in the list already... */
-    while (tmp != NULL)
-    {
-      if (tmp == t)
-      {
-        printk("timer name: %s data: 0x%08lX already in list!\n", name, data);
-        sanity_failed++;
-        return;
-      }
-      else
-      {
+	while (tmp != NULL) {
+		if (tmp == t) {
+			printk(KERN_DEBUG
+				"timer name: %s data: 0x%08lX already "
+				"in list!\n", name, data);
+			sanity_failed++;
+			goto done;
+		} else
         tmp = tmp->next;
-      }
     }
     tmp = fast_timer_list;
   });
@@ -343,11 +226,10 @@ void start_one_shot_timer(struct fast_timer *t,
   t->name = name;
 
   t->tv_expires.tv_usec = t->tv_set.tv_usec + delay_us % 1000000;
-  t->tv_expires.tv_sec  = t->tv_set.tv_sec  + delay_us / 1000000;
-  if (t->tv_expires.tv_usec > 1000000)
-  {
+	t->tv_expires.tv_jiff = t->tv_set.tv_jiff + delay_us / 1000000 / HZ;
+	if (t->tv_expires.tv_usec > 1000000) {
     t->tv_expires.tv_usec -= 1000000;
-    t->tv_expires.tv_sec++;
+		t->tv_expires.tv_jiff += HZ;
   }
 #ifdef FAST_TIMER_LOG
   timer_added_log[fast_timers_added % NUM_TIMER_STATS] = *t;
@@ -355,15 +237,12 @@ void start_one_shot_timer(struct fast_timer *t,
   fast_timers_added++;
 
   /* Check if this should timeout before anything else */
-  if (tmp == NULL || timeval_cmp(&t->tv_expires, &tmp->tv_expires) < 0)
-  {
+  if (tmp == NULL || fasttime_cmp(&t->tv_expires, &tmp->tv_expires) < 0) {
     /* Put first in list and modify the timer value */
     t->prev = NULL;
     t->next = fast_timer_list;
     if (fast_timer_list)
-    {
       fast_timer_list->prev = t;
-    }
     fast_timer_list = t;
 #ifdef FAST_TIMER_LOG
     timer_started_log[fast_timers_started % NUM_TIMER_STATS] = *t;
@@ -372,10 +251,8 @@ void start_one_shot_timer(struct fast_timer *t,
   } else {
     /* Put in correct place in list */
     while (tmp->next &&
-           timeval_cmp(&t->tv_expires, &tmp->next->tv_expires) > 0)
-    {
+		fasttime_cmp(&t->tv_expires, &tmp->next->tv_expires) > 0)
       tmp = tmp->next;
-    }
     /* Insert t after tmp */
     t->prev = tmp;
     t->next = tmp->next;
@@ -388,6 +265,7 @@ void start_one_shot_timer(struct fast_timer *t,
 
   D2(printk("start_one_shot_timer: %d us done\n", delay_us));
 
+done:
   local_irq_restore(flags);
 } /* start_one_shot_timer */
 
@@ -431,19 +309,18 @@ int del_fast_timer(struct fast_timer * t)
 /* Timer interrupt handler for trig interrupts */
 
 static irqreturn_t
-timer_trig_interrupt(int irq, void *dev_id, struct pt_regs *regs)
+timer_trig_interrupt(int irq, void *dev_id)
 {
   reg_timer_r_masked_intr masked_intr;
-
   /* Check if the timer interrupt is for us (a trig int) */
-  masked_intr = REG_RD(timer, regi_timer, r_masked_intr);
+	masked_intr = REG_RD(timer, regi_timer0, r_masked_intr);
   if (!masked_intr.trig)
     return IRQ_NONE;
-  timer_trig_handler();
+	timer_trig_handler(NULL);
   return IRQ_HANDLED;
 }
 
-static void timer_trig_handler(void)
+static void timer_trig_handler(struct work_struct *work)
 {
   reg_timer_rw_ack_intr ack_intr = { 0 };
   reg_timer_rw_intr_mask intr_mask;
@@ -451,38 +328,45 @@ static void timer_trig_handler(void)
   struct fast_timer *t;
   unsigned long flags;
 
+	/* We keep interrupts disabled not only when we modify the
+	 * fast timer list, but any time we hold a reference to a
+	 * timer in the list, since del_fast_timer may be called
+	 * from (another) interrupt context.  Thus, the only time
+	 * when interrupts are enabled is when calling the timer
+	 * callback function.
+	 */
   local_irq_save(flags);
 
   /* Clear timer trig interrupt */
-  intr_mask = REG_RD(timer, regi_timer, rw_intr_mask);
+	intr_mask = REG_RD(timer, regi_timer0, rw_intr_mask);
   intr_mask.trig = 0;
-  REG_WR(timer, regi_timer, rw_intr_mask, intr_mask);
+  REG_WR(timer, regi_timer0, rw_intr_mask, intr_mask);
 
   /* First stop timer, then ack interrupt */
   /* Stop timer */
   trig_cfg.tmr = regk_timer_off;
-  REG_WR(timer, regi_timer, rw_trig_cfg, trig_cfg);
+	REG_WR(timer, regi_timer0, rw_trig_cfg, trig_cfg);
 
   /* Ack interrupt */
   ack_intr.trig = 1;
-  REG_WR(timer, regi_timer, rw_ack_intr, ack_intr);
+	REG_WR(timer, regi_timer0, rw_ack_intr, ack_intr);
 
   fast_timer_running = 0;
   fast_timer_ints++;
 
-  local_irq_restore(flags);
+	fast_timer_function_type *f;
+	unsigned long d;
 
   t = fast_timer_list;
-  while (t)
-  {
-    struct timeval tv;
+	while (t) {
+		struct fasttime_t tv;
 
     /* Has it really expired? */
     do_gettimeofday_fast(&tv);
-    D1(printk("t: %is %06ius\n", tv.tv_sec, tv.tv_usec));
+		D1(printk(KERN_DEBUG
+			"t: %is %06ius\n", tv.tv_jiff, tv.tv_usec));
 
-    if (timeval_cmp(&t->tv_expires, &tv) <= 0)
-    {
+		if (fasttime_cmp(&t->tv_expires, &tv) <= 0) {
       /* Yes it has expired */
 #ifdef FAST_TIMER_LOG
       timer_expired_log[fast_timers_expired % NUM_TIMER_STATS] = *t;
@@ -490,84 +374,77 @@ static void timer_trig_handler(void)
       fast_timers_expired++;
 
       /* Remove this timer before call, since it may reuse the timer */
-      local_irq_save(flags);
       if (t->prev)
-      {
         t->prev->next = t->next;
-      }
       else
-      {
         fast_timer_list = t->next;
-      }
       if (t->next)
-      {
         t->next->prev = t->prev;
-      }
       t->prev = NULL;
       t->next = NULL;
-      local_irq_restore(flags);
 
-      if (t->function != NULL)
-      {
-        t->function(t->data);
-      }
-      else
-      {
+			/* Save function callback data before enabling
+			 * interrupts, since the timer may be removed and we
+			 * don't know how it was allocated (e.g. ->function
+			 * and ->data may become overwritten after deletion
+			 * if the timer was stack-allocated).
+			 */
+			f = t->function;
+			d = t->data;
+
+			if (f != NULL) {
+				/* Run the callback function with interrupts
+				 * enabled. */
+				local_irq_restore(flags);
+				f(d);
+				local_irq_save(flags);
+			} else
         DEBUG_LOG("!trimertrig %i function==NULL!\n", fast_timer_ints);
-      }
-    }
-    else
-    {
+		} else {
       /* Timer is to early, let's set it again using the normal routines */
       D1(printk(".\n"));
     }
 
-    local_irq_save(flags);
-    if ((t = fast_timer_list) != NULL)
-    {
+		t = fast_timer_list;
+		if (t != NULL) {
       /* Start next timer.. */
-      long us;
-      struct timeval tv;
+			long us = 0;
+			struct fasttime_t tv;
 
       do_gettimeofday_fast(&tv);
-      us = ((t->tv_expires.tv_sec - tv.tv_sec) * 1000000 +
-            t->tv_expires.tv_usec - tv.tv_usec);
-      if (us > 0)
-      {
-        if (!fast_timer_running)
-        {
+
+			/* time_after_eq takes care of wrapping */
+			if (time_after_eq(t->tv_expires.tv_jiff, tv.tv_jiff))
+				us = ((t->tv_expires.tv_jiff - tv.tv_jiff) *
+					1000000 / HZ + t->tv_expires.tv_usec -
+					tv.tv_usec);
+
+			if (us > 0) {
+				if (!fast_timer_running) {
 #ifdef FAST_TIMER_LOG
           timer_started_log[fast_timers_started % NUM_TIMER_STATS] = *t;
 #endif
           start_timer_trig(us);
         }
-        local_irq_restore(flags);
         break;
-      }
-      else
-      {
+			} else {
         /* Timer already expired, let's handle it better late than never.
          * The normal loop handles it
          */
         D1(printk("e! %d\n", us));
       }
     }
-    local_irq_restore(flags);
   }
 
-  if (!t)
-  {
+	local_irq_restore(flags);
+
+	if (!t)
     D1(printk("ttrig stop!\n"));
-  }
 }
 
 static void wake_up_func(unsigned long data)
 {
-#ifdef DECLARE_WAITQUEUE
   wait_queue_head_t  *sleep_wait_p = (wait_queue_head_t*)data;
-#else
-  struct wait_queue **sleep_wait_p = (struct wait_queue **)data;
-#endif
   wake_up(sleep_wait_p);
 }
 
@@ -577,28 +454,17 @@ static void wake_up_func(unsigned long data)
 void schedule_usleep(unsigned long us)
 {
   struct fast_timer t;
-#ifdef DECLARE_WAITQUEUE
   wait_queue_head_t sleep_wait;
   init_waitqueue_head(&sleep_wait);
-  {
-  DECLARE_WAITQUEUE(wait, current);
-#else
-  struct wait_queue *sleep_wait = NULL;
-  struct wait_queue wait = { current, NULL };
-#endif
 
   D1(printk("schedule_usleep(%d)\n", us));
-  add_wait_queue(&sleep_wait, &wait);
-  set_current_state(TASK_INTERRUPTIBLE);
   start_one_shot_timer(&t, wake_up_func, (unsigned long)&sleep_wait, us,
                        "usleep");
-  schedule();
-  set_current_state(TASK_RUNNING);
-  remove_wait_queue(&sleep_wait, &wait);
+	/* Uninterruptible sleep on the fast timer. (The condition is
+	 * somewhat redundant since the timer is what wakes us up.) */
+	wait_event(sleep_wait, !fast_timer_pending(&t));
+
   D1(printk("done schedule_usleep(%d)\n", us));
-#ifdef DECLARE_WAITQUEUE
-  }
-#endif
 }
 
 #ifdef CONFIG_PROC_FS
@@ -618,20 +484,22 @@ static int proc_fasttimer_read(char *buf, char **start, off_t offset, int len
   unsigned long flags;
   int i = 0;
   int num_to_show;
-  struct timeval tv;
+	struct fasttime_t tv;
   struct fast_timer *t, *nextt;
   static char *bigbuf = NULL;
   static unsigned long used;
 
-  if (!bigbuf && !(bigbuf = vmalloc(BIG_BUF_SIZE)))
-  {
-    used = 0;
-    bigbuf[0] = '\0';
-    return 0;
-  }
-
-  if (!offset || !used)
-  {
+	if (!bigbuf) {
+		bigbuf = vmalloc(BIG_BUF_SIZE);
+		if (!bigbuf) {
+			used = 0;
+			if (buf)
+				buf[0] = '\0';
+			return 0;
+		}
+	}
+
+	if (!offset || !used) {
     do_gettimeofday_fast(&tv);
 
     used = 0;
@@ -648,7 +516,7 @@ static int proc_fasttimer_read(char *buf, char **start, off_t offset, int len
     used += sprintf(bigbuf + used, "Fast timer running:    %s\n",
                     fast_timer_running ? "yes" : "no");
     used += sprintf(bigbuf + used, "Current time:          %lu.%06lu\n",
-                    (unsigned long)tv.tv_sec,
+			(unsigned long)tv.tv_jiff,
                     (unsigned long)tv.tv_usec);
 #ifdef FAST_TIMER_SANITY_CHECKS
     used += sprintf(bigbuf + used, "Sanity failed:         %i\n",
@@ -661,10 +529,8 @@ static int proc_fasttimer_read(char *buf, char **start, off_t offset, int len
       int end_i = debug_log_cnt;
       i = 0;
 
-      if (debug_log_cnt_wrapped)
-      {
+			if (debug_log_cnt_wrapped)
         i = debug_log_cnt;
-      }
 
       while ((i != end_i || (debug_log_cnt_wrapped && !used)) &&
              used+100 < BIG_BUF_SIZE)
@@ -697,9 +563,9 @@ static int proc_fasttimer_read(char *buf, char **start, off_t offset, int len
                       "d: %6li us data: 0x%08lX"
                       "\n",
                       t->name,
-                      (unsigned long)t->tv_set.tv_sec,
+				(unsigned long)t->tv_set.tv_jiff,
                       (unsigned long)t->tv_set.tv_usec,
-                      (unsigned long)t->tv_expires.tv_sec,
+				(unsigned long)t->tv_expires.tv_jiff,
                       (unsigned long)t->tv_expires.tv_usec,
                       t->delay_us,
                       t->data
@@ -719,9 +585,9 @@ static int proc_fasttimer_read(char *buf, char **start, off_t offset, int len
                       "d: %6li us data: 0x%08lX"
                       "\n",
                       t->name,
-                      (unsigned long)t->tv_set.tv_sec,
+				(unsigned long)t->tv_set.tv_jiff,
                       (unsigned long)t->tv_set.tv_usec,
-                      (unsigned long)t->tv_expires.tv_sec,
+				(unsigned long)t->tv_expires.tv_jiff,
                       (unsigned long)t->tv_expires.tv_usec,
                       t->delay_us,
                       t->data
@@ -739,9 +605,9 @@ static int proc_fasttimer_read(char *buf, char **start, off_t offset, int len
                       "d: %6li us data: 0x%08lX"
                       "\n",
                       t->name,
-                      (unsigned long)t->tv_set.tv_sec,
+				(unsigned long)t->tv_set.tv_jiff,
                       (unsigned long)t->tv_set.tv_usec,
-                      (unsigned long)t->tv_expires.tv_sec,
+				(unsigned long)t->tv_expires.tv_jiff,
                       (unsigned long)t->tv_expires.tv_usec,
                       t->delay_us,
                       t->data
@@ -752,26 +618,25 @@ static int proc_fasttimer_read(char *buf, char **start, off_t offset, int len
 
     used += sprintf(bigbuf + used, "Active timers:\n");
     local_irq_save(flags);
-    local_irq_save(flags);
     t = fast_timer_list;
     while (t != NULL && (used+100 < BIG_BUF_SIZE))
     {
       nextt = t->next;
       local_irq_restore(flags);
       used += sprintf(bigbuf + used, "%-14s s: %6lu.%06lu e: %6lu.%06lu "
-                      "d: %6li us data: 0x%08lX"
-/*                      " func: 0x%08lX" */
-                      "\n",
-                      t->name,
-                      (unsigned long)t->tv_set.tv_sec,
-                      (unsigned long)t->tv_set.tv_usec,
-                      (unsigned long)t->tv_expires.tv_sec,
-                      (unsigned long)t->tv_expires.tv_usec,
+			"d: %6li us data: 0x%08lX"
+/*			" func: 0x%08lX" */
+			"\n",
+			t->name,
+			(unsigned long)t->tv_set.tv_jiff,
+			(unsigned long)t->tv_set.tv_usec,
+			(unsigned long)t->tv_expires.tv_jiff,
+			(unsigned long)t->tv_expires.tv_usec,
                       t->delay_us,
                       t->data
 /*                      , t->function */
                       );
-      local_irq_disable();
+			local_irq_save(flags);
       if (t->next != nextt)
       {
         printk("timer removed!\n");
@@ -800,7 +665,7 @@ static volatile int num_test_timeout = 0;
 static struct fast_timer tr[10];
 static int exp_num[10];
 
-static struct timeval tv_exp[100];
+static struct fasttime_t tv_exp[100];
 
 static void test_timeout(unsigned long data)
 {
@@ -838,7 +703,7 @@ static void fast_timer_test(void)
   int prev_num;
   int j;
 
-  struct timeval tv, tv0, tv1, tv2;
+	struct fasttime_t tv, tv0, tv1, tv2;
 
   printk("fast_timer_test() start\n");
   do_gettimeofday_fast(&tv);
@@ -851,21 +716,22 @@ static void fast_timer_test(void)
   {
     do_gettimeofday_fast(&tv_exp[j]);
   }
-  printk("fast_timer_test() %is %06i\n", tv.tv_sec, tv.tv_usec);
+  printk(KERN_DEBUG "fast_timer_test() %is %06i\n", tv.tv_jiff, tv.tv_usec);
 
   for (j = 0; j < 1000; j++)
   {
-    printk("%i %i %i %i %i\n",j_u[j], j_u[j+1], j_u[j+2], j_u[j+3], j_u[j+4]);
+    printk(KERN_DEBUG "%i %i %i %i %i\n",
+      j_u[j], j_u[j+1], j_u[j+2], j_u[j+3], j_u[j+4]);
     j += 4;
   }
   for (j = 0; j < 100; j++)
   {
-    printk("%i.%i %i.%i %i.%i %i.%i %i.%i\n",
-           tv_exp[j].tv_sec,tv_exp[j].tv_usec,
-           tv_exp[j+1].tv_sec,tv_exp[j+1].tv_usec,
-           tv_exp[j+2].tv_sec,tv_exp[j+2].tv_usec,
-           tv_exp[j+3].tv_sec,tv_exp[j+3].tv_usec,
-           tv_exp[j+4].tv_sec,tv_exp[j+4].tv_usec);
+    printk(KERN_DEBUG "%i.%i %i.%i %i.%i %i.%i %i.%i\n",
+			tv_exp[j].tv_jiff, tv_exp[j].tv_usec,
+			tv_exp[j+1].tv_jiff, tv_exp[j+1].tv_usec,
+			tv_exp[j+2].tv_jiff, tv_exp[j+2].tv_usec,
+			tv_exp[j+3].tv_jiff, tv_exp[j+3].tv_usec,
+			tv_exp[j+4].tv_jiff, tv_exp[j+4].tv_usec);
     j += 4;
   }
   do_gettimeofday_fast(&tv0);
@@ -892,14 +758,15 @@ static void fast_timer_test(void)
   while (num_test_timeout < i)
   {
     if (num_test_timeout != prev_num)
-    {
       prev_num = num_test_timeout;
-    }
   }
   do_gettimeofday_fast(&tv2);
-  printk("Timers started    %is %06i\n", tv0.tv_sec, tv0.tv_usec);
-  printk("Timers started at %is %06i\n", tv1.tv_sec, tv1.tv_usec);
-  printk("Timers done       %is %06i\n", tv2.tv_sec, tv2.tv_usec);
+	printk(KERN_INFO "Timers started    %is %06i\n",
+		tv0.tv_jiff, tv0.tv_usec);
+	printk(KERN_INFO "Timers started at %is %06i\n",
+		tv1.tv_jiff, tv1.tv_usec);
+	printk(KERN_INFO "Timers done       %is %06i\n",
+		tv2.tv_jiff, tv2.tv_usec);
   DP(printk("buf0:\n");
      printk(buf0);
      printk("buf1:\n");
@@ -921,9 +788,9 @@ static void fast_timer_test(void)
     printk("%-10s set: %6is %06ius exp: %6is %06ius "
            "data: 0x%08X func: 0x%08X\n",
            t->name,
-           t->tv_set.tv_sec,
+			t->tv_set.tv_jiff,
            t->tv_set.tv_usec,
-           t->tv_expires.tv_sec,
+			t->tv_expires.tv_jiff,
            t->tv_expires.tv_usec,
            t->data,
            t->function
@@ -931,10 +798,12 @@ static void fast_timer_test(void)
 
     printk("           del: %6ius     did exp: %6is %06ius as #%i error: %6li\n",
            t->delay_us,
-           tv_exp[j].tv_sec,
+			tv_exp[j].tv_jiff,
            tv_exp[j].tv_usec,
            exp_num[j],
-           (tv_exp[j].tv_sec - t->tv_expires.tv_sec)*1000000 + tv_exp[j].tv_usec - t->tv_expires.tv_usec);
+			(tv_exp[j].tv_jiff - t->tv_expires.tv_jiff) *
+				1000000 + tv_exp[j].tv_usec -
+				t->tv_expires.tv_usec);
   }
   proc_fasttimer_read(buf5, NULL, 0, 0, 0);
   printk("buf5 after all done:\n");
@@ -944,7 +813,7 @@ static void fast_timer_test(void)
 #endif
 
 
-void fast_timer_init(void)
+int fast_timer_init(void)
 {
   /* For some reason, request_irq() hangs when called froom time_init() */
   if (!fast_timer_is_init)
@@ -952,18 +821,20 @@ void fast_timer_init(void)
     printk("fast_timer_init()\n");
 
 #ifdef CONFIG_PROC_FS
-   if ((fasttimer_proc_entry = create_proc_entry( "fasttimer", 0, 0 )))
-     fasttimer_proc_entry->read_proc = proc_fasttimer_read;
+    fasttimer_proc_entry = create_proc_entry("fasttimer", 0, 0);
+    if (fasttimer_proc_entry)
+      fasttimer_proc_entry->read_proc = proc_fasttimer_read;
 #endif /* PROC_FS */
-    if(request_irq(TIMER_INTR_VECT, timer_trig_interrupt, IRQF_DISABLED,
-                   "fast timer int", NULL))
-    {
-      printk("err: timer1 irq\n");
-    }
+		if (request_irq(TIMER0_INTR_VECT, timer_trig_interrupt,
+				IRQF_SHARED | IRQF_DISABLED,
+				"fast timer int", &fast_timer_list))
+			printk(KERN_ERR "err: fasttimer irq\n");
     fast_timer_is_init = 1;
 #ifdef FAST_TIMER_TEST
     printk("do test\n");
     fast_timer_test();
 #endif
   }
+	return 0;
 }
+__initcall(fast_timer_init);
-- 
1.5.3.6.970.gd25430

