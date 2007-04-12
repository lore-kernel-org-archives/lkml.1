Return-Path: <linux-kernel-owner+w=401wt.eu-S1030790AbXDLWAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030790AbXDLWAB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 18:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030792AbXDLWAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 18:00:01 -0400
Received: from holomorphy.com ([66.93.40.71]:60926 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030790AbXDLWAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 18:00:00 -0400
Date: Thu, 12 Apr 2007 15:00:15 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Buytaert_Steven@emc.com, andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: sched_yield proposals/rationale
Message-ID: <20070412220015.GG2986@holomorphy.com>
References: <585DC2133F7C974F87D4EC432896F1720309F1EA@CORPUSMX10A.corp.emc.com> <p737ish90ss.fsf@bingen.suse.de> <585DC2133F7C974F87D4EC432896F1720309F3DB@CORPUSMX10A.corp.emc.com> <461E33BA.2030104@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461E33BA.2030104@yahoo.com.au>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 11:27:22PM +1000, Nick Piggin wrote:
> This one should be pretty rare (actually I think it is dead code in 
> practice, due to the way the page allocator works).
> Avoiding sched_yield is a really good idea outside realtime scheduling. 
> Since we have gone this far with the current semantics, I think it
> would be sad to back down now.
> It would be nice if you could pressure those other components to adapt :)

Outside of realtime scheduling there appear to be two desired behaviors:
(1) busywait: demote as aggressively as possible
(2) CPU burn: give other apps a chance to run but demote lightly at most

There is no way for the scheduler to distinguish which of the two
behaviors is desired. A fresh system call taking an argument to describe
which is the desired behavior is my recommended solution. Most unaware
apps should be able to be dealt with via LD_PRELOAD.

Busywaiters able to be modified could be given more specific scheduling
primitives, in particular "directed yields," which donate timeslice and
possibly dynamic priority to their targets. They would look something
like:
	int yield_to(pid_t);
	int yield_to_futex(int *);
	int yield_to_sem(int);
	/* etc. */
as userspace library functions where yielding to a resource is intended
to donate timeslice to its owner or one of its owners, where those
owner(s) are to be determined by the kernel. Directed yields are a more
direct attack on the priority inversion one most desperately wants to
avoid in the case of sched_yield() -based busywaiters on a resource,
namely the resource owner falling behind the busywaiters in priority or
running out of timeslice. They furthermore reduce the competition for
CPU between resource owners and busywaiters on that resource.

A less direct alternative suggested by Andi Kleen is to have coprocess
groups and an alternative to sched_yield() that directs yielding toward
a member of the same coprocess group as the yielder, possibly using the
standard system call by making that the default behavior when a process
is a member of such a coprocess group.


-- wli
