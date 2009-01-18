Return-Path: <linux-kernel-owner+w=401wt.eu-S933529AbZAROI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933529AbZAROI6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 09:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760617AbZAROIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 09:08:48 -0500
Received: from mail.gmx.net ([213.165.64.20]:49874 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760494AbZAROIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 09:08:47 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/IZAxauwHIgIhm2IJU2hEV9x0DSRtXAeCoZmWyVg
	hQdR4ljfLJ8DjH
Subject: Re: [git pull] scheduler fixes
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1232193617.14073.67.camel@laptop>
References: <20090111144305.GA7154@elte.hu>
	 <20090114121521.197dfc5e.akpm@linux-foundation.org>
	 <1231964647.14825.59.camel@laptop>
	 <20090116204049.f4d6ef1c.akpm@linux-foundation.org>
	 <1232173776.7073.21.camel@marge.simson.net>
	 <1232186054.6813.48.camel@marge.simson.net>
	 <1232186877.14073.59.camel@laptop>
	 <1232188484.6813.85.camel@marge.simson.net>
	 <1232193617.14073.67.camel@laptop>
Content-Type: text/plain
Date: Sun, 18 Jan 2009 15:08:38 +0100
Message-Id: <1232287718.12958.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-17 at 13:00 +0100, Peter Zijlstra wrote:
> On Sat, 2009-01-17 at 11:34 +0100, Mike Galbraith wrote:
> > > Right, how about we flip the 'initial' case in place_entity() for !
> > > nr_exclusive wakeups.
> > 
> > Wouldn't that be more drastic than sleep denial?
> 
> Strictly speaking that DEBIT thing is valid for each wakeup, IIRC we
> restricted it to clone() only because that was where we could actually
> observe these latency spikes using a fork-bomb.
> 
> This reduces the latency hits to around 400ms, which is about right for
> the given load.

Disregarding the startup landmine for the moment, maybe we should put a
buddy slice knob in the user's hands, so they can tune latency, along
with a full on/off switch for those who care not one whit about
scalability.

ProcessSchedulerTest 100 100000

2.6.29.git
min:0.003ms|avg:0.003-0.004ms|mid:0.003ms|max:691.454ms|duration:-0.324s
min:0.003ms|avg:0.003-0.004ms|mid:0.003ms|max:700.731ms|duration:-0.407s
min:0.003ms|avg:0.003-0.004ms|mid:0.003ms|max:688.367ms|duration:-0.388s

NO_LAST_BUDDY
min:0.003ms|avg:0.003-0.004ms|mid:0.004ms|max:90.659ms|duration:0.035s
min:0.003ms|avg:0.003-0.004ms|mid:0.004ms|max:94.995ms|duration:0.022s
min:0.003ms|avg:0.003-0.004ms|mid:0.004ms|max:75.753ms|duration:0.148s

2.6.29.git + buddy_slice.diff

NO_BUDDIES
min:0.003ms|avg:0.003-0.024ms|mid:0.012ms|max:14.548ms|duration:0.731s
min:0.003ms|avg:0.003-0.028ms|mid:0.015ms|max:14.986ms|duration:0.760s
min:0.003ms|avg:0.003-0.028ms|mid:0.019ms|max:15.257ms|duration:0.782s

BUDDIES
sched_buddy_slice_ns=100000
min:0.003ms|avg:0.003-0.004ms|mid:0.003ms|max:21.199ms|duration:-0.101s
min:0.003ms|avg:0.003-0.004ms|mid:0.003ms|max:21.602ms|duration:-0.030s
min:0.003ms|avg:0.003-0.004ms|mid:0.003ms|max:18.421ms|duration:-0.124s

sched_buddy_slice_ns=1000000
min:0.003ms|avg:0.003-0.004ms|mid:0.003ms|max:55.067ms|duration:-0.224s
min:0.003ms|avg:0.003-0.004ms|mid:0.003ms|max:58.090ms|duration:-0.036s
min:0.003ms|avg:0.003-0.004ms|mid:0.003ms|max:72.055ms|duration:0.025s

sched_buddy_slice_ns=2000000
min:0.003ms|avg:0.003-0.004ms|mid:0.003ms|max:244.128ms|duration:-0.052s
min:0.003ms|avg:0.003-0.004ms|mid:0.003ms|max:230.404ms|duration:-0.153s
min:0.003ms|avg:0.003-0.004ms|mid:0.003ms|max:229.958ms|duration:0.030s

sched_buddy_slice_ns=4000000 (default)
min:0.003ms|avg:0.003-0.004ms|mid:0.003ms|max:396.093ms|duration:-0.016s
min:0.003ms|avg:0.003-0.004ms|mid:0.003ms|max:366.363ms|duration:-0.055s
min:0.003ms|avg:0.003-0.004ms|mid:0.003ms|max:360.373ms|duration:-0.129s

sched_buddy_slice_ns=15000000
min:0.003ms|avg:0.003-0.004ms|mid:0.003ms|max:670.781ms|duration:-0.086s
min:0.003ms|avg:0.003-0.004ms|mid:0.003ms|max:563.612ms|duration:-0.049s
min:0.003ms|avg:0.003-0.004ms|mid:0.003ms|max:680.968ms|duration:-0.244s


diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4cae9b8..0ea8eb7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1708,6 +1708,7 @@ static inline void wake_up_idle_cpu(int cpu) { }
 
 extern unsigned int sysctl_sched_latency;
 extern unsigned int sysctl_sched_min_granularity;
+extern unsigned int sysctl_sched_buddy_slice;
 extern unsigned int sysctl_sched_wakeup_granularity;
 extern unsigned int sysctl_sched_shares_ratelimit;
 extern unsigned int sysctl_sched_shares_thresh;
diff --git a/kernel/sched.c b/kernel/sched.c
index 52bbf1c..f37c243 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -406,6 +406,7 @@ struct cfs_rq {
 
 	u64 exec_clock;
 	u64 min_vruntime;
+	u64 pair_start;
 
 	struct rb_root tasks_timeline;
 	struct rb_node *rb_leftmost;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5cc1c16..e261cd5 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -43,6 +43,12 @@ unsigned int sysctl_sched_latency = 20000000ULL;
 unsigned int sysctl_sched_min_granularity = 4000000ULL;
 
 /*
+ * Buddy timeslice:
+ * (default: 4 msec * (1 + ilog(ncpus)), units: nanoseconds)
+ */
+unsigned int sysctl_sched_buddy_slice = 4000000ULL;
+
+/*
  * is kept at sysctl_sched_latency / sysctl_sched_min_granularity
  */
 static unsigned int sched_nr_latency = 5;
@@ -808,6 +814,11 @@ wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
 static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *se = __pick_next_entity(cfs_rq);
+	struct rq *rq = rq_of(cfs_rq);
+	u64 buddy_slice = rq->clock - cfs_rq->pair_start;
+
+	if (buddy_slice > sysctl_sched_buddy_slice)
+		goto out;
 
 	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, se) < 1)
 		return cfs_rq->next;
