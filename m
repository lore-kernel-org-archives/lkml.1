Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbXISVVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbXISVVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 17:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbXISVVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:21:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43934 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbXISVVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:21:13 -0400
Date: Wed, 19 Sep 2007 23:19:43 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [RFC][PATCH 2/6] lockdep: validate rcu_dereference() vs
 rcu_read_lock()
Message-ID: <20070919231943.4b121361@lappy>
In-Reply-To: <d120d5000709191341p1c331e80qf7bad973bc899a0@mail.gmail.com>
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
	<d120d5000709191341p1c331e80qf7bad973bc899a0@mail.gmail.com>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.11.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 16:41:04 -0400 "Dmitry Torokhov"
<dmitry.torokhov@gmail.com> wrote:

> > If the IRQ handler does rcu_read_lock(),unlock() and the i8042_stop()
> > function does sync_rcu() instead of _sched(), it should be good again.
> > It will not affect anything else than the task that calls _stop(). And
> > even there the only change is that the sleep might be a tad longer.
> 
> And the IRQ handler needs to do some extra job... Anyway, it looks -rt
> breaks synchronize_sched() and needs to have it fixed:
> 
> "/**
>  * synchronize_sched - block until all CPUs have exited any non-preemptive
>  * kernel code sequences.
>  *
>  * This means that all preempt_disable code sequences, including NMI and
>  * hardware-interrupt handlers, in progress on entry will have completed
>  * before this primitive returns."

That still does as it says in -rt. Its just that the interrupt handler
will be preemptible so the guarantees it gives are useless.

> > I find it curious that a driver that is 'low performant' and does not
> > suffer lock contention pioneers locking schemes. I agree with
> > optimizing, but this is not the place to push the envelope.
> 
> Please realize that evey microsecond wasted on a 'low performant'
> driver is taken from high performers and if we can help it why
> shouldn't we?

sure, but the cache eviction caused by running the driver will have
more impact than the added rcu_read_{,un}lock() calls.
