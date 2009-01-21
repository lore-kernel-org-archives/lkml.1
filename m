Return-Path: <linux-kernel-owner+w=401wt.eu-S1764484AbZAUMkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764484AbZAUMkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 07:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758601AbZAUMkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 07:40:33 -0500
Received: from mail.gmx.net ([213.165.64.20]:46010 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758134AbZAUMkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 07:40:32 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19t5VA+NXltpVZ/GU4eowYXkHl5PXa5zxgdpnJIJR
	6rNTbhBaqP9iwG
Subject: Re: [git pull] scheduler fixes
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1232304855.5908.40.camel@marge.simson.net>
References: <20090111144305.GA7154@elte.hu>
	 <20090114121521.197dfc5e.akpm@linux-foundation.org>
	 <1231964647.14825.59.camel@laptop>
	 <20090116204049.f4d6ef1c.akpm@linux-foundation.org>
	 <1232173776.7073.21.camel@marge.simson.net>
	 <1232186054.6813.48.camel@marge.simson.net>
	 <1232186877.14073.59.camel@laptop>
	 <1232188484.6813.85.camel@marge.simson.net>
	 <1232193617.14073.67.camel@laptop>
	 <1232287718.12958.8.camel@marge.simson.net>
	 <1232292491.5204.3.camel@laptop>
	 <1232304855.5908.40.camel@marge.simson.net>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 13:40:28 +0100
Message-Id: <1232541628.10035.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-18 at 19:54 +0100, Mike Galbraith wrote:
> On Sun, 2009-01-18 at 16:28 +0100, Peter Zijlstra wrote:
> >
> > If however your workload consists of cpu hogs, each will run for the
> > full wakeup preemption 'slice' you now see these buddy pairs do.
> 
> Hm.  I had a whack buddy tags if you are one at tick in there, but
> removed it pending measurement.  I was wondering if a last buddy hog
> could end up getting the CPU back after having received his quanta and
> being resched, but haven't checked that yet.

Dunno if this really needs fixing, but it does happen, and frequently.

Buddies can be selected over waiting tasks despite having just received their
full slice and more.  Fix this by clearing the buddy tag in put_prev_entity()
or check_preempt_tick() if they've received their fair share.

Clear buddy status once a task has received it's fair share.

Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 kernel/sched_fair.c |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -768,8 +768,10 @@ check_preempt_tick(struct cfs_rq *cfs_rq
 
 	ideal_runtime = sched_slice(cfs_rq, curr);
 	delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
-	if (delta_exec > ideal_runtime)
+	if (delta_exec >= ideal_runtime) {
+		clear_buddies(cfs_rq, curr);
 		resched_task(rq_of(cfs_rq)->curr);
+	}
 }
 
 static void
@@ -818,6 +820,33 @@ static struct sched_entity *pick_next_en
 	return se;
 }
 
+static void cond_clear_buddy(struct cfs_rq *cfs_rq, struct sched_entity *prev)
+{
+	s64 delta_exec = prev->sum_exec_runtime;
+	u64 min = sysctl_sched_min_granularity;
+
+	/*
+	 * We need to clear buddy status if the previous task has received it's
+	 * fair share, but we don't want to increase overhead significantly for
+	 * fast/light tasks by calling sched_slice() too frequently.
+	 */
+	if (unlikely(prev->load.weight != NICE_0_LOAD)) {
+		struct load_weight load;
+
+		load.weight = prio_to_weight[NICE_TO_PRIO(0) - MAX_RT_PRIO];
+		load.inv_weight = prio_to_wmult[NICE_TO_PRIO(0) - MAX_RT_PRIO];
+		min = calc_delta_mine(min, prev->load.weight, &load);
+	}
+
+	delta_exec -= prev->prev_sum_exec_runtime;
+
+	if (delta_exec > min) {
+		delta_exec -= sched_slice(cfs_rq, prev);
+		if (delta_exec >= 0)
+			clear_buddies(cfs_rq, prev);
+	}
+}
+
 static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 {
 	/*
@@ -829,6 +858,8 @@ static void put_prev_entity(struct cfs_r
 
 	check_spread(cfs_rq, prev);
 	if (prev->on_rq) {
+		if (prev == cfs_rq->next || prev == cfs_rq->last)
+			cond_clear_buddy(cfs_rq, prev);
 		update_stats_wait_start(cfs_rq, prev);
 		/* Put 'current' back into the tree. */
 		__enqueue_entity(cfs_rq, prev);
 

