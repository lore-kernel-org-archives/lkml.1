Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbZBZOQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbZBZOQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbZBZOPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:15:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43029 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbZBZOPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:38 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/40] KVM Updates for the 2.6.30 merge window (1/3)
Date: Thu, 26 Feb 2009 16:14:50 +0200
Message-Id: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first batch of three containing the current 2.6.30 patch queue
for review.

Changes include nested virtualization on AMD hosts, ppc e500 support,
improved guest debugging support, better performance and improved emulation
accuracy.

Alexander Graf (10):
  KVM: SVM: Clean up VINTR setting
  KVM: SVM: Move EFER and MSR constants to generic x86 code
  KVM: SVM: Add helper functions for nested SVM
  KVM: SVM: Implement GIF, clgi and stgi
  KVM: SVM: Implement hsave
  KVM: SVM: Add VMLOAD and VMSAVE handlers
  KVM: SVM: Add VMRUN handler
  KVM: SVM: Add VMEXIT handler and intercepts
  KVM: SVM: Allow setting the SVME bit
  KVM: SVM: Only allow setting of EFER_SVME when CPUID SVM is set

Avi Kivity (11):
  KVM: MMU: Inherit a shadow page's guest level count from vcpu setup
  KVM: MMU: Segregate mmu pages created with different cr4.pge settings
  KVM: MMU: Initialize a shadow page's global attribute from cr4.pge
  KVM: Fix vmload and friends misinterpreted as lidt
  KVM: MMU: Add for_each_shadow_entry(), a simpler alternative to
    walk_shadow()
  KVM: MMU: Use for_each_shadow_entry() in __direct_map()
  KVM: MMU: Replace walk_shadow() by for_each_shadow_entry() in fetch()
  KVM: MMU: Replace walk_shadow() by for_each_shadow_entry() in
    invlpg()
  KVM: MMU: Drop walk_shadow()
  KVM: Fallback support for MSR_VM_HSAVE_PA
  KVM: Move struct kvm_pio_request into x86 kvm_host.h

Hollis Blanchard (5):
  KVM: ppc: move struct kvmppc_44x_tlbe into 44x-specific header
  KVM: ppc: cosmetic changes to mmu hook names
  KVM: ppc: small cosmetic changes to Book E DTLB miss handler
  KVM: ppc: change kvmppc_mmu_map() parameters
  KVM: ppc: turn tlb_xlate() into a per-core hook (and give it a better
    name)

Izik Eidus (2):
  KVM: introduce kvm_read_guest_virt, kvm_write_guest_virt
  KVM: remove the vmap usage

Jan Kiszka (7):
  KVM: VMX: Support for injecting software exceptions
  KVM: New guest debug interface
  KVM: VMX: Allow single-stepping when uninterruptible
  KVM: x86: Virtualize debug registers
  KVM: x86: Wire-up hardware breakpoints for guest debugging
  KVM: Remove old kvm_guest_debug structs
  KVM: Advertise guest debug capability per-arch

Jes Sorensen (1):
  KVM: ia64: stack get/restore patch

Joerg Roedel (1):
  KVM: SVM: Allow read access to MSR_VM_VR

Marcelo Tosatti (2):
  KVM: VMX: initialize TSC offset relative to vm creation time
  KVM: PIT: provide an option to disable interrupt reinjection

Xiantao Zhang (1):
  KVM: ia64: Code cleanup

 arch/ia64/include/asm/kvm.h         |   14 +
 arch/ia64/include/asm/kvm_host.h    |    8 +-
 arch/ia64/kvm/kvm-ia64.c            |   96 ++++-
 arch/ia64/kvm/process.c             |   15 -
 arch/ia64/kvm/vcpu.c                |   39 +--
 arch/ia64/kvm/vtlb.c                |    5 -
 arch/powerpc/include/asm/kvm.h      |    7 +
 arch/powerpc/include/asm/kvm_44x.h  |    7 +
 arch/powerpc/include/asm/kvm_host.h |   13 -
 arch/powerpc/include/asm/kvm_ppc.h  |    8 +-
 arch/powerpc/kvm/44x.c              |    6 +-
 arch/powerpc/kvm/44x_tlb.c          |   27 +-
 arch/powerpc/kvm/44x_tlb.h          |    7 -
 arch/powerpc/kvm/booke.c            |   20 +-
 arch/powerpc/kvm/powerpc.c          |    6 +-
 arch/s390/include/asm/kvm.h         |    7 +
 arch/s390/include/asm/kvm_host.h    |    3 -
 arch/s390/kvm/kvm-s390.c            |    4 +-
 arch/x86/include/asm/kvm.h          |   23 +
 arch/x86/include/asm/kvm_host.h     |   54 ++-
 arch/x86/include/asm/msr-index.h    |    7 +
 arch/x86/include/asm/svm.h          |    4 -
 arch/x86/include/asm/virtext.h      |    2 +-
 arch/x86/include/asm/vmx.h          |    5 +-
 arch/x86/kvm/i8254.c                |    4 +
 arch/x86/kvm/i8254.h                |    1 +
 arch/x86/kvm/kvm_svm.h              |   16 +-
 arch/x86/kvm/mmu.c                  |  171 ++++----
 arch/x86/kvm/paging_tmpl.h          |  209 ++++-----
 arch/x86/kvm/svm.c                  |  863 +++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx.c                  |  268 +++++++----
 arch/x86/kvm/x86.c                  |  261 +++++++----
 arch/x86/kvm/x86_emulate.c          |   15 +-
 include/linux/kvm.h                 |   60 ++-
 include/linux/kvm_host.h            |    6 +-
 include/linux/kvm_types.h           |   13 -
 virt/kvm/kvm_main.c                 |    6 +-
 37 files changed, 1611 insertions(+), 669 deletions(-)

