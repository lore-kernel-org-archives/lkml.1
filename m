Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278Ab0AGQeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab0AGQeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 11:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954Ab0AGQeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 11:34:23 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39246 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab0AGQeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 11:34:22 -0500
Date: Thu, 7 Jan 2010 08:34:18 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
Message-ID: <20100107163418.GA6764@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100104182429.833180340@chello.nl> <20100104182813.753545361@chello.nl> <20100105054536.44bf8002@infradead.org> <alpine.DEB.2.00.1001050916300.1074@router.home> <20100105192243.1d6b2213@infradead.org> <alpine.DEB.2.00.1001071007210.901@router.home> <alpine.LFD.2.00.1001070814080.7821@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001070814080.7821@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 08:19:56AM -0800, Linus Torvalds wrote:
> 
> 
> On Thu, 7 Jan 2010, Christoph Lameter wrote:
> > >
> > > depends on the workload; on a many-threads-java workload, you also get
> > > it for write quite a bit (lots of malloc/frees in userspace in addition
> > > to pagefaults).. at which point you do end up serializing on the
> > > zeroing.
> > >
> > > There's some real life real big workloads that show this pretty badly;
> > > so far the workaround is to have glibc batch up a lot of the free()s..
> > > but that's just pushing it a little further out.
> > 
> > Again mmap_sem is a rwsem and only a read lock is held. Zeroing in
> > do_anonymous_page can occur concurrently on multiple processors in the
> > same address space. The pte lock is intentionally taken *after* zeroing to
> > allow concurrent zeroing to occur.
> 
> You're missing what Arjan said - the jav workload does a lot of memory 
> allocations too, causing mmap/munmap.
> 
> So now some paths are indeed holding it for writing (or need to wait for 
> it to become writable). And the fairness of rwsems quite possibly then 
> impacts throughput a _lot_..
> 
> (Side note: I wonder if we should wake up _all_ readers when we wake up 
> any. Right now, we wake up all readers - but only until we hit a writer. 
> Which is the _fair_ thing to do, but it does mean that we can end up in 
> horrible patterns of alternating readers/writers, when it could be much 
> better to just say "release the hounds" and let all pending readers go 
> after a writer has had its turn).

This can indeed work well in many cases.  The situation where it can
get you in trouble is where there are many more readers than CPUs (or
disk spindles or whatever it is that limits the amount of effective
parallelism readers can attain).  In this case, releasing more readers
than can run in parallel will delay the writers for no good reason.

So one strategy is to release readers, but no more than the number of
CPUs (or whatever the limit is).  More complicated strategies are out
there, but there is a limit to how much of the scheduler one should
involve in lock-granting decisions.

							Thanx, Paul
