Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab0CESp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 13:45:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:56337 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151Ab0CESp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 13:45:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,588,1262592000"; 
   d="scan'208";a="546467791"
Message-Id: <20100305184213.829832580@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 05 Mar 2010 10:39:25 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>
Cc: Arjan van de Ven <arjan@linux.jf.intel.com>, linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yanmin Zhang <yanmin_zhang@linux.jf.intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/2] sched: check for prev_cpu == this_cpu in wake_affine()
Content-Disposition: inline; filename=fix_wake_affine.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a single cpu system with SMT, in the scenario of one SMT thread being
idle with another SMT thread running a task and doing a non sync wakeup of
another task, we see (from the traces) that the woken up task ends up running
on the busy thread instead of the idle thread. Idle balancing that comes
in little bit later is fixing the scernaio.

But fixing this wake balance and running the woken up task directly on the
idle SMT thread improved the performance (phoronix 7zip compression workload)
by ~9% on an atom platform.

During the process wakeup, select_task_rq_fair() and wake_affine() makes
the decision to wakeup the task either on the previous cpu that the task
ran or the cpu that the task is currently woken up.

select_task_rq_fair() also goes through to see if there are any idle siblings
for the cpu that the task is woken up on. This is to ensure that we select
any idle sibling rather than choose a busy cpu.

In the above load scenario, it so happens that the prev_cpu (that the
task ran before) and this_cpu (where it is woken up currently) are the same. And
in this case, it looks like wake_affine() returns 0 and ultimately not selecting
the idle sibling chosen by select_idle_sibling() in select_task_rq_fair().
Further down the path of select_task_rq_fair(), we ultimately select
the currently running cpu (busy SMT thread instead of the idle SMT thread).

Check for prev_cpu == this_cpu in wake_affine() and no need to do
any fancy stuff(and ultimately taking wrong decisions) in this case.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/sched_fair.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -1252,6 +1252,10 @@ static int wake_affine(struct sched_doma
 	idx	  = sd->wake_idx;
 	this_cpu  = smp_processor_id();
 	prev_cpu  = task_cpu(p);
+
+	if (prev_cpu == this_cpu)
+		return 1;
+
 	load	  = source_load(prev_cpu, idx);
 	this_load = target_load(this_cpu, idx);
 


