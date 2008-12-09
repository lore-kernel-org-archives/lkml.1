Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbYLIUa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbYLIUa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbYLIUXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:23:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34901 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754987AbYLIUXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:14 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 05/44] KVM: ppc: optimize irq delivery path
Date: Tue,  9 Dec 2008 22:22:20 +0200
Message-Id: <1228854179-23002-6-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

In kvmppc_deliver_interrupt is just one case left in the switch and it is a
rare one (less than 8%) when looking at the exit numbers. Therefore we can
at least drop the switch/case and if an if. I inserted an unlikely too, but
that's open for discussion.

In kvmppc_can_deliver_interrupt all frequent cases are in the default case.
I know compilers are smart but we can make it easier for them. By writing
down all options and removing the default case combined with the fact that
ithe values are constants 0..15 should allow the compiler to write an easy
jump table.
Modifying kvmppc_can_deliver_interrupt pointed me to the fact that gcc seems
to be unable to reduce priority_exception[x] to a build time constant.
Therefore I changed the usage of the translation arrays in the interrupt
delivery path completely. It is now using priority without translation to irq
on the full irq delivery path.
To be able to do that ivpr regs are stored by their priority now.

Additionally the decision made in kvmppc_can_deliver_interrupt is already
sufficient to get the value of interrupt_msr_mask[x]. Therefore we can replace
the 16x4byte array used here with a single 4byte variable (might still be one
miss, but the chance to find this in cache should be better than the right
entry of the whole array).

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_ppc.h |    3 -
 arch/powerpc/kvm/44x_emulate.c     |  100 ++++++++++++++-------
 arch/powerpc/kvm/booke.c           |  175 +++++++++++------------------------
 arch/powerpc/kvm/booke.h           |   18 ++++
 4 files changed, 140 insertions(+), 156 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 976ecc4..844f683 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -36,9 +36,6 @@ enum emulation_result {
 	EMULATE_FAIL,         /* can't emulate this instruction */
 };
 
-extern const unsigned char exception_priority[];
-extern const unsigned char priority_exception[];
-
 extern int __kvmppc_vcpu_run(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu);
 extern char kvmppc_handlers_start[];
 extern unsigned long kvmppc_handler_len;
diff --git a/arch/powerpc/kvm/44x_emulate.c b/arch/powerpc/kvm/44x_emulate.c
index a634c0c..9bc50ce 100644
--- a/arch/powerpc/kvm/44x_emulate.c
+++ b/arch/powerpc/kvm/44x_emulate.c
@@ -228,39 +228,56 @@ int kvmppc_core_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, int rs)
 		vcpu->arch.sprg7 = vcpu->arch.gpr[rs]; break;
 
 	case SPRN_IVPR:
-		vcpu->arch.ivpr = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.ivpr = vcpu->arch.gpr[rs];
+		break;
 	case SPRN_IVOR0:
-		vcpu->arch.ivor[0] = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.ivor[BOOKE_IRQPRIO_CRITICAL] = vcpu->arch.gpr[rs];
+		break;
 	case SPRN_IVOR1:
-		vcpu->arch.ivor[1] = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.ivor[BOOKE_IRQPRIO_MACHINE_CHECK] = vcpu->arch.gpr[rs];
+		break;
 	case SPRN_IVOR2:
-		vcpu->arch.ivor[2] = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.ivor[BOOKE_IRQPRIO_DATA_STORAGE] = vcpu->arch.gpr[rs];
+		break;
 	case SPRN_IVOR3:
-		vcpu->arch.ivor[3] = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.ivor[BOOKE_IRQPRIO_INST_STORAGE] = vcpu->arch.gpr[rs];
+		break;
 	case SPRN_IVOR4:
-		vcpu->arch.ivor[4] = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.ivor[BOOKE_IRQPRIO_EXTERNAL] = vcpu->arch.gpr[rs];
+		break;
 	case SPRN_IVOR5:
-		vcpu->arch.ivor[5] = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.ivor[BOOKE_IRQPRIO_ALIGNMENT] = vcpu->arch.gpr[rs];
+		break;
 	case SPRN_IVOR6:
