Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbZETL1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbZETL1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbZETLUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:20:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55279 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755613AbZETLSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:50 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 34/46] KVM: x86: check for cr3 validity in ioctl_set_sregs
Date: Wed, 20 May 2009 14:18:31 +0300
Message-Id: <1242818323-10413-35-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Matt T. Yourst notes that kvm_arch_vcpu_ioctl_set_sregs lacks validity
checking for the new cr3 value:

"Userspace callers of KVM_SET_SREGS can pass a bogus value of cr3 to
the kernel. This will trigger a NULL pointer access in gfn_to_rmap()
when userspace next tries to call KVM_RUN on the affected VCPU and kvm
attempts to activate the new non-existent page table root.

This happens since kvm only validates that cr3 points to a valid guest
physical memory page when code *inside* the guest sets cr3. However, kvm
currently trusts the userspace caller (e.g. QEMU) on the host machine to
always supply a valid page table root, rather than properly validating
it along with the rest of the reloaded guest state."

http://sourceforge.net/tracker/?func=detail&atid=893831&aid=2687641&group_id=180599

Check for a valid cr3 address in kvm_arch_vcpu_ioctl_set_sregs, triple
fault in case of failure.

Cc: stable@kernel.org
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a7ea26e..6fc53bb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3989,7 +3989,13 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 
 	vcpu->arch.cr2 = sregs->cr2;
 	mmu_reset_needed |= vcpu->arch.cr3 != sregs->cr3;
-	vcpu->arch.cr3 = sregs->cr3;
+
+	down_read(&vcpu->kvm->slots_lock);
+	if (gfn_to_memslot(vcpu->kvm, sregs->cr3 >> PAGE_SHIFT))
+		vcpu->arch.cr3 = sregs->cr3;
+	else
+		set_bit(KVM_REQ_TRIPLE_FAULT, &vcpu->requests);
+	up_read(&vcpu->kvm->slots_lock);
 
 	kvm_set_cr8(vcpu, sregs->cr8);
 
-- 
1.6.0.6

