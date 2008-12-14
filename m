Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbYLNIUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbYLNIUd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbYLNII1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:08:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59945 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168AbYLNIHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:21 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 23/36] KVM: ppc: Implement in-kernel exit timing statistics
Date: Sun, 14 Dec 2008 10:06:56 +0200
Message-Id: <1229242029-13410-24-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Existing KVM statistics are either just counters (kvm_stat) reported for
KVM generally or trace based aproaches like kvm_trace.
For KVM on powerpc we had the need to track the timings of the different exit
types. While this could be achieved parsing data created with a kvm_trace
extension this adds too much overhead (at least on embedded PowerPC) slowing
down the workloads we wanted to measure.

Therefore this patch adds a in-kernel exit timing statistic to the powerpc kvm
code. These statistic is available per vm&vcpu under the kvm debugfs directory.
As this statistic is low, but still some overhead it can be enabled via a
.config entry and should be off by default.

Since this patch touched all powerpc kvm_stat code anyway this code is now
merged and simplified together with the exit timing statistic code (still
working with exit timing disabled in .config).

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_host.h |   56 ++++++++
 arch/powerpc/kernel/asm-offsets.c   |   11 ++
 arch/powerpc/kvm/44x_emulate.c      |   11 ++-
 arch/powerpc/kvm/44x_tlb.c          |    3 +
 arch/powerpc/kvm/Kconfig            |   11 ++
 arch/powerpc/kvm/Makefile           |    1 +
 arch/powerpc/kvm/booke.c            |   36 +++--
 arch/powerpc/kvm/booke.h            |    5 +-
 arch/powerpc/kvm/booke_interrupts.S |   24 +++
 arch/powerpc/kvm/emulate.c          |    4 +
 arch/powerpc/kvm/powerpc.c          |    8 +-
 arch/powerpc/kvm/timing.c           |  262 +++++++++++++++++++++++++++++++++++
 arch/powerpc/kvm/timing.h           |  102 ++++++++++++++
 13 files changed, 516 insertions(+), 18 deletions(-)
 create mode 100644 arch/powerpc/kvm/timing.c
 create mode 100644 arch/powerpc/kvm/timing.h

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index a4a7d5e..2f5b49f 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -71,6 +71,49 @@ struct kvmppc_44x_tlbe {
 	u32 word2;
 };
 
+enum kvm_exit_types {
+	MMIO_EXITS,
+	DCR_EXITS,
+	SIGNAL_EXITS,
+	ITLB_REAL_MISS_EXITS,
+	ITLB_VIRT_MISS_EXITS,
+	DTLB_REAL_MISS_EXITS,
+	DTLB_VIRT_MISS_EXITS,
+	SYSCALL_EXITS,
+	ISI_EXITS,
+	DSI_EXITS,
+	EMULATED_INST_EXITS,
+	EMULATED_MTMSRWE_EXITS,
+	EMULATED_WRTEE_EXITS,
+	EMULATED_MTSPR_EXITS,
+	EMULATED_MFSPR_EXITS,
+	EMULATED_MTMSR_EXITS,
+	EMULATED_MFMSR_EXITS,
+	EMULATED_TLBSX_EXITS,
+	EMULATED_TLBWE_EXITS,
+	EMULATED_RFI_EXITS,
+	DEC_EXITS,
+	EXT_INTR_EXITS,
+	HALT_WAKEUP,
+	USR_PR_INST,
+	FP_UNAVAIL,
+	DEBUG_EXITS,
+	TIMEINGUEST,
+	__NUMBER_OF_KVM_EXIT_TYPES
+};
+
+#ifdef CONFIG_KVM_EXIT_TIMING
+/* allow access to big endian 32bit upper/lower parts and 64bit var */
+struct exit_timing {
+	union {
+		u64 tv64;
+		struct {
+			u32 tbu, tbl;
+		} tv32;
+	};
+};
+#endif
+
 struct kvm_arch {
 };
 
