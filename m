Return-Path: <linux-kernel-owner+w=401wt.eu-S1759214AbYAFOm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214AbYAFOm1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758173AbYAFOjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:39:53 -0500
Received: from il.qumranet.com ([82.166.9.18]:46606 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864AbYAFOjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:43 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 06/33] KVM: Portability: Move kvm_vcpu definition back to kvm.h
Date: Sun,  6 Jan 2008 16:39:12 +0200
Message-Id: <1199630379-28638-7-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

This patches moves kvm_vcpu definition to kvm.h, and finally
kvm.h includes x86.h.

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/irq.h   |    2 +-
 drivers/kvm/kvm.h   |  113 ++++-----------------------------------------------
 drivers/kvm/types.h |   13 ++++++
 drivers/kvm/x86.h   |  102 ++++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 117 insertions(+), 113 deletions(-)

diff --git a/drivers/kvm/irq.h b/drivers/kvm/irq.h
index e88d939..a688c51 100644
--- a/drivers/kvm/irq.h
+++ b/drivers/kvm/irq.h
@@ -26,7 +26,7 @@
 #include <linux/hrtimer.h>
 #include <asm/kvm.h>
 #include "iodev.h"
-#include "x86.h"
+#include "kvm.h"
 
 struct kvm;
 struct kvm_vcpu;
diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index c040bb3..53717be 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -22,17 +22,13 @@
 
 #include "types.h"
 
+#include "x86.h"
+
 #define KVM_MAX_VCPUS 4
 #define KVM_ALIAS_SLOTS 4
 #define KVM_MEMORY_SLOTS 8
 /* memory slots that does not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 4
-#define KVM_PERMILLE_MMU_PAGES 20
-#define KVM_MIN_ALLOC_MMU_PAGES 64
-#define KVM_NUM_MMU_PAGES 1024
-#define KVM_MIN_FREE_MMU_PAGES 5
-#define KVM_REFILL_PAGES 25
-#define KVM_MAX_CPUID_ENTRIES 40
 
 #define KVM_PIO_PAGE_OFFSET 1
 
@@ -41,111 +37,16 @@
  */
 #define KVM_REQ_TLB_FLUSH          0
 
-#define NR_PTE_CHAIN_ENTRIES 5
-
-struct kvm_pte_chain {
-	u64 *parent_ptes[NR_PTE_CHAIN_ENTRIES];
-	struct hlist_node link;
-};
-
-/*
- * kvm_mmu_page_role, below, is defined as:
- *
- *   bits 0:3 - total guest paging levels (2-4, or zero for real mode)
- *   bits 4:7 - page table level for this shadow (1-4)
- *   bits 8:9 - page table quadrant for 2-level guests
- *   bit   16 - "metaphysical" - gfn is not a real page (huge page/real mode)
- *   bits 17:19 - common access permissions for all ptes in this shadow page
- */
-union kvm_mmu_page_role {
-	unsigned word;
-	struct {
-		unsigned glevels : 4;
-		unsigned level : 4;
-		unsigned quadrant : 2;
-		unsigned pad_for_nice_hex_output : 6;
-		unsigned metaphysical : 1;
-		unsigned access : 3;
-	};
-};
-
-struct kvm_mmu_page {
-	struct list_head link;
-	struct hlist_node hash_link;
-
-	/*
-	 * The following two entries are used to key the shadow page in the
-	 * hash table.
-	 */
-	gfn_t gfn;
-	union kvm_mmu_page_role role;
-
-	u64 *spt;
-	/* hold the gfn of each spte inside spt */
-	gfn_t *gfns;
-	unsigned long slot_bitmap; /* One bit set per slot which has memory
-				    * in this shadow page.
-				    */
-	int multimapped;         /* More than one parent_pte? */
-	int root_count;          /* Currently serving as active root */
-	union {
-		u64 *parent_pte;               /* !multimapped */
-		struct hlist_head parent_ptes; /* multimapped, kvm_pte_chain */
-	};
-};
 
 struct kvm_vcpu;
 extern struct kmem_cache *kvm_vcpu_cache;
 
