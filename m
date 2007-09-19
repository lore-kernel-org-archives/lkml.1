Return-Path: <linux-kernel-owner+w=401wt.eu-S1762535AbXISReJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762535AbXISReJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762344AbXISRcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:32:52 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37695 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762338AbXISRcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:32:51 -0400
Date: Wed, 19 Sep 2007 10:32:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [RFC][PATCH 2/6] lockdep: validate rcu_dereference() vs rcu_read_lock()
Message-ID: <20070919173249.GE8666@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070919104125.286538000@chello.nl> <20070919105054.332308000@chello.nl> <d120d5000709190717y69dca8b3tf4a17b920267806b@mail.gmail.com> <20070919163111.05c18021@twins> <d120d5000709190816o2899f85fpb8ae88cbf9a18830@mail.gmail.com> <20070919153750.GB8666@linux.vnet.ibm.com> <d120d5000709190959p351c7ba4mdb1eeb433098e0e6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000709190959p351c7ba4mdb1eeb433098e0e6@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 12:59:10PM -0400, Dmitry Torokhov wrote:
> On 9/19/07, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > On Wed, Sep 19, 2007 at 11:16:21AM -0400, Dmitry Torokhov wrote:
> > > On 9/19/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > > On Wed, 19 Sep 2007 10:17:25 -0400 "Dmitry Torokhov"
> > > > <dmitry.torokhov@gmail.com> wrote:
> > > >
> > > > > Hi Peter,
> > > > >
> > > > > On 9/19/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > > > > Warn when rcu_dereference() is not used in combination with rcu_read_lock()
> > > > > >
> > > > >
> > > > > According to Paul it is fine to use RCU primitives (when accompanied
> > > > > with proper comments) when the read-size critical section is guarded
> > > > > by spin_lock_irqsave()/spin_lock_irqsrestore() instead of
> > > > > rcu_read_lock()/rcu_read_unlock() and writers synchronize with
> > > > > synchronize_sched(), not synchronize_rcu(). Your patch will trigger
> > > > > warnign on such valid usages.
> > > > >
> > > >
> > > > Sounds fragile to begin with. But you're right in that that is valid
> > > > for Linux as you know it. However in -rt most/all spinlocks are
> > > > converted to sleeping locks. In that case sync_sched() is not enough.
> > >
> > > OK, then it goes beyond RCU... We need to come up with something that
> > > can be used to synchronize with IRQ handlers (quite often in driver
> > > code one needs to be sure that current invocation of IRQ handler
> > > completed before doing something). And once we have it splinlock + RCU
> > > users can just use that method.
> >
> > But Peter's approach would not cause a problem here -- you wouldn't be
> > doing an rcu_dereference from within the IRQ handler in this case, right?
> 
> Yes I do. Along with list_for_each_rcu().

OK, in that case it does indeed need to be handled.

							Thanx, Paul

> > That said, we will need something to handle threaded interrupts, since
> > synchronize_sched() only waits for hardirq, NMI, SMI, etc., and not
> > threaded IRQs.
> >
> >                                                        Thanx, Paul
> >
> 
> -- 
> Dmitry
