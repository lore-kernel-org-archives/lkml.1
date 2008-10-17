Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbYJQGmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbYJQGmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 02:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYJQGmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 02:42:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61650 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbYJQGmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 02:42:40 -0400
Message-ID: <48F8335E.5060401@cn.fujitsu.com>
Date: Fri, 17 Oct 2008 14:40:30 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] rcupdate: fix bug of rcu_barrier*()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


current rcu_barrier_bh() is like this:

void rcu_barrier_bh(void)
{
	BUG_ON(in_interrupt());
	/* Take cpucontrol mutex to protect against CPU hotplug */
	mutex_lock(&rcu_barrier_mutex);
	init_completion(&rcu_barrier_completion);
	atomic_set(&rcu_barrier_cpu_count, 0);
	/*
	 * The queueing of callbacks in all CPUs must be atomic with
	 * respect to RCU, otherwise one CPU may queue a callback,
	 * wait for a grace period, decrement barrier count and call
	 * complete(), while other CPUs have not yet queued anything.
	 * So, we need to make sure that grace periods cannot complete
	 * until all the callbacks are queued.
	 */
	rcu_read_lock();
	on_each_cpu(rcu_barrier_func, (void *)RCU_BARRIER_BH, 1);
	rcu_read_unlock();
	wait_for_completion(&rcu_barrier_completion);
	mutex_unlock(&rcu_barrier_mutex);
}

The inconsistency of the code and the comments show a bug here.
rcu_read_lock() cannot make sure that "grace periods for RCU_BH
cannot complete until all the callbacks are queued".
it only make sure that race periods for RCU cannot complete
until all the callbacks are queued.

so we must use rcu_read_lock_bh() for rcu_barrier_bh().
like this:

void rcu_barrier_bh(void)
{
	......
	rcu_read_lock_bh();
	on_each_cpu(rcu_barrier_func, (void *)RCU_BARRIER_BH, 1);
	rcu_read_unlock_bh();
	......
}

and also rcu_barrier() rcu_barrier_sched() are implemented like this.
it will bring a lot of duplicate code. My patch uses another way to
fix this bug, please see the comment of my patch.
Thank Paul E. McKenney for he rewrote the comment.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 467d594..ad63af8 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -119,18 +119,19 @@ static void _rcu_barrier(enum rcu_barrier type)
 	/* Take cpucontrol mutex to protect against CPU hotplug */
 	mutex_lock(&rcu_barrier_mutex);
 	init_completion(&rcu_barrier_completion);
-	atomic_set(&rcu_barrier_cpu_count, 0);
 	/*
-	 * The queueing of callbacks in all CPUs must be atomic with
-	 * respect to RCU, otherwise one CPU may queue a callback,
-	 * wait for a grace period, decrement barrier count and call
-	 * complete(), while other CPUs have not yet queued anything.
-	 * So, we need to make sure that grace periods cannot complete
-	 * until all the callbacks are queued.
+	 * Initialize rcu_barrier_cpu_count to 1, then invoke
+	 * rcu_barrier_func() on each CPU, so that each CPU also has
+	 * incremented rcu_barrier_cpu_count.  Only then is it safe to
+	 * decrement rcu_barrier_cpu_count -- otherwise the first CPU
+	 * might complete its grace period before all of the other CPUs
+	 * did their increment, causing this function to return too
+	 * early.
 	 */
-	rcu_read_lock();
+	atomic_set(&rcu_barrier_cpu_count, 1);
 	on_each_cpu(rcu_barrier_func, (void *)type, 1);
-	rcu_read_unlock();
+	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
+		complete(&rcu_barrier_completion);
 	wait_for_completion(&rcu_barrier_completion);
 	mutex_unlock(&rcu_barrier_mutex);
 }





