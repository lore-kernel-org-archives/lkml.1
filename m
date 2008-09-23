Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbYIWNxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbYIWNxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbYIWNrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52353 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbYIWNrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:11 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 07/40] KVM: Move NMI IRET fault processing to new vmx_complete_interrupts()
Date: Tue, 23 Sep 2008 16:46:21 +0300
Message-Id: <1222177614-26669-8-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

Currently most interrupt exit processing is handled on the entry path,
which is confusing.  Move the NMI IRET fault processing to a new function,
vmx_complete_interrupts(), which is called on the vmexit path.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c |   36 ++++++++++++++++++++++++------------
 1 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 5a3a032..2adfacb 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2817,6 +2817,27 @@ static void enable_intr_window(struct kvm_vcpu *vcpu)
 		enable_irq_window(vcpu);
 }
 
+static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
+{
+	u32 exit_intr_info;
+	bool unblock_nmi;
+	u8 vector;
+
+	exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
+	if (cpu_has_virtual_nmis()) {
+		unblock_nmi = (exit_intr_info & INTR_INFO_UNBLOCK_NMI) != 0;
+		vector = exit_intr_info & INTR_INFO_VECTOR_MASK;
+		/*
+		 * SDM 3: 25.7.1.2
+		 * Re-set bit "block by NMI" before VM entry if vmexit caused by
+		 * a guest IRET fault.
+		 */
+		if (unblock_nmi && vector != DF_VECTOR)
+			vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO,
+				      GUEST_INTR_STATE_NMI);
+	}
+}
+
 static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -2873,23 +2894,12 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 		return;
 	}
 	if (cpu_has_virtual_nmis()) {
-		/*
-		 * SDM 3: 25.7.1.2
-		 * Re-set bit "block by NMI" before VM entry if vmexit caused by
-		 * a guest IRET fault.
-		 */
-		if ((exit_intr_info_field & INTR_INFO_UNBLOCK_NMI) &&
-		    (exit_intr_info_field & INTR_INFO_VECTOR_MASK) != 8)
-			vmcs_write32(GUEST_INTERRUPTIBILITY_INFO,
-				vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) |
-				GUEST_INTR_STATE_NMI);
-		else if (vcpu->arch.nmi_pending) {
+		if (vcpu->arch.nmi_pending) {
 			if (vmx_nmi_enabled(vcpu))
 				vmx_inject_nmi(vcpu);
 			enable_intr_window(vcpu);
 			return;
 		}
-
 	}
 	if (!kvm_cpu_has_interrupt(vcpu))
 		return;
@@ -3076,6 +3086,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		KVMTRACE_0D(NMI, vcpu, handler);
 		asm("int $2");
 	}
+
+	vmx_complete_interrupts(vmx);
 }
 
 static void vmx_free_vmcs(struct kvm_vcpu *vcpu)
-- 
1.6.0.1

