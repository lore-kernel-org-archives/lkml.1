Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980AbXLZLIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbXLZLIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbXLZLGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:21 -0500
Received: from il.qumranet.com ([82.166.9.18]:50433 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbXLZLGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:03 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 01/55] KVM: Portability: Split kvm_vcpu into arch dependent and independent parts (part 1)
Date: Wed, 26 Dec 2007 13:05:06 +0200
Message-Id: <1198667160-22953-2-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

First step to split kvm_vcpu.  Currently, we just use an macro to define
the common fields in kvm_vcpu for all archs, and all archs need to define
its own kvm_vcpu struct.

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/ioapic.c      |    2 +
 drivers/kvm/irq.c         |    1 +
 drivers/kvm/kvm.h         |  154 ++++++++-------------------------------------
 drivers/kvm/kvm_main.c    |    4 +-
 drivers/kvm/lapic.c       |    2 +
 drivers/kvm/mmu.c         |    1 +
 drivers/kvm/svm.c         |    2 +-
 drivers/kvm/vmx.c         |    1 +
 drivers/kvm/x86.h         |  117 ++++++++++++++++++++++++++++++++++
 drivers/kvm/x86_emulate.c |    1 +
 10 files changed, 155 insertions(+), 130 deletions(-)

diff --git a/drivers/kvm/ioapic.c b/drivers/kvm/ioapic.c
index 8503d99..e14b7c7 100644
--- a/drivers/kvm/ioapic.c
+++ b/drivers/kvm/ioapic.c
@@ -27,6 +27,8 @@
  */
 
 #include "kvm.h"
+#include "x86.h"
+
 #include <linux/kvm.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
diff --git a/drivers/kvm/irq.c b/drivers/kvm/irq.c
index 7628c7f..59b47c5 100644
--- a/drivers/kvm/irq.c
+++ b/drivers/kvm/irq.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 
 #include "kvm.h"
+#include "x86.h"
 #include "irq.h"
 
 /*
diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index eb006ed..db18d27 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -308,93 +308,37 @@ struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus, gpa_t addr);
 void kvm_io_bus_register_dev(struct kvm_io_bus *bus,
 			     struct kvm_io_device *dev);
 
-struct kvm_vcpu {
-	struct kvm *kvm;
-	struct preempt_notifier preempt_notifier;
-	int vcpu_id;
-	struct mutex mutex;
-	int   cpu;
-	u64 host_tsc;
-	struct kvm_run *run;
-	int interrupt_window_open;
-	int guest_mode;
-	unsigned long requests;
-	unsigned long irq_summary; /* bit vector: 1 per word in irq_pending */
-	DECLARE_BITMAP(irq_pending, KVM_NR_INTERRUPTS);
-	unsigned long regs[NR_VCPU_REGS]; /* for rsp: vcpu_load_rsp_rip() */
-	unsigned long rip;      /* needs vcpu_load_rsp_rip() */
-
-	unsigned long cr0;
-	unsigned long cr2;
-	unsigned long cr3;
-	unsigned long cr4;
-	unsigned long cr8;
-	u64 pdptrs[4]; /* pae */
-	u64 shadow_efer;
-	u64 apic_base;
-	struct kvm_lapic *apic;    /* kernel irqchip context */
-#define VCPU_MP_STATE_RUNNABLE          0
-#define VCPU_MP_STATE_UNINITIALIZED     1
-#define VCPU_MP_STATE_INIT_RECEIVED     2
-#define VCPU_MP_STATE_SIPI_RECEIVED     3
-#define VCPU_MP_STATE_HALTED            4
-	int mp_state;
-	int sipi_vector;
-	u64 ia32_misc_enable_msr;
-
-	struct kvm_mmu mmu;
-
-	struct kvm_mmu_memory_cache mmu_pte_chain_cache;
-	struct kvm_mmu_memory_cache mmu_rmap_desc_cache;
-	struct kvm_mmu_memory_cache mmu_page_cache;
-	struct kvm_mmu_memory_cache mmu_page_header_cache;
-
-	gfn_t last_pt_write_gfn;
-	int   last_pt_write_count;
-	u64  *last_pte_updated;
-
-	struct kvm_guest_debug guest_debug;
-
-	struct i387_fxsave_struct host_fx_image;
-	struct i387_fxsave_struct guest_fx_image;
-	int fpu_active;
-	int guest_fpu_loaded;
-
-	int mmio_needed;
-	int mmio_read_completed;
-	int mmio_is_write;
-	int mmio_size;
-	unsigned char mmio_data[8];
+#ifdef CONFIG_HAS_IOMEM
+#define KVM_VCPU_MMIO 			\
+	int mmio_needed;		\
+	int mmio_read_completed;	\
+	int mmio_is_write;		\
+	int mmio_size;			\
+	unsigned char mmio_data[8];	\
 	gpa_t mmio_phys_addr;