@@ -130,6 +173,19 @@ struct kvm_vcpu_arch {
 	u32 dbcr0;
 	u32 dbcr1;
 
+#ifdef CONFIG_KVM_EXIT_TIMING
+	struct exit_timing timing_exit;
+	struct exit_timing timing_last_enter;
+	u32 last_exit_type;
+	u32 timing_count_type[__NUMBER_OF_KVM_EXIT_TYPES];
+	u64 timing_sum_duration[__NUMBER_OF_KVM_EXIT_TYPES];
+	u64 timing_sum_quad_duration[__NUMBER_OF_KVM_EXIT_TYPES];
+	u64 timing_min_duration[__NUMBER_OF_KVM_EXIT_TYPES];
+	u64 timing_max_duration[__NUMBER_OF_KVM_EXIT_TYPES];
+	u64 timing_last_exit;
+	struct dentry *debugfs_exit_timing;
+#endif
+
 	u32 last_inst;
 	ulong fault_dear;
 	ulong fault_esr;
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 80fa29b..fc3b863 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -377,5 +377,16 @@ int main(void)
 	DEFINE(VCPU_FAULT_ESR, offsetof(struct kvm_vcpu, arch.fault_esr));
 #endif
 
+#ifdef CONFIG_KVM_EXIT_TIMING
+	DEFINE(VCPU_TIMING_EXIT_TBU, offsetof(struct kvm_vcpu,
+						arch.timing_exit.tv32.tbu));
+	DEFINE(VCPU_TIMING_EXIT_TBL, offsetof(struct kvm_vcpu,
+						arch.timing_exit.tv32.tbl));
+	DEFINE(VCPU_TIMING_LAST_ENTER_TBU, offsetof(struct kvm_vcpu,
+					arch.timing_last_enter.tv32.tbu));
+	DEFINE(VCPU_TIMING_LAST_ENTER_TBL, offsetof(struct kvm_vcpu,
+					arch.timing_last_enter.tv32.tbl));
+#endif
+
 	return 0;
 }
diff --git a/arch/powerpc/kvm/44x_emulate.c b/arch/powerpc/kvm/44x_emulate.c
index 9ef79c7..69f88d5 100644
--- a/arch/powerpc/kvm/44x_emulate.c
+++ b/arch/powerpc/kvm/44x_emulate.c
@@ -22,6 +22,7 @@
 #include <asm/dcr-regs.h>
 #include <asm/disassemble.h>
 #include <asm/kvm_44x.h>
+#include "timing.h"
 
 #include "booke.h"
 #include "44x_tlb.h"
@@ -58,11 +59,11 @@ int kvmppc_core_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
 	int ws;
 
 	switch (get_op(inst)) {
-
 	case OP_RFI:
 		switch (get_xop(inst)) {
 		case XOP_RFI:
 			kvmppc_emul_rfi(vcpu);
+			kvmppc_set_exit_type(vcpu, EMULATED_RFI_EXITS);
 			*advance = 0;
 			break;
 
@@ -78,10 +79,12 @@ int kvmppc_core_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		case XOP_MFMSR:
 			rt = get_rt(inst);
 			vcpu->arch.gpr[rt] = vcpu->arch.msr;
+			kvmppc_set_exit_type(vcpu, EMULATED_MFMSR_EXITS);
 			break;
 
 		case XOP_MTMSR:
 			rs = get_rs(inst);
+			kvmppc_set_exit_type(vcpu, EMULATED_MTMSR_EXITS);
 			kvmppc_set_msr(vcpu, vcpu->arch.gpr[rs]);
 			break;
 
@@ -89,11 +92,13 @@ int kvmppc_core_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			rs = get_rs(inst);
 			vcpu->arch.msr = (vcpu->arch.msr & ~MSR_EE)
 							 | (vcpu->arch.gpr[rs] & MSR_EE);
+			kvmppc_set_exit_type(vcpu, EMULATED_WRTEE_EXITS);
 			break;
 
 		case XOP_WRTEEI:
 			vcpu->arch.msr = (vcpu->arch.msr & ~MSR_EE)
 							 | (inst & MSR_EE);
+			kvmppc_set_exit_type(vcpu, EMULATED_WRTEE_EXITS);
 			break;
 
 		case XOP_MFDCR:
@@ -127,6 +132,7 @@ int kvmppc_core_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
 				run->dcr.is_write = 0;
 				vcpu->arch.io_gpr = rt;
 				vcpu->arch.dcr_needed = 1;
+				account_exit(vcpu, DCR_EXITS);
 				emulated = EMULATE_DO_DCR;
 			}
 
@@ -146,6 +152,7 @@ int kvmppc_core_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
 				run->dcr.data = vcpu->arch.gpr[rs];
 				run->dcr.is_write = 1;
 				vcpu->arch.dcr_needed = 1;
+				account_exit(vcpu, DCR_EXITS);
 				emulated = EMULATE_DO_DCR;
 			}
 
@@ -276,6 +283,7 @@ int kvmppc_core_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, int rs)
 		return EMULATE_FAIL;
 	}
 
+	kvmppc_set_exit_type(vcpu, EMULATED_MTSPR_EXITS);
 	return EMULATE_DONE;
 }
 
