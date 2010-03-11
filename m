Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab0CKKBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 05:01:25 -0500
Received: from mail.gmx.net ([213.165.64.20]:36462 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755457Ab0CKKBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 05:01:23 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/HuEBMxH7HQKDR/zcq2p+x6idaAc9WIUo/d7PoLg
	oD8VakQuCggZ8M
Subject: Re: [patch 11/12] sched: remove ASYM_GRAN feature
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1268300950.6785.27.camel@marge.simson.net>
References: <1268300950.6785.27.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 11 Mar 2010 11:01:15 +0100
Message-Id: <1268301675.6785.44.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46999999999999997
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sched: remove ASYM_GRAN feature

This features has been enabled for quite a while, after testing showed that
easing preemption for light tasks was harmful to high priority threads.

Remove it.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 kernel/sched_fair.c     |   28 +++++++++++-----------------
 kernel/sched_features.h |    6 ------
 2 files changed, 11 insertions(+), 23 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1582,24 +1582,18 @@ wakeup_gran(struct sched_entity *curr, s
 	/*
 	 * Since its curr running now, convert the gran from real-time
 	 * to virtual-time in his units.
+	 *
+	 * By using 'se' instead of 'curr' we penalize light tasks, so
+	 * they get preempted easier. That is, if 'se' < 'curr' then
+	 * the resulting gran will be larger, therefore penalizing the
+	 * lighter, if otoh 'se' > 'curr' then the resulting gran will
+	 * be smaller, again penalizing the lighter task.
+	 *
+	 * This is especially important for buddies when the leftmost
+	 * task is higher priority than the buddy.
 	 */
-	if (sched_feat(ASYM_GRAN)) {
-		/*
-		 * By using 'se' instead of 'curr' we penalize light tasks, so
-		 * they get preempted easier. That is, if 'se' < 'curr' then
-		 * the resulting gran will be larger, therefore penalizing the
-		 * lighter, if otoh 'se' > 'curr' then the resulting gran will
-		 * be smaller, again penalizing the lighter task.
-		 *
-		 * This is especially important for buddies when the leftmost
-		 * task is higher priority than the buddy.
-		 */
-		if (unlikely(se->load.weight != NICE_0_LOAD))
-			gran = calc_delta_fair(gran, se);
-	} else {
-		if (unlikely(curr->load.weight != NICE_0_LOAD))
-			gran = calc_delta_fair(gran, curr);
-	}
+	if (unlikely(se->load.weight != NICE_0_LOAD))
+		gran = calc_delta_fair(gran, se);
 
 	return gran;
 }
Index: linux-2.6/kernel/sched_features.h
===================================================================
--- linux-2.6.orig/kernel/sched_features.h
+++ linux-2.6/kernel/sched_features.h
@@ -17,12 +17,6 @@ SCHED_FEAT(START_DEBIT, 1)
 SCHED_FEAT(WAKEUP_PREEMPT, 1)
 
 /*
- * When converting the wakeup granularity to virtual time, do it such
- * that heavier tasks preempting a lighter task have an edge.
- */
-SCHED_FEAT(ASYM_GRAN, 1)
-
-/*
  * Use the SYNC wakeup hint, pipes and the likes use this to indicate
  * the remote end is likely to consume the data we just wrote, and
  * therefore has cache benefit from being placed on the same cpu, see


