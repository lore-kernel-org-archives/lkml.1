Return-Path: <linux-kernel-owner+w=401wt.eu-S1752670AbZKLIxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbZKLIxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 03:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbZKLIxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 03:53:13 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:56255 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbZKLIxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 03:53:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qirHBB0iCn2TOg0T7CNcbpT+vMYF5bCUTd6Kd9Ej6+VhZajXCI/fTYVuOSibc8pr6I
         z8FERyOxIVu9MzgyMW6yywsJoLIII0DGvROQseiwUrWFe3D3fWfpHSpSHa+oz8lf3CX+
         FDQkjkQ06lmoHogHXTNiquzT6nWK7p8NhcWsY=
Message-ID: <4AFBCD1A.70402@gmail.com>
Date: Thu, 12 Nov 2009 00:53:46 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [PATCH 3/3][RFC] tracing: Separate out x86 time stamp reading
 and ns conversion
References: <20091112054354.838746008@goodmis.org> <20091112054846.053562222@goodmis.org>
In-Reply-To: <20091112054846.053562222@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> From: Steven Rostedt<srostedt@redhat.com>
>
> This patch separates the trace_clock_local time stamp reading from
> the conversion to nanoseconds for x86 by overriding the trace_clock_local
> and trace_noramlize_local furctions. It uses the time stamp normalize
> feature of the ring buffer to allow the ring buffer to record
> the raw cycles and have the read side convert it to nanoseconds.
>
> Before this separation, the cost of a trace was 179 ns, after it is
> 149 ns (30 ns performance boost 17%).
>
> perf top before separation:
>
> ------------------------------------------------------------------------------
>     PerfTop:    1002 irqs/sec  kernel:100.0% [1000Hz cpu-clock-msecs],  (all, 4 CPUs)
> ------------------------------------------------------------------------------
>
>               samples    pcnt   kernel function
>               _______   _____   _______________
>
>               1653.00 - 25.0% : sched_clock
>               1147.00 - 17.4% : rb_reserve_next_event
>                865.00 - 13.1% : ring_buffer_lock_reserve
>                628.00 -  9.5% : rb_end_commit
>                521.00 -  7.9% : ring_buffer_unlock_commit
>                481.00 -  7.3% : __rb_reserve_next
>                392.00 -  5.9% : debug_smp_processor_id
>                284.00 -  4.3% : trace_clock_local
>                270.00 -  4.1% : ring_buffer_producer_thread 	[ring_buffer_benchmark]
>                108.00 -  1.6% : ring_buffer_event_data
>                100.00 -  1.5% : trace_recursive_unlock
>                 70.00 -  1.1% : _spin_unlock_irq
>                 30.00 -  0.5% : do_gettimeofday
>                 21.00 -  0.3% : tick_nohz_stop_sched_tick
>                 18.00 -  0.3% : read_tsc
>
> and after:
>
> ------------------------------------------------------------------------------
>     PerfTop:    1024 irqs/sec  kernel:100.0% [1000Hz cpu-clock-msecs],  (all, 4 CPUs)
> ------------------------------------------------------------------------------
>
>               samples    pcnt   kernel function
>               _______   _____   _______________
>
>               1595.00 - 19.9% : rb_reserve_next_event
>               1521.00 - 18.9% : trace_clock_local
>               1393.00 - 17.3% : ring_buffer_lock_reserve
>                864.00 - 10.8% : __rb_reserve_next
>                745.00 -  9.3% : rb_end_commit
>                736.00 -  9.2% : ring_buffer_unlock_commit
>                395.00 -  4.9% : ring_buffer_producer_thread 	[ring_buffer_benchmark]
>                256.00 -  3.2% : debug_smp_processor_id
>                188.00 -  2.3% : ring_buffer_event_data
>                179.00 -  2.2% : trace_recursive_unlock
>                 52.00 -  0.6% : _spin_unlock_irq
>                 38.00 -  0.5% : read_tsc
>                 34.00 -  0.4% : do_gettimeofday
>                 27.00 -  0.3% : getnstimeofday
>
> Signed-off-by: Steven Rostedt<rostedt@goodmis.org>
> ---
>   arch/x86/kernel/tsc.c |   35 +++++++++++++++++++++++++++++++++++
>   1 files changed, 35 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index cd982f4..c6576f2 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -37,6 +37,7 @@ static int __read_mostly tsc_unstable;
>   static int __read_mostly tsc_disabled = -1;
>
>   static int tsc_clocksource_reliable;
> +
>   /*
>    * Scheduler clock - returns current time in nanosec units.
>    */
> @@ -64,6 +65,40 @@ u64 native_sched_clock(void)
>   	return __cycles_2_ns(this_offset);
>   }
>
> +u64 trace_clock_local(void)
> +{
> +	u64 this_offset;
> +
> +	/*
> +	 * Fall back to jiffies if there's no TSC available:
> +	 * ( But note that we still use it if the TSC is marked
> +	 *   unstable. We do this because unlike Time Of Day,
> +	 *   the scheduler clock tolerates small errors and it's
> +	 *   very important for it to be as fast as the platform
> +	 *   can achive it. )
> +	 */
> +	if (unlikely(tsc_disabled))
> +		/* No locking but a rare wrong value is not a big deal: */
> +		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
> +
> +	/* read the Time Stamp Counter: */
> +	rdtscll(this_offset);
> +
> +	return this_offset;
> +}
> +
> +void trace_normalize_local(int cpu, u64 *ts)
> +{
> +	unsigned long long ns = per_cpu(cyc2ns_offset, cpu);
> +	unsigned long long cyc = *ts;
> +
> +	if (unlikely(tsc_disabled))
> +		return;
> +
> +	ns += cyc * per_cpu(cyc2ns, cpu)>>  CYC2NS_SCALE_FACTOR;
> +	*ts = ns;
> +}
> +
>   /* We need to define a real function for sched_clock, to override the
>      weak default version */
>   #ifdef CONFIG_PARAVIRT
>    
Well, since I seem to have English as a second language
(according to the University, even though it's my only language)
my guess would be to correct this:

  * ( But note that we still use it if the TSC is marked
+	 *   unstable. We do this because unlike Time Of Day,
+	 *   the scheduler clock tolerates small errors and it's
+	 *   very important for it to be as fast as the platform
+	 *   can achive it. )

to:

  *   But note that we still use it if the TSC is marked
+	 *   unstable. We do this because unlike Time Of Day,
+	 *   the scheduler clock tolerates small errors and it's
+	 *   very important for it to be as fast as the platform
+	 *   can achieve it.

(achive could be a word like pak da kah(boston))

but this is just cosmetic.

Justin P. Mattock



