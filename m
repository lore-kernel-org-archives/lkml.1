Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab0BMICd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:02:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269Ab0BMICD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:03 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/39] KVM updates for the 2.6.34 merge window (batch 2/4)
Date: Sat, 13 Feb 2010 10:01:20 +0200
Message-Id: <1266048119-14325-1-git-send-email-avi@redhat.com>
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

Alexander Graf (18):
  KVM: PPC: Enable lightweight exits again
  KVM: PPC: Use accessor functions for GPR access
  KVM: PPC: Add helpers for CR, XER
  KVM: PPC: Use PACA backed shadow vcpu
  KVM: PPC: Implement 'skip instruction' mode
  KVM: PPC: Get rid of unnecessary RFI
  KVM: PPC: Call SLB patching code in interrupt safe manner
  KVM: PPC: Emulate trap SRR1 flags properly
  KVM: PPC: Fix HID5 setting code
  KVM: PPC: Pass program interrupt flags to the guest
  KVM: PPC: Pass through program interrupts
  KVM: PPC: Make large pages work
  KVM: PPC: Export __giveup_vsx
  KVM: PPC: Add helper functions to call real mode loaders
  KVM: PPC: Add support for FPU/Altivec/VSX
  KVM: PPC: Fix initial GPR settings
  KVM: PPC: Keep SRR1 flags around in shadow_msr
  KVM: PPC: Move Shadow MSR calculation to function

Avi Kivity (11):
  KVM: VMX: trace clts and lmsw instructions as cr accesses
  KVM: Replace read accesses of vcpu->arch.cr0 by an accessor
  KVM: VMX: Allow the guest to own some cr0 bits
  KVM: Lazify fpu activation and deactivation
  KVM: VMX: Give the guest ownership of cr0.ts when the fpu is active
  KVM: Set cr0.et when the guest writes cr0
  KVM: SVM: Fix SVM_CR0_SELECTIVE_MASK
  KVM: SVM: Initialize fpu_active in init_vmcb()
  KVM: SVM: Restore unconditional cr0 intercept under npt
  KVM: SVM: Selective cr0 intercept
  KVM: SVM: Lazy fpu with npt

Gleb Natapov (4):
  KVM: Add HYPER-V header file
  KVM: Implement bare minimum of HYPER-V MSRs
  KVM: Add HYPER-V apic access MSRs
  KVM: Implement NotifyLongSpinWait HYPER-V hypercall

Roel Kluin (1):
  KVM: ia64: remove redundant kvm_get_exit_data() NULL tests

Sheng Yang (3):
  KVM: x86: Moving PT_*_LEVEL to mmu.h
  KVM: x86: Rename gb_page_enable() to get_lpage_level() in kvm_x86_ops
  KVM: VMX: Enable EPT 1GB page support

Takuya Yoshikawa (2):
  KVM: Fix the explanation of write_emulated
  KVM: rename is_writeble_pte() to is_writable_pte()

 arch/ia64/kvm/kvm_fw.c                       |   28 +--
 arch/powerpc/include/asm/kvm_asm.h           |    6 +
 arch/powerpc/include/asm/kvm_book3s.h        |   11 +-
 arch/powerpc/include/asm/kvm_book3s_64_asm.h |   18 ++
 arch/powerpc/include/asm/kvm_host.h          |   21 ++-
 arch/powerpc/include/asm/kvm_ppc.h           |   82 ++++++-
 arch/powerpc/include/asm/paca.h              |    5 +
 arch/powerpc/include/asm/reg.h               |    4 +
 arch/powerpc/kernel/asm-offsets.c            |   33 +++-
 arch/powerpc/kernel/ppc_ksyms.c              |    1 +
 arch/powerpc/kvm/44x_emulate.c               |   25 +-
 arch/powerpc/kvm/44x_tlb.c                   |   20 +-
 arch/powerpc/kvm/book3s.c                    |  260 ++++++++++++++++++--
 arch/powerpc/kvm/book3s_64_emulate.c         |   77 +++---
 arch/powerpc/kvm/book3s_64_exports.c         |    8 +
 arch/powerpc/kvm/book3s_64_interrupts.S      |  336 ++++++++++----------------
 arch/powerpc/kvm/book3s_64_mmu.c             |   10 +-
 arch/powerpc/kvm/book3s_64_rmhandlers.S      |  119 ++++++++--
 arch/powerpc/kvm/book3s_64_slb.S             |  158 ++++++++-----
 arch/powerpc/kvm/booke.c                     |   27 +-
 arch/powerpc/kvm/booke_emulate.c             |  107 ++++----
 arch/powerpc/kvm/e500_emulate.c              |   95 ++++----
 arch/powerpc/kvm/e500_tlb.c                  |    4 +-
 arch/powerpc/kvm/emulate.c                   |  113 +++++----
 arch/powerpc/kvm/powerpc.c                   |   21 +-
 arch/x86/include/asm/hyperv.h                |  186 ++++++++++++++
 arch/x86/include/asm/kvm_emulate.h           |    2 +-
 arch/x86/include/asm/kvm_host.h              |   11 +-
 arch/x86/include/asm/kvm_para.h              |    1 +
 arch/x86/include/asm/svm.h                   |    2 +-
 arch/x86/include/asm/vmx.h                   |    1 +
 arch/x86/kvm/emulate.c                       |    6 +-
 arch/x86/kvm/kvm_cache_regs.h                |   12 +
 arch/x86/kvm/lapic.c                         |   31 +++
 arch/x86/kvm/lapic.h                         |    8 +
 arch/x86/kvm/mmu.c                           |   32 ++--
 arch/x86/kvm/mmu.h                           |    6 +-
 arch/x86/kvm/paging_tmpl.h                   |    2 +-
 arch/x86/kvm/svm.c                           |   95 ++++----
 arch/x86/kvm/trace.h                         |   32 +++
 arch/x86/kvm/vmx.c                           |   73 ++++--
 arch/x86/kvm/x86.c                           |  268 +++++++++++++++++++-
 include/linux/kvm.h                          |    3 +
 include/linux/kvm_host.h                     |    1 +
 44 files changed, 1686 insertions(+), 675 deletions(-)
 create mode 100644 arch/x86/include/asm/hyperv.h

