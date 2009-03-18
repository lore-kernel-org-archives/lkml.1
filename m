Return-Path: <linux-kernel-owner+w=401wt.eu-S1760922AbZCRV4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760922AbZCRV4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758616AbZCRVoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:44:15 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54475 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758556AbZCRVoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:44:12 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 17/57] microblaze_v7: supported function for memory - kernel/lib
Date: Wed, 18 Mar 2009 21:30:44 +0100
Message-Id: <1477ec41e7ba0ec847a064e1f8e422dc2a5dcc9f.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <eb4ccc67cf39abc816c8d7653fdc7561d14c1da2.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
 <f7c1685bd3f387be8633db5fb3dd4cb5e7c2d792.1237407249.git.monstr@monstr.eu>
 <2f48efc353c11dfdfc7b052bdfe052b71c09ab23.1237407249.git.monstr@monstr.eu>
 <f7f2d17e21a3df9931c75976c37a003d11190cc9.1237407249.git.monstr@monstr.eu>
 <58cf06c85e07477170677b72ce3437af10476bec.1237407249.git.monstr@monstr.eu>
 <eaa0169a360a328883ab0eabd2a189c21bad4c30.1237407249.git.monstr@monstr.eu>
 <20227d6f2615060d6560785090513e251cbe2654.1237407249.git.monstr@monstr.eu>
 <69ef4f976d86c870a97fbe4974c242c74acc477d.1237407249.git.monstr@monstr.eu>
 <eb4ccc67cf39abc816c8d7653fdc7561d14c1da2.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/lib/fastcopy.S |  660 ++++++++++++++++++++++++++++++++++++++++
 arch/microblaze/lib/memcpy.c   |  160 ++++++++++
 arch/microblaze/lib/memmove.c  |  174 +++++++++++
 arch/microblaze/lib/memset.c   |   81 +++++
 4 files changed, 1075 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/lib/fastcopy.S
 create mode 100644 arch/microblaze/lib/memcpy.c
 create mode 100644 arch/microblaze/lib/memmove.c
 create mode 100644 arch/microblaze/lib/memset.c

