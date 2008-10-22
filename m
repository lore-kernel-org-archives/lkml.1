Return-Path: <linux-kernel-owner+w=401wt.eu-S1752907AbYJVHhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbYJVHhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 03:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYJVHg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 03:36:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33073 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbYJVHg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 03:36:57 -0400
Date: Wed, 22 Oct 2008 09:36:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, henrik@austad.us,
       linux-kernel@vger.kernel.org, Henrik Austad <henrik.austad@gmail.com>
Subject: Re: sched: add CONFIG_SMP consistency
Message-ID: <20081022073640.GA31633@elte.hu>
References: <1224614719-14452-1-git-send-email-henrik@austad.us> <1224615681.661.3.camel@twins> <48FED566.7020907@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FED566.7020907@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> How about the following patch?

i've applied it in the form below. Peter, does it look good to you too?

	Ingo

-------------->
>From 667ff69f5a248fde6cf871f2c9c5c5d2aa182e71 Mon Sep 17 00:00:00 2001
From: Li Zefan <lizf@cn.fujitsu.com>
Date: Wed, 22 Oct 2008 15:25:26 +0800
Subject: [PATCH] sched: add CONFIG_SMP consistency

a patch from Henrik Austad did this:

>> Do not declare select_task_rq as part of sched_class when CONFIG_SMP is
>> not set.

Peter observed:

> While a proper cleanup, could you do it by re-arranging the methods so
> as to not create an additional ifdef?

Do not declare select_task_rq and some other methods as part of sched_class
when CONFIG_SMP is not set.

Also gather those methods to avoid CONFIG_SMP mess.

Idea-by: Henrik Austad <henrik.austad@gmail.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h   |   12 +++++++-----
 kernel/sched_fair.c     |    5 ++---
 kernel/sched_idletask.c |    5 ++---
 kernel/sched_rt.c       |    5 ++---
 4 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4f59c8e..c05b45f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -897,7 +897,6 @@ struct sched_class {
 	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
 	void (*yield_task) (struct rq *rq);
-	int  (*select_task_rq)(struct task_struct *p, int sync);
 
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int sync);
 
@@ -905,6 +904,8 @@ struct sched_class {
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
 
 #ifdef CONFIG_SMP
+	int  (*select_task_rq)(struct task_struct *p, int sync);
+
 	unsigned long (*load_balance) (struct rq *this_rq, int this_cpu,
 			struct rq *busiest, unsigned long max_load_move,
 			struct sched_domain *sd, enum cpu_idle_type idle,
@@ -916,16 +917,17 @@ struct sched_class {
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
 	void (*post_schedule) (struct rq *this_rq);
 	void (*task_wake_up) (struct rq *this_rq, struct task_struct *task);
-#endif
 
-	void (*set_curr_task) (struct rq *rq);
-	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
-	void (*task_new) (struct rq *rq, struct task_struct *p);
 	void (*set_cpus_allowed)(struct task_struct *p,
 				 const cpumask_t *newmask);
 
 	void (*rq_online)(struct rq *rq);
 	void (*rq_offline)(struct rq *rq);
+#endif
+
+	void (*set_curr_task) (struct rq *rq);
+	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
+	void (*task_new) (struct rq *rq, struct task_struct *p);
 
 	void (*switched_from) (struct rq *this_rq, struct task_struct *task,
 			       int running);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a0aa38b..8de48a5 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1593,9 +1593,6 @@ static const struct sched_class fair_sched_class = {
 	.enqueue_task		= enqueue_task_fair,
 	.dequeue_task		= dequeue_task_fair,
 	.yield_task		= yield_task_fair,
-#ifdef CONFIG_SMP
-	.select_task_rq		= select_task_rq_fair,
-#endif /* CONFIG_SMP */
 
 	.check_preempt_curr	= check_preempt_wakeup,
 
@@ -1603,6 +1600,8 @@ static const struct sched_class fair_sched_class = {
 	.put_prev_task		= put_prev_task_fair,
 
 #ifdef CONFIG_SMP
+	.select_task_rq		= select_task_rq_fair,
+
 	.load_balance		= load_balance_fair,
 	.move_one_task		= move_one_task_fair,
 #endif
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index dec4cca..8a21a2e 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -105,9 +105,6 @@ static const struct sched_class idle_sched_class = {
 
 	/* dequeue is not valid, we print a debug message there: */
 	.dequeue_task		= dequeue_task_idle,
-#ifdef CONFIG_SMP
-	.select_task_rq		= select_task_rq_idle,
-#endif /* CONFIG_SMP */
 
 	.check_preempt_curr	= check_preempt_curr_idle,
 
@@ -115,6 +112,8 @@ static const struct sched_class idle_sched_class = {
 	.put_prev_task		= put_prev_task_idle,
 
 #ifdef CONFIG_SMP
+	.select_task_rq		= select_task_rq_idle,
+
 	.load_balance		= load_balance_idle,
 	.move_one_task		= move_one_task_idle,
 #endif
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index cdf5740..c9aa5be 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1502,9 +1502,6 @@ static const struct sched_class rt_sched_class = {
 	.enqueue_task		= enqueue_task_rt,
 	.dequeue_task		= dequeue_task_rt,
 	.yield_task		= yield_task_rt,
-#ifdef CONFIG_SMP
-	.select_task_rq		= select_task_rq_rt,
-#endif /* CONFIG_SMP */
 
 	.check_preempt_curr	= check_preempt_curr_rt,
 
@@ -1512,6 +1509,8 @@ static const struct sched_class rt_sched_class = {
 	.put_prev_task		= put_prev_task_rt,
 
 #ifdef CONFIG_SMP
+	.select_task_rq		= select_task_rq_rt,
+
 	.load_balance		= load_balance_rt,
 	.move_one_task		= move_one_task_rt,
 	.set_cpus_allowed       = set_cpus_allowed_rt,
