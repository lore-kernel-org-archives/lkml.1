Return-Path: <linux-kernel-owner+w=401wt.eu-S1757799AbZAIW1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799AbZAIW1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932310AbZAIW0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:26:33 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:41622 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290AbZAIW01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:26:27 -0500
Message-ID: <4967CFC2.3090604@novell.com>
Date: Fri, 09 Jan 2009 17:29:22 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: 2.6.24.7-rt25 and 2.6.26.8-rt12
References: <1229752520.974.37.camel@localhost.localdomain> <20081228151026.GB28520@ghostprotocols.net>
In-Reply-To: <20081228151026.GB28520@ghostprotocols.net>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5D19101F24170B8A31EF8BDE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5D19101F24170B8A31EF8BDE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Arnaldo Carvalho de Melo wrote:
> Em Sat, Dec 20, 2008 at 12:55:20AM -0500, Steven Rostedt escreveu:
>  =20
>> We are pleased to announce the 2.6.24.7-rt25 and 2.6.26.8-rt12 trees,
>> which can be downloaded from the location:
>>
>>   http://rt.et.redhat.com/download/
>>
>> Information on the RT patch can be found at:
>>
>>   http://rt.wiki.kernel.org/index.php/Main_Page
>>
>> Changes since 2.6.26.6-rt11
>>    =20
>
> I managed to boot 2.6.26.8-rt12 once, but it oopsed when I started a
> market data workload while generating load with a make -j 64 kernel
> compile, couldn't get the proper backtrace because I was swamped with
> /proc/sys/kernel/hung_task_timeout_secs related messages.
Hi Arnaldo,

I believe this may have been a result of the patch:

sched-prioritize-non-migrating-rt-tasks.patch

Please try this patch:

----------------------

commit a8841359ef48279dd3c11f0dca614d7f9da6f7b7
Author: Gregory Haskins <ghaskins@novell.com>
Date:   Fri Jan 9 17:27:43 2009 -0500

    sched: revert "sched-prioritize-non-migrating-rt-tasks.patch"
  =20
    This patch was originally accepted to -rt and later pulled upstream
    to -tip.  However, it was later dropped due to a better alternative
    solutuion.  Therefore, we dropped this patch in 28-rt but inadvertent=
ly
    left it in 26-rt.  Now it seems to be causing a crash in 26.8-rt12.
    However, it is not worth finding/fixing the problem.  We should just
    drop the patch in 26-rt as well.
  =20
    For the convenience of testers out there, please apply this patch to
    -rt12 to revert the logic.  The proper solution for -rt13 is to just
    remove sched-prioritize-non-migrating-rt-tasks.patch from the series
    file.
  =20
    Signed-off-by: Gregory Haskins <ghaskins@novell.com>

diff --git a/kernel/sched.c b/kernel/sched.c
index c56bfde..88c9519 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -203,8 +203,7 @@ static inline int task_has_rt_policy(struct
task_struct *p)
  */
 struct rt_prio_array {
     DECLARE_BITMAP(bitmap, MAX_RT_PRIO+1); /* include 1 bit for
delimiter */
-    struct list_head xqueue[MAX_RT_PRIO];  /* exclusive queue */
-    struct list_head squeue[MAX_RT_PRIO];  /* shared queue */
+    struct list_head queue[MAX_RT_PRIO];
 };
=20
 struct rt_bandwidth {
@@ -8360,8 +8359,7 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct
rq *rq)
=20
     array =3D &rt_rq->active;
     for (i =3D 0; i < MAX_RT_PRIO; i++) {
-        INIT_LIST_HEAD(array->xqueue + i);
-        INIT_LIST_HEAD(array->squeue + i);
+        INIT_LIST_HEAD(array->queue + i);
         __clear_bit(i, array->bitmap);
     }
     /* delimiter for bitsearch: */
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 4eec7aa..3b92165 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -519,13 +519,7 @@ static void __enqueue_rt_entity(struct
sched_rt_entity *rt_se)
     if (group_rq && (rt_rq_throttled(group_rq) ||
!group_rq->rt_nr_running))
         return;
=20
-    if (rt_se->nr_cpus_allowed =3D=3D 1)
-        list_add_tail(&rt_se->run_list,
-                  array->xqueue + rt_se_prio(rt_se));
-    else
-        list_add_tail(&rt_se->run_list,
-                  array->squeue + rt_se_prio(rt_se));
-
+    list_add_tail(&rt_se->run_list, array->queue + rt_se_prio(rt_se));
     __set_bit(rt_se_prio(rt_se), array->bitmap);
=20
     inc_rt_tasks(rt_se, rt_rq);
@@ -537,8 +531,7 @@ static void __dequeue_rt_entity(struct
sched_rt_entity *rt_se)
     struct rt_prio_array *array =3D &rt_rq->active;
=20
     list_del_init(&rt_se->run_list);
-    if (list_empty(array->squeue + rt_se_prio(rt_se))
-        && list_empty(array->xqueue + rt_se_prio(rt_se)))
+    if (list_empty(array->queue + rt_se_prio(rt_se)))
         __clear_bit(rt_se_prio(rt_se), array->bitmap);
