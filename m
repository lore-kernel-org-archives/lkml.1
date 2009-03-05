Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbZCEUbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbZCEUbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 15:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636AbZCEU2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 15:28:50 -0500
Received: from [213.79.90.228] ([213.79.90.228]:46851 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755121AbZCEU2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 15:28:50 -0500
Date: Thu, 5 Mar 2009 23:28:47 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 10/11] sdhci: Add quirk for forcing maximum block size to
	2048 bytes
Message-ID: <20090305202847.GJ28709@oksana.dev.rtsoft.ru>
References: <20090305202737.GA24166@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090305202737.GA24166@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FSL eSDHC controllers can support maximum block size up to 4096 bytes,
the MBL (Maximum Block Length) field in the capabilities register
extended by one bit, and is set to 0x3.

But the SDHCI core doesn't support blocks of 4096 bytes, and thus
forces blksz to the lowest value -- 512 bytes. With this patch we can
pin up the blksz to the maximum supported block size, i.e. 2048 bytes.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/sdhci.c |   20 +++++++++++++-------
 drivers/mmc/host/sdhci.h |    2 ++
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index f012e7e..284bc5d 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1832,13 +1832,19 @@ int sdhci_add_host(struct sdhci_host *host)
 	 * Maximum block size. This varies from controller to controller and
 	 * is specified in the capabilities register.
 	 */
-	mmc->max_blk_size = (caps & SDHCI_MAX_BLOCK_MASK) >> SDHCI_MAX_BLOCK_SHIFT;
-	if (mmc->max_blk_size >= 3) {
-		printk(KERN_WARNING "%s: Invalid maximum block size, "
-			"assuming 512 bytes\n", mmc_hostname(mmc));
-		mmc->max_blk_size = 512;
-	} else
-		mmc->max_blk_size = 512 << mmc->max_blk_size;
+	if (host->quirks & SDHCI_QUIRK_FORCE_BLK_SZ_2048) {
+		mmc->max_blk_size = 2;
+	} else {
+		mmc->max_blk_size = (caps & SDHCI_MAX_BLOCK_MASK) >>
+				SDHCI_MAX_BLOCK_SHIFT;
+		if (mmc->max_blk_size >= 3) {
+			printk(KERN_WARNING "%s: Invalid maximum block size, "
+				"assuming 512 bytes\n", mmc_hostname(mmc));
+			mmc->max_blk_size = 0;
+		}
+	}
+
+	mmc->max_blk_size = 512 << mmc->max_blk_size;
 
 	/*
 	 * Maximum block count.
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 35c78bc..1697e01 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -222,6 +222,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_PIO_NEEDS_DELAY			(1<<18)
 /* Controller losing signal/interrupt enable states after reset */
 #define SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET		(1<<19)
+/* Controller has to be forced to use block size of 2048 bytes */
+#define SDHCI_QUIRK_FORCE_BLK_SZ_2048			(1<<20)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
-- 
1.5.6.5

