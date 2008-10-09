Return-Path: <linux-kernel-owner+w=401wt.eu-S1759147AbYJIMF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147AbYJIMF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 08:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757863AbYJIMF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 08:05:26 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:47624 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758895AbYJIMFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 08:05:24 -0400
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 2/5] sched: calculate statistics for current load
	balance domain
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
Date: Thu, 09 Oct 2008 17:39:34 +0530
Message-ID: <20081009120934.27010.45896.stgit@drishya.in.ibm.com>
In-Reply-To: <20081009120705.27010.12857.stgit@drishya.in.ibm.com>
References: <20081009120705.27010.12857.stgit@drishya.in.ibm.com>
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

 kernel/sched.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ab77937..cfd83d9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3178,6 +3178,57 @@ int get_group_loads(struct sched_group *group, int this_cpu,
 	return need_balance;
 }
 
+/* Struct to hold sched domain level loads */
+
+struct sd_loads {
+	struct sched_domain *sd;
+	unsigned long load; /* Total decay load */
+	unsigned long cpu_power; /* Total cpu_power */
+	unsigned long max_load; /* load of busiest group */
+	unsigned long load_per_cpu; /* Decay load per cpu in this sd
+				     * (load/cpu_power)
+				     */
+	struct group_loads local; /* this_cpu's group,
+				   * need to pull from busiest
+				   */
+	struct group_loads busiest; /* Candidate group to pull */
+	/* sched_mc power_save balance groups */
+	struct group_loads min_load_group; /* Group that is least loaded and
+					    * can fit the tasks into the
+					    * leader group
+					    */
+	struct group_loads power_save_leader_group; /* Group that is almost
+						     * full but can still pull
+						     * tasks from
+						     * min_load_group
+						     */
+};
+
+/* Function to aggregate per group loads to sched domain loads */
+
+void update_sd_loads(struct sd_loads *sdl, struct group_loads *gl)
+{
+	int group_capacity = gl->group->__cpu_power / SCHED_LOAD_SCALE;
+	sdl->max_load = 0;
+
+	if (gl->local_group)
+		sdl->local = *gl;
+	else {
+		sdl->load += gl->load;
+		sdl->cpu_power += gl->group->__cpu_power;
+
+
+		/* Find the busiest */
+		if (gl->load > sdl->max_load &&
+			(gl->nr_running > group_capacity ||
+			 gl->group_imbalance)) {
+
+			sdl->max_load = gl->load;
+			sdl->busiest = *gl;
+		}
+	}
+}
+
 /*
  * find_busiest_group finds and returns the busiest CPU group within the
  * domain. It calculates and returns the amount of weighted load which

