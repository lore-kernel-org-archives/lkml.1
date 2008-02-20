Return-Path: <linux-kernel-owner+w=401wt.eu-S1763515AbYBTBv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763515AbYBTBv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 20:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757734AbYBTBu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 20:50:58 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60115 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757062AbYBTBu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 20:50:56 -0500
Subject: Re: [PATCH] correct inconsistent ntp interval/tick_length usage
From: john stultz <johnstul@us.ibm.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <Pine.LNX.4.64.0802190219360.2723@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801251349120.17507@scrub.home>
	 <1201573686.6766.13.camel@localhost>
	 <Pine.LNX.4.64.0801290439480.17507@scrub.home>
	 <1201659263.6766.40.camel@localhost>
	 <Pine.LNX.4.64.0801310251090.17507@scrub.home>
	 <1201745776.6195.14.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801310404480.17507@scrub.home>
	 <1201914175.6216.46.camel@jstultz-laptop>
	 <Pine.LNX.4.64.0802081718040.3378@scrub.home>
	 <1202523452.6174.45.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0802101917030.3378@scrub.home>
	 <1202774999.5984.106.camel@localhost>
	 <Pine.LNX.4.64.0802120335170.3378@scrub.home>
	 <1202963796.6195.141.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0802150436300.1822@scrub.home>
	 <1203382940.5984.242.camel@localhost>
	 <Pine.LNX.4.64.0802190219360.2723@scrub.home>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 17:50:50 -0800
Message-Id: <1203472250.6123.98.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-19 at 05:04 +0100, Roman Zippel wrote:
> Hi,
> 
> On Mon, 18 Feb 2008, john stultz wrote:
> 
> > If we are building a train station, and each train car is 60ft, it
> > doesn't make much sense to build 1000ft stations, right? Instead you'll
> > do better if you build a 1020ft station.
> 
> That would assume trains are always 60ft long, which is the basic error in 
> your assumption.
> 
> Since we're using analogies: What you're doing is to put you winter 
> clothes on your weight scale and reset the scale to zero to offset for the 
> weigth of the clothes. If you stand now with your bathing clothes on the 
> scale, does that mean you lost weight?

Sheesh, now you're calling me deceiving *and* fat! ;)


> That's all you do - you change the scale and slightly screw the scale for 
> everyone else trying to use it.

I don't think so. This all has to do with intervals, not scale offsets.
I'm having a hard time seeing how we're not connecting on this.

To better keep with your analogy, you'd have to imagine a scale that
only reads in X pound increments. As long as X is fairly small, it
should measure everyone's weight fairly well. However, if X is large,
like say 50kg, then it won't weigh a 70kg person very accurately (even
if he is a liar and he really weighs 77kgs).


This is the granularity error I'm talking about. 

Again, this all has to do with our accumulation intervals.

Lets look at the code. I'm going to focus on jiffies as its the best
example, being both very common and very course.


Let's say we make our base interval 1,000,000ns.

Using the jiffies clocksource, the closest we can get to this interval
is 1 jiffy, which is 999,847ns. 

Now every interval we will see 153ns error. The clocksource_adjust()
function will watch this error accumulate and adjust the jiffies's
frequency by 153ppm to try to compensate. Note, this compensation is not
adjusting for any hardware drift, it is only compensating for the error
we've injected by choosing an interval the clocksource cannot match.

Now, when NTP starts up, if we had perfect hardware and there was no
hardware drift, NTP would have to inject a -153ppm correction to offset
the systematic error we've introduced.

If we do not have perfect hardware, then NTP would have to correct for
both the 153ppm error and the hardware error. Sp if the hardware error
was in the same direction, we can now only compensate for up to a 347ppm
hardware drift, before we hit the 500ppm bound in NTP.

Using the test program I sent out before:
HZ=1000 CLOCK_TICK_ADJUST=0

jiffies     
==========
1 cycles per 1000000 ns
999847 ns per cycle
999847 ns per interval
153000 ppb error

jiffies NOHZ
==========
500 cycles per 500000000 ns
999847 ns per cycle
499923500 ns per interval
153000 ppb error


Now, if we make our base interval match the clocksource granularity,
this can avoid the error. If the base interval we accumulate with is
999,847ns, we avoid needlessly accumulating error. 

This means without NTP correction, the system clock drift will match the
hardware clock drift. So when NTP does kick in, it only has to correct
for that hardware drift.

HZ=1000 CLOCK_TICK_ADJUST=-152533
jiffies     
==========
1 cycles per 999847 ns
999847 ns per cycle
999847 ns per interval
0 ppb error

jiffies NOHZ
==========
500 cycles per 499923733 ns
999847 ns per cycle
499923500 ns per interval
466 ppb error


> To keep in mind what time adjusting is supposed to do:
> 
> 	freq = 1sec + time_freq

But it is this fixation on 1sec that is the cause of the granularity
error. I believe the following is also correct (assuming time_freq is in
ppm units):

adjusted_freq = interval_length + (interval_length * time_freq)/MILLION

This properly scales the adjustment to any interval length.


> What we do instead is:
> 
> 	freq + tick_adj = 1sec + time_freq
> 
> Where exactly is now the problem to integrate tick_adj into time_freq? The 
> result is _exactly_ the same. The only visible difference is a slightly 
> higher time_freq value and as long as it is within the 500 ppm limit there 
> is simply no problem.

Well, it is a problem if its large. The 500ppm limit is supposed to be
for hardware frequency error correction, not hardware frequency +
software error correction. Now, if it were 1-10ppm, it wouldn't be that
big of an issue, but with the jiffies example above, 153ppm does cut
into the correctable space a good bit.

Show me how we cut that error down, and I'll be happy to kill
CLOCK_TICK_ADJUST.

> > And yes, if we remove CLOCK_TICK_ADJUST, that would also resolve the 
> > (A!=B) issue, but it doesn't address the error from #2 below.
> > [..]
> > 2) We need a solution that handles granularity error well, as this is a
> > moderate source of error for course clocksources such as jiffies.
> > CLOCK_TICK_ADJUST does cover this fairly well in most cases. I suspect
> > we could do even better, but that will take some deeper changes.
> 
> How exactly does CLOCK_TICK_ADJUST address this problem? The error due to 
> insufficient resolution is still there, all it does is shifting the scale, 
> so it's not immediately visible.

Again, I agree there is a small error (76ppb in my earlier example)
caused when we time_freq adjustment to what we assume is 1 second, when
CLOCK_TICK_ADJ is involved.

However, relatively this is small compared with the example 153ppm error
above caused by ignoring the granularity issue. Additionally we can fix
it using the scaling method I pointed out above.

> > My understanding of your approach (removing CLOCK_TICK_ADJUST),
> > addresses issues #1 and #3, but hurts issue #2.
> 
> What exactly is hurt?

By injecting 153ppm of error, the ability for NTP to correct hardware
error within 500ppm is hurt.

Sigh. So at this point, if we're not closing the gap in our
understanding, I'm not sure how much its worth to continue on the
discussion in this manner. I'd welcome anyone to help clarify what I'm
missing, or maybe assistance in better communicating my point.

In the meantime, I'll add the scaling fix from above to my code and
re-submit it. If you want you can send your own patch and I'll gladly
test, review it and try to figure out what I'm missing.

Once again, thanks for the feedback.
-john

