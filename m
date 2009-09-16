Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbZIPKTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbZIPKTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755486AbZIPKTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:19:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:46305 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755447AbZIPKTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:19:41 -0400
Date: Wed, 16 Sep 2009 10:19:18 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Split WAKEUP_OVERLAP
Message-ID: <tip-e6b1b2c9c0461c4e0971ed905ce3cda6512ee82a@git.kernel.org>
Git-Commit-ID: e6b1b2c9c0461c4e0971ed905ce3cda6512ee82a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:19:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6b1b2c9c0461c4e0971ed905ce3cda6512ee82a
Gitweb:     http://git.kernel.org/tip/e6b1b2c9c0461c4e0971ed905ce3cda6512ee82a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 11 Sep 2009 11:59:22 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 16:01:02 +0200

sched: Split WAKEUP_OVERLAP

It consists of two conditions, split them out in separate toggles
so we can test them independently.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_fair.c     |    7 ++++---
 kernel/sched_features.h |    1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index aa7f841..cea5b82 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1526,9 +1526,10 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
-	if (sched_feat(WAKEUP_OVERLAP) && (sync ||
-			(se->avg_overlap < sysctl_sched_migration_cost &&
-			 pse->avg_overlap < sysctl_sched_migration_cost))) {
+	if ((sched_feat(WAKEUP_SYNC) && sync) ||
+	    (sched_feat(WAKEUP_OVERLAP) &&
+	     (se->avg_overlap < sysctl_sched_migration_cost &&
+	      pse->avg_overlap < sysctl_sched_migration_cost))) {
 		resched_task(curr);
 		return;
 	}
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index e2dc63a..07c8250 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -12,6 +12,7 @@ SCHED_FEAT(ASYM_GRAN, 1)
 SCHED_FEAT(LB_BIAS, 1)
 SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
 SCHED_FEAT(ASYM_EFF_LOAD, 1)
+SCHED_FEAT(WAKEUP_SYNC, 0)
 SCHED_FEAT(WAKEUP_OVERLAP, 0)
 SCHED_FEAT(LAST_BUDDY, 1)
 SCHED_FEAT(OWNER_SPIN, 1)
