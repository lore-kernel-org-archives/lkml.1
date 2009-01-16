Return-Path: <linux-kernel-owner+w=401wt.eu-S933638AbZAPRb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638AbZAPRb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 12:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757986AbZAPRbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 12:31:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757492AbZAPRbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 12:31:42 -0500
Date: Fri, 16 Jan 2009 09:31:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
Message-Id: <20090116093101.6d77b69b.akpm@linux-foundation.org>
In-Reply-To: <20090116152721.GA6994@havoc.gtf.org>
References: <20090116152721.GA6994@havoc.gtf.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009 10:27:21 -0500 Jeff Garzik <jeff@garzik.org> wrote:

> 
> And a new, oft-reposted, finally ready cfl driver.
> 
> The ioctl fix is notable, an ugly bug.
> 
> Please pull from 'upstream-linus' branch of
> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus
> 
> to receive the following updates:
> 
> ...
>
> Andrew Morton (1):
>       drivers/ata/pata_ali.c: s/isa_bridge/ali_isa_bridge/ to fix alpha build

hi, mom.

>
> ...
>
> -static int atiixp_init_one(struct pci_dev *dev, const struct pci_device_id *id)
> +static int atiixp_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
>  {
>  	static const struct ata_port_info info = {
>  		.flags = ATA_FLAG_SLAVE_POSS,
> @@ -241,8 +225,18 @@ static int atiixp_init_one(struct pci_dev *dev, const struct pci_device_id *id)
>  		.udma_mask = 0x3F,
>  		.port_ops = &atiixp_port_ops
>  	};
> -	const struct ata_port_info *ppi[] = { &info, NULL };
> -	return ata_pci_sff_init_one(dev, ppi, &atiixp_sht, NULL);
> +	static const struct pci_bits atiixp_enable_bits[] = {
> +		{ 0x48, 1, 0x01, 0x00 },
> +		{ 0x48, 1, 0x08, 0x00 }
> +	};
> +	const struct ata_port_info *ppi[] = { &info, &info };
> +	int i;
> +
> +	for (i = 0; i < 2; i++)

s/2/ARRAY_SIZE/

> +		if (!pci_test_config_bits(pdev, &atiixp_enable_bits[i]))
> +			ppi[i] = &ata_dummy_port_info;
> +
> +	return ata_pci_sff_init_one(pdev, ppi, &atiixp_sht, NULL);
>  }
>  
>
> ...
>
> --- /dev/null
> +++ b/drivers/ata/pata_octeon_cf.c
> @@ -0,0 +1,965 @@
> +/*
> + * Driver for the Octeon bootbus compact flash.
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file "COPYING" in the main directory of this archive
> + * for more details.
> + *
> + * Copyright (C) 2005 - 2009 Cavium Networks
> + * Copyright (C) 2008 Wind River Systems
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/libata.h>
> +#include <linux/irq.h>
> +#include <linux/platform_device.h>
> +#include <linux/workqueue.h>
> +#include <scsi/scsi_host.h>
> +
> +#include <asm/octeon/octeon.h>
> +
> +/*
> + * The Octeon bootbus compact flash interface is connected in at least
> + * 3 different configurations on various evaluation boards:
> + *
> + * -- 8  bits no irq, no DMA
> + * -- 16 bits no irq, no DMA
> + * -- 16 bits True IDE mode with DMA, but no irq.
> + *
> + * In the last case the DMA engine can generate an interrupt when the
> + * transfer is complete.  For the first two cases only PIO is supported.
> + *
> + */
> +
> +#define DRV_NAME	"pata_octeon_cf"
> +#define DRV_VERSION	"2.1"
> +
> +
> +struct octeon_cf_port {
> +	struct workqueue_struct *wq;
> +	struct delayed_work delayed_finish;
> +	struct ata_port *ap;
> +	int dma_finished;
> +};
> +
> +static struct scsi_host_template octeon_cf_sht = {
> +	ATA_PIO_SHT(DRV_NAME),
> +};
> +
> +/**
> + * Convert nanosecond based time to setting used in the
> + * boot bus timing register, based on timing multiple
> + */

There are comments in this file which use the kerneldoc token, but
which aren't in kerneldoc format.

> +static unsigned int ns_to_tim_reg(unsigned int tim_mult, unsigned int nsecs)
> +{
> +	unsigned int val;
> +
> +	/*
> +	 * Compute # of eclock periods to get desired duration in
> +	 * nanoseconds.
> +	 */
> +	val = DIV_ROUND_UP(nsecs * (octeon_get_clock_rate() / 1000000),
> +			  1000 * tim_mult);
> +
> +	return val;
> +}
>

There's great potential for overflows here, but I couldn't be bothered
picking through it.  Are we sure that it's watertight?

There's a 64-bit divide in there.  Will it link on 32-bit platforms?

Or is this all 64-bit-only code?

wtf is an octeon anyway?  (greps).  Some MIPS thing.  I guess it's
64-bit-only.

