Return-Path: <linux-kernel-owner+w=401wt.eu-S1946009AbXDCWcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946009AbXDCWcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 18:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992432AbXDCWcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 18:32:04 -0400
Received: from mail17.syd.optusnet.com.au ([211.29.132.198]:43761 "EHLO
	mail17.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946009AbXDCWcD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 18:32:03 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: 2.6.21-rc5-mm4
Date: Wed, 4 Apr 2007 08:31:34 +1000
User-Agent: KMail/1.9.5
Cc: Michal Piotrowski <michal.k.k.piotrowski@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org> <46127CBF.8040803@googlemail.com> <4612D32E.20105@googlemail.com>
In-Reply-To: <4612D32E.20105@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704040831.35225.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 April 2007 08:20, Michal Piotrowski wrote:
> Michal Piotrowski napisał(a):
> > http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5-mm4/m
> >m-oops
> > http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5-mm4/m
> >m-config
>
> Sorry for a delay.

Never apologise! 

(I'm trying hard to stay offline for my own health so I may have huge delays).

> Con, I think that your
> sched-implement-staircase-deadline-cpu-scheduler-staircase-improvements.pat
>ch is causing this oops.

Thanks for heads up!

Try this patch please?
---
Fix exiting recalc_task_prio without p->array being updated.

Microoptimisation courtesy of Dmitry Adamushko <dmitry.adamushko@gmail.com>

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 kernel/sched.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

Index: linux-2.6.21-rc5-mm3/kernel/sched.c
===================================================================
--- linux-2.6.21-rc5-mm3.orig/kernel/sched.c	2007-04-04 08:23:45.000000000 +1000
+++ linux-2.6.21-rc5-mm3/kernel/sched.c	2007-04-04 08:25:39.000000000 +1000
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
@@ -736,11 +738,8 @@ static inline int next_entitled_slot(str
 
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
@@ -800,9 +799,9 @@ static void recalc_task_prio(struct task
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

-- 
-ck
