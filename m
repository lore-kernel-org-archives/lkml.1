Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbYJXFIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbYJXFIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 01:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbYJXFIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 01:08:07 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:39355 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbYJXFIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 01:08:05 -0400
Date: Fri, 24 Oct 2008 10:38:30 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Add hierarchical accounting to cpu accounting
	controller
Message-ID: <20081024050830.GA4387@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20081023054335.GC3280@in.ibm.com> <6599ad830810230849x71961a0asd7f00d3baa2f2271@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830810230849x71961a0asd7f00d3baa2f2271@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 08:49:19AM -0700, Paul Menage wrote:
> On Wed, Oct 22, 2008 at 10:43 PM, Bharata B Rao
> <bharata@linux.vnet.ibm.com> wrote:
> > ---
> >  kernel/sched.c |   30 ++++++++++++++++++++++++------
> >  1 file changed, 24 insertions(+), 6 deletions(-)
> >
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -9131,10 +9131,15 @@ struct cpuacct {
> >        struct cgroup_subsys_state css;
> >        /* cpuusage holds pointer to a u64-type object on every cpu */
> >        u64 *cpuusage;
> > +       struct cpuacct *parent;
> >  };
> >
> > +static struct cpuacct init_cpuacct_group;
> 
> Why are you making the root state static?

Because it is not used anywhere outside sched.c. Is that a problem ?
> 
> >  struct cgroup_subsys cpuacct_subsys;
> >
> > +#define for_each_cpuacct_group(ca) \
> > +               for (; ca; ca = ca->parent)
> > +
> 
> This is only used once, so doesn't seem worth creating a new macro for.

Ok. Removed.

> 
> >
> > +       if (cgrp->parent) {
> > +               ca->css.cgroup = cgrp;
> 
> The cgroup pointer in the css is maintained by cgroups - you don't
> need to set it.

Yes, I realized this immediately after my 1st post and posted
a corrected version subsequently.

Paul, thanks for your review.

Updated patch below:

Add hierarchical accounting to cpu accounting controller

Currently, while charging the task's cputime to its accounting group,
the accounting group hierarchy isn't updated. This patch charges the cputime
of a task to its accounting group and all its parent accounting groups.

Reported-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9131,8 +9131,10 @@ struct cpuacct {
 	struct cgroup_subsys_state css;
 	/* cpuusage holds pointer to a u64-type object on every cpu */
 	u64 *cpuusage;
+	struct cpuacct *parent;
 };
 
+static struct cpuacct init_cpuacct_group;
 struct cgroup_subsys cpuacct_subsys;
 
 /* return cpu accounting group corresponding to this container */
@@ -9153,17 +9155,27 @@ static inline struct cpuacct *task_ca(st
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
 
@@ -9243,14 +9255,16 @@ static int cpuacct_populate(struct cgrou
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
