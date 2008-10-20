Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbYJTSMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbYJTSMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 14:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYJTSMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 14:12:38 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:5134 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbYJTSMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 14:12:37 -0400
Message-ID: <48FCCA14.5000103@ct.jp.nec.com>
Date: Mon, 20 Oct 2008 11:12:36 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: CFS related question
References: <20081018200319.GC8188@localhost> <1224361698.10548.38.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1224361698.10548.38.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Sun, 2008-10-19 at 00:03 +0400, Cyrill Gorcunov wrote:
>> Hi Ingo, Peter,
>>
>> I just curious, look we have the following
>>
>> static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
>> {
>> 	struct sched_entity *se = NULL;
>>
>> 	if (first_fair(cfs_rq)) {
>> 		se = __pick_next_entity(cfs_rq);
>> 		se = pick_next(cfs_rq, se);
>> 		set_next_entity(cfs_rq, se);
>> 	}
>>
>> 	return se;
>> }
>>
>> which I presume may return NULL so the following piece
>> could fail
>>
>> static struct task_struct *pick_next_task_fair(struct rq *rq)
>> {
>> 	struct task_struct *p;
>> 	struct cfs_rq *cfs_rq = &rq->cfs;
>> 	struct sched_entity *se;
>>
>> 	if (unlikely(!cfs_rq->nr_running))
>> 		return NULL;
>>
>> 	do {
>> -->		se = pick_next_entity(cfs_rq);
>> --> OOPs	cfs_rq = group_cfs_rq(se);
>> 	} while (cfs_rq);
>>
>> 	p = task_of(se);
>> 	hrtick_start_fair(rq, p);
>>
>> 	return p;
>> }
>>
>> Did I miss something? Or it comepletely can NOT happen?
> 
> pick_next_entity() only returns NULL when !first_fair(), which is when !
> nr_running.
> 
> So the initial !nr_running check in pick_next_task_fair() will catch
> that. Further nested RQs will never have !nr_running because then they
> get dequeued.

Hi Peter,

pick_next_entity() is used in pick_next_task_fair() only.
So, checking first_fair() never fail, and if fails it means bug. Right?

How about the below patch?
--------
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: [PATCH] sched: replace check with BUG_ON in pick_next_entity()

BUG_ON instead of returning NULL in pick_next_entity() when !first_fair().
Basically first_fair() is always true, and returning NULL will cause oops later.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 kernel/sched_fair.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 9573c33..3ce7c25 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -758,13 +758,13 @@ pick_next(struct cfs_rq *cfs_rq, struct sched_entity *se)
 
 static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 {
-	struct sched_entity *se = NULL;
+	struct sched_entity *se;
 
-	if (first_fair(cfs_rq)) {
-		se = __pick_next_entity(cfs_rq);
-		se = pick_next(cfs_rq, se);
-		set_next_entity(cfs_rq, se);
-	}
+	BUG_ON(!first_fair(cfs_rq));
+
+	se = __pick_next_entity(cfs_rq);
+	se = pick_next(cfs_rq, se);
+	set_next_entity(cfs_rq, se);
 
 	return se;
 }
-- 
1.5.6

