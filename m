Return-Path: <linux-kernel-owner+w=401wt.eu-S1762139AbXFQKAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762139AbXFQKAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 06:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759693AbXFQJpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:41 -0400
Received: from il.qumranet.com ([82.166.9.18]:55187 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759462AbXFQJov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:51 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 54/58] KVM: Flush remote tlbs when reducing shadow pte permissions
Date: Sun, 17 Jun 2007 12:44:35 +0300
Message-Id: <118207348119-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When a vcpu causes a shadow tlb entry to have reduced permissions, it
must also clear the tlb on remote vcpus.  We do that by:

- setting a bit on the vcpu that requests a tlb flush before the next entry
- if the vcpu is currently executing, we send an ipi to make sure it
  exits before we continue

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    8 ++++++++
 drivers/kvm/kvm_main.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/kvm/mmu.c      |    8 +++++---
 drivers/kvm/svm.c      |   17 ++++++++++++-----
 drivers/kvm/vmx.c      |   22 +++++++++++++++-------
 5 files changed, 84 insertions(+), 15 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 528a56b..b08272b 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -84,6 +84,11 @@
 #define KVM_PIO_PAGE_OFFSET 1
 
 /*
+ * vcpu->requests bit members
+ */
+#define KVM_TLB_FLUSH 0
+
+/*
  * Address types:
  *
  *  gva - guest virtual address
@@ -272,6 +277,8 @@ struct kvm_vcpu {
 	u64 host_tsc;
 	struct kvm_run *run;
 	int interrupt_window_open;
+	int guest_mode;
+	unsigned long requests;
 	unsigned long irq_summary; /* bit vector: 1 per word in irq_pending */
 #define NR_IRQ_WORDS KVM_IRQ_BITMAP_SIZE(unsigned long)
 	unsigned long irq_pending[NR_IRQ_WORDS];
@@ -530,6 +537,7 @@ void save_msrs(struct vmx_msr_entry *e, int n);
 void kvm_resched(struct kvm_vcpu *vcpu);
 void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
 void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
+void kvm_flush_remote_tlbs(struct kvm *kvm);
 
 int kvm_read_guest(struct kvm_vcpu *vcpu,
 	       gva_t addr,
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 4e1a017..633c2ed 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -41,6 +41,8 @@
 #include <linux/fs.h>
 #include <linux/mount.h>
 #include <linux/sched.h>
+#include <linux/cpumask.h>
+#include <linux/smp.h>
 
 #include "x86_emulate.h"
 #include "segment_descriptor.h"
@@ -309,6 +311,48 @@ static void vcpu_put(struct kvm_vcpu *vcpu)
 	mutex_unlock(&vcpu->mutex);
 }
 
+static void ack_flush(void *_completed)
+{
+	atomic_t *completed = _completed;
+
+	atomic_inc(completed);
+}
+
+void kvm_flush_remote_tlbs(struct kvm *kvm)
+{
+	int i, cpu, needed;
+	cpumask_t cpus;
+	struct kvm_vcpu *vcpu;
+	atomic_t completed;
+
+	atomic_set(&completed, 0);
+	cpus_clear(cpus);
+	needed = 0;
+	for (i = 0; i < kvm->nvcpus; ++i) {
+		vcpu = &kvm->vcpus[i];
+		if (test_and_set_bit(KVM_TLB_FLUSH, &vcpu->requests))
+			continue;
+		cpu = vcpu->cpu;
+		if (cpu != -1 && cpu != raw_smp_processor_id())
+			if (!cpu_isset(cpu, cpus)) {
+				cpu_set(cpu, cpus);
+				++needed;
+			}
+	}
+
+	/*
+	 * We really want smp_call_function_mask() here.  But that's not
+	 * available, so ipi all cpus in parallel and wait for them
+	 * to complete.
+	 */
+	for (cpu = first_cpu(cpus); cpu != NR_CPUS; cpu = next_cpu(cpu, cpus))
+		smp_call_function_single(cpu, ack_flush, &completed, 1, 0);
+	while (atomic_read(&completed) != needed) {
+		cpu_relax();
+		barrier();
+	}
+}
+
 static struct kvm *kvm_create_vm(void)
 {
 	struct kvm *kvm = kzalloc(sizeof(struct kvm), GFP_KERNEL);
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index d4de988..ad50cfd 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -441,7 +441,7 @@ static void rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 		BUG_ON(!(*spte & PT_WRITABLE_MASK));
 		rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
 		rmap_remove(vcpu, spte);
-		kvm_arch_ops->tlb_flush(vcpu);
+		kvm_flush_remote_tlbs(vcpu->kvm);
 		set_shadow_pte(spte, *spte & ~PT_WRITABLE_MASK);
 	}
 }
@@ -656,7 +656,7 @@ static void kvm_mmu_page_unlink_children(struct kvm_vcpu *vcpu,
 				rmap_remove(vcpu, &pt[i]);
 			pt[i] = 0;
 		}
