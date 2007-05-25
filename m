Return-Path: <linux-kernel-owner+w=401wt.eu-S1760584AbXEYIWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760584AbXEYIWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbXEYIWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:22:20 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:28251 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751298AbXEYIWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:22:17 -0400
Subject: Re: [patch] sched_clock(): cleanups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070525074915.GA18400@elte.hu>
References: <20070525071005.GA6431@elte.hu>
	 <a781481a0705250022t3dec8f13u7c75d0ade40b0010@mail.gmail.com>
	 <20070525073158.GB8094@one.firstfloor.org> <20070525073957.GA15207@elte.hu>
	 <20070525074316.GA16821@elte.hu>  <20070525074915.GA18400@elte.hu>
Content-Type: text/plain
Date: Fri, 25 May 2007 10:22:09 +0200
Message-Id: <1180081329.7348.44.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-25 at 09:49 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > updated version of the cleanup patch below, renamed r_s_c to 
> > resync_freq, and changed 'f' to 'freq'.
> 
> updated one below.
> 
> 	Ingo
> 
> ------------------->
> Subject: [patch] sched_clock(): cleanups
> From: Ingo Molnar <mingo@elte.hu>
> 
> clean up sched-clock.c - mostly comment style fixes.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Looks good.

> ---
>  arch/i386/kernel/sched-clock.c |  110 +++++++++++++++++++++++++----------------
>  1 file changed, 69 insertions(+), 41 deletions(-)
> 
> Index: linux-cfs-2.6.22-rc2-mm1.q/arch/i386/kernel/sched-clock.c
> ===================================================================
> --- linux-cfs-2.6.22-rc2-mm1.q.orig/arch/i386/kernel/sched-clock.c
> +++ linux-cfs-2.6.22-rc2-mm1.q/arch/i386/kernel/sched-clock.c
> @@ -60,18 +60,20 @@ DEFINE_PER_CPU(struct sc_data, sc_data) 
>   */
>  unsigned long long native_sched_clock(void)
>  {
> -	unsigned long long r;
>  	struct sc_data *sc = &get_cpu_var(sc_data);
> +	unsigned long long r;
> +	unsigned long flags;
>  
>  	if (sc->unstable) {
> -		unsigned long flags;
>  		r = (jiffies_64 - sc->sync_base) * (1000000000 / HZ);
>  		r += sc->ns_base;
>  		local_irq_save(flags);
> -		/* last_val is used to avoid non monotonity on a
> -		   stable->unstable transition. Make sure the time
> -		   never goes to before the last value returned by
> -		   the TSC clock */
> +		/*
> +		 * last_val is used to avoid non monotonity on a
> +		 * stable->unstable transition. Make sure the time
> +		 * never goes to before the last value returned by
> +		 * the TSC clock
> +		 */
>  		if (r <= sc->last_val)
>  			r = sc->last_val + 1;
>  		sc->last_val = r;
> @@ -87,8 +89,10 @@ unsigned long long native_sched_clock(vo
>  	return r;
>  }
>  
> -/* We need to define a real function for sched_clock, to override the
> -   weak default version */
> +/*
> + * We need to define a real function for sched_clock, to override the
> + * weak default version
> + */
>  #ifdef CONFIG_PARAVIRT
>  unsigned long long sched_clock(void)
>  {
> @@ -101,9 +105,11 @@ unsigned long long sched_clock(void)
>  
>  static int no_sc_for_printk;
>  
> -/* printk clock: when it is known the sc results are very non monotonic
> -   fall back to jiffies for printk. Other sched_clock users are supposed
> -   to handle this. */
> +/*
> + * printk clock: when it is known the sc results are very non monotonic
> + * fall back to jiffies for printk. Other sched_clock users are supposed
> + * to handle this.
> + */
>  unsigned long long printk_clock(void)
>  {
>  	if (unlikely(no_sc_for_printk))
> @@ -119,35 +125,46 @@ static void resync_sc_freq(struct sc_dat
>  		sc->unstable = 1;
>  		return;
>  	}
> -	/* Handle nesting, but when we're zero multiple calls in a row
> -	   are ok too and not a bug */
> +	/*
> +	 * Handle nesting, but when we're zero multiple calls in a row
> +	 * are ok too and not a bug
> +	 */
>  	if (sc->unstable > 0)
>  		sc->unstable--;
>  	if (sc->unstable)
>  		return;
> -	/* RED-PEN protect with seqlock? I hope that's not needed
> -	   because sched_clock callers should be able to tolerate small
> -	   errors. */
> +	/*
> +	 * RED-PEN protect with seqlock? I hope that's not needed
> +	 * because sched_clock callers should be able to tolerate small
> +	 * errors.
> +	 */
>  	sc->ns_base = ktime_to_ns(ktime_get());
>  	rdtscll(sc->sync_base);
>  	sc->cyc2ns_scale = (1000000 << CYC2NS_SCALE_FACTOR) / newfreq;
>  }
>  
> -static void call_r_s_f(void *arg)
> +static void __resync_freq(void *arg)
>  {
> -	struct cpufreq_freqs *freq = arg;
> -	unsigned f = freq->new;
> -	if (!f)
> -		f = cpufreq_get(freq->cpu);
> -	if (!f)
> -		f = tsc_khz;
> -	resync_sc_freq(&per_cpu(sc_data, freq->cpu), f);
> +	struct cpufreq_freqs *freqp = arg;
> +	unsigned freq = freqp->new;
> +
> +	if (!freq) {
> +		freq = cpufreq_get(freqp->cpu);
> +		/*
> +		 * Still no frequency? Then fall back to tsc_khz:
> +		 */
> +		if (!freq)
> +			freq = tsc_khz;
> +	}
> +	resync_sc_freq(&per_cpu(sc_data, freqp->cpu), freq);
>  }
>  
> -static void call_r_s_f_here(void *arg)
> +static void resync_freq(void *arg)
>  {
> -	struct cpufreq_freqs f = { .cpu = get_cpu(), .new = 0 };
> -	call_r_s_f(&f);
> +	struct cpufreq_freqs f = { .new = 0 };
> +
> +	f.cpu = get_cpu();
> +	__resync_freq(&f);
>  	put_cpu();
>  }
>  
> @@ -155,9 +172,11 @@ static int sc_freq_event(struct notifier
>  			 void *data)
>  {
>  	struct cpufreq_freqs *freq = data;
> -	int cpu = get_cpu();
> -	struct sc_data *sc = &per_cpu(sc_data, cpu);
> +	struct sc_data *sc;
> +	int cpu;
>  
> +	cpu = get_cpu();
> +	sc = &per_cpu(sc_data, cpu);
>  	if (cpu_has(&cpu_data[cpu], X86_FEATURE_CONSTANT_TSC))
>  		goto out;
>  	if (freq->old == freq->new)
> @@ -167,25 +186,30 @@ static int sc_freq_event(struct notifier
>  	case CPUFREQ_SUSPENDCHANGE:
>  		/* Mark TSC unstable during suspend/resume */
>  	case CPUFREQ_PRECHANGE:
> -		/* Mark TSC as unstable until cpu frequency change is done
> -		   because we don't know when exactly it will change.
> -		   unstable in used as a counter to guard against races
> -		   between the cpu frequency notifiers and normal resyncs */
> +		/*
> +		 * Mark TSC as unstable until cpu frequency change is done
> +		 * because we don't know when exactly it will change.
> +		 * unstable in used as a counter to guard against races
> +		 * between the cpu frequency notifiers and normal resyncs
> +		 */
>  		sc->unstable++;
>  		/* FALL THROUGH */
>  	case CPUFREQ_RESUMECHANGE:
>  	case CPUFREQ_POSTCHANGE:
> -		/* Frequency change or resume is done -- update everything and
> -		   mark TSC as stable again. */
> +		/*
> +		 * Frequency change or resume is done -- update everything
> +		 * and mark TSC as stable again.
> +		 */
>  		if (cpu == freq->cpu)
>  			resync_sc_freq(sc, freq->new);
>  		else
> -			smp_call_function_single(freq->cpu, call_r_s_f,
> +			smp_call_function_single(freq->cpu, __resync_freq,
>  						 freq, 0, 1);
>  		break;
>  	}
>  out:
>  	put_cpu();
> +
>  	return NOTIFY_DONE;
>  }
>  
> @@ -197,9 +221,11 @@ static int __cpuinit
>  sc_cpu_event(struct notifier_block *self, unsigned long event, void *hcpu)
>  {
>  	long cpu = (long)hcpu;
> +
>  	if (event == CPU_ONLINE) {
>  		struct cpufreq_freqs f = { .cpu = cpu, .new = 0 };
> -		smp_call_function_single(cpu, call_r_s_f, &f, 0, 1);
> +
> +		smp_call_function_single(cpu, __resync_freq, &f, 0, 1);
>  	}
>  	return NOTIFY_DONE;
>  }
> @@ -209,13 +235,15 @@ static __init int init_sched_clock(void)
>  	if (unsynchronized_tsc())
>  		no_sc_for_printk = 1;
>  
> -	/* On a race between the various events the initialization might be
> -	   done multiple times, but code is tolerant to this */
> +	/*
> +	 * On a race between the various events the initialization might be
> +	 * done multiple times, but code is tolerant to this
> +	 */
>  	cpufreq_register_notifier(&sc_freq_notifier,
>  				CPUFREQ_TRANSITION_NOTIFIER);
>  	hotcpu_notifier(sc_cpu_event, 0);
> -	on_each_cpu(call_r_s_f_here, NULL, 0, 0);
> +	on_each_cpu(resync_freq, NULL, 0, 0);
> +
>  	return 0;
>  }
>  core_initcall(init_sched_clock);
> -

