Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031926Ab0B1TCG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 14:02:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:49799 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030734Ab0B1TAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 14:00:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,556,1262592000"; 
   d="scan'208";a="496414089"
Date: Sun, 28 Feb 2010 20:01:18 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Denis Turischev <denis@compulab.co.il>
Cc: LKML <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH v3 3/3] gpio: add Intel SCH GPIO controller driver
Message-ID: <20100228190117.GC3589@sortiz.org>
References: <4B73DAEE.5080400@compulab.co.il>
 <4B73DBE9.2030307@compulab.co.il>
 <4B7C0DC3.3060907@compulab.co.il>
 <4B812C21.8000602@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B812C21.8000602@compulab.co.il>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denis,

On Sun, Feb 21, 2010 at 02:50:41PM +0200, Denis Turischev wrote:
> v2: there is no acpi_check_region, it will be implemented in mfd-core
> v3: patch refreshed against the latest Linus tree
As with patch #2 of that serie, patch still doesnt apply against Linus' latest
tree:

patching file drivers/gpio/Kconfig
Hunk #1 FAILED at 85.
1 out of 1 hunk FAILED -- saving rejects to file drivers/gpio/Kconfig.rej
patching file drivers/gpio/Makefile
Hunk #1 FAILED at 22.
1 out of 1 hunk FAILED -- saving rejects to file drivers/gpio/Makefile.rej
patching file drivers/gpio/sch_gpio.c

Cheers,
Samuel.


