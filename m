Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbZCGK42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbZCGK42 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 05:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbZCGK4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 05:56:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61821 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753921AbZCGK4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 05:56:18 -0500
Message-ID: <49B2526E.40106@cn.fujitsu.com>
Date: Sat, 07 Mar 2009 18:54:38 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] rcu_barrier VS cpu_hotplug: Ensure callbacks in dead cpu
 are migrated to online cpu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[RFC]
I don't like this patch, but I thought for some days and I can't
thought out a better one.

I'm very hope rcu_barrier() can be called anywhere(any sleepable context).
But get_online_cpus() is a very large lock, it limits rcu_barrier().

We can avoid get_online_cpus() easily for rcupreempt by using a new rcu_barrier:
void rcu_barrier(void)
{
	for each rcu_data {
		lock rcu_data;
		if rcu_data is not empty, queue a callback for rcu_barrier;
		unlock rcu_data;
	}
}
But we cannot use this algorithm for rcuclassic and rcutree,
rcu_data in rcuclassic and rcutree have not a spinlock for queuing callback.

From: Lai Jiangshan <laijs@cn.fujitsu.com>

cpu hotplug may be happened asynchronously, some rcu callbacks are maybe
still in dead cpu, rcu_barrier() also needs to wait for these rcu callbacks
to complete, so we must ensure callbacks in dead cpu are migrated to
online cpu.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index cae8a05..4665d18 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -129,6 +129,8 @@ static void rcu_barrier_func(void *type)
 static void _rcu_barrier(enum rcu_barrier type)
 {
 	BUG_ON(in_interrupt());
+	/* Ensure callbacks in dead cpu are migrated to online cpu */
+	get_online_cpus();
 	/* Take cpucontrol mutex to protect against CPU hotplug */
 	mutex_lock(&rcu_barrier_mutex);
 	init_completion(&rcu_barrier_completion);
@@ -147,6 +149,7 @@ static void _rcu_barrier(enum rcu_barrier type)
 		complete(&rcu_barrier_completion);
 	wait_for_completion(&rcu_barrier_completion);
 	mutex_unlock(&rcu_barrier_mutex);
+	put_online_cpus();
 }
 
 /**

