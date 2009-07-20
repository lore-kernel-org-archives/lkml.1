Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbZGTNb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbZGTNb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 09:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbZGTNb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 09:31:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:41955 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbZGTNb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 09:31:27 -0400
Date: Mon, 20 Jul 2009 06:33:05 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@tglx.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       nikolag@ca.ibm.com, Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [RFC][PATCH] Introduce CLOCK_REALTIME_COARSE
Message-ID: <20090720063305.2ad49d40@infradead.org>
In-Reply-To: <1248088622.15751.8465.camel@twins>
References: <1247873945.8334.67.camel@localhost.localdomain>
	<alpine.LFD.2.00.0907181027510.11571@localhost.localdomain>
	<1247954978.14494.19.camel@work-vm>
	<20090718153011.1de3af8e@infradead.org>
	<1248088622.15751.8465.camel@twins>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jul 2009 13:17:02 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Sat, 2009-07-18 at 15:30 -0700, Arjan van de Ven wrote:
> > On Sat, 18 Jul 2009 15:09:38 -0700
> > john stultz <johnstul@us.ibm.com> wrote:
> > 
> > > After talking with some application writers who want very fast,
> > > but not fine-grained timestamps, I decided to try to implement a
> > > new clock_ids to clock_gettime(): CLOCK_REALTIME_COARSE and
> > > CLOCK_MONOTONIC_COARSE which returns the time at the last tick.
> > > This is very fast as we don't have to access any hardware (which
> > > can be very painful if you're using something like the acpi_pm
> > > clocksource), and we can even use the vdso clock_gettime() method
> > > to avoid the syscall. The only trade off is you only get low-res
> > > tick grained time resolution.
> > 
> > Does this tie us to having a tick? I still have hope that we can get
> > rid of the tick even when apps are running .... since with CFS we
> > don't really need the tick for the scheduler anymore for example....
> 
> On the hardware side to make this happen we'd need a platform that
> has:
> 
>   - cheap, high-res, cross-cpu synced, clocksource
>   - cheap, high-res, clockevents
> 
> Maybe power64, sparc64 and s390x qualify, but certainly nothing on x86
> does.

the x86 on my desk disagrees.
 
> Furthermore, on the software side we'd need a few modifications, such
> as doing lazy accounting for things like u/s-time which currently
> rely on the tick and moving the load-balancing into a hrtimer.

I thought the load balancer no longer runs as a timer.. but I could
well be wrong.

> Also, even with the above done, we'd probably want to tinker with the
> clockevent/hrtimer code and possibly use a second per-cpu hardware
> timer for the scheduler, since doing the whole hrtimer rb-tree dance
> for every context switch is simply way too expensive.
> 
> But even with all that manged, there's still other bits that rely on
> the tick -- RCU being one of the more interesting ones.

we need to at least keep our options open to go there, since even the
early measurements (iirc from Andrea 5 years ago) of the 1 KHz time show
that it has a real performance impact, as much as 1%. While we may not
need to switch over RIGHT NOW, adding more dependencies on this timer
is just not a good idea...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
