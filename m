Return-Path: <linux-kernel-owner+w=401wt.eu-S1759408AbZBFUox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408AbZBFUox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 15:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZBFUon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 15:44:43 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:50757 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863AbZBFUom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 15:44:42 -0500
Date: Fri, 6 Feb 2009 21:44:41 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Jens Axboe <axboe@kernel.dk>, Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/02] mmc/sdhci: use PIO - scatterlist wrappers
Message-ID: <20090206204441.GC13217@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use sg_dwiter_*_io() in sdhci_*_block_pio(). This assumes that
buffer sizes are multiple of 4 when transferring more than one
block consecutively.

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

diff -urN b/drivers/mmc/host/sdhci.c c/drivers/mmc/host/sdhci.c
--- b/drivers/mmc/host/sdhci.c	2008-12-25 00:26:37.000000000 +0100
+++ c/drivers/mmc/host/sdhci.c	2009-02-03 00:12:23.000000000 +0100
@@ -176,44 +176,17 @@
 static void sdhci_read_block_pio(struct sdhci_host *host)
 {
 	unsigned long flags;
-	size_t blksize, len, chunk;
-	u32 uninitialized_var(scratch);
-	u8 *buf;
+	size_t blksize;
 
 	DBG("PIO reading\n");
 
-	blksize = host->data->blksz;
-	chunk = 0;
+	blksize = (host->data->blksz + 3) >> 2;
 
 	local_irq_save(flags);
 
-	while (blksize) {
-		if (!sg_miter_next(&host->sg_miter))
-			BUG();
-
-		len = min(host->sg_miter.length, blksize);
-
-		blksize -= len;
-		host->sg_miter.consumed = len;
-
-		buf = host->sg_miter.addr;
-
-		while (len) {
-			if (chunk == 0) {
-				scratch = readl(host->ioaddr + SDHCI_BUFFER);
-				chunk = 4;
-			}
-
-			*buf = scratch & 0xFF;
-
-			buf++;
-			scratch >>= 8;
-			chunk--;
-			len--;
-		}
-	}
-
-	sg_miter_stop(&host->sg_miter);
+	sg_dwiter_write_from_io(&host->sg_miter,
+		host->ioaddr + SDHCI_BUFFER, blksize);
+	sg_miter_stop_writing(&host->sg_miter);
 
 	local_irq_restore(flags);
 }
@@ -221,44 +194,16 @@
 static void sdhci_write_block_pio(struct sdhci_host *host)
 {
 	unsigned long flags;
-	size_t blksize, len, chunk;
-	u32 scratch;
-	u8 *buf;
+	size_t blksize;
 
 	DBG("PIO writing\n");
 
-	blksize = host->data->blksz;
-	chunk = 0;
-	scratch = 0;
+	blksize = (host->data->blksz + 3) >> 2;
 
 	local_irq_save(flags);
 
-	while (blksize) {
-		if (!sg_miter_next(&host->sg_miter))
-			BUG();
-
-		len = min(host->sg_miter.length, blksize);
-
-		blksize -= len;
-		host->sg_miter.consumed = len;
-
-		buf = host->sg_miter.addr;
-
-		while (len) {
-			scratch |= (u32)*buf << (chunk * 8);
-
-			buf++;
-			chunk++;
-			len--;
-
-			if ((chunk == 4) || ((len == 0) && (blksize == 0))) {
-				writel(scratch, host->ioaddr + SDHCI_BUFFER);
-				chunk = 0;
-				scratch = 0;
-			}
-		}
-	}
-
+	sg_dwiter_read_to_io(&host->sg_miter,
+		host->ioaddr + SDHCI_BUFFER, blksize);
 	sg_miter_stop(&host->sg_miter);
 
 	local_irq_restore(flags);
