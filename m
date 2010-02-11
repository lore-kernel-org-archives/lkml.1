Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab0BKVpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 16:45:23 -0500
Received: from smtp-out.google.com ([216.239.33.17]:47314 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757011Ab0BKVpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 16:45:22 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=tku2L1m347bmPMKXSeyiO3CWn39nn1rMRDOhKMUpCMtII+5TOjDHvG3B7ZByRCKJA
	Nk2Ed07pRE2wAFa/5sgxQ==
Date: Thu, 11 Feb 2010 13:45:16 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       haicheng.li@intel.com
Subject: Re: [PATCH] [3/4] SLAB: Set up the l3 lists for the memory of freshly
 added memory v2
In-Reply-To: <20100211205403.05A8EB1978@basil.firstfloor.org>
Message-ID: <alpine.DEB.2.00.1002111344130.8809@chino.kir.corp.google.com>
References: <20100211953.850854588@firstfloor.org> <20100211205403.05A8EB1978@basil.firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010, Andi Kleen wrote:

> Index: linux-2.6.32-memhotadd/mm/slab.c
> ===================================================================
> --- linux-2.6.32-memhotadd.orig/mm/slab.c
> +++ linux-2.6.32-memhotadd/mm/slab.c
> @@ -115,6 +115,7 @@
>  #include	<linux/reciprocal_div.h>
>  #include	<linux/debugobjects.h>
>  #include	<linux/kmemcheck.h>
> +#include	<linux/memory.h>
>  
>  #include	<asm/cacheflush.h>
>  #include	<asm/tlbflush.h>
> @@ -1554,6 +1555,23 @@ void __init kmem_cache_init(void)
>  	g_cpucache_up = EARLY;
>  }
>  
> +static int slab_memory_callback(struct notifier_block *self,
> +				unsigned long action, void *arg)
> +{
> +	struct memory_notify *mn = (struct memory_notify *)arg;
> +
> +	/*
> +	 * When a node goes online allocate l3s early.	 This way
> +	 * kmalloc_node() works for it.
> +	 */
> +	if (action == MEM_ONLINE && mn->status_change_nid >= 0) {
> +		mutex_lock(&cache_chain_mutex);
> +		slab_node_prepare(mn->status_change_nid);
> +		mutex_unlock(&cache_chain_mutex);
> +	}
> +	return NOTIFY_OK;
> +}
> +
>  void __init kmem_cache_init_late(void)
>  {
>  	struct kmem_cache *cachep;
> @@ -1577,6 +1595,8 @@ void __init kmem_cache_init_late(void)
>  	 */
>  	register_cpu_notifier(&cpucache_notifier);
>  
> +	hotplug_memory_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
> +

Only needed for CONFIG_NUMA, but there's no side-effects for UMA kernels 
since status_change_nid will always be -1.

Acked-by: David Rientjes <rientjes@google.com>
