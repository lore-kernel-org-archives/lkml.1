Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbZIPKZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbZIPKZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757624AbZIPKZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:25:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:58460 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758794AbZIPKZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:25:30 -0400
Date: Wed, 16 Sep 2009 10:25:08 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Implement a gentler fair-sleepers feature
Message-ID: <tip-51e0304ce6e55a6e59658558916b4f74da085ff0@git.kernel.org>
Git-Commit-ID: 51e0304ce6e55a6e59658558916b4f74da085ff0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:25:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  51e0304ce6e55a6e59658558916b4f74da085ff0
Gitweb:     http://git.kernel.org/tip/51e0304ce6e55a6e59658558916b4f74da085ff0
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 16 Sep 2009 08:54:45 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Sep 2009 09:05:20 +0200

sched: Implement a gentler fair-sleepers feature

Add back FAIR_SLEEPERS and GENTLE_FAIR_SLEEPERS.

FAIR_SLEEPERS is the old logic: credit sleepers with their sleep time.

GENTLE_FAIR_SLEEPERS dampens this a bit: 50% of their sleep time gets
credited.

The hope here is to still give the benefits of fair-sleepers logic
(quick wakeups, etc.) while not allow them to have 100% of their
sleep time as if they were running.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_fair.c     |    9 ++++++++-
 kernel/sched_features.h |    9 ++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a37f311..acf16a8 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -711,7 +711,7 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
-		if (sched_feat(NEW_FAIR_SLEEPERS)) {
+		if (sched_feat(FAIR_SLEEPERS)) {
 			unsigned long thresh = sysctl_sched_latency;
 
 			/*
@@ -725,6 +725,13 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 					 task_of(se)->policy != SCHED_IDLE))
 				thresh = calc_delta_fair(thresh, se);
 
+			/*
+			 * Halve their sleep time's effect, to allow
+			 * for a gentler effect of sleepers:
+			 */
+			if (sched_feat(GENTLE_FAIR_SLEEPERS))
+				thresh >>= 1;
+
 			vruntime -= thresh;
 		}
 	}
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 70115c6..fd37567 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -3,7 +3,14 @@
  * considers the task to be running during that period. This gives it
  * a service deficit on wakeup, allowing it to run sooner.
  */
-SCHED_FEAT(NEW_FAIR_SLEEPERS, 0)
+SCHED_FEAT(FAIR_SLEEPERS, 1)
+
+/*
+ * Only give sleepers 50% of their service deficit. This allows
+ * them to run sooner, but does not allow tons of sleepers to
+ * rip the spread apart.
+ */
+SCHED_FEAT(GENTLE_FAIR_SLEEPERS, 1)
 
 /*
  * By not normalizing the sleep time, heavy tasks get an effective
