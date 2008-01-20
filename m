Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbYATLHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbYATLHl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 06:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYATLHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 06:07:33 -0500
Received: from smtp-100-sunday.nerim.net ([62.4.16.100]:51116 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752095AbYATLHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 06:07:32 -0500
Date: Sun, 20 Jan 2008 12:07:30 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [i2c] [PATCH 19 3/5] Clean up error returns
Message-ID: <20080120120730.06dd8a7f@hyperion.delvare>
In-Reply-To: <20080112024743.7023.23630.stgit@terra.home>
References: <20080112024737.7023.61680.stgit@terra.home>
	<20080112024743.7023.23630.stgit@terra.home>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

On Fri, 11 Jan 2008 21:47:43 -0500, Jon Smirl wrote:
> Return errors that were being ignored in the mpc-i2c driver

This wording is a bit excessive. The errors were not being ignored,
only the error code was replaced with a less informative -1. Still,
that's a good fix, although totally unrelated with the patch set it was
hiding into. The only question I have is:

> 
> Signed-off-by: Jon Smirl <jonsmirl@gmail.com>
> ---
> 
>  drivers/i2c/busses/i2c-mpc.c |   30 +++++++++++++++++-------------
>  1 files changed, 17 insertions(+), 13 deletions(-)
> 
> 
> diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
> index d8de4ac..7c35a8f 100644
> --- a/drivers/i2c/busses/i2c-mpc.c
> +++ b/drivers/i2c/busses/i2c-mpc.c
> @@ -180,7 +180,7 @@ static void mpc_i2c_stop(struct mpc_i2c *i2c)
>  static int mpc_write(struct mpc_i2c *i2c, int target,
>  		     const u8 * data, int length, int restart)
>  {
> -	int i;
> +	int i, result;
>  	unsigned timeout = i2c->adap.timeout;
>  	u32 flags = restart ? CCR_RSTA : 0;
>  
> @@ -192,15 +192,17 @@ static int mpc_write(struct mpc_i2c *i2c, int target,
>  	/* Write target byte */
>  	writeb((target << 1), i2c->base + MPC_I2C_DR);
>  
> -	if (i2c_wait(i2c, timeout, 1) < 0)
> -		return -1;
> +	result = i2c_wait(i2c, timeout, 1);
> +	if (result < 0)
> +		return result;
>  
>  	for (i = 0; i < length; i++) {
>  		/* Write data byte */
>  		writeb(data[i], i2c->base + MPC_I2C_DR);
>  
> -		if (i2c_wait(i2c, timeout, 1) < 0)
> -			return -1;
> +		result = i2c_wait(i2c, timeout, 1);
> +		if (result < 0)
> +			return result;
>  	}
>  
>  	return 0;
> @@ -210,7 +212,7 @@ static int mpc_read(struct mpc_i2c *i2c, int target,
>  		    u8 * data, int length, int restart)
>  {
>  	unsigned timeout = i2c->adap.timeout;
> -	int i;
> +	int i, result;
>  	u32 flags = restart ? CCR_RSTA : 0;
>  
>  	/* Start with MEN */
> @@ -221,8 +223,9 @@ static int mpc_read(struct mpc_i2c *i2c, int target,
>  	/* Write target address byte - this time with the read flag set */
>  	writeb((target << 1) | 1, i2c->base + MPC_I2C_DR);
>  
> -	if (i2c_wait(i2c, timeout, 1) < 0)
> -		return -1;
> +	result = i2c_wait(i2c, timeout, 1);
> +	if (result < 0)
> +		return result;
>  
>  	if (length) {
>  		if (length == 1)
> @@ -234,8 +237,9 @@ static int mpc_read(struct mpc_i2c *i2c, int target,
>  	}
>  
>  	for (i = 0; i < length; i++) {
> -		if (i2c_wait(i2c, timeout, 0) < 0)
> -			return -1;
> +		result = i2c_wait(i2c, timeout, 0);
> +		if (result < 0)
> +			return result;
>  
>  		/* Generate txack on next to last byte */
>  		if (i == length - 2)
> @@ -321,9 +325,9 @@ static int fsl_i2c_probe(struct platform_device *pdev)
>  
>  	pdata = (struct fsl_i2c_platform_data *) pdev->dev.platform_data;
>  
> -	if (!(i2c = kzalloc(sizeof(*i2c), GFP_KERNEL))) {
> +	i2c = kzalloc(sizeof(*i2c), GFP_KERNEL);
> +	if (!i2c)
>  		return -ENOMEM;
> -	}
>  
>  	i2c->irq = platform_get_irq(pdev, 0);
>  	if (i2c->irq < 0) {
> @@ -381,7 +385,7 @@ static int fsl_i2c_remove(struct platform_device *pdev)
>  	i2c_del_adapter(&i2c->adap);
>  	platform_set_drvdata(pdev, NULL);
>  
> -	if (i2c->irq != 0)
> +	if (i2c->irq != NO_IRQ)
>  		free_irq(i2c->irq, i2c);
>  
>  	iounmap(i2c->base);
> 
> 

Is this last chunk a cleanup or a bugfix? It seems that NO_IRQ can have
value 0 or -1 depending on the architecture, so your change is real on
some architectures.

I have to admit that I'm a bit confused by the way IRQs are handled by
this driver. On the one hand, there is code to handle polled-mode:

static int i2c_wait(struct mpc_i2c *i2c, unsigned timeout, int writing)
{
	(...)
	if (i2c->irq == 0)
	{
		(...)
	} else {
		/* Interrupt mode */

But on the other hand the initialization code bails out if the platform
device doesn't provide an IRQ:

static int fsl_i2c_probe(struct platform_device *pdev)
{
	(...)
	i2c->irq = platform_get_irq(pdev, 0);
	if (i2c->irq < 0) {
		result = -ENXIO;
		goto fail_get_irq;
	}

So it seems to me like the polling mode code is never actually used?
Unless some platforms include an "empty" IRQ in their device
definition. Which indeed seems to be the case... but then they set the
IRQ to 0, NOT to NO_IRQ, so I'm wondering if the change you propose is
really correct.

Either way, there are more places in the driver where the IRQ is
compared to 0, so if your change is correct, it should be applied
consistently. Thus I will revert this part for the time being, if any
change is really needed with regards to interrupts in this driver,
please send a separate patch. But please double-check first, as I said
above it's trickier than it looks.

-- 
Jean Delvare
