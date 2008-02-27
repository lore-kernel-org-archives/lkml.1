Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986AbYB0LBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbYB0LBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 06:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbYB0LAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 06:00:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43154 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbYB0LAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 06:00:52 -0500
Subject: [PATCH] sched: rt-group: fixup schedulability constraints
	calculation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 12:00:46 +0100
Message-Id: <1204110046.6242.379.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched: rt-group: fixup schedulability constraints calculation

div64_64() has a different calling convention than do_div() :/

fix a few untidies while were here; sysctl_sched_rt_period may overflow
due to that multiplication, so cast to u64 first. Also that RUNTIME_INF
juggling makes little sense although its an effective NOP.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7934,9 +7934,7 @@ static unsigned long to_ratio(u64 period
 	if (runtime == RUNTIME_INF)
 		return 1ULL << 16;
 
-	runtime *= (1ULL << 16);
-	div64_64(runtime, period);
-	return runtime;
+	return div64_64(runtime << 16, period);
 }
 
 static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
@@ -7965,18 +7963,16 @@ int sched_group_set_rt_runtime(struct ta
 	u64 rt_runtime, rt_period;
 	int err = 0;
 
-	rt_period = sysctl_sched_rt_period * NSEC_PER_USEC;
+	rt_period = (u64)sysctl_sched_rt_period * NSEC_PER_USEC;
 	rt_runtime = (u64)rt_runtime_us * NSEC_PER_USEC;
 	if (rt_runtime_us == -1)
-		rt_runtime = rt_period;
+		rt_runtime = RUNTIME_INF;
 
 	mutex_lock(&rt_constraints_mutex);
 	if (!__rt_schedulable(tg, rt_period, rt_runtime)) {
 		err = -EINVAL;
 		goto unlock;
 	}
-	if (rt_runtime_us == -1)
-		rt_runtime = RUNTIME_INF;
 	tg->rt_runtime = rt_runtime;
  unlock:
 	mutex_unlock(&rt_constraints_mutex);


