Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbYKUI3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbYKUI3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756036AbYKUI2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:28:45 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:56284 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbYKUI2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:28:44 -0500
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 3/7] sched: nominate preferred wakeup cpu
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
       Gregory Haskins <gregory.haskins@gmail.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Fri, 21 Nov 2008 14:01:14 +0530
Message-ID: <20081121083114.27075.2113.stgit@drishya.in.ibm.com>
In-Reply-To: <20081121082533.27075.12056.stgit@drishya.in.ibm.com>
References: <20081121082533.27075.12056.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the system utilisation is low and more cpus are idle,
then the process waking up from sleep should prefer to
wakeup an idle cpu from semi-idle cpu package (multi core
package) rather than a completely idle cpu package which
would waste power.

Use the sched_mc balance logic in find_busiest_group() to
nominate a preferred wakeup cpu.

This info can be sored in appropriate sched_domain, but
updating this info in all copies of sched_domain is not
practical.  Hence this information is stored in root_domain
struct which is one copy per partitioned sched domain.
The root_domain can be accessed from each cpu's runqueue
and there is one copy per partitioned sched domain.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 kernel/sched.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 79b71f3..d28cd98 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -493,6 +493,17 @@ struct root_domain {
 #ifdef CONFIG_SMP
 	struct cpupri cpupri;
 #endif
+#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
+
+	/*
+	 * Preferred wake up cpu nominated by sched_mc balance that will be
+	 * used when most cpus are idle in the system indicating overall very
+	 * low system utilisation. Triggered at POWERSAVINGS_BALANCE_WAKEUP(2)
+	 */
+	unsigned int sched_mc_preferred_wakeup_cpu;
+
+#endif
+
 };
 
 /*
@@ -3090,6 +3101,7 @@ static int move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	return 0;
 }
 
+
 /*
  * find_busiest_group finds and returns the busiest CPU group within the
  * domain. It calculates and returns the amount of weighted load which
@@ -3406,6 +3418,9 @@ out_balanced:
 
 	if (this == group_leader && group_leader != group_min) {
 		*imbalance = min_load_per_task;
+		if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP)
+			cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu =
+					first_cpu(group_leader->cpumask);
 		return group_min;
 	}
 #endif

