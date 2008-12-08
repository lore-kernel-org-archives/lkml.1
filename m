Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbYLHLry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbYLHLry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbYLHLiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:38:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48265 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbYLHLhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:05 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xiantao Zhang <xiantao.zhang@intel.com>
Subject: [PATCH 34/45] KVM: ia64: Re-organize data sturure of guests' data area
Date: Mon,  8 Dec 2008 13:36:45 +0200
Message-Id: <1228736216-15787-35-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiantao Zhang <xiantao.zhang@intel.com>

1. Increase the size of data area to 64M
2. Support more vcpus and memory, 128 vcpus and 256G memory are supported
   for guests.
3. Add the boundary check for memory and vcpu allocation.

With this patch, kvm guest's data area looks as follow:
  *
  *            +----------------------+  ------- KVM_VM_DATA_SIZE
  *            |     vcpu[n]'s data   |   |     ___________________KVM_STK_OFFSET
  *            |                      |   |    /                   |
  *            |        ..........    |   |   /vcpu's struct&stack |
  *            |        ..........    |   |  /---------------------|---- 0
  *            |     vcpu[5]'s data   |   | /       vpd            |
  *            |     vcpu[4]'s data   |   |/-----------------------|
  *            |     vcpu[3]'s data   |   /         vtlb           |
  *            |     vcpu[2]'s data   |  /|------------------------|
  *            |     vcpu[1]'s data   |/  |         vhpt           |
  *            |     vcpu[0]'s data   |____________________________|
  *            +----------------------+   |
  *            |    memory dirty log  |   |
  *            +----------------------+   |
  *            |    vm's data struct  |   |
  *            +----------------------+   |
  *            |                      |   |
  *            |                      |   |
  *            |                      |   |
  *            |                      |   |
  *            |                      |   |
  *            |                      |   |
  *            |                      |   |
  *            |   vm's p2m table  |      |
  *            |                      |   |
  *            |                      |   |
  *            |                      |   |  |
  * vm's data->|                      |   |  |
  *            +----------------------+ ------- 0
  * To support large memory, needs to increase the size of p2m.
  * To support more vcpus, needs to ensure it has enough space to
  * hold vcpus' data.
  */

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/include/asm/kvm_host.h |  192 ++++++++++++++++++++++++--------------
 arch/ia64/kvm/kvm-ia64.c         |   60 ++++++------
 arch/ia64/kvm/kvm_minstate.h     |    4 +-
 arch/ia64/kvm/misc.h             |    3 +-
 arch/ia64/kvm/vcpu.c             |    5 +-
 arch/ia64/kvm/vtlb.c             |    4 +-
 6 files changed, 161 insertions(+), 107 deletions(-)

diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
index c60d324..678e264 100644
--- a/arch/ia64/include/asm/kvm_host.h
+++ b/arch/ia64/include/asm/kvm_host.h
@@ -23,17 +23,6 @@
 #ifndef __ASM_KVM_HOST_H
 #define __ASM_KVM_HOST_H
 
-
-#include <linux/types.h>
-#include <linux/mm.h>
-#include <linux/kvm.h>
-#include <linux/kvm_para.h>
-#include <linux/kvm_types.h>
-
-#include <asm/pal.h>
-#include <asm/sal.h>
-
-#define KVM_MAX_VCPUS 4
 #define KVM_MEMORY_SLOTS 32
 /* memory slots that does not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 4
@@ -52,68 +41,127 @@
 #define EXIT_REASON_PTC_G		8
 
 /*Define vmm address space and vm data space.*/
-#define KVM_VMM_SIZE (16UL<<20)
+#define KVM_VMM_SIZE (__IA64_UL_CONST(16)<<20)
 #define KVM_VMM_SHIFT 24
