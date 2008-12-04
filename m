Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbYLDPl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbYLDPl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 10:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757132AbYLDPkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 10:40:20 -0500
Received: from 68-112-229-48.dhcp.oxfr.ma.charter.com ([68.112.229.48]:53221
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757032AbYLDPkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 10:40:18 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH v3 4/4] sched: use highest_prio.next to optimize pull
	operations
To: mingo@elte.hu
Cc: peterz@infradead.org, rostedt@goodmis.org, ghaskins@novell.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Date: Thu, 04 Dec 2008 10:43:57 -0500
Message-ID: <20081204154357.21712.52115.stgit@dev.haskins.net>
In-Reply-To: <20081204154100.21712.88806.stgit@dev.haskins.net>
References: <20081204154100.21712.88806.stgit@dev.haskins.net>
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
index ffdd00e..afcc67a 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1220,6 +1220,18 @@ static int pull_rt_task(struct rq *this_rq)
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

