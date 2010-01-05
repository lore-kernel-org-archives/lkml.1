Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970Ab0AESzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab0AESzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 13:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191Ab0AESzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 13:55:48 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48264 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab0AESzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 13:55:47 -0500
Date: Tue, 5 Jan 2010 10:55:42 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
Message-ID: <20100105185542.GH6714@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100105134357.4bfb4951.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1001042052210.3630@localhost.localdomain> <20100105143046.73938ea2.kamezawa.hiroyu@jp.fujitsu.com> <20100105163939.a3f146fb.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1001050707520.3630@localhost.localdomain> <alpine.LFD.2.00.1001050810380.3630@localhost.localdomain> <87wrzwbh0z.fsf@basil.nowhere.org> <alpine.LFD.2.00.1001050950500.3630@localhost.localdomain> <alpine.DEB.2.00.1001051211000.2246@router.home> <alpine.LFD.2.00.1001051019280.3630@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001051019280.3630@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 10:25:43AM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 5 Jan 2010, Christoph Lameter wrote:
> > 
> > If the critical section protected by the spinlock is small then the
> > delay will keep the cacheline exclusive until we hit the unlock. This
> > is the case here as far as I can tell.
> 
> I hope somebody can time it. Because I think the idle reads on all the 
> (unsuccessful) spinlocks will kill it.

But on many systems, it does take some time for the idle reads to make
their way to the CPU that just acquired the lock.  My (admittedly dated)
experience is that the CPU acquiring the lock has a few bus clocks
before the cache line containing the lock gets snatched away.

> Think of it this way: under heavy contention, you'll see a lot of people 
> waiting for the spinlocks and one of them succeeds at writing it, reading 
> the line. So you get an O(n^2) bus traffic access pattern. In contrast, 
> with an xadd, you get O(n) behavior - everybody does _one_ acquire-for- 
> write bus access.

xadd (and xchg) certainly are nicer where they apply!

> Remember: the critical section is small, but since you're contending on 
> the spinlock, that doesn't much _help_. The readers are all hitting the 
> lock (and you can try to solve the O(n*2) issue with back-off, but quite 
> frankly, anybody who does that has basically already lost - I'm personally 
> convinced you should never do lock backoff, and instead look at what you 
> did wrong at a higher level instead).

Music to my ears!  ;-)

							Thanx, Paul