diff --git a/arch/microblaze/lib/fastcopy.S b/arch/microblaze/lib/fastcopy.S
new file mode 100644
index 0000000..df5e4ad
--- /dev/null
+++ b/arch/microblaze/lib/fastcopy.S
@@ -0,0 +1,660 @@
+/*
+ * Copyright 2008 (c) Jim Law - Iris LP  All rights reserved.
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License.  See the file COPYING in the main directory of this
+ * archive for more details.
+ *
+ * Written by Jim Law <jlaw@irispower.com>
+ *
+ * intended to replace:
+ *	memcpy in memcpy.c and
+ *	memmove in memmove.c
+ * ... in arch/microblaze/lib
+ *
+ *
+ * assly_fastcopy.S
+ *
+ * Attempt at quicker memcpy and memmove for MicroBlaze
+ *	Input :	Operand1 in Reg r5 - destination address
+ *		Operand2 in Reg r6 - source address
+ *		Operand3 in Reg r7 - number of bytes to transfer
+ *	Output: Result in Reg r3 - starting destinaition address
+ *
+ *
+ * Explanation:
+ *	Perform (possibly unaligned) copy of a block of memory
+ *	between mem locations with size of xfer spec'd in bytes
+ */
+
+#include <linux/linkage.h>
+
+	.globl	memcpy
+	.ent	memcpy
+
+memcpy:
+fast_memcpy_ascending:
+	/* move d to return register as value of function */
+	addi	r3, r5, 0
+
+	addi	r4, r0, 4	/* n = 4 */
+	cmpu	r4, r4, r7	/* n = c - n  (unsigned) */
+	blti	r4, a_xfer_end	/* if n < 0, less than one word to transfer */
+
+	/* transfer first 0~3 bytes to get aligned dest address */
+	andi	r4, r5, 3		/* n = d & 3 */
+	/* if zero, destination already aligned */
+	beqi	r4, a_dalign_done
+	/* n = 4 - n (yields 3, 2, 1 transfers for 1, 2, 3 addr offset) */
+	rsubi	r4, r4, 4
+	rsub	r7, r4, r7		/* c = c - n adjust c */
+
+a_xfer_first_loop:
+	/* if no bytes left to transfer, transfer the bulk */
+	beqi	r4, a_dalign_done
+	lbui	r11, r6, 0		/* h = *s */
+	sbi	r11, r5, 0		/* *d = h */
+	addi	r6, r6, 1		/* s++ */
+	addi	r5, r5, 1		/* d++ */
+	brid	a_xfer_first_loop	/* loop */
+	addi	r4, r4, -1		/* n-- (IN DELAY SLOT) */
+
+a_dalign_done:
+	addi	r4, r0, 32		/* n = 32 */
+	cmpu	r4, r4, r7		/* n = c - n  (unsigned) */
+	/* if n < 0, less than one block to transfer */
+	blti	r4, a_block_done
+
+a_block_xfer:
+	andi	r4, r7, 0xffffffe0	/* n = c & ~31 */
+	rsub	r7, r4, r7		/* c = c - n */
+
+	andi	r9, r6, 3		/* t1 = s & 3 */
+	/* if temp != 0, unaligned transfers needed */
+	bnei	r9, a_block_unaligned
+
+a_block_aligned:
+	lwi	r9, r6, 0		/* t1 = *(s + 0) */
+	lwi	r10, r6, 4		/* t2 = *(s + 4) */
+	lwi	r11, r6, 8		/* t3 = *(s + 8) */
+	lwi	r12, r6, 12		/* t4 = *(s + 12) */
+	swi	r9, r5, 0		/* *(d + 0) = t1 */
+	swi	r10, r5, 4		/* *(d + 4) = t2 */
+	swi	r11, r5, 8		/* *(d + 8) = t3 */
+	swi	r12, r5, 12		/* *(d + 12) = t4 */
+	lwi	r9, r6, 16		/* t1 = *(s + 16) */
+	lwi	r10, r6, 20		/* t2 = *(s + 20) */
+	lwi	r11, r6, 24		/* t3 = *(s + 24) */
+	lwi	r12, r6, 28		/* t4 = *(s + 28) */
+	swi	r9, r5, 16		/* *(d + 16) = t1 */
+	swi	r10, r5, 20		/* *(d + 20) = t2 */
+	swi	r11, r5, 24		/* *(d + 24) = t3 */
+	swi	r12, r5, 28		/* *(d + 28) = t4 */
+	addi	r6, r6, 32		/* s = s + 32 */
+	addi	r4, r4, -32		/* n = n - 32 */
+	bneid	r4, a_block_aligned	/* while (n) loop */
+	addi	r5, r5, 32		/* d = d + 32 (IN DELAY SLOT) */
+	bri	a_block_done
+
+a_block_unaligned:
+	andi	r8, r6, 0xfffffffc	/* as = s & ~3 */
+	add	r6, r6, r4		/* s = s + n */
+	lwi	r11, r8, 0		/* h = *(as + 0) */
+
+	addi	r9, r9, -1
+	beqi	r9, a_block_u1		/* t1 was 1 => 1 byte offset */
+	addi	r9, r9, -1
+	beqi	r9, a_block_u2		/* t1 was 2 => 2 byte offset */
+
+a_block_u3:
+	bslli	r11, r11, 24	/* h = h << 24 */
+a_bu3_loop:
+	lwi	r12, r8, 4	/* v = *(as + 4) */
+	bsrli	r9, r12, 8	/* t1 = v >> 8 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 0	/* *(d + 0) = t1 */
+	bslli	r11, r12, 24	/* h = v << 24 */
+	lwi	r12, r8, 8	/* v = *(as + 8) */
+	bsrli	r9, r12, 8	/* t1 = v >> 8 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 4	/* *(d + 4) = t1 */
+	bslli	r11, r12, 24	/* h = v << 24 */
+	lwi	r12, r8, 12	/* v = *(as + 12) */
+	bsrli	r9, r12, 8	/* t1 = v >> 8 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 8	/* *(d + 8) = t1 */
+	bslli	r11, r12, 24	/* h = v << 24 */
+	lwi	r12, r8, 16	/* v = *(as + 16) */
+	bsrli	r9, r12, 8	/* t1 = v >> 8 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 12	/* *(d + 12) = t1 */
+	bslli	r11, r12, 24	/* h = v << 24 */
+	lwi	r12, r8, 20	/* v = *(as + 20) */
+	bsrli	r9, r12, 8	/* t1 = v >> 8 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 16	/* *(d + 16) = t1 */
+	bslli	r11, r12, 24	/* h = v << 24 */
+	lwi	r12, r8, 24	/* v = *(as + 24) */
+	bsrli	r9, r12, 8	/* t1 = v >> 8 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 20	/* *(d + 20) = t1 */
+	bslli	r11, r12, 24	/* h = v << 24 */
+	lwi	r12, r8, 28	/* v = *(as + 28) */
+	bsrli	r9, r12, 8	/* t1 = v >> 8 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 24	/* *(d + 24) = t1 */
+	bslli	r11, r12, 24	/* h = v << 24 */
+	lwi	r12, r8, 32	/* v = *(as + 32) */
+	bsrli	r9, r12, 8	/* t1 = v >> 8 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 28	/* *(d + 28) = t1 */
+	bslli	r11, r12, 24	/* h = v << 24 */
+	addi	r8, r8, 32	/* as = as + 32 */
+	addi	r4, r4, -32	/* n = n - 32 */
+	bneid	r4, a_bu3_loop	/* while (n) loop */
+	addi	r5, r5, 32	/* d = d + 32 (IN DELAY SLOT) */
+	bri	a_block_done
+
+a_block_u1:
+	bslli	r11, r11, 8	/* h = h << 8 */
+a_bu1_loop:
+	lwi	r12, r8, 4	/* v = *(as + 4) */
+	bsrli	r9, r12, 24	/* t1 = v >> 24 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 0	/* *(d + 0) = t1 */
+	bslli	r11, r12, 8	/* h = v << 8 */
+	lwi	r12, r8, 8	/* v = *(as + 8) */
+	bsrli	r9, r12, 24	/* t1 = v >> 24 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 4	/* *(d + 4) = t1 */
+	bslli	r11, r12, 8	/* h = v << 8 */
+	lwi	r12, r8, 12	/* v = *(as + 12) */
+	bsrli	r9, r12, 24	/* t1 = v >> 24 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 8	/* *(d + 8) = t1 */
+	bslli	r11, r12, 8	/* h = v << 8 */
+	lwi	r12, r8, 16	/* v = *(as + 16) */
+	bsrli	r9, r12, 24	/* t1 = v >> 24 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 12	/* *(d + 12) = t1 */
+	bslli	r11, r12, 8	/* h = v << 8 */
+	lwi	r12, r8, 20	/* v = *(as + 20) */
+	bsrli	r9, r12, 24	/* t1 = v >> 24 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 16	/* *(d + 16) = t1 */
+	bslli	r11, r12, 8	/* h = v << 8 */
+	lwi	r12, r8, 24	/* v = *(as + 24) */
+	bsrli	r9, r12, 24	/* t1 = v >> 24 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 20	/* *(d + 20) = t1 */
+	bslli	r11, r12, 8	/* h = v << 8 */
+	lwi	r12, r8, 28	/* v = *(as + 28) */
+	bsrli	r9, r12, 24	/* t1 = v >> 24 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 24	/* *(d + 24) = t1 */
+	bslli	r11, r12, 8	/* h = v << 8 */
+	lwi	r12, r8, 32	/* v = *(as + 32) */
+	bsrli	r9, r12, 24	/* t1 = v >> 24 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 28	/* *(d + 28) = t1 */
+	bslli	r11, r12, 8	/* h = v << 8 */
+	addi	r8, r8, 32	/* as = as + 32 */
+	addi	r4, r4, -32	/* n = n - 32 */
+	bneid	r4, a_bu1_loop	/* while (n) loop */
+	addi	r5, r5, 32	/* d = d + 32 (IN DELAY SLOT) */
+	bri	a_block_done
+
+a_block_u2:
+	bslli	r11, r11, 16	/* h = h << 16 */
+a_bu2_loop:
+	lwi	r12, r8, 4	/* v = *(as + 4) */
+	bsrli	r9, r12, 16	/* t1 = v >> 16 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 0	/* *(d + 0) = t1 */
+	bslli	r11, r12, 16	/* h = v << 16 */
+	lwi	r12, r8, 8	/* v = *(as + 8) */
+	bsrli	r9, r12, 16	/* t1 = v >> 16 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 4	/* *(d + 4) = t1 */
+	bslli	r11, r12, 16	/* h = v << 16 */
+	lwi	r12, r8, 12	/* v = *(as + 12) */
+	bsrli	r9, r12, 16	/* t1 = v >> 16 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 8	/* *(d + 8) = t1 */
+	bslli	r11, r12, 16	/* h = v << 16 */
+	lwi	r12, r8, 16	/* v = *(as + 16) */
+	bsrli	r9, r12, 16	/* t1 = v >> 16 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 12	/* *(d + 12) = t1 */
+	bslli	r11, r12, 16	/* h = v << 16 */
+	lwi	r12, r8, 20	/* v = *(as + 20) */
+	bsrli	r9, r12, 16	/* t1 = v >> 16 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 16	/* *(d + 16) = t1 */
+	bslli	r11, r12, 16	/* h = v << 16 */
+	lwi	r12, r8, 24	/* v = *(as + 24) */
+	bsrli	r9, r12, 16	/* t1 = v >> 16 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 20	/* *(d + 20) = t1 */
+	bslli	r11, r12, 16	/* h = v << 16 */
+	lwi	r12, r8, 28	/* v = *(as + 28) */
+	bsrli	r9, r12, 16	/* t1 = v >> 16 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 24	/* *(d + 24) = t1 */
+	bslli	r11, r12, 16	/* h = v << 16 */
+	lwi	r12, r8, 32	/* v = *(as + 32) */
+	bsrli	r9, r12, 16	/* t1 = v >> 16 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 28	/* *(d + 28) = t1 */
+	bslli	r11, r12, 16	/* h = v << 16 */
+	addi	r8, r8, 32	/* as = as + 32 */
+	addi	r4, r4, -32	/* n = n - 32 */
+	bneid	r4, a_bu2_loop	/* while (n) loop */
+	addi	r5, r5, 32	/* d = d + 32 (IN DELAY SLOT) */
+
+a_block_done:
+	addi	r4, r0, 4	/* n = 4 */
+	cmpu	r4, r4, r7	/* n = c - n  (unsigned) */
+	blti	r4, a_xfer_end	/* if n < 0, less than one word to transfer */
+
+a_word_xfer:
+	andi	r4, r7, 0xfffffffc	/* n = c & ~3 */
+	addi	r10, r0, 0		/* offset = 0 */
+
+	andi	r9, r6, 3		/* t1 = s & 3 */
+	/* if temp != 0, unaligned transfers needed */
+	bnei	r9, a_word_unaligned
+
+a_word_aligned:
+	lw	r9, r6, r10		/* t1 = *(s+offset) */
+	sw	r9, r5, r10		/* *(d+offset) = t1 */
+	addi	r4, r4,-4		/* n-- */
+	bneid	r4, a_word_aligned	/* loop */
+	addi	r10, r10, 4		/* offset++ (IN DELAY SLOT) */
+
+	bri	a_word_done
+
+a_word_unaligned:
+	andi	r8, r6, 0xfffffffc	/* as = s & ~3 */
+	lwi	r11, r8, 0		/* h = *(as + 0) */
+	addi	r8, r8, 4		/* as = as + 4 */
+
+	addi	r9, r9, -1
+	beqi	r9, a_word_u1		/* t1 was 1 => 1 byte offset */
+	addi	r9, r9, -1
+	beqi	r9, a_word_u2		/* t1 was 2 => 2 byte offset */
+
+a_word_u3:
+	bslli	r11, r11, 24	/* h = h << 24 */
+a_wu3_loop:
+	lw	r12, r8, r10	/* v = *(as + offset) */
+	bsrli	r9, r12, 8	/* t1 = v >> 8 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	sw	r9, r5, r10	/* *(d + offset) = t1 */
+	bslli	r11, r12, 24	/* h = v << 24 */
+	addi	r4, r4,-4	/* n = n - 4 */
+	bneid	r4, a_wu3_loop	/* while (n) loop */
+	addi	r10, r10, 4	/* offset = ofset + 4 (IN DELAY SLOT) */
+
+	bri	a_word_done
+
+a_word_u1:
+	bslli	r11, r11, 8	/* h = h << 8 */
+a_wu1_loop:
+	lw	r12, r8, r10	/* v = *(as + offset) */
+	bsrli	r9, r12, 24	/* t1 = v >> 24 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	sw	r9, r5, r10	/* *(d + offset) = t1 */
+	bslli	r11, r12, 8	/* h = v << 8 */
+	addi	r4, r4,-4	/* n = n - 4 */
+	bneid	r4, a_wu1_loop	/* while (n) loop */
+	addi	r10, r10, 4	/* offset = ofset + 4 (IN DELAY SLOT) */
+
+	bri	a_word_done
+
+a_word_u2:
+	bslli	r11, r11, 16	/* h = h << 16 */
+a_wu2_loop:
+	lw	r12, r8, r10	/* v = *(as + offset) */
+	bsrli	r9, r12, 16	/* t1 = v >> 16 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	sw	r9, r5, r10	/* *(d + offset) = t1 */
+	bslli	r11, r12, 16	/* h = v << 16 */
+	addi	r4, r4,-4	/* n = n - 4 */
+	bneid	r4, a_wu2_loop	/* while (n) loop */
+	addi	r10, r10, 4	/* offset = ofset + 4 (IN DELAY SLOT) */
+
+a_word_done:
+	add	r5, r5, r10	/* d = d + offset */
+	add	r6, r6, r10	/* s = s + offset */
+	rsub	r7, r10, r7	/* c = c - offset */
+
+a_xfer_end:
+a_xfer_end_loop:
+	beqi	r7, a_done		/* while (c) */
+	lbui	r9, r6, 0		/* t1 = *s */
+	addi	r6, r6, 1		/* s++ */
+	sbi	r9, r5, 0		/* *d = t1 */
+	addi	r7, r7, -1		/* c-- */
+	brid	a_xfer_end_loop		/* loop */
+	addi	r5, r5, 1		/* d++ (IN DELAY SLOT) */
+
+a_done:
+	rtsd	r15, 8
+	nop
+
+.end memcpy
+/*----------------------------------------------------------------------------*/
+	.globl	memmove
+	.ent	memmove
+
+memmove:
+	cmpu	r4, r5, r6	/* n = s - d */
+	bgei	r4,fast_memcpy_ascending
+
+fast_memcpy_descending:
+	/* move d to return register as value of function */
+	addi	r3, r5, 0
+
+	add	r5, r5, r7	/* d = d + c */
+	add	r6, r6, r7	/* s = s + c */
+
+	addi	r4, r0, 4	/* n = 4 */
+	cmpu	r4, r4, r7	/* n = c - n  (unsigned) */
+	blti	r4,d_xfer_end	/* if n < 0, less than one word to transfer */
+
+	/* transfer first 0~3 bytes to get aligned dest address */
+	andi	r4, r5, 3		/* n = d & 3 */
+	/* if zero, destination already aligned */
+	beqi	r4,d_dalign_done
+	rsub	r7, r4, r7		/* c = c - n adjust c */
+
+d_xfer_first_loop:
+	/* if no bytes left to transfer, transfer the bulk */
+	beqi	r4,d_dalign_done
+	addi	r6, r6, -1		/* s-- */
+	addi	r5, r5, -1		/* d-- */
+	lbui	r11, r6, 0		/* h = *s */
+	sbi	r11, r5, 0		/* *d = h */
+	brid	d_xfer_first_loop	/* loop */
+	addi	r4, r4, -1		/* n-- (IN DELAY SLOT) */
+
+d_dalign_done:
+	addi	r4, r0, 32	/* n = 32 */
+	cmpu	r4, r4, r7	/* n = c - n  (unsigned) */
+	/* if n < 0, less than one block to transfer */
+	blti	r4, d_block_done
+
+d_block_xfer:
+	andi	r4, r7, 0xffffffe0	/* n = c & ~31 */
+	rsub	r7, r4, r7		/* c = c - n */
+
+	andi	r9, r6, 3		/* t1 = s & 3 */
+	/* if temp != 0, unaligned transfers needed */
+	bnei	r9, d_block_unaligned
+
+d_block_aligned:
+	addi	r6, r6, -32		/* s = s - 32 */
+	addi	r5, r5, -32		/* d = d - 32 */
+	lwi	r9, r6, 28		/* t1 = *(s + 28) */
+	lwi	r10, r6, 24		/* t2 = *(s + 24) */
+	lwi	r11, r6, 20		/* t3 = *(s + 20) */
+	lwi	r12, r6, 16		/* t4 = *(s + 16) */
+	swi	r9, r5, 28		/* *(d + 28) = t1 */
+	swi	r10, r5, 24		/* *(d + 24) = t2 */
+	swi	r11, r5, 20		/* *(d + 20) = t3 */
+	swi	r12, r5, 16		/* *(d + 16) = t4 */
+	lwi	r9, r6, 12		/* t1 = *(s + 12) */
+	lwi	r10, r6, 8		/* t2 = *(s + 8) */
+	lwi	r11, r6, 4		/* t3 = *(s + 4) */
+	lwi	r12, r6, 0		/* t4 = *(s + 0) */
+	swi	r9, r5, 12		/* *(d + 12) = t1 */
+	swi	r10, r5, 8		/* *(d + 8) = t2 */
+	swi	r11, r5, 4		/* *(d + 4) = t3 */
+	addi	r4, r4, -32		/* n = n - 32 */
+	bneid	r4, d_block_aligned	/* while (n) loop */
+	swi	r12, r5, 0		/* *(d + 0) = t4 (IN DELAY SLOT) */
+	bri	d_block_done
+
+d_block_unaligned:
+	andi	r8, r6, 0xfffffffc	/* as = s & ~3 */
+	rsub	r6, r4, r6		/* s = s - n */
+	lwi	r11, r8, 0		/* h = *(as + 0) */
+
+	addi	r9, r9, -1
+	beqi	r9,d_block_u1		/* t1 was 1 => 1 byte offset */
+	addi	r9, r9, -1
+	beqi	r9,d_block_u2		/* t1 was 2 => 2 byte offset */
+
+d_block_u3:
+	bsrli	r11, r11, 8	/* h = h >> 8 */
+d_bu3_loop:
+	addi	r8, r8, -32	/* as = as - 32 */
+	addi	r5, r5, -32	/* d = d - 32 */
+	lwi	r12, r8, 28	/* v = *(as + 28) */
+	bslli	r9, r12, 24	/* t1 = v << 24 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 28	/* *(d + 28) = t1 */
+	bsrli	r11, r12, 8	/* h = v >> 8 */
+	lwi	r12, r8, 24	/* v = *(as + 24) */
+	bslli	r9, r12, 24	/* t1 = v << 24 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 24	/* *(d + 24) = t1 */
+	bsrli	r11, r12, 8	/* h = v >> 8 */
+	lwi	r12, r8, 20	/* v = *(as + 20) */
+	bslli	r9, r12, 24	/* t1 = v << 24 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 20	/* *(d + 20) = t1 */
+	bsrli	r11, r12, 8	/* h = v >> 8 */
+	lwi	r12, r8, 16	/* v = *(as + 16) */
+	bslli	r9, r12, 24	/* t1 = v << 24 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 16	/* *(d + 16) = t1 */
+	bsrli	r11, r12, 8	/* h = v >> 8 */
+	lwi	r12, r8, 12	/* v = *(as + 12) */
+	bslli	r9, r12, 24	/* t1 = v << 24 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 12	/* *(d + 112) = t1 */
+	bsrli	r11, r12, 8	/* h = v >> 8 */
+	lwi	r12, r8, 8	/* v = *(as + 8) */
+	bslli	r9, r12, 24	/* t1 = v << 24 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 8	/* *(d + 8) = t1 */
+	bsrli	r11, r12, 8	/* h = v >> 8 */
+	lwi	r12, r8, 4	/* v = *(as + 4) */
+	bslli	r9, r12, 24	/* t1 = v << 24 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 4	/* *(d + 4) = t1 */
+	bsrli	r11, r12, 8	/* h = v >> 8 */
+	lwi	r12, r8, 0	/* v = *(as + 0) */
+	bslli	r9, r12, 24	/* t1 = v << 24 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 0	/* *(d + 0) = t1 */
+	addi	r4, r4, -32	/* n = n - 32 */
+	bneid	r4, d_bu3_loop	/* while (n) loop */
+	bsrli	r11, r12, 8	/* h = v >> 8 (IN DELAY SLOT) */
+	bri	d_block_done
+
+d_block_u1:
+	bsrli	r11, r11, 24	/* h = h >> 24 */
+d_bu1_loop:
+	addi	r8, r8, -32	/* as = as - 32 */
+	addi	r5, r5, -32	/* d = d - 32 */
+	lwi	r12, r8, 28	/* v = *(as + 28) */
+	bslli	r9, r12, 8	/* t1 = v << 8 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 28	/* *(d + 28) = t1 */
+	bsrli	r11, r12, 24	/* h = v >> 24 */
+	lwi	r12, r8, 24	/* v = *(as + 24) */
+	bslli	r9, r12, 8	/* t1 = v << 8 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 24	/* *(d + 24) = t1 */
+	bsrli	r11, r12, 24	/* h = v >> 24 */
+	lwi	r12, r8, 20	/* v = *(as + 20) */
+	bslli	r9, r12, 8	/* t1 = v << 8 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 20	/* *(d + 20) = t1 */
+	bsrli	r11, r12, 24	/* h = v >> 24 */
+	lwi	r12, r8, 16	/* v = *(as + 16) */
+	bslli	r9, r12, 8	/* t1 = v << 8 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 16	/* *(d + 16) = t1 */
+	bsrli	r11, r12, 24	/* h = v >> 24 */
+	lwi	r12, r8, 12	/* v = *(as + 12) */
+	bslli	r9, r12, 8	/* t1 = v << 8 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 12	/* *(d + 112) = t1 */
+	bsrli	r11, r12, 24	/* h = v >> 24 */
+	lwi	r12, r8, 8	/* v = *(as + 8) */
+	bslli	r9, r12, 8	/* t1 = v << 8 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 8	/* *(d + 8) = t1 */
+	bsrli	r11, r12, 24	/* h = v >> 24 */
+	lwi	r12, r8, 4	/* v = *(as + 4) */
+	bslli	r9, r12, 8	/* t1 = v << 8 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 4	/* *(d + 4) = t1 */
+	bsrli	r11, r12, 24	/* h = v >> 24 */
+	lwi	r12, r8, 0	/* v = *(as + 0) */
+	bslli	r9, r12, 8	/* t1 = v << 8 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 0	/* *(d + 0) = t1 */
+	addi	r4, r4, -32	/* n = n - 32 */
+	bneid	r4, d_bu1_loop	/* while (n) loop */
+	bsrli	r11, r12, 24	/* h = v >> 24 (IN DELAY SLOT) */
+	bri	d_block_done
+
+d_block_u2:
+	bsrli	r11, r11, 16	/* h = h >> 16 */
+d_bu2_loop:
+	addi	r8, r8, -32	/* as = as - 32 */
+	addi	r5, r5, -32	/* d = d - 32 */
+	lwi	r12, r8, 28	/* v = *(as + 28) */
+	bslli	r9, r12, 16	/* t1 = v << 16 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 28	/* *(d + 28) = t1 */
+	bsrli	r11, r12, 16	/* h = v >> 16 */
+	lwi	r12, r8, 24	/* v = *(as + 24) */
+	bslli	r9, r12, 16	/* t1 = v << 16 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 24	/* *(d + 24) = t1 */
+	bsrli	r11, r12, 16	/* h = v >> 16 */
+	lwi	r12, r8, 20	/* v = *(as + 20) */
+	bslli	r9, r12, 16	/* t1 = v << 16 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 20	/* *(d + 20) = t1 */
+	bsrli	r11, r12, 16	/* h = v >> 16 */
+	lwi	r12, r8, 16	/* v = *(as + 16) */
+	bslli	r9, r12, 16	/* t1 = v << 16 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 16	/* *(d + 16) = t1 */
+	bsrli	r11, r12, 16	/* h = v >> 16 */
+	lwi	r12, r8, 12	/* v = *(as + 12) */
+	bslli	r9, r12, 16	/* t1 = v << 16 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 12	/* *(d + 112) = t1 */
+	bsrli	r11, r12, 16	/* h = v >> 16 */
+	lwi	r12, r8, 8	/* v = *(as + 8) */
+	bslli	r9, r12, 16	/* t1 = v << 16 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 8	/* *(d + 8) = t1 */
+	bsrli	r11, r12, 16	/* h = v >> 16 */
+	lwi	r12, r8, 4	/* v = *(as + 4) */
+	bslli	r9, r12, 16	/* t1 = v << 16 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 4	/* *(d + 4) = t1 */
+	bsrli	r11, r12, 16	/* h = v >> 16 */
+	lwi	r12, r8, 0	/* v = *(as + 0) */
+	bslli	r9, r12, 16	/* t1 = v << 16 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	swi	r9, r5, 0	/* *(d + 0) = t1 */
+	addi	r4, r4, -32	/* n = n - 32 */
+	bneid	r4, d_bu2_loop	/* while (n) loop */
+	bsrli	r11, r12, 16	/* h = v >> 16 (IN DELAY SLOT) */
+
+d_block_done:
+	addi	r4, r0, 4	/* n = 4 */
+	cmpu	r4, r4, r7	/* n = c - n  (unsigned) */
+	blti	r4,d_xfer_end	/* if n < 0, less than one word to transfer */
+
+d_word_xfer:
+	andi	r4, r7, 0xfffffffc	/* n = c & ~3 */
+	rsub	r5, r4, r5		/* d = d - n */
+	rsub	r6, r4, r6		/* s = s - n */
+	rsub	r7, r4, r7		/* c = c - n */
+
+	andi	r9, r6, 3		/* t1 = s & 3 */
+	/* if temp != 0, unaligned transfers needed */
+	bnei	r9, d_word_unaligned
+
+d_word_aligned:
+	addi	r4, r4,-4		/* n-- */
+	lw	r9, r6, r4		/* t1 = *(s+n) */
+	bneid	r4, d_word_aligned	/* loop */
+	sw	r9, r5, r4		/* *(d+n) = t1 (IN DELAY SLOT) */
+
+	bri	d_word_done
+
+d_word_unaligned:
+	andi	r8, r6, 0xfffffffc	/* as = s & ~3 */
+	lw	r11, r8, r4		/* h = *(as + n) */
+
+	addi	r9, r9, -1
+	beqi	r9,d_word_u1		/* t1 was 1 => 1 byte offset */
+	addi	r9, r9, -1
+	beqi	r9,d_word_u2		/* t1 was 2 => 2 byte offset */
+
+d_word_u3:
+	bsrli	r11, r11, 8	/* h = h >> 8 */
+d_wu3_loop:
+	addi	r4, r4,-4	/* n = n - 4 */
+	lw	r12, r8, r4	/* v = *(as + n) */
+	bslli	r9, r12, 24	/* t1 = v << 24 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	sw	r9, r5, r4	/* *(d + n) = t1 */
+	bneid	r4, d_wu3_loop	/* while (n) loop */
+	bsrli	r11, r12, 8	/* h = v >> 8 (IN DELAY SLOT) */
+
+	bri	d_word_done
+
+d_word_u1:
+	bsrli	r11, r11, 24	/* h = h >> 24 */
+d_wu1_loop:
+	addi	r4, r4,-4	/* n = n - 4 */
+	lw	r12, r8, r4	/* v = *(as + n) */
+	bslli	r9, r12, 8	/* t1 = v << 8 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	sw	r9, r5, r4	/* *(d + n) = t1 */
+	bneid	r4, d_wu1_loop	/* while (n) loop */
+	bsrli	r11, r12, 24	/* h = v >> 24 (IN DELAY SLOT) */
+
+	bri	d_word_done
+
+d_word_u2:
+	bsrli	r11, r11, 16	/* h = h >> 16 */
+d_wu2_loop:
+	addi	r4, r4,-4	/* n = n - 4 */
+	lw	r12, r8, r4	/* v = *(as + n) */
+	bslli	r9, r12, 16	/* t1 = v << 16 */
+	or	r9, r11, r9	/* t1 = h | t1 */
+	sw	r9, r5, r4	/* *(d + n) = t1 */
+	bneid	r4, d_wu2_loop	/* while (n) loop */
+	bsrli	r11, r12, 16	/* h = v >> 16 (IN DELAY SLOT) */
+
+d_word_done:
+
+d_xfer_end:
+d_xfer_end_loop:
+	beqi	r7, a_done		/* while (c) */
+	addi	r6, r6, -1		/* s-- */
+	lbui	r9, r6, 0		/* t1 = *s */
+	addi	r5, r5, -1		/* d-- */
+	sbi	r9, r5, 0		/* *d = t1 */
+	brid	d_xfer_end_loop		/* loop */
+	addi	r7, r7, -1		/* c-- (IN DELAY SLOT) */
+
+d_done:
+	rtsd	r15, 8
+	nop
+
+.end memmove
diff --git a/arch/microblaze/lib/memcpy.c b/arch/microblaze/lib/memcpy.c
new file mode 100644
index 0000000..8cb3dec
--- /dev/null
+++ b/arch/microblaze/lib/memcpy.c
@@ -0,0 +1,160 @@
+/*
+ * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2007 John Williams
+ *
+ * Reasonably optimised generic C-code for memcpy on Microblaze
+ * This is generic C code to do efficient, alignment-aware memcpy.
+ *
+ * It is based on demo code originally Copyright 2001 by Intel Corp, taken from
+ * http://www.embedded.com/showArticle.jhtml?articleID=19205567
+ *
+ * Attempts were made, unsuccesfully, to contact the original
+ * author of this code (Michael Morrow, Intel).  Below is the original
+ * copyright notice.
+ *
+ * This software has been developed by Intel Corporation.
+ * Intel specifically disclaims all warranties, express or
+ * implied, and all liability, including consequential and
+ * other indirect damages, for the use of this program, including
+ * liability for infringement of any proprietary rights,
+ * and including the warranties of merchantability and fitness
+ * for a particular purpose. Intel does not assume any
+ * responsibility for and errors which may appear in this program
+ * not any responsibility to update it.
+ */
+
+#include <linux/types.h>
+#include <linux/stddef.h>
+#include <linux/compiler.h>
+#include <linux/module.h>
+
+#include <linux/string.h>
+#include <asm/system.h>
+
+#ifdef __HAVE_ARCH_MEMCPY
+void *memcpy(void *v_dst, const void *v_src, __kernel_size_t c)
+{
+	const char *src = v_src;
+	char *dst = v_dst;
+#ifndef CONFIG_OPT_LIB_FUNCTION
+	/* Simple, byte oriented memcpy. */
+	while (c--)
+		*dst++ = *src++;
+
+	return v_dst;
+#else
+	/* The following code tries to optimize the copy by using unsigned
+	 * alignment. This will work fine if both source and destination are
+	 * aligned on the same boundary. However, if they are aligned on
+	 * different boundaries shifts will be necessary. This might result in
+	 * bad performance on MicroBlaze systems without a barrel shifter.
+	 */
+	const uint32_t *i_src;
+	uint32_t *i_dst;
+
+	if (c >= 4) {
+		unsigned  value, buf_hold;
+
+		/* Align the dstination to a word boundry. */
+		/* This is done in an endian independant manner. */
+		switch ((unsigned long)dst & 3) {
+		case 1:
+			*dst++ = *src++;
+			--c;
+		case 2:
+			*dst++ = *src++;
+			--c;
+		case 3:
+			*dst++ = *src++;
+			--c;
+		}
+
+		i_dst = (void *)dst;
+
+		/* Choose a copy scheme based on the source */
+		/* alignment relative to dstination. */
+		switch ((unsigned long)src & 3) {
+		case 0x0:	/* Both byte offsets are aligned */
+			i_src  = (const void *)src;
+
+			for (; c >= 4; c -= 4)
+				*i_dst++ = *i_src++;
+
+			src  = (const void *)i_src;
+			break;
+		case 0x1:	/* Unaligned - Off by 1 */
+			/* Word align the source */
+			i_src = (const void *) ((unsigned)src & ~3);
+
+			/* Load the holding buffer */
+			buf_hold = *i_src++ << 8;
+
+			for (; c >= 4; c -= 4) {
+				value = *i_src++;
+				*i_dst++ = buf_hold | value >> 24;
+				buf_hold = value << 8;
+			}
+
+			/* Realign the source */
+			src = (const void *)i_src;
+			src -= 3;
+			break;
+		case 0x2:	/* Unaligned - Off by 2 */
+			/* Word align the source */
+			i_src = (const void *) ((unsigned)src & ~3);
+
+			/* Load the holding buffer */
+			buf_hold = *i_src++ << 16;
+
+			for (; c >= 4; c -= 4) {
+				value = *i_src++;
+				*i_dst++ = buf_hold | value >> 16;
+				buf_hold = value << 16;
+			}
+
+			/* Realign the source */
+			src = (const void *)i_src;
+			src -= 2;
+			break;
+		case 0x3:	/* Unaligned - Off by 3 */
+			/* Word align the source */
+			i_src = (const void *) ((unsigned)src & ~3);
+
+			/* Load the holding buffer */
+			buf_hold = *i_src++ << 24;
+
+			for (; c >= 4; c -= 4) {
+				value = *i_src++;
+				*i_dst++ = buf_hold | value >> 8;
+				buf_hold = value << 24;
+			}
+
+			/* Realign the source */
+			src = (const void *)i_src;
+			src -= 1;
+			break;
+		}
+		dst = (void *)i_dst;
+	}
+
+	/* Finish off any remaining bytes */
+	/* simple fast copy, ... unless a cache boundry is crossed */
+	switch (c) {
+	case 3:
+		*dst++ = *src++;
+	case 2:
+		*dst++ = *src++;
+	case 1:
+		*dst++ = *src++;
+	}
+
+	return v_dst;
+#endif
+}
+EXPORT_SYMBOL(memcpy);
+#endif /* __HAVE_ARCH_MEMCPY */
+
+void *cacheable_memcpy(void *d, const void *s, __kernel_size_t c)
+{
+	return memcpy(d, s, c);
+}
diff --git a/arch/microblaze/lib/memmove.c b/arch/microblaze/lib/memmove.c
new file mode 100644
index 0000000..87d17b2
--- /dev/null
+++ b/arch/microblaze/lib/memmove.c
@@ -0,0 +1,174 @@
+/*
+ * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2007 John Williams
+ *
+ * Reasonably optimised generic C-code for memcpy on Microblaze
+ * This is generic C code to do efficient, alignment-aware memmove.
+ *
+ * It is based on demo code originally Copyright 2001 by Intel Corp, taken from
+ * http://www.embedded.com/showArticle.jhtml?articleID=19205567
+ *
+ * Attempts were made, unsuccesfully, to contact the original
+ * author of this code (Michael Morrow, Intel).  Below is the original
+ * copyright notice.
+ *
+ * This software has been developed by Intel Corporation.
+ * Intel specifically disclaims all warranties, express or
+ * implied, and all liability, including consequential and
+ * other indirect damages, for the use of this program, including
+ * liability for infringement of any proprietary rights,
+ * and including the warranties of merchantability and fitness
+ * for a particular purpose. Intel does not assume any
+ * responsibility for and errors which may appear in this program
+ * not any responsibility to update it.
+ */
+
+#include <linux/types.h>
+#include <linux/stddef.h>
+#include <linux/compiler.h>
+#include <linux/module.h>
+#include <linux/string.h>
+
+#ifdef __HAVE_ARCH_MEMMOVE
+void *memmove(void *v_dst, const void *v_src, __kernel_size_t c)
+{
+	const char *src = v_src;
+	char *dst = v_dst;
+
+#ifdef CONFIG_OPT_LIB_FUNCTION
+	const uint32_t *i_src;
+	uint32_t *i_dst;
+#endif
+
+	if (!c)
+		return v_dst;
+
+	/* Use memcpy when source is higher than dest */
+	if (v_dst <= v_src)
+		return memcpy(v_dst, v_src, c);
+
+#ifndef CONFIG_OPT_LIB_FUNCTION
+	/* copy backwards, from end to beginning */
+	src += c;
+	dst += c;
+
+	/* Simple, byte oriented memmove. */
+	while (c--)
+		*--dst = *--src;
+
+	return v_dst;
+#else
+	/* The following code tries to optimize the copy by using unsigned
+	 * alignment. This will work fine if both source and destination are
+	 * aligned on the same boundary. However, if they are aligned on
+	 * different boundaries shifts will be necessary. This might result in
+	 * bad performance on MicroBlaze systems without a barrel shifter.
+	 */
+	/* FIXME this part needs more test */
+	/* Do a descending copy - this is a bit trickier! */
+	dst += c;
+	src += c;
+
+	if (c >= 4) {
+		unsigned  value, buf_hold;
+
+		/* Align the destination to a word boundry. */
+		/* This is done in an endian independant manner. */
+
+		switch ((unsigned long)dst & 3) {
+		case 3:
+			*--dst = *--src;
+			--c;
+		case 2:
+			*--dst = *--src;
+			--c;
+		case 1:
+			*--dst = *--src;
+			--c;
+		}
+
+		i_dst = (void *)dst;
+		/* Choose a copy scheme based on the source */
+		/* alignment relative to dstination. */
+		switch ((unsigned long)src & 3) {
+		case 0x0:	/* Both byte offsets are aligned */
+
+			i_src  = (const void *)src;
+
+			for (; c >= 4; c -= 4)
+				*--i_dst = *--i_src;
+
+			src  = (const void *)i_src;
+			break;
+		case 0x1:	/* Unaligned - Off by 1 */
+			/* Word align the source */
+			i_src = (const void *) (((unsigned)src + 4) & ~3);
+
+			/* Load the holding buffer */
+			buf_hold = *--i_src >> 24;
+
+			for (; c >= 4; c -= 4) {
+				value = *--i_src;
+				*--i_dst = buf_hold << 8 | value;
+				buf_hold = value >> 24;
+			}
+
+			/* Realign the source */
+			src = (const void *)i_src;
+			src += 1;
+			break;
+		case 0x2:	/* Unaligned - Off by 2 */
+			/* Word align the source */
+			i_src = (const void *) (((unsigned)src + 4) & ~3);
+
+			/* Load the holding buffer */
+			buf_hold = *--i_src >> 16;
+
+			for (; c >= 4; c -= 4) {
+				value = *--i_src;
+				*--i_dst = buf_hold << 16 | value;
+				buf_hold = value >> 16;
+			}
+
+			/* Realign the source */
+			src = (const void *)i_src;
+			src += 2;
+			break;
+		case 0x3:	/* Unaligned - Off by 3 */
+			/* Word align the source */
+			i_src = (const void *) (((unsigned)src + 4) & ~3);
+
+			/* Load the holding buffer */
+			buf_hold = *--i_src >> 8;
+
+			for (; c >= 4; c -= 4) {
+				value = *--i_src;
+				*--i_dst = buf_hold << 24 | value;
+				buf_hold = value >> 8;
+			}
+
+			/* Realign the source */
+			src = (const void *)i_src;
+			src += 3;
+			break;
+		}
+		dst = (void *)i_dst;
+	}
+
+	/* simple fast copy, ... unless a cache boundry is crossed */
+	/* Finish off any remaining bytes */
+	switch (c) {
+	case 4:
+		*--dst = *--src;
+	case 3:
+		*--dst = *--src;
+	case 2:
+		*--dst = *--src;
+	case 1:
+		*--dst = *--src;
+	}
+	return v_dst;
+#endif
+}
+EXPORT_SYMBOL(memmove);
+#endif /* __HAVE_ARCH_MEMMOVE */
diff --git a/arch/microblaze/lib/memset.c b/arch/microblaze/lib/memset.c
new file mode 100644
index 0000000..8cd4f38
--- /dev/null
+++ b/arch/microblaze/lib/memset.c
@@ -0,0 +1,81 @@
+/*
+ * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2007 John Williams
+ *
+ * Reasonably optimised generic C-code for memset on Microblaze
+ * This is generic C code to do efficient, alignment-aware memcpy.
+ *
+ * It is based on demo code originally Copyright 2001 by Intel Corp, taken from
+ * http://www.embedded.com/showArticle.jhtml?articleID=19205567
+ *
+ * Attempts were made, unsuccesfully, to contact the original
+ * author of this code (Michael Morrow, Intel).  Below is the original
+ * copyright notice.
+ *
+ * This software has been developed by Intel Corporation.
+ * Intel specifically disclaims all warranties, express or
+ * implied, and all liability, including consequential and
+ * other indirect damages, for the use of this program, including
+ * liability for infringement of any proprietary rights,
+ * and including the warranties of merchantability and fitness
+ * for a particular purpose. Intel does not assume any
+ * responsibility for and errors which may appear in this program
+ * not any responsibility to update it.
+ */
+
+#include <linux/types.h>
+#include <linux/stddef.h>
+#include <linux/compiler.h>
+#include <linux/module.h>
+#include <linux/string.h>
+
+#ifdef __HAVE_ARCH_MEMSET
+void *memset(void *v_src, int c, __kernel_size_t n)
+{
+
+	char *src = v_src;
+#ifdef CONFIG_OPT_LIB_FUNCTION
+	uint32_t *i_src;
+	uint32_t w32;
+#endif
+	/* Truncate c to 8 bits */
+	c = (c & 0xFF);
+
+#ifdef CONFIG_OPT_LIB_FUNCTION
+	/* Make a repeating word out of it */
+	w32 = c;
+	w32 |= w32 << 8;
+	w32 |= w32 << 16;
+
+	if (n >= 4) {
+		/* Align the destination to a word boundary */
+		/* This is done in an endian independant manner */
+		switch ((unsigned) src & 3) {
+		case 1:
+			*src++ = c;
+			--n;
+		case 2:
+			*src++ = c;
+			--n;
+		case 3:
+			*src++ = c;
+			--n;
+		}
+
+		i_src  = (void *)src;
+
+		/* Do as many full-word copies as we can */
+		for (; n >= 4; n -= 4)
+			*i_src++ = w32;
+
+		src  = (void *)i_src;
+	}
+#endif
+	/* Simple, byte oriented memset or the rest of count. */
+	while (n--)
+		*src++ = c;
+
+	return v_src;
+}
+EXPORT_SYMBOL(memset);
+#endif /* __HAVE_ARCH_MEMSET */
-- 
1.5.5.1

