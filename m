Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab0BMNF1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 08:05:27 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:49010 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab0BMNDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 08:03:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Q8C1czqzn7grQ7dOMCzghlpSp7TFKynQJNW7VRI3jv4TZjHYsryrUvvKQBSmscA/wm
         pQNcNzcQu5QgLX2QsCrArM1eYE9YGDOG9xTWh0jdy/7Xku99SwguHAIbGR8jkewjHeBd
         f9rFC5mI36fstJAH9f5XwUHaNVyylpKHPGyXw=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "stanley.miao" <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 08/14] MTD: nand: cleanup the nand_do_write_ops
Date: Sat, 13 Feb 2010 15:03:07 +0200
Message-Id: <1266066193-17625-9-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266066193-17625-1-git-send-email-maximlevitsky@gmail.com>
References: <1266066193-17625-1-git-send-email-maximlevitsky@gmail.com>
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
index 53c1e04..2ff9c02 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -1881,11 +1881,9 @@ static int nand_write_page(struct mtd_info *mtd, struct nand_chip *chip,
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
@@ -1940,6 +1938,11 @@ static int nand_do_write_ops(struct mtd_info *mtd, loff_t to,
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
@@ -1981,6 +1984,10 @@ static int nand_do_write_ops(struct mtd_info *mtd, loff_t to,
 	if (likely(!oob))
 		memset(chip->oob_poi, 0xff, mtd->oobsize);
 
+	/* Don't allow multipage oob writes with offset */
+	if (ops->ooboffs && (ops->ooboffs + ops->ooblen > oobmaxlen))
+		return -EINVAL;
+
 	while(1) {
 		int bytes = mtd->writesize;
 		int cached = writelen > bytes && page != blockmask;
@@ -1996,8 +2003,11 @@ static int nand_do_write_ops(struct mtd_info *mtd, loff_t to,
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
@@ -2171,7 +2181,7 @@ static int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
 		chip->pagebuf = -1;
 
 	memset(chip->oob_poi, 0xff, mtd->oobsize);
-	nand_fill_oob(chip, ops->oobbuf, ops);
+	nand_fill_oob(chip, ops->oobbuf, ops->ooblen, ops);
 	status = chip->ecc.write_oob(mtd, chip, page & chip->pagemask);
 	memset(chip->oob_poi, 0xff, mtd->oobsize);
 
-- 
1.6.3.3

