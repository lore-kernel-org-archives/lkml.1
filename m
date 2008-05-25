Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbYE1LSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbYE1LSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 07:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYE1LRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 07:17:49 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3107 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752564AbYE1LRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 07:17:48 -0400
Date: Sun, 25 May 2008 20:01:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, akpm@osdl.org,
       Ingo Molnar <mingo@elte.hu>, Clark Williams <clark.williams@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Gregory Haskins <ghaskins@novell.com>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: enable preemption in delay
Message-ID: <20080525180122.GA4247@ucw.cz>
References: <Pine.LNX.4.58.0805242306280.3977@gandalf.stny.rr.com> <alpine.LFD.1.10.0805251406260.3295@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805251406260.3295@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > +		if (unlikely(cpu != smp_processor_id())) {
> 
> Eeek, once you migrated you do this all the time. you need to update
> cpu here.
> 
> > +			if ((now-bclock) >= loops)
> > +				break;
> 
> Also this is really dangerous with unsynchronized TSCs. You might get
> migrated and return immediately because the TSC on the other CPU is
> far ahead.
> 
> What you really want is something like the patch below, but we should
> reuse the sched_clock_cpu() thingy to make that simpler. Looking into
> that right now.

> @@ -40,17 +40,51 @@ static void delay_loop(unsigned long loops)
>  		:"0" (loops));
>  }
>  
> +/*
> + * 5 usec on a 1GHZ machine. Not necessarily correct, but not too long
> + * either.
> + */
> +#define TSC_MIGRATE_COUNT 5000
> +
>  /* TSC based delay: */
>  static void delay_tsc(unsigned long loops)
>  {
>  	unsigned long bclock, now;
> +	int cpu;
>  
> -	preempt_disable();		/* TSC's are per-cpu */
> +	preempt_disable();
> +	cpu = smp_processor_id();
>  	rdtscl(bclock);
>  	do {
>  		rep_nop();
> -		rdtscl(now);
> -	} while ((now-bclock) < loops);
> +
> +		/* Allow RT tasks to run */
> +		preempt_enable();
> +		preempt_disable();
> +
> +		/*
> +		 * It is possible that we moved to another CPU, and
> +		 * since TSC's are per-cpu we need to calculate
> +		 * that. The delay must guarantee that we wait "at
> +		 * least" the amount of time. Being moved to another
> +		 * CPU could make the wait longer but we just need to
> +		 * make sure we waited long enough. Rebalance the
> +		 * counter for this CPU.
> +		 */
> +		if (unlikely(cpu != smp_processor_id())) {
> +			if (loops <= TSC_MIGRATE_COUNT)
> +				break;
> +			cpu = smp_processor_id();
> +			rdtscl(bclock);
> +			loops -= TSC_MIGRATE_COUNT;
> +		} else {
> +			rdtscl(now);
> +			if ((now - bclock) >= loops)
> +				break;
> +			loops -= (now - bclock);
> +			bclock = now;

What happens with different cpus running on different frequencies...?
Cpufreq?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
