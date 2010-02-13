Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab0BMIGq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:06:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab0BMICF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:05 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 33/39] KVM: PPC: Keep SRR1 flags around in shadow_msr
Date: Sat, 13 Feb 2010 10:01:53 +0200
Message-Id: <1266048119-14325-34-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

SRR1 stores more information that just the MSR value. It also stores
valuable information about the type of interrupt we received, for
example whether the storage interrupt we just got was because of a
missing htab entry or not.

We use that information to speed up the exit path.

Now if we get preempted before we can interpret the shadow_msr values,
we get into vcpu_put which then calls the MSR handler, which then sets
all the SRR1 information bits in shadow_msr to 0. Great.

So let's preserve the SRR1 specific bits in shadow_msr whenever we set
the MSR. They don't hurt.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_host.h     |    1 +
 arch/powerpc/kernel/asm-offsets.c       |    1 +
 arch/powerpc/kvm/book3s.c               |   13 +++++++------
 arch/powerpc/kvm/book3s_64_interrupts.S |    2 +-
 4 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index c30a70c..715aa6b 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -198,6 +198,7 @@ struct kvm_vcpu_arch {
 	ulong msr;
 #ifdef CONFIG_PPC64
 	ulong shadow_msr;
+	ulong shadow_srr1;
 	ulong hflags;
 	ulong guest_owned_ext;
 #endif
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index ee99354..957ceb7 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -433,6 +433,7 @@ int main(void)
 	DEFINE(VCPU_HOST_R2, offsetof(struct kvm_vcpu, arch.host_r2));
 	DEFINE(VCPU_HOST_MSR, offsetof(struct kvm_vcpu, arch.host_msr));
 	DEFINE(VCPU_SHADOW_MSR, offsetof(struct kvm_vcpu, arch.shadow_msr));
+	DEFINE(VCPU_SHADOW_SRR1, offsetof(struct kvm_vcpu, arch.shadow_srr1));
 	DEFINE(VCPU_TRAMPOLINE_LOWMEM, offsetof(struct kvm_vcpu, arch.trampoline_lowmem));
 	DEFINE(VCPU_TRAMPOLINE_ENTER, offsetof(struct kvm_vcpu, arch.trampoline_enter));
 	DEFINE(VCPU_HIGHMEM_HANDLER, offsetof(struct kvm_vcpu, arch.highmem_handler));
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 2cb1813..58f5200 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -524,14 +524,14 @@ int kvmppc_handle_pagefault(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		/* Page not found in guest PTE entries */
 		vcpu->arch.dear = vcpu->arch.fault_dear;
 		to_book3s(vcpu)->dsisr = vcpu->arch.fault_dsisr;
-		vcpu->arch.msr |= (vcpu->arch.shadow_msr & 0x00000000f8000000ULL);
+		vcpu->arch.msr |= (vcpu->arch.shadow_srr1 & 0x00000000f8000000ULL);
 		kvmppc_book3s_queue_irqprio(vcpu, vec);
 	} else if (page_found == -EPERM) {
 		/* Storage protection */
 		vcpu->arch.dear = vcpu->arch.fault_dear;
 		to_book3s(vcpu)->dsisr = vcpu->arch.fault_dsisr & ~DSISR_NOHPTE;
 		to_book3s(vcpu)->dsisr |= DSISR_PROTFAULT;
-		vcpu->arch.msr |= (vcpu->arch.shadow_msr & 0x00000000f8000000ULL);
+		vcpu->arch.msr |= (vcpu->arch.shadow_srr1 & 0x00000000f8000000ULL);
 		kvmppc_book3s_queue_irqprio(vcpu, vec);
 	} else if (page_found == -EINVAL) {
 		/* Page not found in guest SLB */
@@ -693,7 +693,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 	case BOOK3S_INTERRUPT_INST_STORAGE:
 		vcpu->stat.pf_instruc++;
 		/* only care about PTEG not found errors, but leave NX alone */
-		if (vcpu->arch.shadow_msr & 0x40000000) {
+		if (vcpu->arch.shadow_srr1 & 0x40000000) {
 			r = kvmppc_handle_pagefault(run, vcpu, vcpu->arch.pc, exit_nr);
 			vcpu->stat.sp_instruc++;
 		} else if (vcpu->arch.mmu.is_dcbz32(vcpu) &&
@@ -705,7 +705,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			 */
 			kvmppc_mmu_pte_flush(vcpu, vcpu->arch.pc, ~0xFFFULL);
 		} else {
-			vcpu->arch.msr |= (vcpu->arch.shadow_msr & 0x58000000);
+			vcpu->arch.msr |= vcpu->arch.shadow_srr1 & 0x58000000;
 			kvmppc_book3s_queue_irqprio(vcpu, exit_nr);
 			kvmppc_mmu_pte_flush(vcpu, vcpu->arch.pc, ~0xFFFULL);
 			r = RESUME_GUEST;
@@ -753,7 +753,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		enum emulation_result er;
 		ulong flags;
 
-		flags = (vcpu->arch.shadow_msr & 0x1f0000ull);
+		flags = vcpu->arch.shadow_srr1 & 0x1f0000ull;
 
 		if (vcpu->arch.msr & MSR_PR) {
 #ifdef EXIT_DEBUG
@@ -808,7 +808,8 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		break;
 	default:
 		/* Ugh - bork here! What did we get? */
-		printk(KERN_EMERG "exit_nr=0x%x | pc=0x%lx | msr=0x%lx\n", exit_nr, vcpu->arch.pc, vcpu->arch.shadow_msr);
+		printk(KERN_EMERG "exit_nr=0x%x | pc=0x%lx | msr=0x%lx\n",
+			exit_nr, vcpu->arch.pc, vcpu->arch.shadow_srr1);
 		r = RESUME_HOST;
 		BUG();
 		break;
diff --git a/arch/powerpc/kvm/book3s_64_interrupts.S b/arch/powerpc/kvm/book3s_64_interrupts.S
index 2ff0b21..c1584d0 100644
--- a/arch/powerpc/kvm/book3s_64_interrupts.S
+++ b/arch/powerpc/kvm/book3s_64_interrupts.S
@@ -169,7 +169,7 @@ kvmppc_handler_highmem:
 	stw	r0, VCPU_LAST_INST(r7)
 
 	std	r3, VCPU_PC(r7)
-	std	r4, VCPU_SHADOW_MSR(r7)
+	std	r4, VCPU_SHADOW_SRR1(r7)
 	std	r5, VCPU_FAULT_DEAR(r7)
 	std	r6, VCPU_FAULT_DSISR(r7)
 
-- 
1.6.5.3

