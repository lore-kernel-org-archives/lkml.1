Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbYEILHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbYEILHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 07:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbYEILGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 07:06:52 -0400
Received: from web32602.mail.mud.yahoo.com ([68.142.207.229]:37951 "HELO
	web32602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751731AbYEILGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 07:06:51 -0400
X-YMail-OSG: y7y77vYVM1nu3QAGEbB20Y7R_TCi30sVpjOr20NxwH_YUuXeukV0fdlmqARZJeCHrD.gOSveOEVCYxClbNIHQxagKWjQEpdx0sJu2vxq.7cQF5QDpoX6mmHYlJc7naY7hIMyx2lf_73xLoM-
X-Mailer: YahooMailRC/975.23 YahooMailWebService/0.7.185
Date: Fri, 9 May 2008 04:06:50 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: 2.6.25.2 - Jiffies/Time jumping back and forth (Regereesion from 2.6.24)
To: Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       linux-kernel@vger.kernel.org, hmh@hmh.eng.br
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <698792.93829.qm@web32602.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: Mike Galbraith <efault@gmx.de>
> To: Thomas Gleixner <tglx@linutronix.de>
> Cc: Martin Knoblauch <spamtrap@knobisoft.de>; Gabriel C <nix.or.die@googlemail.com>; Bart Van Assche <bart.vanassche@gmail.com>; linux-kernel@vger.kernel.org; hmh@hmh.eng.br
> Sent: Thursday, May 8, 2008 7:31:28 PM
> Subject: Re: 2.6.25.2 - Jiffies/Time jumping back and forth (Regereesion from 2.6.24)
> 
> 
> On Thu, 2008-05-08 at 16:13 +0200, Thomas Gleixner wrote:
> > On Thu, 8 May 2008, Martin Knoblauch wrote:
> > > on two different systems running 2.6.25.2:
> > > 
> > > ibm x3650(2xDualCore)
> > > -------------------------------------
> > > [root@lpsdm60 ~]# cat 
> /sys/devices/system/clocksource/clocksource0/available_clocksource
> > > tsc hpet acpi_pm jiffies
> > > [root@lpsdm60 ~]# cat 
> /sys/devices/system/clocksource/clocksource0/current_clocksource
> > > tsc
> > > 
> > > HP Proliant DL-380G4 (2xSingleCore)
> > > ------------------------------------------------------------
> > > [root@lpsdm52 ~]# cat 
> /sys/devices/system/clocksource/clocksource0/available_clocksource
> > > tsc hpet acpi_pm jiffies
> > > [root@lpsdm52 ~]# cat 
> /sys/devices/system/clocksource/clocksource0/current_clocksource
> > > tsc
> > > 
> > > and on the DL380G4 running 2.6.24:
> > > ---------------------------------------------------------
> > > [root@lpsdm52 ~]# cat 
> /sys/devices/system/clocksource/clocksource0/available_clocksource
> > > hpet acpi_pm jiffies tsc
> > > [root@lpsdm52 ~]# cat 
> /sys/devices/system/clocksource/clocksource0/current_clocksource
> > > hpet
> > 
> > So on 2.6.24 the TSC is declared unstable at some point and 2.6.25
> > thinks it works fine. Is this the same kernel config (aside of the 24/25 fuzz) 
> ?
> 
> I had a problem with my P4's tsc being declared unstable after S2R.  I
> carry this patchlet (it's in mainline) in my 2.6.24 kernels to keep the
> TSC operational.  (browsing, dunno if it's the same problem, but it
> might be..)
> 
> diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
> index 9125efe..05d8f25 100644
> --- a/arch/x86/kernel/tsc_sync.c
> +++ b/arch/x86/kernel/tsc_sync.c
> @@ -129,24 +129,24 @@ void __cpuinit check_tsc_sync_source(int cpu)
>     while (atomic_read(&stop_count) != cpus-1)
>         cpu_relax();
> 
> -    /*
> -     * Reset it - just in case we boot another CPU later:
> -     */
> -    atomic_set(&start_count, 0);
> -
>     if (nr_warps) {
>         printk("\n");
>         printk(KERN_WARNING "Measured %Ld cycles TSC warp between CPUs,"
>                     " turning off TSC clock.\n", max_warp);
>         mark_tsc_unstable("check_tsc_sync_source failed");
> -        nr_warps = 0;
> -        max_warp = 0;
> -        last_tsc = 0;
>     } else {
>         printk(" passed.\n");
>     }
> 
>     /*
> +     * Reset it - just in case we boot another CPU later:
> +     */
> +    atomic_set(&start_count, 0);
> +    nr_warps = 0;
> +    max_warp = 0;
> +    last_tsc = 0;
> +
> +    /*
>      * Let the target continue with the bootup:
>      */
>     atomic_inc(&stop_count);

 Not sure, as I never had this problem in 2.6.24 - started with 2.6.25.2. But trying does not cost ...

...

Nope. That patch is indeed already in 2.6.25.2.

Cheers
Martin
