Return-Path: <linux-kernel-owner+w=401wt.eu-S1751487AbXCRVIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbXCRVIZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 17:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbXCRVIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 17:08:25 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:62529 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751487AbXCRVIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 17:08:23 -0400
Date: Sun, 18 Mar 2007 17:08:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Guillaume Chazarain <guichaz@gmail.com>
Cc: Andi Kleen <ak@suse.de>, john stultz <johnstul@us.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add an offset in the cyc2ns computation to fix sched_clock jumps
Message-ID: <20070318210819.GB19818@Krystal>
References: <3d8471ca0703161114o7ad654car60c1a6b801401149@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <3d8471ca0703161114o7ad654car60c1a6b801401149@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 16:33:33 up 44 days, 10:41,  4 users,  load average: 1.04, 1.22, 1.36
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guillaume,

I understand your need for a working system, but the impression I get
is that this looks too much like yet another level of band-aid over a
broken architecture : AMD 7th and 8th generations, which does not give a
synchronized TSC.

The patch you suggest may work for scheduler purposes, but I wonder if
other parts of the kernel suffers from those TSC inconsistencies and
therefore would need to have this problem addressed differently that
smoothing the per-cpu frequency changes.

The approach you use implies hooking in the frequency change callback,
but it does not deal with frequency scaling due to temperature related
events, and does not, as I recall, deal with frequency scaling in halt
mode. It may also have problems with the values in the period of time
close to the frequency change.

For what it's worth, I would be tempted to use a "simple" approach for
these broken architectures, which would give a monotonic clock source.
Either :

- Use HPET or PM, as suggested by AMD. http://lkml.org/lkml/2005/11/4/173
  For some reasons, x86_64 does not use it for sched_clock, because it
  takes too long to access and is not enabled before the scheduler. I
  don't disagree about optimizing for broken hardware, except when it
  implies multiple layers of band-aids.

- I am currently developing a completely monotonic clock source for
  tracing purposes on those AMD systems. It uses LOCKed atomic operation
  to update the "global" last_tsc value to the count of the CPU with
  highest TSC value at each TSC read and increments this global TSC
  count of the amount of cycles necessary to read the TSC by the other
  CPUs to generate a logical clock. I also plan to update this global
  last_tsc every timer tick to give a higher bound to time accuracy.
  This is a workaround that :
  - Does not scale perfectly (uses locked atomic operation, shares a
    variable between the CPUs, therefore causes contention)
  - Takes about 225 cycles per TSC read instead of 181.
  - Requires an IPI every timer tick.
  - Give a worse case time precision of 1/HZ (1ms to 10ms).
  - Can get a much better time precision by sending an IPI to each CPU
    in a special read operation if necessary, but this is awfully slow.
  - Gives the time in cycles since boot, but does not match perfectly a
    conversion from cycles to ns, since the scaling value is inaccurate.

Therefore, depending on your needs (accuracy vs granularity), I would be
tempted to use either the HPET or my monotonic TSC workaround.

Regards,

Mathieu

* Guillaume Chazarain (guichaz@gmail.com) wrote:
> Hello,
> 
> The scheduling problems I reported in the thread:
> http://lkml.org/lkml/2007/3/3/128
> are caused by the set_cyc2ns_scale() function called when the CPU speed 
> changes.
> Changing the scale causes a warp in the value returned by sched_clock().
> 
> The attached patch fixes the problem by adding an offset to the cyc2ns code 
> to
> smooth CPU frequency transitions. It also makes the cyc2ns parameters
> per-CPU as cpufreq seems to support SMP but I don't have the hardware
> to test. If you want
> a version without the per-CPU or irqsave stuff, just ask.
> 
> Although it solved all my scheduler issues, it may not be fully satisfactory
> as for example my TSC can run at a frequency as low as 350 MHz when the CPU 
> is
> idle and slowed down to the max at 798 MHz by ondemand. So in this case,
> sched_clock() does not return nanoseconds as it thinks it does. Hopefully 
> this
> is a non-issue as the scheduler is not stressed when the CPU is idle.
> 
> For me, this is needed in 2.6.21 if I want to be able to listen to music 
> while
> compiling a kernel using the ondemand governor.
> 
> Thanks.
> 
> Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
> ---
> 
> diff -r fb83e6d92a4c arch/i386/kernel/tsc.c
> --- a/arch/i386/kernel/tsc.c
> +++ b/arch/i386/kernel/tsc.c
> @@ -10,6 +10,7 @@
> #include <linux/jiffies.h>
> #include <linux/init.h>
> #include <linux/dmi.h>
> +#include <linux/percpu.h>
> 
> #include <asm/delay.h>
> #include <asm/tsc.h>
> @@ -79,20 +80,57 @@ static inline int check_tsc_unstable(voi
>  *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
>  *  (mathieu.desnoyers@polymtl.ca)
>  *
> + *  ns += offset to avoid sched_clock jumps with cpufreq (guichaz@yahoo.fr)
> + *
>  *			-johnstul@us.ibm.com "math is hard, lets go 
>  shopping!"
>  */
> -static unsigned long cyc2ns_scale __read_mostly;
> -
> #define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
> 
> -static inline void set_cyc2ns_scale(unsigned long cpu_khz)
> -{
> -	cyc2ns_scale = (1000000 << CYC2NS_SCALE_FACTOR)/cpu_khz;
> +struct cyc2ns_params {
> +	unsigned long scale;
> +	unsigned long long offset;
> +};
> +DEFINE_PER_CPU(struct cyc2ns_params, cyc2ns) __read_mostly;
> +
> +static inline unsigned long long __cycles_2_ns(struct cyc2ns_params 
> *params,
> +					       unsigned long long cyc)
> +{
> +	return ((cyc * params->scale) >> CYC2NS_SCALE_FACTOR) + 
> params->offset;
> }
> 
> static inline unsigned long long cycles_2_ns(unsigned long long cyc)
> {
> -	return (cyc * cyc2ns_scale) >> CYC2NS_SCALE_FACTOR;
> +	struct cyc2ns_params *params;
> +	unsigned long flags;
> +	unsigned long long ns;
> +
> +	params = &get_cpu_var(cyc2ns);
> +
> +	local_irq_save(flags);
> +	ns = __cycles_2_ns(params, cyc);
> +	local_irq_restore(flags);
> +
> +	put_cpu_var(cyc2ns);
> +	return ns;
> +}
> +
> +static void set_cyc2ns_scale(unsigned long cpu_khz)
> +{
> +	struct cyc2ns_params *params;
> +	unsigned long flags;
> +	unsigned long long tsc_now, ns_now;
> +
> +	get_scheduled_cycles(tsc_now);
> +	params = &get_cpu_var(cyc2ns);
> +
> +	local_irq_save(flags);
> +	ns_now = __cycles_2_ns(params, tsc_now);
> +
> +	params->scale = (1000000 << CYC2NS_SCALE_FACTOR)/cpu_khz;
> +	params->offset += ns_now - __cycles_2_ns(params, tsc_now);
> +	local_irq_restore(flags);
> +
> +	put_cpu_var(cyc2ns);
> }
> 
> /*
> 
> 
> -- 
> Guillaume

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
