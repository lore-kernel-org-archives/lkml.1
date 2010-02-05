Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934115Ab0BEXTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 18:19:18 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:36334 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933925Ab0BEXSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 18:18:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=C4CwcK5j8L8jUBtPYFQn7Dxfb82v6o7at5fypFyD+zdU7+kgdMWDpuT+DFrORsh8Cb
         LBk6H2Kdd8t0qCO+3LIxcBpdwaa9SsFbt8POO0BJjl3u+4ivVEkB21iFuTTKeNL6pSPB
         7SrWKROI65QmTxnbFcg+2b1Cl8Y/liTP04MY4=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "stanley.miao" <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 4/7] MTD: nand: make reads using MTD_OOB_RAW affect only ECC validation
Date: Sat,  6 Feb 2010 01:18:07 +0200
Message-Id: <1265411890-9156-5-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265411890-9156-1-git-send-email-maximlevitsky@gmail.com>
References: <1265411890-9156-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the behavier of MTD_OOB_RAW. It used to read both OOB and data
to the data buffer, however you would still need to specify the dummy oob buffer.

This is only used in one place, but makes it hard to read data+oob without ECC
test, thus I removed that behavier, and fixed the user.

Now MTD_OOB_RAW behaves like MTD_OOB_PLACE, but doesn't do ECC validation

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/nand/nand_base.c |   19 +++++++------------
 drivers/mtd/nand/nand_bbt.c  |   26 ++++++++++++++++++++++----
 include/linux/mtd/mtd.h      |    4 +---
 3 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 2ff9c02..c393df3 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -1283,18 +1283,13 @@ static int nand_do_read_ops(struct mtd_info *mtd, loff_t from,
 
 			if (unlikely(oob)) {
 
-				/* Raw mode does data:oob:data:oob */
-				if (ops->mode != MTD_OOB_RAW) {
-					int toread = min(oobreadlen,
-								max_oobsize);
-					if (toread) {
-						oob = nand_transfer_oob(chip,
-							oob, ops, toread);
-						oobreadlen -= toread;
-					}
-				} else
-					buf = nand_transfer_oob(chip,
-						buf, ops, mtd->oobsize);
+				int toread = min(oobreadlen, max_oobsize);
+
+				if (toread) {
+					oob = nand_transfer_oob(chip,
+						oob, ops, toread);
+					oobreadlen -= toread;
+				}
 			}
 
 			if (!(chip->options & NAND_NO_READRDY)) {
diff --git a/drivers/mtd/nand/nand_bbt.c b/drivers/mtd/nand/nand_bbt.c
index 55c23e5..387c45c 100644
--- a/drivers/mtd/nand/nand_bbt.c
+++ b/drivers/mtd/nand/nand_bbt.c
@@ -237,15 +237,33 @@ static int scan_read_raw(struct mtd_info *mtd, uint8_t *buf, loff_t offs,
 			 size_t len)
 {
 	struct mtd_oob_ops ops;
+	int res;
 
 	ops.mode = MTD_OOB_RAW;
 	ops.ooboffs = 0;
 	ops.ooblen = mtd->oobsize;
-	ops.oobbuf = buf;
-	ops.datbuf = buf;
-	ops.len = len;
 
-	return mtd->read_oob(mtd, offs, &ops);
+
+	while (len > 0) {
+		if (len <= mtd->writesize) {
+			ops.oobbuf = buf + len;
+			ops.datbuf = buf;
+			ops.len = len;
+			return mtd->read_oob(mtd, offs, &ops);
+		} else {
+			ops.oobbuf = buf + mtd->writesize;
+			ops.datbuf = buf;
+			ops.len = mtd->writesize;
+			res = mtd->read_oob(mtd, offs, &ops);
+
+			if (res)
+				return res;
+		}
+
+		buf += mtd->oobsize + mtd->writesize;
+		len -= mtd->writesize;
+	}
+	return 0;
 }
 
 /*
diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
index 662d747..84bb375 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -61,9 +61,7 @@ struct mtd_erase_region_info {
  * MTD_OOB_PLACE:	oob data are placed at the given offset
  * MTD_OOB_AUTO:	oob data are automatically placed at the free areas
  *			which are defined by the ecclayout
- * MTD_OOB_RAW:		mode to read raw data+oob in one chunk. The oob data
- *			is inserted into the data. Thats a raw image of the
- *			flash contents.
+ * MTD_OOB_RAW:		mode to read oob and data without doing ECC checking
  */
 typedef enum {
 	MTD_OOB_PLACE,
-- 
1.6.3.3

