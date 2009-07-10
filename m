Return-Path: <linux-kernel-owner+w=401wt.eu-S1752372AbZGJLwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbZGJLwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 07:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbZGJLwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 07:52:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54118 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbZGJLwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 07:52:21 -0400
Message-ID: <61339.192.168.10.89.1247226724.squirrel@dbdmail.itg.ti.com>
Date: Fri, 10 Jul 2009 17:22:04 +0530 (IST)
Subject: [PATCH 1:2] [MTD][NAND]omap: Adding support for nand prefetch-read 
          and post-write, in MPU mode.
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
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds prefetch support to access nand flash in mpu mode.
This patch also adds 8-bit nand support (omap_read/write_buf8).
Prefetch can be used for both 8- and 16-bit devices.

Signed-off-by: Vimal Singh <vimalsingh@ti.com>
---

 arch/arm/mach-omap2/gpmc.c             |   63 ++++++++++++-
 arch/arm/plat-omap/include/mach/gpmc.h |    4
 drivers/mtd/nand/Kconfig               |    8 +
 drivers/mtd/nand/omap2.c               |  158 +++++++++++++++++++++++++++++++--
 4 files changed, 225 insertions(+), 8 deletions(-)

Index: mtd-2.6/arch/arm/mach-omap2/gpmc.c
===================================================================
--- mtd-2.6.orig/arch/arm/mach-omap2/gpmc.c
+++ mtd-2.6/arch/arm/mach-omap2/gpmc.c
@@ -57,6 +57,11 @@
 #define GPMC_CHUNK_SHIFT	24		/* 16 MB */
 #define GPMC_SECTION_SHIFT	28		/* 128 MB */

+#define PREFETCH_FIFOTHRESHOLD	(0x40 << 8)
+#define CS_NUM_SHIFT		24
+#define ENABLE_PREFETCH		(0x1 << 7)
+#define DMA_MPU_MODE		2
+
 static struct resource	gpmc_mem_root;
 static struct resource	gpmc_cs_mem[GPMC_CS_NUM];
 static DEFINE_SPINLOCK(gpmc_mem_lock);
@@ -386,6 +391,63 @@ void gpmc_cs_free(int cs)
 }
 EXPORT_SYMBOL(gpmc_cs_free);

+/**
+ * gpmc_prefetch_enable - configures and starts prefetch transfer
+ * @cs: nand cs (chip select) number
+ * @dma_mode: dma mode enable (1) or disable (0)
+ * @u32_count: number of bytes to be transferred
+ * @is_write: prefetch read(0) or write post(1) mode
+ */
+int gpmc_prefetch_enable(int cs, int dma_mode,
+				unsigned int u32_count, int is_write)
+{
+	uint32_t prefetch_config1;
+
+	if (!(gpmc_read_reg(GPMC_PREFETCH_CONTROL))) {
+		/* Set the amount of bytes to be prefetched */
+		gpmc_write_reg(GPMC_PREFETCH_CONFIG2, u32_count);
+
+		/* Set dma/mpu mode, the prefetch read / post write and
+		 * enable the engine. Set which cs is has requested for.
+		 */
+		prefetch_config1 = ((cs << CS_NUM_SHIFT) |
+					PREFETCH_FIFOTHRESHOLD |
+					ENABLE_PREFETCH |
+					(dma_mode << DMA_MPU_MODE) |
+					(0x1 & is_write));
+		gpmc_write_reg(GPMC_PREFETCH_CONFIG1, prefetch_config1);
+	} else {
+		return -EBUSY;
+	}
+	/*  Start the prefetch engine */
+	gpmc_write_reg(GPMC_PREFETCH_CONTROL, 0x1);
+
+	return 0;
+}
+EXPORT_SYMBOL(gpmc_prefetch_enable);
+
+/**
+ * gpmc_prefetch_reset - disables and stops the prefetch engine
+ */
+void gpmc_prefetch_reset(void)
+{
+	/* Stop the PFPW engine */
+	gpmc_write_reg(GPMC_PREFETCH_CONTROL, 0x0);
+
+	/* Reset/disable the PFPW engine */
+	gpmc_write_reg(GPMC_PREFETCH_CONFIG1, 0x0);
+}
+EXPORT_SYMBOL(gpmc_prefetch_reset);
+
+/**
+ * gpmc_prefetch_status - reads prefetch status of engine
+ */
+int  gpmc_prefetch_status(void)
+{
+	return gpmc_read_reg(GPMC_PREFETCH_STATUS);
+}
+EXPORT_SYMBOL(gpmc_prefetch_status);
+
 static void __init gpmc_mem_init(void)
 {
 	int cs;
@@ -452,6 +514,5 @@ void __init gpmc_init(void)
 	l &= 0x03 << 3;
 	l |= (0x02 << 3) | (1 << 0);
 	gpmc_write_reg(GPMC_SYSCONFIG, l);
-
 	gpmc_mem_init();
 }
