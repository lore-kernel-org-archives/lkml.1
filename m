Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbYJWPKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbYJWPKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 11:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbYJWPKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 11:10:22 -0400
Received: from ozlabs.org ([203.10.76.45]:51718 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbYJWPKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 11:10:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH 1/7] work_on_cpu: helper for doing task on a CPU.
Date: Fri, 24 Oct 2008 02:10:22 +1100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, travis@sgi.com, Ingo Molnar <mingo@elte.hu>,
       Gautham R Shenoy <ego@in.ibm.com>
References: <20081023005751.53973DDEFE@ozlabs.org> <20081023094036.GA7593@redhat.com>
In-Reply-To: <20081023094036.GA7593@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810240210.23085.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 October 2008 20:40:36 Oleg Nesterov wrote:
> Once we drop cpu_hotplug lock, CPU can go away and this work can migrate
> to another cpu.

Thanks Oleg.  It is wrong.  I'll use your suggestion; it's simpler.

Cheers,
Rusty.

work_on_cpu: helper for doing task on a CPU.

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
 include/linux/workqueue.h |    8 ++++++++
 kernel/workqueue.c        |   45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff -r 494880dd124b include/linux/workqueue.h
--- a/include/linux/workqueue.h	Fri Oct 24 00:29:43 2008 +1100
+++ b/include/linux/workqueue.h	Fri Oct 24 01:16:52 2008 +1100
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
diff -r 494880dd124b kernel/workqueue.c
--- a/kernel/workqueue.c	Fri Oct 24 00:29:43 2008 +1100
+++ b/kernel/workqueue.c	Fri Oct 24 01:16:52 2008 +1100
@@ -970,6 +970,51 @@ undo:
 	return ret;
 }
 
+#ifdef CONFIG_SMP
+struct work_for_cpu {
+	struct work_struct work;
+	long (*fn)(void *);
+	void *arg;
+	long ret;
+};
+
+static void do_work_for_cpu(struct work_struct *w)
+{
+	struct work_for_cpu *wfc = container_of(w, struct work_for_cpu, work);
+
+	wfc->ret = wfc->fn(wfc->arg);
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
+	wfc.fn = fn;
+	wfc.arg = arg;
+	get_online_cpus();
+	if (unlikely(!cpu_online(cpu)))
+		wfc.ret = -EINVAL;
+	else {
+		schedule_work_on(cpu, &wfc.work);
+		flush_workqueue(&wfc.work);
+	}
+	put_online_cpus();
+
+	return wfc.ret;
+}
+EXPORT_SYMBOL_GPL(work_on_cpu);
+#endif /* CONFIG_SMP */
+
 void __init init_workqueues(void)
 {
 	cpu_populated_map = cpu_online_map;
