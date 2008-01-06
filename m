Return-Path: <linux-kernel-owner+w=401wt.eu-S1758780AbYAFOlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780AbYAFOlY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757907AbYAFOju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:39:50 -0500
Received: from il.qumranet.com ([82.166.9.18]:46594 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728AbYAFOjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:42 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 04/33] KVM: Portability: Introduce kvm_vcpu_arch
Date: Sun,  6 Jan 2008 16:39:10 +0200
Message-Id: <1199630379-28638-5-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

Move all the architecture-specific fields in kvm_vcpu into a new struct
kvm_vcpu_arch.

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/ioapic.c      |   10 +-
 drivers/kvm/kvm_main.c    |    2 +-
 drivers/kvm/lapic.c       |   91 ++++----
 drivers/kvm/mmu.c         |  142 ++++++------
 drivers/kvm/paging_tmpl.h |   16 +-
 drivers/kvm/svm.c         |  122 ++++++------
 drivers/kvm/vmx.c         |  212 +++++++++---------
 drivers/kvm/x86.c         |  522 ++++++++++++++++++++++----------------------
 drivers/kvm/x86.h         |   25 ++-
 drivers/kvm/x86_emulate.c |   24 +-
 10 files changed, 585 insertions(+), 581 deletions(-)

diff --git a/drivers/kvm/ioapic.c b/drivers/kvm/ioapic.c
index e7debfa..0491036 100644
--- a/drivers/kvm/ioapic.c
+++ b/drivers/kvm/ioapic.c
@@ -158,7 +158,7 @@ static u32 ioapic_get_delivery_bitmask(struct kvm_ioapic *ioapic, u8 dest,
 	if (dest_mode == 0) {	/* Physical mode. */
 		if (dest == 0xFF) {	/* Broadcast. */
 			for (i = 0; i < KVM_MAX_VCPUS; ++i)
-				if (kvm->vcpus[i] && kvm->vcpus[i]->apic)
+				if (kvm->vcpus[i] && kvm->vcpus[i]->arch.apic)
 					mask |= 1 << i;
 			return mask;
 		}
@@ -166,8 +166,8 @@ static u32 ioapic_get_delivery_bitmask(struct kvm_ioapic *ioapic, u8 dest,
 			vcpu = kvm->vcpus[i];
 			if (!vcpu)
 				continue;
-			if (kvm_apic_match_physical_addr(vcpu->apic, dest)) {
-				if (vcpu->apic)
+			if (kvm_apic_match_physical_addr(vcpu->arch.apic, dest)) {
+				if (vcpu->arch.apic)
 					mask = 1 << i;
 				break;
 			}
@@ -177,8 +177,8 @@ static u32 ioapic_get_delivery_bitmask(struct kvm_ioapic *ioapic, u8 dest,
 			vcpu = kvm->vcpus[i];
 			if (!vcpu)
 				continue;
-			if (vcpu->apic &&
-			    kvm_apic_match_logical_addr(vcpu->apic, dest))
+			if (vcpu->arch.apic &&
+			    kvm_apic_match_logical_addr(vcpu->arch.apic, dest))
 				mask |= 1 << vcpu->vcpu_id;
 		}
 	ioapic_debug("mask %x\n", mask);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index cfb27ef..5bfa200 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -670,7 +670,7 @@ static int kvm_vcpu_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (vmf->pgoff == 0)
 		page = virt_to_page(vcpu->run);
 	else if (vmf->pgoff == KVM_PIO_PAGE_OFFSET)
-		page = virt_to_page(vcpu->pio_data);
+		page = virt_to_page(vcpu->arch.pio_data);
 	else
 		return VM_FAULT_SIGBUS;
 	get_page(page);
diff --git a/drivers/kvm/lapic.c b/drivers/kvm/lapic.c
index 466c37f..5c9f467 100644
--- a/drivers/kvm/lapic.c
+++ b/drivers/kvm/lapic.c
@@ -58,6 +58,7 @@
 
 #define VEC_POS(v) ((v) & (32 - 1))
 #define REG_POS(v) (((v) >> 5) << 4)
+
 static inline u32 apic_get_reg(struct kvm_lapic *apic, int reg_off)
 {
 	return *((u32 *) (apic->regs + reg_off));
@@ -90,7 +91,7 @@ static inline void apic_clear_vector(int vec, void *bitmap)
 
 static inline int apic_hw_enabled(struct kvm_lapic *apic)
 {
-	return (apic)->vcpu->apic_base & MSR_IA32_APICBASE_ENABLE;
+	return (apic)->vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE;
 }
 
 static inline int  apic_sw_enabled(struct kvm_lapic *apic)
@@ -174,7 +175,7 @@ static inline int apic_find_highest_irr(struct kvm_lapic *apic)
 
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu)
 {
-	struct kvm_lapic *apic = vcpu->apic;
+	struct kvm_lapic *apic = vcpu->arch.apic;
 	int highest_irr;
 
 	if (!apic)
@@ -187,7 +188,7 @@ EXPORT_SYMBOL_GPL(kvm_lapic_find_highest_irr);
 
 int kvm_apic_set_irq(struct kvm_vcpu *vcpu, u8 vec, u8 trig)
 {
-	struct kvm_lapic *apic = vcpu->apic;
+	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	if (!apic_test_and_set_irr(vec, apic)) {
 		/* a new pending irq is set in IRR */
@@ -272,7 +273,7 @@ static int apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
 			   int short_hand, int dest, int dest_mode)
 {
 	int result = 0;
-	struct kvm_lapic *target = vcpu->apic;
+	struct kvm_lapic *target = vcpu->arch.apic;
 
 	apic_debug("target %p, source %p, dest 0x%x, "
 		   "dest_mode 0x%x, short_hand 0x%x",
@@ -339,10 +340,10 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 		} else
 			apic_clear_vector(vector, apic->regs + APIC_TMR);
 
-		if (vcpu->mp_state == VCPU_MP_STATE_RUNNABLE)
+		if (vcpu->arch.mp_state == VCPU_MP_STATE_RUNNABLE)
 			kvm_vcpu_kick(vcpu);
-		else if (vcpu->mp_state == VCPU_MP_STATE_HALTED) {
-			vcpu->mp_state = VCPU_MP_STATE_RUNNABLE;
+		else if (vcpu->arch.mp_state == VCPU_MP_STATE_HALTED) {
+			vcpu->arch.mp_state = VCPU_MP_STATE_RUNNABLE;
 			if (waitqueue_active(&vcpu->wq))
 				wake_up_interruptible(&vcpu->wq);
 		}
@@ -363,11 +364,11 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 
 	case APIC_DM_INIT:
 		if (level) {
-			if (vcpu->mp_state == VCPU_MP_STATE_RUNNABLE)
+			if (vcpu->arch.mp_state == VCPU_MP_STATE_RUNNABLE)
 				printk(KERN_DEBUG
 				       "INIT on a runnable vcpu %d\n",
 				       vcpu->vcpu_id);
-			vcpu->mp_state = VCPU_MP_STATE_INIT_RECEIVED;
+			vcpu->arch.mp_state = VCPU_MP_STATE_INIT_RECEIVED;
 			kvm_vcpu_kick(vcpu);
 		} else {
 			printk(KERN_DEBUG
@@ -380,9 +381,9 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 	case APIC_DM_STARTUP:
 		printk(KERN_DEBUG "SIPI to vcpu %d vector 0x%02x\n",
 		       vcpu->vcpu_id, vector);
-		if (vcpu->mp_state == VCPU_MP_STATE_INIT_RECEIVED) {
-			vcpu->sipi_vector = vector;
-			vcpu->mp_state = VCPU_MP_STATE_SIPI_RECEIVED;
+		if (vcpu->arch.mp_state == VCPU_MP_STATE_INIT_RECEIVED) {
+			vcpu->arch.sipi_vector = vector;
+			vcpu->arch.mp_state = VCPU_MP_STATE_SIPI_RECEIVED;
 			if (waitqueue_active(&vcpu->wq))
 				wake_up_interruptible(&vcpu->wq);
 		}
@@ -411,7 +412,7 @@ static struct kvm_lapic *kvm_apic_round_robin(struct kvm *kvm, u8 vector,
 			next = 0;
 		if (kvm->vcpus[next] == NULL || !test_bit(next, &bitmap))
 			continue;
-		apic = kvm->vcpus[next]->apic;
+		apic = kvm->vcpus[next]->arch.apic;
 		if (apic && apic_enabled(apic))
 			break;
 		apic = NULL;
@@ -482,12 +483,12 @@ static void apic_send_ipi(struct kvm_lapic *apic)
 		if (!vcpu)
 			continue;
 
-		if (vcpu->apic &&
+		if (vcpu->arch.apic &&
 		    apic_match_dest(vcpu, apic, short_hand, dest, dest_mode)) {
 			if (delivery_mode == APIC_DM_LOWEST)
 				set_bit(vcpu->vcpu_id, &lpr_map);
 			else
-				__apic_accept_irq(vcpu->apic, delivery_mode,
+				__apic_accept_irq(vcpu->arch.apic, delivery_mode,
 						  vector, level, trig_mode);
 		}
 	}
@@ -495,7 +496,7 @@ static void apic_send_ipi(struct kvm_lapic *apic)
 	if (delivery_mode == APIC_DM_LOWEST) {
 		target = kvm_get_lowest_prio_vcpu(vcpu->kvm, vector, lpr_map);
 		if (target != NULL)
-			__apic_accept_irq(target->apic, delivery_mode,
+			__apic_accept_irq(target->arch.apic, delivery_mode,
 					  vector, level, trig_mode);
 	}
 }
@@ -772,15 +773,15 @@ static int apic_mmio_range(struct kvm_io_device *this, gpa_t addr)
 
 void kvm_free_lapic(struct kvm_vcpu *vcpu)
 {
-	if (!vcpu->apic)
+	if (!vcpu->arch.apic)
 		return;
 
-	hrtimer_cancel(&vcpu->apic->timer.dev);
+	hrtimer_cancel(&vcpu->arch.apic->timer.dev);
 
-	if (vcpu->apic->regs_page)
-		__free_page(vcpu->apic->regs_page);
+	if (vcpu->arch.apic->regs_page)
+		__free_page(vcpu->arch.apic->regs_page);
 
-	kfree(vcpu->apic);
+	kfree(vcpu->arch.apic);
 }
 
 /*
@@ -791,7 +792,7 @@ void kvm_free_lapic(struct kvm_vcpu *vcpu)
 
 void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8)
 {
-	struct kvm_lapic *apic = vcpu->apic;
+	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	if (!apic)
 		return;
@@ -800,7 +801,7 @@ void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8)
 
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu)
 {
-	struct kvm_lapic *apic = vcpu->apic;
+	struct kvm_lapic *apic = vcpu->arch.apic;
 	u64 tpr;
 
 	if (!apic)
@@ -813,29 +814,29 @@ EXPORT_SYMBOL_GPL(kvm_lapic_get_cr8);
 
 void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 {
-	struct kvm_lapic *apic = vcpu->apic;
+	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	if (!apic) {
 		value |= MSR_IA32_APICBASE_BSP;
-		vcpu->apic_base = value;
+		vcpu->arch.apic_base = value;
 		return;
 	}
 	if (apic->vcpu->vcpu_id)
 		value &= ~MSR_IA32_APICBASE_BSP;
 
-	vcpu->apic_base = value;
-	apic->base_address = apic->vcpu->apic_base &
+	vcpu->arch.apic_base = value;
+	apic->base_address = apic->vcpu->arch.apic_base &
 			     MSR_IA32_APICBASE_BASE;
 
 	/* with FSB delivery interrupt, we can restart APIC functionality */
 	apic_debug("apic base msr is 0x%016" PRIx64 ", and base address is "
-		   "0x%lx.\n", apic->vcpu->apic_base, apic->base_address);
+		   "0x%lx.\n", apic->vcpu->arch.apic_base, apic->base_address);
 
 }
 
 u64 kvm_lapic_get_base(struct kvm_vcpu *vcpu)
 {
-	return vcpu->apic_base;
+	return vcpu->arch.apic_base;
 }
 EXPORT_SYMBOL_GPL(kvm_lapic_get_base);
 
@@ -847,7 +848,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu)
 	apic_debug("%s\n", __FUNCTION__);
 
 	ASSERT(vcpu);
-	apic = vcpu->apic;
+	apic = vcpu->arch.apic;
 	ASSERT(apic != NULL);
 
 	/* Stop the timer in case it's a reset to an active apic */
@@ -878,19 +879,19 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu)
 	update_divide_count(apic);
 	atomic_set(&apic->timer.pending, 0);
 	if (vcpu->vcpu_id == 0)
-		vcpu->apic_base |= MSR_IA32_APICBASE_BSP;
+		vcpu->arch.apic_base |= MSR_IA32_APICBASE_BSP;
 	apic_update_ppr(apic);
 
 	apic_debug(KERN_INFO "%s: vcpu=%p, id=%d, base_msr="
 		   "0x%016" PRIx64 ", base_address=0x%0lx.\n", __FUNCTION__,
 		   vcpu, kvm_apic_id(apic),
-		   vcpu->apic_base, apic->base_address);
+		   vcpu->arch.apic_base, apic->base_address);
 }
 EXPORT_SYMBOL_GPL(kvm_lapic_reset);
 
 int kvm_lapic_enabled(struct kvm_vcpu *vcpu)
 {
-	struct kvm_lapic *apic = vcpu->apic;
+	struct kvm_lapic *apic = vcpu->arch.apic;
 	int ret = 0;
 
 	if (!apic)
@@ -915,7 +916,7 @@ static int __apic_timer_fn(struct kvm_lapic *apic)
 
 	atomic_inc(&apic->timer.pending);
 	if (waitqueue_active(q)) {
-		apic->vcpu->mp_state = VCPU_MP_STATE_RUNNABLE;
+		apic->vcpu->arch.mp_state = VCPU_MP_STATE_RUNNABLE;
 		wake_up_interruptible(q);
 	}
 	if (apic_lvtt_period(apic)) {
@@ -961,7 +962,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu)
 	if (!apic)
 		goto nomem;
 
-	vcpu->apic = apic;
+	vcpu->arch.apic = apic;
 
 	apic->regs_page = alloc_page(GFP_KERNEL);
 	if (apic->regs_page == NULL) {
@@ -976,7 +977,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu)
 	hrtimer_init(&apic->timer.dev, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 	apic->timer.dev.function = apic_timer_fn;
 	apic->base_address = APIC_DEFAULT_PHYS_BASE;
-	vcpu->apic_base = APIC_DEFAULT_PHYS_BASE;
+	vcpu->arch.apic_base = APIC_DEFAULT_PHYS_BASE;
 
 	kvm_lapic_reset(vcpu);
 	apic->dev.read = apic_mmio_read;
@@ -994,7 +995,7 @@ EXPORT_SYMBOL_GPL(kvm_create_lapic);
 
 int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
 {
-	struct kvm_lapic *apic = vcpu->apic;
+	struct kvm_lapic *apic = vcpu->arch.apic;
 	int highest_irr;
 
 	if (!apic || !apic_enabled(apic))
@@ -1010,11 +1011,11 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
 
 int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu)
 {
-	u32 lvt0 = apic_get_reg(vcpu->apic, APIC_LVT0);
+	u32 lvt0 = apic_get_reg(vcpu->arch.apic, APIC_LVT0);
 	int r = 0;
 
 	if (vcpu->vcpu_id == 0) {
-		if (!apic_hw_enabled(vcpu->apic))
+		if (!apic_hw_enabled(vcpu->arch.apic))
 			r = 1;
 		if ((lvt0 & APIC_LVT_MASKED) == 0 &&
 		    GET_APIC_DELIVERY_MODE(lvt0) == APIC_MODE_EXTINT)
@@ -1025,7 +1026,7 @@ int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu)
 
 void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu)
 {
-	struct kvm_lapic *apic = vcpu->apic;
+	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	if (apic && apic_lvt_enabled(apic, APIC_LVTT) &&
 		atomic_read(&apic->timer.pending) > 0) {
@@ -1036,7 +1037,7 @@ void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu)
 
 void kvm_apic_timer_intr_post(struct kvm_vcpu *vcpu, int vec)
 {
-	struct kvm_lapic *apic = vcpu->apic;
+	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	if (apic && apic_lvt_vector(apic, APIC_LVTT) == vec)
 		apic->timer.last_update = ktime_add_ns(
@@ -1047,7 +1048,7 @@ void kvm_apic_timer_intr_post(struct kvm_vcpu *vcpu, int vec)
 int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
 {
 	int vector = kvm_apic_has_interrupt(vcpu);
-	struct kvm_lapic *apic = vcpu->apic;
+	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	if (vector == -1)
 		return -1;
@@ -1060,9 +1061,9 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
 
 void kvm_apic_post_state_restore(struct kvm_vcpu *vcpu)
 {
-	struct kvm_lapic *apic = vcpu->apic;
+	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	apic->base_address = vcpu->apic_base &
+	apic->base_address = vcpu->arch.apic_base &
 			     MSR_IA32_APICBASE_BASE;
 	apic_set_reg(apic, APIC_LVR, APIC_VERSION);
 	apic_update_ppr(apic);
@@ -1073,7 +1074,7 @@ void kvm_apic_post_state_restore(struct kvm_vcpu *vcpu)
 
 void kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
 {
-	struct kvm_lapic *apic = vcpu->apic;
+	struct kvm_lapic *apic = vcpu->arch.apic;
 	struct hrtimer *timer;
 
 	if (!apic)
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 92ac0d1..da1dedb 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -180,7 +180,7 @@ EXPORT_SYMBOL_GPL(kvm_mmu_set_nonpresent_ptes);
 
 static int is_write_protection(struct kvm_vcpu *vcpu)
 {
-	return vcpu->cr0 & X86_CR0_WP;
+	return vcpu->arch.cr0 & X86_CR0_WP;
 }
 
 static int is_cpuid_PSE36(void)
@@ -190,7 +190,7 @@ static int is_cpuid_PSE36(void)
 
 static int is_nx(struct kvm_vcpu *vcpu)
 {
-	return vcpu->shadow_efer & EFER_NX;
+	return vcpu->arch.shadow_efer & EFER_NX;
 }
 
 static int is_present_pte(unsigned long pte)
@@ -292,18 +292,18 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 	int r;
 
 	kvm_mmu_free_some_pages(vcpu);
-	r = mmu_topup_memory_cache(&vcpu->mmu_pte_chain_cache,
+	r = mmu_topup_memory_cache(&vcpu->arch.mmu_pte_chain_cache,
 				   pte_chain_cache, 4);
 	if (r)
 		goto out;
-	r = mmu_topup_memory_cache(&vcpu->mmu_rmap_desc_cache,
+	r = mmu_topup_memory_cache(&vcpu->arch.mmu_rmap_desc_cache,
 				   rmap_desc_cache, 1);
 	if (r)
 		goto out;
-	r = mmu_topup_memory_cache_page(&vcpu->mmu_page_cache, 8);
+	r = mmu_topup_memory_cache_page(&vcpu->arch.mmu_page_cache, 8);
 	if (r)
 		goto out;
-	r = mmu_topup_memory_cache(&vcpu->mmu_page_header_cache,
+	r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
 				   mmu_page_header_cache, 4);
 out:
 	return r;
@@ -311,10 +311,10 @@ out:
 
 static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
-	mmu_free_memory_cache(&vcpu->mmu_pte_chain_cache);
-	mmu_free_memory_cache(&vcpu->mmu_rmap_desc_cache);
-	mmu_free_memory_cache_page(&vcpu->mmu_page_cache);
-	mmu_free_memory_cache(&vcpu->mmu_page_header_cache);
+	mmu_free_memory_cache(&vcpu->arch.mmu_pte_chain_cache);
+	mmu_free_memory_cache(&vcpu->arch.mmu_rmap_desc_cache);
+	mmu_free_memory_cache_page(&vcpu->arch.mmu_page_cache);
+	mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
 static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc,
@@ -330,7 +330,7 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc,
 
 static struct kvm_pte_chain *mmu_alloc_pte_chain(struct kvm_vcpu *vcpu)
 {
-	return mmu_memory_cache_alloc(&vcpu->mmu_pte_chain_cache,
+	return mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_chain_cache,
 				      sizeof(struct kvm_pte_chain));
 }
 
@@ -341,7 +341,7 @@ static void mmu_free_pte_chain(struct kvm_pte_chain *pc)
 
 static struct kvm_rmap_desc *mmu_alloc_rmap_desc(struct kvm_vcpu *vcpu)
 {
-	return mmu_memory_cache_alloc(&vcpu->mmu_rmap_desc_cache,
+	return mmu_memory_cache_alloc(&vcpu->arch.mmu_rmap_desc_cache,
 				      sizeof(struct kvm_rmap_desc));
 }
 
@@ -568,9 +568,9 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 	if (!vcpu->kvm->n_free_mmu_pages)
 		return NULL;
 
-	sp = mmu_memory_cache_alloc(&vcpu->mmu_page_header_cache, sizeof *sp);
-	sp->spt = mmu_memory_cache_alloc(&vcpu->mmu_page_cache, PAGE_SIZE);
-	sp->gfns = mmu_memory_cache_alloc(&vcpu->mmu_page_cache, PAGE_SIZE);
+	sp = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache, sizeof *sp);
+	sp->spt = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache, PAGE_SIZE);
+	sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache, PAGE_SIZE);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 	list_add(&sp->link, &vcpu->kvm->active_mmu_pages);
 	ASSERT(is_empty_shadow_page(sp->spt));
@@ -692,11 +692,11 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	struct hlist_node *node;
 
 	role.word = 0;
-	role.glevels = vcpu->mmu.root_level;
+	role.glevels = vcpu->arch.mmu.root_level;
 	role.level = level;
 	role.metaphysical = metaphysical;
 	role.access = access;
-	if (vcpu->mmu.root_level <= PT32_ROOT_LEVEL) {
+	if (vcpu->arch.mmu.root_level <= PT32_ROOT_LEVEL) {
 		quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
 		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
 		role.quadrant = quadrant;
@@ -718,7 +718,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	sp->gfn = gfn;
 	sp->role = role;
 	hlist_add_head(&sp->hash_link, bucket);
-	vcpu->mmu.prefetch_page(vcpu, sp);
+	vcpu->arch.mmu.prefetch_page(vcpu, sp);
 	if (!metaphysical)
 		rmap_write_protect(vcpu->kvm, gfn);
 	if (new_page)
@@ -768,7 +768,7 @@ static void kvm_mmu_reset_last_pte_updated(struct kvm *kvm)
 
 	for (i = 0; i < KVM_MAX_VCPUS; ++i)
 		if (kvm->vcpus[i])
-			kvm->vcpus[i]->last_pte_updated = NULL;
+			kvm->vcpus[i]->arch.last_pte_updated = NULL;
 }
 
 static void kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
@@ -875,7 +875,7 @@ static void page_header_update_slot(struct kvm *kvm, void *pte, gfn_t gfn)
 
 struct page *gva_to_page(struct kvm_vcpu *vcpu, gva_t gva)
 {
-	gpa_t gpa = vcpu->mmu.gva_to_gpa(vcpu, gva);
+	gpa_t gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, gva);
 
 	if (gpa == UNMAPPED_GVA)
 		return NULL;
@@ -962,7 +962,7 @@ unshadowed:
 	else
 		kvm_release_page_clean(page);
 	if (!ptwrite || !*ptwrite)
-		vcpu->last_pte_updated = shadow_pte;
+		vcpu->arch.last_pte_updated = shadow_pte;
 }
 
 static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
@@ -972,7 +972,7 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 {
 	int level = PT32E_ROOT_LEVEL;
-	hpa_t table_addr = vcpu->mmu.root_hpa;
+	hpa_t table_addr = vcpu->arch.mmu.root_hpa;
 	int pt_write = 0;
 
 	for (; ; level--) {
@@ -1024,29 +1024,29 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 	int i;
 	struct kvm_mmu_page *sp;
 
-	if (!VALID_PAGE(vcpu->mmu.root_hpa))
+	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
 		return;
 #ifdef CONFIG_X86_64
-	if (vcpu->mmu.shadow_root_level == PT64_ROOT_LEVEL) {
-		hpa_t root = vcpu->mmu.root_hpa;
+	if (vcpu->arch.mmu.shadow_root_level == PT64_ROOT_LEVEL) {
+		hpa_t root = vcpu->arch.mmu.root_hpa;
 
 		sp = page_header(root);
 		--sp->root_count;
-		vcpu->mmu.root_hpa = INVALID_PAGE;
+		vcpu->arch.mmu.root_hpa = INVALID_PAGE;
 		return;
 	}
 #endif
 	for (i = 0; i < 4; ++i) {
-		hpa_t root = vcpu->mmu.pae_root[i];
+		hpa_t root = vcpu->arch.mmu.pae_root[i];
 
 		if (root) {
 			root &= PT64_BASE_ADDR_MASK;
 			sp = page_header(root);
 			--sp->root_count;
 		}
-		vcpu->mmu.pae_root[i] = INVALID_PAGE;
+		vcpu->arch.mmu.pae_root[i] = INVALID_PAGE;
 	}
-	vcpu->mmu.root_hpa = INVALID_PAGE;
+	vcpu->arch.mmu.root_hpa = INVALID_PAGE;
 }
 
 static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
@@ -1055,41 +1055,41 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
 	gfn_t root_gfn;
 	struct kvm_mmu_page *sp;
 
-	root_gfn = vcpu->cr3 >> PAGE_SHIFT;
+	root_gfn = vcpu->arch.cr3 >> PAGE_SHIFT;
 
 #ifdef CONFIG_X86_64
-	if (vcpu->mmu.shadow_root_level == PT64_ROOT_LEVEL) {
-		hpa_t root = vcpu->mmu.root_hpa;
+	if (vcpu->arch.mmu.shadow_root_level == PT64_ROOT_LEVEL) {
+		hpa_t root = vcpu->arch.mmu.root_hpa;
 
 		ASSERT(!VALID_PAGE(root));
 		sp = kvm_mmu_get_page(vcpu, root_gfn, 0,
 				      PT64_ROOT_LEVEL, 0, ACC_ALL, NULL, NULL);
 		root = __pa(sp->spt);
 		++sp->root_count;
-		vcpu->mmu.root_hpa = root;
+		vcpu->arch.mmu.root_hpa = root;
 		return;
 	}
 #endif
 	for (i = 0; i < 4; ++i) {
-		hpa_t root = vcpu->mmu.pae_root[i];
+		hpa_t root = vcpu->arch.mmu.pae_root[i];
 
 		ASSERT(!VALID_PAGE(root));
-		if (vcpu->mmu.root_level == PT32E_ROOT_LEVEL) {
-			if (!is_present_pte(vcpu->pdptrs[i])) {
-				vcpu->mmu.pae_root[i] = 0;
+		if (vcpu->arch.mmu.root_level == PT32E_ROOT_LEVEL) {
+			if (!is_present_pte(vcpu->arch.pdptrs[i])) {
+				vcpu->arch.mmu.pae_root[i] = 0;
 				continue;
 			}
-			root_gfn = vcpu->pdptrs[i] >> PAGE_SHIFT;
-		} else if (vcpu->mmu.root_level == 0)
+			root_gfn = vcpu->arch.pdptrs[i] >> PAGE_SHIFT;
+		} else if (vcpu->arch.mmu.root_level == 0)
 			root_gfn = 0;
 		sp = kvm_mmu_get_page(vcpu, root_gfn, i << 30,
 				      PT32_ROOT_LEVEL, !is_paging(vcpu),
 				      ACC_ALL, NULL, NULL);
 		root = __pa(sp->spt);
 		++sp->root_count;
-		vcpu->mmu.pae_root[i] = root | PT_PRESENT_MASK;
+		vcpu->arch.mmu.pae_root[i] = root | PT_PRESENT_MASK;
 	}
-	vcpu->mmu.root_hpa = __pa(vcpu->mmu.pae_root);
+	vcpu->arch.mmu.root_hpa = __pa(vcpu->arch.mmu.pae_root);
 }
 
 static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gva_t vaddr)
@@ -1109,7 +1109,7 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 		return r;
 
 	ASSERT(vcpu);
-	ASSERT(VALID_PAGE(vcpu->mmu.root_hpa));
+	ASSERT(VALID_PAGE(vcpu->arch.mmu.root_hpa));
 
 	gfn = gva >> PAGE_SHIFT;
 
@@ -1124,7 +1124,7 @@ static void nonpaging_free(struct kvm_vcpu *vcpu)
 
 static int nonpaging_init_context(struct kvm_vcpu *vcpu)
 {
-	struct kvm_mmu *context = &vcpu->mmu;
+	struct kvm_mmu *context = &vcpu->arch.mmu;
 
 	context->new_cr3 = nonpaging_new_cr3;
 	context->page_fault = nonpaging_page_fault;
@@ -1171,7 +1171,7 @@ static void paging_free(struct kvm_vcpu *vcpu)
 
 static int paging64_init_context_common(struct kvm_vcpu *vcpu, int level)
 {
-	struct kvm_mmu *context = &vcpu->mmu;
+	struct kvm_mmu *context = &vcpu->arch.mmu;
 
 	ASSERT(is_pae(vcpu));
 	context->new_cr3 = paging_new_cr3;
@@ -1192,7 +1192,7 @@ static int paging64_init_context(struct kvm_vcpu *vcpu)
 
 static int paging32_init_context(struct kvm_vcpu *vcpu)
 {
-	struct kvm_mmu *context = &vcpu->mmu;
+	struct kvm_mmu *context = &vcpu->arch.mmu;
 
 	context->new_cr3 = paging_new_cr3;
 	context->page_fault = paging32_page_fault;
@@ -1213,7 +1213,7 @@ static int paging32E_init_context(struct kvm_vcpu *vcpu)
 static int init_kvm_mmu(struct kvm_vcpu *vcpu)
 {
 	ASSERT(vcpu);
-	ASSERT(!VALID_PAGE(vcpu->mmu.root_hpa));
+	ASSERT(!VALID_PAGE(vcpu->arch.mmu.root_hpa));
 
 	if (!is_paging(vcpu))
 		return nonpaging_init_context(vcpu);
@@ -1228,9 +1228,9 @@ static int init_kvm_mmu(struct kvm_vcpu *vcpu)
 static void destroy_kvm_mmu(struct kvm_vcpu *vcpu)
 {
 	ASSERT(vcpu);
-	if (VALID_PAGE(vcpu->mmu.root_hpa)) {
-		vcpu->mmu.free(vcpu);
-		vcpu->mmu.root_hpa = INVALID_PAGE;
+	if (VALID_PAGE(vcpu->arch.mmu.root_hpa)) {
+		vcpu->arch.mmu.free(vcpu);
+		vcpu->arch.mmu.root_hpa = INVALID_PAGE;
 	}
 }
 
@@ -1250,7 +1250,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	if (r)
 		goto out;
 	mmu_alloc_roots(vcpu);
-	kvm_x86_ops->set_cr3(vcpu, vcpu->mmu.root_hpa);
+	kvm_x86_ops->set_cr3(vcpu, vcpu->arch.mmu.root_hpa);
 	kvm_mmu_flush_tlb(vcpu);
 out:
 	mutex_unlock(&vcpu->kvm->lock);
@@ -1323,7 +1323,7 @@ static void mmu_pte_write_flush_tlb(struct kvm_vcpu *vcpu, u64 old, u64 new)
 
 static bool last_updated_pte_accessed(struct kvm_vcpu *vcpu)
 {
-	u64 *spte = vcpu->last_pte_updated;
+	u64 *spte = vcpu->arch.last_pte_updated;
 
 	return !!(spte && (*spte & PT_ACCESSED_MASK));
 }
@@ -1350,15 +1350,15 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	pgprintk("%s: gpa %llx bytes %d\n", __FUNCTION__, gpa, bytes);
 	++vcpu->kvm->stat.mmu_pte_write;
 	kvm_mmu_audit(vcpu, "pre pte write");
-	if (gfn == vcpu->last_pt_write_gfn
+	if (gfn == vcpu->arch.last_pt_write_gfn
 	    && !last_updated_pte_accessed(vcpu)) {
-		++vcpu->last_pt_write_count;
-		if (vcpu->last_pt_write_count >= 3)
+		++vcpu->arch.last_pt_write_count;
+		if (vcpu->arch.last_pt_write_count >= 3)
 			flooded = 1;
 	} else {
-		vcpu->last_pt_write_gfn = gfn;
-		vcpu->last_pt_write_count = 1;
-		vcpu->last_pte_updated = NULL;
+		vcpu->arch.last_pt_write_gfn = gfn;
+		vcpu->arch.last_pt_write_count = 1;
+		vcpu->arch.last_pte_updated = NULL;
 	}
 	index = kvm_page_table_hashfn(gfn) % KVM_NUM_MMU_PAGES;
 	bucket = &vcpu->kvm->mmu_page_hash[index];
@@ -1420,7 +1420,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 {
-	gpa_t gpa = vcpu->mmu.gva_to_gpa(vcpu, gva);
+	gpa_t gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, gva);
 
 	return kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
 }
@@ -1443,7 +1443,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code)
 	enum emulation_result er;
 
 	mutex_lock(&vcpu->kvm->lock);
-	r = vcpu->mmu.page_fault(vcpu, cr2, error_code);
+	r = vcpu->arch.mmu.page_fault(vcpu, cr2, error_code);
 	if (r < 0)
 		goto out;
 
@@ -1486,7 +1486,7 @@ static void free_mmu_pages(struct kvm_vcpu *vcpu)
 				  struct kvm_mmu_page, link);
 		kvm_mmu_zap_page(vcpu->kvm, sp);
 	}
-	free_page((unsigned long)vcpu->mmu.pae_root);
+	free_page((unsigned long)vcpu->arch.mmu.pae_root);
 }
 
 static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
@@ -1508,9 +1508,9 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
 	page = alloc_page(GFP_KERNEL | __GFP_DMA32);
 	if (!page)
 		goto error_1;
-	vcpu->mmu.pae_root = page_address(page);
+	vcpu->arch.mmu.pae_root = page_address(page);
 	for (i = 0; i < 4; ++i)
-		vcpu->mmu.pae_root[i] = INVALID_PAGE;
+		vcpu->arch.mmu.pae_root[i] = INVALID_PAGE;
 
 	return 0;
 
@@ -1522,7 +1522,7 @@ error_1:
 int kvm_mmu_create(struct kvm_vcpu *vcpu)
 {
 	ASSERT(vcpu);
-	ASSERT(!VALID_PAGE(vcpu->mmu.root_hpa));
+	ASSERT(!VALID_PAGE(vcpu->arch.mmu.root_hpa));
 
 	return alloc_mmu_pages(vcpu);
 }
@@ -1530,7 +1530,7 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 int kvm_mmu_setup(struct kvm_vcpu *vcpu)
 {
 	ASSERT(vcpu);
-	ASSERT(!VALID_PAGE(vcpu->mmu.root_hpa));
+	ASSERT(!VALID_PAGE(vcpu->arch.mmu.root_hpa));
 
 	return init_kvm_mmu(vcpu);
 }
@@ -1659,11 +1659,11 @@ static void audit_mappings_page(struct kvm_vcpu *vcpu, u64 page_pte,
 				printk(KERN_ERR "audit: (%s) nontrapping pte"
 				       " in nonleaf level: levels %d gva %lx"
 				       " level %d pte %llx\n", audit_msg,
-				       vcpu->mmu.root_level, va, level, ent);
+				       vcpu->arch.mmu.root_level, va, level, ent);
 
 			audit_mappings_page(vcpu, ent, va, level - 1);
 		} else {
-			gpa_t gpa = vcpu->mmu.gva_to_gpa(vcpu, va);
+			gpa_t gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, va);
 			struct page *page = gpa_to_page(vcpu, gpa);
 			hpa_t hpa = page_to_phys(page);
 
@@ -1671,7 +1671,7 @@ static void audit_mappings_page(struct kvm_vcpu *vcpu, u64 page_pte,
 			    && (ent & PT64_BASE_ADDR_MASK) != hpa)
 				printk(KERN_ERR "xx audit error: (%s) levels %d"
 				       " gva %lx gpa %llx hpa %llx ent %llx %d\n",
-				       audit_msg, vcpu->mmu.root_level,
+				       audit_msg, vcpu->arch.mmu.root_level,
 				       va, gpa, hpa, ent,
 				       is_shadow_present_pte(ent));
 			else if (ent == shadow_notrap_nonpresent_pte
@@ -1688,13 +1688,13 @@ static void audit_mappings(struct kvm_vcpu *vcpu)
 {
 	unsigned i;
 
-	if (vcpu->mmu.root_level == 4)
-		audit_mappings_page(vcpu, vcpu->mmu.root_hpa, 0, 4);
+	if (vcpu->arch.mmu.root_level == 4)
+		audit_mappings_page(vcpu, vcpu->arch.mmu.root_hpa, 0, 4);
 	else
 		for (i = 0; i < 4; ++i)
-			if (vcpu->mmu.pae_root[i] & PT_PRESENT_MASK)
+			if (vcpu->arch.mmu.pae_root[i] & PT_PRESENT_MASK)
 				audit_mappings_page(vcpu,
-						    vcpu->mmu.pae_root[i],
+						    vcpu->arch.mmu.pae_root[i],
 						    i << 30,
 						    2);
 }
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index fb19596..56b88f7 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -129,11 +129,11 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 
 	pgprintk("%s: addr %lx\n", __FUNCTION__, addr);
 walk:
-	walker->level = vcpu->mmu.root_level;
-	pte = vcpu->cr3;
+	walker->level = vcpu->arch.mmu.root_level;
+	pte = vcpu->arch.cr3;
 #if PTTYPE == 64
 	if (!is_long_mode(vcpu)) {
-		pte = vcpu->pdptrs[(addr >> 30) & 3];
+		pte = vcpu->arch.pdptrs[(addr >> 30) & 3];
 		if (!is_present_pte(pte))
 			goto not_present;
 		--walker->level;
@@ -275,10 +275,10 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	if (!is_present_pte(walker->ptes[walker->level - 1]))
 		return NULL;
 
-	shadow_addr = vcpu->mmu.root_hpa;
-	level = vcpu->mmu.shadow_root_level;
+	shadow_addr = vcpu->arch.mmu.root_hpa;
+	level = vcpu->arch.mmu.shadow_root_level;
 	if (level == PT32E_ROOT_LEVEL) {
-		shadow_addr = vcpu->mmu.pae_root[(addr >> 30) & 3];
+		shadow_addr = vcpu->arch.mmu.pae_root[(addr >> 30) & 3];
 		shadow_addr &= PT64_BASE_ADDR_MASK;
 		--level;
 	}
@@ -380,7 +380,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	if (!r) {
 		pgprintk("%s: guest page fault\n", __FUNCTION__);
 		inject_page_fault(vcpu, addr, walker.error_code);
-		vcpu->last_pt_write_count = 0; /* reset fork detector */
+		vcpu->arch.last_pt_write_count = 0; /* reset fork detector */
 		return 0;
 	}
 
@@ -390,7 +390,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 		 shadow_pte, *shadow_pte, write_pt);
 
 	if (!write_pt)
-		vcpu->last_pt_write_count = 0; /* reset fork detector */
+		vcpu->arch.last_pt_write_count = 0; /* reset fork detector */
 
 	/*
 	 * mmio: emulate if accessible, otherwise its a guest fault.
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 839a75f..6c100b1 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -99,20 +99,20 @@ static inline u32 svm_has(u32 feat)
 
 static inline u8 pop_irq(struct kvm_vcpu *vcpu)
 {
-	int word_index = __ffs(vcpu->irq_summary);
-	int bit_index = __ffs(vcpu->irq_pending[word_index]);
+	int word_index = __ffs(vcpu->arch.irq_summary);
+	int bit_index = __ffs(vcpu->arch.irq_pending[word_index]);
 	int irq = word_index * BITS_PER_LONG + bit_index;
 
-	clear_bit(bit_index, &vcpu->irq_pending[word_index]);
-	if (!vcpu->irq_pending[word_index])
-		clear_bit(word_index, &vcpu->irq_summary);
+	clear_bit(bit_index, &vcpu->arch.irq_pending[word_index]);
+	if (!vcpu->arch.irq_pending[word_index])
+		clear_bit(word_index, &vcpu->arch.irq_summary);
 	return irq;
 }
 
 static inline void push_irq(struct kvm_vcpu *vcpu, u8 irq)
 {
-	set_bit(irq, vcpu->irq_pending);
-	set_bit(irq / BITS_PER_LONG, &vcpu->irq_summary);
+	set_bit(irq, vcpu->arch.irq_pending);
+	set_bit(irq / BITS_PER_LONG, &vcpu->arch.irq_summary);
 }
 
 static inline void clgi(void)
@@ -185,7 +185,7 @@ static void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 		efer &= ~EFER_LME;
 
 	to_svm(vcpu)->vmcb->save.efer = efer | MSR_EFER_SVME_MASK;
-	vcpu->shadow_efer = efer;
+	vcpu->arch.shadow_efer = efer;
 }
 
 static void svm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
@@ -227,10 +227,10 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 		       svm->vmcb->save.rip,
 		       svm->next_rip);
 
-	vcpu->rip = svm->vmcb->save.rip = svm->next_rip;
+	vcpu->arch.rip = svm->vmcb->save.rip = svm->next_rip;
 	svm->vmcb->control.int_state &= ~SVM_INTERRUPT_SHADOW_MASK;
 
-	vcpu->interrupt_window_open = 1;
+	vcpu->arch.interrupt_window_open = 1;
 }
 
 static int has_svm(void)
@@ -559,8 +559,8 @@ static int svm_vcpu_reset(struct kvm_vcpu *vcpu)
 
 	if (vcpu->vcpu_id != 0) {
 		svm->vmcb->save.rip = 0;
-		svm->vmcb->save.cs.base = svm->vcpu.sipi_vector << 12;
-		svm->vmcb->save.cs.selector = svm->vcpu.sipi_vector << 8;
+		svm->vmcb->save.cs.base = svm->vcpu.arch.sipi_vector << 12;
+		svm->vmcb->save.cs.selector = svm->vcpu.arch.sipi_vector << 8;
 	}
 
 	return 0;
@@ -597,9 +597,9 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 
 	fx_init(&svm->vcpu);
 	svm->vcpu.fpu_active = 1;
-	svm->vcpu.apic_base = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
+	svm->vcpu.arch.apic_base = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
 	if (svm->vcpu.vcpu_id == 0)
-		svm->vcpu.apic_base |= MSR_IA32_APICBASE_BSP;
+		svm->vcpu.arch.apic_base |= MSR_IA32_APICBASE_BSP;
 
 	return &svm->vcpu;
 
@@ -633,7 +633,7 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		 * increasing TSC.
 		 */
 		rdtscll(tsc_this);
-		delta = vcpu->host_tsc - tsc_this;
+		delta = vcpu->arch.host_tsc - tsc_this;
 		svm->vmcb->control.tsc_offset += delta;
 		vcpu->cpu = cpu;
 		kvm_migrate_apic_timer(vcpu);
@@ -652,7 +652,7 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
 		wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
 
-	rdtscll(vcpu->host_tsc);
+	rdtscll(vcpu->arch.host_tsc);
 }
 
 static void svm_vcpu_decache(struct kvm_vcpu *vcpu)
@@ -663,17 +663,17 @@ static void svm_cache_regs(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	vcpu->regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
-	vcpu->regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;
-	vcpu->rip = svm->vmcb->save.rip;
+	vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
+	vcpu->arch.regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;
+	vcpu->arch.rip = svm->vmcb->save.rip;
 }
 
 static void svm_decache_regs(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	svm->vmcb->save.rax = vcpu->regs[VCPU_REGS_RAX];
-	svm->vmcb->save.rsp = vcpu->regs[VCPU_REGS_RSP];
-	svm->vmcb->save.rip = vcpu->rip;
+	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
+	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
+	svm->vmcb->save.rip = vcpu->arch.rip;
 }
 
 static unsigned long svm_get_rflags(struct kvm_vcpu *vcpu)
@@ -771,24 +771,24 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 #ifdef CONFIG_X86_64
-	if (vcpu->shadow_efer & EFER_LME) {
+	if (vcpu->arch.shadow_efer & EFER_LME) {
 		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
-			vcpu->shadow_efer |= EFER_LMA;
+			vcpu->arch.shadow_efer |= EFER_LMA;
 			svm->vmcb->save.efer |= EFER_LMA | EFER_LME;
 		}
 
 		if (is_paging(vcpu) && !(cr0 & X86_CR0_PG)) {
-			vcpu->shadow_efer &= ~EFER_LMA;
+			vcpu->arch.shadow_efer &= ~EFER_LMA;
 			svm->vmcb->save.efer &= ~(EFER_LMA | EFER_LME);
 		}
 	}
 #endif
-	if ((vcpu->cr0 & X86_CR0_TS) && !(cr0 & X86_CR0_TS)) {
+	if ((vcpu->arch.cr0 & X86_CR0_TS) && !(cr0 & X86_CR0_TS)) {
 		svm->vmcb->control.intercept_exceptions &= ~(1 << NM_VECTOR);
 		vcpu->fpu_active = 1;
 	}
 
-	vcpu->cr0 = cr0;
+	vcpu->arch.cr0 = cr0;
 	cr0 |= X86_CR0_PG | X86_CR0_WP;
 	cr0 &= ~(X86_CR0_CD | X86_CR0_NW);
 	svm->vmcb->save.cr0 = cr0;
@@ -796,7 +796,7 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 
 static void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
-       vcpu->cr4 = cr4;
+       vcpu->arch.cr4 = cr4;
        to_svm(vcpu)->vmcb->save.cr4 = cr4 | X86_CR4_PAE;
 }
 
@@ -901,7 +901,7 @@ static void svm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long value,
 		svm->db_regs[dr] = value;
 		return;
 	case 4 ... 5:
-		if (vcpu->cr4 & X86_CR4_DE) {
+		if (vcpu->arch.cr4 & X86_CR4_DE) {
 			*exception = UD_VECTOR;
 			return;
 		}
@@ -950,7 +950,7 @@ static int ud_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 static int nm_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
 	svm->vmcb->control.intercept_exceptions &= ~(1 << NM_VECTOR);
-	if (!(svm->vcpu.cr0 & X86_CR0_TS))
+	if (!(svm->vcpu.arch.cr0 & X86_CR0_TS))
 		svm->vmcb->save.cr0 &= ~X86_CR0_TS;
 	svm->vcpu.fpu_active = 1;
 
@@ -1103,14 +1103,14 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 
 static int rdmsr_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
-	u32 ecx = svm->vcpu.regs[VCPU_REGS_RCX];
+	u32 ecx = svm->vcpu.arch.regs[VCPU_REGS_RCX];
 	u64 data;
 
 	if (svm_get_msr(&svm->vcpu, ecx, &data))
 		kvm_inject_gp(&svm->vcpu, 0);
 	else {
 		svm->vmcb->save.rax = data & 0xffffffff;
-		svm->vcpu.regs[VCPU_REGS_RDX] = data >> 32;
+		svm->vcpu.arch.regs[VCPU_REGS_RDX] = data >> 32;
 		svm->next_rip = svm->vmcb->save.rip + 2;
 		skip_emulated_instruction(&svm->vcpu);
 	}
@@ -1176,9 +1176,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 
 static int wrmsr_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
-	u32 ecx = svm->vcpu.regs[VCPU_REGS_RCX];
+	u32 ecx = svm->vcpu.arch.regs[VCPU_REGS_RCX];
 	u64 data = (svm->vmcb->save.rax & -1u)
-		| ((u64)(svm->vcpu.regs[VCPU_REGS_RDX] & -1u) << 32);
+		| ((u64)(svm->vcpu.arch.regs[VCPU_REGS_RDX] & -1u) << 32);
 	svm->next_rip = svm->vmcb->save.rip + 2;
 	if (svm_set_msr(&svm->vcpu, ecx, data))
 		kvm_inject_gp(&svm->vcpu, 0);
@@ -1205,7 +1205,7 @@ static int interrupt_window_interception(struct vcpu_svm *svm,
 	 * possible
 	 */
 	if (kvm_run->request_interrupt_window &&
-	    !svm->vcpu.irq_summary) {
+	    !svm->vcpu.arch.irq_summary) {
 		++svm->vcpu.stat.irq_window_exits;
 		kvm_run->exit_reason = KVM_EXIT_IRQ_WINDOW_OPEN;
 		return 0;
@@ -1382,20 +1382,20 @@ static void kvm_reput_irq(struct vcpu_svm *svm)
 		push_irq(&svm->vcpu, control->int_vector);
 	}
 
-	svm->vcpu.interrupt_window_open =
+	svm->vcpu.arch.interrupt_window_open =
 		!(control->int_state & SVM_INTERRUPT_SHADOW_MASK);
 }
 
 static void svm_do_inject_vector(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
-	int word_index = __ffs(vcpu->irq_summary);
-	int bit_index = __ffs(vcpu->irq_pending[word_index]);
+	int word_index = __ffs(vcpu->arch.irq_summary);
+	int bit_index = __ffs(vcpu->arch.irq_pending[word_index]);
 	int irq = word_index * BITS_PER_LONG + bit_index;
 
-	clear_bit(bit_index, &vcpu->irq_pending[word_index]);
-	if (!vcpu->irq_pending[word_index])
-		clear_bit(word_index, &vcpu->irq_summary);
+	clear_bit(bit_index, &vcpu->arch.irq_pending[word_index]);
+	if (!vcpu->arch.irq_pending[word_index])
+		clear_bit(word_index, &vcpu->arch.irq_summary);
 	svm_inject_irq(svm, irq);
 }
 
@@ -1405,11 +1405,11 @@ static void do_interrupt_requests(struct kvm_vcpu *vcpu,
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb_control_area *control = &svm->vmcb->control;
 
-	svm->vcpu.interrupt_window_open =
+	svm->vcpu.arch.interrupt_window_open =
 		(!(control->int_state & SVM_INTERRUPT_SHADOW_MASK) &&
 		 (svm->vmcb->save.rflags & X86_EFLAGS_IF));
 
-	if (svm->vcpu.interrupt_window_open && svm->vcpu.irq_summary)
+	if (svm->vcpu.arch.interrupt_window_open && svm->vcpu.arch.irq_summary)
 		/*
 		 * If interrupts enabled, and not blocked by sti or mov ss. Good.
 		 */
@@ -1418,8 +1418,8 @@ static void do_interrupt_requests(struct kvm_vcpu *vcpu,
 	/*
 	 * Interrupts blocked.  Wait for unblock.
 	 */
-	if (!svm->vcpu.interrupt_window_open &&
-	    (svm->vcpu.irq_summary || kvm_run->request_interrupt_window))
+	if (!svm->vcpu.arch.interrupt_window_open &&
+	    (svm->vcpu.arch.irq_summary || kvm_run->request_interrupt_window))
 		control->intercept |= 1ULL << INTERCEPT_VINTR;
 	 else
 		control->intercept &= ~(1ULL << INTERCEPT_VINTR);
@@ -1471,7 +1471,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	svm->host_cr2 = kvm_read_cr2();
 	svm->host_dr6 = read_dr6();
 	svm->host_dr7 = read_dr7();
-	svm->vmcb->save.cr2 = vcpu->cr2;
+	svm->vmcb->save.cr2 = vcpu->arch.cr2;
 
 	if (svm->vmcb->save.dr7 & 0xff) {
 		write_dr7(0);
@@ -1563,21 +1563,21 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		:
 		: [svm]"a"(svm),
 		  [vmcb]"i"(offsetof(struct vcpu_svm, vmcb_pa)),
-		  [rbx]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_RBX])),
-		  [rcx]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_RCX])),
-		  [rdx]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_RDX])),
-		  [rsi]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_RSI])),
-		  [rdi]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_RDI])),
-		  [rbp]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_RBP]))
+		  [rbx]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_RBX])),
+		  [rcx]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_RCX])),
+		  [rdx]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_RDX])),
+		  [rsi]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_RSI])),
+		  [rdi]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_RDI])),
+		  [rbp]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_RBP]))
 #ifdef CONFIG_X86_64
