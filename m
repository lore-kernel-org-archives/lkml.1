Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbZKSNjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbZKSNjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbZKSNjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:39:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537AbZKSNfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:08 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 25/35] KVM: VMX: move CR3/PDPTR update to vmx_set_cr3
Date: Thu, 19 Nov 2009 15:35:01 +0200
Message-Id: <1258637711-11674-26-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

GUEST_CR3 is updated via kvm_set_cr3 whenever CR3 is modified from
outside guest context. Similarly pdptrs are updated via load_pdptrs.

Let kvm_set_cr3 perform the update, removing it from the vcpu_run
fast path.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Acked-by: Acked-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    5 +----
 arch/x86/kvm/x86.c |    4 +++-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index bf46253..a5f3f3e 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1737,6 +1737,7 @@ static void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		vmcs_write64(EPT_POINTER, eptp);
 		guest_cr3 = is_paging(vcpu) ? vcpu->arch.cr3 :
 			vcpu->kvm->arch.ept_identity_map_addr;
+		ept_load_pdptrs(vcpu);
 	}
 
 	vmx_flush_tlb(vcpu);
@@ -3625,10 +3626,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (enable_ept && is_paging(vcpu)) {
-		vmcs_writel(GUEST_CR3, vcpu->arch.cr3);
-		ept_load_pdptrs(vcpu);
-	}
 	/* Record the guest's net vcpu time for enforced NMI injections. */
 	if (unlikely(!cpu_has_virtual_nmis() && vmx->soft_vnmi_blocked))
 		vmx->entry_time = ktime_get();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dbddcc2..719f31e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4591,8 +4591,10 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 
 	mmu_reset_needed |= vcpu->arch.cr4 != sregs->cr4;
 	kvm_x86_ops->set_cr4(vcpu, sregs->cr4);
-	if (!is_long_mode(vcpu) && is_pae(vcpu))
+	if (!is_long_mode(vcpu) && is_pae(vcpu)) {
 		load_pdptrs(vcpu, vcpu->arch.cr3);
+		mmu_reset_needed = 1;
+	}
 
 	if (mmu_reset_needed)
 		kvm_mmu_reset_context(vcpu);
-- 
1.6.5.2

