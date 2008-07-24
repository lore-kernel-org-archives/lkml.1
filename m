Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbYGXLAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbYGXLAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 07:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbYGXK7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:59:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:58648 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbYGXK7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:59:54 -0400
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
	__netif_schedule+0x2c/0x98()
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Miller <davem@davemloft.net>, jarkao2@gmail.com,
       Larry.Finger@lwfinger.net, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, mingo@redhat.com,
       paulmck@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <200807242038.36693.nickpiggin@yahoo.com.au>
References: <1216890648.7257.258.camel@twins>
	 <20080724.023210.229338550.davem@davemloft.net>
	 <1216894136.7257.266.camel@twins>
	 <200807242038.36693.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 12:59:46 +0200
Message-Id: <1216897186.7257.279.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-24 at 20:38 +1000, Nick Piggin wrote:
> On Thursday 24 July 2008 20:08, Peter Zijlstra wrote:
> > On Thu, 2008-07-24 at 02:32 -0700, David Miller wrote:
> > > From: Peter Zijlstra <peterz@infradead.org>
> > > Date: Thu, 24 Jul 2008 11:27:05 +0200
> > >
> > > > Well, not only lockdep, taking a very large number of locks is
> > > > expensive as well.
> > >
> > > Right now it would be on the order of 16 or 32 for
> > > real hardware.
> > >
> > > Much less than the scheduler currently takes on some
> > > of my systems, so currently you are the pot calling the
> > > kettle black. :-)
> >
> > One nit, and then I'll let this issue rest :-)
> >
> > The scheduler has a long lock dependancy chain (nr_cpu_ids rq locks),
> > but it never takes all of them at the same time. Any one code path will
> > at most hold two rq locks.
> 
> Aside from lockdep, is there a particular problem with taking 64k locks
> at once? (in a very slow path, of course) I don't think it causes a
> problem with preempt_count, does it cause issues with -rt kernel?

PI-chains might explode I guess, Thomas?

Besides that, I just have this voice in my head telling me that
minimizing the number of locks held is a good thing.

> Hey, something kind of cool (and OT) I've just thought of that we can
> do with ticket locks is to take tickets for 2 (or 64K) nested locks,
> and then wait for them both (all), so the cost is N*lock + longest spin,
> rather than N*lock + N*avg spin.
> 
> That would mean even at the worst case of a huge amount of contention
> on all 64K locks, it should only take a couple of ms to take all of
> them (assuming max spin time isn't ridiculous).
> 
> Probably not the kind of feature we want to expose widely, but for
> really special things like the scheduler, it might be a neat hack to
> save a few cycles ;) Traditional implementations would just have
> #define spin_lock_async	      spin_lock
> #define spin_lock_async_wait  do {} while (0)
> 
> Sorry it's offtopic, but if I didn't post it, I'd forget to. Might be
> a fun quick hack for someone.

It might just be worth it for double_rq_lock() - if you can sort out the
deadlock potential Miklos just raised ;-)