-		  , [r8]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_R8])),
-		  [r9]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_R9])),
-		  [r10]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_R10])),
-		  [r11]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_R11])),
-		  [r12]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_R12])),
-		  [r13]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_R13])),
-		  [r14]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_R14])),
-		  [r15]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_R15]))
+		  , [r8]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_R8])),
+		  [r9]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_R9])),
+		  [r10]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_R10])),
+		  [r11]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_R11])),
+		  [r12]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_R12])),
+		  [r13]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_R13])),
+		  [r14]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_R14])),
+		  [r15]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_R15]))
 #endif
 		: "cc", "memory"
 #ifdef CONFIG_X86_64
@@ -1591,7 +1591,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	if ((svm->vmcb->save.dr7 & 0xff))
 		load_db_regs(svm->host_db_regs);
 
-	vcpu->cr2 = svm->vmcb->save.cr2;
+	vcpu->arch.cr2 = svm->vmcb->save.cr2;
 
 	write_dr6(svm->host_dr6);
 	write_dr7(svm->host_dr7);
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 548e3a5..e26e299 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -247,7 +247,7 @@ static void __vcpu_clear(void *arg)
 		vmcs_clear(vmx->vmcs);
 	if (per_cpu(current_vmcs, cpu) == vmx->vmcs)
 		per_cpu(current_vmcs, cpu) = NULL;
