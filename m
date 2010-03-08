Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab0CHXUC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:20:02 -0500
Received: from smtp-out.google.com ([216.239.44.51]:26785 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab0CHXT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:19:59 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=YcgoLarSnfGPWlwNF8S7nQ55iUEKATSwwRKP7FjandSVjDw6aASHUZHV7h2cSMWKf
	cQngF9x7DBdAGaTmtU8Fg==
Date: Mon, 8 Mar 2010 15:19:48 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Piggin <npiggin@suse.de>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, haicheng.li@intel.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [patch] slab: add memory hotplug support
In-Reply-To: <20100305062002.GV8653@laptop>
Message-ID: <alpine.DEB.2.00.1003081502400.30456@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002240949140.26771@router.home> <4B862623.5090608@cs.helsinki.fi> <alpine.DEB.2.00.1002242357450.26099@chino.kir.corp.google.com> <alpine.DEB.2.00.1002251228140.18861@router.home> <20100226114136.GA16335@basil.fritz.box>
 <alpine.DEB.2.00.1002260904311.6641@router.home> <20100226155755.GE16335@basil.fritz.box> <alpine.DEB.2.00.1002261123520.7719@router.home> <alpine.DEB.2.00.1002261555030.32111@chino.kir.corp.google.com> <alpine.DEB.2.00.1003010224170.26824@chino.kir.corp.google.com>
 <20100305062002.GV8653@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Mar 2010, Nick Piggin wrote:

> > +#if defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)
> > +/*
> > + * Drains and frees nodelists for a node on each slab cache, used for memory
> > + * hotplug.  Returns -EBUSY if all objects cannot be drained on memory
> > + * hot-remove so that the node is not removed.  When used because memory
> > + * hot-add is canceled, the only result is the freed kmem_list3.
> > + *
> > + * Must hold cache_chain_mutex.
> > + */
> > +static int __meminit free_cache_nodelists_node(int node)
> > +{
> > +	struct kmem_cache *cachep;
> > +	int ret = 0;
> > +
> > +	list_for_each_entry(cachep, &cache_chain, next) {
> > +		struct array_cache *shared;
> > +		struct array_cache **alien;
> > +		struct kmem_list3 *l3;
> > +
> > +		l3 = cachep->nodelists[node];
> > +		if (!l3)
> > +			continue;
> > +
> > +		spin_lock_irq(&l3->list_lock);
> > +		shared = l3->shared;
> > +		if (shared) {
> > +			free_block(cachep, shared->entry, shared->avail, node);
> > +			l3->shared = NULL;
> > +		}
> > +		alien = l3->alien;
> > +		l3->alien = NULL;
> > +		spin_unlock_irq(&l3->list_lock);
> > +
> > +		if (alien) {
> > +			drain_alien_cache(cachep, alien);
> > +			free_alien_cache(alien);
> > +		}
> > +		kfree(shared);
> > +
> > +		drain_freelist(cachep, l3, l3->free_objects);
> > +		if (!list_empty(&l3->slabs_full) ||
> > +					!list_empty(&l3->slabs_partial)) {
> > +			/*
> > +			 * Continue to iterate through each slab cache to free
> > +			 * as many nodelists as possible even though the
> > +			 * offline will be canceled.
> > +			 */
> > +			ret = -EBUSY;
> > +			continue;
> > +		}
> > +		kfree(l3);
> > +		cachep->nodelists[node] = NULL;
> 
> What's stopping races of other CPUs trying to access l3 and array
> caches while they're being freed?
> 

numa_node_id() will not return an offlined nodeid and cache_alloc_node() 
already does a fallback to other onlined nodes in case a nodeid is passed 
to kmalloc_node() that does not have a nodelist.  l3->shared and l3->alien 
cannot be accessed without l3->list_lock (drain, cache_alloc_refill, 
cache_flusharray) or cache_chain_mutex (kmem_cache_destroy, cache_reap).

> > +	}
> > +	return ret;
> > +}
> > +
> > +/*
> > + * Onlines nid either as the result of memory hot-add or canceled hot-remove.
> > + */
> > +static int __meminit slab_node_online(int nid)
> > +{
> > +	int ret;
> > +	mutex_lock(&cache_chain_mutex);
> > +	ret = init_cache_nodelists_node(nid);
> > +	mutex_unlock(&cache_chain_mutex);
> > +	return ret;
> > +}
> > +
> > +/*
> > + * Offlines nid either as the result of memory hot-remove or canceled hot-add.
> > + */
> > +static int __meminit slab_node_offline(int nid)
> > +{
> > +	int ret;
> > +	mutex_lock(&cache_chain_mutex);
> > +	ret = free_cache_nodelists_node(nid);
> > +	mutex_unlock(&cache_chain_mutex);
> > +	return ret;
> > +}
> > +
> > +static int __meminit slab_memory_callback(struct notifier_block *self,
> > +					unsigned long action, void *arg)
> > +{
> > +	struct memory_notify *mnb = arg;
> > +	int ret = 0;
> > +	int nid;
> > +
> > +	nid = mnb->status_change_nid;
> > +	if (nid < 0)
> > +		goto out;
> > +
> > +	switch (action) {
> > +	case MEM_GOING_ONLINE:
> > +	case MEM_CANCEL_OFFLINE:
> > +		ret = slab_node_online(nid);
> > +		break;
> 
> This would explode if CANCEL_OFFLINE fails. Call it theoretical and
> put a panic() in here and I don't mind. Otherwise you get corruption
> somewhere in the slab code.
> 

MEM_CANCEL_ONLINE would only fail here if a struct kmem_list3 couldn't be 
allocated anywhere on the system and if that happens then the node simply 
couldn't be allocated from (numa_node_id() would never return it as the 
cpu's node, so it's possible to fallback in this scenario).

Instead of doing this all at MEM_GOING_OFFLINE, we could delay freeing of 
the array caches and the nodelist until MEM_OFFLINE.  We're guaranteed 
that all pages are freed at that point so there are no existing objects 
that we need to track and then if the offline fails from a different 
callback it would be possible to reset the l3->nodelists[node] pointers 
since they haven't been freed yet.
