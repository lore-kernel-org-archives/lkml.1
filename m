Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbYIWN5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbYIWN5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbYIWNsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:48:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52461 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbYIWNsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:48:07 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 27/40] KVM: ppc: Stop saving host TLB state
Date: Tue, 23 Sep 2008 16:46:41 +0300
Message-Id: <1222177614-26669-28-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

We're saving the host TLB state to memory on every exit, but never using it.
Originally I had thought that we'd want to restore host TLB for heavyweight
exits, but that could actually hurt when context switching to an unrelated host
process (i.e. not qemu).

Since this decreases the performance penalty of all exits, this patch improves
guest boot time by about 15%.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/powerpc/include/asm/kvm_host.h |    2 --
 arch/powerpc/kernel/asm-offsets.c   |    1 -
 arch/powerpc/kvm/booke_interrupts.S |   17 +++--------------
 3 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 23bad40..dc3a756 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -81,8 +81,6 @@ struct kvm_vcpu_arch {
 	struct tlbe shadow_tlb[PPC44x_TLB_SIZE];
 	/* Pages which are referenced in the shadow TLB. */
 	struct page *shadow_pages[PPC44x_TLB_SIZE];
-	/* Copy of the host's TLB. */
-	struct tlbe host_tlb[PPC44x_TLB_SIZE];
 
 	u32 host_stack;
 	u32 host_pid;
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 92768d3..5940649 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -356,7 +356,6 @@ int main(void)
 
 	DEFINE(VCPU_HOST_STACK, offsetof(struct kvm_vcpu, arch.host_stack));
 	DEFINE(VCPU_HOST_PID, offsetof(struct kvm_vcpu, arch.host_pid));
-	DEFINE(VCPU_HOST_TLB, offsetof(struct kvm_vcpu, arch.host_tlb));
 	DEFINE(VCPU_SHADOW_TLB, offsetof(struct kvm_vcpu, arch.shadow_tlb));
 	DEFINE(VCPU_GPRS, offsetof(struct kvm_vcpu, arch.gpr));
 	DEFINE(VCPU_LR, offsetof(struct kvm_vcpu, arch.lr));
diff --git a/arch/powerpc/kvm/booke_interrupts.S b/arch/powerpc/kvm/booke_interrupts.S
index 8eaba26..3e88dfa 100644
--- a/arch/powerpc/kvm/booke_interrupts.S
+++ b/arch/powerpc/kvm/booke_interrupts.S
@@ -342,26 +342,15 @@ lightweight_exit:
 	andc	r6, r5, r6
 	mtmsr	r6
 
-	/* Save the host's non-pinned TLB mappings, and load the guest mappings
-	 * over them. Leave the host's "pinned" kernel mappings in place. */
-	/* XXX optimization: use generation count to avoid swapping unmodified
-	 * entries. */
+	/* Load the guest mappings, leaving the host's "pinned" kernel mappings
+	 * in place. */
+	/* XXX optimization: load only modified guest entries. */
 	mfspr	r10, SPRN_MMUCR			/* Save host MMUCR. */
 	lis	r8, tlb_44x_hwater@ha
 	lwz	r8, tlb_44x_hwater@l(r8)
-	addi	r3, r4, VCPU_HOST_TLB - 4
 	addi	r9, r4, VCPU_SHADOW_TLB - 4
 	li	r6, 0
 1:
-	/* Save host entry. */
-	tlbre	r7, r6, PPC44x_TLB_PAGEID
-	mfspr	r5, SPRN_MMUCR
-	stwu	r5, 4(r3)
-	stwu	r7, 4(r3)
-	tlbre	r7, r6, PPC44x_TLB_XLAT
-	stwu	r7, 4(r3)
-	tlbre	r7, r6, PPC44x_TLB_ATTRIB
-	stwu	r7, 4(r3)
 	/* Load guest entry. */
 	lwzu	r7, 4(r9)
 	mtspr	SPRN_MMUCR, r7
-- 
1.6.0.1

