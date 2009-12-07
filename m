Return-Path: <linux-kernel-owner+w=401wt.eu-S935568AbZLGSSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935568AbZLGSSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 13:18:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935537AbZLGSSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 13:18:13 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55839 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935489AbZLGSSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 13:18:12 -0500
Date: Mon, 7 Dec 2009 10:18:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [rfc] "fair" rw spinlocks
Message-ID: <20091207181816.GF6808@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091130100041.GA29610@infradead.org> <alpine.LFD.2.00.0911300722370.2872@localhost.localdomain> <20091130174638.GA9782@elte.hu> <alpine.LFD.2.00.0911302206370.24119@localhost.localdomain> <1259616429.26472.499.camel@laptop> <alpine.LFD.2.00.0911302300550.24119@localhost.localdomain> <alpine.LFD.2.00.0911301409560.2872@localhost.localdomain> <alpine.LFD.2.00.0911302328350.24119@localhost.localdomain> <alpine.LFD.2.00.0911301443110.2872@localhost.localdomain> <m1y6lg7q3n.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y6lg7q3n.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 05, 2009 at 07:12:28PM -0800, Eric W. Biederman wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> > On Mon, 30 Nov 2009, Thomas Gleixner wrote:
> >> 
> >> I'm aware of that. The number of places where we read_lock
> >> tasklist_lock is 79 in 36 files right now. That's not a horrible task
> >> to go through them one by one and do a case by case conversion with a
> >> proper changelog. That would only leave the write_lock sites. 
> >
> > The write_lock sites should be fine, since just changing them to a 
> > spinlock should be 100% semantically equivalent - except for the lack of 
> > interrupt disable. And the lack of interrupt disable will result in a nice 
> > big deadlock if some interrupt really does take the spinlock, which is 
> > much easier to debug than a subtle race that would get the wrong read 
> > value.
> >
> >> We can then either do the rw_lock to spin_lock conversion or keep the
> >> rw_lock which has no readers anymore and behaves like a spinlock for a
> >> transition time so reverts of one of the read_lock -> rcu patches
> >> could be done to debug stuff.
> >
> > So as per the above, I wouldn't worry about the write lockers. Might as 
> > well change it to a spinlock, since that's what it will act as. It's not 
> > as if there is any chance that the spinlock code is subtly buggy.
> >
> > So the only reason to keep it as a rwlock would be if you decide to do the 
> > read-locked cases one by one, and don't end up with all of them converted. 
> > Which is a reasonable strategy too, of course. We don't _have_ to convert 
> > them all - if the main problem is some starvation issue, it's sufficient 
> > to convert just the main read-lock cases so that writers never get 
> > starved.
> >
> > But converting it all would be nice, because that whole
> >
> > 	write_lock_irq(&tasklist_lock);
> >
> > to
> >
> > 	spin_lock(&tasklist_lock);
> >
> > conversion would likely be a measurable performance win. Both because 
> > spinlocks are fundamentally faster (no atomic on unlock), and because you 
> > get rid of the irq disable/enable. But in order to get there, you'd have 
> > to convert _all_ the read-lockers, so you'd miss the opportunity to only 
> > convert the easy cases.
> 
> Atomically sending signal to every member of a process group, is the
> big fly in the ointment I am aware of.  Last time I looked I could
> not see how to convert it rcu.
> 
> Fundamentally: "kill -KILL -pgrp" should be usable to kill all of
> the processes in a process group, and "kill -KILL -1" should be usable
> to kill everything except the sender and init.  Something I have seen
> in shutdown scripts on more than one occasion.
> 
> This is a subtle in the sense that it won't show up in simple tests if
> you get it wrong.
> 
> This is a pain because we occasionally signal a process group from
> interrupt context.

Is it required that all of the processes see the signal before the
corresponding interrupt handler returns?  (My guess is "no", which
enables a trick or two, but thought I should ask.)

> The trouble as I recall is how to ensure new processes see the signal.

And can we afford to serialize signals to groups of processes?  Not
necessarily one at a time, but a limited set at a given time?
Alternatively, a long list of pending group signals for each new task to
walk?

							Thanx, Paul