-		vcpu->arch.ivor[6] = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.ivor[BOOKE_IRQPRIO_PROGRAM] = vcpu->arch.gpr[rs];
+		break;
 	case SPRN_IVOR7:
-		vcpu->arch.ivor[7] = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.ivor[BOOKE_IRQPRIO_FP_UNAVAIL] = vcpu->arch.gpr[rs];
+		break;
 	case SPRN_IVOR8:
-		vcpu->arch.ivor[8] = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.ivor[BOOKE_IRQPRIO_SYSCALL] = vcpu->arch.gpr[rs];
+		break;
 	case SPRN_IVOR9:
-		vcpu->arch.ivor[9] = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.ivor[BOOKE_IRQPRIO_AP_UNAVAIL] = vcpu->arch.gpr[rs];
+		break;
 	case SPRN_IVOR10:
-		vcpu->arch.ivor[10] = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.ivor[BOOKE_IRQPRIO_DECREMENTER] = vcpu->arch.gpr[rs];
+		break;
 	case SPRN_IVOR11:
-		vcpu->arch.ivor[11] = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.ivor[BOOKE_IRQPRIO_FIT] = vcpu->arch.gpr[rs];
+		break;
 	case SPRN_IVOR12:
-		vcpu->arch.ivor[12] = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.ivor[BOOKE_IRQPRIO_WATCHDOG] = vcpu->arch.gpr[rs];
+		break;
 	case SPRN_IVOR13:
-		vcpu->arch.ivor[13] = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.ivor[BOOKE_IRQPRIO_DTLB_MISS] = vcpu->arch.gpr[rs];
+		break;
 	case SPRN_IVOR14:
-		vcpu->arch.ivor[14] = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.ivor[BOOKE_IRQPRIO_ITLB_MISS] = vcpu->arch.gpr[rs];
+		break;
 	case SPRN_IVOR15:
-		vcpu->arch.ivor[15] = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.ivor[BOOKE_IRQPRIO_DEBUG] = vcpu->arch.gpr[rs];
+		break;
 
 	default:
 		return EMULATE_FAIL;
@@ -295,37 +312,54 @@ int kvmppc_core_emulate_mfspr(struct kvm_vcpu *vcpu, int sprn, int rt)
 		vcpu->arch.gpr[rt] = vcpu->arch.dbcr1; break;
 
 	case SPRN_IVOR0:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[0]; break;
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_CRITICAL];
+		break;
 	case SPRN_IVOR1:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[1]; break;
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_MACHINE_CHECK];
+		break;
 	case SPRN_IVOR2:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[2]; break;
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_DATA_STORAGE];
+		break;
 	case SPRN_IVOR3:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[3]; break;
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_INST_STORAGE];
+		break;
 	case SPRN_IVOR4:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[4]; break;
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_EXTERNAL];
+		break;
 	case SPRN_IVOR5:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[5]; break;
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_ALIGNMENT];
+		break;
 	case SPRN_IVOR6:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[6]; break;
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_PROGRAM];
+		break;
 	case SPRN_IVOR7:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[7]; break;
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_FP_UNAVAIL];
+		break;
 	case SPRN_IVOR8:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[8]; break;
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_SYSCALL];
+		break;
 	case SPRN_IVOR9:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[9]; break;
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_AP_UNAVAIL];
+		break;
 	case SPRN_IVOR10:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[10]; break;
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_DECREMENTER];
+		break;
 	case SPRN_IVOR11:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[11]; break;
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_FIT];
+		break;
 	case SPRN_IVOR12:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[12]; break;
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_WATCHDOG];
+		break;
 	case SPRN_IVOR13:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[13]; break;
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_DTLB_MISS];
+		break;
 	case SPRN_IVOR14:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[14]; break;
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_ITLB_MISS];
+		break;
 	case SPRN_IVOR15:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[15]; break;
+		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_DEBUG];
+		break;
+
 	default:
 		return EMULATE_FAIL;
 	}
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 0f06471..ec59a67 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -55,64 +55,6 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ NULL }
 };
 
