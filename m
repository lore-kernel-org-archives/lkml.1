Return-Path: <linux-kernel-owner+w=401wt.eu-S1760495AbZB0KkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760495AbZB0KkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:40:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758215AbZB0K2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:28:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53570 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881AbZB0K1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:09 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/37] KVM: ppc: Add extra E500 exceptions
Date: Fri, 27 Feb 2009 12:26:34 +0200
Message-Id: <1235730420-7929-12-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

e500 has additional interrupt vectors (and corresponding IVORs) for SPE and
performance monitoring interrupts.

Signed-off-by: Liu Yu <yu.liu@freescale.com>
Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_asm.h  |    7 ++++++-
 arch/powerpc/include/asm/kvm_host.h |    2 +-
 arch/powerpc/kvm/booke.c            |   18 ++++++++++++++++++
 arch/powerpc/kvm/booke.h            |   30 ++++++++++++++++++------------
 arch/powerpc/kvm/booke_interrupts.S |    3 +++
 arch/powerpc/kvm/e500.c             |   20 +++++++++++++++++++-
 arch/powerpc/kvm/e500_emulate.c     |   27 +++++++++++++++++++++++++++
 7 files changed, 92 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_asm.h b/arch/powerpc/include/asm/kvm_asm.h
index 2197764..56bfae5 100644
--- a/arch/powerpc/include/asm/kvm_asm.h
+++ b/arch/powerpc/include/asm/kvm_asm.h
@@ -42,7 +42,12 @@
 #define BOOKE_INTERRUPT_DTLB_MISS 13
 #define BOOKE_INTERRUPT_ITLB_MISS 14
 #define BOOKE_INTERRUPT_DEBUG 15
-#define BOOKE_MAX_INTERRUPT 15
+
+/* E500 */
+#define BOOKE_INTERRUPT_SPE_UNAVAIL 32
+#define BOOKE_INTERRUPT_SPE_FP_DATA 33
+#define BOOKE_INTERRUPT_SPE_FP_ROUND 34
+#define BOOKE_INTERRUPT_PERFORMANCE_MONITOR 35
 
 #define RESUME_FLAG_NV          (1<<0)  /* Reload guest nonvolatile state? */
 #define RESUME_FLAG_HOST        (1<<1)  /* Resume host? */
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 50e5ce1..1c61876 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -150,7 +150,7 @@ struct kvm_vcpu_arch {
 	u32 tbu;
 	u32 tcr;
 	u32 tsr;
-	u32 ivor[16];
+	u32 ivor[64];
 	ulong ivpr;
 	u32 pir;
 
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index f192fbe..642e420 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -118,6 +118,9 @@ static int kvmppc_booke_irqprio_deliver(struct kvm_vcpu *vcpu,
 	case BOOKE_IRQPRIO_DATA_STORAGE:
 	case BOOKE_IRQPRIO_INST_STORAGE:
 	case BOOKE_IRQPRIO_FP_UNAVAIL:
+	case BOOKE_IRQPRIO_SPE_UNAVAIL:
+	case BOOKE_IRQPRIO_SPE_FP_DATA:
+	case BOOKE_IRQPRIO_SPE_FP_ROUND:
 	case BOOKE_IRQPRIO_AP_UNAVAIL:
 	case BOOKE_IRQPRIO_ALIGNMENT:
 		allowed = 1;
@@ -261,6 +264,21 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		r = RESUME_GUEST;
 		break;
 
+	case BOOKE_INTERRUPT_SPE_UNAVAIL:
+		kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_SPE_UNAVAIL);
+		r = RESUME_GUEST;
+		break;
+
+	case BOOKE_INTERRUPT_SPE_FP_DATA:
+		kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_SPE_FP_DATA);
+		r = RESUME_GUEST;
+		break;
+
+	case BOOKE_INTERRUPT_SPE_FP_ROUND:
+		kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_SPE_FP_ROUND);
+		r = RESUME_GUEST;
+		break;
+
 	case BOOKE_INTERRUPT_DATA_STORAGE:
 		vcpu->arch.dear = vcpu->arch.fault_dear;
 		vcpu->arch.esr = vcpu->arch.fault_esr;
