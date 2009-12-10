Return-Path: <linux-kernel-owner+w=401wt.eu-S1760154AbZLJJ4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154AbZLJJ4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 04:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759451AbZLJJ4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 04:56:25 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:48982 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759437AbZLJJ4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 04:56:24 -0500
Date: Thu, 10 Dec 2009 10:56:29 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] hrtimer: move timer stats helper functions to hrtimer.c
Message-ID: <20091210095629.GC4144@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

There is no reason to make timer_stats_hrtimer_set_start_info and friends
visible to the rest of the kernel. So move all of them to hrtimer.c.
Also make timer_stats_hrtimer_set_start_info a static inline function
so it gets inlined and we avoid another function call.
Based on a patch by Thomas Gleixner.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/linux/hrtimer.h |   43 -------------------------------------------
 kernel/hrtimer.c        |   24 ++++++++++++++++++++----
 2 files changed, 20 insertions(+), 47 deletions(-)

Index: linux-2.6/include/linux/hrtimer.h
===================================================================
--- linux-2.6.orig/include/linux/hrtimer.h
+++ linux-2.6/include/linux/hrtimer.h
@@ -435,47 +435,4 @@ extern u64 ktime_divns(const ktime_t kt,
 /* Show pending timers: */
 extern void sysrq_timer_list_show(void);
 
-/*
- * Timer-statistics info:
- */
-#ifdef CONFIG_TIMER_STATS
-
-extern void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
-				     void *timerf, char *comm,
-				     unsigned int timer_flag);
-
-static inline void timer_stats_account_hrtimer(struct hrtimer *timer)
-{
-	if (likely(!timer_stats_active))
-		return;
-	timer_stats_update_stats(timer, timer->start_pid, timer->start_site,
-				 timer->function, timer->start_comm, 0);
-}
-
-extern void __timer_stats_hrtimer_set_start_info(struct hrtimer *timer,
-						 void *addr);
-
-static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
-{
-	__timer_stats_hrtimer_set_start_info(timer, __builtin_return_address(0));
-}
-
-static inline void timer_stats_hrtimer_clear_start_info(struct hrtimer *timer)
-{
-	timer->start_site = NULL;
-}
-#else
-static inline void timer_stats_account_hrtimer(struct hrtimer *timer)
-{
-}
-
-static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
-{
-}
-
-static inline void timer_stats_hrtimer_clear_start_info(struct hrtimer *timer)
-{
-}
-#endif
-
 #endif
Index: linux-2.6/kernel/hrtimer.c
===================================================================
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -747,17 +747,33 @@ static inline void hrtimer_init_timer_hr
 
 #endif /* CONFIG_HIGH_RES_TIMERS */
 
-#ifdef CONFIG_TIMER_STATS
-void __timer_stats_hrtimer_set_start_info(struct hrtimer *timer, void *addr)
+static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
 {
+#ifdef CONFIG_TIMER_STATS
 	if (timer->start_site)
 		return;
-
-	timer->start_site = addr;
+	timer->start_site = __builtin_return_address(0);
 	memcpy(timer->start_comm, current->comm, TASK_COMM_LEN);
 	timer->start_pid = current->pid;
+#endif
 }
+
+static inline void timer_stats_hrtimer_clear_start_info(struct hrtimer *timer)
+{
+#ifdef CONFIG_TIMER_STATS
+	timer->start_site = NULL;
 #endif
+}
+
+static inline void timer_stats_account_hrtimer(struct hrtimer *timer)
+{
+#ifdef CONFIG_TIMER_STATS
+	if (likely(!timer_stats_active))
+		return;
+	timer_stats_update_stats(timer, timer->start_pid, timer->start_site,
+				 timer->function, timer->start_comm, 0);
+#endif
+}
 
 /*
  * Counterpart to lock_hrtimer_base above:
