Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbZHPJbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbZHPJbh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbZHPJbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:31:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45382 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123AbZHPJaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:15 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 48/48] KVM: Use macro to iterate over vcpus.
Date: Sun, 16 Aug 2009 12:30:08 +0300
Message-Id: <1250415008-17175-49-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c   |   29 ++++++++++++++---------------
 arch/powerpc/kvm/powerpc.c |   16 ++++++++++------
 arch/s390/kvm/kvm-s390.c   |   33 ++++++++++++++++-----------------
 arch/x86/kvm/i8254.c       |    7 ++-----
 arch/x86/kvm/mmu.c         |    6 +++---
 arch/x86/kvm/x86.c         |   25 ++++++++++++-------------
 include/linux/kvm_host.h   |   11 +++++++++++
 virt/kvm/irq_comm.c        |    6 ++----
 virt/kvm/kvm_main.c        |   19 +++++++------------
 9 files changed, 77 insertions(+), 75 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index d1f7bcd..5c766bd 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -337,13 +337,12 @@ static struct kvm_vcpu *lid_to_vcpu(struct kvm *kvm, unsigned long id,
 {
 	union ia64_lid lid;
 	int i;
+	struct kvm_vcpu *vcpu;
 
-	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++) {
-		if (kvm->vcpus[i]) {
-			lid.val = VCPU_LID(kvm->vcpus[i]);
-			if (lid.id == id && lid.eid == eid)
-				return kvm->vcpus[i];
-		}
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		lid.val = VCPU_LID(vcpu);
+		if (lid.id == id && lid.eid == eid)
+			return vcpu;
 	}
 
 	return NULL;
@@ -409,21 +408,21 @@ static int handle_global_purge(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	struct kvm *kvm = vcpu->kvm;
 	struct call_data call_data;
 	int i;
+	struct kvm_vcpu *vcpui;
 
 	call_data.ptc_g_data = p->u.ptc_g_data;
 
-	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++) {
-		if (!kvm->vcpus[i] || kvm->vcpus[i]->arch.mp_state ==
-						KVM_MP_STATE_UNINITIALIZED ||
-					vcpu == kvm->vcpus[i])
+	kvm_for_each_vcpu(i, vcpui, kvm) {
+		if (vcpui->arch.mp_state == KVM_MP_STATE_UNINITIALIZED ||
+				vcpu == vcpui)
 			continue;
 
-		if (waitqueue_active(&kvm->vcpus[i]->wq))
-			wake_up_interruptible(&kvm->vcpus[i]->wq);
+		if (waitqueue_active(&vcpui->wq))
+			wake_up_interruptible(&vcpui->wq);
 
-		if (kvm->vcpus[i]->cpu != -1) {
-			call_data.vcpu = kvm->vcpus[i];
-			smp_call_function_single(kvm->vcpus[i]->cpu,
+		if (vcpui->cpu != -1) {
+			call_data.vcpu = vcpui;
+			smp_call_function_single(vcpui->cpu,
 					vcpu_global_purge, &call_data, 1);
 		} else
 			printk(KERN_WARNING"kvm: Uninit vcpu received ipi!\n");
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 2cf915e..7ad30e0 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -122,13 +122,17 @@ struct kvm *kvm_arch_create_vm(void)
 static void kvmppc_free_vcpus(struct kvm *kvm)
 {
 	unsigned int i;
+	struct kvm_vcpu *vcpu;
 
-	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-		if (kvm->vcpus[i]) {
-			kvm_arch_vcpu_free(kvm->vcpus[i]);
-			kvm->vcpus[i] = NULL;
-		}
-	}
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_arch_vcpu_free(vcpu);
+
+	mutex_lock(&kvm->lock);
+	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++)
+		kvm->vcpus[i] = NULL;
+
+	atomic_set(&kvm->online_vcpus, 0);
+	mutex_unlock(&kvm->lock);
 }
 
 void kvm_arch_sync_events(struct kvm *kvm)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 098bfa6..36ad2b4 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -211,13 +211,17 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 static void kvm_free_vcpus(struct kvm *kvm)
 {
 	unsigned int i;
+	struct kvm_vcpu *vcpu;
 
-	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-		if (kvm->vcpus[i]) {
-			kvm_arch_vcpu_destroy(kvm->vcpus[i]);
-			kvm->vcpus[i] = NULL;
-		}
-	}
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_arch_vcpu_destroy(vcpu);
+
+	mutex_lock(&kvm->lock);
+	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++)
+		kvm->vcpus[i] = NULL;
+
+	atomic_set(&kvm->online_vcpus, 0);
+	mutex_unlock(&kvm->lock);
 }
 
 void kvm_arch_sync_events(struct kvm *kvm)
@@ -314,8 +318,6 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 	BUG_ON(!kvm->arch.sca);
 	if (!kvm->arch.sca->cpu[id].sda)
 		kvm->arch.sca->cpu[id].sda = (__u64) vcpu->arch.sie_block;
-	else
-		BUG_ON(!kvm->vcpus[id]); /* vcpu does already exist */
 	vcpu->arch.sie_block->scaoh = (__u32)(((__u64)kvm->arch.sca) >> 32);
 	vcpu->arch.sie_block->scaol = (__u32)(__u64)kvm->arch.sca;
 
@@ -682,7 +684,8 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 				struct kvm_memory_slot old,
 				int user_alloc)
 {
-	int i;
+	int i, j = 0, r = -EINVAL;
+	struct kvm_vcpu *vcpu;
 
 	/* A few sanity checks. We can have exactly one memory slot which has
 	   to start at guest virtual zero and which has to be located at a
@@ -707,14 +710,10 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 		return -EINVAL;
 
 	/* request update of sie control block for all available vcpus */
-	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-		if (kvm->vcpus[i]) {
-			if (test_and_set_bit(KVM_REQ_MMU_RELOAD,
-						&kvm->vcpus[i]->requests))
-				continue;
-			kvm_s390_inject_sigp_stop(kvm->vcpus[i],
-						  ACTION_RELOADVCPU_ON_STOP);
-		}
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (test_and_set_bit(KVM_REQ_MMU_RELOAD, &vcpu->requests))
+			continue;
+		kvm_s390_inject_sigp_stop(vcpu, ACTION_RELOADVCPU_ON_STOP);
 	}
 
 	return 0;
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 06d8f84..15fc95b 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -669,11 +669,8 @@ static void __inject_pit_timer_intr(struct kvm *kvm)
 	 * VCPU0, and only if its LVT0 is in EXTINT mode.
 	 */
 	if (kvm->arch.vapics_in_nmi_mode > 0)
