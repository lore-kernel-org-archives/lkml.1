Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbXCLCKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbXCLCKv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 22:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbXCLCKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 22:10:51 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:8169 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932654AbXCLCKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 22:10:50 -0400
X-IronPort-AV: i="4.14,271,1170651600"; 
   d="scan'208"; a="30831376:sNHT23631328"
Subject: Re: [PATCH v2] Bitbanging i2c bus driver using the GPIO API
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: David Brownell <david-b@pacbell.net>, Jean Delvare <khali@linux-fr.org>,
       Bryan Wu <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org
In-Reply-To: <11735324081261-git-send-email-hskinnemoen@atmel.com>
References: <200703091345.44744.david-b@pacbell.net>
	 <11735324081261-git-send-email-hskinnemoen@atmel.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 12 Mar 2007 18:07:59 +0800
Message-Id: <1173694079.6638.13.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-10 at 14:13 +0100, Haavard Skinnemoen wrote:
> This is a very simple bitbanging i2c bus driver utilizing the new
> arch-neutral GPIO API. Useful for chips that don't have a built-in
> i2c controller, additional i2c busses, or testing purposes.
> 

Sorry for missing this hot discussion. Your idea is exactly what I want.
So many arch specific GPIO based I2C adapter implementation will benefit
from this.

> To use, include something similar to the following in the
> board-specific setup code:
> 
>   #include <linux/i2c-gpio.h>
> 
>   static struct i2c_gpio_platform_data i2c_gpio_data = {
> 	.sda_pin	= GPIO_PIN_FOO,
> 	.scl_pin	= GPIO_PIN_BAR,
>   };

Is this usage right, because 3 flags are added to this structure as
below:

struct i2c_gpio_platform_data {
	unsigned int sda_pin;
	unsigned int scl_pin;
	unsigned int sda_is_open_drain:1;
	unsigned int scl_is_open_drain:1;
	unsigned int scl_is_output_only:1;
};

>   static struct platform_device i2c_gpio_device = {
> 	.name		= "i2c-gpio",
> 	.id		= 0,
> 	.dev		= {
> 		.platform_data	= &i2c_gpio_data,
> 	},
>   };
> 
> Register this platform_device, set up the i2c pins as GPIO if
> required and you're ready to go.
> 
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> ---
> This patch is different from the first patch in the following ways:
>   * Handles pins set up as open drain (aka multidrive) by toggling
>     the output value instead of the direction
>   * Handles output-only SCL pins the same way, and also does not
>     install a getscl() callback for such pins
>   * Does not add anything to include/linux/i2c-ids.h
>   * Sets the output value explicitly after changing the direction to
>     output.
>   * Plugs a memory leak in remove() -- algo_data wasn't freed.
>   * Prints out the pin IDs in decimal, with an extra note when clock
>     stretching isn't supported
> 
> This version has been compile-tested only. I'll give it a spin when I
> get back to work on monday.
> 
> Dave, does this address your concerns?
> 
> Haavard   

Thanks a lot,  I will drop our GPIO based I2C driver and try this one on
our platform.

> +	if (!pdata->scl_is_output_only)
> +		bit_data->getscl = i2c_gpio_getscl,
> +
> +	bit_data->getsda	= i2c_gpio_getsda,
> +	bit_data->udelay	= 5,			/* 100 kHz */
> +	bit_data->timeout	= HZ / 10,		/* 100 ms */

Can we add these udelay/timeout to struct i2c_gpio_platform_data? And
let customer to choose these according their specific requirement. We
use Kconfig to do this, but Jean and David don't like the idea, -:(

Regards,
-Bryan Wu
