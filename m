Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690AbYJ0Q0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbYJ0Q0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbYJ0Q01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:26:27 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:61552 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbYJ0Q0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:26:25 -0400
Date: Mon, 27 Oct 2008 09:25:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pavel Machek <pavel@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-stable@vger.kernel.org,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Stanislav Brabec <utx@penguin.cz>,
       kernel list <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, Dirk@opfer-online.de, arminlitzel@web.de,
       pavel.urban@ct.cz, metan@atrey.karlin.mff.cuni.cz,
       thommycheck@gmail.com, milan@ucw.cz
Subject: Re: [Patch 2.6.27] fix booting on Sharp Zaurus c3000
Message-Id: <20081027092512.9327b690.randy.dunlap@oracle.com>
In-Reply-To: <20081026184108.GB1847@ucw.cz>
References: <20081009091929.GE29957@atrey.karlin.mff.cuni.cz>
	<20081015101747.GB28824@atrey.karlin.mff.cuni.cz>
	<20081015113923.GA21756@flint.arm.linux.org.uk>
	<200810250001.04835.rjw@sisk.pl>
	<20081026184108.GB1847@ucw.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; i686-pc-linux-gnu)
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

On Sun, 26 Oct 2008 19:41:09 +0100
Pavel Machek <pavel@suse.cz> wrote:

> Hi!
> 
> > > > Thanks for the effort, but it looks like it did not make it, right?
> > > 
> > > Correct - Linus was unpredictable and released 2.6.27 that evening,
> > > four days early giving me no time to push the fix to him.
> > > 
> > > However, it's gone in as part of the first ARM merge, so should be in
> > > -rc1.
> > 
> > Is it in -stable?  if not, is it considered as -stable material?
> 
> Yes, I guess it should go to stable.
> 
> commit 69fc7eed5f56bce15b239e5110de2575a6970df4
> Author: Dmitry Baryshkov <dbaryshkov@gmail.com>
> Date:   Thu Oct 9 16:58:13 2008 +0100
> 
>     [ARM] 5300/1: fixup spitz reset during boot
>     
>     Some machines don't have the pullup/down on their reset
>     pin, so configuring the reset generating pin as input makes
>     them reset immediately. Fix that by making reset pin direction
>     configurable.
>     
> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> diff --git a/arch/arm/mach-pxa/include/mach/reset.h b/arch/arm/mach-pxa/include/mach/reset.h
> index 9489a48..7b8842c 100644
> --- a/arch/arm/mach-pxa/include/mach/reset.h
> +++ b/arch/arm/mach-pxa/include/mach/reset.h
> @@ -10,9 +10,12 @@
>  extern unsigned int reset_status;
>  extern void clear_reset_status(unsigned int mask);
>  
> -/*
> - * register GPIO as reset generator
> +/**
> + * init_gpio_reset() - register GPIO as reset generator
> + *
> + * @gpio - gpio nr
> + * @output - set gpio as out/low instead of input during normal work

Use colon (':') after function parameters, not hyphen/dash.


>   */
> -extern int init_gpio_reset(int gpio);
> +extern int init_gpio_reset(int gpio, int output);
>  
>  #endif /* __ASM_ARCH_RESET_H */
> diff --git a/arch/arm/mach-pxa/reset.c b/arch/arm/mach-pxa/reset.c
> index 31d7885..1b2af57 100644
> --- a/arch/arm/mach-pxa/reset.c
> +++ b/arch/arm/mach-pxa/reset.c
> @@ -20,7 +20,7 @@ static void do_hw_reset(void);
>  
>  static int reset_gpio = -1;
>  
> -int init_gpio_reset(int gpio)
> +int init_gpio_reset(int gpio, int output)
>  {
>  	int rc;
>  
> @@ -30,9 +30,12 @@ int init_gpio_reset(int gpio)
>  		goto out;
>  	}
>  
> -	rc = gpio_direction_input(gpio);
> +	if (output)
> +		rc = gpio_direction_output(gpio, 0);
> +	else
> +		rc = gpio_direction_input(gpio);
>  	if (rc) {
> -		printk(KERN_ERR "Can't configure reset_gpio for input\n");
> +		printk(KERN_ERR "Can't configure reset_gpio\n");
>  		gpio_free(gpio);
>  		goto out;
>  	}
> diff --git a/arch/arm/mach-pxa/spitz.c b/arch/arm/mach-pxa/spitz.c
> index 9b4f24c..524f656 100644
> --- a/arch/arm/mach-pxa/spitz.c
> +++ b/arch/arm/mach-pxa/spitz.c
> @@ -618,7 +618,7 @@ static void spitz_restart(char mode)
>  
>  static void __init common_init(void)
>  {
> -	init_gpio_reset(SPITZ_GPIO_ON_RESET);
> +	init_gpio_reset(SPITZ_GPIO_ON_RESET, 1);
>  	pm_power_off = spitz_poweroff;
>  	arm_pm_restart = spitz_restart;
>  
> diff --git a/arch/arm/mach-pxa/tosa.c b/arch/arm/mach-pxa/tosa.c
> index 9f3ef9e..130e37e 100644
> --- a/arch/arm/mach-pxa/tosa.c
> +++ b/arch/arm/mach-pxa/tosa.c
> @@ -781,7 +781,7 @@ static void __init tosa_init(void)
>  	gpio_set_wake(MFP_PIN_GPIO1, 1);
>  	/* We can't pass to gpio-keys since it will drop the Reset altfunc */
>  
> -	init_gpio_reset(TOSA_GPIO_ON_RESET);
> +	init_gpio_reset(TOSA_GPIO_ON_RESET, 0);
>  
>  	pm_power_off = tosa_poweroff;
>  	arm_pm_restart = tosa_restart;
> 
> 

-- 
~Randy
