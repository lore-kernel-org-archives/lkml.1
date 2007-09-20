Return-Path: <linux-kernel-owner+w=401wt.eu-S1758320AbXITRbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320AbXITRbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbXITRbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:31:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:1709 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbXITRbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:31:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pv9nV2V1OzHLo6sO/8siumIyitln+jiApJxcYxWq49ySdvpcXqhiiuJQ+xzSJXERcBnvpn5w6GSXlr1gokcllxeY0VnPa89uaC0hav4a+dDnYQwiek+aOV7Ls4XXZ2ravQRBtdxhj6vPOnXkKKFB6Q28kyYN1XFRgN1S38KDxiQ=
Message-ID: <d120d5000709201031o687ac0d5qe4d32406c12a7886@mail.gmail.com>
Date: Thu, 20 Sep 2007 13:31:35 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 2/6] lockdep: validate rcu_dereference() vs rcu_read_lock()
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
In-Reply-To: <20070919234700.3b532dcd@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070919104125.286538000@chello.nl>
	 <20070919174857.GA11922@linux.vnet.ibm.com>
	 <d120d5000709191149q3d850d07nd8bf864a6e797055@mail.gmail.com>
	 <20070919214110.5d832f28@lappy>
	 <d120d5000709191249w461967d6w8da303dc54f2dd41@mail.gmail.com>
	 <20070919221349.2935f69d@lappy>
	 <d120d5000709191341p1c331e80qf7bad973bc899a0@mail.gmail.com>
	 <20070919231943.4b121361@lappy>
	 <d120d5000709191429n29f5dc78g2746de3ee4e9ca81@mail.gmail.com>
	 <20070919234700.3b532dcd@lappy>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/19/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 19 Sep 2007 17:29:09 -0400 "Dmitry Torokhov"
> <dmitry.torokhov@gmail.com> wrote:
>
> > On 9/19/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > On Wed, 19 Sep 2007 16:41:04 -0400 "Dmitry Torokhov"
> > > <dmitry.torokhov@gmail.com> wrote:
> > >
> > > > > If the IRQ handler does rcu_read_lock(),unlock() and the i8042_stop()
> > > > > function does sync_rcu() instead of _sched(), it should be good again.
> > > > > It will not affect anything else than the task that calls _stop(). And
> > > > > even there the only change is that the sleep might be a tad longer.
> > > >
> > > > And the IRQ handler needs to do some extra job... Anyway, it looks -rt
> > > > breaks synchronize_sched() and needs to have it fixed:
> > > >
> > > > "/**
> > > >  * synchronize_sched - block until all CPUs have exited any non-preemptive
> > > >  * kernel code sequences.
> > > >  *
> > > >  * This means that all preempt_disable code sequences, including NMI and
> > > >  * hardware-interrupt handlers, in progress on entry will have completed
> > > >  * before this primitive returns."
> > >
> > > That still does as it says in -rt. Its just that the interrupt handler
> > > will be preemptible so the guarantees it gives are useless.
> >
> > Please note "... including NMI and hardware-interrupt handlers ..."
>
> -rt doesn't run interrupt handlers in hardware irq context anymore.

OK, then what is the purpose of synchronize_sched() in -rt?

You really need to provide users with a replacement. There are several
drivers that use it and for example r8169 is not what you'd call a
'low performer'.

I guess I can switch i8042 to use synchronize_irq(). That still works
in -rt, doesn't it? That still leaves atkbd...

>
> > >
> > > > > I find it curious that a driver that is 'low performant' and does not
> > > > > suffer lock contention pioneers locking schemes. I agree with
> > > > > optimizing, but this is not the place to push the envelope.
> > > >
> > > > Please realize that evey microsecond wasted on a 'low performant'
> > > > driver is taken from high performers and if we can help it why
> > > > shouldn't we?
> > >
> > > sure, but the cache eviction caused by running the driver will have
> > > more impact than the added rcu_read_{,un}lock() calls.
> >
> > Are you saying that adding rcu_read_{,un}lock() will help with cache
> > eviction? How?
>
> No, I'm saying that its noise compared to the cache eviction overhead
> it causes for others.
>

What about udelay(10)? It is probably also a noise but we shoudl not
go and sprinkle it through drivers, should we? ;)

-- 
Dmitry
