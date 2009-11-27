Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbZK0TS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbZK0TS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 14:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbZK0TS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 14:18:58 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:42247 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751151AbZK0TS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 14:18:57 -0500
Message-ID: <4B10265C.1090004@ru.mvista.com>
Date: Fri, 27 Nov 2009 22:19:56 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_hpt366: add hpt36x_find_mode() helper
References: <200911271954.54019.bzolnier@gmail.com>
In-Reply-To: <200911271954.54019.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> Factor out code for finding the register programming information
> from hpt366_set_mode() to hpt36x_find_mode().

    Not sure what it gives us...

> This makes pata_hpt366 driver more similar to pata_{37x,3x2n} ones.

    ... if only that. :-)

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> Sergei, pata_hpt{37x,3x2n} drivers can also be made to use *set_mode()
> helper but I don't want to interfere with your pending fixes there.

    Yeah, it's on my agenda. :-)

>  drivers/ata/pata_hpt366.c |   35 +++++++++++++++++++++++++----------
>  1 file changed, 25 insertions(+), 10 deletions(-)
> 
> Index: b/drivers/ata/pata_hpt366.c
> ===================================================================
> --- a/drivers/ata/pata_hpt366.c
> +++ b/drivers/ata/pata_hpt366.c
> @@ -114,6 +114,28 @@ static const struct hpt_clock hpt366_25[
>  	{	0,		0x01208585	}
>  };
>  
> +/**
> + *	hpt36x_find_mode	-	find the hpt36x timing
> + *	@ap: ATA port
> + *	@speed: transfer mode
> + *
> + *	Return the 32bit register programming information for this channel
> + *	that matches the speed provided.
> + */
> +
> +static u32 hpt36x_find_mode(struct ata_port *ap, int speed)
> +{
> +	struct hpt_clock *clocks = ap->host->private_data;
> +
> +	while (clocks->xfer_mode) {
> +		if (clocks->xfer_mode == speed)
> +			return clocks->timing;
> +		clocks++;

    This whole data structure of <mode, timing> tuples makes my eyes hurt.
If you remember, I've changed it to a separate array of modes and timings 
which takes ~twice less space...

> +	}
> +	BUG();
> +	return 0xffffffffU;	/* silence compiler warning */
> +}
> +
>  static const char *bad_ata33[] = {
>  	"Maxtor 92720U8", "Maxtor 92040U6", "Maxtor 91360U4", "Maxtor 91020U3", "Maxtor 90845U3", "Maxtor 90650U2",
>  	"Maxtor 91360D8", "Maxtor 91190D7", "Maxtor 91020D6", "Maxtor 90845D5", "Maxtor 90680D4", "Maxtor 90510D3", "Maxtor 90340D2",
> @@ -238,11 +260,10 @@ static int hpt36x_prereset(struct ata_li
>  static void hpt366_set_mode(struct ata_port *ap, struct ata_device *adev,
>  			    u8 mode)
>  {
> -	struct hpt_clock *clocks = ap->host->private_data;
>  	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
>  	u32 addr1 = 0x40 + 4 * (adev->devno + 2 * ap->port_no);
>  	u32 addr2 = 0x51 + 4 * ap->port_no;
> -	u32 mask, reg;
> +	u32 mask, reg, t;

    Alan calls this 't' variable 'mode' if you want to be 100% similar. ;-)

WBR, Sergei
