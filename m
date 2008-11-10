Return-Path: <linux-kernel-owner+w=401wt.eu-S1754383AbYKJPLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbYKJPLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 10:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbYKJPLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 10:11:03 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34368 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbYKJPLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 10:11:01 -0500
Date: Mon, 10 Nov 2008 20:41:13 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] Add hierarchical accounting to cpu accounting
	controller
Message-ID: <20081110151113.GA3933@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20081027101703.e954071d.kamezawa.hiroyu@jp.fujitsu.com> <20081027044319.GA4386@in.ibm.com> <661de9470810262357y6c560facl87dcaea3ce35e3ac@mail.gmail.com> <49057ADD.1050705@cn.fujitsu.com> <20081030171622.GA19872@linux.vnet.ibm.com> <20081031094041.194a32d9.kamezawa.hiroyu@jp.fujitsu.com> <20081104124937.GB4898@in.ibm.com> <20081104092040.781f9546.randy.dunlap@oracle.com> <20081105032440.GA3298@in.ibm.com> <20081110130937.GB32613@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081110130937.GB32613@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 02:09:37PM +0100, Ingo Molnar wrote:
> 
> * Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:
> 
> > I will resend the patch with other corrections you mentioned only if 
> > Paul/Ingo want this patch to go in.
> 
> yes, please resend the fixed version.

Here it is:

Add hierarchical accounting to cpu accounting controller and include
cpuacct documentation.

Currently, while charging the task's cputime to its accounting group,
the accounting group hierarchy isn't updated. This patch charges the cputime
of a task to its accounting group and all its parent accounting groups.

Reported-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Reviewed-by: Paul Menage <menage@google.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/controllers/cpuacct.txt |   32 ++++++++++++++++++++++++++++++++
 kernel/sched.c                        |   12 +++++++++---
 2 files changed, 41 insertions(+), 3 deletions(-)

--- /dev/null
+++ b/Documentation/controllers/cpuacct.txt
@@ -0,0 +1,32 @@
+CPU Accounting Controller
+-------------------------
+
+The CPU accounting controller is used to group tasks using cgroups and
+account the CPU usage of these groups of tasks.
+
+The CPU accounting controller supports multi-hierarchy groups. An accounting
+group accumulates the CPU usage of all of its child groups and the tasks
+directly present in its group.
+
+Accounting groups can be created by first mounting the cgroup filesystem.
+
+# mkdir /cgroups
+# mount -t cgroup -ocpuacct none /cgroups
+
+With the above step, the initial or the parent accounting group
+becomes visible at /cgroups. At bootup, this group includes all the
+tasks in the system. /cgroups/tasks lists the tasks in this cgroup.
+/cgroups/cpuacct.usage gives the CPU time (in nanoseconds) obtained by
+this group which is essentially the CPU time obtained by all the tasks
+in the system.
+
+New accounting groups can be created under the parent group /cgroups.
+
+# cd /cgroups
+# mkdir g1
+# echo $$ > g1
+
+The above steps create a new group g1 and move the current shell
+process (bash) into it. CPU time consumed by this bash and its children
+can be obtained from g1/cpuacct.usage and the same is accumulated in
+/cgroups/cpuacct.usage also.
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9231,11 +9231,12 @@ struct cgroup_subsys cpu_cgroup_subsys =
  * (balbir@in.ibm.com).
  */
 
-/* track cpu usage of a group of tasks */
+/* track cpu usage of a group of tasks and its child groups */
 struct cpuacct {
 	struct cgroup_subsys_state css;
 	/* cpuusage holds pointer to a u64-type object on every cpu */
 	u64 *cpuusage;
+	struct cpuacct *parent;
 };
 
 struct cgroup_subsys cpuacct_subsys;
@@ -9269,6 +9270,9 @@ static struct cgroup_subsys_state *cpuac
 		return ERR_PTR(-ENOMEM);
 	}
 
+	if (cgrp->parent)
+		ca->parent = cgroup_ca(cgrp->parent);
+
 	return &ca->css;
 }
 
@@ -9348,14 +9352,16 @@ static int cpuacct_populate(struct cgrou
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
 
+	for (; ca; ca = ca->parent) {
+		u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
 		*cpuusage += cputime;
 	}
 }

Regards,
Bharata.
