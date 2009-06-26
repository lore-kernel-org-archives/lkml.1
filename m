Return-Path: <linux-kernel-owner+w=401wt.eu-S1759131AbZFZTD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759131AbZFZTD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 15:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZFZTDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 15:03:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49717 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbZFZTDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:03:19 -0400
Date: Fri, 26 Jun 2009 21:03:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] timer fixes
Message-ID: <20090626190311.GA1412@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

The timer stats performance fix seemed significant (and simple) 
enough for a post-rc1 merge as it's enabled in a number of distros 
by default - but can leave it out if it's too much.

 Thanks,

	Ingo

------------------>
Arun R Bharadwaj (1):
      timers: Fix timer_migration interface which accepts any number as input

Heiko Carstens (1):
      timer stats: Optimize by adding quick check to avoid function calls


 include/linux/hrtimer.h   |    5 +++++
 include/linux/timer.h     |    4 ++++
 kernel/sysctl.c           |    5 ++++-
 kernel/time/timer_stats.c |   16 ++++++++--------
 kernel/timer.c            |    2 ++
 5 files changed, 23 insertions(+), 9 deletions(-)

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
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 62e4ff9..c428ba1 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -335,7 +335,10 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_timer_migration,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &one,
 	},
 #endif
 	{
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
 
