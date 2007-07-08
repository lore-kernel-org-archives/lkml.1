Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbXGHDuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbXGHDuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 23:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756176AbXGHDuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 23:50:20 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49236 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755404AbXGHDuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 23:50:17 -0400
Message-Id: <20070708034952.022985379@sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 07 Jul 2007 20:49:52 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@vger.kernel.org
Cc: suresh.b.siddha@intel.com
Cc: corey.d.gough@intel.com
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org
Subject: [patch 00/10] [RFC] SLUB patches for more functionality, performance and maintenance
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This series here contains a number of patches that need some discussion or
evaluation. They apply on top of 2.6.22-rc6-mm1 + slub patches already
in mm.

1. Page allocator pass through

SLOB does pass through all larger kmalloc requests directly to the page
allocator. The advantage is that the allocator overhead is eliminated
and that we do not need to provide kmalloc slabs >= PAGE_SIZE.
This patch does the same thing in SLUB.

For allocation whose size is know the call to the slab may be converted to
a call to the page allocator at compile time.

The result of doing so is also that the behavior of SLUB for pagesize
and higher kmalloc allocation will conform to SLAB. Meaning large
kmalloc allocations are no longer debuggable and are guaranteed to be
page aligned.

Do we want this?

2. A series of performance enhancements patches

The patches improve the producer / consumer scenario. If objects are
always allocated on one processor and released on another then both
will use distinct cachelines to store their information in order to
avoid a bouncing cacheline.

In order to do so we have to introduce a per cpu structure to keep
per cpu allocation lists in distinct cachelines from the remote free
information in the page struct. If we introduce a per cpu structure
then we also need to allocate that in a NUMA aware fashion from the
local node.

Having a per cpu structure allows to avoid the use of certain fields
in the page struct which in turn allows us to avoid using page->mapping
and increasing the maximum number of objects per slab. More optimizations
become possible by shifting information from the kmem_cache structure
that is used in the hotpath to the per cpu structure thereby minimizing
cacheline coverage.

Finally there is an implementation of slab_alloc/slab_free using a cmpxchg
instead of current interrupt enable disable approach. This was inspired by
LTTng's approach. A cmpxchg is less costly than interrupt enabe/disable
but means more complexity in managing the resulting race conditions.
The disadvantage is that the allocation / free paths become very
complex and fragile.

All of these patches need to be evaluated as to what impact they
have on a variety of loads.

3. Removal of SLOB and SLAB.

We would like to consolidate and only have one slab allocator in the future.
Two patches are included that remove SLOB and SLAB. There is only minimal
justification for retaining SLOB. So I think we could remove SLOB for 2.6.23.

SLAB is the reference that SLUB must be measured against to avoid regressions.
On the other hand it will be a problem to support new functionality like
Slab defragmentation since its design makes it difficult to implement comparable
features. So I think that we need to keep SLAB around for one more cycle and
then we may be able to get rid of it. Or we can keep it in the tree for
awhile and produce more and more shims for new slab functionality.

-- 
