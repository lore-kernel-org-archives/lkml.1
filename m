Return-Path: <linux-kernel-owner+w=401wt.eu-S1763254AbZCaSAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763254AbZCaSAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 14:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759648AbZCaSAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 14:00:40 -0400
Received: from gw.goop.org ([64.81.55.164]:53696 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715AbZCaSAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 14:00:38 -0400
Message-ID: <49D25A42.7060300@goop.org>
Date: Tue, 31 Mar 2009 11:00:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: [GIT PULL] Xen for 2.6.30 #2
References: <49D1209A.9000800@goop.org>
In-Reply-To: <49D1209A.9000800@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the second (and final) set of Xen updates for 2.6.30.  This set 
contains Xen dom0 support, which includes:

    * adding to the existing Xen support to allow running as a
      privileged domain
    * some hooks into the apic setup code to allow Xen interrupts to get
      routed properly
    * a Xen implementation of the DMA ops API
    * a Xen MTRR driver
    * other misc things

These changes only hook into init/setup code, and will have no runtime 
performance impact on native execution when CONFIG_PARAVIRT is enabled, 
and are completely compiled out without it.

These changes are more or less unchanged since their first posting about 
3-4 weeks ago.  The x86 parts have been reviewed (mainly by HPA) and 
considered not too objectionable.

I merged current linux-2.6 into my branch and sorted out the couple of 
minor conflicts with recent changes, and merged in the previous changes 
(the domU stuff).  So if you pull this, you'll get the previous pull 
with it; otherwise you can pull them in order.  Uh, I couldn't work out 
how to generate a shortlog+diffstat with just the dom0 set of changes, 
so it includes some of the previous pull-requests changes as well.

(I realize now the previous pull request didn't have much of an 
overview.  The quick take is:

    * allow lazy mmu updates to be preempted, removing some
      preempt_disable sections
    * general Xen core updates
    * add /sys/hypervisor support
    * add a /dev/xen/evtchn driver so usermode can wait for and send Xen
      events)


Thanks,
    J

The following changes since commit 15f7176eb1cccec0a332541285ee752b935c1c85:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git for-linus/xen/merged

Alex Nixon (8):
      Xen: Add virt_to_pfn helper function
      xen: Don't disable the I/O space
      xen: Allow unprivileged Xen domains to create iomap pages
      Xen: Rename the balloon lock
      xen: Add xen_create_contiguous_region
      x86/PCI: Clean up pci_cache_line_size
      x86/PCI: Enable scanning of all pci functions
      Xen/x86/PCI: Add support for the Xen PCI subsytem

Christophe Saout (1):
      paravirtualize IO permission bitmap

Gerd Hoffmann (2):
      xen: set pirq name to something useful.
      xen: fix legacy irq setup, make ioapic-less machines work.

Hannes Eder (1):
      NULL noise: arch/x86/xen/smp.c

Ian Campbell (13):
      xen: resume interrupts before system devices.
      xen: disable PAT
      xen/dom0: Use host E820 map
      xen: implement XENMEM_machphys_mapping
      xen: clear reserved bits in l3 entries given in the initial pagetables
      xen: pre-initialize legacy irqs early
      xen: add /proc/xen/xsd_{kva,port} to xenfs
      swiotlb: range_needs_mapping should take a physical address.
      swiotlb: do not use sg_virt()
      xen swiotlb: fixup swiotlb is chunks smaller than MAX_CONTIG_ORDER
      xen: add hooks for mapping phys<->bus addresses in swiotlb
      xen/swiotlb: add hook for swiotlb_arch_range_needs_mapping
      xen: enable swiotlb for xen domain 0.

Jeremy Fitzhardinge (74):
      mm: disable preemption in apply_to_pte_range
      x86/paravirt: remove lazy mode in interrupts
      x86/pvops: replace arch_enter_lazy_cpu_mode with arch_start_context_switch
      x86/paravirt: flush pending mmu updates on context switch
      x86/paravirt: finish change from lazy cpu to context switch start/end
      x86/paravirt: allow preemption with lazy mmu mode
      mm: allow preemption in apply_to_pte_range
      x86/paravirt: use percpu_ rather than __get_cpu_var
      xen: disable preempt for leave_lazy_mmu
      xen: separate p2m allocation from setting
      xen: split construction of p2m mfn tables from registration
      xen: clean up xen_load_gdt
      xen: make xen_load_gdt simpler
      xen: remove xen_load_gdt debug
      xen: mask XSAVE from cpuid
      x86-64: remove PGE from must-have feature list
      x86-64: non-paravirt systems always has PSE and PGE
      xen/mmu: some early pagetable cleanups
      xen/mmu: weaken flush_tlb_other test
      xen: set _PAGE_NX in __supported_pte_mask before pagetable construction
      xen: clean up gate trap/interrupt constants
      xen dom0: Make hvc_xen console work for dom0.
      xen: add "capabilities" file
      xen/dom0: use _PAGE_IOMAP in ioremap to do machine mappings
      xen: allow enable use of VGA console on dom0
      xen/dom0: add XEN_DOM0 config option
      x86: make /dev/mem mappings _PAGE_IOMAP
      x86: don't need "changed" parameter for set_io_bitmap()
      xen: checkpatch cleanups
      xen/dom0: handle acpi lapic parsing in Xen dom0
      xen: hook io_apic read/write operations
      xen: create dummy ioapic mapping
      xen: implement pirq type event channels
      x86/io_apic: add get_nr_irqs_gsi()
      xen/apic: identity map gsi->irqs
      xen: direct irq registration to pirq event channels
      xen: bind pirq to vector and event channel
      xen: don't setup acpi interrupt unless there is one
      xen: use acpi_get_override_irq() to get triggering for legacy irqs
      xen: initialize irq 0 too
      xen: dynamically allocate irq & event structures
      xen: disable MSI
      xen/apic: checkpatch cleanups
      xen: set cpu_callout_mask to make mtrr work
      xen: set cpu_callout_mask in cpu_up
      Merge branch 'for-linus/xen/xenfs' into for-linus/xen/dom0/xenfs
      xen: add xen_set_domain_pte()
      xen: add privcmd driver
      xen/privcmd: create address space to allow writable mmaps
      xen: add variable hypercall caller
      xen/privcmd: clean up ioctls into their own functions
      xen/privcmd: rearrange mmap ioctl to share code
      xen/xenfs: set_page_dirty is supposed to return true if it dirties
      xen/privcmd: print SIGBUS faults
      xen/privcmd: make sure vma is ours before doing anything to it
      xenbus: export xen_store_interface for xenfs
      xen/xenfs: checkpatch cleanups
      x86/pci: make sure _PAGE_IOMAP it set on pci mappings
      xen/pci: clean up Kconfig a bit
      xen: make sure swiotlb allocation is physically contigious
      xen/swiotlb: use dma_alloc_from_coherent to get device coherent memory
      swiotlb: use swiotlb_alloc_boot to allocate emergency pool
      xen/swiotlb: improve comment on gfp flags in xen_alloc_coherent()
      xen/swiotlb: add sync functions
      pci-swiotlb: fix "no return in non-void function"
      pci-swiotlb: remove __weak vs __weak binding
      xen: checkpatch cleanups
      x86: define arch_vm_get_page_prot to set _PAGE_IOMAP on VM_IO vmas
      agp: use more dma-ops-like operations for agp memory
      agp/intel: use dma_alloc_coherent for special cursor memory
      Merge branches 'for-linus/xen/dom0/apic', 'for-linus/xen/dom0/pci', 'for-linus/xen/dom0/drm', 'for-linus/xen/dom0/mtrr' and 'for-linus/xen/dom0/xenfs' into for-linus/xen/dom0/master
      Merge commit 'origin/master' into for-linus/xen/merged
      xen/swiotlb: update to new new dma_ops
      xen/apic: add pin argument to setup_ioapic_entry()

Juan Quintela (2):
      xen dom0: Initialize xenbus for dom0.
      xen dom0: Set up basic IO permissions for dom0.

Mark McLoughlin (5):
      xen mtrr: Use specific cpu_has_foo macros instead of generic cpu_has()
      xen mtrr: Use generic_validate_add_page()
      xen mtrr: Implement xen_get_free_region()
      xen mtrr: Add xen_{get,set}_mtrr() implementations
      xen mtrr: Kill some unnecessary includes

Stephen Tweedie (2):
      xen dom0: Add support for the platform_ops hypercall
      xen mtrr: Add mtrr_ops support for Xen mtrr

 arch/x86/Kconfig                         |    4 +
 arch/x86/include/asm/agp.h               |   15 +-
 arch/x86/include/asm/io.h                |    2 +
 arch/x86/include/asm/io_apic.h           |    7 +
 arch/x86/include/asm/paravirt.h          |   31 ++-
 arch/x86/include/asm/pat.h               |    5 +
 arch/x86/include/asm/pci.h               |    8 +-
 arch/x86/include/asm/pci_x86.h           |    2 +
 arch/x86/include/asm/pgtable.h           |    5 +
 arch/x86/include/asm/processor.h         |    4 +
 arch/x86/include/asm/required-features.h |    8 +-
 arch/x86/include/asm/thread_info.h       |    2 +
 arch/x86/include/asm/xen/hypercall.h     |   25 ++
 arch/x86/include/asm/xen/interface.h     |    6 +-
 arch/x86/include/asm/xen/interface_32.h  |    5 +
 arch/x86/include/asm/xen/interface_64.h  |   13 +-
 arch/x86/include/asm/xen/iommu.h         |   12 +
 arch/x86/include/asm/xen/page.h          |   19 +-
 arch/x86/include/asm/xen/pci.h           |   13 +
 arch/x86/kernel/acpi/boot.c              |   18 +-
 arch/x86/kernel/apic/io_apic.c           |   37 ++-
 arch/x86/kernel/cpu/mtrr/Makefile        |    1 +
 arch/x86/kernel/cpu/mtrr/amd.c           |    1 +
 arch/x86/kernel/cpu/mtrr/centaur.c       |    1 +
 arch/x86/kernel/cpu/mtrr/cyrix.c         |    1 +
 arch/x86/kernel/cpu/mtrr/generic.c       |    1 +
 arch/x86/kernel/cpu/mtrr/main.c          |   11 +-
 arch/x86/kernel/cpu/mtrr/mtrr.h          |    7 +
 arch/x86/kernel/cpu/mtrr/xen.c           |  120 ++++++++
 arch/x86/kernel/ioport.c                 |   29 ++-
 arch/x86/kernel/kvm.c                    |    2 +-
 arch/x86/kernel/paravirt.c               |   57 ++--
 arch/x86/kernel/pci-dma.c                |    3 +
 arch/x86/kernel/pci-swiotlb.c            |   31 ++-
 arch/x86/kernel/process.c                |   27 +--
 arch/x86/kernel/process_32.c             |    2 +-
 arch/x86/kernel/process_64.c             |    2 +-
 arch/x86/kernel/vmi_32.c                 |   20 +-
 arch/x86/lguest/boot.c                   |   16 +-
 arch/x86/mm/fault.c                      |    6 +-
 arch/x86/mm/highmem_32.c                 |    2 -
 arch/x86/mm/iomap_32.c                   |    1 -
 arch/x86/mm/pageattr.c                   |   14 -
 arch/x86/mm/pat.c                        |    7 +-
 arch/x86/mm/pgtable.c                    |   10 +
 arch/x86/pci/Makefile                    |    1 +
 arch/x86/pci/common.c                    |   18 +-
 arch/x86/pci/i386.c                      |    3 +
 arch/x86/pci/init.c                      |    6 +
 arch/x86/pci/xen.c                       |   51 +++
 arch/x86/xen/Kconfig                     |   40 +++
 arch/x86/xen/Makefile                    |    4 +-
 arch/x86/xen/apic.c                      |   60 ++++
 arch/x86/xen/enlighten.c                 |  150 ++++++++--
 arch/x86/xen/mmu.c                       |  490 +++++++++++++++++++++++++++---
 arch/x86/xen/mmu.h                       |    3 +
 arch/x86/xen/pci.c                       |   86 ++++++
 arch/x86/xen/setup.c                     |   50 +++-
 arch/x86/xen/smp.c                       |    6 +-
 arch/x86/xen/vga.c                       |   68 ++++
 arch/x86/xen/xen-ops.h                   |   21 ++-
 drivers/char/agp/intel-agp.c             |   24 +-
 drivers/char/hvc_xen.c                   |   99 ++++--
 drivers/pci/Makefile                     |    2 +
 drivers/pci/pci.h                        |    2 -
 drivers/pci/xen-iommu.c                  |  331 ++++++++++++++++++++
 drivers/xen/balloon.c                    |   15 +-
 drivers/xen/events.c                     |  276 ++++++++++++++++-
 drivers/xen/manage.c                     |    5 +-
 drivers/xen/xenbus/xenbus_probe.c        |   34 ++-
 drivers/xen/xenfs/Makefile               |    3 +-
 drivers/xen/xenfs/privcmd.c              |  442 +++++++++++++++++++++++++++
 drivers/xen/xenfs/super.c                |  115 +++++++-
 drivers/xen/xenfs/xenfs.h                |    3 +
 drivers/xen/xenfs/xenstored.c            |   67 ++++
 include/asm-frv/pgtable.h                |    4 +-
 include/asm-generic/pgtable.h            |   21 +-
 include/linux/pci.h                      |    6 +
 include/xen/Kbuild                       |    1 +
 include/xen/events.h                     |   24 ++
 include/xen/interface/memory.h           |   92 ++++++
 include/xen/interface/platform.h         |  222 ++++++++++++++
 include/xen/interface/xen.h              |   41 +++
 include/xen/privcmd.h                    |   80 +++++
 include/xen/swiotlb.h                    |   20 ++
 include/xen/xen-ops.h                    |    6 +
 kernel/sched.c                           |    2 +-
 lib/swiotlb.c                            |    5 +-
 88 files changed, 3276 insertions(+), 336 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/iommu.h
 create mode 100644 arch/x86/include/asm/xen/pci.h
 create mode 100644 arch/x86/kernel/cpu/mtrr/xen.c
 create mode 100644 arch/x86/pci/xen.c
 create mode 100644 arch/x86/xen/apic.c
 create mode 100644 arch/x86/xen/pci.c
 create mode 100644 arch/x86/xen/vga.c
 create mode 100644 drivers/pci/xen-iommu.c
 create mode 100644 drivers/xen/xenfs/privcmd.c
 create mode 100644 drivers/xen/xenfs/xenstored.c
 create mode 100644 include/xen/Kbuild
 create mode 100644 include/xen/interface/platform.h
 create mode 100644 include/xen/privcmd.h
 create mode 100644 include/xen/swiotlb.h


