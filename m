Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbZAaPMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbZAaPMO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 10:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbZAaPL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 10:11:58 -0500
Received: from h155.mvista.com ([63.81.120.155]:35661 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752165AbZAaPL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 10:11:57 -0500
Message-ID: <49846A36.5000708@ru.mvista.com>
Date: Sat, 31 Jan 2009 18:11:50 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Hugh Dickins <hugh@veritas.com>, Jeff Garzik <jgarzik@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc libata sff 32bit PIO regression
References: <Pine.LNX.4.64.0901211322010.15945@blonde.anvils> <20090126191151.18b094e6@lxorguk.ukuu.org.uk>
In-Reply-To: <20090126191151.18b094e6@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan Cox wrote:

> pata_amd: Program FIFO
>
> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
>
> With 32bit PIO we can use the posted write buffers, but only for 32bit I/O
> cycles. This means we must disable the FIFO for ATAPI where a final 16bit
> cycle may occur.
>
> Rework the FIFO logic so that we disable the FIFO then selectively re-enable
> it when we set the timings on AMD devices. Also fix a case where we scribbled
> on PCI config 0x41 of Nvidia chips when we shouldn't.
>
> Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
>   
[...]
> diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
> index 63719ab..c380a4e 100644
> --- a/drivers/ata/pata_amd.c
> +++ b/drivers/ata/pata_amd.c
>   
[...]
> @@ -158,6 +165,40 @@ static int amd_cable_detect(struct ata_port *ap)
>  }
>  
>  /**
> + *	amd_fifo_setup		-	set the PIO FIFO for ATA/ATAPI
> + *	@ap: ATA interface
> + *	@adev: ATA device
> + *
> + *	Set the PCI fifo for this device according to the devices present
> + *	on the bus at this point in time. We need to turn the post write buffer
> + *	off for ATAPI devices as we may need to issue a word sized write to the
> + *	device as the final I/O
> + */
> +
> +static void amd_fifo_setup(struct ata_port *ap)
> +{
> +	struct ata_device *adev;
> +	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
> +	static const u8 fifobit[2] = { 0xC0, 0x30};
> +	u8 fifo = fifobit[ap->port_no];
> +	u8 r;
> +
> +
> +	ata_for_each_dev(adev, &ap->link, ENABLED) {
> +		if (adev->class == ATA_DEV_ATAPI)
> +			fifo = 0;
> +	}
>   

   Er, couldn't we do that dynamically, based on which device is 
executing the command now?

> +	if (pdev->device == PCI_DEVICE_ID_AMD_VIPER_7411) /* FIFO is broken */
> +		fifo = 0;
> +
> +	/* On the later chips the read prefetch bits become no-op bits */
> +	pci_read_config_byte(pdev, 0x41, &r);
> +	r &= ~fifobit[ap->port_no];
>   

  Why not:

       r &= ~fifo;

> +	r |= fifo;
> +	pci_write_config_byte(pdev, 0x41, r);
> +}

MBR, Sergei


