Return-Path: <linux-kernel-owner+w=401wt.eu-S1761672AbXHWLrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761672AbXHWLrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 07:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760308AbXHWLrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 07:47:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38721 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbXHWLrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 07:47:20 -0400
Subject: Re: gettimeofday() jumping into the future
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Smith <msmith@xiph.org>
Cc: linux-kernel@vger.kernel.org, Andy Wingo <wingo@fluendo.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>
In-Reply-To: <3c1737210708230408i7a8049a9m5db49e6c4d89ab62@mail.gmail.com>
References: <3c1737210708230408i7a8049a9m5db49e6c4d89ab62@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 23 Aug 2007 13:47:12 +0200
Message-Id: <1187869632.6114.368.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ CCs added ]

On Thu, 2007-08-23 at 13:08 +0200, Michael Smith wrote:
> Hi,
> 
> We've been seeing some strange behaviour on some of our applications
> recently. I've tracked this down to gettimeofday() returning spurious
> values occasionally.
> 
> Specifically, gettimeofday() will suddenly, for a single call, return
> a value about 4398 seconds (~1 hour 13 minutes) in the future. The
> following call goes back to a normal value.
> 
> This seems to be occurring when the clock source goes slightly
> backwards for a single call. In
> kernel/time/timekeeping.c:__get_nsec_offset(), we have this:
>  cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> 
> So a small decrease in time here will (this is all unsigned
> arithmetic) give us a very large cycle_delta. cyc2ns() then multiplies
> this by some value, then right shifts by 22. The resulting value (in
> nanoseconds) is approximately 4398 seconds; this gets added on to the
> xtime value, giving us our jump into the future. The next call to
> gettimeofday() returns to normal as we don't have this huge nanosecond
> offset.
> 
> This system is a 2-socket core 2 quad machine (8 cpus), running 32 bit
> mode. It's a dell poweredge 1950. The kernel selects the TSC as the
> clock source, having determined that the tsc runs synchronously on
> this system. Switching the systems to use a different time source
> seems to make the problem go away (which is fine for us, but we'd like
> to get this fixed properly upstream).
> 
> We've also seen this behaviour with a synthetic test program (which
> just runs 4 threads all calling gettimeofday() in a loop as fast as
> possible and testing that it doesn't jump) on an older machine, a dell
> poweredge SC1425 with two p4 hyperthreaded xeons.
> 
> Can anyone advise on what's going wrong here? I can't find much in the
> way of documentation on whether the TSC is guaranteed to be
> monotonically increasing on intel systems. Should the code choose not
> to use the TSC? Or should the TSC reading code ensure that the
> returned values are monotonic?
> 
> Is there any more information that would be useful? I'll be on a plane
> for most of tomorrow, so might be a little slow responding.

The exact version of the kernel you're using might be good thing to
start with :-)


