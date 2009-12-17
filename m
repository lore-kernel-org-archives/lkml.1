Return-Path: <linux-kernel-owner+w=401wt.eu-S1764155AbZLQMdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764155AbZLQMdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 07:33:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764130AbZLQMdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 07:33:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:58140 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761501AbZLQMck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 07:32:40 -0500
Date: Thu, 17 Dec 2009 12:31:52 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091217121830.137155561@chello.nl>
References: <20091217121830.137155561@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix broken assertion
Message-ID: <tip-077614ee1e93245a3b9a4e1213659405dbeb0ba6@git.kernel.org>
Git-Commit-ID: 077614ee1e93245a3b9a4e1213659405dbeb0ba6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  077614ee1e93245a3b9a4e1213659405dbeb0ba6
Gitweb:     http://git.kernel.org/tip/077614ee1e93245a3b9a4e1213659405dbeb0ba6
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 17 Dec 2009 13:16:31 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 17 Dec 2009 13:22:46 +0100

sched: Fix broken assertion

There's a preemption race in the set_task_cpu() debug check in
that when we get preempted after setting task->state we'd still
be on the rq proper, but fail the test.

Check for preempted tasks, since those are always on the RQ.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20091217121830.137155561@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 7be88a7..720df10 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2041,7 +2041,8 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 	 * We should never call set_task_cpu() on a blocked task,
 	 * ttwu() will sort out the placement.
 	 */
-	WARN_ON_ONCE(p->state != TASK_RUNNING && p->state != TASK_WAKING);
+	WARN_ON_ONCE(p->state != TASK_RUNNING && p->state != TASK_WAKING &&
+			!(task_thread_info(p)->preempt_count & PREEMPT_ACTIVE));
 #endif
 
 	trace_sched_migrate_task(p, new_cpu);
