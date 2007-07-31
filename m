Return-Path: <linux-kernel-owner+w=401wt.eu-S1763021AbXGaORd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763021AbXGaORd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759861AbXGaORF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:17:05 -0400
Received: from h155.mvista.com ([63.81.120.155]:11774 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762209AbXGaORB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:17:01 -0400
Message-ID: <46AF44D3.3090608@ru.mvista.com>
Date: Tue, 31 Jul 2007 18:18:59 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: Correct IORDY handling
References: <20070731140148.4cb780de@the-village.bc.nu>
In-Reply-To: <20070731140148.4cb780de@the-village.bc.nu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan Cox wrote:

> Debugging a report of a problem with an ancient solid state disk showed
> up some problems in the IORDY handling

> 1.	We check the wrong bit to see if the device has IORDY
> 2.	Even then some ancient creaking piles of crap don't support
> 	SETXFER at all.

> I think this should go via -mm for a bit. The cases it fixes are obscure
> and the risk of side effects is slight but possible. This also moves us
> slightly closer to supporting original MFM/RLL disks with libata but
> before Jeff panics I have no plans to do that....

> Signed-off-by: Alan Cox <alan@redhat.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/drivers/ata/libata-core.c linux-2.6.23rc1-mm1/drivers/ata/libata-core.c
> --- linux.vanilla-2.6.23rc1-mm1/drivers/ata/libata-core.c	2007-07-26 15:02:57.000000000 +0100
> +++ linux-2.6.23rc1-mm1/drivers/ata/libata-core.c	2007-07-31 10:47:21.152431008 +0100
> @@ -2787,7 +2803,11 @@
>  	/* Old CFA may refuse this command, which is just fine */
>  	if (dev->xfer_shift == ATA_SHIFT_PIO && ata_id_is_cfa(dev->id))
>          	err_mask &= ~AC_ERR_DEV;
> -
> +	/* Some very old devices and some bad newer ones fail any kind of
> +	   SET_XFERMODE request but support PIO0-2 timings and no IORDY */
> +	if (dev->xfer_shift == ATA_SHIFT_PIO && !ata_id_has_iordy(dev->id) &&

    I'd have joined this to the previous if...

> +			dev->pio_mode <= XFER_PIO_2)

    Overindented line (to my taste :-). And do we really need to check this?

> +		err_mask &= ~AC_ERR_DEV;
>  	if (err_mask) {
>  		ata_dev_printk(dev, KERN_ERR, "failed to set xfermode "
>  			       "(err_mask=0x%x)\n", err_mask);
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/include/linux/ata.h linux-2.6.23rc1-mm1/include/linux/ata.h
> --- linux.vanilla-2.6.23rc1-mm1/include/linux/ata.h	2007-07-26 15:02:58.000000000 +0100
> +++ linux-2.6.23rc1-mm1/include/linux/ata.h	2007-07-27 19:03:40.000000000 +0100
> @@ -354,7 +355,7 @@
>  	( (((id)[76] != 0x0000) && ((id)[76] != 0xffff)) && \
>  	  ((id)[78] & (1 << 5)) )
>  #define ata_id_iordy_disable(id) ((id)[49] & (1 << 10))
> -#define ata_id_has_iordy(id) ((id)[49] & (1 << 9))
> +#define ata_id_has_iordy(id) ((id)[49] & (1 << 11))

   Ha, it was cheking for LBA support instead... :-)

MBR, Sergei
