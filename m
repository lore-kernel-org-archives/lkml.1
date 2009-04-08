Return-Path: <linux-kernel-owner+w=401wt.eu-S1753599AbZDHD1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbZDHD1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 23:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZDHD1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 23:27:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51209 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbZDHD1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 23:27:10 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com
Subject: [PATCH] do not keep interrupt window closed by sti in real mode
Date: Wed,  8 Apr 2009 00:23:37 -0300
Message-Id: <1239161017-7398-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While in real mode, sti does not block interrupts from the subsequent
instruction. This is stated at Intel SDM Volume 2b, page 4-432

Without this patch, I cannot boot gpxe option roms at vmx machines.
This is described at https://bugzilla.redhat.com/show_bug.cgi?id=494469

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 arch/x86/kvm/vmx.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c6997c0..51e0b8a 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2490,18 +2490,19 @@ static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
 static void vmx_update_window_states(struct kvm_vcpu *vcpu)
 {
 	u32 guest_intr = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
+	int rmode = vcpu->arch.rmode.active;
 
 	vcpu->arch.nmi_window_open =
-		!(guest_intr & (GUEST_INTR_STATE_STI |
-				GUEST_INTR_STATE_MOV_SS |
+		(rmode || !(guest_intr & GUEST_INTR_STATE_STI)) &&
+		!(guest_intr & (GUEST_INTR_STATE_MOV_SS |
 				GUEST_INTR_STATE_NMI));
 	if (!cpu_has_virtual_nmis() && to_vmx(vcpu)->soft_vnmi_blocked)
 		vcpu->arch.nmi_window_open = 0;
 
 	vcpu->arch.interrupt_window_open =
 		((vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) &&
-		 !(guest_intr & (GUEST_INTR_STATE_STI |
-				 GUEST_INTR_STATE_MOV_SS)));
+		(rmode || !(guest_intr & GUEST_INTR_STATE_STI)) &&
+		 !(guest_intr & GUEST_INTR_STATE_MOV_SS));
 }
 
 static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu)
-- 
1.6.2

