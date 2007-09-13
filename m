Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbXIMIiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbXIMIiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 04:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbXIMIiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 04:38:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42749 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753064AbXIMIiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 04:38:05 -0400
Date: Thu, 13 Sep 2007 01:37:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: bryan.wu@analog.com
Cc: David Woodhouse <dwmw2@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Blackfin BF54x NAND Flash Controller driver
Message-Id: <20070913013702.d446739a.akpm@linux-foundation.org>
In-Reply-To: <1188804323.29566.6.camel@roc-laptop>
References: <1188804323.29566.6.camel@roc-laptop>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Sep 2007 15:25:23 +0800 Bryan Wu <bryan.wu@analog.com> wrote:

> This is the driver for latest Blackfin BF54x nand flash controller
> 
>  - use nand_chip and mtd_info common nand driver interface
>  - provide both PIO and dma operation
>  - compiled with ezkit bf548 configuration
>  - use hardware 1-bit ECC
>  - tested with YAFFS2 and can mount YAFFS2 filesystem as rootfs
> 
> ...
>
> +int hardware_ecc = 0;

scripts/checkpatch.pl, please.

> +#endif
> +
> +unsigned short bfin_nfc_pin_req[] = {P_NAND_CE, P_NAND_RB, 0};

static.  Please review whole patch for this.

> +/*
> + * bf54x_nand_hwcontrol
> + *
> + * Issue command and address cycles to the chip
> + */
> +static void bf54x_nand_hwcontrol(struct mtd_info *mtd, int cmd,
> +				   unsigned int ctrl)
> +{
> +	if (cmd == NAND_CMD_NONE)
> +		return;
> +
> +	while (bfin_read_NFC_STAT() & WB_FULL)
> +		continue;

cpu_relax().  Please check the whole patch for this too.

> +	if (ctrl & NAND_CLE)
> +		bfin_write_NFC_CMD(cmd);
> +	else
> +		bfin_write_NFC_ADDR(cmd);
> +	SSYNC();
> +}
> +
>
> ...
>
> +/*----------------------------------------------------------------------------
> + * ECC functions
> + *
> + * These allow the bf54x to use the controller's ECC
> + * generator block to ECC the data as it passes through
> + */
> +static inline int count_bits(uint32_t byte)
> +{
> +	int res = 0;
> +
> +	for (; byte; byte >>= 1)
> +		res += byte & 0x01;
> +	return res;
> +}

delete this, use hweight32() at its callsites.

> +
> +static int bf54x_nand_correct_data(struct mtd_info *mtd, u_char *dat,
> +					u_char *read_ecc, u_char *calc_ecc)
> +{	struct bf54x_nand_info *info = mtd_to_nand_info(mtd);

missing newline

> +	struct bf54x_nand_platform *plat = info->platform;
> +	unsigned short page_size = (plat->page_size ? 512 : 256);
> +
> +	int ret;

extraneous newline

> +	ret = bf54x_nand_correct_data_256(mtd, dat, read_ecc, calc_ecc);
> +
> +	/* If page size is 512, correct second 256 bytes */
> +	if (page_size == 512) {
> +		dat += 256;
> +		read_ecc += 8;
> +		calc_ecc += 8;
> +		ret = bf54x_nand_correct_data_256(mtd, dat, read_ecc, calc_ecc);
> +	}
> +
> +	return ret;
> +}
> +
> +static void bf54x_nand_enable_hwecc(struct mtd_info *mtd, int mode)
> +{
> +	/*
> +	 * This register must be written before each page is
> +	 * transferred to generate the correct ECC register
> +	 * values.
> +	 */
> +	return;
> +
> +}

comment doesn't match code.

extraneous newline

> +
> +/*----------------------------------------------------------------------------
> + * PIO mode for buffer writing and reading
> + */

remove the ------------------------------ thingy.  (whole patch)

