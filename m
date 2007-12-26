Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbXLZLWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbXLZLWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbXLZLHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:07:10 -0500
Received: from il.qumranet.com ([82.166.9.18]:50480 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbXLZLGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:08 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 38/55] KVM: VMX: Read & store IDT_VECTORING_INFO_FIELD
Date: Wed, 26 Dec 2007 13:05:43 +0200
Message-Id: <1198667160-22953-39-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'll want to write to it in order to fix real-mode irq injection problems,
but it is a read-only field.  Storing it in a variable solves that issue.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 1166132..bde2d07 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -48,6 +48,7 @@ struct vcpu_vmx {
 	struct kvm_vcpu       vcpu;
 	int                   launched;
 	u8                    fail;
+	u32                   idt_vectoring_info;
 	struct kvm_msr_entry *guest_msrs;
 	struct kvm_msr_entry *host_msrs;
 	int                   nmsrs;
@@ -863,9 +864,10 @@ static int set_guest_debug(struct kvm_vcpu *vcpu, struct kvm_debug_guest *dbg)
 
 static int vmx_get_irq(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 idtv_info_field;
 
-	idtv_info_field = vmcs_read32(IDT_VECTORING_INFO_FIELD);
+	idtv_info_field = vmx->idt_vectoring_info;
 	if (idtv_info_field & INTR_INFO_VALID_MASK) {
 		if (is_external_interrupt(idtv_info_field))
 			return idtv_info_field & VECTORING_INFO_VECTOR_MASK;
@@ -1817,12 +1819,13 @@ static int handle_rmode_exception(struct kvm_vcpu *vcpu,
 
 static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 intr_info, error_code;
 	unsigned long cr2, rip;
 	u32 vect_info;
 	enum emulation_result er;
 
-	vect_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
+	vect_info = vmx->idt_vectoring_info;
 	intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 
 	if ((vect_info & VECTORING_INFO_VALID_MASK) &&
@@ -2171,9 +2174,9 @@ static const int kvm_vmx_max_exit_handlers =
  */
 static int kvm_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 {
-	u32 vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
 	u32 exit_reason = vmcs_read32(VM_EXIT_REASON);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u32 vectoring_info = vmx->idt_vectoring_info;
 
 	if (unlikely(vmx->fail)) {
 		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
@@ -2228,6 +2231,7 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
 
 static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 idtv_info_field, intr_info_field;
 	int has_ext_irq, interrupt_window_open;
 	int vector;
@@ -2236,7 +2240,7 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 
 	has_ext_irq = kvm_cpu_has_interrupt(vcpu);
 	intr_info_field = vmcs_read32(VM_ENTRY_INTR_INFO_FIELD);
-	idtv_info_field = vmcs_read32(IDT_VECTORING_INFO_FIELD);
+	idtv_info_field = vmx->idt_vectoring_info;
 	if (intr_info_field & INTR_INFO_VALID_MASK) {
 		if (idtv_info_field & INTR_INFO_VALID_MASK) {
 			/* TODO: fault when IDT_Vectoring */
@@ -2396,6 +2400,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 #endif
 	      );
 
+	vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
+
 	vcpu->interrupt_window_open =
 		(vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & 3) == 0;
 
@@ -2413,7 +2419,8 @@ static void vmx_inject_page_fault(struct kvm_vcpu *vcpu,
 				  unsigned long addr,
 				  u32 err_code)
 {
-	u32 vect_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u32 vect_info = vmx->idt_vectoring_info;
 
 	++vcpu->stat.pf_guest;
 
-- 
1.5.3.7

