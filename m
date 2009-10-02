Return-Path: <linux-kernel-owner+w=401wt.eu-S1757804AbZJBNOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804AbZJBNOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 09:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757779AbZJBNOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 09:14:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:3563 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757773AbZJBNOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 09:14:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,494,1249282800"; 
   d="scan'208";a="453989595"
Date: Fri, 2 Oct 2009 15:15:47 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org, Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH v2] mfd: ADP5520 Multifunction LCD Backlight and Keypad
 Input Device Driver
Message-ID: <20091002131546.GB7575@sortiz.org>
References: <1253212036-29445-1-git-send-email-vapier@gentoo.org>
 <1253682664-27040-1-git-send-email-vapier@gentoo.org>
 <20091001140948.GD10199@sortiz.org>
 <8A42379416420646B9BFAC9682273B6D0E33AC35@limkexm3.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8A42379416420646B9BFAC9682273B6D0E33AC35@limkexm3.ad.analog.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Fri, Oct 02, 2009 at 10:38:16AM +0100, Hennerich, Michael wrote:
> >> +static int __devinit adp5520_add_subdevs(struct adp5520_chip *chip,
> >> +					struct adp5520_platform_data
> *pdata)
> >> +{
> >> +	struct adp5520_subdev_info *subdev;
> >> +	struct platform_device *pdev;
> >> +	int i, ret = 0;
> >> +
> >> +	for (i = 0; i < pdata->num_subdevs; i++) {
> >> +		subdev = &pdata->subdevs[i];
> >> +
> >> +		pdev = platform_device_alloc(subdev->name, subdev->id);
> >> +
> >> +		pdev->dev.parent = chip->dev;
> >> +		pdev->dev.platform_data = subdev->platform_data;
> >> +
> >> +		ret = platform_device_add(pdev);
> >> +		if (ret)
> >> +			goto failed;
> >> +	}
> >> +	return 0;
> >Here I would expect the MFD core driver to know about all the potential
> >subdevices and add them in that routine, and not take the subdevices
> list from
> >the platform definition.
> >I realize da903x has the same issue btw.
> 
> The ADP5520 is an I2C device and gets registered via struct
> i2c_board_info.
> How about having multiple ADP5520 in a system with different I2C salve
> addresses?
> Each ADP5520 having different Keypad, Backlight and GPIO configurations
> passed in platform_data?
> How will they map? The MFD core is struct resource centric, which is not
> going to help here.
With 2 of those devices, your board file would look like that:

static struct i2c_board_info __initdata board_i2c_board_info[] = {
	{	/* APD5520 #1 */
		I2C_BOARD_INFO("pmic-adp5520", SLAVE_ADDR_1),
		.platform_data	= &apd5520_platform_1,
	},
	{	/* APD5520 #2 */
		I2C_BOARD_INFO("pmic-adp5520", SLAVE_ADDR_2),
		.platform_data	= &apd5520_platform_2,
	},
};

and your platform data would be an aggregation of all subdevices platform data
structures:

struct adp5520_platform_data {
	struct adp5520_leds_platfrom_data *leds;
	struct adp5520_keys_platfrom_data *keyp;
	struct adp5520_gpio_platfrom_data *gpio;
}

Then, your mfd/adp5520.c will have that piece of code:

static struct platform_device adp5520_gpio_device = {
	.name	= "adp5520-gpio",
	.id	= -1,
}

static struct platform_device *adp5520_subdevs[] = {
	&adp5520_gpio_device,
	&adp5520_leds_device,
	&adp5520_keyp_device,
}

Finally, your i2c probe routine would assign platform_data pointers to te
right devices:

static int __devinit adp5520_probe(struct i2c_client *client,
					const struct i2c_device_id *id)
{
	struct adp5520_platform_data *pdata = client->dev.platform_data; 
[...]
	for (i = 0; i < ARRAY_SIZE(adp5520_subdevs); i++) {
		adp5520_subdevs[i]->dev.parent = &client->dev;
		adp5520_assign_pdata(&adp5520_subdevs[i], pdata);
	}

	platform_add_devices(adp5520_subdevs,
			ARRAY_SIZE(adp5520_subdevs)); 
}

Where adp5520_assign_pdata() is a routine setting the platform_device's
platform_data pointer according e.g. to the platform_device name field.

Would that make sense to you ?

Cheers,
Samuel.

> I could be doing something like this:
>                            
> Index: drivers/mfd/adp5520.c
> 
> ===================================================================
> 
> --- drivers/mfd/adp5520.c       (revision 7535)
> 
> +++ drivers/mfd/adp5520.c       (working copy)
> 
> @@ -25,6 +25,7 @@
> 
>  #include <linux/irq.h>
> 
>  #include <linux/workqueue.h>
> 
>  #include <linux/i2c.h>
> 
> +#include <linux/mfd/core.h>
> 
>  
> 
>  #include <linux/mfd/adp5520.h>
> 
>  
> 
> @@ -235,6 +236,21 @@
> 
>         return ret;
> 
>  }
> 
>  
> 
> +static struct mfd_cell __devinitdata adp5520_cells[] = {
> 
> +       {
> 
> +               .name = "adp5520-backlight",
> 
> +       },
> 
> +       {
> 
> +               .name = "adp5520-led",
> 
> +       },
> 
> +       {
> +               .name = "adp5520-gpio",
> +       },
> +       {
> +               .name = "adp5520-keys",
> +       },
> +};
> +
>  static int __devinit adp5520_probe(struct i2c_client *client,
>                                         const struct i2c_device_id *id)
>  {
> @@ -284,11 +300,20 @@
>                 goto out_free_irq;
>         }
> 
> +#if 0
>         ret = adp5520_add_subdevs(chip, pdata);
> 
>         if (!ret)
>                 return ret;
> +#endif
> 
> +       ret = mfd_add_devices(&chip->dev, id->driver_data,
> +                       adp5520_cells, ARRAY_SIZE(adp5520_cells),
> +                       NULL, client->irq);
> +
> +       if (!ret)
> +               return ret;
> +
>  out_free_irq:
>         if (chip->irq)
>                 free_irq(chip->irq, chip);
> @@ -337,7 +362,8 @@
>  #endif
> 
>  static const struct i2c_device_id adp5520_id[] = {
> -       { "pmic-adp5520", 0 },
> +       { "adp5520", ID_ADP5520 },
> +       { "adp5501", ID_ADP5501 },
>         { }
>  };
>  MODULE_DEVICE_TABLE(i2c, adp5520_id); 
> 
> 
> However this would just work for exactly one ADP5520 in a system.
> A way out could be to append the I2C salve address to the cell .name?
> 
> Comments appreciated.
> 
> >
> >Also, please note that you could use the mfd-core API for adding
> devices, but
> >that's just optional.
> >
> >Cheers,
> >Samuel.
> >
> >--
> >Intel Open Source Technology Centre
> >http://oss.intel.com/
> 
> Best regards,
> Michael

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
