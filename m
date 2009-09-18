Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbZIRVEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbZIRVEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 17:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbZIRVE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 17:04:29 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:52411 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751946AbZIRVE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 17:04:29 -0400
Date: Fri, 18 Sep 2009 17:01:14 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Mel Gorman <mel@csn.ul.ie>
cc: Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] slqb: Treat pages freed on a memoryless node as
 local node
In-Reply-To: <1253302451-27740-3-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0909181657280.9490@V090114053VZO-1>
References: <1253302451-27740-1-git-send-email-mel@csn.ul.ie> <1253302451-27740-3-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009, Mel Gorman wrote:

> --- a/mm/slqb.c
> +++ b/mm/slqb.c
> @@ -1726,6 +1726,7 @@ static __always_inline void __slab_free(struct kmem_cache *s,
>  	struct kmem_cache_cpu *c;
>  	struct kmem_cache_list *l;
>  	int thiscpu = smp_processor_id();
> +	int thisnode = numa_node_id();

thisnode must be the first reachable node with usable RAM. Not the current
node. cpu 0 may be on node 0 but there is no memory on 0. Instead
allocations fall back to node 2 (depends on policy effective as well. The
round robin meory policy default on bootup may result in allocations from
different nodes as well).

>  	c = get_cpu_slab(s, thiscpu);
>  	l = &c->list;
> @@ -1733,12 +1734,14 @@ static __always_inline void __slab_free(struct kmem_cache *s,
>  	slqb_stat_inc(l, FREE);
>
>  	if (!NUMA_BUILD || !slab_numa(s) ||
> -			likely(slqb_page_to_nid(page) == numa_node_id())) {
> +			likely(slqb_page_to_nid(page) == numa_node_id() ||
> +			!node_state(thisnode, N_HIGH_MEMORY))) {

Same here.

Note that page_to_nid can yield surprising results if you are trying to
allocate from a node that has no memory and you get some fallback node.

SLAB for some time had a bug that caused list corruption because of this.

