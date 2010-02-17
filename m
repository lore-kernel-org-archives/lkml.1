Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934189Ab0BQNpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:45:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932951Ab0BQNpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:45:33 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/20] KVM: MMU: Add tracepoint for guest page aging
Date: Wed, 17 Feb 2010 15:45:12 +0200
Message-Id: <1266414330-27444-3-git-send-email-avi@redhat.com>
In-Reply-To: <1266414330-27444-1-git-send-email-avi@redhat.com>
References: <1266414330-27444-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c         |   11 ++++++++---
 include/trace/events/kvm.h |   22 ++++++++++++++++++++++
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b8da671..7397932 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -151,6 +151,9 @@ module_param(oos_shadow, bool, 0644);
 #define ACC_USER_MASK    PT_USER_MASK
 #define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
 
+#include <trace/events/kvm.h>
+
+#undef TRACE_INCLUDE_FILE
 #define CREATE_TRACE_POINTS
 #include "mmutrace.h"
 
@@ -792,6 +795,7 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 					 unsigned long data))
 {
 	int i, j;
+	int ret;
 	int retval = 0;
 	struct kvm_memslots *slots;
 
@@ -806,16 +810,17 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 		if (hva >= start && hva < end) {
 			gfn_t gfn_offset = (hva - start) >> PAGE_SHIFT;
 
-			retval |= handler(kvm, &memslot->rmap[gfn_offset],
-					  data);
+			ret = handler(kvm, &memslot->rmap[gfn_offset], data);
 
 			for (j = 0; j < KVM_NR_PAGE_SIZES - 1; ++j) {
 				int idx = gfn_offset;
 				idx /= KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL + j);
-				retval |= handler(kvm,
+				ret |= handler(kvm,
 					&memslot->lpage_info[j][idx].rmap_pde,
 					data);
 			}
+			trace_kvm_age_page(hva, memslot, ret);
+			retval |= ret;
 		}
 	}
 
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 8abdc12..b17d49d 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -164,6 +164,28 @@ TRACE_EVENT(kvm_fpu,
 	TP_printk("%s", __print_symbolic(__entry->load, kvm_fpu_load_symbol))
 );
 
+TRACE_EVENT(kvm_age_page,
+	TP_PROTO(ulong hva, struct kvm_memory_slot *slot, int ref),
+	TP_ARGS(hva, slot, ref),
+
+	TP_STRUCT__entry(
+		__field(	u64,	hva		)
+		__field(	u64,	gfn		)
+		__field(	u8,	referenced	)
+	),
+
+	TP_fast_assign(
+		__entry->hva		= hva;
+		__entry->gfn		=
+		  slot->base_gfn + ((hva - slot->userspace_addr) >> PAGE_SHIFT);
+		__entry->referenced	= ref;
+	),
+
+	TP_printk("hva %llx gfn %llx %s",
+		  __entry->hva, __entry->gfn,
+		  __entry->referenced ? "YOUNG" : "OLD")
+);
+
 #endif /* _TRACE_KVM_MAIN_H */
 
 /* This part must be outside protection */
-- 
1.6.5.3

