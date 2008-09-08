Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778AbYIHNUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbYIHNUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYIHNUC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:20:02 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:55293 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYIHNUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:20:00 -0400
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 6/7] sched: bias task wakeups to preferred semi-idle
	packages
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Mon, 08 Sep 2008 18:52:33 +0530
Message-ID: <20080908132233.3221.18231.stgit@drishya.in.ibm.com>
In-Reply-To: <20080908131334.3221.61302.stgit@drishya.in.ibm.com>
References: <20080908131334.3221.61302.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preferred wakeup cpu (from a semi idle package) has been
nominated in find_busiest_group() in the previous patch.  Use
this information in sched_mc_preferred_wakeup_cpu in function
select_task_rq_fair() to bias task wakeups if the following
conditions are satisfied:
	- The present cpu that is trying to wakeup the process is
	  idle and waking the target process on this cpu will
	  potentially wakeup a completely idle package
	- The previous cpu on which the target process ran is
	  also idle and hence selecting the previous cpu may
	  wakeup a semi idle cpu package
	- The task being woken up is allowed to run in the
	  nominated cpu (cpu affinity and restrictions)

Basically if both the current cpu and the previous cpu on
which the task ran is idle, select the nominated cpu from semi
idle cpu package for running the new task that is waking up.

Cache hotness and system utilisation could also be considered
before the decision is made.  (Not currently implemented)

This technique will effectively move short running bursty jobs in
an mostly idle system.

Wakeup biasing for power savings gets automatically disabled if
system utilisation increases due to the fact that the probability
of finding both this_cpu and prev_cpu idle decreases.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 kernel/sched_fair.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index f1c96e3..1301521 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -73,6 +73,9 @@ unsigned int sysctl_sched_wakeup_granularity = 5000000UL;
 
 const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
 
+/* Preferred wakeup cpu nominated by sched_mc load balancing logic */
+extern unsigned int sched_mc_preferred_wakeup_cpu;
+
 /**************************************************************
  * CFS operations on generic schedulable entities:
  */
@@ -1232,6 +1235,16 @@ static int select_task_rq_fair(struct task_struct *p, int sync)
 		}
 	}
 
+	/*
+	 * At POWERSAVINGS_BALANCE_WAKEUP level, if both this_cpu and prev_cpu
+	 * are idle and this is not a kernel thread and this task's affinity
+	 * allows it to be moved to preferred cpu, then just move!
+	 */
+	if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP &&
+		idle_cpu(prev_cpu) && idle_cpu(this_cpu) && p->mm &&
+		cpu_isset(sched_mc_preferred_wakeup_cpu, p->cpus_allowed))
+		return sched_mc_preferred_wakeup_cpu;
+
 	if (unlikely(!cpu_isset(this_cpu, p->cpus_allowed)))
 		goto out;
 

