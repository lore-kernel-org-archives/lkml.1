Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbYIWNyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbYIWNyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbYIWNrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52413 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660AbYIWNrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:43 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 26/40] KVM: ppc: guest breakpoint support
Date: Tue, 23 Sep 2008 16:46:40 +0300
Message-Id: <1222177614-26669-27-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Allow host userspace to program hardware debug registers to set breakpoints
inside guests.

Signed-off-by: Jerone Young <jyoung5@us.ibm.com>
Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/powerpc/include/asm/kvm_host.h |    5 ++
 arch/powerpc/kvm/booke_guest.c      |   15 ++++++
 arch/powerpc/kvm/booke_interrupts.S |   11 ++++-
 arch/powerpc/kvm/powerpc.c          |   84 ++++++++++++++++++++++++++++++++++-
 4 files changed, 113 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 2655e2a..23bad40 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -86,6 +86,11 @@ struct kvm_vcpu_arch {
 
 	u32 host_stack;
 	u32 host_pid;
+	u32 host_dbcr0;
+	u32 host_dbcr1;
+	u32 host_dbcr2;
+	u32 host_iac[4];
+	u32 host_msr;
 
 	u64 fpr[32];
 	u32 gpr[32];
diff --git a/arch/powerpc/kvm/booke_guest.c b/arch/powerpc/kvm/booke_guest.c
index 9c8ad85..3cca079 100644
--- a/arch/powerpc/kvm/booke_guest.c
+++ b/arch/powerpc/kvm/booke_guest.c
@@ -410,6 +410,21 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		break;
 	}
 
+	case BOOKE_INTERRUPT_DEBUG: {
+		u32 dbsr;
+
+		vcpu->arch.pc = mfspr(SPRN_CSRR0);
+
+		/* clear IAC events in DBSR register */
+		dbsr = mfspr(SPRN_DBSR);
+		dbsr &= DBSR_IAC1 | DBSR_IAC2 | DBSR_IAC3 | DBSR_IAC4;
+		mtspr(SPRN_DBSR, dbsr);
+
+		run->exit_reason = KVM_EXIT_DEBUG;
+		r = RESUME_HOST;
+		break;
+	}
+
 	default:
 		printk(KERN_EMERG "exit_nr %d\n", exit_nr);
 		BUG();
diff --git a/arch/powerpc/kvm/booke_interrupts.S b/arch/powerpc/kvm/booke_interrupts.S
index 3b653b5..8eaba26 100644
--- a/arch/powerpc/kvm/booke_interrupts.S
+++ b/arch/powerpc/kvm/booke_interrupts.S
@@ -42,7 +42,8 @@
 #define HOST_STACK_LR   (HOST_STACK_SIZE + 4) /* In caller stack frame. */
 
 #define NEED_INST_MASK ((1<<BOOKE_INTERRUPT_PROGRAM) | \
-                        (1<<BOOKE_INTERRUPT_DTLB_MISS))
+                        (1<<BOOKE_INTERRUPT_DTLB_MISS) | \
+                        (1<<BOOKE_INTERRUPT_DEBUG))
 
 #define NEED_DEAR_MASK ((1<<BOOKE_INTERRUPT_DATA_STORAGE) | \
                         (1<<BOOKE_INTERRUPT_DTLB_MISS))
@@ -431,6 +432,14 @@ lightweight_exit:
 	oris	r3, r3, KVMPPC_MSR_MASK@h
 	ori	r3, r3, KVMPPC_MSR_MASK@l
 	mtsrr1	r3
+
+	/* Clear any debug events which occurred since we disabled MSR[DE].
+	 * XXX This gives us a 3-instruction window in which a breakpoint
+	 * intended for guest context could fire in the host instead. */
+	lis	r3, 0xffff
+	ori	r3, r3, 0xffff
+	mtspr	SPRN_DBSR, r3
+
 	lwz	r3, VCPU_GPR(r3)(r4)
 	lwz	r4, VCPU_GPR(r4)(r4)
 	rfi
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 53826a5..b756071 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -239,18 +239,100 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
 }
 
