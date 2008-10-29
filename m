Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbYJ2XNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbYJ2XNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 19:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbYJ2XNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 19:13:31 -0400
Received: from www.tglx.de ([62.245.132.106]:56408 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbYJ2XNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 19:13:30 -0400
Date: Thu, 30 Oct 2008 00:13:16 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Mike Frysinger <vapier@gentoo.org>
Cc: hjk@linutronix.de, gregkh@suse.de, damm@igel.co.jp,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] UIO: uio_pdrv_genirq: allow custom irq_flags
Message-ID: <20081029231315.GA7182@local>
References: <1225319752-659-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225319752-659-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 06:35:52PM -0400, Mike Frysinger wrote:
> I can't think of a reason why the driver prevents people from setting any
> custom bits in their platform device, but I can think of some reasons for
> allowing custom flags.  Like setting the IRQF_TRIGGER_... bits.

We wanted to prevent users from setting IRQF_SHARED in their platform
code, because uio_pdrv_genirq.c explicitly relies on an interrupt not
being shared. This code explicitly checks for IRQF_SHARED and lets
uio_pdrv_genirq_probe() fail if it's set. This allows users to set other
IRQF_* flags. That's an improvement and looks alright to me.

> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

> ---
> v2
> 	- disallow IRQF_SHARED in irq_flags
> 
>  drivers/uio/uio_pdrv_genirq.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
> index 1f82c83..3f06818 100644
> --- a/drivers/uio/uio_pdrv_genirq.c
> +++ b/drivers/uio/uio_pdrv_genirq.c
> @@ -81,7 +81,8 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>  		goto bad0;
>  	}
>  
> -	if (uioinfo->handler || uioinfo->irqcontrol || uioinfo->irq_flags) {
> +	if (uioinfo->handler || uioinfo->irqcontrol ||
> +	    uioinfo->irq_flags & IRQF_SHARED) {
>  		dev_err(&pdev->dev, "interrupt configuration error\n");
>  		goto bad0;
>  	}
> @@ -132,7 +133,7 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>  	 * Interrupt sharing is not supported.
>  	 */
>  
> -	uioinfo->irq_flags = IRQF_DISABLED;
> +	uioinfo->irq_flags |= IRQF_DISABLED;
>  	uioinfo->handler = uio_pdrv_genirq_handler;
>  	uioinfo->irqcontrol = uio_pdrv_genirq_irqcontrol;
>  	uioinfo->priv = priv;
> -- 
> 1.6.0.2
