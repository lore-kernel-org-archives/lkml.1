Return-Path: <linux-kernel-owner+w=401wt.eu-S1762097AbYDCTfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762097AbYDCTfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757456AbYDCTdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:03 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53022
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757392AbYDCTc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:32:57 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 07/35] KVM: MMU: ignore zapped root pagetables
Date: Thu,  3 Apr 2008 22:32:22 +0300
Message-Id: <1207251170-5013-8-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Mark zapped root pagetables as invalid and ignore such pages during lookup.

This is a problem with the cr3-target feature, where a zapped root table fools
the faulting code into creating a read-only mapping. The result is a lockup
if the instruction can't be emulated.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Anthony Liguori <aliguori@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c         |   12 ++++++++++--
 arch/x86/kvm/x86.c         |   12 ++++++++++++
 include/asm-x86/kvm_host.h |    1 +
 include/linux/kvm_host.h   |    2 ++
 virt/kvm/kvm_main.c        |   23 +++++++++++++++++++++++
 5 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f7541fe..103d008 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -667,7 +667,8 @@ static struct kvm_mmu_page *kvm_mmu_lookup_page(struct kvm *kvm, gfn_t gfn)
 	index = kvm_page_table_hashfn(gfn);
 	bucket = &kvm->arch.mmu_page_hash[index];
 	hlist_for_each_entry(sp, node, bucket, hash_link)
-		if (sp->gfn == gfn && !sp->role.metaphysical) {
+		if (sp->gfn == gfn && !sp->role.metaphysical
+		    && !sp->role.invalid) {
 			pgprintk("%s: found role %x\n",
 				 __FUNCTION__, sp->role.word);
 			return sp;
@@ -792,8 +793,11 @@ static void kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	if (!sp->root_count) {
 		hlist_del(&sp->hash_link);
 		kvm_mmu_free_page(kvm, sp);
-	} else
+	} else {
 		list_move(&sp->link, &kvm->arch.active_mmu_pages);
+		sp->role.invalid = 1;
+		kvm_reload_remote_mmus(kvm);
+	}
 	kvm_mmu_reset_last_pte_updated(kvm);
 }
 
@@ -1073,6 +1077,8 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 
 		sp = page_header(root);
 		--sp->root_count;
+		if (!sp->root_count && sp->role.invalid)
+			kvm_mmu_zap_page(vcpu->kvm, sp);
 		vcpu->arch.mmu.root_hpa = INVALID_PAGE;
 		spin_unlock(&vcpu->kvm->mmu_lock);
 		return;
@@ -1085,6 +1091,8 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 			root &= PT64_BASE_ADDR_MASK;
 			sp = page_header(root);
 			--sp->root_count;
+			if (!sp->root_count && sp->role.invalid)
+				kvm_mmu_zap_page(vcpu->kvm, sp);
 		}
 		vcpu->arch.mmu.pae_root[i] = INVALID_PAGE;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0dd038e..e8e6492 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2658,6 +2658,10 @@ preempted:
 		kvm_x86_ops->guest_debug_pre(vcpu);
 
 again:
+	if (vcpu->requests)
+		if (test_and_clear_bit(KVM_REQ_MMU_RELOAD, &vcpu->requests))
+			kvm_mmu_unload(vcpu);
+
 	r = kvm_mmu_reload(vcpu);
 	if (unlikely(r))
 		goto out;
@@ -2689,6 +2693,14 @@ again:
 		goto out;
 	}
 
+	if (vcpu->requests)
+		if (test_bit(KVM_REQ_MMU_RELOAD, &vcpu->requests)) {
+			local_irq_enable();
+			preempt_enable();
+			r = 1;
+			goto out;
+		}
+
 	if (signal_pending(current)) {
 		local_irq_enable();
 		preempt_enable();
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 4f5a71a..7535839 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -140,6 +140,7 @@ union kvm_mmu_page_role {
 		unsigned pad_for_nice_hex_output : 6;
 		unsigned metaphysical : 1;
 		unsigned access : 3;
+		unsigned invalid : 1;
 	};
 };
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index eb88d32..994278f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -37,6 +37,7 @@
 #define KVM_REQ_TLB_FLUSH          0
 #define KVM_REQ_MIGRATE_TIMER      1
 #define KVM_REQ_REPORT_TPR_ACCESS  2
+#define KVM_REQ_MMU_RELOAD         3
 
 struct kvm_vcpu;
 extern struct kmem_cache *kvm_vcpu_cache;
@@ -190,6 +191,7 @@ void kvm_resched(struct kvm_vcpu *vcpu);
 void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
 void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
 void kvm_flush_remote_tlbs(struct kvm *kvm);
+void kvm_reload_remote_mmus(struct kvm *kvm);
 
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cf6df51..c41eb57 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -119,6 +119,29 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 	smp_call_function_mask(cpus, ack_flush, NULL, 1);
 }
 
+void kvm_reload_remote_mmus(struct kvm *kvm)
+{
+	int i, cpu;
+	cpumask_t cpus;
+	struct kvm_vcpu *vcpu;
+
+	cpus_clear(cpus);
+	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+		vcpu = kvm->vcpus[i];
+		if (!vcpu)
+			continue;
+		if (test_and_set_bit(KVM_REQ_MMU_RELOAD, &vcpu->requests))
+			continue;
+		cpu = vcpu->cpu;
+		if (cpu != -1 && cpu != raw_smp_processor_id())
+			cpu_set(cpu, cpus);
+	}
+	if (cpus_empty(cpus))
+		return;
+	smp_call_function_mask(cpus, ack_flush, NULL, 1);
+}
+
+
 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 {
 	struct page *page;
-- 
1.5.4.5

