Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606AbZF2GWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbZF2GWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 02:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZF2GV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 02:21:56 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:61310 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbZF2GVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 02:21:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HTNTZnfqubZQuml//OP+m4Y6EKyAFIajLXX3U+GOkGu9Cko377liw4y+m27clpwkNQ
         VP1uUfACiGwbP52ldbFwDqR3h4VbB1uOODl4bSrFU7pkSNarMg2xhY3TN3rVf5zvl2+V
         eyUF06fTmCX5oEjFoU9yqxyXaJxRQ+FQVjZvw=
Date: Sun, 28 Jun 2009 23:14:34 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: linux-input@vger.kernel.org, inux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Ilya Petrov <ilya.muromec@gmail.com>
Subject: Re: [PATCH] PCAP misc input driver (for 2.6.32)
Message-ID: <20090629061434.GD12821@dtor-d630.eng.vmware.com>
References: <1246122592.3727.20.camel@brutus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246122592.3727.20.camel@brutus>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Sat, Jun 27, 2009 at 02:09:52PM -0300, Daniel Ribeiro wrote:
> This is a driver for misc input events for the PCAP2 PMIC, it handles
> the power button, headphone insertion/removal and the headphone button.
> 
> Signed-off-by: Ilya Petrov <ilya.muromec@gmail.com>
> Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
> 
> ---
>  drivers/input/keyboard/Kconfig     |    7 ++
>  drivers/input/keyboard/Makefile    |    1 +
>  drivers/input/keyboard/pcap_keys.c |  152 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 160 insertions(+), 0 deletions(-)
> 

First of all I think the driver should live in misc, not in keyboard,
since it is not a full-fledged keyboard.

> diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
> index 9d8f796..ea512b0 100644
> --- a/drivers/input/keyboard/Kconfig
> +++ b/drivers/input/keyboard/Kconfig
> @@ -353,4 +353,11 @@ config KEYBOARD_EP93XX
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called ep93xx_keypad.
>  
> +config KEYBOARD_PCAP
> +        tristate "Motorola EZX PCAP events"
> +        depends on EZX_PCAP
> +        help
> +          Say Y here if you want to use power key and jack events
> +          on Motorola EZX 2nd generation phones
> +

To compile this driver as a module...

