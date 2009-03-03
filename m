Return-Path: <linux-kernel-owner+w=401wt.eu-S1758951AbZCCQ5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951AbZCCQ5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 11:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbZCCQ5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 11:57:14 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:42558 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751084AbZCCQ5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 11:57:13 -0500
Date: Tue, 3 Mar 2009 11:47:32 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] slub: enforce cpuset restrictions for cpu slabs
In-Reply-To: <alpine.DEB.2.00.0903022011430.17284@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0903031136380.26454@qirst.com>
References: <alpine.DEB.2.00.0903022009490.17284@chino.kir.corp.google.com> <alpine.DEB.2.00.0903022011430.17284@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009, David Rientjes wrote:

> Slab allocations should respect cpuset hardwall restrictions.  Otherwise,
> it is possible for tasks in a cpuset to fill slabs allocated on mems
> assigned to a disjoint cpuset.

Not sure that I understand this correctly. If multiple tasks are running
on the same processor that are part of disjoint cpusets and both taska are
performing slab allocations without specifying a node then one task could
allocate a page from the first cpuset, take one object from it and then
the second task on the same cpu could consume the rest from a nodeset that
it would otherwise not be allowed to access. On the other hand it is
likely that the second task will also allocate memory from its allowed
nodes that are then consumed by the first task. This is a tradeoff coming
with the pushing of the enforcement of memory policy / cpuset stuff out of
the slab allocator and relying for this on the page allocator.

> If an allocation is intended for a particular node that the task does not
> have access to because of its cpuset, an allowed partial slab is used
> instead of failing.

This would get us back to the slab allocator enforcing memory policies.

> -static inline int node_match(struct kmem_cache_cpu *c, int node)
> +static inline int node_match(struct kmem_cache_cpu *c, int node, gfp_t gfpflags)
>  {
>  #ifdef CONFIG_NUMA
>  	if (node != -1 && c->node != node)
>  		return 0;
>  #endif
> -	return 1;
> +	return cpuset_node_allowed_hardwall(c->node, gfpflags);
>  }

This is a hotpath function and doing an expensive function call here would
significantly impact performance.

It also will cause a reloading of the per cpu slab after each task switch
in the scenario discussed above.

The solution that SLAB has for this scenario is to simply not use the
fastpath for off node allocations. This means all allocations that are not
on the current node always are going through slow path allocations.



