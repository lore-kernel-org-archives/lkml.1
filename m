Return-Path: <linux-kernel-owner+w=401wt.eu-S1761463AbXJRG0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761463AbXJRG0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 02:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757200AbXJRG0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 02:26:01 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55588 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756367AbXJRGZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 02:25:59 -0400
Date: Wed, 17 Oct 2007 23:25:58 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [Patch](memory hotplug) Make kmem_cache_node for SLUB on memory
 online to avoid panic(take 3)
In-Reply-To: <20071017204651.aefcece7.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0710172321550.11401@schroedinger.engr.sgi.com>
References: <20071018122345.514F.Y-GOTO@jp.fujitsu.com>
 <20071017204651.aefcece7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007, Andrew Morton wrote:

> > +#if defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)
> 
> hm.  There should be no linkage between memory hotpluggability and
> NUMA, surely?

NUMA support in the slab allocators requires allocation of per node 
structures. The per node structures are folded into the global structure 
for non NUMA.

> > +			/*
> > +			 * if n->nr_slabs > 0, slabs still exist on the node
> > +			 * that is going down. We were unable to free them,
> > +			 * and offline_pages() function shoudn't call this
> > +			 * callback. So, we must fail.
> > +			 */
> > +			BUG_ON(atomic_read(&n->nr_slabs));
> 
> Expereince tells us that WARN_ON is preferred for newly added code ;)

It would be bad to just zap a per node array while there is still data in 
there. This will cause later failures when an attempt is made to free the 
objects that now have no per node structure anymore.

> > +  		/*
> > +		 * XXX: kmem_cache_alloc_node will fallback to other nodes
> > +		 *      since memory is not yet available from the node that
> > +		 *      is brought up.
> > +  		 */
> > +		n = kmem_cache_alloc(kmalloc_caches, GFP_KERNEL);
> > +		if (!n)
> > +			return -ENOMEM;
> 
> err, we forgot slub_lock.  I'll fix that.

Right.

> So that's slub.  Does slab already have this functionality or are you
> not bothering to maintain slab in this area?

Slab brings up a per node structure when the corresponding cpu is brought 
up. That was sufficient as long as we did not have any memoryless nodes. 
Now we may have to fix some things over there as well.

