Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbXLDPRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbXLDPRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 10:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbXLDPRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 10:17:08 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36058 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753863AbXLDPRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 10:17:06 -0500
Date: Tue, 4 Dec 2007 10:17:04 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jarek Poplawski <jarkao2@gmail.com>
cc: Jarek Poplawski <jarkao2@o2.pl>, Ingo Molnar <mingo@elte.hu>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: Need lockdep help
In-Reply-To: <4754907E.9060203@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0712041000540.4321-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007, Jarek Poplawski wrote:

> Alan Stern wrote, On 12/03/2007 04:08 PM:
> 
> > On Mon, 3 Dec 2007, Jarek Poplawski wrote:
> > 

> >> Actually, IMHO, there is no reason for any lockdep violation:
> >>
> >> thread #1: has down_read(A); waits for #2 to down_write(B)
> >> thread #2: has down_write(B); never waits for #1 to down_read(A)
> >>
> >> So, deadlock isn't possible here. If lockdep reports something else it
> >> should be fixed (and you'd be right to omit lockdep until this is
> >> done).
> > 
> > I think the reasoning goes the way Arjan described.  Suppose in between
> > #1 and #2 there is thread #3 trying to do down_write(A) and waiting for
> > #1.  Then thread #2 doesn't have to wait for #1 directly, but it would
> > have to wait for #3.
> 
> 
> As a matter of fact I completely missed Arjan's point because I thought
> you described these locks according to lockdep's report, and there is
> an information about read or write... Since, you still seem to guess
> above about possible scenario, maybe it would be easier to show this
> report (and maybe a piece of this code if possible)?

I have changed my new code, so now the problem is avoided.

> Btw., if it were like you're suggesting, it still shouldn't make any
> difference: if thread #3 is only waiting for the lock taken for reading,
> then I can't see why thread #2 has to wait for anything.

The deadlock occurs because:

	Thread #1 has locked A for reading and is waiting for
	#2 to release B so that #1 can lock B for writing.

	Thread #3 is waiting for #1 to release A so that #3
	can lock A for writing.

	Thread #2 has locked B for writing and is waiting for
	#3 to finish using A so that #2 can lock A for reading.

So #1 is waiting for #2, #2 is waiting for #3, and #3 is waiting for 
#1.  Lockdep warns because this might happen.

Perhaps the point you're missing is that if #3 does down_write(A)  
before #2 does down_read(A) then #2 has to wait until #3 releases the
write lock.  #2 isn't allowed to sneak in front of #3; that's what
Arjan meant when he said that rwsems are fair.

The same sort of problem occurs when a thread does nested read locks on
a single rwsem.  If a different thread were to try to acquire a write
lock in between, another deadlock would occur.  That's why lockdep
warns about nested (or recursive) read locks.

> Probably more
> dangerous, at least for lockdep, could look taking down_write(A) by
> thread #1 in between, but if it all were possible only within one
> thread, then still there should be no reason to change good program
> only to please lockdep.

I believe the idea behind lockdep is to warn about situations that
might reasonably be expected to occur.  A thread deadlocking itself by
doing down_read(A) followed immediately by down_write(A) isn't
reasonable, so lockdep doesn't worry about that possibility.

> > In my case the simplest answer appears to be the replace the rwsem
> > with something slightly more complicated (a mutex plus a boolean flag 
> > -- the loss of concurrency won't matter much since it isn't on a hot 
> > path).
> 
> I'm not sure I can understand your plan, but I doubt there should be
> such problems with taking rwsem for sleeping, so maybe it would be
> better to figure out what really scares lockdep, to fix the right place?

The real problem is that lockdep has to make some generalizations.  It
can't be aware of the details of every possible situation, and it
doesn't have a global view of the entire kernel, so it doesn't know
when special circumstances make deadlock impossible.

Furthermore, in this case deadlock isn't really impossible -- it could 
occur if there were a bug somewhere else in the kernel.  So lockdep was 
correct to warn that deadlock might occur.

Alan Stern

