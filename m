Return-Path: <linux-kernel-owner+w=401wt.eu-S1758176AbYLPLmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbYLPLmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758080AbYLPLlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:41:42 -0500
Received: from exchtp08.via.com.tw ([61.66.243.7]:5287 "EHLO
	exchtp08.via.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758055AbYLPLlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:41:37 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: [Patch 2/3] via-sdmmc: via-sdmmc.c
Date: Tue, 16 Dec 2008 19:41:35 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB808520F3B@exchtp03.taipei.via.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Patch 2/3] via-sdmmc: via-sdmmc.c
Thread-Index: Aclfcz/t2fkPORrcRYK5+/8hiuCdYQ==
From: <JosephChan@via.com.tw>
To: <linux-kernel@vger.kernel.org>
Cc: <JosephChan@via.com.tw>
X-OriginalArrivalTime: 16 Dec 2008 11:41:36.0345 (UTC) FILETIME=[406BBC90:01C95F73]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id mBGBgWi3028826

VIA MSP SD/MMC card reader driver of via-sdmmc

BRs,
Joseph Chan 

Signed-off-by: Joseph Chan <josephchan@via.com.tw>

--- a/drivers/mmc/host/via-sdmmc.c	1970-01-01 08:00:00.000000000 +0800
+++ b/drivers/mmc/host/via-sdmmc.c	2008-12-13 00:33:20.000000000 +0800
@@ -0,0 +1,1035 @@
+/*
+ *  drivers/mmc/host/via-sdmmc.c - VIA SD/MMC Card Reader driver
+ *  Copyright (c) 2008, VIA Technologies Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or (at
+ * your option) any later version.
+ */
+
+#include <linux/pci.h>
+#include <linux/dma-mapping.h>
+#include <linux/highmem.h>
+#include <linux/delay.h>
+#include <linux/mmc/card.h>
+#include <linux/mmc/mmc.h>
+#include <linux/mmc/sd.h>
+#include <linux/mmc/host.h>
+
+#include "via-sdmmc.h"
+
+#define DRV_NAME	"via_sdmmc_driver"
+#define DRIVER_VERSION 	"2.0 beta 3"
+
+static struct pci_device_id via_ids[] = {
+	{PCI_VENDOR_ID_VIA, 0x9530, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0,},
+	{0,}
+};
+
+MODULE_DEVICE_TABLE(pci, via_ids);
+
+static void via_print_sdchc(struct via_crdr_chip *vcrdr_chip)
+{
+	void __iomem *addrbase;
+
+	addrbase = vcrdr_chip->sdhc_mmiobase;
+
+	pr_debug("SDC MMIO Registers:\n");
+	pr_debug("SDCONTROL_REG=%x ,", readl(addrbase + SDCONTROL_REG));
+	pr_debug("SDCMDARG_REG=%x ,", readl(addrbase + SDCMDARG_REG));
+	pr_debug("SDBUSMODE_REG=%x\n", readl(addrbase + SDBUSMODE_REG));
+	pr_debug("SDBLKLEN_REG=%x ,", readl(addrbase + SDBLKLEN_REG));
+	pr_debug("SDCURBLKCNT_REG=%x,", readl(addrbase + SDCURBLKCNT_REG));
+	pr_debug("SDINTMASK_REG=%x\n", readl(addrbase + SDINTMASK_REG));
+	pr_debug("SDSTATUS_REG=%x,", readl(addrbase + SDSTATUS_REG));
+	pr_debug("SDCLKSEL_REG=%x,", readl(addrbase + SDCLKSEL_REG));
+	pr_debug("SDEXTCTRL_REG=%x\n", readl(addrbase + SDEXTCTRL_REG));
+}
+
+static void via_print_pcictrl(struct via_crdr_chip *vcrdr_chip)
+{
+	void __iomem *addrbase;
+
+	addrbase = vcrdr_chip->pcictrl_mmiobase;
+
+	pr_debug("PCI Control Registers:\n");
+	pr_debug("PCICLKGATT_REG=%x,", readb(addrbase + PCICLKGATT_REG));
+	pr_debug("PCIMSCCCLK_REG=%x,", readb(addrbase + PCIMSCCLK_REG));
+	pr_debug("PCISDCCLK_REG=%x,", readb(addrbase + PCISDCCLK_REG));
+	pr_debug("PCIDMACLK_REG=%x\n,", readb(addrbase + PCIDMACLK_REG));
+	pr_debug("PCIINTCTRL_REG=%x,", readb(addrbase + PCIINTCTRL_REG));
+	pr_debug("PCIINTSTATUS_REG=%x\n", readb(addrbase + PCIINTSTATUS_REG));
+}
+
+static void via_save_pcictrlreg(struct via_crdr_chip *vcrdr_chip)
+{
+	struct pcictrlreg *pm_pcictrl_reg;
+	void __iomem *addrbase;
+
+	pm_pcictrl_reg = &(vcrdr_chip->pm_pcictrl_reg);
+	addrbase = vcrdr_chip->pcictrl_mmiobase;
+
+	pm_pcictrl_reg->pciclkgat_reg = readb(addrbase + PCICLKGATT_REG);
+	pm_pcictrl_reg->pciclkgat_reg |=
+	    PCI_CLKGATT_POWSEL | PCI_CLKGATT_POWOFF;
+	pm_pcictrl_reg->pcimscclk_reg = readb(addrbase + PCIMSCCLK_REG);
+	pm_pcictrl_reg->pcisdclk_reg = readb(addrbase + PCISDCCLK_REG);
+	pm_pcictrl_reg->pcidmaclk_reg = readb(addrbase + PCIDMACLK_REG);
+	pm_pcictrl_reg->pciintctrl_reg = readb(addrbase + PCIINTCTRL_REG);
+	pm_pcictrl_reg->pciintstatus_reg = readb(addrbase + PCIINTSTATUS_REG);
+	pm_pcictrl_reg->pcitmoctrl_reg = readb(addrbase + PCITMOCTRL_REG);
+}
+
+static void via_restore_pcictrlreg(struct via_crdr_chip *vcrdr_chip)
+{
+	struct pcictrlreg *pm_pcictrl_reg;
+	void __iomem *addrbase;
+
+	pm_pcictrl_reg = &(vcrdr_chip->pm_pcictrl_reg);
+	addrbase = vcrdr_chip->pcictrl_mmiobase;
+
+	writeb(pm_pcictrl_reg->pciclkgat_reg, addrbase + PCICLKGATT_REG);
+	writeb(pm_pcictrl_reg->pcimscclk_reg, addrbase + PCIMSCCLK_REG);
+	writeb(pm_pcictrl_reg->pcisdclk_reg, addrbase + PCISDCCLK_REG);
+	writeb(pm_pcictrl_reg->pcidmaclk_reg, addrbase + PCIDMACLK_REG);
+	writeb(pm_pcictrl_reg->pciintctrl_reg, addrbase + PCIINTCTRL_REG);
+	writeb(pm_pcictrl_reg->pciintstatus_reg, addrbase + PCIINTSTATUS_REG);
+	writeb(pm_pcictrl_reg->pcitmoctrl_reg, addrbase + PCITMOCTRL_REG);
+}
+
+static void via_save_sdcreg(struct via_crdr_chip *vcrdr_chip)
+{
+	struct sdhcreg *pm_sdhc_reg;
+	void __iomem *addrbase;
+
+	pm_sdhc_reg = &(vcrdr_chip->pm_sdhc_reg);
+	addrbase = vcrdr_chip->sdhc_mmiobase;
+
+	pm_sdhc_reg->sdcontrol_reg = readl(addrbase + SDCONTROL_REG);
+	pm_sdhc_reg->sdcmdarg_reg = readl(addrbase + SDCMDARG_REG);
+	pm_sdhc_reg->sdbusmode_reg = readl(addrbase + SDBUSMODE_REG);
+	pm_sdhc_reg->sdblklen_reg = readl(addrbase + SDBLKLEN_REG);
+	pm_sdhc_reg->sdcurblkcnt_reg = readl(addrbase + SDCURBLKCNT_REG);
+	pm_sdhc_reg->sdintmask_reg = readl(addrbase + SDINTMASK_REG);
+	pm_sdhc_reg->sdstatus_reg = readl(addrbase + SDSTATUS_REG);
+	pm_sdhc_reg->sdrsptmo_reg = readl(addrbase + SDRSPTMO_REG);
+	pm_sdhc_reg->sdclksel_reg = readl(addrbase + SDCLKSEL_REG);
+	pm_sdhc_reg->sdextctrl_reg = readl(addrbase + SDEXTCTRL_REG);
+}
+
+static void via_restore_sdcreg(struct via_crdr_chip *vcrdr_chip)
+{
+	struct sdhcreg *pm_sdhc_reg;
+	void __iomem *addrbase;
+
+	pm_sdhc_reg = &(vcrdr_chip->pm_sdhc_reg);
+	addrbase = vcrdr_chip->sdhc_mmiobase;
+
+	writel(pm_sdhc_reg->sdcontrol_reg, addrbase + SDCONTROL_REG);
+	writel(pm_sdhc_reg->sdcmdarg_reg, addrbase + SDCMDARG_REG);
+	writel(pm_sdhc_reg->sdbusmode_reg, addrbase + SDBUSMODE_REG);
+	writel(pm_sdhc_reg->sdblklen_reg, addrbase + SDBLKLEN_REG);
+	writel(pm_sdhc_reg->sdcurblkcnt_reg, addrbase + SDCURBLKCNT_REG);
+	writel(pm_sdhc_reg->sdintmask_reg, addrbase + SDINTMASK_REG);
+	writel(pm_sdhc_reg->sdstatus_reg, addrbase + SDSTATUS_REG);
+	writel(pm_sdhc_reg->sdrsptmo_reg, addrbase + SDRSPTMO_REG);
+	writel(pm_sdhc_reg->sdclksel_reg, addrbase + SDCLKSEL_REG);
+	writel(pm_sdhc_reg->sdextctrl_reg, addrbase + SDEXTCTRL_REG);
+}
+
+static void via_set_ddma(struct via_crdr_chip *vcrdr_chip,
+			 u32 physaddr, u32 count, int dir, int enirq)
+{
+	void __iomem *addrbase = vcrdr_chip->ddma_mmiobase;
+	u32 ctrl_data = 0;
+
+	if (enirq)
+		ctrl_data |= DDMA_CONTROL_RDENIRQ;
+
+	if (dir)
+		ctrl_data |= DDMA_CONTROL_RDDIR;
+
+	writel(physaddr, addrbase + DDMABASEADD_REG);
+	writel(count, addrbase + DDMACOUNTER_REG);
+	writel(ctrl_data, addrbase + DDMACONTROL_REG);
+	writel(0x01, addrbase + DDMASTART_REG);
+}
+
+static void via_sdc_preparedata(struct via_crdr_mmc_host *host,
+				struct mmc_data *data)
+{
+	void __iomem *addrbase;
+	struct scatterlist *sg = data->sg;
+	unsigned int len = data->sg_len;
+	unsigned char *tmpbuf = NULL;
+	u32 org_data, blk_reg;
+	u32 offset = 0;
+	int dir, i, count;
+
+	host->data = data;
+	host->data_early = 0;
+	count = data->blocks * data->blksz;
+
+	memset(host->ddmabuf, 0, count);
+
+	if (data->flags & MMC_DATA_WRITE)
+		dir = MEM_TO_CARD;
+	else
+		dir = CARD_TO_MEM;
+
+	if (data->flags & MMC_DATA_WRITE) {
+		for (i = 0; i < len; i++) {
+			tmpbuf = kmap_atomic(sg_page(&sg[i]), KM_BIO_SRC_IRQ);
+			tmpbuf += sg[i].offset;
+			memcpy(host->ddmabuf + offset, tmpbuf, sg[i].length);
+			offset += sg[i].length;
+			kunmap_atomic(tmpbuf, KM_BIO_SRC_IRQ);
+		}
+	}
+
+	via_set_ddma(host->chip, virt_to_phys(host->ddmabuf), count, dir, 0);
+
+	addrbase = host->chip->pcictrl_mmiobase;
+	if (readb(addrbase + PCISDCCLK_REG) != PCI_CLK_48M)
+		writeb(PCI_CLK_48M, addrbase + PCISDCCLK_REG);
+
+	addrbase = host->chip->sdhc_mmiobase;
+	blk_reg = (((data->blksz) - 1) & 0xffff) | (data->blocks << 16);
+	org_data = readl(addrbase + SDBLKLEN_REG);
+	org_data &= ~0xffff07ff;
+	blk_reg &= 0xffff07ff;
+	writel(org_data | blk_reg, addrbase + SDBLKLEN_REG);
+}
+
+static void via_sdc_get_response(struct via_crdr_mmc_host *host,
+				 struct mmc_command *cmd)
+{
+	void __iomem *addrbase = host->chip->sdhc_mmiobase;
+	u32 dwdata0 = readl(addrbase + SDRESP0_REG);
+	u32 dwdata1 = readl(addrbase + SDRESP1_REG);
+	u32 dwdata2 = readl(addrbase + SDRESP2_REG);
+	u32 dwdata3 = readl(addrbase + SDRESP3_REG);
+
+	if (cmd->flags & MMC_RSP_136) {
+		cmd->resp[0] = ((u8) (dwdata1)) |
+		    (((u8) (dwdata0 >> 24)) << 8) |
+		    (((u8) (dwdata0 >> 16)) << 16) |
+		    (((u8) (dwdata0 >> 8)) << 24);
+
+		cmd->resp[1] = ((u8) (dwdata2)) |
+		    (((u8) (dwdata1 >> 24)) << 8) |
+		    (((u8) (dwdata1 >> 16)) << 16) |
+		    (((u8) (dwdata1 >> 8)) << 24);
+
+		cmd->resp[2] = ((u8) (dwdata3)) |
+		    (((u8) (dwdata2 >> 24)) << 8) |
+		    (((u8) (dwdata2 >> 16)) << 16) |
+		    (((u8) (dwdata2 >> 8)) << 24);
+
+		cmd->resp[3] = 0xff |
+		    ((((u8) (dwdata3 >> 24))) << 8) |
+		    (((u8) (dwdata3 >> 16)) << 16) |
+		    (((u8) (dwdata3 >> 8)) << 24);
+	} else {
+		dwdata0 >>= 8;
+		cmd->resp[0] = ((dwdata0 & 0xff) << 24) |
+		    (((dwdata0 >> 8) & 0xff) << 16) |
+		    (((dwdata0 >> 16) & 0xff) << 8) | (dwdata1 & 0xff);
+
+		dwdata1 >>= 8;
+		cmd->resp[1] = ((dwdata1 & 0xff) << 24) |
+		    (((dwdata1 >> 8) & 0xff) << 16) |
+		    (((dwdata1 >> 16) & 0xff) << 8);
+	}
+}
+
+static void via_sdc_send_command(struct via_crdr_mmc_host *host,
+				 struct mmc_command *cmd)
+{
+	void __iomem *addrbase;
+	struct mmc_data *data;
+	u32 cmdctrl = 0;
+
+	data = cmd->data;
+
+	mod_timer(&host->timer, jiffies + 10 * HZ);
+	host->cmd = cmd;
+
+	cmdctrl = cmd->opcode << 8;
+
+	cmd->flags &= 0x1f;
+	switch (cmd->flags) {
+	case MMC_RSP_NONE:
+		cmdctrl |= ((u32) (0x0 << 16));
+		break;
+	case MMC_RSP_R1:
+		cmdctrl |= ((u32) (0x01 << 16));
+		break;
+	case MMC_RSP_R1B:
+		cmdctrl |= ((u32) (0x09 << 16));
+		break;
+	case MMC_RSP_R2:
+		cmdctrl |= ((u32) (0x02 << 16));
+		break;
+	case MMC_RSP_R3:
+		cmdctrl |= ((u32) (0x03 << 16));
+		break;
+	default:
+		pr_err("%s: cmd->flag is not valid\n", mmc_hostname(host->mmc));
+		break;
+	}
+
+	if (!(cmd->data))
+		goto nodata;
+
+	via_sdc_preparedata(host, data);
+
+	if (data->blocks > 1) {
+		if (data->flags & MMC_DATA_WRITE)
+			cmdctrl |= 0x34;
+		else
+			cmdctrl |= 0x40;
+	} else {
+		if (data->flags & MMC_DATA_WRITE)
+			cmdctrl |= 0x14;
+		else
+			cmdctrl |= 0x20;
+	}
+
+nodata:
+	if (cmd->opcode == MMC_STOP_TRANSMISSION)
+		cmdctrl |= 0x70;
+
+	cmdctrl |= 1;
+
+	addrbase = host->chip->sdhc_mmiobase;
+	writel(cmd->arg, addrbase + SDCMDARG_REG);
+	writel(cmdctrl, addrbase + SDCONTROL_REG);
+}
+
+static void via_sdc_finish_data(struct via_crdr_mmc_host *host)
+{
+	struct mmc_data *data;
+	u16 blocks;
+	u32 offset = 0;
+
+	BUG_ON(!host->data);
+
+	data = host->data;
+	host->data = NULL;
+
+	if (data->blocks == 1)
+		blocks = (data->error == 0) ? 0 : 1;
+	else
+		blocks = readw(host->chip->sdhc_mmiobase + SDCURBLKCNT_REG);
+	data->bytes_xfered = data->blksz * (data->blocks - blocks);
+
+	if (!data->error && blocks) {
+		pr_err("%s: Controller signalled completion even "
+		       "though there were blocks left.\n",
+		       mmc_hostname(host->mmc));
+		data->error = -EIO;
+	}
+
+	if (data->flags & MMC_DATA_READ) {
+		struct scatterlist *sg = data->sg;
+		unsigned char *sgbuf;
+		int i;
+
+		for (i = 0; i < data->sg_len; i++) {
+			sgbuf = kmap_atomic(sg_page(&sg[i]), KM_BIO_SRC_IRQ);
+			memcpy(sgbuf + sg[i].offset, host->ddmabuf + offset,
+			       sg[i].length);
+			offset += sg[i].length;
+			kunmap_atomic(sgbuf, KM_BIO_SRC_IRQ);
+		}
+	}
+
+	if (data->stop)
+		via_sdc_send_command(host, data->stop);
+	else
+		tasklet_schedule(&host->finish_tasklet);
+}
+
+static void via_sdc_finish_command(struct via_crdr_mmc_host *host)
+{
+	via_sdc_get_response(host, host->cmd);
+
+	host->cmd->error = 0;
+
+	if (host->data && host->data_early)
+		via_sdc_finish_data(host);
+
+	if (!host->cmd->data)
+		tasklet_schedule(&host->finish_tasklet);
+
+	host->cmd = NULL;
+}
+
+static void via_sdc_request(struct mmc_host *mmc, struct mmc_request *mrq)
+{
+	void __iomem *addrbase;
+	struct via_crdr_mmc_host *host;
+	struct via_crdr_chip *vcrdr_chip;
+	unsigned long flags;
+	u16 status;
+
+	host = mmc_priv(mmc);
+	vcrdr_chip = host->chip;
+
+	addrbase = vcrdr_chip->pcictrl_mmiobase;
+	writeb(PCI_DMA_CLK_SDC, addrbase + PCIDMACLK_REG);
+	vcrdr_chip->cur_device = DEV_SDC;
+
+	status = readw(vcrdr_chip->sdhc_mmiobase + SDSTATUS_REG);
+	status &= SD_STS_W1C_MASK;
+	writew(status, vcrdr_chip->sdhc_mmiobase + SDSTATUS_REG);
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	WARN_ON(host->mrq != NULL);
+	host->mrq = mrq;
+
+	if (host->mrq->cmd->opcode == 5) {
+		host->mrq->cmd->error = -ENOMEDIUM;
+		tasklet_schedule(&host->finish_tasklet);
+		goto out;
+	}
+
+	status = readw(vcrdr_chip->sdhc_mmiobase + SDSTATUS_REG);
+	if (!(status & SD_STS_SLOTG)) {
+		host->mrq->cmd->error = -ENOMEDIUM;
+		tasklet_schedule(&host->finish_tasklet);
+	} else {
+		via_sdc_send_command(host, mrq->cmd);
+	}
+
+out:
+	mmiowb();
+	spin_unlock_irqrestore(&host->lock, flags);
+}
+
+static void via_sdc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
+{
+	struct via_crdr_mmc_host *host;
+	struct via_crdr_chip *vcrdr_chip;
+	unsigned long flags;
+
+	host = mmc_priv(mmc);
+	vcrdr_chip = host->chip;
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	if (host->bus_width != ios->bus_width) {
+		void __iomem *addrbase = vcrdr_chip->sdhc_mmiobase;
+		u32 org_data = readl(addrbase + SDBUSMODE_REG);
+
+		if (ios->bus_width == MMC_BUS_WIDTH_1) {
+			host->bus_width = MMC_BUS_WIDTH_1;
+			org_data &= ~SD_MODE_4BIT;
+		} else {
+			host->bus_width = MMC_BUS_WIDTH_4;
+			org_data |= SD_MODE_4BIT;
+		}
+		writel(org_data, addrbase + SDBUSMODE_REG);
+	}
+
+	mmiowb();
+	spin_unlock_irqrestore(&host->lock, flags);
+}
+
+static int via_sdc_get_ro(struct mmc_host *mmc)
+{
+	struct via_crdr_mmc_host *host;
+	struct via_crdr_chip *vcrdr_chip;
+	unsigned long flags;
+	u16 status;
+
+	host = mmc_priv(mmc);
+	vcrdr_chip = host->chip;
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	status = readw(vcrdr_chip->sdhc_mmiobase + SDSTATUS_REG);
+
+	spin_unlock_irqrestore(&host->lock, flags);
+
+	return !(status & SD_STS_WP);
+}
+
+static const struct mmc_host_ops via_sdc_ops = {
+	.request = via_sdc_request,
+	.set_ios = via_sdc_set_ios,
+	.get_ro = via_sdc_get_ro,
+};
+
+static void via_reset_pcictrl(struct via_crdr_mmc_host *host)
+{
+	struct via_crdr_chip *vcrdr_chip;
+	u8 gatt;
+	void __iomem *addrbase;
+
+	vcrdr_chip = host->chip;
+	addrbase = vcrdr_chip->pcictrl_mmiobase;
+
+	via_save_pcictrlreg(vcrdr_chip);
+	via_save_sdcreg(vcrdr_chip);
+
+	gatt = readb(addrbase + PCICLKGATT_REG);
+	gatt &= ~PCI_CLKGATT_SOFTRST;
+	gatt |= PCI_CLKGATT_POWSEL | PCI_CLKGATT_POWOFF;
+	writeb(gatt, addrbase + PCICLKGATT_REG);
+
+	mdelay(1);
+
+	via_restore_pcictrlreg(vcrdr_chip);
+	via_restore_sdcreg(vcrdr_chip);
+}
+
+static void via_sdc_cmd_isr(struct via_crdr_mmc_host *host, u16 intmask)
+{
+	BUG_ON(intmask == 0);
+
+	if (!host->cmd) {
+		pr_err("%s: Got command interrupt 0x%x even "
+		       "though no command operation was in progress.\n",
+		       mmc_hostname(host->mmc), intmask);
+		return;
+	}
+
+	if (intmask & SD_STS_RA)
+		host->cmd->error = -ETIMEDOUT;
+	else if (intmask & SD_STS_SC)
+		host->cmd->error = -EILSEQ;
+
+	if (host->cmd->error)
+		tasklet_schedule(&host->finish_tasklet);
+	else if (intmask & SD_STS_CR)
+		via_sdc_finish_command(host);
+}
+
+static void via_sdc_data_isr(struct via_crdr_mmc_host *host, u16 intmask)
+{
+	BUG_ON(intmask == 0);
+
+	if (intmask & SD_STS_DT)
+		host->data->error = -ETIMEDOUT;
+	else if (intmask & (SD_STS_RC | SD_STS_WC))
+		host->data->error = -EILSEQ;
+
+	if (host->data->error)
+		via_sdc_finish_data(host);
+	else {
+		if (host->cmd)
+			host->data_early = 1;
+		else
+			via_sdc_finish_data(host);
+	}
+}
+
+static irqreturn_t via_sdc_isr(int irq, void *dev_id)
+{
+	struct via_crdr_mmc_host *sdhost = dev_id;
+	struct via_crdr_chip *vcrdr_chip = sdhost->chip;
+	void __iomem *addrbase;
+	u8 pci_status;
+	u16 sd_status;
+	irqreturn_t result;
+
+	spin_lock(&sdhost->lock);
+
+	addrbase = vcrdr_chip->pcictrl_mmiobase;
+	pci_status = readb(addrbase + PCIINTSTATUS_REG);
+	if (!(pci_status & PCI_INT_STATUS_SDC)) {
+		result = IRQ_NONE;
+		goto out;
+	}
+
+	addrbase = vcrdr_chip->sdhc_mmiobase;
+	sd_status = readw(addrbase + SDSTATUS_REG);
+	sd_status &= SD_STS_INT_MASK;
+	sd_status &= ~SD_STS_IGN_MASK;
+	if (!sd_status) {
+		result = IRQ_NONE;
+		goto out;
+	}
+
+	if (sd_status & SD_STS_SI) {
+		writew(sd_status & SD_STS_SI, addrbase + SDSTATUS_REG);
+		tasklet_schedule(&sdhost->carddet_tasklet);
+	}
+
+	sd_status &= ~SD_STS_SI;
+	if (sd_status & SD_STS_CMD_MASK) {
+		writew(sd_status & SD_STS_CMD_MASK, addrbase + SDSTATUS_REG);
+		via_sdc_cmd_isr(sdhost, sd_status & SD_STS_CMD_MASK);
+	}
+	if (sd_status & SD_STS_DATA_MASK) {
+		writew(sd_status & SD_STS_DATA_MASK, addrbase + SDSTATUS_REG);
+		via_sdc_data_isr(sdhost, sd_status & SD_STS_DATA_MASK);
+	}
+
+	sd_status &= ~(SD_STS_CMD_MASK | SD_STS_DATA_MASK);
+	if (sd_status) {
+		pr_err("%s: Unexpected interrupt 0x%x\n",
+		       mmc_hostname(sdhost->mmc), sd_status);
+		writew(sd_status, addrbase + SDSTATUS_REG);
+	}
+
+	result = IRQ_HANDLED;
+
+	mmiowb();
+out:
+	spin_unlock(&sdhost->lock);
+
+	return result;
+}
+
+static void via_sdc_timeout(unsigned long ulongdata)
+{
+	struct via_crdr_mmc_host *sdhost;
+	unsigned long flags;
+
+	sdhost = (struct via_crdr_mmc_host *)ulongdata;
+
+	spin_lock_irqsave(&sdhost->lock, flags);
+
+	if (sdhost->mrq) {
+		pr_err("%s: Timeout waiting for hardware interrupt."
+		       "cmd:0x%x\n", mmc_hostname(sdhost->mmc),
+		       sdhost->mrq->cmd->opcode);
+		if (sdhost->data) {
+			sdhost->data->error = -ETIMEDOUT;
+			via_sdc_finish_data(sdhost);
+		} else {
+			if (sdhost->cmd)
+				sdhost->cmd->error = -ETIMEDOUT;
+			else
+				sdhost->mrq->cmd->error = -ETIMEDOUT;
+			tasklet_schedule(&sdhost->finish_tasklet);
+		}
+	}
+
+	mmiowb();
+	spin_unlock_irqrestore(&sdhost->lock, flags);
+}
+
+static void via_sdc_tasklet_finish(unsigned long param)
+{
+	struct via_crdr_mmc_host *host;
+	unsigned long flags;
+	struct mmc_request *mrq;
+
+	host = (struct via_crdr_mmc_host *)param;
+
+	spin_lock_irqsave(&host->lock, flags);
+	del_timer(&host->timer);
+	mrq = host->mrq;
+	host->mrq = NULL;
+	host->cmd = NULL;
+	host->data = NULL;
+	mmiowb();
+	spin_unlock_irqrestore(&host->lock, flags);
+
+	mmc_request_done(host->mmc, mrq);
+}
+
+static void via_sdc_tasklet_card(unsigned long param)
+{
+	struct via_crdr_mmc_host *host;
+	struct via_crdr_chip *vcrdr_chip;
+	void __iomem *addrbase;
+	unsigned long flags;
+	u16 status;
+
+	host = (struct via_crdr_mmc_host *)param;
+	vcrdr_chip = host->chip;
+
+	addrbase = vcrdr_chip->ddma_mmiobase;
+	writel(DDMA_CONTROL_SOFTRESET, addrbase + DDMACONTROL_REG);
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	addrbase = vcrdr_chip->pcictrl_mmiobase;
+	writeb(PCI_DMA_CLK_SDC, addrbase + PCIDMACLK_REG);
+	vcrdr_chip->cur_device = DEV_SDC;
+
+	addrbase = vcrdr_chip->sdhc_mmiobase;
+	status = readw(addrbase + SDSTATUS_REG);
+	if (!(status & SD_STS_SLOTG)) {
+		if (host->mrq) {
+			pr_err("%s: Card removed during transfer!\n",
+			       mmc_hostname(host->mmc));
+			host->mrq->cmd->error = -ENOMEDIUM;
+			tasklet_schedule(&host->finish_tasklet);
+		}
+
+		addrbase = vcrdr_chip->pcictrl_mmiobase;
+		writeb(PCI_CLK_375K, addrbase + PCISDCCLK_REG);
+
+		via_reset_pcictrl(host);
+
+		vcrdr_chip->cur_device = DEV_NULL;
+	}
+	mmiowb();
+	spin_unlock_irqrestore(&host->lock, flags);
+
+	via_print_pcictrl(vcrdr_chip);
+	via_print_sdchc(vcrdr_chip);
+
+	mmc_detect_change(host->mmc, 0);
+}
+
+static void via_init_mmc_host(struct via_crdr_mmc_host *host)
+{
+	struct via_crdr_chip *vcrdr_chip = host->chip;
+	struct mmc_host *mmc = host->mmc;
+	void __iomem *addrbase;
+	u32 lenreg;
+	u32 status;
+
+	init_timer(&host->timer);
+	host->timer.data = (unsigned long)host;
+	host->timer.function = via_sdc_timeout;
+
+	spin_lock_init(&host->lock);
+
+	host->mmc->f_min = 450000;
+	host->mmc->f_max = 24000000;
+	host->mmc->max_seg_size = 512;
+	host->mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
+	host->mmc->caps = MMC_CAP_4_BIT_DATA;
+	host->mmc->ops = &via_sdc_ops;
+	host->mmc->max_hw_segs = 128;
+	host->mmc->max_phys_segs = 128;
+	host->mmc->max_seg_size = mmc->max_hw_segs * 512;
+
+	tasklet_init(&host->carddet_tasklet, via_sdc_tasklet_card,
+		     (unsigned long)host);
+
+	tasklet_init(&host->finish_tasklet, via_sdc_tasklet_finish,
+		     (unsigned long)host);
+
+	addrbase = vcrdr_chip->sdhc_mmiobase;
+	writel(0x0, addrbase + SDINTMASK_REG);
+	mdelay(1);
+
+	lenreg = 0x1ff;
+	lenreg |= SD_BLKLEN_GPIDET | SD_BLKLEN_INTEN;
+	lenreg |= 0x80000;
+	writel(lenreg, addrbase + SDBLKLEN_REG);
+
+	status = readw(addrbase + SDSTATUS_REG);
+	status &= SD_STS_W1C_MASK;
+	writew(status, addrbase + SDSTATUS_REG);
+
+	status = readw(addrbase + SDSTATUS_REG2);
+	status |= SD_STS_CFE;
+	writew(status, addrbase + SDSTATUS_REG2);
+
+	writeb(0x0, addrbase + SDEXTCTRL_REG);
+
+	writel(SD_ACTIVE_INTMASK, addrbase + SDINTMASK_REG);
+	udelay(20);
+
+	host->bus_width = MMC_BUS_WIDTH_1;
+
+	addrbase = vcrdr_chip->pcictrl_mmiobase;
+	writeb(PCI_CLK_375K, addrbase + PCISDCCLK_REG);
+}
+
+static int __devinit via_chip_probe(struct pci_dev *pcidev,
+				    const struct pci_device_id *id)
+{
+	struct device *dev;
+	struct mmc_host *mmc;
+	struct via_crdr_mmc_host *sdhost;
+	struct via_crdr_chip *vcrdr_chip;
+	u32 mmiobase;
+	u32 len;
+	u8 rev;
+	int ret;
+	u8 gatt;
+
+	pci_read_config_byte(pcidev, PCI_CLASS_REVISION, &rev);
+	pr_info(DRV_NAME
+		": VIA SDMMC controller found at %s [%04x:%04x] (rev %x)\n",
+		pci_name(pcidev), (int)pcidev->vendor, (int)pcidev->device,
+		(int)rev);
+
+	ret = pci_enable_device(pcidev);
+	if (ret)
+		return ret;
+
+	ret = pci_request_regions(pcidev, DRV_NAME);
+	if (ret)
+		goto disable;
+
+	vcrdr_chip = kzalloc(sizeof(*vcrdr_chip), GFP_KERNEL);
+	if (!vcrdr_chip) {
+		ret = -ENOMEM;
+		goto release;
+	}
+
+	pci_write_config_byte(pcidev, PCI_WORK_MODE, 0);
+	pci_write_config_byte(pcidev, PCI_DEBUG_MODE, 0);
+
+	len = pci_resource_len(pcidev, 0);
+	mmiobase = pci_resource_start(pcidev, 0);
+	vcrdr_chip->mmiobase = ioremap_nocache(mmiobase, len);
+	if (!vcrdr_chip->mmiobase) {
+		ret = -ENOMEM;
+		goto chip_free;
+	}
+	vcrdr_chip->sdhc_mmiobase = vcrdr_chip->mmiobase + SDC_OFFSET;
+	vcrdr_chip->ddma_mmiobase = vcrdr_chip->mmiobase + DDMA_OFFSET;
+	vcrdr_chip->pcictrl_mmiobase = vcrdr_chip->mmiobase + PCICTRL_OFFSET;
+
+	dev = &pcidev->dev;
+	dev_set_drvdata(dev, vcrdr_chip);
+
+	vcrdr_chip->cur_device = DEV_NULL;
+
+	gatt = PCI_CLKGATT_POWSEL | PCI_CLKGATT_POWOFF;
+	writeb(gatt, vcrdr_chip->pcictrl_mmiobase + PCICLKGATT_REG);
+	mdelay(3);
+	gatt |= PCI_CLKGATT_SOFTRST;
+	writeb(gatt, vcrdr_chip->pcictrl_mmiobase + PCICLKGATT_REG);
+	mdelay(3);
+
+	mmc = mmc_alloc_host(sizeof(struct via_crdr_mmc_host), dev);
+	if (!mmc) {
+		ret = -ENOMEM;
+		goto unmap;
+	}
+
+	sdhost = mmc_priv(mmc);
+	sdhost->mmc = mmc;
+	sdhost->chip = vcrdr_chip;
+	vcrdr_chip->sdc = sdhost;
+
+	via_init_mmc_host(sdhost);
+
+	ret =
+	    request_irq(pcidev->irq, via_sdc_isr, IRQF_SHARED, DRV_NAME,
+			sdhost);
+	if (ret)
+		goto free_mmc_host;
+
+	sdhost->ddmabuf = (u8 *) __get_free_pages(GFP_KERNEL, 7);
+	if (!sdhost->ddmabuf) {
+		ret = -ENOMEM;
+		goto free_mmc_irq;
+	}
+
+	writeb(PCI_INTCTRL_SDCIRQEN,
+	       vcrdr_chip->pcictrl_mmiobase + PCIINTCTRL_REG);
+	writeb(PCI_TMO_CTRL_1024MS,
+	       vcrdr_chip->pcictrl_mmiobase + PCITMOCTRL_REG);
+
+	mmc_add_host(mmc);
+
+	return 0;
+
+free_mmc_irq:
+	free_irq(pcidev->irq, sdhost);
+free_mmc_host:
+	mmc_free_host(mmc);
+unmap:
+	dev_set_drvdata(dev, NULL);
+	iounmap(vcrdr_chip->mmiobase);
+chip_free:
+	kfree(vcrdr_chip);
+release:
+	pci_release_regions(pcidev);
+disable:
+	pci_disable_device(pcidev);
+
+	return ret;
+}
+
+static void __devexit via_chip_remove(struct pci_dev *pcidev)
+{
+	struct via_crdr_chip *vcrdr_chip;
+	struct via_crdr_mmc_host *sdhost;
+	u8 gatt;
+
+	vcrdr_chip = pci_get_drvdata(pcidev);
+	sdhost = vcrdr_chip->sdc;
+	pr_info(DRV_NAME
+		": VIA SDMMC controller at %s [%04x:%04x] has been removed\n",
+		pci_name(pcidev), (int)pcidev->vendor, (int)pcidev->device);
+
+	if (sdhost) {
+
+		tasklet_kill(&sdhost->finish_tasklet);
+		tasklet_kill(&sdhost->carddet_tasklet);
+		free_pages((unsigned long)sdhost->ddmabuf, 7);
+
+		if (&sdhost->timer)
+			del_timer_sync(&sdhost->timer);
+
+		mmc_remove_host(sdhost->mmc);
+	}
+
+	free_irq(pcidev->irq, sdhost);
+	mmc_free_host(sdhost->mmc);
+
+	writeb(0x0, vcrdr_chip->pcictrl_mmiobase + PCIINTCTRL_REG);
+
+	gatt = readb(vcrdr_chip->pcictrl_mmiobase + PCICLKGATT_REG);
+	gatt &= ~PCI_CLKGATT_POWOFF;
+	writeb(gatt, vcrdr_chip->pcictrl_mmiobase + PCICLKGATT_REG);
+
+	dev_set_drvdata(&pcidev->dev, NULL);
+	iounmap(vcrdr_chip->mmiobase);
+	kfree(vcrdr_chip);
+	pci_release_regions(pcidev);
+	pci_disable_device(pcidev);
+}
+
+#ifdef CONFIG_PM
+static void via_save_pcicfg(struct pci_dev *pcidev,
+			    struct via_crdr_chip *vcrdr_chip)
+{
+	int i;
+
+	for (i = 0; i < 0x42; i++)
+		pci_read_config_byte(pcidev, i, &(vcrdr_chip->pci_cfg_bak[i]));
+}
+
+static void via_restore_pcicfg(struct pci_dev *pcidev,
+			       struct via_crdr_chip *vcrdr_chip)
+{
+	int i;
+
+	for (i = 0; i < 0x42; i++)
+		pci_write_config_byte(pcidev, i, vcrdr_chip->pci_cfg_bak[i]);
+}
+
+static void via_init_sdc_pm(struct via_crdr_chip *vcrdr_chip)
+{
+	struct sdhcreg *pm_sdhcreg;
+	void __iomem *addrbase;
+	u32 lenreg;
+	u16 status;
+
+	pm_sdhcreg = &(vcrdr_chip->pm_sdhc_reg);
+	addrbase = vcrdr_chip->sdhc_mmiobase;
+
+	writel(0x0, addrbase + SDINTMASK_REG);
+
+	lenreg = 0x1ff;
+	lenreg |= SD_BLKLEN_GPIDET | SD_BLKLEN_INTEN;
+	lenreg |= 0x80000;
+	writel(lenreg, addrbase + SDBLKLEN_REG);
+
+	status = readw(addrbase + SDSTATUS_REG);
+	status &= SD_STS_W1C_MASK;
+	writew(status, addrbase + SDSTATUS_REG);
+
+	status = readw(addrbase + SDSTATUS_REG2);
+	status |= SD_STS_CFE;
+	writew(status, addrbase + SDSTATUS_REG2);
+
+	mdelay(1);
+
+	writel(pm_sdhcreg->sdcontrol_reg, addrbase + SDCONTROL_REG);
+	writel(pm_sdhcreg->sdcmdarg_reg, addrbase + SDCMDARG_REG);
+	writel(pm_sdhcreg->sdintmask_reg, addrbase + SDINTMASK_REG);
+	writel(pm_sdhcreg->sdrsptmo_reg, addrbase + SDRSPTMO_REG);
+	writel(pm_sdhcreg->sdclksel_reg, addrbase + SDCLKSEL_REG);
+	writel(pm_sdhcreg->sdextctrl_reg, addrbase + SDEXTCTRL_REG);
+
+	addrbase = vcrdr_chip->pcictrl_mmiobase;
+	writeb(PCI_CLK_375K, addrbase + PCISDCCLK_REG);
+
+	via_print_pcictrl(vcrdr_chip);
+	via_print_sdchc(vcrdr_chip);
+}
+
+static int via_chip_suspend(struct pci_dev *pcidev, pm_message_t state)
+{
+	struct via_crdr_mmc_host *sdhost;
+	struct via_crdr_chip *vcrdr_chip;
+	int ret = 0;
+
+	vcrdr_chip = pci_get_drvdata(pcidev);
+	sdhost = vcrdr_chip->sdc;
+
+	via_save_pcicfg(pcidev, vcrdr_chip);
+	via_save_pcictrlreg(vcrdr_chip);
+	via_save_sdcreg(vcrdr_chip);
+
+	switch (vcrdr_chip->cur_device) {
+	case DEV_SDC:
+		ret = mmc_suspend_host(sdhost->mmc, state);
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+static int via_chip_resume(struct pci_dev *pcidev)
+{
+	struct via_crdr_mmc_host *sdhost;
+	struct via_crdr_chip *vcrdr_chip;
+	int ret = 0;
+
+	vcrdr_chip = pci_get_drvdata(pcidev);
+	sdhost = vcrdr_chip->sdc;
+
+	via_restore_pcicfg(pcidev, vcrdr_chip);
+	via_restore_pcictrlreg(vcrdr_chip);
+	via_init_sdc_pm(vcrdr_chip);
+
+	switch (vcrdr_chip->cur_device) {
+	case DEV_SDC:
+		ret = mmc_resume_host(sdhost->mmc);
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+#else /* CONFIG_PM */
+
+#define via_chip_suspend NULL
+#define via_chip_resume NULL
+
+#endif /* CONFIG_PM */
+
+static struct pci_driver via_sd_driver = {
+	.name = DRV_NAME,
+	.id_table = via_ids,
+	.probe = via_chip_probe,
+	.remove = __devexit_p(via_chip_remove),
+	.suspend = via_chip_suspend,
+	.resume = via_chip_resume,
+};
+
+static int __init via_sd_drv_init(void)
+{
+	pr_info(DRV_NAME ": VIA SD/MMC Card Reader driver\n");
+	pr_info(DRV_NAME ": Copyright(c) VIA Technologies Inc.\n");
+
+	return pci_register_driver(&via_sd_driver);
+}
+
+static void __exit via_sd_drv_exit(void)
+{
+	pci_unregister_driver(&via_sd_driver);
+}
+
+module_init(via_sd_drv_init);
+module_exit(via_sd_drv_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("VIA Technologies Inc.");
+MODULE_DESCRIPTION("VIA SD/MMC Card Interface driver");
+MODULE_VERSION(DRIVER_VERSION);
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