-#define KVM_VMM_BASE 0xD000000000000000UL
-#define VMM_SIZE (8UL<<20)
+#define KVM_VMM_BASE 0xD000000000000000
+#define VMM_SIZE (__IA64_UL_CONST(8)<<20)
 
 /*
  * Define vm_buffer, used by PAL Services, base address.
- * Note: vmbuffer is in the VMM-BLOCK, the size must be < 8M
+ * Note: vm_buffer is in the VMM-BLOCK, the size must be < 8M
  */
 #define KVM_VM_BUFFER_BASE (KVM_VMM_BASE + VMM_SIZE)
-#define KVM_VM_BUFFER_SIZE (8UL<<20)
-
-/*Define Virtual machine data layout.*/
-#define KVM_VM_DATA_SHIFT  24
-#define KVM_VM_DATA_SIZE (1UL << KVM_VM_DATA_SHIFT)
-#define KVM_VM_DATA_BASE (KVM_VMM_BASE + KVM_VMM_SIZE)
-
-
-#define KVM_P2M_BASE    KVM_VM_DATA_BASE
-#define KVM_P2M_OFS     0
-#define KVM_P2M_SIZE    (8UL << 20)
-
-#define KVM_VHPT_BASE   (KVM_P2M_BASE + KVM_P2M_SIZE)
-#define KVM_VHPT_OFS    KVM_P2M_SIZE
-#define KVM_VHPT_BLOCK_SIZE   (2UL << 20)
-#define VHPT_SHIFT      18
-#define VHPT_SIZE       (1UL << VHPT_SHIFT)
-#define VHPT_NUM_ENTRIES (1<<(VHPT_SHIFT-5))
-
-#define KVM_VTLB_BASE   (KVM_VHPT_BASE+KVM_VHPT_BLOCK_SIZE)
-#define KVM_VTLB_OFS    (KVM_VHPT_OFS+KVM_VHPT_BLOCK_SIZE)
-#define KVM_VTLB_BLOCK_SIZE   (1UL<<20)
-#define VTLB_SHIFT      17
-#define VTLB_SIZE       (1UL<<VTLB_SHIFT)
-#define VTLB_NUM_ENTRIES (1<<(VTLB_SHIFT-5))
-
-#define KVM_VPD_BASE   (KVM_VTLB_BASE+KVM_VTLB_BLOCK_SIZE)
-#define KVM_VPD_OFS    (KVM_VTLB_OFS+KVM_VTLB_BLOCK_SIZE)
-#define KVM_VPD_BLOCK_SIZE   (2UL<<20)
-#define VPD_SHIFT       16
-#define VPD_SIZE        (1UL<<VPD_SHIFT)
-
-#define KVM_VCPU_BASE   (KVM_VPD_BASE+KVM_VPD_BLOCK_SIZE)
-#define KVM_VCPU_OFS    (KVM_VPD_OFS+KVM_VPD_BLOCK_SIZE)
-#define KVM_VCPU_BLOCK_SIZE   (2UL<<20)
-#define VCPU_SHIFT 18
-#define VCPU_SIZE (1UL<<VCPU_SHIFT)
-#define MAX_VCPU_NUM KVM_VCPU_BLOCK_SIZE/VCPU_SIZE
-
-#define KVM_VM_BASE     (KVM_VCPU_BASE+KVM_VCPU_BLOCK_SIZE)
-#define KVM_VM_OFS      (KVM_VCPU_OFS+KVM_VCPU_BLOCK_SIZE)
-#define KVM_VM_BLOCK_SIZE     (1UL<<19)
-
-#define KVM_MEM_DIRTY_LOG_BASE (KVM_VM_BASE+KVM_VM_BLOCK_SIZE)
-#define KVM_MEM_DIRTY_LOG_OFS  (KVM_VM_OFS+KVM_VM_BLOCK_SIZE)
-#define KVM_MEM_DIRTY_LOG_SIZE (1UL<<19)
-
-/* Get vpd, vhpt, tlb, vcpu, base*/
-#define VPD_ADDR(n) (KVM_VPD_BASE+n*VPD_SIZE)
-#define VHPT_ADDR(n) (KVM_VHPT_BASE+n*VHPT_SIZE)
-#define VTLB_ADDR(n) (KVM_VTLB_BASE+n*VTLB_SIZE)
-#define VCPU_ADDR(n) (KVM_VCPU_BASE+n*VCPU_SIZE)
+#define KVM_VM_BUFFER_SIZE (__IA64_UL_CONST(8)<<20)
+
+/*
+ * kvm guest's data area looks as follow:
+ *
+ *            +----------------------+	-------	KVM_VM_DATA_SIZE
+ *	      |	    vcpu[n]'s data   |	 |     ___________________KVM_STK_OFFSET
+ *     	      |			     |	 |    /			  |
+ *     	      |	       ..........    |	 |   /vcpu's struct&stack |
+ *     	      |	       ..........    |	 |  /---------------------|---- 0
+ *	      |	    vcpu[5]'s data   |	 | /	   vpd		  |
+ *	      |	    vcpu[4]'s data   |	 |/-----------------------|
+ *	      |	    vcpu[3]'s data   |	 /	   vtlb		  |
+ *	      |	    vcpu[2]'s data   |	/|------------------------|
+ *	      |	    vcpu[1]'s data   |/  |	   vhpt		  |
+ *	      |	    vcpu[0]'s data   |____________________________|
+ *            +----------------------+	 |
+ *	      |	   memory dirty log  |	 |
+ *            +----------------------+	 |
+ *	      |	   vm's data struct  |	 |
+ *            +----------------------+	 |
+ *	      |			     |	 |
+ *	      |			     |	 |
+ *	      |			     |	 |
+ *	      |			     |	 |
+ *	      |			     |	 |
+ *	      |			     |	 |
+ *	      |			     |	 |
+ *	      |	  vm's p2m table  |	 |
+ *	      |			     |	 |
+ *            |			     |	 |
+ *	      |			     |	 |  |
+ * vm's data->|			     |   |  |
+ *	      +----------------------+ ------- 0
+ * To support large memory, needs to increase the size of p2m.
+ * To support more vcpus, needs to ensure it has enough space to
+ * hold vcpus' data.
+ */
+
+#define KVM_VM_DATA_SHIFT	26
+#define KVM_VM_DATA_SIZE	(__IA64_UL_CONST(1) << KVM_VM_DATA_SHIFT)
+#define KVM_VM_DATA_BASE	(KVM_VMM_BASE + KVM_VM_DATA_SIZE)
+
+#define KVM_P2M_BASE		KVM_VM_DATA_BASE
+#define KVM_P2M_SIZE		(__IA64_UL_CONST(24) << 20)
+
+#define VHPT_SHIFT		16
+#define VHPT_SIZE		(__IA64_UL_CONST(1) << VHPT_SHIFT)
+#define VHPT_NUM_ENTRIES	(__IA64_UL_CONST(1) << (VHPT_SHIFT-5))
+
+#define VTLB_SHIFT		16
+#define VTLB_SIZE		(__IA64_UL_CONST(1) << VTLB_SHIFT)
+#define VTLB_NUM_ENTRIES	(1UL << (VHPT_SHIFT-5))
+
+#define VPD_SHIFT		16
+#define VPD_SIZE		(__IA64_UL_CONST(1) << VPD_SHIFT)
+
+#define VCPU_STRUCT_SHIFT	16
+#define VCPU_STRUCT_SIZE	(__IA64_UL_CONST(1) << VCPU_STRUCT_SHIFT)
+
+#define KVM_STK_OFFSET		VCPU_STRUCT_SIZE
+
+#define KVM_VM_STRUCT_SHIFT	19
+#define KVM_VM_STRUCT_SIZE	(__IA64_UL_CONST(1) << KVM_VM_STRUCT_SHIFT)
+
+#define KVM_MEM_DIRY_LOG_SHIFT	19
+#define KVM_MEM_DIRTY_LOG_SIZE (__IA64_UL_CONST(1) << KVM_MEM_DIRY_LOG_SHIFT)
+
+#ifndef __ASSEMBLY__
+
+/*Define the max vcpus and memory for Guests.*/
+#define KVM_MAX_VCPUS	(KVM_VM_DATA_SIZE - KVM_P2M_SIZE - KVM_VM_STRUCT_SIZE -\
+			KVM_MEM_DIRTY_LOG_SIZE) / sizeof(struct kvm_vcpu_data)
+#define KVM_MAX_MEM_SIZE (KVM_P2M_SIZE >> 3 << PAGE_SHIFT)
+
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/kvm.h>
+#include <linux/kvm_para.h>
+#include <linux/kvm_types.h>
+
+#include <asm/pal.h>
+#include <asm/sal.h>
+#include <asm/page.h>
+
+struct kvm_vcpu_data {
+	char vcpu_vhpt[VHPT_SIZE];
+	char vcpu_vtlb[VTLB_SIZE];
+	char vcpu_vpd[VPD_SIZE];
+	char vcpu_struct[VCPU_STRUCT_SIZE];
+};
+
+struct kvm_vm_data {
+	char kvm_p2m[KVM_P2M_SIZE];
+	char kvm_vm_struct[KVM_VM_STRUCT_SIZE];
+	char kvm_mem_dirty_log[KVM_MEM_DIRTY_LOG_SIZE];
+	struct kvm_vcpu_data vcpu_data[KVM_MAX_VCPUS];
+};
+
+#define VCPU_BASE(n)	KVM_VM_DATA_BASE + \
+				offsetof(struct kvm_vm_data, vcpu_data[n])
+#define VM_BASE		KVM_VM_DATA_BASE + \
+				offsetof(struct kvm_vm_data, kvm_vm_struct)
+#define KVM_MEM_DIRTY_LOG_BASE	KVM_VM_DATA_BASE + \
+				offsetof(struct kvm_vm_data, kvm_mem_dirty_log)
+
+#define VHPT_BASE(n) (VCPU_BASE(n) + offsetof(struct kvm_vcpu_data, vcpu_vhpt))
+#define VTLB_BASE(n) (VCPU_BASE(n) + offsetof(struct kvm_vcpu_data, vcpu_vtlb))
+#define VPD_BASE(n)  (VCPU_BASE(n) + offsetof(struct kvm_vcpu_data, vcpu_vpd))
+#define VCPU_STRUCT_BASE(n)	(VCPU_BASE(n) + \
+				offsetof(struct kvm_vcpu_data, vcpu_struct))
 
 /*IO section definitions*/
 #define IOREQ_READ      1
