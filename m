Return-Path: <linux-kernel-owner+w=401wt.eu-S1764777AbXKIXvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764777AbXKIXvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761166AbXKIXvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:51:36 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57266 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759774AbXKIXvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:51:35 -0500
Message-id: <151715551528512164.slaby@pripojeni.net>
In-reply-to: <10551261882075921134.slaby@pripojeni.net>
Subject: [RFC 13/13] Char: nozomi, cleanup read and write
From: Jiri Slaby <jirislaby@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: Frank Seidel <fseidel@suse.de>
Date: Fri, 9 Nov 2007 18:51:35 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

nozomi, cleanup read and write

- remove macros testing for endianness, le*_to_cpu and complements will do
  it
- pointers cleanup (no need to have different pointers for be and le)
- put unlikely into reading/writing while loop, because it will proceed
  through this case only on last two bytes
- also fix typos in write, le16_to_cpu instead of cpu_to_le16 for 2-byte
  writes

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit fe27da2c4a35d2f91fd1ed542d91353f7a3c1dd2
tree a9f8d35b2047a24277d92758d3d579eb59427323
parent 92ca82bcbd5dde95096dac24d0f6a9beab68e003
author Jiri Slaby <jirislaby@gmail.com> Sat, 10 Nov 2007 00:19:04 +0100
committer Jiri Slaby <jirislaby@gmail.com> Sat, 10 Nov 2007 00:19:04 +0100

 drivers/char/nozomi.c |   80 ++++++++++---------------------------------------
 1 files changed, 16 insertions(+), 64 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index 0735df0..7379cd4 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -105,6 +105,7 @@
 
 #include <linux/delay.h>
 
+#include <asm/byteorder.h>
 
 #define VERSION_STRING DRIVER_DESC " 2.1c (build date: " \
 					__DATE__ " " __TIME__ ")"
@@ -261,8 +262,7 @@ enum port_type {
 	PORT_ERROR	= -1,
 };
 
-#ifdef __ARMEB__
-/* Big endian */
+#ifdef __BIG_ENDIAN
 
 struct toggles {
 	unsigned enabled:5;	/*
@@ -470,16 +470,10 @@ static inline struct port *get_port_by_tty(const struct tty_struct *tty)
  * -Rewrite cleaner
  */
 
-static void read_mem32(u32 *buf, const void __iomem *mem_addr_start,
-			u32 size_bytes)
+static void read_mem32(u32 *buf, void __iomem *ptr, u32 size_bytes)
 {
-	u32 i = 0;
-#ifdef __ARMEB__
-	const u32 *ptr = (u32 *) mem_addr_start;
-#else
-	const u32 *ptr = (__force u32 *) mem_addr_start;
-#endif
 	u16 *buf16;
+	u32 i = 0;
 
 	if (unlikely(!ptr || !buf))
 		goto out;
@@ -488,40 +482,22 @@ static void read_mem32(u32 *buf, const void __iomem *mem_addr_start,
 	switch (size_bytes) {
 	case 2:	/* 2 bytes */
 		buf16 = (u16 *) buf;
-#ifdef __ARMEB__
-		*buf16 = __le16_to_cpu(readw(ptr));
-#else
-		*buf16 = readw((void __iomem *)ptr);
-#endif
+		*buf16 = le16_to_cpu(readw(ptr));
 		goto out;
-		break;
 	case 4:	/* 4 bytes */
-#ifdef __ARMEB__
-		*(buf) = __le32_to_cpu(readl(ptr));
-#else
-		*(buf) = readl((void __iomem *)ptr);
-#endif
+		*buf = le32_to_cpu(readl(ptr));
 		goto out;
-		break;
 	}
 
 	while (i < size_bytes) {
-		if (size_bytes - i == 2) {
+		if (unlikely(size_bytes - i == 2)) {
 			/* Handle 2 bytes in the end */
 			buf16 = (u16 *) buf;
-#ifdef __ARMEB__
-			*(buf16) = __le16_to_cpu(readw(ptr));
-#else
-			*(buf16) = readw((void __iomem *)ptr);
-#endif
+			*buf16 = le16_to_cpu(readw(ptr));
 			i += 2;
 		} else {
 			/* Read 4 bytes */
-#ifdef __ARMEB__
-			*(buf) = __le32_to_cpu(readl(ptr));
-#else
-			*(buf) = readl((void __iomem *)ptr);
-#endif
+			*buf = le32_to_cpu(readl(ptr));
 			i += 4;
 		}
 		buf++;
@@ -536,15 +512,9 @@ out:
  * -Optimize
  * -Rewrite cleaner
  */
-static u32 write_mem32(void __iomem *mem_addr_start, u32 *buf,
-			u32 size_bytes)
+static u32 write_mem32(void __iomem *ptr, u32 *buf, u32 size_bytes)
 {
 	u32 i = 0;
-#ifdef __ARMEB__
-	u32 *ptr = (u32 *) mem_addr_start;
-#else
-	u32 *ptr = (__force u32 *) mem_addr_start;
-#endif
 	u16 *buf16;
 
 	if (unlikely(!ptr || !buf))
@@ -553,41 +523,23 @@ static u32 write_mem32(void __iomem *mem_addr_start, u32 *buf,
 	/* shortcut for extremely often used cases */
 	switch (size_bytes) {
 	case 2:	/* 2 bytes */
-		buf16 = (u16 *) buf;
-#ifdef __ARMEB__
-		writew(__le16_to_cpu(*buf16), ptr);
-#else
-		writew(*buf16, (void __iomem *)ptr);
-#endif
+		buf16 = (u16 *)buf;
+		writew(cpu_to_le16(*buf16), ptr);
 		return 2;
-		break;
 	case 4: /* 4 bytes */
-#ifdef __ARMEB__
-		writel(__cpu_to_le32(*buf), ptr);
-#else
-		writel(*buf, (void __iomem *)ptr);
-#endif
+		writel(cpu_to_le32(*buf), ptr);
 		return 4;
-		break;
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
+			writew(cpu_to_le16(*buf16), ptr);
 			i += 2;
 		} else {
 			/* 4 bytes */
-#ifdef __ARMEB__
-			writel(__cpu_to_le32(*buf), ptr);
-#else
-			writel(*buf, (void __iomem *)ptr);
-#endif
+			writel(cpu_to_le32(*buf), ptr);
 			i += 4;
 		}
 		buf++;
