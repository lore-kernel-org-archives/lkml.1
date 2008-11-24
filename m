Return-Path: <linux-kernel-owner+w=401wt.eu-S1753185AbYKXKeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbYKXKeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 05:34:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYKXKdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 05:33:50 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:57785 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751933AbYKXKdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 05:33:49 -0500
Message-ID: <492A8306.9000400@ru.mvista.com>
Date: Mon, 24 Nov 2008 13:33:42 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Shane McDonald <mcdonald.shane@gmail.com>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Resurrect IT8172 IDE controller driver
References: <E1L4UpB-0007ro-1g@localhost>
In-Reply-To: <E1L4UpB-0007ro-1g@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Shane McDonald wrote:

> diff -uprN a/drivers/ide/it8172.c b/drivers/ide/it8172.c
> --- a/drivers/ide/it8172.c	1969-12-31 18:00:00.000000000 -0600
> +++ b/drivers/ide/it8172.c	2008-11-23 01:06:01.000000000 -0600
> @@ -0,0 +1,205 @@
> +/*
> + *
> + * BRIEF MODULE DESCRIPTION
> + *      IT8172 IDE controller support
> + *
> + * Copyright 2000 MontaVista Software Inc.
> + * Author: MontaVista Software, Inc.
> + *              stevel@mvista.com or source@mvista.com
>   

   You can remove the former address, Steve Longerbeam is no longer with 
MV (quit long ago). And I think you may add your own copyright now.

> +/*
> + * Prototypes
> + */
>   

   I see no prototypes here...

