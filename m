Return-Path: <linux-kernel-owner+w=401wt.eu-S1764782AbYBMA0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764782AbYBMA0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764269AbYBMA0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:26:14 -0500
Received: from smtp-out.google.com ([216.239.45.13]:39829 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763932AbYBMA0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:26:11 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=Uv8c+yjYsa71AaL7qJZLHenRUu1pFPY28ZY5QSRDQP+IQzG/FRpadxUYsTYNiGVvl
	FmM7TONHTnGf2ceOIAe/w==
Date: Tue, 12 Feb 2008 16:25:51 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/4] mempolicy: support optional mode flags
In-Reply-To: <1202861669.4974.33.camel@localhost>
Message-ID: <alpine.DEB.1.00.0802121622370.3291@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>  <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com> <1202861669.4974.33.camel@localhost>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Lee Schermerhorn wrote:

> What is the benefit of pulling the flags and mode apart at the user
> interface, passing them as separate args to mpol_new(), do_* and
> mpol_shared_policy_init() and then stitching them back together in
> mpol_new()?   Modes passed in via [sys_]{set_mempolicy|mbind}() and
> those stored in the the shmem_sb_info can already have the flags there,
> so this seems like extra work.
> 
> I think this patch and the previous one [1/4] would be simplified if the
> formal parameters were left as an int [mabye, unsigned]  and the flags
> were masked of when necessary in mpol_new() and elsewhere.
> 

Christoph made a similiar suggestion.

> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -203,18 +203,20 @@ static struct zonelist *bind_zonelist(nodemask_t *nodes)
> >  }
> >  
> >  /* Create a new policy */
> > -static struct mempolicy *mpol_new(enum mempolicy_mode mode, nodemask_t *nodes)
> > +static struct mempolicy *mpol_new(enum mempolicy_mode mode,
> > +				  unsigned short flags, nodemask_t *nodes)
> >  {
> >  	struct mempolicy *policy;
> >  
> > -	pr_debug("setting mode %d nodes[0] %lx\n",
> > -		 mode, nodes ? nodes_addr(*nodes)[0] : -1);
> > +	pr_debug("setting mode %d flags %d nodes[0] %lx\n",
> > +		 mode, flags, nodes ? nodes_addr(*nodes)[0] : -1);
> >  
> >  	if (mode == MPOL_DEFAULT)
> >  		return NULL;
> >  	policy = kmem_cache_alloc(policy_cache, GFP_KERNEL);
> >  	if (!policy)
> >  		return ERR_PTR(-ENOMEM);
> > +	flags &= MPOL_MODE_FLAGS;
> >  	atomic_set(&policy->refcnt, 1);
> >  	switch (mode) {
> >  	case MPOL_INTERLEAVE:
> > @@ -240,7 +242,7 @@ static struct mempolicy *mpol_new(enum mempolicy_mode mode, nodemask_t *nodes)
> >  	default:
> >  		BUG();
> >  	}
> > -	policy->policy = mode;
> > +	policy->policy = mode | flags;
> >  	policy->cpuset_mems_allowed = cpuset_mems_allowed(current);
> >  	return policy;
> >  }
> > @@ -483,19 +485,20 @@ static void mpol_set_task_struct_flag(void)
> >  }
> >  
> >  /* Set the process memory policy */
> > -static long do_set_mempolicy(enum mempolicy_mode mode, nodemask_t *nodes)
> > +static long do_set_mempolicy(enum mempolicy_mode mode, unsigned short flags,
> > +			     nodemask_t *nodes)
> >  {
> >  	struct mempolicy *new;
> >  
> >  	if (mpol_check_policy(mode, nodes))
> >  		return -EINVAL;
> > -	new = mpol_new(mode, nodes);
> > +	new = mpol_new(mode, flags, nodes);
> >  	if (IS_ERR(new))
> >  		return PTR_ERR(new);
> >  	mpol_free(current->mempolicy);
> >  	current->mempolicy = new;
> >  	mpol_set_task_struct_flag();
> > -	if (new && new->policy == MPOL_INTERLEAVE)
> > +	if (new && mpol_mode(new->policy) == MPOL_INTERLEAVE)
> >  		current->il_next = first_node(new->v.nodes);
> >  	return 0;
> >  }
> > @@ -506,7 +509,7 @@ static void get_zonemask(struct mempolicy *p, nodemask_t *nodes)
> >  	int i;
> >  
> >  	nodes_clear(*nodes);
> > -	switch (p->policy) {
> > +	switch (mpol_mode(p->policy)) {
> >  	case MPOL_BIND:
> >  		for (i = 0; p->v.zonelist->zones[i]; i++)
> >  			node_set(zone_to_nid(p->v.zonelist->zones[i]),
> > @@ -588,7 +591,7 @@ static long do_get_mempolicy(int *policy, nodemask_t *nmask,
> >  				goto out;
> >  			*policy = err;
> >  		} else if (pol == current->mempolicy &&
> > -				pol->policy == MPOL_INTERLEAVE) {
> > +				mpol_mode(pol->policy) == MPOL_INTERLEAVE) {
> >  			*policy = current->il_next;
> >  		} else {
> >  			err = -EINVAL;
> > @@ -785,8 +788,8 @@ static struct page *new_vma_page(struct page *page, unsigned long private, int *
> >  #endif
> >  
> >  static long do_mbind(unsigned long start, unsigned long len,
> > -		     enum mempolicy_mode mode, nodemask_t *nmask,
> > -		     unsigned long flags)
> > +		     enum mempolicy_mode mode, unsigned short mode_flags,
> > +		     nodemask_t *nmask, unsigned long flags)
> >  {
> >  	struct vm_area_struct *vma;
> >  	struct mm_struct *mm = current->mm;
> > @@ -818,7 +821,7 @@ static long do_mbind(unsigned long start, unsigned long len,
> >  	if (mpol_check_policy(mode, nmask))
> >  		return -EINVAL;
> >  
> > -	new = mpol_new(mode, nmask);
> > +	new = mpol_new(mode, mode_flags, nmask);
> >  	if (IS_ERR(new))
> >  		return PTR_ERR(new);
> >  
> > @@ -829,8 +832,9 @@ static long do_mbind(unsigned long start, unsigned long len,
> >  	if (!new)
> >  		flags |= MPOL_MF_DISCONTIG_OK;
> >  
> > -	pr_debug("mbind %lx-%lx mode:%d nodes:%lx\n",start,start+len,
> > -		 mode, nmask ? nodes_addr(*nmask)[0] : -1);
> > +	pr_debug("mbind %lx-%lx mode:%d flags:%d nodes:%lx\n",
> > +		 start, start + len, mode, mode_flags,
> > +		 nmask ? nodes_addr(*nmask)[0] : -1);
> >  
> >  	down_write(&mm->mmap_sem);
> >  	vma = check_range(mm, start, end, nmask,
> > @@ -929,13 +933,16 @@ asmlinkage long sys_mbind(unsigned long start, unsigned long len,
> >  {
> >  	nodemask_t nodes;
> >  	int err;
> > +	unsigned short mode_flags;
> >  
> > +	mode_flags = mpol_flags(mode);
> > 
> > 
> I suggest restricting the flags to the defined flags here.  This gives
> us the ability to defined new flags w/o breaking [changing behavior of]
> applications that accidently pass undefined flags.  An error return
> forced the user to fix the application [assuming they check error
> returns].
> 

That looks appropriate.  It will also help in the future if certain flags 
are only defined for set_mempolicy() or only defined for mbind() to either 
mask them out in their respective functions or return -EINVAL.

Thanks for the comments.

		David