diff --git a/arch/powerpc/kvm/booke.h b/arch/powerpc/kvm/booke.h
index 7ceeb3e..d59bcca 100644
--- a/arch/powerpc/kvm/booke.h
+++ b/arch/powerpc/kvm/booke.h
@@ -31,18 +31,24 @@
 #define BOOKE_IRQPRIO_ALIGNMENT 2
 #define BOOKE_IRQPRIO_PROGRAM 3
 #define BOOKE_IRQPRIO_FP_UNAVAIL 4
-#define BOOKE_IRQPRIO_SYSCALL 5
-#define BOOKE_IRQPRIO_AP_UNAVAIL 6
-#define BOOKE_IRQPRIO_DTLB_MISS 7
-#define BOOKE_IRQPRIO_ITLB_MISS 8
-#define BOOKE_IRQPRIO_MACHINE_CHECK 9
-#define BOOKE_IRQPRIO_DEBUG 10
-#define BOOKE_IRQPRIO_CRITICAL 11
-#define BOOKE_IRQPRIO_WATCHDOG 12
-#define BOOKE_IRQPRIO_EXTERNAL 13
-#define BOOKE_IRQPRIO_FIT 14
-#define BOOKE_IRQPRIO_DECREMENTER 15
-#define BOOKE_IRQPRIO_MAX 15
+#define BOOKE_IRQPRIO_SPE_UNAVAIL 5
+#define BOOKE_IRQPRIO_SPE_FP_DATA 6
+#define BOOKE_IRQPRIO_SPE_FP_ROUND 7
+#define BOOKE_IRQPRIO_SYSCALL 8
+#define BOOKE_IRQPRIO_AP_UNAVAIL 9
+#define BOOKE_IRQPRIO_DTLB_MISS 10
+#define BOOKE_IRQPRIO_ITLB_MISS 11
+#define BOOKE_IRQPRIO_MACHINE_CHECK 12
+#define BOOKE_IRQPRIO_DEBUG 13
+#define BOOKE_IRQPRIO_CRITICAL 14
+#define BOOKE_IRQPRIO_WATCHDOG 15
+#define BOOKE_IRQPRIO_EXTERNAL 16
+#define BOOKE_IRQPRIO_FIT 17
+#define BOOKE_IRQPRIO_DECREMENTER 18
+#define BOOKE_IRQPRIO_PERFORMANCE_MONITOR 19
+#define BOOKE_IRQPRIO_MAX 19
+
+extern unsigned long kvmppc_booke_handlers;
 
 /* Helper function for "full" MSR writes. No need to call this if only EE is
  * changing. */
diff --git a/arch/powerpc/kvm/booke_interrupts.S b/arch/powerpc/kvm/booke_interrupts.S
index 4679ec2..d0c6f84 100644
--- a/arch/powerpc/kvm/booke_interrupts.S
+++ b/arch/powerpc/kvm/booke_interrupts.S
@@ -86,6 +86,9 @@ KVM_HANDLER BOOKE_INTERRUPT_WATCHDOG
 KVM_HANDLER BOOKE_INTERRUPT_DTLB_MISS
 KVM_HANDLER BOOKE_INTERRUPT_ITLB_MISS
 KVM_HANDLER BOOKE_INTERRUPT_DEBUG
+KVM_HANDLER BOOKE_INTERRUPT_SPE_UNAVAIL
+KVM_HANDLER BOOKE_INTERRUPT_SPE_FP_DATA
+KVM_HANDLER BOOKE_INTERRUPT_SPE_FP_ROUND
 
 _GLOBAL(kvmppc_handler_len)
 	.long kvmppc_handler_1 - kvmppc_handler_0
