Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbZFGPW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbZFGPW0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 11:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbZFGPWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 11:22:19 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35927 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbZFGPWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 11:22:18 -0400
Date: Sun, 7 Jun 2009 16:21:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>, eric miao <eric.y.miao@gmail.com>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com
Subject: Re: zaurus needs generic pxa suspend/resume routines
Message-ID: <20090607152152.GA7785@n2100.arm.linux.org.uk>
References: <20090605131625.GC1376@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090605131625.GC1376@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 03:16:25PM +0200, Pavel Machek wrote:
> For suspend/resume to work, spitz needs pxa_pm_suspend/resume to be
> called. Otherwise PSPR is not set properly, and system will die during
> resume.

100 points for copying lots of people.  0 points for omitting the right
person.  Add Eric.

Eric, ack?

> Signed-off-by: Pavel Machek <pavel@ucw.cz> 
> 
> PATCH FOLLOWS
> KernelVersion: 2.6.30-rc6
> 
> --- linux-rc/arch/arm.ofic/common/sharpsl_pm.c	2009-05-29 01:10:31.000000000 +0200
> +++ linux-rc/arch/arm/common/sharpsl_pm.c	2009-06-02 15:33:11.000000000 +0200
> @@ -553,7 +556,7 @@
>  			corgi_goto_sleep(alarm_time, alarm_enable, state);
>  			return 1;
>  		}
> -		if(sharpsl_off_charge_battery()) {
> +		if (sharpsl_off_charge_battery()) {
>  			dev_dbg(sharpsl_pm.dev, "Charging. Suspend...\n");
>  			corgi_goto_sleep(alarm_time, alarm_enable, state);
>  			return 1;
> @@ -774,7 +777,9 @@
>  }
>  
>  #ifdef CONFIG_PM
>  static struct platform_suspend_ops sharpsl_pm_ops = {
> +	.prepare	= pxa_pm_prepare,
> +	.finish		= pxa_pm_finish,
>  	.enter		= corgi_pxa_pm_enter,
>  	.valid		= suspend_valid_only_mem,
>  };
> diff -ur linux-rc/arch/arm.ofic/mach-pxa/include/mach/pm.h linux-rc/arch/arm/mach-pxa/include/mach/pm.h
> --- linux-rc/arch/arm.ofic/mach-pxa/include/mach/pm.h	2009-05-29 01:11:00.000000000 +0200
> +++ linux-rc/arch/arm/mach-pxa/include/mach/pm.h	2009-06-02 15:39:50.000000000 +0200
> @@ -27,6 +27,8 @@
>  extern void pxa_cpu_resume(void);
>  
>  extern int pxa_pm_enter(suspend_state_t state);
> +extern int pxa_pm_prepare(void);
> +extern void pxa_pm_finish(void);
>  
>  /* NOTE: this is for PM debugging on Lubbock,  it's really a big
>   * ugly, but let's keep the crap minimum here, instead of direct
> diff -ur linux-rc/arch/arm.ofic/mach-pxa/pm.c linux-rc/arch/arm/mach-pxa/pm.c
> --- linux-rc/arch/arm.ofic/mach-pxa/pm.c	2009-05-29 01:11:02.000000000 +0200
> +++ linux-rc/arch/arm/mach-pxa/pm.c	2009-06-01 12:01:07.000000000 +0200
> @@ -79,7 +84,7 @@
>  	return -EINVAL;
>  }
>  
> -static int pxa_pm_prepare(void)
> +int pxa_pm_prepare(void)
>  {
>  	int ret = 0;
>  
> @@ -89,7 +94,7 @@
>  	return ret;
>  }
>  
> -static void pxa_pm_finish(void)
> +void pxa_pm_finish(void)
>  {
>  	if (pxa_cpu_pm_fns && pxa_cpu_pm_fns->finish)
>  		pxa_cpu_pm_fns->finish();
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 
> -------------------------------------------------------------------
> List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
