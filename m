Return-Path: <linux-kernel-owner+w=401wt.eu-S1752487AbZHSNG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbZHSNG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZHSNEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:04:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50579 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752000AbZHSNCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:49 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 38/47] KVM: powerpc: convert marker probes to event trace
Date: Wed, 19 Aug 2009 16:02:34 +0300
Message-Id: <1250686963-8357-39-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

[avi: make it build]
[avi: fold trace-arch.h into trace.h]

CC: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/44x_tlb.c  |   11 +++--
 arch/powerpc/kvm/Makefile   |    4 ++
 arch/powerpc/kvm/e500_tlb.c |   16 +++----
 arch/powerpc/kvm/emulate.c  |    3 +-
 arch/powerpc/kvm/powerpc.c  |    3 +
 arch/powerpc/kvm/trace.h    |  104 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 126 insertions(+), 15 deletions(-)
 create mode 100644 arch/powerpc/kvm/trace.h

diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index 4a16f47..ff3cb63 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -30,6 +30,7 @@
 #include "timing.h"
 
 #include "44x_tlb.h"
+#include "trace.h"
 
 #ifndef PPC44x_TLBE_SIZE
 #define PPC44x_TLBE_SIZE	PPC44x_TLB_4K
@@ -263,7 +264,7 @@ static void kvmppc_44x_shadow_release(struct kvmppc_vcpu_44x *vcpu_44x,
 
 	/* XXX set tlb_44x_index to stlb_index? */
 
-	KVMTRACE_1D(STLB_INVAL, &vcpu_44x->vcpu, stlb_index, handler);
+	trace_kvm_stlb_inval(stlb_index);
 }
 
 void kvmppc_mmu_destroy(struct kvm_vcpu *vcpu)
@@ -365,8 +366,8 @@ void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gpa_t gpaddr,
 	/* Insert shadow mapping into hardware TLB. */
 	kvmppc_44x_tlbe_set_modified(vcpu_44x, victim);
 	kvmppc_44x_tlbwe(victim, &stlbe);
-	KVMTRACE_5D(STLB_WRITE, vcpu, victim, stlbe.tid, stlbe.word0, stlbe.word1,
-	            stlbe.word2, handler);
+	trace_kvm_stlb_write(victim, stlbe.tid, stlbe.word0, stlbe.word1,
+			     stlbe.word2);
 }
 
 /* For a particular guest TLB entry, invalidate the corresponding host TLB
@@ -485,8 +486,8 @@ int kvmppc_44x_emul_tlbwe(struct kvm_vcpu *vcpu, u8 ra, u8 rs, u8 ws)
 		kvmppc_mmu_map(vcpu, eaddr, gpaddr, gtlb_index);
 	}
 
-	KVMTRACE_5D(GTLB_WRITE, vcpu, gtlb_index, tlbe->tid, tlbe->word0,
-	            tlbe->word1, tlbe->word2, handler);
+	trace_kvm_gtlb_write(gtlb_index, tlbe->tid, tlbe->word0, tlbe->word1,
+			     tlbe->word2);
 
 	kvmppc_set_exit_type(vcpu, EMULATED_TLBWE_EXITS);
 	return EMULATE_DONE;
diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
index 459c7ee..4f407f2 100644
--- a/arch/powerpc/kvm/Makefile
+++ b/arch/powerpc/kvm/Makefile
@@ -10,6 +10,10 @@ common-objs-y = $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmio.o)
 
 common-objs-$(CONFIG_KVM_TRACE)  += $(addprefix ../../../virt/kvm/, kvm_trace.o)
 
+CFLAGS_44x_tlb.o  := -I.
+CFLAGS_e500_tlb.o := -I.
+CFLAGS_emulate.o  := -I.
+
 kvm-objs := $(common-objs-y) powerpc.o emulate.o
 obj-$(CONFIG_KVM_EXIT_TIMING) += timing.o
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/powerpc/kvm/e500_tlb.c b/arch/powerpc/kvm/e500_tlb.c
index a2048ac..fb1e1dc 100644
--- a/arch/powerpc/kvm/e500_tlb.c
+++ b/arch/powerpc/kvm/e500_tlb.c
@@ -22,6 +22,7 @@
 
 #include "../mm/mmu_decl.h"
 #include "e500_tlb.h"
+#include "trace.h"
 
 #define to_htlb1_esel(esel) (tlb1_entry_num - (esel) - 1)
 
@@ -224,9 +225,8 @@ static void kvmppc_e500_stlbe_invalidate(struct kvmppc_vcpu_e500 *vcpu_e500,
 
 	kvmppc_e500_shadow_release(vcpu_e500, tlbsel, esel);
 	stlbe->mas1 = 0;
-	KVMTRACE_5D(STLB_INVAL, &vcpu_e500->vcpu, index_of(tlbsel, esel),
-			stlbe->mas1, stlbe->mas2, stlbe->mas3, stlbe->mas7,
-			handler);
+	trace_kvm_stlb_inval(index_of(tlbsel, esel), stlbe->mas1, stlbe->mas2,
+			     stlbe->mas3, stlbe->mas7);
 }
 
 static void kvmppc_e500_tlb1_invalidate(struct kvmppc_vcpu_e500 *vcpu_e500,
@@ -319,9 +319,8 @@ static inline void kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 				vcpu_e500->vcpu.arch.msr & MSR_PR);
 	stlbe->mas7 = (hpaddr >> 32) & MAS7_RPN;
 
-	KVMTRACE_5D(STLB_WRITE, &vcpu_e500->vcpu, index_of(tlbsel, esel),
-			stlbe->mas1, stlbe->mas2, stlbe->mas3, stlbe->mas7,
-			handler);
+	trace_kvm_stlb_write(index_of(tlbsel, esel), stlbe->mas1, stlbe->mas2,
+			     stlbe->mas3, stlbe->mas7);
 }
 
 /* XXX only map the one-one case, for now use TLB0 */
