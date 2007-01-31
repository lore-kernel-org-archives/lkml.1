Return-Path: <linux-kernel-owner+w=401wt.eu-S932983AbXAaKsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983AbXAaKsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 05:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932994AbXAaKsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 05:48:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53512 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932983AbXAaKsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 05:48:24 -0500
Date: Wed, 31 Jan 2007 11:46:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 10/23] clocksource: remove update_callback
Message-ID: <20070131104610.GA740@elte.hu>
References: <20070131033710.420168478@mvista.com> <20070131033806.127340327@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131033806.127340327@mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_40 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	1.0 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3700]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> Uses the block notifier to replace the functionality of 
> update_callback(). update_callback() was a special case specifically 
> for the tsc, but including it in the clocksource structure duplicated 
> it needlessly for other clocks.

Firstly, it think it should be mentioned that Thomas' queue already does 
this, in clocksource-remove-the-update-callback.patch (hence he should 
have been Cc:-ed). Your queue 'drops' Thomas' patch then redoes it here 
without mentioning that this is another version of what is in Thomas's 
queue. So we get this situation:

   clocksource-remove-the-update-callback.patch
   drop-clocksource-remove-the-update-callback.patch
   clocksource_remove_update_callback.patch

that all flip-flops the same thing.

Secondly, your patch seems to do other changes as well:

> @@ -179,6 +172,7 @@ int recalibrate_cpu_khz(void)
>  	if (cpu_has_tsc) {
>  		cpu_khz = calculate_cpu_khz();
>  		tsc_khz = cpu_khz;
> +		mark_tsc_unstable();
>  		cpu_data[0].loops_per_jiffy =
>  			cpufreq_scale(cpu_data[0].loops_per_jiffy,
>  					cpu_khz_old, cpu_khz);

this adds a new event to a place that didnt have it before. (If this is 
fixing up an initialization artifact then that needs a comment at 
least.)

plus:

>  struct clocksource *clock = &clocksource_jiffies;
> +atomic_t clock_recalc_interval = ATOMIC_INIT(0);

is not mentioned in the changelog. It's also needlessly global. 
Furthermore, it seems to be a rather unclean method of passing 
information from clocksource_callback() into change_clocksource():

> @@ -176,8 +177,9 @@ static int change_clocksource(void)
>  		printk(KERN_INFO "Time: %s clocksource has been installed.\n",
>  		       clock->name);
>  		return 1;
> -	} else if (clock->update_callback) {
> -		return clock->update_callback();
> +	} else if (unlikely(atomic_read(&clock_recalc_interval))) {
> +		atomic_set(&clock_recalc_interval, 0);
> +		return 1;

that's quite bad: you lost an information passing facility by going to a 
notifier, and you try to work it around via a global atomic variable. 
Which also looks quite racy as well.

The clean solution is i think what Thomas did: he calls straight into 
clocksource_change_rating(). And look at Thomas' patch:

 3 files changed, 17 insertions(+), 37 deletions(-)

versus yours:

 5 files changed, 45 insertions(+), 42 deletions(-)

Thomas' looks definitely simpler to me.

	ingo
