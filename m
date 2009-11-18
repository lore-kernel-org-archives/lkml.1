Return-Path: <linux-kernel-owner+w=401wt.eu-S932176AbZKRTfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176AbZKRTfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 14:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbZKRTfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 14:35:50 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:55221 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158AbZKRTfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 14:35:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=RZk2znBbDr1DXkHpjtEN4esskvotI0qwDdgrxTsf2Hr8jPQJ/NMj4OLFHXtyXu8RT4
         mGxApj+8FnM/AB8Fka+Oj2GbYpu5uP+zFPqzQlCtRsAIWzNlmF5+F56uQGJ8B7pfIblE
         bijWdbUUfi6OgOkyExKzGE1O9N0t48ix2hAlk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 4/5] pata: Update experimental tags
Date: Wed, 18 Nov 2009 20:34:19 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20091117144450.15430.83450.stgit@localhost.localdomain> <200911181919.19127.bzolnier@gmail.com> <20091118184125.623e063d@lxorguk.ukuu.org.uk>
In-Reply-To: <20091118184125.623e063d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911182034.19785.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 November 2009 19:41:25 Alan Cox wrote:

> > PCI IDs which make detection across multiple drivers extremely painful) and
> > confusion (i.e. would you have guessed that HPT302 is supported by pata_hpt37x
> > while HPT302N by pata_hpt3x2n?).
> 
> I love highpoint too for their ever weirder and more confusingly labelled
> and identified chips. I still think the split is worth it, and the 'wtf
> device am I' logic is needed in both cases - either to pick a driver or
> pick a set of methods.

While in case of pata_hpt366.c it doesn't look that bad in case of two other
drivers it does..

pata_hpt366.c:
...
/**
 *	hpt36x_init_one		-	Initialise an HPT366/368
 *	@dev: PCI device
 *	@id: Entry in match table
 *
 *	Initialise an HPT36x device. There are some interesting complications
 *	here. Firstly the chip may report 366 and be one of several variants.
 *	Secondly all the timings depend on the clock for the chip which we must
 *	detect and look up
 *
 *	This is the known chip mappings. It may be missing a couple of later
 *	releases.
 *
 *	Chip version		PCI		Rev	Notes
 *	HPT366			4 (HPT366)	0	UDMA66
 *	HPT366			4 (HPT366)	1	UDMA66
 *	HPT368			4 (HPT366)	2	UDMA66
 *	HPT37x/30x		4 (HPT366)	3+	Other driver
 *
 */

static int hpt36x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
{
	static const struct ata_port_info info_hpt366 = {
		.flags = ATA_FLAG_SLAVE_POSS,
		.pio_mask = ATA_PIO4,
		.mwdma_mask = ATA_MWDMA2,
		.udma_mask = ATA_UDMA4,
		.port_ops = &hpt366_port_ops
	};
	const struct ata_port_info *ppi[] = { &info_hpt366, NULL };

	void *hpriv = NULL;
	u32 class_rev;
	u32 reg1;
	int rc;

	rc = pcim_enable_device(dev);
	if (rc)
		return rc;

	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class_rev);
	class_rev &= 0xFF;

	/* May be a later chip in disguise. Check */
	/* Newer chips are not in the HPT36x driver. Ignore them */
	if (class_rev > 2)
			return -ENODEV;
...

pata_hpt37x.c:
...
/**
 *	hpt37x_init_one		-	Initialise an HPT37X/302
 *	@dev: PCI device
 *	@id: Entry in match table
 *
 *	Initialise an HPT37x device. There are some interesting complications
 *	here. Firstly the chip may report 366 and be one of several variants.
 *	Secondly all the timings depend on the clock for the chip which we must
 *	detect and look up
 *
 *	This is the known chip mappings. It may be missing a couple of later
 *	releases.
 *
 *	Chip version		PCI		Rev	Notes
 *	HPT366			4 (HPT366)	0	Other driver
 *	HPT366			4 (HPT366)	1	Other driver
 *	HPT368			4 (HPT366)	2	Other driver
 *	HPT370			4 (HPT366)	3	UDMA100
 *	HPT370A			4 (HPT366)	4	UDMA100
 *	HPT372			4 (HPT366)	5	UDMA133 (1)
 *	HPT372N			4 (HPT366)	6	Other driver
 *	HPT372A			5 (HPT372)	1	UDMA133 (1)
 *	HPT372N			5 (HPT372)	2	Other driver
 *	HPT302			6 (HPT302)	1	UDMA133
 *	HPT302N			6 (HPT302)	2	Other driver
 *	HPT371			7 (HPT371)	*	UDMA133
 *	HPT374			8 (HPT374)	*	UDMA133 4 channel
 *	HPT372N			9 (HPT372N)	*	Other driver
 *
 *	(1) UDMA133 support depends on the bus clock
 */

