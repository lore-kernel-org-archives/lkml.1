Return-Path: <linux-kernel-owner+w=401wt.eu-S1757889AbZGHVpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbZGHVpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 17:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbZGHVpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 17:45:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:43909 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761AbZGHVpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 17:45:36 -0400
Subject: Re: [patch] perf_counter: Add p6 PMU
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vince@deater.net>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0907081718450.2715@pianoman.cluster.toy>
References: <Pine.LNX.4.64.0907071559200.30742@pianoman.cluster.toy>
	 <1247051751.9777.49.camel@twins>
	 <Pine.LNX.4.64.0907081718450.2715@pianoman.cluster.toy>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 23:45:29 +0200
Message-Id: <1247089529.16156.27.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 17:46 -0400, Vince Weaver wrote:
> On Wed, 8 Jul 2009, Peter Zijlstra wrote:
> 
> >   doesn't sound like the right kind of event.. but then, it doesn't
> >   have anything better either.
> 
> Is there a way to specify "invalid event"?  Just setting it to 0 doesn't 
> work, on the Pentium Pro event 0 returns what looks like essentially
> random numbers.

Hmm, bugger. I was assuming writing 0 to the evensel would disable the
counter. Apparently that only works for eventsel1, which would mean we
cannot run counter1 without counter0. That means we'd need to do a
counter swap at times... :/

I think we can extend __hw_perf_counter_init() to return failure when
->event_map() returns 0 or something.

> > 
> >  - s/CORE_/P6_/ for the evntsel masks
> 
> thanks, I missed that.
> 
> > -	int err;
> > -	err = checking_wrmsrl(hwc->config_base + idx,
> > +	(void)checking_wrmsrl(hwc->config_base + idx,
> 
> the patches that do the above seem to be unrelated to p6 support.
> Did they get mixed in somehow?

Yeah, random cleanups..

> The patch as it stands will break non-p6 intel perf counters, as Core2 and 
> atom are also cpu family 6.  The attached patch takes the updated version 
> you sent out, and includes a fix to the detection logic.

Ah, thanks!

> Also the current patch gives the following warning:
>  arch/x86/kernel/cpu/perf_counter.c: In function p6_pmu_disable_counter:
>  arch/x86/kernel/cpu/perf_counter.c:925: warning: right shift count >= width of type

#define checking_wrmsrl(msr, val) wrmsr_safe((msr), (u32)(val),         \
                                             (u32)((val) >> 32))

and I passed in a unsigned long, which on ia32 is well 32 bits :-)

> though I don't see where that actually happens, unless some deep macro 
> magic is going on.
> 
> Patch attached below.  This is my first attempt at kernel development in 
> the modern era, so I have no idea how to do the signed off by if multiple 
> people are involved.  Do I just put then all together?

Yeah, that usually works..

Thanks, I'll have a got at it tomorrow.


