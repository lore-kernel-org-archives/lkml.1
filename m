Return-Path: <linux-kernel-owner+w=401wt.eu-S1758688AbZB0K3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688AbZB0K3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757525AbZB0K1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:27:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53561 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325AbZB0K1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:08 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/37] KVM: ppc: split out common Book E instruction emulation
Date: Fri, 27 Feb 2009 12:26:27 +0200
Message-Id: <1235730420-7929-5-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

The Book E code will be shared with e500.

I've left PID in kvmppc_core_emulate_op() just so that we don't need to move
kvmppc_set_pid() right now. Once we have the e500 implementation, we can
probably share that too.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/44x_emulate.c   |  217 ++-----------------------------
 arch/powerpc/kvm/Makefile        |    1 +
 arch/powerpc/kvm/booke.h         |    6 +
 arch/powerpc/kvm/booke_emulate.c |  262 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 284 insertions(+), 202 deletions(-)
 create mode 100644 arch/powerpc/kvm/booke_emulate.c

diff --git a/arch/powerpc/kvm/44x_emulate.c b/arch/powerpc/kvm/44x_emulate.c
index 82489a7..61af58f 100644
--- a/arch/powerpc/kvm/44x_emulate.c
+++ b/arch/powerpc/kvm/44x_emulate.c
@@ -27,25 +27,12 @@
 #include "booke.h"
 #include "44x_tlb.h"
 
-#define OP_RFI      19
-
-#define XOP_RFI     50
-#define XOP_MFMSR   83
-#define XOP_WRTEE   131
-#define XOP_MTMSR   146
-#define XOP_WRTEEI  163
 #define XOP_MFDCR   323
 #define XOP_MTDCR   451
 #define XOP_TLBSX   914
 #define XOP_ICCCI   966
 #define XOP_TLBWE   978
 
