Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbZGRJu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbZGRJu0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 05:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbZGRJuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 05:50:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:42200 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbZGRJuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 05:50:24 -0400
Date: Sat, 18 Jul 2009 09:49:49 GMT
From: tip-bot for Fabio Checconi <fabio@gandalf.sssup.it>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, fabio@gandalf.sssup.it, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, fabio@gandalf.sssup.it, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:sched/urgent] sched: Account for vruntime wrapping
Message-ID: <tip-54fdc5816631b43ba55fc3206d7add2d85850bc6@git.kernel.org>
Git-Commit-ID: 54fdc5816631b43ba55fc3206d7add2d85850bc6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Jul 2009 09:49:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54fdc5816631b43ba55fc3206d7add2d85850bc6
Gitweb:     http://git.kernel.org/tip/54fdc5816631b43ba55fc3206d7add2d85850bc6
Author:     Fabio Checconi <fabio@gandalf.sssup.it>
AuthorDate: Thu, 16 Jul 2009 12:32:27 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Jul 2009 11:17:08 +0200

sched: Account for vruntime wrapping

I spotted two sites that didn't take vruntime wrap-around into
account. Fix these by creating a comparison helper that does do
so.

Signed-off-by: Fabio Checconi <fabio@gandalf.sssup.it>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_fair.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 7c248dc..9ffb2b2 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -266,6 +266,12 @@ static inline u64 min_vruntime(u64 min_vruntime, u64 vruntime)
 	return min_vruntime;
 }
 
+static inline int entity_before(struct sched_entity *a,
+				struct sched_entity *b)
+{
+	return (s64)(a->vruntime - b->vruntime) < 0;
+}
+
 static inline s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	return se->vruntime - cfs_rq->min_vruntime;
@@ -1017,7 +1023,7 @@ static void yield_task_fair(struct rq *rq)
 	/*
 	 * Already in the rightmost position?
 	 */
-	if (unlikely(!rightmost || rightmost->vruntime < se->vruntime))
+	if (unlikely(!rightmost || entity_before(rightmost, se)))
 		return;
 
 	/*
@@ -1713,7 +1719,7 @@ static void task_new_fair(struct rq *rq, struct task_struct *p)
 
 	/* 'curr' will be NULL if the child belongs to a different group */
 	if (sysctl_sched_child_runs_first && this_cpu == task_cpu(p) &&
-			curr && curr->vruntime < se->vruntime) {
+			curr && entity_before(curr, se)) {
 		/*
 		 * Upon rescheduling, sched_class::put_prev_task() will place
 		 * 'current' within the tree based on its new key value.
