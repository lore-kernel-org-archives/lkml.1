Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbXJIUja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbXJIUja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 16:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbXJIUjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 16:39:22 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:43325 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbXJIUjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 16:39:21 -0400
Date: Tue, 9 Oct 2007 13:39:36 -0700
From: mike kravetz <kravetz@us.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, pmorreale@novell.com,
       sdietrich@novell.com
Subject: Re: [RFC PATCH RT] push waiting rt tasks to cpus with lower prios.
Message-ID: <20071009203936.GB23388@monkey.ibm.com>
References: <20071009142044.4941.65189.stgit@novell1.haskins.net> <Pine.LNX.4.58.0710091054430.21404@gandalf.stny.rr.com> <1191944024.4281.72.camel@ghaskins-t60p.haskins.net> <1191952777.23198.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191952777.23198.8.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 01:59:37PM -0400, Steven Rostedt wrote:
> This has been complied tested (and no more ;-)
> 
> The idea here is when we find a situation that we just scheduled in an
> RT task and we either pushed a lesser RT task away or more than one RT
> task was scheduled on this CPU before scheduling occurred.
> 
> The answer that this patch does is to do a O(n) search of CPUs for the
> CPU with the lowest prio task running. When that CPU is found the next
> highest RT task is pushed to that CPU.
> 
> Some notes:
> 
> 1) no lock is taken while looking for the lowest priority CPU. When one
> is found, only that CPU's lock is taken and after that a check is made
> to see if it is still a candidate to push the RT task over. If not, we
> try the search again, for a max of 3 tries.

I did something like this a while ago for another scheduling project.
A couple 'possible' optimizations to think about are:
1) Only scan the remote runqueues once and keep a local copy of the
   remote priorities for subsequent 'scans'.  Accessing the remote
   runqueus (CPU specific cache lines) can be expensive.
2) When verifying priorities, just perform spin_trylock() on the remote
   runqueue.  If you can immediately get it great.  If not, it implies
   someone else is messing with the runqueue and there is a good chance
   the data you pre-fetched (curr->Priority) is invalid.  In this case
   it might be faster to just 'move on' to the next candidate runqueue/CPU.
   i.e. The next highest priority that the new task can preempt.

Of course, these 'optimizations' would change the algorithm.  Trying to
make any decision based on data that is changing is always a crap shoot. :)
-- 
Mike
