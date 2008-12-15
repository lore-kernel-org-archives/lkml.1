Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbYLOHf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbYLOHf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 02:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbYLOHft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 02:35:49 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:15254 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbYLOHfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 02:35:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l4zhD85du1SGuTptNlR1BAudVPVq8+L/85O3Rb0Ucigtm9Wyg0Flg4EVyeyRx+71zk
         428gnSAwnUU9//7uoY50TM9+Gy8Ee6KVJI5rjaRHAv8RJQAo2SA4mAnV9YRH2+SPiL5z
         DEWTCjEK/U9atmRPuBLyxImuF3KyGbNqLKFh0=
Date: Mon, 15 Dec 2008 02:35:40 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Balaji Rao <balajirrao@openmoko.org>
Cc: linux-kernel@vger.kernel.org, Andy Green <andy@openmoko.com>
Subject: Re: [PATCH 6/7] input: PCF50633 input driver
Message-ID: <20081215073540.GB1454@anvil.corenet.prv>
References: <20081214110152.3307.50843.stgit@cff.thadambail> <20081214110341.3307.12766.stgit@cff.thadambail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081214110341.3307.12766.stgit@cff.thadambail>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balaji,

On Sun, Dec 14, 2008 at 04:33:41PM +0530, Balaji Rao wrote:
> Signed-off-by: Balaji Rao <balajirrao@openmoko.org>

Looks good, some small nitpicks:

>  
> +config INPUT_PCF50633_PMU
> +	tristate "PCF50633 PMU events"
> +	depends on MFD_PCF50633
> +	help
> +	 Say Y to include support for input events on NXP PCF50633.
> +

I'd like to see something like ".. support for deliveing PMU events via
input layer on NXP PCF50633".

>  endif
> diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
> index d7db2ae..bb62e6e 100644
> --- a/drivers/input/misc/Makefile
> +++ b/drivers/input/misc/Makefile
> @@ -21,3 +21,4 @@ obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
>  obj-$(CONFIG_INPUT_UINPUT)		+= uinput.o
>  obj-$(CONFIG_INPUT_APANEL)		+= apanel.o
>  obj-$(CONFIG_INPUT_SGI_BTNS)		+= sgi_btns.o
> +obj-$(CONFIG_INPUT_PCF50633_PMU)	+= pcf50633-input.o
> diff --git a/drivers/input/misc/pcf50633-input.c b/drivers/input/misc/pcf50633-input.c
> new file mode 100644
> index 0000000..36ea8b2
> --- /dev/null
> +++ b/drivers/input/misc/pcf50633-input.c
> @@ -0,0 +1,119 @@
> +/* NXP PCF50633 Input Driver
> + *
> + * (C) 2006-2008 by Openmoko, Inc.
> + * Author: Balaji Rao <balajirrao@openmoko.org>
> + * All rights reserved.
> + *
> + * Broken down from monstrous PCF50633 driver mainly by
> + * Harald Welte, Andy Green and Werner Almesberger
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
> + * MA 02111-1307 USA
> + */
> +
> +#include <linux/input.h>
> +
> +#include <linux/mfd/pcf50633/core.h>
> +#include <linux/mfd/pcf50633/input.h>
> +
> +static void
> +pcf50633_input_irq(struct pcf50633 *pcf, int irq, void *unused)
> +{
> +	struct input_dev *input_dev = pcf->input.input_dev;
> +	int onkey_released;
> +
> +	/* We report only one event depending on the key press status */
> +	onkey_released = pcf50633_reg_read(pcf, PCF50633_REG_OOCSTAT)
> +						& PCF50633_OOCSTAT_ONKEY;
> +
> +	if (irq == PCF50633_IRQ_ONKEYF && !onkey_released)
> +		input_report_key(input_dev, KEY_POWER, 1);
> +	else if (irq == PCF50633_IRQ_ONKEYR && onkey_released)
> +		input_report_key(input_dev, KEY_POWER, 0);
> +
> +	input_sync(input_dev);
> +}
> +
> +int __init pcf50633_input_probe(struct platform_device *pdev)

Static? __devinit?

> +{
> +	struct pcf50633 *pcf;
> +	struct input_dev *input_dev;
> +	int ret;
> +
> +	pcf = platform_get_drvdata(pdev);
> +
> +	input_dev = input_allocate_device();
> +	if (!input_dev)
> +		return -ENOMEM;
> +
> +	input_dev->name = "PCF50633 PMU events";
> +	input_dev->id.bustype = BUS_I2C;
> +
> +	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_PWR);
> +	set_bit(KEY_POWER, input_dev->keybit);
> +
> +	ret = input_register_device(input_dev);
> +	if (ret)
> +		goto out;
> +
> +	pcf->input.input_dev = input_dev;
> +
> +	/* Set up interrupt handlers */
> +	pcf->irq_handler[PCF50633_IRQ_ONKEYR].handler = pcf50633_input_irq;
> +	pcf->irq_handler[PCF50633_IRQ_ONKEYF].handler = pcf50633_input_irq;
> +
> +	return 0;
> +
> +out:
> +	input_free_device(input_dev);
> +	return ret;
> +}
> +
> +static int __devexit pcf50633_input_remove(struct platform_device *pdev)
> +{
> +	struct pcf50633 *pcf;
> +
> +	pcf = platform_get_drvdata(pdev);
> +
> +	input_unregister_device(pcf->input.input_dev);
> +	input_free_device(pcf->input.input_dev);

Don't call input_free_device() after input_unregister_device(), it will
lead to double free.

> +
> +	return 0;
> +}
> +
> +struct platform_driver pcf50633_input_driver = {
> +	.driver = {
> +		.name = "pcf50633-input",
> +	},
> +	.probe = pcf50633_input_probe,
> +	.remove = __devexit_p(pcf50633_input_remove),
> +};
> +
> +static int __init pcf50633_input_init(void)
> +{
> +		return platform_driver_register(&pcf50633_input_driver);

Just one tab should be enough.

> +}
> +module_init(pcf50633_input_init);
> +
> +static void __exit pcf50633_input_exit(void)
> +{
> +		platform_driver_unregister(&pcf50633_input_driver);

Same here.

> +}
> +module_exit(pcf50633_input_exit);
> +
> +MODULE_AUTHOR("Balaji Rao <balajirrao@openmoko.org>");
> +MODULE_DESCRIPTION("PCF50633 input driver");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:pcf50633-input");
> 

-- 
Dmitry