-	rdtscll(vmx->vcpu.host_tsc);
+	rdtscll(vmx->vcpu.arch.host_tsc);
 }
 
 static void vcpu_clear(struct vcpu_vmx *vmx)
@@ -343,7 +343,7 @@ static void update_exception_bitmap(struct kvm_vcpu *vcpu)
 		eb |= 1u << NM_VECTOR;
 	if (vcpu->guest_debug.enabled)
 		eb |= 1u << 1;
-	if (vcpu->rmode.active)
+	if (vcpu->arch.rmode.active)
 		eb = ~0;
 	vmcs_write32(EXCEPTION_BITMAP, eb);
 }
@@ -528,7 +528,7 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		 * Make sure the time stamp counter is monotonous.
 		 */
 		rdtscll(tsc_this);
-		delta = vcpu->host_tsc - tsc_this;
+		delta = vcpu->arch.host_tsc - tsc_this;
 		vmcs_write64(TSC_OFFSET, vmcs_read64(TSC_OFFSET) + delta);
 	}
 }
@@ -544,7 +544,7 @@ static void vmx_fpu_activate(struct kvm_vcpu *vcpu)
 		return;
 	vcpu->fpu_active = 1;
 	vmcs_clear_bits(GUEST_CR0, X86_CR0_TS);
-	if (vcpu->cr0 & X86_CR0_TS)
+	if (vcpu->arch.cr0 & X86_CR0_TS)
 		vmcs_set_bits(GUEST_CR0, X86_CR0_TS);
 	update_exception_bitmap(vcpu);
 }
@@ -570,7 +570,7 @@ static unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
 
 static void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 {
-	if (vcpu->rmode.active)
+	if (vcpu->arch.rmode.active)
 		rflags |= IOPL_MASK | X86_EFLAGS_VM;
 	vmcs_writel(GUEST_RFLAGS, rflags);
 }
@@ -592,7 +592,7 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	if (interruptibility & 3)
 		vmcs_write32(GUEST_INTERRUPTIBILITY_INFO,
 			     interruptibility & ~3);
-	vcpu->interrupt_window_open = 1;
+	vcpu->arch.interrupt_window_open = 1;
 }
 
 static void vmx_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
@@ -661,7 +661,7 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 		 * if efer.sce is enabled.
 		 */
 		index = __find_msr_index(vmx, MSR_K6_STAR);
-		if ((index >= 0) && (vmx->vcpu.shadow_efer & EFER_SCE))
+		if ((index >= 0) && (vmx->vcpu.arch.shadow_efer & EFER_SCE))
 			move_msr_up(vmx, index, save_nmsrs++);
 	}
 #endif