@@ -357,6 +365,7 @@ int kvmppc_core_emulate_mfspr(struct kvm_vcpu *vcpu, int sprn, int rt)
 		return EMULATE_FAIL;
 	}
 
+	kvmppc_set_exit_type(vcpu, EMULATED_MFSPR_EXITS);
 	return EMULATE_DONE;
 }
 
diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index ff16d0e..9a34b8e 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -27,6 +27,7 @@
 #include <asm/mmu-44x.h>
 #include <asm/kvm_ppc.h>
 #include <asm/kvm_44x.h>
+#include "timing.h"
 
 #include "44x_tlb.h"
 
@@ -470,6 +471,7 @@ int kvmppc_44x_emul_tlbwe(struct kvm_vcpu *vcpu, u8 ra, u8 rs, u8 ws)
 	KVMTRACE_5D(GTLB_WRITE, vcpu, gtlb_index, tlbe->tid, tlbe->word0,
 	            tlbe->word1, tlbe->word2, handler);
 
+	kvmppc_set_exit_type(vcpu, EMULATED_TLBWE_EXITS);
 	return EMULATE_DONE;
 }
 
@@ -493,5 +495,6 @@ int kvmppc_44x_emul_tlbsx(struct kvm_vcpu *vcpu, u8 rt, u8 ra, u8 rb, u8 rc)
 	}
 	vcpu->arch.gpr[rt] = gtlb_index;
 
+	kvmppc_set_exit_type(vcpu, EMULATED_TLBSX_EXITS);
 	return EMULATE_DONE;
 }
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index e4ab1c7..6dbdc48 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -32,6 +32,17 @@ config KVM_440
 
 	  If unsure, say N.
 
+config KVM_EXIT_TIMING
+	bool "Detailed exit timing"
+	depends on KVM
+	---help---
+	  Calculate elapsed time for every exit/enter cycle. A per-vcpu
+	  report is available in debugfs kvm/vm#_vcpu#_timing.
+	  The overhead is relatively small, however it is not recommended for
+	  production environments.
+
+	  If unsure, say N.
+
 config KVM_TRACE
 	bool "KVM trace support"
 	depends on KVM && MARKERS && SYSFS
diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
index f045fad..df7ba59 100644
--- a/arch/powerpc/kvm/Makefile
+++ b/arch/powerpc/kvm/Makefile
@@ -9,6 +9,7 @@ common-objs-y = $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmio.o)
 common-objs-$(CONFIG_KVM_TRACE)  += $(addprefix ../../../virt/kvm/, kvm_trace.o)
 
 kvm-objs := $(common-objs-y) powerpc.o emulate.o
+obj-$(CONFIG_KVM_EXIT_TIMING) += timing.o
 obj-$(CONFIG_KVM) += kvm.o
 
 AFLAGS_booke_interrupts.o := -I$(obj)
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index eb24383..0f17124 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -28,6 +28,7 @@
 #include <asm/cputable.h>
 #include <asm/uaccess.h>
 #include <asm/kvm_ppc.h>
+#include "timing.h"
 #include <asm/cacheflush.h>
 #include <asm/kvm_44x.h>
 
@@ -185,6 +186,9 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 	enum emulation_result er;
 	int r = RESUME_HOST;
 
+	/* update before a new last_exit_type is rewritten */
+	kvmppc_update_timing_stats(vcpu);
+
 	local_irq_enable();
 
 	run->exit_reason = KVM_EXIT_UNKNOWN;
@@ -198,7 +202,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		break;
 
 	case BOOKE_INTERRUPT_EXTERNAL:
-		vcpu->stat.ext_intr_exits++;
+		account_exit(vcpu, EXT_INTR_EXITS);
 		if (need_resched())
 			cond_resched();
 		r = RESUME_GUEST;
@@ -208,8 +212,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		/* Since we switched IVPR back to the host's value, the host
 		 * handled this interrupt the moment we enabled interrupts.
 		 * Now we just offer it a chance to reschedule the guest. */
-
-		vcpu->stat.dec_exits++;
+		account_exit(vcpu, DEC_EXITS);
 		if (need_resched())
 			cond_resched();
 		r = RESUME_GUEST;
@@ -222,20 +225,21 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			vcpu->arch.esr = vcpu->arch.fault_esr;
 			kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_PROGRAM);
 			r = RESUME_GUEST;
