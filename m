Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbYKUIam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbYKUIam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756755AbYKUIaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:30:13 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:57053 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756734AbYKUIaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:30:11 -0500
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 4/7] sched: bias task wakeups to preferred semi-idle
	packages
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
Date: Fri, 21 Nov 2008 14:01:27 +0530
Message-ID: <20081121083126.27075.14849.stgit@drishya.in.ibm.com>
In-Reply-To: <20081121082533.27075.12056.stgit@drishya.in.ibm.com>
References: <20081121082533.27075.12056.stgit@drishya.in.ibm.com>
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
wake_idle() to bias task wakeups if the following conditions
are satisfied:
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

Cache hotness is considered since the actual biasing happens
in wake_idle() only if the application is cache cold.

This technique will effectively move short running bursty jobs in
a mostly idle system.

Wakeup biasing for power savings gets automatically disabled if
system utilisation increases due to the fact that the probability
of finding both this_cpu and prev_cpu idle decreases.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 kernel/sched_fair.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 98345e4..939f2a1 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1027,6 +1027,23 @@ static int wake_idle(int cpu, struct task_struct *p)
 	cpumask_t tmp;
 	struct sched_domain *sd;
 	int i;
+	unsigned int chosen_wakeup_cpu;
+	int this_cpu;
+
+	/*
+	 * At POWERSAVINGS_BALANCE_WAKEUP level, if both this_cpu and prev_cpu
+	 * are idle and this is not a kernel thread and this task's affinity
+	 * allows it to be moved to preferred cpu, then just move!
+	 */
+
+	this_cpu = smp_processor_id();
+	chosen_wakeup_cpu =
+		cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu;
+
+	if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP &&
+		idle_cpu(cpu) && idle_cpu(this_cpu) && p->mm &&
+		cpu_isset(chosen_wakeup_cpu, p->cpus_allowed))
+		return chosen_wakeup_cpu;
 
 	/*
 	 * If it is idle, then it is the best cpu to run this task.

