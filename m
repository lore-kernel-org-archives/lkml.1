Return-Path: <linux-kernel-owner+w=401wt.eu-S1753017AbZGJNip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbZGJNip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 09:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbZGJNig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 09:38:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40694 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbZGJNif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 09:38:35 -0400
Message-ID: <54001.192.168.10.89.1247233098.squirrel@dbdmail.itg.ti.com>
In-Reply-To: <63362.192.168.10.89.1247226917.squirrel@dbdmail.itg.ti.com>
References: <63362.192.168.10.89.1247226917.squirrel@dbdmail.itg.ti.com>
Date: Fri, 10 Jul 2009 19:08:18 +0530 (IST)
Subject: [PATCH-v2 2:2][MTD][NAND]omap : Adding DMA mode support in nand    
       prefetch/post-write
From: "vimal singh" <vimalsingh@ti.com>
To: linux-mtd@lists.infradead.org
Cc: "Tony Lindgren" <tony@atomide.com>, dwmw2@infradead.org,
       dedekind@infradead.org, david-b@pacbell.net,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch also got updated due to changes in 1st patch.
Also made 'len/64' to 'len >> 6', as per Artem's comment.

-vimal

This patch adds DMA mode support for nand prefetch/post-write engine.

Signed-off-by: Vimal Singh <vimalsingh@ti.com>
---

 drivers/mtd/nand/Kconfig |    9 ++
 drivers/mtd/nand/omap2.c |  186 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 193 insertions(+), 2 deletions(-)

Index: mtd-2.6/drivers/mtd/nand/Kconfig
===================================================================
--- mtd-2.6.orig/drivers/mtd/nand/Kconfig
+++ mtd-2.6/drivers/mtd/nand/Kconfig
@@ -88,6 +88,15 @@ config MTD_NAND_OMAP_PREFETCH
 	 The NAND device can be accessed for Read/Write using GPMC PREFETCH engine
 	 to improve the performance.

+config MTD_NAND_OMAP_PREFETCH_DMA
+	depends on MTD_NAND_OMAP_PREFETCH
+	bool "DMA mode"
+	default n
+	help
+	 The GPMC PREFETCH engine can be configured eigther in MPU interrupt mode
+	 or in DMA interrupt mode.
+	 Say y for DMA mode or MPU mode will be used
+
 config MTD_NAND_TS7250
 	tristate "NAND Flash device on TS-7250 board"
 	depends on MACH_TS72XX
Index: mtd-2.6/drivers/mtd/nand/omap2.c
===================================================================
--- mtd-2.6.orig/drivers/mtd/nand/omap2.c
+++ mtd-2.6/drivers/mtd/nand/omap2.c
@@ -18,8 +18,7 @@
 #include <linux/mtd/partitions.h>
 #include <linux/io.h>

-#include <asm/dma.h>
-
+#include <mach/dma.h>
 #include <mach/gpmc.h>
 #include <mach/nand.h>

@@ -118,8 +117,19 @@ static int use_prefetch = 1;
 /* "modprobe ... use_prefetch=0" etc */
 module_param(use_prefetch, bool, 0);
 MODULE_PARM_DESC(use_prefetch, "enable/disable use of PREFETCH");
+
+#ifdef CONFIG_MTD_NAND_OMAP_PREFETCH_DMA
+static int use_dma = 1;
+
+/* "modprobe ... use_dma=0" etc */
+module_param(use_dma, bool, 0);
+MODULE_PARM_DESC(use_dma, "enable/disable use of DMA");
+#else
+const int use_dma;
+#endif
 #else
 const int use_prefetch;
