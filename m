Return-Path: <linux-kernel-owner+w=401wt.eu-S1759801AbYFYEos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759801AbYFYEos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756343AbYFYEhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:36 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37464 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755202AbYFYEhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:22 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 00 of 36] x86/paravirt: groundwork for 64-bit Xen support
Message-Id: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:18:56 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This series lays the groundwork for 64-bit Xen support.  It follows
the usual pattern: a series of general cleanups and improvements,
followed by additions and modifications needed to slide Xen in.

Most of the 64-bit paravirt-ops work has already been done and
integrated for some time, so the changes are relatively minor.

Interesting and potentially hazardous changes in this series are:

"paravirt/x86_64: move __PAGE_OFFSET to leave a space for hypervisor"

This moves __PAGE_OFFSET up by 16 GDT slots, from 0xffff810000000000
to 0xffff880000000000.  I have no general justification for this: the
specific reason is that Xen claims the first 16 kernel GDT slots for
itself, and we must move up the mapping to make room.  In the process
I parameterised the compile-time construction of the initial
pagetables in head_64.S to cope with it.

"x86_64: adjust mapping of physical pagetables to work with Xen"
"x86_64: create small vmemmap mappings if PSE not available"

This rearranges the construction of the physical mapping so that it
works with Xen.  This affects three aspects of the code:
 1. It can't use pse, so it will only use pse if the processor
    supports it.
 2. It never replaces an existing mapping, so it can just extend the
    early boot-provided mappings (either from head_64.S or the Xen domain
    builder).
 3. It makes sure that any page is iounmapped before attaching it to the 
    pagetable to avoid having writable aliases of pagetable pages.

The logical structure of the code is more or less unchanged, and still
works fine in the native case.

vmemmap mapping is likewise changed.

"x86_64: PSE no longer a hard requirement."

Because booting under Xen doesn't set PSE, it's no longer a hard
requirement for the kernel.  PSE will be used whereever possible.

Overall diffstat:
 arch/x86/Kconfig                    |    7 +
 arch/x86/ia32/ia32entry.S           |   37 +++--
 arch/x86/kernel/aperture_64.c       |    4 
 arch/x86/kernel/asm-offsets_32.c    |    2 
 arch/x86/kernel/asm-offsets_64.c    |    5 
 arch/x86/kernel/cpu/common_64.c     |    3 
 arch/x86/kernel/e820.c              |    2 
 arch/x86/kernel/early-quirks.c      |    2 
 arch/x86/kernel/entry_32.S          |    8 -
 arch/x86/kernel/entry_64.S          |   14 +-
 arch/x86/kernel/head64.c            |    5 
 arch/x86/kernel/head_64.S           |   17 +-
 arch/x86/kernel/machine_kexec_64.c  |    2 
 arch/x86/kernel/paravirt.c          |   24 +++
 arch/x86/kernel/paravirt_patch_32.c |    4 
 arch/x86/kernel/paravirt_patch_64.c |    9 -
 arch/x86/kernel/pci-calgary_64.c    |    4 
 arch/x86/kernel/pci-dma.c           |    4 
 arch/x86/kernel/pci-gart_64.c       |    4 
 arch/x86/kernel/pci-swiotlb_64.c    |    2 
 arch/x86/kernel/process_64.c        |   50 +++++--
 arch/x86/kernel/setup_64.c          |   24 +--
 arch/x86/kernel/vmi_32.c            |    4 
 arch/x86/kernel/vsyscall_64.c       |   12 -
 arch/x86/mm/fault.c                 |   73 +++--------
 arch/x86/mm/init_64.c               |  234 +++++++++++++++++++++---------------
 arch/x86/mm/ioremap.c               |    7 -
 arch/x86/mm/k8topology_64.c         |    4 
 arch/x86/mm/numa_64.c               |    4 
 arch/x86/mm/pgtable.c               |  176 ++++++++++++++++-----------
 arch/x86/mm/srat_64.c               |    2 
 arch/x86/power/hibernate_64.c       |    2 
 arch/x86/xen/enlighten.c            |    9 +
 include/asm-x86/cmpxchg_64.h        |   37 +++++
 include/asm-x86/desc_defs.h         |    4 
 include/asm-x86/elf.h               |    2 
 include/asm-x86/fixmap_64.h         |   16 ++
 include/asm-x86/io.h                |   13 ++
 include/asm-x86/io_32.h             |   12 -
 include/asm-x86/irqflags.h          |   19 ++
 include/asm-x86/mmu_context.h       |   32 ++++
 include/asm-x86/mmu_context_32.h    |   28 ----
 include/asm-x86/mmu_context_64.h    |   18 --
 include/asm-x86/msr.h               |    5 
 include/asm-x86/page_64.h           |   11 +
 include/asm-x86/paravirt.h          |  141 ++++++++++++++++++---
 include/asm-x86/pgalloc.h           |    4 
 include/asm-x86/pgtable.h           |   20 +++
 include/asm-x86/pgtable_32.h        |   20 ---
 include/asm-x86/pgtable_64.h        |    8 -
 include/asm-x86/processor.h         |    2 
 include/asm-x86/required-features.h |    2 
 include/asm-x86/setup.h             |    4 
 include/asm-x86/system.h            |    7 -
 54 files changed, 734 insertions(+), 431 deletions(-)


Thanks,
	   J

