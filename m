Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbXKIRUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbXKIRUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 12:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbXKIRUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 12:20:05 -0500
Received: from palrel12.hp.com ([156.153.255.237]:47765 "EHLO palrel12.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbXKIRUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 12:20:03 -0500
Subject: Re: [PATCH 6/6] Use one zonelist that is filtered by nodemask
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Mel Gorman <mel@skynet.ie>, Christoph Lameter <clameter@sgi.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com
In-Reply-To: <20071109164537.GG7507@us.ibm.com>
References: <20071109143226.23540.12907.sendpatchset@skynet.skynet.ie>
	 <20071109143426.23540.44459.sendpatchset@skynet.skynet.ie>
	 <Pine.LNX.4.64.0711090741120.13932@schroedinger.engr.sgi.com>
	 <20071109161455.GB32088@skynet.ie>  <20071109164537.GG7507@us.ibm.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 09 Nov 2007 12:18:52 -0500
Message-Id: <1194628732.5296.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-09 at 08:45 -0800, Nishanth Aravamudan wrote:
> On 09.11.2007 [16:14:55 +0000], Mel Gorman wrote:
> > On (09/11/07 07:45), Christoph Lameter didst pronounce:
> > > On Fri, 9 Nov 2007, Mel Gorman wrote:
> > > 
> > > >  struct page * fastcall
> > > >  __alloc_pages(gfp_t gfp_mask, unsigned int order,
> > > >  		struct zonelist *zonelist)
> > > >  {
> > > > +	/*
> > > > +	 * Use a temporary nodemask for __GFP_THISNODE allocations. If the
> > > > +	 * cost of allocating on the stack or the stack usage becomes
> > > > +	 * noticable, allocate the nodemasks per node at boot or compile time
> > > > +	 */
> > > > +	if (unlikely(gfp_mask & __GFP_THISNODE)) {
> > > > +		nodemask_t nodemask;
> > > 
> > > Hmmm.. This places a potentially big structure on the stack. nodemask can 
> > > contain up to 1024 bits which means 128 bytes. Maybe keep an array of 
> > > gfp_thisnode nodemasks (node_nodemask?) and use node_nodemask[nid]?
> > > 
> > 
> > That is what I was hinting at in the comment as a possible solution.
> > 
> > > > +
> > > > +		return __alloc_pages_internal(gfp_mask, order,
> > > > +			zonelist, nodemask_thisnode(numa_node_id(), &nodemask));
> > > 
> > > Argh.... GFP_THISNODE must use the nid passed to alloc_pages_node
> > > and *not* the local numa node id. Only if the node specified to
> > > alloc_pages nodes is -1 will this work.
> > > 
> > 
> > alloc_pages_node() calls __alloc_pages_nodemask() though where in this
> > function if I'm reading it right is called without a node id. Given no
> > other details on the nid, the current one seemed a logical choice.
> 
> Yeah, I guess the context here matters (and is a little hard to follow
> because thare are a few places that change in different ways here):
> 
> For allocating pages from a particular node (GFP_THISNODE with nid),
> the nid clearly must be specified. This only happens with
> alloc_pages_node(), AFAICT. So, in that interface, the right thing is
> done and the appropriate nodemask will be built.

I agree.  In an earlier patch, Mel was ignoring nid and using
numa_node_id() here.  This was causing your [Nish's] hugetlb pool
allocation patches to fail.  Mel fixed that ~9oct07.  

> 
> On the other hand, if we call alloc_pages() with GFP_THISNODE set, there
> is no nid to base the allocation on, so we "fallback" to numa_node_id()
> [ almost like the nid had been specified as -1 ].
> 
> So I guess this is logical -- but I wonder, do we have any callers of
> alloc_pages(GFP_THISNODE) ? It seems like an odd thing to do, when
> alloc_pages_node() exists?

I don't know if we have any current callers that do this, but absent any
documentation specifying otherwise, Mel's implementation matches what
I'd expect the behavior to be if I DID call alloc_pages with 'THISNODE.
However, we could specify that THISNODE is ignored in __alloc_pages()
and recommend the use of alloc_pages_node() passing numa_node_id() as
the nid parameter to achieve the behavior.  This would eliminate the
check for 'THISNODE in __alloc_pages().  Just mask it off before calling
down to __alloc_pages_internal().

Does this make sense?

Lee


