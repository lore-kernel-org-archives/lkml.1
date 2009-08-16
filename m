Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbZHPJi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbZHPJi5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbZHPJi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:38:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45333 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbZHPJaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:10 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/48] KVM updates for 2.6.32 merge window (1/4)
Date: Sun, 16 Aug 2009 12:29:20 +0300
Message-Id: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the first of four batches containing the KVM changes for 2.6.32.
The 2.6.32 cycle will see scalability improvements, support for new hardware
features, improvements in nested svm support, and eventfd-based
infrastructure for connecting kvm guests to components in the host kernel,
host userspace, and other guests.  Also of note is conversion to the new
trace infrastructure and x2apic emulation.

Andre Przywara (1):
  KVM: SVM: use explicit 64bit storage for sysenter values

Avi Kivity (14):
  KVM: x86 emulator: Implement zero-extended immediate decoding
  KVM: x86 emulator: fix jmp far decoding (opcode 0xea)
  KVM: Move common KVM Kconfig items to new file virt/kvm/Kconfig
  KVM: SVM: Fold kvm_svm.h info svm.c
  KVM: VMX: Avoid duplicate ept tlb flush when setting cr3
  KVM: VMX: Simplify pdptr and cr3 management
  KVM: Cache pdptrs
  KVM: VMX: Fix reporting of unhandled EPT violations
  KVM: Calculate available entries in coalesced mmio ring
  KVM: Reorder ioctls in kvm.h
  KVM: VMX: Move rmode structure to vmx-specific code
  KVM: MMU: Fix is_dirty_pte()
  KVM: MMU: Adjust pte accessors to explicitly indicate guest or shadow
    pte
  KVM: MMU: s/shadow_pte/spte/

Christian Ehrhardt (4):
  KVM: s390: infrastructure to kick vcpus out of guest state
  KVM: s390: fix signal handling
  KVM: s390: streamline memslot handling
  KVM: remove redundant declarations

Christoph Hellwig (1):
  KVM: cleanup arch/x86/kvm/Makefile

Gleb Natapov (6):
  KVM: VMX: Properly handle software interrupt re-injection in real
    mode
  KVM: Drop interrupt shadow when single stepping should be done only
    on VMX
  KVM: Introduce kvm_vcpu_is_bsp() function.
  KVM: Use pointer to vcpu instead of vcpu_id in timer code.
  KVM: Break dependency between vcpu index in vcpus array and vcpu_id.
  KVM: Use macro to iterate over vcpus.

Gregory Haskins (4):
  KVM: irqfd
  KVM: Clean up coalesced_mmio destruction
  KVM: cleanup io_device code
  KVM: do not register i8254 PIO regions until we are initialized

Huang Ying (1):
  KVM: Add MCE support

Jan Kiszka (2):
  KVM: Allow PIT emulation without speaker port
  KVM: Cleanup LAPIC interface

Jaswinder Singh Rajput (2):
  KVM: Replace MSR_IA32_TIME_STAMP_COUNTER with MSR_IA32_TSC of
    msr-index.h
  KVM: Use MSR names in place of address

Jes Sorensen (1):
  KVM: ia64: Correct itc_offset calculations

Liu Yu (3):
  KVM: ppc: e500: Move to Book-3e MMU definitions
  KVM: ppc: e500: Directly pass pvr to guest
  KVM: ppc: e500: Add MMUCFG and PVR emulation

Marcelo Tosatti (4):
  KVM: Grab pic lock in kvm_pic_clear_isr_ack
  KVM: move coalesced_mmio locking to its own device
  KVM: introduce irq_lock, use it to protect ioapic
  KVM: switch irq injection/acking data structures to irq_lock

Mark McLoughlin (1):
  KVM: fix cpuid E2BIG handling for extended request types

Nitin A Kamble (1):
  KVM: VMX: Support Unrestricted Guest feature

