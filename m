Return-Path: <linux-kernel-owner+w=401wt.eu-S1753116AbZCYI0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbZCYI0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 04:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbZCYI0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 04:26:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35095 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbZCYI0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 04:26:16 -0400
Date: Wed, 25 Mar 2009 09:25:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: john stultz <johnstul@us.ibm.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
       Clark Williams <williams@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roman Zippel <zippel@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] Logarithmic Timekeeping Accumulation
Message-ID: <20090325082523.GG25833@elte.hu>
References: <1237858102.7068.20.camel@jstultz-laptop> <20090324141338.GF32043@elte.hu> <1237940077.6065.3.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237940077.6065.3.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* john stultz <johnstul@us.ibm.com> wrote:

> On Tue, 2009-03-24 at 15:13 +0100, Ingo Molnar wrote:
> > * John Stultz <johnstul@us.ibm.com> wrote:
> > 
> > > Accumulating one tick at a time works well unless we're using 
> > > NOHZ. Then it can be an issue, since we may have to run through 
> > > the loop a few thousand times, which can increase timer interrupt 
> > > caused latency.
> > > 
> > > The current solution was to accumulate in half-second intervals 
> > > with NOHZ. This kept the number of loops down, however it did 
> > > slightly change how we make NTP adjustments. While not an issue 
> > > with NTPd users, as NTPd makes adjustments over a longer period of 
> > > time, other adjtimex() users have noticed the half-second 
> > > granularity with which we can apply frequency changes to the 
> > > clock.
> > > 
> > > For instance, if a application tries to apply a 100ppm frequency 
> > > correction for 20ms to correct a 2us offset, with NOHZ they either 
> > > get no correction, or a 50us correction.
> > > 
> > > Now, there will always be some granularity error for applying 
> > > frequency corrections. However with users sensitive to this error 
> > > have seen a 50-500x increase with NOHZ compared to running without 
> > > NOHZ.
> > > 
> > > So I figured I'd try another approach then just simply increasing 
> > > the interval. My approach is to consume the time interval 
> > > logarithmically. This reduces the number of times through the loop 
> > > needed keeping latency down, while still preserving the original 
> > > granularity error for adjtimex() changes.
> > > 
> > > This has been lightly tested and appears to work correctly, but 
> > > I'd appreciate any feedback or comments on the idea and code.
> > > 
> > > Signed-off-by: John Stultz <johnstul@us.ibm.com>
> > 
> > Hm, we used to have some sort of problem with a similar patch in the 
> > past. 
> 
> Do you recall any details about the problem? I don't.

Do you remember that logarithmic accumulation patch you did for -rt 
originally? That was which introduced an NTP breakage. My memories 
are fuzzy, and it's probably all moot, just wanted to ask :-)

> > >  		/* accumulate error between NTP and clock interval */
> > > -		clock->error += tick_length;
> > > -		clock->error -= clock->xtime_interval << (NTP_SCALE_SHIFT - clock->shift);
> > > +		clock->error += tick_length << shift;
> > > +		clock->error -= (clock->xtime_interval
> > > +				<< (NTP_SCALE_SHIFT - clock->shift))
> > > +					<< shift;
> > 
> > Why not:
> > 
> > 		clock->error -= clock->xtime_interval
> > 				<< (NTP_SCALE_SHIFT - clock->shift + shift);
> > 
> > ?
> 
> Yep. Much cleaner.
> 
> 
> > > +		if (shift > 0) /*don't roll under!*/
> > > +			shift--;
> > 
> > (nit: watch out the comment style)
> 
> Good point.
> 
> > that bit looks a bit messy. We estimated the shift:
> > 
> > +	while (offset > (clock->cycle_interval << shift))
> > +               shift++;
> > +	shift--;
> > 
> > can it really ever roll under in this loop:
> 
> It probably can't. I just haven't sat down to work out the full math to
> prove it to myself, so I've been cautious. 
> 
> 
> Thanks for the suggestions, I'll roll those fixes up into the next
> version.
> 
> 
> So the basic approach seems ok by you?

Yeah, certainly.

Please mention it in the changelog that the logarithmic method is a 
perfect replacement for the existing code - not an approximation.

Most of the loop is linear calculations so there going to a 
logarithmic loop is fine (as long as shift does not cause an 
overflow in the worst case - that should be double checked).

The only non-linear aspect of this loop is:

                if (clock->xtime_nsec >= (u64)NSEC_PER_SEC << clock->shift) {
                        clock->xtime_nsec -= (u64)NSEC_PER_SEC << clock->shift;
                        xtime.tv_sec++;
                        second_overflow();
               	}


We'll now hit this moment imprecisely - with a 
~clock->cycle_interval/2 worst-case.

Fortunately this is not an issue in terms of second_overflow() 
internals, except one small (nitpicky) detail: we should make sure 
elsewhere (or at least comment on the fact) that 
clock->cycle_interval should never be below 1 seconds range - 
otherwise we could miss a second_overflow() call. That is true 
currently (HZ=10 is the current lowest timer tick frequency AFAICS).

One more thing:

+       while (offset > (clock->cycle_interval << shift))
+               shift++;
+	shift--;

why not use ilog2()?

About your choice of algorithm.

In theory we could use a different implementation here: instead of 
the current linear and your proposed logarithmic algorithm, it could 
be plain multiplicative, calculating the clock offsets straight 
forward by 'offset' nanoseconds - and calculating the number of 
second overflows it touched along the way. Then we could do a 
seconds_overflow() (note the plural) code in NTP.

The problem is, sufficiently large 'offset' values would rarely be 
tested - and this would make it fragile in practice to overflow 
conditions in the multiplication math.

So i think we are best served by your logarithmic approach - it's 
all plain shifts with clear bounds, so easier to validate (and 
easier to tweak for overflows), and basically just as fast.

> > that bit looks a bit messy. We estimated the shift:
> >
> > +   while (offset > (clock->cycle_interval << shift))
> > +               shift++;
> > +   shift--;
> >
> > can it really ever roll under in this loop:
> 
> It probably can't. I just haven't sat down to work out the full 
> math to prove it to myself, so I've been cautious.

That needs to be done though, instead of silently being wrong on the 
math for really long intervals. The ilog2 is done in a reverse 
direction in the loop inside (modulo 1) so it should match up 
perfectly. If it does not, we need to emit a WARN_ONCE(). (Note: 
first release the xtime_lock in that case, we'll lock up otherwise.)

A quick look suggests that there might be a problem area: we might 
need to limit the maximum value of shift, to never overflow this:

 		clock->error -= clock->xtime_interval
 				<< (NTP_SCALE_SHIFT - clock->shift + shift);

Either via a clock->max_shift, or - ideally - via a reasonable 
constant of max shift of around 16 or so.

We cannot assume anything about the maximum value of 'offset' on 
NOHZ here - i've seen dynticks sleep times of over 120 seconds in 
the past. So an input of 120,000,000,000 is possible (with HZ=1000 
that would be a shift of ~17) and i think the shift needs to be 
capped to not overflow the 64 bit width.

Fortunately, as HZ goes up, xtime_iterval goes down, so a cap of 16 
looks realistic and robust. Please re-do the math though :)

Thanks,

	Ingo
