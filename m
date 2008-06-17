Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbYFQItj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbYFQItj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 04:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbYFQIta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 04:49:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42067 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbYFQIt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 04:49:29 -0400
Subject: Re: [BUG: NULL pointer dereference] cgroups and
	RT	scheduling	interact badly.
From: Peter Zijlstra <peterz@infradead.org>
To: "Daniel K." <dk@uw.no>
Cc: mingo@elte.hu, menage@google.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <1213629536.16944.109.camel@twins>
References: <485445AE.2010602@uw.no> <1213612447.16944.99.camel@twins>
	 <4856671B.1020304@uw.no>  <1213624312.16944.104.camel@twins>
	 <1213627148.16944.106.camel@twins>  <485682B0.8010805@uw.no>
	 <1213629536.16944.109.camel@twins>
Content-Type: text/plain
Date: Tue, 17 Jun 2008 10:49:17 +0200
Message-Id: <1213692557.16944.153.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-16 at 17:18 +0200, Peter Zijlstra wrote:
> On Mon, 2008-06-16 at 17:11 +0200, Daniel K. wrote:
> > Peter Zijlstra wrote:
> > > On Mon, 2008-06-16 at 15:51 +0200, Peter Zijlstra wrote:
> > >> On Mon, 2008-06-16 at 15:14 +0200, Daniel K. wrote:
> > >>> Peter Zijlstra wrote:
> > >>>
> > >>> Although this patch seems to be correct, this is what shows up on my
> > >>> netconsole, when applying it -- with an offset, do you have other fixes
> > >>> applied as well?
> > >> I had indeed, although nothing touching the rt scheduler. I popped all
> > >> my patches and pulled an update from Linus, but I fail to reproduce the
> > >> below.
> > >>
> > >> /me goes look for that burnp6 thing, I used a simple while (1); loop.
> > > 
> > > found it, still seems to work for me. do you have a funny number of
> > > cpus? or anything else noteworthy?
> > 
> > I don't think so, this is on a SUN X2200 M2, with two AMD Opteron 2214
> > processors, and 8G RAM.
> > 
> > If I follow the procedure up to 'echo 4000 > oops/cpu.rt_runtime_us'
> > then I can
> > 
> > # burnP6 &
> > [1] 3395
> > # schedtool -R -p 1 3395
> > 
> > but
> > 
> > # echo -n 3395 > /dev/cgroup/burn/oops/tasks
> 
> Ah, that did it,.. I'll go poke at it. Thanks!

How's this work for you? (includes the previuos patchlet too)

---
Subject: sched: rt-group: fix NULL deref

 - the rt group hierarchy got corrupted by always pointing the entity's
rq pointer to the root rq.

 - the enqueue/dequeue on throttle should also use the full
dequeue_rt_stack like regular task enqueue/dequeue do. Not doing this
can leave empty groups and possibly corrupt the priority queues.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/kernel/sched.c b/kernel/sched.c
index eaf6751..efbb7d9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7626,7 +7626,6 @@ static void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
 	else
 		rt_se->rt_rq = parent->my_q;
 
-	rt_se->rt_rq = &rq->rt;
 	rt_se->my_q = rt_rq;
 	rt_se->parent = parent;
 	INIT_LIST_HEAD(&rt_se->run_list);
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 3432d57..95c408e 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -449,7 +449,7 @@ void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 #endif
 }
 
-static void enqueue_rt_entity(struct sched_rt_entity *rt_se)
+static void __enqueue_rt_entity(struct sched_rt_entity *rt_se)
 {
 	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
 	struct rt_prio_array *array = &rt_rq->active;
@@ -464,7 +464,7 @@ static void enqueue_rt_entity(struct sched_rt_entity *rt_se)
 	inc_rt_tasks(rt_se, rt_rq);
 }
 
-static void dequeue_rt_entity(struct sched_rt_entity *rt_se)
+static void __dequeue_rt_entity(struct sched_rt_entity *rt_se)
 {
 	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
 	struct rt_prio_array *array = &rt_rq->active;
@@ -480,11 +480,10 @@ static void dequeue_rt_entity(struct sched_rt_entity *rt_se)
  * Because the prio of an upper entry depends on the lower
  * entries, we must remove entries top - down.
  */
-static void dequeue_rt_stack(struct task_struct *p)
+static void dequeue_rt_stack(struct sched_rt_entity *rt_se)
 {
-	struct sched_rt_entity *rt_se, *back = NULL;
+	struct sched_rt_entity *back = NULL;
 
-	rt_se = &p->rt;
 	for_each_sched_rt_entity(rt_se) {
 		rt_se->back = back;
 		back = rt_se;
@@ -492,7 +491,26 @@ static void dequeue_rt_stack(struct task_struct *p)
 
 	for (rt_se = back; rt_se; rt_se = rt_se->back) {
 		if (on_rt_rq(rt_se))
-			dequeue_rt_entity(rt_se);
+			__dequeue_rt_entity(rt_se);
+	}
+}
+
+static void enqueue_rt_entity(struct sched_rt_entity *rt_se)
+{
+	dequeue_rt_stack(rt_se);
+	for_each_sched_rt_entity(rt_se)
+		__enqueue_rt_entity(rt_se);
+}
+
+static void dequeue_rt_entity(struct sched_rt_entity *rt_se)
+{
+	dequeue_rt_stack(rt_se);
+
+	for_each_sched_rt_entity(rt_se) {
+		struct rt_rq *rt_rq = group_rt_rq(rt_se);
+
+		if (rt_rq && rt_rq->rt_nr_running)
+			__enqueue_rt_entity(rt_se);
 	}
 }
 
@@ -506,32 +524,15 @@ static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)
 	if (wakeup)
 		rt_se->timeout = 0;
 
-	dequeue_rt_stack(p);
-
-	/*
-	 * enqueue everybody, bottom - up.
-	 */
-	for_each_sched_rt_entity(rt_se)
-		enqueue_rt_entity(rt_se);
+	enqueue_rt_entity(rt_se);
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
 {
 	struct sched_rt_entity *rt_se = &p->rt;
-	struct rt_rq *rt_rq;
 
 	update_curr_rt(rq);
-
-	dequeue_rt_stack(p);
-
-	/*
-	 * re-enqueue all non-empty rt_rq entities.
-	 */
-	for_each_sched_rt_entity(rt_se) {
-		rt_rq = group_rt_rq(rt_se);
-		if (rt_rq && rt_rq->rt_nr_running)
-			enqueue_rt_entity(rt_se);
-	}
+	dequeue_rt_entity(rt_se);
 }
 
 /*


