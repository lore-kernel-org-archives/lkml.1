Return-Path: <linux-kernel-owner+w=401wt.eu-S1760687AbZB0Kkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760687AbZB0Kkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758226AbZB0K2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:28:41 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53568 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376AbZB0K1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:09 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 14/37] KVM: VMX: Prevent exit handler from running if emulating due to invalid state
Date: Fri, 27 Feb 2009 12:26:37 +0200
Message-Id: <1235730420-7929-15-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we've just emulated an instruction, we won't have any valid exit
reason and associated information.

Fix by moving the clearing of the emulation_required flag to the exit handler.
This way the exit handler can notice that we've been emulating and abort
early.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a6598cb..a309be6 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3130,7 +3130,6 @@ static int handle_nmi_window(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 static void handle_invalid_guest_state(struct kvm_vcpu *vcpu,
 				struct kvm_run *kvm_run)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int err;
 
 	preempt_enable();
@@ -3155,11 +3154,6 @@ static void handle_invalid_guest_state(struct kvm_vcpu *vcpu,
 
 	local_irq_disable();
 	preempt_disable();
-
-	/* Guest state should be valid now except if we need to
-	 * emulate an MMIO */
-	if (guest_state_valid(vcpu))
-		vmx->emulation_required = 0;
 }
 
 /*
@@ -3208,8 +3202,11 @@ static int kvm_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 
 	/* If we need to emulate an MMIO from handle_invalid_guest_state
 	 * we just return 0 */
-	if (vmx->emulation_required && emulate_invalid_guest_state)
+	if (vmx->emulation_required && emulate_invalid_guest_state) {
+		if (guest_state_valid(vcpu))
+			vmx->emulation_required = 0;
 		return 0;
+	}
 
 	/* Access CR3 don't cause VMExit in paging mode, so we need
 	 * to sync with guest real CR3. */
-- 
1.6.0.6

