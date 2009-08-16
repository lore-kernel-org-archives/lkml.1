Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbZHPJfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbZHPJfk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbZHPJfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:35:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45357 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050AbZHPJaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 27/48] KVM: VMX: Simplify pdptr and cr3 management
Date: Sun, 16 Aug 2009 12:29:47 +0300
Message-Id: <1250415008-17175-28-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of reading the PDPTRs from memory after every exit (which is slow
and wrong, as the PDPTRs are stored on the cpu), sync the PDPTRs from
memory to the VMCS before entry, and from the VMCS to memory after exit.
Do the same for cr3.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ea0e1d5..752465f 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1547,10 +1547,6 @@ static void vmx_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
 static void ept_load_pdptrs(struct kvm_vcpu *vcpu)
 {
 	if (is_paging(vcpu) && is_pae(vcpu) && !is_long_mode(vcpu)) {
-		if (!load_pdptrs(vcpu, vcpu->arch.cr3)) {
-			printk(KERN_ERR "EPT: Fail to load pdptrs!\n");
-			return;
-		}
 		vmcs_write64(GUEST_PDPTR0, vcpu->arch.pdptrs[0]);
 		vmcs_write64(GUEST_PDPTR1, vcpu->arch.pdptrs[1]);
 		vmcs_write64(GUEST_PDPTR2, vcpu->arch.pdptrs[2]);
@@ -1558,6 +1554,16 @@ static void ept_load_pdptrs(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void ept_save_pdptrs(struct kvm_vcpu *vcpu)
+{
+	if (is_paging(vcpu) && is_pae(vcpu) && !is_long_mode(vcpu)) {
+		vcpu->arch.pdptrs[0] = vmcs_read64(GUEST_PDPTR0);
+		vcpu->arch.pdptrs[1] = vmcs_read64(GUEST_PDPTR1);
+		vcpu->arch.pdptrs[2] = vmcs_read64(GUEST_PDPTR2);
+		vcpu->arch.pdptrs[3] = vmcs_read64(GUEST_PDPTR3);
+	}
+}
+
 static void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 
 static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
@@ -1651,7 +1657,6 @@ static void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	if (enable_ept) {
 		eptp = construct_eptp(cr3);
 		vmcs_write64(EPT_POINTER, eptp);
-		ept_load_pdptrs(vcpu);
 		guest_cr3 = is_paging(vcpu) ? vcpu->arch.cr3 :
 			VMX_EPT_IDENTITY_PAGETABLE_ADDR;
 	}
@@ -3252,7 +3257,7 @@ static int vmx_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 	 * to sync with guest real CR3. */
 	if (enable_ept && is_paging(vcpu)) {
 		vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
-		ept_load_pdptrs(vcpu);
+		ept_save_pdptrs(vcpu);
 	}
 
 	if (unlikely(vmx->fail)) {
@@ -3437,6 +3442,10 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (enable_ept && is_paging(vcpu)) {
+		vmcs_writel(GUEST_CR3, vcpu->arch.cr3);
+		ept_load_pdptrs(vcpu);
+	}
 	/* Record the guest's net vcpu time for enforced NMI injections. */
 	if (unlikely(!cpu_has_virtual_nmis() && vmx->soft_vnmi_blocked))
 		vmx->entry_time = ktime_get();
-- 
1.6.3.3