@@ -535,9 +534,8 @@ int kvmppc_e500_emul_tlbwe(struct kvm_vcpu *vcpu)
 	gtlbe->mas3 = vcpu_e500->mas3;
 	gtlbe->mas7 = vcpu_e500->mas7;
 
-	KVMTRACE_5D(GTLB_WRITE, vcpu, vcpu_e500->mas0,
-			gtlbe->mas1, gtlbe->mas2, gtlbe->mas3, gtlbe->mas7,
-			handler);
+	trace_kvm_gtlb_write(vcpu_e500->mas0, gtlbe->mas1, gtlbe->mas2,
+			     gtlbe->mas3, gtlbe->mas7);
 
 	/* Invalidate shadow mappings for the about-to-be-clobbered TLBE. */
 	if (tlbe_is_host_safe(vcpu, gtlbe)) {
diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
index 28a8237..7737146 100644
--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -29,6 +29,7 @@
 #include <asm/kvm_ppc.h>
 #include <asm/disassemble.h>
 #include "timing.h"
+#include "trace.h"
 
 #define OP_TRAP 3
 
@@ -419,7 +420,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 		}
 	}
 
-	KVMTRACE_3D(PPC_INSTR, vcpu, inst, (int)vcpu->arch.pc, emulated, entryexit);
+	trace_kvm_ppc_instr(inst, vcpu->arch.pc, emulated);
 
 	if (advance)
 		vcpu->arch.pc += 4; /* Advance past emulated instruction. */
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 7ad30e0..0341391 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -31,6 +31,9 @@
 #include "timing.h"
 #include "../mm/mmu_decl.h"
 
+#define CREATE_TRACE_POINTS
+#include "trace.h"
+
 gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	return gfn;
diff --git a/arch/powerpc/kvm/trace.h b/arch/powerpc/kvm/trace.h
new file mode 100644
index 0000000..67f219d
--- /dev/null
+++ b/arch/powerpc/kvm/trace.h
@@ -0,0 +1,104 @@
+#if !defined(_TRACE_KVM_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_KVM_H
+
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM kvm
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE trace
+
+/*
+ * Tracepoint for guest mode entry.
+ */
+TRACE_EVENT(kvm_ppc_instr,
+	TP_PROTO(unsigned int inst, unsigned long pc, unsigned int emulate),
+	TP_ARGS(inst, pc, emulate),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	inst		)
+		__field(	unsigned long,	pc		)
+		__field(	unsigned int,	emulate		)
+	),
+
+	TP_fast_assign(
+		__entry->inst		= inst;
+		__entry->pc		= pc;
+		__entry->emulate	= emulate;
+	),
+
+	TP_printk("inst %u pc 0x%lx emulate %u\n",
+		  __entry->inst, __entry->pc, __entry->emulate)
+);
+
+TRACE_EVENT(kvm_stlb_inval,
+	TP_PROTO(unsigned int stlb_index),
+	TP_ARGS(stlb_index),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	stlb_index	)
+	),
+
+	TP_fast_assign(
+		__entry->stlb_index	= stlb_index;
+	),
+
+	TP_printk("stlb_index %u", __entry->stlb_index)
+);
+
+TRACE_EVENT(kvm_stlb_write,
+	TP_PROTO(unsigned int victim, unsigned int tid, unsigned int word0,
+		 unsigned int word1, unsigned int word2),
+	TP_ARGS(victim, tid, word0, word1, word2),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	victim		)
+		__field(	unsigned int,	tid		)
+		__field(	unsigned int,	word0		)
+		__field(	unsigned int,	word1		)
+		__field(	unsigned int,	word2		)
+	),
+
+	TP_fast_assign(
+		__entry->victim		= victim;
+		__entry->tid		= tid;
+		__entry->word0		= word0;
+		__entry->word1		= word1;
+		__entry->word2		= word2;
+	),
+
+	TP_printk("victim %u tid %u w0 %u w1 %u w2 %u",
+		__entry->victim, __entry->tid, __entry->word0,
+		__entry->word1, __entry->word2)
+);
+
+TRACE_EVENT(kvm_gtlb_write,
+	TP_PROTO(unsigned int gtlb_index, unsigned int tid, unsigned int word0,
+		 unsigned int word1, unsigned int word2),
+	TP_ARGS(gtlb_index, tid, word0, word1, word2),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	gtlb_index	)
+		__field(	unsigned int,	tid		)
+		__field(	unsigned int,	word0		)
+		__field(	unsigned int,	word1		)
+		__field(	unsigned int,	word2		)
+	),
+
+	TP_fast_assign(
+		__entry->gtlb_index	= gtlb_index;
+		__entry->tid		= tid;
+		__entry->word0		= word0;
+		__entry->word1		= word1;
+		__entry->word2		= word2;
+	),
+
+	TP_printk("gtlb_index %u tid %u w0 %u w1 %u w2 %u",
+		__entry->gtlb_index, __entry->tid, __entry->word0,
+		__entry->word1, __entry->word2)
+);
+
+#endif /* _TRACE_KVM_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.6.3.3

