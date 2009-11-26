Return-Path: <linux-kernel-owner+w=401wt.eu-S1751868AbZKZS2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbZKZS2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 13:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbZKZS2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 13:28:16 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:12407 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751834AbZKZS2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 13:28:12 -0500
Message-ID: <4B0EC8F5.9040409@ru.mvista.com>
Date: Thu, 26 Nov 2009 21:29:09 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 41/86] pata_efar: unify code for programming PIO and MWDMA
 timings
References: <20091125170218.5446.13513.sendpatchset@localhost> <20091125170712.5446.50300.sendpatchset@localhost>
In-Reply-To: <20091125170712.5446.50300.sendpatchset@localhost>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> It results in ~9% decrease in the driver LOC count and also ~6%
> decrease in the driver binary size (as measured on x86-32).

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ata/pata_it8213.c |   87 +++++++++++++++-------------------------------
>  1 file changed, 29 insertions(+), 58 deletions(-)

> Index: b/drivers/ata/pata_it8213.c
> ===================================================================
> --- a/drivers/ata/pata_it8213.c
> +++ b/drivers/ata/pata_it8213.c
> @@ -61,20 +61,9 @@ static int it8213_cable_detect(struct at
>  	return ATA_CBL_PATA80;
>  }
>  
> -/**
> - *	it8213_set_piomode - Initialize host controller PATA PIO timings
> - *	@ap: Port whose timings we are configuring
> - *	@adev: Device whose timings we are configuring
> - *
> - *	Set PIO mode for device, in host controller PCI config space.
> - *
> - *	LOCKING:
> - *	None (inherited from caller).
> - */
> -
> -static void it8213_set_piomode (struct ata_port *ap, struct ata_device *adev)
> +static void it8213_set_timings(struct ata_port *ap, struct ata_device *adev,
> +			       u8 pio, bool use_mwdma)

    Perhaps 'set_mwdma' would be a better name...

>  {
> -	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
>  	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
>  	u8 master_port		= ap->port_no ? 0x42 : 0x40;
>  	u16 master_data;
> @@ -92,13 +81,18 @@ static void it8213_set_piomode (struct a
>  			    { 2, 1 },
>  			    { 2, 3 }, };
>  
> -	if (pio > 1)
> +	if (pio > 1 || use_mwdma)
>  		control |= 1;	/* TIME */
> -	if (ata_pio_need_iordy(adev))	/* PIO 3/4 require IORDY */
> +	if (ata_pio_need_iordy(adev) || use_mwdma)

    I believe this "IORDY for MWDMA" stupidity results from the table 35 in 
ICH PRD which for some reason insists on setting IE bit with DMA, and I 
believe this is wrong -- IORDY shouldn't have anything to with DMA.

>  		control |= 2;	/* IE */
>  	/* Bit 2 is set for ATAPI on the IT8213 - reverse of ICH/PIIX */
>  	if (adev->class != ATA_DEV_ATA)
>  		control |= 4;	/* PPE */
> +	/* If the drive MWDMA is faster than it can do PIO then
> +	   we must force PIO into PIO0 */
> +	if (use_mwdma && adev->pio_mode < (XFER_PIO_0 + pio))

    Parens not needed...

> +		/* Enable DMA timing only */
> +		control |= 8;	/* PIO cycles in PIO0 */
>  
>  	pci_read_config_word(dev, master_port, &master_data);

MBR, Sergei
