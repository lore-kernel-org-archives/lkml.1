Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbXDDNZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbXDDNZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 09:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbXDDNZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 09:25:38 -0400
Received: from mail35.syd.optusnet.com.au ([211.29.133.51]:32876 "EHLO
	mail35.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753797AbXDDNZh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 09:25:37 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       ck list <ck@vds.kolivas.org>
Subject: [PATCH] sched: implement staircase deadline cpu scheduler improvements fix
Date: Wed, 4 Apr 2007 23:22:05 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org> <200704040831.35225.kernel@kolivas.org> <4612E3C3.6020806@googlemail.com>
In-Reply-To: <4612E3C3.6020806@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704042322.06085.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 April 2007 09:31, Michal Piotrowski wrote:
> Con Kolivas napisał(a):
> > On Wednesday 04 April 2007 08:20, Michal Piotrowski wrote:
> >> Michal Piotrowski napisał(a):
> >>> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5-mm4
> >>>/m m-oops
> >>> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5-mm4
> >>>/m m-config

> >> Con, I think that your
> >> sched-implement-staircase-deadline-cpu-scheduler-staircase-improvements.
> >>pat ch is causing this oops.
> >
> > Thanks for heads up!

Confirmed offline with Michal that the following patch fixes it. Thanks!

This should also make nice work better in the way the previous patch intended
it to.

---
Use of memset was bogus. Fix it.

Fix exiting recalc_task_prio without p->array being updated.

Microoptimisation courtesy of Dmitry Adamushko <dmitry.adamushko@gmail.com>

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 kernel/sched.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

Index: linux-2.6.21-rc5-mm4/kernel/sched.c
===================================================================
--- linux-2.6.21-rc5-mm4.orig/kernel/sched.c	2007-04-04 12:14:29.000000000 +1000
+++ linux-2.6.21-rc5-mm4/kernel/sched.c	2007-04-04 12:49:39.000000000 +1000
@@ -683,11 +683,13 @@ static void dequeue_task(struct task_str
  * The task is being queued on a fresh array so it has its entitlement
  * bitmap cleared.
  */
-static inline void task_new_array(struct task_struct *p, struct rq *rq)
+static void task_new_array(struct task_struct *p, struct rq *rq,
+			   struct prio_array *array)
 {
 	bitmap_zero(p->bitmap, PRIO_RANGE);
 	p->rotation = rq->prio_rotation;
 	p->time_slice = p->quota;
+	p->array = array;
 }
 
 /* Find the first slot from the relevant prio_matrix entry */
@@ -709,6 +711,8 @@ static inline int next_entitled_slot(str
 	DECLARE_BITMAP(tmp, PRIO_RANGE);
 	int search_prio, uprio = USER_PRIO(p->static_prio);
 
+	if (!rq->prio_level[uprio])
+		rq->prio_level[uprio] = MAX_RT_PRIO;
 	/*
 	 * Only priorities equal to the prio_level and above for their
 	 * static_prio are acceptable, and only if it's not better than
@@ -736,11 +740,8 @@ static inline int next_entitled_slot(str
 
 static void queue_expired(struct task_struct *p, struct rq *rq)
 {
-	p->array = rq->expired;
-	task_new_array(p, rq);
+	task_new_array(p, rq, rq->expired);
 	p->prio = p->normal_prio = first_prio_slot(p);
-	p->time_slice = p->quota;
-	p->rotation = rq->prio_rotation;
 }
 
 #ifdef CONFIG_SMP
@@ -800,9 +801,9 @@ static void recalc_task_prio(struct task
 			queue_expired(p, rq);
 			return;
 		} else
-			task_new_array(p, rq);
+			task_new_array(p, rq, array);
 	} else
-		task_new_array(p, rq);
+		task_new_array(p, rq, array);
 
 	queue_prio = next_entitled_slot(p, rq);
 	if (queue_prio >= MAX_PRIO) {
@@ -3445,7 +3446,7 @@ EXPORT_SYMBOL(sub_preempt_count);
 
 static inline void reset_prio_levels(struct rq *rq)
 {
-	memset(rq->prio_level, MAX_RT_PRIO, ARRAY_SIZE(rq->prio_level));
+	memset(rq->prio_level, 0, sizeof(int) * PRIO_RANGE);
 }
 
 /*

-- 
-ck