@@ -805,12 +805,12 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 
 /*
  * Sync the rsp and rip registers into the vcpu structure.  This allows
- * registers to be accessed by indexing vcpu->regs.
+ * registers to be accessed by indexing vcpu->arch.regs.
  */
 static void vcpu_load_rsp_rip(struct kvm_vcpu *vcpu)
 {
-	vcpu->regs[VCPU_REGS_RSP] = vmcs_readl(GUEST_RSP);
-	vcpu->rip = vmcs_readl(GUEST_RIP);
+	vcpu->arch.regs[VCPU_REGS_RSP] = vmcs_readl(GUEST_RSP);
+	vcpu->arch.rip = vmcs_readl(GUEST_RIP);
 }
 
 /*
@@ -819,8 +819,8 @@ static void vcpu_load_rsp_rip(struct kvm_vcpu *vcpu)
  */
 static void vcpu_put_rsp_rip(struct kvm_vcpu *vcpu)
 {
-	vmcs_writel(GUEST_RSP, vcpu->regs[VCPU_REGS_RSP]);
-	vmcs_writel(GUEST_RIP, vcpu->rip);
+	vmcs_writel(GUEST_RSP, vcpu->arch.regs[VCPU_REGS_RSP]);
+	vmcs_writel(GUEST_RIP, vcpu->arch.rip);
 }
 
 static int set_guest_debug(struct kvm_vcpu *vcpu, struct kvm_debug_guest *dbg)
@@ -1111,15 +1111,15 @@ static void enter_pmode(struct kvm_vcpu *vcpu)
 {
 	unsigned long flags;
 
-	vcpu->rmode.active = 0;
+	vcpu->arch.rmode.active = 0;
 
-	vmcs_writel(GUEST_TR_BASE, vcpu->rmode.tr.base);
-	vmcs_write32(GUEST_TR_LIMIT, vcpu->rmode.tr.limit);
-	vmcs_write32(GUEST_TR_AR_BYTES, vcpu->rmode.tr.ar);
+	vmcs_writel(GUEST_TR_BASE, vcpu->arch.rmode.tr.base);
+	vmcs_write32(GUEST_TR_LIMIT, vcpu->arch.rmode.tr.limit);
+	vmcs_write32(GUEST_TR_AR_BYTES, vcpu->arch.rmode.tr.ar);
 
 	flags = vmcs_readl(GUEST_RFLAGS);
 	flags &= ~(IOPL_MASK | X86_EFLAGS_VM);
-	flags |= (vcpu->rmode.save_iopl << IOPL_SHIFT);
+	flags |= (vcpu->arch.rmode.save_iopl << IOPL_SHIFT);
 	vmcs_writel(GUEST_RFLAGS, flags);
 
 	vmcs_writel(GUEST_CR4, (vmcs_readl(GUEST_CR4) & ~X86_CR4_VME) |
@@ -1127,10 +1127,10 @@ static void enter_pmode(struct kvm_vcpu *vcpu)
 
 	update_exception_bitmap(vcpu);
 
-	fix_pmode_dataseg(VCPU_SREG_ES, &vcpu->rmode.es);
-	fix_pmode_dataseg(VCPU_SREG_DS, &vcpu->rmode.ds);
-	fix_pmode_dataseg(VCPU_SREG_GS, &vcpu->rmode.gs);
-	fix_pmode_dataseg(VCPU_SREG_FS, &vcpu->rmode.fs);
+	fix_pmode_dataseg(VCPU_SREG_ES, &vcpu->arch.rmode.es);
+	fix_pmode_dataseg(VCPU_SREG_DS, &vcpu->arch.rmode.ds);
+	fix_pmode_dataseg(VCPU_SREG_GS, &vcpu->arch.rmode.gs);
+	fix_pmode_dataseg(VCPU_SREG_FS, &vcpu->arch.rmode.fs);
 
 	vmcs_write16(GUEST_SS_SELECTOR, 0);
 	vmcs_write32(GUEST_SS_AR_BYTES, 0x93);
@@ -1168,19 +1168,19 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 {
 	unsigned long flags;
 
-	vcpu->rmode.active = 1;
+	vcpu->arch.rmode.active = 1;
 
-	vcpu->rmode.tr.base = vmcs_readl(GUEST_TR_BASE);
+	vcpu->arch.rmode.tr.base = vmcs_readl(GUEST_TR_BASE);
 	vmcs_writel(GUEST_TR_BASE, rmode_tss_base(vcpu->kvm));
 
-	vcpu->rmode.tr.limit = vmcs_read32(GUEST_TR_LIMIT);
+	vcpu->arch.rmode.tr.limit = vmcs_read32(GUEST_TR_LIMIT);
 	vmcs_write32(GUEST_TR_LIMIT, RMODE_TSS_SIZE - 1);
 
-	vcpu->rmode.tr.ar = vmcs_read32(GUEST_TR_AR_BYTES);
+	vcpu->arch.rmode.tr.ar = vmcs_read32(GUEST_TR_AR_BYTES);
 	vmcs_write32(GUEST_TR_AR_BYTES, 0x008b);
 
 	flags = vmcs_readl(GUEST_RFLAGS);
-	vcpu->rmode.save_iopl = (flags & IOPL_MASK) >> IOPL_SHIFT;
+	vcpu->arch.rmode.save_iopl = (flags & IOPL_MASK) >> IOPL_SHIFT;
 
 	flags |= IOPL_MASK | X86_EFLAGS_VM;
 
@@ -1198,10 +1198,10 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 		vmcs_writel(GUEST_CS_BASE, 0xf0000);
 	vmcs_write16(GUEST_CS_SELECTOR, vmcs_readl(GUEST_CS_BASE) >> 4);
 
-	fix_rmode_seg(VCPU_SREG_ES, &vcpu->rmode.es);
-	fix_rmode_seg(VCPU_SREG_DS, &vcpu->rmode.ds);
-	fix_rmode_seg(VCPU_SREG_GS, &vcpu->rmode.gs);
-	fix_rmode_seg(VCPU_SREG_FS, &vcpu->rmode.fs);
+	fix_rmode_seg(VCPU_SREG_ES, &vcpu->arch.rmode.es);
+	fix_rmode_seg(VCPU_SREG_DS, &vcpu->arch.rmode.ds);
+	fix_rmode_seg(VCPU_SREG_GS, &vcpu->arch.rmode.gs);
+	fix_rmode_seg(VCPU_SREG_FS, &vcpu->arch.rmode.fs);
 
 	kvm_mmu_reset_context(vcpu);
 	init_rmode_tss(vcpu->kvm);
@@ -1222,7 +1222,7 @@ static void enter_lmode(struct kvm_vcpu *vcpu)
 			     | AR_TYPE_BUSY_64_TSS);
 	}
 
-	vcpu->shadow_efer |= EFER_LMA;
+	vcpu->arch.shadow_efer |= EFER_LMA;
 
 	find_msr_entry(to_vmx(vcpu), MSR_EFER)->data |= EFER_LMA | EFER_LME;
 	vmcs_write32(VM_ENTRY_CONTROLS,
@@ -1232,7 +1232,7 @@ static void enter_lmode(struct kvm_vcpu *vcpu)
 
 static void exit_lmode(struct kvm_vcpu *vcpu)
 {
-	vcpu->shadow_efer &= ~EFER_LMA;
+	vcpu->arch.shadow_efer &= ~EFER_LMA;
 
 	vmcs_write32(VM_ENTRY_CONTROLS,
 		     vmcs_read32(VM_ENTRY_CONTROLS)
@@ -1243,22 +1243,22 @@ static void exit_lmode(struct kvm_vcpu *vcpu)
 
 static void vmx_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
 {
-	vcpu->cr4 &= KVM_GUEST_CR4_MASK;
-	vcpu->cr4 |= vmcs_readl(GUEST_CR4) & ~KVM_GUEST_CR4_MASK;
+	vcpu->arch.cr4 &= KVM_GUEST_CR4_MASK;
+	vcpu->arch.cr4 |= vmcs_readl(GUEST_CR4) & ~KVM_GUEST_CR4_MASK;
 }
 
 static void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	vmx_fpu_deactivate(vcpu);
 
-	if (vcpu->rmode.active && (cr0 & X86_CR0_PE))
+	if (vcpu->arch.rmode.active && (cr0 & X86_CR0_PE))
 		enter_pmode(vcpu);
 
-	if (!vcpu->rmode.active && !(cr0 & X86_CR0_PE))
+	if (!vcpu->arch.rmode.active && !(cr0 & X86_CR0_PE))
 		enter_rmode(vcpu);
 
 #ifdef CONFIG_X86_64
-	if (vcpu->shadow_efer & EFER_LME) {
+	if (vcpu->arch.shadow_efer & EFER_LME) {
 		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG))
 			enter_lmode(vcpu);
 		if (is_paging(vcpu) && !(cr0 & X86_CR0_PG))
@@ -1269,7 +1269,7 @@ static void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	vmcs_writel(CR0_READ_SHADOW, cr0);
 	vmcs_writel(GUEST_CR0,
 		    (cr0 & ~KVM_GUEST_CR0_MASK) | KVM_VM_CR0_ALWAYS_ON);
-	vcpu->cr0 = cr0;
+	vcpu->arch.cr0 = cr0;
 
 	if (!(cr0 & X86_CR0_TS) || !(cr0 & X86_CR0_PE))
 		vmx_fpu_activate(vcpu);
@@ -1278,16 +1278,16 @@ static void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 static void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	vmcs_writel(GUEST_CR3, cr3);
-	if (vcpu->cr0 & X86_CR0_PE)
+	if (vcpu->arch.cr0 & X86_CR0_PE)
 		vmx_fpu_deactivate(vcpu);
 }
 
 static void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	vmcs_writel(CR4_READ_SHADOW, cr4);
-	vmcs_writel(GUEST_CR4, cr4 | (vcpu->rmode.active ?
+	vmcs_writel(GUEST_CR4, cr4 | (vcpu->arch.rmode.active ?
 		    KVM_RMODE_VM_CR4_ALWAYS_ON : KVM_PMODE_VM_CR4_ALWAYS_ON));
-	vcpu->cr4 = cr4;
+	vcpu->arch.cr4 = cr4;
 }
 
 #ifdef CONFIG_X86_64
@@ -1297,7 +1297,7 @@ static void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct kvm_msr_entry *msr = find_msr_entry(vmx, MSR_EFER);
 
-	vcpu->shadow_efer = efer;
+	vcpu->arch.shadow_efer = efer;
 	if (efer & EFER_LMA) {
 		vmcs_write32(VM_ENTRY_CONTROLS,
 				     vmcs_read32(VM_ENTRY_CONTROLS) |
@@ -1374,17 +1374,17 @@ static void vmx_set_segment(struct kvm_vcpu *vcpu,
 	struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
 	u32 ar;
 
-	if (vcpu->rmode.active && seg == VCPU_SREG_TR) {
-		vcpu->rmode.tr.selector = var->selector;
-		vcpu->rmode.tr.base = var->base;
-		vcpu->rmode.tr.limit = var->limit;
-		vcpu->rmode.tr.ar = vmx_segment_access_rights(var);
+	if (vcpu->arch.rmode.active && seg == VCPU_SREG_TR) {
+		vcpu->arch.rmode.tr.selector = var->selector;
+		vcpu->arch.rmode.tr.base = var->base;
+		vcpu->arch.rmode.tr.limit = var->limit;
+		vcpu->arch.rmode.tr.ar = vmx_segment_access_rights(var);
 		return;
 	}
 	vmcs_writel(sf->base, var->base);
 	vmcs_write32(sf->limit, var->limit);
 	vmcs_write16(sf->selector, var->selector);
-	if (vcpu->rmode.active && var->s) {
+	if (vcpu->arch.rmode.active && var->s) {
 		/*
 		 * Hack real-mode segments into vm86 compatibility.
 		 */
@@ -1613,9 +1613,9 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 		goto out;
 	}
 
-	vmx->vcpu.rmode.active = 0;
+	vmx->vcpu.arch.rmode.active = 0;
 
-	vmx->vcpu.regs[VCPU_REGS_RDX] = get_rdx_init_val();
+	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
 	set_cr8(&vmx->vcpu, 0);
 	msr = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
 	if (vmx->vcpu.vcpu_id == 0)
@@ -1632,8 +1632,8 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 		vmcs_write16(GUEST_CS_SELECTOR, 0xf000);
 		vmcs_writel(GUEST_CS_BASE, 0x000f0000);
 	} else {
-		vmcs_write16(GUEST_CS_SELECTOR, vmx->vcpu.sipi_vector << 8);
-		vmcs_writel(GUEST_CS_BASE, vmx->vcpu.sipi_vector << 12);
+		vmcs_write16(GUEST_CS_SELECTOR, vmx->vcpu.arch.sipi_vector << 8);
+		vmcs_writel(GUEST_CS_BASE, vmx->vcpu.arch.sipi_vector << 12);
 	}
 	vmcs_write32(GUEST_CS_LIMIT, 0xffff);
 	vmcs_write32(GUEST_CS_AR_BYTES, 0x9b);
@@ -1691,7 +1691,7 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 		vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, 0);
 		if (vm_need_tpr_shadow(vmx->vcpu.kvm))
 			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR,
-				     page_to_phys(vmx->vcpu.apic->regs_page));
+				page_to_phys(vmx->vcpu.arch.apic->regs_page));
 		vmcs_write32(TPR_THRESHOLD, 0);
 	}
 
@@ -1699,8 +1699,8 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 		vmcs_write64(APIC_ACCESS_ADDR,
 			     page_to_phys(vmx->vcpu.kvm->apic_access_page));
 
-	vmx->vcpu.cr0 = 0x60000010;
-	vmx_set_cr0(&vmx->vcpu, vmx->vcpu.cr0); /* enter rmode */
+	vmx->vcpu.arch.cr0 = 0x60000010;
+	vmx_set_cr0(&vmx->vcpu, vmx->vcpu.arch.cr0); /* enter rmode */
 	vmx_set_cr4(&vmx->vcpu, 0);
 #ifdef CONFIG_X86_64
 	vmx_set_efer(&vmx->vcpu, 0);
@@ -1718,7 +1718,7 @@ static void vmx_inject_irq(struct kvm_vcpu *vcpu, int irq)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (vcpu->rmode.active) {
+	if (vcpu->arch.rmode.active) {
 		vmx->rmode.irq.pending = true;
 		vmx->rmode.irq.vector = irq;
 		vmx->rmode.irq.rip = vmcs_readl(GUEST_RIP);
@@ -1734,13 +1734,13 @@ static void vmx_inject_irq(struct kvm_vcpu *vcpu, int irq)
 
 static void kvm_do_inject_irq(struct kvm_vcpu *vcpu)
 {
-	int word_index = __ffs(vcpu->irq_summary);
-	int bit_index = __ffs(vcpu->irq_pending[word_index]);
+	int word_index = __ffs(vcpu->arch.irq_summary);
+	int bit_index = __ffs(vcpu->arch.irq_pending[word_index]);
 	int irq = word_index * BITS_PER_LONG + bit_index;
 
-	clear_bit(bit_index, &vcpu->irq_pending[word_index]);
-	if (!vcpu->irq_pending[word_index])
-		clear_bit(word_index, &vcpu->irq_summary);
+	clear_bit(bit_index, &vcpu->arch.irq_pending[word_index]);
+	if (!vcpu->arch.irq_pending[word_index])
+		clear_bit(word_index, &vcpu->arch.irq_summary);
 	vmx_inject_irq(vcpu, irq);
 }
 
@@ -1750,12 +1750,12 @@ static void do_interrupt_requests(struct kvm_vcpu *vcpu,
 {
 	u32 cpu_based_vm_exec_control;
 
-	vcpu->interrupt_window_open =
+	vcpu->arch.interrupt_window_open =
 		((vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) &&
 		 (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & 3) == 0);
 
-	if (vcpu->interrupt_window_open &&
-	    vcpu->irq_summary &&
+	if (vcpu->arch.interrupt_window_open &&
+	    vcpu->arch.irq_summary &&
 	    !(vmcs_read32(VM_ENTRY_INTR_INFO_FIELD) & INTR_INFO_VALID_MASK))
 		/*
 		 * If interrupts enabled, and not blocked by sti or mov ss. Good.
@@ -1763,8 +1763,8 @@ static void do_interrupt_requests(struct kvm_vcpu *vcpu,
 		kvm_do_inject_irq(vcpu);
 
 	cpu_based_vm_exec_control = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
-	if (!vcpu->interrupt_window_open &&
-	    (vcpu->irq_summary || kvm_run->request_interrupt_window))
+	if (!vcpu->arch.interrupt_window_open &&
+	    (vcpu->arch.irq_summary || kvm_run->request_interrupt_window))
 		/*
 		 * Interrupts blocked.  Wait for unblock.
 		 */
@@ -1812,7 +1812,7 @@ static void kvm_guest_debug_pre(struct kvm_vcpu *vcpu)
 static int handle_rmode_exception(struct kvm_vcpu *vcpu,
 				  int vec, u32 err_code)
 {
-	if (!vcpu->rmode.active)
+	if (!vcpu->arch.rmode.active)
 		return 0;
 
 	/*
@@ -1843,8 +1843,8 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	if (!irqchip_in_kernel(vcpu->kvm) && is_external_interrupt(vect_info)) {
 		int irq = vect_info & VECTORING_INFO_VECTOR_MASK;
-		set_bit(irq, vcpu->irq_pending);
-		set_bit(irq / BITS_PER_LONG, &vcpu->irq_summary);
+		set_bit(irq, vcpu->arch.irq_pending);
+		set_bit(irq / BITS_PER_LONG, &vcpu->arch.irq_summary);
 	}
 
 	if ((intr_info & INTR_INFO_INTR_TYPE_MASK) == 0x200) /* nmi */
@@ -1871,11 +1871,11 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		return kvm_mmu_page_fault(vcpu, cr2, error_code);
 	}
 
-	if (vcpu->rmode.active &&
+	if (vcpu->arch.rmode.active &&
 	    handle_rmode_exception(vcpu, intr_info & INTR_INFO_VECTOR_MASK,
 								error_code)) {
-		if (vcpu->halt_request) {
-			vcpu->halt_request = 0;
+		if (vcpu->arch.halt_request) {
+			vcpu->arch.halt_request = 0;
 			return kvm_emulate_halt(vcpu);
 		}
 		return 1;
@@ -1956,22 +1956,22 @@ static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		switch (cr) {
 		case 0:
 			vcpu_load_rsp_rip(vcpu);
-			set_cr0(vcpu, vcpu->regs[reg]);
+			set_cr0(vcpu, vcpu->arch.regs[reg]);
 			skip_emulated_instruction(vcpu);
 			return 1;
 		case 3:
 			vcpu_load_rsp_rip(vcpu);
-			set_cr3(vcpu, vcpu->regs[reg]);
+			set_cr3(vcpu, vcpu->arch.regs[reg]);
 			skip_emulated_instruction(vcpu);
 			return 1;
 		case 4:
 			vcpu_load_rsp_rip(vcpu);
-			set_cr4(vcpu, vcpu->regs[reg]);
+			set_cr4(vcpu, vcpu->arch.regs[reg]);
 			skip_emulated_instruction(vcpu);
 			return 1;
 		case 8:
 			vcpu_load_rsp_rip(vcpu);
-			set_cr8(vcpu, vcpu->regs[reg]);
+			set_cr8(vcpu, vcpu->arch.regs[reg]);
 			skip_emulated_instruction(vcpu);
 			if (irqchip_in_kernel(vcpu->kvm))
 				return 1;
@@ -1982,8 +1982,8 @@ static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	case 2: /* clts */
 		vcpu_load_rsp_rip(vcpu);
 		vmx_fpu_deactivate(vcpu);
-		vcpu->cr0 &= ~X86_CR0_TS;
-		vmcs_writel(CR0_READ_SHADOW, vcpu->cr0);
+		vcpu->arch.cr0 &= ~X86_CR0_TS;
+		vmcs_writel(CR0_READ_SHADOW, vcpu->arch.cr0);
 		vmx_fpu_activate(vcpu);
 		skip_emulated_instruction(vcpu);
 		return 1;
@@ -1991,13 +1991,13 @@ static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		switch (cr) {
 		case 3:
 			vcpu_load_rsp_rip(vcpu);
-			vcpu->regs[reg] = vcpu->cr3;
+			vcpu->arch.regs[reg] = vcpu->arch.cr3;
 			vcpu_put_rsp_rip(vcpu);
 			skip_emulated_instruction(vcpu);
 			return 1;
 		case 8:
 			vcpu_load_rsp_rip(vcpu);
-			vcpu->regs[reg] = get_cr8(vcpu);
+			vcpu->arch.regs[reg] = get_cr8(vcpu);
 			vcpu_put_rsp_rip(vcpu);
 			skip_emulated_instruction(vcpu);
 			return 1;
@@ -2043,7 +2043,7 @@ static int handle_dr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		default:
 			val = 0;
 		}
-		vcpu->regs[reg] = val;
+		vcpu->arch.regs[reg] = val;
 	} else {
 		/* mov to dr */
 	}
@@ -2060,7 +2060,7 @@ static int handle_cpuid(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 static int handle_rdmsr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	u32 ecx = vcpu->regs[VCPU_REGS_RCX];
+	u32 ecx = vcpu->arch.regs[VCPU_REGS_RCX];
 	u64 data;
 
 	if (vmx_get_msr(vcpu, ecx, &data)) {
@@ -2069,17 +2069,17 @@ static int handle_rdmsr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	}
 
 	/* FIXME: handling of bits 32:63 of rax, rdx */
-	vcpu->regs[VCPU_REGS_RAX] = data & -1u;
-	vcpu->regs[VCPU_REGS_RDX] = (data >> 32) & -1u;
+	vcpu->arch.regs[VCPU_REGS_RAX] = data & -1u;
+	vcpu->arch.regs[VCPU_REGS_RDX] = (data >> 32) & -1u;
 	skip_emulated_instruction(vcpu);
 	return 1;
 }
 
 static int handle_wrmsr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	u32 ecx = vcpu->regs[VCPU_REGS_RCX];
-	u64 data = (vcpu->regs[VCPU_REGS_RAX] & -1u)
-		| ((u64)(vcpu->regs[VCPU_REGS_RDX] & -1u) << 32);
+	u32 ecx = vcpu->arch.regs[VCPU_REGS_RCX];
+	u64 data = (vcpu->arch.regs[VCPU_REGS_RAX] & -1u)
+		| ((u64)(vcpu->arch.regs[VCPU_REGS_RDX] & -1u) << 32);
 
 	if (vmx_set_msr(vcpu, ecx, data) != 0) {
 		kvm_inject_gp(vcpu, 0);
@@ -2110,7 +2110,7 @@ static int handle_interrupt_window(struct kvm_vcpu *vcpu,
 	 * possible
 	 */
 	if (kvm_run->request_interrupt_window &&
-	    !vcpu->irq_summary) {
+	    !vcpu->arch.irq_summary) {
 		kvm_run->exit_reason = KVM_EXIT_IRQ_WINDOW_OPEN;
 		++vcpu->stat.irq_window_exits;
 		return 0;
@@ -2270,7 +2270,7 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 	if (unlikely(idtv_info_field & INTR_INFO_VALID_MASK)) {
 		if ((idtv_info_field & VECTORING_INFO_TYPE_MASK)
 		    == INTR_TYPE_EXT_INTR
-		    && vcpu->rmode.active) {
+		    && vcpu->arch.rmode.active) {
 			u8 vect = idtv_info_field & VECTORING_INFO_VECTOR_MASK;
 
 			vmx_inject_irq(vcpu, vect);
@@ -2424,24 +2424,24 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	      : : "c"(vmx), "d"((unsigned long)HOST_RSP),
 		[launched]"i"(offsetof(struct vcpu_vmx, launched)),
 		[fail]"i"(offsetof(struct vcpu_vmx, fail)),
-		[rax]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_RAX])),
-		[rbx]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_RBX])),
-		[rcx]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_RCX])),
-		[rdx]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_RDX])),
-		[rsi]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_RSI])),
-		[rdi]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_RDI])),
-		[rbp]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_RBP])),
+		[rax]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_RAX])),
+		[rbx]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_RBX])),
+		[rcx]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_RCX])),
+		[rdx]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_RDX])),
+		[rsi]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_RSI])),
+		[rdi]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_RDI])),
+		[rbp]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_RBP])),
 #ifdef CONFIG_X86_64
