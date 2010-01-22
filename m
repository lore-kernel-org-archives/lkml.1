Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537Ab0AVVRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab0AVVRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 16:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458Ab0AVVRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 16:17:44 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:39639 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab0AVVRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 16:17:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=qvzCd45Jn7uQhZDTMwvTerCaak4wlm5W1yN52F0mCTuU7e/JMf3RBCZjJ97TXHefIe
         TFKd1pP/0/jf1Z/LfdeI78AtCLmgPCE353GLpGxYYrG3vFiWON0U39nqHBSPRtrQg4NL
         Ed7V+zsaWUEVZ2uA31wJocbv/K/TlhXAz8cRg=
Message-ID: <4B5A172C.2010609@gmail.com>
Date: Fri, 22 Jan 2010 22:22:52 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Leo Chen <leochen@broadcom.com>, Scott Branden <sbranden@broadcom.com>,
       linux-mtd@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mtd: hot spin and code duplication in nand_bcm_umi_bch_read_oobEcc()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the branch where pagesize equalled NAND_DATA_ACCESS_SIZE, NumToRead
wasn't decremented in the `while (numToRead > 11)' loop.
Also the first and last while loops were duplicated in both branches.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/mtd/nand/nand_bcm_umi.h |   71 ++++++++++++++-------------------------
 1 files changed, 25 insertions(+), 46 deletions(-)

diff --git a/drivers/mtd/nand/nand_bcm_umi.h b/drivers/mtd/nand/nand_bcm_umi.h
index 7cec2cd..198b304 100644
--- a/drivers/mtd/nand/nand_bcm_umi.h
+++ b/drivers/mtd/nand/nand_bcm_umi.h
@@ -167,18 +167,27 @@ static inline void nand_bcm_umi_bch_read_oobEcc(uint32_t pageSize,
 	int numToRead = 16;	/* There are 16 bytes per sector in the OOB */
 
 	/* ECC is already paused when this function is called */
+	if (pageSize != NAND_DATA_ACCESS_SIZE) {
+		/* skip BI */
+#if defined(__KERNEL__) && !defined(STANDALONE)
+		*oobp++ = REG_NAND_DATA8;
+#else
+		REG_NAND_DATA8;
+#endif
+		numToRead--;
+	}
 
-	if (pageSize == NAND_DATA_ACCESS_SIZE) {
-		while (numToRead > numEccBytes) {
-			/* skip free oob region */
+	while (numToRead > numEccBytes) {
+		/* skip free oob region */
 #if defined(__KERNEL__) && !defined(STANDALONE)
-			*oobp++ = REG_NAND_DATA8;
+		*oobp++ = REG_NAND_DATA8;
 #else
-			REG_NAND_DATA8;
+		REG_NAND_DATA8;
 #endif
-			numToRead--;
-		}
+		numToRead--;
+	}
 
+	if (pageSize == NAND_DATA_ACCESS_SIZE) {
 		/* read ECC bytes before BI */
 		nand_bcm_umi_bch_resume_read_ecc_calc();
 
@@ -190,6 +199,7 @@ static inline void nand_bcm_umi_bch_read_oobEcc(uint32_t pageSize,
 #else
 			eccCalc[eccPos++] = REG_NAND_DATA8;
 #endif
+			numToRead--;
 		}
 
 		nand_bcm_umi_bch_pause_read_ecc_calc();
@@ -204,49 +214,18 @@ static inline void nand_bcm_umi_bch_read_oobEcc(uint32_t pageSize,
 			numToRead--;
 		}
 
-		/* read ECC bytes */
-		nand_bcm_umi_bch_resume_read_ecc_calc();
-		while (numToRead) {
-#if defined(__KERNEL__) && !defined(STANDALONE)
-			*oobp = REG_NAND_DATA8;
-			eccCalc[eccPos++] = *oobp;
-			oobp++;
-#else
-			eccCalc[eccPos++] = REG_NAND_DATA8;
-#endif
-			numToRead--;
-		}
-	} else {
-		/* skip BI */
+	}
+	/* read ECC bytes */
+	nand_bcm_umi_bch_resume_read_ecc_calc();
+	while (numToRead) {
 #if defined(__KERNEL__) && !defined(STANDALONE)
-		*oobp++ = REG_NAND_DATA8;
+		*oobp = REG_NAND_DATA8;
+		eccCalc[eccPos++] = *oobp;
+		oobp++;
 #else
-		REG_NAND_DATA8;
+		eccCalc[eccPos++] = REG_NAND_DATA8;
 #endif
 		numToRead--;
-
-		while (numToRead > numEccBytes) {
-			/* skip free oob region */
-#if defined(__KERNEL__) && !defined(STANDALONE)
-			*oobp++ = REG_NAND_DATA8;
-#else
-			REG_NAND_DATA8;
-#endif
-			numToRead--;
-		}
-
-		/* read ECC bytes */
-		nand_bcm_umi_bch_resume_read_ecc_calc();
-		while (numToRead) {
-#if defined(__KERNEL__) && !defined(STANDALONE)
-			*oobp = REG_NAND_DATA8;
-			eccCalc[eccPos++] = *oobp;
-			oobp++;
-#else
-			eccCalc[eccPos++] = REG_NAND_DATA8;
-#endif
-			numToRead--;
-		}
 	}
 }
 
