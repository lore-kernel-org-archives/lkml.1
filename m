Return-Path: <linux-kernel-owner+w=401wt.eu-S1752138AbZHSNDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbZHSNDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbZHSNCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:02:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50544 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751862AbZHSNCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:44 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/47] KVM updates for 2.6.32 merge window (2/4)
Date: Wed, 19 Aug 2009 16:01:56 +0300
Message-Id: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Second batch of the KVM patch queue.  Happy reviewing.

Alexander Graf (4):
  x86: Add definition for IGNNE MSR
  KVM: Implement MSRs used by Hyper-V
  KVM: SVM: Implement INVLPGA
  KVM: SVM: Improve nested interrupt injection

Andre Przywara (10):
  KVM: Move performance counter MSR access interception to generic x86
    path
  KVM: Allow emulation of syscalls instructions on #UD
  KVM: x86 emulator: Add missing EFLAGS bit definitions
  KVM: x86 emulator: Prepare for emulation of syscall instructions
  KVM: x86 emulator: add syscall emulation
  KVM: x86 emulator: Add sysenter emulation
  KVM: x86 emulator: Add sysexit emulation
  KVM: ignore AMDs HWCR register access to set the FFDIS bit
  KVM: ignore reads from AMDs C1E enabled MSR
  KVM: introduce module parameter for ignoring unknown MSRs accesses

Avi Kivity (3):
  KVM: Return to userspace on emulation failure
  KVM: VMX: Only reload guest cr2 if different from host cr2
  KVM: SVM: Don't save/restore host cr2

Christian Borntraeger (1):
  KVM: s390: Fix memslot initialization for userspace_addr != 0

Gleb Natapov (2):
  KVM: Replace pending exception by PF if it happens serially
  KVM: Optimize searching for highest IRR

Jan Kiszka (2):
  KVM: Fix racy event propagation in timer
  KVM: Drop useless atomic test from timer function

Jiri Slaby (1):
  KVM: fix lock imbalance

Joerg Roedel (2):
  hugetlbfs: export vma_kernel_pagsize to modules
  KVM: Prepare memslot data structures for multiple hugepage sizes

Marcelo Tosatti (16):
  KVM: MMU: introduce is_last_spte helper
  KVM: MMU audit: update count_writable_mappings / count_rmaps
  KVM: MMU audit: update audit_write_protection
  KVM: MMU audit: nontrapping ptes in nonleaf level
  KVM: MMU audit: audit_mappings tweaks
  KVM: MMU audit: largepage handling
  KVM: VMX: more MSR_IA32_VMX_EPT_VPID_CAP capability bits
  KVM: MMU: make for_each_shadow_entry aware of largepages
  KVM: MMU: add kvm_mmu_get_spte_hierarchy helper
  KVM: VMX: EPT misconfiguration handler
  KVM: VMX: conditionally disable 2M pages
  KVM: convert custom marker based tracing to event traces
  KVM: x86: missing locking in PIT/IRQCHIP/SET_BSP_CPU ioctl paths
  KVM: powerpc: convert marker probes to event trace
  KVM: remove old KVMTRACE support code
  KVM: use vcpu_id instead of bsp_vcpu pointer in kvm_vcpu_is_bsp

Michael S. Tsirkin (6):
  KVM: document locking for kvm_io_device_ops
  KVM: switch coalesced mmio changes to slots_lock
  KVM: switch pit creation to slots_lock
  KVM: convert bus to slots_lock
  KVM: remove in_range from io devices
  KVM: document lock nesting rule

 arch/ia64/include/asm/kvm_host.h    |    3 +-
 arch/ia64/kvm/Kconfig               |    3 -
 arch/ia64/kvm/kvm-ia64.c            |   28 +---
 arch/powerpc/include/asm/kvm_host.h |    3 +-
 arch/powerpc/kvm/44x_tlb.c          |   11 +-
 arch/powerpc/kvm/Kconfig            |   11 --
 arch/powerpc/kvm/Makefile           |    4 +-
 arch/powerpc/kvm/e500_tlb.c         |   16 +-
 arch/powerpc/kvm/emulate.c          |    3 +-
 arch/powerpc/kvm/powerpc.c          |    3 +
 arch/powerpc/kvm/trace.h            |  104 +++++++++++++
 arch/s390/include/asm/kvm_host.h    |    6 +-
 arch/s390/kvm/Kconfig               |    3 -
 arch/x86/include/asm/kvm_host.h     |   14 +-
 arch/x86/include/asm/msr-index.h    |    1 +
 arch/x86/include/asm/vmx.h          |    7 +
 arch/x86/kvm/Kconfig                |   12 --
 arch/x86/kvm/Makefile               |    5 +-
 arch/x86/kvm/i8254.c                |   56 ++++----
 arch/x86/kvm/i8259.c                |   22 ++-
 arch/x86/kvm/lapic.c                |   75 ++++++----
 arch/x86/kvm/lapic.h                |    1 +
 arch/x86/kvm/mmu.c                  |  222 ++++++++++++++++++++-------
 arch/x86/kvm/mmu.h                  |    2 +
 arch/x86/kvm/paging_tmpl.h          |    3 +-
 arch/x86/kvm/svm.c                  |  175 +++++++++++++---------
 arch/x86/kvm/timer.c                |   14 +-
 arch/x86/kvm/trace.h                |  260 +++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx.c                  |  208 +++++++++++++++++++------
 arch/x86/kvm/x86.c                  |  290 ++++++++++++++++++++---------------
 arch/x86/kvm/x86_emulate.c          |  240 ++++++++++++++++++++++++++++-
 include/linux/kvm.h                 |   38 +----
 include/linux/kvm_host.h            |   47 ++-----
 include/trace/events/kvm.h          |   57 +++++++
 mm/hugetlb.c                        |    1 +
 virt/kvm/coalesced_mmio.c           |   28 ++--
 virt/kvm/ioapic.c                   |   25 ++--
 virt/kvm/iodev.h                    |   42 +++---
 virt/kvm/irq_comm.c                 |    5 +
 virt/kvm/kvm_main.c                 |  119 +++++++++++----
 virt/kvm/kvm_trace.c                |  285 ----------------------------------
 41 files changed, 1574 insertions(+), 878 deletions(-)
 create mode 100644 arch/powerpc/kvm/trace.h
 create mode 100644 arch/x86/kvm/trace.h
 create mode 100644 include/trace/events/kvm.h
 delete mode 100644 virt/kvm/kvm_trace.c

