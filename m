Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbZLBReh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbZLBReh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 12:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbZLBReg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 12:34:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:50624 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755023AbZLBRee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 12:34:34 -0500
Date: Wed, 2 Dec 2009 17:33:34 GMT
From: tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, spencer@bluehost.com, hpa@zytor.com,
       mingo@redhat.com, seto.hidetoshi@jp.fujitsu.com, peterz@infradead.org,
       xiyou.wangcong@gmail.com, balbir@in.ibm.com, tglx@linutronix.de,
       oleg@redhat.com, sgruszka@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, spencer@bluehost.com,
       linux-kernel@vger.kernel.org, seto.hidetoshi@jp.fujitsu.com,
       peterz@infradead.org, xiyou.wangcong@gmail.com, balbir@in.ibm.com,
       oleg@redhat.com, tglx@linutronix.de, sgruszka@redhat.com, mingo@elte.hu
In-Reply-To: <4B1624C7.7040302@jp.fujitsu.com>
References: <4B1624C7.7040302@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, cputime: Cleanups related to task_times()
Message-ID: <tip-d99ca3b977fc5a93141304f571475c2af9e6c1c5@git.kernel.org>
Git-Commit-ID: d99ca3b977fc5a93141304f571475c2af9e6c1c5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d99ca3b977fc5a93141304f571475c2af9e6c1c5
Gitweb:     http://git.kernel.org/tip/d99ca3b977fc5a93141304f571475c2af9e6c1c5
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Wed, 2 Dec 2009 17:26:47 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Dec 2009 17:32:39 +0100

sched, cputime: Cleanups related to task_times()

- Remove if({u,s}t)s because no one call it with NULL now.
- Use cputime_{add,sub}().
- Add ifndef-endif for prev_{u,s}time since they are used
  only when !VIRT_CPU_ACCOUNTING.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Spencer Candland <spencer@bluehost.com>
Cc: Americo Wang <xiyou.wangcong@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
LKML-Reference: <4B1624C7.7040302@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    2 ++
 kernel/fork.c         |    2 ++
 kernel/sched.c        |   16 ++++++----------
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0395b0f..dff85e5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1331,7 +1331,9 @@ struct task_struct {
 
 	cputime_t utime, stime, utimescaled, stimescaled;
 	cputime_t gtime;
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	cputime_t prev_utime, prev_stime;
+#endif
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time; 		/* monotonic time */
 	struct timespec real_start_time;	/* boot based time */
diff --git a/kernel/fork.c b/kernel/fork.c
index 166b8c4..ad7cb6d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1066,8 +1066,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->gtime = cputime_zero;
 	p->utimescaled = cputime_zero;
 	p->stimescaled = cputime_zero;
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	p->prev_utime = cputime_zero;
 	p->prev_stime = cputime_zero;
+#endif
 
 	p->default_timer_slack_ns = current->timer_slack_ns;
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 4883fee..17e2c1d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5184,10 +5184,8 @@ void account_idle_ticks(unsigned long ticks)
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
 void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
-	if (ut)
-		*ut = p->utime;
-	if (st)
-		*st = p->stime;
+	*ut = p->utime;
+	*st = p->stime;
 }
 #else
 
@@ -5197,7 +5195,7 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 
 void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
-	cputime_t rtime, utime = p->utime, total = utime + p->stime;
+	cputime_t rtime, utime = p->utime, total = cputime_add(utime, p->stime);
 
 	/*
 	 * Use CFS's precise accounting:
@@ -5217,12 +5215,10 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	 * Compare with previous values, to keep monotonicity:
 	 */
 	p->prev_utime = max(p->prev_utime, utime);
-	p->prev_stime = max(p->prev_stime, rtime - p->prev_utime);
+	p->prev_stime = max(p->prev_stime, cputime_sub(rtime, p->prev_utime));
 
-	if (ut)
-		*ut = p->prev_utime;
-	if (st)
-		*st = p->prev_stime;
+	*ut = p->prev_utime;
+	*st = p->prev_stime;
 }
 #endif
 
