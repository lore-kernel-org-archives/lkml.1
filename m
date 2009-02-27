Return-Path: <linux-kernel-owner+w=401wt.eu-S1758521AbZB0K3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbZB0K3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757408AbZB0K1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:27:17 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53560 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322AbZB0K1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:08 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/37] KVM: ppc: use macros instead of hardcoded literals for instruction decoding
Date: Fri, 27 Feb 2009 12:26:26 +0200
Message-Id: <1235730420-7929-4-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/emulate.c |   93 +++++++++++++++++++++++++++++--------------
 1 files changed, 63 insertions(+), 30 deletions(-)

diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
index d1d38da..a561d6e 100644
--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -30,6 +30,39 @@
 #include <asm/disassemble.h>
 #include "timing.h"
 
+#define OP_TRAP 3
+
+#define OP_31_XOP_LWZX      23
+#define OP_31_XOP_LBZX      87
+#define OP_31_XOP_STWX      151
+#define OP_31_XOP_STBX      215
+#define OP_31_XOP_STBUX     247
+#define OP_31_XOP_LHZX      279
+#define OP_31_XOP_LHZUX     311
+#define OP_31_XOP_MFSPR     339
+#define OP_31_XOP_STHX      407
+#define OP_31_XOP_STHUX     439
+#define OP_31_XOP_MTSPR     467
+#define OP_31_XOP_DCBI      470
+#define OP_31_XOP_LWBRX     534
+#define OP_31_XOP_TLBSYNC   566
+#define OP_31_XOP_STWBRX    662
+#define OP_31_XOP_LHBRX     790
+#define OP_31_XOP_STHBRX    918
+
+#define OP_LWZ  32
+#define OP_LWZU 33
+#define OP_LBZ  34
+#define OP_LBZU 35
+#define OP_STW  36
+#define OP_STWU 37
+#define OP_STB  38
+#define OP_STBU 39
+#define OP_LHZ  40
+#define OP_LHZU 41
+#define OP_STH  44
+#define OP_STHU 45
+
 void kvmppc_emulate_dec(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->arch.tcr & TCR_DIE) {
@@ -78,7 +111,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 	kvmppc_set_exit_type(vcpu, EMULATED_INST_EXITS);
 
 	switch (get_op(inst)) {
-	case 3:                                             /* trap */
+	case OP_TRAP:
 		vcpu->arch.esr |= ESR_PTR;
 		kvmppc_core_queue_program(vcpu);
 		advance = 0;
@@ -87,31 +120,31 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 	case 31:
 		switch (get_xop(inst)) {
 
-		case 23:                                        /* lwzx */
+		case OP_31_XOP_LWZX:
 			rt = get_rt(inst);
 			emulated = kvmppc_handle_load(run, vcpu, rt, 4, 1);
 			break;
 
-		case 87:                                        /* lbzx */
+		case OP_31_XOP_LBZX:
 			rt = get_rt(inst);
 			emulated = kvmppc_handle_load(run, vcpu, rt, 1, 1);
 			break;
 
-		case 151:                                       /* stwx */
+		case OP_31_XOP_STWX:
 			rs = get_rs(inst);
 			emulated = kvmppc_handle_store(run, vcpu,
 			                               vcpu->arch.gpr[rs],
 			                               4, 1);
 			break;
 
-		case 215:                                       /* stbx */
+		case OP_31_XOP_STBX:
 			rs = get_rs(inst);
 			emulated = kvmppc_handle_store(run, vcpu,
 			                               vcpu->arch.gpr[rs],
 			                               1, 1);
 			break;
 
-		case 247:                                       /* stbux */
+		case OP_31_XOP_STBUX:
 			rs = get_rs(inst);
 			ra = get_ra(inst);
 			rb = get_rb(inst);
@@ -126,12 +159,12 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 			vcpu->arch.gpr[rs] = ea;
 			break;
 
-		case 279:                                       /* lhzx */
+		case OP_31_XOP_LHZX:
 			rt = get_rt(inst);
 			emulated = kvmppc_handle_load(run, vcpu, rt, 2, 1);
 			break;
 
-		case 311:                                       /* lhzux */
+		case OP_31_XOP_LHZUX:
 			rt = get_rt(inst);
 			ra = get_ra(inst);
 			rb = get_rb(inst);
@@ -144,7 +177,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 			vcpu->arch.gpr[ra] = ea;
 			break;
 
-		case 339:                                       /* mfspr */
+		case OP_31_XOP_MFSPR:
 			sprn = get_sprn(inst);
 			rt = get_rt(inst);
 
@@ -185,7 +218,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 			}
 			break;
 
-		case 407:                                       /* sthx */
+		case OP_31_XOP_STHX:
 			rs = get_rs(inst);
 			ra = get_ra(inst);
 			rb = get_rb(inst);
@@ -195,7 +228,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 			                               2, 1);
 			break;
 
-		case 439:                                       /* sthux */
+		case OP_31_XOP_STHUX:
 			rs = get_rs(inst);
 			ra = get_ra(inst);
 			rb = get_rb(inst);
@@ -210,7 +243,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 			vcpu->arch.gpr[ra] = ea;
 			break;
 
-		case 467:                                       /* mtspr */
+		case OP_31_XOP_MTSPR:
 			sprn = get_sprn(inst);
 			rs = get_rs(inst);
 			switch (sprn) {
@@ -246,7 +279,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 			}
 			break;
 
-		case 470:                                       /* dcbi */
+		case OP_31_XOP_DCBI:
 			/* Do nothing. The guest is performing dcbi because
 			 * hardware DMA is not snooped by the dcache, but
 			 * emulated DMA either goes through the dcache as
@@ -254,15 +287,15 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 			 * coherence. */
 			break;
 
-		case 534:                                       /* lwbrx */
+		case OP_31_XOP_LWBRX:
 			rt = get_rt(inst);
 			emulated = kvmppc_handle_load(run, vcpu, rt, 4, 0);
 			break;
 
-		case 566:                                       /* tlbsync */
+		case OP_31_XOP_TLBSYNC:
 			break;
 
-		case 662:                                       /* stwbrx */
+		case OP_31_XOP_STWBRX:
 			rs = get_rs(inst);
 			ra = get_ra(inst);
 			rb = get_rb(inst);
@@ -272,12 +305,12 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 			                               4, 0);
 			break;
 