-static const u32 interrupt_msr_mask[16] = {
-	[BOOKE_INTERRUPT_CRITICAL]      = MSR_ME,
-	[BOOKE_INTERRUPT_MACHINE_CHECK] = 0,
-	[BOOKE_INTERRUPT_DATA_STORAGE]  = MSR_CE|MSR_ME|MSR_DE,
-	[BOOKE_INTERRUPT_INST_STORAGE]  = MSR_CE|MSR_ME|MSR_DE,
-	[BOOKE_INTERRUPT_EXTERNAL]      = MSR_CE|MSR_ME|MSR_DE,
-	[BOOKE_INTERRUPT_ALIGNMENT]     = MSR_CE|MSR_ME|MSR_DE,
-	[BOOKE_INTERRUPT_PROGRAM]       = MSR_CE|MSR_ME|MSR_DE,
-	[BOOKE_INTERRUPT_FP_UNAVAIL]    = MSR_CE|MSR_ME|MSR_DE,
-	[BOOKE_INTERRUPT_SYSCALL]       = MSR_CE|MSR_ME|MSR_DE,
-	[BOOKE_INTERRUPT_AP_UNAVAIL]    = MSR_CE|MSR_ME|MSR_DE,
-	[BOOKE_INTERRUPT_DECREMENTER]   = MSR_CE|MSR_ME|MSR_DE,
-	[BOOKE_INTERRUPT_FIT]           = MSR_CE|MSR_ME|MSR_DE,
-	[BOOKE_INTERRUPT_WATCHDOG]      = MSR_ME,
-	[BOOKE_INTERRUPT_DTLB_MISS]     = MSR_CE|MSR_ME|MSR_DE,
-	[BOOKE_INTERRUPT_ITLB_MISS]     = MSR_CE|MSR_ME|MSR_DE,
-	[BOOKE_INTERRUPT_DEBUG]         = MSR_ME,
-};
-
-const unsigned char exception_priority[] = {
-	[BOOKE_INTERRUPT_DATA_STORAGE] = 0,
-	[BOOKE_INTERRUPT_INST_STORAGE] = 1,
-	[BOOKE_INTERRUPT_ALIGNMENT] = 2,
-	[BOOKE_INTERRUPT_PROGRAM] = 3,
-	[BOOKE_INTERRUPT_FP_UNAVAIL] = 4,
-	[BOOKE_INTERRUPT_SYSCALL] = 5,
-	[BOOKE_INTERRUPT_AP_UNAVAIL] = 6,
-	[BOOKE_INTERRUPT_DTLB_MISS] = 7,
-	[BOOKE_INTERRUPT_ITLB_MISS] = 8,
-	[BOOKE_INTERRUPT_MACHINE_CHECK] = 9,
-	[BOOKE_INTERRUPT_DEBUG] = 10,
-	[BOOKE_INTERRUPT_CRITICAL] = 11,
-	[BOOKE_INTERRUPT_WATCHDOG] = 12,
-	[BOOKE_INTERRUPT_EXTERNAL] = 13,
-	[BOOKE_INTERRUPT_FIT] = 14,
-	[BOOKE_INTERRUPT_DECREMENTER] = 15,
-};
-
-const unsigned char priority_exception[] = {
-	BOOKE_INTERRUPT_DATA_STORAGE,
-	BOOKE_INTERRUPT_INST_STORAGE,
-	BOOKE_INTERRUPT_ALIGNMENT,
-	BOOKE_INTERRUPT_PROGRAM,
-	BOOKE_INTERRUPT_FP_UNAVAIL,
-	BOOKE_INTERRUPT_SYSCALL,
-	BOOKE_INTERRUPT_AP_UNAVAIL,
-	BOOKE_INTERRUPT_DTLB_MISS,
-	BOOKE_INTERRUPT_ITLB_MISS,
-	BOOKE_INTERRUPT_MACHINE_CHECK,
-	BOOKE_INTERRUPT_DEBUG,
-	BOOKE_INTERRUPT_CRITICAL,
-	BOOKE_INTERRUPT_WATCHDOG,
-	BOOKE_INTERRUPT_EXTERNAL,
-	BOOKE_INTERRUPT_FIT,
-	BOOKE_INTERRUPT_DECREMENTER,
-};
-
-
 /* TODO: use vcpu_printf() */
 void kvmppc_dump_vcpu(struct kvm_vcpu *vcpu)
 {
@@ -133,103 +75,96 @@ void kvmppc_dump_vcpu(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void kvmppc_booke_queue_exception(struct kvm_vcpu *vcpu, int exception)
+static void kvmppc_booke_queue_irqprio(struct kvm_vcpu *vcpu,
+                                       unsigned int priority)
 {
-	unsigned int priority = exception_priority[exception];
 	set_bit(priority, &vcpu->arch.pending_exceptions);
 }
 
-static void kvmppc_booke_clear_exception(struct kvm_vcpu *vcpu, int exception)
-{
-	unsigned int priority = exception_priority[exception];
-	clear_bit(priority, &vcpu->arch.pending_exceptions);
-}
-
 void kvmppc_core_queue_program(struct kvm_vcpu *vcpu)
 {
-	kvmppc_booke_queue_exception(vcpu, BOOKE_INTERRUPT_PROGRAM);
+	kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_PROGRAM);
 }
 
 void kvmppc_core_queue_dec(struct kvm_vcpu *vcpu)
 {
-	kvmppc_booke_queue_exception(vcpu, BOOKE_INTERRUPT_DECREMENTER);
+	kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_DECREMENTER);
 }
 
 int kvmppc_core_pending_dec(struct kvm_vcpu *vcpu)
 {
-	unsigned int priority = exception_priority[BOOKE_INTERRUPT_DECREMENTER];
-	return test_bit(priority, &vcpu->arch.pending_exceptions);
+	return test_bit(BOOKE_IRQPRIO_DECREMENTER, &vcpu->arch.pending_exceptions);
 }
 
 void kvmppc_core_queue_external(struct kvm_vcpu *vcpu,
                                 struct kvm_interrupt *irq)
 {
-	kvmppc_booke_queue_exception(vcpu, BOOKE_INTERRUPT_EXTERNAL);
+	kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_EXTERNAL);
 }
 
