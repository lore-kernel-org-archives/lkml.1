Return-Path: <linux-kernel-owner+w=401wt.eu-S1762789AbXJLRUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762789AbXJLRUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762258AbXJLRTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:19:34 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46463 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762714AbXJLRTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:19:32 -0400
Date: Fri, 12 Oct 2007 10:19:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Yasunori Goto <y-goto@jp.fujitsu.com>
cc: Andrew Morton <akpm@osdl.org>,
       Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [Patch 002/002] Create/delete kmem_cache_node for SLUB on memory
 online callback
In-Reply-To: <20071012133336.B9A5.Y-GOTO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0710121014430.8605@schroedinger.engr.sgi.com>
References: <20071012112801.B9A1.Y-GOTO@jp.fujitsu.com>
 <Pine.LNX.4.64.0710112056300.1882@schroedinger.engr.sgi.com>
 <20071012133336.B9A5.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2007, Yasunori Goto wrote:

> > > +	down_read(&slub_lock);
> > > +	list_for_each_entry(s, &slab_caches, list) {
> > > +		local_node = page_to_nid(virt_to_page(s));
> > > +		if (local_node == offline_node)
> > > +			/* This slub is on the offline node. */
> > > +			return -EBUSY;
> > > +	}
> > > +	up_read(&slub_lock);
> > 
> > So this checks if the any kmem_cache structure is on the offlined node? If
> > so then we cannot offline the node?
> 
> Right. If slabs' migration is possible, here would be good place for
> doing it. But, it is not possible (at least now).

I think you can avoid this check. The kmem_cache structures are allocated 
from the kmalloc array. The check if the kmalloc slabs are empty will fail 
if kmem_cache structures still exist on the node.

> > > +			 * because the node is used by slub yet.
> > > +			 */
> > 
> > It may be clearer to say:
> > 
> > "If nr_slabs > 0 then slabs still exist on the node that is going down.
> > We were unable to free them so we must fail."
> 
> Again. If nr_slabs > 0, offline_pages must be fail due to slabs
> remaining on the node before. So, this callback isn't called.

Ok then we can remove these checks?

> > > +static int slab_mem_going_online_callback(void *arg)
> > > +{
> > > +	struct kmem_cache_node *n;
> > > +	struct kmem_cache *s;
> > > +	struct memory_notify *marg = arg;
> > > +	int nid = marg->status_change_nid;
> > > +
> > > +	/* If the node already has memory, then nothing is necessary. */
> > > +	if (nid < 0)
> > > +		return 0;
> > 
> > The node must have memory????  Or we have already brought up the code?
> 
> kmem_cache_node is created at boot time if the node has memory.
> (Or, it is created by this callback on first added memory on the node).
> 
> When nid = - 1, kmem_cache_node is created before this node due to
> node has memory. 

So the function can be called for a node that is already online?

> > > +	 * New memory will be onlined on the node which has no memory so far.
> > > +	 * New kmem_cache_node is necssary for it.
> > 
> > "We are bringing a node online. No memory is available yet. We must 
> > allocate a kmem_cache_node structure in order to bring the node online." ?
> 
> Your mention might be ok.
> But. I would like to prefer to define status of node hotplug for
> exactitude like followings
> 
> 
> A)Node online -- pgdat is created and can be accessed for this node.
>                  but there are no gurantee that cpu or memory is onlined.
>                  This status is very close from memory-less node.
>                  But this might be halfway status for node hotplug.
>                  Node online bit is set. But N_HIGH_MEMORY
>                  (or N_NORMAL_MEMORY) might be not set.

Ahh.. Okay.

> B)Node has memory--
>                  one or more sections memory is onlined on the node.
>                  N_HIGH_MEMORY (or N_NORMAL_MEMORY) is set.
> 
> If first memory is onlined on the node, the node status changes
> from A) to B).
> 
> I feel this is very useful to manage "halfway status" of node
> hotplug. (So, memory-less node patch is very helpful for me.)
> 
> So, I would like to avoid using the word "node online" at here.
> But, if above definition is messy for others, I'll change it.

Ok can we talk about this as

	node online

and

	node memory available?

