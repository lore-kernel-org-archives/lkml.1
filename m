Return-Path: <linux-kernel-owner+w=401wt.eu-S1752412AbZCJE1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbZCJE1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 00:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbZCJE1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 00:27:06 -0400
Received: from smtp-out.google.com ([216.239.45.13]:32215 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZCJE1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 00:27:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=B6P4pu+iYm3PfljMvtHVO/GVwjKaTlkKaryZ7Etiaynm2HV63SbzRC0ob6UuDixWm
	ibSc0SRUuGNq6PKJ0C39w==
Date: Mon, 9 Mar 2009 21:26:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Matt Mackall <mpm@selenic.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Paul Menage <menage@google.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] cpusets: add memory_slab_hardwall flag
In-Reply-To: <1236657954.4192.523.camel@calx>
Message-ID: <alpine.DEB.2.00.0903092112100.26081@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0903091448110.20314@qirst.com>  <alpine.DEB.2.00.0903091307570.27253@chino.kir.corp.google.com>  <20090310102926.A47E.A69D9226@jp.fujitsu.com>  <alpine.DEB.2.00.0903091853000.25296@chino.kir.corp.google.com>
 <1236657954.4192.523.camel@calx>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Mar 2009, Matt Mackall wrote:

> But we are still extremely sensitive to adding potential branches to one
> of the most important fast-paths in the kernel, especially for a feature
> with a fairly narrow use case. We've invested an awful lot of time into
> micro-optimizing SLAB (by rewriting it as SLUB/SLQB) so any steps
> backward at this stage are cause for concern. Also, remember 99%+ of
> users will never care about this feature.
> 

My latest proposal simply checks for !(current->flags & PF_SLAB_HARDWALL) 
before determining whether the set of allowable nodes needs to be checked.  
For slub, this is in addition to the prexisting logic that checks whether 
the object can be from any node (node == -1) in slab_alloc() or the cpu 
slab is from the node requested for kmalloc_node() users for CONFIG_NUMA 
kernels.

You could argue that, in the slub example, check_node() should do this:

	static inline int check_node(struct kmem_cache_cpu *c, int node,
				     gfp_t flags)
	{
	#ifdef CONFIG_NUMA
		if (node != -1 && c->node != node)
			return 0;
		if (likely(!(current->flags & PF_SLAB_HARDWALL)))
			return 1;
	#endif
		return current_cpuset_object_allowed(node, flags);
	}

Although this would penalize the case where current's cpuset has 
memory_slab_hardwall enabled, yet the cpu slab is still allowed because it 
originated from current->mems_allowed.

If checking for the PF_SLAB_HARDWALL bit in current->flags really is 
unacceptable in my latest proposal, then a viable solution probably 
doesn't exist for such workloads that want hardwall object allocations.
