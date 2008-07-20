Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbYGTV5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbYGTV5y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 17:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbYGTV5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 17:57:45 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:57843 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYGTV5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 17:57:44 -0400
Date: Sun, 20 Jul 2008 14:56:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       Piot Skamruk <piotr.skamruk@gmail.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, openwrt-devel@lists.openwrt.org,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH v3] Add GPIO-based MMC/SD driver
Message-Id: <20080720145659.53b8e50e.randy.dunlap@oracle.com>
In-Reply-To: <200807202148.59851.mb@bu3sch.de>
References: <200807202148.59851.mb@bu3sch.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jul 2008 21:48:58 +0200 Michael Buesch wrote:

> This driver hooks up the mmc_spi and spi_gpio modules so that
> MMC/SD cards can be used on a GPIO based bus by bitbanging
> the SPI protocol in software.
> 
> This driver provides a configfs interface to dynamically create
> and destroy GPIO-based MMC/SD card interfaces. It also provides
> a platform device interface API.
> See Documentation/gpiommc.txt for details.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> This driver is used in OpenWrt since quite some time, so please
> consider for inclusion in mainline.
> 
> Changes since v2: The sysfs interface has been replaced by a configfs interface.
> Although I don't really like the bloat this adds (this is a driver for embedded
> machines), I do like the much cleaner interface and I think it's worth the bloat.

> Index: linux-next/Documentation/gpiommc.txt
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-next/Documentation/gpiommc.txt	2008-07-20 21:40:47.000000000 +0200
> @@ -0,0 +1,97 @@

...

One minor nit below, otherwise looks good to me.
Thanks.


> +Registering devices via configfs
> +================================
> +
> +MMC/SD cards connected via GPIO often are a pretty dynamic thing, as for example
> +selfmade hacks for soldering an MMC/SD card to standard GPIO pins on embedded
> +hardware are a common situation.
> +So we provide a dynamic interface to conveniently handle adding and removing
> +devices from userspace, without the need to recompile the kernel.
> +
> +The "gpiommc" subdirectory at the configfs mountpoint is used for handling
> +the dynamic configuration.
> +
> +To create a new device, it must first be allocated with mkdir.
> +The following command will allocate a device named "my_mmc":
> +	mkdir /config/gpiommc/my_mmc
> +
> +There are several configuration files available in the new
> +/config/gpiommc/my_mmc/ directory:
> +
> +gpio_data_in			= The SPI data-IN GPIO pin number.
> +gpio_data_out			= The SPI data-OUT GPIO pin number.
> +gpio_clock			= The SPI Clock GPIO pin number.
> +gpio_chipselect			= The SPI Chipselect GPIO pin number.
> +gpio_chipselect_activelow	= Boolean. If 0, Chipselect is active-HIGH.
> +				  If 1, Chipselect is active-LOW.
> +spi_mode			= The SPI data mode. Can be 0-3.


> +spi_delay			= Enable all delays in the lowlevel bitbanging.
> +max_bus_speed			= The maximum SPI bus speed. In Hertz.
> +
> +register			= Not a configuration parameter.
> +				  Used to register the configured card
> +				  with the kernel.
> +
> +The device must first get configured and then registered by writing "1" to
> +the "register" file.
> +The configuration parameters "gpio_data_in", "gpio_data_out", "gpio_clock"
> +and "gpio_chipselect" are essential and _must_ be configured before writing
> +"1" to the "register" file. The registration will fail, otherwise.
> +
> +The default values for the other parameters are:
> +gpio_chipselect_activelow	= 1		(CS active-LOW)
> +spi_mode			= 0		(SPI_MODE_0)
> +spi_delay			= 1		(enabled)
> +max_bus_speed			= 5000000	(5 Mhz)
> +
> +Configuration values can not be changed after registration. To unregister

                        cannot

> +the device, write a "0" to the "register" file. The configuration can be
> +changed again after unregistering.


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
