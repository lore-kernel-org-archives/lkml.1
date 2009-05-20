Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbZETSZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbZETSZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbZETSYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:24:51 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:36825 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643AbZETSYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:24:48 -0400
Subject: [RFC v2][PATCH 00/35] consolidate pte mapping functions across all architectures
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 20 May 2009 11:24:45 -0700
Message-Id: <20090520182445.D7B49A7C@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should address all the comments made on the last set.

Is there a linux-next tree into which it would be appropriate
to integrate these?  They should probably have at least a bit
of incubation time there or in -mm.
--

I want to use pte_offset_map() and pte_unmap() for nefarious
purposes.  But, there are too many dang implementations
in all the architectures.  These patches set out to
consolidate them.

These are mostly one patch per arch to make it easier for
the individual arch maintainers to go and look at only the
bits that they care about.

In the end, we go from 34 implementations of
pte_offset_map{_nested}() and pte_unmap{_nested}() to only
three:
1. all highpte implementations (x86, ppc32, frv)
2. all direct-mapped pte implementations (everything almost)
3. SUN3-based m68k

The SUN3 one is special because it uses kmap() instead of
kmap_atomic() for which it is wholly unique.

The diffstat is long, but here's the summary.  Pretty cool
considering that 41 of these lines are just for #includes.
 67 files changed, 62 insertions(+), 196 deletions(-)

The steps are as follows, and should be bisectable:
1. Break out all the functions into a new asm/ptemap.h and
   include it in place of the original functions.
2. Move linux/mm.h arch-independent pte mapping code to
   linux/ptemap.h, include asm/ptemap.h there
3. Include linux/ptemap.h directly at all use sites
   (only 39 of these kernel-wide)
4. Standardize all the implementations to use
   pte_offset_kernel() as the basis for pte_offset_map()
   whenever possible.
5. Create asm-generic/ptemap.h and consolidate all the
   architectures that share the pte_offset_kernel()
   implementations.
6. Consolidate the three HIGHPTE implementations (x86,
   frv, ppc64) in asm-generic/ptemap.h.  
7. Remove the direct asm/ptemap.h includes.

This passes my compile tests on x86, x86_64, sparc, sparc64
s390, ppc64, ppc32, m68k, arm and alpha.

The pte_offset_kernel() migrations help fix the issue
that there are two basical variants of pte_offset_map()
which is the same for pte_offset_kernel() for !HIGHPTE
(this has a few casts removed for clarity):
 
	#define pte_offset_map(dir, address)   \
	       (page_address(pmd_page(*dir)) + pte_index(address))
and
	#define pte_offset_map(dir, address)   \
	       (pmd_page_vaddr(*dir) + pte_index(addr))

As you can see, the pte_index() is exactly the same.  The
only question is if

	page_address(pmd_page(*dir))
and
	pmd_page_vaddr(*dir)

are equivalent.  I claim they are and that the pmd_page_vaddr()
version is superior since it doesn't need to do the conversion
to a 'struct page' and back.

Let's look at those with pmd_page_vaddr() and pmd_page expanded:

	page_address(pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT))

	__va(pmd_val(pmd) & PTE_PFN_MASK)

pmd pages are never in highmem, so page_address() is always
effectively lowmem_page_address().  Epanding that, we have:

	__va(page_to_pfn(pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT)) << PAGE_SHIFT)

doing page_to_pfn(pfn_to_page()) is a noop, so that simplifies
to:
	__va((pmd_val(pmd) >> PAGE_SHIFT) << PAGE_SHIFT)
which we're comparing to:
	__va(pmd_val(pmd) & PTE_PFN_MASK)

