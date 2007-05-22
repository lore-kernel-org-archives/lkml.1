Return-Path: <linux-kernel-owner+w=401wt.eu-S935212AbXEVPWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935212AbXEVPWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758407AbXEVPTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:19:25 -0400
Received: from host217-46-209-99.in-addr.btopenworld.com ([217.46.209.99]:4983
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761162AbXEVPTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:19:11 -0400
Message-Id: <20070522140941.802382212@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 22 May 2007 15:09:41 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [patch 00/33] xen: Xen paravirt_ops implementation
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the Xen implementation for the paravirt_ops interface.  The
series is based on 2.6.22-rc1-mm1, and I think its ready to be cooked
in -mm with a view to being merged in 2.6.23.

The first part of the series is some small changes to the core kernel.
Apart from the new code added in "Allocate and free vmalloc areas"
(posted many times before), they are simply a few one-liners around
the place.

	paravirt: add an "mm" argument to alloc_pt
	paravirt: add a hook for once the allocator is ready
	paravirt: increase IRQ limit
	paravirt: unstatic leave_mm
	paravirt: unstatic smp_store_cpu_info
	paravirt: make siblingmap functions visible
	paravirt: export __supported_pte_mask
	xen: Allocate and free vmalloc areas

 arch/i386/kernel/setup.c                           |    2 
 arch/i386/kernel/smp.c                             |    5 -
 arch/i386/kernel/smpboot.c                         |    8 -
 arch/i386/kernel/vsyscall-note.S                   |   28 +++++
 arch/i386/mm/init.c                                |    1 
 include/asm-i386/mach-default/irq_vectors_limits.h |    2 
 include/asm-i386/mmu_context.h                     |    2 
 include/asm-i386/paravirt.h                        |    8 +
 include/asm-i386/setup.h                           |    4 
 include/asm-i386/smp.h                             |    5 +
 include/linux/vmalloc.h                            |    4 
 mm/vmalloc.c                                       |   53 +++++++++++
 12 files changed, 114 insertions(+), 8 deletions(-)

The rest of the series is the Xen implementation itself.  This
includes the core of Xen itself, plus the Xenbus virtual bus, and
virtual console, disk and net drivers. The vast majority of it is new
code, with a few changes to non-Xen files to:

  1. Makefile/Kconfig build stuff
  2. add a new ELF note to the VDSO to select a Xen-optimised libc
  3. a chunk of new code in entry.S, to handle upcalls from Xen,
     which in turn need to jump into other entry.S labels
  4. Define a proper label for PG_owner_priv_1
  5. Define a major for the Xen virtual block device
  6. Increate NR_IRQ to 224 when CONFIG_PARAVIRT is enabled, even if
     there's no IO APIC.

	xen: Add nosegneg capability to the vsyscall page notes
	xen: Add Xen interface header files
	xen: Core Xen implementation
	xen: Xen virtual mmu
	xen: xen event channels
	xen: xen time implementation
	xen: xen configuration
	xen: add pinned page flag
	xen: Complete pagetable pinning for Xen
	xen: ignore RW mapping of RO pages in pagetable_init
	xen: Account for time stolen by Xen
	xen: Implement xen_sched_clock
	xen: Xen SMP guest support
	xen: Add support for preemption
	xen: lazy-mmu operations
	xen: hack to prevent bad segment register reload
	xen: Use the hvc console infrastructure for Xen console
	xen: Add Xen grant table support
	xen: Add the Xenbus sysfs and virtual device hotplug driver.
	xen: Add Xen virtual block device driver.
	xen: Add the Xen virtual network device driver.
	xen: Xen machine operations
	xen: handle external requests for shutdown, reboot and sysrq
	xen: Place vcpu_info structure into per-cpu memory, if possible
	xen: Attempt to patch inline versions of common operations

 arch/i386/Kconfig                     |    2 
 arch/i386/Makefile                    |    3 

 arch/i386/kernel/asm-offsets.c        |    7 
 arch/i386/kernel/entry.S              |   71 
 arch/i386/kernel/head.S               |    5 
 arch/i386/kernel/vmlinux.lds.S        |    1 

 arch/i386/xen/Kconfig                 |   11 
 arch/i386/xen/Makefile                |    4 
 arch/i386/xen/enlighten.c             | 1134 +++++++++++++
 arch/i386/xen/events.c                |  588 +++++++
 arch/i386/xen/features.c              |   29 
 arch/i386/xen/manage.c                |  143 +
 arch/i386/xen/mmu.c                   |  599 +++++++
 arch/i386/xen/mmu.h                   |   60 
 arch/i386/xen/multicalls.c            |  115 +
 arch/i386/xen/multicalls.h            |   45 
 arch/i386/xen/setup.c                 |   93 +
 arch/i386/xen/smp.c                   |  405 ++++
 arch/i386/xen/time.c                  |  585 +++++++
 arch/i386/xen/xen-asm.S               |  114 +
 arch/i386/xen/xen-head.S              |   36 
 arch/i386/xen/xen-ops.h               |   70 

 arch/x86_64/kernel/early_printk.c     |    5 

 drivers/Makefile                      |    2 
 drivers/block/Kconfig                 |    8 
 drivers/block/Makefile                |    1 
 drivers/block/xen-blkfront.c          |  988 +++++++++++

 drivers/char/Kconfig                  |    8 
 drivers/char/Makefile                 |    1 
 drivers/char/hvc_xen.c                |  159 +

 drivers/net/Kconfig                   |   12 
 drivers/net/Makefile                  |    1 
 drivers/net/xen-netfront.c            | 1995 ++++++++++++++++++++++++

 drivers/xen/Makefile                  |    2 
 drivers/xen/grant-table.c             |  582 +++++++
 drivers/xen/xenbus/Makefile           |    7 
 drivers/xen/xenbus/xenbus_client.c    |  569 ++++++
 drivers/xen/xenbus/xenbus_comms.c     |  233 ++
 drivers/xen/xenbus/xenbus_comms.h     |   46 
 drivers/xen/xenbus/xenbus_probe.c     |  935 +++++++++++
 drivers/xen/xenbus/xenbus_probe.h     |   74 
 drivers/xen/xenbus/xenbus_xs.c        |  861 ++++++++++

 include/asm-i386/irq.h                |    1 
 include/asm-i386/xen/hypercall.h      |  431 +++++
 include/asm-i386/xen/hypervisor.h     |   73 
 include/asm-i386/xen/interface.h      |  187 ++
 include/linux/major.h                 |    2 
 include/linux/page-flags.h            |    5 

 include/xen/events.h                  |   48 
 include/xen/features.h                |   23 
 include/xen/grant_table.h             |  107 +
 include/xen/hvc-console.h             |    6 
 include/xen/interface/elfnote.h       |  133 +
 include/xen/interface/event_channel.h |  195 ++
 include/xen/interface/features.h      |   43 
 include/xen/interface/grant_table.h   |  375 ++++
 include/xen/interface/io/blkif.h      |   94 +
 include/xen/interface/io/console.h    |   23 
 include/xen/interface/io/netif.h      |  156 +
 include/xen/interface/io/ring.h       |  260 +++
 include/xen/interface/io/xenbus.h     |   42 
 include/xen/interface/io/xs_wire.h    |   87 +
 include/xen/interface/memory.h        |  145 +
 include/xen/interface/physdev.h       |  145 +
 include/xen/interface/sched.h         |   77 
 include/xen/interface/vcpu.h          |  177 ++
 include/xen/interface/version.h       |   60 
 include/xen/interface/xen.h           |  446 +++++
 include/xen/page.h                    |  178 ++
 include/xen/xenbus.h                  |  234 ++
 70 files changed, 14361 insertions(+), 1 deletion(-)

-- 

