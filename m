Return-Path: <linux-kernel-owner+w=401wt.eu-S1759551AbYCaOqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551AbYCaOqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYCaOhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:48 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51313
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbYCaOhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:34 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 29/40] KVM: SVM: let init_vmcb() take struct vcpu_svm as parameter
Date: Mon, 31 Mar 2008 17:37:13 +0300
Message-Id: <1206974244-9716-30-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

Change the parameter of the init_vmcb() function in the kvm-amd module from
struct vmcb to struct vcpu_svm.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8e9d4a5..d934819 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -471,10 +471,10 @@ static void init_sys_seg(struct vmcb_seg *seg, uint32_t type)
 	seg->base = 0;
 }
 
-static void init_vmcb(struct vmcb *vmcb)
+static void init_vmcb(struct vcpu_svm *svm)
 {
-	struct vmcb_control_area *control = &vmcb->control;
-	struct vmcb_save_area *save = &vmcb->save;
+	struct vmcb_control_area *control = &svm->vmcb->control;
+	struct vmcb_save_area *save = &svm->vmcb->save;
 
 	control->intercept_cr_read = 	INTERCEPT_CR0_MASK |
 					INTERCEPT_CR3_MASK |
@@ -600,7 +600,7 @@ static int svm_vcpu_reset(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	init_vmcb(svm->vmcb);
+	init_vmcb(svm);
 
 	if (vcpu->vcpu_id != 0) {
 		svm->vmcb->save.rip = 0;
@@ -638,7 +638,7 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	svm->vmcb_pa = page_to_pfn(page) << PAGE_SHIFT;
 	svm->asid_generation = 0;
 	memset(svm->db_regs, 0, sizeof(svm->db_regs));
-	init_vmcb(svm->vmcb);
+	init_vmcb(svm);
 
 	fx_init(&svm->vcpu);
 	svm->vcpu.fpu_active = 1;
@@ -1024,7 +1024,7 @@ static int shutdown_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	 * so reinitialize it.
 	 */
 	clear_page(svm->vmcb);
-	init_vmcb(svm->vmcb);
+	init_vmcb(svm);
 
 	kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;
 	return 0;
-- 
1.5.4.5

