Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbYA3JT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbYA3JT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbYA3JS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:18:28 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:15373 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbYA3JSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:18:24 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="47623616"
From: Bryan Wu <bryan.wu@analog.com>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 3/3] [MTD/NAND] Blackfin NFC driver: fix ECC caculating bug when NAND Flash chip page size is 512 bytes
Date: Wed, 30 Jan 2008 17:18:18 +0800
Message-Id: <1201684698-26936-4-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1201684698-26936-1-git-send-email-bryan.wu@analog.com>
References: <1201684698-26936-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/mtd/nand/bf5xx_nand.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/nand/bf5xx_nand.c b/drivers/mtd/nand/bf5xx_nand.c
index 2fe9678..7d6ac6a 100644
--- a/drivers/mtd/nand/bf5xx_nand.c
+++ b/drivers/mtd/nand/bf5xx_nand.c
@@ -293,7 +293,6 @@ static int bf5xx_nand_calculate_ecc(struct mtd_info *mtd,
 	u16 ecc0, ecc1;
 	u32 code[2];
 	u8 *p;
-	int bytes = 3, i;
 
 	/* first 4 bytes ECC code for 256 page size */
 	ecc0 = bfin_read_NFC_ECC0();
@@ -303,19 +302,24 @@ static int bf5xx_nand_calculate_ecc(struct mtd_info *mtd,
 
 	dev_dbg(info->device, "returning ecc 0x%08x\n", code[0]);
 
+	/* first 3 bytes in ecc_code for 256 page size */
+	p = (u8 *) code;
+	memcpy(ecc_code, p, 3);
+
 	/* second 4 bytes ECC code for 512 page size */
 	if (page_size == 512) {
 		ecc0 = bfin_read_NFC_ECC2();
 		ecc1 = bfin_read_NFC_ECC3();
 		code[1] = (ecc0 & 0x3FF) | ((ecc1 & 0x3FF) << 11);
-		bytes = 6;
+
+		/* second 3 bytes in ecc_code for second 256
+		 * bytes of 512 page size
+		 */
+		p = (u8 *) (code + 1);
+		memcpy((ecc_code + 3), p, 3);
 		dev_dbg(info->device, "returning ecc 0x%08x\n", code[1]);
 	}
 
-	p = (u8 *)code;
-	for (i = 0; i < bytes; i++)
-		ecc_code[i] = p[i];
-
 	return 0;
 }
 
-- 
1.5.3.4
