Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbZHSNJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbZHSNJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbZHSNJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:09:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50560 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751934AbZHSNCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:47 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 19/47] KVM: SVM: Don't save/restore host cr2
Date: Wed, 19 Aug 2009 16:02:15 +0300
Message-Id: <1250686963-8357-20-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The host never reads cr2 in process context, so are free to clobber it.  The
vmx code does this, so we can safely remove the save/restore code.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e1dd47d..5a1f26c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -82,7 +82,6 @@ struct vcpu_svm {
 
 	u64 host_user_msrs[NR_HOST_SAVE_USER_MSRS];
 	u64 host_gs_base;
-	unsigned long host_cr2;
 
 	u32 *msrpm;
 	struct vmcb *hsave;
@@ -187,19 +186,6 @@ static inline void invlpga(unsigned long addr, u32 asid)
 	asm volatile (__ex(SVM_INVLPGA) :: "a"(addr), "c"(asid));
 }
 
-static inline unsigned long kvm_read_cr2(void)
-{
-	unsigned long cr2;
-
-	asm volatile ("mov %%cr2, %0" : "=r" (cr2));
-	return cr2;
-}
-
-static inline void kvm_write_cr2(unsigned long val)
-{
-	asm volatile ("mov %0, %%cr2" :: "r" (val));
-}
-
 static inline void force_new_asid(struct kvm_vcpu *vcpu)
 {
 	to_svm(vcpu)->asid_generation--;
@@ -2528,7 +2514,6 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	fs_selector = kvm_read_fs();
 	gs_selector = kvm_read_gs();
 	ldt_selector = kvm_read_ldt();
-	svm->host_cr2 = kvm_read_cr2();
 	if (!is_nested(svm))
 		svm->vmcb->save.cr2 = vcpu->arch.cr2;
 	/* required for live migration with NPT */
@@ -2615,8 +2600,6 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	vcpu->arch.regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;
 	vcpu->arch.regs[VCPU_REGS_RIP] = svm->vmcb->save.rip;
 
-	kvm_write_cr2(svm->host_cr2);
-
 	kvm_load_fs(fs_selector);
 	kvm_load_gs(gs_selector);
 	kvm_load_ldt(ldt_selector);
-- 
1.6.3.3

