Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbZLJMbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbZLJMbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 07:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbZLJMbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 07:31:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:33211 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885AbZLJMbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 07:31:11 -0500
Date: Thu, 10 Dec 2009 12:30:52 GMT
From: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       heiko.carstens@de.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       heiko.carstens@de.ibm.com, tglx@linutronix.de
In-Reply-To: <20091210095629.GC4144@osiris.boeblingen.de.ibm.com>
References: <20091210095629.GC4144@osiris.boeblingen.de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] hrtimer: move timer stats helper functions to hrtimer.c
Message-ID: <tip-5f201907dfe4ad42c44006ddfcec00ed12e59497@git.kernel.org>
Git-Commit-ID: 5f201907dfe4ad42c44006ddfcec00ed12e59497
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5f201907dfe4ad42c44006ddfcec00ed12e59497
Gitweb:     http://git.kernel.org/tip/5f201907dfe4ad42c44006ddfcec00ed12e59497
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Thu, 10 Dec 2009 10:56:29 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 10 Dec 2009 13:08:11 +0100

hrtimer: move timer stats helper functions to hrtimer.c

There is no reason to make timer_stats_hrtimer_set_start_info and
friends visible to the rest of the kernel. So move all of them to
hrtimer.c.  Also make timer_stats_hrtimer_set_start_info a static
inline function so it gets inlined and we avoid another function call.
Based on a patch by Thomas Gleixner.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
LKML-Reference: <20091210095629.GC4144@osiris.boeblingen.de.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/hrtimer.h |   43 -------------------------------------------
 kernel/hrtimer.c        |   24 ++++++++++++++++++++----
 2 files changed, 20 insertions(+), 47 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 040b679..af634e9 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -440,47 +440,4 @@ extern u64 ktime_divns(const ktime_t kt, s64 div);
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
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 931a4d9..d2f9239 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -756,17 +756,33 @@ static inline void hrtimer_init_timer_hres(struct hrtimer *timer) { }
 
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
