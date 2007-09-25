Return-Path: <linux-kernel-owner+w=401wt.eu-S1751566AbXIYXnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbXIYXnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbXIYXmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:42:51 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:57655 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751585AbXIYXmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:42:49 -0400
Message-Id: <20070925234204.546836393@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 25 Sep 2007 16:42:04 -0700
From: Christoph Lameter <clameter@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [00/17] Virtual Compound Page Support V1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

RFC->V1
- Support for all compound functions for virtual compound pages
  (including the compound_nth_page() necessary for LBS mmap support)
- Fix various bugs
- Fix i386 build

Currently there is a strong tendency to avoid larger page allocations in
the kernel because of past fragmentation issues and the current
defragmentation methods are still evolving. It is not clear to what extend
they can provide reliable allocations for higher order pages (plus the
definition of "reliable" seems to be in the eye of the beholder).

We use vmalloc allocations in many locations to provide a safe
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

- Reliability as long as the vmalloc layer can provide virtual mappings.

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


The patch set is also available via git from the largeblock git tree via

git pull
  git://git.kernel.org/pub/scm/linux/kernel/git/christoph/largeblocksize.git
    vcompound

-- 
