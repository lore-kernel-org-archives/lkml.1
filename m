Return-Path: <linux-kernel-owner+w=401wt.eu-S1755774AbYF1MOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbYF1MOR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 08:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYF1MOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 08:14:07 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:49350 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbYF1MOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 08:14:05 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH RESEND 2/3] atmel_nand: Work around AT32AP7000 ECC errata
Date: Sat, 28 Jun 2008 14:14:07 +0200
Message-Id: <1214655248-15707-2-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1214655248-15707-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214655248-15707-1-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 28 Jun 2008 12:13:55.0778 (UTC) FILETIME=[6FC67A20:01C8D918]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ALE signal isn't correctly wired up to the ECC controller on the
AP7000, so it starts calculating ECC during the address cycles.

Work around this by resetting the ECC controller between the address and
data cycles.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Acked-by: Andrew Victor <linux@maxim.org.za>
---
Andrew, the comment you mentioned

   nand_chip->ecc.hwctl = at91_nand_hwctl;     /* unused */

doesn't seem to have made it into the MTD tree. So there was nothing
to remove.

 drivers/mtd/nand/atmel_nand.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 4814fc9..99aec46 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -33,6 +33,7 @@
 #include <linux/io.h>
 
 #include <asm/arch/board.h>
+#include <asm/arch/cpu.h>
 
 #ifdef CONFIG_MTD_NAND_ATMEL_ECC_HW
 #define hard_ecc	1
@@ -264,6 +265,19 @@ static int atmel_nand_read_page(struct mtd_info *mtd,
 	uint8_t *ecc_pos;
 	int stat;
 
+	/*
+	 * Errata: ALE is incorrectly wired up to the ECC controller
+	 * on the AP7000, so it will include the address cycles in the
+	 * ECC calculation.
+	 *
+	 * Workaround: Reset the parity registers before reading the
+	 * actual data.
+	 */
+	if (cpu_is_at32ap7000()) {
+		struct atmel_nand_host *host = chip->priv;
+		ecc_writel(host->ecc, CR, ATMEL_ECC_RST);
+	}
+
 	/* read the page */
 	chip->read_buf(mtd, p, eccsize);
 
@@ -377,9 +391,16 @@ static int atmel_nand_correct(struct mtd_info *mtd, u_char *dat,
 }
 
 /*
- * Enable HW ECC : unsused
+ * Enable HW ECC : unused on most chips
  */
-static void atmel_nand_hwctl(struct mtd_info *mtd, int mode) { ; }
+static void atmel_nand_hwctl(struct mtd_info *mtd, int mode)
+{
+	if (cpu_is_at32ap7000()) {
+		struct nand_chip *nand_chip = mtd->priv;
+		struct atmel_nand_host *host = nand_chip->priv;
+		ecc_writel(host->ecc, CR, ATMEL_ECC_RST);
+	}
+}
 
 #ifdef CONFIG_MTD_PARTITIONS
 static const char *part_probes[] = { "cmdlinepart", NULL };
-- 
1.5.5.4

