Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbZICHOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbZICHOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 03:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbZICHOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 03:14:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:46690 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574AbZICHOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 03:14:15 -0400
Date: Thu, 3 Sep 2009 09:14:16 +0200
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul McKenney <paulmck@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: tree rcu: call_rcu scalability problem?
Message-ID: <20090903071416.GB979@wotan.suse.de>
References: <20090902094835.GB12251@wotan.suse.de> <20090902122756.GC12251@wotan.suse.de> <1251919064.10394.25.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251919064.10394.25.camel@laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 09:17:44PM +0200, Peter Zijlstra wrote:
> On Wed, 2009-09-02 at 14:27 +0200, Nick Piggin wrote:
> 
> > It seems like nearly 2/3 of the cost is here:
> >         /* Add the callback to our list. */
> >         *rdp->nxttail[RCU_NEXT_TAIL] = head; <<<
> >         rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
> > 
> > In loading the pointer to the next tail pointer. If I'm reading the profile
> > correctly. Can't see why that should be a probem though...
> > 
> > ffffffff8107dee0 <__call_rcu>: /* __call_rcu total: 320971 100.000 */
> >    697  0.2172 :ffffffff8107dee0:       push   %r12
> 
> >    921  0.2869 :ffffffff8107df57:       push   %rdx
> >    151  0.0470 :ffffffff8107df58:       popfq
> > 183507 57.1725 :ffffffff8107df59:       mov    0x50(%rbx),%rax
> >    995  0.3100 :ffffffff8107df5d:       mov    %rdi,(%rax)
> 
> I'd guess at popfq to be the expensive op here.. skid usually causes the
> attribution to be a few ops down the line.

Well it doesn't really explain why it is getting more costly per
unit of work as core count increases. The popfq should run completely
out of L1 cache (or even from store forwarding) and it is expensive,
but those costs should remain the same regardless of how many cores
in the system.

But I am getting some strange looking profiles, so I'm going to get
a bigger system to run it on to see if we can get really pronounced
scalability problem. Maybe even make a microbenchmark to eliminate
other elements of the workload.

