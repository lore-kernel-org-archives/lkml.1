Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbXFNJsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbXFNJsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 05:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbXFNJsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 05:48:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43447 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbXFNJsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 05:48:42 -0400
Date: Thu, 14 Jun 2007 11:48:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch] sched: fix SysRq-N (normalize RT tasks)
Message-ID: <20070614094830.GA494@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: [patch] sched: fix SysRq-N (normalize RT tasks)

Gene Heskett reported the following problem while testing CFS: SysRq-N 
is not always effective in normalizing tasks back to SCHED_OTHER.

the reason for that turns out to be the following bug: 
normalize_rt_tasks() uses for_each_process() to iterate through all 
tasks in the system. The problem is, this method does not iterate 
through all tasks, it iterates through all thread groups. The proper 
mechanism to enumerate all tasks is to use a do_each_thread() + 
while_each_thread() loop.

obvious bugfix for v2.6.22 inclusion. -stable candidate as well.

Reported-by: Gene Heskett <gene.heskett@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux/kernel/sched.c
===================================================================
--- linux/kernel/sched.c
+++ linux/kernel/sched.c
@@ -7071,12 +7071,13 @@ EXPORT_SYMBOL(__might_sleep);
 void normalize_rt_tasks(void)
 {
 	struct prio_array *array;
-	struct task_struct *p;
+	struct task_struct *g, *p;
 	unsigned long flags;
 	struct rq *rq;
 
 	read_lock_irq(&tasklist_lock);
-	for_each_process(p) {
+
+	do_each_thread(g, p) {
 		if (!rt_task(p))
 			continue;
 
@@ -7094,7 +7095,8 @@ void normalize_rt_tasks(void)
 
 		__task_rq_unlock(rq);
 		spin_unlock_irqrestore(&p->pi_lock, flags);
-	}
+	} while_each_thread(g, p);
+
 	read_unlock_irq(&tasklist_lock);
 }
 
