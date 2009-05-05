Return-Path: <linux-kernel-owner+w=401wt.eu-S1758491AbZEEQUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491AbZEEQUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 12:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbZEEQSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 12:18:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50005 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbZEEQSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 12:18:10 -0400
Message-Id: <20090505155436.863098054@chello.nl>
References: <20090505155020.309162852@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 05 May 2009 17:50:21 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/7] sched: rt: document the risk of small values in the bandwidth settings 
Content-Disposition: inline; filename=sched-rt-docu.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas noted that we should disallow sysctl_sched_rt_runtime == 0 for (!
RT_GROUP) since the root group always has some RT tasks in it.

Further, update the documentation to inspire clue.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/scheduler/sched-rt-group.txt |   18 ++++++++++++++++++
 kernel/sched.c                             |    7 +++++++
 2 files changed, 25 insertions(+)

Index: linux-2.6/Documentation/scheduler/sched-rt-group.txt
===================================================================
--- linux-2.6.orig/Documentation/scheduler/sched-rt-group.txt
+++ linux-2.6/Documentation/scheduler/sched-rt-group.txt
@@ -4,6 +4,7 @@
 CONTENTS
 ========
 
+0. WARNING
 1. Overview
   1.1 The problem
   1.2 The solution
@@ -14,6 +15,23 @@ CONTENTS
 3. Future plans
 
 
+0. WARNING
+==========
+
+ Fiddling with these settings can result in an unstable system, the knobs are
+ root only and assumes root knows what he is doing.
+
+Most notable:
+
+ * very small values in sched_rt_period_us can result in an unstable
+   system when the period is smaller than either the available hrtimer
+   resolution, or the time it takes to handle the budget refresh itself.
+
+ * very small values in sched_rt_runtime_us can result in an unstable
+   system when the runtime is so small the system has difficulty making
+   forward progress (NOTE: the migration thread and kstopmachine both
+   are real-time processes).
+
 1. Overview
 ===========
 
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -10024,6 +10024,13 @@ static int sched_rt_global_constraints(v
 	if (sysctl_sched_rt_period <= 0)
 		return -EINVAL;
 
+	/*
+	 * There's always some RT tasks in the root group
+	 * -- migration, kstopmachine etc..
+	 */
+	if (sysctl_sched_rt_runtime == 0)
+		return -EBUSY;
+
 	spin_lock_irqsave(&def_rt_bandwidth.rt_runtime_lock, flags);
 	for_each_possible_cpu(i) {
 		struct rt_rq *rt_rq = &cpu_rq(i)->rt;

-- 

