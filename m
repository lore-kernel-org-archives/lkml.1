Return-Path: <linux-kernel-owner+w=401wt.eu-S933807AbZHWMD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933807AbZHWMD7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933528AbZHWMD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:03:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933517AbZHWL4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:48 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/46] KVM: Trace shadow page lifecycle
Date: Sun, 23 Aug 2009 14:56:12 +0300
Message-Id: <1251028605-31977-14-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create, sync, unsync, zap.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c      |   10 +++--
 arch/x86/kvm/mmutrace.h |  103 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 109 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c0dda64..ac121b3 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1122,6 +1122,7 @@ static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		return 1;
 	}
 
+	trace_kvm_mmu_sync_page(sp);
 	if (rmap_write_protect(vcpu->kvm, sp->gfn))
 		kvm_flush_remote_tlbs(vcpu->kvm);
 	kvm_unlink_unsync_page(vcpu->kvm, sp);
@@ -1244,8 +1245,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
 		role.quadrant = quadrant;
 	}
-	pgprintk("%s: looking gfn %lx role %x\n", __func__,
-		 gfn, role.word);
 	index = kvm_page_table_hashfn(gfn);
 	bucket = &vcpu->kvm->arch.mmu_page_hash[index];
 	hlist_for_each_entry_safe(sp, node, tmp, bucket, hash_link)
@@ -1262,14 +1261,13 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 				set_bit(KVM_REQ_MMU_SYNC, &vcpu->requests);
 				kvm_mmu_mark_parents_unsync(vcpu, sp);
 			}
-			pgprintk("%s: found\n", __func__);
+			trace_kvm_mmu_get_page(sp, false);
 			return sp;
 		}
 	++vcpu->kvm->stat.mmu_cache_miss;
 	sp = kvm_mmu_alloc_page(vcpu, parent_pte);
 	if (!sp)
 		return sp;
-	pgprintk("%s: adding gfn %lx role %x\n", __func__, gfn, role.word);
 	sp->gfn = gfn;
 	sp->role = role;
 	hlist_add_head(&sp->hash_link, bucket);
@@ -1282,6 +1280,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		vcpu->arch.mmu.prefetch_page(vcpu, sp);
 	else
 		nonpaging_prefetch_page(vcpu, sp);
+	trace_kvm_mmu_get_page(sp, true);
 	return sp;
 }
 
@@ -1410,6 +1409,8 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
 static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	int ret;
+
+	trace_kvm_mmu_zap_page(sp);
 	++kvm->stat.mmu_shadow_zapped;
 	ret = mmu_zap_unsync_children(kvm, sp);
 	kvm_mmu_page_unlink_children(kvm, sp);
@@ -1656,6 +1657,7 @@ static int kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	struct kvm_mmu_page *s;
 	struct hlist_node *node, *n;
 
+	trace_kvm_mmu_unsync_page(sp);
 	index = kvm_page_table_hashfn(sp->gfn);
 	bucket = &vcpu->kvm->arch.mmu_page_hash[index];
 	/* don't unsync if pagetable is shadowed with multiple roles */
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 1367f82..3e4a5c6 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -2,12 +2,48 @@
 #define _TRACE_KVMMMU_H
 
 #include <linux/tracepoint.h>
+#include <linux/ftrace_event.h>
 
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM kvmmmu
 #define TRACE_INCLUDE_PATH .
 #define TRACE_INCLUDE_FILE mmutrace
 
+#define KVM_MMU_PAGE_FIELDS \
+	__field(__u64, gfn) \
+	__field(__u32, role) \
+	__field(__u32, root_count) \
+	__field(__u32, unsync)
+
+#define KVM_MMU_PAGE_ASSIGN(sp)			     \
+	__entry->gfn = sp->gfn;			     \
+	__entry->role = sp->role.word;		     \
+	__entry->root_count = sp->root_count;        \
+	__entry->unsync = sp->unsync;
+
+#define KVM_MMU_PAGE_PRINTK() ({				        \
+	const char *ret = p->buffer + p->len;				\
+	static const char *access_str[] = {			        \
+		"---", "--x", "w--", "w-x", "-u-", "-ux", "wu-", "wux"  \
+	};							        \
+	union kvm_mmu_page_role role;				        \
+								        \
+	role.word = __entry->role;					\
+									\
+	trace_seq_printf(p, "sp gfn %llx %u/%u q%u%s %s%s %spge"	\
+			 " %snxe root %u %s%c",				\
+			 __entry->gfn, role.level, role.glevels,	\
+			 role.quadrant,					\
+			 role.direct ? " direct" : "",			\
+			 access_str[role.access],			\
+			 role.invalid ? " invalid" : "",		\
+			 role.cr4_pge ? "" : "!",			\
+			 role.nxe ? "" : "!",				\
+			 __entry->root_count,				\
+			 __entry->unsync ? "unsync" : "sync", 0);	\
+	ret;								\
+		})
+
 #define kvm_mmu_trace_pferr_flags       \
 	{ PFERR_PRESENT_MASK, "P" },	\
 	{ PFERR_WRITE_MASK, "W" },	\
@@ -111,6 +147,73 @@ TRACE_EVENT(
 		  __print_flags(__entry->pferr, "|", kvm_mmu_trace_pferr_flags))
 );
 
+TRACE_EVENT(
+	kvm_mmu_get_page,
+	TP_PROTO(struct kvm_mmu_page *sp, bool created),
+	TP_ARGS(sp, created),
+
+	TP_STRUCT__entry(
+		KVM_MMU_PAGE_FIELDS
+		__field(bool, created)
+		),
+
+	TP_fast_assign(
+		KVM_MMU_PAGE_ASSIGN(sp)
+		__entry->created = created;
+		),
+
+	TP_printk("%s %s", KVM_MMU_PAGE_PRINTK(),
+		  __entry->created ? "new" : "existing")
+);
+
+TRACE_EVENT(
+	kvm_mmu_sync_page,
+	TP_PROTO(struct kvm_mmu_page *sp),
+	TP_ARGS(sp),
+
+	TP_STRUCT__entry(
+		KVM_MMU_PAGE_FIELDS
+		),
+
+	TP_fast_assign(
+		KVM_MMU_PAGE_ASSIGN(sp)
+		),
+
+	TP_printk("%s", KVM_MMU_PAGE_PRINTK())
+);
+
+TRACE_EVENT(
+	kvm_mmu_unsync_page,
+	TP_PROTO(struct kvm_mmu_page *sp),
+	TP_ARGS(sp),
+
+	TP_STRUCT__entry(
+		KVM_MMU_PAGE_FIELDS
+		),
+
+	TP_fast_assign(
+		KVM_MMU_PAGE_ASSIGN(sp)
+		),
+
+	TP_printk("%s", KVM_MMU_PAGE_PRINTK())
+);
+
+TRACE_EVENT(
+	kvm_mmu_zap_page,
+	TP_PROTO(struct kvm_mmu_page *sp),
+	TP_ARGS(sp),
+
+	TP_STRUCT__entry(
+		KVM_MMU_PAGE_FIELDS
+		),
+
+	TP_fast_assign(
+		KVM_MMU_PAGE_ASSIGN(sp)
+		),
+
+	TP_printk("%s", KVM_MMU_PAGE_PRINTK())
+);
+
 #endif /* _TRACE_KVMMMU_H */
 
 /* This part must be outside protection */
-- 
1.6.4.1

