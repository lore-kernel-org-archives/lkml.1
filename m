Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbZCJQIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbZCJQIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756872AbZCJQFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:05:45 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44975 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756871AbZCJQFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:05:44 -0400
Date: Tue, 10 Mar 2009 12:05:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ingo Molnar <mingo@elte.hu>
cc: prasad@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 06/11] Use virtual debug registers in process/thread
 handling code
In-Reply-To: <20090310144933.GH3850@elte.hu>
Message-ID: <Pine.LNX.4.44L0.0903101155000.3979-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009, Ingo Molnar wrote:

> > @@ -595,6 +596,12 @@ __switch_to(struct task_struct *prev_p, 
> >  
> >  	percpu_write(current_task, next_p);
> >  
> > +	/*
> > +	 * Handle debug registers.  This must be done _after_ current
> > +	 * is updated.
> > +	 */
> > +	if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
> > +		switch_to_thread_hw_breakpoint(next_p);
> 
> why does this have to be called after 'current' has been 
> updated? AFAICS switch_to_thread_hw_breakpoint() does not take a 
> look at 'current'.

There was a discussion about this on LKML last October 17, and you were 
in the CC list.  Here is the reason, extracted from one of those 
messages:


There's a problem with moving the switch_to_thread_hw_breakpoint() call 
before current is updated.  Suppose a kernel breakpoint is triggered in 
between the two.  The hw-breakpoint handler will see that current is 
different from the task pointer stored in the chbi area, so it will 
think the task pointer is leftover from an old task (lazy switching) 
and will erase it.  Then until the next context switch, no 
user-breakpoints will be installed.

The real problem is that it's impossible to update both current and 
chbi->bp_task at the same instant, so there will always be a window in 
which they disagree and a breakpoint might get triggered.  Since we use 
lazy switching, we are forced to assume that a disagreement means that 
current is correct and chbi->bp_task is old.  But if you move the code 
above then you'll create a window in which current is old and 
chbi->bp_task is correct.


> Speaking of switch_to_thread_hw_breakpoint(), i dont like that 
> function at all:
> 
> - why does it have to do a list of debug registers?

I'm not sure I understand the point of this question.  Are you asking
why the hw_breakpoint structures are stored on a list?  Because there
can be an arbitrarily large number of them.

> - why does it worry about IPIs arriving when context-switches on 
>   x86 are always done with interrupts disabled?

The routine gets invoked at times other than during a context switch.  
However you may be right that these times are all mutually exclusive.  
If so then a good deal of complication can be removed.

> - also, what do the ->installed() and ->uninstalled() callbacks 
>   do - nothing uses it!

What do you mean?  They do what any callback does.  And of course 
nothing uses them -- the code hasn't been merged yet!

The intention is to let programs (or kernel debuggers) know when the 
statistics they are gathering are contaminated because the breakpoint 
in question has been uninstalled, and when the statistics are again 
valid because the breakpoint has been re-installed.

Alan Stern