>  endif
> diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
> index 156b647..06b77dd 100644
> --- a/drivers/input/keyboard/Makefile
> +++ b/drivers/input/keyboard/Makefile
> @@ -30,3 +30,4 @@ obj-$(CONFIG_KEYBOARD_MAPLE)		+= maple_keyb.o
>  obj-$(CONFIG_KEYBOARD_BFIN)		+= bf54x-keys.o
>  obj-$(CONFIG_KEYBOARD_SH_KEYSC)		+= sh_keysc.o
>  obj-$(CONFIG_KEYBOARD_EP93XX)		+= ep93xx_keypad.o
> +obj-$(CONFIG_KEYBOARD_PCAP)		+= pcap_keys.o
> diff --git a/drivers/input/keyboard/pcap_keys.c b/drivers/input/keyboard/pcap_keys.c
> new file mode 100644
> index 0000000..8a9b533
> --- /dev/null
> +++ b/drivers/input/keyboard/pcap_keys.c
> @@ -0,0 +1,152 @@
> +/*
> + *  Input driver for PCAP events:
> + *   * Power key
> + *   * Jack plug/unplug
> + *   * Headphone button
> + *
> + *  Copyright (c) 2008,2009 Ilya Petrov <ilya.muromec@gmail.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/input.h>
> +#include <linux/mfd/ezx-pcap.h>
> +
> +struct pcap_keys {
> +	struct pcap_chip *pcap;
> +	struct input_dev *input;
> +};
> +
> +/* PCAP2 interrupts us on keypress */
> +static irqreturn_t pcap_keys_handler(int irq, void *_pcap_keys)
> +{
> +	struct pcap_keys *pcap_keys = _pcap_keys;
> +	int pirq = irq_to_pcap(pcap_keys->pcap, irq);
> +	u32 pstat;
> +
> +	ezx_pcap_read(pcap_keys->pcap, PCAP_REG_PSTAT, &pstat);
> +	pstat &= 1 << pirq;
> +
> +	switch (pirq) {
> +	case PCAP_IRQ_ONOFF:
> +		input_report_key(pcap_keys->input, KEY_POWER, !pstat);
> +		break;
> +	case PCAP_IRQ_HS:
> +		input_report_switch(pcap_keys->input,
> +				SW_HEADPHONE_INSERT, !pstat);
> +		break;
> +	case PCAP_IRQ_MIC:
> +		input_report_key(pcap_keys->input, KEY_HP, !pstat);

Why not SW_MICROPHONE_INSERT?

> +		break;
> +	}
> +
> +	input_sync(pcap_keys->input);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int __init pcap_keys_probe(struct platform_device *pdev)

__devinit, not __init should be used on driver's probe() methods.

> +{
> +	int err = -ENOMEM;
> +	struct pcap_keys *pcap_keys;
> +
> +	pcap_keys = kmalloc(sizeof(struct pcap_keys), GFP_KERNEL);
> +	if (!pcap_keys)
> +		return err;
> +
> +	pcap_keys->pcap = platform_get_drvdata(pdev);
> +
> +	pcap_keys->input = input_allocate_device();
> +	if (!pcap_keys->input)
> +		goto fail;
> +
> +	platform_set_drvdata(pdev, pcap_keys);
> +	pcap_keys->input->name = pdev->name;
> +	pcap_keys->input->phys = "pcap-keys/input0";
> +	pcap_keys->input->dev.parent = &pdev->dev;

I do like a temp for input_dev, it usually makes code a bit smaller.
Also it would be nice to have but type set (BUS_HOST I think).

> +
> +	pcap_keys->input->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_SW);
> +	set_bit(KEY_POWER, pcap_keys->input->keybit);
> +	set_bit(SW_HEADPHONE_INSERT, pcap_keys->input->swbit);
> +	set_bit(KEY_HP, pcap_keys->input->keybit);
> +

__set_bit() please, like Trolok said.

> +	err = request_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_ONOFF),
> +			pcap_keys_handler, 0, "Power key", pcap_keys);
> +	if (err)
> +		goto fail_dev;
> +
> +	err = request_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_HS),
> +			pcap_keys_handler, 0, "Headphone jack", pcap_keys);
> +	if (err)
> +		goto fail_pwrkey;
> +
> +	err = request_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_MIC),
> +			pcap_keys_handler, 0, "MIC jack/button", pcap_keys);
> +	if (err)
> +		goto fail_jack;
> +
> +	err = input_register_device(pcap_keys->input);
> +	if (err)
> +		goto fail_mic;
> +
> +	return 0;
> +
> +fail_mic:
> +	free_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_MIC), pcap_keys);
> +fail_jack:
> +	free_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_HS), pcap_keys);
> +fail_pwrkey:
> +	free_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_ONOFF), pcap_keys);
> +fail_dev:
> +	input_free_device(pcap_keys->input);
> +fail:
> +	kfree(pcap_keys);
> +	return err;
> +}
> +
> +static int pcap_keys_remove(struct platform_device *pdev)

__devexit here.

> +{
> +	struct pcap_keys *pcap_keys = platform_get_drvdata(pdev);
> +
> +	free_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_ONOFF), pcap_keys);
> +	free_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_HS), pcap_keys);
> +	free_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_MIC), pcap_keys);
> +
> +	input_unregister_device(pcap_keys->input);
> +	kfree(pcap_keys);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver pcap_keys_device_driver = {
> +	.probe		= pcap_keys_probe,
> +	.remove		= pcap_keys_remove,

__devexit_p()

> +	.driver		= {
> +		.name	= "pcap-keys",
> +		.owner	= THIS_MODULE,
> +	}
> +};
> +
> +static int __init pcap_keys_init(void)
> +{
> +	return platform_driver_register(&pcap_keys_device_driver);
> +};
> +
> +static void __exit pcap_keys_exit(void)
> +{
> +	platform_driver_unregister(&pcap_keys_device_driver);
> +};
> +
> +module_init(pcap_keys_init);
> +module_exit(pcap_keys_exit);
> +
> +MODULE_DESCRIPTION("Motorola PCAP2 input events driver");
> +MODULE_AUTHOR("Ilya Petrov <ilya.muromec@gmail.com>");
> +MODULE_LICENSE("GPL");

Do we need MODULE_ALIAS() here?

Thanks!

-- 
Dmitry
