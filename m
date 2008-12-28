Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbYL1Wo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbYL1Wo0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 17:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757461AbYL1WoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 17:44:10 -0500
Received: from h155.mvista.com ([63.81.120.155]:39882 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756952AbYL1WoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 17:44:08 -0500
Message-ID: <49580131.6090006@ru.mvista.com>
Date: Mon, 29 Dec 2008 01:44:01 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Shane McDonald <mcdonald.shane@gmail.com>
Cc: alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Resurrect IT8172 IDE controller driver
References: <E1LEfcO-0007lL-Mq@localhost>
In-Reply-To: <E1LEfcO-0007lL-Mq@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Shane McDonald wrote:

> Support for the IT8172 IDE controller was removed from the kernel
> sometime after 2.6.18.  Support for the only boards that used the IT8172
> was removed from the kernel after 2.6.18, as they had never compiled
> since 2.6.0.  However, there are a couple of platforms that use this
> chip: the PMC-Sierra Xiao Hu thin-client computer, which is no longer
> in production, and the Linksys NSS4000 Network Attached Storage box,
> which is based on the Xiao Hu board.  I am attempting to add support
> for the Xiao Hu to the kernel, and this IT8172 IDE controller is the
> first bit of code in this effort.
>
> This patch resurrects the IT8172 IDE controller code.  I began with
> the 2.6.18 version of the it8172.c file, and have moved it forward so
> that it works with the latest version of the kernel.  I have run this
> driver on a PMC-Sierra Xiao Hu board with the 2.6.28-rc9 kernel, and
> I have had no problems with it in my configuration.  The attached patch
> applies cleanly against 2.6.28-rc9.
>
> Signed-off-by: Shane McDonald <mcdonald.shane@gmail.com>
>   

   Well, you're close. :-)

> diff -uprN a/drivers/ide/it8172.c b/drivers/ide/it8172.c
> --- a/drivers/ide/it8172.c	1969-12-31 18:00:00.000000000 -0600
> +++ b/drivers/ide/it8172.c	2008-12-22 01:23:15.000000000 -0600
> @@ -0,0 +1,188 @@
>   
[...]
> +static void it8172_set_pio_mode(ide_drive_t *drive, const u8 pio)
> +{
> +	ide_hwif_t *hwif	= HWIF(drive);
> +	struct pci_dev *dev	= to_pci_dev(hwif->dev);
> +	u16 drive_enables;
> +	u32 drive_timing;
> +
> +				     /* RTx  PWx */
> +	static const u8 timings[][2] = {
> +					{ 7, 7 },
> +					{ 3, 4 },
>   

   This is not enough for PIO mode 1, as this only gives 150 ns active + 
120 ns recovery = 270 ns where minimum is 383 ns

> +					{ 1, 2 }, };
> +	/*
> +	 * The highest value of DIOR/DIOW pulse width and recovery time
> +	 * that can be set in the IT8172 is 8 PCI clock cycles.  As a result,
> +	 * it cannot be configured for PIO mode 0.  This table sets these
> +	 * parameters to the maximum supported by the IT8172.
> +	 */
> +
> +	pci_read_config_word(dev, 0x40, &drive_enables);
> +	pci_read_config_dword(dev, 0x44, &drive_timing);
> +
> +	/*
> +	 * Enable port 0x44. The IT8172 spec is confused; it calls
> +	 * this register the "Slave IDE Timing Register", but in fact,
> +	 * it controls timing for both master and slave drives.
> +	 */
> +	drive_enables |= 0x4000;
> +
> +	if (drive->dn) {
>   

   Would have been good to collapse both branches...

> +		drive_enables &= 0xc006;
> +		if (drive->media == ide_disk)
> +			/* enable prefetch */
> +			drive_enables |= 0x0040;
> +		if (pio > 2 || ata_id_has_iordy(drive->id))
>   

   You can actually skip "pio > 2" test.

> +static void it8172_set_dma_mode(ide_drive_t *drive, const u8 speed)
> +{
> +	ide_hwif_t *hwif	= HWIF(drive);
> +	struct pci_dev *dev	= to_pci_dev(hwif->dev);
> +	int a_speed		= 3 << (drive->dn * 4);
> +	int u_flag		= 1 << drive->dn;
> +	int u_speed		= 0;
> +	u8 reg48, reg4a;
> +
> +	pci_read_config_byte(dev, 0x48, &reg48);
> +	pci_read_config_byte(dev, 0x4a, &reg4a);
> +
> +	if (speed >= XFER_UDMA_0) {
> +		u8 udma = speed - XFER_UDMA_0;
> +		u_speed = min_t(u8, 2 - (udma & 1), udma) << (drive->dn * 4);
>   

   There's no need to use such complex math when the chip only supports 
UltraDMA modes 0 thru 2. Be simple:

		u_speed = udma << (drive->dn * 4);


> +		pci_write_config_byte(dev, 0x48, reg48 | u_flag);
> +		reg4a &= ~a_speed;
> +		pci_write_config_byte(dev, 0x4a, reg4a | u_speed);
> +	} else {
> +		const u8 mwdma_to_pio[] = { 0, 3, 4 };
> +		u8 pio;
> +
> +		pci_write_config_byte(dev, 0x48, reg48 & ~u_flag);
> +		pci_write_config_byte(dev, 0x4a, reg4a & ~a_speed);
> +
> +		if (speed >= XFER_MW_DMA_0)
>   

   We dropped support for SWDMA, so the check  should not be needed...

> +			pio = mwdma_to_pio[speed - XFER_MW_DMA_0];
> +		else
> +			pio = 2;
>   

   ... and *else* branch is pointless.

> +		it8172_set_pio_mode(drive, pio);
>   

   Well, not the best place in the PIIX driver -- DMA modes shouldn't 
affect prefetch and IORDY settings (regardless of what the Intel's 
programming manuals say :-).
Àlthough, it's probably OK to continue abusing the set_pio_mode() method.

> +static const struct ide_port_info it8172_port_info __devinitdata = {
> +	.name		= DRV_NAME,
> +	.port_ops	= &it8172_port_ops,
> +	.enablebits	= {{0x41, 0x80, 0x80}, {0x00, 0x00, 0x00} },
>   

   Inconsistent spacing, add space after first {...

MBR, Sergei


