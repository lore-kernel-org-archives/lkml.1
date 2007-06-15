Return-Path: <linux-kernel-owner+w=401wt.eu-S1757638AbXFOUMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638AbXFOUMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbXFOUMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:12:41 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:46979 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946AbXFOUMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:12:40 -0400
Date: Fri, 15 Jun 2007 13:12:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Using RCU with rcu_read_lock()?
Message-ID: <20070615201238.GE9301@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <d120d5000706151200u34bd6728n7fca0983d6175f29@mail.gmail.com> <1181934259.11113.6.camel@lappy> <20070615192940.GA2996@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070615192940.GA2996@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2007 at 12:59:40AM +0530, Dipankar Sarma wrote:
> On Fri, Jun 15, 2007 at 09:04:19PM +0200, Peter Zijlstra wrote:
> > On Fri, 2007-06-15 at 15:00 -0400, Dmitry Torokhov wrote:
> > > Hi,
> > > 
> > > I have a piece of code that is always called under a spinlock with
> > > interrups disabled. Within that piece of code I iterate through a
> > > list. I have another piece of code that wants to modify that list. I
> > > have 2 options:
> > > 
> > > I don't want to do 1) because the otheir piece of code does not really
> > > care about object owning the spinlock and so acquiring the spinlock is
> > > "not nice". However it is guaranteed that the piece of code that
> > > accesses lock runs atomically with interrupts disabled. So
> > > rcu_read_lock() would be superfluos there.
> > > 
> > > Is it possible to still use list_for_each_rcu() and friends to access
> > > that list without rcu_read_lock()? Or it is betteruse complete RCU
> > > interface and eat cost of couple of extra instrctions?
> > 
> > Yes, preemptible rcu requires that you use the full interface, also, it
> > more clearly documents the code. Trying to find code that breaks these
> > assumptions is very tedious work after the fact.
> > 
> > Please do use the RCU interface in full.
> 
> As Peter said, you should use the strict RCU APIs and not rely
> on the current implementation of RCU to optimize. Things change.
> Plus static/dynamic checking becomes easier that way.

What they said!!!

There are a couple of other options, however:

1.	Use preempt_disable() and preempt_enable() on the read side,
	and synchronize_sched() on the update side.

2.	Use local_irq_save() and local_irq_restore() on the read side,
	and synchronize_sched() on the update side.  Usually not
	competitive -- unless interrupts needed to be disabled for some
	other reason anyway.  Which you in fact say that you do.

I believe that #2 might do what you want.  But please, PLEASE carefully
comment this usage!!!

							Thanx, Paul
