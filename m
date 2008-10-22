Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbYJVHZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbYJVHZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 03:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYJVHZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 03:25:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51090 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbYJVHZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 03:25:34 -0400
Message-ID: <48FED566.7020907@cn.fujitsu.com>
Date: Wed, 22 Oct 2008 15:25:26 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: mingo@elte.hu
CC: Peter Zijlstra <peterz@infradead.org>, henrik@austad.us,
       linux-kernel@vger.kernel.org, Henrik Austad <henrik.austad@gmail.com>
Subject: Re: sched: add CONFIG_SMP consistency
References: <1224614719-14452-1-git-send-email-henrik@austad.us> <1224615681.661.3.camel@twins>
In-Reply-To: <1224615681.661.3.camel@twins>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2008-10-21 at 20:45 +0200, henrik@austad.us wrote:
>> From: Henrik Austad <henrik.austad@gmail.com>
>>
>> Do not declare select_task_rq as part of sched_class when CONFIG_SMP is
>> not set.
> 

Not only select_task_rq(), but also set_cpus_allowed(), rq_online() and
rq_offline().

> While a proper cleanup, could you do it by re-arranging the methods so
> as to not create an additional ifdef?
> 

How about the following patch?

==================


From: Li Zefan <lizf@cn.fujitsu.com>
Date: Wed, 22 Oct 2008 15:13:06 +0800
Subject: [PATCH] make CONFIG_SMP consistent for sched_class methods

Do not declare select_task_rq and some other methods as part of sched_class
when CONFIG_SMP is not set.

Also gather those methods to avoid CONFIG_SMP mess.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/sched.h   |   12 +++++++-----
 kernel/sched_fair.c     |    5 ++---
 kernel/sched_idletask.c |    5 ++---
 kernel/sched_rt.c       |    5 ++---
 4 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5c38db5..fc1a615 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -941,7 +941,6 @@ struct sched_class {
 	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
 	void (*yield_task) (struct rq *rq);
-	int  (*select_task_rq)(struct task_struct *p, int sync);
 
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int sync);
 
@@ -949,6 +948,8 @@ struct sched_class {
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
 
 #ifdef CONFIG_SMP
+	int  (*select_task_rq)(struct task_struct *p, int sync);
+
 	unsigned long (*load_balance) (struct rq *this_rq, int this_cpu,
 			struct rq *busiest, unsigned long max_load_move,
 			struct sched_domain *sd, enum cpu_idle_type idle,
@@ -960,16 +961,17 @@ struct sched_class {
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
index f604dae..73bef78 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1576,9 +1576,6 @@ static const struct sched_class fair_sched_class = {
 	.enqueue_task		= enqueue_task_fair,
 	.dequeue_task		= dequeue_task_fair,
 	.yield_task		= yield_task_fair,
-#ifdef CONFIG_SMP
-	.select_task_rq		= select_task_rq_fair,
-#endif /* CONFIG_SMP */
 
 	.check_preempt_curr	= check_preempt_wakeup,
 
@@ -1586,6 +1583,8 @@ static const struct sched_class fair_sched_class = {
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
index b446dc8..d9ba9d5 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1504,9 +1504,6 @@ static const struct sched_class rt_sched_class = {
 	.enqueue_task		= enqueue_task_rt,
 	.dequeue_task		= dequeue_task_rt,
 	.yield_task		= yield_task_rt,
-#ifdef CONFIG_SMP
-	.select_task_rq		= select_task_rq_rt,
-#endif /* CONFIG_SMP */
 
 	.check_preempt_curr	= check_preempt_curr_rt,
 
@@ -1514,6 +1511,8 @@ static const struct sched_class rt_sched_class = {
 	.put_prev_task		= put_prev_task_rt,
 
 #ifdef CONFIG_SMP
+	.select_task_rq		= select_task_rq_rt,
+
 	.load_balance		= load_balance_rt,
 	.move_one_task		= move_one_task_rt,
 	.set_cpus_allowed       = set_cpus_allowed_rt,
-- 
1.5.4.rc3


