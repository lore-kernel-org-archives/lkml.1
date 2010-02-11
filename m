Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab0BKSHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 13:07:17 -0500
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:60154 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755311Ab0BKSHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 13:07:14 -0500
Subject: Re: [PATCH] Add Dell Business Class Netbook LED driver
From: Richard Purdie <rpurdie@rpsys.net>
To: Bob Rodgers <Robert_Rodgers@dell.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "lenb@kernel.org" <lenb@kernel.org>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       Louis Davis <Louis_Davis@dell.com>, Jim Dailey <Jim_Dailey@dell.com>,
       Michael Brown <Michael_E_Brown@dell.com>,
       Mario Limonciello <Mario_Limonciello@dell.com>,
       Matt Domsch <Matt_Domsch@dell.com>, Dan Carpenter <error27@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
In-Reply-To: <4B7078E2.50407@dell.com>
References: <4B7078E2.50407@dell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Feb 2010 17:59:14 +0000
Message-ID: <1265911154.4689.11.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-08 at 14:49 -0600, Bob Rodgers wrote:
> This patch adds an LED driver to support the Dell Activity LED on the 
> Dell Latitude 2100 netbook and future products to come. The Activity LED 
> is visible externally in the lid so classroom instructors can observe it 
> from a distance. The driver uses the sysfs led_class and provides a 
> standard LED interface. This driver is ready for submission upstream.

A couple of comments:

> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index 8a0e1ec..40dd693 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -269,6 +269,13 @@ config LEDS_ADP5520
>  	  To compile this driver as a module, choose M here: the module will
>  	  be called leds-adp5520.
> 
> +config LEDS_DELL_NETBOOKS
> +	tristate "External LED on Dell Business Netbooks"
> +	depends on LEDS_CLASS
> +	help
> +	  This adds support for the Latitude 2100 and similar
> +	  notebooks that have an external LED.
> +
>  comment "LED Triggers"

I assume this driver applies to X86 only? Is there anything else this
config option should be depending on?

> +static int __devinit dell_led_probe(struct platform_device *pdev)
> +{
> +	return led_classdev_register(&pdev->dev, &dell_led);
> +}
> +
> +static int dell_led_remove(struct platform_device *pdev)
> +{
> +	led_classdev_unregister(&dell_led);
> +	return 0;
> +}
> +
> +static struct platform_driver dell_led_driver = {
> +	.probe		= dell_led_probe,
> +	.remove		= dell_led_remove,
> +	.driver		= {
> +		.name	= KBUILD_MODNAME,
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +static struct platform_device *pdev;
> +
> +static int __init dell_led_init(void)
> +{
> +	int error = 0;
> +
> +	if (!wmi_has_guid(DELL_LED_BIOS_GUID)) {
> +		printk(KERN_DEBUG KBUILD_MODNAME
> +			": could not find: DELL_LED_BIOS_GUID\n");
> +		return -ENODEV;
> +	}
> +
> +	error = led_off();
> +	if (error != 0) {
> +		printk(KERN_DEBUG KBUILD_MODNAME
> +			": could not communicate with LED"
> +			": error %d\n", error);
> +		return -ENODEV;
> +	}
> +
> +	error = platform_driver_register(&dell_led_driver);
> +	if (error < 0)
> +		return error;
> +
> +	pdev = platform_device_register_simple(KBUILD_MODNAME, -1, NULL, 0);
> +	if (IS_ERR(pdev)) {
> +		error = PTR_ERR(pdev);
> +		platform_driver_unregister(&dell_led_driver);
> +	}
> +
> +	return error;
> +}

Rather than add all this overhead of a platform device, why not just
pass NULL as the parent to led_classdev_register()?

Cheers,

Richard

