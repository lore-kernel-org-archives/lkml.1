Return-Path: <linux-kernel-owner+w=401wt.eu-S1760949AbYC2DMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949AbYC2DMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759871AbYC2DKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:10:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50224 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551AbYC2DKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:10:23 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] fix the broken annotations in fsldma
Cc: wei.zhang@freescale.com, linux-kernel@vger.kernel.org
Message-Id: <E1JfRSU-0002xg-LA@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 29 Mar 2008 03:10:18 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


a) every bitwise declaration will give a unique type; use typedefs.
b) no need to bother with the stuff pointed to by iomem pointers, unless
it's accessed directly.  noderef will force us to use helpers anyway.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/dma/fsldma.h |   47 +++++++++++++++++++++++++++--------------------
 1 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h
index fddd6ae..6faf07b 100644
--- a/drivers/dma/fsldma.h
+++ b/drivers/dma/fsldma.h
@@ -75,12 +75,15 @@
 #define FSL_DMA_DGSR_EOSI	0x02
 #define FSL_DMA_DGSR_EOLSI	0x01
 
+typedef u64 __bitwise v64;
+typedef u32 __bitwise v32;
+
 struct fsl_dma_ld_hw {
-	u64 __bitwise	src_addr;
-	u64 __bitwise	dst_addr;
-	u64 __bitwise	next_ln_addr;
-	u32 __bitwise	count;
-	u32 __bitwise	reserve;
+	v64 src_addr;
+	v64 dst_addr;
+	v64 next_ln_addr;
+	v32 count;
+	v32 reserve;
 } __attribute__((aligned(32)));
 
 struct fsl_desc_sw {
@@ -92,13 +95,13 @@ struct fsl_desc_sw {
 } __attribute__((aligned(32)));
 
 struct fsl_dma_chan_regs {
-	u32 __bitwise	mr;	/* 0x00 - Mode Register */
-	u32 __bitwise	sr;	/* 0x04 - Status Register */
-	u64 __bitwise	cdar;	/* 0x08 - Current descriptor address register */
-	u64 __bitwise	sar;	/* 0x10 - Source Address Register */
-	u64 __bitwise	dar;	/* 0x18 - Destination Address Register */
-	u32 __bitwise	bcr;	/* 0x20 - Byte Count Register */
-	u64 __bitwise	ndar;	/* 0x24 - Next Descriptor Address Register */
+	u32 mr;	/* 0x00 - Mode Register */
+	u32 sr;	/* 0x04 - Status Register */
+	u64 cdar;	/* 0x08 - Current descriptor address register */
+	u64 sar;	/* 0x10 - Source Address Register */
+	u64 dar;	/* 0x18 - Destination Address Register */
+	u32 bcr;	/* 0x20 - Byte Count Register */
+	u64 ndar;	/* 0x24 - Next Descriptor Address Register */
 };
 
 struct fsl_dma_chan;
@@ -151,25 +154,27 @@ struct fsl_dma_chan {
 #ifndef __powerpc64__
 static u64 in_be64(const u64 __iomem *addr)
 {
-	return ((u64)in_be32((u32 *)addr) << 32) | (in_be32((u32 *)addr + 1));
+	return ((u64)in_be32((u32 __iomem *)addr) << 32) |
+		(in_be32((u32 __iomem *)addr + 1));
 }
 
 static void out_be64(u64 __iomem *addr, u64 val)
 {
-	out_be32((u32 *)addr, val >> 32);
-	out_be32((u32 *)addr + 1, (u32)val);
+	out_be32((u32 __iomem *)addr, val >> 32);
+	out_be32((u32 __iomem *)addr + 1, (u32)val);
 }
 
 /* There is no asm instructions for 64 bits reverse loads and stores */
 static u64 in_le64(const u64 __iomem *addr)
 {
-	return ((u64)in_le32((u32 *)addr + 1) << 32) | (in_le32((u32 *)addr));
+	return ((u64)in_le32((u32 __iomem *)addr + 1) << 32) |
+		(in_le32((u32 __iomem *)addr));
 }
 
 static void out_le64(u64 __iomem *addr, u64 val)
 {
-	out_le32((u32 *)addr + 1, val >> 32);
-	out_le32((u32 *)addr, (u32)val);
+	out_le32((u32 __iomem *)addr + 1, val >> 32);
+	out_le32((u32 __iomem *)addr, (u32)val);
 }
 #endif
 
@@ -182,9 +187,11 @@ static void out_le64(u64 __iomem *addr, u64 val)
 
 #define DMA_TO_CPU(fsl_chan, d, width)					\
 		(((fsl_chan)->feature & FSL_DMA_BIG_ENDIAN) ?		\
-			be##width##_to_cpu(d) :	le##width##_to_cpu(d))
+			be##width##_to_cpu((__force __be##width)(v##width)d) : \
+			le##width##_to_cpu((__force __le##width)(v##width)d))
 #define CPU_TO_DMA(fsl_chan, c, width)					\
 		(((fsl_chan)->feature & FSL_DMA_BIG_ENDIAN) ?		\
-			cpu_to_be##width(c) : cpu_to_le##width(c))
+			(__force v##width)cpu_to_be##width(c) :		\
+			(__force v##width)cpu_to_le##width(c))
 
 #endif	/* __DMA_FSLDMA_H */
-- 
1.5.3.GIT


