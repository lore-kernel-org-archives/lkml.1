Return-Path: <linux-kernel-owner+w=401wt.eu-S1755728AbYBDVSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbYBDVSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:18:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbYBDVRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:17:13 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46906 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359AbYBDVRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:17:08 -0500
Message-Id: <20080204211836.465121000@chello.nl>
References: <20080204210258.118479000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 04 Feb 2008 22:02:59 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: tong.n.li@intel.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/8] sched: fix incorrect irq lock usage in normalize_rt_tasks()
Content-Disposition: inline; filename=sched-fix-normalize-rt-tasks.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lockdep spotted this bogus irq locking. normalize_rt_tasks() can be called
from hardirq context through sysrq-n

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7345,7 +7345,7 @@ void normalize_rt_tasks(void)
 	unsigned long flags;
 	struct rq *rq;
 
-	read_lock_irq(&tasklist_lock);
+	read_lock_irqsave(&tasklist_lock, flags);
 	do_each_thread(g, p) {
 		/*
 		 * Only normalize user tasks:
@@ -7371,16 +7371,16 @@ void normalize_rt_tasks(void)
 			continue;
 		}
 
-		spin_lock_irqsave(&p->pi_lock, flags);
+		spin_lock(&p->pi_lock);
 		rq = __task_rq_lock(p);
 
 		normalize_task(rq, p);
 
 		__task_rq_unlock(rq);
-		spin_unlock_irqrestore(&p->pi_lock, flags);
+		spin_unlock(&p->pi_lock);
 	} while_each_thread(g, p);
 
-	read_unlock_irq(&tasklist_lock);
+	read_unlock_irqrestore(&tasklist_lock, flags);
 }
 
 #endif /* CONFIG_MAGIC_SYSRQ */

--

