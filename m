Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbYDTDvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbYDTDvg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 23:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbYDTDv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 23:51:26 -0400
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:20811 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751456AbYDTDvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 23:51:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=o9rbfiaf2xsKqS8JjB5EBbhwVKj2SKxIjfkdLHNOHVCaPcG7WoCM6vmmpRuaJYMHREljX1qZ+hLsDAG7JHWQwsZTCwDD75A7bVuJwgWrmk24UihvXWyV3ui65HXP/VVGjpcO+spV8j1xsf7LRaG1/RNk8ehonqwkYSlg/t+ZusE=  ;
X-YMail-OSG: ZfVTbTMVM1k_ipdvYfx5FeFvL_z3RzGuKjACIuimSCjFToFFjAJclYQtCbBG6k789lzgg.vYQLfPR59S_2SgG9DNOxdjy_dzOHpTRw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: david@lang.hm
Subject: Re: [linux-pm] Higer latency with dynamic tick (need for an io-ondemand govenor?)
Date: Sat, 19 Apr 2008 20:51:22 -0700
User-Agent: KMail/1.9.6
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.linux-foundation.org,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
References: <3B6D69C3A9EBCA4BA5DA60D913027429010253CD@dlee13.ent.ti.com> <alpine.LFD.1.10.0804190839140.3261@apollo.tec.linutronix.de> <alpine.DEB.1.10.0804191546430.4670@asgard>
In-Reply-To: <alpine.DEB.1.10.0804191546430.4670@asgard>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804192051.22492.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 April 2008, david@lang.hm wrote:
> On Sat, 19 Apr 2008, Thomas Gleixner wrote:
> 
> > On Fri, 18 Apr 2008, David Brownell wrote:
> >> On Friday 18 April 2008, Woodruff, Richard wrote:
> >>> When capturing some traces with dynamic tick we were noticing the
> >>> interrupt latency seems to go up a good amount. 
> >>
> >>> I was wondering what thoughts of optimizing this might be.
> >>
> >> Cutting down the math implied by jiffies updates might help.

And update_wall_time() costs, too.


> >> The 64 bit math for ktime structs isn't cheap; purely by eyeball,
> >> that was almost 1/3 the cost of that 24 usec (mostly __do_div64).
> >
> > Hmm, I have no real good idea to avoid the div64 in the case of a long
> > idle sleep. Any brilliant patches are welcome :)

That is, in tick_do_update_jiffies64()?

                delta = ktime_sub(delta, tick_period);
                last_jiffies_update = ktime_add(last_jiffies_update,
                                                tick_period);

                /* Slow path for long timeouts */
                if (unlikely(delta.tv64 >= tick_period.tv64)) {
                        s64 incr = ktime_to_ns(tick_period);

                        ticks = ktime_divns(delta, incr);

                        last_jiffies_update = ktime_add_ns(last_jiffies_update,
                                                           incr * ticks);
                }
                do_timer(++ticks);

Some math not shown here is converting clocksource values
to ktimes ... cyc2ns() has a comment about needing some
optimization, I wonder if that's an issue here.

Maybe turning tick_period into an *actual* constant (it's
a function of HZ) would help a bit; "incr" too.

Re the "ticks = ktime_divns(...)":  since "incr" is constant,
the first thing that comes to mind is a binary search over a
precomputed table.

For HZ=100 (common for ARM) a table of size 128 would exceed
the normal range of NO_HZ tick rates ... down to below 1 HZ.


> how long is 'long idle sleep'? and how common are such sleeps?

The above code says "unlikely()" but that presumes very busy
systems.  I would have assumed taking more than one tick was
the most common case, since most systems spend more time idle
than working.  I certainly observe it to be the common case,
and it's a power management optimization goal.


> is it  
> possibly worth the cost of a test in the hotpath to see if you need to do 
> the 64 bit math or can get away with 32 bit math (at least on some 
> platforms)

Possibly opening a can of worms, I'll observe that when the
concern is just to update jiffies, converting to ktime values
seems all but needless.  Deltas at the level of a clocksource
can be mapped to jiffies as easily as deltas at the nsec level,
saving some work...

Those delta tables could use just 32 bit values in the most
common cases:  clocksource ticking at less than 4 GHz, and
the IRQs firing more often than once a second. 

- Dave
