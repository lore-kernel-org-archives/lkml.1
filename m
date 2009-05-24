Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbZEXPvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbZEXPvc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbZEXPug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:50:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41821 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849AbZEXPub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:31 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 00/45] KVM updates for the 2.6.31 merge window (batch 3/3)
Date: Sun, 24 May 2009 18:49:45 +0300
Message-Id: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Third batch of the 2.6.31 merge window submission.  Please review.

Andre Przywara (1):
  KVM: SVM: Fix cross vendor migration issue in segment segment
    descriptor

Avi Kivity (4):
  KVM: Fix cpuid feature misreporting
  KVM: Add AMD cpuid bit: cr8_legacy, abm, misaligned sse, sse4, 3dnow
    prefetch
  x86: Add cpu features MOVBE and POPCNT
  KVM: Update cpuid 1.ecx reporting

Carsten Otte (4):
  KVM: s390: Fix memory slot versus run - v3
  KVM: s390: Unlink vcpu on destroy - v2
  KVM: s390: Sanity check on validity intercept
  KVM: s390: Verify memory in kvm run

Chris Wright (1):
  KVM: Trivial format fix in setup_routing_entry()

Christian Borntraeger (2):
  KVM: s390: use hrtimer for clock wakeup from idle - v2
  KVM: s390: optimize float int lock: spin_lock_bh --> spin_lock

Glauber Costa (3):
  KVM: fix apic_debug instances
  KVM: Replace ->drop_interrupt_shadow() by ->set_interrupt_shadow()
  KVM: Deal with interrupt shadow state for emulated instructions

Gleb Natapov (19):
  KVM: Remove inject_pending_vectors() callback
  KVM: Remove kvm_push_irq()
  KVM: sync_lapic_to_cr8() should always sync cr8 to V_TPR
  KVM: Do not report TPR write to userspace if new value bigger or
    equal to a previous one.
  KVM: Get rid of arch.interrupt_window_open & arch.nmi_window_open
  KVM: SVM: Add NMI injection support
  KVM: Fix userspace IRQ chip migration
  KVM: Get rid of get_irq() callback
  KVM: SVM: Don't reinject event that caused a task switch
  KVM: Unprotect a page if #PF happens during NMI injection.
  KVM: Do not allow interrupt injection from userspace if there is a
    pending event.
  KVM: Remove irq_pending bitmap
  KVM: skip_emulated_instruction() decode instruction if size is not
    known
  KVM: Do not re-execute INTn instruction.
  KVM: Always request IRQ/NMI window if an interrupt is pending
  KVM: inject NMI after IRET from a previous NMI, not before.
  KVM: Do not migrate pending software interrupts.
  KVM: Disable CR8 intercept if tpr patching is active
  KVM: Move "exit due to NMI" handling into vmx_complete_interrupts()

Jan Blunck (1):
  KVM: Wake up waitqueue before calling get_cpu()

Jan Kiszka (1):
  KVM: Drop request_nmi from stats

Marcelo Tosatti (5):
  KVM: use smp_send_reschedule in kvm_vcpu_kick
  KVM: protect assigned dev workqueue, int handler and irq acker
  KVM: MMU: protect kvm_mmu_change_mmu_pages with mmu_lock
  KVM: take mmu_lock when updating a deleted slot
  KVM: x86: check for cr3 validity in mmu_alloc_roots

Robert P. J. Day (1):
  KVM: Expand on "help" info to specify kvm intel and amd module names

Sheng Yang (3):
  KVM: Replace get_mt_mask_shift with get_mt_mask
  KVM: Enable snooping control for supported hardware
  KVM: VMX: Disable VMX when system shutdown

 arch/ia64/include/asm/kvm_host.h       |    1 +
 arch/ia64/kernel/irq_ia64.c            |    3 +
 arch/ia64/kvm/kvm-ia64.c               |   22 +--
 arch/s390/include/asm/kvm_host.h       |    5 +-
 arch/s390/kvm/intercept.c              |   28 +++--
 arch/s390/kvm/interrupt.c              |   53 ++++---
 arch/s390/kvm/kvm-s390.c               |   63 +++++++--
 arch/s390/kvm/kvm-s390.h               |    4 +-
 arch/s390/kvm/priv.c                   |    4 +-
 arch/s390/kvm/sigp.c                   |   16 +-
 arch/x86/include/asm/cpufeature.h      |    2 +
 arch/x86/include/asm/kvm_host.h        |   30 +++--
 arch/x86/include/asm/kvm_x86_emulate.h |    6 +
 arch/x86/kernel/smp.c                  |    3 +
 arch/x86/kvm/Kconfig                   |    6 +
 arch/x86/kvm/irq.c                     |    4 +-
 arch/x86/kvm/lapic.c                   |    4 +-
 arch/x86/kvm/mmu.c                     |   50 ++++---
 arch/x86/kvm/svm.c                     |  248 ++++++++++++++++++++-----------
 arch/x86/kvm/vmx.c                     |  260 ++++++++++++++++----------------
 arch/x86/kvm/x86.c                     |  247 ++++++++++++++++++------------
 arch/x86/kvm/x86.h                     |   22 +--
 arch/x86/kvm/x86_emulate.c             |   20 +++
 include/linux/kvm_host.h               |    6 +-
 virt/kvm/iommu.c                       |   27 +++-
 virt/kvm/irq_comm.c                    |    2 +-
 virt/kvm/kvm_main.c                    |   33 +++--
 27 files changed, 721 insertions(+), 448 deletions(-)

