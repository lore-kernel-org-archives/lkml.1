Return-Path: <linux-kernel-owner+w=401wt.eu-S1757281AbYAJABA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281AbYAJABA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 19:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbYAJAAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 19:00:52 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55357 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbYAJAAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 19:00:51 -0500
Subject: Re: [RFC PATCH 13/22 -v2] handle accurate time keeping over long
	delays
From: john stultz <johnstul@us.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20080109233044.288563621@goodmis.org>
References: <20080109232914.676624725@goodmis.org>
	 <20080109233044.288563621@goodmis.org>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 16:00:19 -0800
Message-Id: <1199923219.6350.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-09 at 18:29 -0500, Steven Rostedt wrote:
> plain text document attachment (rt-time-starvation-fix.patch)
> Handle accurate time even if there's a long delay between
> accumulated clock cycles.
> 
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  arch/x86/kernel/vsyscall_64.c |    5 ++-
>  include/asm-x86/vgtod.h       |    2 -
>  include/linux/clocksource.h   |   58 ++++++++++++++++++++++++++++++++++++++++--
>  kernel/time/timekeeping.c     |   35 +++++++++++++------------
>  4 files changed, 80 insertions(+), 20 deletions(-)
> 
> linux-2.6.21-rc5_cycles-accumulated_C7.patch
            ^^ An oldie but a goodie?

I was just reminded that in the time since 2.6.21-rc5, other arches
beside x86_64 have gained vgettimeofday implementations, and thus will
need similar update_vsyscall() tweaks as seen below to get the correct
time.

Here's the fix for x86_64:
> Index: linux-compile-i386.git/arch/x86/kernel/vsyscall_64.c
> ===================================================================
> --- linux-compile-i386.git.orig/arch/x86/kernel/vsyscall_64.c	2008-01-09 14:10:20.000000000 -0500
> +++ linux-compile-i386.git/arch/x86/kernel/vsyscall_64.c	2008-01-09 14:17:53.000000000 -0500
> @@ -86,6 +86,7 @@ void update_vsyscall(struct timespec *wa
>  	vsyscall_gtod_data.clock.mask = clock->mask;
>  	vsyscall_gtod_data.clock.mult = clock->mult;
>  	vsyscall_gtod_data.clock.shift = clock->shift;
> +	vsyscall_gtod_data.clock.cycle_accumulated = clock->cycle_accumulated;
>  	vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
>  	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
>  	vsyscall_gtod_data.wall_to_monotonic = wall_to_monotonic;
> @@ -121,7 +122,7 @@ static __always_inline long time_syscall
> 
>  static __always_inline void do_vgettimeofday(struct timeval * tv)
>  {
> -	cycle_t now, base, mask, cycle_delta;
> +	cycle_t now, base, accumulated, mask, cycle_delta;
>  	unsigned seq;
>  	unsigned long mult, shift, nsec;
>  	cycle_t (*vread)(void);
> @@ -135,6 +136,7 @@ static __always_inline void do_vgettimeo
>  		}
>  		now = vread();
>  		base = __vsyscall_gtod_data.clock.cycle_last;
> +		accumulated  = __vsyscall_gtod_data.clock.cycle_accumulated;
>  		mask = __vsyscall_gtod_data.clock.mask;
>  		mult = __vsyscall_gtod_data.clock.mult;
>  		shift = __vsyscall_gtod_data.clock.shift;
> @@ -145,6 +147,7 @@ static __always_inline void do_vgettimeo
> 
>  	/* calculate interval: */
>  	cycle_delta = (now - base) & mask;
> +	cycle_delta += accumulated;
>  	/* convert to nsecs: */
>  	nsec += (cycle_delta * mult) >> shift;


Tony:  ia64 also needs something like this, but I found the fsyscall asm
bits a little difficult to grasp. So I'll need some assistance on how to
include the accumulated cycles into the final calculation.


The following is a quick and dirty fix for powerpc so it includes
cycle_accumulated in its calculation. It relies on the fact that the
powerpc clocksource is a 64bit counter (don't have to worry about
multiple overflows), so the subtraction should be safe.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Index: 2.6.24-rc5/arch/powerpc/kernel/time.c
===================================================================
--- 2.6.24-rc5.orig/arch/powerpc/kernel/time.c	2008-01-09 15:17:32.000000000 -0800
+++ 2.6.24-rc5/arch/powerpc/kernel/time.c	2008-01-09 15:17:43.000000000 -0800
@@ -773,7 +773,7 @@ void update_vsyscall(struct timespec *wa
 	stamp_xsec = (u64) xtime.tv_nsec * XSEC_PER_SEC;
 	do_div(stamp_xsec, 1000000000);
 	stamp_xsec += (u64) xtime.tv_sec * XSEC_PER_SEC;
-	update_gtod(clock->cycle_last, stamp_xsec, t2x);
+	update_gtod(clock->cycle_last-clock->cycle_accumulated, stamp_xsec, t2x);
 }
 
 void update_vsyscall_tz(void)





