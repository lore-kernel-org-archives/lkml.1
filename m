Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab0BEVSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 16:18:06 -0500
Received: from smtp-out.google.com ([216.239.33.17]:52930 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757511Ab0BEVSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 16:18:02 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=DBY6HMmMCh86DAJAEqW6nycY09S539hxinV12kHSkxZRqvD4PjoHeqMiEd1F2XPCK
	lngWbh7Rk2SPMoA9eW5Ww==
Date: Fri, 5 Feb 2010 13:17:56 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: submit@firstfloor.org, linux-kernel@vger.kernel.org, haicheng.li@intel.com,
       penberg@cs.helsinki.fi, linux-mm@kvack.org
Subject: Re: [PATCH] [2/4] SLAB: Set up the l3 lists for the memory of freshly
 added memory
In-Reply-To: <20100203213913.D5CD4B1620@basil.firstfloor.org>
Message-ID: <alpine.DEB.2.00.1002051316300.2376@chino.kir.corp.google.com>
References: <201002031039.710275915@firstfloor.org> <20100203213913.D5CD4B1620@basil.firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010, Andi Kleen wrote:

> Index: linux-2.6.33-rc3-ak/mm/slab.c
> ===================================================================
> --- linux-2.6.33-rc3-ak.orig/mm/slab.c
> +++ linux-2.6.33-rc3-ak/mm/slab.c
> @@ -115,6 +115,7 @@
>  #include	<linux/reciprocal_div.h>
>  #include	<linux/debugobjects.h>
>  #include	<linux/kmemcheck.h>
> +#include	<linux/memory.h>
>  
>  #include	<asm/cacheflush.h>
>  #include	<asm/tlbflush.h>
> @@ -1560,6 +1561,20 @@ void __init kmem_cache_init(void)
>  	g_cpucache_up = EARLY;
>  }
>  
> +static int slab_memory_callback(struct notifier_block *self,
> +				unsigned long action, void *arg)
> +{
> +	struct memory_notify *mn = (struct memory_notify *)arg;

No cast necessary.

> +
> +	/*
> +	 * When a node goes online allocate l3s early.	 This way
> +	 * kmalloc_node() works for it.
> +	 */
> +	if (action == MEM_ONLINE && mn->status_change_nid >= 0)
> +		slab_node_prepare(mn->status_change_nid);
> +	return NOTIFY_OK;
> +}
> +
>  void __init kmem_cache_init_late(void)
>  {
>  	struct kmem_cache *cachep;
> @@ -1583,6 +1598,8 @@ void __init kmem_cache_init_late(void)
>  	 */
>  	register_cpu_notifier(&cpucache_notifier);
>  
> +	hotplug_memory_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);

Only needed for CONFIG_NUMA.

> +
>  	/*
>  	 * The reap timers are started later, with a module init call: That part
>  	 * of the kernel is not yet operational.
