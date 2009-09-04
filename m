Return-Path: <linux-kernel-owner+w=401wt.eu-S933717AbZIDQUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717AbZIDQUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933023AbZIDQUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:20:48 -0400
Received: from mba.ocn.ne.jp ([122.28.14.163]:63454 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932542AbZIDQUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:20:46 -0400
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: linux-mtd@lists.infradead.org
Cc: dwmw2@infradead.org, Ian Molton <spyro@f2s.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       vimal singh <vimal.newwork@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] mtd/nand: Fix tmio_nand ecc correction
Date: Sat,  5 Sep 2009 01:20:44 +0900
Message-Id: <1252081245-11895-2-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver may be reading 512 bytes at a times, but still calculates
256-byte sector ECC.  So the nand_correct_data() is not appropriate
for this driver.  Implement its ecc.correct function calling
__nand_correct_data() twice.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Acked-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Acked-by: Vimal Singh <vimalsingh@ti.com>
---
This is resend of:
http://lists.infradead.org/pipermail/linux-mtd/2009-July/026651.html

 drivers/mtd/nand/tmio_nand.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/tmio_nand.c b/drivers/mtd/nand/tmio_nand.c
index daa6a4c..92c7334 100644
--- a/drivers/mtd/nand/tmio_nand.c
+++ b/drivers/mtd/nand/tmio_nand.c
@@ -301,6 +301,21 @@ static int tmio_nand_calculate_ecc(struct mtd_info *mtd, const u_char *dat,
 	return 0;
 }
 
+static int tmio_nand_correct_data(struct mtd_info *mtd, unsigned char *buf,
+		unsigned char *read_ecc, unsigned char *calc_ecc)
+{
+	int r0, r1;
+
+	/* assume ecc.size = 512 and ecc.bytes = 6 */
+	r0 = __nand_correct_data(buf, read_ecc, calc_ecc, 256);
+	if (r0 < 0)
+		return r0;
+	r1 = __nand_correct_data(buf + 256, read_ecc + 3, calc_ecc + 3, 256);
+	if (r1 < 0)
+		return r1;
+	return r0 + r1;
+}
+
 static int tmio_hw_init(struct platform_device *dev, struct tmio_nand *tmio)
 {
 	struct mfd_cell *cell = (struct mfd_cell *)dev->dev.platform_data;
@@ -424,7 +439,7 @@ static int tmio_probe(struct platform_device *dev)
 	nand_chip->ecc.bytes = 6;
 	nand_chip->ecc.hwctl = tmio_nand_enable_hwecc;
 	nand_chip->ecc.calculate = tmio_nand_calculate_ecc;
-	nand_chip->ecc.correct = nand_correct_data;
+	nand_chip->ecc.correct = tmio_nand_correct_data;
 
 	if (data)
 		nand_chip->badblock_pattern = data->badblock_pattern;
-- 
1.5.6.5

