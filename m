Return-Path: <linux-kernel-owner+w=401wt.eu-S1764315AbXJRDrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764315AbXJRDrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 23:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760436AbXJRDrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 23:47:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42476 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760049AbXJRDrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 23:47:04 -0400
Date: Wed, 17 Oct 2007 20:46:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [Patch](memory hotplug) Make kmem_cache_node for SLUB on memory
 online to avoid panic(take 3)
Message-Id: <20071017204651.aefcece7.akpm@linux-foundation.org>
In-Reply-To: <20071018122345.514F.Y-GOTO@jp.fujitsu.com>
References: <20071018122345.514F.Y-GOTO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007 12:25:37 +0900 Yasunori Goto <y-goto@jp.fujitsu.com> wrote:

> 
> This patch fixes panic due to access NULL pointer
> of kmem_cache_node at discard_slab() after memory online.
> 
> When memory online is called, kmem_cache_nodes are created for
> all SLUBs for new node whose memory are available.
> 
> slab_mem_going_online_callback() is called to make kmem_cache_node()
> in callback of memory online event. If it (or other callbacks) fails,
> then slab_mem_offline_callback() is called for rollback.
> 
> In memory offline, slab_mem_going_offline_callback() is called to
> shrink all slub cache, then slab_mem_offline_callback() is called later.
> 
> This patch is tested on my ia64 box.
> 
> ...
>  
> +#if defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)

hm.  There should be no linkage between memory hotpluggability and
NUMA, surely?

> +static int slab_mem_going_offline_callback(void *arg)
> +{
> +	struct kmem_cache *s;
> +
> +	down_read(&slub_lock);
> +	list_for_each_entry(s, &slab_caches, list)
> +		kmem_cache_shrink(s);
> +	up_read(&slub_lock);
> +
> +	return 0;
> +}
> +
> +static void slab_mem_offline_callback(void *arg)
> +{
> +	struct kmem_cache_node *n;
> +	struct kmem_cache *s;
> +	struct memory_notify *marg = arg;
> +	int offline_node;
> +
> +	offline_node = marg->status_change_nid;
> +
> +	/*
> +	 * If the node still has available memory. we need kmem_cache_node
> +	 * for it yet.
> +	 */
> +	if (offline_node < 0)
> +		return;
> +
> +	down_read(&slub_lock);
> +	list_for_each_entry(s, &slab_caches, list) {
> +		n = get_node(s, offline_node);
> +		if (n) {
> +			/*
> +			 * if n->nr_slabs > 0, slabs still exist on the node
> +			 * that is going down. We were unable to free them,
> +			 * and offline_pages() function shoudn't call this
> +			 * callback. So, we must fail.
> +			 */
> +			BUG_ON(atomic_read(&n->nr_slabs));

Expereince tells us that WARN_ON is preferred for newly added code ;)

> +			s->node[offline_node] = NULL;
> +			kmem_cache_free(kmalloc_caches, n);
> +		}
> +	}
> +	up_read(&slub_lock);
> +}
> +
> +static int slab_mem_going_online_callback(void *arg)
> +{
> +	struct kmem_cache_node *n;
> +	struct kmem_cache *s;
> +	struct memory_notify *marg = arg;
> +	int nid = marg->status_change_nid;
> +
> +	/*
> +	 * If the node's memory is already available, then kmem_cache_node is
> +	 * already created. Nothing to do.
> +	 */
> +	if (nid < 0)
> +		return 0;
> +
> +	/*
> +	 * We are bringing a node online. No memory is availabe yet. We must
> +	 * allocate a kmem_cache_node structure in order to bring the node
> +	 * online.
> +	 */
> +	down_read(&slub_lock);
> +	list_for_each_entry(s, &slab_caches, list) {
> +  		/*
> +		 * XXX: kmem_cache_alloc_node will fallback to other nodes
> +		 *      since memory is not yet available from the node that
> +		 *      is brought up.
> +  		 */
> +		n = kmem_cache_alloc(kmalloc_caches, GFP_KERNEL);
> +		if (!n)
> +			return -ENOMEM;

err, we forgot slub_lock.  I'll fix that.

> +		init_kmem_cache_node(n);
> +		s->node[nid] = n;
> +  	}
> +	up_read(&slub_lock);
> +
> +  	return 0;
> +}

So that's slub.  Does slab already have this functionality or are you
not bothering to maintain slab in this area?

