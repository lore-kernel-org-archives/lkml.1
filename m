Return-Path: <linux-kernel-owner+w=401wt.eu-S934719AbZIEAcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934719AbZIEAcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934598AbZIEAcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:32:03 -0400
Received: from kroah.org ([198.145.64.141]:42127 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934588AbZIEAUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:49 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:51 2009
Message-Id: <20090905001450.984456308@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:13:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Glauber Costa <glommer@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, avi@redhat.com
Subject: [patch 23/71] KVM: Introduce {set/get}_interrupt_shadow()
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=kvm-introduce-set-get-_interrupt_shadow.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Glauber Costa <glommer@redhat.com>

This patch introduces set/get_interrupt_shadow(), that does exactly
what the name suggests. It also replaces open code that explicitly does
it with the now existent functions. It differs slightly from upstream,
because upstream merged it after gleb's interrupt rework, that we don't
ship.

Just for reference, upstream changelog is
(2809f5d2c4cfad171167b131bb2a21ab65eba40f):

This patch replaces drop_interrupt_shadow with the more
general set_interrupt_shadow, that can either drop or raise
it, depending on its parameter.  It also adds ->get_interrupt_shadow()
for future use.

Signed-off-by: Glauber Costa <glommer@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/include/asm/kvm_host.h        |    2 +
 arch/x86/include/asm/kvm_x86_emulate.h |    3 ++
 arch/x86/kvm/svm.c                     |   25 ++++++++++++++++++-
 arch/x86/kvm/vmx.c                     |   42 +++++++++++++++++++++++++--------
 4 files changed, 62 insertions(+), 10 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -513,6 +513,8 @@ struct kvm_x86_ops {
 	void (*run)(struct kvm_vcpu *vcpu, struct kvm_run *run);
 	int (*handle_exit)(struct kvm_run *run, struct kvm_vcpu *vcpu);
 	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
+	void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
+	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
 	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
 				unsigned char *hypercall_addr);
 	int (*get_irq)(struct kvm_vcpu *vcpu);
--- a/arch/x86/include/asm/kvm_x86_emulate.h
+++ b/arch/x86/include/asm/kvm_x86_emulate.h
@@ -143,6 +143,9 @@ struct decode_cache {
 	struct fetch_cache fetch;
 };
 
+#define X86_SHADOW_INT_MOV_SS  1
+#define X86_SHADOW_INT_STI     2
+
 struct x86_emulate_ctxt {
 	/* Register state before/after emulation. */
 	struct kvm_vcpu *vcpu;
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -227,6 +227,27 @@ static int is_external_interrupt(u32 inf
 	return info == (SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR);
 }
 
+static u32 svm_get_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	u32 ret = 0;
+
+	if (svm->vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK)
+		ret |= X86_SHADOW_INT_STI | X86_SHADOW_INT_MOV_SS;
+	return ret & mask;
+}
+
+static void svm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (mask == 0)
+		svm->vmcb->control.int_state &= ~SVM_INTERRUPT_SHADOW_MASK;
+	else
+		svm->vmcb->control.int_state |= SVM_INTERRUPT_SHADOW_MASK;
+
+}
+
 static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -240,7 +261,7 @@ static void skip_emulated_instruction(st
 		       __func__, kvm_rip_read(vcpu), svm->next_rip);
 
 	kvm_rip_write(vcpu, svm->next_rip);
-	svm->vmcb->control.int_state &= ~SVM_INTERRUPT_SHADOW_MASK;
+	svm_set_interrupt_shadow(vcpu, 0);
 
 	vcpu->arch.interrupt_window_open = (svm->vcpu.arch.hflags & HF_GIF_MASK);
 }
@@ -2667,6 +2688,8 @@ static struct kvm_x86_ops svm_x86_ops = 
 	.run = svm_vcpu_run,
 	.handle_exit = handle_exit,
 	.skip_emulated_instruction = skip_emulated_instruction,
+	.set_interrupt_shadow = svm_set_interrupt_shadow,
+	.get_interrupt_shadow = svm_get_interrupt_shadow,
 	.patch_hypercall = svm_patch_hypercall,
 	.get_irq = svm_get_irq,
 	.set_irq = svm_set_irq,
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -732,23 +732,45 @@ static void vmx_set_rflags(struct kvm_vc
 	vmcs_writel(GUEST_RFLAGS, rflags);
 }
 
+static u32 vmx_get_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
+{
+	u32 interruptibility = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
+	int ret = 0;
+
+	if (interruptibility & GUEST_INTR_STATE_STI)
+		ret |= X86_SHADOW_INT_STI;
+	if (interruptibility & GUEST_INTR_STATE_MOV_SS)
+		ret |= X86_SHADOW_INT_MOV_SS;
+
+	return ret & mask;
+}
+
+static void vmx_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
+{
+	u32 interruptibility_old = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
+	u32 interruptibility = interruptibility_old;
+
+	interruptibility &= ~(GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS);
+
+	if (mask & X86_SHADOW_INT_MOV_SS)
+		interruptibility |= GUEST_INTR_STATE_MOV_SS;
+	if (mask & X86_SHADOW_INT_STI)
+		interruptibility |= GUEST_INTR_STATE_STI;
+
+	if ((interruptibility != interruptibility_old))
+		vmcs_write32(GUEST_INTERRUPTIBILITY_INFO, interruptibility);
+}
+
 static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
 	unsigned long rip;
-	u32 interruptibility;
 
 	rip = kvm_rip_read(vcpu);
 	rip += vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
 	kvm_rip_write(vcpu, rip);
 
-	/*
-	 * We emulated an instruction, so temporary interrupt blocking
-	 * should be removed, if set.
-	 */
-	interruptibility = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
-	if (interruptibility & 3)
-		vmcs_write32(GUEST_INTERRUPTIBILITY_INFO,
-			     interruptibility & ~3);
+	/* skipping an emulated instruction also counts */
+	vmx_set_interrupt_shadow(vcpu, 0);
 	vcpu->arch.interrupt_window_open = 1;
 }
 
@@ -3738,6 +3760,8 @@ static struct kvm_x86_ops vmx_x86_ops = 
 	.run = vmx_vcpu_run,
 	.handle_exit = kvm_handle_exit,
 	.skip_emulated_instruction = skip_emulated_instruction,
+	.set_interrupt_shadow = vmx_set_interrupt_shadow,
+	.get_interrupt_shadow = vmx_get_interrupt_shadow,
 	.patch_hypercall = vmx_patch_hypercall,
 	.get_irq = vmx_get_irq,
 	.set_irq = vmx_inject_irq,