static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
{
	/* HPT370 - UDMA100 */
	static const struct ata_port_info info_hpt370 = {
		.flags = ATA_FLAG_SLAVE_POSS,
		.pio_mask = ATA_PIO4,
		.mwdma_mask = ATA_MWDMA2,
		.udma_mask = ATA_UDMA5,
		.port_ops = &hpt370_port_ops
	};
	/* HPT370A - UDMA100 */
	static const struct ata_port_info info_hpt370a = {
		.flags = ATA_FLAG_SLAVE_POSS,
		.pio_mask = ATA_PIO4,
		.mwdma_mask = ATA_MWDMA2,
		.udma_mask = ATA_UDMA5,
		.port_ops = &hpt370a_port_ops
	};
	/* HPT370 - UDMA100 */
	static const struct ata_port_info info_hpt370_33 = {
		.flags = ATA_FLAG_SLAVE_POSS,
		.pio_mask = ATA_PIO4,
		.mwdma_mask = ATA_MWDMA2,
		.udma_mask = ATA_UDMA5,
		.port_ops = &hpt370_port_ops
	};
	/* HPT370A - UDMA100 */
	static const struct ata_port_info info_hpt370a_33 = {
		.flags = ATA_FLAG_SLAVE_POSS,
		.pio_mask = ATA_PIO4,
		.mwdma_mask = ATA_MWDMA2,
		.udma_mask = ATA_UDMA5,
		.port_ops = &hpt370a_port_ops
	};
	/* HPT371, 372 and friends - UDMA133 */
	static const struct ata_port_info info_hpt372 = {
		.flags = ATA_FLAG_SLAVE_POSS,
		.pio_mask = ATA_PIO4,
		.mwdma_mask = ATA_MWDMA2,
		.udma_mask = ATA_UDMA6,
		.port_ops = &hpt372_port_ops
	};
	/* HPT374 - UDMA100, function 1 uses different prereset method */
	static const struct ata_port_info info_hpt374_fn0 = {
		.flags = ATA_FLAG_SLAVE_POSS,
		.pio_mask = ATA_PIO4,
		.mwdma_mask = ATA_MWDMA2,
		.udma_mask = ATA_UDMA5,
		.port_ops = &hpt372_port_ops
	};
	static const struct ata_port_info info_hpt374_fn1 = {
		.flags = ATA_FLAG_SLAVE_POSS,
		.pio_mask = ATA_PIO4,
		.mwdma_mask = ATA_MWDMA2,
		.udma_mask = ATA_UDMA5,
		.port_ops = &hpt374_fn1_port_ops
	};

	static const int MHz[4] = { 33, 40, 50, 66 };
	void *private_data = NULL;
	const struct ata_port_info *ppi[] = { NULL, NULL };

	u8 irqmask;
	u32 class_rev;
	u8 mcr1;
	u32 freq;
	int prefer_dpll = 1;

	unsigned long iobase = pci_resource_start(dev, 4);

	const struct hpt_chip *chip_table;
	int clock_slot;
	int rc;

	rc = pcim_enable_device(dev);
	if (rc)
		return rc;

	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class_rev);
	class_rev &= 0xFF;

	if (dev->device == PCI_DEVICE_ID_TTI_HPT366) {
		/* May be a later chip in disguise. Check */
		/* Older chips are in the HPT366 driver. Ignore them */
		if (class_rev < 3)
			return -ENODEV;
		/* N series chips have their own driver. Ignore */
		if (class_rev == 6)
			return -ENODEV;

		switch(class_rev) {
			case 3:
				ppi[0] = &info_hpt370;
				chip_table = &hpt370;
				prefer_dpll = 0;
				break;
			case 4:
				ppi[0] = &info_hpt370a;
				chip_table = &hpt370a;
				prefer_dpll = 0;
				break;
			case 5:
				ppi[0] = &info_hpt372;
				chip_table = &hpt372;
				break;
			default:
				printk(KERN_ERR "pata_hpt37x: Unknown HPT366 subtype please report (%d).\n", class_rev);
				return -ENODEV;
		}
	} else {
		switch(dev->device) {
			case PCI_DEVICE_ID_TTI_HPT372:
				/* 372N if rev >= 2*/
				if (class_rev >= 2)
					return -ENODEV;
				ppi[0] = &info_hpt372;
				chip_table = &hpt372a;
				break;
			case PCI_DEVICE_ID_TTI_HPT302:
				/* 302N if rev > 1 */
				if (class_rev > 1)
					return -ENODEV;
				ppi[0] = &info_hpt372;
				/* Check this */
				chip_table = &hpt302;
				break;
			case PCI_DEVICE_ID_TTI_HPT371:
				if (class_rev > 1)
					return -ENODEV;
				ppi[0] = &info_hpt372;
				chip_table = &hpt371;
				/* Single channel device, master is not present
				   but the BIOS (or us for non x86) must mark it
				   absent */
				pci_read_config_byte(dev, 0x50, &mcr1);
				mcr1 &= ~0x04;
				pci_write_config_byte(dev, 0x50, mcr1);
				break;
			case PCI_DEVICE_ID_TTI_HPT374:
				chip_table = &hpt374;
				if (!(PCI_FUNC(dev->devfn) & 1))
					*ppi = &info_hpt374_fn0;
				else
					*ppi = &info_hpt374_fn1;
				break;
			default:
				printk(KERN_ERR "pata_hpt37x: PCI table is bogus please report (%d).\n", dev->device);
				return -ENODEV;
		}
	}
