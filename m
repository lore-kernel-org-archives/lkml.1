Return-Path: <linux-kernel-owner+w=401wt.eu-S1757737AbZEHUNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737AbZEHUNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 16:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbZEHUNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 16:13:09 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:40040 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbZEHUNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 16:13:08 -0400
Date: Fri, 8 May 2009 22:13:02 +0200
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Ville Syrjala <syrjala@sci.fi>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH] w1-gpio: add external pull-up enable callback
Message-ID: <20090508201302.GA24080@buzzloop.caiaq.de>
References: <1241527413-22920-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241527413-22920-1-git-send-email-daniel@caiaq.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc Evgeniy Polyakov)

Evgeniy, could you give some feedback on this? Ville Syrjala gave his
Acked-by already.

Thanks,
Daniel


On Tue, May 05, 2009 at 02:43:33PM +0200, Daniel Mack wrote:
> On embedded devices, sleep mode conditions can be tricky to handle,
> Especially when processors tend to pull-down the w1 bus during sleep.
> Bus slaves (such as the ds2760) may interpret this as a reason for
> power-down conditions and entirely switch off the device.
> 
> This patch adds a callback function pointer to let users switch on and
> off the external pull-up resistor. This lets the outside world know
> whether the processor is currently actively driving the bus or not.
> 
> When this callback is not provided, the code behaviour won't change.
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Ville Syrjala <syrjala@sci.fi>
> ---
>  drivers/w1/masters/w1-gpio.c |   35 +++++++++++++++++++++++++++++++++++
>  include/linux/w1-gpio.h      |    1 +
>  2 files changed, 36 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
> index a411702..6f8866d 100644
> --- a/drivers/w1/masters/w1-gpio.c
> +++ b/drivers/w1/masters/w1-gpio.c
> @@ -74,6 +74,9 @@ static int __init w1_gpio_probe(struct platform_device *pdev)
>  	if (err)
>  		goto free_gpio;
>  
> +	if (pdata->enable_external_pullup)
> +		pdata->enable_external_pullup(1);
> +
>  	platform_set_drvdata(pdev, master);
>  
>  	return 0;
> @@ -91,6 +94,9 @@ static int __exit w1_gpio_remove(struct platform_device *pdev)
>  	struct w1_bus_master *master = platform_get_drvdata(pdev);
>  	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
>  
> +	if (pdata->enable_external_pullup)
> +		pdata->enable_external_pullup(0);
> +
>  	w1_remove_master_device(master);
>  	gpio_free(pdata->pin);
>  	kfree(master);
> @@ -98,12 +104,41 @@ static int __exit w1_gpio_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PM
> +
> +static int w1_gpio_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
> +
> +	if (pdata->enable_external_pullup)
> +		pdata->enable_external_pullup(0);
> +
> +	return 0;
> +}
> +
> +static int w1_gpio_resume(struct platform_device *pdev)
> +{
> +	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
> +
> +	if (pdata->enable_external_pullup)
> +		pdata->enable_external_pullup(1);
> +
> +	return 0;
> +}
> +
> +#else
> +#define w1_gpio_suspend	NULL
> +#define w1_gpio_resume	NULL
> +#endif
> +
>  static struct platform_driver w1_gpio_driver = {
>  	.driver = {
>  		.name	= "w1-gpio",
>  		.owner	= THIS_MODULE,
>  	},
>  	.remove	= __exit_p(w1_gpio_remove),
> +	.suspend = w1_gpio_suspend,
> +	.resume = w1_gpio_resume,
>  };
>  
>  static int __init w1_gpio_init(void)
> diff --git a/include/linux/w1-gpio.h b/include/linux/w1-gpio.h
> index 9797fec..3adeff8 100644
> --- a/include/linux/w1-gpio.h
> +++ b/include/linux/w1-gpio.h
> @@ -18,6 +18,7 @@
>  struct w1_gpio_platform_data {
>  	unsigned int pin;
>  	unsigned int is_open_drain:1;
> +	void (*enable_external_pullup)(int enable);
>  };
>  
>  #endif /* _LINUX_W1_GPIO_H */
> -- 
> 1.6.2.1
> 
