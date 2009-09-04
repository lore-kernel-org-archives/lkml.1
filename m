Return-Path: <linux-kernel-owner+w=401wt.eu-S933730AbZIDQUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730AbZIDQUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933719AbZIDQUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:20:52 -0400
Received: from mba.ocn.ne.jp ([122.28.14.163]:63431 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933681AbZIDQUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:20:46 -0400
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: linux-mtd@lists.infradead.org
Cc: dwmw2@infradead.org, Ian Molton <spyro@f2s.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       vimal singh <vimal.newwork@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] mtd/nand: Add __nand_correct_data helper function
Date: Sat,  5 Sep 2009 01:20:43 +0900
Message-Id: <1252081245-11895-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split nand_correct_data() into two part, a pure calculation function
and a wrapper for mtd interface.

The tmio_nand driver can implement its ecc.correct function easily
using this __nand_correct_data helper.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Acked-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Acked-by: Vimal Singh <vimalsingh@ti.com>
---
This is resend of:
http://lists.infradead.org/pipermail/linux-mtd/2009-July/026652.html

 drivers/mtd/nand/nand_ecc.c  |   31 ++++++++++++++++++++++++-------
 include/linux/mtd/nand_ecc.h |    6 ++++++
 2 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/nand/nand_ecc.c b/drivers/mtd/nand/nand_ecc.c
index c0cb87d..db7ae9d 100644
--- a/drivers/mtd/nand/nand_ecc.c
+++ b/drivers/mtd/nand/nand_ecc.c
@@ -417,22 +417,22 @@ int nand_calculate_ecc(struct mtd_info *mtd, const unsigned char *buf,
 EXPORT_SYMBOL(nand_calculate_ecc);
 
 /**
- * nand_correct_data - [NAND Interface] Detect and correct bit error(s)
- * @mtd:	MTD block structure
+ * __nand_correct_data - [NAND Interface] Detect and correct bit error(s)
  * @buf:	raw data read from the chip
  * @read_ecc:	ECC from the chip
  * @calc_ecc:	the ECC calculated from raw data
+ * @eccsize:	data bytes per ecc step (256 or 512)
  *
- * Detect and correct a 1 bit error for 256/512 byte block
+ * Detect and correct a 1 bit error for eccsize byte block
  */
-int nand_correct_data(struct mtd_info *mtd, unsigned char *buf,
-		      unsigned char *read_ecc, unsigned char *calc_ecc)
+int __nand_correct_data(unsigned char *buf,
+			unsigned char *read_ecc, unsigned char *calc_ecc,
+			unsigned int eccsize)
 {
 	unsigned char b0, b1, b2, bit_addr;
 	unsigned int byte_addr;
 	/* 256 or 512 bytes/ecc  */
-	const uint32_t eccsize_mult =
-			(((struct nand_chip *)mtd->priv)->ecc.size) >> 8;
+	const uint32_t eccsize_mult = eccsize >> 8;
 
 	/*
 	 * b0 to b2 indicate which bit is faulty (if any)
@@ -495,6 +495,23 @@ int nand_correct_data(struct mtd_info *mtd, unsigned char *buf,
 	printk(KERN_ERR "uncorrectable error : ");
 	return -1;
 }
+EXPORT_SYMBOL(__nand_correct_data);
+
+/**
+ * nand_correct_data - [NAND Interface] Detect and correct bit error(s)
+ * @mtd:	MTD block structure
+ * @buf:	raw data read from the chip
+ * @read_ecc:	ECC from the chip
+ * @calc_ecc:	the ECC calculated from raw data
+ *
+ * Detect and correct a 1 bit error for 256/512 byte block
+ */
+int nand_correct_data(struct mtd_info *mtd, unsigned char *buf,
+		      unsigned char *read_ecc, unsigned char *calc_ecc)
+{
+	return __nand_correct_data(buf, read_ecc, calc_ecc,
+				   ((struct nand_chip *)mtd->priv)->ecc.size);
+}
 EXPORT_SYMBOL(nand_correct_data);
 
 MODULE_LICENSE("GPL");
diff --git a/include/linux/mtd/nand_ecc.h b/include/linux/mtd/nand_ecc.h
index 090da50..052ea8c 100644
--- a/include/linux/mtd/nand_ecc.h
+++ b/include/linux/mtd/nand_ecc.h
@@ -21,6 +21,12 @@ struct mtd_info;
 int nand_calculate_ecc(struct mtd_info *mtd, const u_char *dat, u_char *ecc_code);
 
 /*
+ * Detect and correct a 1 bit error for eccsize byte block
+ */
+int __nand_correct_data(u_char *dat, u_char *read_ecc, u_char *calc_ecc,
+			unsigned int eccsize);
+
+/*
  * Detect and correct a 1 bit error for 256 byte block
  */
 int nand_correct_data(struct mtd_info *mtd, u_char *dat, u_char *read_ecc, u_char *calc_ecc);
-- 
1.5.6.5