Sheng Yang (2):
  KVM: Downsize max support MSI-X entry to 256
  KVM: No disable_irq for MSI/MSI-X interrupt on device assignment

Stephen Rothwell (1):
  KVM: powerpc: fix some init/exit annotations

 arch/ia64/include/asm/kvm_host.h    |    1 -
 arch/ia64/kvm/Kconfig               |    8 +-
 arch/ia64/kvm/kvm-ia64.c            |   41 ++---
 arch/ia64/kvm/vcpu.c                |    4 +-
 arch/powerpc/include/asm/kvm_host.h |    1 -
 arch/powerpc/kvm/44x.c              |    4 +-
 arch/powerpc/kvm/Kconfig            |    3 +-
 arch/powerpc/kvm/booke.c            |    2 +-
 arch/powerpc/kvm/e500.c             |    7 +-
 arch/powerpc/kvm/e500_emulate.c     |    3 +
 arch/powerpc/kvm/e500_tlb.c         |   10 +-
 arch/powerpc/kvm/e500_tlb.h         |    6 +-
 arch/powerpc/kvm/emulate.c          |    4 +-
 arch/powerpc/kvm/powerpc.c          |   16 +-
 arch/s390/include/asm/kvm_host.h    |    9 +-
 arch/s390/kvm/Kconfig               |    6 +-
 arch/s390/kvm/gaccess.h             |   23 ++--
 arch/s390/kvm/intercept.c           |   18 ++-
 arch/s390/kvm/kvm-s390.c            |   80 ++++-----
 arch/s390/kvm/kvm-s390.h            |   32 ++++-
 arch/s390/kvm/sigp.c                |   60 ++++---
 arch/x86/include/asm/kvm.h          |    1 +
 arch/x86/include/asm/kvm_host.h     |   33 ++--
 arch/x86/include/asm/vmx.h          |    1 +
 arch/x86/kvm/Kconfig                |    9 +-
 arch/x86/kvm/Makefile               |   32 ++--
 arch/x86/kvm/i8254.c                |   70 +++++---
 arch/x86/kvm/i8254.h                |    2 +-
 arch/x86/kvm/i8259.c                |   28 ++-
 arch/x86/kvm/kvm_cache_regs.h       |    9 +
 arch/x86/kvm/kvm_svm.h              |   51 ------
 arch/x86/kvm/kvm_timer.h            |    2 +-
 arch/x86/kvm/lapic.c                |   47 +++---
 arch/x86/kvm/mmu.c                  |  127 +++++++-------
 arch/x86/kvm/mmu.h                  |    2 +-
 arch/x86/kvm/paging_tmpl.h          |   40 ++--
 arch/x86/kvm/svm.c                  |   86 ++++++++--
 arch/x86/kvm/timer.c                |    2 +-
 arch/x86/kvm/vmx.c                  |  210 ++++++++++++++++-------
 arch/x86/kvm/x86.c                  |  305 ++++++++++++++++++++++++++------
 arch/x86/kvm/x86_emulate.c          |   17 ++-
 include/linux/kvm.h                 |   57 ++++++-
 include/linux/kvm_host.h            |   54 ++++++-
 virt/kvm/Kconfig                    |   14 ++
 virt/kvm/coalesced_mmio.c           |   44 +++--
 virt/kvm/coalesced_mmio.h           |    1 +
 virt/kvm/eventfd.c                  |  329 +++++++++++++++++++++++++++++++++++
 virt/kvm/ioapic.c                   |   31 +++-
 virt/kvm/iodev.h                    |   29 ++-
 virt/kvm/irq_comm.c                 |   40 ++++-
 virt/kvm/kvm_main.c                 |  130 ++++++++------
 51 files changed, 1502 insertions(+), 639 deletions(-)
 delete mode 100644 arch/x86/kvm/kvm_svm.h
 create mode 100644 virt/kvm/Kconfig
 create mode 100644 virt/kvm/eventfd.c