-	gva_t mmio_fault_cr2;
-	struct kvm_pio_request pio;
-	void *pio_data;
-	wait_queue_head_t wq;
 
-	int sigset_active;
-	sigset_t sigset;
+#else
+#define KVM_VCPU_MMIO
 
-	struct kvm_stat stat;
+#endif
 
-	struct {
-		int active;
-		u8 save_iopl;
-		struct kvm_save_segment {
-			u16 selector;
-			unsigned long base;
-			u32 limit;
-			u32 ar;
-		} tr, es, ds, fs, gs;
-	} rmode;
-	int halt_request; /* real mode on Intel only */
-
-	int cpuid_nent;
-	struct kvm_cpuid_entry cpuid_entries[KVM_MAX_CPUID_ENTRIES];
-
-	/* emulate context */
-
-	struct x86_emulate_ctxt emulate_ctxt;
-};
+#define KVM_VCPU_COMM 					\
+	struct kvm *kvm; 				\
+	struct preempt_notifier preempt_notifier;	\
+	int vcpu_id;					\
+	struct mutex mutex;				\
+	int   cpu;					\
+	struct kvm_run *run;				\
+	int guest_mode;					\
+	unsigned long requests;				\
+	struct kvm_guest_debug guest_debug;		\
+	int fpu_active; 				\
+	int guest_fpu_loaded;				\
+	wait_queue_head_t wq;				\
+	int sigset_active;				\
+	sigset_t sigset;				\
+	struct kvm_stat stat;				\
+	KVM_VCPU_MMIO
 
 struct kvm_mem_alias {
 	gfn_t base_gfn;
@@ -680,50 +624,6 @@ static inline void kvm_guest_exit(void)
 	current->flags &= ~PF_VCPU;
 }
 
-static inline int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
-				     u32 error_code)
-{
-	return vcpu->mmu.page_fault(vcpu, gva, error_code);
-}
-
-static inline void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
-{
-	if (unlikely(vcpu->kvm->n_free_mmu_pages < KVM_MIN_FREE_MMU_PAGES))
-		__kvm_mmu_free_some_pages(vcpu);
-}
-
-static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
-{
-	if (likely(vcpu->mmu.root_hpa != INVALID_PAGE))
-		return 0;
-
-	return kvm_mmu_load(vcpu);
-}
-
-static inline int is_long_mode(struct kvm_vcpu *vcpu)
-{
-#ifdef CONFIG_X86_64
-	return vcpu->shadow_efer & EFER_LME;
-#else
-	return 0;
-#endif
-}
-
-static inline int is_pae(struct kvm_vcpu *vcpu)
-{
-	return vcpu->cr4 & X86_CR4_PAE;
-}
-
-static inline int is_pse(struct kvm_vcpu *vcpu)
-{
-	return vcpu->cr4 & X86_CR4_PSE;
-}
-
-static inline int is_paging(struct kvm_vcpu *vcpu)
-{
-	return vcpu->cr0 & X86_CR0_PG;
-}
-
 static inline int memslot_id(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
 	return slot - kvm->memslots;
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index a228c05..41d4a93 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2244,7 +2244,7 @@ static int kvm_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		if (r)
 			goto out;
 	}
-
+#if CONFIG_HAS_IOMEM
 	if (vcpu->mmio_needed) {
 		memcpy(vcpu->mmio_data, kvm_run->mmio.data, 8);
 		vcpu->mmio_read_completed = 1;
@@ -2259,7 +2259,7 @@ static int kvm_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 			goto out;
 		}
 	}
