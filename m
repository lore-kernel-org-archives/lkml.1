Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbZLAOkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbZLAOkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 09:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZLAOkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 09:40:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46194 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbZLAOkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 09:40:42 -0500
Subject: Re: Perf events/ARM
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jamie Iles <jamie@jamieiles.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091201143105.GB1183@elte.hu>
References: <20091201120439.GB4061@wear.picochip.com>
	 <20091201143105.GB1183@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Dec 2009 15:40:44 +0100
Message-ID: <1259678444.1697.487.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-01 at 15:31 +0100, Ingo Molnar wrote:
> * Jamie Iles <jamie@jamieiles.com> wrote:
> 
> > Hi,
> > 
> > I'm looking at adding support for the hardware performance counters in ARMv6
> > using the new perf events framework. I have a simple setup that uses the
> > counters on their own, but wrt the perf events framework:
> > 
> > 	- what are the requirements of set_perf_event_pending() and
> > 	perf_event_do_pending()? As far as I can tell from sparc/x86/powerpc,
> > 	set_perf_event_pending() triggers an interrupt that then calls
> > 	perf_event_do_pending(). Does perf_event_do_pending need to run in
> > 	interrupt context or could I use a soft IRQ if platforms don't have a
> > 	spare IRQ?
> 
> softirq would be fine too i suspect - but then you need to increase the 
> buffering of perf_pending_head, as multiple hardirqs could hit before 
> the softirq processing has finished.
> 
> As that gets complex quick, an acceptable first-order approach would be 
> to just ignore those lost events and run it from a softirq - i _think_ 
> everything should be OK.

Things like wakeups and ->event_limit might get delayed.

Delayed wakeups can be mitigated by larger buffers, delayed disable on
->event_limit is not something you can fix up.

Does your PMU generate regular interrupts or actual NMIs? If its normal
interrupts you can simply call perf_event_do_pending() at the
pmu-interrupt tail.

x86 does a self-ipi to get from NMI context into IRQ context as fast as
possible, simply because you cannot do very much from NMI context.

> > 	- ARM does not have proper support for atomic64's. Other than
> > 	performance, would there be any known problems with using the generic
> > 	spinlocked atomic64's?
> 
> Not a problem at all. Even performance-wise they are pretty nice - Paul 
> has done a nice job hashing it along 16 spinlocks - so for small SMP 
> systems there should be no global cacheline bounce.

Depends, again if your PMU generates NMIs a spinlock'ed version won't
work.

