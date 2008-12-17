Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760539AbYLQHvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760539AbYLQHvm (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 02:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760335AbYLQHvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 02:51:24 -0500
Received: from smtp-out.google.com ([216.239.45.13]:26390 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760283AbYLQHvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 02:51:22 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:content-transfer-encoding;
	b=L5HZZOiUON3Qyq4pQ05WO1qHu/KHtdx0kPzwKoNxaqUul8bPcClhg0fiaGOut+uUd
	ICeKfindAteNXnv4cIB7A==
MIME-Version: 1.0
Date: Tue, 16 Dec 2008 23:51:19 -0800
Message-ID: <b040c32a0812162351u4876096aq7aa538873b4935d3@mail.gmail.com>
Subject: [patch] cpuacct: add per cgroup run-delay accounting
From: Ken Chen <kenchen@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Menage <menage@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds per cpuacct cgroup scheduler run-delay accounting.  we
intent to use this stats to track group of tasks' wait time on CPU run
queue for monitoring purpose.

Due to lack of atomic64_t support on 32-bit arch, this functionality is
limited to 64-bit arch.

Signed-off-by: Ken Chen <kenchen@google.com>


diff --git a/kernel/sched.c b/kernel/sched.c
index e4bb1dd..4d1920d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1390,6 +1390,15 @@ static void cpuacct_charge(
 static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
 #endif

+#if defined(CONFIG_CGROUP_CPUACCT) && defined(CONFIG_SCHEDSTATS) &&	\
+    defined(CONFIG_64BIT)
+static void
+cpuacct_accumulate_run_delay(struct task_struct *task, u64 delta);
+#else
+static inline void
+cpuacct_accumulate_run_delay(struct task_struct *t, u64 delta) {}
+#endif
+
 static inline void inc_cpu_load(struct rq *rq, unsigned long load)
 {
 	update_load_add(&rq->load, load);
@@ -9256,6 +9265,11 @@ struct cpuacct {
 	struct cgroup_subsys_state css;
 	/* cpuusage holds pointer to a u64-type object on every cpu */
 	u64 *cpuusage;
+
+#if defined(CONFIG_SCHEDSTATS) && defined(CONFIG_64BIT)
+	/* accumulative schedule rq wait time for tasks in this cgroup */
+	atomic64_t run_delay;
+#endif
 };

 struct cgroup_subsys cpuacct_subsys;
@@ -9347,12 +9361,33 @@ out:
 	return err;
 }

+#if defined(CONFIG_SCHEDSTATS) && defined(CONFIG_64BIT)
+static u64 cpuacct_run_delay_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	struct cpuacct *ca = cgroup_ca(cgrp);
+	return atomic64_read(&ca->run_delay);
+}
+
+static void cpuacct_accumulate_run_delay(struct task_struct *task, u64 delta)
+{
+	struct cpuacct *ca = task_ca(task);
+	if (ca)
+		atomic64_add(delta, &ca->run_delay);
+}
+#endif
+
 static struct cftype files[] = {
 	{
 		.name = "usage",
 		.read_u64 = cpuusage_read,
 		.write_u64 = cpuusage_write,
 	},
+#if defined(CONFIG_SCHEDSTATS) && defined(CONFIG_64BIT)
+	{
+		.name = "run_delay",
+		.read_u64 = cpuacct_run_delay_read,
+	},
+#endif
 };

 static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 7dbf72a..4272594 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -180,6 +180,7 @@ static inline void sched_info_dequeued(
 	sched_info_reset_dequeued(t);
 	t->sched_info.run_delay += delta;

+	cpuacct_accumulate_run_delay(t, delta);
 	rq_sched_info_dequeued(task_rq(t), delta);
 }

@@ -199,6 +200,7 @@ static void sched_info_arrive(
 	t->sched_info.last_arrival = now;
 	t->sched_info.pcount++;

+	cpuacct_accumulate_run_delay(t, delta);
 	rq_sched_info_arrive(task_rq(t), delta);
 }
