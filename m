Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbZBVUzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbZBVUzT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 15:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbZBVUzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 15:55:05 -0500
Received: from smtp5.welho.com ([213.243.153.39]:59757 "EHLO smtp5.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbZBVUzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 15:55:04 -0500
Date: Sun, 22 Feb 2009 22:56:54 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 1/2] PM: Split up sysdev_[suspend|resume] from
	device_power_[down|up]
Message-ID: <20090222205654.GC4485@localhost.pp.htv.fi>
References: <200902221837.49396.rjw@sisk.pl> <200902221838.51548.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200902221838.51548.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 06:38:50PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Move the sysdev_suspend/resume from the callee to the callers, with
> no real change in semantics, so that we can rework the disabling of
> interrupts during suspend/hibernation.
> 
> This is based on an earlier patch from Linus.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>...
> --- linux-2.6.orig/arch/x86/kernel/apm_32.c
> +++ linux-2.6/arch/x86/kernel/apm_32.c
> @@ -1192,6 +1192,7 @@ static int suspend(int vetoable)
>  	device_suspend(PMSG_SUSPEND);
>  	local_irq_disable();
>  	device_power_down(PMSG_SUSPEND);
> +	sysdev_suspend(PMSG_SUSPEND);
>  
>  	local_irq_enable();
>  
> @@ -1208,6 +1209,7 @@ static int suspend(int vetoable)
>  	if (err != APM_SUCCESS)
>  		apm_error("suspend", err);
>  	err = (err == APM_SUCCESS) ? 0 : -EIO;
> +	sysdev_resume();
>  	device_power_up(PMSG_RESUME);
>  	local_irq_enable();
>  	device_resume(PMSG_RESUME);
> @@ -1228,6 +1230,7 @@ static void standby(void)
>  
>  	local_irq_disable();
>  	device_power_down(PMSG_SUSPEND);
> +	sysdev_suspend(PMSG_SUSPEND);
>  	local_irq_enable();
>  
>  	err = set_system_power_state(APM_STATE_STANDBY);
> @@ -1235,6 +1238,7 @@ static void standby(void)
>  		apm_error("standby", err);
>  
>  	local_irq_disable();
> +	sysdev_resume();
>  	device_power_up(PMSG_RESUME);
>  	local_irq_enable();
>  }
>...

This causes the following build error with CONFIG_APM=m:

<--  snip  -->

...
  MODPOST 2586 modules
ERROR: "sysdev_resume" [arch/x86/kernel/apm.ko] undefined!
ERROR: "sysdev_suspend" [arch/x86/kernel/apm.ko] undefined!
make[2]: *** [__modpost] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

