Return-Path: <linux-kernel-owner+w=401wt.eu-S1759738AbYBNLMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738AbYBNLMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 06:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbYBNLMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 06:12:35 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51051 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751868AbYBNLMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 06:12:34 -0500
Date: Thu, 14 Feb 2008 05:12:25 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: Lee.Schermerhorn@hp.com, akpm@linux-foundation.org, clameter@sgi.com,
       ak@suse.de, linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
Message-Id: <20080214051225.f2b70814.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802131314210.5914@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
	<1202862136.4974.41.camel@localhost>
	<20080212215242.0342fa25.pj@sgi.com>
	<alpine.DEB.1.00.0802121955040.11889@chino.kir.corp.google.com>
	<20080212221354.a33799f2.pj@sgi.com>
	<alpine.DEB.1.00.0802122018550.11889@chino.kir.corp.google.com>
	<20080213020344.45c9d924.pj@sgi.com>
	<alpine.DEB.1.00.0802130113020.3936@chino.kir.corp.google.com>
	<20080213110426.15179378.pj@sgi.com>
	<alpine.DEB.1.00.0802131050240.9186@chino.kir.corp.google.com>
	<20080213142956.5ba52101.pj@sgi.com>
	<alpine.DEB.1.00.0802131314210.5914@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> So let's say, like my first example from the previous email, that you have 
> MPOL_INTERLEAVE | MPOL_F_RELATIVE_NODES over nodes 3-4 and your cpuset's 
> mems is only nodes 5-7.  This would interleave over no nodes.  Correct?

Given what I said yesterday, that would be a correct conclusion.

However, as I just posted, what I said yesterday was wrong.

Using the same table format as I used in what I just posted, we see that
the two nodes 5 and 6 would be included in the interleave.  Each requested
node gets folded modulo the size (weight) of the current mems_allowed,
into some actual node to be included in the interleave.

  Given
	N: how many nodes are allowed by the tasks cpuset (3, here [5,6,7])

	   n		m := (n % N)	r := m-th set node in allowed
	requested	  mod 3		result (in set 5,6,7 allowed)
	   3		    0			5
	   4		    1			6

> it just cares about the order.

MPOL_F_RELATIVE_NODES is for use by jobs consisting of multiple compute
threads which care about how many CPUs they run on, how many memory nodes
they have, and which nodes are closest to which CPUs.  In the typical case
all CPUs are equivalent, and all memory nodes are equivalent, except for
the basic topology issues of which nodes are near which CPUs, and in the
bigger NUMA systems (the less uniform NUMA systems, I should say), whether
all these CPUs and nodes are "close to" each other in the larger system.

> I don't understand the use case for this

The use case is the original motivating use case for cpusets, and for
my customer audience still one of the largest use cases of interest.

They are running N-way tightly coupled parallel threads, with sometimes
extreme sensitivity to data placement.  The job may run for hours, even
days, with exactly N threads, on exactly N CPUs, carefully placing each
data page on the memory node nearest the CPU that will access it most
frequently.  They may be using OpenMP, synchronizing many times per
second across many hundreds of threads.  If -any- of the threads takes
a few per-cent longer due to poor page placement, the entire job slows
as much.  If various threads, at uncorrelated times, each slow a few
per-cent, then the entire job can take twice as long.  When you're
computing tomorrows weather forecast, getting the result the day after
tomorrow is rather useless.

Now, if the job is critical enough, the customer simply won't interfere
with it or move it to other CPUs or any of that nonsense.  But when
running a mix of such jobs, under a batch scheduler such as PBS or LSF,
where the jobs have varying priority and varying resource needs, then
the batch scheduler will, intentionally, move less critical jobs about,
sometimes suspending them entirely, in order to provide the more
critical jobs with exactly what they need, while keeping the
utilization of the rest of the system as high as possible.

> It comes 
> with the premise that the task doesn't already know it's cpuset mems 
> (otherwise, the current implementation without MPOL_F_STATIC_NODES would 
> work fine for this)

No.

The current "classical" implementation doesn't work adequately.

I think I've already explained this before, so will just copy my
previous explanation here.  Perhaps you missed it the first time,
or perhaps something in it isn't clear enough.

=========
    This second, cpuset relative, mode is required:

    1) to provide a race-free means for an application to place its memory
       when the application considers all physical nodes essentially
       equivalent, and just wants to lay things out relative to whatever
       cpuset it happens to be running in, and

    2) to provide a practical means, without the need for constantly
       reprobing ones current cpuset placement, for an application to
       specify cpuset-relative placement to be applied whenever the
       application is placed in a larger cpuset, even if the application
       is presently in a smaller cpuset.

    Without it, the application has to first query its current physical
    cpuset placement, then calculate its desired relative placement into
    terms of the current physical nodes it finds itself on, and then issue
    various mbind or set_mempolicy calls using those current physical node
    numbers, praying that it wasn't migrated to other physical nodes at the
    same time, which would have invalidated its current placement
    assumptions in its relative to physical node number calculations.

    And without it, if an application is currently placed in a smaller cpuset
    than it would prefer, it cannot specify how it would want its mempolicies
    should it ever subsequently be moved to a larger cpuset.  This leaves such
    an application with little option other than to constantly reprobe its
    cpuset placement, in order to know if and when it needs to reissue its
    mbind and set_mempolicy calls because it gained access to a larger cpuset.
=========

We would have similar problems with remapping sched_setaffinity policies
as we do with mempolicies, except that sched_setaffinity can be applied
by one task on another.  So the batch schedulers can and do fix up the
scheduler policies of migrated tasks behind their back.  They cannot
do so for memory policies, because mbind and set_mempolicy can only be
issued on a task by itself.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