+			account_exit(vcpu, USR_PR_INST);
 			break;
 		}
 
 		er = kvmppc_emulate_instruction(run, vcpu);
 		switch (er) {
 		case EMULATE_DONE:
+			/* don't overwrite subtypes, just account kvm_stats */
+			account_exit_stat(vcpu, EMULATED_INST_EXITS);
 			/* Future optimization: only reload non-volatiles if
 			 * they were actually modified by emulation. */
-			vcpu->stat.emulated_inst_exits++;
 			r = RESUME_GUEST_NV;
 			break;
 		case EMULATE_DO_DCR:
 			run->exit_reason = KVM_EXIT_DCR;
-			vcpu->stat.dcr_exits++;
 			r = RESUME_HOST;
 			break;
 		case EMULATE_FAIL:
@@ -255,6 +259,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 
 	case BOOKE_INTERRUPT_FP_UNAVAIL:
 		kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_FP_UNAVAIL);
+		account_exit(vcpu, FP_UNAVAIL);
 		r = RESUME_GUEST;
 		break;
 
@@ -262,20 +267,20 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		vcpu->arch.dear = vcpu->arch.fault_dear;
 		vcpu->arch.esr = vcpu->arch.fault_esr;
 		kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_DATA_STORAGE);
-		vcpu->stat.dsi_exits++;
+		account_exit(vcpu, DSI_EXITS);
 		r = RESUME_GUEST;
 		break;
 
 	case BOOKE_INTERRUPT_INST_STORAGE:
 		vcpu->arch.esr = vcpu->arch.fault_esr;
 		kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_INST_STORAGE);
-		vcpu->stat.isi_exits++;
+		account_exit(vcpu, ISI_EXITS);
 		r = RESUME_GUEST;
 		break;
 
 	case BOOKE_INTERRUPT_SYSCALL:
 		kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_SYSCALL);
-		vcpu->stat.syscall_exits++;
+		account_exit(vcpu, SYSCALL_EXITS);
 		r = RESUME_GUEST;
 		break;
 
@@ -294,7 +299,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_DTLB_MISS);
 			vcpu->arch.dear = vcpu->arch.fault_dear;
 			vcpu->arch.esr = vcpu->arch.fault_esr;
-			vcpu->stat.dtlb_real_miss_exits++;
+			account_exit(vcpu, DTLB_REAL_MISS_EXITS);
 			r = RESUME_GUEST;
 			break;
 		}
@@ -312,13 +317,13 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			 * invoking the guest. */
 			kvmppc_mmu_map(vcpu, eaddr, vcpu->arch.paddr_accessed, gtlbe->tid,
 			               gtlbe->word2, get_tlb_bytes(gtlbe), gtlb_index);
-			vcpu->stat.dtlb_virt_miss_exits++;
+			account_exit(vcpu, DTLB_VIRT_MISS_EXITS);
 			r = RESUME_GUEST;
 		} else {
 			/* Guest has mapped and accessed a page which is not
 			 * actually RAM. */
 			r = kvmppc_emulate_mmio(run, vcpu);
-			vcpu->stat.mmio_exits++;
+			account_exit(vcpu, MMIO_EXITS);
 		}
 
 		break;
@@ -340,11 +345,11 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		if (gtlb_index < 0) {
 			/* The guest didn't have a mapping for it. */
 			kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_ITLB_MISS);
-			vcpu->stat.itlb_real_miss_exits++;
+			account_exit(vcpu, ITLB_REAL_MISS_EXITS);
 			break;
 		}
 
-		vcpu->stat.itlb_virt_miss_exits++;
+		account_exit(vcpu, ITLB_VIRT_MISS_EXITS);
 
 		gtlbe = &vcpu_44x->guest_tlb[gtlb_index];
 		gpaddr = tlb_xlate(gtlbe, eaddr);
@@ -378,6 +383,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		mtspr(SPRN_DBSR, dbsr);
 
 		run->exit_reason = KVM_EXIT_DEBUG;
+		account_exit(vcpu, DEBUG_EXITS);
 		r = RESUME_HOST;
 		break;
 	}
@@ -398,7 +404,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		if (signal_pending(current)) {
 			run->exit_reason = KVM_EXIT_INTR;
 			r = (-EINTR << 2) | RESUME_HOST | (r & RESUME_FLAG_NV);
-			vcpu->stat.signal_exits++;
+			account_exit(vcpu, SIGNAL_EXITS);
 		}
 	}
 
@@ -418,6 +424,8 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 	 * before it's programmed its own IVPR. */
 	vcpu->arch.ivpr = 0x55550000;
 
+	kvmppc_init_timing_stats(vcpu);
+
 	return kvmppc_core_vcpu_setup(vcpu);
 }
 
diff --git a/arch/powerpc/kvm/booke.h b/arch/powerpc/kvm/booke.h
index 48d905f..cf7c94c 100644
--- a/arch/powerpc/kvm/booke.h
+++ b/arch/powerpc/kvm/booke.h
@@ -22,6 +22,7 @@
 
 #include <linux/types.h>
 #include <linux/kvm_host.h>