-		kvm_arch_ops->tlb_flush(vcpu);
+		kvm_flush_remote_tlbs(vcpu->kvm);
 		return;
 	}
 
@@ -669,6 +669,7 @@ static void kvm_mmu_page_unlink_children(struct kvm_vcpu *vcpu,
 		ent &= PT64_BASE_ADDR_MASK;
 		mmu_page_remove_parent_pte(vcpu, page_header(ent), &pt[i]);
 	}
+	kvm_flush_remote_tlbs(vcpu->kvm);
 }
 
 static void kvm_mmu_put_page(struct kvm_vcpu *vcpu,
@@ -1093,6 +1094,7 @@ static void mmu_pte_write_zap_pte(struct kvm_vcpu *vcpu,
 		}
 	}
 	*spte = 0;
+	kvm_flush_remote_tlbs(vcpu->kvm);
 }
 
 static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
@@ -1308,7 +1310,7 @@ void kvm_mmu_zap_all(struct kvm_vcpu *vcpu)
 	}
 
 	mmu_free_memory_caches(vcpu);
-	kvm_arch_ops->tlb_flush(vcpu);
+	kvm_flush_remote_tlbs(vcpu->kvm);
 	init_kvm_mmu(vcpu);
 }
 
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 70f386e..eb175c5 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1470,6 +1470,11 @@ static void load_db_regs(unsigned long *db_regs)
 	asm volatile ("mov %0, %%dr3" : : "r"(db_regs[3]));
 }
 
+static void svm_flush_tlb(struct kvm_vcpu *vcpu)
+{
+	force_new_asid(vcpu);
+}
+
 static int svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	u16 fs_selector;
@@ -1487,6 +1492,11 @@ again:
 
 	clgi();
 
+	vcpu->guest_mode = 1;
+	if (vcpu->requests)
+		if (test_and_clear_bit(KVM_TLB_FLUSH, &vcpu->requests))
+		    svm_flush_tlb(vcpu);
+
 	pre_svm_run(vcpu);
 
 	save_host_msrs(vcpu);
@@ -1618,6 +1628,8 @@ again:
 #endif
 		: "cc", "memory" );
 
+	vcpu->guest_mode = 0;
+
 	if (vcpu->fpu_active) {
 		fx_save(vcpu->guest_fx_image);
 		fx_restore(vcpu->host_fx_image);
@@ -1682,11 +1694,6 @@ again:
 	return r;
 }
 
-static void svm_flush_tlb(struct kvm_vcpu *vcpu)
-{
-	force_new_asid(vcpu);
-}
-
 static void svm_set_cr3(struct kvm_vcpu *vcpu, unsigned long root)
 {
 	vcpu->svm->vmcb->save.cr3 = root;
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index a1f51b9..b969db1 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1972,6 +1972,11 @@ static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu,
 		(vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF));
 }
 
+static void vmx_flush_tlb(struct kvm_vcpu *vcpu)
+{
+	vmcs_writel(GUEST_CR3, vmcs_readl(GUEST_CR3));
+}
+
 static int vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	u8 fail;
@@ -1997,9 +2002,15 @@ again:
 	 */
 	vmcs_writel(HOST_CR0, read_cr0());
 
+	local_irq_disable();
+
+	vcpu->guest_mode = 1;
+	if (vcpu->requests)
+		if (test_and_clear_bit(KVM_TLB_FLUSH, &vcpu->requests))
+		    vmx_flush_tlb(vcpu);
+
 	asm (
 		/* Store host registers */
-		"pushf \n\t"
 #ifdef CONFIG_X86_64
 		"push %%rax; push %%rbx; push %%rdx;"
 		"push %%rsi; push %%rdi; push %%rbp;"
@@ -2091,7 +2102,6 @@ again:
 		"pop %%ecx; popa \n\t"
 #endif
 		"setbe %0 \n\t"
-		"popf \n\t"
 	      : "=q" (fail)
 	      : "r"(vcpu->launched), "d"((unsigned long)HOST_RSP),
 		"c"(vcpu),
@@ -2115,6 +2125,9 @@ again:
 		[cr2]"i"(offsetof(struct kvm_vcpu, cr2))
 	      : "cc", "memory" );
 
+	vcpu->guest_mode = 0;
+	local_irq_enable();
+
 	++vcpu->stat.exits;
 
 	vcpu->interrupt_window_open = (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & 3) == 0;
@@ -2167,11 +2180,6 @@ out:
 	return r;
 }
 
-static void vmx_flush_tlb(struct kvm_vcpu *vcpu)
-{
-	vmcs_writel(GUEST_CR3, vmcs_readl(GUEST_CR3));
-}
-
 static void vmx_inject_page_fault(struct kvm_vcpu *vcpu,
 				  unsigned long addr,
 				  u32 err_code)
-- 
1.5.0.6

