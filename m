Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728Ab0ALTf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab0ALTf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 14:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729Ab0ALTfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 14:35:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:35910 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab0ALTfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 14:35:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ISRjT36kQG85BxD7kUaFqUs5xkUjDxdErhZNC1qKCm4md060fe17EjZSC7rMrW5Y96
         xI/a0vWC3Ak1BJVMyFohDlmp2XPc3ZR6WILOhAGhKkIQaz5xq5R1/SgoDzS/x81lBXGu
         2KptQ49J5OeFANSaXqt8Yeiw1ivTbrnZGYGvM=
Subject: [PATCH 7/9] MTD: add few workarounds to nand system for
 SmartMedia/xD chips.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>, joern <joern@logfs.org>,
       Alex Dubov <oakad@yahoo.com>
In-Reply-To: <1263324518.6236.18.camel@maxim-laptop>
References: <1263324518.6236.18.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jan 2010 21:35:18 +0200
Message-ID: <1263324918.6236.25.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 43f5dddd8787ffe32b27cb63ac3e7b72895a3d14 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Tue, 12 Jan 2010 21:09:34 +0200
Subject: [PATCH 7/9] MTD: add few workarounds to nand system for SmartMedia/xD chips.

* Add an option NAND_SMARTMEDIA that can be set by nand driver
 If set, it will cause separate ID table to be used, which includes
 mask rom devices and new xD cards

* Workaround for wrong write protect status on some xD cards

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/nand/nand_base.c |   30 ++++++++++++++++++++++--------
 drivers/mtd/nand/nand_ids.c  |   39 +++++++++++++++++++++++++++++++++++++++
 drivers/mtd/nand/sm_common.c |    2 +-
 include/linux/mtd/nand.h     |   11 +++++++++++
 4 files changed, 73 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 13d1d67..90409f6 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -397,9 +397,18 @@ static int nand_default_block_markbad(struct mtd_info *mtd, loff_t ofs)
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
@@ -2624,14 +2633,18 @@ static struct nand_flash_dev *nand_get_flash_type(struct mtd_info *mtd,
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
@@ -2988,7 +3001,8 @@ int nand_scan_tail(struct mtd_info *mtd)
 
 	/* Fill in remaining MTD driver data */
 	mtd->type = MTD_NANDFLASH;
-	mtd->flags = MTD_CAP_NANDFLASH;
+	mtd->flags = chip->options & NAND_ROM ? MTD_CAP_ROM :
+							MTD_CAP_NANDFLASH;
 	mtd->erase = nand_erase;
 	mtd->point = NULL;
 	mtd->unpoint = NULL;
diff --git a/drivers/mtd/nand/nand_ids.c b/drivers/mtd/nand/nand_ids.c
index 69ee2c9..799c080 100644
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
+#define XD_TYPEM	NAND_NO_AUTOINCR | NAND_BROKEN_XD
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
diff --git a/drivers/mtd/nand/sm_common.c b/drivers/mtd/nand/sm_common.c
index 55ae3ff..8df170d 100644
--- a/drivers/mtd/nand/sm_common.c
+++ b/drivers/mtd/nand/sm_common.c
@@ -91,7 +91,7 @@ int sm_register_device(struct mtd_info *mtd)
 	struct nand_chip *chip = (struct nand_chip *)mtd->priv;
 	int ret;
 
-	chip->options |= NAND_SKIP_BBTSCAN;
+	chip->options |= NAND_SKIP_BBTSCAN | NAND_SMARTMEDIA;
 
 	/* Scan for card properties */
 	ret = nand_scan_ident(mtd, 1);
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 8c2333a..bb25cd8 100644
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



