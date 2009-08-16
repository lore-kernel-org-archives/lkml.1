Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbZHPJaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbZHPJaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbZHPJaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:30:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45331 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbZHPJaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:10 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/48] KVM: VMX: Properly handle software interrupt re-injection in real mode
Date: Sun, 16 Aug 2009 12:29:21 +0300
Message-Id: <1250415008-17175-2-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

When reinjecting a software interrupt or exception, use the correct
instruction length provided by the hardware instead of a hardcoded 1.

Fixes problems running the suse 9.1 livecd boot loader.

Problem introduced by commit f0a3602c20 ("KVM: Move interrupt injection
logic to x86.c").

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 29f9129..db0b8b6 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -801,8 +801,9 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
 		vmx->rmode.irq.pending = true;
 		vmx->rmode.irq.vector = nr;
 		vmx->rmode.irq.rip = kvm_rip_read(vcpu);
-		if (nr == BP_VECTOR || nr == OF_VECTOR)
-			vmx->rmode.irq.rip++;
+		if (kvm_exception_is_soft(nr))
+			vmx->rmode.irq.rip +=
+				vmx->vcpu.arch.event_exit_inst_len;
 		intr_info |= INTR_TYPE_SOFT_INTR;
 		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
 		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN, 1);
@@ -2468,6 +2469,9 @@ static void vmx_inject_irq(struct kvm_vcpu *vcpu)
 		vmx->rmode.irq.pending = true;
 		vmx->rmode.irq.vector = irq;
 		vmx->rmode.irq.rip = kvm_rip_read(vcpu);
+		if (vcpu->arch.interrupt.soft)
+			vmx->rmode.irq.rip +=
+				vmx->vcpu.arch.event_exit_inst_len;
 		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
 			     irq | INTR_TYPE_SOFT_INTR | INTR_INFO_VALID_MASK);
 		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN, 1);
-- 
1.6.3.3

