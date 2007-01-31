Return-Path: <linux-kernel-owner+w=401wt.eu-S932933AbXAaPnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbXAaPnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 10:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932934AbXAaPnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 10:43:37 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:18679 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933AbXAaPng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 10:43:36 -0500
Subject: Re: [PATCH 10/23] clocksource: remove update_callback
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070131104610.GA740@elte.hu>
References: <20070131033710.420168478@mvista.com>
	 <20070131033806.127340327@mvista.com>  <20070131104610.GA740@elte.hu>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 07:42:05 -0800
Message-Id: <1170258125.9781.50.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 11:46 +0100, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > Uses the block notifier to replace the functionality of 
> > update_callback(). update_callback() was a special case specifically 
> > for the tsc, but including it in the clocksource structure duplicated 
> > it needlessly for other clocks.
> 
> Firstly, it think it should be mentioned that Thomas' queue already does 
> this, in clocksource-remove-the-update-callback.patch (hence he should 
> have been Cc:-ed). Your queue 'drops' Thomas' patch then redoes it here 
> without mentioning that this is another version of what is in Thomas's 
> queue. So we get this situation:
> 
>    clocksource-remove-the-update-callback.patch
>    drop-clocksource-remove-the-update-callback.patch
>    clocksource_remove_update_callback.patch
> 
> that all flip-flops the same thing.

To be clear this change has exists for a very long time, long before
Thomas implemented it .. 

> Secondly, your patch seems to do other changes as well:
> 
> > @@ -179,6 +172,7 @@ int recalibrate_cpu_khz(void)
> >  	if (cpu_has_tsc) {
> >  		cpu_khz = calculate_cpu_khz();
> >  		tsc_khz = cpu_khz;
> > +		mark_tsc_unstable();
> >  		cpu_data[0].loops_per_jiffy =
> >  			cpufreq_scale(cpu_data[0].loops_per_jiffy,
> >  					cpu_khz_old, cpu_khz);
> 
> this adds a new event to a place that didnt have it before. (If this is 
> fixing up an initialization artifact then that needs a comment at 
> least.)

Alright .. Later on I talk about clock frequency recalculation which
pertains to this change .. 

> plus:
> 
> >  struct clocksource *clock = &clocksource_jiffies;
> > +atomic_t clock_recalc_interval = ATOMIC_INIT(0);
> 
> is not mentioned in the changelog. It's also needlessly global. 
> Furthermore, it seems to be a rather unclean method of passing 
> information from clocksource_callback() into change_clocksource():

It's a bisect artifact .. It's eventually dropped in a latter patch .

> > @@ -176,8 +177,9 @@ static int change_clocksource(void)
> >  		printk(KERN_INFO "Time: %s clocksource has been installed.\n",
> >  		       clock->name);
> >  		return 1;
> > -	} else if (clock->update_callback) {
> > -		return clock->update_callback();
> > +	} else if (unlikely(atomic_read(&clock_recalc_interval))) {
> > +		atomic_set(&clock_recalc_interval, 0);
> > +		return 1;
> 
> that's quite bad: you lost an information passing facility by going to a 
> notifier, and you try to work it around via a global atomic variable. 
> Which also looks quite racy as well.
> 
> The clean solution is i think what Thomas did: he calls straight into 
> clocksource_change_rating(). And look at Thomas' patch:

The information passing was purposefully dropped .. It was used (in
part) to recalculate the frequency of a clock , but after discussing it
with John he suggested we drop the frequency recalculation entirely. So
the information passing should no longer be needed.

Daniel

