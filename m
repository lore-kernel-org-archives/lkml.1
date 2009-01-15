Return-Path: <linux-kernel-owner+w=401wt.eu-S1762085AbZAONRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762085AbZAONRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755947AbZAONRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:17:34 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54234 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858AbZAONRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:17:32 -0500
Subject: Re: [BUG] How to get real-time priority using idle priority
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Brian Rogers <brian@xyzw.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090115125451.GB21839@elte.hu>
References: <4969D0D7.2060401@xyzw.org>
	 <1231736941.6003.7.camel@marge.simson.net>
	 <1231765433.5789.35.camel@marge.simson.net> <20090112131406.GB670@elte.hu>
	 <496BE8F6.1040308@xyzw.org> <1232011723.26761.36.camel@marge.simson.net>
	 <1232014456.8870.26.camel@laptop>
	 <1232015423.13856.5.camel@marge.simson.net>
	 <1232019428.5720.8.camel@marge.simson.net>
	 <1232019686.8870.45.camel@laptop>  <20090115125451.GB21839@elte.hu>
Content-Type: text/plain
Date: Thu, 15 Jan 2009 14:16:51 +0100
Message-Id: <1232025411.8870.49.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you then fold this on top we have 3 patches, alas not along the lines
that would have been pretty:

 - update_min_vruntime fix
 - SCHED_IDLE weight change
 - SCHED_IDLE vs SCHED_OTHER isolation

But I guess that's life.

---
Subject: sched: fix update_min_vruntime
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Jan 15 14:13:28 CET 2009

OK, so we have 1 running task A (which is obviously curr and the tree is
equally obviously empty).

A nicely chugs along, doing its thing, carrying min_vruntime along as it
goes.

Then some whacko speed freak SCHED_IDLE task gets inserted due to SMP
balancing, which is very likely far right, in that case

update_curr
  update_min_vruntime
    cfs_rq->rb_leftmost := true (the crazy task sitting in a tree)
      vruntime = se->vruntime

and voila, min_vruntime is waaay right of where it ought to be.

OK, so why did I write it like that to begin with...

Aah, yes.

Say we've just dequeued current

schedule
  deactivate_task(prev)
    dequeue_entity
      update_min_vruntime

Then we'll set

  vruntime = cfs_rq->min_vruntime;

we find !cfs_rq->curr, but do find someone in the tree. Then we _must_
do vruntime = se->vruntime, because

 vruntime = min_vruntime(vruntime := cfs_rq->min_vruntime, se->vruntime)

will not advance vruntime, and cause lags the other way around (which we
fixed with that initial patch: 1af5f730fc1bf7c62ec9fb2d307206e18bf40a69
(sched: more accurate min_vruntime accounting).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Mike Galbraith <efault@gmx.de>
Acked-by: Mike Galbraith <efault@gmx.de>
---
 kernel/sched_fair.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -283,7 +283,10 @@ static void update_min_vruntime(struct c
 						   struct sched_entity,
 						   run_node);
 
-		vruntime = min_vruntime(vruntime, se->vruntime);
+		if (!cfs_rq->curr)
+			vruntime = se->vruntime;
+		else
+			vruntime = min_vruntime(vruntime, se->vruntime);
 	}
 
 	cfs_rq->min_vruntime = max_vruntime(cfs_rq->min_vruntime, vruntime);


