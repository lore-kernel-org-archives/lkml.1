Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbXLZLRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbXLZLRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbXLZLGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:52 -0500
Received: from il.qumranet.com ([82.166.9.18]:50482 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbXLZLGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:08 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 39/55] KVM: Fix faults during injection of real-mode interrupts
Date: Wed, 26 Dec 2007 13:05:44 +0200
Message-Id: <1198667160-22953-40-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If vmx fails to inject a real-mode interrupt while fetching the interrupt
redirection table, it fails to record this in the vectoring information
field.  So we detect this condition and do it ourselves.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index bde2d07..63c230d 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -65,7 +65,13 @@ struct vcpu_vmx {
 		int           fs_reload_needed;
 		int           guest_efer_loaded;
 	} host_state;
-
+	struct {
+		struct {
+			bool pending;
+			u8 vector;
+			unsigned rip;
+		} irq;
+	} rmode;
 };
 
 static inline struct vcpu_vmx *to_vmx(struct kvm_vcpu *vcpu)
@@ -1713,11 +1719,16 @@ out:
 
 static void vmx_inject_irq(struct kvm_vcpu *vcpu, int irq)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
 	if (vcpu->rmode.active) {
+		vmx->rmode.irq.pending = true;
+		vmx->rmode.irq.vector = irq;
+		vmx->rmode.irq.rip = vmcs_readl(GUEST_RIP);
 		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
 			     irq | INTR_TYPE_SOFT_INTR | INTR_INFO_VALID_MASK);
 		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN, 1);
-		vmcs_writel(GUEST_RIP, vmcs_readl(GUEST_RIP) - 1);
+		vmcs_writel(GUEST_RIP, vmx->rmode.irq.rip - 1);
 		return;
 	}
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
@@ -2251,6 +2262,17 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 		return;
 	}
 	if (unlikely(idtv_info_field & INTR_INFO_VALID_MASK)) {
+		if ((idtv_info_field & VECTORING_INFO_TYPE_MASK)
+		    == INTR_TYPE_EXT_INTR
+		    && vcpu->rmode.active) {
+			u8 vect = idtv_info_field & VECTORING_INFO_VECTOR_MASK;
+
+			vmx_inject_irq(vcpu, vect);
+			if (unlikely(has_ext_irq))
+				enable_irq_window(vcpu);
+			return;
+		}
+
 		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, idtv_info_field);
 		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN,
 				vmcs_read32(VM_EXIT_INSTRUCTION_LEN));
@@ -2275,6 +2297,29 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 		enable_irq_window(vcpu);
 }
 
+/*
+ * Failure to inject an interrupt should give us the information
+ * in IDT_VECTORING_INFO_FIELD.  However, if the failure occurs
+ * when fetching the interrupt redirection bitmap in the real-mode
+ * tss, this doesn't happen.  So we do it ourselves.
+ */
+static void fixup_rmode_irq(struct vcpu_vmx *vmx)
+{
+	vmx->rmode.irq.pending = 0;
+	if (vmcs_readl(GUEST_RIP) + 1 != vmx->rmode.irq.rip)
+		return;
+	vmcs_writel(GUEST_RIP, vmx->rmode.irq.rip);
+	if (vmx->idt_vectoring_info & VECTORING_INFO_VALID_MASK) {
+		vmx->idt_vectoring_info &= ~VECTORING_INFO_TYPE_MASK;
+		vmx->idt_vectoring_info |= INTR_TYPE_EXT_INTR;
+		return;
+	}
+	vmx->idt_vectoring_info =
+		VECTORING_INFO_VALID_MASK
+		| INTR_TYPE_EXT_INTR
+		| vmx->rmode.irq.vector;
+}
+
 static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -2401,6 +2446,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	      );
 
 	vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
+	if (vmx->rmode.irq.pending)
+		fixup_rmode_irq(vmx);
 
 	vcpu->interrupt_window_open =
 		(vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & 3) == 0;
-- 
1.5.3.7

