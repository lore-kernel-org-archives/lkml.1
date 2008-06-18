Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbYFRLvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbYFRLvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 07:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbYFRLvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 07:51:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:51359 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbYFRLvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 07:51:07 -0400
Subject: Re: [BUG: NULL pointer dereference] cgroups and	RT scheduling
	interact badly.
From: Peter Zijlstra <peterz@infradead.org>
To: "Daniel K." <dk@uw.no>
Cc: mingo@elte.hu, menage@google.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <48583122.7080409@uw.no>
References: <485445AE.2010602@uw.no> <1213612447.16944.99.camel@twins>
	 <4856671B.1020304@uw.no>  <1213624312.16944.104.camel@twins>
	 <1213627148.16944.106.camel@twins>  <485682B0.8010805@uw.no>
	 <1213629536.16944.109.camel@twins> <1213692557.16944.153.camel@twins>
	 <4857AD38.2090601@uw.no>
	 <1213732878.3223.95.camel@lappy.programming.kicks-ass.net>
	 <48583122.7080409@uw.no>
Content-Type: text/plain
Date: Wed, 18 Jun 2008 13:50:54 +0200
Message-Id: <1213789854.16944.216.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-17 at 21:48 +0000, Daniel K. wrote:
> Peter Zijlstra wrote:
> > On Tue, 2008-06-17 at 14:25 +0200, Daniel K. wrote:
> >> Peter Zijlstra wrote:
> >>> How's this [patch] work for you? (includes the previuos patchlet too)
> >> Thanks,
> >>
> >> this patch fixed the obvious problem, namely
> >>
> >> # echo $$ > /dev/cgroup/burn/oops/tasks
> >> # schedtool -R -p 1 -e burnP6 &
> >>
> >> now works again. However, the last step below
> >>
> >> # echo $$ > /dev/cgroup/tasks
> >> # burnP6 &
> >> [1] 3414
> >> # echo 3414 > /dev/cgroup/burn/oops/tasks
> >> # schedtool -R -p 1 3414
> >>
> >> gives this new and shiny Oops instead.
> > 
> > Whilst I'm gracious for your testing, I truly hope you're done breaking
> > my stuff ;-)
> > 
> > How's this for you?
> 
> root@lc01:/dev/cgroup/burn# burnP6 &
> [1] 3393
> root@lc01:/dev/cgroup/burn# schedtool -R -p 1 3393
> root@lc01:/dev/cgroup/burn# echo 3393 > oops/tasks
> root@lc01:/dev/cgroup/burn# schedtool -R -p 1 3393
> root@lc01:/dev/cgroup/burn# schedtool -R -p 1 3393
> 
> Multiple redundant schedtool invocations now work without incident.
> 
> I had almost given up trying to break it, but then this happened.
> 
> root@lc01:/dev/cgroup/burn# echo $$ > /dev/cgroup/burn/oops/tasks
> root@lc01:/dev/cgroup/burn# schedtool -R -p 1 -e burnP6 &
> [2] 3397
> 
> The following Oops happened immediately, but note that it was the first
> burnP6 process (PID 3393) that is reported as the offender.
> 
> I tried the above procedure a second time, and now it ran for about one
> second before the same Oops manifested itself, but this time with the
> other burnP6 process as the culprit (the equivalent of PID 3397)

Ah, fun a race between dequeueing because of runtime quota and
requeueing because of RR slice length.

> Yes, I realize I'm starting to sound like a broken record.

Ah, don't worry - I was just hoping there was an end to the amount of
glaring bugs in my code :-/

Reproducing was a bit harder than for you, it took me a whole minute of
runtime and setting the runtime limit above the RR slice length (and
realizing you're running RR, not FIFO).

The below patch (on top of the other one) seems to not make it crash
this case for at least 15 minutes.

---
Subject: sched: rt-group: fix RR buglet
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

In tick_task_rt() we first call update_curr_rt() which can dequeue a runqueue
due to it running out of runtime, and then we try to requeue it, of it also 
having exhausted its RR quota. Obviously requeueing something that is no longer
on the runqueue will not have the expected result.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_rt.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -549,8 +549,10 @@ static
 void requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se)
 {
 	struct rt_prio_array *array = &rt_rq->active;
+	struct list_head *queue = array->queue + rt_se_prio(rt_se);
 
-	list_move_tail(&rt_se->run_list, array->queue + rt_se_prio(rt_se));
+	if (on_rt_rq(rt_se))
+		list_move_tail(&rt_se->run_list, queue);
 }
 
 static void requeue_task_rt(struct rq *rq, struct task_struct *p)




