Return-Path: <linux-kernel-owner+w=401wt.eu-S1030261AbXAaTMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030261AbXAaTMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 14:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030302AbXAaTMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 14:12:30 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:45296 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030261AbXAaTM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 14:12:29 -0500
Date: Wed, 31 Jan 2007 11:12:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, oleg@tv-sign.ru
Subject: Re: [PATCH 3/7] barrier: a scalable synchonisation barrier
Message-ID: <20070131191215.GK2574@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128120509.719287000@programming.kicks-ass.net> <20070128143941.GA16552@infradead.org> <20070128152435.GC9196@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128152435.GC9196@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28, 2007 at 04:24:35PM +0100, Ingo Molnar wrote:
> 
> * Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Sun, Jan 28, 2007 at 12:51:21PM +0100, Peter Zijlstra wrote:
> > > This barrier thing is constructed so that it will not write in the 
> > > sync() condition (the hot path) when there are no active lock 
> > > sections; thus avoiding cacheline bouncing. -- I'm just not sure how 
> > > this will work out in relation to PI. We might track those in the 
> > > barrier scope and boost those by the max prio of the blockers.
> > 
> > Is this really needed?  We seem to grow new funky locking algorithms 
> > exponentially, while people already have a hard time understanding the 
> > existing ones.
> 
> yes, it's needed.

Would it be possible to come up with something common between this primitive
and the one that Oleg Nesterov put together for Jens Axboe?

	http://lkml.org/lkml/2006/11/29/330

Oleg's approach acquires a lock on the update side, which Peter would
not want in the uncontended case -- but perhaps there is some way to
make Oleg's approach be able to safely test both counters so as to
avoid acquiring the lock if there are no readers.

Oleg, any chance of this working?  I believe it does, but have not
thought it through fully.

If it does turn out that we cannot converge these, I believe that
Peter's implementation needs an smp_mb() at both the beginning
and the end of barrier_sync().  Without the first smp_mb(), the
test in barrier_sync() might precede the prior change, and without
the second smp_mb() the barrier_sync() might slide after the following
cleanup code.  (But I could easily be misunderstanding the code
using barrier_sync().)

							Thanx, Paul
