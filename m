Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbXFYTN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbXFYTN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 15:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbXFYTNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 15:13:19 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:58503 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbXFYTNS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 15:13:18 -0400
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
From: Steven Rostedt <rostedt@goodmis.org>
To: Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@redhat.com>
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
In-Reply-To: <1182797325.1689.14.camel@hinata.boston.redhat.com>
References: <20070622040014.234651401@goodmis.org>
	 <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
	 <20070622204058.GA11777@elte.hu>
	 <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org>
	 <20070622215953.GA22917@elte.hu>
	 <1182797325.1689.14.camel@hinata.boston.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Date: Mon, 25 Jun 2007 15:11:18 -0400
Message-Id: <1182798678.5493.179.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-25 at 14:48 -0400, Kristian Høgsberg wrote:

> OK, here's a yell.  I'm using tasklets in the new firewire stack for all

Thanks for speaking up!

> interrupt handling.  All my interrupt handler does is read out the event
> mask and schedule the appropriate tasklets.  Most of these tasklets
> typically just end up scheduling work or completing a completion, so
> moving it to a workqueue is pretty pointless.  In particular, the
> isochronous DMA events must be handled with as little latency as
> possible, so a workqueue in that code path would be pretty bad.
> 
> I'm not strongly attached to tasklets, and it sounds like I got it wrong
> and used the wrong delayed execution mechanism.  But that's just another
> data point that suggests that there are too many of these.  I guess I
> need to sit down and look into porting that to softirqs?
> 
> However, I don't really understand how you can discuss a wholesale
> replacing of tasklets with workqueues, given the very different
> execution sematics of the two mechanisms.  I would think that others
> have used tasklets for similar purposes as I have and moving that to
> workqueues just has to break a bunch of stuff.  I don't know the various
> places tasklets are used as well as other people in this thread, but I
> think deprecating them and moving code to either softirqs or workqueues
> on a case by case basis is a better approach.  That way we also avoid
> the gross wrappers.

The gross wrappers were a perfect way to shed light on something that is
overused, and should most likely be replaced.

Does your system need to have these functions that are in tasklets need
to be non-reentrant?  I wonder how many "irq critical" functions used
tasklets just because adding a softirq requires too much (no generic
softirq code).  A tasklet is constrained to run on one CPU at a time,
and it is not guaranteed to run on the CPU it was scheduled on.

Perhaps it's time to add a new functionality while removing tasklets.
Things that are ok to bounce around CPUs (like tasklets do) can most
likely be replaced by a work queue. But these highly critical tasks
probably would benefit from being a softirq.

Maybe we should be looking at something like GENERIC_SOFTIRQ to run
functions that a driver could add. But they would run only on the CPU
that scheduled them, and do not guarantee non-reentrant as tasklets do
today.

I think I even found a bug in a driver that was trying to get around the
non-reentrancy of a tasklet (will post this soon).

It's looking like only a few tasklets have this critical requirement,
and are the candidates to move to a more generic softirq.  The rest of
the tasklets would be switched to work queues, and this gross wrapper of
mine can do that in the meantime so we can find those that should be
converted to a generic softirq.

-- Steve


