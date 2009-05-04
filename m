Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbZEDPI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbZEDPI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 11:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757121AbZEDPIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 11:08:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:44135 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980AbZEDPIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 11:08:05 -0400
Subject: [PATCH] sched: rt: document the risk of small values in the
 bandwidth settings
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 04 May 2009 17:07:58 +0200
Message-Id: <1241449678.7620.4931.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas noted that we should disallow sysctl_sched_rt_runtime == 0 for (!
RT_GROUP) since the root group always has some RT tasks in it.

Further, update the documentation to inspire clue.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/scheduler/sched-rt-group.txt |   18 ++++++++++++++++++
 kernel/sched.c                             |    7 +++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/Documentation/scheduler/sched-rt-group.txt b/Documentation/scheduler/sched-rt-group.txt
index 5ba4d3f..cfd51c0 100644
--- a/Documentation/scheduler/sched-rt-group.txt
+++ b/Documentation/scheduler/sched-rt-group.txt
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
+Fiddling with these settings can result in an unusable system, the knobs are
+root only and assume root knows what he's on about.
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
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 11f6da4..c5ef114 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -10021,6 +10021,13 @@ static int sched_rt_global_constraints(void)
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

