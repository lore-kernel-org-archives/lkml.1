Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbZBQVdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbZBQVdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 16:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbZBQVc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 16:32:59 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46587 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbZBQVc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 16:32:58 -0500
Date: Tue, 17 Feb 2009 13:32:56 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jens Axboe <jens.axboe@oracle.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: Q: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove
	single ipi fallback for smp_call_function_many())
Message-ID: <20090217213256.GJ6761@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090216213205.GA9098@redhat.com> <1234820704.30178.396.camel@laptop> <20090216220214.GA10093@redhat.com> <1234823097.30178.406.camel@laptop> <20090216231946.GA12009@redhat.com> <1234862974.4744.31.camel@laptop> <20090217101130.GA8660@wotan.suse.de> <1234866453.4744.58.camel@laptop> <20090217112657.GE26402@wotan.suse.de> <20090217192810.GA4980@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217192810.GA4980@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 08:28:10PM +0100, Oleg Nesterov wrote:
> On 02/17, Nick Piggin wrote:
> >
> > How's this?
> 
> To me, this patch makes the code much more clean/understandable.
> 
> And imho it is very good it removes smp_read_barrier_depends()s
> which (I think) were just wrong.
> 
> 
> But I still have the question,
> 
> > Does any architecture actually needs barriers? For the initiator I
> > could see it, but for the handler I would be surprised. The other
> > thing we could do for simplicity is just to require that a full
> > barrier is required before generating an IPI, and after receiving an
> > IPI. We can't just do that in generic code without auditing
> > architectures. There have been subtle hangs here on some archs in
> > the past.
> 
> OK, so we add the barrier here:
> 
> > @@ -104,6 +111,14 @@ void generic_smp_call_function_interrupt
> >  	int cpu = get_cpu();
> >
> >  	/*
> > +	 * Ensure entry is visible on call_function_queue after we have
> > +	 * entered the IPI. See comment in smp_call_function_many.
> > +	 * If we don't have this, then we may miss an entry on the list
> > +	 * and never get another IPI to process it.
> > +	 */
> > +	smp_mb();
> 
> But, any arch which needs this barrier should also call mb() in, say,
> smp_reschedule_interrupt() path. Otherwise we can miss TIF_NEED_RESCHED
> after return from the handler.
> 
> So the question is: is there any arch which surely needs this barrier?
> 
> IOW,
> 	int COND;
> 
> 	void smp_xxx_interrupt(regs)
> 	{
> 		BUG_ON(!COND);
> 	}
> 
> 	COND = 1;
> 	mb();
> 	smp_send_xxx(cpu);
> 
> can we really hit the BUG_ON() above on some arch?

If all of the above is executed by the same task, tripping the BUG_ON()
means either a compiler or CPU bug.

							Thanx, Paul

> (but in any case I agree, it is better to be safe and add the barrier
>  like this patch does).
> 
> Oleg.
> 
