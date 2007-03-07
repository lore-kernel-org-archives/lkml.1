Return-Path: <linux-kernel-owner+w=401wt.eu-S932860AbXCGG7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860AbXCGG7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 01:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932863AbXCGG7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 01:59:17 -0500
Received: from smtp-103-wednesday.noc.nerim.net ([62.4.17.103]:3169 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932860AbXCGG7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 01:59:16 -0500
Date: Wed, 7 Mar 2007 07:58:22 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Bryan Wu <bryan.wu@analog.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sonic Zhang <sonic.adi@gmail.com>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
       mhfan@ustc.edu
Subject: Re: [PATCH -mm] Blackfin: blackfin i2c driver
Message-Id: <20070307075822.53e53c42.khali@linux-fr.org>
In-Reply-To: <1173247078.28531.24.camel@roc-desktop>
References: <1173164058.31825.16.camel@roc-desktop>
	<20070306214301.GA5590@martell.zuzino.mipt.ru>
	<1173247078.28531.24.camel@roc-desktop>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On Wed, 07 Mar 2007 13:57:58 +0800, Wu, Bryan wrote:
> Here is the updated blackfin i2c driver.
> 
> [PATCH] Blackfin: blackfin i2c driver
> 
> The i2c linux driver for blackfin architecture which supports both GPIO
> i2c operation and blackfin on-chip TWI controller i2c operation.
> 
> Signed-off-by: Bryan Wu <bryan.wu@analog.com> 
> ---
>  drivers/i2c/busses/Kconfig         |   47 ++++
>  drivers/i2c/busses/i2c-bfin-gpio.c |   98 +++++++++
>  drivers/i2c/busses/i2c-bfin-twi.c  |  589 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++

I'd prefer i2c-blackfin-gpio and i2c-blackfin-twi. Abreviations tend to
confuse newcomers.

>  3 files changed, 734 insertions(+)
> 
> Index: linux-2.6/drivers/i2c/busses/Kconfig
> ===================================================================
> --- linux-2.6.orig/drivers/i2c/busses/Kconfig	2007-03-07 13:32:02.000000000 +0800
> +++ linux-2.6/drivers/i2c/busses/Kconfig	2007-03-07 13:44:19.000000000 +0800
> @@ -5,6 +5,53 @@
>  menu "I2C Hardware Bus support"
>  	depends on I2C
>  
> +config I2C_BFIN_GPIO

I2C_BLACKFIN_GPIO

Please move the entries to the right location. The list is sorted
alphabetically if you didn't notice.

> +	tristate "Generic Blackfin and HHBF533/561 development board I2C support"

You can drop the trailing "I2C support", the user is in a menu named
"I2C hardware bus support" so it's pretty clear what we're talking
about.

> +	depends on I2C && EXPERIMENTAL
> +	select I2C_ALGOBIT
> +	help
> +	--
> +
> +menu "BFIN I2C SDA/SCL Selection"
> +	depends on I2C_BFIN_GPIO
> +config BFIN_SDA

I2C_BLACKFIN_SDA

> +	int "SDA is GPIO Number"

"SDA GPIO pin number"

> +	range 0 15 if (BF533 || BF532 || BF531) 

Trailing whitespace.

> +	range 0 47 if (BF534 || BF536 || BF537)
> +	range 0 47 if BF561
> +	default 2 if (BF533 || BF532 || BF531) 

Trailing whitespace.

No default for the other cases?

> +
> +config BFIN_SCL

I2C_BLACKFIN_SCL
Etc etc, all the options should start with I2C_BLACKFIN.

> +	int "SCL is GPIO Number"

"SCL GPIO pin number"

> +	range 0 15 if (BF533 || BF532 || BF531) 

Trailing whitespace, and many more after that. Please fix them all!

> +	range 0 47 if (BF534 || BF536 || BF537)
> +	range 0 47 if BF561
> +	default 3 
> +endmenu
> +
> +config I2C_BFIN_GPIO_CYCLE_DELAY
> +	int "Cycle Delay in usec"
> +	depends on I2C_BFIN_GPIO
> +	range 1 100 
> +	default 40

This should really not be a kernel configuration option. Please turn it
into a kernel module parameter or a sysfs attribute if you really need
it. Also note that we already have an interface to change this
value from user-space (using an ioctl on /dev/i2c-N) and that might be
sufficient for your needs.

And allowing 1 usec delay is probably not a good idea, I don't
recommend values below 6 usec with i2c-algo-bit.

> +
> +config I2C_BFIN_TWI
> +	tristate "Blackfin TWI I2C support"
> +	depends on I2C && (BF534 || BF536 || BF537)
> +	help
> +	  This the TWI I2C device driver for Blackfin 534/536/537.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called i2c-bfin-twi.
> +
> +config TWICLK_KHZ
> +	int "TWI clock (kHZ)"

kHz

> +	depends on I2C_BFIN_TWI
> +	default 50
> +	help
> +	  The unit of the TWI clock is kilo HZ. Please divide the clock 
> +	  by 1024 if you count it in HZ. The value should be less than 400.

Why don't you use "range" here too to ensure that the value is actually
less than 400? Either way, same as above, IMHO this should not be a
compilation-time decision.

A kHz is really 1000 Hz, not 1024. And everybody skilled enough to
configure a kernel should know that, I doubt it's worth reminding.

> +
>  config I2C_ALI1535
>  	tristate "ALI 1535"
>  	depends on I2C && PCI

All these options won't work really well until you also change
drivers/i2c/busses/Makefile to make something useful with them...

-- 
Jean Delvare