-		case 790:                                       /* lhbrx */
+		case OP_31_XOP_LHBRX:
 			rt = get_rt(inst);
 			emulated = kvmppc_handle_load(run, vcpu, rt, 2, 0);
 			break;
 
-		case 918:                                       /* sthbrx */
+		case OP_31_XOP_STHBRX:
 			rs = get_rs(inst);
 			ra = get_ra(inst);
 			rb = get_rb(inst);
@@ -293,37 +326,37 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 		}
 		break;
 
-	case 32:                                                /* lwz */
+	case OP_LWZ:
 		rt = get_rt(inst);
 		emulated = kvmppc_handle_load(run, vcpu, rt, 4, 1);
 		break;
 
-	case 33:                                                /* lwzu */
+	case OP_LWZU:
 		ra = get_ra(inst);
 		rt = get_rt(inst);
 		emulated = kvmppc_handle_load(run, vcpu, rt, 4, 1);
 		vcpu->arch.gpr[ra] = vcpu->arch.paddr_accessed;
 		break;
 
-	case 34:                                                /* lbz */
+	case OP_LBZ:
 		rt = get_rt(inst);
 		emulated = kvmppc_handle_load(run, vcpu, rt, 1, 1);
 		break;
 
-	case 35:                                                /* lbzu */
+	case OP_LBZU:
 		ra = get_ra(inst);
 		rt = get_rt(inst);
 		emulated = kvmppc_handle_load(run, vcpu, rt, 1, 1);
 		vcpu->arch.gpr[ra] = vcpu->arch.paddr_accessed;
 		break;
 
-	case 36:                                                /* stw */
+	case OP_STW:
 		rs = get_rs(inst);
 		emulated = kvmppc_handle_store(run, vcpu, vcpu->arch.gpr[rs],
 		                               4, 1);
 		break;
 
-	case 37:                                                /* stwu */
+	case OP_STWU:
 		ra = get_ra(inst);
 		rs = get_rs(inst);
 		emulated = kvmppc_handle_store(run, vcpu, vcpu->arch.gpr[rs],
@@ -331,13 +364,13 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 		vcpu->arch.gpr[ra] = vcpu->arch.paddr_accessed;
 		break;
 
-	case 38:                                                /* stb */
+	case OP_STB:
 		rs = get_rs(inst);
 		emulated = kvmppc_handle_store(run, vcpu, vcpu->arch.gpr[rs],
 		                               1, 1);
 		break;
 
-	case 39:                                                /* stbu */
+	case OP_STBU:
 		ra = get_ra(inst);
 		rs = get_rs(inst);
 		emulated = kvmppc_handle_store(run, vcpu, vcpu->arch.gpr[rs],
@@ -345,25 +378,25 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 		vcpu->arch.gpr[ra] = vcpu->arch.paddr_accessed;
 		break;
 
-	case 40:                                                /* lhz */
+	case OP_LHZ:
 		rt = get_rt(inst);
 		emulated = kvmppc_handle_load(run, vcpu, rt, 2, 1);
 		break;
 
-	case 41:                                                /* lhzu */
+	case OP_LHZU:
 		ra = get_ra(inst);
 		rt = get_rt(inst);
 		emulated = kvmppc_handle_load(run, vcpu, rt, 2, 1);
 		vcpu->arch.gpr[ra] = vcpu->arch.paddr_accessed;
 		break;
 
-	case 44:                                                /* sth */
+	case OP_STH:
 		rs = get_rs(inst);
 		emulated = kvmppc_handle_store(run, vcpu, vcpu->arch.gpr[rs],
 		                               2, 1);
 		break;
 
-	case 45:                                                /* sthu */
+	case OP_STHU:
 		ra = get_ra(inst);
 		rs = get_rs(inst);
 		emulated = kvmppc_handle_store(run, vcpu, vcpu->arch.gpr[rs],
-- 
1.6.0.6

