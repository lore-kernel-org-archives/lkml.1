Return-Path: <linux-kernel-owner+w=401wt.eu-S1758737AbZBZOWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbZBZOWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:22:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757299AbZBZOQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:16:17 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43064 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431AbZBZOPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 14/40] KVM: VMX: Allow single-stepping when uninterruptible
Date: Thu, 26 Feb 2009 16:15:04 +0200
Message-Id: <1235657730-27683-15-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

When single-stepping over STI and MOV SS, we must clear the
corresponding interruptibility bits in the guest state. Otherwise
vmentry fails as it then expects bit 14 (BS) in pending debug exceptions
being set, but that's not correct for the guest debugging case.

Note that clearing those bits is safe as we check for interruptibility
based on the original state and do not inject interrupts or NMIs if
guest interruptibility was blocked.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f55690d..c776868 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2478,6 +2478,11 @@ static void do_interrupt_requests(struct kvm_vcpu *vcpu,
 {
 	vmx_update_window_states(vcpu);
 
+	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
+		vmcs_clear_bits(GUEST_INTERRUPTIBILITY_INFO,
+				GUEST_INTR_STATE_STI |
+				GUEST_INTR_STATE_MOV_SS);
+
 	if (vcpu->arch.nmi_pending && !vcpu->arch.nmi_injected) {
 		if (vcpu->arch.interrupt.pending) {
 			enable_nmi_window(vcpu);
@@ -3244,6 +3249,11 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 
 	vmx_update_window_states(vcpu);
 
+	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
+		vmcs_clear_bits(GUEST_INTERRUPTIBILITY_INFO,
+				GUEST_INTR_STATE_STI |
+				GUEST_INTR_STATE_MOV_SS);
+
 	if (vcpu->arch.nmi_pending && !vcpu->arch.nmi_injected) {
 		if (vcpu->arch.interrupt.pending) {
 			enable_nmi_window(vcpu);
-- 
1.6.0.6

