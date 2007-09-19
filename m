Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbXISVPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbXISVPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 17:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbXISVPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:15:04 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:42826 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbXISVPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:15:02 -0400
Message-ID: <46F19148.4090404@ct.jp.nec.com>
Date: Wed, 19 Sep 2007 14:14:48 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sched: fix to use invalid sched_class
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I found an issue about the scheduler.
If you need a test case, please let me know.
Here is a patch.

When using rt_mutex, a NULL pointer dereference is occurred at
enqueue_task_rt. Here is a scenario;
1) there are two threads, the thread A is fair_sched_class and
   thread B is rt_sched_class.
2) Thread A is boosted up to rt_sched_class, because the thread A
   has a rt_mutex lock and the thread B is waiting the lock.
3) At this time, when thread A create a new thread C, the thread
   C has a rt_sched_class.
4) When doing wake_up_new_task() for the thread C, the priority
   of the thread C is out of the RT priority range, because the
   normal priority of thread A is not the RT priority. It makes
   data corruption by overflowing the rt_prio_array.
The new thread C should be fair_sched_class.

The new thread should be valid scheduler class before queuing.
This patch fixes to set the suitable scheduler class.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---

diff --git a/kernel/sched.c b/kernel/sched.c
index deeb1f8..b0c582b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1682,6 +1682,11 @@ void fastcall wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 
 	p->prio = effective_prio(p);
 
+	if (rt_prio(p->prio))
+		p->sched_class = &rt_sched_class;
+	else
+		p->sched_class = &fair_sched_class;
+
 	if (!p->sched_class->task_new || !sysctl_sched_child_runs_first ||
 			(clone_flags & CLONE_VM) || task_cpu(p) != this_cpu ||
 			!current->se.on_rq) {

