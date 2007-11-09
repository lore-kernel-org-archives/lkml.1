Return-Path: <linux-kernel-owner+w=401wt.eu-S1756972AbXKISrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbXKISrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 13:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbXKISrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 13:47:13 -0500
Received: from www.tglx.de ([62.245.132.106]:49415 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166AbXKISrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 13:47:11 -0500
Date: Fri, 9 Nov 2007 19:40:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: eranian@hpl.hp.com, perfmon2-devel@lists.sourceforge.net,
       perfmon@napali.hpl.hp.com, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: conflict between tickless and perfmon2
In-Reply-To: <1194605991.6289.162.camel@twins>
Message-ID: <alpine.LRH.0.999.0711091934210.1196@www.tglx.de>
References: <20071109104438.GB18909@frankl.hpl.hp.com>
 <1194605991.6289.162.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2007, Peter Zijlstra wrote:

> On Fri, 2007-11-09 at 02:44 -0800, Stephane Eranian wrote:
> > Hello,
> > 
> > We have identified a conflict between TICKLESS (CONFIG_NO_HZ) and
> > the current perfmon2 implementation. The problem impacts system-wide
> > sessions using timeout-based event set multiplexing.
> > 
> > Event set multiplexing allows monitoring tools to measure more events
> > than there are actual performance counters on the processor. Events
> > are grouped in sets which are then multiplexed onto the actual counters.
> > Switching can be triggered either by a timeout or by a counter overflow.
> > This is supported for per-thread and system-wide sessions.
> > 
> > For timeout-based switching, the duration expressed in nanoseconds is
> > meant to represent wall-clock time in system-wide mode, and execution
> > time in per-thread mode. Granularity is limited by HZ.
> > 
> > The current implementation for timeout is a simple hook on the timer
> > interrupt path in apic_*.c:smp_local_timer_interrupt(). Unfortunately,
> > this does not work when tickless is enabled: we get much less set
> > switches than expected on an idle system.

What a surprise. :)

> > It looks like a solution would be to change the implementation of
> > timeout-based switching to use HR timers instead. Similar to what is
> > done for ITIMER_REAL and ITIMER_VIRTUAL.

Using a hrtimer is perfrectly fine, I'd say it's preferred over hooks in 
some code which has absoluty no guarantee of being executed periodically 
or even executed at all. OTOH it seems rather stupid to measure stuff 
while the system is idle and doing nothing.

	tglx

