Return-Path: <linux-kernel-owner+w=401wt.eu-S1758143AbZFXNPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143AbZFXNPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 09:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZFXNPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 09:15:42 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:53691 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbZFXNPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 09:15:41 -0400
Date: Wed, 24 Jun 2009 22:14:40 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: register_timer_hook use in arch/sh/oprofile
Message-ID: <20090624131440.GA9700@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ingo Molnar <mingo@elte.hu>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20090624131104.705c828d@skybase> <20090624112929.GB2079@linux-sh.org> <20090624142828.7c6a2337@skybase> <20090624123416.GB9510@linux-sh.org> <20090624124542.GB32306@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624124542.GB32306@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 02:45:42PM +0200, Ingo Molnar wrote:
> 
> * Paul Mundt <lethal@linux-sh.org> wrote:
> 
> > My current plan is to migrate things over to the perf_counter API 
> > and annoy Ingo with my interrupt deprived counters ;-)
> 
> Please do :-)
> 
> I just wrote a longer explanation about them: i think they can be 
> made full-blown hardware counters, which in the end would be 
> basically just as capable as 'real' IRQ capable counters.
> 
Thanks for the hints, now that all of my -rc1 stuff is out of the way,
I've got some spare cycles to start working on the hardware counters.

The lack of design awareness for these sorts of use cases has been one of
the biggest hassles of trying to deal with oprofile and the various
incarnations of perfmon and so on in the past, but perf_counter certainly
looks like a good way forward here.

> The main complication that such counters bring is that in their 'own 
> metric' they do interrupt periods in an 'irregular' way (because 
> they interrupt in the nanosec metric - being hrtimers) - but both 
> the tools can deal with uneven periods just fine and the auto-freq 
> code can auto-balance based on this just fine too.
> 
How we have mostly handled these counters in the past have been for
long-term workload analysis. A given user wants to measure certain events
across the lifetime of their workload to get an idea of where the hot
spots are, and then send us numbers later. 64-bit hardware counters give
them quite a bit of time to accumulate results, and in these cases
precision is not so important as continuous non-interactive monitoring.

On the other hand trying to beat these sorts of counters in to a
framework where they can leverage existing userspace tools has never
really worked as well as it could have, and this too is something that
perf_counter seems well suited to accomodate.

I knew quite a few other architectures that also have similar counters,
so having these tie in cleanly in a generic way will make these a lot
more useful, especially since in the past people have either just thrown
them at sysfs or just ignored them completely.

> So you should be able to implement this within arch/sh/ with 
> existing perf_counter facilities and hrtimers, or you can help us 
> librarize it in kernel/perf_counter.c some more, to minimize 
> architecture code.
> 
Architecturally we have two fairly different counter types that follow a
similar design, so they will need separate drivers regardless. I don't
have much interest in hiding generic stuff in arch/sh/, especially given
that we aren't the only ones with these types of counters, so I'll
certainly hack on kernel/perf_counter.c as necessary to get things moving
along. I expect between the two types of SH counters we have to handle
there will already be quite a bit of variation.

> [ Of course, given that you are the first architecture to do this,
>   you would be fair to expect some unexpected details along the way 
>   as well ;-) ]
> 
That tends to be the way things go more often than not. In any event,
it's certainly worth spending time on getting right, and I would rather
spend my time being the guinea pig for evolving in-tree code than not
having the counters be useful at all. ;-)
