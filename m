Return-Path: <linux-kernel-owner+w=401wt.eu-S1758063AbXIQIvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbXIQIvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577AbXIQIdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:24 -0400
Received: from il.qumranet.com ([82.166.9.18]:45310 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612AbXIQIcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:35 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 090/104] KVM: VMX: Move vm entry failure handling to the exit handler
Date: Mon, 17 Sep 2007 10:32:12 +0200
Message-Id: <11900179493346-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This will help moving the main loop to subarch independent code.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 57a6055..713f78a 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -43,6 +43,7 @@ struct vmcs {
 struct vcpu_vmx {
 	struct kvm_vcpu       vcpu;
 	int                   launched;
+	u8                    fail;
 	struct kvm_msr_entry *guest_msrs;
 	struct kvm_msr_entry *host_msrs;
 	int                   nmsrs;
@@ -2099,6 +2100,14 @@ static int kvm_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 {
 	u32 vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
 	u32 exit_reason = vmcs_read32(VM_EXIT_REASON);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (unlikely(vmx->fail)) {
+		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
+		kvm_run->fail_entry.hardware_entry_failure_reason
+			= vmcs_read32(VM_INSTRUCTION_ERROR);
+		return 0;
+	}
 
 	if ( (vectoring_info & VECTORING_INFO_VALID_MASK) &&
 				exit_reason != EXIT_REASON_EXCEPTION_NMI )
@@ -2208,7 +2217,6 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 static int vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u8 fail;
 	int r;
 
 	if (unlikely(vcpu->mp_state == VCPU_MP_STATE_SIPI_RECEIVED)) {
@@ -2352,7 +2360,7 @@ again:
 		"pop %%ecx; popa \n\t"
 #endif
 		"setbe %0 \n\t"
-	      : "=q" (fail)
+	      : "=q" (vmx->fail)
 	      : "r"(vmx->launched), "d"((unsigned long)HOST_RSP),
 		"c"(vcpu),
 		[rax]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RAX])),
@@ -2387,13 +2395,6 @@ again:
 
 	preempt_enable();
 
-	if (unlikely(fail)) {
-		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
-		kvm_run->fail_entry.hardware_entry_failure_reason
-			= vmcs_read32(VM_INSTRUCTION_ERROR);
-		r = 0;
-		goto out;
-	}
 	/*
 	 * Profile KVM exit RIPs:
 	 */
-- 
1.5.3

