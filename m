Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbZIMAz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbZIMAz6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 20:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbZIMAzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 20:55:55 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34852 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036AbZIMAzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 20:55:53 -0400
Message-ID: <4AAC4315.6010102@pobox.com>
Date: Sat, 12 Sep 2009 20:55:49 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Jung-Ik (John) Lee" <jilee@google.com>
CC: Robert Hancock <hancockrwd@gmail.com>, Daniel Walker <dwalker@fifo99.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Grant Grundler <grundler@google.com>,
       Gwendal Grignou <gwendal@google.com>, Eric Uhrhane <ericu@google.com>
Subject: Re: [PATCH] libata: Add pata_atp867x driver for Artop/Acard ATP867X
 	controllers
References: <8b5805ff0909111906j68c20c3yf7226f2798a67d80@mail.gmail.com> 	<1252721641.28368.34.camel@desktop> <8b5805ff0909120359g2faf661br463b19518d935110@mail.gmail.com> 	<4AABD122.2000400@gmail.com> <8b5805ff0909121717w1516c273k2a568779b9c31662@mail.gmail.com> <8b5805ff0909121726g2f1a78c1o1ff7289e059eabe5@mail.gmail.com>
In-Reply-To: <8b5805ff0909121726g2f1a78c1o1ff7289e059eabe5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



General comment:

* since you use iomap to map the region, you should use ioread{8,16,32} 
/ iowrite{8,16,32} accessors.  Do not use inb/outb/inl/outl/etc.

* run through scripts/checkpatch.pl


On 09/12/2009 08:26 PM, Jung-Ik (John) Lee wrote:
> +/*
> + * IO Registers
> + * Note that all runtime hot ports are cached in ap private_data
> + */
> +
> +#define ATP867X_IO_CHANNEL_OFFSET	0x10
> +#define ATP867X_IOBASE(d)		pci_resource_start((d), 0)
> +#define ATP867X_SYS_INFO(d)		(0x3F + ATP867X_IOBASE(d))
> +
> +#define ATP867X_IO_PORTBASE(d, port)	(0x00 + ATP867X_IOBASE(d) + \
> +					(port) * ATP867X_IO_CHANNEL_OFFSET)
> +#define ATP867X_IO_DMABASE(d, port)	(0x40 + \
> +					ATP867X_IO_PORTBASE((d), (port)))
> +
> +#define ATP867X_IO_STATUS(d, port)	(0x07 + \
> +					ATP867X_IO_PORTBASE((d), (port)))
> +#define ATP867X_IO_ALTSTATUS(d, port)	(0x0E + \
> +					ATP867X_IO_PORTBASE((d), (port)))
> +
> +#define ATP867X_IO_MSTRPIOSPD(d, port)	(0x08 + ATP867X_IO_DMABASE((d), (port)))
> +#define ATP867X_IO_SLAVPIOSPD(d, port)	(0x09 + ATP867X_IO_DMABASE((d), (port)))
> +#define ATP867X_IO_8BPIOSPD(d, port)	(0x0A + ATP867X_IO_DMABASE((d), (port)))
> +#define ATP867X_IO_DMAMODE(d, port)	(0x0B + ATP867X_IO_DMABASE((d), (port)))
> +
> +#define ATP867X_IO_PORTSPEED(d, port)	(0x4A + \
> +					ATP867X_IO_PORTBASE((d), (port)))
> +#define ATP867X_IO_PREREAD(d, port)	(0x4C + \
> +					ATP867X_IO_PORTBASE((d), (port)))
> +
> +/*
> + * IO Register Bitfields
> + */
> +
> +#define ATP867X_IO_PIOSPD_ACTIVE_SHIFT	4
> +#define ATP867X_IO_PIOSPD_RECOVER_SHIFT	0
> +
> +#define ATP867X_IO_DMAMODE_MSTR_SHIFT	0
> +#define ATP867X_IO_DMAMODE_MSTR_MASK	0x07
> +#define ATP867X_IO_DMAMODE_SLAVE_SHIFT	4
> +#define ATP867X_IO_DMAMODE_SLAVE_MASK	0x70
> +
> +#define ATP867X_IO_DMAMODE_UDMA_6	0x07
> +#define ATP867X_IO_DMAMODE_UDMA_5	0x06
> +#define ATP867X_IO_DMAMODE_UDMA_4	0x05
> +#define ATP867X_IO_DMAMODE_UDMA_3	0x04
> +#define ATP867X_IO_DMAMODE_UDMA_2	0x03
> +#define ATP867X_IO_DMAMODE_UDMA_1	0x02
> +#define ATP867X_IO_DMAMODE_UDMA_0	0x01
> +#define ATP867X_IO_DMAMODE_DISABLE	0x00
> +
> +#define ATP867X_IO_SYS_INFO_66MHZ	0x04
> +#define ATP867X_IO_SYS_INFO_SLOW_UDMA5	0x02
> +#define ATP867X_IO_SYS_MASK_RESERVED	(~0xf1)
> +
> +#define ATP867X_IO_PORTSPEED_VAL	0x1143
> +#define ATP867X_PREREAD_VAL		0x0200
> +
> +#define ATP867X_NUM_PORTS		4
> +#define ATP867X_BAR_IOBASE		0
> +#define ATP867X_BAR_ROMBASE		6

