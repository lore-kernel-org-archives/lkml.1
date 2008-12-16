Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbYLPNb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbYLPNb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 08:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbYLPNbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 08:31:51 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62226 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbYLPNbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 08:31:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: JosephChan@via.com.tw
Subject: Re: [Patch 2/3] via-sdmmc: via-sdmmc.c
Date: Tue, 16 Dec 2008 14:31:42 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB808520F3B@exchtp03.taipei.via.com.tw>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB808520F3B@exchtp03.taipei.via.com.tw>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200812161431.42387.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18Dm5FKL24gbpwafsR/CM/dIzqNoRqtdJT7uXI
 jy+yMb0I2z1ECOb3CZlFlAlHSABWeEQLaz8jCJFufgOOc37TEN
 f0qdZp/BEWXt16fQpzvqg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 December 2008, JosephChan@via.com.tw wrote:
> VIA MSP SD/MMC card reader driver of via-sdmmc

The code looks very nice, good work.

> +static void via_save_pcictrlreg(struct via_crdr_chip *vcrdr_chip)
> +{
> +	struct pcictrlreg *pm_pcictrl_reg;
> +	void __iomem *addrbase;
> +
> +	pm_pcictrl_reg = &(vcrdr_chip->pm_pcictrl_reg);
> +	addrbase = vcrdr_chip->pcictrl_mmiobase;
> +
> +	pm_pcictrl_reg->pciclkgat_reg = readb(addrbase + PCICLKGATT_REG);
> +	pm_pcictrl_reg->pciclkgat_reg |=
> +	    PCI_CLKGATT_POWSEL | PCI_CLKGATT_POWOFF;
> +	pm_pcictrl_reg->pcimscclk_reg = readb(addrbase + PCIMSCCLK_REG);
> +	pm_pcictrl_reg->pcisdclk_reg = readb(addrbase + PCISDCCLK_REG);
> +	pm_pcictrl_reg->pcidmaclk_reg = readb(addrbase + PCIDMACLK_REG);
> +	pm_pcictrl_reg->pciintctrl_reg = readb(addrbase + PCIINTCTRL_REG);
> +	pm_pcictrl_reg->pciintstatus_reg = readb(addrbase + PCIINTSTATUS_REG);
> +	pm_pcictrl_reg->pcitmoctrl_reg = readb(addrbase + PCITMOCTRL_REG);
> +}

Since you already define the data structure for the save area, how about
using it for the register accesses as well? You could drop all the PCI*_REG
macro definitions and do

struct pcictrlreg __iomem *pcr = vcrdr_chip->pcictrl_mmiobase;
pm_pcictrl_reg->pcisdclk_reg = readb(&pcr->pcisdclk_reg);

Of course, your code is doing the same things effectively and entirely
ok here.

> +	if (data->flags & MMC_DATA_WRITE)
> +		dir = MEM_TO_CARD;
> +	else
> +		dir = CARD_TO_MEM;
> +
> +	if (data->flags & MMC_DATA_WRITE) {
> +		for (i = 0; i < len; i++) {
> +			tmpbuf = kmap_atomic(sg_page(&sg[i]), KM_BIO_SRC_IRQ);
> +			tmpbuf += sg[i].offset;
> +			memcpy(host->ddmabuf + offset, tmpbuf, sg[i].length);
> +			offset += sg[i].length;
> +			kunmap_atomic(tmpbuf, KM_BIO_SRC_IRQ);
> +		}
> +	}
> +
> +	via_set_ddma(host->chip, virt_to_phys(host->ddmabuf), count, dir, 0);

You can't use virt_to_phys here, since the physical address might not be the
same as the bus address, in case you are using an IOMMU. The correct way
to do it would be to drop the memcpy to the internal buffer, and do a
dma_map_sg() to get the bus address.


> +
> +	if (data->flags & MMC_DATA_READ) {
> +		struct scatterlist *sg = data->sg;
> +		unsigned char *sgbuf;
> +		int i;
> +
> +		for (i = 0; i < data->sg_len; i++) {
> +			sgbuf = kmap_atomic(sg_page(&sg[i]), KM_BIO_SRC_IRQ);
> +			memcpy(sgbuf + sg[i].offset, host->ddmabuf + offset,
> +			       sg[i].length);
> +			offset += sg[i].length;
> +			kunmap_atomic(sgbuf, KM_BIO_SRC_IRQ);
> +		}
> +	}

same here.

