Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbXE3Xx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbXE3Xx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbXE3Xxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:53:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:33202 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbXE3Xxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:53:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,595,1170662400"; 
   d="scan'208";a="251446820"
Date: Wed, 30 May 2007 16:50:23 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Add a flag to indicate deferrable timers in /proc/timer_stats
Message-ID: <20070530235023.GF16793@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Add a flag in /proc/timer_stats to indicate deferrable timers. This will let
developers/users to differentiate between types of tiemrs in /proc/timer_stats.

Deferrable timer and normal timer will appear in /proc/timer_stats as below.
  10D,     1 swapper          queue_delayed_work_on (delayed_work_timer_fn)
   10,     1 swapper          queue_delayed_work_on (delayed_work_timer_fn)

Also version of timer_stats changes from v0.1 to v0.2

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.22-rc-mm/include/linux/hrtimer.h
===================================================================
--- linux-2.6.22-rc-mm.orig/include/linux/hrtimer.h	2007-05-24 17:04:10.000000000 -0700
+++ linux-2.6.22-rc-mm/include/linux/hrtimer.h	2007-05-30 15:02:49.000000000 -0700
@@ -329,12 +329,13 @@
 #ifdef CONFIG_TIMER_STATS
 
 extern void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
-				     void *timerf, char * comm);
+				     void *timerf, char * comm,
+				     unsigned int timer_flag);
 
 static inline void timer_stats_account_hrtimer(struct hrtimer *timer)
 {
 	timer_stats_update_stats(timer, timer->start_pid, timer->start_site,
-				 timer->function, timer->start_comm);
+				 timer->function, timer->start_comm, 0);
 }
 
 extern void __timer_stats_hrtimer_set_start_info(struct hrtimer *timer,
Index: linux-2.6.22-rc-mm/kernel/timer.c
===================================================================
--- linux-2.6.22-rc-mm.orig/kernel/timer.c	2007-05-24 17:04:10.000000000 -0700
+++ linux-2.6.22-rc-mm/kernel/timer.c	2007-05-30 15:19:15.000000000 -0700
@@ -305,6 +305,20 @@
 	memcpy(timer->start_comm, current->comm, TASK_COMM_LEN);
 	timer->start_pid = current->pid;
 }
+
+static void timer_stats_account_timer(struct timer_list *timer)
+{
+	unsigned int flag = 0;
+
+	if (unlikely(tbase_get_deferrable(timer->base)))
+		flag |= TIMER_STATS_FLAG_DEFERRABLE;
+
+	timer_stats_update_stats(timer, timer->start_pid, timer->start_site,
+				 timer->function, timer->start_comm, flag);
+}
+
+#else
+static void timer_stats_account_timer(struct timer_list *timer) {}
 #endif
 
 /**
Index: linux-2.6.22-rc-mm/kernel/time/timer_stats.c
===================================================================
--- linux-2.6.22-rc-mm.orig/kernel/time/timer_stats.c	2007-05-24 17:04:10.000000000 -0700
+++ linux-2.6.22-rc-mm/kernel/time/timer_stats.c	2007-05-30 15:36:55.000000000 -0700
@@ -68,6 +68,7 @@
 	 * Number of timeout events:
 	 */
 	unsigned long		count;
+	unsigned int		timer_flag;
 
 	/*
 	 * We save the command-line string to preserve
@@ -227,7 +228,8 @@
  * incremented. Otherwise the timer is registered in a free slot.
  */
 void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
-			      void *timerf, char * comm)
+			      void *timerf, char * comm,
+			      unsigned int timer_flag)
 {
 	/*
 	 * It doesnt matter which lock we take:
@@ -240,6 +242,7 @@
 	input.start_func = startf;
 	input.expire_func = timerf;
 	input.pid = pid;
+	input.timer_flag = timer_flag;
 
 	spin_lock_irqsave(lock, flags);
 	if (!active)
@@ -286,7 +289,7 @@
 	period = ktime_to_timespec(time);
 	ms = period.tv_nsec / 1000000;
 
-	seq_puts(m, "Timer Stats Version: v0.1\n");
+	seq_puts(m, "Timer Stats Version: v0.2\n");
 	seq_printf(m, "Sample period: %ld.%03ld s\n", period.tv_sec, ms);
 	if (atomic_read(&overflow_count))
 		seq_printf(m, "Overflow: %d entries\n",
@@ -294,8 +297,13 @@
 
 	for (i = 0; i < nr_entries; i++) {
 		entry = entries + i;
-		seq_printf(m, "%4lu, %5d %-16s ",
+ 		if (entry->timer_flag & TIMER_STATS_FLAG_DEFERRABLE) {
+			seq_printf(m, "%4luD, %5d %-16s ",
 				entry->count, entry->pid, entry->comm);
+		} else {
+			seq_printf(m, " %4lu, %5d %-16s ",
+				entry->count, entry->pid, entry->comm);
+		}
 
 		print_name_offset(m, (unsigned long)entry->start_func);
 		seq_puts(m, " (");
Index: linux-2.6.22-rc-mm/include/linux/timer.h
===================================================================
--- linux-2.6.22-rc-mm.orig/include/linux/timer.h	2007-05-24 17:04:10.000000000 -0700
+++ linux-2.6.22-rc-mm/include/linux/timer.h	2007-05-30 15:19:23.000000000 -0700
@@ -85,16 +85,13 @@
  */
 #ifdef CONFIG_TIMER_STATS
 
+#define TIMER_STATS_FLAG_DEFERRABLE	0x1
+
 extern void init_timer_stats(void);
 
 extern void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
-				     void *timerf, char * comm);
-
-static inline void timer_stats_account_timer(struct timer_list *timer)
-{
-	timer_stats_update_stats(timer, timer->start_pid, timer->start_site,
-				 timer->function, timer->start_comm);
-}
+				     void *timerf, char * comm,
+				     unsigned int timer_flag);
 
 extern void __timer_stats_timer_set_start_info(struct timer_list *timer,
 					       void *addr);
@@ -113,10 +110,6 @@
 {
 }
 
-static inline void timer_stats_account_timer(struct timer_list *timer)
-{
-}
-
 static inline void timer_stats_timer_set_start_info(struct timer_list *timer)
 {
 }
Index: linux-2.6.22-rc-mm/Documentation/hrtimer/timer_stats.txt
===================================================================
--- linux-2.6.22-rc-mm.orig/Documentation/hrtimer/timer_stats.txt	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22-rc-mm/Documentation/hrtimer/timer_stats.txt	2007-05-30 15:36:36.000000000 -0700
@@ -66,3 +66,7 @@
 
     Thomas, Ingo
 
+Added flag to indicate 'deferrable timer' in /proc/timer_stats. A deferrable
+timer will appear as follows
+  10D,     1 swapper          queue_delayed_work_on (delayed_work_timer_fn)
+
