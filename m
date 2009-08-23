Return-Path: <linux-kernel-owner+w=401wt.eu-S933586AbZHWL4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586AbZHWL4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 07:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933532AbZHWL4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 07:56:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933526AbZHWL4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:48 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/46] KVM: MMU: Trace guest pagetable walker
Date: Sun, 23 Aug 2009 14:56:10 +0300
Message-Id: <1251028605-31977-12-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c         |    3 +
 arch/x86/kvm/mmutrace.h    |  117 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/paging_tmpl.h |   11 +++-
 3 files changed, 128 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/kvm/mmutrace.h

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b67585c..c0dda64 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -140,6 +140,9 @@ module_param(oos_shadow, bool, 0644);
 #define ACC_USER_MASK    PT_USER_MASK
 #define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
 
+#define CREATE_TRACE_POINTS
+#include "mmutrace.h"
+
 #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
 
 struct kvm_rmap_desc {
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
new file mode 100644
index 0000000..1367f82
--- /dev/null
+++ b/arch/x86/kvm/mmutrace.h
@@ -0,0 +1,117 @@
+#if !defined(_TRACE_KVMMMU_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_KVMMMU_H
+
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM kvmmmu
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE mmutrace
+
+#define kvm_mmu_trace_pferr_flags       \
+	{ PFERR_PRESENT_MASK, "P" },	\
+	{ PFERR_WRITE_MASK, "W" },	\
+	{ PFERR_USER_MASK, "U" },	\
+	{ PFERR_RSVD_MASK, "RSVD" },	\
+	{ PFERR_FETCH_MASK, "F" }
+
+/*
+ * A pagetable walk has started
+ */
+TRACE_EVENT(
+	kvm_mmu_pagetable_walk,
+	TP_PROTO(u64 addr, int write_fault, int user_fault, int fetch_fault),
+	TP_ARGS(addr, write_fault, user_fault, fetch_fault),
+
+	TP_STRUCT__entry(
+		__field(__u64, addr)
+		__field(__u32, pferr)
+	),
+
+	TP_fast_assign(
+		__entry->addr = addr;
+		__entry->pferr = (!!write_fault << 1) | (!!user_fault << 2)
+		                 | (!!fetch_fault << 4);
+	),
+
+	TP_printk("addr %llx pferr %x %s", __entry->addr, __entry->pferr,
+		  __print_flags(__entry->pferr, "|", kvm_mmu_trace_pferr_flags))
+);
+
+
+/* We just walked a paging element */
+TRACE_EVENT(
+	kvm_mmu_paging_element,
+	TP_PROTO(u64 pte, int level),
+	TP_ARGS(pte, level),
+
+	TP_STRUCT__entry(
+		__field(__u64, pte)
+		__field(__u32, level)
+		),
+
+	TP_fast_assign(
+		__entry->pte = pte;
+		__entry->level = level;
+		),
+
+	TP_printk("pte %llx level %u", __entry->pte, __entry->level)
+);
+
+/* We set a pte accessed bit */
+TRACE_EVENT(
+	kvm_mmu_set_accessed_bit,
+	TP_PROTO(unsigned long table_gfn, unsigned index, unsigned size),
+	TP_ARGS(table_gfn, index, size),
+
+	TP_STRUCT__entry(
+		__field(__u64, gpa)
+		),
+
+	TP_fast_assign(
+		__entry->gpa = ((u64)table_gfn << PAGE_SHIFT)
+				+ index * size;
+		),
+
+	TP_printk("gpa %llx", __entry->gpa)
+);
+
+/* We set a pte dirty bit */
+TRACE_EVENT(
+	kvm_mmu_set_dirty_bit,
+	TP_PROTO(unsigned long table_gfn, unsigned index, unsigned size),
+	TP_ARGS(table_gfn, index, size),
+
+	TP_STRUCT__entry(
+		__field(__u64, gpa)
+		),
+
+	TP_fast_assign(
+		__entry->gpa = ((u64)table_gfn << PAGE_SHIFT)
+				+ index * size;
+		),
+
+	TP_printk("gpa %llx", __entry->gpa)
+);
+
+TRACE_EVENT(
+	kvm_mmu_walker_error,
+	TP_PROTO(u32 pferr),
+	TP_ARGS(pferr),
+
+	TP_STRUCT__entry(
+		__field(__u32, pferr)
+		),
+
+	TP_fast_assign(
+		__entry->pferr = pferr;
+		),
+
+	TP_printk("pferr %x %s", __entry->pferr,
+		  __print_flags(__entry->pferr, "|", kvm_mmu_trace_pferr_flags))
+);
+
+#endif /* _TRACE_KVMMMU_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 53e129c..36ac6d7 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -125,13 +125,15 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 	gpa_t pte_gpa;
 	int rsvd_fault = 0;
 
-	pgprintk("%s: addr %lx\n", __func__, addr);
+	trace_kvm_mmu_pagetable_walk(addr, write_fault, user_fault,
+				     fetch_fault);
 walk:
 	walker->level = vcpu->arch.mmu.root_level;
 	pte = vcpu->arch.cr3;
 #if PTTYPE == 64
 	if (!is_long_mode(vcpu)) {
 		pte = kvm_pdptr_read(vcpu, (addr >> 30) & 3);
+		trace_kvm_mmu_paging_element(pte, walker->level);
 		if (!is_present_gpte(pte))
 			goto not_present;
 		--walker->level;
@@ -150,10 +152,9 @@ walk:
 		pte_gpa += index * sizeof(pt_element_t);
 		walker->table_gfn[walker->level - 1] = table_gfn;
 		walker->pte_gpa[walker->level - 1] = pte_gpa;
-		pgprintk("%s: table_gfn[%d] %lx\n", __func__,
-			 walker->level - 1, table_gfn);
 
 		kvm_read_guest(vcpu->kvm, pte_gpa, &pte, sizeof(pte));
+		trace_kvm_mmu_paging_element(pte, walker->level);
 
 		if (!is_present_gpte(pte))
 			goto not_present;
@@ -175,6 +176,8 @@ walk:
 #endif
 
 		if (!(pte & PT_ACCESSED_MASK)) {
+			trace_kvm_mmu_set_accessed_bit(table_gfn, index,
+						       sizeof(pte));
 			mark_page_dirty(vcpu->kvm, table_gfn);
 			if (FNAME(cmpxchg_gpte)(vcpu->kvm, table_gfn,
 			    index, pte, pte|PT_ACCESSED_MASK))
@@ -208,6 +211,7 @@ walk:
 	if (write_fault && !is_dirty_gpte(pte)) {
 		bool ret;
 
+		trace_kvm_mmu_set_dirty_bit(table_gfn, index, sizeof(pte));
 		mark_page_dirty(vcpu->kvm, table_gfn);
 		ret = FNAME(cmpxchg_gpte)(vcpu->kvm, table_gfn, index, pte,
 			    pte|PT_DIRTY_MASK);
@@ -239,6 +243,7 @@ err:
 		walker->error_code |= PFERR_FETCH_MASK;
 	if (rsvd_fault)
 		walker->error_code |= PFERR_RSVD_MASK;
+	trace_kvm_mmu_walker_error(walker->error_code);
 	return 0;
 }
 
-- 
1.6.4.1