> +static void octeon_cf_set_boot_reg_cfg(int cs)
> +{
> +	union cvmx_mio_boot_reg_cfgx reg_cfg;
> +	reg_cfg.u64 = cvmx_read_csr(CVMX_MIO_BOOT_REG_CFGX(cs));
> +	reg_cfg.s.dmack = 0;	/* Don't assert DMACK on access */
> +	reg_cfg.s.tim_mult = 2;	/* Timing mutiplier 2x */
> +	reg_cfg.s.rd_dly = 0;	/* Sample on falling edge of BOOT_OE */
> +	reg_cfg.s.sam = 0;	/* Don't combine write and output enable */
> +	reg_cfg.s.we_ext = 0;	/* No write enable extension */
> +	reg_cfg.s.oe_ext = 0;	/* No read enable extension */
> +	reg_cfg.s.en = 1;	/* Enable this region */
> +	reg_cfg.s.orbit = 0;	/* Don't combine with previous region */
> +	reg_cfg.s.ale = 0;	/* Don't do address multiplexing */
> +	cvmx_write_csr(CVMX_MIO_BOOT_REG_CFGX(cs), reg_cfg.u64);
> +}
> +
> +/**
> + * Called after libata determines the needed PIO mode. This
> + * function programs the Octeon bootbus regions to support the
> + * timing requirements of the PIO mode.
> + *
> + * @ap:     ATA port information
> + * @dev:    ATA device
> + */

That's getting more kerneldoccy, but isn't there yet.

> +static void octeon_cf_set_piomode(struct ata_port *ap, struct ata_device *dev)
> +{
> +	struct octeon_cf_data *ocd = ap->dev->platform_data;
> +	union cvmx_mio_boot_reg_timx reg_tim;
> +	int cs = ocd->base_region;
> +	int T;
> +	struct ata_timing timing;
> +
> +	int use_iordy;
> +	int trh;
> +	int pause;
> +	/* These names are timing parameters from the ATA spec */
> +	int t1;
> +	int t2;
> +	int t2i;
> +
> +	T = (int)(2000000000000LL / octeon_get_clock_rate());

64/64 divide.

> +	if (ata_timing_compute(dev, dev->pio_mode, &timing, T, T))
> +		BUG();
> +
> +	t1 = timing.setup;
> +	if (t1)
> +		t1--;
> +	t2 = timing.active;
> +	if (t2)
> +		t2--;
> +	t2i = timing.act8b;
> +	if (t2i)
> +		t2i--;
> +
> +	trh = ns_to_tim_reg(2, 20);
> +	if (trh)
> +		trh--;
> +
> +	pause = timing.cycle - timing.active - timing.setup - trh;
> +	if (pause)
> +		pause--;
> +
> +	octeon_cf_set_boot_reg_cfg(cs);
> +	if (ocd->dma_engine >= 0)
> +		/* True IDE mode, program both chip selects.  */
> +		octeon_cf_set_boot_reg_cfg(cs + 1);
> +
> +
> +	use_iordy = ata_pio_need_iordy(dev);
> +
> +	reg_tim.u64 = cvmx_read_csr(CVMX_MIO_BOOT_REG_TIMX(cs));
> +	/* Disable page mode */
> +	reg_tim.s.pagem = 0;
> +	/* Enable dynamic timing */
> +	reg_tim.s.waitm = use_iordy;
> +	/* Pages are disabled */
> +	reg_tim.s.pages = 0;
> +	/* We don't use multiplexed address mode */
> +	reg_tim.s.ale = 0;
> +	/* Not used */
> +	reg_tim.s.page = 0;
> +	/* Time after IORDY to coninue to assert the data */
> +	reg_tim.s.wait = 0;
> +	/* Time to wait to complete the cycle. */
> +	reg_tim.s.pause = pause;
> +	/* How long to hold after a write to de-assert CE. */
> +	reg_tim.s.wr_hld = trh;
> +	/* How long to wait after a read to de-assert CE. */
> +	reg_tim.s.rd_hld = trh;
> +	/* How long write enable is asserted */
> +	reg_tim.s.we = t2;
> +	/* How long read enable is asserted */
> +	reg_tim.s.oe = t2;
> +	/* Time after CE that read/write starts */
> +	reg_tim.s.ce = ns_to_tim_reg(2, 5);
> +	/* Time before CE that address is valid */
> +	reg_tim.s.adr = 0;
> +
> +	/* Program the bootbus region timing for the data port chip select. */
> +	cvmx_write_csr(CVMX_MIO_BOOT_REG_TIMX(cs), reg_tim.u64);
> +	if (ocd->dma_engine >= 0)
> +		/* True IDE mode, program both chip selects.  */
> +		cvmx_write_csr(CVMX_MIO_BOOT_REG_TIMX(cs + 1), reg_tim.u64);
> +}
> +
>
> ...
>
> +static void octeon_cf_tf_read16(struct ata_port *ap, struct ata_taskfile *tf)
> +{
> +	u16 blob;
> +	/* The base of the registers is at ioaddr.data_addr. */
> +	void __iomem *base = ap->ioaddr.data_addr;
> +
> +	blob = __raw_readw(base + 0xc);

why __raw?

> +	tf->feature = blob >> 8;
> +
> +	blob = __raw_readw(base + 2);
> +	tf->nsect = blob & 0xff;
> +	tf->lbal = blob >> 8;
> +
> +	blob = __raw_readw(base + 4);
> +	tf->lbam = blob & 0xff;
> +	tf->lbah = blob >> 8;
> +
> +	blob = __raw_readw(base + 6);
> +	tf->device = blob & 0xff;
> +	tf->command = blob >> 8;
> +
> +	if (tf->flags & ATA_TFLAG_LBA48) {
> +		if (likely(ap->ioaddr.ctl_addr)) {
> +			iowrite8(tf->ctl | ATA_HOB, ap->ioaddr.ctl_addr);
> +
> +			blob = __raw_readw(base + 0xc);
> +			tf->hob_feature = blob >> 8;
> +
> +			blob = __raw_readw(base + 2);
> +			tf->hob_nsect = blob & 0xff;
> +			tf->hob_lbal = blob >> 8;
> +
> +			blob = __raw_readw(base + 4);
> +			tf->hob_lbam = blob & 0xff;
> +			tf->hob_lbah = blob >> 8;
> +
> +			iowrite8(tf->ctl, ap->ioaddr.ctl_addr);
> +			ap->last_ctl = tf->ctl;
> +		} else {
> +			WARN_ON(1);
> +		}
> +	}
> +}
> +
>
> ...
>
> +static void octeon_cf_dma_setup(struct ata_queued_cmd *qc)
> +{
> +	struct ata_port *ap = qc->ap;
> +	struct octeon_cf_port *cf_port;
> +
> +	cf_port = (struct octeon_cf_port *)ap->private_data;

Unneeded, undesirable cast of void* (multiple instances).

> +	DPRINTK("ENTER\n");
> +	/* issue r/w command */
> +	qc->cursg = qc->sg;
> +	cf_port->dma_finished = 0;
> +	ap->ops->sff_exec_command(ap, &qc->tf);
> +	DPRINTK("EXIT\n");
> +}
> +
>
> ...
>
> +static irqreturn_t octeon_cf_interrupt(int irq, void *dev_instance)
> +{
> +	struct ata_host *host = dev_instance;
> +	struct octeon_cf_port *cf_port;
> +	int i;
> +	unsigned int handled = 0;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&host->lock, flags);