...

pata_hpt3x2n.c:
...
/**
 *	hpt3x2n_init_one		-	Initialise an HPT37X/302
 *	@dev: PCI device
 *	@id: Entry in match table
 *
 *	Initialise an HPT3x2n device. There are some interesting complications
 *	here. Firstly the chip may report 366 and be one of several variants.
 *	Secondly all the timings depend on the clock for the chip which we must
 *	detect and look up
 *
 *	This is the known chip mappings. It may be missing a couple of later
 *	releases.
 *
 *	Chip version		PCI		Rev	Notes
 *	HPT372			4 (HPT366)	5	Other driver
 *	HPT372N			4 (HPT366)	6	UDMA133
 *	HPT372			5 (HPT372)	1	Other driver
 *	HPT372N			5 (HPT372)	2	UDMA133
 *	HPT302			6 (HPT302)	*	Other driver
 *	HPT302N			6 (HPT302)	> 1	UDMA133
 *	HPT371			7 (HPT371)	*	Other driver
 *	HPT371N			7 (HPT371)	> 1	UDMA133
 *	HPT374			8 (HPT374)	*	Other driver
 *	HPT372N			9 (HPT372N)	*	UDMA133
 *
 *	(1) UDMA133 support depends on the bus clock
 *
 *	To pin down		HPT371N
 */

static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
{
	/* HPT372N and friends - UDMA133 */
	static const struct ata_port_info info = {
		.flags = ATA_FLAG_SLAVE_POSS,
		.pio_mask = ATA_PIO4,
		.mwdma_mask = ATA_MWDMA2,
		.udma_mask = ATA_UDMA6,
		.port_ops = &hpt3x2n_port_ops
	};
	const struct ata_port_info *ppi[] = { &info, NULL };

	u8 irqmask;
	u32 class_rev;

	unsigned int pci_mhz;
	unsigned int f_low, f_high;
	int adjust;
	unsigned long iobase = pci_resource_start(dev, 4);
	void *hpriv = NULL;
	int rc;

	rc = pcim_enable_device(dev);
	if (rc)
		return rc;

	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class_rev);
	class_rev &= 0xFF;

	switch(dev->device) {
		case PCI_DEVICE_ID_TTI_HPT366:
			if (class_rev < 6)
				return -ENODEV;
			break;
		case PCI_DEVICE_ID_TTI_HPT371:
			if (class_rev < 2)
				return -ENODEV;
			/* 371N if rev > 1 */
			break;
		case PCI_DEVICE_ID_TTI_HPT372:
			/* 372N if rev >= 2*/
			if (class_rev < 2)
				return -ENODEV;
			break;
		case PCI_DEVICE_ID_TTI_HPT302:
			if (class_rev < 2)
				return -ENODEV;
			break;
		case PCI_DEVICE_ID_TTI_HPT372N:
			break;
		default:
			printk(KERN_ERR "pata_hpt3x2n: PCI table is bogus please report (%d).\n", dev->device);
			return -ENODEV;
	}
...


and now for the comparison hpt366.c:


