Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbYGFTxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbYGFTxN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 15:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYGFTw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 15:52:58 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:59646 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbYGFTw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 15:52:58 -0400
Date: Sun, 6 Jul 2008 22:52:12 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v2] gpiolib: Allow user-selection
Message-ID: <20080706195212.GF21669@cs181140183.pp.htv.fi>
References: <200807031233.04229.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200807031233.04229.mb@bu3sch.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 12:33:03PM +0200, Michael Buesch wrote:
>...
> --- linux-next.orig/drivers/gpio/Kconfig	2008-07-03 11:31:08.000000000 +0200
> +++ linux-next/drivers/gpio/Kconfig	2008-07-03 11:36:14.000000000 +0200
> @@ -2,15 +2,40 @@
>  # GPIO infrastructure and expanders
>  #
>  
> -config HAVE_GPIO_LIB
> +config ARCH_WANT_OPTIONAL_GPIOLIB
>  	bool
>  	help
> +	  Select this config option from the architecture Kconfig, if
> +	  it is possible to use gpiolib on the architecture, but let the
> +	  user decide whether to actually build it or not.
> +	  Select this instead of ARCH_REQUIRE_GPIOLIB, if your architecture does
> +	  not depend on GPIOs being available, but rather let the user
> +	  decide whether he needs it or not.
> +
> +config ARCH_REQUIRE_GPIOLIB
> +	bool
> +	select GPIOLIB
> +	help
>  	  Platforms select gpiolib if they use this infrastructure
>  	  for all their GPIOs, usually starting with ones integrated
>  	  into SOC processors.
> +	  Selecting this from the architecture code will cause the gpiolib
> +	  code to always get built in.
> +
> +
> +
> +menuconfig GPIOLIB
> +	bool "GPIO Support"
> +	depends on ARCH_WANT_OPTIONAL_GPIOLIB || ARCH_REQUIRE_GPIOLIB
> +	select GENERIC_GPIO
> +	help
> +	  This enables GPIO support through the generic GPIO library.
> +	  You only need to enable this, if you also want to enable
> +	  one or more of the GPIO expansion card drivers below.
> +
> +	  If unsure, say N.
>...

The implementation of ARCH_REQUIRE_GPIOLIB does not match the description.

Matching the description would be:

menuconfig GPIOLIB
        bool "GPIO Support" if !ARCH_REQUIRE_GPIOLIB
        depends on ARCH_WANT_OPTIONAL_GPIOLIB || ARCH_REQUIRE_GPIOLIB
        default ARCH_REQUIRE_GPIOLIB
        select GENERIC_GPIO
        help
          ...

> --- linux-next.orig/arch/arm/configs/am200epdkit_defconfig	2008-07-03 11:31:05.000000000 +0200
> +++ linux-next/arch/arm/configs/am200epdkit_defconfig	2008-07-03 11:36:14.000000000 +0200
> @@ -668,7 +668,7 @@
>  #
>  # CONFIG_SPI is not set
>  # CONFIG_SPI_MASTER is not set
> -CONFIG_HAVE_GPIO_LIB=y
> +CONFIG_ARCH_REQUIRE_GPIOLIB=y
>...

Please don't do this kind of defconfig updates - it doesn't bring any
advantage but can create tons of patch conflicts.

The next time a defconfig gets updated it will anyway automatically be
fixed, and for defconfigs that aren't updated it doesn't create any
problems to keep them as they are today until they might one day get
updated.

> Greetings Michael.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