+/* Note: clearing MSR[DE] just means that the debug interrupt will not be
+ * delivered *immediately*. Instead, it simply sets the appropriate DBSR bits.
+ * If those DBSR bits are still set when MSR[DE] is re-enabled, the interrupt
+ * will be delivered as an "imprecise debug event" (which is indicated by
+ * DBSR[IDE].
+ */
+static void kvmppc_disable_debug_interrupts(void)
+{
+	mtmsr(mfmsr() & ~MSR_DE);
+}
+
+static void kvmppc_restore_host_debug_state(struct kvm_vcpu *vcpu)
+{
+	kvmppc_disable_debug_interrupts();
+
+	mtspr(SPRN_IAC1, vcpu->arch.host_iac[0]);
+	mtspr(SPRN_IAC2, vcpu->arch.host_iac[1]);
+	mtspr(SPRN_IAC3, vcpu->arch.host_iac[2]);
+	mtspr(SPRN_IAC4, vcpu->arch.host_iac[3]);
+	mtspr(SPRN_DBCR1, vcpu->arch.host_dbcr1);
+	mtspr(SPRN_DBCR2, vcpu->arch.host_dbcr2);
+	mtspr(SPRN_DBCR0, vcpu->arch.host_dbcr0);
+	mtmsr(vcpu->arch.host_msr);
+}
+
+static void kvmppc_load_guest_debug_registers(struct kvm_vcpu *vcpu)
+{
+	struct kvm_guest_debug *dbg = &vcpu->guest_debug;
+	u32 dbcr0 = 0;
+
+	vcpu->arch.host_msr = mfmsr();
+	kvmppc_disable_debug_interrupts();
+
+	/* Save host debug register state. */
+	vcpu->arch.host_iac[0] = mfspr(SPRN_IAC1);
+	vcpu->arch.host_iac[1] = mfspr(SPRN_IAC2);
+	vcpu->arch.host_iac[2] = mfspr(SPRN_IAC3);
+	vcpu->arch.host_iac[3] = mfspr(SPRN_IAC4);
+	vcpu->arch.host_dbcr0 = mfspr(SPRN_DBCR0);
+	vcpu->arch.host_dbcr1 = mfspr(SPRN_DBCR1);
+	vcpu->arch.host_dbcr2 = mfspr(SPRN_DBCR2);
+
+	/* set registers up for guest */
+
+	if (dbg->bp[0]) {
+		mtspr(SPRN_IAC1, dbg->bp[0]);
+		dbcr0 |= DBCR0_IAC1 | DBCR0_IDM;
+	}
+	if (dbg->bp[1]) {
+		mtspr(SPRN_IAC2, dbg->bp[1]);
+		dbcr0 |= DBCR0_IAC2 | DBCR0_IDM;
+	}
+	if (dbg->bp[2]) {
+		mtspr(SPRN_IAC3, dbg->bp[2]);
+		dbcr0 |= DBCR0_IAC3 | DBCR0_IDM;
+	}
+	if (dbg->bp[3]) {
+		mtspr(SPRN_IAC4, dbg->bp[3]);
+		dbcr0 |= DBCR0_IAC4 | DBCR0_IDM;
+	}
+
+	mtspr(SPRN_DBCR0, dbcr0);
+	mtspr(SPRN_DBCR1, 0);
+	mtspr(SPRN_DBCR2, 0);
+}
+
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
+	if (vcpu->guest_debug.enabled)
+		kvmppc_load_guest_debug_registers(vcpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	if (vcpu->guest_debug.enabled)
+		kvmppc_restore_host_debug_state(vcpu);
 }
 
 int kvm_arch_vcpu_ioctl_debug_guest(struct kvm_vcpu *vcpu,
                                     struct kvm_debug_guest *dbg)
 {
-	return -ENOTSUPP;
+	int i;
+
+	vcpu->guest_debug.enabled = dbg->enabled;
+	if (vcpu->guest_debug.enabled) {
+		for (i=0; i < ARRAY_SIZE(vcpu->guest_debug.bp); i++) {
+			if (dbg->breakpoints[i].enabled)
+				vcpu->guest_debug.bp[i] = dbg->breakpoints[i].address;
+			else
+				vcpu->guest_debug.bp[i] = 0;
+		}
+	}
+
+	return 0;
 }
 
 static void kvmppc_complete_dcr_load(struct kvm_vcpu *vcpu,
-- 
1.6.0.1

