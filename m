Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934097Ab0BEXSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 18:18:47 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:45940 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934078Ab0BEXSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 18:18:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UpGFIuVAwI7nFNeySrwqR1afAhxIIklfo2vXzJ6jf++m24PgjnydTFpmIpGaY0CxeA
         xAFiP2TomuhKaDwsItfkDQyAUXFVEdiEzRegdCDHKooBa4o8A6Mq49cF5+Z6yOPGzqh0
         nBtwiE9ysE4q8x46jDTNS/bkpafihHaQf/tKo=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "stanley.miao" <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 7/7] MTD: add few workarounds to nand system for SmartMedia/xD chips.
Date: Sat,  6 Feb 2010 01:18:10 +0200
Message-Id: <1265411890-9156-8-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265411890-9156-1-git-send-email-maximlevitsky@gmail.com>
References: <1265411890-9156-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add an option NAND_SMARTMEDIA that can be set by nand driver
 If set, it will cause separate ID table to be used, which includes
 mask rom devices and new xD cards

* Workaround for wrong write protect status on some xD cards

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/nand/nand_base.c |   30 ++++++++++++++++++++++--------
 drivers/mtd/nand/nand_ids.c  |   39 +++++++++++++++++++++++++++++++++++++++
 include/linux/mtd/nand.h     |   11 +++++++++++
 3 files changed, 72 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 86fa40a..09d1433 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -395,9 +395,18 @@ static int nand_default_block_markbad(struct mtd_info *mtd, loff_t ofs)
 static int nand_check_wp(struct mtd_info *mtd)
 {
 	struct nand_chip *chip = mtd->priv;
+	int wp;
+
+	/* broken xD cards report WP despite beeing writable */
+	if (chip->options & NAND_BROKEN_XD)
+		return 0;
+
 	/* Check the WP bit */
 	chip->cmdfunc(mtd, NAND_CMD_STATUS, -1, -1);
-	return (chip->read_byte(mtd) & NAND_STATUS_WP) ? 0 : 1;
+	wp = (chip->read_byte(mtd) & NAND_STATUS_WP) ? 0 : 1;
+
+
+	return wp;
 }
 
 /**
@@ -2651,14 +2660,18 @@ static struct nand_flash_dev *nand_get_flash_type(struct mtd_info *mtd,
 	}
 
 	/* Lookup the flash id */
-	for (i = 0; nand_flash_ids[i].name != NULL; i++) {
-		if (dev_id == nand_flash_ids[i].id) {
-			type =  &nand_flash_ids[i];
+#ifdef CONFIG_MTD_NAND_SMARTMEDIA
+	if (chip->options & NAND_SMARTMEDIA)
+		type = nand_smartmedia_flash_ids;
+	else
+#endif
+		type = nand_flash_ids;
+
+	for (i = 0; type->name != NULL; type++)
+		if (dev_id == type->id)
 			break;
-		}
-	}
 
-	if (!type)
+	if (!type->name)
 		return ERR_PTR(-ENODEV);
 
 	if (!mtd->name)
@@ -3015,7 +3028,8 @@ int nand_scan_tail(struct mtd_info *mtd)
 
 	/* Fill in remaining MTD driver data */
 	mtd->type = MTD_NANDFLASH;
-	mtd->flags = MTD_CAP_NANDFLASH;
+	mtd->flags = chip->options & NAND_ROM ? MTD_CAP_ROM :
+							MTD_CAP_NANDFLASH;
 	mtd->erase = nand_erase;
 	mtd->point = NULL;
 	mtd->unpoint = NULL;
diff --git a/drivers/mtd/nand/nand_ids.c b/drivers/mtd/nand/nand_ids.c
index 69ee2c9..f9e72d5 100644
--- a/drivers/mtd/nand/nand_ids.c
+++ b/drivers/mtd/nand/nand_ids.c
@@ -127,6 +127,45 @@ struct nand_flash_dev nand_flash_ids[] = {
 	{NULL,}
 };
 
