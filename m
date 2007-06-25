Return-Path: <linux-kernel-owner+w=401wt.eu-S1752070AbXFYULF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbXFYULF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 16:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbXFYUKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 16:10:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbXFYUKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 16:10:55 -0400
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
From: Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru
In-Reply-To: <1182798678.5493.179.camel@localhost.localdomain>
References: <20070622040014.234651401@goodmis.org>
	 <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
	 <20070622204058.GA11777@elte.hu>
	 <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org>
	 <20070622215953.GA22917@elte.hu>
	 <1182797325.1689.14.camel@hinata.boston.redhat.com>
	 <1182798678.5493.179.camel@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Date: Mon, 25 Jun 2007 16:07:01 -0400
Message-Id: <1182802021.1689.50.camel@hinata.boston.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-25 at 15:11 -0400, Steven Rostedt wrote:
> On Mon, 2007-06-25 at 14:48 -0400, Kristian Høgsberg wrote:
> ...
> > However, I don't really understand how you can discuss a wholesale
> > replacing of tasklets with workqueues, given the very different
> > execution sematics of the two mechanisms.  I would think that others
> > have used tasklets for similar purposes as I have and moving that to
> > workqueues just has to break a bunch of stuff.  I don't know the various
> > places tasklets are used as well as other people in this thread, but I
> > think deprecating them and moving code to either softirqs or workqueues
> > on a case by case basis is a better approach.  That way we also avoid
> > the gross wrappers.
> 
> The gross wrappers were a perfect way to shed light on something that is
> overused, and should most likely be replaced.
> 
> Does your system need to have these functions that are in tasklets need
> to be non-reentrant?  I wonder how many "irq critical" functions used
> tasklets just because adding a softirq requires too much (no generic
> softirq code).  A tasklet is constrained to run on one CPU at a time,
> and it is not guaranteed to run on the CPU it was scheduled on.

When I started the firewire work, I wasn't aware that tasklets were
going away, but I knew that doing too much work in the interrupt handler
was frowned upon, for good reasons.  So I was looking at softirqs vs
taslkets, and since using softirqs means you have to go add yourself to
the big bitmask, I opted for tasklets.  The comment in interrupt.h
directly recommends this.  As it stands, the firewire stack does
actaully rely on the non-reentrancy of tasklets, but that's not a
deal-breaker, I can add the necessary locking.

> Perhaps it's time to add a new functionality while removing tasklets.
> Things that are ok to bounce around CPUs (like tasklets do) can most
> likely be replaced by a work queue. But these highly critical tasks
> probably would benefit from being a softirq.
> 
> Maybe we should be looking at something like GENERIC_SOFTIRQ to run
> functions that a driver could add. But they would run only on the CPU
> that scheduled them, and do not guarantee non-reentrant as tasklets do
> today.

Sounds like this will fill the gap.  Of course, this won't reduce the
number of delayed-execution mechanisms available...

Kristian

