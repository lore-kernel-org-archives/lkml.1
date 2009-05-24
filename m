Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbZEXPuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbZEXPuo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZEXPub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:50:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41818 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbZEXPua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:30 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 01/45] KVM: Remove inject_pending_vectors() callback
Date: Sun, 24 May 2009 18:49:46 +0300
Message-Id: <1243180230-2480-2-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

It is the same as inject_pending_irq() for VMX/SVM now.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 --
 arch/x86/kvm/svm.c              |    1 -
 arch/x86/kvm/vmx.c              |    1 -
 arch/x86/kvm/x86.c              |    4 +---
 4 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ea3741e..aa5a54e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -517,8 +517,6 @@ struct kvm_x86_ops {
 	void (*queue_exception)(struct kvm_vcpu *vcpu, unsigned nr,
 				bool has_error_code, u32 error_code);
 	void (*inject_pending_irq)(struct kvm_vcpu *vcpu, struct kvm_run *run);
-	void (*inject_pending_vectors)(struct kvm_vcpu *vcpu,
-				       struct kvm_run *run);
 	int (*interrupt_allowed)(struct kvm_vcpu *vcpu);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*get_tdp_level)(void);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8fa5a0e..2905475 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2655,7 +2655,6 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.set_irq = svm_set_irq,
 	.queue_exception = svm_queue_exception,
 	.inject_pending_irq = svm_intr_assist,
-	.inject_pending_vectors = svm_intr_assist,
 	.interrupt_allowed = svm_interrupt_allowed,
 
 	.set_tss_addr = svm_set_tss_addr,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 3186fcf..9162b4c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3693,7 +3693,6 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.set_irq = vmx_inject_irq,
 	.queue_exception = vmx_queue_exception,
 	.inject_pending_irq = vmx_intr_assist,
-	.inject_pending_vectors = vmx_intr_assist,
 	.interrupt_allowed = vmx_interrupt_allowed,
 	.set_tss_addr = vmx_set_tss_addr,
 	.get_tdp_level = get_ept_level,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2683d7e..4bd56c7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3167,10 +3167,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	if (vcpu->arch.exception.pending)
 		__queue_exception(vcpu);
-	else if (irqchip_in_kernel(vcpu->kvm))
-		kvm_x86_ops->inject_pending_irq(vcpu, kvm_run);
 	else
-		kvm_x86_ops->inject_pending_vectors(vcpu, kvm_run);
+		kvm_x86_ops->inject_pending_irq(vcpu, kvm_run);
 
 	kvm_lapic_sync_to_vapic(vcpu);
 
-- 
1.6.0.6

