Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbXLBQdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbXLBQdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 11:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbXLBQdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 11:33:42 -0500
Received: from emerald.lightlink.com ([205.232.34.14]:2293 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbXLBQdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 11:33:41 -0500
Date: Sun, 2 Dec 2007 11:28:14 -0500
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jiri Slaby <jirislaby@gmail.com>, Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 1/1] HWMON: coretemp, suspend fix
Message-ID: <20071202162814.GZ13717@jupiter.solarsys.private>
References: <661416096128474967.slaby@pripojeni.net> <47508C72.8050703@gmail.com> <200712010045.50297.rjw@sisk.pl> <200712010051.41227.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712010051.41227.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

* Rafael J. Wysocki <rjw@sisk.pl> [2007-12-01 00:51:40 +0100]:
> On Saturday, 1 of December 2007, Rafael J. Wysocki wrote:
> > On Friday, 30 of November 2007, Jiri Slaby wrote:
> > > On 11/30/2007 11:15 PM, Jean Delvare wrote:
> > > > Hi Jiri,
> > > 
> [--snip--]
> > > > 
> > > > Should this change go to the stable tree(s) as well?
> > > 
> > > Sorry, I have no idea. Rafael?
> > 
> > Well, actually, having looked once again at the patch, I think that it's
> > slightly wrong.  Namely, it looks like we just should drop all of the _FROZEN
> > actions from there.
> > 
> > Fixed patch follows and I think it's also a candidate for -stable.
> 
> Crap, I forgot to add the sign-off, so here it goes again:
> 
> ---
> Subject: HWMON: coretemp, suspend fix
>  
> It's not permitted to unregister a device after devices have been suspended.
> It causes deadlocks to appear on systems with coretemp hwmon loaded.  To avoid
> this, we can make coretemp_cpu_callback() do nothing if the _FROZEN bit is set
> in action.
>  
> Also, in other cases it's generally to late to unregister the coretemp device
> if the CPU is already dead, so it should be unregistered on CPU_DOWN_PREPARE.
>  
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl> (frozen fix)
> Cc: Mark M. Hoffman <mhoffman@lightlink.com>
> Cc: Jiri Slaby <jirislaby@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/hwmon/coretemp.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/drivers/hwmon/coretemp.c
> ===================================================================
> --- linux-2.6.orig/drivers/hwmon/coretemp.c
> +++ linux-2.6/drivers/hwmon/coretemp.c
> @@ -337,11 +337,10 @@ static int coretemp_cpu_callback(struct 
>  
>  	switch (action) {
>  	case CPU_ONLINE:
> -	case CPU_ONLINE_FROZEN:
> +	case CPU_DOWN_FAILED:
>  		coretemp_device_add(cpu);
>  		break;
> -	case CPU_DEAD:
> -	case CPU_DEAD_FROZEN:
> +	case CPU_DOWN_PREPARE:
>  		coretemp_device_remove(cpu);
>  		break;
>  	}

Sorry for the delay, it took me some time to RTF code and convince
myself that nothing can tickle this driver's sysfs files after a
CPU_DOWN_PREPARE_FROZEN.  As long as I didn't misread that...

Acked-by: Mark M. Hoffman <mhoffman@lightlink.com>

PS: while reading kernel/power/disk.c, I saw this...

335 static void power_down(void)
336 {
337         switch (hibernation_mode) {
338         case HIBERNATION_TEST:
339         case HIBERNATION_TESTPROC:
340                 break;
341         case HIBERNATION_REBOOT:
342                 kernel_restart(NULL);
343                 break;
344         case HIBERNATION_PLATFORM:
345                 hibernation_platform_enter();
346         case HIBERNATION_SHUTDOWN:
347                 kernel_power_off();
348                 break;
349         }
350         kernel_halt();
351         /*
352          * Valid image is on the disk, if we continue we risk serious data
353          * corruption after resume.
354          */
355         printk(KERN_CRIT "Please power me down manually\n");
356         while(1);
357 }

Shouldn't that be while(1) cpu_relax(); ?

Regards,

-- 
Mark M. Hoffman
mhoffman@lightlink.com