-
+#endif
 	if (kvm_run->exit_reason == KVM_EXIT_HYPERCALL) {
 		kvm_x86_ops->cache_regs(vcpu);
 		vcpu->regs[VCPU_REGS_RAX] = kvm_run->hypercall.ret;
diff --git a/drivers/kvm/lapic.c b/drivers/kvm/lapic.c
index 8840f9d..64f74bd 100644
--- a/drivers/kvm/lapic.c
+++ b/drivers/kvm/lapic.c
@@ -18,6 +18,8 @@
  */
 
 #include "kvm.h"
+#include "x86.h"
+
 #include <linux/kvm.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 5d7af4b..d9c5950 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -19,6 +19,7 @@
 
 #include "vmx.h"
 #include "kvm.h"
+#include "x86.h"
 
 #include <linux/types.h>
 #include <linux/string.h>
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 4ff2922..09c4b14 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -13,7 +13,7 @@
  * the COPYING file in the top-level directory.
  *
  */
-
+#include "x86.h"
 #include "kvm_svm.h"
 #include "x86_emulate.h"
 #include "irq.h"
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index be6846d..828d3cb 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -16,6 +16,7 @@
  */
 
 #include "kvm.h"
+#include "x86.h"
 #include "x86_emulate.h"
 #include "irq.h"
 #include "vmx.h"
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index 1e2f71b..01452b5 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -13,4 +13,121 @@
 
 #include "kvm.h"
 
+#include <linux/types.h>
+#include <linux/mm.h>
+
+#include <linux/kvm.h>
+#include <linux/kvm_para.h>
+
+struct kvm_vcpu {
+	KVM_VCPU_COMM;
+	u64 host_tsc;
+	int interrupt_window_open;
+	unsigned long irq_summary; /* bit vector: 1 per word in irq_pending */
+	DECLARE_BITMAP(irq_pending, KVM_NR_INTERRUPTS);
+	unsigned long regs[NR_VCPU_REGS]; /* for rsp: vcpu_load_rsp_rip() */
+	unsigned long rip;      /* needs vcpu_load_rsp_rip() */
+
+	unsigned long cr0;
+	unsigned long cr2;
+	unsigned long cr3;
+	unsigned long cr4;
+	unsigned long cr8;
+	u64 pdptrs[4]; /* pae */
+	u64 shadow_efer;
+	u64 apic_base;
+	struct kvm_lapic *apic;    /* kernel irqchip context */
+#define VCPU_MP_STATE_RUNNABLE          0
+#define VCPU_MP_STATE_UNINITIALIZED     1
+#define VCPU_MP_STATE_INIT_RECEIVED     2
+#define VCPU_MP_STATE_SIPI_RECEIVED     3
+#define VCPU_MP_STATE_HALTED            4
+	int mp_state;
+	int sipi_vector;
+	u64 ia32_misc_enable_msr;
+
+	struct kvm_mmu mmu;
+
+	struct kvm_mmu_memory_cache mmu_pte_chain_cache;
+	struct kvm_mmu_memory_cache mmu_rmap_desc_cache;
+	struct kvm_mmu_memory_cache mmu_page_cache;
+	struct kvm_mmu_memory_cache mmu_page_header_cache;
+
+	gfn_t last_pt_write_gfn;
+	int   last_pt_write_count;
+	u64  *last_pte_updated;
+
+
+	struct i387_fxsave_struct host_fx_image;
+	struct i387_fxsave_struct guest_fx_image;
+
+	gva_t mmio_fault_cr2;
+	struct kvm_pio_request pio;
+	void *pio_data;
+
+	struct {
+		int active;
+		u8 save_iopl;
+		struct kvm_save_segment {
+			u16 selector;
+			unsigned long base;
+			u32 limit;
+			u32 ar;
+		} tr, es, ds, fs, gs;
+	} rmode;
+	int halt_request; /* real mode on Intel only */
+
+	int cpuid_nent;
+	struct kvm_cpuid_entry cpuid_entries[KVM_MAX_CPUID_ENTRIES];
+
+	/* emulate context */
+
+	struct x86_emulate_ctxt emulate_ctxt;
+};
+
+static inline int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
+				     u32 error_code)
+{
+	return vcpu->mmu.page_fault(vcpu, gva, error_code);
+}
+
+static inline void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
+{
+	if (unlikely(vcpu->kvm->n_free_mmu_pages < KVM_MIN_FREE_MMU_PAGES))
+		__kvm_mmu_free_some_pages(vcpu);
+}
+
+static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
+{
+	if (likely(vcpu->mmu.root_hpa != INVALID_PAGE))
+		return 0;
+
+	return kvm_mmu_load(vcpu);
+}
+
+static inline int is_long_mode(struct kvm_vcpu *vcpu)
+{
+#ifdef CONFIG_X86_64
+	return vcpu->shadow_efer & EFER_LME;
+#else
+	return 0;
+#endif
+}
+
+static inline int is_pae(struct kvm_vcpu *vcpu)
+{
+	return vcpu->cr4 & X86_CR4_PAE;
+}
+
+static inline int is_pse(struct kvm_vcpu *vcpu)
+{
+	return vcpu->cr4 & X86_CR4_PSE;
+}
+
+static inline int is_paging(struct kvm_vcpu *vcpu)
+{
+	return vcpu->cr0 & X86_CR0_PG;
+}
+
+
 #endif
diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index e962de3..73e3580 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -26,6 +26,7 @@
 #define DPRINTF(_f, _a ...) printf(_f , ## _a)
 #else
 #include "kvm.h"
+#include "x86.h"
 #define DPRINTF(x...) do {} while (0)
 #endif
 #include "x86_emulate.h"
-- 
1.5.3.7

