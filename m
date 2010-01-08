Return-Path: <linux-kernel-owner+w=401wt.eu-S1753817Ab0AHPLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab0AHPLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 10:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668Ab0AHPLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 10:11:17 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:59571 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab0AHPLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 10:11:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=G3RL3mozXwSePqC8zSY8jrtX6TOeo4rLpoWpCCFKgMrWFZu5+tzqGpv3VujwYDRIpm
         X8LaV+H6UV5Ea0p7G7fqEw/C770kU+Kmo2uecz4rLQgKQrCBZYWwPmgGwbQGBDpNGj3h
         3ZFKp4ddr32XSUH4lyz+VOLBvuUC23/XoWx34=
Subject: [PATCH 8/9] mtd: Add nand driver for ricoh xD/SmartMedia reader
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>, Alex Dubov <oakad@yahoo.com>,
       joern <joern@logfs.org>
In-Reply-To: <1262963092.12577.14.camel@maxim-laptop>
References: <1262963092.12577.14.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jan 2010 17:11:09 +0200
Message-ID: <1262963469.12577.22.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8ba5765479d06c2b2cd5d54ad62bd4c4406dac85 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Fri, 8 Jan 2010 16:26:41 +0200
Subject: [PATCH 8/9] mtd: Add nand driver for ricoh xD/SmartMedia reader

This adds a driver for Ricoh xD card reader that has
0x0852 PCI ID

Since the reader is a part of larger mulifunction chip, it
is hard to determine the correct model name. Might be R5C852.

Driver is complete, but bewere of the fact that some
(probably only type M) xD cards are 'fake' which means that
they have an on board CPU and expose emulated nand command set
Thus they demand to have proper values written in the oob area,
and therefore only useful with SmartMedia FTL.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 MAINTAINERS               |    6 +
 drivers/mtd/nand/Kconfig  |   11 +
 drivers/mtd/nand/Makefile |    1 +
 drivers/mtd/nand/r822.c   | 1051 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/nand/r822.h   |  155 +++++++
 5 files changed, 1224 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mtd/nand/r822.c
 create mode 100644 drivers/mtd/nand/r822.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 8f0109b..81c451b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4585,6 +4585,12 @@ S:	Maintained
 F:	Documentation/rfkill.txt
 F:	net/rfkill/
 
+RICOH SMARTMEDIA/XD DRIVER
+M:	Maxim Levitsky <maximlevitsky@gmail.com>
+S:	Maintained
+F:	drivers/mtd/nand/r822.c
+F:	drivers/mtd/nand/r822.h
+
 RISCOM8 DRIVER
 S:	Orphan
 F:	Documentation/serial/riscom8.txt
diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 677cd53..59bfabb 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -104,6 +104,17 @@ config MTD_NAND_TS7250
 config MTD_NAND_IDS
 	tristate
 
+config MTD_NAND_RICOH
+	tristate "Ricoh xD card reader"
+	default n
+	select MTD_SM_COMMON
+	help
+	  Enable support for Ricoh xD card reader
+	  You also need to enable ether
+	  NAND SSFDC (SmartMedia) read only translation layer' or new
+	  expermental, readwrite
+	  'SmartMedia/xD new translation layer'
+
 config MTD_NAND_AU1550
 	tristate "Au1550/1200 NAND support"
 	depends on SOC_AU1200 || SOC_AU1550
diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
index 1407bd1..986ab9c 100644
--- a/drivers/mtd/nand/Makefile
+++ b/drivers/mtd/nand/Makefile
@@ -42,5 +42,6 @@ obj-$(CONFIG_MTD_NAND_TXX9NDFMC)	+= txx9ndfmc.o
 obj-$(CONFIG_MTD_NAND_W90P910)		+= w90p910_nand.o
 obj-$(CONFIG_MTD_NAND_NOMADIK)		+= nomadik_nand.o
 obj-$(CONFIG_MTD_NAND_BCM_UMI)		+= bcm_umi_nand.o nand_bcm_umi.o
+obj-$(CONFIG_MTD_NAND_RICOH)		+= r822.o
 
 nand-objs := nand_base.o nand_bbt.o
