Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbZI3PLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbZI3PLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbZI3PLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:11:16 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:46828 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754676AbZI3PLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:11:14 -0400
Date: Wed, 30 Sep 2009 11:06:04 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mel@csn.ul.ie>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 2/4] slqb: Record what node is local to a
 kmem_cache_cpu
In-Reply-To: <20090930144117.GA17906@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0909301053550.9450@gentwo.org>
References: <1253624054-10882-1-git-send-email-mel@csn.ul.ie> <1253624054-10882-3-git-send-email-mel@csn.ul.ie> <84144f020909220638l79329905sf9a35286130e88d0@mail.gmail.com> <20090922135453.GF25965@csn.ul.ie> <84144f020909221154x820b287r2996480225692fad@mail.gmail.com>
 <20090922185608.GH25965@csn.ul.ie> <20090930144117.GA17906@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009, Mel Gorman wrote:

> Ok, so I spent today looking at this again. The problem is not with faulty
> drain logic as such. As frees always place an object on a remote list
> and the allocation side is often (but not always) allocating a new page,
> a significant number of objects in the free list are the only object
> in a page. SLQB drains based on the number of objects on the free list,
> not the number of pages. With many of the pages having only one object,
> the freelists are pinning a lot more memory than expected.  For example,
> a watermark to drain of 512 could be pinning 2MB of pages.

No good. So we are allocating new pages from somewhere allocating a
single object and putting them on the freelist where we do not find them
again. This is bad caching behavior as well.

> The drain logic could be extended to track not only the number of objects on
> the free list but also the number of pages but I really don't think that is
> desirable behaviour. I'm somewhat running out of sensible ideas for dealing
> with this but here is another go anyway that might be more palatable than
> tracking what a "local" node is within the slab.

SLUB avoids that issue by having a "current" page for a processor. It
allocates from the current page until its exhausted. It can use fast path
logic both for allocations and frees regardless of the pages origin. The
node fallback is handled by the page allocator and that one is only
involved when a new slab page is needed.

SLAB deals with it in fallback_alloc(). It scans the nodes in zonelist
order for free objects of the kmem_cache and then picks up from the
nearest node. Ugly but it works. SLQB would have to do something similar
since it also has the per node object bins that SLAB has.

The local node for a memoryless node may not exist at all since there may
be multiple nodes at the same distance to the memoryless node. So at
mininum you would have to manage a set of local nodes. If you have the set
then you also would need to consider memory policies. During bootup you
would have to simulate the interleave mode in effect. After bootup you
would have to use the tasks policy.

This all points to major NUMA issues in SLQB. This is not arch specific.
SLQB cannot handle memoryless nodes at this point.

> This patch alters the allocation path. If the allocation from local
> lists fails and the local node is memoryless, an attempt will be made to
> allocate from the remote lists before going to the page allocator.

Are the allocation attempts from the remote lists governed by memory
policies? Otherwise you may create imbalances on neighboring nodes.