-		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-			vcpu = kvm->vcpus[i];
-			if (vcpu)
-				kvm_apic_nmi_wd_deliver(vcpu);
-		}
+		kvm_for_each_vcpu(i, vcpu, kvm)
+			kvm_apic_nmi_wd_deliver(vcpu);
 }
 
 void kvm_inject_pit_timer_irqs(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d443a42..5f97dbd 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1347,10 +1347,10 @@ static void kvm_mmu_put_page(struct kvm_mmu_page *sp, u64 *parent_pte)
 static void kvm_mmu_reset_last_pte_updated(struct kvm *kvm)
 {
 	int i;
+	struct kvm_vcpu *vcpu;
 
-	for (i = 0; i < KVM_MAX_VCPUS; ++i)
-		if (kvm->vcpus[i])
-			kvm->vcpus[i]->arch.last_pte_updated = NULL;
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		vcpu->arch.last_pte_updated = NULL;
 }
 
 static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d8adc1d..89862a8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2946,10 +2946,7 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 
 	spin_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list) {
-		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-			vcpu = kvm->vcpus[i];
-			if (!vcpu)
-				continue;
+		kvm_for_each_vcpu(i, vcpu, kvm) {
 			if (vcpu->cpu != freq->cpu)
 				continue;
 			if (!kvm_request_guest_time_update(vcpu))
@@ -4678,20 +4675,22 @@ static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
 static void kvm_free_vcpus(struct kvm *kvm)
 {
 	unsigned int i;
+	struct kvm_vcpu *vcpu;
 
 	/*
 	 * Unpin any mmu pages first.
 	 */
-	for (i = 0; i < KVM_MAX_VCPUS; ++i)
-		if (kvm->vcpus[i])
-			kvm_unload_vcpu_mmu(kvm->vcpus[i]);
-	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-		if (kvm->vcpus[i]) {
-			kvm_arch_vcpu_free(kvm->vcpus[i]);
-			kvm->vcpus[i] = NULL;
-		}
-	}
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_unload_vcpu_mmu(vcpu);
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_arch_vcpu_free(vcpu);
+
+	mutex_lock(&kvm->lock);
+	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++)
+		kvm->vcpus[i] = NULL;
 
+	atomic_set(&kvm->online_vcpus, 0);
+	mutex_unlock(&kvm->lock);
 }
 
 void kvm_arch_sync_events(struct kvm *kvm)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d3fdf1a..c6e4d02 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -179,6 +179,17 @@ struct kvm {
 #define kvm_printf(kvm, fmt ...) printk(KERN_DEBUG fmt)
 #define vcpu_printf(vcpu, fmt...) kvm_printf(vcpu->kvm, fmt)
 
+static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
+{
+	smp_rmb();
+	return kvm->vcpus[i];
+}
+
+#define kvm_for_each_vcpu(idx, vcpup, kvm) \
+	for (idx = 0, vcpup = kvm_get_vcpu(kvm, idx); \
+	     idx < atomic_read(&kvm->online_vcpus) && vcpup; \
+	     vcpup = kvm_get_vcpu(kvm, ++idx))
+
 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id);
 void kvm_vcpu_uninit(struct kvm_vcpu *vcpu);
 
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 08a9a49..bb8a1b5 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -68,10 +68,8 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 			kvm_is_dm_lowest_prio(irq))
 		printk(KERN_INFO "kvm: apic: phys broadcast and lowest prio\n");
 