diff --git a/drivers/mtd/nand/r822.c b/drivers/mtd/nand/r822.c
new file mode 100644
index 0000000..9dbb578
--- /dev/null
+++ b/drivers/mtd/nand/r822.c
@@ -0,0 +1,1051 @@
+/*
+ * Copyright (C) 2009 - Maxim Levitsky
+ * driver for Ricoh xD readers
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/jiffies.h>
+#include <linux/workqueue.h>
+#include <linux/interrupt.h>
+#include <linux/pci_ids.h>
+#include <asm/byteorder.h>
+#include <linux/sched.h>
+#include "../sm_common.h"
+#include "r822.h"
+
+/* read register */
+static inline u8 r822_read_reg(struct r822_device *dev, int address)
+{
+	u8 reg = readb(dev->mmio + address);
+	return reg;
+}
+
+/* write register */
+static inline void r822_write_reg(struct r822_device *dev,
+						int address, u8 value)
+{
+	writeb(value, dev->mmio + address);
+}
+
+
+/* read dword sized register */
+static inline u32 r822_read_reg_dword(struct r822_device *dev, int address)
+{
+	u32 reg = le32_to_cpu(readl(dev->mmio + address));
+	return reg;
+}
+
+/* write dword sized register */
+static inline void r822_write_reg_dword(struct r822_device *dev,
+							int address, u32 value)
+{
+	writel(cpu_to_le32(value), dev->mmio + address);
+}
+
+/* returns pointer to our private structure */
+static inline struct r822_device *r822_get_dev(struct mtd_info *mtd)
+{
+	struct nand_chip *chip = (struct nand_chip *)mtd->priv;
+	return (struct r822_device *)chip->priv;
+}
+
+
+/* check if controller supports dma */
+static void r822_dma_test(struct r822_device *dev)
+{
+	dev->dma_usable = (r822_read_reg(dev, R822_DMA_CAP) &
+		(R822_DMA1 | R822_DMA2)) == (R822_DMA1 | R822_DMA2);
+
+	if (!dev->dma_usable)
+		dbg("Non dma capable device detected, dma disabled");
+}
+
+/*
+ * Enable dma. Enables ether first or second stage of the DMA,
+ * Expects dev->dma_dir and dev->dma_state be set
+ */
+static void r822_dma_enable(struct r822_device *dev)
+{
+	u8 dma_reg = dev->dma_dir ? R822_DMA_READ : 0;
+
+	if (dev->dma_state == DMA_INTERNAL)
+		dma_reg |= R822_DMA_INTERNAL;
+	else {
+		dma_reg |= R822_DMA_MEMORY;
+		r822_write_reg_dword(dev, R822_DMA_ADDR,
+			cpu_to_le32(dev->phys_dma_addr));
+	}
+
+	r822_write_reg(dev, R822_DMA_IRQ_STA,
+			r822_read_reg(dev, R822_DMA_IRQ_STA));
+
+	r822_write_reg(dev, R822_DMA_SETTINGS, dma_reg);
+	r822_write_reg(dev, R822_DMA_IRQ_ENABLE,
+		R822_DMA_IRQ_INTERNAL |
+		R822_DMA_IRQ_ERROR |
+		R822_DMA_IRQ_MEMORY);
+}
+
+/*
+ * Disable dma, called from the interrupt handler, which specifies
+ * success of the operation via 'error' argument
+ */
+static void r822_dma_done(struct r822_device *dev, int error)
+{
+	WARN_ON(dev->dma_stage == 0);
+
+	if (error)
+		dbg("dma: complete with error");
+
+	r822_write_reg(dev, R822_DMA_IRQ_STA,
+			r822_read_reg(dev, R822_DMA_IRQ_STA));
+
+	r822_write_reg(dev, R822_DMA_SETTINGS, 0);
+	r822_write_reg(dev, R822_DMA_IRQ_ENABLE, 0);
+
+	dev->dma_error = error;
+	dev->dma_stage = 0;
+
+	if (dev->phys_dma_addr && dev->phys_dma_addr != dev->phys_bounce_buffer)
+		pci_unmap_single(dev->pci_dev, dev->phys_dma_addr, R822_DMA_LEN,
+			dev->dma_dir ? PCI_DMA_FROMDEVICE : PCI_DMA_TODEVICE);
+	complete(&dev->dma_done);
+}
+
+/*
+ * Wait, till dma is done, which includes both phases of it
+ */
+static int r822_dma_wait(struct r822_device *dev)
+{
+	long timeout = wait_for_completion_interruptible_timeout(&dev->dma_done,
+				msecs_to_jiffies(1000));
+	if (timeout < 0)
+		return -EAGAIN;
+	if (!timeout)
+		return -ETIMEDOUT;
+	return 0;
+}
+
+/*
+ * Read/Write one page using dma. Only pages can be read (512 bytes), oob
+ * can't be read here
+*/
+static void r822_do_dma(struct r822_device *dev, uint8_t *buf, int do_read)
+{
+	int bounce = 0;
+	unsigned long flags;
+	int error;
+
+	dev->dma_error = 0;
+
+	/* Set dma direction */
+	dev->dma_dir = do_read;
+	dev->dma_stage = 1;
+
+	/* Set intial dma state: for reading first fill on board buffer,
+	  from device, for writes first fill the buffer  from memory*/
+	dev->dma_state = do_read ? DMA_INTERNAL : DMA_MEMORY;
+
+	/* if incoming buffer is not page aligned, we should do bounce */
+	if ((unsigned long)buf & (PAGE_SIZE-1))
+		bounce = 1;
+
+	if (!bounce) {
+		dev->phys_dma_addr = pci_map_single(dev->pci_dev, (void *)buf,
+			R822_DMA_LEN,
+			(do_read ? PCI_DMA_FROMDEVICE : PCI_DMA_TODEVICE));
+
+		if (dev->phys_dma_addr == DMA_ERROR_CODE)
+			bounce = 1;
+	}
+
+	if (bounce) {
+		dev->phys_dma_addr = dev->phys_bounce_buffer;
+
+		if (!do_read)
+			memcpy(dev->bounce_buffer, buf, R822_DMA_LEN);
+	}
+
+	/* Enable DMA */
+	spin_lock_irqsave(&dev->irqlock, flags);
+	r822_dma_enable(dev);
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	/* Wait till complete */
+	error = r822_dma_wait(dev)
+
+	if (error) {
+		r822_dma_done(dev, error);
+		return;
+	}
+
+	if (do_read && bounce)
+		memcpy((void *)buf, dev->bounce_buffer, R822_DMA_LEN);
+}
+
+/*
+ * Program data lines of the nand chip to send data to it
+ */
+void r822_write_buf(struct mtd_info *mtd, const uint8_t *buf, int len)
+{
+	struct r822_device *dev = r822_get_dev(mtd);
+	u32 reg;
+
+	if (dev->card_unstable)
+		return;
+
+	/* special case for whole sector read */
+	if (len == R822_DMA_LEN && dev->dma_usable) {
+		r822_do_dma(dev, (uint8_t *)buf, 0);
+		return;
+	}
+
+	/* write DWORD chinks - faster */
+	while (len) {
+		reg = buf[0] | buf[1] << 8 | buf[2] << 16 | buf[3] << 24;
+		r822_write_reg_dword(dev, R822_DATALINE, reg);
+		buf += 4;
+		len -= 4;
+
+		if ((len % 16) == 0)
+			udelay(20);
+	}
+
+	/* write rest */
+	while (len)
+		r822_write_reg(dev, R822_DATALINE, *buf++);
+}
+
+/*
+ * Read data lines of the nand chip to retrieve data
+ */
+void r822_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
+{
+	struct r822_device *dev = r822_get_dev(mtd);
+	u32 reg;
+
+	if (dev->card_unstable)
+		return;
+
+	/* special case for whole sector read */
+	if (len == R822_DMA_LEN && dev->dma_usable) {
+		r822_do_dma(dev, buf, 1);
+		return;
+	}
+
+	/* read in dword sized chunks */
+	while (len >= 4) {
+
+		reg = r822_read_reg_dword(dev, R822_DATALINE);
+		*buf++ = reg & 0xFF;
+		*buf++ = (reg >> 8) & 0xFF;
+		*buf++ = (reg >> 16) & 0xFF;
+		*buf++ = (reg >> 24) & 0xFF;
+		len -= 4;
+	}
+
+	/* read the reset by bytes */
+	while (len--)
+		*buf++ = r822_read_reg(dev, R822_DATALINE);
+}
+
+static uint8_t r822_read_byte(struct mtd_info *mtd)
+{
+	struct r822_device *dev = r822_get_dev(mtd);
+	return r822_read_reg(dev, R822_DATALINE);
+}
+
+
+/*
+ * Readback the buffer to verify it
+ */
+int r822_verify_buf(struct mtd_info *mtd, const uint8_t *buf, int len)
+{
+	struct r822_device *dev = r822_get_dev(mtd);
+
+	if (dev->card_unstable)
+		return 0;
+
+	if (len > SM_SECTOR_SIZE)
+		return 0;
+
+	r822_read_buf(mtd, dev->tmp_buffer, len);
+	return memcmp(buf, dev->tmp_buffer, len);
+}
+
+/*
+ * Control several chip lines & send commands
+ */
+void r822_cmdctl(struct mtd_info *mtd, int dat, unsigned int ctrl)
+{
+	struct r822_device *dev = r822_get_dev(mtd);
+
+	if (dev->card_unstable)
+		return;
+
+	if (ctrl & NAND_CTRL_CHANGE) {
+
+		dev->ctlreg &= ~(R822_CTL_DATA | R822_CTL_COMMAND |
+				 R822_CTL_ON | R822_CTL_CARDENABLE);
+
+		if (ctrl & NAND_ALE)
+			dev->ctlreg |= R822_CTL_DATA;
+
+		if (ctrl & NAND_CLE)
+			dev->ctlreg |= R822_CTL_COMMAND;
+
+		if (ctrl & NAND_NCE)
+			dev->ctlreg |= (R822_CTL_CARDENABLE | R822_CTL_ON);
+		else
+			dev->ctlreg &= ~R822_CTL_WRITE;
+
+		/* when write is stareted, enable write access */
+		if (dat == NAND_CMD_ERASE1)
+			dev->ctlreg |= R822_CTL_WRITE;
+
+		r822_write_reg(dev, R822_CTL, dev->ctlreg);
+	}
+
+
+	 /* HACK: NAND_CMD_SEQIN is called without NAND_CTRL_CHANGE, but we need
+		to set write mode */
+	if (dat == NAND_CMD_SEQIN && (dev->ctlreg & R822_CTL_COMMAND)) {
+		dev->ctlreg |= R822_CTL_WRITE;
+		r822_write_reg(dev, R822_CTL, dev->ctlreg);
+	}
+
+	if (dat != NAND_CMD_NONE)
+		r822_write_reg(dev, R822_DATALINE, dat);
+}
+
+/*
+ * Wait till card is ready... This has to be a busy loop because
+ * 'our <censored> controller' doesn't have an interrupt for that...
+ * based on nand_wait
+ */
+int r822_wait(struct mtd_info *mtd, struct nand_chip *chip)
+{
+	struct r822_device *dev = (struct r822_device *)chip->priv;
+
+	unsigned long timeout;
+	int status;
+
+	timeout = jiffies + (chip->state == FL_ERASING ?
+		msecs_to_jiffies(400) : msecs_to_jiffies(20));
+
+	while (time_before(jiffies, timeout)) {
+		if (chip->dev_ready(mtd))
+			break;
+		cond_resched();
+	}
+
+	chip->cmdfunc(mtd, NAND_CMD_STATUS, -1, -1);
+	status = (int)chip->read_byte(mtd);
+
+	/* Unfortunelly, no way to send detailed error status... */
+	if (dev->dma_error) {
+		status |= NAND_STATUS_FAIL;
+		dev->dma_error = 0;
+	}
+
+	return status;
+}
+
+/*
+ * Check if card is ready
+ */
+
+int r822_ready(struct mtd_info *mtd)
+{
+	struct r822_device *dev = r822_get_dev(mtd);
+	return !(r822_read_reg(dev, R822_CARD_STA) & R822_CARD_STA_BUSY);
+}
+
+
+/*
+ * Set ECC engine mode
+*/
+
+void r822_ecc_hwctl(struct mtd_info *mtd, int mode)
+{
+	struct r822_device *dev = r822_get_dev(mtd);
+
+	if (dev->card_unstable)
+		return;
+
+	switch (mode) {
+	case NAND_ECC_READ:
+	case NAND_ECC_WRITE:
+		/* enable ecc generation/check*/
+		dev->ctlreg |= R822_CTL_ECC_ENABLE;
+
+		/* flush ecc buffer */
+		r822_write_reg(dev, R822_CTL,
+			dev->ctlreg | R822_CTL_ECC_ACCESS);
+
+		r822_read_reg(dev, R822_DATALINE);
+		r822_write_reg(dev, R822_CTL, dev->ctlreg);
+		return;
+
+	case NAND_ECC_READSYN:
+		/* disable ecc generation */
+		dev->ctlreg &= ~R822_CTL_ECC_ENABLE;
+		r822_write_reg(dev, R822_CTL, dev->ctlreg);
+	}
+}
+
+/*
+ * Calculate ECC, only used for writes
+ */
+
+int r822_ecc_calculate(struct mtd_info *mtd, const uint8_t *dat,
+							uint8_t *ecc_code)
+{
+	struct r822_device *dev = r822_get_dev(mtd);
+	struct sm_oob_raw *oob = (struct sm_oob_raw *)ecc_code;
+	u32 ecc1, ecc2;
+
+	if (dev->card_unstable)
+		return 0;
+
+	dev->ctlreg &= ~R822_CTL_ECC_ENABLE;
+	r822_write_reg(dev, R822_CTL, dev->ctlreg | R822_CTL_ECC_ACCESS);
+
+	ecc1 = r822_read_reg_dword(dev, R822_DATALINE);
+	ecc2 = r822_read_reg_dword(dev, R822_DATALINE);
+
+	oob->ecc1[0] = (ecc1) & 0xFF;
+	oob->ecc1[1] = (ecc1 >> 8) & 0xFF;
+	oob->ecc1[2] = (ecc1 >> 16) & 0xFF;
+
+	oob->ecc2[0] = (ecc2) & 0xFF;
+	oob->ecc2[1] = (ecc2 >> 8) & 0xFF;
+	oob->ecc2[2] = (ecc2 >> 16) & 0xFF;
+
+	r822_write_reg(dev, R822_CTL, dev->ctlreg);
+	return 0;
+}
+
+/*
+ * Correct the data using ECC, hw did almost everything for us
+ */
+
+int r822_ecc_correct(struct mtd_info *mtd, uint8_t *dat,
+				uint8_t *read_ecc, uint8_t *calc_ecc)
+{
+	u16 ecc_reg;
+	u8 ecc_status, err_byte;
+	int i, error = 0;
+
+	struct r822_device *dev = r822_get_dev(mtd);
+
+	if (dev->card_unstable)
+		return 0;
+
+	r822_write_reg(dev, R822_CTL, dev->ctlreg | R822_CTL_ECC_ACCESS);
+	ecc_reg = r822_read_reg_dword(dev, R822_DATALINE);
+	r822_write_reg(dev, R822_CTL, dev->ctlreg);
+
+	for (i = 0 ; i <= 1 ; i++) {
+
+		ecc_status = (ecc_reg >> 8) & 0xFF;
+
+		/* ecc uncorrectable error */
+		if (ecc_status & R822_ECC_FAIL) {
+			dbg("ecc: unrecoverable error, in half %d", i);
+			error = -1;
+			goto exit;
+		}
+
+		/* correctable error */
+		if (ecc_status & R822_ECC_CORRECTABLE) {
+
+			err_byte = ecc_reg & 0xFF;
+
+			dbg("ecc: recoverable error, "
+				"in half %d, byte %d, bit %d", i,
+				err_byte, ecc_status & R822_ECC_ERR_BIT_MSK);
+
+			dat[err_byte] ^=
+				1 << (ecc_status & R822_ECC_ERR_BIT_MSK);
+
+			error++;
+		}
+
+		dat += 256;
+		ecc_reg >>= 16;
+	}
+exit:
+	return error;
+}
+
+/*
+ * This is copy of nand_read_oob_std
+ * nand_read_oob_syndrome assumes we can send column address - we can't
+ */
+static int r822_read_oob(struct mtd_info *mtd, struct nand_chip *chip,
+			     int page, int sndcmd)
+{
+	if (sndcmd) {
+		chip->cmdfunc(mtd, NAND_CMD_READOOB, 0, page);
+		sndcmd = 0;
+	}
+	chip->read_buf(mtd, chip->oob_poi, mtd->oobsize);
+	return sndcmd;
+}
+
+/*
+ * Start the hardware
+ */
+
+void r822_device_start(struct r822_device *dev)
+{
+	if (r822_read_reg(dev, R822_HW) & R822_HW_UNKNOWN) {
+		dbg("r822_device_start: probably recovering from HW error");
+		r822_write_reg(dev, R822_CTL, R822_CTL_RESET | R822_CTL_ON);
+		r822_write_reg_dword(dev, R822_HW, R822_HW_ENABLED);
+	} else {
+		r822_write_reg(dev, R822_HW, R822_HW_ENABLED);
+		r822_write_reg(dev, R822_CTL, R822_CTL_RESET | R822_CTL_ON);
+		r822_write_reg(dev, R822_CTL, 0);
+	}
+	msleep(200);
+}
+
+
+/*
+ * Shutdown the hardware
+ */
+
+void r822_device_shutdown(struct r822_device *dev)
+{
+	r822_write_reg(dev, R822_HW, 0);
+	r822_write_reg(dev, R822_CTL, R822_CTL_RESET);
+}
+
+/*
+ * Test if card is present
+ */
+
+void r822_card_update_present(struct r822_device *dev)
+{
+	unsigned long flags;
+	u8 reg;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+	reg = r822_read_reg(dev, R822_CARD_STA);
+	dev->card_detected = !!(reg & R822_CARD_STA_PRESENT);
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+}
+
+/*
+ * Update card detection IRQ state according to current card state
+ * which is read in r822_card_update_present
+ */
+void r822_update_card_detect(struct r822_device *dev)
+{
+	int card_detect_reg = R822_CARD_IRQ_GENABLE;
+	card_detect_reg |= dev->card_detected ?
+		R822_CARD_IRQ_REMOVE : R822_CARD_IRQ_INSERT;
+
+	r822_write_reg(dev, R822_CARD_IRQ_ENABLE, card_detect_reg);
+}
+
+
+/* Detect properties of card in slot */
+void r822_update_media_status(struct r822_device *dev)
+{
+	u8 reg;
+	unsigned long flags;
+	int readonly, sm;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+	if (!dev->card_detected) {
+		dbg("card removed");
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		return ;
+	}
+
+	readonly  = r822_read_reg(dev, R822_CARD_STA) & R822_CARD_STA_RO;
+	reg = r822_read_reg(dev, R822_DMA_CAP);
+	sm = (reg & (R822_DMA1 | R822_DMA2)) && (reg & R822_SMBIT);
+
+	dbg("detected %s %s card in slot",
+		sm ? "SmartMedia" : "xD",
+		readonly ? "readonly" : "writeable");
+
+	dev->readonly = readonly;
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+}
+
+/*
+ * Register the nand device
+ * Called when the card is detected
+ */
+int r822_register_nand_device(struct r822_device *dev)
+{
+	dev->mtd = kzalloc(sizeof(struct mtd_info), GFP_KERNEL);
+
+	if (!dev->mtd)
+		goto error1;
+
+	dev->mtd->owner = THIS_MODULE;
+	dev->mtd->priv = dev->chip;
+
+	if (dev->readonly)
+		dev->chip->options |= NAND_ROM;
+
+	r822_device_start(dev);
+	if (sm_register_device(dev->mtd))
+		goto error2;
+
+	dev->card_registred = 1;
+	return 0;
+error2:
+	kfree(dev->mtd);
+error1:
+	return -1;
+}
+
+/*
+ * Unregister the card
+ */
+
+void r822_unregister_nand_device(struct r822_device *dev)
+{
+	if (!dev->card_registred)
+		return;
+
+	nand_release(dev->mtd);
+	r822_device_shutdown(dev);
+	dev->card_registred = 0;
+	kfree(dev->mtd);
+	dev->mtd = NULL;
+}
+
+
+/* Card state updater */
+void r822_card_detect_work(struct work_struct *work)
+{
+	struct r822_device *dev =
+		container_of(work, struct r822_device, card_detect_work.work);
+
+	r822_card_update_present(dev);
+	dev->card_unstable = 0;
+
+	/* false alarm */
+	if (dev->card_detected == dev->card_registred)
+		goto exit;
+
+	r822_update_media_status(dev);
+
+	/* no card present */
+	if (!dev->card_detected) {
+		r822_unregister_nand_device(dev);
+		goto exit;
+	}
+
+	/* card present from now */
+
+
+	if (!r822_register_nand_device(dev))
+		goto exit;
+	else
+		dev->card_detected = 0;
+exit:
+	r822_update_card_detect(dev);
+}
+
+
+/* disable IRQ generation */
+static void r822_disable_irqs(struct r822_device *dev)
+{
+	u8 reg;
+	reg = r822_read_reg(dev, R822_CARD_IRQ_ENABLE);
+	r822_write_reg(dev, R822_CARD_IRQ_ENABLE, reg & ~R822_CARD_IRQ_MASK);
+
+	reg = r822_read_reg(dev, R822_DMA_IRQ_ENABLE);
+	r822_write_reg(dev, R822_DMA_IRQ_ENABLE, reg & ~R822_DMA_IRQ_MASK);
+
+	reg = r822_read_reg(dev, R822_CARD_IRQ_STA);
+	r822_write_reg(dev, R822_CARD_IRQ_STA, reg);
+
+	reg = r822_read_reg(dev, R822_DMA_IRQ_STA);
+	r822_write_reg(dev, R822_DMA_IRQ_STA, reg);
+
+}
+
+/* Interrupt handler */
+static irqreturn_t r822_irq(int irq, void *data)
+{
+	struct r822_device *dev = (struct r822_device *)data;
+
+	u8 card_status, dma_status;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	/* test card status interrupts */
+	card_status =
+		r822_read_reg(dev, R822_CARD_IRQ_STA) & R822_CARD_IRQ_MASK;
+
+	if (card_status & (R822_CARD_IRQ_INSERT|R822_CARD_IRQ_REMOVE)) {
+
+		dev->card_detected = !!(card_status & R822_CARD_IRQ_INSERT);
+
+		/* we shouldn't recieve any interrupts if we wait for card
+			to settle */
+		WARN_ON(dev->card_unstable);
+
+		/* disable irqs while card is unstable */
+		/* this will timeout DMA if active, but better that garbage */
+		r822_disable_irqs(dev);
+
+		/* let, card state to settle a bit, and then do the work */
+		if (!dev->card_unstable) {
+			dev->card_unstable = 1;
+			queue_delayed_work(dev->card_workqueue,
+				&dev->card_detect_work, msecs_to_jiffies(100));
+		}
+
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		return IRQ_HANDLED;
+	}
+
+	card_status &= ~R822_CARD_IRQ_UNUSED1;
+	if (card_status)
+		dbg("card status = %02x", card_status);
+
+	/* test and ack dma interrupts */
+	dma_status = r822_read_reg(dev, R822_DMA_IRQ_STA) & R822_DMA_IRQ_MASK;
+	r822_write_reg(dev, R822_DMA_IRQ_STA, dma_status);
+
+	if (!dma_status) {
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		return IRQ_NONE;
+	}
+
+	if (dma_status & R822_DMA_IRQ_ERROR) {
+		dbg("recieved dma error IRQ");
+		r822_dma_done(dev, -EIO);
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		return IRQ_HANDLED;
+	}
+
+
+	/* recieved DMA interrupt out of nowhere? */
+	WARN_ON(dev->dma_stage == 0);
+
+
+	/* done device access */
+	if (dev->dma_state == DMA_INTERNAL &&
+				(dma_status & R822_DMA_IRQ_INTERNAL)) {
+
+		dev->dma_state = DMA_MEMORY;
+		dev->dma_stage++;
+	}
+
+	/* done memory DMA */
+	if (dev->dma_state == DMA_MEMORY &&
+				(dma_status & R822_DMA_IRQ_MEMORY)) {
+		dev->dma_state = DMA_INTERNAL;
+		dev->dma_stage++;
+	}
+
+	/* Enable 2nd half of dma dance */
+	if (dev->dma_stage == 2)
+		r822_dma_enable(dev);
+
+
+	/* Operation done */
+	if (dev->dma_stage == 3)
+		r822_dma_done(dev, 0);
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	return IRQ_HANDLED;
+}
+
+int  r822_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
+{
+	int error;
+	struct nand_chip *chip;
+	struct r822_device *dev;
+
+	/* pci initialization */
+	error = pci_enable_device(pci_dev);
+
+	if (error)
+		goto error1;
+
+	pci_set_master(pci_dev);
+
+	error = pci_set_dma_mask(pci_dev, DMA_32BIT_MASK);
+	if (error)
+		goto error2;
+
+	error = pci_request_regions(pci_dev, DRV_NAME);
+
+	if (error)
+		goto error3;
+
+	error = -ENOMEM;
+
+	/* init nand chip, but register it only on card insert */
+	chip = kzalloc(sizeof(struct nand_chip), GFP_KERNEL);
+
+	if (!chip)
+		goto error4;
+
+	/* commands */
+	chip->cmd_ctrl = r822_cmdctl;
+	chip->waitfunc = r822_wait;
+	chip->dev_ready = r822_ready;
+
+	/* I/O */
+	chip->read_byte = r822_read_byte;
+	chip->read_buf = r822_read_buf;
+	chip->write_buf = r822_write_buf;
+	chip->verify_buf = r822_verify_buf;
+
+	/* ecc */
+	chip->ecc.mode = NAND_ECC_HW_SYNDROME;
+	chip->ecc.size = R822_DMA_LEN;
+	chip->ecc.bytes = SM_OOB_SIZE;
+	chip->ecc.hwctl = r822_ecc_hwctl;
+	chip->ecc.calculate = r822_ecc_calculate;
+	chip->ecc.correct = r822_ecc_correct;
+
+	/* TODO: hack */
+	chip->ecc.read_oob = r822_read_oob;
+
+	/* init our device structure */
+	dev = kzalloc(sizeof(struct r822_device), GFP_KERNEL);
+
+	if (!dev)
+		goto error5;
+
+	chip->priv = dev;
+	dev->chip = chip;
+	dev->pci_dev = pci_dev;
+	pci_set_drvdata(pci_dev, dev);
+
+	dev->bounce_buffer = pci_alloc_consistent(pci_dev, R822_DMA_LEN,
+		&dev->phys_bounce_buffer);
+
+	if (!dev->bounce_buffer)
+		goto error6;
+
+
+	error = -ENODEV;
+	dev->mmio = pci_ioremap_bar(pci_dev, 0);
+
+	if (!dev->mmio)
+		goto error7;
+
+	error = -ENOMEM;
+	dev->tmp_buffer = kzalloc(SM_SECTOR_SIZE, GFP_KERNEL);
+
+	if (!dev->tmp_buffer)
+		goto error8;
+
+	init_completion(&dev->dma_done);
+
+	dev->card_workqueue = create_freezeable_workqueue(DRV_NAME);
+
+	if (!dev->card_workqueue)
+		goto error9;
+
+	INIT_DELAYED_WORK(&dev->card_detect_work, r822_card_detect_work);
+
+	/* shutdown everything - precation */
+	r822_device_shutdown(dev);
+	r822_disable_irqs(dev);
+	r822_dma_test(dev);
+
+	/*register irq handler*/
+	error = -ENODEV;
+	if (request_irq(pci_dev->irq, &r822_irq, IRQF_SHARED,
+			  DRV_NAME, dev))
+		goto error10;
+
+	dev->irq = pci_dev->irq;
+	spin_lock_init(&dev->irqlock);
+
+	/* kick initial present test */
+	dev->card_detected = 0;
+	r822_card_update_present(dev);
+	queue_delayed_work(dev->card_workqueue,
+		&dev->card_detect_work, 0);
+
+	/* Load the FTL */
+	request_module_nowait("sm_ftl");
+
+	printk(KERN_NOTICE DRV_NAME ": driver loaded succesfully\n");
+	return 0;
+
+
+error10:
+	destroy_workqueue(dev->card_workqueue);
+error9:
+	kfree(dev->tmp_buffer);
+error8:
+	pci_iounmap(pci_dev, dev->mmio);
+
+error7:
+	pci_free_consistent(pci_dev, R822_DMA_LEN,
+		dev->bounce_buffer, dev->phys_bounce_buffer);
+error6:
+	kfree(dev);
+error5:
+	kfree(chip);
+error4:
+	pci_release_regions(pci_dev);
+error3:
+error2:
+	pci_disable_device(pci_dev);
+error1:
+	return error;
+}
+
+
+void r822_remove(struct pci_dev *pci_dev)
+{
+	struct r822_device *dev = pci_get_drvdata(pci_dev);
+
+	/* Stop detect workqueue -
+		we are going to unregister the device anyway*/
+	cancel_delayed_work_sync(&dev->card_detect_work);
+	destroy_workqueue(dev->card_workqueue);
+
+	/* Unregister the device, this might make more IO */
+	r822_unregister_nand_device(dev);
+
+	/* Stop interrupts */
+	r822_disable_irqs(dev);
+	synchronize_irq(dev->irq);
+	free_irq(dev->irq, dev);
+
+	/* Cleanup */
+	kfree(dev->tmp_buffer);
+	pci_iounmap(pci_dev, dev->mmio);
+	pci_free_consistent(pci_dev, R822_DMA_LEN,
+		dev->bounce_buffer, dev->phys_bounce_buffer);
+	kfree(dev);
+	kfree(dev->chip);
+
+	/* Shutdown the PCI device */
+	pci_release_regions(pci_dev);
+	pci_disable_device(pci_dev);
+}
+
+void r822_shutdown(struct pci_dev *pci_dev)
+{
+	struct r822_device *dev = pci_get_drvdata(pci_dev);
+
+	cancel_delayed_work_sync(&dev->card_detect_work);
+	r822_disable_irqs(dev);
+	pci_disable_device(pci_dev);
+}
+
+int r822_suspend(struct device *device)
+{
+	struct r822_device *dev = pci_get_drvdata(to_pci_dev(device));
+
+	if (dev->ctlreg & R822_CTL_CARDENABLE)
+		return -EBUSY;
+
+	cancel_delayed_work_sync(&dev->card_detect_work);
+	r822_disable_irqs(dev);
+	r822_device_shutdown(dev);
+
+	/* If card was pulled off just during the suspend, which is very
+		unlikely, we will remove it on resume, it too late now
+		anyway... */
+	dev->card_unstable = 0;
+
+	pci_save_state(to_pci_dev(device));
+	pci_set_power_state(to_pci_dev(device), PCI_D3cold);
+
+
+	return 0;
+}
+
+int r822_resume(struct device *device)
+{
+	struct r822_device *dev = pci_get_drvdata(to_pci_dev(device));
+
+	pci_set_power_state(to_pci_dev(device), PCI_D0);
+	pci_restore_state(to_pci_dev(device));
+
+
+	r822_disable_irqs(dev);
+	r822_card_update_present(dev);
+	r822_device_shutdown(dev);
+
+
+	/* If card status changed, just do the work */
+	if (dev->card_detected != dev->card_registred) {
+		dbg("card was %s during low power state",
+			dev->card_detected ? "added" : "removed");
+
+		queue_delayed_work(dev->card_workqueue,
+		&dev->card_detect_work, 0);
+		return 0;
+	}
+
+	/* Otherwise, initialize the card */
+	if (dev->card_registred) {
+		r822_device_start(dev);
+		dev->chip->select_chip(dev->mtd, 0);
+		dev->chip->cmdfunc(dev->mtd, NAND_CMD_RESET, -1, -1);
+		dev->chip->cmdfunc(dev->mtd, NAND_CMD_READ0, -1, -1);
+		dev->chip->select_chip(dev->mtd, -1);
+	}
+
+	/* And start card detection IRQ */
+	r822_update_card_detect(dev);
+
+	return 0;
+}
+
+static const struct pci_device_id r822_pci_id_tbl[] = {
+
+	{ PCI_VDEVICE(RICOH, PCI_DEVICE_ID_RICOH_RL5C852), },
+	{ },
+};
+
+MODULE_DEVICE_TABLE(pci, r822_pci_id_tbl);
+
+SIMPLE_DEV_PM_OPS(r822_pm_ops, r822_suspend, r822_resume);
+
+
+static struct pci_driver r822_pci_driver = {
+	.name		= DRV_NAME,
+	.id_table	= r822_pci_id_tbl,
+	.probe		= r822_probe,
+	.remove		= r822_remove,
+	.shutdown	= r822_shutdown,
+	.driver.pm	= &r822_pm_ops,
+};
+
+static __init int r822_module_init(void)
+{
+	return pci_register_driver(&r822_pci_driver);
+}
+
+static void __exit r822_module_exit(void)
+{
+	pci_unregister_driver(&r822_pci_driver);
+}
+
+module_init(r822_module_init);
+module_exit(r822_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Maxim Levitsky <maximlevitsky@gmail.com>");
+MODULE_DESCRIPTION("Ricoh 85xx xD/smartmedia card reader driver");
diff --git a/drivers/mtd/nand/r822.h b/drivers/mtd/nand/r822.h
new file mode 100644
index 0000000..1b41769
--- /dev/null
+++ b/drivers/mtd/nand/r822.h
@@ -0,0 +1,155 @@
+/*
+ * Copyright (C) 2009 - Maxim Levitsky
+ * driver for Ricoh xD readers
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/pci.h>
+#include <linux/completion.h>
+#include <linux/workqueue.h>
+#include <linux/mtd/nand.h>
+#include <linux/spinlock.h>
+
+
+/* nand interface + ecc
+   byte write/read does one cycle on nand data lines.
+   dword write/read does 4 cycles
+   if R822_CTL_ECC_ACCESS is set in R822_CTL, then dword read reads
+   results of ecc correction, if DMA read was done before.
+   If write was done two dword reads read generated ecc checksums
+*/
+#define	R822_DATALINE		0x00
+
+/* control register */
+#define R822_CTL			0x04
+#define R822_CTL_COMMAND 	0x01	/* send command (#CLE)*/
+#define R822_CTL_DATA		0x02	/* read/write data (#ALE)*/
+#define R822_CTL_ON		0x04	/* only seem to controls the hd led, */
+					/* but has to be set on start...*/
+#define R822_CTL_RESET		0x08	/* unknown, set only on start once*/
+#define R822_CTL_CARDENABLE	0x10	/* probably (#CE) - always set*/
+#define R822_CTL_ECC_ENABLE	0x20	/* enable ecc engine */
+#define R822_CTL_ECC_ACCESS	0x40	/* read/write ecc via reg #0*/
+#define R822_CTL_WRITE		0x80	/* set when performing writes (#WP) */
+
+
+/* card detection status */
+#define R822_CARD_STA		0x05
+#define R822_CARD_STA_UNUSED1	0x01	/* unknown */
+#define R822_CARD_STA_RO	0x02	/* card is readonly -- test on #WP???*/
+#define R822_CARD_STA_PRESENT	0x04	/* card is present (#CD) */
+#define R822_CARD_STA_BUSY	0x80	/* card is busy - (#R/B) */
+
+/* card detection irq status*/
+#define R822_CARD_IRQ_STA	0x06	/* IRQ status */
+
+/* card detection irq enable */
+#define R822_CARD_IRQ_ENABLE	0x07	/* IRQ enable */
+
+#define R822_CARD_IRQ_UNUSED1	0x01	/* unknown */
+#define R822_CARD_IRQ_REMOVE	0x04	/* detect card removal */
+#define R822_CARD_IRQ_INSERT	0x08	/* detect card insert */
+#define R822_CARD_IRQ_UNUSED2	0x10	/* unknown */
+#define R822_CARD_IRQ_GENABLE	0x80	/* general enable */
+#define R822_CARD_IRQ_MASK	0x1D
+
+
+/* hardware enable */
+#define R822_HW			0x08
+#define R822_HW_ENABLED		0x01	/* hw enabled */
+#define R822_HW_UNKNOWN		0x80
+
+
+/* dma capabilities */
+#define R822_DMA_CAP		0x09
+#define R822_SMBIT		0x20	/* if set with bit #6 or bit #7, then */
+					/* hw is smartmedia */
+#define R822_DMA1		0x40	/* if set w/bit #7, dma is supported */
+#define R822_DMA2		0x80	/* if set w/bit #6, dma is supported */
+
+
+/* physical DMA address - 32 bit value*/
+#define R822_DMA_ADDR		0x0C
+
+
+/* dma settings */
+#define R822_DMA_SETTINGS	0x10
+#define R822_DMA_MEMORY		0x01	/* (memory <-> internal hw buffer) */
+#define R822_DMA_READ		0x02	/* 0 = write, 1 = read */
+#define R822_DMA_INTERNAL	0x04	/* (internal hw buffer <-> card) */
+
+/* dma IRQ status */
+#define R822_DMA_IRQ_STA		0x14
+
+/* dma IRQ enable */
+#define R822_DMA_IRQ_ENABLE	0x18
+
+#define R822_DMA_IRQ_MEMORY	0x01	/* (memory <-> internal hw buffer) */
+#define R822_DMA_IRQ_ERROR	0x02	/* error did happen */
+#define R822_DMA_IRQ_INTERNAL	0x04	/* (internal hw buffer <-> card) */
+#define R822_DMA_IRQ_MASK	0x07	/* mask of all IRQ bits */
+
+
+/* ECC syndrome format - read from reg #0 will return two copies of these for
+   each half of the page.
+   first byte is error byte location, and second, bit location + flags */
+#define R822_ECC_ERR_BIT_MSK	0x07	/* error bit location */
+#define R822_ECC_CORRECT		0x10	/* no errors - (guessed) */
+#define R822_ECC_CORRECTABLE	0x20	/* correctable error exist */
+#define R822_ECC_FAIL		0x40	/* non correctable error detected */
+
+#define R822_DMA_LEN		512
+
+#define DMA_INTERNAL	0
+#define DMA_MEMORY	1
+
+struct r822_device {
+	void __iomem *mmio;		/* mmio */
+	struct mtd_info *mtd;		/* mtd backpointer */
+	struct nand_chip *chip;		/* nand chip backpointer */
+	struct pci_dev *pci_dev;	/* pci backpointer */
+
+	/* dma area */
+	dma_addr_t phys_dma_addr;	/* bus address of buffer*/
+	struct completion dma_done;	/* data transfer done */
+
+	dma_addr_t phys_bounce_buffer;	/* bus address of bounce buffer */
+	u8 *bounce_buffer;		/* virtual address of bounce buffer */
+
+	int dma_dir;			/* 1 = read, 0 = write */
+	int dma_stage;			/* 0 - idle, 1 - first step,
+					   2 - second step */
+
+	int dma_state;			/* 0 = internal, 1 = memory */
+	int dma_error;			/* dma errors */
+	int dma_usable;			/* is it possible to use dma */
+
+
+	/* card status area */
+	struct delayed_work card_detect_work;
+	struct workqueue_struct *card_workqueue;
+	int card_registred;		/* card registered with mtd */
+	int card_detected;		/* card detected in slot */
+	int card_unstable;		/* whenever the card is inserted,
+					   is not known yet */
+	int readonly;			/* card is readonly */
+
+	/* misc */
+	spinlock_t irqlock;		/* IRQ protecting lock */
+	void *tmp_buffer;		/* temporary buffer */
+	u8 ctlreg;			/* cached contents of control reg */
+	int irq;			/* irq num */
+};
+
+#define DRV_NAME "r822xd"
+
+
+/* this will go to pci_ids.h */
+#define PCI_DEVICE_ID_RICOH_RL5C852	0x0852
+
+
+#define dbg(format, ...) \
+	printk(KERN_ERR DRV_NAME ": " format "\n", ## __VA_ARGS__)
-- 
1.6.3.3



