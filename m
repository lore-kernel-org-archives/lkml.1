Return-Path: <linux-kernel-owner+w=401wt.eu-S1764759AbYEBOVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764759AbYEBOVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 10:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760550AbYEBOVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 10:21:44 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43769 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759020AbYEBOVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 10:21:43 -0400
Date: Fri, 2 May 2008 07:21:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       jeremy@goop.org, mingo@elte.hu
Subject: Re: [PATCH 1/10] Add generic helpers for arch IPI function calls
Message-ID: <20080502142139.GA7599@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080429135936.GC12390@linux.vnet.ibm.com> <20080430112934.GA23203@linux.vnet.ibm.com> <20080430113456.GY12774@kernel.dk> <20080430121712.GR11126@linux.vnet.ibm.com> <20080430123717.GC12774@kernel.dk> <20080502020241.GA26088@linux.vnet.ibm.com> <20080502021233.GC11844@wotan.suse.de> <20080502122955.GB15522@linux.vnet.ibm.com> <20080502124205.GA23680@linux.vnet.ibm.com> <1209733169.13978.157.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209733169.13978.157.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
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
> 
> It it doesn't return -ENOMEM I know its been queued and will be
> processed at some point, if it does fail, I can deal with it in another
> way.
> 
> I know I'd like to do that and I suspect Nick has a few use cases up his
> sleeve as well.

OK, so one approach would be to check for irqs being disabled,
perhaps as follows, on top of my previous patch:

		struct call_single_data *data = NULL;

		if (!wait) {
			data = kmalloc(sizeof(*data), GFP_ATOMIC);
			if (data)
				data->flags = CSD_FLAG_ALLOC;
		}
		if (!data) {
			if (unlikely(irqs_disabled())) {
				put_cpu();
				return -ENOMEM;
			}
			data = &d;
			data->flags = CSD_FLAG_WAIT;
		}

		data->func = func;
		data->info = info;
		generic_exec_single(cpu, data);

That would prevent -ENOMEM unless you invoked the function with irqs
disabled.  So normal callers would still see the current failure-free
semantics -- you really don't want to be inflicting failure when not
necessary, right?

There could only be one irq-disabled caller at a time, which could be
handled using a trylock, returning -EBUSY if the lock is already held.
Otherwise, you end up with the scenario called out above (which Keith
Ownens pointed out some years ago).

Does this approach make sense?

							Thanx, Paul
