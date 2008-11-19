Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbYKSTSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbYKSTSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 14:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365AbYKSTSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 14:18:33 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:41176 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbYKSTSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 14:18:31 -0500
From: Trent Piepho <tpiepho@freescale.com>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org, Gala Kumar <kumar.gala@freescale.com>,
       Trent Piepho <tpiepho@freescale.com>
Subject: [PATCH] powerpc: Better setup of boot page TLB entry
Date: Wed, 19 Nov 2008 11:14:30 -0800
Message-Id: <1227122070-6835-1-git-send-email-tpiepho@freescale.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initial TLB mapping for the kernel boot didn't set the memory coherent
attribute, MAS2[M], in SMP mode.

If this code supported booting a secondary processor, which it doesn't yet,
but suppose it did, then when a secondary processor boots, it would have
probably signaled the primary processor by setting a variable called
something like __secondary_hold_acknowledge.  However, due to the lack of
the M bit, the primary processor would not have snooped the transaction
(even if a transaction were broadcast).  If primary CPU's L1 D-cache had a
copy, it would not have been flushed and the CPU would have never seen the
ack.  Which would have resulted in the primary CPU spinning for a long
time, perhaps a full second before it would have given up, while it would
have waited for the ack from the secondary CPU that it wouldn't have been
able to see because of the stale cache.

The value of MAS2 for the boot page TLB1 entry is a compile time constant,
so there is no need to calculate it in powerpc assembly language.

Also, from the MPC8572 manual section 6.12.5.3, "Bits that represent
offsets within a page are ignored and should be cleared." Existing code
didn't clear them, this code does.

The same when the page of KERNELBASE is found; we don't need to use asm to
mask the lower 12 bits off.

In the code that computes the address to rfi from, don't hard code the
offset to 24 bytes, but have the assembler figure that out for us.

Signed-off-by: Trent Piepho <tpiepho@freescale.com>
Acked-by: Kumar Gala <galak@kernel.crashing.org>
---
 arch/powerpc/include/asm/mmu-fsl-booke.h |    2 ++
 arch/powerpc/kernel/head_fsl_booke.S     |   22 +++++++++++++---------
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/include/asm/mmu-fsl-booke.h b/arch/powerpc/include/asm/mmu-fsl-booke.h
index 925d93c..5588a41 100644
--- a/arch/powerpc/include/asm/mmu-fsl-booke.h
+++ b/arch/powerpc/include/asm/mmu-fsl-booke.h
@@ -40,6 +40,8 @@
 #define MAS2_M		0x00000004
 #define MAS2_G		0x00000002
 #define MAS2_E		0x00000001
+#define MAS2_EPN_MASK(size)		(~0 << (2*(size) + 10))
+#define MAS2_VAL(addr, size, flags)	((addr) & MAS2_EPN_MASK(size) | (flags))
 
 #define MAS3_RPN	0xFFFFF000
 #define MAS3_U0		0x00000200
diff --git a/arch/powerpc/kernel/head_fsl_booke.S b/arch/powerpc/kernel/head_fsl_booke.S
index 590304c..e621eac 100644
--- a/arch/powerpc/kernel/head_fsl_booke.S
+++ b/arch/powerpc/kernel/head_fsl_booke.S
@@ -235,36 +235,40 @@ skpinv:	addi	r6,r6,1				/* Increment */
 	tlbivax 0,r9
 	TLBSYNC
 
+/* The mapping only needs to be cache-coherent on SMP */
+#ifdef CONFIG_SMP
+#define	M_IF_SMP	MAS2_M
+#else
+#define M_IF_SMP	0
+#endif
+
 /* 6. Setup KERNELBASE mapping in TLB1[0] */
 	lis	r6,0x1000		/* Set MAS0(TLBSEL) = TLB1(1), ESEL = 0 */
 	mtspr	SPRN_MAS0,r6
 	lis	r6,(MAS1_VALID|MAS1_IPROT)@h
 	ori	r6,r6,(MAS1_TSIZE(BOOKE_PAGESZ_64M))@l
 	mtspr	SPRN_MAS1,r6
-	li	r7,0
-	lis	r6,PAGE_OFFSET@h
-	ori	r6,r6,PAGE_OFFSET@l
-	rlwimi	r6,r7,0,20,31
+	lis	r6,MAS2_VAL(PAGE_OFFSET, BOOKE_PAGESZ_64M, M_IF_SMP)@h
+	ori	r6,r6,MAS2_VAL(PAGE_OFFSET, BOOKE_PAGESZ_64M, M_IF_SMP)@l
 	mtspr	SPRN_MAS2,r6
 	mtspr	SPRN_MAS3,r8
 	tlbwe
 
 /* 7. Jump to KERNELBASE mapping */
-	lis	r6,KERNELBASE@h
-	ori	r6,r6,KERNELBASE@l
-	rlwimi	r6,r7,0,20,31
+	lis	r6,(KERNELBASE & ~0xfff)@h
+	ori	r6,r6,(KERNELBASE & ~0xfff)@l
 	lis	r7,MSR_KERNEL@h
 	ori	r7,r7,MSR_KERNEL@l
 	bl	1f			/* Find our address */
 1:	mflr	r9
 	rlwimi	r6,r9,0,20,31
-	addi	r6,r6,24
+	addi	r6,r6,(2f - 1b)
 	mtspr	SPRN_SRR0,r6
 	mtspr	SPRN_SRR1,r7
 	rfi				/* start execution out of TLB1[0] entry */
 
 /* 8. Clear out the temp mapping */
-	lis	r7,0x1000	/* Set MAS0(TLBSEL) = 1 */
+2:	lis	r7,0x1000	/* Set MAS0(TLBSEL) = 1 */
 	rlwimi	r7,r5,16,4,15	/* Setup MAS0 = TLBSEL | ESEL(r5) */
 	mtspr	SPRN_MAS0,r7
 	tlbre
-- 
1.5.4.1

