Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab0BQVv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 16:51:56 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:55109 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab0BQVtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 16:49:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lFA04a+aBJsEVVnRWX4uzffZKaarcbhWa2HpDeb0ZGdmwy+9mJ6i7WGSuhC3mmFRc/
         Tl83n9h7l4Uce2TM5ClPNdhhEkL8R2uKdp9M1oh8qC145HC6P3jkIpjyapNsqNzdQ7kc
         IABL1z9dfVsUWXeOg3qcYbMcsKFObkrFiEGMk=
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
Subject: [PATCH 07/14] MTD: nand: make MTD_OOB_PLACE work correctly.
Date: Wed, 17 Feb 2010 23:49:17 +0200
Message-Id: <1266443364-4538-8-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266443364-4538-1-git-send-email-maximlevitsky@gmail.com>
References: <1266443364-4538-1-git-send-email-maximlevitsky@gmail.com>
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
index 279b960..53c1e04 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -1229,6 +1229,9 @@ static int nand_do_read_ops(struct mtd_info *mtd, loff_t from,
 	int ret = 0;
 	uint32_t readlen = ops->len;
 	uint32_t oobreadlen = ops->ooblen;
+	uint32_t max_oobsize = ops->mode == MTD_OOB_AUTO ?
+		mtd->oobavail : mtd->oobsize;
+
 	uint8_t *bufpoi, *oob, *buf;
 
 	stats = mtd->ecc_stats;
@@ -1279,10 +1282,11 @@ static int nand_do_read_ops(struct mtd_info *mtd, loff_t from,
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

