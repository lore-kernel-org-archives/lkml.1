Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbXBJEcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbXBJEcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 23:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbXBJEcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 23:32:20 -0500
Received: from firewall.rowland.harvard.edu ([140.247.233.35]:33647 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1752686AbXBJEcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 23:32:20 -0500
Date: Fri, 9 Feb 2007 23:32:17 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Kwatch: kernel watchpoints using CPU debug registers
In-Reply-To: <20070209233150.B9542180055@magilla.sf.frob.com>
Message-ID: <Pine.LNX.4.44L0.0702092316550.3251-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Feb 2007, Roland McGrath wrote:

> I don't think I really object to the ABI change of clearing %dr6 after an
> exception so that it does not accumulate multiple results.  But first I'll
> have to convince myself that we never actually do want to accumulate
> multiple results.  Hmm, I think we can, so maybe I do object.  If you set
> two watchpoints inside a user buffer and then do a system call that touches
> both those addresses (e.g. read), then you will go through do_debug (to
> send_sigtrap) twice before returning to user mode.  When the syscall is
> done, you'll have a pending SIGTRAP for the debugger to handle.  By looking
> at your %dr6 the debugger can see that both watchpoints hit.  (gdb does not
> handle this case, but it should.)  Am I wrong?

I think you're right.

> So this gets to the more complicated view of %dr6 handling that I had first
> had in mind yesterday.  Each allocation "owns" one of the low 4 bits in
> %dr6 too.  Only the dr6 bits owned by the userland "raw" allocation
> (i.e. ptrace/utrace_regset) should appear nonzero in thread.debugreg[6].
> So when kwatch swallows a debug exception, it should mask off its bit from
> %dr6 in the CPU, but not clear %dr6 completely.  That way you can have a
> sequence of user dr0 hit, kwatch dr3 hit, user dr1 hit, all inside one
> system call (including interrupt handlers), and when it gets to the
> userland debugger examining dr6 it sees the low 2 bits both set.

Okay; I'll fix this too.  Come to think of it, kwatch needs to handle 
multiple hits as well -- there might be two watchpoints set to the same 
address.

> > It's really quite a tricky matter.  Should a register be allocated to
> > kwatch only when no user process needs it?  Should we really go about
> > checking the requirements of every single process whenever a kwatch
> > allocation request comes in?  What if the processes which need a
> > particular register aren't running -- should the register then be given to
> > kwatch?  What if one of those processes then does start running on one
> > CPU?
> 
> To "go about checking the requirements of every single process" is not so
> hard as it sounds when they're recorded as a single global use count per
> slot, as your original code does.  When you mentioned a "your allocation is
> available" callback, I was thinking it might come to that being called
> inside context switch.  It's all rather tricky, indeed.  
> 
> The obvious answer is to start simple.  If any user process anywhere uses
> drN, kwatch has to give it up for all CPUs (watchpoints with less than
> "break ptrace" priority do).  If anyone really cares about more flexibility
> than that, we can change or extend it.  Some copious comments in the
> interface descriptions can lead them in the right direction if the
> situation comes up.  Probably with systemtap support in a while, we'll get
> a lot more concrete uses of watchpoints and people finding out what really 
> matters to them.

It's still more complicated than you might think.  Let's say two user
processes each have dr1 allocated, one with low priority and the other
with high priority.  The kernel has to be aware of the high-priority
allocation, so that it can refuse intermediate-priority kwatch allocation
attempts.  Now suppose the second process exits.  dr1 is still allocated
to the first user process but only with low priority, so now
intermediate-priority kwatch allocation attempts should succeed.

In order for this to work, when the second process gives up its allocation 
I would have to either scan though all tasks to see the first process, or 
else keep several global use counts for each slot -- in fact, one use 
count for each priority level.  That's doable if there are only a few 
levels, but not if there are many.

How do you suggest this be handled?  Maybe we should just keep track of a
maximum user priority level for each slot, allowing it to go up but not
down until all user processes have given up the slot.  (I.e., in the
example above the later kwatch requests would still fail because we would
continue to remember the high user priority level so long as the first
process maintained its allocation.)  That would be overly pessimistic, but
it would at least be safe.

Alan Stern

