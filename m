Return-Path: <linux-kernel-owner+w=401wt.eu-S1759651AbYECFtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651AbYECFtn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 01:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbYECFte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 01:49:34 -0400
Received: from mx1.suse.de ([195.135.220.2]:39138 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbYECFtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 01:49:33 -0400
Date: Sat, 3 May 2008 07:49:30 +0200
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       jeremy@goop.org, mingo@elte.hu
Subject: Re: [PATCH 1/10] Add generic helpers for arch IPI function calls
Message-ID: <20080503054930.GA19664@wotan.suse.de>
References: <20080429135936.GC12390@linux.vnet.ibm.com> <20080430112934.GA23203@linux.vnet.ibm.com> <20080430113456.GY12774@kernel.dk> <20080430121712.GR11126@linux.vnet.ibm.com> <20080430123717.GC12774@kernel.dk> <20080502020241.GA26088@linux.vnet.ibm.com> <20080502021233.GC11844@wotan.suse.de> <20080502122955.GB15522@linux.vnet.ibm.com> <20080502124205.GA23680@linux.vnet.ibm.com> <1209733169.13978.157.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209733169.13978.157.camel@twins>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 02:59:29PM +0200, Peter Zijlstra wrote:
> On Fri, 2008-05-02 at 05:42 -0700, Paul E. McKenney wrote:
> 
> > And here is one scenario that makes me doubt that my imagination is
> > faulty:
> > 
> > 1.	CPU 0 disables irqs.
> > 
> > 2.	CPU 1 disables irqs.
> > 
> > 3.	CPU 0 invokes smp_call_function().  But CPU 1 will never respond
> > 	because its irqs are disabled.
> > 
> > 4.	CPU 1 invokes smp_call_function().  But CPU 0 will never respond
> > 	because its irqs are disabled.
> > 
> > Looks like inherent deadlock to me, requiring that smp_call_function()
> > be invoked with irqs enabled.
> > 
> > So, what am I missing here?
> 
> The wish to do it anyway ;-)
> 
> I can imagine some situations where I'd like to try anyway and fall back
> to a slower path when failing.
> 
> With the initial design we would simply allocate data, stick it on the
> queue and call the ipi (when needed).
> 
> This is perfectly deadlock free when wait=0 and it just returns -ENOMEM
> on allocation failure.

Yeah, I'm just talking about the wait=0 case. (btw. I'd rather the core
API takes some data rather than allocates some itself, eg because you
might want to have it on the stack).

For the wait=1 case, something very clever such as processing pending
requests in a polling loop might be cool... however I'd rather not add
such complexity until someone needs it (you could stick a comment in
there outlining your algorithm). But I'd just rather not have peole rely
on it yet.

 
> It it doesn't return -ENOMEM I know its been queued and will be
> processed at some point, if it does fail, I can deal with it in another
> way.

At least with IPIs I think we can guarantee they will be processed on
the target after we queue them.

 
> I know I'd like to do that and I suspect Nick has a few use cases up his
> sleeve as well.

It would be handy. The "quickly kick something off on another CPU" is
pretty nice in mm/ when you have per-cpu queues or caches that might
want to be flushed.
