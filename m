Return-Path: <linux-kernel-owner+w=401wt.eu-S1752581AbYL2RnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbYL2RnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 12:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbYL2RnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 12:43:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55939 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbYL2RnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 12:43:06 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@osdl.org
cc: dhowells@redhat.com, rgetz@blackfin.uclinux.org, vapier.adi@gmail.com,
       lethal@linux-sh.org, bernds_cb1@t-online.de,
       linux-kernel@vger.kernel.org
Subject: [GIT] NOMMU mmap changes
Date: Mon, 29 Dec 2008 17:42:06 +0000
Message-ID: <21562.1230572526@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Can you pull the attached request please?  It makes the following changes:

 (1) Discard the askedalloc and realalloc variables from NOMMU mmap as nothing
     uses the values computed.

 (2) Stop ELF-FDPIC and FLAT binary formats from using kobjsize() by stopping
     them from attempting to expand the stack segments to use the full amount
     allocated (we'd like to get rid of kobjsize()).

 (3) Support XIP on initramfs.  This is simply a matter of using truncate() to
     pre-size the files ramfs files so generated so that they are constructed
     from contiguous pages, and so can be mapped in place with NOMMU mmap().

 (4) Make NOMMU VMAs per-MM as for MMU-mode Linux.  Whilst this uses more
     memory, it also fixes a couple of bugs:

     (*) The SYSV SHM nattch count for a segment must reflect the number of
     	 attachments made, but since attachments were being shared, it did
     	 not.

     (*) The VMA's vm_mm is set to point to the parent mm by an exec'ing
     	 process when VM_EXECUTABLE is specified, but vm_mm was being shared
     	 by all the processes that shared that VMA.

 (5) NOMMU private non-shared mmaps are allocated with alloc_pages() rather
     than kmalloc(), and without using __GFP_COMP.  This makes handling of
     the pages in an mmap() region simpler.  Excess space can be trimmed after
     allocation (configurable in /proc/sys).

 (6) A new struct (vm_region) is introduced to track mapped regions in NOMMU
     mode, and to handle the sharing of backing stores.  This required the
     vm_region structs of PowerPC and ARM to be renamed (the former patch has
     been pulled via the ppc tree).

 (7) NOMMU VMAs are attached to their parent inodes as for MMU VMAs.

 (8) munmap() may do a partial unmapping.

 (9) Core dumping for ELF-FDPIC is simplified as the NOMMU- and MMU-mode code
     behaves more similarly.

(10) /proc/maps provided in NOMMU mode now shows the regions allocated rather
     than the common VMA list.  /proc/meminfo now shows the amount of RAM
     currently allocated to private copies by private mmaps.

These patches have had some soak time in linux-next.  I've also applied them
as-are to the latest merge window and tested that on my FRV board.

David
---
The following changes since commit 1bda71282ded6a2e09a2db7c8884542fb46bfd4f:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../ieee1394/linux1394-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-2.6-nommu.git master

David Howells (8):
      NOMMU: Rename PowerPC's struct vm_region
      NOMMU: Rename ARM's struct vm_region
      NOMMU: Delete askedalloc and realalloc variables
      NOMMU: Make VMAs per MM as for MMU-mode linux
      NOMMU: Improve procfs output using per-MM VMAs
      FDPIC: Don't attempt to expand the userspace stack to fill the space allocated
      FLAT: Don't attempt to expand the userspace stack to fill the space allocated
      NOMMU: Support XIP on initramfs

Matt Mackall (1):
      shmem: remove unused shmem_get_unmapped_area

Paul Mundt (2):
      NOMMU: Make mmap allocation page trimming behaviour configurable.
      NOMMU: Teach kobjsize() about VMA regions.

 Documentation/nommu-mmap.txt       |   31 +-
 Documentation/sysctl/vm.txt        |   18 +
 arch/arm/include/asm/mmu.h         |    1 -
 arch/arm/mm/dma-mapping.c          |   28 +-
 arch/blackfin/include/asm/mmu.h    |    1 -
 arch/blackfin/kernel/ptrace.c      |    6 +-
 arch/blackfin/kernel/traps.c       |   11 +-
 arch/frv/kernel/ptrace.c           |   11 +-
 arch/h8300/include/asm/mmu.h       |    1 -
 arch/m68knommu/include/asm/mmu.h   |    1 -
 arch/powerpc/lib/dma-noncoherent.c |   24 +-
 arch/sh/include/asm/mmu.h          |    1 -
 fs/binfmt_elf_fdpic.c              |   35 +--
 fs/binfmt_flat.c                   |   34 +-
 fs/proc/internal.h                 |    2 -
 fs/proc/meminfo.c                  |    6 +
 fs/proc/nommu.c                    |   71 ++--
 fs/proc/task_nommu.c               |  120 +++--
 include/asm-frv/mmu.h              |    1 -
 include/asm-m32r/mmu.h             |    1 -
 include/linux/mm.h                 |   26 +-
 include/linux/mm_types.h           |   19 +-
 init/initramfs.c                   |    1 +
 ipc/shm.c                          |   12 +
 kernel/fork.c                      |    4 +-
 kernel/sysctl.c                    |   14 +
 lib/Kconfig.debug                  |    7 +
 mm/mmap.c                          |   10 +
 mm/nommu.c                         | 1027 ++++++++++++++++++++++++------------
 mm/tiny-shmem.c                    |   11 -
 30 files changed, 994 insertions(+), 541 deletions(-)
