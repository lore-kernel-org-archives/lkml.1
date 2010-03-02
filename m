Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab0CBWdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 17:33:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:48234 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab0CBWdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 17:33:52 -0500
Date: Tue, 2 Mar 2010 22:32:23 GMT
Message-Id: <201003022232.o22MWNgl007014@hera.kernel.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Johannes Weiner <hannes@saeurebad.de>, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>,
       Yinghai Lu <yinghai@kernel.org>
Subject: [GIT PULL] x86/bootmem: get rid of bootmem on the x86 platform
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 02 Mar 2010 22:32:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This patchset allows the earlyres range allocator to replace bootmem.
We have already pushed slab/slub initialization earlier, so the
earlyres allocator can take up the remaining bootmem allocations.
This reduces the total number of allocators used at different phases
of the x86 boot from 4 to 3 (brk, earlyres, full allocator).

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-bootmem-for-linus

H. Peter Anvin (2):
      Merge remote branch 'linus/master' into x86/bootmem
      ibmphp: Rename add_range() to add_bus_range() to avoid conflict

Yinghai Lu (29):
      x86: Move range related operation to one file
      x86/pci: Use resource_size_t in update_res
      x86/pci: AMD one chain system to use pci read out res
      x86/pci: Use u64 instead of size_t in amd_bus.c
      x86/pci: Add cap_resource()
      x86/pci: Enable pci root res read out for 32bit too
      x86: Change range end to start+size
      x86: Print out RAM buffer information
      x86: Call early_res_to_bootmem one time
      x86: Introduce max_early_res and early_res_count
      x86: Dynamically increase early_res array size
      x86: Make early_node_mem get mem > 4 GB if possible
      x86: Only call dma32_reserve_bootmem 64bit !CONFIG_NUMA
      x86: Make 64 bit use early_res instead of bootmem before slab
      sparsemem: Put usemap for one node together
      sparsemem: Put mem map for one node together.
      x86: Move bios page reserve early to head32/64.c
      x86: Separate early_res related code from e820.c
      x86: Add find_early_area_size
      x86: Move back find_e820_area to e820.c
      early_res: Enhance check_and_double_early_res
      x86: Make 32bit support NO_BOOTMEM
      Move round_up/down to kernel.h
      x86: Add find_fw_memmap_area
      core: Move early_res from arch/x86 to kernel/
      x86: Fix non-bootmem compilation on PowerPC
      early_res: Add free_early_partial()
      sparsemem: Fix compilation on PowerPC
      early_res: Need to save the allocation name in drop_range_partial()

 arch/mips/mm/init.c                |    2 +-
 arch/score/mm/init.c               |    2 +-
 arch/x86/Kconfig                   |   15 +
 arch/x86/include/asm/e820.h        |    5 +-
 arch/x86/include/asm/page_types.h  |    1 -
 arch/x86/include/asm/pci.h         |    2 +
 arch/x86/include/asm/pci_64.h      |    2 -
 arch/x86/include/asm/proto.h       |   10 -
 arch/x86/kernel/cpu/mtrr/cleanup.c |  208 ++-----------
 arch/x86/kernel/e820.c             |  357 +++--------------------
 arch/x86/kernel/head32.c           |   10 +
 arch/x86/kernel/mmconf-fam10h_64.c |    7 +-
 arch/x86/kernel/pci-dma.c          |   13 +-
 arch/x86/kernel/setup.c            |   29 ++-
 arch/x86/kernel/setup_percpu.c     |    6 +
 arch/x86/mm/init_32.c              |    7 +-
 arch/x86/mm/init_64.c              |    9 +-
 arch/x86/mm/ioremap.c              |   37 ---
 arch/x86/mm/numa_32.c              |    3 +
 arch/x86/mm/numa_64.c              |   97 +++---
 arch/x86/pci/Makefile              |    3 +-
 arch/x86/pci/amd_bus.c             |  127 +++------
 arch/x86/pci/bus_numa.c            |   25 +-
 arch/x86/pci/bus_numa.h            |    9 +-
 arch/x86/pci/i386.c                |    4 -
 drivers/pci/hotplug/ibmphp_res.c   |   14 +-
 include/linux/bootmem.h            |    7 +
 include/linux/early_res.h          |   23 ++
 include/linux/kernel.h             |   10 +
 include/linux/mm.h                 |   14 +
 include/linux/mmzone.h             |    2 +
 include/linux/range.h              |   30 ++
 kernel/Makefile                    |    3 +-
 kernel/early_res.c                 |  578 ++++++++++++++++++++++++++++++++++++
 kernel/range.c                     |  163 ++++++++++
 kernel/resource.c                  |   13 +
 mm/Kconfig                         |    4 +
 mm/bootmem.c                       |  195 ++++++++++++-
 mm/page_alloc.c                    |   61 ++++-
 mm/sparse-vmemmap.c                |   76 +++++-
 mm/sparse.c                        |  196 +++++++++++--
 41 files changed, 1611 insertions(+), 768 deletions(-)
 create mode 100644 include/linux/early_res.h
 create mode 100644 include/linux/range.h
 create mode 100644 kernel/early_res.c
 create mode 100644 kernel/range.c