Would spin_lock() suffice here?

> +	DPRINTK("ENTER\n");
> +	for (i = 0; i < host->n_ports; i++) {
> +		u8 status;
> +		struct ata_port *ap;
> +		struct ata_queued_cmd *qc;
> +		union cvmx_mio_boot_dma_intx dma_int;
> +		union cvmx_mio_boot_dma_cfgx dma_cfg;
> +		struct octeon_cf_data *ocd;
> +
> +		ap = host->ports[i];
> +		ocd = ap->dev->platform_data;
> +		if (!ap || (ap->flags & ATA_FLAG_DISABLED))
> +			continue;
> +
> +		ocd = ap->dev->platform_data;
> +		cf_port = (struct octeon_cf_port *)ap->private_data;
> +		dma_int.u64 =
> +			cvmx_read_csr(CVMX_MIO_BOOT_DMA_INTX(ocd->dma_engine));
> +		dma_cfg.u64 =
> +			cvmx_read_csr(CVMX_MIO_BOOT_DMA_CFGX(ocd->dma_engine));
> +
> +		qc = ata_qc_from_tag(ap, ap->link.active_tag);
> +
> +		if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING)) &&
> +		    (qc->flags & ATA_QCFLAG_ACTIVE)) {
> +			if (dma_int.s.done && !dma_cfg.s.en) {
> +				if (!sg_is_last(qc->cursg)) {
> +					qc->cursg = sg_next(qc->cursg);
> +					handled = 1;
> +					octeon_cf_dma_start(qc);
> +					continue;
> +				} else {
> +					cf_port->dma_finished = 1;
> +				}
> +			}
> +			if (!cf_port->dma_finished)
> +				continue;
> +			status = ioread8(ap->ioaddr.altstatus_addr);
> +			if (status & (ATA_BUSY | ATA_DRQ)) {
> +				/*
> +				 * We are busy, try to handle it
> +				 * later.  This is the DMA finished
> +				 * interrupt, and it could take a
> +				 * little while for the card to be
> +				 * ready for more commands.
> +				 */
> +				/* Clear DMA irq. */
> +				dma_int.u64 = 0;
> +				dma_int.s.done = 1;
> +				cvmx_write_csr(CVMX_MIO_BOOT_DMA_INTX(ocd->dma_engine),
> +					       dma_int.u64);
> +
> +				queue_delayed_work(cf_port->wq,
> +						   &cf_port->delayed_finish, 1);
> +				handled = 1;
> +			} else {
> +				handled |= octeon_cf_dma_finished(ap, qc);
> +			}
> +		}
> +	}
> +	spin_unlock_irqrestore(&host->lock, flags);
> +	DPRINTK("EXIT\n");
> +	return IRQ_RETVAL(handled);
> +}
> +
>
> ...
>

