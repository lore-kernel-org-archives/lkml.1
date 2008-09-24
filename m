Return-Path: <linux-kernel-owner+w=401wt.eu-S1755079AbYIXQPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbYIXQPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbYIXQOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:14:46 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:57860 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753791AbYIXQOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:14:43 -0400
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v1 4/5] Small imbalance corrections
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 24 Sep 2008 21:48:16 +0530
Message-ID: <20080924161816.31581.57747.stgit@drishya.in.ibm.com>
In-Reply-To: <20080924161228.31581.57651.stgit@drishya.in.ibm.com>
References: <20080924161228.31581.57651.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add functions to bump up the imbalance to eventually initiate 
a task move to balance across groups.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 kernel/sched.c |   72 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index dd87061..1f38e2c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3219,6 +3219,78 @@ void update_sd_loads(struct sd_loads *sdl, struct group_loads *gl)
 
 }
 
+/* Bump up imbalance to one task so that some task movement can happen */
+
+int small_imbalance_one_task(struct sd_loads *sdl, unsigned long *imbalance)
+{
+	unsigned int imbn;
+	imbn = 2;
+	if (sdl->local.nr_running) {
+		if (sdl->busiest.avg_load_per_task >
+			sdl->local.avg_load_per_task)
+			imbn = 1;
+	}
+
+	if (sdl->max_load - sdl->local.load +
+		2*sdl->busiest.avg_load_per_task >=
+				sdl->busiest.avg_load_per_task * imbn) {
+		*imbalance = sdl->busiest.avg_load_per_task;
+		return 1;
+	}
+	return 0;
+}
+
+/*
+ * Adjust imbalance to move task if the result of the move will
+ * yield better use of cpu power
+ */
+
+void small_imbalance_optimize_cpu_power(struct sd_loads *sdl,
+					unsigned long *imbalance)
+{
+	unsigned long tmp, pwr_now, pwr_move;
+	pwr_move = pwr_now = 0;
+
+	/*
+	 * OK, we don't have enough imbalance to justify moving tasks,
+	 * however we may be able to increase total CPU power used by
+	 * moving them.
+	 */
+
+	pwr_now += sdl->busiest.group->__cpu_power *
+			min(sdl->busiest.avg_load_per_task, sdl->max_load);
+	pwr_now += sdl->local.group->__cpu_power *
+			min(sdl->local.avg_load_per_task, sdl->local.load);
+	pwr_now /= SCHED_LOAD_SCALE;
+
+	/* Amount of load we'd subtract */
+	tmp = sg_div_cpu_power(sdl->busiest.group,
+			sdl->busiest.avg_load_per_task * SCHED_LOAD_SCALE);
+	if (sdl->max_load > tmp)
+		pwr_move += sdl->busiest.group->__cpu_power *
+			min(sdl->busiest.avg_load_per_task,
+			    sdl->max_load - tmp);
+
+	/* Amount of load we'd add */
+	if (sdl->max_load * sdl->busiest.group->__cpu_power <
+			sdl->busiest.avg_load_per_task * SCHED_LOAD_SCALE)
+		tmp = sg_div_cpu_power(sdl->local.group,
+				sdl->max_load *
+				sdl->busiest.group->__cpu_power);
+	else
+		tmp = sg_div_cpu_power(sdl->local.group,
+			sdl->busiest.avg_load_per_task * SCHED_LOAD_SCALE);
+	pwr_move += sdl->local.group->__cpu_power *
+			min(sdl->local.avg_load_per_task,
+			sdl->local.load + tmp);
+	pwr_move /= SCHED_LOAD_SCALE;
+
+	/* Move if we gain throughput */
+	if (pwr_move > pwr_now)
+		*imbalance = sdl->busiest.avg_load_per_task;
+
+}
+
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
 void update_powersavings_group_loads(struct sd_loads *sdl,
 				     struct group_loads *gl,