> Signed-off-by: Denis Turischev <denis@compulab.co.il>
> ---
>  drivers/gpio/Kconfig    |   16 +++
>  drivers/gpio/Makefile   |    1 +
>  drivers/gpio/sch_gpio.c |  282 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 299 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/gpio/sch_gpio.c
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 1f1d88a..1730068 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -85,6 +85,22 @@ config GPIO_VR41XX
>  	help
>  	  Say yes here to support the NEC VR4100 series General-purpose I/O Uint
> 
> +config GPIO_SCH
> +	tristate "Intel SCH GPIO"
> +	depends on GPIOLIB
> +	select LPC_SCH
> +	help
> +	  Say yes here to support GPIO interface on Intel Poulsbo SCH.
> +	  The Intel SCH contains a total of 14 GPIO pins. Ten GPIOs are
> +	  powered by the core power rail and are turned off during sleep
> +	  modes (S3 and higher). The remaining four GPIOs are powered by
> +	  the Intel SCH suspend power supply. These GPIOs remain
> +	  active during S3. The suspend powered GPIOs can be used to wake the
> +	  system from the Suspend-to-RAM state.
> +
> +	  This driver can also be built as a module. If so, the module
> +	  will be called sch-gpio.
> +
>  comment "I2C GPIO expanders:"
> 
>  config GPIO_MAX732X
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index 4868723..aa1d06e 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -22,3 +22,4 @@ obj-$(CONFIG_GPIO_CS5535)	+= cs5535-gpio.o
>  obj-$(CONFIG_GPIO_BT8XX)	+= bt8xxgpio.o
>  obj-$(CONFIG_GPIO_VR41XX)	+= vr41xx_giu.o
>  obj-$(CONFIG_GPIO_WM831X)	+= wm831x-gpio.o
> +obj-$(CONFIG_GPIO_SCH)		+= sch_gpio.o
> diff --git a/drivers/gpio/sch_gpio.c b/drivers/gpio/sch_gpio.c
> new file mode 100644
> index 0000000..761071a
> --- /dev/null
> +++ b/drivers/gpio/sch_gpio.c
> @@ -0,0 +1,282 @@
> +/*
> + *  sch_gpio.c - GPIO interface for Intel Poulsbo SCH
> + *
> + *  Copyright (c) 2010 CompuLab Ltd
> + *  Author: Denis Turischev <denis@compulab.co.il>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License 2 as published
> + *  by the Free Software Foundation.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; see the file COPYING.  If not, write to
> + *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/io.h>
> +#include <linux/errno.h>
> +#include <linux/acpi.h>
> +#include <linux/platform_device.h>
> +
> +#include <linux/gpio.h>
> +
> +static DEFINE_SPINLOCK(gpio_lock);
> +
> +#define CGEN	(0x00)
> +#define CGIO	(0x04)
> +#define CGLV	(0x08)
> +
> +#define RGEN	(0x20)
> +#define RGIO	(0x24)
> +#define RGLV	(0x28)
> +
> +static unsigned short gpio_ba;
> +
> +static int sch_gpio_core_direction_in(struct gpio_chip *gc, unsigned  gpio_num)
> +{
> +	u8 curr_dirs;
> +	unsigned short offset, bit;
> +
> +	spin_lock(&gpio_lock);
> +
> +	offset = CGIO + gpio_num / 8;
> +	bit = gpio_num % 8;
> +
> +	curr_dirs = inb(gpio_ba + offset);
> +
> +	if (!(curr_dirs & (1 << bit)))
> +		outb(curr_dirs | (1 << bit), gpio_ba + offset);
> +
> +	spin_unlock(&gpio_lock);
> +	return 0;
> +}
> +
> +static int sch_gpio_core_get(struct gpio_chip *gc, unsigned gpio_num)
> +{
> +	int res;
> +	unsigned short offset, bit;
> +
> +	offset = CGLV + gpio_num / 8;
> +	bit = gpio_num % 8;
> +
> +	res = !!(inb(gpio_ba + offset) & (1 << bit));
> +	return res;
> +}
> +
> +static void sch_gpio_core_set(struct gpio_chip *gc, unsigned gpio_num, int val)
> +{
> +	u8 curr_vals;
> +	unsigned short offset, bit;
> +
> +	spin_lock(&gpio_lock);
> +
> +	offset = CGLV + gpio_num / 8;
> +	bit = gpio_num % 8;
> +
> +	curr_vals = inb(gpio_ba + offset);
> +
> +	if (val)
> +		outb(curr_vals | (1 << bit), gpio_ba + offset);
> +	else
> +		outb((curr_vals & ~(1 << bit)), gpio_ba + offset);
> +	spin_unlock(&gpio_lock);
> +}
> +
> +static int sch_gpio_core_direction_out(struct gpio_chip *gc,
> +					unsigned gpio_num, int val)
> +{
> +	u8 curr_dirs;
> +	unsigned short offset, bit;
> +
> +	sch_gpio_core_set(gc, gpio_num, val);
> +
> +	spin_lock(&gpio_lock);
> +
> +	offset = CGIO + gpio_num / 8;
> +	bit = gpio_num % 8;
> +
> +	curr_dirs = inb(gpio_ba + offset);
> +	if (curr_dirs & (1 << bit))
> +		outb(curr_dirs & ~(1 << bit), gpio_ba + offset);
> +
> +	spin_unlock(&gpio_lock);
> +	return 0;
> +}
> +
> +static struct gpio_chip sch_gpio_core = {
> +	.label			= "sch_gpio_core",
> +	.owner			= THIS_MODULE,
> +	.direction_input	= sch_gpio_core_direction_in,
> +	.get			= sch_gpio_core_get,
> +	.direction_output	= sch_gpio_core_direction_out,
> +	.set			= sch_gpio_core_set,
> +};
> +
> +static int sch_gpio_resume_direction_in(struct gpio_chip *gc,
> +					unsigned gpio_num)
> +{
> +	u8 curr_dirs;
> +
> +	spin_lock(&gpio_lock);
> +
> +	curr_dirs = inb(gpio_ba + RGIO);
> +
> +	if (!(curr_dirs & (1 << gpio_num)))
> +		outb(curr_dirs | (1 << gpio_num) , gpio_ba + RGIO);
> +
> +	spin_unlock(&gpio_lock);
> +	return 0;
> +}
> +
> +static int sch_gpio_resume_get(struct gpio_chip *gc, unsigned gpio_num)
> +{
> +	return !!(inb(gpio_ba + RGLV) & (1 << gpio_num));
> +}
> +
> +static void sch_gpio_resume_set(struct gpio_chip *gc,
> +				unsigned gpio_num, int val)
> +{
> +	u8 curr_vals;
> +
> +	spin_lock(&gpio_lock);
> +
> +	curr_vals = inb(gpio_ba + RGLV);
> +
> +	if (val)
> +		outb(curr_vals | (1 << gpio_num), gpio_ba + RGLV);
> +	else
> +		outb((curr_vals & ~(1 << gpio_num)), gpio_ba + RGLV);
> +
> +	spin_unlock(&gpio_lock);
> +}
> +
> +static int sch_gpio_resume_direction_out(struct gpio_chip *gc,
> +					unsigned gpio_num, int val)
> +{
> +	u8 curr_dirs;
> +
> +	sch_gpio_resume_set(gc, gpio_num, val);
> +
> +	spin_lock(&gpio_lock);
> +
> +	curr_dirs = inb(gpio_ba + RGIO);
> +	if (curr_dirs & (1 << gpio_num))
> +		outb(curr_dirs & ~(1 << gpio_num), gpio_ba + RGIO);
> +
> +	spin_unlock(&gpio_lock);
> +	return 0;
> +}
> +
> +static struct gpio_chip sch_gpio_resume = {
> +	.label			= "sch_gpio_resume",
> +	.owner			= THIS_MODULE,
> +	.direction_input	= sch_gpio_resume_direction_in,
> +	.get			= sch_gpio_resume_get,
> +	.direction_output	= sch_gpio_resume_direction_out,
> +	.set			= sch_gpio_resume_set,
> +};
> +
> +static int __devinit sch_gpio_probe(struct platform_device *pdev)
> +{
> +	struct resource *res;
> +	int err;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
> +	if (!res)
> +		return -EBUSY;
> +
> +	if (!request_region(res->start, resource_size(res), pdev->name))
> +		return -EBUSY;
> +
> +	gpio_ba = res->start;
> +
> +	sch_gpio_core.base = 0;
> +	sch_gpio_core.ngpio = 10;
> +	sch_gpio_core.dev = &pdev->dev;
> +
> +	sch_gpio_resume.base = 10;
> +	sch_gpio_resume.ngpio = 4;
> +	sch_gpio_resume.dev = &pdev->dev;
> +
> +	err = gpiochip_add(&sch_gpio_core);
> +	if (err < 0)
> +		goto err_sch_gpio_core;
> +
> +	err = gpiochip_add(&sch_gpio_resume);
> +	if (err < 0)
> +		goto err_sch_gpio_resume;
> +
> +	/*
> +	 * GPIO[6:0] enabled by default
> +	 * GPIO7 is configured by the CMC as SLPIOVR
> +	 * Enable GPIO[9:8] core powered gpios explicitly
> +	 */
> +	outb(0x3, gpio_ba + CGEN + 1);
> +	/*
> +	 * SUS_GPIO[2:0] enabled by default
> +	 * Enable SUS_GPIO3 resume powered gpio explicitly
> +	 */
> +	outb(0x8, gpio_ba + RGEN);
> +
> +	return 0;
> +
> +err_sch_gpio_resume:
> +	gpiochip_remove(&sch_gpio_core);
> +
> +err_sch_gpio_core:
> +	release_region(res->start, resource_size(res));
> +	gpio_ba = 0;
> +
> +	return err;
> +}
> +
> +static int __devexit sch_gpio_remove(struct platform_device *pdev)
> +{
> +	struct resource *res;
> +	if (gpio_ba) {
> +		gpiochip_remove(&sch_gpio_core);
> +		gpiochip_remove(&sch_gpio_resume);
> +
> +		res = platform_get_resource(pdev, IORESOURCE_IO, 0);
> +
> +		release_region(res->start, resource_size(res));
> +		gpio_ba = 0;
> +	}
> +
> +	return 0;
> +}
> +
> +static struct platform_driver sch_gpio_driver = {
> +	.driver = {
> +		.name = "sch_gpio",
> +		.owner = THIS_MODULE,
> +	},
> +	.probe		= sch_gpio_probe,
> +	.remove		= __devexit_p(sch_gpio_remove),
> +};
> +
> +static int __init sch_gpio_init(void)
> +{
> +	return platform_driver_register(&sch_gpio_driver);
> +}
> +
> +static void __exit sch_gpio_exit(void)
> +{
> +	platform_driver_unregister(&sch_gpio_driver);
> +}
> +
> +module_init(sch_gpio_init);
> +module_exit(sch_gpio_exit);
> +
> +MODULE_AUTHOR("Denis Turischev <denis@compulab.co.il>");
> +MODULE_DESCRIPTION("GPIO interface for Intel Poulsbo SCH");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:sch_gpio");
> -- 
> 1.6.3.3
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
