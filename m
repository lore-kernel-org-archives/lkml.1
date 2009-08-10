Return-Path: <linux-kernel-owner+w=401wt.eu-S1752287AbZHJSe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbZHJSe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 14:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbZHJSe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 14:34:27 -0400
Received: from mga05.intel.com ([192.55.52.89]:16341 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751158AbZHJSe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 14:34:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,354,1246863600"; 
   d="scan'208";a="715503200"
Date: Mon, 10 Aug 2009 20:33:21 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, eric.y.miao@gmail.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, openezx-devel@lists.openezx.org,
       Ilya Petrov <ilya.muromec@gmail.com>,
       Antonio Ospite <ospite@studenti.unina.it>
Subject: Re: [PATCH v3] input: PCAP2 misc input driver
Message-ID: <20090810183319.GC9547@sortiz.org>
References: <1249678456-15381-1-git-send-email-drwyrm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249678456-15381-1-git-send-email-drwyrm@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel.

On Fri, Aug 07, 2009 at 10:54:16PM +0200, Daniel Ribeiro wrote:
> This is a driver for misc input events for the PCAP2 PMIC, it handles
> the Power key and the Headphone button.
Applied, thanks.

Cheers,
Samuel.


> Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
> Signed-off-by: Ilya Petrov <ilya.muromec@gmail.com>
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> 
> ---
> 
> Changes since v2:
>   * Get pcap data from the parent device, don't abuse
>     platform device drvdata
> 
> pcap_keys v2 is here: http://patchwork.kernel.org/patch/38863/
> 
>  drivers/input/misc/Kconfig     |   11 +++
>  drivers/input/misc/Makefile    |    1 +
>  drivers/input/misc/pcap_keys.c |  144 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 156 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> index 1acfa3a..b9cbb5e 100644
> --- a/drivers/input/misc/Kconfig
> +++ b/drivers/input/misc/Kconfig
> @@ -269,4 +269,15 @@ config INPUT_DM355EVM
>  
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called dm355evm_keys.
> +
> +config INPUT_PCAP
> +	tristate "Motorola EZX PCAP misc input events"
> +	depends on EZX_PCAP
> +	help
> +	  Say Y here if you want to use Power key and Headphone button
> +	  on Motorola EZX phones.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called pcap_keys.
> +
>  endif
> diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
> index 0d979fd..679bae3 100644
> --- a/drivers/input/misc/Makefile
> +++ b/drivers/input/misc/Makefile
> @@ -26,3 +26,4 @@ obj-$(CONFIG_INPUT_TWL4030_PWRBUTTON)	+= twl4030-pwrbutton.o
>  obj-$(CONFIG_INPUT_UINPUT)		+= uinput.o
>  obj-$(CONFIG_INPUT_WISTRON_BTNS)	+= wistron_btns.o
>  obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
> +obj-$(CONFIG_INPUT_PCAP)		+= pcap_keys.o
> diff --git a/drivers/input/misc/pcap_keys.c b/drivers/input/misc/pcap_keys.c
> new file mode 100644
> index 0000000..7ea9693
> --- /dev/null
> +++ b/drivers/input/misc/pcap_keys.c
> @@ -0,0 +1,144 @@
> +/*
> + *  Input driver for PCAP events:
> + *   * Power key
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
> +	case PCAP_IRQ_MIC:
> +		input_report_key(pcap_keys->input, KEY_HP, !pstat);
> +		break;
> +	}
> +
> +	input_sync(pcap_keys->input);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int __devinit pcap_keys_probe(struct platform_device *pdev)
> +{
> +	int err = -ENOMEM;
> +	struct pcap_keys *pcap_keys;
> +	struct input_dev *input_dev;
> +
> +	pcap_keys = kmalloc(sizeof(struct pcap_keys), GFP_KERNEL);
> +	if (!pcap_keys)
> +		return err;
> +
> +	pcap_keys->pcap = dev_get_drvdata(pdev->dev.parent);
> +
> +	input_dev = input_allocate_device();
> +	if (!input_dev)
> +		goto fail;
> +
> +	pcap_keys->input = input_dev;
> +
> +	platform_set_drvdata(pdev, pcap_keys);
> +	input_dev->name = pdev->name;
> +	input_dev->phys = "pcap-keys/input0";
> +	input_dev->id.bustype = BUS_HOST;
> +	input_dev->dev.parent = &pdev->dev;
> +
> +	__set_bit(EV_KEY, input_dev->evbit);
> +	__set_bit(KEY_POWER, input_dev->keybit);
> +	__set_bit(KEY_HP, input_dev->keybit);
> +
> +	err = input_register_device(input_dev);
> +	if (err)
> +		goto fail_allocate;
> +
> +	err = request_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_ONOFF),
> +			pcap_keys_handler, 0, "Power key", pcap_keys);
> +	if (err)
> +		goto fail_register;
> +
> +	err = request_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_MIC),
> +			pcap_keys_handler, 0, "Headphone button", pcap_keys);
> +	if (err)
> +		goto fail_pwrkey;
> +
> +	return 0;
> +
> +fail_pwrkey:
> +	free_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_ONOFF), pcap_keys);
> +fail_register:
> +	input_unregister_device(input_dev);
> +	goto fail;
> +fail_allocate:
> +	input_free_device(input_dev);
> +fail:
> +	kfree(pcap_keys);
> +	return err;
> +}
> +
> +static int __devexit pcap_keys_remove(struct platform_device *pdev)
> +{
> +	struct pcap_keys *pcap_keys = platform_get_drvdata(pdev);
> +
> +	free_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_ONOFF), pcap_keys);
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
> +	.remove		= __devexit_p(pcap_keys_remove),
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
> +MODULE_ALIAS("platform:pcap_keys");
> -- 
> tg: (9097083..) ezx/pcap_keys (depends on: ezx/local/pcap)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
