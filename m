Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbXISDhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbXISDhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 23:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXISDgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 23:36:44 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54920 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751782AbXISDgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 23:36:42 -0400
From: Christoph Lameter <clameter@sgi.com>
Message-Id: <20070919033605.785839297@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Sep 2007 20:36:05 -0700
To: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: [00/17] [RFC] Virtual Compound Page Support
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there is a strong tendency to avoid larger page allocations in
the kernel because of past fragmentation issues and the current
defragmentation methods are still evolving. It is not clear to what extend
they can provide reliable allocations for higher order pages (plus the
definition of "reliable" seems to be in the eye of the beholder).

Currently we use vmalloc allocations in many locations to provide a safe
way to allocate larger arrays. That is due to the danger of higher order
allocations failing. Virtual Compound pages allow the use of regular
page allocator allocations that will fall back only if there is an actual
problem with acquiring a higher order page.

This patch set provides a way for a higher page allocation to fall back.
Instead of a physically contiguous page a virtually contiguous page
is provided. The functionality of the vmalloc layer is used to provide
the necessary page tables and control structures to establish a virtually
contiguous area.

Advantages:

- If higher order allocations are failing then virtual compound pages
  consisting of a series of order-0 pages can stand in for those
  allocations.

- "Reliability" as long as the vmalloc layer can provide virtual mappings.

- Ability to reduce the use of vmalloc layer significantly by using
  physically contiguous memory instead of virtual contiguous memory.
  Most uses of vmalloc() can be converted to page allocator calls.

- The use of physically contiguous memory instead of vmalloc may allow the
  use larger TLB entries thus reducing TLB pressure. Also reduces the need
  for page table walks.

Disadvantages:

- In order to use fall back the logic accessing the memory must be
  aware that the memory could be backed by a virtual mapping and take
  precautions. virt_to_page() and page_address() may not work and
  vmalloc_to_page() and vmalloc_address() (introduced through this
  patch set) may have to be called.

- Virtual mappings are less efficient than physical mappings.
  Performance will drop once virtual fall back occurs.

- Virtual mappings have more memory overhead. vm_area control structures
  page tables, page arrays etc need to be allocated and managed to provide
  virtual mappings.

The patchset provides this functionality in stages. Stage 1 introduces
the basic fall back mechanism necessary to replace vmalloc allocations
with

	alloc_page(GFP_VFALLBACK, order, ....)

which signifies to the page allocator that a higher order is to be found
but a virtual mapping may stand in if there is an issue with fragmentation.

Stage 1 functionality does not allow allocation and freeing of virtual
mappings from interrupt contexts.

The stage 1 series ends with the conversion of a few key uses of vmalloc
in the VM to alloc_pages() for the allocation of sparsemems memmap table
and the wait table in each zone. Other uses of vmalloc could be converted
in the same way.


Stage 2 functionality enhances the fallback even more allowing allocation
and frees in interrupt context.

SLUB is then modified to use the virtual mappings for slab caches
that are marked with SLAB_VFALLBACK. If a slab cache is marked this way
then we drop all the restraints regarding page order and allocate
good large memory areas that fit lots of objects so that we rarely
have to use the slow paths.

Two slab caches--the dentry cache and the buffer_heads--are then flagged
that way. Others could be converted in the same way.

The patch set also provides a debugging aid through setting

	CONFIG_VFALLBACK_ALWAYS

If set then all GFP_VFALLBACK allocations fall back to the virtual
mappings. This is useful for verification tests. The test of this
patch set was done by enabling that options and compiling a kernel.


Stage 3 functionality could be the adding of support for the large
buffer size patchset. Not done yet and not sure if it would be useful
to do.

Much of this patchset may only be needed for special cases in which the
existing defragmentation methods fail for some reason. It may be better to
have the system operate without such a safety net and make sure that the
page allocator can return large orders in a reliable way.

The initial idea for this patchset came from Nick Piggin's fsblock
and from his arguments about reliability and guarantees. Since his
fsblock uses the virtual mappings I think it is legitimate to
generalize the use of virtual mappings to support higher order
allocations in this way. The application of these ideas to the large
block size patchset etc are straightforward. If wanted I can base
the next rev of the largebuffer patchset on this one and implement
fallback.

Contrary to Nick, I still doubt that any of this provides a "guarantee".
Have said that I have to deal with various failure scenarios in the VM
daily and I'd certainly like to see it work in a more reliable manner.

IMHO getting rid of the various workarounds to deal with the small 4k
pages and avoiding additional layers that group these pages in subsystem
specific ways is something that can simplify the kernel and make the
kernel more reliable overall.

If people feel that a virtual fall back is needed then so be it. Maybe
we can shed our security blanket later when the approaches to deal
with fragmentation have matured.

The patch set is also available via git from the largeblock git tree via

git pull
  git://git.kernel.org/pub/scm/linux/kernel/git/christoph/largeblocksize.git
    vcompound

-- 
