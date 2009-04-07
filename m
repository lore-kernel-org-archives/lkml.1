Return-Path: <linux-kernel-owner+w=401wt.eu-S1760454AbZDGT65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760454AbZDGT65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 15:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756838AbZDGT6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 15:58:43 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36586 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760192AbZDGT6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 15:58:42 -0400
Message-ID: <49DBAF7E.30704@cs.helsinki.fi>
Date: Tue, 07 Apr 2009 22:54:38 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: default min_partial to at least highest cpus per
  node
References: <alpine.DEB.2.00.0904051653420.25339@chino.kir.corp.google.com>  <49DBA23A.3000106@cs.helsinki.fi> <84144f020904071209j638aae9bv406661ec401af7af@mail.gmail.com> <alpine.DEB.2.00.0904071231500.21113@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0904071231500.21113@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Tue, 7 Apr 2009, Pekka Enberg wrote:
> 
>>> Hmm, partial lists are per-node, so wouldn't it be better to do the
>>> adjustment for every struct kmem_cache_node separately? The
>>> 'min_partial_per_node' global seems just too ugly and confusing to live
>>> with.
>> Btw, that requires moving ->min_partial to struct kmem_cache_node from
>> struct kmem_cache.  But I think that makes a whole lot of sense if
>> some nodes may have more CPUs than others.
>>
>> And while the improvement is kinda obvious, I would be interested to
>> know what kind of workload benefits from this patch (and see numbers
>> if there are any).
>>
> 
> It doesn't really depend on the workload, it depends on the type of NUMA 
> machine it's running on (and whether that NUMA is asymmetric amongst 
> cpus).
> 
> Since min_partial_per_node is capped at MAX_PARTIAL, this is only really 
> relevant for remote node defragmentation if it's allowed (and not just 2% 
> of the time like the default).  We want to avoid stealing partial slabs 
> from remote nodes if there are fewer than the number of cpus on that node.
> 
> Otherwise, it's possible for each cpu on the victim node to try to 
> allocate a single object and require nr_cpus_node(node) new slab 
> allocations.  In this case it's entirely possible for the majority of cpus 
> to have cpu slabs from remote nodes.  This change reduces the liklihood of 
> that happening because we'll always have cpu slab replacements on our 
> local partial list before allowing remote defragmentation.
> 
> I'd be just as happy with the following, although it would require 
> changing MIN_PARTIAL to be greater than its default of 5 if a node 
> supports more cpus for optimal performance (the old patch did that 
> automatically up to MAX_PARTIAL).

Hmm but why not move ->min_partial to struct kmem_cache_node as I 
suggested and make sure it's adjusted properly as with nr_cpus_node()?

> diff --git a/mm/slub.c b/mm/slub.c
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1326,11 +1326,13 @@ static struct page *get_any_partial(struct kmem_cache *s, gfp_t flags)
>  	zonelist = node_zonelist(slab_node(current->mempolicy), flags);
>  	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
>  		struct kmem_cache_node *n;
> +		int node;
>  
> -		n = get_node(s, zone_to_nid(zone));
> +		node = zone_to_nid(zone);
> +		n = get_node(s, node);
>  
>  		if (n && cpuset_zone_allowed_hardwall(zone, flags) &&
> -				n->nr_partial > s->min_partial) {
> +				n->nr_partial > nr_cpus_node(node)) {
>  			page = get_partial_node(n);
>  			if (page)
>  				return page;
