Return-Path: <linux-kernel-owner+w=401wt.eu-S970584AbXHMUaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970584AbXHMUaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032830AbXHMU3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:29:30 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:22149 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032576AbXHMU31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:29:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=uRj42BXn7n07Wr1DQF7wm4xCpaVzujQUcAcqw48GKcS60GjreALNyMKZVRi/pCDiOW7sQDL/RMGHuMSkw9ZeJM/7rYhar/PDpARZW1x7HkY13QTFpFlToggrY1eKLWScA9NV4LVv/suEAnyQDt9q8g+/iB96KSZAfyXqVHtMTsk=
Message-ID: <46C0BF56.7000308@gmail.com>
Date: Mon, 13 Aug 2007 22:30:14 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: postfail@hushmail.com
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       dri-devel@lists.sourceforge.net
Subject: Re: [PATCH 4 of 5 ] /drivers/char/rio ioremap balancing/ returncode
 check
References: <20070813040530.9E0E9DA82E@mailserver8.hushmail.com>
In-Reply-To: <20070813040530.9E0E9DA82E@mailserver8.hushmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

why dri-devel@lists.sourceforge.net?

Scott Thompson napsal(a):
> patchset against 2.6.23-rc2 and this set is an audit of 
> /drivers/char/a* 
> through drivers/char .   
> 
> this corrects missing ioremap return checks and balancing on 
> iounmap calls..
> 
> Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
> ----------------------------------------------------------
> diff --git a/drivers/char/rio/rio_linux.c 
> b/drivers/char/rio/rio_linux.c
> index 0ce9667..fdaf44f 100644
> --- a/drivers/char/rio/rio_linux.c
> +++ b/drivers/char/rio/rio_linux.c
> @@ -924,6 +924,11 @@ static void fix_rio_pci(struct pci_dev *pdev)
>  
>  	hwbase = pci_resource_start(pdev, 0);
>  	rebase = ioremap(hwbase, 0x80);
> +	if (!rebase) {
> +		printk(KERN_DEBUG "rio: unable to perform cntrl reg fix as 
> ioremap call failed\n");
> +		return;
> +	}
> +		
>  	t = readl(rebase + CNTRL_REG_OFFSET);
>  	if (t != CNTRL_REG_GOODVALUE) {
>  		printk(KERN_DEBUG "rio: performing cntrl reg fix: %08x -> 
> %08x\n", t, CNTRL_REG_GOODVALUE);
> @@ -996,6 +1001,11 @@ static int __init rio_init(void)
>  		if (((1 << hp->Ivec) & rio_irqmask) == 0)
>  			hp->Ivec = 0;
>  		hp->Caddr = ioremap(p->RIOHosts[p->RIONumHosts].PaddrP, 
> RIO_WINDOW_LEN);
> +		if (!hp->Caddr) {
> +			printk(KERN_ERR "RIO: Unable to ioremap.\n");
> +			return -ENOMEM;
> +		}

hmm, and what about the yet inited cards here?

> +
>  		hp->CardP = (struct DpRam __iomem *) hp->Caddr;
>  		hp->Type = RIO_PCI;
>  		hp->Copy = rio_copy_to_card;
> @@ -1049,6 +1059,10 @@ static int __init rio_init(void)
>  			hp->Ivec = 0;
>  		hp->Ivec |= 0x8000;	/* Mark as non-sharable */
>  		hp->Caddr = ioremap(p->RIOHosts[p->RIONumHosts].PaddrP, 
> RIO_WINDOW_LEN);
> +		if (!hp->Caddr) {
> +			printk(KERN_ERR "RIO: Unable to ioremap.\n");
> +			return -ENOMEM;
> +		}

And here.

>  		hp->CardP = (struct DpRam __iomem *) hp->Caddr;
>  		hp->Type = RIO_PCI;
>  		hp->Copy = rio_copy_to_card;

And what about the one on the line 1093?

-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