@@ -403,14 +451,13 @@ struct kvm_sal_data {
 };
 
 struct kvm_arch {
+	spinlock_t dirty_log_lock;
+
 	unsigned long	vm_base;
 	unsigned long	metaphysical_rr0;
 	unsigned long	metaphysical_rr4;
 	unsigned long	vmm_init_rr;
-	unsigned long	vhpt_base;
-	unsigned long	vtlb_base;
-	unsigned long 	vpd_base;
-	spinlock_t dirty_log_lock;
+
 	struct kvm_ioapic *vioapic;
 	struct kvm_vm_stat stat;
 	struct kvm_sal_data rdv_sal_data;
@@ -512,7 +559,7 @@ struct kvm_pt_regs {
 
 static inline struct kvm_pt_regs *vcpu_regs(struct kvm_vcpu *v)
 {
-	return (struct kvm_pt_regs *) ((unsigned long) v + IA64_STK_OFFSET) - 1;
+	return (struct kvm_pt_regs *) ((unsigned long) v + KVM_STK_OFFSET) - 1;
 }
 
 typedef int kvm_vmm_entry(void);
@@ -531,5 +578,6 @@ int kvm_pal_emul(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run);
 void kvm_sal_emul(struct kvm_vcpu *vcpu);
 
 static inline void kvm_inject_nmi(struct kvm_vcpu *vcpu) {}
+#endif /* __ASSEMBLY__*/
 
 #endif
diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index af1464f..43e45f6 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -698,27 +698,24 @@ out:
 	return r;
 }
 
-/*
- * Allocate 16M memory for every vm to hold its specific data.
- * Its memory map is defined in kvm_host.h.
- */
 static struct kvm *kvm_alloc_kvm(void)
 {
 
 	struct kvm *kvm;
 	uint64_t  vm_base;
 
+	BUG_ON(sizeof(struct kvm) > KVM_VM_STRUCT_SIZE);
+
 	vm_base = __get_free_pages(GFP_KERNEL, get_order(KVM_VM_DATA_SIZE));
 
 	if (!vm_base)
 		return ERR_PTR(-ENOMEM);
-	printk(KERN_DEBUG"kvm: VM data's base Address:0x%lx\n", vm_base);
 
-	/* Zero all pages before use! */
 	memset((void *)vm_base, 0, KVM_VM_DATA_SIZE);
-
-	kvm = (struct kvm *)(vm_base + KVM_VM_OFS);
+	kvm = (struct kvm *)(vm_base +
+			offsetof(struct kvm_vm_data, kvm_vm_struct));
 	kvm->arch.vm_base = vm_base;
+	printk(KERN_DEBUG"kvm: vm's data area:0x%lx\n", vm_base);
 
 	return kvm;
 }
@@ -760,21 +757,12 @@ static void kvm_build_io_pmt(struct kvm *kvm)
 
 static void kvm_init_vm(struct kvm *kvm)
 {
-	long vm_base;
-
 	BUG_ON(!kvm);
 
 	kvm->arch.metaphysical_rr0 = GUEST_PHYSICAL_RR0;
 	kvm->arch.metaphysical_rr4 = GUEST_PHYSICAL_RR4;
 	kvm->arch.vmm_init_rr = VMM_INIT_RR;
 
-	vm_base = kvm->arch.vm_base;
-	if (vm_base) {
-		kvm->arch.vhpt_base = vm_base + KVM_VHPT_OFS;
-		kvm->arch.vtlb_base = vm_base + KVM_VTLB_OFS;
-		kvm->arch.vpd_base  = vm_base + KVM_VPD_OFS;
-	}
-
 	/*
 	 *Fill P2M entries for MMIO/IO ranges
 	 */
@@ -864,7 +852,7 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 		goto out;
 	r = copy_from_user(vcpu + 1, regs->saved_stack +
 			sizeof(struct kvm_vcpu),
-			IA64_STK_OFFSET - sizeof(struct kvm_vcpu));
+			KVM_STK_OFFSET - sizeof(struct kvm_vcpu));
 	if (r)
 		goto out;
 	vcpu->arch.exit_data =
@@ -1166,10 +1154,11 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 		/*Set entry address for first run.*/
 		regs->cr_iip = PALE_RESET_ENTRY;
 
-		/*Initilize itc offset for vcpus*/
+		/*Initialize itc offset for vcpus*/
 		itc_offset = 0UL - ia64_getreg(_IA64_REG_AR_ITC);
-		for (i = 0; i < MAX_VCPU_NUM; i++) {
-			v = (struct kvm_vcpu *)((char *)vcpu + VCPU_SIZE * i);
+		for (i = 0; i < KVM_MAX_VCPUS; i++) {
+			v = (struct kvm_vcpu *)((char *)vcpu +
+					sizeof(struct kvm_vcpu_data) * i);
 			v->arch.itc_offset = itc_offset;
 			v->arch.last_itc = 0;
 		}
@@ -1183,7 +1172,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	vcpu->arch.apic->vcpu = vcpu;
 
 	p_ctx->gr[1] = 0;
-	p_ctx->gr[12] = (unsigned long)((char *)vmm_vcpu + IA64_STK_OFFSET);
+	p_ctx->gr[12] = (unsigned long)((char *)vmm_vcpu + KVM_STK_OFFSET);
 	p_ctx->gr[13] = (unsigned long)vmm_vcpu;
 	p_ctx->psr = 0x1008522000UL;
 	p_ctx->ar[40] = FPSR_DEFAULT; /*fpsr*/
@@ -1218,12 +1207,12 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	vcpu->arch.hlt_timer.function = hlt_timer_fn;
 
 	vcpu->arch.last_run_cpu = -1;
-	vcpu->arch.vpd = (struct vpd *)VPD_ADDR(vcpu->vcpu_id);
+	vcpu->arch.vpd = (struct vpd *)VPD_BASE(vcpu->vcpu_id);
 	vcpu->arch.vsa_base = kvm_vsa_base;
 	vcpu->arch.__gp = kvm_vmm_gp;
 	vcpu->arch.dirty_log_lock_pa = __pa(&kvm->arch.dirty_log_lock);
-	vcpu->arch.vhpt.hash = (struct thash_data *)VHPT_ADDR(vcpu->vcpu_id);
-	vcpu->arch.vtlb.hash = (struct thash_data *)VTLB_ADDR(vcpu->vcpu_id);
+	vcpu->arch.vhpt.hash = (struct thash_data *)VHPT_BASE(vcpu->vcpu_id);
+	vcpu->arch.vtlb.hash = (struct thash_data *)VTLB_BASE(vcpu->vcpu_id);
 	init_ptce_info(vcpu);
 
 	r = 0;
@@ -1273,12 +1262,22 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 	int r;
 	int cpu;
 
+	BUG_ON(sizeof(struct kvm_vcpu) > VCPU_STRUCT_SIZE/2);
+
+	r = -EINVAL;
+	if (id >= KVM_MAX_VCPUS) {
+		printk(KERN_ERR"kvm: Can't configure vcpus > %ld",
+				KVM_MAX_VCPUS);
+		goto fail;
+	}
+
 	r = -ENOMEM;
 	if (!vm_base) {
 		printk(KERN_ERR"kvm: Create vcpu[%d] error!\n", id);
 		goto fail;
 	}
-	vcpu = (struct kvm_vcpu *)(vm_base + KVM_VCPU_OFS + VCPU_SIZE * id);
+	vcpu = (struct kvm_vcpu *)(vm_base + offsetof(struct kvm_vm_data,
+					vcpu_data[id].vcpu_struct));
 	vcpu->kvm = kvm;
 
 	cpu = get_cpu();
@@ -1396,7 +1395,7 @@ int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 					sizeof(union context));
 	if (r)
 		goto out;
-	r = copy_to_user(regs->saved_stack, (void *)vcpu, IA64_STK_OFFSET);
+	r = copy_to_user(regs->saved_stack, (void *)vcpu, KVM_STK_OFFSET);
 	if (r)
 		goto out;
 	SAVE_REGS(mp_state);
@@ -1457,6 +1456,9 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 	struct kvm_memory_slot *memslot = &kvm->memslots[mem->slot];
 	unsigned long base_gfn = memslot->base_gfn;
 
+	if (base_gfn + npages > (KVM_MAX_MEM_SIZE >> PAGE_SHIFT))
+		return -ENOMEM;
+
 	for (i = 0; i < npages; i++) {
 		pfn = gfn_to_pfn(kvm, base_gfn + i);
 		if (!kvm_is_mmio_pfn(pfn)) {
@@ -1631,8 +1633,8 @@ static int kvm_ia64_sync_dirty_log(struct kvm *kvm,
 	struct kvm_memory_slot *memslot;
 	int r, i;
 	long n, base;
-	unsigned long *dirty_bitmap = (unsigned long *)((void *)kvm - KVM_VM_OFS
-					+ KVM_MEM_DIRTY_LOG_OFS);
+	unsigned long *dirty_bitmap = (unsigned long *)(kvm->arch.vm_base +
+			offsetof(struct kvm_vm_data, kvm_mem_dirty_log));
 
 	r = -EINVAL;
 	if (log->slot >= KVM_MEMORY_SLOTS)
diff --git a/arch/ia64/kvm/kvm_minstate.h b/arch/ia64/kvm/kvm_minstate.h
index 2cc41d1..b2bcaa2 100644
--- a/arch/ia64/kvm/kvm_minstate.h
+++ b/arch/ia64/kvm/kvm_minstate.h
@@ -24,6 +24,8 @@
 #include <asm/asmmacro.h>
 #include <asm/types.h>
 #include <asm/kregs.h>
+#include <asm/kvm_host.h>
+
 #include "asm-offsets.h"
 
 #define KVM_MINSTATE_START_SAVE_MIN	     					\
@@ -33,7 +35,7 @@
 	addl r22 = VMM_RBS_OFFSET,r1;            /* compute base of RBS */	\
 	;;									\
 	lfetch.fault.excl.nt1 [r22];						\
-	addl r1 = IA64_STK_OFFSET-VMM_PT_REGS_SIZE,r1;  /* compute base of memory stack */  \
+	addl r1 = KVM_STK_OFFSET-VMM_PT_REGS_SIZE, r1;  \
 	mov r23 = ar.bspstore;			/* save ar.bspstore */          \
 	;;									\
 	mov ar.bspstore = r22;				/* switch to kernel RBS */\
diff --git a/arch/ia64/kvm/misc.h b/arch/ia64/kvm/misc.h
index e585c46..dd979e0 100644
--- a/arch/ia64/kvm/misc.h
+++ b/arch/ia64/kvm/misc.h
@@ -27,7 +27,8 @@
  */
 static inline uint64_t *kvm_host_get_pmt(struct kvm *kvm)
 {
-	return (uint64_t *)(kvm->arch.vm_base + KVM_P2M_OFS);
+	return (uint64_t *)(kvm->arch.vm_base +
+				offsetof(struct kvm_vm_data, kvm_p2m));
 }
 
 static inline void kvm_set_pmt_entry(struct kvm *kvm, gfn_t gfn,
diff --git a/arch/ia64/kvm/vcpu.c b/arch/ia64/kvm/vcpu.c
index e44027c..a528d70 100644
--- a/arch/ia64/kvm/vcpu.c
+++ b/arch/ia64/kvm/vcpu.c
@@ -816,8 +816,9 @@ static void vcpu_set_itc(struct kvm_vcpu *vcpu, u64 val)
 	unsigned long vitv = VCPU(vcpu, itv);
 
 	if (vcpu->vcpu_id == 0) {
-		for (i = 0; i < MAX_VCPU_NUM; i++) {
-			v = (struct kvm_vcpu *)((char *)vcpu + VCPU_SIZE * i);
+		for (i = 0; i < KVM_MAX_VCPUS; i++) {
+			v = (struct kvm_vcpu *)((char *)vcpu +
+					sizeof(struct kvm_vcpu_data) * i);
 			VMX(v, itc_offset) = itc_offset;
 			VMX(v, last_itc) = 0;
 		}
diff --git a/arch/ia64/kvm/vtlb.c b/arch/ia64/kvm/vtlb.c
index e22b933..6b6307a 100644
--- a/arch/ia64/kvm/vtlb.c
+++ b/arch/ia64/kvm/vtlb.c
@@ -183,8 +183,8 @@ void mark_pages_dirty(struct kvm_vcpu *v, u64 pte, u64 ps)
 	u64 i, dirty_pages = 1;
 	u64 base_gfn = (pte&_PAGE_PPN_MASK) >> PAGE_SHIFT;
 	spinlock_t *lock = __kvm_va(v->arch.dirty_log_lock_pa);
-	void *dirty_bitmap = (void *)v - (KVM_VCPU_OFS + v->vcpu_id * VCPU_SIZE)
-						+ KVM_MEM_DIRTY_LOG_OFS;
+	void *dirty_bitmap = (void *)KVM_MEM_DIRTY_LOG_BASE;
+
 	dirty_pages <<= ps <= PAGE_SHIFT ? 0 : ps - PAGE_SHIFT;
 
 	vmm_spin_lock(lock);
-- 
1.6.0.3

