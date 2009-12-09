Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbZLIJyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbZLIJyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbZLIJyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:54:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:45092 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091AbZLIJyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:54:32 -0500
Date: Wed, 9 Dec 2009 09:54:07 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Clean up ttwu() rq locking
Message-ID: <tip-ab19cb23313733c55e0517607844b86720b35f5f@git.kernel.org>
Git-Commit-ID: ab19cb23313733c55e0517607844b86720b35f5f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ab19cb23313733c55e0517607844b86720b35f5f
Gitweb:     http://git.kernel.org/tip/ab19cb23313733c55e0517607844b86720b35f5f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 27 Nov 2009 15:44:43 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 10:03:04 +0100

sched: Clean up ttwu() rq locking

Since set_task_clock() doesn't rely on rq->clock anymore we can simplyfy
the mess in ttwu().

Optimize things a bit by not fiddling with the IRQ state there.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 1f9c6d9..c92670f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2371,17 +2371,14 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible--;
 	p->state = TASK_WAKING;
-	task_rq_unlock(rq, &flags);
+	__task_rq_unlock(rq);
 
 	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
-	if (cpu != orig_cpu) {
-		local_irq_save(flags);
-		rq = cpu_rq(cpu);
-		update_rq_clock(rq);
+	if (cpu != orig_cpu)
 		set_task_cpu(p, cpu);
-		local_irq_restore(flags);
-	}
-	rq = task_rq_lock(p, &flags);
+
+	rq = __task_rq_lock(p);
+	update_rq_clock(rq);
 
 	WARN_ON(p->state != TASK_WAKING);
 	cpu = task_cpu(p);
