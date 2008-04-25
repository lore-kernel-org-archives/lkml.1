Return-Path: <linux-kernel-owner+w=401wt.eu-S1751387AbYDYEI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387AbYDYEI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 00:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbYDYEH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 00:07:58 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:41144 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbYDYEH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 00:07:56 -0400
X-IronPort-AV: E=Sophos;i="4.25,706,1199682000"; 
   d="scan'208";a="67099939"
From: Bryan Wu <cooloney@kernel.org>
To: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
Cc: Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/3] [MTD] m25p80: add FAST_READ access support to M25Pxx
Date: Fri, 25 Apr 2008 12:07:32 +0800
Message-Id: <1209096453-21610-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1209096453-21610-1-git-send-email-cooloney@kernel.org>
References: <1209096453-21610-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/mtd/devices/Kconfig  |    7 +++++++
 drivers/mtd/devices/m25p80.c |   31 +++++++++++++++++++++----------
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
index 811d56f..35ed110 100644
--- a/drivers/mtd/devices/Kconfig
+++ b/drivers/mtd/devices/Kconfig
@@ -77,6 +77,13 @@ config MTD_M25P80
 	  if you want to specify device partitioning or to use a device which
 	  doesn't support the JEDEC ID instruction.
 
+config M25PXX_USE_FAST_READ
+	bool "Use FAST_READ OPCode allowing SPI CLK <= 50MHz"
+	depends on MTD_M25P80
+	default y
+	help
+	  This option enables FAST_READ access supported by ST M25Pxx.
+
 config MTD_SLRAM
 	tristate "Uncached system RAM"
 	help
diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 98df5bc..14dd88d 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -33,7 +33,7 @@
 /* Flash opcodes. */
 #define	OPCODE_WREN		0x06	/* Write enable */
 #define	OPCODE_RDSR		0x05	/* Read status register */
-#define	OPCODE_READ		0x03	/* Read data bytes (low frequency) */
+#define	OPCODE_NORM_READ	0x03	/* Read data bytes (low frequency) */
 #define	OPCODE_FAST_READ	0x0b	/* Read data bytes (high frequency) */
 #define	OPCODE_PP		0x02	/* Page program (up to 256 bytes) */
 #define	OPCODE_BE_4K 		0x20	/* Erase 4KiB block */
@@ -52,7 +52,15 @@
 
 /* Define max times to check status register before we give up. */
 #define	MAX_READY_WAIT_COUNT	100000
+#define	CMD_SIZE		4
 
+#ifdef CONFIG_M25PXX_USE_FAST_READ
+#define OPCODE_READ 	OPCODE_FAST_READ
+#define FAST_READ_DUMMY_BYTE 1
+#else
+#define OPCODE_READ 	OPCODE_NORM_READ
+#define FAST_READ_DUMMY_BYTE 0
+#endif
 
 #ifdef CONFIG_MTD_PARTITIONS
 #define	mtd_has_partitions()	(1)
@@ -68,7 +76,7 @@ struct m25p {
 	struct mtd_info		mtd;
 	unsigned		partitioned:1;
 	u8			erase_opcode;
-	u8			command[4];
+ 	u8			command[CMD_SIZE + FAST_READ_DUMMY_BYTE];
 };
 
 static inline struct m25p *mtd_to_m25p(struct mtd_info *mtd)
@@ -167,7 +175,7 @@ static int erase_sector(struct m25p *flash, u32 offset)
 	flash->command[2] = offset >> 8;
 	flash->command[3] = offset;
 
-	spi_write(flash->spi, flash->command, sizeof(flash->command));
+	spi_write(flash->spi, flash->command, CMD_SIZE);
 
 	return 0;
 }
@@ -253,8 +261,12 @@ static int m25p80_read(struct mtd_info *mtd, loff_t from, size_t len,
 	spi_message_init(&m);
 	memset(t, 0, (sizeof t));
 
+	/* NOTE:
+	 * OPCODE_FAST_READ (if available) is faster.
+	 * Should add 1 byte DUMMY_BYTE.
+	 */
 	t[0].tx_buf = flash->command;
-	t[0].len = sizeof(flash->command);
+	t[0].len = CMD_SIZE + FAST_READ_DUMMY_BYTE;
 	spi_message_add_tail(&t[0], &m);
 
 	t[1].rx_buf = buf;
@@ -287,7 +299,7 @@ static int m25p80_read(struct mtd_info *mtd, loff_t from, size_t len,
 
 	spi_sync(flash->spi, &m);
 
-	*retlen = m.actual_length - sizeof(flash->command);
+	*retlen = m.actual_length - CMD_SIZE - FAST_READ_DUMMY_BYTE;
 
 	mutex_unlock(&flash->lock);
 
@@ -325,7 +337,7 @@ static int m25p80_write(struct mtd_info *mtd, loff_t to, size_t len,
 	memset(t, 0, (sizeof t));
 
 	t[0].tx_buf = flash->command;
-	t[0].len = sizeof(flash->command);
+	t[0].len = CMD_SIZE;
 	spi_message_add_tail(&t[0], &m);
 
 	t[1].tx_buf = buf;
@@ -354,7 +366,7 @@ static int m25p80_write(struct mtd_info *mtd, loff_t to, size_t len,
 
 		spi_sync(flash->spi, &m);
 
-		*retlen = m.actual_length - sizeof(flash->command);
+		*retlen = m.actual_length - CMD_SIZE;
 	} else {
 		u32 i;
 
@@ -364,7 +376,7 @@ static int m25p80_write(struct mtd_info *mtd, loff_t to, size_t len,
 		t[1].len = page_size;
 		spi_sync(flash->spi, &m);
 
-		*retlen = m.actual_length - sizeof(flash->command);
+		*retlen = m.actual_length - CMD_SIZE;
 
 		/* write everything in PAGESIZE chunks */
 		for (i = page_size; i < len; i += page_size) {
@@ -387,8 +399,7 @@ static int m25p80_write(struct mtd_info *mtd, loff_t to, size_t len,
 			spi_sync(flash->spi, &m);
 
 			if (retlen)
-				*retlen += m.actual_length
-					- sizeof(flash->command);
+				*retlen += m.actual_length - CMD_SIZE;
 		}
 	}
 
-- 
1.5.5