> +static void bf54x_nand_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
> +{
> +	int i;
> +	unsigned short val;
> +
> +	/*
> +	 * Data reads are requested by first writing to NFC_DATA_RD
> +	 * and then reading back from NFC_READ.
> +	 */
> +	for (i = 0; i < len; i++) {
> +		while (bfin_read_NFC_STAT() & WB_FULL)
> +			continue;

cpu_relax()

> +		/* Contents do not matter */
> +		bfin_write_NFC_DATA_RD(0x0000);
> +		SSYNC();
> +
> +		while ((bfin_read_NFC_IRQSTAT() & RD_RDY) != RD_RDY)
> +			continue;
> +
> +		buf[i] = bfin_read_NFC_READ();
> +
> +		val = bfin_read_NFC_IRQSTAT();
> +		val |= RD_RDY;
> +		bfin_write_NFC_IRQSTAT(val);
> +		SSYNC();
> +	}
> +}
> +
> +static uint8_t bf54x_nand_read_byte(struct mtd_info *mtd)
> +{
> +	uint8_t val;
> +
> +	bf54x_nand_read_buf(mtd, &val, 1);
> +
> +	return val;
> +}
> +
> +static void bf54x_nand_write_buf(struct mtd_info *mtd,
> +				const uint8_t *buf, int len)
> +{
> +	int i;
> +
> +	for (i = 0; i < len; i++) {
> +		while (bfin_read_NFC_STAT() & WB_FULL)
> +			continue;

dittoes

> +		bfin_write_NFC_DATA_WR(buf[i]);
> +		SSYNC();
> +	}
> +}
> +
>
> ...
>
> +/*----------------------------------------------------------------------------
> + * DMA functions for buffer writing and reading
> + */
> +static irqreturn_t bf54x_nand_dma_irq (int irq, void *dev_id)
> +{
> +	struct bf54x_nand_info *info = (struct bf54x_nand_info *) dev_id;

unneeded and undesirable cast of void*

> +
> +	clear_dma_irqstat(CH_NFC);
> +	disable_dma(CH_NFC);
> +	complete(&info->dma_completion);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int bf54x_nand_dma_rw(struct mtd_info *mtd,
> +				uint8_t *buf, int is_read)
> +{
> +	struct bf54x_nand_info *info = mtd_to_nand_info(mtd);
> +	struct bf54x_nand_platform *plat = info->platform;
> +	unsigned short page_size = (plat->page_size ? 512 : 256);
> +	unsigned short val;
> +
> +	dev_dbg(info->device, " mtd->%p, buf->%p, len %d, is_read %d\n",
> +			mtd, buf, is_read);
> +
> +	if (is_read)
> +		invalidate_dcache_range((unsigned int)buf,
> +				(unsigned int)(buf + page_size));
> +	else
> +		flush_dcache_range((unsigned int)buf,
> +				(unsigned int)(buf + page_size));

I'd have though that the MM tricks here need a comment so readers know
what's going on?

> +	bfin_write_NFC_RST(0x1);
> +	SSYNC();
> +
> +	disable_dma(CH_NFC);
> +	clear_dma_irqstat(CH_NFC);
> +
> +	/* setup DMA register with Blackfin DMA API */
> +	set_dma_config(CH_NFC, 0x0);
> +	set_dma_start_addr(CH_NFC, (unsigned long) buf);
> +	set_dma_x_count(CH_NFC, (page_size >> 2));
> +	set_dma_x_modify(CH_NFC, 4);
> +
> +	/* setup write or read operation */
> +	val = DI_EN | WDSIZE_32;
> +	if (is_read)
> +		val |= WNR;
> +	set_dma_config(CH_NFC, val);
> +	enable_dma(CH_NFC);
> +
> +	/* Start PAGE read/write operation */
> +	if (is_read)
> +		bfin_write_NFC_PGCTL(0x1);
> +	else
> +		bfin_write_NFC_PGCTL(0x2);
> +	wait_for_completion(&info->dma_completion);
> +
> +	return 0;
> +}
> +
>
> ...
>
> +/*
> + * BF54X NFC hardware initialization
> + *  - pin mux setup
> + *  - clear interrupt status
> + */
> +static int bf54x_nand_hw_init(struct bf54x_nand_info *info)
> +{
> +	int err = 0;
> +	unsigned short val;
> +	struct bf54x_nand_platform *plat = info->platform;
> +
> +	if (!info)
> +		return -EINVAL;

can this happen?

> +	/* setup NFC_CTL register */
> +	dev_info(info->device,
> +		"page_size=%d, data_width=%d, wr_dly=%d, rd_dly=%d\n",
> +		(plat->page_size ? 512 : 256),
> +		(plat->data_width ? 16 : 8),
> +		plat->wr_dly, plat->rd_dly);
> +
> +	val = (plat->page_size << NFC_PG_SIZE_OFFSET) |
> +		(plat->data_width << NFC_NWIDTH_OFFSET) |
> +		(plat->rd_dly << NFC_RDDLY_OFFSET) |
> +		(plat->rd_dly << NFC_WRDLY_OFFSET);
> +	dev_dbg(info->device, "NFC_CTL is 0x%04x\n", val);
> +
> +	bfin_write_NFC_CTL(val);
> +	SSYNC();
> +
> +	/* clear interrupt status */
> +	bfin_write_NFC_IRQMASK(0x0);
> +	SSYNC();
> +	val = bfin_read_NFC_IRQSTAT();
> +	bfin_write_NFC_IRQSTAT(val);
> +	SSYNC();
> +
> +	if (peripheral_request_list(bfin_nfc_pin_req, DRV_NAME)) {
> +		printk(KERN_ERR DRV_NAME
> +		": Requesting Peripherals failed\n");
> +		return -EFAULT;
> +	}
> +
> +

extraneous newline

> +	/* DMA initialization  */
> +	if (bf54x_nand_dma_init(info)) {
> +		err = -ENXIO;
> +	}
> +
> +	return err;
> +}
> +
>
> ...
>
> +static int bf54x_nand_remove(struct platform_device *pdev)
> +{
> +	struct bf54x_nand_info *info = to_nand_info(pdev);
> +	struct mtd_info *mtd = NULL;
> +
> +	platform_set_drvdata(pdev, NULL);
> +
> +	if (!info)
> +		return 0;

can this happen?

> +	/* first thing we need to do is release all our mtds
> +	 * and their partitions, then go through freeing the
> +	 * resources used
> +	 */
> +	mtd = &info->mtd;
> +	if (mtd) {
> +		nand_release(mtd);
> +		kfree(mtd);
> +	}
> +
> +	peripheral_free_list(bfin_nfc_pin_req);
> +
> +	/* free the common resources */
> +	kfree(info);
> +
> +	return 0;
> +}
> +
> +/*
> + * bf54x_nand_probe
> + *
> + * called by device layer when it finds a device matching
> + * one our driver can handled. This code checks to see if
> + * it can allocate all necessary resources then calls the
> + * nand layer to look for devices
> + */
> +static int bf54x_nand_probe(struct platform_device *pdev)
> +{
> +	struct bf54x_nand_platform *plat = to_nand_plat(pdev);
> +	struct bf54x_nand_info *info = NULL;
> +	struct nand_chip *chip = NULL;
> +	struct mtd_info *mtd = NULL;
> +	int err = 0;
> +
> +	dev_dbg(&pdev->dev, "(%p)\n", pdev);
> +
> +	if (!plat) {
> +		dev_err(&pdev->dev, "no platform specific information\n");
> +		goto exit_error;

and can this?

> +	}
> +
> +	info = kzalloc(sizeof(*info), GFP_KERNEL);
> +	if (info == NULL) {
> +		dev_err(&pdev->dev, "no memory for flash info\n");
> +		err = -ENOMEM;
> +		goto exit_error;
> +	}
> +
> +	platform_set_drvdata(pdev, info);
> +
> +	spin_lock_init(&info->controller.lock);
> +	init_waitqueue_head(&info->controller.wq);
> +
> +	info->device     = &pdev->dev;
> +	info->platform   = plat;
> +
> +	/* initialise chip data struct */
> +	chip = &info->chip;
> +
> +	if (plat->data_width)
> +		chip->options |= NAND_BUSWIDTH_16;
> +
> +	chip->options |= NAND_CACHEPRG | NAND_SKIP_BBTSCAN;
> +
> +	chip->read_buf = (plat->data_width) ?
> +		bf54x_nand_read_buf16 : bf54x_nand_read_buf;
> +	chip->write_buf = (plat->data_width) ?
> +		bf54x_nand_write_buf16 : bf54x_nand_write_buf;
> +
> +	chip->read_byte    = bf54x_nand_read_byte;
> +
> +	chip->cmd_ctrl     = bf54x_nand_hwcontrol;
> +	chip->dev_ready    = bf54x_nand_devready;
> +
> +	chip->priv	   = &info->mtd;
> +	chip->controller   = &info->controller;
> +
> +	chip->IO_ADDR_R    = (void __iomem *) NFC_READ;
> +	chip->IO_ADDR_W    = (void __iomem *) NFC_DATA_WR;
> +
> +	chip->chip_delay   = 0;
> +
> +	/* initialise mtd info data struct */
> +	mtd 		= &info->mtd;
> +	mtd->priv	= chip;
> +	mtd->owner	= THIS_MODULE;
> +
> +	/* initialise the hardware */
> +	err = bf54x_nand_hw_init(info);
> +	if (err != 0)
> +		goto exit_error;
> +
> +	/* setup hardware ECC data struct */
> +	if (hardware_ecc) {
> +		if (plat->page_size == NFC_PG_SIZE_256) {
> +			chip->ecc.bytes = 3;
> +			chip->ecc.size = 256;
> +		} else if (mtd->writesize == NFC_PG_SIZE_512) {
> +			chip->ecc.bytes = 6;
> +			chip->ecc.size = 512;
> +		}
> +
> +		chip->read_buf      = bf54x_nand_dma_read_buf;
> +		chip->write_buf     = bf54x_nand_dma_write_buf;
> +		chip->ecc.calculate = bf54x_nand_calculate_ecc;
> +		chip->ecc.correct   = bf54x_nand_correct_data;
> +		chip->ecc.mode	    = NAND_ECC_HW;
> +		chip->ecc.hwctl	    = bf54x_nand_enable_hwecc;
> +	} else {
> +		chip->ecc.mode	    = NAND_ECC_SOFT;
> +	}
> +
> +	/* scan hardware nand chip and setup mtd info data struct */
> +	if (nand_scan(mtd, 1)) {
> +		err = -ENXIO;
> +		goto exit_error;
> +	}
> +
> +	/* add NAND partition */
> +	bf54x_nand_add_partition(info);
> +
> +	dev_dbg(&pdev->dev, "initialised ok\n");
> +	return 0;
> +
> +exit_error:
> +	bf54x_nand_remove(pdev);
> +
> +	if (err == 0)
> +		err = -EINVAL;
> +	return err;
> +}
> +
> +	if (info)
> +		bf54x_nand_hw_init(info);
> +
> +	return 0;
> +}
> +

