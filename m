Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbXJIB4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbXJIB4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 21:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbXJIB4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 21:56:09 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:39129 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752542AbXJIB4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 21:56:08 -0400
Date: Mon, 8 Oct 2007 18:56:05 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nishanth Aravamudan <nacc@us.ibm.com>
cc: Mel Gorman <mel@csn.ul.ie>, akpm@linux-foundation.org,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 6/6] Use one zonelist that is filtered by nodemask
In-Reply-To: <20071009011143.GC14670@us.ibm.com>
Message-ID: <Pine.LNX.4.64.0710081854370.28455@schroedinger.engr.sgi.com>
References: <20070928142326.16783.98817.sendpatchset@skynet.skynet.ie>
 <20070928142526.16783.97067.sendpatchset@skynet.skynet.ie>
 <20071009011143.GC14670@us.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Oct 2007, Nishanth Aravamudan wrote:

> >  struct page * fastcall
> >  __alloc_pages(gfp_t gfp_mask, unsigned int order,
> >  		struct zonelist *zonelist)
> >  {
> > +	/*
> > +	 * Use a temporary nodemask for __GFP_THISNODE allocations. If the
> > +	 * cost of allocating on the stack or the stack usage becomes
> > +	 * noticable, allocate the nodemasks per node at boot or compile time
> > +	 */
> > +	if (unlikely(gfp_mask & __GFP_THISNODE)) {
> > +		nodemask_t nodemask;
> > +
> > +		return __alloc_pages_internal(gfp_mask, order,
> > +				zonelist, nodemask_thisnode(&nodemask));
> > +	}
> > +
> >  	return __alloc_pages_internal(gfp_mask, order, zonelist, NULL);
> >  }
> 
> <snip>
> 
> So alloc_pages_node() calls here and for THISNODE allocations, we go ask
> nodemask_thisnode() for a nodemask...

Hmmmm... nodemask_thisnode needs to be passed the zonelist.

> And nodemask_thisnode() always gives us a nodemask with only the node
> the current process is running on set, I think?

Right.

 
> That seems really wrong -- and would explain what Lee was seeing while
> using my patches for the hugetlb pool allocator to use THISNODE
> allocations. All the allocations would end up coming from whatever node
> the process happened to be running on. This obviously messes up hugetlb
> accounting, as I rely on THISNODE requests returning NULL if they go
> off-node.
> 
> I'm not sure how this would be fixed, as __alloc_pages() no longer has
> the nid to set in the mask.
> 
> Am I wrong in my analysis?

No you are right on target. The thisnode function must determine the node 
from the first zone of the zonelist.
