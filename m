Return-Path: <linux-kernel-owner+w=401wt.eu-S1761151AbXJSUgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761151AbXJSUgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 16:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765512AbXJSUgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 16:36:38 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:27981 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116AbXJSUgh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 16:36:37 -0400
Date: Fri, 19 Oct 2007 13:36:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Richard Purdie <rpurdie@rpsys.net>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Rodrigo Pereira <rodripe@gmail.com>
Subject: Re: [PATCH 3/3] leds-clevo-mail: driver for Clevo mail LED
Message-Id: <20071019133607.3419b00a.randy.dunlap@oracle.com>
In-Reply-To: <4718FD04.3080602@freemail.hu>
References: <4718FD04.3080602@freemail.hu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007 20:52:52 +0200 Németh Márton wrote:

> From: Márton Németh <nm127@freemail.hu>
> 
> The driver supports the mail LED commonly found on different Clevo notebooks.
> The driver access the LED through the i8042 hardware and implements the support for
> hardware accelerated blink function.
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> diff -uprN linux-2.6.23.orig/drivers/leds/Kconfig linux-2.6.23/drivers/leds/Kconfig
> --- linux-2.6.23.orig/drivers/leds/Kconfig	2007-10-09 22:31:38.000000000 +0200
> +++ linux-2.6.23/drivers/leds/Kconfig	2007-10-18 07:20:12.000000000 +0200
> @@ -101,6 +101,26 @@ config LEDS_GPIO
>  	  outputs. To be useful the particular board must have LEDs
>  	  and they must be connected to the GPIO lines.
> 
> +config LEDS_CLEVO_MAIL
> +	tristate "Mail LED on Clevo notebook (EXPERIMENTAL)"
> +	depends on LEDS_CLASS && X86 && SERIO_I8042 && DMI && EXPERIMENTAL
> +	help
> +	  This driver makes the mail LED accessible from userspace
> +	  programs through the leds subsystem. This LED can blink at
> +	  about 0.5Hz and 1Hz.

?:
	  can blink 1 time every 1 or 2 seconds.

> +	  This module can drive the mail LED for the following notebooks:
> +
> +		Clevo D410J
> +		Clevo D410V
> +		Clevo D400V/D470V (not tested, but might work)
> +		Clevo M540N
> +		Clevo M5x0N (not tested, but might work)
> +		Positivo Mobile (Clevo M5x0V)
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called leds-clevo-mail.
> +
>  comment "LED Triggers"
> 
>  config LEDS_TRIGGERS
> diff -uprN linux-2.6.23.orig/drivers/leds/leds-clevo-mail.c linux-2.6.23/drivers/leds/leds-clevo-mail.c
> --- linux-2.6.23.orig/drivers/leds/leds-clevo-mail.c	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.23/drivers/leds/leds-clevo-mail.c	2007-10-18 07:17:56.000000000 +0200
> @@ -0,0 +1,226 @@
> +
> +#include <linux/module.h>
> +
> +#include <linux/platform_device.h>
> +#include <linux/err.h>
> +#include <linux/leds.h>
> +
> +#include <linux/io.h>
> +#include <linux/dmi.h>
> +
> +#include <linux/i8042.h>
> +
> +
> +#define TRUE				1
> +#define FALSE				0

Just use true / false.

> +#define HANDLED				0
> +
> +#define CLEVO_MAIL_LED_OFF		0x0084
> +#define CLEVO_MAIL_LED_BLINK_1HZ	0x008A
> +#define CLEVO_MAIL_LED_BLINK_0_5HZ	0x0083
> +
> +#define MODULE_FNAME		"leds-clevo-mail.c"
> +#define DRVNAME			"clevo-mail-led"

Kbuild provides KBUILD_BASENAME and KBUILD_MODNAME.  Can you use
one of those?

> +#define NO_RESOURCES		NULL

Just use NULL.

> +MODULE_AUTHOR("Márton Németh <nm127@freemail.hu>");
> +MODULE_DESCRIPTION("Clevo mail LED driver");
> +MODULE_LICENSE("GPL");
> +
> +
> +static int __init clevo_mail_led_dmi_callback(struct dmi_system_id *id)
> +{
> +	printk(KERN_INFO MODULE_FNAME ": '%s' found\n", id->ident);

MODULE_FNAME string looks too long and out of place here.

> +	return 1;
> +}
> +
> +/**

/** introduces kernel-doc, but there is no following kernel-doc....,
so just use /*, please.

> + * struct mail_led_whitelist - List of known good models
> + *
> + * Contains the known good models this driver is compatible with.
> + * When adding a new model try to be as strict as possible. This
> + * makes it possible to keep the false positives (the model is
> + * detected as working, but in reality it is not) as low as
> + * possible.
> + */
> +static struct dmi_system_id __initdata mail_led_whitelist[] = {
> +	{
...
> +	{ }
> +};
> +
> +
> +
> +static struct led_classdev clevo_mail_led = {
> +	.name			= "clevo::mail",

What's the purpose of the "::"?

> +	.brightness_set		= clevo_mail_led_set,
> +	.blink_set		= clevo_mail_led_blink,
> +};
> +
> +
> +static struct platform_driver clevo_mail_led_driver = {
> +	.probe		= clevo_mail_led_probe,
> +	.remove		= clevo_mail_led_remove,
> +#ifdef CONFIG_PM
> +	.suspend	= clevo_mail_led_suspend,
> +	.resume		= clevo_mail_led_resume,
> +#endif
> +	.driver		= {
> +		.name		= DRVNAME,
> +	},
> +};

We prefer to have clevo_mail_led_susped() and _resume() defined
all the time, so that the above  ifdef & endif can go away, so
do more like:

#ifdef CONFIG_PM
/* those functions as you have them */
#else
#define clevo_mail_led_suspend	NULL
#define clevo_mail_led_resume	NULL
#endif



> +static int __init clevo_mail_led_init(void)
> +{
> +	int error = 0;
> +	int count = 0;
> +
> +	/* Check with the help of DMI if we are running on supported hardware */
> +	if (!nodetect) {
> +		count = dmi_check_system(mail_led_whitelist);
> +	} else {
> +		count = 1;
> +		printk(KERN_ERR MODULE_FNAME ": Skipping DMI detection. "
> +		       "If the driver works on your hardware please "
> +		       "report model and the output of dmidecode in tracker "
> +		       "at http://sourceforge.net/projects/clevo-mailled/\n");
> +	}
> +
> +	if (!count) {
> +		return -ENODEV;
> +	}

Don't use braces on one-statement/one-line "blocks."

> +	pdev = platform_device_register_simple(DRVNAME, -1, NO_RESOURCES, 0);
> +	if (!IS_ERR(pdev)) {
> +		error = platform_driver_probe(&clevo_mail_led_driver,
> +					      clevo_mail_led_probe);
> +		if (error) {
> +			printk(KERN_ERR MODULE_FNAME

Use the module logical name, not source file name.

> +			       ": Can't probe platform driver\n");
> +			platform_device_unregister(pdev);
> +		}
> +	} else {
> +		error = PTR_ERR(pdev);
> +	}
> +
> +	return error;
> +}


---
~Randy
