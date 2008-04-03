Return-Path: <linux-kernel-owner+w=401wt.eu-S1761540AbYDCTn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761540AbYDCTn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760664AbYDCTd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:29 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53022
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760358AbYDCTc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:32:59 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 21/35] KVM: MMU: hypercall based pte updates and TLB flushes
Date: Thu,  3 Apr 2008 22:32:36 +0300
Message-Id: <1207251170-5013-22-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Hypercall based pte updates are faster than faults, and also allow use
of the lazy MMU mode to batch operations.

Don't report the feature if two dimensional paging is enabled.

[avi:
 - one mmu_op hypercall instead of one per op
 - allow 64-bit gpa on hypercall
 - don't pass host errors (-ENOMEM) to guest]

[akpm: warning fix on i386]

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c         |  136 +++++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c         |   18 ++++++-
 include/asm-x86/kvm_host.h |    4 +
 include/asm-x86/kvm_para.h |   29 +++++++++
 include/linux/kvm.h        |    1 +
 include/linux/kvm_para.h   |    5 +-
 6 files changed, 190 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 414405b..072e942 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -28,6 +28,7 @@
 #include <linux/module.h>
 #include <linux/swap.h>
 #include <linux/hugetlb.h>
+#include <linux/compiler.h>
 
 #include <asm/page.h>
 #include <asm/cmpxchg.h>
@@ -40,7 +41,7 @@
  * 2. while doing 1. it walks guest-physical to host-physical
  * If the hardware supports that we don't need to do shadow paging.
  */
-static bool tdp_enabled = false;
+bool tdp_enabled = false;
 
 #undef MMU_DEBUG
 
@@ -167,6 +168,13 @@ static int dbg = 1;
 #define ACC_USER_MASK    PT_USER_MASK
 #define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
 
+struct kvm_pv_mmu_op_buffer {
+	void *ptr;
+	unsigned len;
+	unsigned processed;
+	char buf[512] __aligned(sizeof(long));
+};
+
 struct kvm_rmap_desc {
 	u64 *shadow_ptes[RMAP_EXT];
 	struct kvm_rmap_desc *more;
@@ -2003,6 +2011,132 @@ unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm)
 	return nr_mmu_pages;
 }
 
+static void *pv_mmu_peek_buffer(struct kvm_pv_mmu_op_buffer *buffer,
+				unsigned len)
+{
+	if (len > buffer->len)
+		return NULL;
+	return buffer->ptr;
+}
+
+static void *pv_mmu_read_buffer(struct kvm_pv_mmu_op_buffer *buffer,
+				unsigned len)
+{
+	void *ret;
+
+	ret = pv_mmu_peek_buffer(buffer, len);
+	if (!ret)
+		return ret;
+	buffer->ptr += len;
+	buffer->len -= len;
+	buffer->processed += len;
+	return ret;
+}
+
+static int kvm_pv_mmu_write(struct kvm_vcpu *vcpu,
+			     gpa_t addr, gpa_t value)
+{
+	int bytes = 8;
+	int r;
+
+	if (!is_long_mode(vcpu) && !is_pae(vcpu))
+		bytes = 4;
+
+	r = mmu_topup_memory_caches(vcpu);
+	if (r)
+		return r;
+
+	if (!__emulator_write_phys(vcpu, addr, &value, bytes))
+		return -EFAULT;
+
+	return 1;
+}
+
+static int kvm_pv_mmu_flush_tlb(struct kvm_vcpu *vcpu)
+{
+	kvm_x86_ops->tlb_flush(vcpu);
+	return 1;
+}
+
+static int kvm_pv_mmu_release_pt(struct kvm_vcpu *vcpu, gpa_t addr)
+{
+	spin_lock(&vcpu->kvm->mmu_lock);
+	mmu_unshadow(vcpu->kvm, addr >> PAGE_SHIFT);
+	spin_unlock(&vcpu->kvm->mmu_lock);
+	return 1;
+}
+
+static int kvm_pv_mmu_op_one(struct kvm_vcpu *vcpu,
+			     struct kvm_pv_mmu_op_buffer *buffer)
+{
+	struct kvm_mmu_op_header *header;
+
+	header = pv_mmu_peek_buffer(buffer, sizeof *header);
+	if (!header)
+		return 0;
+	switch (header->op) {
+	case KVM_MMU_OP_WRITE_PTE: {
+		struct kvm_mmu_op_write_pte *wpte;
+
+		wpte = pv_mmu_read_buffer(buffer, sizeof *wpte);
+		if (!wpte)
+			return 0;
+		return kvm_pv_mmu_write(vcpu, wpte->pte_phys,
+					wpte->pte_val);
+	}
+	case KVM_MMU_OP_FLUSH_TLB: {
+		struct kvm_mmu_op_flush_tlb *ftlb;
+
+		ftlb = pv_mmu_read_buffer(buffer, sizeof *ftlb);
+		if (!ftlb)
+			return 0;
+		return kvm_pv_mmu_flush_tlb(vcpu);
+	}
+	case KVM_MMU_OP_RELEASE_PT: {
+		struct kvm_mmu_op_release_pt *rpt;
+
+		rpt = pv_mmu_read_buffer(buffer, sizeof *rpt);
+		if (!rpt)
+			return 0;
+		return kvm_pv_mmu_release_pt(vcpu, rpt->pt_phys);
+	}
+	default: return 0;
+	}
+}
+
+int kvm_pv_mmu_op(struct kvm_vcpu *vcpu, unsigned long bytes,
+		  gpa_t addr, unsigned long *ret)
+{
+	int r;
+	struct kvm_pv_mmu_op_buffer buffer;
+
+	down_read(&vcpu->kvm->slots_lock);
+	down_read(&current->mm->mmap_sem);
+
+	buffer.ptr = buffer.buf;
+	buffer.len = min_t(unsigned long, bytes, sizeof buffer.buf);
+	buffer.processed = 0;
+
+	r = kvm_read_guest(vcpu->kvm, addr, buffer.buf, buffer.len);
+	if (r)
+		goto out;
+
+	while (buffer.len) {
+		r = kvm_pv_mmu_op_one(vcpu, &buffer);
+		if (r < 0)
+			goto out;
+		if (r == 0)
+			break;
+	}
+
+	r = 1;
+out:
+	*ret = buffer.processed;
+	up_read(&current->mm->mmap_sem);
+	up_read(&vcpu->kvm->slots_lock);
+	return r;
+}
+
 #ifdef AUDIT
 
 static const char *audit_msg;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 03ba402..63afca1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -832,6 +832,9 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_NR_MEMSLOTS:
 		r = KVM_MEMORY_SLOTS;
 		break;
