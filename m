Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbYJTULX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbYJTULX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 16:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbYJTULP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 16:11:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753069AbYJTULO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 16:11:14 -0400
Date: Mon, 20 Oct 2008 13:10:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: "Luck, Tony" <tony.luck@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC patch 15/15] LTTng timestamp x86
In-Reply-To: <20081017184215.GB9874@Krystal>
Message-ID: <alpine.LFD.2.00.0810201256350.3518@nehalem.linux-foundation.org>
References: <20081016232729.699004293@polymtl.ca> <20081016234657.837704867@polymtl.ca> <alpine.LFD.2.00.0810161701470.3288@nehalem.linux-foundation.org> <20081017012835.GA30195@Krystal> <57C9024A16AD2D4C97DC78E552063EA3532D455F@orsmsx505.amr.corp.intel.com>
 <20081017172515.GA9639@goodmis.org> <57C9024A16AD2D4C97DC78E552063EA3533458AC@orsmsx505.amr.corp.intel.com> <20081017184215.GB9874@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Oct 2008, Mathieu Desnoyers wrote:
> 
> Hrm, on such systems
> - *large* amount of cpus
> - no synchronized TSCs
> 
> What would be the best approach to order events ?

My strong opinion has been - for a longish while now, and independently of 
any timestamping code - that we should be seriously looking at basically 
doing essentially a "ntp" inside the kernel to give up the whole idiotic 
notion of "synchronized TSCs". Yes, TSC's are often synchronized, but even 
when they are, we might as well _think_ of them as not being so.

In other words, instead of expecting internal clocks to be synchronized, 
just make the clock be a clock network of independent TSC domains. The 
domains could in theory be per-package (assuming TSC is synchronized at 
that level), but even if we _could_ do that, we'd probably still be better 
off by simply always doing it per-core. If only because then the reading 
would be per-core.

I think it's a mistake for us to maintain a single clock for 
gettimeofday() (well, "getnstimeofday" and the whole "clocksource_read()" 
crud to be technically correct). And sure, I bet clocksource_read() can do 
various per-CPU things and try to do that, but it's complex and pretty 
generic code, and as far as I know none of the clocksources have even 
tried. The TSC clocksource read certainly does not (it just does a very 
similar horrible "at least don't go backwards" crud that the LTTng patch 
suggested).

So I think we should make "xtime" be a per-CPU thing, and add support for 
per-CPU clocksources. And screw that insane "mark_tsc_unstable()" thing.

And if we did it well, we migth be able to get good timestamps that way 
too.

		Linus
