Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab0BVSlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:41:14 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:42209 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab0BVSlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:41:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sjaqne4TyEqEzlSYCVSs1dC1syw1dx/1I109ygzdPOPfmuvSsVELBVHj47ChQHwMiw
         QXltlYEBpkv2Bgz9qQc8j9RSigdRiWllOFwhm+ugx6iWmf8hXxJozOf9p1zJuRHomEfB
         QxBMRge7UNTNN6UFpjrGQGCIx0dEUKo+rSRH4=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>, <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 09/15] MTD: nand: cleanup the nand_do_write_ops
Date: Mon, 22 Feb 2010 20:39:36 +0200
Message-Id: <1266863982-5258-10-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266863982-5258-1-git-send-email-maximlevitsky@gmail.com>
References: <1266863982-5258-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nand_do_write_ops have broken in regard to writing several pages,
 each with its own oob.

Although nand_do_write_ops intends to allow such mode, it fails do do so
Probably this was never tested.

Also add missing checks for attemts to write at illegal offsets.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/nand/nand_base.c |   24 +++++++++++++++++-------
 1 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index cada4cf..1386741 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2072,11 +2072,9 @@ static int nand_write_page(struct mtd_info *mtd, struct nand_chip *chip,
  * @oob:	oob data buffer
  * @ops:	oob ops structure
  */
-static uint8_t *nand_fill_oob(struct nand_chip *chip, uint8_t *oob,
-				  struct mtd_oob_ops *ops)
+static uint8_t *nand_fill_oob(struct nand_chip *chip, uint8_t *oob, size_t len,
+						struct mtd_oob_ops *ops)
 {
-	size_t len = ops->ooblen;
-
 	switch(ops->mode) {
 
 	case MTD_OOB_PLACE:
@@ -2131,6 +2129,11 @@ static int nand_do_write_ops(struct mtd_info *mtd, loff_t to,
 	int chipnr, realpage, page, blockmask, column;
 	struct nand_chip *chip = mtd->priv;
 	uint32_t writelen = ops->len;
+
+	uint32_t oobwritelen = ops->ooblen;
+	uint32_t oobmaxlen = ops->mode == MTD_OOB_AUTO ?
+				mtd->oobavail : mtd->oobsize;
+
 	uint8_t *oob = ops->oobbuf;
 	uint8_t *buf = ops->datbuf;
 	int ret, subpage;
@@ -2172,6 +2175,10 @@ static int nand_do_write_ops(struct mtd_info *mtd, loff_t to,
 	if (likely(!oob))
 		memset(chip->oob_poi, 0xff, mtd->oobsize);
 
+	/* Don't allow multipage oob writes with offset */
+	if (ops->ooboffs && (ops->ooboffs + ops->ooblen > oobmaxlen))
+		return -EINVAL;
+
 	while(1) {
 		int bytes = mtd->writesize;
 		int cached = writelen > bytes && page != blockmask;
@@ -2187,8 +2194,11 @@ static int nand_do_write_ops(struct mtd_info *mtd, loff_t to,
 			wbuf = chip->buffers->databuf;
 		}
 
-		if (unlikely(oob))
-			oob = nand_fill_oob(chip, oob, ops);
+		if (unlikely(oob)) {
+			size_t len = min(oobwritelen, oobmaxlen);
+			oob = nand_fill_oob(chip, oob, len, ops);
+			oobwritelen -= len;
+		}
 
 		ret = chip->write_page(mtd, chip, wbuf, page, cached,
 				       (ops->mode == MTD_OOB_RAW));
@@ -2362,7 +2372,7 @@ static int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
 		chip->pagebuf = -1;
 
 	memset(chip->oob_poi, 0xff, mtd->oobsize);
-	nand_fill_oob(chip, ops->oobbuf, ops);
+	nand_fill_oob(chip, ops->oobbuf, ops->ooblen, ops);
 	status = chip->ecc.write_oob(mtd, chip, page & chip->pagemask);
 	memset(chip->oob_poi, 0xff, mtd->oobsize);
 
-- 
1.6.3.3