diff --git a/arch/powerpc/kvm/e500.c b/arch/powerpc/kvm/e500.c
index 7992da4..d8067fd 100644
--- a/arch/powerpc/kvm/e500.c
+++ b/arch/powerpc/kvm/e500.c
@@ -21,6 +21,7 @@
 #include <asm/kvm_e500.h>
 #include <asm/kvm_ppc.h>
 
+#include "booke.h"
 #include "e500_tlb.h"
 
 void kvmppc_core_load_host_debugstate(struct kvm_vcpu *vcpu)
@@ -133,12 +134,29 @@ void kvmppc_core_vcpu_free(struct kvm_vcpu *vcpu)
 
 static int kvmppc_e500_init(void)
 {
-	int r;
+	int r, i;
+	unsigned long ivor[3];
+	unsigned long max_ivor = 0;
 
 	r = kvmppc_booke_init();
 	if (r)
 		return r;
 
+	/* copy extra E500 exception handlers */
+	ivor[0] = mfspr(SPRN_IVOR32);
+	ivor[1] = mfspr(SPRN_IVOR33);
+	ivor[2] = mfspr(SPRN_IVOR34);
+	for (i = 0; i < 3; i++) {
+		if (ivor[i] > max_ivor)
+			max_ivor = ivor[i];
+
+		memcpy((void *)kvmppc_booke_handlers + ivor[i],
+		       kvmppc_handlers_start + (i + 16) * kvmppc_handler_len,
+		       kvmppc_handler_len);
+	}
+	flush_icache_range(kvmppc_booke_handlers,
+			kvmppc_booke_handlers + max_ivor + kvmppc_handler_len);
+
 	return kvm_init(NULL, sizeof(struct kvmppc_vcpu_e500), THIS_MODULE);
 }
 
diff --git a/arch/powerpc/kvm/e500_emulate.c b/arch/powerpc/kvm/e500_emulate.c
index a47f44c..d3c0c7c 100644
--- a/arch/powerpc/kvm/e500_emulate.c
+++ b/arch/powerpc/kvm/e500_emulate.c
@@ -107,6 +107,20 @@ int kvmppc_core_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, int rs)
 	case SPRN_HID1:
 		vcpu_e500->hid1 = vcpu->arch.gpr[rs]; break;
 
+	/* extra exceptions */
+	case SPRN_IVOR32:
+		vcpu->arch.ivor[BOOKE_IRQPRIO_SPE_UNAVAIL] = vcpu->arch.gpr[rs];
+		break;
+	case SPRN_IVOR33:
+		vcpu->arch.ivor[BOOKE_IRQPRIO_SPE_FP_DATA] = vcpu->arch.gpr[rs];
+		break;
+	case SPRN_IVOR34:
+		vcpu->arch.ivor[BOOKE_IRQPRIO_SPE_FP_ROUND] = vcpu->arch.gpr[rs];
+		break;
+	case SPRN_IVOR35:
+		vcpu->arch.ivor[BOOKE_IRQPRIO_PERFORMANCE_MONITOR] = vcpu->arch.gpr[rs];
+		break;
+
 	default:
 		emulated = kvmppc_booke_emulate_mtspr(vcpu, sprn, rs);
 	}
@@ -160,6 +174,19 @@ int kvmppc_core_emulate_mfspr(struct kvm_vcpu *vcpu, int sprn, int rt)
 	case SPRN_HID1:
 		vcpu->arch.gpr[rt] = vcpu_e500->hid1; break;
 
+	/* extra exceptions */
+	case SPRN_IVOR32:
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_SPE_UNAVAIL];
+		break;
+	case SPRN_IVOR33:
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_SPE_FP_DATA];
+		break;
+	case SPRN_IVOR34:
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_SPE_FP_ROUND];
+		break;
+	case SPRN_IVOR35:
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_PERFORMANCE_MONITOR];
+		break;
 	default:
 		emulated = kvmppc_booke_emulate_mfspr(vcpu, sprn, rt);
 	}
-- 
1.6.0.6

