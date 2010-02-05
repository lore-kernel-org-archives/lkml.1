Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933841Ab0BEXSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 18:18:30 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:36334 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757669Ab0BEXS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 18:18:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FXDI7web3qDo3yOkp/6D2mXjA88/tGca8m0cN/Goa1Vyqsl6BpsfhnEo1YDqvJmXHv
         91SdvdsfG7d5YGqwkgiKpW2d5+HbWJFL6mM5ekmAKZa89RtH71cDyYzNnzQcw6jsxmM7
         SYmw/SpGJ/CajYV5BfDR+f6pQcKyb21B1tjAo=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "stanley.miao" <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 1/7] MTD: nand: make MTD_OOB_PLACE work correctly.
Date: Sat,  6 Feb 2010 01:18:04 +0200
Message-Id: <1265411890-9156-2-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265411890-9156-1-git-send-email-maximlevitsky@gmail.com>
References: <1265411890-9156-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MTD_OOB_PLACE is supposed to read/write raw oob data similiar to MTD_OOB_RAW
however due to a bug, currently its not possible to read more data that
specified in oob 'free' regions

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/nand/nand_base.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 8f2958f..405c538 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -1232,6 +1232,9 @@ static int nand_do_read_ops(struct mtd_info *mtd, loff_t from,
 	int ret = 0;
 	uint32_t readlen = ops->len;
 	uint32_t oobreadlen = ops->ooblen;
+	uint32_t max_oobsize = ops->mode == MTD_OOB_AUTO ?
+		mtd->oobavail : mtd->oobsize;
+
 	uint8_t *bufpoi, *oob, *buf;
 
 	stats = mtd->ecc_stats;
@@ -1282,10 +1285,11 @@ static int nand_do_read_ops(struct mtd_info *mtd, loff_t from,
 			buf += bytes;
 
 			if (unlikely(oob)) {
+
 				/* Raw mode does data:oob:data:oob */
 				if (ops->mode != MTD_OOB_RAW) {
 					int toread = min(oobreadlen,
-						chip->ecc.layout->oobavail);
+								max_oobsize);
 					if (toread) {
 						oob = nand_transfer_oob(chip,
 							oob, ops, toread);
-- 
1.6.3.3

