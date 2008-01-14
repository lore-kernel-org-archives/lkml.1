Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbYANIEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbYANIEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 03:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbYANIEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 03:04:39 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:18788 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbYANIEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 03:04:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UEx7ZdwaTwKylOPJuazRy6pIxuxs10G1AKtENQbKodnP2vjx/RGFnCnve0f3SpwEfMlmvSxJSrQ8EMs8Xt7NSUpQiSYQoRNOI9yabxUihI9oezGxzMCMAPk6k6V8DtUtKkhIUdWORgium426wDLgM1lCX0C1JwiKfejmxhumSiE=
Message-ID: <8bd0f97a0801140004q6a32c2ceh397a2208d3012f0e@mail.gmail.com>
Date: Mon, 14 Jan 2008 03:04:36 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Marc Pignat" <marc.pignat@hevs.ch>
Subject: Re: [RFC, PATCH] watchdog on gpio
Cc: wim@iguana.be, linux-kernel@vger.kernel.org
In-Reply-To: <200801101611.08867.marc.pignat@hevs.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801101611.08867.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 10, 2008 10:11 AM, Marc Pignat <marc.pignat@hevs.ch> wrote:
> watchdog driver for embedded systems with a supervisor watchdog (MAX823 or so)
> connected to a gpio. This is the platform_driver and needs platform_data for
> defining the gpio pin and the watchdog timeout.

generic gpio watchdog is good stuff ...

> #include <linux/gpio_wdt.h>

perhaps "watchdog" rather than "wdt" considering it's already
"linux/watchdog.h" ?

> --- a/drivers/watchdog/gpio_wdt.c       1970-01-01 01:00:00.000000000 +0100
> +++ b/drivers/watchdog/gpio_wdt.c       2008-01-10 16:06:09.000000000 +0100
> +#include <asm/arch/gpio.h>

this should be <asm/gpio.h>

> +static struct watchdog_info ident = {
> +       .firmware_version = 0,

no point in setting this i dont think ...

> +static int gpio_wdt_ioctl(struct inode *inode, struct file *file,
> +    unsigned int cmd, unsigned long arg)
> +{
> +       case WDIOC_KEEPALIVE:
> +               gpio_wdt_keepalive(wdt);
> +               return 0;

this two lines should be merged.

> +       default:
> +               return -ENOIOCTLCMD;

should be -ENOTTY like all the other watchdogs

> +static char banner[] __initdata = KERN_INFO PFX "fixed %d.%03d seconds timeout (nowayout= %d)\n";

this only gets used once in the init function ... having it be broken
out like this is kind of silly

> +static int __init gpio_wdt_probe(struct platform_device *pdev)

shouldnt this be __devinit ?

> +       if (watchdog) {
> +               printk(KERN_ERR PFX "only one device supported\n");
> +               return -ENODEV;
> +       }

why ?  it'd be trivial to abstract this driver away from a global
"watchdog" state into a proper arbitrary # of gpio watchdogs.

> +static int __exit gpio_wdt_remove(struct platform_device *pdev)

shouldnt this be __devexit ?

> +#define gpio_wdt_suspend()
> +#define gpio_wdt_resume()

i'm pretty sure this is incorrect and instead should read:
#define gpio_wdt_suspend NULL
#define gpio_wdt_resume NULL

> +static struct platform_driver gpio_wdt_driver = {
> +       .probe          = gpio_wdt_probe,
> +       .remove         = __exit_p(gpio_wdt_remove),

once you fix the remove to be __devexit, this should be __devexit_p()

> --- a/drivers/watchdog/Kconfig  2008-01-08 17:30:30.000000000 +0100
> +++ b/drivers/watchdog/Kconfig  2008-01-10 14:00:30.000000000 +0100
> +config GPIO_WATCHDOG
> +       tristate "Support for GPIO connected watchdog"
> +       depends on GENERIC_GPIO
> +       help
> +         This option enables support for a MAX823-like watchdog connected to
> +         GPIO input/output.

this is misleading/confusing.  suggested rewording:
This option enables support for a watchdog connected via GPIO lines
(such as the MAX823).

To compile this driver as a module, choose M here: the module will be
called gpio_wdt.

> --- a/include/linux/gpio_wdt.h  1970-01-01 01:00:00.000000000 +0100
> +++ b/include/linux/gpio_wdt.h  2008-01-10 15:48:42.000000000 +0100
> +#include <asm/arch/hardware.h>

no idea why you're including this as it is surely incorrect and not
needed.  please remove it and add <linux/types.h>.

> +#define GPIO_WDT_DRIVER_NAME "gpio_wdt"

this belongs in the driver C file, not the header.
-mike
