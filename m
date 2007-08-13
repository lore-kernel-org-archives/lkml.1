Return-Path: <linux-kernel-owner+w=401wt.eu-S1032563AbXHMUQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032563AbXHMUQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757631AbXHMUQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:16:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:6159 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbXHMUQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:16:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=K49fdK9NjOXqQM7I3XbBd9+zCqhHbAiYmKoFyVR7JDdQb9bph76aJA6Ecx8PGNgrRp0tR+K57X4VKGAXGlZ5jl2WrGhYcaPDDVsyoetP2lIhkpMm1wfuDearuheRC6MdNn7EYLMoAXeKm4FCGPQ5ExrvAFDEsk9kfMpPAEEuNo4=
Message-ID: <46C0BC59.6070208@gmail.com>
Date: Mon, 13 Aug 2007 22:17:29 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: postfail@hushmail.com
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       dri-devel@lists.sourceforge.net
Subject: Re: [PATCH 1 of 5 ] /drivers/char ioremap balancing/ returncode check
References: <20070813040039.71A3DDA820@mailserver8.hushmail.com>
In-Reply-To: <20070813040039.71A3DDA820@mailserver8.hushmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Thompson napsal(a):
> patchset against 2.6.23-rc2 and this set is an audit of 
> /drivers/char/a* 
> through drivers/char .   
> 
> this corrects missing ioremap return checks and balancing on 
> iounmap calls..
> 
> Signed-off-by: Scott Thompson <postfail <at> hushmail.com>


NAK.

> ----------------------------------------------------------
> diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
> index ed76f0a..094323d 100644
> --- a/drivers/char/moxa.c
> +++ b/drivers/char/moxa.c
> @@ -447,6 +447,13 @@ static int __init moxa_init(void)
>  	for (i = 0; i < numBoards; i++) {
>  		moxa_boards[i].basemem = ioremap(moxa_boards[i].baseAddr,
>  				0x4000);
> +		if (!moxa_boards[i].basemem) { 
> +			for (;i > 0;i--)
> +				if (moxa_boards[i].basemem)
> +					iounmap(moxa_boards[i].basemem);
> +
> +			return -ENOMEM; 
> +		}

This leaks. This is loop only for ISA cards. If you have CONFIG_PCI and have the
card, resources of the PCI one are not freed and are unusable from now.

>  	}
>  
>  	return retval;
> diff --git a/drivers/char/sx.c b/drivers/char/sx.c
> index 85a2328..30829ed 100644
> --- a/drivers/char/sx.c
> +++ b/drivers/char/sx.c
> @@ -2627,6 +2627,12 @@ static void __devinit fix_sx_pci(struct 
> pci_dev *pdev, struct sx_board *board)
>  	pci_read_config_dword(pdev, PCI_BASE_ADDRESS_0, &hwbase);
>  	hwbase &= PCI_BASE_ADDRESS_MEM_MASK;
>  	rebase = ioremap(hwbase, 0x80);
> +	if (!rebase) {
> +		printk(KERN_DEBUG 
> +			"sx:ioremap fail, unable to perform cntrl reg fix\n");
> +		return;
> +	}
> +		

1) this should be pci_iomap(pdev, 0, 0x80)
2) KERN_DEBUG is inappropriate and wrap the string in the middle and not in the
beginning
3) you should change void to int and return some error and check it in the caller

>  	t = readl(rebase + CNTRL_REG_OFFSET);
>  	if (t != CNTRL_REG_GOODVALUE) {
>  		printk(KERN_DEBUG "sx: performing cntrl reg fix: %08x -> "
> diff --git a/drivers/char/vr41xx_giu.c b/drivers/char/vr41xx_giu.c
> index e5ed091..2381162 100644
> --- a/drivers/char/vr41xx_giu.c
> +++ b/drivers/char/vr41xx_giu.c
> @@ -639,8 +639,10 @@ static int __devinit giu_probe(struct 
> platform_device *dev)
>  	}
>  
>  	irq = platform_get_irq(dev, 0);
> -	if (irq < 0 || irq >= NR_IRQS)
> +	if (irq < 0 || irq >= NR_IRQS) {
> +		iounmap(giu_base);

+ unregister_chrdev()?

>  		return -EBUSY;
> +	}
>  
>  	return cascade_irq(irq, giu_get_irq);
>  }


-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
