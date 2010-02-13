Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab0BMICn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:02:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257Ab0BMICD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:03 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/39] KVM: PPC: Get rid of unnecessary RFI
Date: Sat, 13 Feb 2010 10:01:30 +0200
Message-Id: <1266048119-14325-11-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

Using an RFI in IR=1 is dangerous. We need to set two SRRs and then do an RFI
without getting interrupted at all, because every interrupt could potentially
overwrite the SRR values.

Fortunately, we don't need to RFI in at least this particular case of the code,
so we can just replace it with an mtmsr and b.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/book3s_64_interrupts.S |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_interrupts.S b/arch/powerpc/kvm/book3s_64_interrupts.S
index 66e3b11..3c0ba55 100644
--- a/arch/powerpc/kvm/book3s_64_interrupts.S
+++ b/arch/powerpc/kvm/book3s_64_interrupts.S
@@ -221,15 +221,8 @@ no_dcbz32_off:
 	mflr	r5
 	std	r5, VCPU_LR(r7)
 
-	/* XXX convert to safe function call */
-
 	/* Restore host msr -> SRR1 */
 	ld	r6, VCPU_HOST_MSR(r7)
-	mtsrr1	r6
-
-	/* Restore host IP -> SRR0 */
-	ld	r5, VCPU_HOST_RETIP(r7)
-	mtsrr0	r5
 
 	/*
 	 * For some interrupts, we need to call the real Linux
@@ -246,8 +239,9 @@ no_dcbz32_off:
 	cmpwi	r12, BOOK3S_INTERRUPT_DECREMENTER
 	beq	call_linux_handler
 
-	/* Back to Interruptable Mode! (goto kvm_return_point) */
-	RFI
+	/* Back to EE=1 */
+	mtmsr	r6
+	b	kvm_return_point
 
 call_linux_handler:
 
@@ -260,10 +254,16 @@ call_linux_handler:
 	 * interrupt handler!
 	 *
 	 * R3 still contains the exit code,
-	 * R6 VCPU_HOST_RETIP and
-	 * R7 VCPU_HOST_MSR
+	 * R5 VCPU_HOST_RETIP and
+	 * R6 VCPU_HOST_MSR
 	 */
 
+	/* Restore host IP -> SRR0 */
+	ld	r5, VCPU_HOST_RETIP(r7)
+
+	/* XXX Better move to a safe function?
+	 *     What if we get an HTAB flush in between mtsrr0 and mtsrr1? */
+
 	mtlr	r12
 
 	ld	r4, VCPU_TRAMPOLINE_LOWMEM(r7)
-- 
1.6.5.3