-/* Check if we are ready to deliver the interrupt */
-static int kvmppc_can_deliver_interrupt(struct kvm_vcpu *vcpu, int interrupt)
+/* Deliver the interrupt of the corresponding priority, if possible. */
+static int kvmppc_booke_irqprio_deliver(struct kvm_vcpu *vcpu,
+                                        unsigned int priority)
 {
-	int r;
-
-	switch (interrupt) {
-	case BOOKE_INTERRUPT_CRITICAL:
-		r = vcpu->arch.msr & MSR_CE;
+	int allowed = 0;
+	ulong msr_mask;
+
+	switch (priority) {
+	case BOOKE_IRQPRIO_PROGRAM:
+	case BOOKE_IRQPRIO_DTLB_MISS:
+	case BOOKE_IRQPRIO_ITLB_MISS:
+	case BOOKE_IRQPRIO_SYSCALL:
+	case BOOKE_IRQPRIO_DATA_STORAGE:
+	case BOOKE_IRQPRIO_INST_STORAGE:
+	case BOOKE_IRQPRIO_FP_UNAVAIL:
+	case BOOKE_IRQPRIO_AP_UNAVAIL:
+	case BOOKE_IRQPRIO_ALIGNMENT:
+		allowed = 1;
+		msr_mask = MSR_CE|MSR_ME|MSR_DE;
 		break;
-	case BOOKE_INTERRUPT_MACHINE_CHECK:
-		r = vcpu->arch.msr & MSR_ME;
+	case BOOKE_IRQPRIO_CRITICAL:
+	case BOOKE_IRQPRIO_WATCHDOG:
+		allowed = vcpu->arch.msr & MSR_CE;
+		msr_mask = MSR_ME;
 		break;
-	case BOOKE_INTERRUPT_EXTERNAL:
-		r = vcpu->arch.msr & MSR_EE;
-		break;
-	case BOOKE_INTERRUPT_DECREMENTER:
-		r = vcpu->arch.msr & MSR_EE;
+	case BOOKE_IRQPRIO_MACHINE_CHECK:
+		allowed = vcpu->arch.msr & MSR_ME;
+		msr_mask = 0;
 		break;
-	case BOOKE_INTERRUPT_FIT:
-		r = vcpu->arch.msr & MSR_EE;
+	case BOOKE_IRQPRIO_EXTERNAL:
+	case BOOKE_IRQPRIO_DECREMENTER:
+	case BOOKE_IRQPRIO_FIT:
+		allowed = vcpu->arch.msr & MSR_EE;
+		msr_mask = MSR_CE|MSR_ME|MSR_DE;
 		break;
-	case BOOKE_INTERRUPT_WATCHDOG:
-		r = vcpu->arch.msr & MSR_CE;
+	case BOOKE_IRQPRIO_DEBUG:
+		allowed = vcpu->arch.msr & MSR_DE;
+		msr_mask = MSR_ME;
 		break;
-	case BOOKE_INTERRUPT_DEBUG:
-		r = vcpu->arch.msr & MSR_DE;
-		break;
-	default:
-		r = 1;
 	}
 
-	return r;
-}
+	if (allowed) {
+		vcpu->arch.srr0 = vcpu->arch.pc;
+		vcpu->arch.srr1 = vcpu->arch.msr;
+		vcpu->arch.pc = vcpu->arch.ivpr | vcpu->arch.ivor[priority];
+		kvmppc_set_msr(vcpu, vcpu->arch.msr & msr_mask);
 
-static void kvmppc_booke_deliver_interrupt(struct kvm_vcpu *vcpu, int interrupt)
-{
-	switch (interrupt) {
-	case BOOKE_INTERRUPT_DECREMENTER:
-		vcpu->arch.tsr |= TSR_DIS;
-		break;
+		clear_bit(priority, &vcpu->arch.pending_exceptions);
 	}
 
-	vcpu->arch.srr0 = vcpu->arch.pc;
-	vcpu->arch.srr1 = vcpu->arch.msr;
-	vcpu->arch.pc = vcpu->arch.ivpr | vcpu->arch.ivor[interrupt];
-	kvmppc_set_msr(vcpu, vcpu->arch.msr & interrupt_msr_mask[interrupt]);
+	return allowed;
 }
 
 /* Check pending exceptions and deliver one, if possible. */
 void kvmppc_core_deliver_interrupts(struct kvm_vcpu *vcpu)
 {
 	unsigned long *pending = &vcpu->arch.pending_exceptions;
-	unsigned int exception;
 	unsigned int priority;
 
 	priority = __ffs(*pending);
 	while (priority <= BOOKE_MAX_INTERRUPT) {
-		exception = priority_exception[priority];
-		if (kvmppc_can_deliver_interrupt(vcpu, exception)) {
-			kvmppc_booke_clear_exception(vcpu, exception);
-			kvmppc_booke_deliver_interrupt(vcpu, exception);
+		if (kvmppc_booke_irqprio_deliver(vcpu, priority))
 			break;
-		}
 
 		priority = find_next_bit(pending,
 		                         BITS_PER_BYTE * sizeof(*pending),
@@ -287,7 +222,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			/* Program traps generated by user-level software must be handled
 			 * by the guest kernel. */
 			vcpu->arch.esr = vcpu->arch.fault_esr;
-			kvmppc_booke_queue_exception(vcpu, BOOKE_INTERRUPT_PROGRAM);
+			kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_PROGRAM);
 			r = RESUME_GUEST;
 			break;
 		}
@@ -321,27 +256,27 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		break;
 
 	case BOOKE_INTERRUPT_FP_UNAVAIL:
-		kvmppc_booke_queue_exception(vcpu, exit_nr);
+		kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_FP_UNAVAIL);
 		r = RESUME_GUEST;
 		break;
 
 	case BOOKE_INTERRUPT_DATA_STORAGE:
 		vcpu->arch.dear = vcpu->arch.fault_dear;
 		vcpu->arch.esr = vcpu->arch.fault_esr;
-		kvmppc_booke_queue_exception(vcpu, exit_nr);
+		kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_DATA_STORAGE);
 		vcpu->stat.dsi_exits++;
 		r = RESUME_GUEST;
 		break;
 
 	case BOOKE_INTERRUPT_INST_STORAGE:
 		vcpu->arch.esr = vcpu->arch.fault_esr;
-		kvmppc_booke_queue_exception(vcpu, exit_nr);
+		kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_INST_STORAGE);
 		vcpu->stat.isi_exits++;
 		r = RESUME_GUEST;
 		break;
 
 	case BOOKE_INTERRUPT_SYSCALL:
