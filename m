Return-Path: <linux-kernel-owner+w=401wt.eu-S1759727AbYFDKMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759727AbYFDKMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 06:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbYFDKMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 06:12:05 -0400
Received: from www.tglx.de ([62.245.132.106]:48585 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192AbYFDKMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 06:12:03 -0400
Date: Wed, 4 Jun 2008 12:11:45 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, Uwe.Kleine-Koenig@digi.com, gregkh@suse.de,
       akpm@linux-foundation.org, hjk@linutronix.de, lethal@linux-sh.org,
       tglx@linutronix.de
Subject: Re: [PATCH] uio_pdrv: Unique IRQ Mode
Message-ID: <20080604101144.GA3207@local>
References: <20080604060826.17162.46972.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080604060826.17162.46972.sendpatchset@rx1.opensource.se>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 03:08:26PM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@igel.co.jp>
> 
> This patch adds a "Unique IRQ Mode" to the uio_pdrv UIO platform driver.
> In this mode the user space driver is responsible for acknowledging and
> re-enabling the interrupt. Shared interrupts are not supported.

I still don't see any gain in this. This only works for embedded
devices, so a user has to setup hardware specific code in his board
support anyway. With your code, we would have to add something like this
to the docs:

IF you define an irq AND ommit the irq handler THEN we silently add a
handler that blindly assumes the irq is not shared...

In my opinion, this is confusing, and all it does is saving the need for a
three-lines irq handler in the board support.

So, NAK to this until somebody convinces me that I completely missed the
point.

Thanks,
Hans

> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> ---
> 
> Think of this as V2 of "[PATCH 00/03][RFC] Reusable UIO Platform Driver".
> Needs "[PATCH 0/1] UIO: Add a write() function to enable/disable interrupts"
> 
>  drivers/uio/uio_pdrv.c |   43 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
> 
> --- 0006/drivers/uio/uio_pdrv.c
> +++ work/drivers/uio/uio_pdrv.c	2008-06-04 14:51:56.000000000 +0900
> @@ -16,8 +16,34 @@
>  
>  struct uio_platdata {
>  	struct uio_info *uioinfo;
> +	unsigned long irq_disabled;
>  };
>  
> +static irqreturn_t uio_pdrv_unique_handler(int irq, struct uio_info *dev_info)
> +{
> +	struct uio_platdata *priv = dev_info->priv;
> +
> +	/* In "Unique IRQ Mode", just disable the interrupt and remember
> +	 * the state so we can enable it later.
> +	 */
> +	disable_irq(irq);
> +	set_bit(0, &priv->irq_disabled);
> +	return IRQ_HANDLED;
> +}
> +
> +static int uio_pdrv_unique_irqcontrol(struct uio_info *dev_info, s32 irq_on)
> +{
> +	struct uio_platdata *priv = dev_info->priv;
> +
> +	/* "Unique IRQ Mode" allows re-enabling of the interrupt */
> +	if (irq_on && test_and_clear_bit(0, &priv->irq_disabled)) {
> +		enable_irq(dev_info->irq);
> +		return 0;
> +	}
> +
> +	return -ENOSYS;
> +}
> +
>  static int uio_pdrv_probe(struct platform_device *pdev)
>  {
>  	struct uio_info *uioinfo = pdev->dev.platform_data;
> @@ -68,6 +94,23 @@ static int uio_pdrv_probe(struct platfor
>  
>  	pdata->uioinfo->priv = pdata;
>  
> +	/* This driver supports a special "Unique IRQ Mode".
> +	 *
> +	 * In this mode, no hardware specific kernel code is required to
> +	 * acknowledge interrupts. Instead, the interrupt is disabled by
> +	 * the interrupt handler. User space is responsible for performing
> +	 * hardware specific acknowledge and enabling of interrupts.
> +	 *
> +	 * Interrupt sharing is _not_ supported by the "Unique IRQ Mode".
> +	 *
> +	 * Enable this mode by passing IRQ number but omitting irq callbacks.
> +	 */
> +	if (!uioinfo->handler && !uioinfo->irqcontrol && uioinfo->irq >= 0) {
> +		uioinfo->irq_flags = IRQF_DISABLED;
> +		uioinfo->handler = uio_pdrv_unique_handler;
> +		uioinfo->irqcontrol = uio_pdrv_unique_irqcontrol;
> +	}
> +
>  	ret = uio_register_device(&pdev->dev, pdata->uioinfo);
>  
>  	if (ret) {
