Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757269AbYLPXHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbYLPXHa (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 18:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbYLPXHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 18:07:17 -0500
Received: from ozlabs.org ([203.10.76.45]:46908 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbYLPXHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 18:07:16 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18760.13407.568536.198724@cargo.ozlabs.ibm.com>
Date: Wed, 17 Dec 2008 10:06:07 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephane Eranian <eranian@googlemail.com>,
        Eric Dumazet <dada1@cosmosbay.com>,
        Robert Richter <robert.richter@amd.com>,
        Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
        "David S. Miller" <davem@davemloft.net>,
        perfctr-devel@lists.sourceforge.net
Subject: Re: [patch] Performance Counters for Linux, v4
In-Reply-To: <1229437341.7025.11.camel@twins>
References: <20081214212829.GA9435@elte.hu>
	<18758.18810.350923.806445@cargo.ozlabs.ibm.com>
	<1229437341.7025.11.camel@twins>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> On Mon, 2008-12-15 at 23:11 +1100, Paul Mackerras wrote:
> > I think the core should put together a list of counters and counter
> > groups that it would like to have on the PMU simultaneously and then
> > make one call to the arch layer to ask if that is possible.  That
> > could either return success or failure.  If it returns failure then
> > the core needs to ask for something less, or something different.  I'm
> > not sure how the core should choose what to ask for instead, though.
> 
> I think the constraint set should be applied when we add to a group, if
> when we add a counter to the group, the result isn't schedulable
> anymore, we should fail the group addition - and thereby the counter
> creation.
> 
> This would leave us with groups that are always schedulable in an atomic
> fashion.

I agree that if adding a counter to a group results in that group not
being schedulable any more, we should fail the addition.

> >From what I understand the code RRs groups (co-scheduling groups where
> possible) (ungrouped counter is a group of one), this means that with
> the above addition you'd have the needed control over things.
> 
> If you need things to be atomic, create a single group, if you're fine
> with RR time-sharing, create multiple.

I think we need a "full-time" attribute for counters and groups that
says "I need to be on the whole time", where "whole time" means
whenever the task is running, for a per-task counter or group, or
continuously for per-cpu counters/groups.

With that, the core can check at creation or enable time and return an
error if it can't fit all the full-time counters and groups on, or if
there is any part-time counter/group that would never get to go on
when all the full-time counters/groups are on.  (And I guess creation
or enabling of a part-time counter or group should fail if it would
never be able to go on.)

> This seems to leave a hole where multiple monitors collide and create
> multiple groups unaware of each-other - could we plug this hole with a
> group attribute?

There could be a "whole-PMU" group attribute, that says "I need raw
access to the PMU with no other counters scheduled", which would allow
monitoring programs to use arcane PMU features that the kernel doesn't
necessarily know about.  But I think that's a bit different from what
you're talking about.

The perf counter subsystem will, in Ingo's design, naturally try to
schedule as many counters and groups on as it can.  Given a list of
counters/groups, it could start with the first and keep on trying to
add counters or groups while it can, essentially trying all possible
combinations until it either fills up all the hardware counters or
exhausts the possible combinations.  If it moves all the
counters/groups that do fit on up to the head of the list, and then
rotates them to the back of the list when the timeslice expires, that
would probably be OK.  In fact the computation about what set of
counters/groups to put on should be done when adding/removing a
counter/group and when the timeslice expires, rather than at context
switch time.  (I'm talking about the list of part-time counters/groups
here, of course.)

Paul.
