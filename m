Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbYKDMup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbYKDMup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 07:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbYKDMug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 07:50:36 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44130 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbYKDMuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 07:50:35 -0500
Date: Tue, 4 Nov 2008 18:19:37 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Add hierarchical accounting to cpu accounting
	controller
Message-ID: <20081104124937.GB4898@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20081024050830.GA4387@in.ibm.com> <6599ad830810241037h575ec17bgb43f750d99bd1518@mail.gmail.com> <20081025060157.GA4614@in.ibm.com> <6599ad830810250838q3f96644bm6dfee8ba9f35dfa3@mail.gmail.com> <20081027101703.e954071d.kamezawa.hiroyu@jp.fujitsu.com> <20081027044319.GA4386@in.ibm.com> <661de9470810262357y6c560facl87dcaea3ce35e3ac@mail.gmail.com> <49057ADD.1050705@cn.fujitsu.com> <20081030171622.GA19872@linux.vnet.ibm.com> <20081031094041.194a32d9.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031094041.194a32d9.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 09:40:41AM +0900, KAMEZAWA Hiroyuki wrote:
> On Thu, 30 Oct 2008 22:46:22 +0530
> Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> > I disagree. The child is a part of the parent's hierarchy, and therefore
> > its usage should reflect in the parent's usage.
> > 
> 
> In my point of view, there is no big difference. It's just whether we need a tool
> in userland or not. If there is no performance impact, I have no objections.
> 
> One request from me is add Documentation/controllers/cpuacct.txt or some to explain
> "what we see".

I am not sure which version (mine or Li Zefan's) Paul prefers. I am
resending my patch anyway with documentation and performance numbers
included. I don't see any significant improvement or degradation in
hackbench, lmbench and volanomark numbers with this patch.

Regards,
Bharata.

Add hierarchical accounting to cpu accounting controller and cpuacct
documentation.

Currently, while charging the task's cputime to its accounting group,
the accounting group hierarchy isn't updated. This patch charges the cputime
of a task to its accounting group and all its parent accounting groups.

Reported-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>
CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Reviewed-by: Paul Menage <menage@google.com>
---
 Documentation/controllers/cpuacct.txt |   32 ++++++++++++++++++++++++++++++++
 kernel/sched.c                        |   10 ++++++++--
 2 files changed, 40 insertions(+), 2 deletions(-)

--- /dev/null
+++ b/Documentation/controllers/cpuacct.txt
@@ -0,0 +1,32 @@
+CPU Accounting Controller
+-------------------------
+
+The CPU accounting controller is used to group tasks using cgroups and
+account the CPU usage of these group of tasks.
+
+The CPU accounting controller supports multi-hierarchy groups. An accounting
+group accumulates the CPU usage of all of it's child groups and
+the tasks directly present in it's group.
+
+Accounting groups can be created by first mounting the cgroup filesystem.
+
+# mkdir /cgroups
+# mount -t cgroup -ocpuacct none /cgroups
+
+With the above step, the initial or the parent accounting group
+becomes visible at /cgroups. At bootup, this group comprises of all the
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
+process (bash) into it. CPU time consumed by this bash and it's children
+can be obtained from g1/cpuacct.usage and the same gets accumulated in
+/cgroups/cpuacct.usage also.
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9236,6 +9236,7 @@ struct cpuacct {
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

Performance numbers
==================
2x2HT=4CPU i386 running 2.6.28-rc3

All benchmarks were run from bash which belonged to the grand
child group of the topmost accounting group. The tests were
first run on 2628rc3 and then on 2628rc3+this patch and the
normalized difference between the two runs is shown below.

I. hackbench
============
# ./hackbench 100 process 100
Running with 100*40 (== 4000) tasks.
Normalized time difference for avg of 5 runs: 1.0059

# ./hackbench 25 thread 100
Running with 25*40 (== 1000) tasks.
Normalized time difference for avg of 5 runs: 1.0139

II. lmbench
===========
---------------------
4 threads
---------------------
size	Normalized
(kb)	Change (Time)
---------------------
16	1.1017
64	1.1168
128	1.1072
256	1.0085
--------------------
8 threads
-------------------
16	1.1835
64	1.0617
128	0.9980
256	0.9682
-------------------
16 threads
-------------------
16	1.1186
64	0.9921
128	0.9505
256	1.0043
-------------------
32 threads
-------------------
16	1.0005
64	1.0089
128	1.0019
256	1.0226
-------------------
64 threads
-------------------
16	1.0207
64	1.0385
128	1.0109
256	1.0159
-------------------

III. volanomark
===============
Normalized average throughput difference for loopback test

------------------------------------------------------------
Nr runs		Normalized average throughput difference
------------------------------------------------------------
10		0.9579
------------------------------------------------------------
4		1.1465
------------------------------------------------------------
9		0.9451
------------------------------------------------------------
19		1.0133
------------------------------------------------------------
