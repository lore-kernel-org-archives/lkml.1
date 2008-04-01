Return-Path: <linux-kernel-owner+w=401wt.eu-S1759018AbYDAMFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018AbYDAMFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 08:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755970AbYDAMFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 08:05:43 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:53981 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798AbYDAMFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 08:05:43 -0400
Subject: Re: [RFC/PATCH 01/17] sched: mix tasks and groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: vatsa@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
In-Reply-To: <20080401121238.GA3341@linux.vnet.ibm.com>
References: <20080309170850.256853000@chello.nl>
	 <20080309170925.857156000@chello.nl>
	 <20080401121238.GA3341@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 01 Apr 2008 14:05:14 +0200
Message-Id: <1207051514.8514.725.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-01 at 17:42 +0530, Srivatsa Vaddagiri wrote:
> On Sun, Mar 09, 2008 at 06:08:51PM +0100, Peter Zijlstra wrote:
> > This patch allows tasks and groups to exist in the same cfs_rq. With this
> > change the CFS group scheduling follows a 1/(M+N) model from a 1/(1+N)
> > fairness model where M tasks and N groups exist at the cfs_rq level.
> > 
> > [a.p.zijlstra@chello.nl: rt bits]
> > Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> >  kernel/sched.c      |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++--
> >  kernel/sched_fair.c |   48 +++++++++++++++++++++++++++++++++++++++++++---
> >  kernel/sched_rt.c   |   15 ++++++++------
> >  3 files changed, 106 insertions(+), 11 deletions(-)
> > 
> > Index: linux-2.6-2/kernel/sched.c
> > ===================================================================
> > --- linux-2.6-2.orig/kernel/sched.c
> > +++ linux-2.6-2/kernel/sched.c
> > @@ -273,18 +273,23 @@ struct task_group {
> >  };
> > 
> >  #ifdef CONFIG_FAIR_GROUP_SCHED
> > +
> > +#ifdef CONFIG_USER_SCHED
> >  /* Default task group's sched entity on each cpu */
> >  static DEFINE_PER_CPU(struct sched_entity, init_sched_entity);
> >  /* Default task group's cfs_rq on each cpu */
> >  static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
> > +#endif
> 
> 
> I am trying to understand the change this brings for semantics of RT-scheduling.
> 
> With this change, /cgroup will be seen as the parent group of all other
> groups (say: /cgroup/A, /cgroup/B etc). Is that correct?
> 
> If so, the check in __rt_schedulable() needs a change as well, which assumes 
> that all task groups form a flat hierarchy.

Yes, I have that on my todo list somewhere. I realized the same thing
earlier today :-)

> For example: lets say that init_task_group (/cgroup in this case) had the
> default rt_bandwidth of 95% (global_rt_runtime()). A child group under it 
> (/cgroup/A) is created. If user tries to assign it a rt-bandwidth of
> 50%, then AFAICS, it will fail with current code, whereas it shouldn't
> (because by giving /cgroup/A 50% bandwidth, we are not really exceeding
> the globally allowed RT bandwidth of 95%, since /cgroup/A is a child of
> /cgroup).


agreed.

