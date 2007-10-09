Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbXJIDRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbXJIDRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 23:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752820AbXJIDRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 23:17:31 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49911 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbXJIDRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 23:17:30 -0400
Date: Mon, 8 Oct 2007 20:17:24 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>, akpm@linux-foundation.org,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 6/6] Use one zonelist that is filtered by nodemask
Message-ID: <20071009031724.GB26472@us.ibm.com>
References: <20070928142326.16783.98817.sendpatchset@skynet.skynet.ie> <20070928142526.16783.97067.sendpatchset@skynet.skynet.ie> <20071009011143.GC14670@us.ibm.com> <Pine.LNX.4.64.0710081854370.28455@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710081854370.28455@schroedinger.engr.sgi.com>
X-Operating-System: Linux 2.6.22.6 (x86_64)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.10.2007 [18:56:05 -0700], Christoph Lameter wrote:
> On Mon, 8 Oct 2007, Nishanth Aravamudan wrote:
> 
> > >  struct page * fastcall
> > >  __alloc_pages(gfp_t gfp_mask, unsigned int order,
> > >  		struct zonelist *zonelist)
> > >  {
> > > +	/*
> > > +	 * Use a temporary nodemask for __GFP_THISNODE allocations. If the
> > > +	 * cost of allocating on the stack or the stack usage becomes
> > > +	 * noticable, allocate the nodemasks per node at boot or compile time
> > > +	 */
> > > +	if (unlikely(gfp_mask & __GFP_THISNODE)) {
> > > +		nodemask_t nodemask;
> > > +
> > > +		return __alloc_pages_internal(gfp_mask, order,
> > > +				zonelist, nodemask_thisnode(&nodemask));
> > > +	}
> > > +
> > >  	return __alloc_pages_internal(gfp_mask, order, zonelist, NULL);
> > >  }
> > 
> > <snip>
> > 
> > So alloc_pages_node() calls here and for THISNODE allocations, we go ask
> > nodemask_thisnode() for a nodemask...
> 
> Hmmmm... nodemask_thisnode needs to be passed the zonelist.
> 
> > And nodemask_thisnode() always gives us a nodemask with only the node
> > the current process is running on set, I think?
> 
> Right.
> 
> 
> > That seems really wrong -- and would explain what Lee was seeing while
> > using my patches for the hugetlb pool allocator to use THISNODE
> > allocations. All the allocations would end up coming from whatever node
> > the process happened to be running on. This obviously messes up hugetlb
> > accounting, as I rely on THISNODE requests returning NULL if they go
> > off-node.
> > 
> > I'm not sure how this would be fixed, as __alloc_pages() no longer has
> > the nid to set in the mask.
> > 
> > Am I wrong in my analysis?
> 
> No you are right on target. The thisnode function must determine the
> node from the first zone of the zonelist.

It seems like I would zonelist_node_idx() for this, along the lines of:

	static nodemask_t *nodemask_thisnode(nodemask_t *nodemask,
		struct zonelist *zonelist)
	{
		int nid = zonelist_node_idx(zonelist);
		/* Build a nodemask for just this node */
		nodes_clear(*nodemask);
		node_set(nid, *nodemask);

		return nodemask;
	}

But I think I need to check that zonelist->_zonerefs->zone is !NULL, given this
definition of zonelist_node_idx()

	static inline int zonelist_node_idx(struct zoneref *zoneref)
	{
	#ifdef CONFIG_NUMA
		/* zone_to_nid not available in this context */
		return zoneref->zone->node;
	#else
		return 0;
	#endif /* CONFIG_NUMA */
	}

and this comment in __alloc_pages_internal():

	....
	z = zonelist->_zonerefs;  /* the list of zones suitable for gfp_mask */

	if (unlikely(!z->zone)) {
		/*
		 * Happens if we have an empty zonelist as a result of
		 * GFP_THISNODE being used on a memoryless node
		 */
		return NULL;
	}
	...

It seems like zoneref->zone may be NULL in zonelist_node_idx()? Maybe
someone else should look into resolving this :)

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
