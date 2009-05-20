Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbZETLcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbZETLcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757215AbZETLVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:21:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55261 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839AbZETLSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:47 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 13/46] KVM: VMX: Do not zero idt_vectoring_info in vmx_complete_interrupts().
Date: Wed, 20 May 2009 14:18:10 +0300
Message-Id: <1242818323-10413-14-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

We will need it later in task_switch().
Code in handle_exception() is dead. is_external_interrupt(vect_info)
will always be false since idt_vectoring_info is zeroed in
vmx_complete_interrupts().

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 577aa95..e4ad9d3 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2626,11 +2626,6 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		printk(KERN_ERR "%s: unexpected, vectoring info 0x%x "
 		       "intr info 0x%x\n", __func__, vect_info, intr_info);
 
-	if (!irqchip_in_kernel(vcpu->kvm) && is_external_interrupt(vect_info)) {
-		int irq = vect_info & VECTORING_INFO_VECTOR_MASK;
-		kvm_push_irq(vcpu, irq);
-	}
-
 	if ((intr_info & INTR_INFO_INTR_TYPE_MASK) == INTR_TYPE_NMI_INTR)
 		return 1;  /* already handled by vmx_vcpu_run() */
 
@@ -3329,11 +3324,9 @@ static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 			kvm_queue_exception_e(&vmx->vcpu, vector, err);
 		} else
 			kvm_queue_exception(&vmx->vcpu, vector);
-		vmx->idt_vectoring_info = 0;
 		break;
 	case INTR_TYPE_EXT_INTR:
 		kvm_queue_interrupt(&vmx->vcpu, vector);
-		vmx->idt_vectoring_info = 0;
 		break;
 	default:
 		break;
-- 
1.6.0.6

