Return-Path: <linux-kernel-owner+w=401wt.eu-S1758746AbXGCRW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbXGCRW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 13:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756408AbXGCRVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 13:21:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:37887 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760511AbXGCRVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 13:21:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=S4GPSjsiwZB4ijcnSD2T0oj0ydvrjTPOU4vxTIhSXEuxNG5t5PNvTo2MoAgnMKG/JMnYNa6TKxa7uBqQzvdwVNsDkHBnQyjgSY3W5Nggw3g9jgN2Vij8i2CG4eaD8L8uFjIJDjmZqwzxcQ9i/C6y8mLkYpuxNUC3aGKT7FzLEwg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] pata_hpt3x3: Major reworking and testing
Date: Tue, 3 Jul 2007 19:38:20 +0200
User-Agent: KMail/1.9.6
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       jeff@garzik.org
References: <20070703161002.1576c39d@the-village.bc.nu>
In-Reply-To: <20070703161002.1576c39d@the-village.bc.nu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707031938.20956.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday 03 July 2007, Alan Cox wrote:
> The HPT343/345 (aka 363) is a bit of a warped device. For many setups you
> need to access the other registers via BAR4 offsets. PIO is now rock

If you happen to have HPT363 you may want to check how BIOS does the DMA
configuration.  I wouldn't be surprised if it turns out that _both_ drivers
do it wrongly currently.

> solid, DMA isn't. Unfortunately the drivers/ide hpt34x driver is
> completely broken so doesn't help further debug.

Translation:

The new improved driver is not really better than the old one because
the old one is broken. :)

Old driver does identical configuration when it comes to PIO modes.

For DMA modes it seem to have bug in setting DMA transfer type bits but DMA
is _never_ enabled unless CONFIG_HPT34X_AUTODMA is set and this config option
is marked EXPERIMENTAL with the help entry stating that enabling DMA is a
dangerous thing to do.

Old driver is a source of PCI quirk which is now propagated to the new driver.

Thanks,
Bart

> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/ata/pata_hpt3x3.c linux-2.6.22-rc6-mm1/drivers/ata/pata_hpt3x3.c
> --- linux.vanilla-2.6.22-rc6-mm1/drivers/ata/pata_hpt3x3.c	2007-07-02 20:50:11.000000000 +0100
> +++ linux-2.6.22-rc6-mm1/drivers/ata/pata_hpt3x3.c	2007-07-02 21:03:32.000000000 +0100
> @@ -23,7 +23,7 @@
>  #include <linux/libata.h>
>  
>  #define DRV_NAME	"pata_hpt3x3"
> -#define DRV_VERSION	"0.4.3"
> +#define DRV_VERSION	"0.5.3"
>  
>  /**
>   *	hpt3x3_set_piomode		-	PIO setup
> @@ -59,6 +59,9 @@
>   *
>   *	Set up the channel for MWDMA or UDMA modes. Much the same as with
>   *	PIO, load the mode number and then set MWDMA or UDMA flag.
> + *
> + *	0x44 : bit 0-2 master mode, 3-5 slave mode, etc 
> + *	0x48 : bit 4/0 DMA/UDMA bit 5/1 for slave etc
>   */
>  
>  static void hpt3x3_set_dmamode(struct ata_port *ap, struct ata_device *adev)
> @@ -76,14 +79,26 @@
>  	r2 &= ~(0x11 << dn);	/* Clear MWDMA and UDMA bits */
>  
>  	if (adev->dma_mode >= XFER_UDMA_0)
> -		r2 |= 0x01 << dn;	/* Ultra mode */
> +		r2 |= (0x10 << dn);	/* Ultra mode */
>  	else
> -		r2 |= 0x10 << dn;	/* MWDMA */
> +		r2 |= (0x01 << dn);	/* MWDMA */
>  
>  	pci_write_config_dword(pdev, 0x44, r1);
>  	pci_write_config_dword(pdev, 0x48, r2);
>  }
>  
> +/**
> + *	hpt3x3_atapi_dma	-	ATAPI DMA check
> + *	@qc: Queued command
> + *
> + *	Just say no - we don't do ATAPI DMA
> + */
> +
> +static int hpt3x3_atapi_dma(struct ata_queued_cmd *qc)
> +{
> +	return 1;
> +}
> +
>  static struct scsi_host_template hpt3x3_sht = {
>  	.module			= THIS_MODULE,
>  	.name			= DRV_NAME,
> @@ -105,7 +120,6 @@
>  static struct ata_port_operations hpt3x3_port_ops = {
>  	.port_disable	= ata_port_disable,
>  	.set_piomode	= hpt3x3_set_piomode,
> -	.set_dmamode	= hpt3x3_set_dmamode,
>  	.mode_filter	= ata_pci_default_filter,
>  
>  	.tf_load	= ata_tf_load,
> @@ -124,8 +138,9 @@
>  	.bmdma_start 	= ata_bmdma_start,
>  	.bmdma_stop	= ata_bmdma_stop,
>  	.bmdma_status 	= ata_bmdma_status,
> +	.check_atapi_dma= hpt3x3_atapi_dma,
>  
> -	.qc_prep 	= ata_qc_prep,
> +	.qc_prep 	= ata_qc_prep,
>  	.qc_issue	= ata_qc_issue_prot,
>  
>  	.data_xfer	= ata_data_xfer,
> @@ -158,32 +173,79 @@
>  		pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x20);
>  }
>  
> -
>  /**
>   *	hpt3x3_init_one		-	Initialise an HPT343/363
> - *	@dev: PCI device
> + *	@pdev: PCI device
>   *	@id: Entry in match table
>   *
> - *	Perform basic initialisation. The chip has a quirk that it won't
> - *	function unless it is at XX00. The old ATA driver touched this up
> - *	but we leave it for pci quirks to do properly.
> + *	Perform basic initialisation. We set the device up so we access all
> + *	ports via BAR4. This is neccessary to work around errata.
>   */
>  
> -static int hpt3x3_init_one(struct pci_dev *dev, const struct pci_device_id *id)
> +static int hpt3x3_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
>  {
> +	static int printed_version;
>  	static const struct ata_port_info info = {
>  		.sht = &hpt3x3_sht,
>  		.flags = ATA_FLAG_SLAVE_POSS,
>  		.pio_mask = 0x1f,
> +#if defined(CONFIG_PATA_HPT3X3_DMA)
> +		/* Further debug needed */		
>  		.mwdma_mask = 0x07,
>  		.udma_mask = 0x07,
> +#endif		
>  		.port_ops = &hpt3x3_port_ops
>  	};
> +	/* Register offsets of taskfiles in BAR4 area */
> +	static const u8 offset_cmd[2] = { 0x20, 0x28 };
> +	static const u8 offset_ctl[2] = { 0x36, 0x3E };
>  	const struct ata_port_info *ppi[] = { &info, NULL };
> -
> -	hpt3x3_init_chipset(dev);
> -	/* Now kick off ATA set up */
> -	return ata_pci_init_one(dev, ppi);
> +	struct ata_host *host;
> +	int i, rc;
> +	void __iomem *base;
> +
> +	hpt3x3_init_chipset(pdev);
> +
> +	if (!printed_version++)
> +		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
> +
> +	host = ata_host_alloc_pinfo(&pdev->dev, ppi, 2);
> +	if (!host)
> +		return -ENOMEM;
> +	/* acquire resources and fill host */
> +	rc = pcim_enable_device(pdev);
> +	if (rc)
> +		return rc;
> +
> +	/* Everything is relative to BAR4 if we set up this way */
> +	rc = pcim_iomap_regions(pdev, 1 << 4, DRV_NAME);
> +	if (rc == -EBUSY)
> +		pcim_pin_device(pdev);
> +	if (rc)
> +		return rc;
> +	host->iomap = pcim_iomap_table(pdev);
> +	rc = pci_set_dma_mask(pdev, ATA_DMA_MASK);
> +	if (rc)
> +		return rc;
> +	rc = pci_set_consistent_dma_mask(pdev, ATA_DMA_MASK);
> +	if (rc)
> +		return rc;
> +
> +	base = host->iomap[4];	/* Bus mastering base */
> +
> +	for (i = 0; i < host->n_ports; i++) {
> +		struct ata_ioports *ioaddr = &host->ports[i]->ioaddr;
> +
> +		ioaddr->cmd_addr = base + offset_cmd[i];
> +		ioaddr->altstatus_addr =
> +		ioaddr->ctl_addr = base + offset_ctl[i];
> +		ioaddr->scr_addr = NULL;
> +		ata_std_ports(ioaddr);
> +		ioaddr->bmdma_addr = base + 8 * i;
> +	}
> +	pci_set_master(pdev);
> +	return ata_host_activate(host, pdev->irq, ata_interrupt, IRQF_SHARED,
> +				 &hpt3x3_sht);
>  }
>  
>  #ifdef CONFIG_PM
> diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/ata/Kconfig linux-2.6.22-rc6-mm1/drivers/ata/Kconfig
> --- linux.vanilla-2.6.22-rc6-mm1/drivers/ata/Kconfig	2007-07-02 20:50:11.000000000 +0100
> +++ linux-2.6.22-rc6-mm1/drivers/ata/Kconfig	2007-07-02 21:02:10.000000000 +0100
> @@ -313,7 +313,7 @@
>  	  If unsure, say N.
>  
>  config PATA_HPT3X3
> -	tristate "HPT 343/363 PATA support (Experimental)"
> +	tristate "HPT 343/363 PATA support"
>  	depends on PCI
>  	help
>  	  This option enables support for the HPT 343/363
> @@ -321,6 +321,14 @@
>  
>  	  If unsure, say N.
>  
> +config PATA_HPT3X3_DMA
> +	bool "HPT 343/363 DMA support (Experimental)"
> +	depends on PATA_HPT3X3
> +	help
> +	  This option enables DMA support for the HPT343/363
> +	  controllers. Enable with care as there are still some
> +	  problems with DMA on this chipset.
> +
>  config PATA_ISAPNP
>  	tristate "ISA Plug and Play PATA support (Experimental)"
>  	depends on EXPERIMENTAL && ISAPNP
