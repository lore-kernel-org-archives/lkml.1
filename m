Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbYLHCPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbYLHCPA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 21:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbYLHCOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 21:14:51 -0500
Received: from www.tglx.de ([62.245.132.106]:47468 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbYLHCOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 21:14:50 -0500
Date: Mon, 8 Dec 2008 03:13:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>,
       Lars Winterfeld <lars.winterfeld@tu-ilmenau.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nohz: add missing handling of clocksource watchdog
In-Reply-To: <200812080124.37944.bzolnier@gmail.com>
Message-ID: <alpine.LFD.2.00.0812080308140.3325@localhost.localdomain>
References: <200812080015.22793.bzolnier@gmail.com> <200812080036.59506.Rafal.Wysocki@fuw.edu.pl> <493C60E3.7070303@ru.mvista.com> <200812080124.37944.bzolnier@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2008, Bartlomiej Zolnierkiewicz wrote:

> On Monday 08 December 2008, Sergei Shtylyov wrote:
> > Hello.
> > 
> > R. J. Wysocki wrote:
> > > On Monday, 8 of December 2008, Bartlomiej Zolnierkiewicz wrote:
> > >   
> > >> Fixes "Clocksource tsc unstable (delta = -974982308 ns)" problem.
> > >>     
> > >
> > > Where can I find the description of the problem?
> > >   
> > 
> >    Kernel.org bug #10216 (it's not about this issue though).
> 
> Looking back at bug #10216 the patch is unlikely to help Lars' system
> since it doesn't use nohz and there are also warnings about unsynced
> TSCs (I just don't know why not for 2.6.27-rc kernels)...
>  
> > > Rafael
> > >
> > >   
> > >> [ IDE was unlucky to be initialized at the same time that
> > >>   clocksource watchdog triggers and was blamed for the issue. ]
> > >>     
> > 
> >    I think it might well have been blamed correctly -- the clocksource 
> > watchdog timer gets run every half second.
> 
> AFAICS this is a special one for measuring stability of the clocksource
> only -- by comparing the value returned by a given clocksource with the
> reference clocksource.  Normal drivers have no bussiness there...
> 
> Anyway I forgot to add that it fixes the issue for me under QEMU (on my
> laptop TSC is unstable due to halts in idle) and it could be as well QEMU's
> oddity (although it looks like a legit kernel problem).  v2 of the patch
> below (updated patch description).
> 
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH v2] nohz: add missing handling of clocksource watchdog
> 
> Fixes "Clocksource tsc unstable (delta = -974982308 ns)" problem
> under QEMU.
> 
> Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> Cc: Lars Winterfeld <lars.winterfeld@tu-ilmenau.de>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  kernel/time/tick-sched.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: b/kernel/time/tick-sched.c
> ===================================================================
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -21,6 +21,7 @@
>  #include <linux/sched.h>
>  #include <linux/tick.h>
>  #include <linux/module.h>
> +#include <linux/clocksource.h>
>  
>  #include <asm/irq_regs.h>
>  
> @@ -153,6 +154,7 @@ void tick_nohz_update_jiffies(void)
>  	local_irq_restore(flags);
>  
>  	touch_softlockup_watchdog();
> +	clocksource_touch_watchdog();

NAK. 

If this happens then the watchdog logic did not manage to schedule the
watchdog timer in time. This patch just papers over the real problem.

We do not fix QEMU problems in the kernel, as we would miss real
hardware wreckage that way.

Thanks,

	tglx