-static void kvmppc_emul_rfi(struct kvm_vcpu *vcpu)
-{
-	vcpu->arch.pc = vcpu->arch.srr0;
-	kvmppc_set_msr(vcpu, vcpu->arch.srr1);
-}
-
 int kvmppc_core_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
                            unsigned int inst, int *advance)
 {
@@ -59,48 +46,9 @@ int kvmppc_core_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
 	int ws;
 
 	switch (get_op(inst)) {
-	case OP_RFI:
-		switch (get_xop(inst)) {
-		case XOP_RFI:
-			kvmppc_emul_rfi(vcpu);
-			kvmppc_set_exit_type(vcpu, EMULATED_RFI_EXITS);
-			*advance = 0;
-			break;
-
-		default:
-			emulated = EMULATE_FAIL;
-			break;
-		}
-		break;
-
 	case 31:
 		switch (get_xop(inst)) {
 
-		case XOP_MFMSR:
-			rt = get_rt(inst);
-			vcpu->arch.gpr[rt] = vcpu->arch.msr;
-			kvmppc_set_exit_type(vcpu, EMULATED_MFMSR_EXITS);
-			break;
-
-		case XOP_MTMSR:
-			rs = get_rs(inst);
-			kvmppc_set_exit_type(vcpu, EMULATED_MTMSR_EXITS);
-			kvmppc_set_msr(vcpu, vcpu->arch.gpr[rs]);
-			break;
-
-		case XOP_WRTEE:
-			rs = get_rs(inst);
-			vcpu->arch.msr = (vcpu->arch.msr & ~MSR_EE)
-							 | (vcpu->arch.gpr[rs] & MSR_EE);
-			kvmppc_set_exit_type(vcpu, EMULATED_WRTEE_EXITS);
-			break;
-
-		case XOP_WRTEEI:
-			vcpu->arch.msr = (vcpu->arch.msr & ~MSR_EE)
-							 | (inst & MSR_EE);
-			kvmppc_set_exit_type(vcpu, EMULATED_WRTEE_EXITS);
-			break;
-
 		case XOP_MFDCR:
 			dcrn = get_dcrn(inst);
 			rt = get_rt(inst);
@@ -186,186 +134,51 @@ int kvmppc_core_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		emulated = EMULATE_FAIL;
 	}
 
+	if (emulated == EMULATE_FAIL)
+		emulated = kvmppc_booke_emulate_op(run, vcpu, inst, advance);
+
 	return emulated;
 }
 
 int kvmppc_core_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, int rs)
 {
+	int emulated = EMULATE_DONE;
+
 	switch (sprn) {
-	case SPRN_MMUCR:
-		vcpu->arch.mmucr = vcpu->arch.gpr[rs]; break;
 	case SPRN_PID:
 		kvmppc_set_pid(vcpu, vcpu->arch.gpr[rs]); break;
+	case SPRN_MMUCR:
+		vcpu->arch.mmucr = vcpu->arch.gpr[rs]; break;
 	case SPRN_CCR0:
 		vcpu->arch.ccr0 = vcpu->arch.gpr[rs]; break;
 	case SPRN_CCR1:
 		vcpu->arch.ccr1 = vcpu->arch.gpr[rs]; break;
-	case SPRN_DEAR:
-		vcpu->arch.dear = vcpu->arch.gpr[rs]; break;
-	case SPRN_ESR:
-		vcpu->arch.esr = vcpu->arch.gpr[rs]; break;
-	case SPRN_DBCR0:
-		vcpu->arch.dbcr0 = vcpu->arch.gpr[rs]; break;
-	case SPRN_DBCR1:
-		vcpu->arch.dbcr1 = vcpu->arch.gpr[rs]; break;
-	case SPRN_TSR:
-		vcpu->arch.tsr &= ~vcpu->arch.gpr[rs]; break;
-	case SPRN_TCR:
-		vcpu->arch.tcr = vcpu->arch.gpr[rs];
-		kvmppc_emulate_dec(vcpu);
-		break;
-
-	/* Note: SPRG4-7 are user-readable. These values are
-	 * loaded into the real SPRGs when resuming the
-	 * guest. */
-	case SPRN_SPRG4:
-		vcpu->arch.sprg4 = vcpu->arch.gpr[rs]; break;
-	case SPRN_SPRG5:
-		vcpu->arch.sprg5 = vcpu->arch.gpr[rs]; break;
-	case SPRN_SPRG6:
-		vcpu->arch.sprg6 = vcpu->arch.gpr[rs]; break;
-	case SPRN_SPRG7:
-		vcpu->arch.sprg7 = vcpu->arch.gpr[rs]; break;
-
-	case SPRN_IVPR:
-		vcpu->arch.ivpr = vcpu->arch.gpr[rs];
-		break;
-	case SPRN_IVOR0:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_CRITICAL] = vcpu->arch.gpr[rs];
-		break;
-	case SPRN_IVOR1:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_MACHINE_CHECK] = vcpu->arch.gpr[rs];
-		break;
-	case SPRN_IVOR2:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_DATA_STORAGE] = vcpu->arch.gpr[rs];
-		break;
-	case SPRN_IVOR3:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_INST_STORAGE] = vcpu->arch.gpr[rs];
-		break;
-	case SPRN_IVOR4:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_EXTERNAL] = vcpu->arch.gpr[rs];
-		break;
-	case SPRN_IVOR5:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_ALIGNMENT] = vcpu->arch.gpr[rs];
-		break;
-	case SPRN_IVOR6:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_PROGRAM] = vcpu->arch.gpr[rs];
-		break;
-	case SPRN_IVOR7:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_FP_UNAVAIL] = vcpu->arch.gpr[rs];
-		break;
-	case SPRN_IVOR8:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_SYSCALL] = vcpu->arch.gpr[rs];
-		break;
-	case SPRN_IVOR9:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_AP_UNAVAIL] = vcpu->arch.gpr[rs];
-		break;
-	case SPRN_IVOR10:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_DECREMENTER] = vcpu->arch.gpr[rs];
-		break;
-	case SPRN_IVOR11:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_FIT] = vcpu->arch.gpr[rs];
-		break;
-	case SPRN_IVOR12:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_WATCHDOG] = vcpu->arch.gpr[rs];
-		break;
-	case SPRN_IVOR13:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_DTLB_MISS] = vcpu->arch.gpr[rs];
-		break;
-	case SPRN_IVOR14:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_ITLB_MISS] = vcpu->arch.gpr[rs];
-		break;
-	case SPRN_IVOR15:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_DEBUG] = vcpu->arch.gpr[rs];
-		break;
-
 	default:
-		return EMULATE_FAIL;
+		emulated = kvmppc_booke_emulate_mtspr(vcpu, sprn, rs);
 	}
 
 	kvmppc_set_exit_type(vcpu, EMULATED_MTSPR_EXITS);
