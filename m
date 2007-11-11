Return-Path: <linux-kernel-owner+w=401wt.eu-S1757000AbXKKQDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000AbXKKQDN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 11:03:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755815AbXKKQC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 11:02:58 -0500
Received: from ns.suse.de ([195.135.220.2]:44895 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752AbXKKQC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 11:02:57 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC 13/13] Char: nozomi, cleanup read and write
Date: Sun, 11 Nov 2007 17:02:51 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jiri Slaby <jirislaby@gmail.com>, Adrian Bunk <bunk@kernel.org>
References: <10551261882075921134.slaby@pripojeni.net> <47362AF9.5080009@gmail.com> <200711110337.29831.fseidel@suse.de>
In-Reply-To: <200711110337.29831.fseidel@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711111702.53191.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sonntag 11 November 2007 03:37:28, you (Frank Seidel) wrote:
> While in the read_mem32 the unlikekly really seems to be of no use at all (the
> switch-case ahead seems to be hit nearly always), the unlikely in the 
> write_mem32 seems to be fine.
> I compared after each 30 seconds and got median ratio of 1381:1 (for the
> likely path) after about 20 minutes, i see a range between 1046:1 and
> 3511:1. So i wouldn't call it a bad guess from my beginners point of view.

I even did some more tracking which pathes get used in there with what
size_bytes values for write_mem32. To what i could see i get about
50% of the calls with size_bytes == 4 (what gets handled in the
switch-case shortcut), about 30% of the calls with size_bytes == 1 (
so i also added a shortcut for this which was just one line) and the
remaining calls (not handled in the switch-case ahead) still reach
a ratio of about 800:1 for the 4-byte-case to the (unlikely) 2-byte-
case.

So i did a rework of that patch which is nearly as nice as Jiris,
but works here without problems and has the size_bytes 1 shortcut,
plus the "unlikely" for the remaining 2-bytes path.

I know the format of the patch isn't fully correct, but i'll integrate
it into the complete patch und polish it there before posting that
again.

Thanks a lot,
Frank
---
Index: linux/drivers/char/nozomi.c
===================================================================
--- linux.orig/drivers/char/nozomi.c
+++ linux/drivers/char/nozomi.c
@@ -104,6 +104,7 @@
 #include <linux/list.h>
 #include <linux/uaccess.h>
 #include <asm/atomic.h>
+#include <asm/byteorder.h>
 
 #include <linux/delay.h>
 
@@ -265,7 +266,7 @@ enum port_type {
 	PORT_ERROR	= -1,
 };
 
-#ifdef __ARMEB__
+#ifdef __BIG_ENDIAN
 /* Big endian */
 
 struct toggles {
@@ -547,11 +548,7 @@ static void read_mem32(u32 *buf, const v
 			u32 size_bytes)
 {
 	u32 i = 0;
-#ifdef __ARMEB__
-	const u32 *ptr = (u32 *) mem_addr_start;
-#else
 	const u32 *ptr = (__force u32 *) mem_addr_start;
-#endif
 	u16 *buf16;
 
 	if (unlikely(!ptr || !buf))
@@ -561,19 +558,11 @@ static void read_mem32(u32 *buf, const v
 	switch (size_bytes) {
 	case 2:	/* 2 bytes */
 		buf16 = (u16 *) buf;
-#ifdef __ARMEB__
-		*buf16 = __le16_to_cpu(readw(ptr));
-#else
-		*buf16 = readw((void __iomem *)ptr);
-#endif
+		*buf16 = __le16_to_cpu(readw((void __iomem *)ptr));
 		goto out;
 		break;
 	case 4:	/* 4 bytes */
-#ifdef __ARMEB__
-		*(buf) = __le32_to_cpu(readl(ptr));
-#else
-		*(buf) = readl((void __iomem *)ptr);
-#endif
+		*(buf) = __le32_to_cpu(readl((void __iomem *)ptr));
 		goto out;
 		break;
 	}
@@ -582,19 +571,11 @@ static void read_mem32(u32 *buf, const v
 		if (size_bytes - i == 2) {
 			/* Handle 2 bytes in the end */
 			buf16 = (u16 *) buf;
-#ifdef __ARMEB__
-			*(buf16) = __le16_to_cpu(readw(ptr));
-#else
-			*(buf16) = readw((void __iomem *)ptr);
-#endif
+			*(buf16) = __le16_to_cpu(readw((void __iomem *)ptr));
 			i += 2;
 		} else {
 			/* Read 4 bytes */
-#ifdef __ARMEB__
-			*(buf) = __le32_to_cpu(readl(ptr));
-#else
-			*(buf) = readl((void __iomem *)ptr);
-#endif
+			*(buf) = __le32_to_cpu(readl((void __iomem *)ptr));
 			i += 4;
 		}
 		buf++;
@@ -613,11 +594,7 @@ static u32 write_mem32(void __iomem *mem
 			u32 size_bytes)
 {
 	u32 i = 0;
-#ifdef __ARMEB__
-	u32 *ptr = (u32 *) mem_addr_start;
-#else
 	u32 *ptr = (__force u32 *) mem_addr_start;
-#endif
 	u16 *buf16;
 
 	if (unlikely(!ptr || !buf))
@@ -627,40 +604,28 @@ static u32 write_mem32(void __iomem *mem
 	switch (size_bytes) {
 	case 2:	/* 2 bytes */
 		buf16 = (u16 *) buf;
-#ifdef __ARMEB__
-		writew(__le16_to_cpu(*buf16), ptr);
-#else
-		writew(*buf16, (void __iomem *)ptr);
-#endif
+		writew(__cpu_to_le16(*buf16), (void __iomem *)ptr);
 		return 2;
 		break;
+	case 1:
+		/* also need to write 4 bytes in this case
+		 * so falling through..
+		 */
 	case 4: /* 4 bytes */
-#ifdef __ARMEB__
-		writel(__cpu_to_le32(*buf), ptr);
-#else
-		writel(*buf, (void __iomem *)ptr);
-#endif
+		writel(__cpu_to_le32(*buf), (void __iomem *)ptr);
 		return 4;
 		break;
 	}
 
 	while (i < size_bytes) {
-		if (size_bytes - i == 2) {
+		if (unlikely(size_bytes - i == 2)) {
 			/* 2 bytes */
 			buf16 = (u16 *) buf;
-#ifdef __ARMEB__
-			writew(__le16_to_cpu(*buf16), ptr);
-#else
-			writew(*buf16, (void __iomem *)ptr);
-#endif
+			writew(__cpu_to_le16(*buf16), (void __iomem *)ptr);
 			i += 2;
 		} else {
 			/* 4 bytes */
-#ifdef __ARMEB__
-			writel(__cpu_to_le32(*buf), ptr);
-#else
-			writel(*buf, (void __iomem *)ptr);
-#endif
+			writel(__cpu_to_le32(*buf), (void __iomem *)ptr);
 			i += 4;
 		}
 		buf++;
