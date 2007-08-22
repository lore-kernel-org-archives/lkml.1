Return-Path: <linux-kernel-owner+w=401wt.eu-S1765489AbXHVSLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765489AbXHVSLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 14:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763820AbXHVSLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 14:11:25 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:27394 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763537AbXHVSLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 14:11:23 -0400
Date: Wed, 22 Aug 2007 11:11:18 -0700
From: Brandon Philips <brandon@ifup.org>
To: postfail@hushmail.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH ] /drivers/ata ioremap returncode check
Message-ID: <20070822181118.GA15764@ifup.org>
References: <387498.11798.qm@web44905.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <387498.11798.qm@web44905.mail.sp1.yahoo.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20:31 Mon 13 Aug 2007, Scott Thompson wrote:
> patchset against 2.6.23-rc3.  corrects missing ioremap return checks.
> 
> Warning -- cleanup handler here may miss additional required cleanup as has occurred on other
> portions of ioremap audit.
> 
> This patch had been submitted previously but hushmail client caused wordwrap issues, resending
> with different mail client.
> 
> Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
> ----------------------------------------------------------
> 
> diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
> index 4ca7fd6..eaebc4d 100644
> --- a/drivers/ata/pata_ixp4xx_cf.c
> +++ b/drivers/ata/pata_ixp4xx_cf.c
> @@ -189,6 +189,14 @@ static __devinit int ixp4xx_pata_probe(struct platform_device *pdev)
>  	data->cs0 = devm_ioremap(&pdev->dev, cs0->start, 0x1000);
>  	data->cs1 = devm_ioremap(&pdev->dev, cs1->start, 0x1000);
>  
> +	if (!data->cs0 || !data->cs1) {
> +		if (data->cs0)
> +			iounmap(data->cs0);
> +		if (data->cs1)
> +			iounmap(data->cs1);
> +		return -ENOMEM;
> +	}
> +
>  	irq = platform_get_irq(pdev, 0);
>  	if (irq)
>  		set_irq_type(irq, IRQT_RISING);

The iounmap calls are unnecessary since devm_ioremap will un-allocate
the space if you return an error from probe.  See
Documentation/driver-model/devres.txt

But, something like this is needed.

+	if (!data->cs0 || !data->cs1)
+		return -ENOMEM;

Thanks,

	Brandon
