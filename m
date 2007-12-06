Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbXLFPuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbXLFPuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 10:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbXLFPuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 10:50:07 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:38893
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753644AbXLFPuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 10:50:06 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/2] Subject: SCHED - Clean up some old cpuset logic
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org, ghaskins@novell.com
Date: Thu, 06 Dec 2007 10:28:02 -0500
Message-ID: <20071206152802.7031.80344.stgit@novell1.haskins.net>
In-Reply-To: <20071206152536.7031.16101.stgit@novell1.haskins.net>
References: <20071206152536.7031.16101.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We had support for overlapping cpuset based rto logic in early prototypes that
is no longer used, so clean it up.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched_rt.c |   32 --------------------------------
 1 files changed, 0 insertions(+), 32 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 53cd9e8..65cbb78 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -586,37 +586,6 @@ static int pull_rt_task(struct rq *this_rq)
 			continue;
 
 		src_rq = cpu_rq(cpu);
-		if (unlikely(src_rq->rt.rt_nr_running <= 1)) {
-			/*
-			 * It is possible that overlapping cpusets
-			 * will miss clearing a non overloaded runqueue.
-			 * Clear it now.
-			 */
-			if (double_lock_balance(this_rq, src_rq)) {
-				/* unlocked our runqueue lock */
-				struct task_struct *old_next = next;
-
-				next = pick_next_task_rt(this_rq);
-				if (next != old_next)
-					ret = 1;
-			}
-			if (likely(src_rq->rt.rt_nr_running <= 1)) {
-				/*
-				 * Small chance that this_rq->curr changed
-				 * but it's really harmless here.
-				 */
-				rt_clear_overload(this_rq);
-			} else {
-				/*
-				 * Heh, the src_rq is now overloaded, since
-				 * we already have the src_rq lock, go straight
-				 * to pulling tasks from it.
-				 */
-				goto try_pulling;
-			}
-			spin_unlock(&src_rq->lock);
-			continue;
-		}
 
 		/*
 		 * We can potentially drop this_rq's lock in
@@ -641,7 +610,6 @@ static int pull_rt_task(struct rq *this_rq)
 			continue;
 		}
 
- try_pulling:
 		p = pick_next_highest_task_rt(src_rq, this_cpu);
 
 		/*

