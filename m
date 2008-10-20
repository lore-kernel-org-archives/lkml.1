Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbYJTWHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbYJTWHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 18:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYJTWHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 18:07:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751650AbYJTWHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 18:07:14 -0400
Date: Mon, 20 Oct 2008 15:06:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: john stultz <johnstul@us.ibm.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Luck, Tony" <tony.luck@intel.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC patch 15/15] LTTng timestamp x86
In-Reply-To: <1f1b08da0810201438g6a109af5i75b34841462b655d@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0810201451190.3287@nehalem.linux-foundation.org>
References: <20081016232729.699004293@polymtl.ca>  <20081016234657.837704867@polymtl.ca>  <alpine.LFD.2.00.0810161701470.3288@nehalem.linux-foundation.org>  <20081017012835.GA30195@Krystal>  <57C9024A16AD2D4C97DC78E552063EA3532D455F@orsmsx505.amr.corp.intel.com>
  <20081017172515.GA9639@goodmis.org>  <57C9024A16AD2D4C97DC78E552063EA3533458AC@orsmsx505.amr.corp.intel.com>  <20081017184215.GB9874@Krystal>  <alpine.LFD.2.00.0810201256350.3518@nehalem.linux-foundation.org>
 <1f1b08da0810201438g6a109af5i75b34841462b655d@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Oct 2008, john stultz wrote:
> 
> I'm not quite sure I followed your per-cpu xtime thoughts.  Could you
> explain further your thinking as to why the entire timekeeping
> subsystem should be per-cpu instead of just keeping that back in the
> arch-specific clocksource implementation?  In other words, why keep
> things synced at the nanosecond level instead of keeping the per-cpu
> TSC synched at the cycle level?

I don't think you can kep them sync'ed without taking frequency drift into 
account. When you have multiple boards (ie big boxes), they simply _will_ 
be in different clock domains. They won't have the exact same frequency.

So the "rewrite the TSC every once in a while" approach (where "after 
coming out of idle" is just a special case of "once in a while" due to 
many CPU's losing TSC in idle) works well in the kind of situation where 
you really only have a single clock domain, and the TSC's are all 
basically from the same reference clock. And that's a common case, but it 
certainly isn't the _only_ case.

What about fundamnetally different frequencies (old TSC's that change with 
cpufreq)? Or what about just subtle different ones (new TSC's but on 
separate sockets that use separate external clocks)?

But sure, I can imagine using a global xtime, but just local TSC offsets 
and frequencies, and just generating a local offset from xtime. BUT HOW DO 
YOU EXPECT TO DO THAT?

Right now, the global xtime offset thing also depends on the fact that we 
have a single global TSC offset! That whole "delta against xtime" logic 
depends very much on this:

	/* calculate the delta since the last update_wall_time: */
	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;

and that base-time setting depends on a _global_ clock source. Why? 
Because it depends on setting that in sync with updating xtime.

And maybe I'm missing something. But I do not believe that it's easy to 
just make the TSC be per-CPU. You need per-cpu correction factors, but you 
_also_ need a per-CPU time base.

Oh, I'm sure you can do hacky things, and work around known issues, and 
consider the TSC to be globally stable in a lot of common schenarios. 
That's what you get by re-syncing after idle etc. And it's going to work 
in a lot of situations.

But it's not going to solve the "hey, I have 512 CPU's, they are all on 
different boards, and no, they are _not_ synchronized to one global 
clock!".

That's why I'd suggest making _purely_ local time, and then aiming for 
something NTP-like. But maybe there are better solutions out there.

			Linus
