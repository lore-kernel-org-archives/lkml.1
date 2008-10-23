Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbYJWGlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbYJWGlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 02:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbYJWGki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 02:40:38 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34551 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbYJWGka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 02:40:30 -0400
Date: Thu, 23 Oct 2008 12:11:00 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Add hierarchical accounting to cpu accounting
	controller
Message-ID: <20081023064100.GD3280@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20081023054335.GC3280@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023054335.GC3280@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I realized from the patch present at http://lkml.org/lkml/2008/10/5/277,
that it is not necessary to initialize css.group in cpuacct_create()
as it is done in cgroup core. Present below is the updated patch:

Regards,
Bharata.

Add hierarchical accounting to cpu accounting controller

Currently, while charging the task's cputime to its accounting group,
the accounting group hierarchy isn't updated. This patch charges the cputime
of a task to its accounting group and all its parent accounting groups.

Reported-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9131,10 +9131,15 @@ struct cpuacct {
 	struct cgroup_subsys_state css;
 	/* cpuusage holds pointer to a u64-type object on every cpu */
 	u64 *cpuusage;
+	struct cpuacct *parent;
 };
 
+static struct cpuacct init_cpuacct_group;
 struct cgroup_subsys cpuacct_subsys;
 
+#define for_each_cpuacct_group(ca) \
+		for (; ca; ca = ca->parent)
+
 /* return cpu accounting group corresponding to this container */
 static inline struct cpuacct *cgroup_ca(struct cgroup *cgrp)
 {
@@ -9153,17 +9158,27 @@ static inline struct cpuacct *task_ca(st
 static struct cgroup_subsys_state *cpuacct_create(
 	struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
-	struct cpuacct *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
+	struct cpuacct *ca;
 
-	if (!ca)
-		return ERR_PTR(-ENOMEM);
+	if (!cgrp->parent) {
+		/* This is early initialization for the top cgroup */
+		ca = &init_cpuacct_group;
+	} else {
+		ca = kzalloc(sizeof(*ca), GFP_KERNEL);
+		if (!ca)
+			return ERR_PTR(-ENOMEM);
+	}
 
 	ca->cpuusage = alloc_percpu(u64);
 	if (!ca->cpuusage) {
-		kfree(ca);
+		if (cgrp->parent)
+			kfree(ca);
 		return ERR_PTR(-ENOMEM);
 	}
 
+	if (cgrp->parent)
+		ca->parent = cgroup_ca(cgrp->parent);
+
 	return &ca->css;
 }
 
@@ -9243,14 +9258,16 @@ static int cpuacct_populate(struct cgrou
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
 
+	for_each_cpuacct_group(ca) {
+		u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
 		*cpuusage += cputime;
 	}
 }