-		kvmppc_booke_queue_exception(vcpu, exit_nr);
+		kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_SYSCALL);
 		vcpu->stat.syscall_exits++;
 		r = RESUME_GUEST;
 		break;
@@ -355,7 +290,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		gtlbe = kvmppc_44x_dtlb_search(vcpu, eaddr);
 		if (!gtlbe) {
 			/* The guest didn't have a mapping for it. */
-			kvmppc_booke_queue_exception(vcpu, exit_nr);
+			kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_DTLB_MISS);
 			vcpu->arch.dear = vcpu->arch.fault_dear;
 			vcpu->arch.esr = vcpu->arch.fault_esr;
 			vcpu->stat.dtlb_real_miss_exits++;
@@ -398,7 +333,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		gtlbe = kvmppc_44x_itlb_search(vcpu, eaddr);
 		if (!gtlbe) {
 			/* The guest didn't have a mapping for it. */
-			kvmppc_booke_queue_exception(vcpu, exit_nr);
+			kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_ITLB_MISS);
 			vcpu->stat.itlb_real_miss_exits++;
 			break;
 		}
@@ -418,7 +353,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			               gtlbe->word2);
 		} else {
 			/* Guest mapped and leaped at non-RAM! */
-			kvmppc_booke_queue_exception(vcpu, BOOKE_INTERRUPT_MACHINE_CHECK);
+			kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_MACHINE_CHECK);
 		}
 
 		break;
