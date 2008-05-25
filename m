Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbYEYNRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbYEYNRS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 09:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbYEYNRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 09:17:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49033 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbYEYNRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 09:17:07 -0400
Date: Sun, 25 May 2008 09:17:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, akpm@osdl.org,
       Ingo Molnar <mingo@elte.hu>, Clark Williams <clark.williams@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Gregory Haskins <ghaskins@novell.com>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: enable preemption in delay
In-Reply-To: <alpine.LFD.1.10.0805251406260.3295@apollo.tec.linutronix.de>
Message-ID: <Pine.LNX.4.58.0805250915410.20625@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0805242306280.3977@gandalf.stny.rr.com>
 <alpine.LFD.1.10.0805251406260.3295@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 25 May 2008, Thomas Gleixner wrote:
>
> +/*
> + * 5 usec on a 1GHZ machine. Not necessarily correct, but not too long
> + * either.

And what happens when we have 10GHz boxes that can do migration in 1us,
and the delay that is asked for is 2us. We can return early.  I don't like
to place assumptions of this kind that can hurt with future hardware
enhancements.

-- Steve


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
> +		}
> +	} while (loops > 0);
>  	preempt_enable();
>  }
>
