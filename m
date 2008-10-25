Return-Path: <linux-kernel-owner+w=401wt.eu-S1753501AbYJYGB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbYJYGB4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 02:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbYJYGBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 02:01:48 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:36408 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbYJYGBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 02:01:47 -0400
Date: Sat, 25 Oct 2008 11:31:58 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Add hierarchical accounting to cpu accounting
	controller
Message-ID: <20081025060157.GA4614@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20081023054335.GC3280@in.ibm.com> <6599ad830810230849x71961a0asd7f00d3baa2f2271@mail.gmail.com> <20081024050830.GA4387@in.ibm.com> <6599ad830810241037h575ec17bgb43f750d99bd1518@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830810241037h575ec17bgb43f750d99bd1518@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 10:37:34AM -0700, Paul Menage wrote:
> On Thu, Oct 23, 2008 at 10:08 PM, Bharata B Rao
> <bharata@linux.vnet.ibm.com> wrote:
> >> > +static struct cpuacct init_cpuacct_group;
> >>
> >> Why are you making the root state static?
> >
> > Because it is not used anywhere outside sched.c. Is that a problem ?
> 
> Sorry, I wasn't clear - I mean, why are you changing it from
> dynamically-allocated in cpuacct_create to statically-allocated in the
> BSS?

Ok. I realized that defining init_cpuacct_group explicitly and statically
isn't needed. I was just influenced by init_task_group and init_mem_cgroup.
I guess those controllers have different reasons to have their init groups
statically defined.

Here is the updated (hopefully final) patch:

Add hierarchical accounting to cpu accounting controller

Currently, while charging the task's cputime to its accounting group,
the accounting group hierarchy isn't updated. This patch charges the cputime
of a task to its accounting group and all its parent accounting groups.

Reported-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>
CC: Paul Menage <menage@google.com>
CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
---
 kernel/sched.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9131,6 +9131,7 @@ struct cpuacct {
 	struct cgroup_subsys_state css;
 	/* cpuusage holds pointer to a u64-type object on every cpu */
 	u64 *cpuusage;
+	struct cpuacct *parent;
 };
 
 struct cgroup_subsys cpuacct_subsys;
@@ -9164,6 +9165,9 @@ static struct cgroup_subsys_state *cpuac
 		return ERR_PTR(-ENOMEM);
 	}
 
+	if (cgrp->parent)
+		ca->parent = cgroup_ca(cgrp->parent);
+
 	return &ca->css;
 }
 
@@ -9243,14 +9247,16 @@ static int cpuacct_populate(struct cgrou
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
