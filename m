Return-Path: <linux-kernel-owner+w=401wt.eu-S1756969AbZJIGfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969AbZJIGfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 02:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756315AbZJIGfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 02:35:53 -0400
Received: from mail.gmx.net ([213.165.64.20]:57351 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754351AbZJIGfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 02:35:53 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/FrllbDF3FMoRfB3OIWWyvdG9fa3exEmgpknOzY8
	xIv/0RSKNPK42L
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for
 CPU"
From: Mike Galbraith <efault@gmx.de>
To: Frans Pop <elendil@planet.nl>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-wireless@vger.kernel.org
In-Reply-To: <200910082259.35204.elendil@planet.nl>
References: <200910051500.55875.elendil@planet.nl>
	 <200910081655.37485.elendil@planet.nl>
	 <1255026217.6643.12.camel@marge.simson.net>
	 <200910082259.35204.elendil@planet.nl>
Content-Type: text/plain
Date: Fri, 09 Oct 2009 08:35:03 +0200
Message-Id: <1255070103.7639.30.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-08 at 22:59 +0200, Frans Pop wrote:
> On Thursday 08 October 2009, Mike Galbraith wrote:
> > I still see very high latencies coming out of idle (last noted was >
> > 300ms, NO_HZ) with this patch,
> >
> > Like this:
> >
> > Cause                                           Maximum    Percentage
> > Scheduler: waiting for cpu                   604.2 msec        49.0 %
> 
> I'm not seeing anything even remotely like that.

Instrumenting, I saw (stale) clock deltas of >900ms coming out of idle,
delta being the difference between rq->clock when we hit update_curr()
and discover that this queue was idle, and what the clock will be an
instant or two later when somebody winds the clock.

I've been watching latencytop for a while now to make sure latency is
really dead.  I see no twitching, so...

sched: update the clock of runqueue select_task_rq() selected.

In try_to_wake_up(), we update the runqueue clock, but select_task_rq()
may select a different runqueue than the one we updated, leaving the new
runqueue's clock stale for a bit.

This patch cures occasional huge latencies reported by latencytop when
coming out of idle on a mostly idle NO_HZ box.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 kernel/sched.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2311,7 +2311,7 @@ static int try_to_wake_up(struct task_st
 {
 	int cpu, orig_cpu, this_cpu, success = 0;
 	unsigned long flags;
-	struct rq *rq;
+	struct rq *rq, *orig_rq;
 
 	if (!sched_feat(SYNC_WAKEUPS))
 		wake_flags &= ~WF_SYNC;
@@ -2319,7 +2319,7 @@ static int try_to_wake_up(struct task_st
 	this_cpu = get_cpu();
 
 	smp_wmb();
-	rq = task_rq_lock(p, &flags);
+	rq = orig_rq = task_rq_lock(p, &flags);
 	update_rq_clock(rq);
 	if (!(p->state & state))
 		goto out;
@@ -2350,6 +2350,10 @@ static int try_to_wake_up(struct task_st
 		set_task_cpu(p, cpu);
 
 	rq = task_rq_lock(p, &flags);
+
+	if (rq != orig_rq)
+		update_rq_clock(rq);
+
 	WARN_ON(p->state != TASK_WAKING);
 	cpu = task_cpu(p);
 


