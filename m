Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab0BOGG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 01:06:59 -0500
Received: from cantor.suse.de ([195.135.220.2]:44690 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab0BOGG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 01:06:58 -0500
Date: Mon, 15 Feb 2010 17:06:55 +1100
From: Nick Piggin <npiggin@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, haicheng.li@intel.com
Subject: Re: [PATCH] [3/4] SLAB: Set up the l3 lists for the memory of
 freshly added memory v2
Message-ID: <20100215060655.GH5723@laptop>
References: <20100211953.850854588@firstfloor.org>
 <20100211205403.05A8EB1978@basil.firstfloor.org>
 <alpine.DEB.2.00.1002111344130.8809@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002111344130.8809@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 01:45:16PM -0800, David Rientjes wrote:
> On Thu, 11 Feb 2010, Andi Kleen wrote:
> 
> > Index: linux-2.6.32-memhotadd/mm/slab.c
> > ===================================================================
> > --- linux-2.6.32-memhotadd.orig/mm/slab.c
> > +++ linux-2.6.32-memhotadd/mm/slab.c
> > @@ -115,6 +115,7 @@
> >  #include	<linux/reciprocal_div.h>
> >  #include	<linux/debugobjects.h>
> >  #include	<linux/kmemcheck.h>
> > +#include	<linux/memory.h>
> >  
> >  #include	<asm/cacheflush.h>
> >  #include	<asm/tlbflush.h>
> > @@ -1554,6 +1555,23 @@ void __init kmem_cache_init(void)
> >  	g_cpucache_up = EARLY;
> >  }
> >  
> > +static int slab_memory_callback(struct notifier_block *self,
> > +				unsigned long action, void *arg)
> > +{
> > +	struct memory_notify *mn = (struct memory_notify *)arg;
> > +
> > +	/*
> > +	 * When a node goes online allocate l3s early.	 This way
> > +	 * kmalloc_node() works for it.
> > +	 */
> > +	if (action == MEM_ONLINE && mn->status_change_nid >= 0) {
> > +		mutex_lock(&cache_chain_mutex);
> > +		slab_node_prepare(mn->status_change_nid);
> > +		mutex_unlock(&cache_chain_mutex);
> > +	}
> > +	return NOTIFY_OK;
> > +}
> > +
> >  void __init kmem_cache_init_late(void)
> >  {
> >  	struct kmem_cache *cachep;
> > @@ -1577,6 +1595,8 @@ void __init kmem_cache_init_late(void)
> >  	 */
> >  	register_cpu_notifier(&cpucache_notifier);
> >  
> > +	hotplug_memory_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
> > +
> 
> Only needed for CONFIG_NUMA, but there's no side-effects for UMA kernels 
> since status_change_nid will always be -1.

Compiler doesn't know that, though.

> 
> Acked-by: David Rientjes <rientjes@google.com>