+	case KVM_CAP_PV_MMU:
+		r = !tdp_enabled;
+		break;
 	default:
 		r = 0;
 		break;
@@ -2452,9 +2455,19 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_halt);
 
+static inline gpa_t hc_gpa(struct kvm_vcpu *vcpu, unsigned long a0,
+			   unsigned long a1)
+{
+	if (is_long_mode(vcpu))
+		return a0;
+	else
+		return a0 | ((gpa_t)a1 << 32);
+}
+
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
 	unsigned long nr, a0, a1, a2, a3, ret;
+	int r = 1;
 
 	kvm_x86_ops->cache_regs(vcpu);
 
@@ -2476,6 +2489,9 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	case KVM_HC_VAPIC_POLL_IRQ:
 		ret = 0;
 		break;
+	case KVM_HC_MMU_OP:
+		r = kvm_pv_mmu_op(vcpu, a0, hc_gpa(vcpu, a1, a2), &ret);
+		break;
 	default:
 		ret = -KVM_ENOSYS;
 		break;
@@ -2483,7 +2499,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	vcpu->arch.regs[VCPU_REGS_RAX] = ret;
 	kvm_x86_ops->decache_regs(vcpu);
 	++vcpu->stat.hypercalls;
-	return 0;
+	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
 
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index c8e51f8..52e276c 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -433,6 +433,10 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
 
 int __emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 			  const void *val, int bytes);
+int kvm_pv_mmu_op(struct kvm_vcpu *vcpu, unsigned long bytes,
+		  gpa_t addr, unsigned long *ret);
+
+extern bool tdp_enabled;
 
 enum emulation_result {
 	EMULATE_DONE,       /* no further processing */
diff --git a/include/asm-x86/kvm_para.h b/include/asm-x86/kvm_para.h
index ed5df3a..5098459 100644
--- a/include/asm-x86/kvm_para.h
+++ b/include/asm-x86/kvm_para.h
@@ -12,10 +12,39 @@
 #define KVM_CPUID_FEATURES	0x40000001
 #define KVM_FEATURE_CLOCKSOURCE		0
 #define KVM_FEATURE_NOP_IO_DELAY	1
+#define KVM_FEATURE_MMU_OP		2
 
 #define MSR_KVM_WALL_CLOCK  0x11
 #define MSR_KVM_SYSTEM_TIME 0x12
 
+#define KVM_MAX_MMU_OP_BATCH           32
+
+/* Operations for KVM_HC_MMU_OP */
+#define KVM_MMU_OP_WRITE_PTE            1
+#define KVM_MMU_OP_FLUSH_TLB	        2
+#define KVM_MMU_OP_RELEASE_PT	        3
+
+/* Payload for KVM_HC_MMU_OP */
+struct kvm_mmu_op_header {
+	__u32 op;
+	__u32 pad;
+};
+
+struct kvm_mmu_op_write_pte {
+	struct kvm_mmu_op_header header;
+	__u64 pte_phys;
+	__u64 pte_val;
+};
+
+struct kvm_mmu_op_flush_tlb {
+	struct kvm_mmu_op_header header;
+};
+
+struct kvm_mmu_op_release_pt {
+	struct kvm_mmu_op_header header;
+	__u64 pt_phys;
+};
+
 #ifdef __KERNEL__
 #include <asm/processor.h>
 
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 76f0947..c1b502a 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -238,6 +238,7 @@ struct kvm_vapic_addr {
 #define KVM_CAP_NR_MEMSLOTS 10   /* returns max memory slots per vm */
 #define KVM_CAP_PIT 11
 #define KVM_CAP_NOP_IO_DELAY 12
+#define KVM_CAP_PV_MMU 13
 
 /*
  * ioctls for VM fds
diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
index 9c462c9..3ddce03 100644
--- a/include/linux/kvm_para.h
+++ b/include/linux/kvm_para.h
@@ -11,8 +11,11 @@
 
 /* Return values for hypercalls */
 #define KVM_ENOSYS		1000
+#define KVM_EFAULT		EFAULT
+#define KVM_E2BIG		E2BIG
 
-#define KVM_HC_VAPIC_POLL_IRQ            1
+#define KVM_HC_VAPIC_POLL_IRQ		1
+#define KVM_HC_MMU_OP			2
 
 /*
  * hypercalls use architecture specific
-- 
1.5.4.5

