Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbZCDGe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbZCDGe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 01:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbZCDGeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 01:34:08 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42288 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbZCDGeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 01:34:06 -0500
Date: Wed, 4 Mar 2009 15:32:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulmck@linux.vnet.ibm.com,
       Bharata B Rao <bharata.rao@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, kenchen@google.com
Subject: [PATCH] remove rq->lock from cpuacct cgroup v2
Message-Id: <20090304153245.109eada4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1236081288.5330.4105.camel@laptop>
References: <49A65455.4030204@cn.fujitsu.com>
	<344eb09a0902260210y44c0684by9b22f041116d3f7c@mail.gmail.com>
	<18f6db017e5d44596e828e0753f28e75.squirrel@webmail-b.css.fujitsu.com>
	<1235645076.4645.4781.camel@laptop>
	<934198669efa83e838a52284e2c4f8b5.squirrel@webmail-b.css.fujitsu.com>
	<1235647682.4948.15.camel@laptop>
	<145d0010d65060bb089d5a87e06cbd0d.squirrel@webmail-b.css.fujitsu.com>
	<20090226164509.GB6634@linux.vnet.ibm.com>
	<20090227095856.ef8c1c05.kamezawa.hiroyu@jp.fujitsu.com>
	<20090227012915.GF6634@linux.vnet.ibm.com>
	<20090227122239.875a3f56.kamezawa.hiroyu@jp.fujitsu.com>
	<1236005770.5330.583.camel@laptop>
	<20090303084218.28010267.kamezawa.hiroyu@jp.fujitsu.com>
	<1236066689.18955.27.camel@twins>
	<d4132000000381ebc2ba5c2ffe9bb1bd.squirrel@webmail-b.css.fujitsu.com>
	<1236073236.18955.46.camel@twins>
	<2d4a44772433903887651c0bfe74c9cc.squirrel@webmail-b.css.fujitsu.com>
	<1236081288.5330.4105.camel@laptop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

cgroup/cpuacct subsystem counts cpu usage by 64bit coutnter in
per-cpu object. In read-side (via cpuacct.usage file), for reading 64bit
value in safe manner, it takes rq->lock of (other) cpus.

In general, taking rq->lock of other cpus from codes not for scheduler
is not good. This patch tries to remove rq->lock in read-side.

To read 64bit value in atomic, this patch uses seqcounter.

Pros.
  - rq->lock is not necessary.
Cons.
  - When updating counter, sequence number must be updated.
    (I hope this per-cpu sequence number is on cache...)

Changelog: v1->v2
 - checking calling context of all calls and avoid unnecessary
   preempt_disable calls.
 - use on_each_cpu() instead of workqueue, at reset

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
Index: mmotm-2.6.29-Mar3/kernel/sched.c
===================================================================
--- mmotm-2.6.29-Mar3.orig/kernel/sched.c
+++ mmotm-2.6.29-Mar3/kernel/sched.c
@@ -9581,6 +9581,71 @@ struct cgroup_subsys cpu_cgroup_subsys =
 
 #ifdef CONFIG_CGROUP_CPUACCT
 
+#ifndef CONFIG_64BIT
+/* seq counter for handle 64bit counter on 32bit system */
+DEFINE_PER_CPU(struct seqcount, cpuacct_cgroup_seq);
+
+/*
+ * Counter update happens while rq->lock is held and we don't need to
+ * disable preempt explcitly.
+ */
+static inline void cpuacct_start_counter_update(void)
+{
+	/* This is called under rq->lock and IRQ is off */
+	struct seqcount *s = &__get_cpu_var(cpuacct_cgroup_seq);
+
+	write_seqcount_begin(s);
+}
+
+static inline void cpuacct_end_counter_update(void)
+{
+	struct seqcount *s = &__get_cpu_var(cpuacct_cgroup_seq);
+
+	write_seqcount_end(s);
+}
+
+static inline u64
+cpuacct_read_counter(u64 *val, int cpu)
+{
+	struct seqcount *s = &per_cpu(cpuacct_cgroup_seq, cpu);
+	unsigned int seq;
+	u64 data;
+
+	do {
+		seq = read_seqcount_begin(s);
+		data = *val;
+	} while (read_seqcount_retry(s, seq));
+	return data;
+}
+/* This is a special funtion called against "offline" cpus. */
+static inline void cpuacct_reset_offline_counter(u64 *val, int cpu)
+{
+	struct seqcount *s = &per_cpu(cpuacct_cgroup_seq, cpu);
+
+	write_seqcount_begin(s);
+	*val = 0;
+	write_seqcount_end(s);
+}
+#else
+static inline void cpuacct_start_counter_update(void)
+{
+}
+
+static inline void cpuacct_end_counter_update(void)
+{
+}
+
+static inline u64 cpuacct_read_counter(u64 *val, int cpu)
+{
+	return *val;
+}
+
+static inline void cpuacct_reset_offline_counter(u64 *val, int cpu)
+{
+	*val = 0;
+}
+#endif
+
 /*
  * CPU accounting code for task groups.
  *
@@ -9643,39 +9708,27 @@ cpuacct_destroy(struct cgroup_subsys *ss
 	kfree(ca);
 }
 
+/* In 32bit enviroment, seqcounter is used for reading 64bit in safe way */
 static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu)
 {
 	u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
 	u64 data;
 
-#ifndef CONFIG_64BIT
-	/*
-	 * Take rq->lock to make 64-bit read safe on 32-bit platforms.
-	 */
-	spin_lock_irq(&cpu_rq(cpu)->lock);
-	data = *cpuusage;
-	spin_unlock_irq(&cpu_rq(cpu)->lock);
-#else
-	data = *cpuusage;
-#endif
+	data = cpuacct_read_counter(cpuusage, cpu);
 
 	return data;
 }
 
