Return-Path: <linux-kernel-owner+w=401wt.eu-S966818AbZLHWqC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966818AbZLHWqC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:46:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966765AbZLHWp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:45:58 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56654 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966671AbZLHWp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:45:57 -0500
Date: Tue, 8 Dec 2009 22:45:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>
Subject: Re: GPIO support for HTC Dream
Message-ID: <20091208224550.GA26915@n2100.arm.linux.org.uk>
References: <20091208102842.GH12264@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091208102842.GH12264@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 11:28:43AM +0100, Pavel Machek wrote:
> Add GPIO support for HTC Dream.
>     
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> index f780086..774c50e 100644
> --- a/arch/arm/mach-msm/Kconfig
> +++ b/arch/arm/mach-msm/Kconfig
> @@ -40,4 +40,8 @@ config MACH_TROUT
>  	help
>  	  Support for the HTC Dream, T-Mobile G1, Android ADP1 devices.
>  
> +config GENERIC_GPIO
> +	bool
> +	default y

Please arrange for this to be handled just like every other ARM
platform via a 'select' statement - eg:

config ARCH_AT91
        bool "Atmel AT91"
        select GENERIC_GPIO
        select ARCH_REQUIRE_GPIOLIB
        select HAVE_CLK

It is not nice to have multiple definitions of the same symbol scattered
throughout the Kconfig files.

> +
>  endif
> diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
> index 91e6f5c..4c2567e 100644
> --- a/arch/arm/mach-msm/Makefile
> +++ b/arch/arm/mach-msm/Makefile
> @@ -6,4 +6,4 @@ obj-y += clock.o clock-7x01a.o
>  
>  obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o
>  
> -obj-$(CONFIG_MACH_TROUT) += board-dream.o
> +obj-$(CONFIG_MACH_TROUT) += board-dream.o board-dream-gpio.o generic_gpio.o 
> diff --git a/arch/arm/mach-msm/board-dream-gpio.c b/arch/arm/mach-msm/board-dream-gpio.c
> new file mode 100644
> index 0000000..1b23a84
> --- /dev/null
> +++ b/arch/arm/mach-msm/board-dream-gpio.c
> @@ -0,0 +1,301 @@
> +/* arch/arm/mach-msm/board-dream-gpio.c
> + *
> + * Copyright (C) 2008 Google, Inc.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/irq.h>
> +#include <linux/pm.h>
> +#include <linux/sysdev.h>
> +#include <linux/io.h> 
> +
> +#include <asm/gpio.h>

linux/gpio.h is preferred over asm/gpio.h

> diff --git a/arch/arm/mach-msm/board-dream.c b/arch/arm/mach-msm/board-dream.c
> index d238e2c..4758957 100644
> --- a/arch/arm/mach-msm/board-dream.c
> +++ b/arch/arm/mach-msm/board-dream.c
> @@ -18,11 +18,13 @@
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
> +#include <linux/delay.h>
>  
>  #include <asm/mach-types.h>
>  #include <asm/mach/arch.h>
>  #include <asm/mach/map.h>
>  #include <asm/setup.h>
> +#include <asm/gpio.h>

ditto.

> diff --git a/arch/arm/mach-msm/generic_gpio.c b/arch/arm/mach-msm/generic_gpio.c
> new file mode 100644
> index 0000000..fe24d38
> --- /dev/null
> +++ b/arch/arm/mach-msm/generic_gpio.c
> @@ -0,0 +1,274 @@
> +/* arch/arm/mach-msm/generic_gpio.c
> + *
> + * Copyright (C) 2007 Google, Inc.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/errno.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <asm/gpio.h>

ditto.
