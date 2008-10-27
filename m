Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbYJ0I2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbYJ0I2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 04:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbYJ0I14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 04:27:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55470 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbYJ0I1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 04:27:55 -0400
Message-ID: <49057ADD.1050705@cn.fujitsu.com>
Date: Mon, 27 Oct 2008 16:25:01 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: bharata@linux.vnet.ibm.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Add hierarchical accounting to cpu accounting controller
References: <20081023054335.GC3280@in.ibm.com>	 <6599ad830810230849x71961a0asd7f00d3baa2f2271@mail.gmail.com>	 <20081024050830.GA4387@in.ibm.com>	 <6599ad830810241037h575ec17bgb43f750d99bd1518@mail.gmail.com>	 <20081025060157.GA4614@in.ibm.com>	 <6599ad830810250838q3f96644bm6dfee8ba9f35dfa3@mail.gmail.com>	 <20081027101703.e954071d.kamezawa.hiroyu@jp.fujitsu.com>	 <20081027044319.GA4386@in.ibm.com> <661de9470810262357y6c560facl87dcaea3ce35e3ac@mail.gmail.com>
In-Reply-To: <661de9470810262357y6c560facl87dcaea3ce35e3ac@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> So in technical terms this patch looks fine now. There's still the
>>>> question of whether it's OK to change the existing API, since it's
>>>> been in the kernel in its currently (non-hierarchical) form for
>>>> several releases now.
>> Hmm... Can we consider this as an API change ? Currently cpuacct.usage
>> readers of a parent accounting group are missing the usage contributions
>> from its children groups. I would consider this patch as fixing the
>> above problem by correctly reflecting the cpu usage for every accounting
>> group.
>>
> 
> If a particular application desires to derive the usage of its
> immediate tasks and does not care about subcgroups, it is a simple
> iteration (after this fix)
> 
> cpuacct - sigma(cpuacct_child)
> 
> and currently if we cared about child accounting, we could do
> 
> cpuacct + recursively(sigma(cpuacct_child))
> 
> In that sense this fix makes more sense, but like Paul said we need to
> figure out if it is an API change. My take is that it is a BUG fix,
> since we do care about child subgroups in accounting.
> 

cpuacct was designed to count cpu usage of a group of tasks, and now some people
want it to also take child group's usage into account, so I think this is a feature
request but not a bug fix.

How about add a flag to disable/enable hierarchical accounting?

=====

From: Li Zefan <lizf@cn.fujitsu.com>
Date: Mon, 27 Oct 2008 16:00:21 +0800
Subject: [PATCH] cpuacct: add hierarchical accouning

Add hierarchical accouning to cpu accouting subsystem, so the cputime
of a task is chareged to its accounting group and all it's parent
accouning groups.

Also add 'cpuacct.hierarchy' control file, so we can enable/disable
hierarchical accounting. The default is disabled, so we reserve the
original behavior of cpuacct.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/sched.c |   75 ++++++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 59 insertions(+), 16 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 6625c3c..1c997bd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9232,15 +9232,22 @@ struct cgroup_subsys cpu_cgroup_subsys = {
  * (balbir@in.ibm.com).
  */
 
-/* track cpu usage of a group of tasks */
+/*
+ * Track cpu usage of a group of tasks.
+ *
+ * If cpuacct_hierarchy is set, it's children's usage is also accounted.
+ */
 struct cpuacct {
 	struct cgroup_subsys_state css;
 	/* cpuusage holds pointer to a u64-type object on every cpu */
 	u64 *cpuusage;
+	struct cpuacct *parent;
 };
 
 struct cgroup_subsys cpuacct_subsys;
 
+static int cpuacct_hierarchy;
+
 /* return cpu accounting group corresponding to this container */
 static inline struct cpuacct *cgroup_ca(struct cgroup *cgrp)
 {
@@ -9256,8 +9263,8 @@ static inline struct cpuacct *task_ca(struct task_struct *tsk)
 }
 
 /* create a new cpu accounting group */
-static struct cgroup_subsys_state *cpuacct_create(
-	struct cgroup_subsys *ss, struct cgroup *cgrp)
+static struct cgroup_subsys_state *cpuacct_create(struct cgroup_subsys *ss,
+						  struct cgroup *cgrp)
 {
 	struct cpuacct *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
 
@@ -9270,12 +9277,14 @@ static struct cgroup_subsys_state *cpuacct_create(
 		return ERR_PTR(-ENOMEM);
 	}
 
+	if (cgrp->parent)
+		ca->parent = cgroup_ca(cgrp->parent);
+
 	return &ca->css;
 }
 
 /* destroy an existing cpu accounting group */
-static void
-cpuacct_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
+static void cpuacct_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
 	struct cpuacct *ca = cgroup_ca(cgrp);
 
@@ -9306,7 +9315,7 @@ static u64 cpuusage_read(struct cgroup *cgrp, struct cftype *cft)
 }
 
 static int cpuusage_write(struct cgroup *cgrp, struct cftype *cftype,
-								u64 reset)
+			  u64 reset)
 {
 	struct cpuacct *ca = cgroup_ca(cgrp);
 	int err = 0;
@@ -9328,17 +9337,42 @@ out:
 	return err;
 }
 
-static struct cftype files[] = {
-	{
-		.name = "usage",
-		.read_u64 = cpuusage_read,
-		.write_u64 = cpuusage_write,
-	},
+static u64 cpuacct_hierarchy_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	return cpuacct_hierarchy;
+}
+
+static int cpuacct_hierarchy_write(struct cgroup *cgrp, struct cftype *cftype,
+				   u64 val)
+{
+	cpuacct_hierarchy = !!val;
+	return 0;
+}
+
+static struct cftype cft_cpuusage = {
+	.name = "usage",
+	.read_u64 = cpuusage_read,
+	.write_u64 = cpuusage_write,
+};
+
+static struct cftype cft_hierarchy = {
+	.name = "hierarchy",
+	.read_u64 = cpuacct_hierarchy_read,
+	.write_u64 = cpuacct_hierarchy_write,
 };
 
 static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
-	return cgroup_add_files(cgrp, ss, files, ARRAY_SIZE(files));
+	int ret;
+
+	ret = cgroup_add_file(cgrp, ss, &cft_cpuusage);
+	if (ret)
+		return ret;
+
+	if (!cgrp->parent)
+		ret = cgroup_add_file(cgrp, ss, &cft_hierarchy);
+
+	return ret;
 }
 
 /*
@@ -9349,15 +9383,24 @@ static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
 static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 {
 	struct cpuacct *ca;
+	int cpu;
 
 	if (!cpuacct_subsys.active)
 		return;
 
+	cpu = task_cpu(tsk);
 	ca = task_ca(tsk);
-	if (ca) {
-		u64 *cpuusage = percpu_ptr(ca->cpuusage, task_cpu(tsk));
 
-		*cpuusage += cputime;
+	if (cpuacct_hierarchy) {
+		for (; ca; ca = ca->parent) {
+			u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
+			*cpuusage += cputime;
+		}
+	} else {
+		if (ca) {
+			u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
+			*cpuusage += cputime;
+		}
 	}
 }
 
-- 
1.5.4.rc3