...
static const struct hpt_info hpt36x __devinitdata = {
	.chip_name	= "HPT36x",
	.chip_type	= HPT36x,
	.udma_mask	= HPT366_ALLOW_ATA66_3 ? (HPT366_ALLOW_ATA66_4 ? ATA_UDMA4 : ATA_UDMA3) : ATA_UDMA2,
	.dpll_clk	= 0,	/* no DPLL */
	.timings	= &hpt36x_timings
};

static const struct hpt_info hpt370 __devinitdata = {
	.chip_name	= "HPT370",
	.chip_type	= HPT370,
	.udma_mask	= HPT370_ALLOW_ATA100_5 ? ATA_UDMA5 : ATA_UDMA4,
	.dpll_clk	= 48,
	.timings	= &hpt37x_timings
};

static const struct hpt_info hpt370a __devinitdata = {
	.chip_name	= "HPT370A",
	.chip_type	= HPT370A,
	.udma_mask	= HPT370_ALLOW_ATA100_5 ? ATA_UDMA5 : ATA_UDMA4,
	.dpll_clk	= 48,
	.timings	= &hpt37x_timings
};

static const struct hpt_info hpt374 __devinitdata = {
	.chip_name	= "HPT374",
	.chip_type	= HPT374,
	.udma_mask	= ATA_UDMA5,
	.dpll_clk	= 48,
	.timings	= &hpt37x_timings
};

static const struct hpt_info hpt372 __devinitdata = {
	.chip_name	= "HPT372",
	.chip_type	= HPT372,
	.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
	.dpll_clk	= 55,
	.timings	= &hpt37x_timings
};

static const struct hpt_info hpt372a __devinitdata = {
	.chip_name	= "HPT372A",
	.chip_type	= HPT372A,
	.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
	.dpll_clk	= 66,
	.timings	= &hpt37x_timings
};

static const struct hpt_info hpt302 __devinitdata = {
	.chip_name	= "HPT302",
	.chip_type	= HPT302,
	.udma_mask	= HPT302_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
	.dpll_clk	= 66,
	.timings	= &hpt37x_timings
};

static const struct hpt_info hpt371 __devinitdata = {
	.chip_name	= "HPT371",
	.chip_type	= HPT371,
	.udma_mask	= HPT371_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
	.dpll_clk	= 66,
	.timings	= &hpt37x_timings
};

static const struct hpt_info hpt372n __devinitdata = {
	.chip_name	= "HPT372N",
	.chip_type	= HPT372N,
	.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
	.dpll_clk	= 77,
	.timings	= &hpt37x_timings
};

static const struct hpt_info hpt302n __devinitdata = {
	.chip_name	= "HPT302N",
	.chip_type	= HPT302N,
	.udma_mask	= HPT302_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
	.dpll_clk	= 77,
	.timings	= &hpt37x_timings
};

static const struct hpt_info hpt371n __devinitdata = {
	.chip_name	= "HPT371N",
	.chip_type	= HPT371N,
	.udma_mask	= HPT371_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
	.dpll_clk	= 77,
	.timings	= &hpt37x_timings
};
...
/**
 *	hpt366_init_one	-	called when an HPT366 is found
 *	@dev: the hpt366 device
 *	@id: the matching pci id
 *
 *	Called when the PCI registration layer (or the IDE initialization)
 *	finds a device matching our IDE device tables.
 */
static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_device_id *id)
{
	const struct hpt_info *info = NULL;
	struct hpt_info *dyn_info;
	struct pci_dev *dev2 = NULL;
	struct ide_port_info d;
	u8 idx = id->driver_data;
	u8 rev = dev->revision;
	int ret;

	if ((idx == 0 || idx == 4) && (PCI_FUNC(dev->devfn) & 1))
		return -ENODEV;

	switch (idx) {
	case 0:
		if (rev < 3)
			info = &hpt36x;
		else {
			switch (min_t(u8, rev, 6)) {
			case 3: info = &hpt370;  break;
			case 4: info = &hpt370a; break;
			case 5: info = &hpt372;  break;
			case 6: info = &hpt372n; break;
			}
			idx++;
		}
		break;
	case 1:
		info = (rev > 1) ? &hpt372n : &hpt372a;
		break;
	case 2:
		info = (rev > 1) ? &hpt302n : &hpt302;
		break;
	case 3:
		hpt371_init(dev);
		info = (rev > 1) ? &hpt371n : &hpt371;
		break;
	case 4:
		info = &hpt374;
		break;
	case 5:
		info = &hpt372n;
		break;
	}
...

-- 
Bartlomiej Zolnierkiewicz
