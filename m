Return-Path: <linux-kernel-owner+w=401wt.eu-S1759845AbZC2CF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759845AbZC2CF7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 22:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755964AbZC2CEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 22:04:12 -0400
Received: from ozlabs.org ([203.10.76.45]:46567 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966AbZC2CEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 22:04:06 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 29 Mar 2009 00:25:52 +1030
Subject: [PATCH 8/10] cpumask: convert rcutorture.c
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Josh Triplett <josh@freedesktop.org>
Message-Id: <20090329020404.9D073DDECF@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We're getting rid of cpumasks on the stack.

Simply change tmp_mask to a global, and allocate it in
rcu_torture_init().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Josh Triplett <josh@freedesktop.org>
---
 kernel/rcutorture.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -126,6 +126,7 @@ static atomic_t n_rcu_torture_error;
 static atomic_t n_rcu_torture_error;
 static long n_rcu_torture_timers = 0;
 static struct list_head rcu_torture_removed;
+static cpumask_var_t shuffle_tmp_mask;
 
 static int stutter_pause_test = 0;
 
@@ -889,10 +890,9 @@ static int rcu_idle_cpu;	/* Force all to
  */
 static void rcu_torture_shuffle_tasks(void)
 {
-	cpumask_t tmp_mask;
 	int i;
 
-	cpus_setall(tmp_mask);
+	cpumask_setall(shuffle_tmp_mask);
 	get_online_cpus();
 
 	/* No point in shuffling if there is only one online CPU (ex: UP) */
@@ -902,29 +902,29 @@ static void rcu_torture_shuffle_tasks(vo
 	}
 
 	if (rcu_idle_cpu != -1)
-		cpu_clear(rcu_idle_cpu, tmp_mask);
+		cpumask_clear_cpu(rcu_idle_cpu, shuffle_tmp_mask);
 
-	set_cpus_allowed_ptr(current, &tmp_mask);
+	set_cpus_allowed_ptr(current, shuffle_tmp_mask);
 
 	if (reader_tasks) {
 		for (i = 0; i < nrealreaders; i++)
 			if (reader_tasks[i])
 				set_cpus_allowed_ptr(reader_tasks[i],
-						     &tmp_mask);
+						     shuffle_tmp_mask);
 	}
 
 	if (fakewriter_tasks) {
 		for (i = 0; i < nfakewriters; i++)
 			if (fakewriter_tasks[i])
 				set_cpus_allowed_ptr(fakewriter_tasks[i],
-						     &tmp_mask);
+						     shuffle_tmp_mask);
 	}
 
 	if (writer_task)
-		set_cpus_allowed_ptr(writer_task, &tmp_mask);
+		set_cpus_allowed_ptr(writer_task, shuffle_tmp_mask);
 
 	if (stats_task)
-		set_cpus_allowed_ptr(stats_task, &tmp_mask);
+		set_cpus_allowed_ptr(stats_task, shuffle_tmp_mask);
 
 	if (rcu_idle_cpu == -1)
 		rcu_idle_cpu = num_online_cpus() - 1;
@@ -1012,6 +1012,7 @@ rcu_torture_cleanup(void)
 	if (shuffler_task) {
 		VERBOSE_PRINTK_STRING("Stopping rcu_torture_shuffle task");
 		kthread_stop(shuffler_task);
+		free_cpumask_var(shuffle_tmp_mask);
 	}
 	shuffler_task = NULL;
 
@@ -1190,10 +1191,18 @@ rcu_torture_init(void)
 	}
 	if (test_no_idle_hz) {
 		rcu_idle_cpu = num_online_cpus() - 1;
+
+		if (!alloc_cpumask_var(&shuffle_tmp_mask, GFP_KERNEL)) {
+			firsterr = -ENOMEM;
+			VERBOSE_PRINTK_ERRSTRING("Failed to alloc mask");
+			goto unwind;
+		}
+
 		/* Create the shuffler thread */
 		shuffler_task = kthread_run(rcu_torture_shuffle, NULL,
 					  "rcu_torture_shuffle");
 		if (IS_ERR(shuffler_task)) {
+			free_cpumask_var(shuffle_tmp_mask);
 			firsterr = PTR_ERR(shuffler_task);
 			VERBOSE_PRINTK_ERRSTRING("Failed to create shuffler");
 			shuffler_task = NULL;