+const int use_dma;
 #endif

 struct omap_nand_info {
@@ -135,6 +145,8 @@ struct omap_nand_info {
 	void __iomem			*gpmc_cs_baseaddr;
 	void __iomem			*gpmc_baseaddr;
 	void __iomem			*nand_pref_fifo_add;
+	struct completion		comp;
+	int				dma_ch;
 };

 /**
@@ -357,6 +369,147 @@ static void omap_write_buf_pref(struct m
 	}
 }

+#ifdef CONFIG_MTD_NAND_OMAP_PREFETCH_DMA
+/*
+ * omap_nand_dma_cb: callback on the completion of dma transfer
+ * @lch: logical channel
+ * @ch_satuts: channel status
+ * @data: pointer to completion data structure
+ */
+static void omap_nand_dma_cb(int lch, u16 ch_status, void *data)
+{
+	complete((struct completion *) data);
+}
+
+/*
+ * omap_nand_dma_transfer: configure and start dma transfer
+ * @mtd: MTD device structure
+ * @addr: virtual address in RAM of source/destination
+ * @len: number of data bytes to be transferred
+ * @is_write: flag for read/write operation
+ */
+static inline int omap_nand_dma_transfer(struct mtd_info *mtd, void *addr,
+					unsigned int len, int is_write)
+{
+	struct omap_nand_info *info = container_of(mtd,
+					struct omap_nand_info, mtd);
+	uint32_t prefetch_status = 0;
+	enum dma_data_direction dir = is_write ? DMA_TO_DEVICE :
+							DMA_FROM_DEVICE;
+	dma_addr_t dma_addr;
+	int ret;
+
+	/* The fifo depth is 64 bytes. We have a sync at each frame and frame
+	 * length is 64 bytes.
+	 */
+	int buf_len = len >> 6;
+
+	if (addr >= high_memory) {
+		struct page *p1;
+
+		if (((size_t)addr & PAGE_MASK) !=
+			((size_t)(addr + len - 1) & PAGE_MASK))
+			goto out_copy;
+		p1 = vmalloc_to_page(addr);
+		if (!p1)
+			goto out_copy;
+		addr = page_address(p1) + ((size_t)addr & ~PAGE_MASK);
+	}
+
+	dma_addr = dma_map_single(&info->pdev->dev, addr, len, dir);
+	if (dma_mapping_error(&info->pdev->dev, dma_addr)) {
+		dev_err(&info->pdev->dev,
+			"Couldn't DMA map a %d byte buffer\n", len);
+		goto out_copy;
+	}
+
+	if (is_write) {
+	    omap_set_dma_dest_params(info->dma_ch, 0, OMAP_DMA_AMODE_CONSTANT,
+						info->phys_base, 0, 0);
+	    omap_set_dma_src_params(info->dma_ch, 0, OMAP_DMA_AMODE_POST_INC,
+							dma_addr, 0, 0);
+	    omap_set_dma_transfer_params(info->dma_ch, OMAP_DMA_DATA_TYPE_S32,
+					0x10, buf_len, OMAP_DMA_SYNC_FRAME,
+					OMAP24XX_DMA_GPMC, OMAP_DMA_DST_SYNC);
+	} else {
+	    omap_set_dma_src_params(info->dma_ch, 0, OMAP_DMA_AMODE_CONSTANT,
+						info->phys_base, 0, 0);
+	    omap_set_dma_dest_params(info->dma_ch, 0, OMAP_DMA_AMODE_POST_INC,
+							dma_addr, 0, 0);
+	    omap_set_dma_transfer_params(info->dma_ch, OMAP_DMA_DATA_TYPE_S32,
+					0x10, buf_len, OMAP_DMA_SYNC_FRAME,
+					OMAP24XX_DMA_GPMC, OMAP_DMA_SRC_SYNC);
+	}
+	/*  configure and start prefetch transfer */
+	ret = gpmc_prefetch_enable(info->gpmc_cs, 0x1, len, is_write);
+	if (ret)
+		/* PFPW engine is busy, use cpu copy methode */
+		goto out_copy;
+
+	init_completion(&info->comp);
+
+	omap_start_dma(info->dma_ch);
+
+	/* setup and start DMA using dma_addr */
+	wait_for_completion(&info->comp);
+
+	while (0x3fff & (prefetch_status = gpmc_prefetch_status()))
+		;
+	/* disable and stop the PFPW engine */
+	gpmc_prefetch_reset();
+
+	dma_unmap_single(&info->pdev->dev, dma_addr, len, dir);
+	return 0;
+
+out_copy:
+	if (info->nand.options & NAND_BUSWIDTH_16)
+		is_write == 0 ? omap_read_buf16(mtd, (u_char *) addr, len)
+			: omap_write_buf16(mtd, (u_char *) addr, len);
+	else
+		is_write == 0 ? omap_read_buf8(mtd, (u_char *) addr, len)
+			: omap_write_buf8(mtd, (u_char *) addr, len);
+	return 0;
+}
+#else
+static void omap_nand_dma_cb(int lch, u16 ch_status, void *data) {}
+static inline int omap_nand_dma_transfer(struct mtd_info *mtd, void *addr,
+					unsigned int len, int is_write)
+{
+	return 0;
+}
+#endif
+
+/**
+ * omap_read_buf_dma_pref - read data from NAND controller into buffer
+ * @mtd: MTD device structure
+ * @buf: buffer to store date
+ * @len: number of bytes to read
+ */
+static void omap_read_buf_dma_pref(struct mtd_info *mtd, u_char *buf, int len)
+{
+	if (len <= mtd->oobsize)
+		omap_read_buf_pref(mtd, buf, len);
+	else
+		/* start transfer in DMA mode */
+		omap_nand_dma_transfer(mtd, buf, len, 0x0);
+}
+
+/**
+ * omap_write_buf_dma_pref - write buffer to NAND controller
+ * @mtd: MTD device structure
+ * @buf: data buffer
+ * @len: number of bytes to write
+ */
+static void omap_write_buf_dma_pref(struct mtd_info *mtd,
+					const u_char *buf, int len)
+{
+	if (len <= mtd->oobsize)
+		omap_write_buf_pref(mtd, buf, len);
+	else
+		/* start transfer in DMA mode */
+		omap_nand_dma_transfer(mtd, buf, len, 0x1);
+}
+
 /**
  * omap_verify_buf - Verify chip data against buffer
  * @mtd: MTD device structure
@@ -823,6 +976,23 @@ static int __devinit omap_nand_probe(str

 		info->nand.read_buf   = omap_read_buf_pref;
 		info->nand.write_buf  = omap_write_buf_pref;
+		if (use_dma) {
+			err = omap_request_dma(OMAP24XX_DMA_GPMC, "NAND",
+				omap_nand_dma_cb, &info->comp, &info->dma_ch);
+			if (err < 0) {
+				info->dma_ch = -1;
+				printk(KERN_WARNING "DMA request failed."
+					" Non-dma data transfer mode\n");
+			} else {
+				omap_set_dma_dest_burst_mode(info->dma_ch,
+						OMAP_DMA_DATA_BURST_16);
+				omap_set_dma_src_burst_mode(info->dma_ch,
+						OMAP_DMA_DATA_BURST_16);
+
+				info->nand.read_buf   = omap_read_buf_dma_pref;
+				info->nand.write_buf  = omap_write_buf_dma_pref;
+			}
+		}
 	} else {
 		if (info->nand.options & NAND_BUSWIDTH_16) {
 			info->nand.read_buf   = omap_read_buf16;
@@ -889,6 +1059,9 @@ static int omap_nand_remove(struct platf
 	struct omap_nand_info *info = mtd->priv;

 	platform_set_drvdata(pdev, NULL);
+	if (use_dma)
+		omap_free_dma(info->dma_ch);
+
 	/* Release NAND device, its internal structures and partitions */
 	nand_release(&info->mtd);
 	iounmap(info->nand_pref_fifo_add);
@@ -908,6 +1081,15 @@ static struct platform_driver omap_nand_
 static int __init omap_nand_init(void)
 {
 	printk(KERN_INFO "%s driver initializing\n", DRIVER_NAME);
+
+	/* This check is required if driver is being
+	 * loaded run time as a module
+	 */
+	if ((1 == use_dma) && (0 == use_prefetch)) {
+		printk(KERN_INFO"Wrong parameters: 'use_dma' can not be 1 "
+				"without use_prefetch'. Prefetch will not be"
+				" used in either mode (mpu or dma)\n");
+	}
 	return platform_driver_register(&omap_nand_driver);
 }



