Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbYLKRk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbYLKRk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 12:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757585AbYLKRjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 12:39:49 -0500
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:41459 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757574AbYLKRjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 12:39:48 -0500
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v5 5/7] sched: activate active load balancing in new idle
	cpus
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
Date: Thu, 11 Dec 2008 23:13:10 +0530
Message-ID: <20081211174310.2020.81073.stgit@drishya.in.ibm.com>
In-Reply-To: <20081211173831.2020.57550.stgit@drishya.in.ibm.com>
References: <20081211173831.2020.57550.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Active load balancing is a process by which migration thread
is woken up on the target CPU in order to pull current
running task on another package into this newly idle
package.

This method is already in use with normal load_balance(),
this patch introduces this method to new idle cpus when
sched_mc is set to POWERSAVINGS_BALANCE_WAKEUP.

This logic provides effective consolidation of short running
daemon jobs in a almost idle system

The side effect of this patch may be ping-ponging of tasks
if the system is moderately utilised. May need to adjust the
iterations before triggering.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 kernel/sched.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0918677..d60f191 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3692,10 +3692,64 @@ redo:
 	}
 
 	if (!ld_moved) {
+		int active_balance;
+
 		schedstat_inc(sd, lb_failed[CPU_NEWLY_IDLE]);
 		if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
 		    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
 			return -1;
+
+		if (sched_mc_power_savings < POWERSAVINGS_BALANCE_WAKEUP)
+			return -1;
+
+		if (sd->nr_balance_failed++ < 2)
+			return -1;
+
+		/*
+		 * The only task running in a non-idle cpu can be moved to this
+		 * cpu in an attempt to completely freeup the other CPU
+		 * package. The same method used to move task in load_balance()
+		 * have been extended for load_balance_newidle() to speedup
+		 * consolidation at sched_mc=POWERSAVINGS_BALANCE_WAKEUP (2)
+		 *
+		 * The package power saving logic comes from
+		 * find_busiest_group().  If there are no imbalance, then
+		 * f_b_g() will return NULL.  However when sched_mc={1,2} then
+		 * f_b_g() will select a group from which a running task may be
+		 * pulled to this cpu in order to make the other package idle.
+		 * If there is no opportunity to make a package idle and if
+		 * there are no imbalance, then f_b_g() will return NULL and no
+		 * action will be taken in load_balance_newidle().
+		 *
+		 * Under normal task pull operation due to imbalance, there
+		 * will be more than one task in the source run queue and
+		 * move_tasks() will succeed.  ld_moved will be true and this
+		 * active balance code will not be triggered.
+		 */
+
+		/* Lock busiest in correct order while this_rq is held */
+		double_lock_balance(this_rq, busiest);
+
+		/*
+		 * don't kick the migration_thread, if the curr
+		 * task on busiest cpu can't be moved to this_cpu
+		 */
+		if (!cpu_isset(this_cpu, busiest->curr->cpus_allowed)) {
+			double_unlock_balance(this_rq, busiest);
+			all_pinned = 1;
+			return ld_moved;
+		}
+
+		if (!busiest->active_balance) {
+			busiest->active_balance = 1;
+			busiest->push_cpu = this_cpu;
+			active_balance = 1;
+		}
+
+		double_unlock_balance(this_rq, busiest);
+		if (active_balance)
+			wake_up_process(busiest->migration_thread);
+
 	} else
 		sd->nr_balance_failed = 0;
 

