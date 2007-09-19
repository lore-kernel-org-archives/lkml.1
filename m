Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbXISUlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbXISUlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 16:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbXISUlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 16:41:07 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:22915 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbXISUlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 16:41:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HRB2PXUX6IhHbBsT6dS5aMLHWAcjgsagCC4Z/gG/UgWiFSTjPlnWxfIXgCS7lu0VUOgbR03s/xaXPO2JDoyHju7HjfXE98BNip6pyHV+Zss2gPJJz9iE/dVHvHfcbpDZrKA37WBIswMM7GE1zaoQQbBLpPxnZuH7LiLPgAF+ehQ=
Message-ID: <d120d5000709191341p1c331e80qf7bad973bc899a0@mail.gmail.com>
Date: Wed, 19 Sep 2007 16:41:04 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 2/6] lockdep: validate rcu_dereference() vs rcu_read_lock()
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
In-Reply-To: <20070919221349.2935f69d@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070919104125.286538000@chello.nl>
	 <d120d5000709190816o2899f85fpb8ae88cbf9a18830@mail.gmail.com>
	 <20070919153750.GB8666@linux.vnet.ibm.com>
	 <d120d5000709190959p351c7ba4mdb1eeb433098e0e6@mail.gmail.com>
	 <20070919173249.GE8666@linux.vnet.ibm.com>
	 <20070919174857.GA11922@linux.vnet.ibm.com>
	 <d120d5000709191149q3d850d07nd8bf864a6e797055@mail.gmail.com>
	 <20070919214110.5d832f28@lappy>
	 <d120d5000709191249w461967d6w8da303dc54f2dd41@mail.gmail.com>
	 <20070919221349.2935f69d@lappy>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/19/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 19 Sep 2007 15:49:24 -0400 "Dmitry Torokhov"
> <dmitry.torokhov@gmail.com> wrote:
>
> > On 9/19/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > On Wed, 19 Sep 2007 14:49:56 -0400 "Dmitry Torokhov"
> > > <dmitry.torokhov@gmail.com> wrote:
> > >
> > > > On 9/19/07, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > >
> > > > > PS to previous -- any problem with inserting rcu_read_lock() and
> > > > > rcu_read_unlock() around the portion of the IRQ handler that has
> > > > > these accesses?
> > > > >
> > > >
> > > > I guess I could but it is an extra lock that needs to be managed and
> > > > given the fact that it is not really needed (other to make a newly
> > > > developed tool happy) I am hestsant to do that.
> > >
> > > As is, these sites are a bug in -rt and we'll need to fix them anyway.
> > >
> > > As for the code you pointed me to, the i8042 driver, it seems to play
> > > way to funny tricks for a simple 'slow' driver.
> >
> > Even "slow" driver should try not to slow down the rest of the system
> > if it can help it. I am sorry if the thing it does do not quite fit in
> > with the changes you are proposing but it does not make the exeisting
> > code invalid.
> >
> > >
> > > If you replace the spin_lock() + sync_sched(), with rcu_read_lock() +
> > > rcu_call() it should work again without adding an extra lock.
> > >
> >
> > Except that I need spin_lock_irq for other reasons. I could take the
> > same lock in write-side code and not use RCU at all but using RCU
> > allows opening/closing input devices without slowing down interrupt
> > handlers so why not use it?
>
> If the IRQ handler does rcu_read_lock(),unlock() and the i8042_stop()
> function does sync_rcu() instead of _sched(), it should be good again.
> It will not affect anything else than the task that calls _stop(). And
> even there the only change is that the sleep might be a tad longer.

And the IRQ handler needs to do some extra job... Anyway, it looks -rt
breaks synchronize_sched() and needs to have it fixed:

"/**
 * synchronize_sched - block until all CPUs have exited any non-preemptive
 * kernel code sequences.
 *
 * This means that all preempt_disable code sequences, including NMI and
 * hardware-interrupt handlers, in progress on entry will have completed
 * before this primitive returns."

>
> I find it curious that a driver that is 'low performant' and does not
> suffer lock contention pioneers locking schemes. I agree with
> optimizing, but this is not the place to push the envelope.

Please realize that evey microsecond wasted on a 'low performant'
driver is taken from high performers and if we can help it why
shouldn't we?

-- 
Dmitry