=20
     dec_rt_tasks(rt_se, rt_rq);
@@ -667,21 +660,15 @@ static void dequeue_task_rt(struct rq *rq, struct
task_struct *p, int sleep)
 /*
  * Put task to the end of the run list without the overhead of dequeue
  * followed by enqueue.
- *
- * Note: We always enqueue the task to the shared-queue, regardless of i=
ts
- * previous position w.r.t. exclusive vs shared.  This is so that
exclusive RR
- * tasks fairly round-robin with all tasks on the runqueue, not just oth=
er
- * exclusive tasks.
  */
 static
 void requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_entity *rt_s=
e)
 {
     struct rt_prio_array *array =3D &rt_rq->active;
+    struct list_head *queue =3D array->queue + rt_se_prio(rt_se);
=20
-    if (on_rt_rq(rt_se)) {
-        list_del_init(&rt_se->run_list);
-        list_add_tail(&rt_se->run_list, array->squeue + rt_se_prio(rt_se=
));
-    }
+    if (on_rt_rq(rt_se))
+        list_move_tail(&rt_se->run_list, queue);
 }
=20
 static void requeue_task_rt(struct rq *rq, struct task_struct *p)
@@ -739,46 +726,13 @@ static int select_task_rq_rt(struct task_struct
*p, int sync)
 }
 #endif /* CONFIG_SMP */
=20
-static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq,
-                           struct rt_rq *rt_rq);
-
 /*
  * Preempt the current task with a newly woken task if needed:
  */
 static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p)
 {
-    if (p->prio < rq->curr->prio) {
+    if (p->prio < rq->curr->prio)
         resched_task(rq->curr);
-        return;
-    }
-
-#ifdef CONFIG_SMP
-    /*
-     * If:
-     *
-     * - the newly woken task is of equal priority to the current task
-     * - the newly woken task is non-migratable while current is migrata=
ble
-     * - current will be preempted on the next reschedule
-     *
-     * we should check to see if current can readily move to a different=

-     * cpu.  If so, we will reschedule to allow the push logic to try
-     * to move current somewhere else, making room for our non-migratabl=
e
-     * task.
-     */
-    if((p->prio =3D=3D rq->curr->prio)
-       && p->rt.nr_cpus_allowed =3D=3D 1
-       && rq->curr->rt.nr_cpus_allowed !=3D 1
-       && pick_next_rt_entity(rq, &rq->rt) !=3D &rq->curr->rt) {
-        cpumask_t mask;
-
-        if (cpupri_find(&rq->rd->cpupri, rq->curr, &mask))
-            /*
-             * There appears to be other cpus that can accept
-             * current, so lets reschedule to try and push it away
-             */
-            resched_task(rq->curr);
-    }
-#endif
 }
=20
 static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq,
@@ -792,15 +746,8 @@ static struct sched_rt_entity
*pick_next_rt_entity(struct rq *rq,
     idx =3D sched_find_first_bit(array->bitmap);
     BUG_ON(idx >=3D MAX_RT_PRIO);
=20
-    queue =3D array->xqueue + idx;
-    if (!list_empty(queue))
-        next =3D list_entry(queue->next, struct sched_rt_entity,
-                  run_list);
-    else {
-        queue =3D array->squeue + idx;
-        next =3D list_entry(queue->next, struct sched_rt_entity,
-                  run_list);
-    }
+    queue =3D array->queue + idx;
+    next =3D list_entry(queue->next, struct sched_rt_entity, run_list);
=20
     return next;
 }
@@ -889,7 +836,7 @@ static struct task_struct
*pick_next_highest_task_rt(struct rq *rq, int cpu)
             continue;
         if (next && next->prio < idx)
             continue;
-        list_for_each_entry(rt_se, array->squeue + idx, run_list) {
+        list_for_each_entry(rt_se, array->queue + idx, run_list) {
             struct task_struct *p =3D rt_task_of(rt_se);
             if (pick_rt_task(rq, p, cpu)) {
                 next =3D p;
@@ -1331,14 +1278,6 @@ static void set_cpus_allowed_rt(struct
task_struct *p,
         }
=20
         update_rt_migration(rq);
-
-        if (unlikely(weight =3D=3D 1 || p->rt.nr_cpus_allowed =3D=3D 1))=

-            /*
-             * If either the new or old weight is a "1", we need
-             * to requeue to properly move between shared and
-             * exclusive queues.
-             */
-            requeue_task_rt(rq, p);
     }
=20
     p->cpus_allowed    =3D *new_mask;









--------------enig5D19101F24170B8A31EF8BDE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAklnz8IACgkQlOSOBdgZUxm4mACfXwmTbWjp+AVx/14WHrKVwOA5
0m4An1ysJuxCBvLu3Qp15bgatVlix3zi
=fz09
-----END PGP SIGNATURE-----

--------------enig5D19101F24170B8A31EF8BDE--
