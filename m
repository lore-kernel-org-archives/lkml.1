Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbZFXJsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbZFXJsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759266AbZFXJsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:48:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:59809 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759292AbZFXJsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:48:21 -0400
Date: Wed, 24 Jun 2009 09:47:08 GMT
From: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       schwidefsky@de.ibm.com, arjan@infradead.org, akpm@linux-foundation.org,
       mustafa.mesanovic@de.ibm.com, heiko.carstens@de.ibm.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: arjan@infradead.org, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mustafa.mesanovic@de.ibm.com, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090623153811.GA4641@osiris.boeblingen.de.ibm.com>
References: <20090623153811.GA4641@osiris.boeblingen.de.ibm.com>
Subject: [tip:timers/urgent] timer stats: Optimize by adding quick check to avoid function calls
Message-ID: <tip-507e123151149e578c9aae33eb876c49824da5f8@git.kernel.org>
Git-Commit-ID: 507e123151149e578c9aae33eb876c49824da5f8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 24 Jun 2009 09:47:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  507e123151149e578c9aae33eb876c49824da5f8
Gitweb:     http://git.kernel.org/tip/507e123151149e578c9aae33eb876c49824da5f8
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Tue, 23 Jun 2009 17:38:15 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 24 Jun 2009 11:15:09 +0200

timer stats: Optimize by adding quick check to avoid function calls

When the kernel is configured with CONFIG_TIMER_STATS but timer
stats are runtime disabled we still get calls to
__timer_stats_timer_set_start_info which initializes some
fields in the corresponding struct timer_list.

So add some quick checks in the the timer stats setup functions
to avoid function calls to __timer_stats_timer_set_start_info
when timer stats are disabled.

In an artificial workload that does nothing but playing ping
pong with a single tcp packet via loopback this decreases cpu
consumption by 1 - 1.5%.

This is part of a modified function trace output on SLES11:

 perl-2497  [00] 28630647177732388 [+  125]: sk_reset_timer <-tcp_v4_rcv
 perl-2497  [00] 28630647177732513 [+  125]: mod_timer <-sk_reset_timer
 perl-2497  [00] 28630647177732638 [+  125]: __timer_stats_timer_set_start_info <-mod_timer
 perl-2497  [00] 28630647177732763 [+  125]: __mod_timer <-mod_timer
 perl-2497  [00] 28630647177732888 [+  125]: __timer_stats_timer_set_start_info <-__mod_timer
 perl-2497  [00] 28630647177733013 [+   93]: lock_timer_base <-__mod_timer

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mustafa Mesanovic <mustafa.mesanovic@de.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>
LKML-Reference: <20090623153811.GA4641@osiris.boeblingen.de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/hrtimer.h   |    5 +++++
 include/linux/timer.h     |    4 ++++
 kernel/time/timer_stats.c |   16 ++++++++--------
 kernel/timer.c            |    2 ++
 4 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 7400900..54648e6 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -21,6 +21,7 @@
 #include <linux/list.h>
 #include <linux/wait.h>
 #include <linux/percpu.h>
+#include <linux/timer.h>
 
 
 struct hrtimer_clock_base;
@@ -447,6 +448,8 @@ extern void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
 
 static inline void timer_stats_account_hrtimer(struct hrtimer *timer)
 {
+	if (likely(!timer->start_pid))
+		return;
 	timer_stats_update_stats(timer, timer->start_pid, timer->start_site,
 				 timer->function, timer->start_comm, 0);
 }
@@ -456,6 +459,8 @@ extern void __timer_stats_hrtimer_set_start_info(struct hrtimer *timer,
 
 static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
 {
+	if (likely(!timer_stats_active))
+		return;
 	__timer_stats_hrtimer_set_start_info(timer, __builtin_return_address(0));
 }
 
diff --git a/include/linux/timer.h b/include/linux/timer.h
index ccf882e..be62ec2 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -190,6 +190,8 @@ extern unsigned long get_next_timer_interrupt(unsigned long now);
  */
 #ifdef CONFIG_TIMER_STATS
 
+extern int timer_stats_active;
+
 #define TIMER_STATS_FLAG_DEFERRABLE	0x1
 
 extern void init_timer_stats(void);
@@ -203,6 +205,8 @@ extern void __timer_stats_timer_set_start_info(struct timer_list *timer,
 
 static inline void timer_stats_timer_set_start_info(struct timer_list *timer)
 {
+	if (likely(!timer_stats_active))
+		return;
 	__timer_stats_timer_set_start_info(timer, __builtin_return_address(0));
 }
 
diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
index c994530..4cde8b9 100644
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -96,7 +96,7 @@ static DEFINE_MUTEX(show_mutex);
 /*
  * Collection status, active/inactive:
  */
-static int __read_mostly active;
+int __read_mostly timer_stats_active;
 
 /*
  * Beginning/end timestamps of measurement:
@@ -242,7 +242,7 @@ void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
 	struct entry *entry, input;
 	unsigned long flags;
 
-	if (likely(!active))
+	if (likely(!timer_stats_active))
 		return;
 
 	lock = &per_cpu(lookup_lock, raw_smp_processor_id());
@@ -254,7 +254,7 @@ void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
 	input.timer_flag = timer_flag;
 
 	spin_lock_irqsave(lock, flags);
-	if (!active)
+	if (!timer_stats_active)
 		goto out_unlock;
 
 	entry = tstat_lookup(&input, comm);
@@ -290,7 +290,7 @@ static int tstats_show(struct seq_file *m, void *v)
 	/*
 	 * If still active then calculate up to now:
 	 */
-	if (active)
+	if (timer_stats_active)
 		time_stop = ktime_get();
 
 	time = ktime_sub(time_stop, time_start);
@@ -368,18 +368,18 @@ static ssize_t tstats_write(struct file *file, const char __user *buf,
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
diff --git a/kernel/timer.c b/kernel/timer.c
index 54d3912..0b36b9e 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -380,6 +380,8 @@ static void timer_stats_account_timer(struct timer_list *timer)
 {
 	unsigned int flag = 0;
 
+	if (likely(!timer->start_site))
+		return;
 	if (unlikely(tbase_get_deferrable(timer->base)))
 		flag |= TIMER_STATS_FLAG_DEFERRABLE;
 
