Return-Path: <linux-kernel-owner+w=401wt.eu-S1754267AbYJNUvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbYJNUvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 16:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYJNUvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 16:51:37 -0400
Received: from h155.mvista.com ([63.81.120.155]:5024 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751567AbYJNUvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 16:51:36 -0400
Message-ID: <48F50649.9080507@ru.mvista.com>
Date: Wed, 15 Oct 2008 00:51:21 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hpt366: add hpt3xx_disable_fast_irq() helper
References: <200808021915.03424.bzolnier@gmail.com>
In-Reply-To: <200808021915.03424.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> * Factor out disabling of "fast interrupt" prediction from
>   init_hwif_hpt366() to hpt3xx_disable_fast_irq() helper.

> * Use hpt3xx_disable_fast_irq() in ->init_chipset instead of
>   ->init_hwif method.

>   This is a preparation for adding proper PCI PM support.

> While at it:

> * Cache chip type in chip_type variable in hpt3xx_disable_fast_irq().

> There should be no functional changes caused by this patch.

    Except a warning. ;-)

> Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

> Index: b/drivers/ide/pci/hpt366.c
> ===================================================================
> --- a/drivers/ide/pci/hpt366.c
> +++ b/drivers/ide/pci/hpt366.c
> @@ -1265,7 +1297,6 @@ static void __devinit init_hwif_hpt366(i
>  	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
>  	int serialize		= HPT_SERIALIZE_IO;
>  	u8  chip_type		= info->chip_type;
> -	u8  new_mcr, old_mcr	= 0;
>  
>  	/* Cache the channel's MISC. control registers' offset */
>  	hwif->select_data	= hwif->channel ? 0x54 : 0x50;
> @@ -1288,29 +1319,6 @@ static void __devinit init_hwif_hpt366(i
>  	/* Serialize access to this device if needed */
>  	if (serialize && hwif->mate)
>  		hwif->serialized = hwif->mate->serialized = 1;
> -
> -	/*
> -	 * Disable the "fast interrupt" prediction.  Don't hold off
> -	 * on interrupts. (== 0x01 despite what the docs say)
> -	 */
> -	pci_read_config_byte(dev, hwif->select_data + 1, &old_mcr);
> -
> -	if (info->chip_type >= HPT374)
> -		new_mcr = old_mcr & ~0x07;
> -	else if (info->chip_type >= HPT370) {
> -		new_mcr = old_mcr;
> -		new_mcr &= ~0x02;
> -
> -#ifdef HPT_DELAY_INTERRUPT
> -		new_mcr &= ~0x01;
> -#else
> -		new_mcr |=  0x01;
> -#endif
> -	} else					/* HPT366 and HPT368  */
> -		new_mcr = old_mcr & ~0x80;
> -
> -	if (new_mcr != old_mcr)
> -		pci_write_config_byte(dev, hwif->select_data + 1, new_mcr);
>  }

   CC      drivers/ide/pci/hpt366.o
drivers/ide/pci/hpt366.c: In function `init_hwif_hpt366':
drivers/ide/pci/hpt366.c:1290: warning: unused variable `dev'

    You've removed the users of that variable but left the variable itself... 
alas, it's too late to fix the patch. :-/

MBR, Sergei
