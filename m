Return-Path: <linux-kernel-owner+w=401wt.eu-S1760953AbYAaE24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760953AbYAaE24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 23:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbYAaE2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 23:28:48 -0500
Received: from relay1.sgi.com ([192.48.171.29]:32790 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754501AbYAaE2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 23:28:48 -0500
Date: Wed, 30 Jan 2008 20:28:47 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slub: fix shadowed variable sparse warnings
In-Reply-To: <1201753405.23523.8.camel@brick>
Message-ID: <Pine.LNX.4.64.0801302027450.25812@schroedinger.engr.sgi.com>
References: <1201753405.23523.8.camel@brick>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008, Harvey Harrison wrote:

> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  mm/slub.c |   15 ++++++---------
>  1 files changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 5cc4b7d..f9a20bf 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3403,19 +3403,19 @@ static int list_locations(struct kmem_cache *s, char *buf,
>  	flush_all(s);
>  
>  	for_each_node_state(node, N_NORMAL_MEMORY) {
> -		struct kmem_cache_node *n = get_node(s, node);
> +		struct kmem_cache_node *nd = get_node(s, node);
>  		unsigned long flags;
>  		struct page *page;
>  
> -		if (!atomic_long_read(&n->nr_slabs))
> +		if (!atomic_long_read(&nd->nr_slabs))
>  			continue;
>  
> -		spin_lock_irqsave(&n->list_lock, flags);
> -		list_for_each_entry(page, &n->partial, lru)
> +		spin_lock_irqsave(&nd->list_lock, flags);
> +		list_for_each_entry(page, &nd->partial, lru)
>  			process_slab(&t, s, page, alloc);
> -		list_for_each_entry(page, &n->full, lru)
> +		list_for_each_entry(page, &nd->full, lru)
>  			process_slab(&t, s, page, alloc);
> -		spin_unlock_irqrestore(&n->list_lock, flags);
> +		spin_unlock_irqrestore(&nd->list_lock, flags);
>  	}

Could you rename the outer variable instead? That is a counter. So call 
this count or something. The n is used throughout to refer to 
kmem_cache_node structs.
  
>  	for (i = 0; i < t.count; i++) {
> @@ -3498,7 +3498,6 @@ static unsigned long slab_objects(struct kmem_cache *s,
>  
>  	for_each_possible_cpu(cpu) {
>  		struct page *page;
> -		int node;
>  		struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
>  
>  		if (!c)

That is okay.

> @@ -3510,8 +3509,6 @@ static unsigned long slab_objects(struct kmem_cache *s,
>  			continue;
>  		if (page) {
>  			if (flags & SO_CPU) {
> -				int x = 0;
> -
>  				if (flags & SO_OBJECTS)
>  					x = page->inuse;
>  				else

Ok too.

