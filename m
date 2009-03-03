Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbZCCRT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbZCCRT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 12:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756598AbZCCRTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 12:19:42 -0500
Received: from smtp-out.google.com ([216.239.45.13]:52448 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255AbZCCRTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 12:19:41 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=UDwdTO5HKn90ECSLKX0JrKP5oGYWlLyTk2PItjTG6L8+rhG4cyIR0VYuwg3Og7pfs
	mZ+LkgU4UP3+AMp+A+O5g==
Date: Tue, 3 Mar 2009 09:19:07 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] slub: enforce cpuset restrictions for cpu slabs
In-Reply-To: <alpine.DEB.1.10.0903031136380.26454@qirst.com>
Message-ID: <alpine.DEB.2.00.0903030900580.6643@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903022009490.17284@chino.kir.corp.google.com> <alpine.DEB.2.00.0903022011430.17284@chino.kir.corp.google.com> <alpine.DEB.1.10.0903031136380.26454@qirst.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Mar 2009, Christoph Lameter wrote:

> > Slab allocations should respect cpuset hardwall restrictions.  Otherwise,
> > it is possible for tasks in a cpuset to fill slabs allocated on mems
> > assigned to a disjoint cpuset.
> 
> Not sure that I understand this correctly. If multiple tasks are running
> on the same processor that are part of disjoint cpusets and both taska are
> performing slab allocations without specifying a node then one task could
> allocate a page from the first cpuset, take one object from it and then
> the second task on the same cpu could consume the rest from a nodeset that
> it would otherwise not be allowed to access. On the other hand it is
> likely that the second task will also allocate memory from its allowed
> nodes that are then consumed by the first task. This is a tradeoff coming
> with the pushing of the enforcement of memory policy / cpuset stuff out of
> the slab allocator and relying for this on the page allocator.
> 

Yes, I agree that it's a significant optimization to allow the cpu slab to 
be used by tasks that are not allowed, either because of its mempolicy or 
cpuset restriction, to access the node on which it was allocated.  That's 
especially true for small object sizes or short-lived allocations where 
the hardwall infringment is acceptable for the speed-up.

Unfortunately, it also leads to a violation of the user imposed 
restriction on acceptable memory usage.  One of the important aspects of 
cpusets is to allow memory isolation from other siblings.  It should be 
possible to kill all tasks in a cpuset, for example, and expect its 
partial list to be emptied and not heavily fragmented by long-lived 
allocations that could prevent any partial slab freeing, which is possible 
when heavy slab users are allowed to allocate objects anywhere.

> > If an allocation is intended for a particular node that the task does not
> > have access to because of its cpuset, an allowed partial slab is used
> > instead of failing.
> 
> This would get us back to the slab allocator enforcing memory policies.
> 

Is that a problem?  get_any_partial() already enforces cpuset-aware memory 
policies when defragmenting remote partial slabs.

> > -static inline int node_match(struct kmem_cache_cpu *c, int node)
> > +static inline int node_match(struct kmem_cache_cpu *c, int node, gfp_t gfpflags)
> >  {
> >  #ifdef CONFIG_NUMA
> >  	if (node != -1 && c->node != node)
> >  		return 0;
> >  #endif
> > -	return 1;
> > +	return cpuset_node_allowed_hardwall(c->node, gfpflags);
> >  }
> 
> This is a hotpath function and doing an expensive function call here would
> significantly impact performance.
> 

It's not expensive.  It's a no-op for !CONFIG_CPUSETS configs and only a 
global variable read for machines running with a single cpuset.  When the 
machine has multiple cpusets, it indicates that memory restrictions are in 
place so checking current->mems_allowed is required and its performance 
impact should be assumed.

> It also will cause a reloading of the per cpu slab after each task switch
> in the scenario discussed above.
> 

There is no alternative solution to prevent egregious amounts of slab to 
be allocated in a disjoint cpuset that is supposedly mem_exclusive.
