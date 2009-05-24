Return-Path: <linux-kernel-owner+w=401wt.eu-S1759681AbZEXQBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759681AbZEXQBS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 12:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758959AbZEXPy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:54:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41832 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbZEXPuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:32 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 08/45] KVM: Get rid of get_irq() callback
Date: Sun, 24 May 2009 18:49:53 +0300
Message-Id: <1243180230-2480-9-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

It just returns pending IRQ vector from the queue for VMX/SVM.
Get IRQ directly from the queue before migration and put it back
after.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 -
 arch/x86/kvm/svm.c              |    8 --------
 arch/x86/kvm/vmx.c              |    8 --------
 arch/x86/kvm/x86.c              |   12 +++++-------
 4 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index dd9ecd3..3e94d05 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -510,7 +510,6 @@ struct kvm_x86_ops {
 	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
 	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
 				unsigned char *hypercall_addr);
-	int (*get_irq)(struct kvm_vcpu *vcpu);
 	void (*set_irq)(struct kvm_vcpu *vcpu, int vec);
 	void (*set_nmi)(struct kvm_vcpu *vcpu);
 	void (*queue_exception)(struct kvm_vcpu *vcpu, unsigned nr,
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1807288..d96a6d3 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -966,13 +966,6 @@ static int svm_guest_debug(struct kvm_vcpu *vcpu, struct kvm_guest_debug *dbg)
 	return 0;
 }
 
-static int svm_get_irq(struct kvm_vcpu *vcpu)
-{
-	if (!vcpu->arch.interrupt.pending)
-		return -1;
-	return vcpu->arch.interrupt.nr;
-}
-
 static void load_host_msrs(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_X86_64
@@ -2647,7 +2640,6 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.handle_exit = handle_exit,
 	.skip_emulated_instruction = skip_emulated_instruction,
 	.patch_hypercall = svm_patch_hypercall,
-	.get_irq = svm_get_irq,
 	.set_irq = svm_set_irq,
 	.set_nmi = svm_inject_nmi,
 	.queue_exception = svm_queue_exception,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index bad2413..25be53a 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1045,13 +1045,6 @@ static int set_guest_debug(struct kvm_vcpu *vcpu, struct kvm_guest_debug *dbg)
 	return 0;
 }
 
-static int vmx_get_irq(struct kvm_vcpu *vcpu)
-{
-	if (!vcpu->arch.interrupt.pending)
-		return -1;
-	return vcpu->arch.interrupt.nr;
-}
-
 static __init int cpu_has_kvm_support(void)
 {
 	return cpu_has_vmx();
@@ -3634,7 +3627,6 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.handle_exit = vmx_handle_exit,
 	.skip_emulated_instruction = skip_emulated_instruction,
 	.patch_hypercall = vmx_patch_hypercall,
-	.get_irq = vmx_get_irq,
 	.set_irq = vmx_inject_irq,
 	.set_nmi = vmx_inject_nmi,
 	.queue_exception = vmx_queue_exception,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf315e8..8f4dc86 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3532,7 +3532,6 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 				  struct kvm_sregs *sregs)
 {
 	struct descriptor_table dt;
-	int pending_vec;
 
 	vcpu_load(vcpu);
 
@@ -3569,9 +3568,9 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 		memcpy(sregs->interrupt_bitmap, vcpu->arch.irq_pending,
 		       sizeof sregs->interrupt_bitmap);
 
-	pending_vec = kvm_x86_ops->get_irq(vcpu);
-	if (pending_vec >= 0)
-		set_bit(pending_vec, (unsigned long *)sregs->interrupt_bitmap);
+	if (vcpu->arch.interrupt.pending)
+		set_bit(vcpu->arch.interrupt.nr,
+			(unsigned long *)sregs->interrupt_bitmap);
 
 	vcpu_put(vcpu);
 
@@ -4093,9 +4092,8 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 			max_bits);
 		/* Only pending external irq is handled here */
 		if (pending_vec < max_bits) {
-			kvm_x86_ops->set_irq(vcpu, pending_vec);
-			pr_debug("Set back pending irq %d\n",
-				 pending_vec);
+			kvm_queue_interrupt(vcpu, pending_vec);
+			pr_debug("Set back pending irq %d\n", pending_vec);
 		}
 		kvm_pic_clear_isr_ack(vcpu->kvm);
 	}
-- 
1.6.0.6

