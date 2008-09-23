Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbYIWNwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbYIWNwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbYIWNri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52378 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbYIWNrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:24 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Jan Kiszka <jan.kiszka@web.de>
Subject: [PATCH 16/40] KVM: VMX: Reinject real mode exception
Date: Tue, 23 Sep 2008 16:46:30 +0300
Message-Id: <1222177614-26669-17-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@web.de>

As we execute real mode guests in VM86 mode, exception have to be
reinjected appropriately when the guest triggered them. For this purpose
the patch adopts the real-mode injection pattern used in vmx_inject_irq
to vmx_queue_exception, additionally taking care that the IP is set
correctly for #BP exceptions. Furthermore it extends
handle_rmode_exception to reinject all those exceptions that can be
raised in real mode.

This fixes the execution of himem.exe from FreeDOS and also makes its
debug.com work properly.

Note that guest debugging in real mode is broken now. This has to be
fixed by the scheduled debugging infrastructure rework (will be done
once base patches for QEMU have been accepted).

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c         |   41 +++++++++++++++++++++++++++++++++++++++--
 include/asm-x86/kvm_host.h |    4 ++++
 2 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 5c9dac5..2879880 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -735,12 +735,30 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 static void vmx_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
 				bool has_error_code, u32 error_code)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (has_error_code)
+		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, error_code);
+
+	if (vcpu->arch.rmode.active) {
+		vmx->rmode.irq.pending = true;
+		vmx->rmode.irq.vector = nr;
+		vmx->rmode.irq.rip = kvm_rip_read(vcpu);
+		if (nr == BP_VECTOR)
+			vmx->rmode.irq.rip++;
+		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
+			     nr | INTR_TYPE_SOFT_INTR
+			     | (has_error_code ? INTR_INFO_DELIVER_CODE_MASK : 0)
+			     | INTR_INFO_VALID_MASK);
+		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN, 1);
+		kvm_rip_write(vcpu, vmx->rmode.irq.rip - 1);
+		return;
+	}
+
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
 		     nr | INTR_TYPE_EXCEPTION
 		     | (has_error_code ? INTR_INFO_DELIVER_CODE_MASK : 0)
 		     | INTR_INFO_VALID_MASK);
-	if (has_error_code)
-		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, error_code);
 }
 
 static bool vmx_exception_injected(struct kvm_vcpu *vcpu)
@@ -2231,6 +2249,25 @@ static int handle_rmode_exception(struct kvm_vcpu *vcpu,
 	if (((vec == GP_VECTOR) || (vec == SS_VECTOR)) && err_code == 0)
 		if (emulate_instruction(vcpu, NULL, 0, 0, 0) == EMULATE_DONE)
 			return 1;
+	/*
+	 * Forward all other exceptions that are valid in real mode.
+	 * FIXME: Breaks guest debugging in real mode, needs to be fixed with
+	 *        the required debugging infrastructure rework.
+	 */
+	switch (vec) {
+	case DE_VECTOR:
+	case DB_VECTOR:
+	case BP_VECTOR:
+	case OF_VECTOR:
+	case BR_VECTOR:
+	case UD_VECTOR:
+	case DF_VECTOR:
+	case SS_VECTOR:
+	case GP_VECTOR:
+	case MF_VECTOR:
+		kvm_queue_exception(vcpu, vec);
+		return 1;
+	}
 	return 0;
 }
 
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 2446893..4104cb2 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -58,6 +58,9 @@
 
 #define DE_VECTOR 0
 #define DB_VECTOR 1
+#define BP_VECTOR 3
+#define OF_VECTOR 4
+#define BR_VECTOR 5
 #define UD_VECTOR 6
 #define NM_VECTOR 7
 #define DF_VECTOR 8
@@ -66,6 +69,7 @@
 #define SS_VECTOR 12
 #define GP_VECTOR 13
 #define PF_VECTOR 14
+#define MF_VECTOR 16
 #define MC_VECTOR 18
 
 #define SELECTOR_TI_MASK (1 << 2)
-- 
1.6.0.1

