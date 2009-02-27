Return-Path: <linux-kernel-owner+w=401wt.eu-S1759614AbZB0Kgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614AbZB0Kgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbZB0K2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:28:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53582 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510AbZB0K1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 19/37] KVM: ppc: remove debug support broken by KVM debug rewrite
Date: Fri, 27 Feb 2009 12:26:42 +0200
Message-Id: <1235730420-7929-20-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

After the rewrite of KVM's debug support, this code doesn't even build any
more.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_host.h |    5 ---
 arch/powerpc/include/asm/kvm_ppc.h  |    3 --
 arch/powerpc/kvm/44x.c              |   66 -----------------------------------
 arch/powerpc/kvm/powerpc.c          |   27 +-------------
 4 files changed, 2 insertions(+), 99 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 1c61876..dfdf13c 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -111,11 +111,6 @@ struct kvm_arch {
 struct kvm_vcpu_arch {
 	u32 host_stack;
 	u32 host_pid;
-	u32 host_dbcr0;
-	u32 host_dbcr1;
-	u32 host_dbcr2;
-	u32 host_iac[4];
-	u32 host_msr;
 
 	u64 fpr[32];
 	ulong gpr[32];
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 6052779..2c6ee34 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -77,9 +77,6 @@ extern int kvmppc_core_vcpu_translate(struct kvm_vcpu *vcpu,
 extern void kvmppc_core_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 extern void kvmppc_core_vcpu_put(struct kvm_vcpu *vcpu);
 
-extern void kvmppc_core_load_guest_debugstate(struct kvm_vcpu *vcpu);
-extern void kvmppc_core_load_host_debugstate(struct kvm_vcpu *vcpu);
-
 extern void kvmppc_core_deliver_interrupts(struct kvm_vcpu *vcpu);
 extern int kvmppc_core_pending_dec(struct kvm_vcpu *vcpu);
 extern void kvmppc_core_queue_program(struct kvm_vcpu *vcpu);
diff --git a/arch/powerpc/kvm/44x.c b/arch/powerpc/kvm/44x.c
index 8383603..0cef809 100644
--- a/arch/powerpc/kvm/44x.c
+++ b/arch/powerpc/kvm/44x.c
@@ -28,72 +28,6 @@
 
 #include "44x_tlb.h"
 
-/* Note: clearing MSR[DE] just means that the debug interrupt will not be
- * delivered *immediately*. Instead, it simply sets the appropriate DBSR bits.
- * If those DBSR bits are still set when MSR[DE] is re-enabled, the interrupt
- * will be delivered as an "imprecise debug event" (which is indicated by
- * DBSR[IDE].
- */
-static void kvm44x_disable_debug_interrupts(void)
-{
-	mtmsr(mfmsr() & ~MSR_DE);
-}
-
-void kvmppc_core_load_host_debugstate(struct kvm_vcpu *vcpu)
-{
-	kvm44x_disable_debug_interrupts();
-
-	mtspr(SPRN_IAC1, vcpu->arch.host_iac[0]);
-	mtspr(SPRN_IAC2, vcpu->arch.host_iac[1]);
-	mtspr(SPRN_IAC3, vcpu->arch.host_iac[2]);
-	mtspr(SPRN_IAC4, vcpu->arch.host_iac[3]);
-	mtspr(SPRN_DBCR1, vcpu->arch.host_dbcr1);
-	mtspr(SPRN_DBCR2, vcpu->arch.host_dbcr2);
-	mtspr(SPRN_DBCR0, vcpu->arch.host_dbcr0);
-	mtmsr(vcpu->arch.host_msr);
-}
-
-void kvmppc_core_load_guest_debugstate(struct kvm_vcpu *vcpu)
-{
-	struct kvm_guest_debug *dbg = &vcpu->guest_debug;
-	u32 dbcr0 = 0;
-
-	vcpu->arch.host_msr = mfmsr();
-	kvm44x_disable_debug_interrupts();
-
-	/* Save host debug register state. */
-	vcpu->arch.host_iac[0] = mfspr(SPRN_IAC1);
-	vcpu->arch.host_iac[1] = mfspr(SPRN_IAC2);
-	vcpu->arch.host_iac[2] = mfspr(SPRN_IAC3);
-	vcpu->arch.host_iac[3] = mfspr(SPRN_IAC4);
-	vcpu->arch.host_dbcr0 = mfspr(SPRN_DBCR0);
-	vcpu->arch.host_dbcr1 = mfspr(SPRN_DBCR1);
-	vcpu->arch.host_dbcr2 = mfspr(SPRN_DBCR2);
-
-	/* set registers up for guest */
-
-	if (dbg->bp[0]) {
-		mtspr(SPRN_IAC1, dbg->bp[0]);
-		dbcr0 |= DBCR0_IAC1 | DBCR0_IDM;
-	}
-	if (dbg->bp[1]) {
-		mtspr(SPRN_IAC2, dbg->bp[1]);
-		dbcr0 |= DBCR0_IAC2 | DBCR0_IDM;
-	}
-	if (dbg->bp[2]) {
-		mtspr(SPRN_IAC3, dbg->bp[2]);
-		dbcr0 |= DBCR0_IAC3 | DBCR0_IDM;
-	}
-	if (dbg->bp[3]) {
-		mtspr(SPRN_IAC4, dbg->bp[3]);
-		dbcr0 |= DBCR0_IAC4 | DBCR0_IDM;
-	}
-
-	mtspr(SPRN_DBCR0, dbcr0);
-	mtspr(SPRN_DBCR1, 0);
-	mtspr(SPRN_DBCR2, 0);
-}
-
 void kvmppc_core_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	kvmppc_44x_tlb_load(vcpu);
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index f30be9e..9057335 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -221,41 +221,18 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-	if (vcpu->guest_debug.enabled)
-		kvmppc_core_load_guest_debugstate(vcpu);
-
 	kvmppc_core_vcpu_load(vcpu, cpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->guest_debug.enabled)
-		kvmppc_core_load_host_debugstate(vcpu);
-
-	/* Don't leave guest TLB entries resident when being de-scheduled. */
-	/* XXX It would be nice to differentiate between heavyweight exit and
-	 * sched_out here, since we could avoid the TLB flush for heavyweight
-	 * exits. */
-	_tlbil_all();
 	kvmppc_core_vcpu_put(vcpu);
 }
 
 int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
-					struct kvm_guest_debug *dbg)
+                                        struct kvm_guest_debug *dbg)
 {
-	int i;
-
-	vcpu->guest_debug.enabled = dbg->enabled;
-	if (vcpu->guest_debug.enabled) {
-		for (i=0; i < ARRAY_SIZE(vcpu->guest_debug.bp); i++) {
-			if (dbg->breakpoints[i].enabled)
-				vcpu->guest_debug.bp[i] = dbg->breakpoints[i].address;
-			else
-				vcpu->guest_debug.bp[i] = 0;
-		}
-	}
-
-	return 0;
+	return -EINVAL;
 }
 
 static void kvmppc_complete_dcr_load(struct kvm_vcpu *vcpu,
-- 
1.6.0.6