> +
> +static void it8172_set_pio_mode(ide_drive_t *drive, const u8 pio)
> +{
> +	ide_hwif_t *hwif	= HWIF(drive);
> +	struct pci_dev *dev	= to_pci_dev(hwif->dev);
> +	int is_slave		= (&hwif->drives[1] == drive);
>   

    Use simpler "drive->dn & 1" (and drop the useless parens please) -- 
& can be dropped though as the controller has only a single channel...

> +	spin_lock_irqsave(&ide_lock, flags);
>   

   Don't use ide_lock here please. Moreover, since the controller has 
only one channel, you don't need any spinlock here.

> +	pci_read_config_word(dev, 0x40, &drive_enables);
> +	pci_read_config_dword(dev, 0x44, &drive_timing);
> +
> +	/*
> +	 * FIX! The DIOR/DIOW pulse width and recovery times in port 0x44
>   

   It's usually FIXME. :-)

> +	 * are being left at the default values of 8 PCI clocks (242 nsec
> +	 * for a 33 MHz clock).

   It's 240, not 242 ns as 33 is actually 33.333.

>  These can be safely shortened at higher
> +	 * PIO modes. The DIOR/DIOW pulse width and recovery times only
> +	 * apply to PIO modes, not to the DMA modes.
> +	 */
>   

   Not true. They do apply to SW/MW DMA modes -- and if you look at your 
own code you'll see that.

> +
> +	/*
> +	 * Enable port 0x44. The IT8172 spec is confused; it calls
> +	 * this register the "Slave IDE Timing Register", but in fact,
> +	 * it controls timing for both master and slave drives.
> +	 */
> +	drive_enables |= 0x4000;
>   

   This is strange because this IDE controller seems to be a clone of 
the one in the Intel PIIX chip. However, the spec. I have tellm it's not 
an exact clone.
I suggest that you take a close look at drivers/ide/piix.c...

> +
> +	if (is_slave) {
> +		drive_enables &= 0xc006;
> +		if (pio > 1)
> +			/* enable prefetch and IORDY sample-point */
> +			drive_enables |= 0x0060;
>   

   IORDY sampling shouldn't be enabled for PIO mode 2 always, only if 
the drive supports it.
   Prefetch should only be enabled for ATA disks, not the ATAPI devices

> +static void it8172_set_dma_mode(ide_drive_t *drive, const u8 speed)
> +{
> +	ide_hwif_t *hwif	= HWIF(drive);
> +	struct pci_dev *dev	= to_pci_dev(hwif->dev);
> +	int a_speed		= 3 << (drive->dn * 4);
> +	int u_flag		= 1 << drive->dn;
> +	int u_speed		= 0;
> +	u8 reg48, reg4a;
> +
> +	const u8 mwdma_to_pio[] = { 0, 3, 4 };
> +	u8 pio;
> +
> +	pci_read_config_byte(dev, 0x48, &reg48);
> +	pci_read_config_byte(dev, 0x4a, &reg4a);
> +
> +	if (speed >= XFER_UDMA_0) {
> +
> +		/* Setting the DMA cycle time to 2 or 3 PCI clocks
> +		 * (60 and 91 nsec at 33 MHz PCI clock) seems to cause
> +		 * BadCRC errors during DMA transfers on some drives,
>   

   Sigh, such drives should have been blacklisted...

> +		 * even though both numbers meet the minimum ATAPI-4 spec
> +		 * of 73 and 54 nsec for UDMA 1 and 2 respectively.
> +		 * So the faster times are not implemented here.
> +		 * The good news is that the slower cycle time has
> +		 * very little affect on transfer performance.
>   

   This should only affect the write performance, reads.

> +		 */
> +
> +		u_speed = 0 << (drive->dn * 4);
>   

   I think you're actually setting UltraDMA mode 2 timing regardless of 
the mode selected.

   The below code only applies to non-UltraDMA modes.

> +
> +	if (speed >= XFER_MW_DMA_0)
> +		pio = mwdma_to_pio[speed - XFER_MW_DMA_0];
> +	else
> +		pio = 2;
> +
> +	it8172_set_pio_mode(drive, pio);
>   

   Moreover, I'd suggest to reimplement it as the timing register layout 
is different from the original PIIX and additional DMA modes can be 
supported: MWDMA0 and SWDMA1.

> +static unsigned int __devinit init_chipset_it8172(struct pci_dev *dev)
> +{
> +	unsigned char progif;
> +
> +	/*
> +	 * Place both IDE interfaces into PCI "native" mode
> +	 */
> +	pci_read_config_byte(dev, PCI_CLASS_PROG, &progif);
> +	pci_write_config_byte(dev, PCI_CLASS_PROG, progif | 0x05);
> +
> +	return dev->irq;
> +}
>   

   As Alan have said, you can't do that here.

> +static const struct ide_port_info it8172_chipset __devinitdata = {
> +	.name		= DRV_NAME,
> +	.init_chipset	= init_chipset_it8172,
> +	.port_ops	= &it8172_port_ops,
> +	.enablebits	= {{0x00, 0x00, 0x00}, {0x40, 0x00, 0x01} },
>   

   Wrong, should be:

	.enablebits	= {{0x41, 0x80, 0x80}, {0x00, 0x00, 0x00}},

  If that doesn't work (firmware doesn't enable the channel), you can leave it all 0s...

> 	.host_flags	= IDE_HFLAG_SINGLE,
> +	.pio_mask	= ATA_PIO4,
> +	.swdma_mask	= ATA_SWDMA2_ONLY,
> +	.mwdma_mask	= ATA_MWDMA12_ONLY,
>   

   More modes are supportable...

> +static const struct ide_port_info it8172_chipset __devinitdata = {

    Please rename this variable to it8172_port_info.

> +};
> +
> +static int __devinit it8172_init_one(struct pci_dev *dev,
> +					const struct pci_device_id *id)
> +{
> +	if ((!(PCI_FUNC(dev->devfn) & 1) ||
> +		(!((dev->class >> 8) == PCI_CLASS_STORAGE_IDE))))
>   

     Please, don't abuse parens, it should be just:

	if (!(PCI_FUNC(dev->devfn) & 1) ||
	     (dev->class >> 8) != PCI_CLASS_STORAGE_IDE)


> +		return -ENODEV; /* IT8172 is more than an IDE controller */
>   

   And I don't get it: why the first check is needed? Is there another 
IDE controller on function 1 that you want to ignore? I doubt it.

> +MODULE_AUTHOR("SteveL@mvista.com");
>   

   I wonder why Steve didn't specify his full name... :-)

MBR, Sergei


