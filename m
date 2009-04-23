Return-Path: <linux-kernel-owner+w=401wt.eu-S1759914AbZDWTOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759914AbZDWTOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759920AbZDWTN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:13:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41383 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759902AbZDWTNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:13:54 -0400
Date: Thu, 23 Apr 2009 20:13:45 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: eric.miao@marvell.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, philipp.zabel@gmail.com,
       lrg@slimlogic.co.uk
Message-ID: <20090423191345.GC6642@sirena.org.uk>
References: <87iqkvp6i3.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iqkvp6i3.fsf@free.fr>
X-Cookie: Don't Worry, Be Happy.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Patch to add mioa701 glue for voltage regulation
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 08:30:44PM +0200, Robert Jarzmik wrote:

> I have that patch which adds voltage regulation definitions to mioa701
> board. The trick is, this patch depends on two others :

>  - one which will be merged through Mark's regulator tree.
>    This one is mandatory as a compiling dependency exists through include files.

Not my regulator tree, Liam's regulator tree - (CCed, not deleting any
text for him).

>  - one which will be merge through Eric pxa tree.
>    This is the cpufreq one, and has a "very weak" dependency, as only the
>    "vcc_core" name _is_ the dependency.

> I think the easiest way to solve the compiling dependency
> (include/linux/regulator.max1586.h) is to make that patch go through regulator
> tree as well for linux-next, even if it's arm machine specific, don't you ?

Either that or merge the regulator driver via Eric's tree - I'd expect
it's more likely that there would be collisions with other changes to
the ARM machine support than with the regulator API.

Another option would be to create a git branch with the regulator driver
in it which gets merged in by both Eric and Liam.

> >From 7d3f66dba8875567fd814ea67ed9b0645a4f5f70 Mon Sep 17 00:00:00 2001
> From: Robert Jarzmik <robert.jarzmik@free.fr>
> Date: Mon, 20 Apr 2009 16:52:25 +0200
> Subject: [PATCH] mioa701: add Maxim 1586 voltage regulator
> 
> On this board, the PXA272 CPU voltage VCC_CORE is provided
> by a Maxim 1586 voltage regulator. Use the regulator
> framework to provide VCC_CORE control. When cpufreq will be
> updated to ask for vcc_core, this will optimize power
> drained by the board.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  arch/arm/mach-pxa/mioa701.c |   52 +++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 52 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-pxa/mioa701.c b/arch/arm/mach-pxa/mioa701.c
> index 204263d..facff90 100644
> --- a/arch/arm/mach-pxa/mioa701.c
> +++ b/arch/arm/mach-pxa/mioa701.c
> @@ -37,6 +37,7 @@
>  #include <linux/wm97xx_batt.h>
>  #include <linux/mtd/physmap.h>
>  #include <linux/usb/gpio_vbus.h>
> +#include <linux/regulator/max1586.h>
>  
>  #include <asm/mach-types.h>
>  #include <asm/mach/arch.h>
> @@ -716,6 +717,48 @@ static struct wm97xx_batt_info mioa701_battery_data = {
>  };
>  
>  /*
> + * Voltage regulation
> + */
> +static struct regulator_consumer_supply max1586_consumers[] = {
> +	{
> +		.supply = "vcc_core",
> +	}
> +};
> +
> +static struct regulator_init_data max1586_v3_info = {
> +	.constraints = {
> +		.name = "vcc_core range",
> +		.min_uV = 1000000,
> +		.max_uV = 1705000,
> +		.always_on = 1,
> +		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
> +	},
> +	.num_consumer_supplies = ARRAY_SIZE(max1586_consumers),
> +	.consumer_supplies = max1586_consumers,
> +};
> +
> +static struct regulator_init_data max1586_v6_info = {
> +	.constraints = {
> +		.name = "vcc_usim range",
> +		.min_uV = 1,
> +		.max_uV = 3000000,
> +		.always_on = 1,
> +		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
> +	},

This reflects the issue I mentioned with your regulator driver not
implementing enable and disable.  This also makes the always_on
constraint look very suspicious - if something did set that then the
regulator would in fact go off which looks odd.

> +	.num_consumer_supplies = 0,
> +};
> +
> +static struct max1586_subdev_data max1586_subdevs[] = {
> +	{ .name = "vcc_core", .id = MAX1586_V3,
> +	  .platform_data = &max1586_v3_info },
> +};

What about vcc_usim?  I'd expect tools like sparse will complain about
it being unreference.

> +
> +static struct max1586_platform_data max1586_info = {
> +	.subdevs = max1586_subdevs,
> +	.num_subdevs = ARRAY_SIZE(max1586_subdevs),
> +};
> +
> +/*
>   * Camera interface
>   */
>  struct pxacamera_platform_data mioa701_pxacamera_platform_data = {
> @@ -733,6 +776,13 @@ static struct i2c_board_info __initdata mioa701_i2c_devices[] = {
>  	},
>  };
>  
> +static struct i2c_board_info __initdata mioa701_pi2c_devices[] = {
> +	{
> +		I2C_BOARD_INFO("max1586", 0x14),
> +		.platform_data = &max1586_info,
> +	},
> +};
> +
>  static struct soc_camera_link iclink = {
>  	.bus_id		= 0, /* Match id in pxa27x_device_camera in device.c */
>  	.board_info	= &mioa701_i2c_devices[0],
> @@ -827,7 +877,9 @@ static void __init mioa701_machine_init(void)
>  	platform_add_devices(devices, ARRAY_SIZE(devices));
>  	gsm_init();
>  
> +	i2c_register_board_info(1, ARRAY_AND_SIZE(mioa701_pi2c_devices));
>  	pxa_set_i2c_info(&i2c_pdata);
> +	pxa27x_set_i2c_power_info(NULL);
>  	pxa_set_camera_info(&mioa701_pxacamera_platform_data);
>  }
>  
> -- 
> 1.6.2.1
> 
> 
> -------------------------------------------------------------------
> List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
> 
