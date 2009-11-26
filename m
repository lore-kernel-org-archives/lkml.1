Return-Path: <linux-kernel-owner+w=401wt.eu-S1752167AbZKZTC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbZKZTC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 14:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbZKZTC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 14:02:57 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:3695 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1750888AbZKZTC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 14:02:56 -0500
Message-ID: <4B0ED119.1090802@ru.mvista.com>
Date: Thu, 26 Nov 2009 22:03:53 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 64/86] pata_radisys: unify code for programming PIO and
 MWDMA timings
References: <20091125170218.5446.13513.sendpatchset@localhost> <20091125171003.5446.66341.sendpatchset@localhost>
In-Reply-To: <20091125171003.5446.66341.sendpatchset@localhost>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> It results in ~6% decrease in the driver LOC count and also ~1%
> decrease in the driver binary size (as measured on x86-32).

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ata/pata_radisys.c |   66 +++++++++++++++++----------------------------
>  1 file changed, 25 insertions(+), 41 deletions(-)

> Index: b/drivers/ata/pata_radisys.c
> ===================================================================
> --- a/drivers/ata/pata_radisys.c
> +++ b/drivers/ata/pata_radisys.c
> @@ -26,20 +26,9 @@
>  #define DRV_NAME	"pata_radisys"
>  #define DRV_VERSION	"0.4.4"
>  
> -/**
> - *	radisys_set_piomode - Initialize host controller PATA PIO timings
> - *	@ap: ATA port
> - *	@adev: Device whose timings we are configuring
> - *
> - *	Set PIO mode for device, in host controller PCI config space.
> - *
> - *	LOCKING:
> - *	None (inherited from caller).
> - */
> -
> -static void radisys_set_piomode (struct ata_port *ap, struct ata_device *adev)
> +static void radisys_set_timings(struct ata_port *ap, struct ata_device *adev,
> +				u8 pio, bool use_mwdma)
>  {
> -	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
>  	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
>  	u16 idetm_data;
>  	int control = 0;
> @@ -52,7 +41,7 @@ static void radisys_set_piomode (struct
>  	 */
>  
>  	static const	 /* ISP  RTC */
> -	u8 timings[][2]	= { { 0, 0 },	/* Check me */
> +	u8 timings[][2]	= { { 0, 0 },
>  			    { 0, 0 },
>  			    { 1, 1 },
>  			    { 2, 2 },
> @@ -62,6 +51,10 @@ static void radisys_set_piomode (struct
>  		control |= 1;	/* TIME1 enable */
>  	if (ata_pio_need_iordy(adev))
>  		control |= 2;	/* IE IORDY */
> +	/* If the drive MWDMA is faster than it can do PIO then
> +	   we must force PIO0 for PIO cycles. */

    Multi-line comment style should preferrably be:

	/*
	 * blah
	 * blah
	 */

> +	if (use_mwdma && adev->pio_mode < (XFER_PIO_0 + pio))
> +		control = 1;

    Hm, shouldn't that be 8?

> @@ -115,20 +112,8 @@ static void radisys_set_dmamode (struct
>  			XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
>  		};
>  		int pio = needed_pio[mwdma] - XFER_PIO_0;
> -		int control = 3;	/* IORDY|TIME0 */
> -
> -		/* If the drive MWDMA is faster than it can do PIO then
> -		   we must force PIO0 for PIO cycles. */
> -
> -		if (adev->pio_mode < needed_pio[mwdma])
> -			control = 1;

    Perhaps there's a bug here?

MBR, Sergei