-	return EMULATE_DONE;
+	return emulated;
 }
 
 int kvmppc_core_emulate_mfspr(struct kvm_vcpu *vcpu, int sprn, int rt)
 {
+	int emulated = EMULATE_DONE;
+
 	switch (sprn) {
-	/* 440 */
+	case SPRN_PID:
+		vcpu->arch.gpr[rt] = vcpu->arch.pid; break;
 	case SPRN_MMUCR:
 		vcpu->arch.gpr[rt] = vcpu->arch.mmucr; break;
 	case SPRN_CCR0:
 		vcpu->arch.gpr[rt] = vcpu->arch.ccr0; break;
 	case SPRN_CCR1:
 		vcpu->arch.gpr[rt] = vcpu->arch.ccr1; break;
-
-	/* Book E */
-	case SPRN_PID:
-		vcpu->arch.gpr[rt] = vcpu->arch.pid; break;
-	case SPRN_IVPR:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivpr; break;
-	case SPRN_DEAR:
-		vcpu->arch.gpr[rt] = vcpu->arch.dear; break;
-	case SPRN_ESR:
-		vcpu->arch.gpr[rt] = vcpu->arch.esr; break;
-	case SPRN_DBCR0:
-		vcpu->arch.gpr[rt] = vcpu->arch.dbcr0; break;
-	case SPRN_DBCR1:
-		vcpu->arch.gpr[rt] = vcpu->arch.dbcr1; break;
-
-	case SPRN_IVOR0:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_CRITICAL];
-		break;
-	case SPRN_IVOR1:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_MACHINE_CHECK];
-		break;
-	case SPRN_IVOR2:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_DATA_STORAGE];
-		break;
-	case SPRN_IVOR3:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_INST_STORAGE];
-		break;
-	case SPRN_IVOR4:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_EXTERNAL];
-		break;
-	case SPRN_IVOR5:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_ALIGNMENT];
-		break;
-	case SPRN_IVOR6:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_PROGRAM];
-		break;
-	case SPRN_IVOR7:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_FP_UNAVAIL];
-		break;
-	case SPRN_IVOR8:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_SYSCALL];
-		break;
-	case SPRN_IVOR9:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_AP_UNAVAIL];
-		break;
-	case SPRN_IVOR10:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_DECREMENTER];
-		break;
-	case SPRN_IVOR11:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_FIT];
-		break;
-	case SPRN_IVOR12:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_WATCHDOG];
-		break;
-	case SPRN_IVOR13:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_DTLB_MISS];
-		break;
-	case SPRN_IVOR14:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_ITLB_MISS];
-		break;
-	case SPRN_IVOR15:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_DEBUG];
-		break;
-
 	default:
-		return EMULATE_FAIL;
+		emulated = kvmppc_booke_emulate_mfspr(vcpu, sprn, rt);
 	}
 
 	kvmppc_set_exit_type(vcpu, EMULATED_MFSPR_EXITS);
-	return EMULATE_DONE;
+	return emulated;
 }
 
diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
index df7ba59..3ef5261 100644
--- a/arch/powerpc/kvm/Makefile
+++ b/arch/powerpc/kvm/Makefile
@@ -16,6 +16,7 @@ AFLAGS_booke_interrupts.o := -I$(obj)
 
 kvm-440-objs := \
 	booke.o \
+	booke_emulate.o \
 	booke_interrupts.o \
 	44x.o \
 	44x_tlb.o \
diff --git a/arch/powerpc/kvm/booke.h b/arch/powerpc/kvm/booke.h
index cf7c94c..311fdbc 100644
--- a/arch/powerpc/kvm/booke.h
+++ b/arch/powerpc/kvm/booke.h
@@ -22,6 +22,7 @@
 
 #include <linux/types.h>
 #include <linux/kvm_host.h>
+#include <asm/kvm_ppc.h>
 #include "timing.h"
 
 /* interrupt priortity ordering */
@@ -57,4 +58,9 @@ static inline void kvmppc_set_msr(struct kvm_vcpu *vcpu, u32 new_msr)
 	};
 }
 
+int kvmppc_booke_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
+                            unsigned int inst, int *advance);
+int kvmppc_booke_emulate_mfspr(struct kvm_vcpu *vcpu, int sprn, int rt);
+int kvmppc_booke_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, int rs);
+
 #endif /* __KVM_BOOKE_H__ */
