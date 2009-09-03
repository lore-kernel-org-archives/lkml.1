Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbZICHpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbZICHpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 03:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbZICHpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 03:45:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:47311 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbZICHpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 03:45:08 -0400
Date: Thu, 3 Sep 2009 09:45:10 +0200
From: Nick Piggin <npiggin@suse.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: tree rcu: call_rcu scalability problem?
Message-ID: <20090903074510.GE979@wotan.suse.de>
References: <20090902094835.GB12251@wotan.suse.de> <20090902122756.GC12251@wotan.suse.de> <1251919064.10394.25.camel@laptop> <20090903051427.GD7138@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090903051427.GD7138@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 10:14:27PM -0700, Paul E. McKenney wrote:
> On Wed, Sep 02, 2009 at 09:17:44PM +0200, Peter Zijlstra wrote:
> > On Wed, 2009-09-02 at 14:27 +0200, Nick Piggin wrote:
> > 
> > > It seems like nearly 2/3 of the cost is here:
> > >         /* Add the callback to our list. */
> > >         *rdp->nxttail[RCU_NEXT_TAIL] = head; <<<
> > >         rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
> > > 
> > > In loading the pointer to the next tail pointer. If I'm reading the profile
> > > correctly. Can't see why that should be a probem though...
> > > 
> > > ffffffff8107dee0 <__call_rcu>: /* __call_rcu total: 320971 100.000 */
> > >    697  0.2172 :ffffffff8107dee0:       push   %r12
> > 
> > >    921  0.2869 :ffffffff8107df57:       push   %rdx
> > >    151  0.0470 :ffffffff8107df58:       popfq
> > > 183507 57.1725 :ffffffff8107df59:       mov    0x50(%rbx),%rax
> > >    995  0.3100 :ffffffff8107df5d:       mov    %rdi,(%rax)
> > 
> > I'd guess at popfq to be the expensive op here.. skid usually causes the
> > attribution to be a few ops down the line.
> 
> I believe that Nick's workload is routinely driving the number of
> callbacks queued on a given CPU above 10,000, which would provoke numerous
> (and possibly inlined) calls to force_quiescent_state().  Like about
> 400,000 such calls per second.  Hey, I was naively assuming that no one
> would see more than 10,000 callbacks queued on a single CPU unless there
> was some sort of major emergency underway, and coded accordingly.  ;-)
> 
> I offer the attached experimental (untested, might not even compile) patch.

Not only does it compile, but __call_rcu is now taking 1/10th the
cycles and absolute performance up nearly 20%. Looks like it is
now better than classic RCU.

I'll collect and post some more detailed numbers and profiles. Do
you want some new rcu trace results too?

Thanks,
Nick
