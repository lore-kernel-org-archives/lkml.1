Return-Path: <linux-kernel-owner+w=401wt.eu-S1761824AbZB0Ki1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761824AbZB0Ki1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757926AbZB0K2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:28:24 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53577 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432AbZB0K1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:10 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 16/37] KVM: VMX: When emulating on invalid vmx state, don't return to userspace unnecessarily
Date: Fri, 27 Feb 2009 12:26:39 +0200
Message-Id: <1235730420-7929-17-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we aren't doing mmio there's no need to exit to userspace (which will
just be confused).

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a309be6..df454de 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -91,6 +91,7 @@ struct vcpu_vmx {
 	} rmode;
 	int vpid;
 	bool emulation_required;
+	enum emulation_result invalid_state_emulation_result;
 
 	/* Support for vnmi-less CPUs */
 	int soft_vnmi_blocked;
@@ -3130,7 +3131,8 @@ static int handle_nmi_window(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 static void handle_invalid_guest_state(struct kvm_vcpu *vcpu,
 				struct kvm_run *kvm_run)
 {
-	int err;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	enum emulation_result err = EMULATE_DONE;
 
 	preempt_enable();
 	local_irq_enable();
@@ -3154,6 +3156,8 @@ static void handle_invalid_guest_state(struct kvm_vcpu *vcpu,
 
 	local_irq_disable();
 	preempt_disable();
+
+	vmx->invalid_state_emulation_result = err;
 }
 
 /*
@@ -3205,7 +3209,7 @@ static int kvm_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 	if (vmx->emulation_required && emulate_invalid_guest_state) {
 		if (guest_state_valid(vcpu))
 			vmx->emulation_required = 0;
-		return 0;
+		return vmx->invalid_state_emulation_result != EMULATE_DO_MMIO;
 	}
 
 	/* Access CR3 don't cause VMExit in paging mode, so we need
-- 
1.6.0.6