diff --git a/arch/powerpc/kvm/booke_emulate.c b/arch/powerpc/kvm/booke_emulate.c
new file mode 100644
index 0000000..8aa78f1
--- /dev/null
+++ b/arch/powerpc/kvm/booke_emulate.c
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
+ * Copyright IBM Corp. 2008
+ *
+ * Authors: Hollis Blanchard <hollisb@us.ibm.com>
+ */
+
+#include <linux/kvm_host.h>
+#include <asm/disassemble.h>
+
+#include "booke.h"
+
+#define OP_19_XOP_RFI     50
+
+#define OP_31_XOP_MFMSR   83
+#define OP_31_XOP_WRTEE   131
+#define OP_31_XOP_MTMSR   146
+#define OP_31_XOP_WRTEEI  163
+
+static void kvmppc_emul_rfi(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.pc = vcpu->arch.srr0;
+	kvmppc_set_msr(vcpu, vcpu->arch.srr1);
+}
+
+int kvmppc_booke_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
+                            unsigned int inst, int *advance)
+{
+	int emulated = EMULATE_DONE;
+	int rs;
+	int rt;
+
+	switch (get_op(inst)) {
+	case 19:
+		switch (get_xop(inst)) {
+		case OP_19_XOP_RFI:
+			kvmppc_emul_rfi(vcpu);
+			kvmppc_set_exit_type(vcpu, EMULATED_RFI_EXITS);
+			*advance = 0;
+			break;
+
+		default:
+			emulated = EMULATE_FAIL;
+			break;
+		}
+		break;
+
+	case 31:
+		switch (get_xop(inst)) {
+
+		case OP_31_XOP_MFMSR:
+			rt = get_rt(inst);
+			vcpu->arch.gpr[rt] = vcpu->arch.msr;
+			kvmppc_set_exit_type(vcpu, EMULATED_MFMSR_EXITS);
+			break;
+
+		case OP_31_XOP_MTMSR:
+			rs = get_rs(inst);
+			kvmppc_set_exit_type(vcpu, EMULATED_MTMSR_EXITS);
+			kvmppc_set_msr(vcpu, vcpu->arch.gpr[rs]);
+			break;
+
+		case OP_31_XOP_WRTEE:
+			rs = get_rs(inst);
+			vcpu->arch.msr = (vcpu->arch.msr & ~MSR_EE)
+							 | (vcpu->arch.gpr[rs] & MSR_EE);
+			kvmppc_set_exit_type(vcpu, EMULATED_WRTEE_EXITS);
+			break;
+
+		case OP_31_XOP_WRTEEI:
+			vcpu->arch.msr = (vcpu->arch.msr & ~MSR_EE)
+							 | (inst & MSR_EE);
+			kvmppc_set_exit_type(vcpu, EMULATED_WRTEE_EXITS);
+			break;
+
+		default:
+			emulated = EMULATE_FAIL;
+		}
+
+		break;
+
+	default:
+		emulated = EMULATE_FAIL;
+	}
+
+	return emulated;
+}
+
+int kvmppc_booke_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, int rs)
+{
+	int emulated = EMULATE_DONE;
+
+	switch (sprn) {
+	case SPRN_DEAR:
+		vcpu->arch.dear = vcpu->arch.gpr[rs]; break;
+	case SPRN_ESR:
+		vcpu->arch.esr = vcpu->arch.gpr[rs]; break;
+	case SPRN_DBCR0:
+		vcpu->arch.dbcr0 = vcpu->arch.gpr[rs]; break;
+	case SPRN_DBCR1:
+		vcpu->arch.dbcr1 = vcpu->arch.gpr[rs]; break;
+	case SPRN_TSR:
+		vcpu->arch.tsr &= ~vcpu->arch.gpr[rs]; break;
+	case SPRN_TCR:
+		vcpu->arch.tcr = vcpu->arch.gpr[rs];
+		kvmppc_emulate_dec(vcpu);
+		break;
+
+	/* Note: SPRG4-7 are user-readable. These values are
+	 * loaded into the real SPRGs when resuming the
+	 * guest. */
+	case SPRN_SPRG4:
+		vcpu->arch.sprg4 = vcpu->arch.gpr[rs]; break;
+	case SPRN_SPRG5:
+		vcpu->arch.sprg5 = vcpu->arch.gpr[rs]; break;
+	case SPRN_SPRG6:
+		vcpu->arch.sprg6 = vcpu->arch.gpr[rs]; break;
+	case SPRN_SPRG7:
+		vcpu->arch.sprg7 = vcpu->arch.gpr[rs]; break;
+
+	case SPRN_IVPR:
+		vcpu->arch.ivpr = vcpu->arch.gpr[rs];
+		break;
+	case SPRN_IVOR0:
+		vcpu->arch.ivor[BOOKE_IRQPRIO_CRITICAL] = vcpu->arch.gpr[rs];
+		break;
+	case SPRN_IVOR1:
+		vcpu->arch.ivor[BOOKE_IRQPRIO_MACHINE_CHECK] = vcpu->arch.gpr[rs];
+		break;
+	case SPRN_IVOR2:
+		vcpu->arch.ivor[BOOKE_IRQPRIO_DATA_STORAGE] = vcpu->arch.gpr[rs];
+		break;
+	case SPRN_IVOR3:
+		vcpu->arch.ivor[BOOKE_IRQPRIO_INST_STORAGE] = vcpu->arch.gpr[rs];
+		break;
+	case SPRN_IVOR4:
+		vcpu->arch.ivor[BOOKE_IRQPRIO_EXTERNAL] = vcpu->arch.gpr[rs];
+		break;
+	case SPRN_IVOR5:
+		vcpu->arch.ivor[BOOKE_IRQPRIO_ALIGNMENT] = vcpu->arch.gpr[rs];
+		break;
+	case SPRN_IVOR6:
+		vcpu->arch.ivor[BOOKE_IRQPRIO_PROGRAM] = vcpu->arch.gpr[rs];
+		break;
+	case SPRN_IVOR7:
+		vcpu->arch.ivor[BOOKE_IRQPRIO_FP_UNAVAIL] = vcpu->arch.gpr[rs];
+		break;
+	case SPRN_IVOR8:
+		vcpu->arch.ivor[BOOKE_IRQPRIO_SYSCALL] = vcpu->arch.gpr[rs];
+		break;
+	case SPRN_IVOR9:
+		vcpu->arch.ivor[BOOKE_IRQPRIO_AP_UNAVAIL] = vcpu->arch.gpr[rs];
+		break;
+	case SPRN_IVOR10:
+		vcpu->arch.ivor[BOOKE_IRQPRIO_DECREMENTER] = vcpu->arch.gpr[rs];
+		break;
+	case SPRN_IVOR11:
+		vcpu->arch.ivor[BOOKE_IRQPRIO_FIT] = vcpu->arch.gpr[rs];
+		break;
+	case SPRN_IVOR12:
+		vcpu->arch.ivor[BOOKE_IRQPRIO_WATCHDOG] = vcpu->arch.gpr[rs];
+		break;
+	case SPRN_IVOR13:
+		vcpu->arch.ivor[BOOKE_IRQPRIO_DTLB_MISS] = vcpu->arch.gpr[rs];
+		break;
+	case SPRN_IVOR14:
+		vcpu->arch.ivor[BOOKE_IRQPRIO_ITLB_MISS] = vcpu->arch.gpr[rs];
+		break;
+	case SPRN_IVOR15:
+		vcpu->arch.ivor[BOOKE_IRQPRIO_DEBUG] = vcpu->arch.gpr[rs];
+		break;
+
+	default:
+		emulated = EMULATE_FAIL;
+	}
+
+	return emulated;
+}
+
+int kvmppc_booke_emulate_mfspr(struct kvm_vcpu *vcpu, int sprn, int rt)
+{
+	int emulated = EMULATE_DONE;
+
+	switch (sprn) {
+	case SPRN_IVPR:
+		vcpu->arch.gpr[rt] = vcpu->arch.ivpr; break;
+	case SPRN_DEAR:
+		vcpu->arch.gpr[rt] = vcpu->arch.dear; break;
+	case SPRN_ESR:
+		vcpu->arch.gpr[rt] = vcpu->arch.esr; break;
+	case SPRN_DBCR0:
+		vcpu->arch.gpr[rt] = vcpu->arch.dbcr0; break;
+	case SPRN_DBCR1:
+		vcpu->arch.gpr[rt] = vcpu->arch.dbcr1; break;
+
+	case SPRN_IVOR0:
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_CRITICAL];
+		break;
+	case SPRN_IVOR1:
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_MACHINE_CHECK];
+		break;
+	case SPRN_IVOR2:
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_DATA_STORAGE];
+		break;
+	case SPRN_IVOR3:
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_INST_STORAGE];
+		break;
+	case SPRN_IVOR4:
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_EXTERNAL];
+		break;
+	case SPRN_IVOR5:
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_ALIGNMENT];
+		break;
+	case SPRN_IVOR6:
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_PROGRAM];
+		break;
+	case SPRN_IVOR7:
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_FP_UNAVAIL];
+		break;
+	case SPRN_IVOR8:
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_SYSCALL];
+		break;
+	case SPRN_IVOR9:
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_AP_UNAVAIL];
+		break;
+	case SPRN_IVOR10:
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_DECREMENTER];
+		break;
+	case SPRN_IVOR11:
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_FIT];
+		break;
+	case SPRN_IVOR12:
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_WATCHDOG];
+		break;
+	case SPRN_IVOR13:
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_DTLB_MISS];
+		break;
+	case SPRN_IVOR14:
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_ITLB_MISS];
+		break;
+	case SPRN_IVOR15:
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_DEBUG];
+		break;
+
+	default:
+		emulated = EMULATE_FAIL;
+	}
+
+	return emulated;
+}
-- 
1.6.0.6