-		[r8]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_R8])),
-		[r9]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_R9])),
-		[r10]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_R10])),
-		[r11]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_R11])),
-		[r12]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_R12])),
-		[r13]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_R13])),
-		[r14]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_R14])),
-		[r15]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_R15])),
+		[r8]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_R8])),
+		[r9]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_R9])),
+		[r10]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_R10])),
+		[r11]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_R11])),
+		[r12]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_R12])),
+		[r13]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_R13])),
+		[r14]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_R14])),
+		[r15]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_R15])),
 #endif
-		[cr2]"i"(offsetof(struct vcpu_vmx, vcpu.cr2))
+		[cr2]"i"(offsetof(struct vcpu_vmx, vcpu.arch.cr2))
 	      : "cc", "memory"
 #ifdef CONFIG_X86_64
 		, "rbx", "rdi", "rsi"
@@ -2455,7 +2455,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	if (vmx->rmode.irq.pending)
 		fixup_rmode_irq(vmx);
 
-	vcpu->interrupt_window_open =
+	vcpu->arch.interrupt_window_open =
 		(vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & 3) == 0;
 
 	asm("mov %0, %%ds; mov %0, %%es" : : "r"(__USER_DS));
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 3b79684..5a2f33a 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -113,9 +113,9 @@ EXPORT_SYMBOL_GPL(segment_base);
 u64 kvm_get_apic_base(struct kvm_vcpu *vcpu)
 {
 	if (irqchip_in_kernel(vcpu->kvm))
-		return vcpu->apic_base;
+		return vcpu->arch.apic_base;
 	else
-		return vcpu->apic_base;
+		return vcpu->arch.apic_base;
 }
 EXPORT_SYMBOL_GPL(kvm_get_apic_base);
 
@@ -125,16 +125,16 @@ void kvm_set_apic_base(struct kvm_vcpu *vcpu, u64 data)
 	if (irqchip_in_kernel(vcpu->kvm))
 		kvm_lapic_set_base(vcpu, data);
 	else
-		vcpu->apic_base = data;
+		vcpu->arch.apic_base = data;
 }
 EXPORT_SYMBOL_GPL(kvm_set_apic_base);
 
 void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr)
 {
-	WARN_ON(vcpu->exception.pending);
-	vcpu->exception.pending = true;
-	vcpu->exception.has_error_code = false;
-	vcpu->exception.nr = nr;
+	WARN_ON(vcpu->arch.exception.pending);
+	vcpu->arch.exception.pending = true;
+	vcpu->arch.exception.has_error_code = false;
+	vcpu->arch.exception.nr = nr;
 }
 EXPORT_SYMBOL_GPL(kvm_queue_exception);
 
