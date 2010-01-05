Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068Ab0AEX3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab0AEX3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 18:29:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785Ab0AEX3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 18:29:10 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59728 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659Ab0AEX3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 18:29:09 -0500
Date: Tue, 5 Jan 2010 15:29:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
Message-ID: <20100105232905.GN6714@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LFD.2.00.1001042052210.3630@localhost.localdomain> <20100105143046.73938ea2.kamezawa.hiroyu@jp.fujitsu.com> <20100105163939.a3f146fb.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1001050707520.3630@localhost.localdomain> <alpine.LFD.2.00.1001050810380.3630@localhost.localdomain> <87wrzwbh0z.fsf@basil.nowhere.org> <alpine.LFD.2.00.1001050950500.3630@localhost.localdomain> <alpine.DEB.2.00.1001051211000.2246@router.home> <alpine.LFD.2.00.1001051019280.3630@localhost.localdomain> <1262723356.4049.11.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262723356.4049.11.camel@laptop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 09:29:16PM +0100, Peter Zijlstra wrote:
> On Tue, 2010-01-05 at 10:25 -0800, Linus Torvalds wrote:
> > The readers are all hitting the 
> > lock (and you can try to solve the O(n*2) issue with back-off, but quite 
> > frankly, anybody who does that has basically already lost 
> 
> /me sneaks in a reference to local spinning spinlocks just to have them
> mentioned.

Been there, done that.  More than once.  One of them remains in
production use.

The trick is to use a normal spinlock at low levels of contention, and
switch to a more elaborate structure if contention becomes a problem --
if a task spins for too long on the normal spinlock, it set a bit
in the normal spinlock word.  A separate structure allowed tasks to
spin on their own lock word, and also arranged to hand the lock off
to requestors on the same NUMA node as the task releasing the lock in
order to reduce the average cache-miss latency, but also bounding the
resulting unfairness.  It also avoided handing locks off to tasks whose
local spins were interrupted, the idea being that if contention is high,
the probability of being interrupted while spinning is higher than that
of being interrupted while holding the lock (since the time spent spinning
is much greater than the time spent actually holding the lock).

The race conditions were extremely challenging, so, in most cases,
designing for low contention seems -much- more productive.  ;-)

							Thanx, Paul
