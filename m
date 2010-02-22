Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab0BVSkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:40:20 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:56979 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab0BVSkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:40:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VMSx1GeloWzTKw3bdBCFUqW3QSeCJRPEK4Kb7ws3yR2jh/W/Va8gs6jA58ozxU8cg3
         fSJwfrnJUqhAr1LwhC6cEewWKEr0TDRkT2VWOvPJgeQtvGc4uHBcv45imF17CMDCJKhR
         tU4O3j7Q4Es9kysT6ib4minKlOoF4qTVYw6qQ=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>, <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 08/15] MTD: nand: make MTD_OOB_PLACE work correctly.
Date: Mon, 22 Feb 2010 20:39:35 +0200
Message-Id: <1266863982-5258-9-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266863982-5258-1-git-send-email-maximlevitsky@gmail.com>
References: <1266863982-5258-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MTD_OOB_PLACE is supposed to read/write the raw oob data similiar to the MTD_OOB_RAW
however due to a bug, currently it is not possible to read more data that
is specified by the oob 'free' regions.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/nand/nand_base.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 7442b3a..cada4cf 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -1420,6 +1420,9 @@ static int nand_do_read_ops(struct mtd_info *mtd, loff_t from,
 	int ret = 0;
 	uint32_t readlen = ops->len;
 	uint32_t oobreadlen = ops->ooblen;
+	uint32_t max_oobsize = ops->mode == MTD_OOB_AUTO ?
+		mtd->oobavail : mtd->oobsize;
+
 	uint8_t *bufpoi, *oob, *buf;
 
 	stats = mtd->ecc_stats;
@@ -1470,10 +1473,11 @@ static int nand_do_read_ops(struct mtd_info *mtd, loff_t from,
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

