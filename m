Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbZGWTWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbZGWTWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 15:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbZGWTWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 15:22:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48185 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbZGWTVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 15:21:12 -0400
Message-Id: <20090723191957.614477996@chello.nl>
References: <20090723191642.780643661@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 23 Jul 2009 21:16:53 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 11/13] sched: Ensure the migration task doesnt go away during use
Content-Disposition: inline; filename=sched-fix-migrate.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like sched_migrate_task(), set_cpus_allowed_ptr() should hold onto the
migration thread too.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7033,8 +7033,12 @@ int set_cpus_allowed_ptr(struct task_str
 
 	if (migrate_task(p, cpumask_any_and(cpu_online_mask, new_mask), &req)) {
 		/* Need help from migration thread: drop lock and wait. */
+		struct task_struct *mt = rq->migration_thread;
+
+		get_task_struct(mt);
 		task_rq_unlock(rq, &flags);
 		wake_up_process(rq->migration_thread);
+		put_task_struct(mt);
 		wait_for_completion(&req.done);
 		tlb_migrate_finish(p->mm);
 		return 0;

-- 

