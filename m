Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbZHPJbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbZHPJbp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbZHPJbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:31:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45381 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114AbZHPJaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:15 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 45/48] KVM: Introduce kvm_vcpu_is_bsp() function.
Date: Sun, 16 Aug 2009 12:30:05 +0300
Message-Id: <1250415008-17175-46-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Use it instead of open code "vcpu_id zero is BSP" assumption.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c |    2 +-
 arch/ia64/kvm/vcpu.c     |    2 +-
 arch/x86/kvm/i8254.c     |    4 ++--
 arch/x86/kvm/i8259.c     |    6 +++---
 arch/x86/kvm/lapic.c     |    7 ++++---
 arch/x86/kvm/svm.c       |    4 ++--
 arch/x86/kvm/vmx.c       |    6 +++---
 arch/x86/kvm/x86.c       |    4 ++--
 include/linux/kvm_host.h |    5 +++++
 virt/kvm/ioapic.c        |    4 +++-
 virt/kvm/kvm_main.c      |    2 ++
 11 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 8dde369..4082665 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1216,7 +1216,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	if (IS_ERR(vmm_vcpu))
 		return PTR_ERR(vmm_vcpu);
 
-	if (vcpu->vcpu_id == 0) {
+	if (kvm_vcpu_is_bsp(vcpu)) {
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
 		/*Set entry address for first run.*/
diff --git a/arch/ia64/kvm/vcpu.c b/arch/ia64/kvm/vcpu.c
index cc406d0..61a3320 100644
--- a/arch/ia64/kvm/vcpu.c
+++ b/arch/ia64/kvm/vcpu.c
@@ -830,7 +830,7 @@ static void vcpu_set_itc(struct kvm_vcpu *vcpu, u64 val)
 
 	kvm = (struct kvm *)KVM_VM_BASE;
 
-	if (vcpu->vcpu_id == 0) {
+	if (kvm_vcpu_is_bsp(vcpu)) {
 		for (i = 0; i < kvm->arch.online_vcpus; i++) {
 			v = (struct kvm_vcpu *)((char *)vcpu +
 					sizeof(struct kvm_vcpu_data) * i);
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 3837db6..008a831 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -231,7 +231,7 @@ int pit_has_pending_timer(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pit *pit = vcpu->kvm->arch.vpit;
 
-	if (pit && vcpu->vcpu_id == 0 && pit->pit_state.irq_ack)
+	if (pit && kvm_vcpu_is_bsp(vcpu) && pit->pit_state.irq_ack)
 		return atomic_read(&pit->pit_state.pit_timer.pending);
 	return 0;
 }
@@ -252,7 +252,7 @@ void __kvm_migrate_pit_timer(struct kvm_vcpu *vcpu)
 	struct kvm_pit *pit = vcpu->kvm->arch.vpit;
 	struct hrtimer *timer;
 
-	if (vcpu->vcpu_id != 0 || !pit)
+	if (!kvm_vcpu_is_bsp(vcpu) || !pit)
 		return;
 
 	timer = &pit->pit_state.pit_timer.timer;
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index bf94a45..148c52a 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -57,7 +57,7 @@ static void pic_unlock(struct kvm_pic *s)
 	}
 
 	if (wakeup) {
-		vcpu = s->kvm->vcpus[0];
+		vcpu = s->kvm->bsp_vcpu;
 		if (vcpu)
 			kvm_vcpu_kick(vcpu);
 	}
@@ -254,7 +254,7 @@ void kvm_pic_reset(struct kvm_kpic_state *s)
 {
 	int irq, irqbase, n;
 	struct kvm *kvm = s->pics_state->irq_request_opaque;
-	struct kvm_vcpu *vcpu0 = kvm->vcpus[0];
+	struct kvm_vcpu *vcpu0 = kvm->bsp_vcpu;
 
 	if (s == &s->pics_state->pics[0])
 		irqbase = 0;
@@ -512,7 +512,7 @@ static void picdev_read(struct kvm_io_device *this,
 static void pic_irq_request(void *opaque, int level)
 {
 	struct kvm *kvm = opaque;
-	struct kvm_vcpu *vcpu = kvm->vcpus[0];
+	struct kvm_vcpu *vcpu = kvm->bsp_vcpu;
 	struct kvm_pic *s = pic_irqchip(kvm);
 	int irq = pic_get_irq(&s->pics[0]);
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 44f20cd..b066130 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -793,7 +793,8 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 		vcpu->arch.apic_base = value;
 		return;
 	}
-	if (apic->vcpu->vcpu_id)
+
+	if (!kvm_vcpu_is_bsp(apic->vcpu))
 		value &= ~MSR_IA32_APICBASE_BSP;
 
 	vcpu->arch.apic_base = value;
@@ -844,7 +845,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu)
 	}
 	update_divide_count(apic);
 	atomic_set(&apic->lapic_timer.pending, 0);
-	if (vcpu->vcpu_id == 0)
+	if (kvm_vcpu_is_bsp(vcpu))
 		vcpu->arch.apic_base |= MSR_IA32_APICBASE_BSP;
 	apic_update_ppr(apic);
 
@@ -985,7 +986,7 @@ int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu)
 	u32 lvt0 = apic_get_reg(vcpu->arch.apic, APIC_LVT0);
 	int r = 0;
 
-	if (vcpu->vcpu_id == 0) {
+	if (kvm_vcpu_is_bsp(vcpu)) {
 		if (!apic_hw_enabled(vcpu->arch.apic))
 			r = 1;
 		if ((lvt0 & APIC_LVT_MASKED) == 0 &&
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 0710e45..a7fa87b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -645,7 +645,7 @@ static int svm_vcpu_reset(struct kvm_vcpu *vcpu)
 
 	init_vmcb(svm);
 
-	if (vcpu->vcpu_id != 0) {
+	if (!kvm_vcpu_is_bsp(vcpu)) {
 		kvm_rip_write(vcpu, 0);
 		svm->vmcb->save.cs.base = svm->vcpu.arch.sipi_vector << 12;
 		svm->vmcb->save.cs.selector = svm->vcpu.arch.sipi_vector << 8;
@@ -709,7 +709,7 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	fx_init(&svm->vcpu);
 	svm->vcpu.fpu_active = 1;
 	svm->vcpu.arch.apic_base = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
-	if (svm->vcpu.vcpu_id == 0)
+	if (kvm_vcpu_is_bsp(&svm->vcpu))
 		svm->vcpu.arch.apic_base |= MSR_IA32_APICBASE_BSP;
 
 	return &svm->vcpu;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ae68292..c08bb4c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2411,7 +2411,7 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
 	kvm_set_cr8(&vmx->vcpu, 0);
 	msr = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
-	if (vmx->vcpu.vcpu_id == 0)
+	if (kvm_vcpu_is_bsp(&vmx->vcpu))
 		msr |= MSR_IA32_APICBASE_BSP;
 	kvm_set_apic_base(&vmx->vcpu, msr);
 
@@ -2422,7 +2422,7 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 	 * GUEST_CS_BASE should really be 0xffff0000, but VT vm86 mode
 	 * insists on having GUEST_CS_BASE == GUEST_CS_SELECTOR << 4.  Sigh.
 	 */
-	if (vmx->vcpu.vcpu_id == 0) {
+	if (kvm_vcpu_is_bsp(&vmx->vcpu)) {
 		vmcs_write16(GUEST_CS_SELECTOR, 0xf000);
 		vmcs_writel(GUEST_CS_BASE, 0x000f0000);
 	} else {
@@ -2451,7 +2451,7 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 	vmcs_writel(GUEST_SYSENTER_EIP, 0);
 
 	vmcs_writel(GUEST_RFLAGS, 0x02);
-	if (vmx->vcpu.vcpu_id == 0)
+	if (kvm_vcpu_is_bsp(&vmx->vcpu))
 		kvm_rip_write(vcpu, 0xfff0);
 	else
 		kvm_rip_write(vcpu, 0);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e877efa..d8adc1d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4330,7 +4330,7 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	kvm_set_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
 
 	/* Older userspace won't unhalt the vcpu on reset. */
-	if (vcpu->vcpu_id == 0 && kvm_rip_read(vcpu) == 0xfff0 &&
+	if (kvm_vcpu_is_bsp(vcpu) && kvm_rip_read(vcpu) == 0xfff0 &&
 	    sregs->cs.selector == 0xf000 && sregs->cs.base == 0xffff0000 &&
 	    !(vcpu->arch.cr0 & X86_CR0_PE))
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
@@ -4601,7 +4601,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	kvm = vcpu->kvm;
 
 	vcpu->arch.mmu.root_hpa = INVALID_PAGE;
-	if (!irqchip_in_kernel(kvm) || vcpu->vcpu_id == 0)
+	if (!irqchip_in_kernel(kvm) || kvm_vcpu_is_bsp(vcpu))
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 	else
 		vcpu->arch.mp_state = KVM_MP_STATE_UNINITIALIZED;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a29ea03..a5bd429 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -131,6 +131,7 @@ struct kvm {
 	int nmemslots;
 	struct kvm_memory_slot memslots[KVM_MEMORY_SLOTS +
 					KVM_PRIVATE_MEM_SLOTS];
+	struct kvm_vcpu *bsp_vcpu;
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 	struct list_head vm_list;
 	struct mutex lock;
@@ -549,4 +550,8 @@ static inline void kvm_irqfd_release(struct kvm *kvm) {}
 
 #endif /* CONFIG_HAVE_KVM_EVENTFD */
 
+static inline bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
+{
+	return vcpu->kvm->bsp_vcpu == vcpu;
+}
 #endif
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 2a56671..0532fa6 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -164,7 +164,9 @@ static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 	/* Always delivery PIT interrupt to vcpu 0 */
 	if (irq == 0) {
 		irqe.dest_mode = 0; /* Physical mode. */
-		irqe.dest_id = ioapic->kvm->vcpus[0]->vcpu_id;
+		/* need to read apic_id from apic regiest since
+		 * it can be rewritten */
+		irqe.dest_id = ioapic->kvm->bsp_vcpu->vcpu_id;
 	}
 #endif
 	return kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0d481b2..0d54ede 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1747,6 +1747,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 		goto vcpu_destroy;
 	}
 	kvm->vcpus[n] = vcpu;
+	if (n == 0)
+		kvm->bsp_vcpu = vcpu;
 	mutex_unlock(&kvm->lock);
 
 	/* Now it's all set up, let userspace reach it */
-- 
1.6.3.3

