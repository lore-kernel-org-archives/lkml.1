Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366Ab0AVP5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab0AVP5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 10:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846Ab0AVP5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 10:57:39 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:50625 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab0AVP5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 10:57:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TNQtZgEP8cNSys9P2wRXoHJEBJfeBuhAVSgYz9G4C9pD830EtOGRvQB99/vEQkxfX3
         Or59PbfFHNCFcF4E7Gn7ZYQFuQj7Dsxgedzd9P3y9MeJbLNHurrq937iNOA5XmJrciCn
         tCJCInNmkyQLewuSwH9x0lb3ayk61N/kY//24=
Subject: [PATCH 1/6] MTD: nand: make MTD_OOB_PLACE work correctly.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1264175781.24012.42.camel@maxim-laptop>
References: <1264175781.24012.42.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 17:57:31 +0200
Message-ID: <1264175851.24012.43.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 53cc4bab741b55c02ee726eed40b876209aa3e91 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Fri, 22 Jan 2010 16:41:33 +0200
Subject: [PATCH 1/6] MTD: nand: make MTD_OOB_PLACE work correctly.

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



