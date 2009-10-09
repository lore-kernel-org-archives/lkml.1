Return-Path: <linux-kernel-owner+w=401wt.eu-S1760762AbZJIKnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760762AbZJIKnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 06:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759828AbZJIKnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 06:43:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50028 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760270AbZJIKnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 06:43:49 -0400
Subject: Re: hackbench regression with kernel 2.6.32-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <1255079943.25078.23.camel@ymzhang>
References: <1255079943.25078.23.camel@ymzhang>
Content-Type: text/plain
Date: Fri, 09 Oct 2009 12:43:06 +0200
Message-Id: <1255084986.8802.46.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-09 at 17:19 +0800, Zhang, Yanmin wrote:
> Comparing with 2.6.31's results, hackbench has some regression on a couple of
> machines woth kernel 2.6.32-rc1.
> I run it with commandline:
> ../hackbench 100 process 2000
> 
> 1) On 4*4 core tigerton: 70%;
> 2) On 2*4 core stoakley: 7%.
> 
> I located below 2 patches.
> commit 29cd8bae396583a2ee9a3340db8c5102acf9f6fd
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Thu Sep 17 09:01:14 2009 +0200
> 
>     sched: Fix SD_POWERSAVING_BALANCE|SD_PREFER_LOCAL vs SD_WAKE_AFFINE
> 
> and 

Should I guess be solved by turning SD_PREFER_LOCAL off, right?

> commit de69a80be32445b0a71e8e3b757e584d7beb90f7
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Thu Sep 17 09:01:20 2009 +0200
> 
>     sched: Stop buddies from hogging the system
> 
> 
> 1) On 4*4 core tigerton: if I revert patch 29cd8b, the regression becomes
> less than 55%; If I revert the 2 patches, all regression disappears.
> 2) On 2*4 core stakley: If I revert the 2 patches, comparing with 2.6.31,
> I get about 8% improvement instead of regression.
> 
> Sorry for reporting the regression later as there is a long national holiday.

No problem. There should still be plenty time to poke at them before .32
hits the street.

I really liked de69a80b, and it affecting hackbench shows I wasn't
crazy ;-)

So hackbench is a multi-cast, with one sender spraying multiple
receivers, who in their turn don't spray back, right?

This would be exactly the scenario that patch 'cures'. Previously we
would not clear the last buddy after running the next, allowing the
sender to get back to work sooner than it otherwise ought to have been.

Now, since those receivers don't poke back, they don't enforce the buddy
relation...


/me ponders a bit

Does this make it any better?

---
 kernel/sched_fair.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 4e777b4..bf5901e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -861,12 +861,21 @@ wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
 static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *se = __pick_next_entity(cfs_rq);
+	struct sched_entity *buddy;
 
-	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, se) < 1)
-		return cfs_rq->next;
+	if (cfs_rq->next) {
+		buddy = cfs_rq->next;
+		cfs_rq->next = NULL;
+		if (wakeup_preempt_entity(buddy, se) < 1)
+			return buddy;
+	}
 
-	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, se) < 1)
-		return cfs_rq->last;
+	if (cfs_rq->last) {
+		buddy = cfs_rq->last;
+		cfs_rq->last = NULL;
+	       	if (wakeup_preempt_entity(buddy, se) < 1)
+			return buddy;
+	}
 
 	return se;
 }
@@ -1654,16 +1663,6 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
 
 	do {
 		se = pick_next_entity(cfs_rq);
-		/*
-		 * If se was a buddy, clear it so that it will have to earn
-		 * the favour again.
-		 *
-		 * If se was not a buddy, clear the buddies because neither
-		 * was elegible to run, let them earn it again.
-		 *
-		 * IOW. unconditionally clear buddies.
-		 */
-		__clear_buddies(cfs_rq, NULL);
 		set_next_entity(cfs_rq, se);
 		cfs_rq = group_cfs_rq(se);
 	} while (cfs_rq);


