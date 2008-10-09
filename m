Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbYJIMGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbYJIMGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 08:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759130AbYJIMFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 08:05:40 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:51919 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759094AbYJIMFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 08:05:39 -0400
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 4/5] sched: small imbalance corrections
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
Date: Thu, 09 Oct 2008 17:39:51 +0530
Message-ID: <20081009120951.27010.3802.stgit@drishya.in.ibm.com>
In-Reply-To: <20081009120705.27010.12857.stgit@drishya.in.ibm.com>
References: <20081009120705.27010.12857.stgit@drishya.in.ibm.com>
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

 kernel/sched.c |   74 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 74 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index c99b5bd..cf1aae1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3229,6 +3229,80 @@ void update_sd_loads(struct sd_loads *sdl, struct group_loads *gl)
 	}
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
+	if (sdl->busiest.load_per_cpu - sdl->local.load_per_cpu +
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
+			min(sdl->busiest.avg_load_per_task,
+			sdl->busiest.load_per_cpu);
+	pwr_now += sdl->local.group->__cpu_power *
+			min(sdl->local.avg_load_per_task,
+			sdl->local.load_per_cpu);
+	pwr_now /= SCHED_LOAD_SCALE;
+
+	/* Amount of load we'd subtract */
+	tmp = sg_div_cpu_power(sdl->busiest.group,
+			sdl->busiest.avg_load_per_task * SCHED_LOAD_SCALE);
+	if (sdl->busiest.load_per_cpu > tmp)
+		pwr_move += sdl->busiest.group->__cpu_power *
+			min(sdl->busiest.avg_load_per_task,
+			    sdl->busiest.load_per_cpu - tmp);
+
+	/* Amount of load we'd add */
+	if (sdl->busiest.load_per_cpu * sdl->busiest.group->__cpu_power <
+			sdl->busiest.avg_load_per_task * SCHED_LOAD_SCALE)
+		tmp = sg_div_cpu_power(sdl->local.group,
+				sdl->busiest.load_per_cpu *
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