-static void cpuacct_cpuusage_write(struct cpuacct *ca, int cpu, u64 val)
+/* called by per-cpu smp call function (in non-preemptable context) */
+static void cpuacct_cpuusage_reset_cpu(void *data)
 {
+	int cpu = smp_processor_id();
+	struct cpuacct *ca = data;
 	u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
 
-#ifndef CONFIG_64BIT
-	/*
-	 * Take rq->lock to make 64-bit write safe on 32-bit platforms.
-	 */
-	spin_lock_irq(&cpu_rq(cpu)->lock);
-	*cpuusage = val;
-	spin_unlock_irq(&cpu_rq(cpu)->lock);
-#else
-	*cpuusage = val;
-#endif
+	cpuacct_start_counter_update();
+	*cpuusage = 0;
+	cpuacct_end_counter_update();
 }
 
 /* return total cpu usage (in nanoseconds) of a group */
@@ -9691,23 +9744,30 @@ static u64 cpuusage_read(struct cgroup *
 	return totalcpuusage;
 }
 
-static int cpuusage_write(struct cgroup *cgrp, struct cftype *cftype,
-								u64 reset)
+static int cpuacct_cpuusage_reset(struct cgroup *cgrp, unsigned int event)
 {
 	struct cpuacct *ca = cgroup_ca(cgrp);
-	int err = 0;
-	int i;
+	int cpu;
+	/*
+	 * We prevent cpu hotplug while we do reset.
+	 */
+	get_online_cpus();
+	/*
+	 * clear all online cpu's status (including local one)
+	 * This reseting uses nowait smp call and counter will be cleared in
+	 * asynchronous way.
+	 */
+	on_each_cpu(cpuacct_cpuusage_reset_cpu, ca, 0);
 
-	if (reset) {
-		err = -EINVAL;
-		goto out;
+	/* clear all present but offline cpus' */
+	for_each_possible_cpu(cpu) {
+		if (!cpu_online(cpu)) {
+			u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
+			cpuacct_reset_offline_counter(cpuusage, cpu);
+		}
 	}
-
-	for_each_present_cpu(i)
-		cpuacct_cpuusage_write(ca, i, 0);
-
-out:
-	return err;
+	put_online_cpus();
+	return 0;
 }
 
 static int cpuacct_percpu_seq_read(struct cgroup *cgroup, struct cftype *cft,
@@ -9729,7 +9789,7 @@ static struct cftype files[] = {
 	{
 		.name = "usage",
 		.read_u64 = cpuusage_read,
-		.write_u64 = cpuusage_write,
+		.trigger = cpuacct_cpuusage_reset,
 	},
 	{
 		.name = "usage_percpu",
@@ -9759,10 +9819,12 @@ static void cpuacct_charge(struct task_s
 	cpu = task_cpu(tsk);
 	ca = task_ca(tsk);
 
+	cpuacct_start_counter_update();
 	for (; ca; ca = ca->parent) {
 		u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
 		*cpuusage += cputime;
 	}
+	cpuacct_end_counter_update();
 }
 
 struct cgroup_subsys cpuacct_subsys = {

