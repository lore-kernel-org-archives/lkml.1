Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601AbXIYKSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbXIYKSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 06:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbXIYKSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 06:18:36 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:53278 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbXIYKSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 06:18:35 -0400
Date: Tue, 25 Sep 2007 15:58:55 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git] CFS-devel, latest code
Message-ID: <20070925102855.GL26289@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070924214537.GA18980@elte.hu> <1190700652.6482.7.camel@Homer.simpson.net> <1190705759.11910.10.camel@Homer.simpson.net> <1190709207.11226.6.camel@Homer.simpson.net> <20070925091331.GA22905@elte.hu> <20070925094440.GK26289@linux.vnet.ibm.com> <20070925094040.GA28391@elte.hu> <20070925101044.GA923@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925101044.GA923@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 12:10:44PM +0200, Ingo Molnar wrote:
> So the patch below just removes the is_same_group() condition. But i can 
> still see bad (and obvious) latencies with Mike's 2-hogs test:
> 
>  taskset 01 perl -e 'while (1) {}' &
>  nice -19 taskset 02 perl -e 'while (1) {}' &
> 
> So something's amiss.

While I try recreating this myself, I wonder if this patch helps?

---
 kernel/sched_fair.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

Index: current/kernel/sched_fair.c
===================================================================
--- current.orig/kernel/sched_fair.c
+++ current/kernel/sched_fair.c
@@ -794,7 +794,8 @@ static void yield_task_fair(struct rq *r
 static void check_preempt_wakeup(struct rq *rq, struct task_struct *p)
 {
 	struct task_struct *curr = rq->curr;
-	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
+	struct cfs_rq *cfs_rq = task_cfs_rq(curr), *pcfs_rq;
+	struct sched_entity *se = &curr->se, *pse = &p->se;
 
 	if (unlikely(rt_prio(p->prio))) {
 		update_rq_clock(rq);
@@ -802,11 +803,19 @@ static void check_preempt_wakeup(struct 
 		resched_task(curr);
 		return;
 	}
-	if (is_same_group(curr, p)) {
-		s64 delta = curr->se.vruntime - p->se.vruntime;
 
-		if (delta > (s64)sysctl_sched_wakeup_granularity)
-			resched_task(curr);
+	for_each_sched_entity(se) {
+		cfs_rq = cfs_rq_of(se);
+		pcfs_rq = cfs_rq_of(pse);
+
+		if (cfs_rq == pcfs_rq) {
+			s64 delta = se->vruntime - pse->vruntime;
+
+			if (delta > (s64)sysctl_sched_wakeup_granularity)
+				resched_task(curr);
+			break;
+		}
+		pse = pse->parent;
 	}
 }
 

-- 
Regards,
vatsa
