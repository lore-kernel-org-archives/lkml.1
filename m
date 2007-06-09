Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454AbXFIF7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbXFIF7h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 01:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbXFIF72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 01:59:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:9710 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbXFIF71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 01:59:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=nA/mFB2LjUfi30hQ19FGGYIk6ZvrXA+LNIxnG71pStS70ixnvXfaZvGpf6ttoobqla+vpbK3dPxvE0Pbp1SXTkVmqA2WOnmKLpTviK95LHkNV83iWrY0oyEeZxF9NSrX4BZeefBEgQNodaextr4qYExK510qb6UnlaD7fLhIVCQ=
Message-ID: <466A417C.5090901@gmail.com>
Date: Sat, 09 Jun 2007 14:58:20 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_it821x: sync with IDE it821x driver
References: <200706090223.20933.bzolnier@gmail.com>
In-Reply-To: <200706090223.20933.bzolnier@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Bartlomiej Zolnierkiewicz wrote:
> * (partially) fix DMA in RAID mode
> 
>   Code intended to check DMA status was checking DMA command register.
>   Moreover firmware seems to "forget" to set DMA capable bit for the
>   slave device (at least in RAID mode but without ITE RAID volumes) so
>   check device ID for DMA capable bit when deciding whether to use DMA
>   and remove DMA status check completely.
> 
>   Thanks to Pavol ©imo for the bugreport and testing the initial fix.

Ah... This is the mysterious mwdma configuration in smart mode, right?
Thanks for fixing this.

>   This change unfortunately still doesn't fix DMA in RAID mode (which
>   works fine with IDE it821x) but Alan is working on the missing pieces
>   (pata_it821x vs libata EH issues).

This is the lbal/nsect SRST problem, right?

> @@ -258,8 +259,14 @@ static void it821x_passthru_set_piomode(
>  	static const u8 pio_want[]    = { ATA_66, ATA_66, ATA_66, ATA_66, ATA_ANY };
>  
>  	struct it821x_dev *itdev = ap->private_data;
> +	struct ata_device *pair = ata_dev_pair(adev);
>  	int unit = adev->devno;
> -	int mode_wanted = adev->pio_mode - XFER_PIO_0;
> +	int mode_wanted = adev->pio_mode;
> +
> +	if (pair && adev->pio_mode > pair->pio_mode)
> +		mode_wanted = pair->pio_mode;
> +
> +	mode_wanted -= XFER_PIO_0;

I think this is better done by mode_filter callback which is guaranteed
to be called before any actual mode configuration is performed and in
device order (master then slave).

Thanks.

-- 
tejun
