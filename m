Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab0BKSF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 13:05:29 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:54058 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311Ab0BKSF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 13:05:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hKaC83MTTfBZChCAm25oyo4ArAOE9p18NIiMo4wkCH3pZRV+ntRRPJMuP7F9nfQRey
         jxxfz5fNeWHTe9Dt7OVcMWeuoseYSOnxoPhURm+lu6t095S/i1pOZk4YZ4sPHRF9PFqS
         g14C+9dmw83JXXEm+R8DjVglTaCOUlPW7s2Fg=
Date: Thu, 11 Feb 2010 10:05:19 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Bob Rodgers <Robert_Rodgers@dell.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       Louis Davis <Louis_Davis@dell.com>, Jim Dailey <Jim_Dailey@dell.com>,
       Michael Brown <Michael_E_Brown@dell.com>,
       Mario Limonciello <Mario_Limonciello@dell.com>,
       Matt Domsch <Matt_Domsch@dell.com>, Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH] Add Dell Business Class Netbook LED driver
Message-ID: <20100211180518.GB26117@core.coreip.homeip.net>
References: <4B7078E2.50407@dell.com>
 <1265911154.4689.11.camel@rex>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265911154.4689.11.camel@rex>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 05:59:14PM +0000, Richard Purdie wrote:
> On Mon, 2010-02-08 at 14:49 -0600, Bob Rodgers wrote:
> > This patch adds an LED driver to support the Dell Activity LED on the 
> > Dell Latitude 2100 netbook and future products to come. The Activity LED 
> > is visible externally in the lid so classroom instructors can observe it 
> > from a distance. The driver uses the sysfs led_class and provides a 
> > standard LED interface. This driver is ready for submission upstream.
> 
> A couple of comments:
> 
> > diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> > index 8a0e1ec..40dd693 100644
> > --- a/drivers/leds/Kconfig
> > +++ b/drivers/leds/Kconfig
> > @@ -269,6 +269,13 @@ config LEDS_ADP5520
> >  	  To compile this driver as a module, choose M here: the module will
> >  	  be called leds-adp5520.
> > 
> > +config LEDS_DELL_NETBOOKS
> > +	tristate "External LED on Dell Business Netbooks"
> > +	depends on LEDS_CLASS
> > +	help
> > +	  This adds support for the Latitude 2100 and similar
> > +	  notebooks that have an external LED.
> > +
> >  comment "LED Triggers"
> 
> I assume this driver applies to X86 only? Is there anything else this
> config option should be depending on?
> 
> > +static int __devinit dell_led_probe(struct platform_device *pdev)
> > +{
> > +	return led_classdev_register(&pdev->dev, &dell_led);
> > +}
> > +
> > +static int dell_led_remove(struct platform_device *pdev)
> > +{
> > +	led_classdev_unregister(&dell_led);
> > +	return 0;
> > +}
> > +
> > +static struct platform_driver dell_led_driver = {
> > +	.probe		= dell_led_probe,
> > +	.remove		= dell_led_remove,
> > +	.driver		= {
> > +		.name	= KBUILD_MODNAME,
> > +		.owner	= THIS_MODULE,
> > +	},
> > +};
> > +
> > +static struct platform_device *pdev;
> > +
> > +static int __init dell_led_init(void)
> > +{
> > +	int error = 0;
> > +
> > +	if (!wmi_has_guid(DELL_LED_BIOS_GUID)) {
> > +		printk(KERN_DEBUG KBUILD_MODNAME
> > +			": could not find: DELL_LED_BIOS_GUID\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	error = led_off();
> > +	if (error != 0) {
> > +		printk(KERN_DEBUG KBUILD_MODNAME
> > +			": could not communicate with LED"
> > +			": error %d\n", error);
> > +		return -ENODEV;
> > +	}
> > +
> > +	error = platform_driver_register(&dell_led_driver);
> > +	if (error < 0)
> > +		return error;
> > +
> > +	pdev = platform_device_register_simple(KBUILD_MODNAME, -1, NULL, 0);
> > +	if (IS_ERR(pdev)) {
> > +		error = PTR_ERR(pdev);
> > +		platform_driver_unregister(&dell_led_driver);
> > +	}
> > +
> > +	return error;
> > +}
> 
> Rather than add all this overhead of a platform device, why not just
> pass NULL as the parent to led_classdev_register()?
> 

Or stuck it in dell-wmi.c...

-- 
Dmitry
