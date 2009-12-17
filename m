Return-Path: <linux-kernel-owner+w=401wt.eu-S1764658AbZLQMTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764658AbZLQMTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 07:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764629AbZLQMTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 07:19:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53916 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935424AbZLQMT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 07:19:26 -0500
Message-Id: <20091217121830.137155561@chello.nl>
References: <20091217121626.682772324@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 17 Dec 2009 13:16:31 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/6] sched: Fix broken assertion
Content-Disposition: inline; filename=foo14.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a preemption race in the set_task_cpu() debug check in that
when we get preempted after setting task->state we'd still be on the
rq proper, but fail the test.

Check for preempted tasks, since those are always on the RQ.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 kernel/sched.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2041,7 +2041,8 @@ void set_task_cpu(struct task_struct *p,
 	 * We should never call set_task_cpu() on a blocked task,
 	 * ttwu() will sort out the placement.
 	 */
-	WARN_ON_ONCE(p->state != TASK_RUNNING && p->state != TASK_WAKING);
+	WARN_ON_ONCE(p->state != TASK_RUNNING && p->state != TASK_WAKING &&
+			!(task_thread_info(p)->preempt_count & PREEMPT_ACTIVE));
 #endif
 
 	trace_sched_migrate_task(p, new_cpu);

-- 

