Return-Path: <linux-kernel-owner+w=401wt.eu-S1759962AbZFWONW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962AbZFWONW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757254AbZFWONO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:13:14 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:39662 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136AbZFWONN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:13:13 -0400
Date: Tue, 23 Jun 2009 16:12:12 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Mustafa Mesanovic <mustafa.mesanovic@de.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH/Resend] timer stats: add quick check to avoid function calls
Message-ID: <20090623161212.5af942c0@osiris.boeblingen.de.ibm.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

When the kernel is configured with CONFIG_TIMER_STATS but timer stats
are runtime disabled we still get calls to __timer_stats_timer_set_start_info
which initializes some fields in the corresponding struct timer_list.

So add some quick checks in the the timer stats setup functions to avoid
function calls to __timer_stats_timer_set_start_info when timer stats are
disabled.

In an artificial workload that does nothing but playing ping pong with a
single tcp packet via loopback this decreases cpu consumption by 1 - 1.5%.

This is part of a modified function trace output on SLES11:

perl-2497  [00] 28630647177732388 [+  125]: sk_reset_timer <-tcp_v4_rcv
perl-2497  [00] 28630647177732513 [+  125]: mod_timer <-sk_reset_timer
perl-2497  [00] 28630647177732638 [+  125]: __timer_stats_timer_set_start_info <-mod_timer
perl-2497  [00] 28630647177732763 [+  125]: __mod_timer <-mod_timer
perl-2497  [00] 28630647177732888 [+  125]: __timer_stats_timer_set_start_info <-__mod_timer
perl-2497  [00] 28630647177733013 [+   93]: lock_timer_base <-__mod_timer

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 include/linux/hrtimer.h   |    6 ++++++
 include/linux/timer.h     |    4 ++++
 kernel/time/timer_stats.c |   16 ++++++++--------
 kernel/timer.c            |    2 ++
 4 files changed, 20 insertions(+), 8 deletions(-)

Index: linux-2.6/include/linux/hrtimer.h
===================================================================
--- linux-2.6.orig/include/linux/hrtimer.h
+++ linux-2.6/include/linux/hrtimer.h
@@ -438,12 +438,16 @@ extern void sysrq_timer_list_show(void);
  */
 #ifdef CONFIG_TIMER_STATS
 
+extern int timer_stats_active;
+
 extern void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
 				     void *timerf, char *comm,
 				     unsigned int timer_flag);
 
 static inline void timer_stats_account_hrtimer(struct hrtimer *timer)
 {
+	if (likely(!timer->start_pid))
+		return;
 	timer_stats_update_stats(timer, timer->start_pid, timer->start_site,
 				 timer->function, timer->start_comm, 0);
 }
@@ -453,6 +457,8 @@ extern void __timer_stats_hrtimer_set_st
 
 static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
 {
+	if (likely(!timer_stats_active))
+		return;
 	__timer_stats_hrtimer_set_start_info(timer, __builtin_return_address(0));
 }
 
Index: linux-2.6/include/linux/timer.h
===================================================================
--- linux-2.6.orig/include/linux/timer.h
+++ linux-2.6/include/linux/timer.h
@@ -187,6 +187,8 @@ extern unsigned long get_next_timer_inte
  */
 #ifdef CONFIG_TIMER_STATS
 
+extern int timer_stats_active;
+
 #define TIMER_STATS_FLAG_DEFERRABLE	0x1
 
 extern void init_timer_stats(void);
@@ -200,6 +202,8 @@ extern void __timer_stats_timer_set_star
 
 static inline void timer_stats_timer_set_start_info(struct timer_list *timer)
 {
+	if (likely(!timer_stats_active))
+		return;
 	__timer_stats_timer_set_start_info(timer, __builtin_return_address(0));
 }
 
Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -378,6 +378,8 @@ static void timer_stats_account_timer(st
 {
 	unsigned int flag = 0;
 
+	if (likely(!timer->start_site))
+		return;
 	if (unlikely(tbase_get_deferrable(timer->base)))
 		flag |= TIMER_STATS_FLAG_DEFERRABLE;
 
Index: linux-2.6/kernel/time/timer_stats.c
===================================================================
--- linux-2.6.orig/kernel/time/timer_stats.c
+++ linux-2.6/kernel/time/timer_stats.c
@@ -96,7 +96,7 @@ static DEFINE_MUTEX(show_mutex);
 /*
  * Collection status, active/inactive:
  */
-static int __read_mostly active;
+int __read_mostly timer_stats_active;
 
 /*
  * Beginning/end timestamps of measurement:
@@ -242,7 +242,7 @@ void timer_stats_update_stats(void *time
 	struct entry *entry, input;
 	unsigned long flags;
 
-	if (likely(!active))
+	if (likely(!timer_stats_active))
 		return;
 
 	lock = &per_cpu(lookup_lock, raw_smp_processor_id());
@@ -254,7 +254,7 @@ void timer_stats_update_stats(void *time
 	input.timer_flag = timer_flag;
 
 	spin_lock_irqsave(lock, flags);
-	if (!active)
+	if (!timer_stats_active)
 		goto out_unlock;
 
 	entry = tstat_lookup(&input, comm);
@@ -290,7 +290,7 @@ static int tstats_show(struct seq_file *
 	/*
 	 * If still active then calculate up to now:
 	 */
-	if (active)
+	if (timer_stats_active)
 		time_stop = ktime_get();
 
 	time = ktime_sub(time_stop, time_start);
@@ -368,18 +368,18 @@ static ssize_t tstats_write(struct file 
 	mutex_lock(&show_mutex);
 	switch (ctl[0]) {
 	case '0':
-		if (active) {
-			active = 0;
+		if (timer_stats_active) {
+			timer_stats_active = 0;
 			time_stop = ktime_get();
 			sync_access();
 		}
 		break;
 	case '1':
-		if (!active) {
+		if (!timer_stats_active) {
 			reset_entries();
 			time_start = ktime_get();
 			smp_mb();
-			active = 1;
+			timer_stats_active = 1;
 		}
 		break;
 	default:
