Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbYIHNVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbYIHNVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbYIHNVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:21:42 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:56168 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbYIHNVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:21:41 -0400
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 7/7] sched: activate active load balancing in new idle
	cpus
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
Date: Mon, 08 Sep 2008 18:53:54 +0530
Message-ID: <20080908132354.3221.87218.stgit@drishya.in.ibm.com>
In-Reply-To: <20080908131334.3221.61302.stgit@drishya.in.ibm.com>
References: <20080908131334.3221.61302.stgit@drishya.in.ibm.com>
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

 kernel/sched.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 4ae79f5..e47e8e8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3656,10 +3656,40 @@ redo:
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
+		if (sd->nr_balance_failed++ < 1)
+			return -1;
+
+		spin_lock_irqsave(&busiest->lock, flags);
+
+		/* don't kick the migration_thread, if the curr
+		 * task on busiest cpu can't be moved to this_cpu
+		 */
+		if (!cpu_isset(this_cpu, busiest->curr->cpus_allowed)) {
+			spin_unlock_irqrestore(&busiest->lock, flags);
+			all_pinned = 1;
+			return ld_moved;
+		}
+
+		if (!busiest->active_balance) {
+			busiest->active_balance = 1;
+			busiest->push_cpu = this_cpu;
+			active_balance = 1;
+		}
+		spin_unlock_irqrestore(&busiest->lock, flags);
+		if (active_balance)
+			wake_up_process(busiest->migration_thread);
+
 	} else
 		sd->nr_balance_failed = 0;
 

