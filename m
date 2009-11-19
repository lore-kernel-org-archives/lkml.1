Return-Path: <linux-kernel-owner+w=401wt.eu-S1758026AbZKSCxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbZKSCxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 21:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757951AbZKSCx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 21:53:29 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:65513 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719AbZKSCx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 21:53:28 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+KEaaDykvuzjXlqQke135I
Date: Wed, 18 Nov 2009 18:53:30 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>,
       linux-omap@vger.kernel.org, Jani Nikula <ext-jani.1.nikula@nokia.com>
Subject: Re: linux-next: manual merge of the input tree with the omap tree
Message-ID: <20091119025329.GV29266@atomide.com>
References: <20091119131216.da16845c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091119131216.da16845c.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell <sfr@canb.auug.org.au> [091118 18:11]:
> Hi Dmitry,
> 
> Today's linux-next merge of the input tree got a conflict in
> arch/arm/mach-omap2/board-rx51-peripherals.c between commit
> ebff0472f451a07fae9f4e72bdc2af4c52ebb682 ("omap3: rx51: Add wl1251 wlan
> driver support") from the omap tree and commit
> 5018461a887d58f4601207deeebb7c352c2da20a ("ARM OMAP3: RX-51 board - add
> initialization of gpio keys") from the input tree.
> 
> Just overlapping additions.  I fixed it up (see below) and can carry the
> fix as necessary.

Thanks again for dealing with these merge conflicts again Stephen!

I've cherry picked 765af10de6d93820def9978c53ed828e4d3bd4f4 from Dmitry's
tree to keep things compiling. Then I've added a modified version of
5018461a887d58f4601207deeebb7c352c2da20a to omap for-next branch.

Dmitry, could you please drop 5018461a887d58f4601207deeebb7c352c2da20a from
your tree now?

Because of us moving the omap headers from mach to plat, there will be a
conflict otherwise. Sorry for all the hassles with this merge window, this
should be an issue for this merge window only.

Regards,

Tony



> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/mach-omap2/board-rx51-peripherals.c
> index caaeadc,a5c02a4..0000000
> --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
> +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
> @@@ -21,53 -20,103 +21,134 @@@
>   #include <linux/delay.h>
>   #include <linux/regulator/machine.h>
>   #include <linux/gpio.h>
> + #include <linux/gpio_keys.h>
>   #include <linux/mmc/host.h>
>   
>  -#include <mach/mcspi.h>
>  -#include <mach/mux.h>
>  -#include <mach/board.h>
>  -#include <mach/common.h>
>  -#include <mach/dma.h>
>  -#include <mach/gpmc.h>
>  -#include <mach/onenand.h>
>  -#include <mach/gpmc-smc91x.h>
>  +#include <plat/mcspi.h>
>  +#include <plat/mux.h>
>  +#include <plat/board.h>
>  +#include <plat/common.h>
>  +#include <plat/dma.h>
>  +#include <plat/gpmc.h>
>  +#include <plat/onenand.h>
>  +#include <plat/gpmc-smc91x.h>
>   
>   #include "mmc-twl4030.h"
>   
>   #define SYSTEM_REV_B_USES_VAUX3	0x1699
>   #define SYSTEM_REV_S_USES_VAUX3 0x8
>   
>  +#define RX51_WL1251_POWER_GPIO		87
>  +#define RX51_WL1251_IRQ_GPIO		42
>  +
>  +static void rx51_wl1251_set_power(bool enable);
>  +
>  +static struct wl12xx_platform_data wl1251_pdata = {
>  +	.set_power = rx51_wl1251_set_power,
>  +};
>  +
>  +static struct omap2_mcspi_device_config wl1251_mcspi_config = {
>  +	.turbo_mode	= 0,
>  +	.single_channel	= 1,
>  +};
>  +
>  +/* list all spi devices here */
>  +enum {
>  +	RX51_SPI_WL1251,
>  +};
>  +
>  +static struct spi_board_info rx51_peripherals_spi_board_info[] __initdata = {
>  +	[RX51_SPI_WL1251] = {
>  +		.modalias		= "wl1251",
>  +		.bus_num		= 4,
>  +		.chip_select		= 0,
>  +		.max_speed_hz   	= 48000000,
>  +		.mode                   = SPI_MODE_2,
>  +		.controller_data	= &wl1251_mcspi_config,
>  +		.platform_data		= &wl1251_pdata,
>  +	},
>  +};
>  +
> + #if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
> + 
> + #define RX51_GPIO_CAMERA_LENS_COVER	110
> + #define RX51_GPIO_CAMERA_FOCUS		68
> + #define RX51_GPIO_CAMERA_CAPTURE	69
> + #define RX51_GPIO_KEYPAD_SLIDE		71
> + #define RX51_GPIO_LOCK_BUTTON		113
> + #define RX51_GPIO_PROXIMITY		89
> + 
> + #define RX51_GPIO_DEBOUNCE_TIMEOUT	10
> + 
> + static struct gpio_keys_button rx51_gpio_keys[] = {
> + 	{
> + 		.desc			= "Camera Lens Cover",
> + 		.type			= EV_SW,
> + 		.code			= SW_CAMERA_LENS_COVER,
> + 		.gpio			= RX51_GPIO_CAMERA_LENS_COVER,
> + 		.active_low		= 1,
> + 		.debounce_interval	= RX51_GPIO_DEBOUNCE_TIMEOUT,
> + 	}, {
> + 		.desc			= "Camera Focus",
> + 		.type			= EV_KEY,
> + 		.code			= KEY_CAMERA_FOCUS,
> + 		.gpio			= RX51_GPIO_CAMERA_FOCUS,
> + 		.active_low		= 1,
> + 		.debounce_interval	= RX51_GPIO_DEBOUNCE_TIMEOUT,
> + 	}, {
> + 		.desc			= "Camera Capture",
> + 		.type			= EV_KEY,
> + 		.code			= KEY_CAMERA,
> + 		.gpio			= RX51_GPIO_CAMERA_CAPTURE,
> + 		.active_low		= 1,
> + 		.debounce_interval	= RX51_GPIO_DEBOUNCE_TIMEOUT,
> + 	}, {
> + 		.desc			= "Lock Button",
> + 		.type			= EV_KEY,
> + 		.code			= KEY_SCREENLOCK,
> + 		.gpio			= RX51_GPIO_LOCK_BUTTON,
> + 		.active_low		= 1,
> + 		.debounce_interval	= RX51_GPIO_DEBOUNCE_TIMEOUT,
> + 	}, {
> + 		.desc			= "Keypad Slide",
> + 		.type			= EV_SW,
> + 		.code			= SW_KEYPAD_SLIDE,
> + 		.gpio			= RX51_GPIO_KEYPAD_SLIDE,
> + 		.active_low		= 1,
> + 		.debounce_interval	= RX51_GPIO_DEBOUNCE_TIMEOUT,
> + 	}, {
> + 		.desc			= "Proximity Sensor",
> + 		.type			= EV_SW,
> + 		.code			= SW_FRONT_PROXIMITY,
> + 		.gpio			= RX51_GPIO_PROXIMITY,
> + 		.active_low		= 0,
> + 		.debounce_interval	= RX51_GPIO_DEBOUNCE_TIMEOUT,
> + 	}
> + };
> + 
> + static struct gpio_keys_platform_data rx51_gpio_keys_data = {
> + 	.buttons	= rx51_gpio_keys,
> + 	.nbuttons	= ARRAY_SIZE(rx51_gpio_keys),
> + };
> + 
> + static struct platform_device rx51_gpio_keys_device = {
> + 	.name	= "gpio-keys",
> + 	.id	= -1,
> + 	.dev	= {
> + 		.platform_data	= &rx51_gpio_keys_data,
> + 	},
> + };
> + 
> + static void __init rx51_add_gpio_keys(void)
> + {
> + 	platform_device_register(&rx51_gpio_keys_device);
> + }
> + #else
> + static void __init rx51_add_gpio_keys(void)
> + {
> + }
> + #endif /* CONFIG_KEYBOARD_GPIO || CONFIG_KEYBOARD_GPIO_MODULE */
> + 
>   static int board_keymap[] = {
>   	KEY(0, 0, KEY_Q),
>   	KEY(0, 1, KEY_O),
