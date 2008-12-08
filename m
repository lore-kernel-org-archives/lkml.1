Return-Path: <linux-kernel-owner+w=401wt.eu-S1756447AbYLHLpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447AbYLHLpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745AbYLHLiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:38:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44446 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489AbYLHLhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:36 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Subject: [PATCH 33/45] KVM: VMX: Handle mmio emulation when guest state is invalid
Date: Mon,  8 Dec 2008 13:36:44 +0200
Message-Id: <1228736216-15787-34-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>

If emulate_invalid_guest_state is enabled, the emulator is called
when guest state is invalid.  Until now, we reported an mmio failure
when emulate_instruction() returned EMULATE_DO_MMIO.  This patch adds
the case where emulate_instruction() failed and an MMIO emulation
is needed.

Signed-off-by: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 816d231..427dbc1 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3052,16 +3052,12 @@ static void handle_invalid_guest_state(struct kvm_vcpu *vcpu,
 	while (!guest_state_valid(vcpu)) {
 		err = emulate_instruction(vcpu, kvm_run, 0, 0, 0);
 
-		switch (err) {
-			case EMULATE_DONE:
-				break;
-			case EMULATE_DO_MMIO:
-				kvm_report_emulation_failure(vcpu, "mmio");
-				/* TODO: Handle MMIO */
-				return;
-			default:
-				kvm_report_emulation_failure(vcpu, "emulation failure");
-				return;
+		if (err == EMULATE_DO_MMIO)
+			break;
+
+		if (err != EMULATE_DONE) {
+			kvm_report_emulation_failure(vcpu, "emulation failure");
+			return;
 		}
 
 		if (signal_pending(current))
@@ -3073,8 +3069,10 @@ static void handle_invalid_guest_state(struct kvm_vcpu *vcpu,
 	local_irq_disable();
 	preempt_disable();
 
-	/* Guest state should be valid now, no more emulation should be needed */
-	vmx->emulation_required = 0;
+	/* Guest state should be valid now except if we need to
+	 * emulate an MMIO */
+	if (guest_state_valid(vcpu))
+		vmx->emulation_required = 0;
 }
 
 /*
@@ -3121,6 +3119,11 @@ static int kvm_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 	KVMTRACE_3D(VMEXIT, vcpu, exit_reason, (u32)kvm_rip_read(vcpu),
 		    (u32)((u64)kvm_rip_read(vcpu) >> 32), entryexit);
 
+	/* If we need to emulate an MMIO from handle_invalid_guest_state
+	 * we just return 0 */
+	if (vmx->emulation_required && emulate_invalid_guest_state)
+		return 0;
+
 	/* Access CR3 don't cause VMExit in paging mode, so we need
 	 * to sync with guest real CR3. */
 	if (vm_need_ept() && is_paging(vcpu)) {
-- 
1.6.0.3

