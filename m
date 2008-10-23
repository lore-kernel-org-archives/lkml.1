Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbYJWA7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbYJWA7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 20:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbYJWA54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 20:57:56 -0400
Received: from ozlabs.org ([203.10.76.45]:40318 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660AbYJWA5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 20:57:52 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu Oct 23 11:55:16 EST 2008
CC: travis@sgi.com
Subject: [PATCH 1/7] work_on_cpu: helper for doing task on a CPU.
Cc: Ingo Molnar <mingo@elte.hu>
Message-Id: <20081023005751.53973DDEFE@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Several places in the kernel do the following:

	saved_mask = current->cpus_allowed;
	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pr->id));
	somefunc();
	/* restore the previous state */
	set_cpus_allowed_ptr(current, &saved_mask);

This is bad, because a process's cpumask is observable and
manipulatable by userspace and should not be toyed with.

We have the infrastructure, this just creates a nice wrapper to
encourage its use.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/workqueue.h |    8 +++++++
 kernel/workqueue.c        |   48 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff -r b72e0cbdd249 include/linux/workqueue.h
--- a/include/linux/workqueue.h	Thu Oct 23 00:39:36 2008 +1100
+++ b/include/linux/workqueue.h	Thu Oct 23 10:53:51 2008 +1100
@@ -240,4 +240,12 @@ void cancel_rearming_delayed_work(struct
 	cancel_delayed_work_sync(work);
 }
 
+#ifndef CONFIG_SMP
+static inline long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
+{
+	return fn(arg);
+}
+#else
+long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg);
+#endif /* CONFIG_SMP */
 #endif
diff -r b72e0cbdd249 kernel/workqueue.c
--- a/kernel/workqueue.c	Thu Oct 23 00:39:36 2008 +1100
+++ b/kernel/workqueue.c	Thu Oct 23 10:53:51 2008 +1100
@@ -970,6 +970,54 @@ undo:
 	return ret;
 }
 
+#ifdef CONFIG_SMP
+struct work_for_cpu {
+	struct work_struct work;
+	long (*fn)(void *);
+	void *arg;
+	long ret;
+	struct completion done;
+};
+
+static void do_work_for_cpu(struct work_struct *w)
+{
+	struct work_for_cpu *wfc = container_of(w, struct work_for_cpu, work);
+
+	wfc->ret = wfc->fn(wfc->arg);
+	complete(&wfc->done);
+}
+
+/**
+ * work_on_cpu - run a function in user context on a particular cpu
+ * @cpu: the cpu to run on
+ * @fn: the function to run
+ * @arg: the function arg
+ *
+ * This will return -EINVAL in the cpu is not online, or the return value
+ * of @fn otherwise.
+ */
+long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
+{
+	struct work_for_cpu wfc;
+
+	INIT_WORK(&wfc.work, do_work_for_cpu);
+	init_completion(&wfc.done);
+	wfc.fn = fn;
+	wfc.arg = arg;
+	get_online_cpus();
+	if (unlikely(!cpu_online(cpu))) {
+		wfc.ret = -EINVAL;
+		complete(&wfc.done);
+	} else
+		schedule_work_on(cpu, &wfc.work);
+	put_online_cpus();
+	wait_for_completion(&wfc.done);
+
+	return wfc.ret;
+}
+EXPORT_SYMBOL_GPL(work_on_cpu);
+#endif /* CONFIG_SMP */
+
 void __init init_workqueues(void)
 {
 	cpu_populated_map = cpu_online_map;

