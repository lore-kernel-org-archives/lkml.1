Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373Ab0BNLdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 06:33:22 -0500
Received: from ozlabs.org ([203.10.76.45]:32807 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893Ab0BNLdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 06:33:21 -0500
Date: Sun, 14 Feb 2010 22:33:14 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, Dave Wootton <dwootton@us.ibm.com>
Subject: Re: Why is PERF_FORMAT_GROUP incompatible with inherited events?
Message-ID: <20100214113314.GG13769@brick.ozlabs.ibm.com>
References: <20100212030205.GE13769@brick.ozlabs.ibm.com>
 <1266142337.5273.417.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266142337.5273.417.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 11:12:17AM +0100, Peter Zijlstra wrote:
> On Fri, 2010-02-12 at 14:02 +1100, Paul Mackerras wrote:
> > We currently have this code in perf_event_alloc() in kernel/perf_event.c:
> > 
> > 	/*
> > 	 * we currently do not support PERF_FORMAT_GROUP on inherited events
> > 	 */
> > 	if (attr->inherit && (attr->read_format & PERF_FORMAT_GROUP))
> > 		goto done;
> > 
> > plus there is a comment "XXX PERF_FORMAT_GROUP vs inherited events
> > seems difficult" next to perf_output_read_group() (but there isn't a
> > similar comment on perf_read_hw()).
> > 
> > First, what is the difficulty referred to here?
> 
> IIRC its the fact that we have to go collect the count delta from all
> the child counters, which can be quite a lot of work depending on the
> number of cpus and children around.

But we don't go and collect the count delta from children without
PERF_FORMAT_GROUP, so why would we with it?

There are two situations where PERF_FORMAT_GROUP makes a difference:
with PERF_SAMPLE_READ when storing a sample in the ring buffer, and
when you do a read() system call on a perf_event fd.  In both
situations, if the counter is inherited, we don't go collecting up
child counts, we just store the value of the counter that overflowed
in the sampling case, or the value of the top-level counter in the
read() case.

Now, I can see a possible difficulty in the sampling case if you have
a group that has some inherited members and some non-inherited
members.  In that case if you get an overflow on a child counter, the
group it's in will have fewer members that the group that the
top-level counter is part of, which could get confusing.  But there is
no such problem for read() since it is always returning the value of
the top-level counter.

> > Secondly, if the difficulty is just to do with the intersection of
> > sampling counters, inheritance, and group readout (as seems to be the
> > case), could we please allow group readout on ordinary counting
> > (non-sampling) counters?  That is, change the test above to something
> > like:
> > 
> > 	if (attr->inherit && attr->sample_period &&
> > 	    (attr->read_format & PERF_FORMAT_GROUP))
> > 		goto done;
> > 
> > Any objections to that change?  If it's OK, could we get it into .33
> > and .32-stable?
> 
> Yeah, that's still broken, you can't do a read without collecting all
> the child counts.

We do a read without collecting all the child counts if
PERF_FORMAT_GROUP is not set -- why would that be any different when
PERF_FORMAT_GROUP is set?  PERF_FORMAT_GROUP is about the "horizontal"
dimension (across group members) not the "vertical" dimension (down to
all the child counters).

Paul.
