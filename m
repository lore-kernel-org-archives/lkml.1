Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbYLaMH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbYLaMH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 07:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756653AbYLaMHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 07:07:36 -0500
Received: from homer.mvista.com ([63.81.120.155]:41160 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755979AbYLaMHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 07:07:35 -0500
Message-ID: <495B6080.7020802@ru.mvista.com>
Date: Wed, 31 Dec 2008 15:07:28 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Shane McDonald <mcdonald.shane@gmail.com>
Cc: alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] Resurrect IT8172 IDE controller driver
References: <E1LHrff-0007jd-Rp@localhost>
In-Reply-To: <E1LHrff-0007jd-Rp@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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
> driver on a PMC-Sierra Xiao Hu board with the 2.6.28 kernel, and
> I have had no problems with it in my configuration.  The attached patch
> applies cleanly against 2.6.28.
>
> Signed-off-by: Shane McDonald <mcdonald.shane@gmail.com>
>   

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> diff -uprN a/drivers/ide/it8172.c b/drivers/ide/it8172.c
> --- a/drivers/ide/it8172.c	1969-12-31 18:00:00.000000000 -0600
> +++ b/drivers/ide/it8172.c	2008-12-30 20:55:29.000000000 -0600
> @@ -0,0 +1,173 @@
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
>   

   By a "happy concidence" these are also an optimal MWDMA0 timings 
(PIO0 is considerably slower).

> +					{ 7, 4 },
> +					{ 3, 3 },
> +					{ 2, 2 },
> +					{ 1, 2 }, };
> +	/*
> +	 * The highest value of DIOR/DIOW pulse width and recovery time
> +	 * that can be set in the IT8172 is 8 PCI clock cycles.  As a result,
> +	 * it cannot be configured for PIO mode 0.  This table sets these
> +	 * parameters to the maximum supported by the IT8172.
> +	 */
>   

   This comment seems somewhat mispalced...

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
> +	drive_enables &= drive->dn ? 0xc006 : 0xc060;
> +	if (drive->media == ide_disk)
> +		/* enable prefetch */
> +		drive_enables |= 0x0004 << (drive->dn * 4);
> +	if (ata_id_has_iordy(drive->id))
> +		/* enable IORDY sample-point */
> +		drive_enables |= 0x0002 << (drive->dn * 4);
> +
> +	drive_timing &= drive->dn ? 0x00003f00 : 0x000fc000;
> +	drive_timing |= ((timings[pio][0] << 11) | (timings[pio][1] << 8))
> +			<< (drive->dn * 6);
>   

   This can be somewhat shortened:

	drive_timing |= ((timings[pio][0] << 3) | timings[pio][1]) <<
			(drive->dn * 6 + 8);


   Could've be shortened even more if timings[] was single-dimensional...

MBR, Sergei


