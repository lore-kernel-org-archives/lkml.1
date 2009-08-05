Return-Path: <linux-kernel-owner+w=401wt.eu-S1751872AbZHESnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbZHESnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 14:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbZHESnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 14:43:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54286 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbZHESnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 14:43:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Mack <daniel@caiaq.de>
Subject: Re: [PATCH 1/5] w1_gpio: switch to new dev_pm_ops
Date: Wed, 5 Aug 2009 20:44:01 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Ville Syrjala <syrjala@sci.fi>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
References: <1249496971-9019-1-git-send-email-daniel@caiaq.de>
In-Reply-To: <1249496971-9019-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908052044.02103.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 August 2009, Daniel Mack wrote:
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Ville Syrjala <syrjala@sci.fi>
> Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> ---
>  drivers/w1/masters/w1-gpio.c |   23 +++++++++++++++--------
>  1 files changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
> index 6f8866d..7099b11 100644
> --- a/drivers/w1/masters/w1-gpio.c
> +++ b/drivers/w1/masters/w1-gpio.c
> @@ -106,9 +106,9 @@ static int __exit w1_gpio_remove(struct platform_device *pdev)
>  
>  #ifdef CONFIG_PM
>  
> -static int w1_gpio_suspend(struct platform_device *pdev, pm_message_t state)
> +static int w1_gpio_suspend(struct device *dev)
>  {
> -	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
> +	struct w1_gpio_platform_data *pdata = dev->platform_data;
>  
>  	if (pdata->enable_external_pullup)
>  		pdata->enable_external_pullup(0);
> @@ -116,9 +116,9 @@ static int w1_gpio_suspend(struct platform_device *pdev, pm_message_t state)
>  	return 0;
>  }
>  
> -static int w1_gpio_resume(struct platform_device *pdev)
> +static int w1_gpio_resume(struct device *dev)
>  {
> -	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
> +	struct w1_gpio_platform_data *pdata = dev->platform_data;
>  
>  	if (pdata->enable_external_pullup)
>  		pdata->enable_external_pullup(1);
> @@ -126,19 +126,26 @@ static int w1_gpio_resume(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +static struct dev_pm_ops w1_gpio_pm_ops = {
> +	.suspend	= w1_gpio_suspend,
> +	.freeze		= w1_gpio_suspend,
> +	.resume		= w1_gpio_resume,
> +	.thaw		= w1_gpio_resume,

You need

+	.poweroff	= w1_gpio_suspend,
+	.restore		= w1_gpio_resume,

in addition to these, which seems to be the case with the rest of the patches
too.

If you wait for a little while with the patchset, we're going to have a
convenience macro for defining such 'standard' dev_pm_ops objects.

> +};
> +
> +#define W1_GPIO_PM_OPS (&w1_gpio_pm_ops)
> +
>  #else
> -#define w1_gpio_suspend	NULL
> -#define w1_gpio_resume	NULL
> +#define W1_GPIO_PM_OPS NULL
>  #endif
>  
>  static struct platform_driver w1_gpio_driver = {
>  	.driver = {
>  		.name	= "w1-gpio",
>  		.owner	= THIS_MODULE,
> +		.pm	= W1_GPIO_PM_OPS,
>  	},
>  	.remove	= __exit_p(w1_gpio_remove),
> -	.suspend = w1_gpio_suspend,
> -	.resume = w1_gpio_resume,
>  };
>  
>  static int __init w1_gpio_init(void)

Best,
Rafael