diff --git a/arch/powerpc/kvm/booke.h b/arch/powerpc/kvm/booke.h
index f694a4b..48d905f 100644
--- a/arch/powerpc/kvm/booke.h
+++ b/arch/powerpc/kvm/booke.h
@@ -23,6 +23,24 @@
 #include <linux/types.h>
 #include <linux/kvm_host.h>
 
+/* interrupt priortity ordering */
+#define BOOKE_IRQPRIO_DATA_STORAGE 0
+#define BOOKE_IRQPRIO_INST_STORAGE 1
+#define BOOKE_IRQPRIO_ALIGNMENT 2
+#define BOOKE_IRQPRIO_PROGRAM 3
+#define BOOKE_IRQPRIO_FP_UNAVAIL 4
+#define BOOKE_IRQPRIO_SYSCALL 5
+#define BOOKE_IRQPRIO_AP_UNAVAIL 6
+#define BOOKE_IRQPRIO_DTLB_MISS 7
+#define BOOKE_IRQPRIO_ITLB_MISS 8
+#define BOOKE_IRQPRIO_MACHINE_CHECK 9
+#define BOOKE_IRQPRIO_DEBUG 10
+#define BOOKE_IRQPRIO_CRITICAL 11
+#define BOOKE_IRQPRIO_WATCHDOG 12
+#define BOOKE_IRQPRIO_EXTERNAL 13
+#define BOOKE_IRQPRIO_FIT 14
+#define BOOKE_IRQPRIO_DECREMENTER 15
+
 /* Helper function for "full" MSR writes. No need to call this if only EE is
  * changing. */
 static inline void kvmppc_set_msr(struct kvm_vcpu *vcpu, u32 new_msr)
-- 
1.6.0.3

