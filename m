Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbYKKObO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbYKKObO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 09:31:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837AbYKKOa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 09:30:58 -0500
Received: from 68-112-229-48.dhcp.oxfr.ma.charter.com ([68.112.229.48]:37604
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755842AbYKKOa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 09:30:57 -0500
X-Greylist: delayed 518 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Nov 2008 09:30:57 EST
From: Gregory Haskins <ghaskins@novell.com>
Subject: [RFC PATCH 3/3] sched: use highest_prio.next to optimize pull
	operations
To: mingo@elte.hu, rostedt@goodmis.org, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, =linux-rt-users@vger.kernel.org
Date: Tue, 11 Nov 2008 09:26:29 -0500
Message-ID: <20081111142629.28477.84763.stgit@dev.haskins.net>
In-Reply-To: <20081111142323.28477.41235.stgit@dev.haskins.net>
References: <20081111142323.28477.41235.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently take the rq->lock for every cpu in an overload state during
pull_rt_tasks().  However, we now have enough information via the
highest_prio.[curr|next] fields to determine if there is any tasks of
interest to warrant the overhead of the rq->lock, before we actually take
it.  So we use this information to reduce lock contention during the
pull for the case where the source-rq doesnt have tasks that preempt
the current task.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched_rt.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index b2305c9..d722aef 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1217,6 +1217,18 @@ static int pull_rt_task(struct rq *this_rq)
 			continue;
 
 		src_rq = cpu_rq(cpu);
+
+		/*
+		 * Don't bother taking the src_rq->lock if the next highest
+		 * task is known to be lower-priority than our current task.
+		 * This may look racy, but if this value is about to go
+		 * logically higher, the src_rq will push this task away.
+		 * And if its going logically lower, we do not care
+		 */
+		if (src_rq->rt.highest_prio.next >=
+		    this_rq->rt.highest_prio.curr)
+			continue;
+
 		/*
 		 * We can potentially drop this_rq's lock in
 		 * double_lock_balance, and another CPU could

