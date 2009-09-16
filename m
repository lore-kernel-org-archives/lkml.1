Return-Path: <linux-kernel-owner+w=401wt.eu-S1758788AbZIPKZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788AbZIPKZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758008AbZIPKZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:25:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:58444 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbZIPKZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:25:13 -0400
Date: Wed, 16 Sep 2009 10:24:41 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add a few SYNC hint knobs to play with
Message-ID: <tip-e69b0f1b41c0e57bb1e29100b5810a5914efcb45@git.kernel.org>
Git-Commit-ID: e69b0f1b41c0e57bb1e29100b5810a5914efcb45
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:24:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e69b0f1b41c0e57bb1e29100b5810a5914efcb45
Gitweb:     http://git.kernel.org/tip/e69b0f1b41c0e57bb1e29100b5810a5914efcb45
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 15 Sep 2009 19:38:52 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 19:47:23 +0200

sched: Add a few SYNC hint knobs to play with

Currently we use overlap to weaken the SYNC hint, but allow it to
set the hint as well.

 echo NO_SYNC_WAKEUP > /debug/sched_features
 echo SYNC_MORE > /debug/sched_features

preserves pipe-test behaviour without using the WF_SYNC hint.

Worth playing with on more workloads...

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_fair.c     |   14 +++++++++++---
 kernel/sched_features.h |   10 ++++++++++
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 6766959..280892e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1165,9 +1165,17 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	load	  = source_load(prev_cpu, idx);
 	this_load = target_load(this_cpu, idx);
 
-	if (sync && (curr->se.avg_overlap > sysctl_sched_migration_cost ||
-			p->se.avg_overlap > sysctl_sched_migration_cost))
-		sync = 0;
+	if (sync) {
+	       if (sched_feat(SYNC_LESS) &&
+		   (curr->se.avg_overlap > sysctl_sched_migration_cost ||
+		    p->se.avg_overlap > sysctl_sched_migration_cost))
+		       sync = 0;
+	} else {
+		if (sched_feat(SYNC_MORE) &&
+		    (curr->se.avg_overlap < sysctl_sched_migration_cost &&
+		     p->se.avg_overlap < sysctl_sched_migration_cost))
+			sync = 1;
+	}
 
 	/*
 	 * If sync wakeup then subtract the (maximum possible)
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 294e10e..70115c6 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -63,6 +63,16 @@ SCHED_FEAT(SYNC_WAKEUPS, 1)
 SCHED_FEAT(AFFINE_WAKEUPS, 1)
 
 /*
+ * Weaken SYNC hint based on overlap
+ */
+SCHED_FEAT(SYNC_LESS, 1)
+
+/*
+ * Add SYNC hint based on overlap
+ */
+SCHED_FEAT(SYNC_MORE, 0)
+
+/*
  * Prefer to schedule the task we woke last (assuming it failed
  * wakeup-preemption), since its likely going to consume data we
  * touched, increases cache locality.
