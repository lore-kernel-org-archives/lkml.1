Return-Path: <linux-kernel-owner+w=401wt.eu-S1759212AbZANWhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212AbZANWhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbZANWhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:37:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753316AbZANWhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:37:34 -0500
Date: Wed, 14 Jan 2009 14:36:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org, johnstul@us.ibm.com,
       gregkh@suse.de, mingo@redhat.com, magnus.damm@gmail.com,
       tglx@linutronix.de
Subject: Re: [RESEND][PATCH] early platform drivers V2
Message-Id: <20090114143635.c64a4943.akpm@linux-foundation.org>
In-Reply-To: <20090114105436.18974.45429.sendpatchset@rx1.opensource.se>
References: <20090114105436.18974.45429.sendpatchset@rx1.opensource.se>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 19:54:36 +0900
Magnus Damm <magnus.damm@gmail.com> wrote:

> From: Magnus Damm <damm@igel.co.jp>
> 
> This patch is V2 of the early platform driver implementation.
> 
> Platform drivers are great for embedded platforms because we
> can separate driver configuration from the actual driver. So
> base addresses, interrupts and other configuration can be kept
> with the processor or board code, and the platform driver can
> be reused by many different platforms.
> 
> For early devices we have nothing today. For instance, to configure
> early timers and early serial ports we cannot use platform devices.
> This because the setup order during boot. Timers are needed before
> the platform driver core code is available. The same goes for early
> printk support. Early in this case means before initcalls.
> 
> These early drivers today have their configuration either hard coded
> or they receive it using some special configuration method. This is
> working quite well, but if we want to support both regular kernel
> modules and early devices then we need to have two ways of configuring
> the same driver. A single way would be better.
> 
> The early platform driver patch is basically a set of functions that
> allow drivers to register themselves and architecture code to locate
> them and probe. Registration happens through early_param(). The time
> for the probe is decided by the architecture code.
> 
> The drivers are regular compiled-in modules with the exception that
> they also register themselves using early_platform_init():
> 
>  +static int __init sh_cmt_init(void)
>  +{
>  +       return platform_driver_register(&sh_cmt_device_driver);
>  +}
>  +
>  +static void __exit sh_cmt_exit(void)
>  +{
>  +       platform_driver_unregister(&sh_cmt_device_driver);
>  +}
>  +
>  +early_platform_init("earlytimer", &sh_cmt_device_driver);
>  +module_init(sh_cmt_init);
>  +module_exit(sh_cmt_exit);
> 
> The architecture code can then decide whenever it wants to probe for
> early platform devices. The architecture code simply does:
> 
>  +void __init time_init(void)
>  +{
>  +       early_platform_driver_probe("earlytimer", sh_timer_pdevs,
>  +                                   sh_timer_nr_pdevs, 1);
> 
> This will first make sure that all compiled-in early platform drivers
> belonging to the class "earlytimer" get registered. After that the
> platform devices passed to the function are scanned through and matched
> against the registered early platform drivers. The user can select which
> device that should be prioritized by specifying the classname and platform
> device name together with id on the kernel commandline. For instance the
> string "earlytimer=cmt0" will match the driver named "cmt" with id 0.
> 
> Later when the platform device core code is up and running the driver
> can turn itself into a regular platform device in the regular probe()
> callback.
> 
> Comments anyone? Maybe there are better ways to do this?
> 

<babe-in-the-woods> Seems that this feature involves adding something to
the kernel boot command line?  Or does the command line remain the
same, only the kernel's handling of it changes?

Is some documentation update needed/appropriate?

IOW: how does one use this feature?

> +#define early_platform_init(class_string, platform_driver)		\
> +static __initdata struct early_platform_driver early_driver = {		\
> +	.class_str = class_string,					\
> +	.pdrv = platform_driver,					\
> +};									\
> +static int __init early_platform_driver_setup_func(char *buf)		\
> +{									\
> +	return early_platform_driver_register(&early_driver, buf);	\
> +}									\
> +early_param(class_string, early_platform_driver_setup_func)

I guess this macro should have an all-caps name, but this name matches
previous up-screwings?