> +static irqreturn_t via_sdc_isr(int irq, void *dev_id)
> +{
> +	struct via_crdr_mmc_host *sdhost = dev_id;
> +	struct via_crdr_chip *vcrdr_chip = sdhost->chip;
> +	void __iomem *addrbase;
> +	u8 pci_status;
> +	u16 sd_status;
> +	irqreturn_t result;
> +
> +	spin_lock(&sdhost->lock);
> +
> +	addrbase = vcrdr_chip->pcictrl_mmiobase;
> +	pci_status = readb(addrbase + PCIINTSTATUS_REG);
> +	if (!(pci_status & PCI_INT_STATUS_SDC)) {
> +		result = IRQ_NONE;
> +		goto out;
> +	}
> +
> +	addrbase = vcrdr_chip->sdhc_mmiobase;
> +	sd_status = readw(addrbase + SDSTATUS_REG);
> +	sd_status &= SD_STS_INT_MASK;
> +	sd_status &= ~SD_STS_IGN_MASK;
> +	if (!sd_status) {
> +		result = IRQ_NONE;
> +		goto out;
> +	}
> +
> +	if (sd_status & SD_STS_SI) {
> +		writew(sd_status & SD_STS_SI, addrbase + SDSTATUS_REG);
> +		tasklet_schedule(&sdhost->carddet_tasklet);
> +	}
> +
> +	sd_status &= ~SD_STS_SI;
> +	if (sd_status & SD_STS_CMD_MASK) {
> +		writew(sd_status & SD_STS_CMD_MASK, addrbase + SDSTATUS_REG);
> +		via_sdc_cmd_isr(sdhost, sd_status & SD_STS_CMD_MASK);
> +	}
> +	if (sd_status & SD_STS_DATA_MASK) {
> +		writew(sd_status & SD_STS_DATA_MASK, addrbase + SDSTATUS_REG);
> +		via_sdc_data_isr(sdhost, sd_status & SD_STS_DATA_MASK);
> +	}
> +
> +	sd_status &= ~(SD_STS_CMD_MASK | SD_STS_DATA_MASK);
> +	if (sd_status) {
> +		pr_err("%s: Unexpected interrupt 0x%x\n",
> +		       mmc_hostname(sdhost->mmc), sd_status);
> +		writew(sd_status, addrbase + SDSTATUS_REG);
> +	}

What are your criteria for deciding which events to handle in interrupt
context or in tasklet context? Are some of them extremely performance
critical?

If you can do all of them in a single tasklet function that you simply
schedule every time without the spinlock, you don't need to disable
interrupts every time you access a register but can instead use
spin_lock_bh.

To go even further, you could use a work queue instead of the tasklet
and use a mutex instead of the spinlock.

> +static void via_init_mmc_host(struct via_crdr_mmc_host *host)
> +{
> +	struct via_crdr_chip *vcrdr_chip = host->chip;
> +	struct mmc_host *mmc = host->mmc;
> +	void __iomem *addrbase;
> +	u32 lenreg;
> +	u32 status;
> +
> +	init_timer(&host->timer);
> +	host->timer.data = (unsigned long)host;
> +	host->timer.function = via_sdc_timeout;
> +
> +	spin_lock_init(&host->lock);
> +
> +	host->mmc->f_min = 450000;
> +	host->mmc->f_max = 24000000;
> +	host->mmc->max_seg_size = 512;
> +	host->mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
> +	host->mmc->caps = MMC_CAP_4_BIT_DATA;
> +	host->mmc->ops = &via_sdc_ops;
> +	host->mmc->max_hw_segs = 128;
> +	host->mmc->max_phys_segs = 128;
> +	host->mmc->max_seg_size = mmc->max_hw_segs * 512;
> +
> +	tasklet_init(&host->carddet_tasklet, via_sdc_tasklet_card,
> +		     (unsigned long)host);
> +
> +	tasklet_init(&host->finish_tasklet, via_sdc_tasklet_finish,
> +		     (unsigned long)host);
> +
> +	addrbase = vcrdr_chip->sdhc_mmiobase;
> +	writel(0x0, addrbase + SDINTMASK_REG);
> +	mdelay(1);

Since this function runs in task context, you should use msleep()
here, not mdelay().
> +
> +	gatt = PCI_CLKGATT_POWSEL | PCI_CLKGATT_POWOFF;
> +	writeb(gatt, vcrdr_chip->pcictrl_mmiobase + PCICLKGATT_REG);
> +	mdelay(3);
> +	gatt |= PCI_CLKGATT_SOFTRST;
> +	writeb(gatt, vcrdr_chip->pcictrl_mmiobase + PCICLKGATT_REG);
> +	mdelay(3);

same here.

	Arnd <><