+#include "timing.h"
 
 /* interrupt priortity ordering */
 #define BOOKE_IRQPRIO_DATA_STORAGE 0
@@ -50,8 +51,10 @@ static inline void kvmppc_set_msr(struct kvm_vcpu *vcpu, u32 new_msr)
 
 	vcpu->arch.msr = new_msr;
 
-	if (vcpu->arch.msr & MSR_WE)
+	if (vcpu->arch.msr & MSR_WE) {
 		kvm_vcpu_block(vcpu);
+		kvmppc_set_exit_type(vcpu, EMULATED_MTMSRWE_EXITS);
+	};
 }
 
 #endif /* __KVM_BOOKE_H__ */
diff --git a/arch/powerpc/kvm/booke_interrupts.S b/arch/powerpc/kvm/booke_interrupts.S
index eb21868..084ebcd 100644
--- a/arch/powerpc/kvm/booke_interrupts.S
+++ b/arch/powerpc/kvm/booke_interrupts.S
@@ -107,6 +107,18 @@ _GLOBAL(kvmppc_resume_host)
 	li	r6, 1
 	slw	r6, r6, r5
 
+#ifdef CONFIG_KVM_EXIT_TIMING
+	/* save exit time */
+1:
+	mfspr	r7, SPRN_TBRU
+	mfspr	r8, SPRN_TBRL
+	mfspr	r9, SPRN_TBRU
+	cmpw	r9, r7
+	bne	1b
+	stw	r8, VCPU_TIMING_EXIT_TBL(r4)
+	stw	r9, VCPU_TIMING_EXIT_TBU(r4)
+#endif
+
 	/* Save the faulting instruction and all GPRs for emulation. */
 	andi.	r7, r6, NEED_INST_MASK
 	beq	..skip_inst_copy
@@ -375,6 +387,18 @@ lightweight_exit:
 	lwz	r3, VCPU_SPRG7(r4)
 	mtspr	SPRN_SPRG7, r3
 
+#ifdef CONFIG_KVM_EXIT_TIMING
+	/* save enter time */
+1:
+	mfspr	r6, SPRN_TBRU
+	mfspr	r7, SPRN_TBRL
+	mfspr	r8, SPRN_TBRU
+	cmpw	r8, r6
+	bne	1b
+	stw	r7, VCPU_TIMING_LAST_ENTER_TBL(r4)
+	stw	r8, VCPU_TIMING_LAST_ENTER_TBU(r4)
+#endif
+
 	/* Finish loading guest volatiles and jump to guest. */
 	lwz	r3, VCPU_CTR(r4)
 	mtctr	r3
diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
index 4c30fa0..d1d38da 100644
--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -28,6 +28,7 @@
 #include <asm/byteorder.h>
 #include <asm/kvm_ppc.h>
 #include <asm/disassemble.h>
