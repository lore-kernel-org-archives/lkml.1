Return-Path: <linux-kernel-owner+w=401wt.eu-S932768AbXJQOgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768AbXJQOgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 10:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbXJQOf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 10:35:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44037 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762AbXJQOf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 10:35:57 -0400
Date: Wed, 17 Oct 2007 15:35:55 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] fix not-and/or errors
Message-ID: <20071017143555.GI8181@ftp.linux.org.uk>
References: <47161243.6060007@tiscali.nl> <47161451.9010309@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47161451.9010309@tiscali.nl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 03:55:29PM +0200, Roel Kluin wrote:
>     if(!x & y) should either be if(!(x & y)) or if(!x && y)
>     I made changes as seemed appropriate, but please review
>     
>     Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/arch/arm/mach-pxa/mfp.c b/arch/arm/mach-pxa/mfp.c
> index 5cd3cad..7229319 100644
> --- a/arch/arm/mach-pxa/mfp.c
> +++ b/arch/arm/mach-pxa/mfp.c
> @@ -199,7 +199,7 @@ void pxa3xx_mfp_set_edge(int mfp, int edge)
>  
>  	mfpr_val &= ~MFPR_EDGE_MASK;
>  	mfpr_val |= (edge & 0x3u) << MFPR_ERE_OFFSET;
> -	mfpr_val |= (!edge & 0x1) << MFPR_EC_OFFSET;
> +	mfpr_val |= (!(edge & 0x1)) << MFPR_EC_OFFSET;
>  
>  	mfpr_writel(mfpr_off, mfpr_val);
>  	mfpr_sync();

ACK

> diff --git a/arch/sh/drivers/dma/dma-sh.c b/arch/sh/drivers/dma/dma-sh.c
> index 958bac1..e8f9c85 100644
> --- a/arch/sh/drivers/dma/dma-sh.c
> +++ b/arch/sh/drivers/dma/dma-sh.c
> @@ -89,7 +89,7 @@ static irqreturn_t dma_tei(int irq, void *dev_id)
>  
>  static int sh_dmac_request_dma(struct dma_channel *chan)
>  {
> -	if (unlikely(!chan->flags & DMA_TEI_CAPABLE))
> +	if (unlikely(!(chan->flags & DMA_TEI_CAPABLE)))
>  		return 0;
>  
>  	return request_irq(get_dmte_irq(chan->chan), dma_tei,

ACK

> --- a/drivers/acpi/asus_acpi.c
> +++ b/drivers/acpi/asus_acpi.c
> @@ -596,7 +596,7 @@ write_led(const char __user * buffer, unsigned long count,
>  	    (led_out) ? (hotk->status | ledmask) : (hotk->status & ~ledmask);
>  
>  	if (invert)		/* invert target value */
> -		led_out = !led_out & 0x1;
> +		led_out = !(led_out & 0x1);

No, simply !led_out

> +		if ((!battery->flags.battery_present_prev && acpi_battery_present(battery))
> +		    || (battery->flags.battery_present_prev && !acpi_battery_present(battery))) {

ITYM != and you've missed another one like that in the same file.

The rest is covered by earlier patches
