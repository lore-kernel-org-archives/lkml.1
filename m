Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbZLIJyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbZLIJyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbZLIJyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:54:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:45091 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050AbZLIJyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:54:32 -0500
Date: Wed, 9 Dec 2009 09:53:53 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Remove rq->clock coupling from set_task_cpu()
Message-ID: <tip-5afcdab706d6002cb02b567ba46e650215e694e8@git.kernel.org>
Git-Commit-ID: 5afcdab706d6002cb02b567ba46e650215e694e8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5afcdab706d6002cb02b567ba46e650215e694e8
Gitweb:     http://git.kernel.org/tip/5afcdab706d6002cb02b567ba46e650215e694e8
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 27 Nov 2009 14:12:25 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 10:03:03 +0100

sched: Remove rq->clock coupling from set_task_cpu()

set_task_cpu() should be rq invariant and only touch task state, it
currently fails to do so, which opens up a few races, since not all
callers hold both rq->locks.

Remove the relyance on rq->clock, as any site calling set_task_cpu()
should also do a remote clock update, which should ensure the observed
time between these two cpus is monotonic, as per
kernel/sched_clock.c:sched_clock_remote().

Therefore we can simply remove the clock_offset bits and be happy.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 01fd131..1f9c6d9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2060,23 +2060,12 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 {
 	int old_cpu = task_cpu(p);
-	struct rq *old_rq = cpu_rq(old_cpu), *new_rq = cpu_rq(new_cpu);
+	struct rq *old_rq = cpu_rq(old_cpu);
 	struct cfs_rq *old_cfsrq = task_cfs_rq(p),
 		      *new_cfsrq = cpu_cfs_rq(old_cfsrq, new_cpu);
-	u64 clock_offset;
-
-	clock_offset = old_rq->clock - new_rq->clock;
 
 	trace_sched_migrate_task(p, new_cpu);
 
-#ifdef CONFIG_SCHEDSTATS
-	if (p->se.wait_start)
-		p->se.wait_start -= clock_offset;
-	if (p->se.sleep_start)
-		p->se.sleep_start -= clock_offset;
-	if (p->se.block_start)
-		p->se.block_start -= clock_offset;
-#endif
 	if (old_cpu != new_cpu) {
 		p->se.nr_migrations++;
 #ifdef CONFIG_SCHEDSTATS
