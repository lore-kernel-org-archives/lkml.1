Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbXLSLST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbXLSLST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 06:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbXLSLSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 06:18:07 -0500
Received: from mail.hevs.ch ([153.109.23.15]:54794 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbXLSLSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 06:18:05 -0500
X-Greylist: delayed 1352 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2007 06:18:05 EST
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: [RFC, PATCH] sdio: move temporary buffer
Date: Wed, 19 Dec 2007 11:55:25 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712191155.26594.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the temporary buffer used by some sdio functions from sdio_func struct to
the mmc_host struct and make it dma-safe.

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
---

There is no need to have this temporary buffer in every sdio_func, since all
access to it are serialized by sdio_[claim/release]_host.

I also think it should be ____cacheline_aligned to make sure we have no data
loss when doing dma syncing operations.

Comments welcome!

Regards

Marc

sdio-dma-tmpbuf-patch (against 2.6.24-rc5)

 drivers/mmc/core/sdio_io.c    |   20 ++++++++++++--------
 include/linux/mmc/host.h      |    3 +++
 include/linux/mmc/sdio_func.h |    2 --
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/core/sdio_io.c b/drivers/mmc/core/sdio_io.c
index 625b92c..e48663e 100644
--- a/drivers/mmc/core/sdio_io.c
+++ b/drivers/mmc/core/sdio_io.c
@@ -389,18 +389,19 @@ unsigned short sdio_readw(struct sdio_func *func, unsigned int addr,
 	int *err_ret)
 {
 	int ret;
+	u8 *tmpbuf = func->card->host->tmpbuf;
 
 	if (err_ret)
 		*err_ret = 0;
 
-	ret = sdio_memcpy_fromio(func, func->tmpbuf, addr, 2);
+	ret = sdio_memcpy_fromio(func, tmpbuf, addr, 2);
 	if (ret) {
 		if (err_ret)
 			*err_ret = ret;
 		return 0xFFFF;
 	}
 
-	return le16_to_cpu(*(u16*)func->tmpbuf);
+	return le16_to_cpu(*(u16*)tmpbuf);
 }
 EXPORT_SYMBOL_GPL(sdio_readw);
 
@@ -419,10 +420,11 @@ void sdio_writew(struct sdio_func *func, unsigned short b, unsigned int addr,
 	int *err_ret)
 {
 	int ret;
+	u8 *tmpbuf = func->card->host->tmpbuf;
 
-	*(u16*)func->tmpbuf = cpu_to_le16(b);
+	*(u16*)tmpbuf = cpu_to_le16(b);
 
-	ret = sdio_memcpy_toio(func, addr, func->tmpbuf, 2);
+	ret = sdio_memcpy_toio(func, addr, tmpbuf, 2);
 	if (err_ret)
 		*err_ret = ret;
 }
@@ -443,18 +445,19 @@ unsigned long sdio_readl(struct sdio_func *func, unsigned int addr,
 	int *err_ret)
 {
 	int ret;
+	u8 *tmpbuf = func->card->host->tmpbuf;
 
 	if (err_ret)
 		*err_ret = 0;
 
-	ret = sdio_memcpy_fromio(func, func->tmpbuf, addr, 4);
+	ret = sdio_memcpy_fromio(func, tmpbuf, addr, 4);
 	if (ret) {
 		if (err_ret)
 			*err_ret = ret;
 		return 0xFFFFFFFF;
 	}
 
-	return le32_to_cpu(*(u32*)func->tmpbuf);
+	return le32_to_cpu(*(u32*)tmpbuf);
 }
 EXPORT_SYMBOL_GPL(sdio_readl);
 
@@ -473,10 +476,11 @@ void sdio_writel(struct sdio_func *func, unsigned long b, unsigned int addr,
 	int *err_ret)
 {
 	int ret;
+	u8 *tmpbuf = func->card->host->tmpbuf;
 
-	*(u32*)func->tmpbuf = cpu_to_le32(b);
+	*(u32*)tmpbuf = cpu_to_le32(b);
 
-	ret = sdio_memcpy_toio(func, addr, func->tmpbuf, 4);
+	ret = sdio_memcpy_toio(func, addr, tmpbuf, 4);
 	if (err_ret)
 		*err_ret = ret;
 }
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 125eee1..8edb796 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -139,6 +139,9 @@ struct mmc_host {
 	struct led_trigger	*led;		/* activity led */
 #endif
 
+	/* DMA:able scratch buffer */
+	u8			tmpbuf[4] ____cacheline_aligned;
+
 	unsigned long		private[0] ____cacheline_aligned;
 };
 
diff --git a/include/linux/mmc/sdio_func.h b/include/linux/mmc/sdio_func.h
index b050f4d..4a797a7 100644
--- a/include/linux/mmc/sdio_func.h
+++ b/include/linux/mmc/sdio_func.h
@@ -49,8 +49,6 @@ struct sdio_func {
 	unsigned int		state;		/* function state */
 #define SDIO_STATE_PRESENT	(1<<0)		/* present in sysfs */
 
-	u8			tmpbuf[4];	/* DMA:able scratch buffer */
-
 	unsigned		num_info;	/* number of info strings */
 	const char		**info;		/* info strings */
 
