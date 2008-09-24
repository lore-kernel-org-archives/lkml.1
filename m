Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYIXQPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYIXQPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbYIXQOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:14:45 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:38198 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753704AbYIXQOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:14:43 -0400
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v1 2/5] Calculate statistics for current load balance
	domain
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
Date: Wed, 24 Sep 2008 21:47:39 +0530
Message-ID: <20080924161739.31581.70726.stgit@drishya.in.ibm.com>
In-Reply-To: <20080924161228.31581.57651.stgit@drishya.in.ibm.com>
References: <20080924161228.31581.57651.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add data structures and function to collect per sched domain 
statistics required for load balance decision.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 kernel/sched.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index abf60ea..8c394a4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3178,6 +3178,47 @@ int get_group_loads(struct sched_group *group, int this_cpu,
 	return need_balance;
 }
 
+/* Struct to hold sched domain level loads */
+
+struct sd_loads {
+	struct sched_domain *sd;
+	unsigned long load;
+	unsigned long cpu_power;
+	unsigned long max_load;
+	unsigned long avg_load;
+	struct group_loads local;
+	struct group_loads busiest;
+	/* sched_mc balance groups */
+	struct group_loads min_load_group;
+	struct group_loads power_save_leader_group;
+};
+
+/* Function to aggregate per group loads to sched domain loads */
+
+void update_sd_loads(struct sd_loads *sdl, struct group_loads *gl)
+{
+	int group_capacity = gl->group->__cpu_power / SCHED_LOAD_SCALE;
+
+	if (gl->local_group)
+		sdl->local = *gl;
+	else {
+		sdl->load += gl->load;
+		sdl->cpu_power += gl->group->__cpu_power;
+
+
+		/* Find the busiest */
+		if (gl->load > sdl->load &&
+			(gl->nr_running > group_capacity ||
+			 gl->group_imbalance)) {
+
+			sdl->load = gl->load;
+			sdl->busiest = *gl;
+		}
+	}
+
+
+}
+
 /*
  * find_busiest_group finds and returns the busiest CPU group within the
  * domain. It calculates and returns the amount of weighted load which