+#include "timing.h"
 
 void kvmppc_emulate_dec(struct kvm_vcpu *vcpu)
 {
@@ -73,6 +74,9 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 	enum emulation_result emulated = EMULATE_DONE;
 	int advance = 1;
 
+	/* this default type might be overwritten by subcategories */
+	kvmppc_set_exit_type(vcpu, EMULATED_INST_EXITS);
+
 	switch (get_op(inst)) {
 	case 3:                                             /* trap */
 		vcpu->arch.esr |= ESR_PTR;
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 0745b6d..343fdb9 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -28,7 +28,7 @@
 #include <asm/uaccess.h>
 #include <asm/kvm_ppc.h>
 #include <asm/tlbflush.h>
-
+#include "timing.h"
 
 gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
 {
@@ -170,11 +170,15 @@ void kvm_arch_flush_shadow(struct kvm *kvm)
 
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
 {
-	return kvmppc_core_vcpu_create(kvm, id);
+	struct kvm_vcpu *vcpu;
+	vcpu = kvmppc_core_vcpu_create(kvm, id);
+	kvmppc_create_vcpu_debugfs(vcpu, id);
+	return vcpu;
 }
 
 void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 {
+	kvmppc_remove_vcpu_debugfs(vcpu);
 	kvmppc_core_vcpu_free(vcpu);
 }
 
diff --git a/arch/powerpc/kvm/timing.c b/arch/powerpc/kvm/timing.c
new file mode 100644
index 0000000..f42d272
--- /dev/null
+++ b/arch/powerpc/kvm/timing.c
@@ -0,0 +1,262 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright IBM Corp. 2007
+ *
+ * Authors: Hollis Blanchard <hollisb@us.ibm.com>
+ *          Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
+ */
+
+#include <linux/kvm_host.h>
+#include <linux/fs.h>
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+
+#include "timing.h"
+#include <asm/time.h>
+#include <asm-generic/div64.h>
+
+void kvmppc_init_timing_stats(struct kvm_vcpu *vcpu)
+{
+	int i;
+
+	/* pause guest execution to avoid concurrent updates */
+	local_irq_disable();
+	mutex_lock(&vcpu->mutex);
+
+	vcpu->arch.last_exit_type = 0xDEAD;
+	for (i = 0; i < __NUMBER_OF_KVM_EXIT_TYPES; i++) {
+		vcpu->arch.timing_count_type[i] = 0;
+		vcpu->arch.timing_max_duration[i] = 0;
+		vcpu->arch.timing_min_duration[i] = 0xFFFFFFFF;
+		vcpu->arch.timing_sum_duration[i] = 0;
+		vcpu->arch.timing_sum_quad_duration[i] = 0;
+	}
+	vcpu->arch.timing_last_exit = 0;
+	vcpu->arch.timing_exit.tv64 = 0;
+	vcpu->arch.timing_last_enter.tv64 = 0;
+
+	mutex_unlock(&vcpu->mutex);
+	local_irq_enable();
+}
+
+static void add_exit_timing(struct kvm_vcpu *vcpu,
+					u64 duration, int type)
+{
+	u64 old;
+
+	do_div(duration, tb_ticks_per_usec);
+	if (unlikely(duration > 0xFFFFFFFF)) {
+		printk(KERN_ERR"%s - duration too big -> overflow"
+			" duration %lld type %d exit #%d\n",
+			__func__, duration, type,
+			vcpu->arch.timing_count_type[type]);
+		return;
+	}
+
+	vcpu->arch.timing_count_type[type]++;
+
+	/* sum */
+	old = vcpu->arch.timing_sum_duration[type];
+	vcpu->arch.timing_sum_duration[type] += duration;
+	if (unlikely(old > vcpu->arch.timing_sum_duration[type])) {
+		printk(KERN_ERR"%s - wrap adding sum of durations"
+			" old %lld new %lld type %d exit # of type %d\n",
+			__func__, old, vcpu->arch.timing_sum_duration[type],
+			type, vcpu->arch.timing_count_type[type]);
+	}
+
+	/* square sum */
+	old = vcpu->arch.timing_sum_quad_duration[type];
+	vcpu->arch.timing_sum_quad_duration[type] += (duration*duration);
+	if (unlikely(old > vcpu->arch.timing_sum_quad_duration[type])) {
+		printk(KERN_ERR"%s - wrap adding sum of squared durations"
+			" old %lld new %lld type %d exit # of type %d\n",
+			__func__, old,
+			vcpu->arch.timing_sum_quad_duration[type],
+			type, vcpu->arch.timing_count_type[type]);
+	}
+
+	/* set min/max */
+	if (unlikely(duration < vcpu->arch.timing_min_duration[type]))
+		vcpu->arch.timing_min_duration[type] = duration;
+	if (unlikely(duration > vcpu->arch.timing_max_duration[type]))
+		vcpu->arch.timing_max_duration[type] = duration;
+}
+
+void kvmppc_update_timing_stats(struct kvm_vcpu *vcpu)
+{
+	u64 exit = vcpu->arch.timing_last_exit;
+	u64 enter = vcpu->arch.timing_last_enter.tv64;
+
+	/* save exit time, used next exit when the reenter time is known */
+	vcpu->arch.timing_last_exit = vcpu->arch.timing_exit.tv64;
+
+	if (unlikely(vcpu->arch.last_exit_type == 0xDEAD || exit == 0))
+		return; /* skip incomplete cycle (e.g. after reset) */
+
+	/* update statistics for average and standard deviation */
+	add_exit_timing(vcpu, (enter - exit), vcpu->arch.last_exit_type);
+	/* enter -> timing_last_exit is time spent in guest - log this too */
+	add_exit_timing(vcpu, (vcpu->arch.timing_last_exit - enter),
+			TIMEINGUEST);
+}
+
+static const char *kvm_exit_names[__NUMBER_OF_KVM_EXIT_TYPES] = {
+	[MMIO_EXITS] = 			"MMIO",
+	[DCR_EXITS] =			"DCR",
+	[SIGNAL_EXITS] =		"SIGNAL",
+	[ITLB_REAL_MISS_EXITS] =	"ITLBREAL",
+	[ITLB_VIRT_MISS_EXITS] =	"ITLBVIRT",
+	[DTLB_REAL_MISS_EXITS] =	"DTLBREAL",
+	[DTLB_VIRT_MISS_EXITS] =	"DTLBVIRT",
+	[SYSCALL_EXITS] =		"SYSCALL",
+	[ISI_EXITS] =			"ISI",
+	[DSI_EXITS] =			"DSI",
+	[EMULATED_INST_EXITS] =		"EMULINST",
+	[EMULATED_MTMSRWE_EXITS] =	"EMUL_WAIT",
+	[EMULATED_WRTEE_EXITS] =	"EMUL_WRTEE",
+	[EMULATED_MTSPR_EXITS] =	"EMUL_MTSPR",
+	[EMULATED_MFSPR_EXITS] =	"EMUL_MFSPR",
+	[EMULATED_MTMSR_EXITS] =	"EMUL_MTMSR",
+	[EMULATED_MFMSR_EXITS] =	"EMUL_MFMSR",
+	[EMULATED_TLBSX_EXITS] =	"EMUL_TLBSX",
+	[EMULATED_TLBWE_EXITS] =	"EMUL_TLBWE",
+	[EMULATED_RFI_EXITS] =		"EMUL_RFI",
+	[DEC_EXITS] =			"DEC",
+	[EXT_INTR_EXITS] =		"EXTINT",
+	[HALT_WAKEUP] =			"HALT",
+	[USR_PR_INST] =			"USR_PR_INST",
+	[FP_UNAVAIL] =			"FP_UNAVAIL",
+	[DEBUG_EXITS] =			"DEBUG",
+	[TIMEINGUEST] =			"TIMEINGUEST"
+};
+
+static int kvmppc_exit_timing_show(struct seq_file *m, void *private)
+{
+	struct kvm_vcpu *vcpu = m->private;
+	int i;
+	u64 min, max;
+
+	for (i = 0; i < __NUMBER_OF_KVM_EXIT_TYPES; i++) {
+		if (vcpu->arch.timing_min_duration[i] == 0xFFFFFFFF)
+			min = 0;
+		else
+			min = vcpu->arch.timing_min_duration[i];
+		if (vcpu->arch.timing_max_duration[i] == 0)
+			max = 0;
+		else
+			max = vcpu->arch.timing_max_duration[i];
+
+		seq_printf(m, "%12s: count %10d min %10lld "
+			"max %10lld sum %20lld sum_quad %20lld\n",
+			kvm_exit_names[i], vcpu->arch.timing_count_type[i],
+			vcpu->arch.timing_min_duration[i],
+			vcpu->arch.timing_max_duration[i],
+			vcpu->arch.timing_sum_duration[i],
+			vcpu->arch.timing_sum_quad_duration[i]);
+	}
+	return 0;
+}
+
+static ssize_t kvmppc_exit_timing_write(struct file *file,
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	size_t len;
+	int err;
+	const char __user *p;
+	char c;
+
+	len = 0;
+	p = user_buf;
+	while (len < count) {
+		if (get_user(c, p++))
+			err = -EFAULT;
+		if (c == 0 || c == '\n')
+			break;
+		len++;
+	}
+
+	if (len > 1) {
+		err = -EINVAL;
+		goto done;
+	}
+
+	if (copy_from_user(&c, user_buf, sizeof(c))) {
+		err = -EFAULT;
+		goto done;
+	}
+
+	if (c == 'c') {
+		struct seq_file *seqf = (struct seq_file *)file->private_data;
+		struct kvm_vcpu *vcpu = seqf->private;
+		/* write does not affect out buffers previsously generated with
+		 * show. Seq file is locked here to prevent races of init with
+		 * a show call */
+		mutex_lock(&seqf->lock);
+		kvmppc_init_timing_stats(vcpu);
+		mutex_unlock(&seqf->lock);
+		err = count;
+	} else {
+		err = -EINVAL;
+		goto done;
+	}
+
+done:
+	return err;
+}
+
+static int kvmppc_exit_timing_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, kvmppc_exit_timing_show, inode->i_private);
+}
+
+static struct file_operations kvmppc_exit_timing_fops = {
+	.owner   = THIS_MODULE,
+	.open    = kvmppc_exit_timing_open,
+	.read    = seq_read,
+	.write   = kvmppc_exit_timing_write,
+	.llseek  = seq_lseek,
+	.release = single_release,
+};
+
+void kvmppc_create_vcpu_debugfs(struct kvm_vcpu *vcpu, unsigned int id)
+{
+	static char dbg_fname[50];
+	struct dentry *debugfs_file;
+
+	snprintf(dbg_fname, sizeof(dbg_fname), "vm%u_vcpu%03u_timing",
+		 current->pid, id);
+	debugfs_file = debugfs_create_file(dbg_fname, 0666,
+					kvm_debugfs_dir, vcpu,
+					&kvmppc_exit_timing_fops);
+
+	if (!debugfs_file) {
+		printk(KERN_ERR"%s: error creating debugfs file %s\n",
+			__func__, dbg_fname);
+		return;
+	}
+
+	vcpu->arch.debugfs_exit_timing = debugfs_file;
+}
+
+void kvmppc_remove_vcpu_debugfs(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.debugfs_exit_timing) {
+		debugfs_remove(vcpu->arch.debugfs_exit_timing);
+		vcpu->arch.debugfs_exit_timing = NULL;
+	}
+}
diff --git a/arch/powerpc/kvm/timing.h b/arch/powerpc/kvm/timing.h
new file mode 100644
index 0000000..1af7181
--- /dev/null
+++ b/arch/powerpc/kvm/timing.h
@@ -0,0 +1,102 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * Authors: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
+ */
+
+#ifndef __POWERPC_KVM_EXITTIMING_H__
+#define __POWERPC_KVM_EXITTIMING_H__
+
+#include <linux/kvm_host.h>
+#include <asm/kvm_host.h>
+
+#ifdef CONFIG_KVM_EXIT_TIMING
+void kvmppc_init_timing_stats(struct kvm_vcpu *vcpu);
+void kvmppc_update_timing_stats(struct kvm_vcpu *vcpu);
+void kvmppc_create_vcpu_debugfs(struct kvm_vcpu *vcpu, unsigned int id);
+void kvmppc_remove_vcpu_debugfs(struct kvm_vcpu *vcpu);
+
+static inline void kvmppc_set_exit_type(struct kvm_vcpu *vcpu, int type)
+{
+	vcpu->arch.last_exit_type = type;
+}
+
+#else
+/* if exit timing is not configured there is no need to build the c file */
+static inline void kvmppc_init_timing_stats(struct kvm_vcpu *vcpu) {}
+static inline void kvmppc_update_timing_stats(struct kvm_vcpu *vcpu) {}
+static inline void kvmppc_create_vcpu_debugfs(struct kvm_vcpu *vcpu,
+						unsigned int id) {}
+static inline void kvmppc_remove_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
+static inline void kvmppc_set_exit_type(struct kvm_vcpu *vcpu, int type) {}
+#endif /* CONFIG_KVM_EXIT_TIMING */
+
+/* account the exit in kvm_stats */
+static inline void account_exit_stat(struct kvm_vcpu *vcpu, int type)
+{
+	/* type has to be known at build time for optimization */
+	BUILD_BUG_ON(__builtin_constant_p(type));
+	switch (type) {
+	case EXT_INTR_EXITS:
+		vcpu->stat.ext_intr_exits++;
+		break;
+	case DEC_EXITS:
+		vcpu->stat.dec_exits++;
+		break;
+	case EMULATED_INST_EXITS:
+		vcpu->stat.emulated_inst_exits++;
+		break;
+	case DCR_EXITS:
+		vcpu->stat.dcr_exits++;
+		break;
+	case DSI_EXITS:
+		vcpu->stat.dsi_exits++;
+		break;
+	case ISI_EXITS:
+		vcpu->stat.isi_exits++;
+		break;
+	case SYSCALL_EXITS:
+		vcpu->stat.syscall_exits++;
+		break;
+	case DTLB_REAL_MISS_EXITS:
+		vcpu->stat.dtlb_real_miss_exits++;
+		break;
+	case DTLB_VIRT_MISS_EXITS:
+		vcpu->stat.dtlb_virt_miss_exits++;
+		break;
+	case MMIO_EXITS:
+		vcpu->stat.mmio_exits++;
+		break;
+	case ITLB_REAL_MISS_EXITS:
+		vcpu->stat.itlb_real_miss_exits++;
+		break;
+	case ITLB_VIRT_MISS_EXITS:
+		vcpu->stat.itlb_virt_miss_exits++;
+		break;
+	case SIGNAL_EXITS:
+		vcpu->stat.signal_exits++;
+		break;
+	}
+}
+
+/* wrapper to set exit time and account for it in kvm_stats */
+static inline void account_exit(struct kvm_vcpu *vcpu, int type)
+{
+	kvmppc_set_exit_type(vcpu, type);
+	account_exit_stat(vcpu, type);
+}
+
+#endif /* __POWERPC_KVM_EXITTIMING_H__ */
-- 
1.6.0.3

