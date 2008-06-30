Return-Path: <linux-kernel-owner+w=401wt.eu-S1758955AbYF3Huu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbYF3Huu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 03:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbYF3Hul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 03:50:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:13841 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbYF3Huk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 03:50:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,726,1204531200"; 
   d="scan'208";a="583361908"
From: Tomas Winkler <tomas.winkler@intel.com>
To: drzeus-list@drzeus.cx
Cc: linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3/3] mmc: fix sdio_io sparse errors
Date: Mon, 30 Jun 2008 10:50:24 +0300
Message-Id: <1214812224-32267-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1214812224-32267-2-git-send-email-tomas.winkler@intel.com>
References: <1214812224-32267-1-git-send-email-tomas.winkler@intel.com>
 <1214812224-32267-2-git-send-email-tomas.winkler@intel.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes sdio_io sparse errors.
This fix changes signature of API functions,
changing
unsigned char -> u8
unsigned short -> u16
unsigned long -> u32 - this was probably a bug in 64 bit platforms

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/mmc/core/sdio_io.c    |   43 +++++++++++++++-------------------------
 include/linux/mmc/sdio_func.h |   33 ++++++++++++++-----------------
 2 files changed, 31 insertions(+), 45 deletions(-)

diff --git a/drivers/mmc/core/sdio_io.c b/drivers/mmc/core/sdio_io.c
index 252c4fd..62ebeba 100755
--- a/drivers/mmc/core/sdio_io.c
+++ b/drivers/mmc/core/sdio_io.c
@@ -164,10 +164,8 @@ int sdio_set_block_size(struct sdio_func *func, unsigned blksz)
 		return -EINVAL;
 
 	if (blksz == 0) {
-		blksz = min(min(
-			func->max_blksize,
-			func->card->host->max_blk_size),
-			512u);
+		blksz = min(func->max_blksize, func->card->host->max_blk_size);
+		blksz = min(blksz, 512u);
 	}
 
 	ret = mmc_io_rw_direct(func->card, 1, 0,
@@ -183,7 +181,6 @@ int sdio_set_block_size(struct sdio_func *func, unsigned blksz)
 	func->cur_blksize = blksz;
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(sdio_set_block_size);
 
 /* Split an arbitrarily sized data transfer into several
@@ -200,10 +197,9 @@ static int sdio_io_rw_ext_helper(struct sdio_func *func, int write,
 		/* Blocks per command is limited by host count, host transfer
 		 * size (we only use a single sg entry) and the maximum for
 		 * IO_RW_EXTENDED of 511 blocks. */
-		max_blocks = min(min(
-			func->card->host->max_blk_count,
-			func->card->host->max_seg_size / func->cur_blksize),
-			511u);
+		max_blocks = min(func->card->host->max_blk_count,
+			func->card->host->max_seg_size / func->cur_blksize);
+		max_blocks = min(max_blocks, 511u);
 
 		while (remainder > func->cur_blksize) {
 			unsigned blocks;
@@ -257,11 +253,10 @@ static int sdio_io_rw_ext_helper(struct sdio_func *func, int write,
  *	function. If there is a problem reading the address, 0xff
  *	is returned and @err_ret will contain the error code.
  */
-unsigned char sdio_readb(struct sdio_func *func, unsigned int addr,
-	int *err_ret)
+u8 sdio_readb(struct sdio_func *func, unsigned int addr, int *err_ret)
 {
 	int ret;
-	unsigned char val;
+	u8 val;
 
 	BUG_ON(!func);
 
@@ -290,8 +285,7 @@ EXPORT_SYMBOL_GPL(sdio_readb);
  *	function. @err_ret will contain the status of the actual
  *	transfer.
  */
-void sdio_writeb(struct sdio_func *func, unsigned char b, unsigned int addr,
-	int *err_ret)
+void sdio_writeb(struct sdio_func *func, u8 b, unsigned int addr, int *err_ret)
 {
 	int ret;
 
@@ -352,7 +346,6 @@ int sdio_readsb(struct sdio_func *func, void *dst, unsigned int addr,
 {
 	return sdio_io_rw_ext_helper(func, 0, addr, 0, dst, count);
 }
-
 EXPORT_SYMBOL_GPL(sdio_readsb);
 
 /**
@@ -382,8 +375,7 @@ EXPORT_SYMBOL_GPL(sdio_writesb);
  *	function. If there is a problem reading the address, 0xffff
  *	is returned and @err_ret will contain the error code.
  */
-unsigned short sdio_readw(struct sdio_func *func, unsigned int addr,
-	int *err_ret)
+u16 sdio_readw(struct sdio_func *func, unsigned int addr, int *err_ret)
 {
 	int ret;
 
@@ -397,7 +389,7 @@ unsigned short sdio_readw(struct sdio_func *func, unsigned int addr,
 		return 0xFFFF;
 	}
 
-	return le16_to_cpu(*(u16*)func->tmpbuf);
+	return le16_to_cpup((__le16 *)func->tmpbuf);
 }
 EXPORT_SYMBOL_GPL(sdio_readw);
 
@@ -412,12 +404,11 @@ EXPORT_SYMBOL_GPL(sdio_readw);
  *	function. @err_ret will contain the status of the actual
  *	transfer.
  */
-void sdio_writew(struct sdio_func *func, unsigned short b, unsigned int addr,
-	int *err_ret)
+void sdio_writew(struct sdio_func *func, u16 b, unsigned int addr, int *err_ret)
 {
 	int ret;
 
-	*(u16*)func->tmpbuf = cpu_to_le16(b);
+	*(__le16 *)func->tmpbuf = cpu_to_le16(b);
 
 	ret = sdio_memcpy_toio(func, addr, func->tmpbuf, 2);
 	if (err_ret)
@@ -436,8 +427,7 @@ EXPORT_SYMBOL_GPL(sdio_writew);
  *	0xffffffff is returned and @err_ret will contain the error
  *	code.
  */
-unsigned long sdio_readl(struct sdio_func *func, unsigned int addr,
-	int *err_ret)
+u32 sdio_readl(struct sdio_func *func, unsigned int addr, int *err_ret)
 {
 	int ret;
 
@@ -451,7 +441,7 @@ unsigned long sdio_readl(struct sdio_func *func, unsigned int addr,
 		return 0xFFFFFFFF;
 	}
 
-	return le32_to_cpu(*(u32*)func->tmpbuf);
+	return le32_to_cpup((__le32 *)func->tmpbuf);
 }
 EXPORT_SYMBOL_GPL(sdio_readl);
 
@@ -466,12 +456,11 @@ EXPORT_SYMBOL_GPL(sdio_readl);
  *	function. @err_ret will contain the status of the actual
  *	transfer.
  */
-void sdio_writel(struct sdio_func *func, unsigned long b, unsigned int addr,
-	int *err_ret)
+void sdio_writel(struct sdio_func *func, u32 b, unsigned int addr, int *err_ret)
 {
 	int ret;
 
-	*(u32*)func->tmpbuf = cpu_to_le32(b);
+	*(__le32 *)func->tmpbuf = cpu_to_le32(b);
 
 	ret = sdio_memcpy_toio(func, addr, func->tmpbuf, 4);
 	if (err_ret)
diff --git a/include/linux/mmc/sdio_func.h b/include/linux/mmc/sdio_func.h
index 8de40f1..3511607 100755
--- a/include/linux/mmc/sdio_func.h
+++ b/include/linux/mmc/sdio_func.h
@@ -121,34 +121,31 @@ extern int sdio_set_block_size(struct sdio_func *func, unsigned blksz);
 extern int sdio_claim_irq(struct sdio_func *func, sdio_irq_handler_t *handler);
 extern int sdio_release_irq(struct sdio_func *func);
 
-extern unsigned char sdio_readb(struct sdio_func *func,
-	unsigned int addr, int *err_ret);
-extern unsigned short sdio_readw(struct sdio_func *func,
-	unsigned int addr, int *err_ret);
-extern unsigned long sdio_readl(struct sdio_func *func,
-	unsigned int addr, int *err_ret);
+extern u8 sdio_readb(struct sdio_func *func, unsigned int addr, int *err_ret);
+extern u16 sdio_readw(struct sdio_func *func, unsigned int addr, int *err_ret);
+extern u32 sdio_readl(struct sdio_func *func, unsigned int addr, int *err_ret);
 
 extern int sdio_memcpy_fromio(struct sdio_func *func, void *dst,
-	unsigned int addr, int count);
+			      unsigned int addr, int count);
 extern int sdio_readsb(struct sdio_func *func, void *dst,
-	unsigned int addr, int count);
+		       unsigned int addr, int count);
 
-extern void sdio_writeb(struct sdio_func *func, unsigned char b,
-	unsigned int addr, int *err_ret);
-extern void sdio_writew(struct sdio_func *func, unsigned short b,
-	unsigned int addr, int *err_ret);
-extern void sdio_writel(struct sdio_func *func, unsigned long b,
-	unsigned int addr, int *err_ret);
+extern void sdio_writeb(struct sdio_func *func, u8 b,
+			unsigned int addr, int *err_ret);
+extern void sdio_writew(struct sdio_func *func, u16 b,
+			unsigned int addr, int *err_ret);
+extern void sdio_writel(struct sdio_func *func, u32 b,
+			unsigned int addr, int *err_ret);
 
 extern int sdio_memcpy_toio(struct sdio_func *func, unsigned int addr,
-	void *src, int count);
+			    void *src, int count);
 extern int sdio_writesb(struct sdio_func *func, unsigned int addr,
-	void *src, int count);
+			void *src, int count);
 
 extern unsigned char sdio_f0_readb(struct sdio_func *func,
-	unsigned int addr, int *err_ret);
+				   unsigned int addr, int *err_ret);
 extern void sdio_f0_writeb(struct sdio_func *func, unsigned char b,
-	unsigned int addr, int *err_ret);
+			   unsigned int addr, int *err_ret);
 
 #endif
 
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

