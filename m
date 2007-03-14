Return-Path: <linux-kernel-owner+w=401wt.eu-S1160997AbXCNUm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160997AbXCNUm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1160998AbXCNUm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:42:28 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:47561 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1160997AbXCNUm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:42:27 -0400
Subject: Re: [RFC][PATCH 2/7] RSS controller core
From: Dave Hansen <hansendc@us.ibm.com>
To: Mel Gorman <mel@skynet.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kirill Korotaev <dev@sw.ru>,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       Mel Gorman <MELGOR@ie.ibm.com>, Andy Wihitcroft <apw@shadowen.org>
In-Reply-To: <20070314153824.GA6607@skynet.ie>
References: <20070306140036.4e85bd2f.akpm@linux-foundation.org>
	 <45F3F581.9030503@sw.ru>
	 <20070311045111.62d3e9f9.akpm@linux-foundation.org>
	 <20070312010039.GC21861@MAIL.13thfloor.at>
	 <1173724979.11945.103.camel@localhost.localdomain>
	 <20070312224129.GC21258@MAIL.13thfloor.at>
	 <20070312220439.677b4787.akpm@linux-foundation.org>
	 <45F67AC9.4080707@sw.ru>
	 <20070313034834.14013bb0.akpm@linux-foundation.org>
	 <1173805534.6680.26.camel@localhost.localdomain>
	 <20070314153824.GA6607@skynet.ie>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 13:42:18 -0700
Message-Id: <1173904938.6680.104.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-14 at 15:38 +0000, Mel Gorman wrote:
> On (13/03/07 10:05), Dave Hansen didst pronounce:
> > How do we determine what is shared, and goes into the shared zones?
> 
> Assuming we had a means of creating a zone that was assigned to a container,
> a second zone for shared data between a set of containers.  For shared data,
> the time the pages are being allocated is at page fault time. At that point,
> the faulting VMA is known and you also know if it's MAP_SHARED or not.

Well, but MAP_SHARED does not necessarily mean shared outside of the
container, right?  Somebody wishing to get around resource limits could
just MAP_SHARED any data they wished to use, and get it into the shared
area before their initial use, right?

How do normal read/write()s fit into this?

> > There's a conflict between the resize granularity of the zones, and the
> > storage space their lookup consumes.  We'd want a container to have a
> > limited ability to fill up memory with stuff like the dcache, so we'd
> > appear to need to put the dentries inside the software zone.  But, that
> > gets us to our inability to evict arbitrary dentries. 
> 
> Stuff like shrinking dentry caches is already pretty course-grained.
> Last I looked, we couldn't even shrink within a specific node, let alone
> a zone or a specific dentry. This is a separate problem.

I shouldn't have used dentries as an example.  I'm just saying that if
we end up (or can end up with) with a whole ton of these software zones,
we might have troubles storing them.  I would imagine the issue would
come immediately from lack of page->flags to address lots of them.

> > After a while,
> > would containers tend to pin an otherwise empty zone into place?  We
> > could resize it, but what is the cost of keeping zones that can be
> > resized down to a small enough size that we don't mind keeping it there?
> > We could merge those "orphaned" zones back into the shared zone.
> 
> Merging "orphaned" zones back into the "main" zone would seem a sensible
> choice.

OK, but merging wouldn't be possible if they're not physically
contiguous.  I guess this could be worked around by just calling it a
shared zone, no matter where it is physically.

> > Were there any requirements about physical contiguity? 
> 
> For the lookup to software zone to be efficient, it would be easiest to have
> them as MAX_ORDER_NR_PAGES contiguous. This would avoid having to break the
> existing assumptions in the buddy allocator about MAX_ORDER_NR_PAGES
> always being in the same zone.

I was mostly wondering about zones spanning other zones.  We _do_
support this today, and it might make quite a bit more merging possible.

> > If we really do bind a set of processes strongly to a set of memory on a
> > set of nodes, then those really do become its home NUMA nodes.  If the
> > CPUs there get overloaded, running it elsewhere will continue to grab
> > pages from the home.  Would this basically keep us from ever being able
> > to move tasks around a NUMA system?
> 
> Moving the tasks around would not be easy. It would require a new zone
> to be created based on the new NUMA node and all the data migrated. hmm

I know we _try_ to avoid this these days, but I'm not sure how taking it
away as an option will affect anything.

-- Dave