@@ -142,32 +142,32 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long addr,
 			   u32 error_code)
 {
 	++vcpu->stat.pf_guest;
-	if (vcpu->exception.pending && vcpu->exception.nr == PF_VECTOR) {
+	if (vcpu->arch.exception.pending && vcpu->arch.exception.nr == PF_VECTOR) {
 		printk(KERN_DEBUG "kvm: inject_page_fault:"
 		       " double fault 0x%lx\n", addr);
-		vcpu->exception.nr = DF_VECTOR;
-		vcpu->exception.error_code = 0;
+		vcpu->arch.exception.nr = DF_VECTOR;
+		vcpu->arch.exception.error_code = 0;
 		return;
 	}
-	vcpu->cr2 = addr;
+	vcpu->arch.cr2 = addr;
 	kvm_queue_exception_e(vcpu, PF_VECTOR, error_code);
 }
 
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code)
 {
-	WARN_ON(vcpu->exception.pending);
-	vcpu->exception.pending = true;
-	vcpu->exception.has_error_code = true;
-	vcpu->exception.nr = nr;
-	vcpu->exception.error_code = error_code;
+	WARN_ON(vcpu->arch.exception.pending);
+	vcpu->arch.exception.pending = true;
+	vcpu->arch.exception.has_error_code = true;
+	vcpu->arch.exception.nr = nr;
+	vcpu->arch.exception.error_code = error_code;
 }
 EXPORT_SYMBOL_GPL(kvm_queue_exception_e);
 
 static void __queue_exception(struct kvm_vcpu *vcpu)
 {
-	kvm_x86_ops->queue_exception(vcpu, vcpu->exception.nr,
-				     vcpu->exception.has_error_code,
-				     vcpu->exception.error_code);
+	kvm_x86_ops->queue_exception(vcpu, vcpu->arch.exception.nr,
+				     vcpu->arch.exception.has_error_code,
+				     vcpu->arch.exception.error_code);
 }
 
 /*
@@ -179,7 +179,7 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 	unsigned offset = ((cr3 & (PAGE_SIZE-1)) >> 5) << 2;
 	int i;
 	int ret;
-	u64 pdpte[ARRAY_SIZE(vcpu->pdptrs)];
+	u64 pdpte[ARRAY_SIZE(vcpu->arch.pdptrs)];
 
 	mutex_lock(&vcpu->kvm->lock);
 	ret = kvm_read_guest_page(vcpu->kvm, pdpt_gfn, pdpte,
@@ -196,7 +196,7 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 	}
 	ret = 1;
 
-	memcpy(vcpu->pdptrs, pdpte, sizeof(vcpu->pdptrs));
+	memcpy(vcpu->arch.pdptrs, pdpte, sizeof(vcpu->arch.pdptrs));
 out:
 	mutex_unlock(&vcpu->kvm->lock);
 
@@ -205,7 +205,7 @@ out:
 
 static bool pdptrs_changed(struct kvm_vcpu *vcpu)
 {
-	u64 pdpte[ARRAY_SIZE(vcpu->pdptrs)];
+	u64 pdpte[ARRAY_SIZE(vcpu->arch.pdptrs)];
 	bool changed = true;
 	int r;
 
@@ -213,10 +213,10 @@ static bool pdptrs_changed(struct kvm_vcpu *vcpu)
 		return false;
 
 	mutex_lock(&vcpu->kvm->lock);
-	r = kvm_read_guest(vcpu->kvm, vcpu->cr3 & ~31u, pdpte, sizeof(pdpte));
+	r = kvm_read_guest(vcpu->kvm, vcpu->arch.cr3 & ~31u, pdpte, sizeof(pdpte));
 	if (r < 0)
 		goto out;
-	changed = memcmp(pdpte, vcpu->pdptrs, sizeof(pdpte)) != 0;
+	changed = memcmp(pdpte, vcpu->arch.pdptrs, sizeof(pdpte)) != 0;
 out:
 	mutex_unlock(&vcpu->kvm->lock);
 
@@ -227,7 +227,7 @@ void set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	if (cr0 & CR0_RESERVED_BITS) {
 		printk(KERN_DEBUG "set_cr0: 0x%lx #GP, reserved bits 0x%lx\n",
-		       cr0, vcpu->cr0);
+		       cr0, vcpu->arch.cr0);
 		kvm_inject_gp(vcpu, 0);
 		return;
 	}
@@ -247,7 +247,7 @@ void set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 
 	if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
 #ifdef CONFIG_X86_64
-		if ((vcpu->shadow_efer & EFER_LME)) {
+		if ((vcpu->arch.shadow_efer & EFER_LME)) {
 			int cs_db, cs_l;
 
 			if (!is_pae(vcpu)) {
@@ -266,7 +266,7 @@ void set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 			}
 		} else
 #endif
-		if (is_pae(vcpu) && !load_pdptrs(vcpu, vcpu->cr3)) {
+		if (is_pae(vcpu) && !load_pdptrs(vcpu, vcpu->arch.cr3)) {
 			printk(KERN_DEBUG "set_cr0: #GP, pdptrs "
 			       "reserved bits\n");
 			kvm_inject_gp(vcpu, 0);
@@ -276,7 +276,7 @@ void set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	}
 
 	kvm_x86_ops->set_cr0(vcpu, cr0);
-	vcpu->cr0 = cr0;
+	vcpu->arch.cr0 = cr0;
 
 	mutex_lock(&vcpu->kvm->lock);
 	kvm_mmu_reset_context(vcpu);
@@ -287,7 +287,7 @@ EXPORT_SYMBOL_GPL(set_cr0);
 
 void lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
 {
-	set_cr0(vcpu, (vcpu->cr0 & ~0x0ful) | (msw & 0x0f));
+	set_cr0(vcpu, (vcpu->arch.cr0 & ~0x0ful) | (msw & 0x0f));
 }
 EXPORT_SYMBOL_GPL(lmsw);
 
@@ -307,7 +307,7 @@ void set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return;
 		}
 	} else if (is_paging(vcpu) && !is_pae(vcpu) && (cr4 & X86_CR4_PAE)
-		   && !load_pdptrs(vcpu, vcpu->cr3)) {
+		   && !load_pdptrs(vcpu, vcpu->arch.cr3)) {
 		printk(KERN_DEBUG "set_cr4: #GP, pdptrs reserved bits\n");
 		kvm_inject_gp(vcpu, 0);
 		return;
@@ -319,7 +319,7 @@ void set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		return;
 	}
 	kvm_x86_ops->set_cr4(vcpu, cr4);
-	vcpu->cr4 = cr4;
+	vcpu->arch.cr4 = cr4;
 	mutex_lock(&vcpu->kvm->lock);
 	kvm_mmu_reset_context(vcpu);
 	mutex_unlock(&vcpu->kvm->lock);
@@ -328,7 +328,7 @@ EXPORT_SYMBOL_GPL(set_cr4);
 
 void set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
-	if (cr3 == vcpu->cr3 && !pdptrs_changed(vcpu)) {
+	if (cr3 == vcpu->arch.cr3 && !pdptrs_changed(vcpu)) {
 		kvm_mmu_flush_tlb(vcpu);
 		return;
 	}
@@ -373,8 +373,8 @@ void set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	if (unlikely(!gfn_to_memslot(vcpu->kvm, cr3 >> PAGE_SHIFT)))
 		kvm_inject_gp(vcpu, 0);
 	else {
-		vcpu->cr3 = cr3;
-		vcpu->mmu.new_cr3(vcpu);
+		vcpu->arch.cr3 = cr3;
+		vcpu->arch.mmu.new_cr3(vcpu);
 	}
 	mutex_unlock(&vcpu->kvm->lock);
 }
@@ -390,7 +390,7 @@ void set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8)
 	if (irqchip_in_kernel(vcpu->kvm))
 		kvm_lapic_set_tpr(vcpu, cr8);
 	else
-		vcpu->cr8 = cr8;
+		vcpu->arch.cr8 = cr8;
 }
 EXPORT_SYMBOL_GPL(set_cr8);
 
@@ -399,7 +399,7 @@ unsigned long get_cr8(struct kvm_vcpu *vcpu)
 	if (irqchip_in_kernel(vcpu->kvm))
 		return kvm_lapic_get_cr8(vcpu);
 	else
-		return vcpu->cr8;
+		return vcpu->arch.cr8;
 }
 EXPORT_SYMBOL_GPL(get_cr8);
 
@@ -437,7 +437,7 @@ static void set_efer(struct kvm_vcpu *vcpu, u64 efer)
 	}
 
 	if (is_paging(vcpu)
-	    && (vcpu->shadow_efer & EFER_LME) != (efer & EFER_LME)) {
+	    && (vcpu->arch.shadow_efer & EFER_LME) != (efer & EFER_LME)) {
 		printk(KERN_DEBUG "set_efer: #GP, change LME while paging\n");
 		kvm_inject_gp(vcpu, 0);
 		return;
@@ -446,9 +446,9 @@ static void set_efer(struct kvm_vcpu *vcpu, u64 efer)
 	kvm_x86_ops->set_efer(vcpu, efer);
 
 	efer &= ~EFER_LMA;
-	efer |= vcpu->shadow_efer & EFER_LMA;
+	efer |= vcpu->arch.shadow_efer & EFER_LMA;
 
-	vcpu->shadow_efer = efer;
+	vcpu->arch.shadow_efer = efer;
 }
 
 #endif
@@ -496,7 +496,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		kvm_set_apic_base(vcpu, data);
 		break;
 	case MSR_IA32_MISC_ENABLE:
-		vcpu->ia32_misc_enable_msr = data;
+		vcpu->arch.ia32_misc_enable_msr = data;
 		break;
 	default:
 		pr_unimpl(vcpu, "unhandled wrmsr: 0x%x\n", msr);
@@ -550,11 +550,11 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 		data = kvm_get_apic_base(vcpu);
 		break;
 	case MSR_IA32_MISC_ENABLE:
-		data = vcpu->ia32_misc_enable_msr;
+		data = vcpu->arch.ia32_misc_enable_msr;
 		break;
 #ifdef CONFIG_X86_64
 	case MSR_EFER:
-		data = vcpu->shadow_efer;
+		data = vcpu->arch.shadow_efer;
 		break;
 #endif
 	default:
@@ -760,8 +760,8 @@ static void cpuid_fix_nx_cap(struct kvm_vcpu *vcpu)
 	struct kvm_cpuid_entry2 *e, *entry;
 
 	entry = NULL;
-	for (i = 0; i < vcpu->cpuid_nent; ++i) {
-		e = &vcpu->cpuid_entries[i];
+	for (i = 0; i < vcpu->arch.cpuid_nent; ++i) {
+		e = &vcpu->arch.cpuid_entries[i];
 		if (e->function == 0x80000001) {
 			entry = e;
 			break;
@@ -793,18 +793,18 @@ static int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 			   cpuid->nent * sizeof(struct kvm_cpuid_entry)))
 		goto out_free;
 	for (i = 0; i < cpuid->nent; i++) {
-		vcpu->cpuid_entries[i].function = cpuid_entries[i].function;
-		vcpu->cpuid_entries[i].eax = cpuid_entries[i].eax;
-		vcpu->cpuid_entries[i].ebx = cpuid_entries[i].ebx;
-		vcpu->cpuid_entries[i].ecx = cpuid_entries[i].ecx;
-		vcpu->cpuid_entries[i].edx = cpuid_entries[i].edx;
-		vcpu->cpuid_entries[i].index = 0;
-		vcpu->cpuid_entries[i].flags = 0;
-		vcpu->cpuid_entries[i].padding[0] = 0;
-		vcpu->cpuid_entries[i].padding[1] = 0;
-		vcpu->cpuid_entries[i].padding[2] = 0;
-	}
-	vcpu->cpuid_nent = cpuid->nent;
+		vcpu->arch.cpuid_entries[i].function = cpuid_entries[i].function;
+		vcpu->arch.cpuid_entries[i].eax = cpuid_entries[i].eax;
+		vcpu->arch.cpuid_entries[i].ebx = cpuid_entries[i].ebx;
+		vcpu->arch.cpuid_entries[i].ecx = cpuid_entries[i].ecx;
+		vcpu->arch.cpuid_entries[i].edx = cpuid_entries[i].edx;
+		vcpu->arch.cpuid_entries[i].index = 0;
+		vcpu->arch.cpuid_entries[i].flags = 0;
+		vcpu->arch.cpuid_entries[i].padding[0] = 0;
+		vcpu->arch.cpuid_entries[i].padding[1] = 0;
+		vcpu->arch.cpuid_entries[i].padding[2] = 0;
+	}
+	vcpu->arch.cpuid_nent = cpuid->nent;
 	cpuid_fix_nx_cap(vcpu);
 	r = 0;
 
@@ -824,10 +824,10 @@ static int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 	if (cpuid->nent > KVM_MAX_CPUID_ENTRIES)
 		goto out;
 	r = -EFAULT;
-	if (copy_from_user(&vcpu->cpuid_entries, entries,
+	if (copy_from_user(&vcpu->arch.cpuid_entries, entries,
 			   cpuid->nent * sizeof(struct kvm_cpuid_entry2)))
 		goto out;
-	vcpu->cpuid_nent = cpuid->nent;
+	vcpu->arch.cpuid_nent = cpuid->nent;
 	return 0;
 
 out:
@@ -841,16 +841,16 @@ static int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
 	int r;
 
 	r = -E2BIG;
-	if (cpuid->nent < vcpu->cpuid_nent)
+	if (cpuid->nent < vcpu->arch.cpuid_nent)
 		goto out;
 	r = -EFAULT;
-	if (copy_to_user(entries, &vcpu->cpuid_entries,
-			   vcpu->cpuid_nent * sizeof(struct kvm_cpuid_entry2)))
+	if (copy_to_user(entries, &vcpu->arch.cpuid_entries,
+			   vcpu->arch.cpuid_nent * sizeof(struct kvm_cpuid_entry2)))
 		goto out;
 	return 0;
 
 out:
-	cpuid->nent = vcpu->cpuid_nent;
+	cpuid->nent = vcpu->arch.cpuid_nent;
 	return r;
 }
 
@@ -1021,7 +1021,7 @@ static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
 				    struct kvm_lapic_state *s)
 {
 	vcpu_load(vcpu);
-	memcpy(s->regs, vcpu->apic->regs, sizeof *s);
+	memcpy(s->regs, vcpu->arch.apic->regs, sizeof *s);
 	vcpu_put(vcpu);
 
 	return 0;
@@ -1031,7 +1031,7 @@ static int kvm_vcpu_ioctl_set_lapic(struct kvm_vcpu *vcpu,
 				    struct kvm_lapic_state *s)
 {
 	vcpu_load(vcpu);
-	memcpy(vcpu->apic->regs, s->regs, sizeof *s);
+	memcpy(vcpu->arch.apic->regs, s->regs, sizeof *s);
 	kvm_apic_post_state_restore(vcpu);
 	vcpu_put(vcpu);
 
@@ -1047,8 +1047,8 @@ static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
 		return -ENXIO;
 	vcpu_load(vcpu);
 
-	set_bit(irq->irq, vcpu->irq_pending);
-	set_bit(irq->irq / BITS_PER_LONG, &vcpu->irq_summary);
+	set_bit(irq->irq, vcpu->arch.irq_pending);
+	set_bit(irq->irq / BITS_PER_LONG, &vcpu->arch.irq_summary);
 
 	vcpu_put(vcpu);
 
@@ -1499,8 +1499,8 @@ static struct kvm_io_device *vcpu_find_pervcpu_dev(struct kvm_vcpu *vcpu,
 {
 	struct kvm_io_device *dev;
 
-	if (vcpu->apic) {
-		dev = &vcpu->apic->dev;
+	if (vcpu->arch.apic) {
+		dev = &vcpu->arch.apic->dev;
 		if (dev->in_range(dev, addr))
 			return dev;
 	}
@@ -1527,7 +1527,7 @@ int emulator_read_std(unsigned long addr,
 	void *data = val;
 
 	while (bytes) {
-		gpa_t gpa = vcpu->mmu.gva_to_gpa(vcpu, addr);
+		gpa_t gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, addr);
 		unsigned offset = addr & (PAGE_SIZE-1);
 		unsigned tocopy = min(bytes, (unsigned)PAGE_SIZE - offset);
 		int ret;
@@ -1561,7 +1561,7 @@ static int emulator_read_emulated(unsigned long addr,
 		return X86EMUL_CONTINUE;
 	}
 
-	gpa = vcpu->mmu.gva_to_gpa(vcpu, addr);
+	gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, addr);
 
 	/* For APIC access vmexit */
 	if ((gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
@@ -1609,7 +1609,7 @@ static int emulator_write_emulated_onepage(unsigned long addr,
 					   struct kvm_vcpu *vcpu)
 {
 	struct kvm_io_device *mmio_dev;
-	gpa_t                 gpa = vcpu->mmu.gva_to_gpa(vcpu, addr);
+	gpa_t                 gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, addr);
 
 	if (gpa == UNMAPPED_GVA) {
 		kvm_inject_page_fault(vcpu, addr, 2);
@@ -1678,7 +1678,7 @@ static int emulator_cmpxchg_emulated(unsigned long addr,
 #ifndef CONFIG_X86_64
 	/* guests cmpxchg8b have to be emulated atomically */
 	if (bytes == 8) {
-		gpa_t gpa = vcpu->mmu.gva_to_gpa(vcpu, addr);
+		gpa_t gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, addr);
 		struct page *page;
 		char *addr;
 		u64 val;
@@ -1715,7 +1715,7 @@ int emulate_invlpg(struct kvm_vcpu *vcpu, gva_t address)
 
 int emulate_clts(struct kvm_vcpu *vcpu)
 {
-	kvm_x86_ops->set_cr0(vcpu, vcpu->cr0 & ~X86_CR0_TS);
+	kvm_x86_ops->set_cr0(vcpu, vcpu->arch.cr0 & ~X86_CR0_TS);
 	return X86EMUL_CONTINUE;
 }
 
@@ -1750,7 +1750,7 @@ void kvm_report_emulation_failure(struct kvm_vcpu *vcpu, const char *context)
 {
 	static int reported;
 	u8 opcodes[4];
-	unsigned long rip = vcpu->rip;
+	unsigned long rip = vcpu->arch.rip;
 	unsigned long rip_linear;
 
 	rip_linear = rip + get_segment_base(vcpu, VCPU_SREG_CS);
@@ -1781,46 +1781,46 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 {
 	int r;
 
-	vcpu->mmio_fault_cr2 = cr2;
+	vcpu->arch.mmio_fault_cr2 = cr2;
 	kvm_x86_ops->cache_regs(vcpu);
 
 	vcpu->mmio_is_write = 0;
-	vcpu->pio.string = 0;
+	vcpu->arch.pio.string = 0;
 
 	if (!no_decode) {
 		int cs_db, cs_l;
 		kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
 
-		vcpu->emulate_ctxt.vcpu = vcpu;
-		vcpu->emulate_ctxt.eflags = kvm_x86_ops->get_rflags(vcpu);
-		vcpu->emulate_ctxt.mode =
-			(vcpu->emulate_ctxt.eflags & X86_EFLAGS_VM)
+		vcpu->arch.emulate_ctxt.vcpu = vcpu;
+		vcpu->arch.emulate_ctxt.eflags = kvm_x86_ops->get_rflags(vcpu);
+		vcpu->arch.emulate_ctxt.mode =
+			(vcpu->arch.emulate_ctxt.eflags & X86_EFLAGS_VM)
 			? X86EMUL_MODE_REAL : cs_l
 			? X86EMUL_MODE_PROT64 :	cs_db
 			? X86EMUL_MODE_PROT32 : X86EMUL_MODE_PROT16;
 
-		if (vcpu->emulate_ctxt.mode == X86EMUL_MODE_PROT64) {
-			vcpu->emulate_ctxt.cs_base = 0;
-			vcpu->emulate_ctxt.ds_base = 0;
-			vcpu->emulate_ctxt.es_base = 0;
-			vcpu->emulate_ctxt.ss_base = 0;
+		if (vcpu->arch.emulate_ctxt.mode == X86EMUL_MODE_PROT64) {
+			vcpu->arch.emulate_ctxt.cs_base = 0;
+			vcpu->arch.emulate_ctxt.ds_base = 0;
+			vcpu->arch.emulate_ctxt.es_base = 0;
+			vcpu->arch.emulate_ctxt.ss_base = 0;
 		} else {
-			vcpu->emulate_ctxt.cs_base =
+			vcpu->arch.emulate_ctxt.cs_base =
 					get_segment_base(vcpu, VCPU_SREG_CS);
-			vcpu->emulate_ctxt.ds_base =
+			vcpu->arch.emulate_ctxt.ds_base =
 					get_segment_base(vcpu, VCPU_SREG_DS);
-			vcpu->emulate_ctxt.es_base =
+			vcpu->arch.emulate_ctxt.es_base =
 					get_segment_base(vcpu, VCPU_SREG_ES);
-			vcpu->emulate_ctxt.ss_base =
+			vcpu->arch.emulate_ctxt.ss_base =
 					get_segment_base(vcpu, VCPU_SREG_SS);
 		}
 
-		vcpu->emulate_ctxt.gs_base =
+		vcpu->arch.emulate_ctxt.gs_base =
 					get_segment_base(vcpu, VCPU_SREG_GS);
-		vcpu->emulate_ctxt.fs_base =
+		vcpu->arch.emulate_ctxt.fs_base =
 					get_segment_base(vcpu, VCPU_SREG_FS);
 
-		r = x86_decode_insn(&vcpu->emulate_ctxt, &emulate_ops);
+		r = x86_decode_insn(&vcpu->arch.emulate_ctxt, &emulate_ops);
 		++vcpu->stat.insn_emulation;
 		if (r)  {
 			++vcpu->stat.insn_emulation_fail;
@@ -1830,9 +1830,9 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 		}
 	}
 
-	r = x86_emulate_insn(&vcpu->emulate_ctxt, &emulate_ops);
+	r = x86_emulate_insn(&vcpu->arch.emulate_ctxt, &emulate_ops);
 
-	if (vcpu->pio.string)
+	if (vcpu->arch.pio.string)
 		return EMULATE_DO_MMIO;
 
 	if ((r || vcpu->mmio_is_write) && run) {
@@ -1854,7 +1854,7 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 	}
 
 	kvm_x86_ops->decache_regs(vcpu);
-	kvm_x86_ops->set_rflags(vcpu, vcpu->emulate_ctxt.eflags);
+	kvm_x86_ops->set_rflags(vcpu, vcpu->arch.emulate_ctxt.eflags);
 
 	if (vcpu->mmio_is_write) {
 		vcpu->mmio_needed = 0;
@@ -1869,33 +1869,33 @@ static void free_pio_guest_pages(struct kvm_vcpu *vcpu)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(vcpu->pio.guest_pages); ++i)
-		if (vcpu->pio.guest_pages[i]) {
-			kvm_release_page_dirty(vcpu->pio.guest_pages[i]);
-			vcpu->pio.guest_pages[i] = NULL;
+	for (i = 0; i < ARRAY_SIZE(vcpu->arch.pio.guest_pages); ++i)
+		if (vcpu->arch.pio.guest_pages[i]) {
+			kvm_release_page_dirty(vcpu->arch.pio.guest_pages[i]);
+			vcpu->arch.pio.guest_pages[i] = NULL;
 		}
 }
 
 static int pio_copy_data(struct kvm_vcpu *vcpu)
 {
-	void *p = vcpu->pio_data;
+	void *p = vcpu->arch.pio_data;
 	void *q;
 	unsigned bytes;
-	int nr_pages = vcpu->pio.guest_pages[1] ? 2 : 1;
+	int nr_pages = vcpu->arch.pio.guest_pages[1] ? 2 : 1;
 
-	q = vmap(vcpu->pio.guest_pages, nr_pages, VM_READ|VM_WRITE,
+	q = vmap(vcpu->arch.pio.guest_pages, nr_pages, VM_READ|VM_WRITE,
 		 PAGE_KERNEL);
 	if (!q) {
 		free_pio_guest_pages(vcpu);
 		return -ENOMEM;
 	}
-	q += vcpu->pio.guest_page_offset;
-	bytes = vcpu->pio.size * vcpu->pio.cur_count;
-	if (vcpu->pio.in)
+	q += vcpu->arch.pio.guest_page_offset;
+	bytes = vcpu->arch.pio.size * vcpu->arch.pio.cur_count;
+	if (vcpu->arch.pio.in)
 		memcpy(q, p, bytes);
 	else
 		memcpy(p, q, bytes);
-	q -= vcpu->pio.guest_page_offset;
+	q -= vcpu->arch.pio.guest_page_offset;
 	vunmap(q);
 	free_pio_guest_pages(vcpu);
 	return 0;
@@ -1903,7 +1903,7 @@ static int pio_copy_data(struct kvm_vcpu *vcpu)
 
 int complete_pio(struct kvm_vcpu *vcpu)
 {
-	struct kvm_pio_request *io = &vcpu->pio;
+	struct kvm_pio_request *io = &vcpu->arch.pio;
 	long delta;
 	int r;
 
@@ -1911,7 +1911,7 @@ int complete_pio(struct kvm_vcpu *vcpu)
 
 	if (!io->string) {
 		if (io->in)
-			memcpy(&vcpu->regs[VCPU_REGS_RAX], vcpu->pio_data,
+			memcpy(&vcpu->arch.regs[VCPU_REGS_RAX], vcpu->arch.pio_data,
 			       io->size);
 	} else {
 		if (io->in) {
@@ -1929,15 +1929,15 @@ int complete_pio(struct kvm_vcpu *vcpu)
 			 * The size of the register should really depend on
 			 * current address size.
 			 */
-			vcpu->regs[VCPU_REGS_RCX] -= delta;
+			vcpu->arch.regs[VCPU_REGS_RCX] -= delta;
 		}
 		if (io->down)
 			delta = -delta;
 		delta *= io->size;
 		if (io->in)
-			vcpu->regs[VCPU_REGS_RDI] += delta;
+			vcpu->arch.regs[VCPU_REGS_RDI] += delta;
 		else
-			vcpu->regs[VCPU_REGS_RSI] += delta;
+			vcpu->arch.regs[VCPU_REGS_RSI] += delta;
 	}
 
 	kvm_x86_ops->decache_regs(vcpu);
@@ -1955,13 +1955,13 @@ static void kernel_pio(struct kvm_io_device *pio_dev,
 	/* TODO: String I/O for in kernel device */
 
 	mutex_lock(&vcpu->kvm->lock);
-	if (vcpu->pio.in)
-		kvm_iodevice_read(pio_dev, vcpu->pio.port,
-				  vcpu->pio.size,
+	if (vcpu->arch.pio.in)
+		kvm_iodevice_read(pio_dev, vcpu->arch.pio.port,
+				  vcpu->arch.pio.size,
 				  pd);
 	else
-		kvm_iodevice_write(pio_dev, vcpu->pio.port,
-				   vcpu->pio.size,
+		kvm_iodevice_write(pio_dev, vcpu->arch.pio.port,
+				   vcpu->arch.pio.size,
 				   pd);
 	mutex_unlock(&vcpu->kvm->lock);
 }
@@ -1969,8 +1969,8 @@ static void kernel_pio(struct kvm_io_device *pio_dev,
 static void pio_string_write(struct kvm_io_device *pio_dev,
 			     struct kvm_vcpu *vcpu)
 {
-	struct kvm_pio_request *io = &vcpu->pio;
-	void *pd = vcpu->pio_data;
+	struct kvm_pio_request *io = &vcpu->arch.pio;
+	void *pd = vcpu->arch.pio_data;
 	int i;
 
 	mutex_lock(&vcpu->kvm->lock);
@@ -1996,25 +1996,25 @@ int kvm_emulate_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 
 	vcpu->run->exit_reason = KVM_EXIT_IO;
 	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
-	vcpu->run->io.size = vcpu->pio.size = size;
+	vcpu->run->io.size = vcpu->arch.pio.size = size;
 	vcpu->run->io.data_offset = KVM_PIO_PAGE_OFFSET * PAGE_SIZE;
-	vcpu->run->io.count = vcpu->pio.count = vcpu->pio.cur_count = 1;
-	vcpu->run->io.port = vcpu->pio.port = port;
-	vcpu->pio.in = in;
-	vcpu->pio.string = 0;
-	vcpu->pio.down = 0;
-	vcpu->pio.guest_page_offset = 0;
-	vcpu->pio.rep = 0;
+	vcpu->run->io.count = vcpu->arch.pio.count = vcpu->arch.pio.cur_count = 1;
+	vcpu->run->io.port = vcpu->arch.pio.port = port;
+	vcpu->arch.pio.in = in;
+	vcpu->arch.pio.string = 0;
+	vcpu->arch.pio.down = 0;
+	vcpu->arch.pio.guest_page_offset = 0;
+	vcpu->arch.pio.rep = 0;
 
 	kvm_x86_ops->cache_regs(vcpu);
-	memcpy(vcpu->pio_data, &vcpu->regs[VCPU_REGS_RAX], 4);
+	memcpy(vcpu->arch.pio_data, &vcpu->arch.regs[VCPU_REGS_RAX], 4);
 	kvm_x86_ops->decache_regs(vcpu);
 
 	kvm_x86_ops->skip_emulated_instruction(vcpu);
 
 	pio_dev = vcpu_find_pio_dev(vcpu, port);
 	if (pio_dev) {
-		kernel_pio(pio_dev, vcpu, vcpu->pio_data);
+		kernel_pio(pio_dev, vcpu, vcpu->arch.pio_data);
 		complete_pio(vcpu);
 		return 1;
 	}
@@ -2034,15 +2034,15 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 
 	vcpu->run->exit_reason = KVM_EXIT_IO;
 	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
-	vcpu->run->io.size = vcpu->pio.size = size;
+	vcpu->run->io.size = vcpu->arch.pio.size = size;
 	vcpu->run->io.data_offset = KVM_PIO_PAGE_OFFSET * PAGE_SIZE;
-	vcpu->run->io.count = vcpu->pio.count = vcpu->pio.cur_count = count;
-	vcpu->run->io.port = vcpu->pio.port = port;
-	vcpu->pio.in = in;
-	vcpu->pio.string = 1;
-	vcpu->pio.down = down;
-	vcpu->pio.guest_page_offset = offset_in_page(address);
-	vcpu->pio.rep = rep;
+	vcpu->run->io.count = vcpu->arch.pio.count = vcpu->arch.pio.cur_count = count;
+	vcpu->run->io.port = vcpu->arch.pio.port = port;
+	vcpu->arch.pio.in = in;
+	vcpu->arch.pio.string = 1;
+	vcpu->arch.pio.down = down;
+	vcpu->arch.pio.guest_page_offset = offset_in_page(address);
+	vcpu->arch.pio.rep = rep;
 
 	if (!count) {
 		kvm_x86_ops->skip_emulated_instruction(vcpu);
@@ -2072,15 +2072,15 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 		return 1;
 	}
 	vcpu->run->io.count = now;
-	vcpu->pio.cur_count = now;
+	vcpu->arch.pio.cur_count = now;
 
-	if (vcpu->pio.cur_count == vcpu->pio.count)
+	if (vcpu->arch.pio.cur_count == vcpu->arch.pio.count)
 		kvm_x86_ops->skip_emulated_instruction(vcpu);
 
 	for (i = 0; i < nr_pages; ++i) {
 		mutex_lock(&vcpu->kvm->lock);
 		page = gva_to_page(vcpu, address + i * PAGE_SIZE);
-		vcpu->pio.guest_pages[i] = page;
+		vcpu->arch.pio.guest_pages[i] = page;
 		mutex_unlock(&vcpu->kvm->lock);
 		if (!page) {
 			kvm_inject_gp(vcpu, 0);
@@ -2090,13 +2090,13 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 	}
 
 	pio_dev = vcpu_find_pio_dev(vcpu, port);
-	if (!vcpu->pio.in) {
+	if (!vcpu->arch.pio.in) {
 		/* string PIO write */
 		ret = pio_copy_data(vcpu);
 		if (ret >= 0 && pio_dev) {
 			pio_string_write(pio_dev, vcpu);
 			complete_pio(vcpu);
-			if (vcpu->pio.count == 0)
+			if (vcpu->arch.pio.count == 0)
 				ret = 1;
 		}
 	} else if (pio_dev)
@@ -2156,9 +2156,9 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.halt_exits;
 	if (irqchip_in_kernel(vcpu->kvm)) {
-		vcpu->mp_state = VCPU_MP_STATE_HALTED;
+		vcpu->arch.mp_state = VCPU_MP_STATE_HALTED;
 		kvm_vcpu_block(vcpu);
-		if (vcpu->mp_state != VCPU_MP_STATE_RUNNABLE)
+		if (vcpu->arch.mp_state != VCPU_MP_STATE_RUNNABLE)
 			return -EINTR;
 		return 1;
 	} else {
@@ -2174,11 +2174,11 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 
 	kvm_x86_ops->cache_regs(vcpu);
 
-	nr = vcpu->regs[VCPU_REGS_RAX];
-	a0 = vcpu->regs[VCPU_REGS_RBX];
-	a1 = vcpu->regs[VCPU_REGS_RCX];
-	a2 = vcpu->regs[VCPU_REGS_RDX];
-	a3 = vcpu->regs[VCPU_REGS_RSI];
+	nr = vcpu->arch.regs[VCPU_REGS_RAX];
+	a0 = vcpu->arch.regs[VCPU_REGS_RBX];
+	a1 = vcpu->arch.regs[VCPU_REGS_RCX];
+	a2 = vcpu->arch.regs[VCPU_REGS_RDX];
+	a3 = vcpu->arch.regs[VCPU_REGS_RSI];
 
 	if (!is_long_mode(vcpu)) {
 		nr &= 0xFFFFFFFF;
@@ -2193,7 +2193,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		ret = -KVM_ENOSYS;
 		break;
 	}
-	vcpu->regs[VCPU_REGS_RAX] = ret;
+	vcpu->arch.regs[VCPU_REGS_RAX] = ret;
 	kvm_x86_ops->decache_regs(vcpu);
 	return 0;
 }
@@ -2215,7 +2215,7 @@ int kvm_fix_hypercall(struct kvm_vcpu *vcpu)
 
 	kvm_x86_ops->cache_regs(vcpu);
 	kvm_x86_ops->patch_hypercall(vcpu, instruction);
-	if (emulator_write_emulated(vcpu->rip, instruction, 3, vcpu)
+	if (emulator_write_emulated(vcpu->arch.rip, instruction, 3, vcpu)
 	    != X86EMUL_CONTINUE)
 		ret = -EFAULT;
 
@@ -2255,13 +2255,13 @@ unsigned long realmode_get_cr(struct kvm_vcpu *vcpu, int cr)
 	kvm_x86_ops->decache_cr4_guest_bits(vcpu);
 	switch (cr) {
 	case 0:
-		return vcpu->cr0;
+		return vcpu->arch.cr0;
 	case 2:
-		return vcpu->cr2;
+		return vcpu->arch.cr2;
 	case 3:
-		return vcpu->cr3;
+		return vcpu->arch.cr3;
 	case 4:
-		return vcpu->cr4;
+		return vcpu->arch.cr4;
 	case 8:
 		return get_cr8(vcpu);
 	default:
@@ -2275,17 +2275,17 @@ void realmode_set_cr(struct kvm_vcpu *vcpu, int cr, unsigned long val,
 {
 	switch (cr) {
 	case 0:
-		set_cr0(vcpu, mk_cr_64(vcpu->cr0, val));
+		set_cr0(vcpu, mk_cr_64(vcpu->arch.cr0, val));
 		*rflags = kvm_x86_ops->get_rflags(vcpu);
 		break;
 	case 2:
-		vcpu->cr2 = val;
+		vcpu->arch.cr2 = val;
 		break;
 	case 3:
 		set_cr3(vcpu, val);
 		break;
 	case 4:
-		set_cr4(vcpu, mk_cr_64(vcpu->cr4, val));
+		set_cr4(vcpu, mk_cr_64(vcpu->arch.cr4, val));
 		break;
 	case 8:
 		set_cr8(vcpu, val & 0xfUL);
@@ -2297,13 +2297,13 @@ void realmode_set_cr(struct kvm_vcpu *vcpu, int cr, unsigned long val,
 
 static int move_to_next_stateful_cpuid_entry(struct kvm_vcpu *vcpu, int i)
 {
-	struct kvm_cpuid_entry2 *e = &vcpu->cpuid_entries[i];
-	int j, nent = vcpu->cpuid_nent;
+	struct kvm_cpuid_entry2 *e = &vcpu->arch.cpuid_entries[i];
+	int j, nent = vcpu->arch.cpuid_nent;
 
 	e->flags &= ~KVM_CPUID_FLAG_STATE_READ_NEXT;
 	/* when no next entry is found, the current entry[i] is reselected */
 	for (j = i + 1; j == i; j = (j + 1) % nent) {
-		struct kvm_cpuid_entry2 *ej = &vcpu->cpuid_entries[j];
+		struct kvm_cpuid_entry2 *ej = &vcpu->arch.cpuid_entries[j];
 		if (ej->function == e->function) {
 			ej->flags |= KVM_CPUID_FLAG_STATE_READ_NEXT;
 			return j;
@@ -2334,15 +2334,15 @@ void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 	struct kvm_cpuid_entry2 *e, *best;
 
 	kvm_x86_ops->cache_regs(vcpu);
-	function = vcpu->regs[VCPU_REGS_RAX];
-	index = vcpu->regs[VCPU_REGS_RCX];
-	vcpu->regs[VCPU_REGS_RAX] = 0;
-	vcpu->regs[VCPU_REGS_RBX] = 0;
-	vcpu->regs[VCPU_REGS_RCX] = 0;
-	vcpu->regs[VCPU_REGS_RDX] = 0;
+	function = vcpu->arch.regs[VCPU_REGS_RAX];
+	index = vcpu->arch.regs[VCPU_REGS_RCX];
+	vcpu->arch.regs[VCPU_REGS_RAX] = 0;
+	vcpu->arch.regs[VCPU_REGS_RBX] = 0;
+	vcpu->arch.regs[VCPU_REGS_RCX] = 0;
+	vcpu->arch.regs[VCPU_REGS_RDX] = 0;
 	best = NULL;
-	for (i = 0; i < vcpu->cpuid_nent; ++i) {
-		e = &vcpu->cpuid_entries[i];
+	for (i = 0; i < vcpu->arch.cpuid_nent; ++i) {
+		e = &vcpu->arch.cpuid_entries[i];
 		if (is_matching_cpuid_entry(e, function, index)) {
 			if (e->flags & KVM_CPUID_FLAG_STATEFUL_FUNC)
 				move_to_next_stateful_cpuid_entry(vcpu, i);
@@ -2357,10 +2357,10 @@ void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 				best = e;
 	}
 	if (best) {
-		vcpu->regs[VCPU_REGS_RAX] = best->eax;
-		vcpu->regs[VCPU_REGS_RBX] = best->ebx;
-		vcpu->regs[VCPU_REGS_RCX] = best->ecx;
-		vcpu->regs[VCPU_REGS_RDX] = best->edx;
+		vcpu->arch.regs[VCPU_REGS_RAX] = best->eax;
+		vcpu->arch.regs[VCPU_REGS_RBX] = best->ebx;
+		vcpu->arch.regs[VCPU_REGS_RCX] = best->ecx;
+		vcpu->arch.regs[VCPU_REGS_RDX] = best->edx;
 	}
 	kvm_x86_ops->decache_regs(vcpu);
 	kvm_x86_ops->skip_emulated_instruction(vcpu);
@@ -2376,9 +2376,9 @@ EXPORT_SYMBOL_GPL(kvm_emulate_cpuid);
 static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu,
 					  struct kvm_run *kvm_run)
 {
-	return (!vcpu->irq_summary &&
+	return (!vcpu->arch.irq_summary &&
 		kvm_run->request_interrupt_window &&
-		vcpu->interrupt_window_open &&
+		vcpu->arch.interrupt_window_open &&
 		(kvm_x86_ops->get_rflags(vcpu) & X86_EFLAGS_IF));
 }
 
@@ -2392,22 +2392,22 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu,
 		kvm_run->ready_for_interrupt_injection = 1;
 	else
 		kvm_run->ready_for_interrupt_injection =
-					(vcpu->interrupt_window_open &&
-					 vcpu->irq_summary == 0);
+					(vcpu->arch.interrupt_window_open &&
+					 vcpu->arch.irq_summary == 0);
 }
 
 static int __vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	int r;
 
-	if (unlikely(vcpu->mp_state == VCPU_MP_STATE_SIPI_RECEIVED)) {
+	if (unlikely(vcpu->arch.mp_state == VCPU_MP_STATE_SIPI_RECEIVED)) {
 		pr_debug("vcpu %d received sipi with vector # %x\n",
-		       vcpu->vcpu_id, vcpu->sipi_vector);
+		       vcpu->vcpu_id, vcpu->arch.sipi_vector);
 		kvm_lapic_reset(vcpu);
 		r = kvm_x86_ops->vcpu_reset(vcpu);
 		if (r)
 			return r;
-		vcpu->mp_state = VCPU_MP_STATE_RUNNABLE;
+		vcpu->arch.mp_state = VCPU_MP_STATE_RUNNABLE;
 	}
 
 preempted:
@@ -2437,7 +2437,7 @@ again:
 		goto out;
 	}
 
-	if (vcpu->exception.pending)
+	if (vcpu->arch.exception.pending)
 		__queue_exception(vcpu);
 	else if (irqchip_in_kernel(vcpu->kvm))
 		kvm_x86_ops->inject_pending_irq(vcpu);
@@ -2475,11 +2475,11 @@ again:
 	 */
 	if (unlikely(prof_on == KVM_PROFILING)) {
 		kvm_x86_ops->cache_regs(vcpu);
-		profile_hit(KVM_PROFILING, (void *)vcpu->rip);
+		profile_hit(KVM_PROFILING, (void *)vcpu->arch.rip);
 	}
 
-	if (vcpu->exception.pending && kvm_x86_ops->exception_injected(vcpu))
-		vcpu->exception.pending = false;
+	if (vcpu->arch.exception.pending && kvm_x86_ops->exception_injected(vcpu))
+		vcpu->arch.exception.pending = false;
 
 	r = kvm_x86_ops->handle_exit(kvm_run, vcpu);
 
@@ -2512,7 +2512,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	vcpu_load(vcpu);
 
-	if (unlikely(vcpu->mp_state == VCPU_MP_STATE_UNINITIALIZED)) {
+	if (unlikely(vcpu->arch.mp_state == VCPU_MP_STATE_UNINITIALIZED)) {
 		kvm_vcpu_block(vcpu);
 		vcpu_put(vcpu);
 		return -EAGAIN;
@@ -2525,7 +2525,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	if (!irqchip_in_kernel(vcpu->kvm))
 		set_cr8(vcpu, kvm_run->cr8);
 
-	if (vcpu->pio.cur_count) {
+	if (vcpu->arch.pio.cur_count) {
 		r = complete_pio(vcpu);
 		if (r)
 			goto out;
@@ -2536,7 +2536,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		vcpu->mmio_read_completed = 1;
 		vcpu->mmio_needed = 0;
 		r = emulate_instruction(vcpu, kvm_run,
-					vcpu->mmio_fault_cr2, 0, 1);
+					vcpu->arch.mmio_fault_cr2, 0, 1);
 		if (r == EMULATE_DO_MMIO) {
 			/*
 			 * Read-modify-write.  Back to userspace.
@@ -2548,7 +2548,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 #endif
 	if (kvm_run->exit_reason == KVM_EXIT_HYPERCALL) {
 		kvm_x86_ops->cache_regs(vcpu);
-		vcpu->regs[VCPU_REGS_RAX] = kvm_run->hypercall.ret;
+		vcpu->arch.regs[VCPU_REGS_RAX] = kvm_run->hypercall.ret;
 		kvm_x86_ops->decache_regs(vcpu);
 	}
 
@@ -2568,26 +2568,26 @@ int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 
 	kvm_x86_ops->cache_regs(vcpu);
 
-	regs->rax = vcpu->regs[VCPU_REGS_RAX];
-	regs->rbx = vcpu->regs[VCPU_REGS_RBX];
-	regs->rcx = vcpu->regs[VCPU_REGS_RCX];
-	regs->rdx = vcpu->regs[VCPU_REGS_RDX];
-	regs->rsi = vcpu->regs[VCPU_REGS_RSI];
-	regs->rdi = vcpu->regs[VCPU_REGS_RDI];
-	regs->rsp = vcpu->regs[VCPU_REGS_RSP];
-	regs->rbp = vcpu->regs[VCPU_REGS_RBP];
+	regs->rax = vcpu->arch.regs[VCPU_REGS_RAX];
+	regs->rbx = vcpu->arch.regs[VCPU_REGS_RBX];
+	regs->rcx = vcpu->arch.regs[VCPU_REGS_RCX];
+	regs->rdx = vcpu->arch.regs[VCPU_REGS_RDX];
+	regs->rsi = vcpu->arch.regs[VCPU_REGS_RSI];
+	regs->rdi = vcpu->arch.regs[VCPU_REGS_RDI];
+	regs->rsp = vcpu->arch.regs[VCPU_REGS_RSP];
+	regs->rbp = vcpu->arch.regs[VCPU_REGS_RBP];
 #ifdef CONFIG_X86_64
-	regs->r8 = vcpu->regs[VCPU_REGS_R8];
-	regs->r9 = vcpu->regs[VCPU_REGS_R9];
-	regs->r10 = vcpu->regs[VCPU_REGS_R10];
-	regs->r11 = vcpu->regs[VCPU_REGS_R11];
-	regs->r12 = vcpu->regs[VCPU_REGS_R12];
-	regs->r13 = vcpu->regs[VCPU_REGS_R13];
-	regs->r14 = vcpu->regs[VCPU_REGS_R14];
-	regs->r15 = vcpu->regs[VCPU_REGS_R15];
+	regs->r8 = vcpu->arch.regs[VCPU_REGS_R8];
+	regs->r9 = vcpu->arch.regs[VCPU_REGS_R9];
+	regs->r10 = vcpu->arch.regs[VCPU_REGS_R10];
+	regs->r11 = vcpu->arch.regs[VCPU_REGS_R11];
+	regs->r12 = vcpu->arch.regs[VCPU_REGS_R12];
+	regs->r13 = vcpu->arch.regs[VCPU_REGS_R13];
+	regs->r14 = vcpu->arch.regs[VCPU_REGS_R14];
+	regs->r15 = vcpu->arch.regs[VCPU_REGS_R15];
 #endif
 
-	regs->rip = vcpu->rip;
+	regs->rip = vcpu->arch.rip;
 	regs->rflags = kvm_x86_ops->get_rflags(vcpu);
 
 	/*
@@ -2605,26 +2605,26 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
 	vcpu_load(vcpu);
 
-	vcpu->regs[VCPU_REGS_RAX] = regs->rax;
-	vcpu->regs[VCPU_REGS_RBX] = regs->rbx;
-	vcpu->regs[VCPU_REGS_RCX] = regs->rcx;
-	vcpu->regs[VCPU_REGS_RDX] = regs->rdx;
-	vcpu->regs[VCPU_REGS_RSI] = regs->rsi;
-	vcpu->regs[VCPU_REGS_RDI] = regs->rdi;
-	vcpu->regs[VCPU_REGS_RSP] = regs->rsp;
-	vcpu->regs[VCPU_REGS_RBP] = regs->rbp;
+	vcpu->arch.regs[VCPU_REGS_RAX] = regs->rax;
+	vcpu->arch.regs[VCPU_REGS_RBX] = regs->rbx;
+	vcpu->arch.regs[VCPU_REGS_RCX] = regs->rcx;
+	vcpu->arch.regs[VCPU_REGS_RDX] = regs->rdx;
+	vcpu->arch.regs[VCPU_REGS_RSI] = regs->rsi;
+	vcpu->arch.regs[VCPU_REGS_RDI] = regs->rdi;
+	vcpu->arch.regs[VCPU_REGS_RSP] = regs->rsp;
+	vcpu->arch.regs[VCPU_REGS_RBP] = regs->rbp;
 #ifdef CONFIG_X86_64
-	vcpu->regs[VCPU_REGS_R8] = regs->r8;
-	vcpu->regs[VCPU_REGS_R9] = regs->r9;
-	vcpu->regs[VCPU_REGS_R10] = regs->r10;
-	vcpu->regs[VCPU_REGS_R11] = regs->r11;
-	vcpu->regs[VCPU_REGS_R12] = regs->r12;
-	vcpu->regs[VCPU_REGS_R13] = regs->r13;
-	vcpu->regs[VCPU_REGS_R14] = regs->r14;
-	vcpu->regs[VCPU_REGS_R15] = regs->r15;
+	vcpu->arch.regs[VCPU_REGS_R8] = regs->r8;
+	vcpu->arch.regs[VCPU_REGS_R9] = regs->r9;
+	vcpu->arch.regs[VCPU_REGS_R10] = regs->r10;
+	vcpu->arch.regs[VCPU_REGS_R11] = regs->r11;
+	vcpu->arch.regs[VCPU_REGS_R12] = regs->r12;
+	vcpu->arch.regs[VCPU_REGS_R13] = regs->r13;
+	vcpu->arch.regs[VCPU_REGS_R14] = regs->r14;
+	vcpu->arch.regs[VCPU_REGS_R15] = regs->r15;
 #endif
 
-	vcpu->rip = regs->rip;
+	vcpu->arch.rip = regs->rip;
 	kvm_x86_ops->set_rflags(vcpu, regs->rflags);
 
 	kvm_x86_ops->decache_regs(vcpu);
@@ -2676,12 +2676,12 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 	sregs->gdt.base = dt.base;
 
 	kvm_x86_ops->decache_cr4_guest_bits(vcpu);
-	sregs->cr0 = vcpu->cr0;
-	sregs->cr2 = vcpu->cr2;
-	sregs->cr3 = vcpu->cr3;
-	sregs->cr4 = vcpu->cr4;
+	sregs->cr0 = vcpu->arch.cr0;
+	sregs->cr2 = vcpu->arch.cr2;
+	sregs->cr3 = vcpu->arch.cr3;
+	sregs->cr4 = vcpu->arch.cr4;
 	sregs->cr8 = get_cr8(vcpu);
-	sregs->efer = vcpu->shadow_efer;
+	sregs->efer = vcpu->arch.shadow_efer;
 	sregs->apic_base = kvm_get_apic_base(vcpu);
 
 	if (irqchip_in_kernel(vcpu->kvm)) {
@@ -2692,7 +2692,7 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 			set_bit(pending_vec,
 				(unsigned long *)sregs->interrupt_bitmap);
 	} else
-		memcpy(sregs->interrupt_bitmap, vcpu->irq_pending,
+		memcpy(sregs->interrupt_bitmap, vcpu->arch.irq_pending,
 		       sizeof sregs->interrupt_bitmap);
 
 	vcpu_put(vcpu);
@@ -2722,13 +2722,13 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	dt.base = sregs->gdt.base;
 	kvm_x86_ops->set_gdt(vcpu, &dt);
 
-	vcpu->cr2 = sregs->cr2;
-	mmu_reset_needed |= vcpu->cr3 != sregs->cr3;
-	vcpu->cr3 = sregs->cr3;
+	vcpu->arch.cr2 = sregs->cr2;
+	mmu_reset_needed |= vcpu->arch.cr3 != sregs->cr3;
+	vcpu->arch.cr3 = sregs->cr3;
 
 	set_cr8(vcpu, sregs->cr8);
 
-	mmu_reset_needed |= vcpu->shadow_efer != sregs->efer;
+	mmu_reset_needed |= vcpu->arch.shadow_efer != sregs->efer;
 #ifdef CONFIG_X86_64
 	kvm_x86_ops->set_efer(vcpu, sregs->efer);
 #endif
@@ -2736,25 +2736,25 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 
 	kvm_x86_ops->decache_cr4_guest_bits(vcpu);
 
-	mmu_reset_needed |= vcpu->cr0 != sregs->cr0;
-	vcpu->cr0 = sregs->cr0;
+	mmu_reset_needed |= vcpu->arch.cr0 != sregs->cr0;
+	vcpu->arch.cr0 = sregs->cr0;
 	kvm_x86_ops->set_cr0(vcpu, sregs->cr0);
 
-	mmu_reset_needed |= vcpu->cr4 != sregs->cr4;
+	mmu_reset_needed |= vcpu->arch.cr4 != sregs->cr4;
 	kvm_x86_ops->set_cr4(vcpu, sregs->cr4);
 	if (!is_long_mode(vcpu) && is_pae(vcpu))
-		load_pdptrs(vcpu, vcpu->cr3);
+		load_pdptrs(vcpu, vcpu->arch.cr3);
 
 	if (mmu_reset_needed)
 		kvm_mmu_reset_context(vcpu);
 
 	if (!irqchip_in_kernel(vcpu->kvm)) {
-		memcpy(vcpu->irq_pending, sregs->interrupt_bitmap,
-		       sizeof vcpu->irq_pending);
-		vcpu->irq_summary = 0;
-		for (i = 0; i < ARRAY_SIZE(vcpu->irq_pending); ++i)
-			if (vcpu->irq_pending[i])
-				__set_bit(i, &vcpu->irq_summary);
+		memcpy(vcpu->arch.irq_pending, sregs->interrupt_bitmap,
+		       sizeof vcpu->arch.irq_pending);
+		vcpu->arch.irq_summary = 0;
+		for (i = 0; i < ARRAY_SIZE(vcpu->arch.irq_pending); ++i)
+			if (vcpu->arch.irq_pending[i])
+				__set_bit(i, &vcpu->arch.irq_summary);
 	} else {
 		max_bits = (sizeof sregs->interrupt_bitmap) << 3;
 		pending_vec = find_first_bit(
@@ -2829,7 +2829,7 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 
 	vcpu_load(vcpu);
 	mutex_lock(&vcpu->kvm->lock);
-	gpa = vcpu->mmu.gva_to_gpa(vcpu, vaddr);
+	gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, vaddr);
 	tr->physical_address = gpa;
 	tr->valid = gpa != UNMAPPED_GVA;
 	tr->writeable = 1;
@@ -2842,7 +2842,7 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
-	struct fxsave *fxsave = (struct fxsave *)&vcpu->guest_fx_image;
+	struct fxsave *fxsave = (struct fxsave *)&vcpu->arch.guest_fx_image;
 
 	vcpu_load(vcpu);
 
@@ -2862,7 +2862,7 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 
 int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
-	struct fxsave *fxsave = (struct fxsave *)&vcpu->guest_fx_image;
+	struct fxsave *fxsave = (struct fxsave *)&vcpu->arch.guest_fx_image;
 
 	vcpu_load(vcpu);
 
@@ -2886,16 +2886,16 @@ void fx_init(struct kvm_vcpu *vcpu)
 
 	/* Initialize guest FPU by resetting ours and saving into guest's */
 	preempt_disable();
-	fx_save(&vcpu->host_fx_image);
+	fx_save(&vcpu->arch.host_fx_image);
 	fpu_init();
-	fx_save(&vcpu->guest_fx_image);
-	fx_restore(&vcpu->host_fx_image);
+	fx_save(&vcpu->arch.guest_fx_image);
+	fx_restore(&vcpu->arch.host_fx_image);
 	preempt_enable();
 
-	vcpu->cr0 |= X86_CR0_ET;
+	vcpu->arch.cr0 |= X86_CR0_ET;
 	after_mxcsr_mask = offsetof(struct i387_fxsave_struct, st_space);
-	vcpu->guest_fx_image.mxcsr = 0x1f80;
-	memset((void *)&vcpu->guest_fx_image + after_mxcsr_mask,
+	vcpu->arch.guest_fx_image.mxcsr = 0x1f80;
+	memset((void *)&vcpu->arch.guest_fx_image + after_mxcsr_mask,
 	       0, sizeof(struct i387_fxsave_struct) - after_mxcsr_mask);
 }
 EXPORT_SYMBOL_GPL(fx_init);
@@ -2906,8 +2906,8 @@ void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 		return;
 
 	vcpu->guest_fpu_loaded = 1;
-	fx_save(&vcpu->host_fx_image);
-	fx_restore(&vcpu->guest_fx_image);
+	fx_save(&vcpu->arch.host_fx_image);
+	fx_restore(&vcpu->arch.guest_fx_image);
 }
 EXPORT_SYMBOL_GPL(kvm_load_guest_fpu);
 
@@ -2917,8 +2917,8 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 		return;
 
 	vcpu->guest_fpu_loaded = 0;
-	fx_save(&vcpu->guest_fx_image);
-	fx_restore(&vcpu->host_fx_image);
+	fx_save(&vcpu->arch.guest_fx_image);
+	fx_restore(&vcpu->arch.host_fx_image);
 	++vcpu->stat.fpu_reload;
 }
 EXPORT_SYMBOL_GPL(kvm_put_guest_fpu);
@@ -2939,7 +2939,7 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 	int r;
 
 	/* We do fxsave: this must be aligned. */
-	BUG_ON((unsigned long)&vcpu->host_fx_image & 0xF);
+	BUG_ON((unsigned long)&vcpu->arch.host_fx_image & 0xF);
 
 	vcpu_load(vcpu);
 	r = kvm_arch_vcpu_reset(vcpu);
@@ -3003,18 +3003,18 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	BUG_ON(vcpu->kvm == NULL);
 	kvm = vcpu->kvm;
 
-	vcpu->mmu.root_hpa = INVALID_PAGE;
+	vcpu->arch.mmu.root_hpa = INVALID_PAGE;
 	if (!irqchip_in_kernel(kvm) || vcpu->vcpu_id == 0)
-		vcpu->mp_state = VCPU_MP_STATE_RUNNABLE;
+		vcpu->arch.mp_state = VCPU_MP_STATE_RUNNABLE;
 	else
-		vcpu->mp_state = VCPU_MP_STATE_UNINITIALIZED;
+		vcpu->arch.mp_state = VCPU_MP_STATE_UNINITIALIZED;
 
 	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (!page) {
 		r = -ENOMEM;
 		goto fail;
 	}
-	vcpu->pio_data = page_address(page);
+	vcpu->arch.pio_data = page_address(page);
 
 	r = kvm_mmu_create(vcpu);
 	if (r < 0)
@@ -3031,7 +3031,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 fail_mmu_destroy:
 	kvm_mmu_destroy(vcpu);
 fail_free_pio_data:
-	free_page((unsigned long)vcpu->pio_data);
+	free_page((unsigned long)vcpu->arch.pio_data);
 fail:
 	return r;
 }
@@ -3040,7 +3040,7 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
 	kvm_free_lapic(vcpu);
 	kvm_mmu_destroy(vcpu);
-	free_page((unsigned long)vcpu->pio_data);
+	free_page((unsigned long)vcpu->arch.pio_data);
 }
 
 struct  kvm *kvm_arch_create_vm(void)
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index 0fc7020..0e01ac7 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -92,8 +92,7 @@ enum {
 
 #include "x86_emulate.h"
 
-struct kvm_vcpu {
-	KVM_VCPU_COMM;
+struct kvm_vcpu_arch {
 	u64 host_tsc;
 	int interrupt_window_open;
 	unsigned long irq_summary; /* bit vector: 1 per word in irq_pending */
@@ -130,7 +129,6 @@ struct kvm_vcpu {
 	int   last_pt_write_count;
 	u64  *last_pte_updated;
 
-
 	struct i387_fxsave_struct host_fx_image;
 	struct i387_fxsave_struct guest_fx_image;
 
@@ -159,12 +157,17 @@ struct kvm_vcpu {
 
 	int cpuid_nent;
 	struct kvm_cpuid_entry2 cpuid_entries[KVM_MAX_CPUID_ENTRIES];
-
 	/* emulate context */
 
 	struct x86_emulate_ctxt emulate_ctxt;
 };
 
+struct kvm_vcpu {
+	KVM_VCPU_COMM;
+
+	struct kvm_vcpu_arch arch;
+};
+
 struct descriptor_table {
 	u16 limit;
 	unsigned long base;
@@ -339,7 +342,7 @@ static inline void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 
 static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
 {
-	if (likely(vcpu->mmu.root_hpa != INVALID_PAGE))
+	if (likely(vcpu->arch.mmu.root_hpa != INVALID_PAGE))
 		return 0;
 
 	return kvm_mmu_load(vcpu);
@@ -348,7 +351,7 @@ static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
 static inline int is_long_mode(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_X86_64
-	return vcpu->shadow_efer & EFER_LME;
+	return vcpu->arch.shadow_efer & EFER_LME;
 #else
 	return 0;
 #endif
@@ -356,17 +359,17 @@ static inline int is_long_mode(struct kvm_vcpu *vcpu)
 
 static inline int is_pae(struct kvm_vcpu *vcpu)
 {
-	return vcpu->cr4 & X86_CR4_PAE;
+	return vcpu->arch.cr4 & X86_CR4_PAE;
 }
 
 static inline int is_pse(struct kvm_vcpu *vcpu)
 {
-	return vcpu->cr4 & X86_CR4_PSE;
+	return vcpu->arch.cr4 & X86_CR4_PSE;
 }
 
 static inline int is_paging(struct kvm_vcpu *vcpu)
 {
-	return vcpu->cr0 & X86_CR0_PG;
+	return vcpu->arch.cr0 & X86_CR0_PG;
 }
 
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
@@ -489,8 +492,8 @@ static inline void kvm_inject_gp(struct kvm_vcpu *vcpu, u32 error_code)
 
 static inline int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
-	return vcpu->mp_state == VCPU_MP_STATE_RUNNABLE
-	       || vcpu->mp_state == VCPU_MP_STATE_SIPI_RECEIVED;
+	return vcpu->arch.mp_state == VCPU_MP_STATE_RUNNABLE
+	       || vcpu->arch.mp_state == VCPU_MP_STATE_SIPI_RECEIVED;
 }
 
 #endif
diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 0a6ab06..50b133f 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -769,8 +769,8 @@ x86_decode_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	/* Shadow copy of register state. Committed on successful emulation. */
 
 	memset(c, 0, sizeof(struct decode_cache));
-	c->eip = ctxt->vcpu->rip;
-	memcpy(c->regs, ctxt->vcpu->regs, sizeof c->regs);
+	c->eip = ctxt->vcpu->arch.rip;
+	memcpy(c->regs, ctxt->vcpu->arch.regs, sizeof c->regs);
 
 	switch (mode) {
 	case X86EMUL_MODE_REAL:
@@ -1226,7 +1226,7 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	 * modify them.
 	 */
 
-	memcpy(c->regs, ctxt->vcpu->regs, sizeof c->regs);
+	memcpy(c->regs, ctxt->vcpu->arch.regs, sizeof c->regs);
 	saved_eip = c->eip;
 
 	if (((c->d & ModRM) && (c->modrm_mod != 3)) || (c->d & MemAbs))
@@ -1235,7 +1235,7 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	if (c->rep_prefix && (c->d & String)) {
 		/* All REP prefixes have the same first termination condition */
 		if (c->regs[VCPU_REGS_RCX] == 0) {
-			ctxt->vcpu->rip = c->eip;
+			ctxt->vcpu->arch.rip = c->eip;
 			goto done;
 		}
 		/* The second termination condition only applies for REPE
@@ -1249,17 +1249,17 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 				(c->b == 0xae) || (c->b == 0xaf)) {
 			if ((c->rep_prefix == REPE_PREFIX) &&
 				((ctxt->eflags & EFLG_ZF) == 0)) {
-					ctxt->vcpu->rip = c->eip;
+					ctxt->vcpu->arch.rip = c->eip;
 					goto done;
 			}
 			if ((c->rep_prefix == REPNE_PREFIX) &&
 				((ctxt->eflags & EFLG_ZF) == EFLG_ZF)) {
-				ctxt->vcpu->rip = c->eip;
+				ctxt->vcpu->arch.rip = c->eip;
 				goto done;
 			}
 		}
 		c->regs[VCPU_REGS_RCX]--;
-		c->eip = ctxt->vcpu->rip;
+		c->eip = ctxt->vcpu->arch.rip;
 	}
 
 	if (c->src.type == OP_MEM) {
@@ -1628,7 +1628,7 @@ special_insn:
 		c->dst.type = OP_NONE; /* Disable writeback. */
 		break;
 	case 0xf4:              /* hlt */
-		ctxt->vcpu->halt_request = 1;
+		ctxt->vcpu->arch.halt_request = 1;
 		goto done;
 	case 0xf5:	/* cmc */
 		/* complement carry flag from eflags reg */
@@ -1665,8 +1665,8 @@ writeback:
 		goto done;
 
 	/* Commit shadow register state. */
-	memcpy(ctxt->vcpu->regs, c->regs, sizeof c->regs);
-	ctxt->vcpu->rip = c->eip;
+	memcpy(ctxt->vcpu->arch.regs, c->regs, sizeof c->regs);
+	ctxt->vcpu->arch.rip = c->eip;
 
 done:
 	if (rc == X86EMUL_UNHANDLEABLE) {
@@ -1783,7 +1783,7 @@ twobyte_insn:
 		rc = kvm_set_msr(ctxt->vcpu, c->regs[VCPU_REGS_RCX], msr_data);
 		if (rc) {
 			kvm_inject_gp(ctxt->vcpu, 0);
-			c->eip = ctxt->vcpu->rip;
+			c->eip = ctxt->vcpu->arch.rip;
 		}
 		rc = X86EMUL_CONTINUE;
 		c->dst.type = OP_NONE;
@@ -1793,7 +1793,7 @@ twobyte_insn:
 		rc = kvm_get_msr(ctxt->vcpu, c->regs[VCPU_REGS_RCX], &msr_data);
 		if (rc) {
 			kvm_inject_gp(ctxt->vcpu, 0);
-			c->eip = ctxt->vcpu->rip;
+			c->eip = ctxt->vcpu->arch.rip;
 		} else {
 			c->regs[VCPU_REGS_RAX] = (u32)msr_data;
 			c->regs[VCPU_REGS_RDX] = msr_data >> 32;
-- 
1.5.3.7