+#ifdef CONFIG_MTD_NAND_SMARTMEDIA
+struct nand_flash_dev nand_smartmedia_flash_ids[] = {
+
+	/* SmartMedia */
+	{"SmartMedia 1MiB 5V",		0x6e, 256, 1, 0x1000, 0},
+	{"SmartMedia 1MiB 3,3V",	0xe8, 256, 1, 0x1000, 0},
+	{"SmartMedia 1MiB 3,3V",	0xec, 256, 1, 0x1000, 0},
+	{"SmartMedia 2MiB 3,3V",	0xea, 256, 2, 0x1000, 0},
+	{"SmartMedia 2MiB 5V",		0x64, 256, 2, 0x1000, 0},
+	{"SmartMedia 2MiB 3,3V ROM",	0x5d, 512, 2, 0x2000, NAND_ROM},
+	{"SmartMedia 4MiB 3,3V",	0xe3, 512, 4, 0x2000, 0},
+	{"SmartMedia 4MiB 3,3/5V",	0xe5, 512, 4, 0x2000, 0},
+	{"SmartMedia 4MiB 5V",		0x6b, 512, 4, 0x2000, 0},
+	{"SmartMedia 4MiB 3,3V ROM",	0xd5, 512, 4, 0x2000, NAND_ROM},
+	{"SmartMedia 8MiB 3,3V",	0xe6, 512, 8, 0x2000, 0},
+	{"SmartMedia 8MiB 3,3V ROM",	0xd6, 512, 8, 0x2000, NAND_ROM},
+
+#define XD_TYPEM	(NAND_NO_AUTOINCR | NAND_BROKEN_XD)
+	/* xD / SmartMedia */
+	{"SmartMedia/xD 16MiB 3,3V",	0x73, 512, 16, 0x4000, 0},
+	{"SmartMedia 16MiB 3,3V ROM",	0x57, 512, 16, 0x4000, NAND_ROM},
+	{"SmartMedia/xD 32MiB 3,3V",	0x75, 512, 32, 0x4000, 0},
+	{"SmartMedia 32MiB 3,3V ROM",	0x58, 512, 32, 0x4000, NAND_ROM},
+	{"SmartMedia/xD 64MiB 3,3V",	0x76, 512, 64, 0x4000, 0},
+	{"SmartMedia 64MiB 3,3V ROM",	0xd9, 512, 64, 0x4000, NAND_ROM},
+	{"SmartMedia/xD 128MiB 3,3V",	0x79, 512, 128, 0x4000, 0},
+	{"SmartMedia 128MiB 3,3V ROM",	0xda, 512, 128, 0x4000, NAND_ROM},
+	{"SmartMedia/xD 256MiB 3,3V",	0x71, 512, 256, 0x4000, XD_TYPEM},
+	{"SmartMedia 256MiB 3,3V ROM",	0x5b, 512, 256, 0x4000, NAND_ROM},
+
+	/* xD only */
+	{"xD 512MiB 3,3V",		0xDC, 512, 512, 0x4000, XD_TYPEM},
+	{"xD 1GiB 3,3V",		0xD3, 512, 1024, 0x4000, XD_TYPEM},
+	{"xD 2GiB 3,3V",		0xD5, 512, 2048, 0x4000, XD_TYPEM},
+	{NULL,}
+};
+EXPORT_SYMBOL(nand_smartmedia_flash_ids);
+#endif
+
 /*
 *	Manufacturer ID list
 */
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 921f24b..3fe8d9e 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -170,6 +170,12 @@ typedef enum {
 /* Chip does not allow subpage writes */
 #define NAND_NO_SUBPAGE_WRITE	0x00000200
 
+/* Device is one of 'new' xD cards that expose fake nand command set */
+#define NAND_BROKEN_XD		0x00000400
+
+/* Device behaves just like nand, but is readonly */
+#define NAND_ROM		0x00000800
+
 /* Options valid for Samsung large page devices */
 #define NAND_SAMSUNG_LP_OPTIONS \
 	(NAND_NO_PADDING | NAND_CACHEPRG | NAND_COPYBACK)
@@ -195,9 +201,13 @@ typedef enum {
 /* This option is defined if the board driver allocates its own buffers
    (e.g. because it needs them DMA-coherent */
 #define NAND_OWN_BUFFERS	0x00040000
+
 /* Chip may not exist, so silence any errors in scan */
 #define NAND_SCAN_SILENT_NODEV	0x00080000
 
+/* controller supports only xD/SmartMedia cards*/
+#define NAND_SMARTMEDIA		0x00100000
+
 /* Options set by nand scan */
 /* Nand scan has allocated controller struct */
 #define NAND_CONTROLLER_ALLOC	0x80000000
@@ -458,6 +468,7 @@ struct nand_manufacturers {
 };
 
 extern struct nand_flash_dev nand_flash_ids[];
+extern struct nand_flash_dev nand_smartmedia_flash_ids[];
 extern struct nand_manufacturers nand_manuf_ids[];
 
 extern int nand_scan_bbt(struct mtd_info *mtd, struct nand_bbt_descr *bd);
-- 
1.6.3.3

