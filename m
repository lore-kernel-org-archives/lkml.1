Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbXJUMzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbXJUMzj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 08:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbXJUMzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 08:55:32 -0400
Received: from mail00a.mail.t-online.hu ([84.2.40.5]:60510 "EHLO
	mail00a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbXJUMzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 08:55:31 -0400
X-Authuid: nmarci
Message-ID: <471B4BA5.30100@freemail.hu>
Date: Sun, 21 Oct 2007 14:52:53 +0200
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Rodrigo Pereira <rodripe@gmail.com>
Subject: Re: [PATCH 3/3] leds-clevo-mail: driver for Clevo mail LED
References: <4718FD04.3080602@freemail.hu> <20071019133607.3419b00a.randy.dunlap@oracle.com>
In-Reply-To: <20071019133607.3419b00a.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Fri, 19 Oct 2007 20:52:52 +0200 Németh Márton wrote:
> 
>> From: Márton Németh <nm127@freemail.hu>
>>
>> The driver supports the mail LED commonly found on different Clevo notebooks.
>> The driver access the LED through the i8042 hardware and implements the support for
>> hardware accelerated blink function.
>>
>> Signed-off-by: Márton Németh <nm127@freemail.hu>
>> ---
>> diff -uprN linux-2.6.23.orig/drivers/leds/Kconfig linux-2.6.23/drivers/leds/Kconfig
>> --- linux-2.6.23.orig/drivers/leds/Kconfig	2007-10-09 22:31:38.000000000 +0200
>> +++ linux-2.6.23/drivers/leds/Kconfig	2007-10-18 07:20:12.000000000 +0200
>> @@ -101,6 +101,26 @@ config LEDS_GPIO
>>  	  outputs. To be useful the particular board must have LEDs
>>  	  and they must be connected to the GPIO lines.
>>
>> +config LEDS_CLEVO_MAIL
>> +	tristate "Mail LED on Clevo notebook (EXPERIMENTAL)"
>> +	depends on LEDS_CLASS && X86 && SERIO_I8042 && DMI && EXPERIMENTAL
>> +	help
>> +	  This driver makes the mail LED accessible from userspace
>> +	  programs through the leds subsystem. This LED can blink at
>> +	  about 0.5Hz and 1Hz.
> 
> ?:
> 	  can blink 1 time every 1 or 2 seconds.

It has three modes, I'll try to explain this in more detail in my next patch version.

> 
>> +	  This module can drive the mail LED for the following notebooks:
>> +
>> +		Clevo D410J
>> +		Clevo D410V
>> +		Clevo D400V/D470V (not tested, but might work)
>> +		Clevo M540N
>> +		Clevo M5x0N (not tested, but might work)
>> +		Positivo Mobile (Clevo M5x0V)
>> +
>> +	  To compile this driver as a module, choose M here: the
>> +	  module will be called leds-clevo-mail.
>> +
>  comment "LED Triggers"
>
>  config LEDS_TRIGGERS

I'll document the led trigger extension in more detail in the next
version of the "[PATCH 2/3] leds-clevo-mail: hw accelerated LED blink extension",
in drivers/leds/Kconfig.

>> +#define TRUE				1
>> +#define FALSE				0
> 
> Just use true / false.

I'll delete these #defines.

>> +#define HANDLED				0
>> +
>> +#define CLEVO_MAIL_LED_OFF		0x0084
>> +#define CLEVO_MAIL_LED_BLINK_1HZ	0x008A
>> +#define CLEVO_MAIL_LED_BLINK_0_5HZ	0x0083
>> +
>> +#define MODULE_FNAME		"leds-clevo-mail.c"
>> +#define DRVNAME			"clevo-mail-led"
> 
> Kbuild provides KBUILD_BASENAME and KBUILD_MODNAME.  Can you use
> one of those?

I'll use KBUILD_MODNAME instead.

>> +#define NO_RESOURCES		NULL
> 
> Just use NULL.

I'll delete NO_RESOURCES.

>> +static int __init clevo_mail_led_dmi_callback(struct dmi_system_id *id)
>> +{
>> +	printk(KERN_INFO MODULE_FNAME ": '%s' found\n", id->ident);
> 
> MODULE_FNAME string looks too long and out of place here.

I'll replace MODULE_FNAME with KBUILD_MODNAME. Is this what you mean?

>> +/**
> 
> /** introduces kernel-doc, but there is no following kernel-doc....,
> so just use /*, please.

OK, I'll replace.

>> +static struct led_classdev clevo_mail_led = {
>> +	.name			= "clevo::mail",
> 
> What's the purpose of the "::"?

Here I have the problem that the different laptop models have
different colors of mail LED. So I left out the color and
introduced the type of the LED which is "mail". I'll try to
document this in Documents/leds-class.txt

>> +static struct platform_driver clevo_mail_led_driver = {
>> +	.probe		= clevo_mail_led_probe,
>> +	.remove		= clevo_mail_led_remove,
>> +#ifdef CONFIG_PM
>> +	.suspend	= clevo_mail_led_suspend,
>> +	.resume		= clevo_mail_led_resume,
>> +#endif
>> +	.driver		= {
>> +		.name		= DRVNAME,
>> +	},
>> +};
> 
> We prefer to have clevo_mail_led_susped() and _resume() defined
> all the time, so that the above  ifdef & endif can go away, so
> do more like:
> 
> #ifdef CONFIG_PM
> /* those functions as you have them */
> #else
> #define clevo_mail_led_suspend	NULL
> #define clevo_mail_led_resume	NULL
> #endif

I'll change this to what you proposed.

>> +	if (!count) {
>> +		return -ENODEV;
>> +	}
> 
> Don't use braces on one-statement/one-line "blocks."

I'll remove the braces for the on-line expression.

>> +	pdev = platform_device_register_simple(DRVNAME, -1, NO_RESOURCES, 0);
>> +	if (!IS_ERR(pdev)) {
>> +		error = platform_driver_probe(&clevo_mail_led_driver,
>> +					      clevo_mail_led_probe);
>> +		if (error) {
>> +			printk(KERN_ERR MODULE_FNAME
> 
> Use the module logical name, not source file name.

I'll use KBUILD_MODNAME instead.

> ---
> ~Randy

Márton Németh