enums are the preferred method of creating named constants.  This 
potentially makes the code more readable in the debugger, imparts type 
information with the constant, and makes CPP output more readable.  eg.

enum {
	ATP867X_NUM_PORTS		= 4,
	ATP867X_BAR_IOBASE		= 0,
};

> +struct atp867x_priv {
> +	unsigned long	dma_mode;
> +	unsigned long	mstr_piospd;
> +	unsigned long	slave_piospd;
> +	unsigned long	eightb_piospd;
> +	int		pci66mhz;
> +};
> +
> +
> +static void atp867x_set_dmamode(struct ata_port *ap, struct ata_device *adev)
> +{
> +	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
> +	struct atp867x_priv *dp = ap->private_data;
> +	u8 speed = adev->dma_mode;
> +	u8 b;
> +	u8 mode;
> +
> +
> +	switch (speed) {
> +	case XFER_UDMA_6:
> +		mode = ATP867X_IO_DMAMODE_UDMA_6;
> +		break;
> +	case XFER_UDMA_5:
> +		mode = ATP867X_IO_DMAMODE_UDMA_5;
> +		break;
> +	case XFER_UDMA_4:
> +		mode = ATP867X_IO_DMAMODE_UDMA_4;
> +		break;
> +	case XFER_UDMA_3:
> +		mode = ATP867X_IO_DMAMODE_UDMA_3;
> +		break;
> +	case XFER_UDMA_2:
> +		mode = ATP867X_IO_DMAMODE_UDMA_2;
> +		break;
> +	case XFER_UDMA_1:
> +		mode = ATP867X_IO_DMAMODE_UDMA_1;
> +		break;
> +	case XFER_UDMA_0:
> +		mode = ATP867X_IO_DMAMODE_UDMA_0;
> +		break;
> +	default:
> +		printk(KERN_WARNING "ATP867X: Unsupported speed %#x."
> +			" Default to XFER_UDMA_0.\n", (unsigned)speed);
> +		mode = ATP867X_IO_DMAMODE_UDMA_0;

a table would be nice, preferred over a switch statement.  You may use 
ARRAY_SIZE() macro to generate a constant at compile time for number of 
elements in array.


> +
> +	/*
> +	 * Doc 6.6.9: decrease the udma mode value by 1 for safer UDMA speed
> +	 * on 66MHz bus
> +	 *   rev-A: UDMA_1~4 (5, 6 no change)
> +	 *   rev-B: all UDMA modes
> +	 *   UDMA_0 stays not to disable UDMA
> +	 */
> +	if (dp->pci66mhz&&  mode>  ATP867X_IO_DMAMODE_UDMA_0&&
> +	   (pdev->device == PCI_DEVICE_ID_ARTOP_ATP867B ||
> +	    mode<  ATP867X_IO_DMAMODE_UDMA_5))
> +		mode--;
> +
> +	b = inb(dp->dma_mode);
> +	if (adev->devno&  1) {
> +		b = (b&  ~ATP867X_IO_DMAMODE_SLAVE_MASK) |
> +			(mode<<  ATP867X_IO_DMAMODE_SLAVE_SHIFT);
> +	} else {
> +		b = (b&  ~ATP867X_IO_DMAMODE_MSTR_MASK) |
> +			(mode<<  ATP867X_IO_DMAMODE_MSTR_SHIFT);

add whitespace between all tokens, eg. surrounding "&&" and ">" and "&" 
operators


> +	}
> +	outb(b, dp->dma_mode);
> +}
> +
> +static int atp867x_get_active_clocks_shifted(unsigned int clk)
> +{
> +	unsigned char clocks = clk;
> +
> +	switch (clocks) {
> +	case 0:
> +		clocks = 1;
> +		break;
> +	case 1 ... 7:
> +		break;
> +	case 8 ... 12:
> +		clocks = 7;
> +		break;
> +	default:
> +		printk(KERN_WARNING "ATP867X: active %dclk is invalid. "
> +			"Using default 8clk.\n", clk);
> +		clocks = 0;	/* 8 clk */
> +		break;
> +	}
> +	return clocks<<  ATP867X_IO_PIOSPD_ACTIVE_SHIFT;
> +}
> +
> +static int atp867x_get_recover_clocks_shifted(unsigned int clk)
> +{
> +	unsigned char clocks = clk;
> +
> +	switch (clocks) {
> +	case 0:
> +		clocks = 1;
> +		break;
> +	case 1 ... 11:
> +		break;
> +	case 12:
> +		clocks = 0;
> +		break;
> +	case 13: case 14:
> +		--clocks;
> +		break;
> +	case 15:
> +		break;
> +	default:
> +		printk(KERN_WARNING "ATP867X: recover %dclk is invalid. "
> +			"Using default 15clk.\n", clk);
> +		clocks = 0;	/* 12 clk */
> +		break;
> +	}
> +	return clocks<<  ATP867X_IO_PIOSPD_RECOVER_SHIFT;

whitespace between all tokens

> +static void atp867x_set_piomode(struct ata_port *ap, struct ata_device *adev)
> +{
> +	struct ata_device *peer = ata_dev_pair(adev);
> +	struct atp867x_priv *dp = ap->private_data;
> +	u8 speed = adev->pio_mode;
> +	struct ata_timing t, p;
> +	int T, UT;
> +	u8 b;
> +
> +	T = 1000000000 / 33333;
> +	UT = T/4;

ditto


> +	switch (speed) {
> +	case XFER_PIO_4:
> +	case XFER_PIO_3:
> +	case XFER_PIO_2:
> +	case XFER_PIO_1:
> +	case XFER_PIO_0:
> +	case XFER_PIO_SLOW:
> +		break;
> +	default:
> +		printk(KERN_WARNING "ATP867X: Unsupported speed %#x."
> +			" Default to XFER_PIO_0.\n", (unsigned)speed);
> +		speed = XFER_PIO_0;

unsupported speeds are masked out via ata_port_info.  no need for 
additional checks.


> +	ata_timing_compute(adev, speed,&t, T, UT);
> +	if (peer&&  peer->pio_mode) {
> +		ata_timing_compute(peer, peer->pio_mode,&p, T, UT);
> +		ata_timing_merge(&p,&t,&t, ATA_TIMING_8BIT);
> +	}
> +
> +	b = inb(dp->dma_mode);
> +	if (adev->devno&  1)
> +		b = (b&  ~ATP867X_IO_DMAMODE_SLAVE_MASK);
> +	else
> +		b = (b&  ~ATP867X_IO_DMAMODE_MSTR_MASK);
> +	outb(b, dp->dma_mode);
> +
> +	b = atp867x_get_active_clocks_shifted(t.active) |
> +		atp867x_get_recover_clocks_shifted(t.recover);
> +	if (dp->pci66mhz)
> +		b += 0x10;
> +
> +	if (adev->devno&  1)
> +		outb(b, dp->slave_piospd);
> +	else
> +		outb(b, dp->mstr_piospd);
> +
> +	/*
> +	 * use the same value for comand timing as for PIO timimg
> +	 */
> +	outb(b, dp->eightb_piospd);

whitespace + ioread/iowrite


> +static int atp867x_cable_detect(struct ata_port *ap)
> +{
> +	return ATA_CBL_PATA40_SHORT;
> +}
> +
> +static struct scsi_host_template atp867x_sht = {
> +	ATA_BMDMA_SHT(DRV_NAME),
> +};
> +
> +static struct ata_port_operations atp867x_ops = {
> +	.inherits		=&ata_bmdma_port_ops,
> +	.cable_detect		= atp867x_cable_detect,
> +	.set_piomode		= atp867x_set_piomode,
> +	.set_dmamode		= atp867x_set_dmamode,
> +};
> +
> +
> +#ifdef	ATP867X_DEBUG
> +static void atp867x_check_res(struct pci_dev *pdev)
> +{
> +	int i;
> +	unsigned long start, len;
> +
> +	/* Check the PCI resources for this channel are enabled */
> +	for (i = 0; i<  DEVICE_COUNT_RESOURCE; i++) {
> +		start = pci_resource_start(pdev, i);
> +		len   = pci_resource_len(pdev, i);
> +		printk(KERN_DEBUG "ATP867X: resource start:len=%lx:%lx\n",
> +			start, len);
> +	}
> +}
> +
> +static void atp867x_check_ports(struct ata_port *ap, struct pci_dev *pdev)
> +{
> +	struct ata_ioports *ioaddr =&ap->ioaddr;
> +	struct atp867x_priv *dp = ap->private_data;
> +	int port = ap->port_no;
> +
> +	printk(KERN_DEBUG "ATP867X: port[%d] addresses\n"
> +		"  cmd_addr	=0x%llx, 0x%llx\n"
> +		"  ctl_addr	=0x%llx, 0x%llx\n"
> +		"  bmdma_addr	=0x%llx, 0x%llx\n"
> +		"  data_addr	=0x%llx\n"
> +		"  error_addr	=0x%llx\n"
> +		"  feature_addr	=0x%llx\n"
> +		"  nsect_addr	=0x%llx\n"
> +		"  lbal_addr	=0x%llx\n"
> +		"  lbam_addr	=0x%llx\n"
> +		"  lbah_addr	=0x%llx\n"
> +		"  device_addr	=0x%llx\n"
> +		"  status_addr	=0x%llx\n"
> +		"  command_addr	=0x%llx\n"
> +		"  dp->dma_mode	=0x%llx\n"
> +		"  dp->mstr_piospd	=0x%llx\n"
> +		"  dp->slave_piospd	=0x%llx\n"
> +		"  dp->eightb_piospd	=0x%llx\n",
> +		port,
> +		(unsigned long long)ioaddr->cmd_addr,
> +			ATP867X_IO_PORTBASE(pdev, port),
> +		(unsigned long long)ioaddr->ctl_addr,
> +			ATP867X_IO_ALTSTATUS(pdev, port),
> +		(unsigned long long)ioaddr->bmdma_addr,
> +			ATP867X_IO_DMABASE(pdev, port),
> +		(unsigned long long)ioaddr->data_addr,
> +		(unsigned long long)ioaddr->error_addr,
> +		(unsigned long long)ioaddr->feature_addr,
> +		(unsigned long long)ioaddr->nsect_addr,
> +		(unsigned long long)ioaddr->lbal_addr,
> +		(unsigned long long)ioaddr->lbam_addr,
> +		(unsigned long long)ioaddr->lbah_addr,
> +		(unsigned long long)ioaddr->device_addr,
> +		(unsigned long long)ioaddr->status_addr,
> +		(unsigned long long)ioaddr->command_addr,
> +		(unsigned long long)dp->dma_mode,
> +		(unsigned long long)dp->mstr_piospd,
> +		(unsigned long long)dp->slave_piospd,
> +		(unsigned long long)dp->eightb_piospd);
> +}
> +#endif
> +
> +static inline void atp867x_get_ports(struct pci_dev *dev, unsigned int port,
> +	unsigned long *base, unsigned long *control)
> +{
> +	*base = ATP867X_IO_PORTBASE(dev, port);
> +	*control = ATP867X_IO_ALTSTATUS(dev, port);
> +}
> +
> +static inline unsigned long atp867x_get_dma_base(struct pci_dev *dev,
> +	unsigned int port)
> +{
> +	return ATP867X_IO_DMABASE(dev, port);
> +}
> +
> +static int atp867x_set_priv(struct ata_port *ap)
> +{
> +	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
> +	struct atp867x_priv *dp;
> +	int port = ap->port_no;
> +
> +	dp = ap->private_data =
> +		devm_kzalloc(&pdev->dev, sizeof(*dp), GFP_KERNEL);
> +	if (dp == NULL)
> +		return -ENOMEM;
> +
> +	dp->dma_mode	 = ATP867X_IO_DMAMODE(pdev, port);
> +	dp->mstr_piospd	 = ATP867X_IO_MSTRPIOSPD(pdev, port);
> +	dp->slave_piospd = ATP867X_IO_SLAVPIOSPD(pdev, port);
> +	dp->eightb_piospd = ATP867X_IO_8BPIOSPD(pdev, port);
> +
> +	dp->pci66mhz = inb(ATP867X_SYS_INFO(pdev))&  ATP867X_IO_SYS_INFO_66MHZ;
> +
> +	return 0;
> +}
> +
> +static int atp867x_ata_pci_sff_init_host(struct ata_host *host)
> +{
> +	struct device *gdev = host->dev;
> +	struct pci_dev *pdev = to_pci_dev(gdev);
> +	unsigned int mask = 0;
> +	int i, rc;
> +
> +	/*
> +	 * do not map rombase
> +	 */
> +	rc = pcim_iomap_regions(pdev, 1<<  ATP867X_BAR_IOBASE, DRV_NAME);
> +	if (rc == -EBUSY)
> +		pcim_pin_device(pdev);
> +	if (rc)
> +		return rc;
> +	host->iomap = pcim_iomap_table(pdev);
> +
> +#ifdef	ATP867X_DEBUG
> +	atp867x_check_res(pdev);
> +
> +	for (i = 0; i<  PCI_ROM_RESOURCE; i++)
> +		printk(KERN_DEBUG "ATP867X: iomap[%d]=0x%llx\n", i,
> +			(unsigned long long)(host->iomap[i]));
> +#endif
> +
> +	/*
> +	 * request, iomap BARs and init port addresses accordingly
> +	 */
> +	for (i = 0; i<  host->n_ports; i++) {
> +		unsigned long base, control, dmabase;
> +		struct ata_port *ap = host->ports[i];
> +		struct ata_ioports *ioaddr =&ap->ioaddr;
> +
> +		atp867x_get_ports(pdev, i,&base,&control);
> +		dmabase = atp867x_get_dma_base(pdev, i);
> +
> +		ioaddr->cmd_addr = devm_ioport_map(gdev, base, 8);
> +		ioaddr->ctl_addr = ioaddr->altstatus_addr =
> +				devm_ioport_map(gdev, control, 1);
> +		ioaddr->bmdma_addr = devm_ioport_map(gdev, dmabase, 8);

why are you mapping separately from pcim_iomap_regions?

Just do the mapping all at once, with pcim_iomap_regions, then simply 
calculate addresses in the n_ports loop.




> +	rc = pcim_enable_device(pdev);
> +	if (rc)
> +		return rc;
> +
> +	/*
> +	 * Broken BIOS might not set latency high enough
> +	 */
> +	pci_read_config_byte(pdev, PCI_LATENCY_TIMER,&v);
> +	if (v<  0x80) {
> +		v = 0x80;
> +		pci_write_config_byte(pdev, PCI_LATENCY_TIMER, v);
> +		printk(KERN_DEBUG "ATP867X: set latency timer of device %s"
> +			" to %d\n", pci_name(pdev), v);
> +	}

this seems pointless - pci_set_master() already does this

