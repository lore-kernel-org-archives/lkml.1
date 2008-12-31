Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbYLaQ0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbYLaQ0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 11:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755914AbYLaQ0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 11:26:23 -0500
Received: from mail.gmx.net ([213.165.64.20]:48836 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754923AbYLaQ0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 11:26:23 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+yUtMe+5eyiiV3cxiT9Ega/lY9zRH5Eh2kZ4wSoe
	DuWf1bpp4I/fRC
Subject: Re: problem with "sched: revert back to per-rq vruntime"?
From: Mike Galbraith <efault@gmx.de>
To: Jayson King <dev@jaysonking.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu
In-Reply-To: <495A788B.3010001@jaysonking.com>
References: <495948E0.8040502@jaysonking.com>
	 <495A788B.3010001@jaysonking.com>
Content-Type: text/plain
Date: Wed, 31 Dec 2008 17:26:13 +0100
Message-Id: <1230740773.6412.21.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-30 at 13:37 -0600, Jayson King wrote:
> Here's some times using bash, for example. Let me know if there are some 
> other tests I can do.
> 

> [jayson@atlas tmp]$ time bash -i -c 'exit'
> exit
> 
> real    0m0.753s
> user    0m0.011s
> sys     0m0.011s

Yeah, it's b0rked.  The problem is that we call sched_slice() before the
new task's load weight has been added to the runqueue.  

Normally this doesn't cause horrible problems, but when there is a +nice
hog on the runqueue, the lighter the hog, and/or heavier the victim...

[  160.489402] bash:5858 vslice: 3840000000 weight: 1024 rq_weight: 15 inv_weight: 268435456

...the closer the victim's vruntime gets to the middle of next week.

Not-signed-off diag hack.

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5ad4440..3254213 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -449,13 +449,34 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 }
 
 /*
+ * A freshly forked task's load weight has not yet been added to the runqueue,
+ * so we can't call calc_delta_weight() and get sane results.  Therefore, we roll
+ * our own so place_entity() can place this task in the right spot.  The runqueue
+ * weight and nr_running will be updated when the task is enqueued.
+ */
+static u64 sched_initial_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	u64 slice = __sched_period(cfs_rq->nr_running + 1);
+
+	for_each_sched_entity(se) {
+		struct load_weight lw = cfs_rq->load;
+
+		lw.weight += se->load.weight;
+		lw.inv_weight = 0;
+		slice = calc_delta_mine(slice, se->load.weight, &lw);
+	}
+
+	return slice;
+}
+
+/*
  * We calculate the vruntime slice of a to be inserted task
  *
  * vs = s/w
  */
 static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	return calc_delta_fair(sched_slice(cfs_rq, se), se);
+	return calc_delta_fair(sched_initial_slice(cfs_rq, se), se);
 }
 
 /*


