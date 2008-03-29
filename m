Return-Path: <linux-kernel-owner+w=401wt.eu-S1760267AbYC2DKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760267AbYC2DKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758304AbYC2DJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:09:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49954 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758471AbYC2DJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:09:09 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] fix iomem misannotations in nozomi
Cc: fseidel@suse.de, linux-kernel@vger.kernel.org
Message-Id: <E1JfRRM-0002lF-K0@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 29 Mar 2008 03:09:08 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


aka if you see a force-cast, be very suspicious...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/char/nozomi.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index 6d0dc5f..6a6843a 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -438,7 +438,7 @@ static void read_mem32(u32 *buf, const void __iomem *mem_addr_start,
 			u32 size_bytes)
 {
 	u32 i = 0;
-	const u32 *ptr = (__force u32 *) mem_addr_start;
+	const u32 __iomem *ptr = mem_addr_start;
 	u16 *buf16;
 
 	if (unlikely(!ptr || !buf))
@@ -448,11 +448,11 @@ static void read_mem32(u32 *buf, const void __iomem *mem_addr_start,
 	switch (size_bytes) {
 	case 2:	/* 2 bytes */
 		buf16 = (u16 *) buf;
-		*buf16 = __le16_to_cpu(readw((void __iomem *)ptr));
+		*buf16 = __le16_to_cpu(readw(ptr));
 		goto out;
 		break;
 	case 4:	/* 4 bytes */
-		*(buf) = __le32_to_cpu(readl((void __iomem *)ptr));
+		*(buf) = __le32_to_cpu(readl(ptr));
 		goto out;
 		break;
 	}
@@ -461,11 +461,11 @@ static void read_mem32(u32 *buf, const void __iomem *mem_addr_start,
 		if (size_bytes - i == 2) {
 			/* Handle 2 bytes in the end */
 			buf16 = (u16 *) buf;
-			*(buf16) = __le16_to_cpu(readw((void __iomem *)ptr));
+			*(buf16) = __le16_to_cpu(readw(ptr));
 			i += 2;
 		} else {
 			/* Read 4 bytes */
-			*(buf) = __le32_to_cpu(readl((void __iomem *)ptr));
+			*(buf) = __le32_to_cpu(readl(ptr));
 			i += 4;
 		}
 		buf++;
@@ -484,7 +484,7 @@ static u32 write_mem32(void __iomem *mem_addr_start, const u32 *buf,
 			u32 size_bytes)
 {
 	u32 i = 0;
-	u32 *ptr = (__force u32 *) mem_addr_start;
+	u32 __iomem *ptr = mem_addr_start;
 	const u16 *buf16;
 
 	if (unlikely(!ptr || !buf))
@@ -494,7 +494,7 @@ static u32 write_mem32(void __iomem *mem_addr_start, const u32 *buf,
 	switch (size_bytes) {
 	case 2:	/* 2 bytes */
 		buf16 = (const u16 *)buf;
-		writew(__cpu_to_le16(*buf16), (void __iomem *)ptr);
+		writew(__cpu_to_le16(*buf16), ptr);
 		return 2;
 		break;
 	case 1: /*
@@ -502,7 +502,7 @@ static u32 write_mem32(void __iomem *mem_addr_start, const u32 *buf,
 		 * so falling through..
 		 */
 	case 4: /* 4 bytes */
-		writel(__cpu_to_le32(*buf), (void __iomem *)ptr);
+		writel(__cpu_to_le32(*buf), ptr);
 		return 4;
 		break;
 	}
@@ -511,11 +511,11 @@ static u32 write_mem32(void __iomem *mem_addr_start, const u32 *buf,
 		if (size_bytes - i == 2) {
 			/* 2 bytes */
 			buf16 = (const u16 *)buf;
-			writew(__cpu_to_le16(*buf16), (void __iomem *)ptr);
+			writew(__cpu_to_le16(*buf16), ptr);
 			i += 2;
 		} else {
 			/* 4 bytes */
-			writel(__cpu_to_le32(*buf), (void __iomem *)ptr);
+			writel(__cpu_to_le32(*buf), ptr);
 			i += 4;
 		}
 		buf++;
-- 
1.5.3.GIT


