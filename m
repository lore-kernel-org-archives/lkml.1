Return-Path: <linux-kernel-owner+w=401wt.eu-S1760437AbYHVCBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760437AbYHVCBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 22:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759230AbYHVCAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 22:00:54 -0400
Received: from elasmtp-kukur.atl.sa.earthlink.net ([209.86.89.65]:58603 "EHLO
	elasmtp-kukur.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758214AbYHVCAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 22:00:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=iePyjIHAoW+iBwyjp/3P/qCNpsal2HHSjjD3CDThhGBKmJQmfuQ8fHkjlZ3ey/+n;
  h=Message-ID:Date:From:Reply-To:To:Subject:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Message-ID: <24000594.1219370450154.JavaMail.root@elwamui-cypress.atl.sa.earthlink.net>
Date: Thu, 21 Aug 2008 19:00:50 -0700 (GMT-07:00)
From: Bruce Leonard <brucle@earthlink.net>
Reply-To: Bruce Leonard <brucle@earthlink.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2][MTD] Code cleanup for > 2GiB MTD devices
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: EarthLink Zoo Mail 1.0
X-ELNK-Trace: 481fc18f0ae4055094f5150ab1c16ac08868399773331e304f90e17fc8bc2c326777ef747ff19f52350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 209.86.224.32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ab740d4e4b786a04a51b1de44e91f51919709e0a Mon Sep 17 00:00:00 2001
From: brucle <brucle@selinc.com>
Date: Wed, 13 Aug 2008 17:16:48 -0700
Subject: [PATCH] Code clean up preping for support of > 2GiB MTD devices

Signed-off-by: Bruce D. Leonard <brucle@selinc.com>

---
 drivers/mtd/nand/nand_base.c |    2 +-
 drivers/mtd/nand/nand_bbt.c  |    5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index d1129ba..d5ac675 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2042,7 +2042,7 @@ int nand_erase_nand(struct mtd_info *mtd, struct erase_info *instr,
 		return -EINVAL;
 	}
 
-	instr->fail_addr = 0xffffffff;
+	instr->fail_addr = (typeof(instr->fail_addr))(-1);
 
 	/* Grab the lock and see if the device is available */
 	nand_get_device(chip, mtd, FL_ERASING);
diff --git a/drivers/mtd/nand/nand_bbt.c b/drivers/mtd/nand/nand_bbt.c
index 0b1c485..2f9f0f5 100644
--- a/drivers/mtd/nand/nand_bbt.c
+++ b/drivers/mtd/nand/nand_bbt.c
@@ -411,7 +411,7 @@ static int create_bbt(struct mtd_info *mtd, uint8_t *buf,
 		numblocks = this->chipsize >> (this->bbt_erase_shift - 1);
 		startblock = chip * numblocks;
 		numblocks += startblock;
-		from = startblock << (this->bbt_erase_shift - 1);
+		from = (loff_t)startblock << (this->bbt_erase_shift - 1);
 	}
 
 	for (i = startblock; i < numblocks;) {
@@ -495,7 +495,7 @@ static int search_bbt(struct mtd_info *mtd, uint8_t *buf, struct nand_bbt_descr
 		for (block = 0; block < td->maxblocks; block++) {
 
 			int actblock = startblock + dir * block;
-			loff_t offs = actblock << this->bbt_erase_shift;
+			loff_t offs = (loff_t)actblock << this->bbt_erase_shift;
 
 			/* Read first page */
 			scan_read_raw(mtd, buf, offs, mtd->writesize);
@@ -1027,7 +1027,6 @@ int nand_update_bbt(struct mtd_info *mtd, loff_t offs)
 	if (!this->bbt || !td)
 		return -EINVAL;
 
-	len = mtd->size >> (this->bbt_erase_shift + 2);
 	/* Allocate a temporary buffer for one eraseblock incl. oob */
 	len = (1 << this->bbt_erase_shift);
 	len += (len >> this->page_shift) * mtd->oobsize;
-- 
1.5.3.4


