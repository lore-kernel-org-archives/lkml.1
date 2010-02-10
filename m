Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab0BJRXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:23:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755114Ab0BJRXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/40] KVM updates for the 2.6.34 merge window (batch 1/4)
Date: Wed, 10 Feb 2010 19:22:29 +0200
Message-Id: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first of four batches of patches for the 2.6.34 merge window.  KVM
changes for this cycle include:

 - rdtscp support
 - powerpc server-class updates
 - much improved large-guest scaling (now up to 64 vcpus)
 - improved guest fpu handling
 - initial Hyper-V emulation
 - better swapping with EPT
 - 1GB pages on Intel
 - x86 emulator fixes

as well as the usual assortment of random fixes and improvements.

Alexander Graf (5):
  KVM: powerpc: Move vector to irqprio resolving to separate function
  KVM: powerpc: Improve DEC handling
  KVM: powerpc: Remove AGGRESSIVE_DEC
  KVM: powerpc: Change maintainer
  KVM: PPC: Fix typo in rebolting code

Avi Kivity (14):
  KVM: MMU: Report spte not found in rmap before BUG()
  KVM: VMX: Move some cr[04] related constants to vmx.c
  KVM: Add accessor for reading cr4 (or some bits of cr4)
  KVM: VMX: Make guest cr4 mask more conservative
  KVM: VMX: When using ept, allow the guest to own cr4.pge
  KVM: VMX: Fold ept_update_paging_mode_cr4() into its caller
  KVM: Disentangle mmu notifiers and coalesced_mmio registration
  KVM: Add include guards for coalesced_mmio.h
  KVM: Remove ifdefs from mmu notifier initialization
  KVM: Add KVM_MMIO kconfig item
  KVM: Simplify coalesced mmio initialization
  KVM: Bump maximum vcpu count to 64
  KVM: Fill out ftrace exit reason strings
  KVM: avoid taking ioapic mutex for non-ioapic EOIs

Eddie Dong (1):
  KVM: x86: make double/triple fault promotion generic to all
    exceptions

Joerg Roedel (1):
  KVM: SVM: Adjust tsc_offset only if tsc_unstable

Marcelo Tosatti (12):
  KVM: x86: raise TSS exception for NULL CS and SS segments
  KVM: modify memslots layout in struct kvm
  KVM: modify alias layout in x86s struct kvm_arch
  KVM: split kvm_arch_set_memory_region into prepare and commit
  KVM: introduce gfn_to_pfn_memslot
  KVM: use gfn_to_pfn_memslot in kvm_iommu_map_pages
  KVM: introduce kvm->srcu and convert kvm_set_memory_region to SRCU
    update
  KVM: use SRCU for dirty log
  KVM: x86: switch kvm_set_memory_alias to SRCU update
  KVM: convert io_bus to SRCU
  KVM: switch vcpu context to use SRCU
  KVM: convert slots_lock to a mutex

Sheng Yang (6):
  KVM: VMX: Trap and invalid MWAIT/MONITOR instruction
  KVM: VMX: Remove redundant variable
  KVM: Extended shared_msr_global to per CPU
  x86: Raise vsyscall priority on hotplug notifier chain
  KVM: Add cpuid_update() callback to kvm_x86_ops
  KVM: VMX: Add instruction rdtscp support for guest

Wu Fengguang (1):
  KVM: trivial document fixes

 Documentation/kvm/api.txt          |   12 +-
 MAINTAINERS                        |    2 +-
 arch/ia64/kvm/Kconfig              |    1 +
 arch/ia64/kvm/kvm-ia64.c           |   47 +++--
 arch/powerpc/include/asm/kvm_ppc.h |    1 +
 arch/powerpc/kvm/Kconfig           |    1 +
 arch/powerpc/kvm/book3s.c          |   51 +++--
 arch/powerpc/kvm/book3s_64_slb.S   |    2 +-
 arch/powerpc/kvm/booke.c           |    5 +
 arch/powerpc/kvm/emulate.c         |    3 +
 arch/powerpc/kvm/powerpc.c         |   18 ++-
 arch/s390/kvm/kvm-s390.c           |   25 ++-
 arch/s390/kvm/kvm-s390.h           |   10 +-
 arch/x86/include/asm/kvm_host.h    |   30 ++--
 arch/x86/include/asm/vmx.h         |    2 +
 arch/x86/kernel/vsyscall_64.c      |    3 +-
 arch/x86/kvm/Kconfig               |    1 +
 arch/x86/kvm/i8254.c               |    8 +-
 arch/x86/kvm/i8259.c               |    4 +-
 arch/x86/kvm/kvm_cache_regs.h      |   12 +
 arch/x86/kvm/mmu.c                 |   39 ++--
 arch/x86/kvm/mmu.h                 |    5 +-
 arch/x86/kvm/svm.c                 |   31 ++-
 arch/x86/kvm/vmx.c                 |  210 ++++++++++++++-----
 arch/x86/kvm/x86.c                 |  424 ++++++++++++++++++++++++------------
 include/linux/kvm.h                |    2 +-
 include/linux/kvm_host.h           |   66 ++++---
 virt/kvm/Kconfig                   |    3 +
 virt/kvm/assigned-dev.c            |    8 +-
 virt/kvm/coalesced_mmio.c          |   39 +++-
 virt/kvm/coalesced_mmio.h          |   15 ++
 virt/kvm/eventfd.c                 |   18 +-
 virt/kvm/ioapic.c                  |   23 ++-
 virt/kvm/ioapic.h                  |    1 +
 virt/kvm/iommu.c                   |   27 ++-
 virt/kvm/kvm_main.c                |  357 ++++++++++++++++++++----------
 36 files changed, 1023 insertions(+), 483 deletions(-)

