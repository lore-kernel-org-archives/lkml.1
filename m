Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbZEESef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbZEESef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 14:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbZEESe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 14:34:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:37549 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbZEESe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 14:34:26 -0400
Date: Tue, 5 May 2009 18:33:49 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090505155436.863098054@chello.nl>
References: <20090505155436.863098054@chello.nl>
Subject: [tip:sched/core] sched: rt: document the risk of small values in the bandwidth settings
Message-ID: <tip-60aa605dfce2976e54fa76e805ab0f221372d4d9@git.kernel.org>
Git-Commit-ID: 60aa605dfce2976e54fa76e805ab0f221372d4d9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 05 May 2009 18:33:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60aa605dfce2976e54fa76e805ab0f221372d4d9
Gitweb:     http://git.kernel.org/tip/60aa605dfce2976e54fa76e805ab0f221372d4d9
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 May 2009 17:50:21 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 5 May 2009 20:07:57 +0200

sched: rt: document the risk of small values in the bandwidth settings

Thomas noted that we should disallow sysctl_sched_rt_runtime == 0 for
(!RT_GROUP) since the root group always has some RT tasks in it.

Further, update the documentation to inspire clue.

[ Impact: exclude corner-case sysctl_sched_rt_runtime value ]

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090505155436.863098054@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/scheduler/sched-rt-group.txt |   18 ++++++++++++++++++
 kernel/sched.c                             |    7 +++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/Documentation/scheduler/sched-rt-group.txt b/Documentation/scheduler/sched-rt-group.txt
index 5ba4d3f..eb74b01 100644
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
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 54d67b9..2a43a58 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9917,6 +9917,13 @@ static int sched_rt_global_constraints(void)
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
