Return-Path: <linux-kernel-owner+w=401wt.eu-S1759935AbYDBWkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759935AbYDBWkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 18:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbYDBWk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 18:40:27 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:60372 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753744AbYDBWk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 18:40:26 -0400
Date: Wed, 2 Apr 2008 15:40:25 -0700
From: Tim Mann <mann@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: mann@vmware.com
Subject: Re: gettimeofday() jumping into the future
Message-ID: <20080402154025.56fb0dbe@manzanita>
In-Reply-To: <47F3F313.7030803@vmware.com>
References: <47F3F313.7030803@vmware.com>
Organization: VMware, Inc.
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm pleased to see this change.  I was dumbfounded by the approach
that was previously taken: run a brief experiment at bootup to see if
we can observe the TSCs being out of sync, and if we can't, conclude
that they are so perfectly in sync that no future observation will ever
see them as out of sync and so it's OK to write code that will blow up
if that conclusion is wrong.  To me, this kind of thing is no better
than removing locks because in a brief experiment we couldn't provoke
the race condition that they guard against.

> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Wed, Apr 2, 2008 at 4:22 AM
> Subject: Re: gettimeofday() jumping into the future
> To: John Stultz <johnstul@us.ibm.com>
> Cc: Tim Ricketts <tr@earth.li>, Michael Smith <msmith@xiph.org>, LKML <
> linux-kernel@vger.kernel.org>, Andy Wingo <wingo@fluendo.com>, Ingo Molnar <
> mingo@elte.hu>
> 
> 
> On Mon, 31 Mar 2008, John Stultz wrote:
> >
> > On Mon, 2008-03-31 at 10:55 +0200, Thomas Gleixner wrote:
> > >
> > > > +     if (cycle_now < clock->cycle_last)
> > > > +             return 0;
> > > > +
> > >
> > > No, this breaks wrapping clocksources e.g. pmtimer. We need a
> > > different sanity check for that TSC crap.
> >
> > Yea. If you're going to do that sort of logic (which requires a costly
> > cmpxchg as well), it should be done in the read() function of the
> > clocksource.
> 
> We can get away without a cmpxchg(). See patch below.
> 
> Tim, Michael, does this solve your problems ?
> 
> Thanks,
> 
>         tglx
> 
> ----------->
> 
> Subject: x86: tsc prevent time going backwards
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Tue, 01 Apr 2008 19:45:18 +0200
> 
> We already catch most of the TSC problems by sanity checks, but there
> is a subtle bug which has been in the code for ever. This can cause
> time jumps in the range of hours.
> 
> This was reported in:
>      http://lkml.org/lkml/2007/8/23/96
> and
>      http://lkml.org/lkml/2008/3/31/23
> 
> I was able to reproduce the problem with a gettimeofday loop test on a
> dual core and a quad core machine which both have sychronized
> TSCs. The TSCs seems not to be perfectly in sync though, but the
> kernel is not able to detect the slight delta in the bootup sync
> check. There exists an extremly small window where this delta can be
> observed with a real big time jump. So far I was only able to
> reproduce this with the vsyscall gettimeofday implementation, but in
> theory this might be observable with the syscall based version as
> well.
> 
> CPU 0 updates the clock source variables under xtime/vyscall lock and
> CPU1, where the TSC is slighty behind CPU0, is reading the time right
> after the seqlock was unlocked.
> 
> The clocksource reference data was updated with the TSC from CPU0 and
> the value which is read from TSC on CPU1 is less than the reference
> data. This results in a huge delta value due to the unsigned
> subtraction of the TSC value and the reference value. This algorithm
> can not be changed due to the support of wrapping clock sources like
> pm timer.
> 
> The huge delta is converted to nanoseconds and added to xtime, which
> is then observable by the caller. The next gettimeofday call on CPU1
> will show the correct time again as now the TSC has advanced above the
> reference value.
> 
> To prevent this TSC specific wreckage we need to compare the TSC value
> against the reference value and return the latter when it is larger
> than the actual TSC value.
> 
> I pondered to mark the TSC unstable when the readout is smaller than
> the reference value, but this would render an otherwise good and fast
> clocksource unusable without a real good reason.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> ---
>   arch/x86/kernel/tsc_32.c |   15 ++++++++++++++-
>   arch/x86/kernel/tsc_64.c |   23 ++++++++++++++++++++---
>   2 files changed, 34 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/tsc_32.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/tsc_32.c
> +++ linux-2.6/arch/x86/kernel/tsc_32.c
> @@ -287,14 +287,27 @@ core_initcall(cpufreq_tsc);
>   /* clock source code */
> 
>   static unsigned long current_tsc_khz = 0;
> +static struct clocksource clocksource_tsc;
> 
> +/*
> + * We compare the TSC to the cycle_last value in the clocksource
> + * structure to avoid a nasty time-warp issue. This can be observed in
> + * a very small window right after one CPU updated cycle_last under
> + * xtime lock and the other CPU reads a TSC value which is smaller
> + * than the cycle_last reference value due to a TSC which is slighty
> + * behind. This delta is nowhere else observable, but in that case it
> + * results in a forward time jump in the range of hours due to the
> + * unsigned delta calculation of the time keeping core code, which is
> + * necessary to support wrapping clocksources like pm timer.
> + */
>   static cycle_t read_tsc(void)
>   {
>         cycle_t ret;
> 
>         rdtscll(ret);
> 
> -       return ret;
> +       return ret >= clocksource_tsc.cycle_last ?
> +               ret : clocksource_tsc.cycle_last;
>   }
> 
>   static struct clocksource clocksource_tsc = {
> Index: linux-2.6/arch/x86/kernel/tsc_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/tsc_64.c
> +++ linux-2.6/arch/x86/kernel/tsc_64.c
> @@ -11,6 +11,7 @@
>   #include <asm/hpet.h>
>   #include <asm/timex.h>
>   #include <asm/timer.h>
> +#include <asm/vgtod.h>
> 
>   static int notsc __initdata = 0;
> 
> @@ -290,18 +291,34 @@ int __init notsc_setup(char *s)
> 
>   __setup("notsc", notsc_setup);
> 
> +static struct clocksource clocksource_tsc;
> 
> -/* clock source code: */
> +/*
> + * We compare the TSC to the cycle_last value in the clocksource
> + * structure to avoid a nasty time-warp. This can be observed in a
> + * very small window right after one CPU updated cycle_last under
> + * xtime/vsyscall_gtod lock and the other CPU reads a TSC value which
> + * is smaller than the cycle_last reference value due to a TSC which
> + * is slighty behind. This delta is nowhere else observable, but in
> + * that case it results in a forward time jump in the range of hours
> + * due to the unsigned delta calculation of the time keeping core
> + * code, which is necessary to support wrapping clocksources like pm
> + * timer.
> + */
>   static cycle_t read_tsc(void)
>   {
>         cycle_t ret = (cycle_t)get_cycles();
> -       return ret;
> +
> +       return ret >= clocksource_tsc.cycle_last ?
> +               ret : clocksource_tsc.cycle_last;
>   }
> 
>   static cycle_t __vsyscall_fn vread_tsc(void)
>   {
>         cycle_t ret = (cycle_t)vget_cycles();
> -       return ret;
> +
> +       return ret >= __vsyscall_gtod_data.clock.cycle_last ?
> +               ret : __vsyscall_gtod_data.clock.cycle_last;
>   }
> 
>   static struct clocksource clocksource_tsc = {
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Tim Mann  work: mann@vmware.com  home: tim@tim-mann.org
          http://www.vmware.com  http://tim-mann.org
