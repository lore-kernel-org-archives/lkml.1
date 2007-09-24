Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbXIXUwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbXIXUwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 16:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbXIXUv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 16:51:58 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:46755 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbXIXUv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 16:51:57 -0400
Message-ID: <46F8236B.9020902@ct.jp.nec.com>
Date: Mon, 24 Sep 2007 13:51:55 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH] sched: cleanup adjusting sched_class
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo and Dmitry,

I made a clean-up patch about fixing invalid sched_class use.

Dmitry, could you please review and sign it?


The adjusting sched_class is a missing part of the already existing
"do not leak PI boosting priority to the child" at the sched_fork().
This patch moves the adjusting sched_class from wake_up_new_task()
to sched_fork().

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---

diff --git a/kernel/sched.c b/kernel/sched.c
index 6107a0c..8862761 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1641,6 +1641,8 @@ void sched_fork(struct task_struct *p, int clone_flags)
 	 * Make sure we do not leak PI boosting priority to the child:
 	 */
 	p->prio = current->normal_prio;
+	if (!rt_prio(p->prio))
+		p->sched_class = &fair_sched_class;
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	if (likely(sched_info_on()))
@@ -1682,11 +1684,6 @@ void fastcall wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 
 	p->prio = effective_prio(p);
 
-	if (rt_prio(p->prio))
-		p->sched_class = &rt_sched_class;
-	else
-		p->sched_class = &fair_sched_class;
-
 	if (!p->sched_class->task_new || !sysctl_sched_child_runs_first ||
 			(clone_flags & CLONE_VM) || task_cpu(p) != this_cpu ||
 			!current->se.on_rq) {


