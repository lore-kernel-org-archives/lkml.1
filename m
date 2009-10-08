Return-Path: <linux-kernel-owner+w=401wt.eu-S1760081AbZJHXTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081AbZJHXTB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 19:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757298AbZJHXSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 19:18:54 -0400
Received: from ozlabs.org ([203.10.76.45]:59422 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755972AbZJHXSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 19:18:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19150.29486.200292.582241@cargo.ozlabs.ibm.com>
Date: Fri, 9 Oct 2009 10:18:06 +1100
From: Paul Mackerras <paulus@samba.org>
To: eranian@gmail.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, perfmon2-devel@lists.sf.net
Subject: Re: [PATCH 2/2] perf_events: add event constraints support for Intel 
	processors
In-Reply-To: <7c86c4470910070531s8ff0d54xb29c22dd982aa387@mail.gmail.com>
References: <1254840129-6198-1-git-send-email-eranian@gmail.com>
	<1254840129-6198-2-git-send-email-eranian@gmail.com>
	<1254840129-6198-3-git-send-email-eranian@gmail.com>
	<1254846544.21044.298.camel@laptop>
	<7c86c4470910061026o247c182dwdea7fa7296027@mail.gmail.com>
	<1254911461.26976.239.camel@twins>
	<19148.30773.350036.411105@cargo.ozlabs.ibm.com>
	<7c86c4470910070531s8ff0d54xb29c22dd982aa387@mail.gmail.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stephane eranian writes:

> I am not an expert on PPC PMU register constraints but I took a quick look
> at the code and in particular hw_perf_enable() where the action seems to be.
> 
> Given that in kernel/perf_events.c, the PMU specific layer is invoked on a per
> event basis in event_sched_in(), you need to have a way to look at the registers
> you have already assigned. I think this is what PPC does. it stops the PMU and
> re-runs the assignment code. But for that it needs to maintains a
> per-cpu structure
> which has the current event -> counter assignment.

The idea is that when switching contexts, the core code does
hw_perf_disable, then calls hw_perf_group_sched_in for each group that
it wants to have on the PMU, then calls hw_perf_enable.  So what the
powerpc code does is to defer the actual assignment of perf_events to
hardware counters until the hw_perf_enable call.

As each group is added, I do the constraint checking to ensure that
the group can go on, but I don't do the assignment of perf_events to
hardware counters or the computation of PMU control register values.
I have a way of encoding all the constraints into a pair of 64-bit
values for each event such that I can tell very quickly (using only
some quick integer arithmetic) whether it's possible to add a given
event to the set that are on the PMU without violating any
constraints.

There is a bit of extra complexity that comes in because there are
sometimes alternative event codes for the same event.  So as each
event is added to the set to go on the PMU, if the initial constraint
check indicates that it can't go on, I then go and do a search over
the space of alternative codes (for all of the events currently in the
set plus the one I want to add) to see if there's a way to get
everything on using alternative codes for some events.  That sounds
expensive but it turns out not to be because only a few events have
alternative codes, and there are generally only a couple of
alternative codes for those events.

The event codes that I use encode settings for the various
multiplexers plus an indication of what set of counters the event can
be counted on.  If an event can be counted on all or some subset of
counters with the same settings for all the relevant multiplexers,
then I use a single code for it.  If an event can be counted for
example on hardware counter 1 with selector code 0xf0, or hardware
counter 2 with selector code 0x12, then I use two alternative event
codes for that event.

So this all means that I can map an event code into two 64-bit
values -- a value/mask pair.  That mapping is processor-specific, but
the code that checks whether a set of events is feasible is generic.
The idea is that the 64-bit value/mask pair is divided into bitfields,
each of which describes one constraint.  The big comment at the end of
arch/powerpc/include/asm/perf_event.h describes the three different
types of constraints that can be represented and how that works as a
bitfield.  It turns out that this is very powerful and very fast,
since the constraint checking is just a few adds, ands and ors, done
on the whole 64-bit value/mask pairs (there is no need to iterate over
individual bitfields).

I hope this makes it a bit clearer.  Let me know if I need to expand
further.

Paul.