the '>> PAGE_SHIFT << PAGE_SHIFT' just has the effect of
masking out some low bits, which is exactly what
'& PTE_PFN_MASK' does.

 67 files changed, 62 insertions(+), 196 deletions(-)

 arch/alpha/include/asm/pgtable.h         |    5 +----
 arch/arm/include/asm/pgtable.h           |    8 ++------
 arch/arm/kernel/traps.c                  |    1 +
 arch/arm/mm/fault-armv.c                 |    1 +
 arch/arm/mm/fault.c                      |    1 +
 arch/arm/mm/pgd.c                        |    1 +
 arch/cris/include/asm/pgtable.h          |    6 ------
 arch/frv/include/asm/highmem.h           |    5 +++++
 arch/frv/include/asm/pgtable.h           |   17 +----------------
 arch/frv/kernel/gdb-stub.c               |    2 +-
 arch/frv/mm/fault.c                      |    2 +-
 arch/ia64/include/asm/pgtable.h          |    4 ----
 arch/ia64/mm/hugetlbpage.c               |    1 +
 arch/m32r/include/asm/pgtable.h          |    5 -----
 arch/m68k/include/asm/motorola_pgtable.h |    5 -----
 arch/m68k/include/asm/sun3_pgtable.h     |    5 -----
 arch/m68k/mm/kmap.c                      |    1 +
 arch/mips/include/asm/pgtable-32.h       |   10 +---------
 arch/mips/include/asm/pgtable-64.h       |   10 +---------
 arch/mips/mm/tlb-r4k.c                   |    1 +
 arch/mips/mm/tlb-r8k.c                   |    1 +
 arch/mn10300/include/asm/pgtable.h       |    6 ------
 arch/mn10300/mm/cache.c                  |    1 +
 arch/parisc/include/asm/pgtable.h        |    7 -------
 arch/parisc/kernel/cache.c               |    1 +
 arch/parisc/kernel/pci-dma.c             |    2 ++
 arch/powerpc/Kconfig                     |    4 ++++
 arch/powerpc/include/asm/pgtable-ppc32.h |    8 --------
 arch/powerpc/include/asm/pgtable-ppc64.h |    5 -----
 arch/powerpc/mm/pgtable_32.c             |    1 +
 arch/powerpc/mm/pgtable_64.c             |    1 +
 arch/powerpc/mm/subpage-prot.c           |    1 +
 arch/s390/include/asm/pgtable.h          |    4 ----
 arch/s390/lib/uaccess_pt.c               |    1 +
 arch/sh/include/asm/pgtable_32.h         |    5 -----
 arch/sh/include/asm/pgtable_64.h         |    5 -----
 arch/sh/mm/cache-sh5.c                   |    1 +
 arch/sh/mm/hugetlbpage.c                 |    1 +
 arch/sparc/include/asm/pgtable_32.h      |   15 ---------------
 arch/sparc/include/asm/pgtable_64.h      |   14 +++++---------
 arch/sparc/kernel/signal32.c             |    1 +
 arch/sparc/mm/fault_64.c                 |    1 +
 arch/sparc/mm/generic_64.c               |    1 +
 arch/sparc/mm/hugetlbpage.c              |    1 +
 arch/sparc/mm/io-unit.c                  |    1 +
 arch/sparc/mm/iommu.c                    |    1 +
 arch/um/include/asm/pgtable.h            |    6 ------
 arch/um/kernel/tlb.c                     |    1 +
 arch/x86/include/asm/pgtable_32.h        |   17 -----------------
 arch/x86/include/asm/pgtable_64.h        |    6 ------
 arch/x86/kernel/vm86_32.c                |    1 +
 arch/x86/mm/gup.c                        |    1 +
 arch/xtensa/include/asm/pgtable.h        |    6 ------
 fs/proc/task_mmu.c                       |    1 +
 include/linux/mm.h                       |   26 --------------------------
 lib/ioremap.c                            |    1 +
 mm/fremap.c                              |    1 +
 mm/memory.c                              |    1 +
 mm/mempolicy.c                           |    1 +
 mm/migrate.c                             |    1 +
 mm/mincore.c                             |    1 +
 mm/mprotect.c                            |    1 +
 mm/mremap.c                              |    1 +
 mm/pagewalk.c                            |    1 +
 mm/rmap.c                                |    1 +
 mm/swapfile.c                            |    1 +
 mm/vmalloc.c                             |    1 +
 67 files changed, 62 insertions(+), 196 deletions(-)
