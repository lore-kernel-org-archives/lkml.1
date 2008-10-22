Return-Path: <linux-kernel-owner+w=401wt.eu-S1756357AbYJVRFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbYJVRFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYJVRFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:05:20 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:48908 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752046AbYJVRFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:05:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtoEAIf3/khMQWQ+/2dsb2JhbACBcsR4g08
Date: Wed, 22 Oct 2008 13:05:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC patch 15/15] LTTng timestamp x86
Message-ID: <20081022170516.GE12650@Krystal>
References: <20081016232729.699004293@polymtl.ca> <20081016234657.837704867@polymtl.ca> <alpine.LFD.2.00.0810161701470.3288@nehalem.linux-foundation.org> <20081017012835.GA30195@Krystal> <57C9024A16AD2D4C97DC78E552063EA3532D455F@orsmsx505.amr.corp.intel.com> <20081017172515.GA9639@goodmis.org> <57C9024A16AD2D4C97DC78E552063EA3533458AC@orsmsx505.amr.corp.intel.com> <20081017184215.GB9874@Krystal> <alpine.LFD.2.00.0810201256350.3518@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810201256350.3518@nehalem.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:52:40 up 139 days, 21:33, 11 users,  load average: 0.89, 0.92,
	0.98
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Fri, 17 Oct 2008, Mathieu Desnoyers wrote:
> > 
> > Hrm, on such systems
> > - *large* amount of cpus
> > - no synchronized TSCs
> > 
> > What would be the best approach to order events ?
> 
> My strong opinion has been - for a longish while now, and independently of 
> any timestamping code - that we should be seriously looking at basically 
> doing essentially a "ntp" inside the kernel to give up the whole idiotic 
> notion of "synchronized TSCs". Yes, TSC's are often synchronized, but even 
> when they are, we might as well _think_ of them as not being so.
> 
> In other words, instead of expecting internal clocks to be synchronized, 
> just make the clock be a clock network of independent TSC domains. The 
> domains could in theory be per-package (assuming TSC is synchronized at 
> that level), but even if we _could_ do that, we'd probably still be better 
> off by simply always doing it per-core. If only because then the reading 
> would be per-core.
> 
> I think it's a mistake for us to maintain a single clock for 
> gettimeofday() (well, "getnstimeofday" and the whole "clocksource_read()" 
> crud to be technically correct). And sure, I bet clocksource_read() can do 
> various per-CPU things and try to do that, but it's complex and pretty 
> generic code, and as far as I know none of the clocksources have even 
> tried. The TSC clocksource read certainly does not (it just does a very 
> similar horrible "at least don't go backwards" crud that the LTTng patch 
> suggested).
> 
> So I think we should make "xtime" be a per-CPU thing, and add support for 
> per-CPU clocksources. And screw that insane "mark_tsc_unstable()" thing.
> 
> And if we did it well, we migth be able to get good timestamps that way 
> too.
> 
> 		Linus

Yep, it looks like a promising area to look into. I think, however, that
it would be good to first experiment with it as a in-kernel time source
rather than as a tracing time source, so we can use a tracer to make
sure it is stable enough. :-)

Also, we have to wonder if it's worth side-stepping tracing developement
on what I consider being a "special-case for buggy hardware". If we let
development on this specific problem at the kernel level go on its own
and decide to use it for tracing when it's judged good enough, we
(tracing people) can focus on the following steps needed to get a tracer
into Linux, namely buffering, event id management, etc. Given I feel the
need for tracing is relatively urgent for the community, I'd recommend
getting a basic, non-perfect timestamping solution in first, and keep
room for improvement.

I prefer to provide tracing for 98% of the machines out there and point
to some documentation telling how to configure the other 1.95% (and feel
sorry for the people how fall in the inevitable 0.05%) than to spend
years trying to come up with a complex scheme aiming precisely at this
1.95%.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
