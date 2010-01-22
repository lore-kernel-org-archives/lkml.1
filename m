Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210Ab0AVP6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab0AVP6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 10:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861Ab0AVP6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 10:58:34 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:59847 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab0AVP6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 10:58:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AXXl8o78FgVKAJ8eoYtabVY5bIWmNaaHPBsETiPCaYv6Fn7uhYfNsNRrGo3JZ1g/hM
         C/TqyPwiB1LgHQPbh76Y6beQJrMj6wpoj2Ja24R23fe9WYlh/x8JsJFcFNs4684P8MQC
         dyyarmj8wKvCSkh7HW/W99UDMHt5Y9rCG7zhQ=
Subject: [PATCH 2/6] MTD: nand: make reads using MTD_OOB_RAW affect only
 ECC validation
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1264175781.24012.42.camel@maxim-laptop>
References: <1264175781.24012.42.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 17:58:26 +0200
Message-ID: <1264175906.24012.44.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d355621ea624e8c9b1e198f0b049253c700b7431 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Fri, 22 Jan 2010 16:41:33 +0200
Subject: [PATCH 2/6] MTD: nand: make reads using MTD_OOB_RAW affect only ECC validation

This changes the behavier of MTD_OOB_RAW. It used to read both OOB and data
to the data buffer, however you would still need to specify the dummy oob buffer.

This is only used in one place, but makes it hard to read data+oob without ECC
test, thus I removed that behavier, and fixed the user.

Now MTD_OOB_RAW behaves like MTD_OOB_PLACE, but doesn't do ECC validation

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/nand/nand_base.c |    5 -----
 drivers/mtd/nand/nand_bbt.c  |   26 ++++++++++++++++++++++----
 include/linux/mtd/mtd.h      |    4 +---
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 405c538..8ff36be 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -1286,8 +1286,6 @@ static int nand_do_read_ops(struct mtd_info *mtd, loff_t from,
 
 			if (unlikely(oob)) {
 
-				/* Raw mode does data:oob:data:oob */
-				if (ops->mode != MTD_OOB_RAW) {
 					int toread = min(oobreadlen,
 								max_oobsize);
 					if (toread) {
@@ -1295,9 +1293,6 @@ static int nand_do_read_ops(struct mtd_info *mtd, loff_t from,
 							oob, ops, toread);
 						oobreadlen -= toread;
 					}
-				} else
-					buf = nand_transfer_oob(chip,
-						buf, ops, mtd->oobsize);
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