@@ -815,6 +826,9 @@ static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, se) < 1)
 		return cfs_rq->last;
 
+out:
+	cfs_rq->pair_start = rq->clock;
+
 	return se;
 }
 
@@ -1347,6 +1361,9 @@ wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se)
 
 static void set_last_buddy(struct sched_entity *se)
 {
+	if (!sched_feat(BUDDIES))
+		return;
+
 	if (likely(task_of(se)->policy != SCHED_IDLE)) {
 		for_each_sched_entity(se)
 			cfs_rq_of(se)->last = se;
@@ -1355,6 +1372,9 @@ static void set_last_buddy(struct sched_entity *se)
 
 static void set_next_buddy(struct sched_entity *se)
 {
+	if (!sched_feat(BUDDIES))
+		return;
+
 	if (likely(task_of(se)->policy != SCHED_IDLE)) {
 		for_each_sched_entity(se)
 			cfs_rq_of(se)->next = se;
@@ -1392,7 +1412,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
 	 * Also, during early boot the idle thread is in the fair class, for
 	 * obvious reasons its a bad idea to schedule back to the idle thread.
 	 */
-	if (sched_feat(LAST_BUDDY) && likely(se->on_rq && curr != rq->idle))
+	if (likely(se->on_rq && curr != rq->idle))
 		set_last_buddy(se);
 	set_next_buddy(pse);
 
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index da5d93b..3a194fa 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -12,4 +12,4 @@ SCHED_FEAT(LB_BIAS, 1)
 SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
 SCHED_FEAT(ASYM_EFF_LOAD, 1)
 SCHED_FEAT(WAKEUP_OVERLAP, 0)
-SCHED_FEAT(LAST_BUDDY, 1)
+SCHED_FEAT(BUDDIES, 1)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 368d163..733ddb6 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -254,6 +254,17 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_buddy_slice_ns",
+		.data		= &sysctl_sched_buddy_slice,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &sched_nr_latency_handler,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &min_sched_granularity_ns,
+		.extra2		= &max_sched_granularity_ns,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_latency_ns",
 		.data		= &sysctl_sched_latency,
 		.maxlen		= sizeof(unsigned int),


