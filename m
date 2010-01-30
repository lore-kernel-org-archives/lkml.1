Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978Ab0A3PDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab0A3PDc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 10:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837Ab0A3PDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 10:03:24 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:59769 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab0A3PDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 10:03:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=p5oc2RmPvQSpcFAJcIG9NPjlz6gKsfu+mBZodNIs3GoU1hSG6PB+WJYr/O3Xrsbepz
         RPtKA0xDIU64YKpZK8ISEqZJ+fAUDZOLeY31ciQN8nGqjoN3C5CPrBc5ad4G8AymScad
         nNNu0NQsaHBL++wonUJlcUOTbGS6H1PuHtznA=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 09/17] MTD: nand: make MTD_OOB_PLACE work correctly.
Date: Sat, 30 Jan 2010 17:02:40 +0200
Message-Id: <1264863768-27606-10-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1264863768-27606-1-git-send-email-maximlevitsky@gmail.com>
References: <1264863768-27606-1-git-send-email-maximlevitsky@gmail.com>
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

