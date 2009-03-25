Return-Path: <linux-kernel-owner+w=401wt.eu-S1756357AbZCYAO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbZCYAO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755895AbZCYAOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:14:48 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:59551 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898AbZCYAOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:14:47 -0400
Subject: Re: [RFC][PATCH] Logarithmic Timekeeping Accumulation
From: john stultz <johnstul@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
       Clark Williams <williams@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <20090324141338.GF32043@elte.hu>
References: <1237858102.7068.20.camel@jstultz-laptop>
	 <20090324141338.GF32043@elte.hu>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 17:14:37 -0700
Message-Id: <1237940077.6065.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-24 at 15:13 +0100, Ingo Molnar wrote:
> * John Stultz <johnstul@us.ibm.com> wrote:
> 
> > Accumulating one tick at a time works well unless we're using 
> > NOHZ. Then it can be an issue, since we may have to run through 
> > the loop a few thousand times, which can increase timer interrupt 
> > caused latency.
> > 
> > The current solution was to accumulate in half-second intervals 
> > with NOHZ. This kept the number of loops down, however it did 
> > slightly change how we make NTP adjustments. While not an issue 
> > with NTPd users, as NTPd makes adjustments over a longer period of 
> > time, other adjtimex() users have noticed the half-second 
> > granularity with which we can apply frequency changes to the 
> > clock.
> > 
> > For instance, if a application tries to apply a 100ppm frequency 
> > correction for 20ms to correct a 2us offset, with NOHZ they either 
> > get no correction, or a 50us correction.
> > 
> > Now, there will always be some granularity error for applying 
> > frequency corrections. However with users sensitive to this error 
> > have seen a 50-500x increase with NOHZ compared to running without 
> > NOHZ.
> > 
> > So I figured I'd try another approach then just simply increasing 
> > the interval. My approach is to consume the time interval 
> > logarithmically. This reduces the number of times through the loop 
> > needed keeping latency down, while still preserving the original 
> > granularity error for adjtimex() changes.
> > 
> > This has been lightly tested and appears to work correctly, but 
> > I'd appreciate any feedback or comments on the idea and code.
> > 
> > Signed-off-by: John Stultz <johnstul@us.ibm.com>
> 
> Hm, we used to have some sort of problem with a similar patch in the 
> past. 

Do you recall any details about the problem? I don't.


> >  		/* accumulate error between NTP and clock interval */
> > -		clock->error += tick_length;
> > -		clock->error -= clock->xtime_interval << (NTP_SCALE_SHIFT - clock->shift);
> > +		clock->error += tick_length << shift;
> > +		clock->error -= (clock->xtime_interval
> > +				<< (NTP_SCALE_SHIFT - clock->shift))
> > +					<< shift;
> 
> Why not:
> 
> 		clock->error -= clock->xtime_interval
> 				<< (NTP_SCALE_SHIFT - clock->shift + shift);
> 
> ?

Yep. Much cleaner.


> > +		if (shift > 0) /*don't roll under!*/
> > +			shift--;
> 
> (nit: watch out the comment style)

Good point.

> that bit looks a bit messy. We estimated the shift:
> 
> +	while (offset > (clock->cycle_interval << shift))
> +               shift++;
> +	shift--;
> 
> can it really ever roll under in this loop:

It probably can't. I just haven't sat down to work out the full math to
prove it to myself, so I've been cautious. 


Thanks for the suggestions, I'll roll those fixes up into the next
version.


So the basic approach seems ok by you?

thanks
-john



