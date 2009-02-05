Return-Path: <linux-kernel-owner+w=401wt.eu-S1757590AbZBEOfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbZBEOfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 09:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757225AbZBEOfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 09:35:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56335 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbZBEOfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 09:35:07 -0500
Date: Thu, 5 Feb 2009 15:34:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mandeep Singh Baines <msb@google.com>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       rientjes@google.com, mbligh@google.com, thockin@google.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2 v4] softlockup: check all tasks in hung_task
Message-ID: <20090205143453.GG28443@elte.hu>
References: <20090204194339.GB22608@elte.hu> <20090205043548.GA18933@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090205043548.GA18933@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mandeep Singh Baines <msb@google.com> wrote:

> The batch_count controls the preemptibility of hung_task. While it might 
> not make sense to expose the value to user-space, we may want to use a 
> different value for the PREEMPT config (not sure what the specific values 
> should be):
> 
> #if defined(CONFIG_PREEMPT) && !defined(CONFIG_PREEMPT_RCU)
> static const int check_count_batching = 256;
> #else
> static const int check_count_batching = 2048;
> #endif

That really is not worth it - and such #ifdefs always look ugly and split 
testing as well.

I've applied your patch to tip:core/softlockup, thanks Mandeep!

	Ingo

------------->
>From 9952001914a7230ab88212a1e2d0e80208bdb907 Mon Sep 17 00:00:00 2001
From: Mandeep Singh Baines <msb@google.com>
Date: Wed, 4 Feb 2009 20:35:48 -0800
Subject: [PATCH] softlockup: check all tasks in hung_task
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Impact: extend the scope of hung-task checks

Changed the default value of hung_task_check_count to PID_MAX_LIMIT.
hung_task_batch_count added to put an upper bound on the critical
section. Every hung_task_batch_count checks, the rcu lock is never
held for a too long time.

Keeping the critical section small minimizes time preemption is disabled
and keeps rcu grace periods small.

To prevent following a stale pointer, get_task_struct is called on g and t.
To verify that g and t have not been unhashed while outside the critical
section, the task states are checked.

The design was proposed by Frédéric Weisbecker.

Signed-off-by: Mandeep Singh Baines <msb@google.com>
Suggested-by: Frédéric Weisbecker <fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/hung_task.c |   39 +++++++++++++++++++++++++++++++++++++--
 1 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index ba8ccd4..d32d293 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -17,9 +17,18 @@
 #include <linux/sysctl.h>
 
 /*
- * Have a reasonable limit on the number of tasks checked:
+ * The number of tasks checked:
  */
-unsigned long __read_mostly sysctl_hung_task_check_count = 1024;
+unsigned long __read_mostly sysctl_hung_task_check_count = PID_MAX_LIMIT;
+
+/*
+ * Limit number of tasks checked in a batch.
+ *
+ * This value controls the preemptibility of khungtaskd since preemption
+ * is disabled during the critical section. It also controls the size of
+ * the RCU grace period. So it needs to be upper-bound.
+ */
+static const int hung_task_batching = 1024;
 
 /*
  * Zero means infinite timeout - no checking done:
@@ -109,6 +118,24 @@ static void check_hung_task(struct task_struct *t, unsigned long now,
 		panic("hung_task: blocked tasks");
 }
 
+ /*
+  * To avoid extending the RCU grace period for an unbounded amount of time,
+  * periodically exit the critical section and enter a new one.
+  *
+  * For preemptible RCU it is sufficient to call rcu_read_unlock in order
+  * exit the grace period. For classic RCU, a reschedule is required.
+  */
+static void rcu_lock_break(struct task_struct *g, struct task_struct *t)
+{
+	get_task_struct(g);
+	get_task_struct(t);
+	rcu_read_unlock();
+	cond_resched();
+	rcu_read_lock();
+	put_task_struct(t);
+	put_task_struct(g);
+}
+
 /*
  * Check whether a TASK_UNINTERRUPTIBLE does not get woken up for
  * a really long time (120 seconds). If that happens, print out
@@ -116,6 +143,7 @@ static void check_hung_task(struct task_struct *t, unsigned long now,
  */
 static void check_hung_uninterruptible_tasks(unsigned long timeout)
 {
+	int batch_count = hung_task_batching;
 	int max_count = sysctl_hung_task_check_count;
 	unsigned long now = get_timestamp();
 	struct task_struct *g, *t;
@@ -131,6 +159,13 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
 	do_each_thread(g, t) {
 		if (!--max_count)
 			goto unlock;
+		if (!--batch_count) {
+			batch_count = hung_task_batching;
+			rcu_lock_break(g, t);
+			/* Exit if t or g was unhashed during refresh. */
+			if (t->state == TASK_DEAD || g->state == TASK_DEAD)
+				goto unlock;
+		}
 		/* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */
 		if (t->state == TASK_UNINTERRUPTIBLE)
 			check_hung_task(t, now, timeout);
