Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbXJULIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbXJULIH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 07:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbXJULHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 07:07:54 -0400
Received: from il.qumranet.com ([82.166.9.18]:58420 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbXJULHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 07:07:53 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 04/11] KVM: VMX: Handle NMIs before enabling interrupts and preemption
Date: Sun, 21 Oct 2007 13:08:05 +0200
Message-Id: <11929648921679-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <1192964892617-git-send-email-avi@qumranet.com>
References: <1192964892617-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This makes sure we handle NMI on the current cpu, and that we don't service
maskable interrupts before non-maskable ones.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 4f115a8..bcc1e39 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1760,10 +1760,8 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		set_bit(irq / BITS_PER_LONG, &vcpu->irq_summary);
 	}
 
-	if ((intr_info & INTR_INFO_INTR_TYPE_MASK) == 0x200) { /* nmi */
-		asm ("int $2");
-		return 1;
-	}
+	if ((intr_info & INTR_INFO_INTR_TYPE_MASK) == 0x200) /* nmi */
+		return 1;  /* already handled by vmx_vcpu_run() */
 
 	if (is_no_device(intr_info)) {
 		vmx_fpu_activate(vcpu);
@@ -2196,6 +2194,7 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u32 intr_info;
 
 	/*
 	 * Loading guest fpu may have cleared host cr0.ts
@@ -2322,6 +2321,12 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	asm ("mov %0, %%ds; mov %0, %%es" : : "r"(__USER_DS));
 	vmx->launched = 1;
+
+	intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
+
+	/* We need to handle NMIs before interrupts are enabled */
+	if ((intr_info & INTR_INFO_INTR_TYPE_MASK) == 0x200) /* nmi */
+		asm("int $2");
 }
 
 static void vmx_inject_page_fault(struct kvm_vcpu *vcpu,
-- 
1.5.3

