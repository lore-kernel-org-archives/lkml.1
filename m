Return-Path: <linux-kernel-owner+w=401wt.eu-S1759588AbZCMRAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588AbZCMRAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759283AbZCMRAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:00:33 -0400
Received: from gw.goop.org ([64.81.55.164]:57362 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753923AbZCMRAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:00:32 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       David Airlie <airlied@linux.ie>
Subject: [GIT PULL] Xen dom0 hardware access support
Date: Fri, 13 Mar 2009 09:59:45 -0700
Message-Id: <1236963612-14287-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series of patches enables the dom0 guest to access and control hardware.  The changes fall into three groups:

1. DMA and swiotlb updates
 - Implement Xen versions of all the DMA API mapping ops
 - Put Xen-specific bits into the swiotlb hooks where needed, and define
    Xen+swiotlb set of ops
 
2. DRM updates
 - make sure _PAGE_IOMAP is set on VM_IO mappings, as created by remap_pfn_range
 - use swiotlb_bus_to_phys/phys_to_bus to implement phys_to_gart/gart_to_phys
   (despite the swiotlb_* name, the functions are fairly generic, at least on x86)
 - Use dma_alloc_coherent for alloc_gatt_pages, to make sure they're physically
   contiguous
 - Likewise, use dma_alloc_coherent for the special i8xx ARGB cursor memory

3. MTRR improvements (to make /proc/mtrr fully functional)
   Complete the MTRR implementation introduced in the xen/dom0/core series

The following changes since commit 089faa06184f85284ba6c4164dd7b4741ca5d5c5:
  Jeremy Fitzhardinge (1):
        x86: don't need "changed" parameter for set_io_bitmap()

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git push/xen/dom0/hardware

Alex Nixon (7):
      xen: Don't disable the I/O space
      xen: Allow unprivileged Xen domains to create iomap pages
      Xen: Rename the balloon lock
      xen: Add xen_create_contiguous_region
      x86/PCI: Clean up pci_cache_line_size
      x86/PCI: Enable scanning of all pci functions
      Xen/x86/PCI: Add support for the Xen PCI subsytem

Ian Campbell (4):
      xen swiotlb: fixup swiotlb is chunks smaller than MAX_CONTIG_ORDER
      xen: add hooks for mapping phys<->bus addresses in swiotlb
      xen/swiotlb: add hook for swiotlb_arch_range_needs_mapping
      xen: enable swiotlb for xen domain 0.

Jeremy Fitzhardinge (12):
      x86/pci: make sure _PAGE_IOMAP it set on pci mappings
      xen/pci: clean up Kconfig a bit
      xen: make sure swiotlb allocation is physically contigious
      xen/swiotlb: use dma_alloc_from_coherent to get device coherent memory
      swiotlb: use swiotlb_alloc_boot to allocate emergency pool
      xen/swiotlb: improve comment on gfp flags in xen_alloc_coherent()
      xen/swiotlb: add sync functions
      xen: set callout_map to make mtrr work
      x86: define arch_vm_get_page_prot to set _PAGE_IOMAP on VM_IO vmas
      agp: use more dma-ops-like operations for agp memory
      agp/intel: use dma_alloc_coherent for special cursor memory
      Merge branches 'push/xen/dom0/drm', 'push/xen/dom0/mtrr' and 'push/xen/dom0/pci' into push/xen/dom0/hardware

Mark McLoughlin (5):
      xen mtrr: Use specific cpu_has_foo macros instead of generic cpu_has()
      xen mtrr: Use generic_validate_add_page()
      xen mtrr: Implement xen_get_free_region()
      xen mtrr: Add xen_{get,set}_mtrr() implementations
      xen mtrr: Kill some unneccessary includes

 arch/x86/Kconfig                 |    4 +
 arch/x86/include/asm/agp.h       |   15 ++-
 arch/x86/include/asm/pci.h       |    8 +-
 arch/x86/include/asm/pci_x86.h   |    2 +
 arch/x86/include/asm/pgtable.h   |    3 +
 arch/x86/include/asm/xen/iommu.h |   12 ++
 arch/x86/kernel/cpu/mtrr/mtrr.h  |    2 +
 arch/x86/kernel/cpu/mtrr/xen.c   |  101 +++++++++---
 arch/x86/kernel/pci-dma.c        |    3 +
 arch/x86/kernel/pci-swiotlb.c    |   28 +++-
 arch/x86/mm/pgtable.c            |   10 ++
 arch/x86/pci/Makefile            |    1 +
 arch/x86/pci/common.c            |   18 ++-
 arch/x86/pci/i386.c              |    3 +
 arch/x86/pci/init.c              |    6 +
 arch/x86/pci/xen.c               |   52 ++++++
 arch/x86/xen/Kconfig             |    3 +
 arch/x86/xen/enlighten.c         |    6 +-
 arch/x86/xen/mmu.c               |  225 +++++++++++++++++++++++++-
 arch/x86/xen/setup.c             |    3 -
 arch/x86/xen/smp.c               |    1 +
 drivers/char/agp/intel-agp.c     |   26 ++--
 drivers/pci/Makefile             |    2 +
 drivers/pci/xen-iommu.c          |  331 ++++++++++++++++++++++++++++++++++++++
 drivers/xen/balloon.c            |   15 +--
 include/xen/interface/memory.h   |   50 ++++++
 include/xen/swiotlb.h            |   19 +++
 include/xen/xen-ops.h            |    6 +
 lib/swiotlb.c                    |    5 +-
 29 files changed, 890 insertions(+), 70 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/iommu.h
 create mode 100644 arch/x86/pci/xen.c
 create mode 100644 drivers/pci/xen-iommu.c
 create mode 100644 include/xen/swiotlb.h