Index: mtd-2.6/arch/arm/plat-omap/include/mach/gpmc.h
===================================================================
--- mtd-2.6.orig/arch/arm/plat-omap/include/mach/gpmc.h
+++ mtd-2.6/arch/arm/plat-omap/include/mach/gpmc.h
@@ -103,6 +103,10 @@ extern int gpmc_cs_request(int cs, unsig
 extern void gpmc_cs_free(int cs);
 extern int gpmc_cs_set_reserved(int cs, int reserved);
 extern int gpmc_cs_reserved(int cs);
+extern int gpmc_prefetch_enable(int cs, int dma_mode,
+					unsigned int u32_count, int is_write);
+extern void gpmc_prefetch_reset(void);
+extern int gpmc_prefetch_status(void);
 extern void __init gpmc_init(void);

 #endif
Index: mtd-2.6/drivers/mtd/nand/Kconfig
===================================================================
--- mtd-2.6.orig/drivers/mtd/nand/Kconfig
+++ mtd-2.6/drivers/mtd/nand/Kconfig
@@ -80,6 +80,14 @@ config MTD_NAND_OMAP2
 	help
           Support for NAND flash on Texas Instruments OMAP2 and OMAP3 platforms.

+config MTD_NAND_OMAP_PREFETCH
+	bool "GPMC prefetch support for NAND Flash device"
+	depends on MTD_NAND && MTD_NAND_OMAP2
+	default y
+	help
+	 The NAND device can be accessed for Read/Write using GPMC PREFETCH engine
+	 to improve the performance.
+
 config MTD_NAND_TS7250
 	tristate "NAND Flash device on TS-7250 board"
 	depends on MACH_TS72XX
Index: mtd-2.6/drivers/mtd/nand/omap2.c
===================================================================
--- mtd-2.6.orig/drivers/mtd/nand/omap2.c
+++ mtd-2.6/drivers/mtd/nand/omap2.c
@@ -112,6 +112,16 @@
 static const char *part_probes[] = { "cmdlinepart", NULL };
 #endif

+#ifdef CONFIG_MTD_NAND_OMAP_PREFETCH
+static int use_prefetch = 1;
+
+/* "modprobe ... use_prefetch=0" etc */
+module_param(use_prefetch, bool, 0);
+MODULE_PARM_DESC(use_prefetch, "enable/disable use of PREFETCH");
+#else
+const int use_prefetch;
+#endif
+
 struct omap_nand_info {
 	struct nand_hw_control		controller;
 	struct omap_nand_platform_data	*pdata;
@@ -124,6 +134,7 @@ struct omap_nand_info {
 	unsigned long			phys_base;
 	void __iomem			*gpmc_cs_baseaddr;
 	void __iomem			*gpmc_baseaddr;
+	void __iomem			*nand_pref_fifo_add;
 };

 /**
@@ -189,6 +200,40 @@ static void omap_hwcontrol(struct mtd_in
 }

 /**
+ * omap_read_buf8 - read data from NAND controller into buffer
+ * @mtd: MTD device structure
+ * @buf: buffer to store date
+ * @len: number of bytes to read
+ */
+static void omap_read_buf8(struct mtd_info *mtd, u_char *buf, int len)
+{
+	struct nand_chip *nand = mtd->priv;
+	u_char *p = (u_char *)buf;
+
+	while (len--)
+		*p++ = __raw_readb(nand->IO_ADDR_R);
+}
+
+/**
+ * omap_write_buf8 - write buffer to NAND controller
+ * @mtd: MTD device structure
+ * @buf: data buffer
+ * @len: number of bytes to write
+ */
+static void omap_write_buf8(struct mtd_info *mtd, const u_char *buf, int len)
+{
+	struct omap_nand_info *info = container_of(mtd,
+						struct omap_nand_info, mtd);
+	u_char *p = (u_char *)buf;
+
+	while (len--) {
+		writeb(*p++, info->nand.IO_ADDR_W);
+		while (GPMC_BUF_EMPTY == (readl(info->gpmc_baseaddr +
+						GPMC_STATUS) & GPMC_BUF_FULL));
+	}
+}
+
+/**
  * omap_read_buf16 - read data from NAND controller into buffer
  * @mtd: MTD device structure
  * @buf: buffer to store date
@@ -224,6 +269,93 @@ static void omap_write_buf16(struct mtd_
 			;
 	}
 }
+
+/**
+ * omap_read_buf_pref - read data from NAND controller into buffer
+ * @mtd: MTD device structure
+ * @buf: buffer to store date
+ * @len: number of bytes to read
+ */
+static void omap_read_buf_pref(struct mtd_info *mtd, u_char *buf, int len)
+{
+	struct omap_nand_info *info = container_of(mtd,
+						struct omap_nand_info, mtd);
+	uint32_t pfpw_status = 0, r_count = 0;
+	int ret = 0;
+	u32 *p = (u32 *)buf;
+
+	/* take care of subpage reads */
+	for (; len % 4 != 0; ) {
+		*buf++ = __raw_readb(info->nand.IO_ADDR_R);
+		len--;
+	}
+	p = (u32 *) buf;
+
+	/* configure and start prefetch transfer */
+	ret = gpmc_prefetch_enable(info->gpmc_cs, 0x0, len, 0x0);
+	if (ret) {
+		/* PFPW engine is busy, use cpu copy methode */
+		if (info->nand.options & NAND_BUSWIDTH_16)
+			omap_read_buf16(mtd, buf, len);
+		else
+			omap_read_buf8(mtd, buf, len);
+	} else {
+		do {
+			pfpw_status = gpmc_prefetch_status();
+			r_count = ((pfpw_status >> 24) & 0x7F) >> 2;
+			__raw_readsl(info->nand_pref_fifo_add, p, r_count);
+			p += r_count;
+			len -= r_count << 2;
+		} while (len);
+	}
+	/* disable and stop the PFPW engine */
+	gpmc_prefetch_reset();
+}
+
+/**
+ * omap_write_buf_pref - write buffer to NAND controller
+ * @mtd: MTD device structure
+ * @buf: data buffer
+ * @len: number of bytes to write
+ */
+static void omap_write_buf_pref(struct mtd_info *mtd,
+					const u_char *buf, int len)
+{
+	struct omap_nand_info *info = container_of(mtd,
+						struct omap_nand_info, mtd);
+	uint32_t pfpw_status = 0, w_count = 0;
+	int i = 0, ret = 0;
+	u16 *p = (u16 *) buf;
+
+	/* take care of subpage writes */
+	if (len % 2 != 0) {
+		writeb(*buf, info->nand.IO_ADDR_R);
+		p = (u16 *)(buf + 1);
+		len--;
+	}
+
+	/*  configure and start prefetch transfer */
+	ret = gpmc_prefetch_enable(info->gpmc_cs, 0x0, len, 0x1);
+	if (ret) {
+		/* PFPW engine is busy, use cpu copy methode */
+		if (info->nand.options & NAND_BUSWIDTH_16)
+			omap_write_buf16(mtd, buf, len);
+		else
+			omap_write_buf8(mtd, buf, len);
+	} else {
+		pfpw_status = gpmc_prefetch_status();
+		while (pfpw_status & 0x3FFF) {
+			w_count = ((pfpw_status >> 24) & 0x7F) >> 1;
+			for (i = 0; (i < w_count) && len; i++, len -= 2)
+				__raw_writew(*p++, info->nand_pref_fifo_add);
+			pfpw_status = gpmc_prefetch_status();
+		}
+	}
+
+	/* disable and stop the PFPW engine */
+	gpmc_prefetch_reset();
+}
+
 /**
  * omap_verify_buf - Verify chip data against buffer
  * @mtd: MTD device structure
@@ -658,17 +790,12 @@ static int __devinit omap_nand_probe(str
 		err = -ENOMEM;
 		goto out_release_mem_region;
 	}
+
 	info->nand.controller = &info->controller;

 	info->nand.IO_ADDR_W = info->nand.IO_ADDR_R;
 	info->nand.cmd_ctrl  = omap_hwcontrol;

-	/* REVISIT:  only supports 16-bit NAND flash */
-
-	info->nand.read_buf   = omap_read_buf16;
-	info->nand.write_buf  = omap_write_buf16;
-	info->nand.verify_buf = omap_verify_buf;
-
 	/*
 	 * If RDY/BSY line is connected to OMAP then use the omap ready
 	 * funcrtion and the generic nand_wait function which reads the status
@@ -689,6 +816,23 @@ static int __devinit omap_nand_probe(str
 								== 0x1000)
 		info->nand.options  |= NAND_BUSWIDTH_16;

+	if (use_prefetch) {
+		/* copy the virtual address of nand base for fifo access */
+		info->nand_pref_fifo_add = info->nand.IO_ADDR_R;
+
+		info->nand.read_buf   = omap_read_buf_pref;
+		info->nand.write_buf  = omap_write_buf_pref;
+	} else {
+		if (info->nand.options & NAND_BUSWIDTH_16) {
+			info->nand.read_buf   = omap_read_buf16;
+			info->nand.write_buf  = omap_write_buf16;
+		} else {
+			info->nand.read_buf   = omap_read_buf8;
+			info->nand.write_buf  = omap_write_buf8;
+		}
+	}
+	info->nand.verify_buf = omap_verify_buf;
+
 #ifdef CONFIG_MTD_NAND_OMAP_HWECC
 	info->nand.ecc.bytes		= 3;
 	info->nand.ecc.size		= 512;
@@ -746,7 +890,7 @@ static int omap_nand_remove(struct platf
 	platform_set_drvdata(pdev, NULL);
 	/* Release NAND device, its internal structures and partitions */
 	nand_release(&info->mtd);
-	iounmap(info->nand.IO_ADDR_R);
+	iounmap(info->nand_pref_fifo_add);
 	kfree(&info->mtd);
 	return 0;
 }


