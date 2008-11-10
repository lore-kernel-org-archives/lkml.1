Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbYKJSxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbYKJSxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 13:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbYKJSxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 13:53:22 -0500
Received: from [59.145.155.6] ([59.145.155.6]:34061 "EHLO e28smtp06.in.ibm.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754046AbYKJSxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 13:53:21 -0500
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v3 5/5] sched: activate active load balancing in new idle
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
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Tue, 11 Nov 2008 00:03:43 +0530
Message-ID: <20081110183343.562.72751.stgit@drishya.in.ibm.com>
In-Reply-To: <20081110181526.562.69941.stgit@drishya.in.ibm.com>
References: <20081110181526.562.69941.stgit@drishya.in.ibm.com>
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

 kernel/sched.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 16c5e1f..4d99509 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3687,10 +3687,45 @@ redo:
 	}
 
 	if (!ld_moved) {
+		int active_balance;
+		unsigned long flags;
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
+		/* Release this_rq lock and take in correct order */
+		spin_unlock(&this_rq->lock);
+		double_rq_lock(this_rq, busiest);
+
+		/* don't kick the migration_thread, if the curr
+		 * task on busiest cpu can't be moved to this_cpu
+		 */
+		if (!cpu_isset(this_cpu, busiest->curr->cpus_allowed)) {
+			double_rq_unlock(this_rq, busiest);
+			spin_lock(&this_rq->lock);
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
+		double_rq_unlock(this_rq, busiest);
+		if (active_balance)
+			wake_up_process(busiest->migration_thread);
+
+		spin_lock(&this_rq->lock);
 	} else
 		sd->nr_balance_failed = 0;
 

