Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbYLHLvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbYLHLvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbYLHLiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:38:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48222 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246AbYLHLhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:03 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 08/45] KVM: VMX: fix real-mode NMI support
Date: Mon,  8 Dec 2008 13:36:19 +0200
Message-Id: <1228736216-15787-9-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Fix NMI injection in real-mode with the same pattern we perform IRQ
injection.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 440f56c..38d1385 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2358,6 +2358,19 @@ static void vmx_inject_irq(struct kvm_vcpu *vcpu, int irq)
 
 static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (vcpu->arch.rmode.active) {
+		vmx->rmode.irq.pending = true;
+		vmx->rmode.irq.vector = NMI_VECTOR;
+		vmx->rmode.irq.rip = kvm_rip_read(vcpu);
+		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
+			     NMI_VECTOR | INTR_TYPE_SOFT_INTR |
+			     INTR_INFO_VALID_MASK);
+		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN, 1);
+		kvm_rip_write(vcpu, vmx->rmode.irq.rip - 1);
+		return;
+	}
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
 			INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK | NMI_VECTOR);
 }
-- 
1.6.0.3