-/*
- * x86 supports 3 paging modes (4-level 64-bit, 3-level 64-bit, and 2-level
- * 32-bit).  The kvm_mmu structure abstracts the details of the current mmu
- * mode.
- */
-struct kvm_mmu {
-	void (*new_cr3)(struct kvm_vcpu *vcpu);
-	int (*page_fault)(struct kvm_vcpu *vcpu, gva_t gva, u32 err);
-	void (*free)(struct kvm_vcpu *vcpu);
-	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t gva);
-	void (*prefetch_page)(struct kvm_vcpu *vcpu,
-			      struct kvm_mmu_page *page);
-	hpa_t root_hpa;
-	int root_level;
-	int shadow_root_level;
-
-	u64 *pae_root;
-};
-
-#define KVM_NR_MEM_OBJS 40
-
-/*
- * We don't want allocation failures within the mmu code, so we preallocate
- * enough memory for a single page fault in a cache.
- */
-struct kvm_mmu_memory_cache {
-	int nobjs;
-	void *objects[KVM_NR_MEM_OBJS];
-};
-
 struct kvm_guest_debug {
 	int enabled;
 	unsigned long bp[4];
 	int singlestep;
 };
 
-struct kvm_pio_request {
-	unsigned long count;
-	int cur_count;
-	struct page *guest_pages[2];
-	unsigned guest_page_offset;
-	int in;
-	int port;
-	int size;
-	int string;
-	int down;
-	int rep;
-};
-
 struct kvm_vcpu_stat {
 	u32 pf_fixed;
 	u32 pf_guest;
@@ -218,6 +119,12 @@ void kvm_io_bus_register_dev(struct kvm_io_bus *bus,
 	struct kvm_vcpu_stat stat;			\
 	KVM_VCPU_MMIO
 
+struct kvm_vcpu {
+	KVM_VCPU_COMM;
+
+	struct kvm_vcpu_arch arch;
+};
+
 struct kvm_mem_alias {
 	gfn_t base_gfn;
 	unsigned long npages;
@@ -441,8 +348,4 @@ struct kvm_stats_debugfs_item {
 };
 extern struct kvm_stats_debugfs_item debugfs_entries[];
 
-#if defined(CONFIG_X86)
-#include "x86.h"
-#endif
-
 #endif
diff --git a/drivers/kvm/types.h b/drivers/kvm/types.h
index 6ad7623..1c4e46d 100644
--- a/drivers/kvm/types.h
+++ b/drivers/kvm/types.h
@@ -38,4 +38,17 @@ typedef unsigned long  hva_t;
 typedef u64            hpa_t;
 typedef unsigned long  hfn_t;
 
+struct kvm_pio_request {
+	unsigned long count;
+	int cur_count;
+	struct page *guest_pages[2];
+	unsigned guest_page_offset;
+	int in;
+	int port;
+	int size;
+	int string;
+	int down;
+	int rep;
+};
+
 #endif /* __KVM_TYPES_H__ */
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index 0da4be9..a0dd447 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -11,8 +11,6 @@
 #ifndef KVM_X86_H
 #define KVM_X86_H
 
-#include "kvm.h"
-
 #include <linux/types.h>
 #include <linux/mm.h>
 
@@ -21,6 +19,8 @@
 
 #include <asm/desc.h>
 
+#include "types.h"
+
 #define CR3_PAE_RESERVED_BITS ((X86_CR3_PWT | X86_CR3_PCD) - 1)
 #define CR3_NONPAE_RESERVED_BITS ((PAGE_SIZE-1) & ~(X86_CR3_PWT | X86_CR3_PCD))
 #define CR3_L_MODE_RESERVED_BITS (CR3_NONPAE_RESERVED_BITS|0xFFFFFF0000000000ULL)
@@ -54,9 +54,19 @@
 
 #define IOPL_SHIFT 12
 
+#define KVM_PERMILLE_MMU_PAGES 20
+#define KVM_MIN_ALLOC_MMU_PAGES 64
+#define KVM_NUM_MMU_PAGES 1024
+#define KVM_MIN_FREE_MMU_PAGES 5
+#define KVM_REFILL_PAGES 25
+#define KVM_MAX_CPUID_ENTRIES 40
+
 extern spinlock_t kvm_lock;
 extern struct list_head vm_list;
 
+struct kvm_vcpu;
+struct kvm;
+
 enum {
 	VCPU_REGS_RAX = 0,
 	VCPU_REGS_RCX = 1,
@@ -92,6 +102,89 @@ enum {
 
 #include "x86_emulate.h"
 
+#define KVM_NR_MEM_OBJS 40
+
+/*
+ * We don't want allocation failures within the mmu code, so we preallocate
+ * enough memory for a single page fault in a cache.
+ */
+struct kvm_mmu_memory_cache {
+	int nobjs;
+	void *objects[KVM_NR_MEM_OBJS];
+};
+
+#define NR_PTE_CHAIN_ENTRIES 5
+
+struct kvm_pte_chain {
+	u64 *parent_ptes[NR_PTE_CHAIN_ENTRIES];
+	struct hlist_node link;
+};
+
+/*
+ * kvm_mmu_page_role, below, is defined as:
+ *
+ *   bits 0:3 - total guest paging levels (2-4, or zero for real mode)
+ *   bits 4:7 - page table level for this shadow (1-4)
+ *   bits 8:9 - page table quadrant for 2-level guests
+ *   bit   16 - "metaphysical" - gfn is not a real page (huge page/real mode)
+ *   bits 17:19 - common access permissions for all ptes in this shadow page
+ */
+union kvm_mmu_page_role {
+	unsigned word;
+	struct {
+		unsigned glevels : 4;
+		unsigned level : 4;
+		unsigned quadrant : 2;
+		unsigned pad_for_nice_hex_output : 6;
+		unsigned metaphysical : 1;
+		unsigned access : 3;
+	};
+};
+
+struct kvm_mmu_page {
+	struct list_head link;
+	struct hlist_node hash_link;
+
+	/*
+	 * The following two entries are used to key the shadow page in the
+	 * hash table.
+	 */
+	gfn_t gfn;
+	union kvm_mmu_page_role role;
+
+	u64 *spt;
+	/* hold the gfn of each spte inside spt */
+	gfn_t *gfns;
+	unsigned long slot_bitmap; /* One bit set per slot which has memory
+				    * in this shadow page.
+				    */
+	int multimapped;         /* More than one parent_pte? */
+	int root_count;          /* Currently serving as active root */
+	union {
+		u64 *parent_pte;               /* !multimapped */
+		struct hlist_head parent_ptes; /* multimapped, kvm_pte_chain */
+	};
+};
+
+/*
+ * x86 supports 3 paging modes (4-level 64-bit, 3-level 64-bit, and 2-level
+ * 32-bit).  The kvm_mmu structure abstracts the details of the current mmu
+ * mode.
+ */
+struct kvm_mmu {
+	void (*new_cr3)(struct kvm_vcpu *vcpu);
+	int (*page_fault)(struct kvm_vcpu *vcpu, gva_t gva, u32 err);
+	void (*free)(struct kvm_vcpu *vcpu);
+	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t gva);
+	void (*prefetch_page)(struct kvm_vcpu *vcpu,
+			      struct kvm_mmu_page *page);
+	hpa_t root_hpa;
+	int root_level;
+	int shadow_root_level;
+
+	u64 *pae_root;
+};
+
 struct kvm_vcpu_arch {
 	u64 host_tsc;
 	int interrupt_window_open;
@@ -162,11 +255,6 @@ struct kvm_vcpu_arch {
 	struct x86_emulate_ctxt emulate_ctxt;
 };
 
-struct kvm_vcpu {
-	KVM_VCPU_COMM;
-
-	struct kvm_vcpu_arch arch;
-};
 
 struct descriptor_table {
 	u16 limit;
-- 
1.5.3.7

