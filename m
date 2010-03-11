Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab0CKSeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:34:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:37117 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756328Ab0CKSeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:34:09 -0500
Date: Thu, 11 Mar 2010 18:33:22 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1268301675.6785.44.camel@marge.simson.net>
References: <1268301675.6785.44.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove ASYM_GRAN feature
Message-ID: <tip-13814d42e45dfbe845a0bbe5184565d9236896ae@git.kernel.org>
Git-Commit-ID: 13814d42e45dfbe845a0bbe5184565d9236896ae
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 18:33:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13814d42e45dfbe845a0bbe5184565d9236896ae
Gitweb:     http://git.kernel.org/tip/13814d42e45dfbe845a0bbe5184565d9236896ae
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 11 Mar 2010 17:17:04 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 18:32:53 +0100

sched: Remove ASYM_GRAN feature

This features has been enabled for quite a while, after testing showed that
easing preemption for light tasks was harmful to high priority threads.

Remove the feature flag.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1268301675.6785.44.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c     |   28 +++++++++++-----------------
 kernel/sched_features.h |    6 ------
 2 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 1d99535..9357ecd 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1583,24 +1583,18 @@ wakeup_gran(struct sched_entity *curr, struct sched_entity *se)
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
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index f54b6f9..83c66e8 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -17,12 +17,6 @@ SCHED_FEAT(START_DEBIT, 1)
 SCHED_FEAT(WAKEUP_PREEMPT, 1)
 
 /*
- * When converting the wakeup granularity to virtual time, do it such
- * that heavier tasks preempting a lighter task have an edge.
- */
-SCHED_FEAT(ASYM_GRAN, 1)
-
-/*
  * Based on load and program behaviour, see if it makes sense to place
  * a newly woken task on the same cpu as the task that woke it --
  * improve cache locality. Typically used with SYNC wakeups as
