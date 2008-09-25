Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbYIYL47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbYIYL47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 07:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbYIYLz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:55:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48520 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817AbYIYLzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:55:23 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 04/39] KVM: VMX: Use interrupt queue for !irqchip_in_kernel
Date: Thu, 25 Sep 2008 14:54:36 +0300
Message-Id: <1222343711-12508-5-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 229e2d0..81db7d4 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2173,7 +2173,7 @@ static void kvm_do_inject_irq(struct kvm_vcpu *vcpu)
 	clear_bit(bit_index, &vcpu->arch.irq_pending[word_index]);
 	if (!vcpu->arch.irq_pending[word_index])
 		clear_bit(word_index, &vcpu->arch.irq_summary);
-	vmx_inject_irq(vcpu, irq);
+	kvm_queue_interrupt(vcpu, irq);
 }
 
 
@@ -2187,13 +2187,12 @@ static void do_interrupt_requests(struct kvm_vcpu *vcpu,
 		 (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & 3) == 0);
 
 	if (vcpu->arch.interrupt_window_open &&
-	    vcpu->arch.irq_summary &&
-	    !(vmcs_read32(VM_ENTRY_INTR_INFO_FIELD) & INTR_INFO_VALID_MASK))
-		/*
-		 * If interrupts enabled, and not blocked by sti or mov ss. Good.
-		 */
+	    vcpu->arch.irq_summary && !vcpu->arch.interrupt.pending)
 		kvm_do_inject_irq(vcpu);
 
+	if (vcpu->arch.interrupt_window_open && vcpu->arch.interrupt.pending)
+		vmx_inject_irq(vcpu, vcpu->arch.interrupt.nr);
+
 	cpu_based_vm_exec_control = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
 	if (!vcpu->arch.interrupt_window_open &&
 	    (vcpu->arch.irq_summary || kvm_run->request_interrupt_window))
-- 
1.6.0.1

