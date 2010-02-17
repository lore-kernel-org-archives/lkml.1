Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab0BQVt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 16:49:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:55109 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757323Ab0BQVt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 16:49:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RQc4AdDAf/x9Uusfw3hAY5uFh3axqyclPf1mbdM2yIuqdye22giyb502P6kHxRO8ms
         U/meM2uHjdkQCSmI04hc0lzZMVb9StpgM4HDNLYsPUcv3GT9inOJYXYLwOi1c18Ot/BI
         yVTUdwnZCy2xbipSPng8QEKoD/SZ+1Y7OXzBE=
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
Subject: [PATCH 10/14] MTD: nand: add ->badblockbits to specify the minimum number of bits in bad block byte to consider the block good
Date: Wed, 17 Feb 2010 23:49:20 +0200
Message-Id: <1266443364-4538-11-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266443364-4538-1-git-send-email-maximlevitsky@gmail.com>
References: <1266443364-4538-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This can be used to protect against bitflips in that field, but now mostly
for smartmedia.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/nand/nand_base.c |   13 +++++++++----
 include/linux/mtd/nand.h     |    1 +
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index c393df3..88750a6 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -335,14 +335,18 @@ static int nand_block_bad(struct mtd_info *mtd, loff_t ofs, int getchip)
 		bad = cpu_to_le16(chip->read_word(mtd));
 		if (chip->badblockpos & 0x1)
 			bad >>= 8;
-		if ((bad & 0xFF) != 0xff)
-			res = 1;
+		else
+			bad &= 0xFF;
 	} else {
 		chip->cmdfunc(mtd, NAND_CMD_READOOB, chip->badblockpos, page);
-		if (chip->read_byte(mtd) != 0xff)
-			res = 1;
+		bad = chip->read_byte(mtd);
 	}
 
+	if (likely(chip->badblockbits == 8))
+		res = bad != 0xFF;
+	else
+		res = hweight8(bad) < chip->badblockbits;
+
 	if (getchip)
 		nand_release_device(mtd);
 
@@ -2710,6 +2714,7 @@ static struct nand_flash_dev *nand_get_flash_type(struct mtd_info *mtd,
 	/* Set the bad block position */
 	chip->badblockpos = mtd->writesize > 512 ?
 		NAND_LARGE_BADBLOCK_POS : NAND_SMALL_BADBLOCK_POS;
+	chip->badblockbits = 8;
 
 	/* Get chip options, preserve non chip based options */
 	chip->options &= ~NAND_CHIPOPTIONS_MSK;
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index ccab9df..27d998e 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -391,6 +391,7 @@ struct nand_chip {
 	int		subpagesize;
 	uint8_t		cellinfo;
 	int		badblockpos;
+	int		badblockbits;
 
 	flstate_t	state;
 
-- 
1.6.3.3

