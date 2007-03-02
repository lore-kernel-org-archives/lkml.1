Return-Path: <linux-kernel-owner+w=401wt.eu-S2992739AbXCBX0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992739AbXCBX0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 18:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992743AbXCBX0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 18:26:10 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54651 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992739AbXCBX0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 18:26:08 -0500
Message-ID: <45E8B28D.7030500@garzik.org>
Date: Fri, 02 Mar 2007 18:26:05 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: akpm@osdl.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_cmd640: CMD640 PCI support
References: <20070302150306.368e24b9@lxorguk.ukuu.org.uk>
In-Reply-To: <20070302150306.368e24b9@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Support for the PCI CMD640 (not VLB)
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

Overall ACK, with minor comments/questions below

Not applying (yet) due to cable_detect dependency.  will await resend 
once dependency is satisfied.


> +static void cmd640_set_piomode(struct ata_port *ap, struct ata_device *adev)
> +{
> +	struct cmd640_reg *timing = ap->private_data;
> +	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
> +	struct ata_timing t;
> +	const unsigned long T = 1000000 / 33;
> +	const u8 setup_data[] = { 0x40, 0x40, 0x40, 0x80, 0x00 };
> +	u8 reg;
> +	int arttim = ARTIM0 + 2 * adev->devno;
> +	struct ata_device *pair = ata_dev_pair(adev);
> +
> +	if (ata_timing_compute(adev, adev->pio_mode, &t, T, 0) < 0) {
> +		printk(KERN_ERR DRV_NAME ": mode computation failed.\n");

ata_dev_printk or dev_printk


> +	/* The second channel has shared timings and the setup timing is
> +	   messy to switch to merge it for worst case */
> +	if (ap->port_no && pair) {
> +		struct ata_timing p;
> +		ata_timing_compute(pair, pair->pio_mode, &p, T, 1);
> +		ata_timing_merge(&p, &t, &t, ATA_TIMING_SETUP);
> +	}
> +
> +	/* Make the timings fit */
> +	if (t.recover > 16) {
> +		t.active += t.recover - 16;
> +		t.recover = 16;
> +	}
> +	if (t.active > 16)
> +		t.active = 16;
> +
> +	/* Now convert the clocks into values we can actually stuff into
> +	   the chip */
> +
> +	if (t.recover > 1)
> +		t.recover--;	/* 640B only */
> +	else
> +		t.recover = 15;
> +
> +	if (t.setup > 4)
> +		t.setup = 0xC0;
> +	else
> +		t.setup = setup_data[t.setup];
> +
> +	if (ap->port_no == 0) {
> +		t.active &= 0x0F;	/* 0 = 16 */
> +
> +		/* Load setup timing */
> +		pci_read_config_byte(pdev, arttim, &reg);
> +		reg &= 0x3F;
> +		reg |= t.setup;
> +		pci_write_config_byte(pdev, arttim, reg);
> +
> +		/* Load active/recovery */
> +		pci_write_config_byte(pdev, arttim + 1, (t.active << 4) | t.recover);
> +	} else {
> +		/* Save the shared timings for channel, they will be loaded
> +		   by qc_issue_prot. Reloading the setup time is expensive 
> +		   so we keep a merged one loaded */
> +		pci_read_config_byte(pdev, ARTIM23, &reg);
> +		reg &= 0x3F;
> +		reg |= t.setup;
> +		pci_write_config_byte(pdev, ARTIM23, reg);
> +		timing->reg58[adev->devno] = (t.active << 4) | t.recover;
> +	}
> +}
> +
> +
> +/**
> + *	cmd640_qc_issue_prot	-	command preparation hook
> + *	@qc: Command to be issued
> + *
> + *	Channel 1 has shared timings. We must reprogram the
> + *	clock each drive 2/3 switch we do.
> + */
> +
> +static unsigned int cmd640_qc_issue_prot(struct ata_queued_cmd *qc)
> +{
> +	struct ata_port *ap = qc->ap;
> +	struct ata_device *adev = qc->dev;
> +	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
> +	struct cmd640_reg *timing = ap->private_data;
> +	
> +	if (ap->port_no != 0 && adev->devno != timing->last) {
> +		pci_write_config_byte(pdev, DRWTIM23, timing->reg58[adev->devno]);
> +		timing->last = adev->devno;
> +	}

It might be worth looking into whether ->dev_select is a better place 
for this sort of code


> +	return ata_qc_issue_prot(qc);
> +}
> +

> +static int cmd640_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +	u8 r;
> +	u8 ctrl;
> +	
> +	static struct ata_port_info info = {
> +		.sht = &cmd640_sht,
> +		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
> +		.pio_mask = 0x1f,

I-dont-know-the-hardware question:  does this h/w have no DMA support?


> +	static struct ata_port_info *port_info[2] = { &info, &info };
> +
> +	/* CMD640 detected, commiserations */
> +	pci_write_config_byte(pdev, 0x5C, 0x00);

magic number


> +	/* Get version info */
> +	pci_read_config_byte(pdev, CFR, &r);
> +	/* PIO0 command cycles */
> +	pci_write_config_byte(pdev, CMDTIM, 0);
> +	/* 512 byte bursts (sector) */
> +	pci_write_config_byte(pdev, BRST, 0x40);
> +	/* 
> +	 * A reporter a long time ago
> +	 * Had problems with the data fifo
> +	 * So don't run the risk
> +	 * Of putting crap on the disk
> +	 * For its better just to go slow
> +	 */
> +	/* Do channel 0 */
> +	pci_read_config_byte(pdev, CNTRL, &ctrl);
> +	pci_write_config_byte(pdev, CNTRL, ctrl | 0xC0);
> +	/* Ditto for channel 1 */
> +	pci_read_config_byte(pdev, ARTIM23, &ctrl);
> +	ctrl |= 0x0C;
> +	pci_write_config_byte(pdev, ARTIM23, ctrl);
> +	
> +	return ata_pci_init_one(pdev, port_info, 2);
> +}
> +
> +static int cmd640_reinit_one(struct pci_dev *pdev)
> +{
> +	return ata_pci_device_resume(pdev);
> +}

appears to be useless wrapper


