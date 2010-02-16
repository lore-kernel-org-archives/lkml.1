Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751059Ab0BPFPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 00:15:24 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44211 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab0BPFPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 00:15:23 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch 3/7 -mm] oom: select task from tasklist for mempolicy ooms
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1002151407000.26927@chino.kir.corp.google.com>
References: <20100215120924.7281.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1002151407000.26927@chino.kir.corp.google.com>
Message-Id: <20100216135240.72EC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 16 Feb 2010 14:15:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 15 Feb 2010, KOSAKI Motohiro wrote:
> 
> > > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > > --- a/mm/mempolicy.c
> > > +++ b/mm/mempolicy.c
> > > @@ -1638,6 +1638,45 @@ bool init_nodemask_of_mempolicy(nodemask_t *mask)
> > >  }
> > >  #endif
> > >  
> > > +/*
> > > + * mempolicy_nodemask_intersects
> > > + *
> > > + * If tsk's mempolicy is "default" [NULL], return 'true' to indicate default
> > > + * policy.  Otherwise, check for intersection between mask and the policy
> > > + * nodemask for 'bind' or 'interleave' policy, or mask to contain the single
> > > + * node for 'preferred' or 'local' policy.
> > > + */
> > > +bool mempolicy_nodemask_intersects(struct task_struct *tsk,
> > > +					const nodemask_t *mask)
> > > +{
> > > +	struct mempolicy *mempolicy;
> > > +	bool ret = true;
> > > +
> > > +	mempolicy = tsk->mempolicy;
> > > +	mpol_get(mempolicy);
> > 
> > Why is this refcount increment necessary? mempolicy is grabbed by tsk,
> > IOW it never be freed in this function.
> 
> We need to get a refcount on the mempolicy to ensure it doesn't get freed 
> from under us, tsk is not necessarily current.

Hm.
if you explanation is correct, I think your patch have following race.


 CPU0                            CPU1
----------------------------------------------
mempolicy_nodemask_intersects()
mempolicy = tsk->mempolicy;
                                 do_exit()
                                 mpol_put(tsk_mempolicy)
mpol_get(mempolicy);




> > > +	if (!mask || !mempolicy)
> > > +		goto out;
> > > +
> > > +	switch (mempolicy->mode) {
> > > +	case MPOL_PREFERRED:
> > > +		if (mempolicy->flags & MPOL_F_LOCAL)
> > > +			ret = node_isset(numa_node_id(), *mask);
> > 
> > Um? Is this good heuristic?
> > The task can migrate various cpus, then "node_isset(numa_node_id(), *mask) == 0"
> > doesn't mean the task doesn't consume *mask's memory.
> > 
> 
> For MPOL_F_LOCAL, we need to check whether the task's cpu is on a node 
> that is allowed by the zonelist passed to the page allocator.  In the 
> second revision of this patchset, this was changed to
> 
> 	node_isset(cpu_to_node(task_cpu(tsk)), *mask)
> 
> to check.  It would be possible for no memory to have been allocated on 
> that node and it just happens that the tsk is running on it momentarily, 
> but it's the best indication we have given the mempolicy of whether 
> killing a task may lead to future memory freeing.

This calculation is still broken. In general, running cpu and allocation node
is not bound.
We can't know such task use which node memory because MPOL_PREFERRED doesn't
bind allocation node. it only provide allocation hint.

	case MPOL_PREFERRED:
		ret = true;
		break;

is better. (probably we can make some bonus to oom_badness, but it's irrelevant thing).


> 
> > > @@ -660,24 +683,18 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
> > >  	 */
> > >  	constraint = constrained_alloc(zonelist, gfp_mask, nodemask);
> > >  	read_lock(&tasklist_lock);
> > > -
> > > -	switch (constraint) {
> > > -	case CONSTRAINT_MEMORY_POLICY:
> > > -		oom_kill_process(current, gfp_mask, order, 0, NULL,
> > > -				"No available memory (MPOL_BIND)");
> > > -		break;
> > > -
> > > -	case CONSTRAINT_NONE:
> > > -		if (sysctl_panic_on_oom) {
> > > +	if (unlikely(sysctl_panic_on_oom)) {
> > > +		/*
> > > +		 * panic_on_oom only affects CONSTRAINT_NONE, the kernel
> > > +		 * should not panic for cpuset or mempolicy induced memory
> > > +		 * failures.
> > > +		 */
> > > +		if (constraint == CONSTRAINT_NONE) {
> > >  			dump_header(NULL, gfp_mask, order, NULL);
> > > -			panic("out of memory. panic_on_oom is selected\n");
> > > +			panic("Out of memory: panic_on_oom is enabled\n");
> > 
> > enabled? Its feature is enabled at boot time. triggered? or fired?
> 
> The panic_on_oom sysctl is "enabled" if it is set to non-zero; that's the 
> word used throughout Documentation/sysctl/vm.txt to describe when a sysctl 
> is being used or not.

Probably, you changed message meanings. I think the original one doesn't
intend to describe enable or disable. but it isn't big matter. I can accept it.



