Return-Path: <linux-kernel-owner+w=401wt.eu-S1764895AbXLMRQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764895AbXLMRQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762450AbXLMRQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:16:42 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:58461 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759538AbXLMRQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:16:40 -0500
Date: Thu, 13 Dec 2007 22:46:06 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E McKenney <paulmck@us.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Ted Tso <tytso@us.ibm.com>, dvhltc@us.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 3/6] Preempt-RCU: Fix rcu_barrier for preemptive
	environment
Message-ID: <20071213171606.GD25981@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071213170348.GA25981@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213170348.GA25981@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preempt-RCU: Fix rcu_barrier for preemptive environment.

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Fix rcu_barrier() to work properly in preemptive kernel environment.
Also, the ordering of callback must be preserved while moving
callbacks to another CPU during CPU hotplug.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Dipankar Sarma <dipankar@in.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 kernel/rcuclassic.c |    2 +-
 kernel/rcupdate.c   |   10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index 11c16aa..deb2acc 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -371,9 +371,9 @@ static void __rcu_offline_cpu(struct rcu_data *this_rdp,
 	if (rcp->cur != rcp->completed)
 		cpu_quiet(rdp->cpu, rcp);
 	spin_unlock_bh(&rcp->lock);
+	rcu_move_batch(this_rdp, rdp->donelist, rdp->donetail);
 	rcu_move_batch(this_rdp, rdp->curlist, rdp->curtail);
 	rcu_move_batch(this_rdp, rdp->nxtlist, rdp->nxttail);
-	rcu_move_batch(this_rdp, rdp->donelist, rdp->donetail);
 }
 
 static void rcu_offline_cpu(int cpu)
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 0ccd009..760dfc2 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -115,7 +115,17 @@ void rcu_barrier(void)
 	mutex_lock(&rcu_barrier_mutex);
 	init_completion(&rcu_barrier_completion);
 	atomic_set(&rcu_barrier_cpu_count, 0);
+	/*
+	 * The queueing of callbacks in all CPUs must be atomic with
+	 * respect to RCU, otherwise one CPU may queue a callback,
+	 * wait for a grace period, decrement barrier count and call
+	 * complete(), while other CPUs have not yet queued anything.
+	 * So, we need to make sure that grace periods cannot complete
+	 * until all the callbacks are queued.
+	 */
+	rcu_read_lock();
 	on_each_cpu(rcu_barrier_func, NULL, 0, 1);
+	rcu_read_unlock();
 	wait_for_completion(&rcu_barrier_completion);
 	mutex_unlock(&rcu_barrier_mutex);
 }
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