-	for (i = 0; i < KVM_MAX_VCPUS; i++) {
-		vcpu = kvm->vcpus[i];
-
-		if (!vcpu || !kvm_apic_present(vcpu))
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (!kvm_apic_present(vcpu))
 			continue;
 
 		if (!kvm_apic_match_dest(vcpu, src, irq->shorthand,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 25e1f9c..777fe53 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -738,10 +738,7 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
 
 	me = get_cpu();
 	spin_lock(&kvm->requests_lock);
-	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-		vcpu = kvm->vcpus[i];
-		if (!vcpu)
-			continue;
+	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (test_and_set_bit(req, &vcpu->requests))
 			continue;
 		cpu = vcpu->cpu;
@@ -1718,7 +1715,7 @@ static int create_vcpu_fd(struct kvm_vcpu *vcpu)
 static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 {
 	int r;
-	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu *vcpu, *v;
 
 	vcpu = kvm_arch_vcpu_create(kvm, id);
 	if (IS_ERR(vcpu))
@@ -1736,8 +1733,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 		goto vcpu_destroy;
 	}
 
-	for (r = 0; r < atomic_read(&kvm->online_vcpus); r++)
-		if (kvm->vcpus[r]->vcpu_id == id) {
+	kvm_for_each_vcpu(r, v, kvm)
+		if (v->vcpu_id == id) {
 			r = -EEXIST;
 			goto vcpu_destroy;
 		}
@@ -2526,11 +2523,9 @@ static int vcpu_stat_get(void *_offset, u64 *val)
 	*val = 0;
 	spin_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list)
-		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-			vcpu = kvm->vcpus[i];
-			if (vcpu)
-				*val += *(u32 *)((void *)vcpu + offset);
-		}
+		kvm_for_each_vcpu(i, vcpu, kvm)
+			*val += *(u32 *)((void *)vcpu + offset);
+
 	spin_unlock(&kvm_lock);
 	return 0;
 }
-- 
1.6.3.3

