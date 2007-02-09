Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbXBIXbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbXBIXbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 18:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbXBIXbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 18:31:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbXBIXby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 18:31:54 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
X-Fcc: ~/Mail/utrace
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Kwatch: kernel watchpoints using CPU debug registers
In-Reply-To: Alan Stern's message of  Friday, 9 February 2007 10:54:40 -0500 <Pine.LNX.4.44L0.0702091044230.4548-100000@iolanthe.rowland.org>
X-Shopping-List: (1) Precocious bruisers
   (2) Surreptitious exhibitions
   (3) Revised console bags
   (4) Decorator hider hamster-lips
   (5) Omniscient dangerous acne
Message-Id: <20070209233150.B9542180055@magilla.sf.frob.com>
Date: Fri,  9 Feb 2007 15:31:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes.  In fact, the current existing code does not handle dr6 correctly.  
> It never clears the register, which means you're likely to get into 
> trouble when multiple breakpoints (or watchpoints) are enabled.

This is a subtle change from the existing ABI, in which userland has to
clear %dr6 via ptrace itself.  But gdb never does that AFAICT.  So it's in
fact subject to confusion when two watchpoints are set and the second hits
after the first.  So gdb ought to be fixed to clear dr6 via ptrace, to work
with existing and older kernels.

I don't think I really object to the ABI change of clearing %dr6 after an
exception so that it does not accumulate multiple results.  But first I'll
have to convince myself that we never actually do want to accumulate
multiple results.  Hmm, I think we can, so maybe I do object.  If you set
two watchpoints inside a user buffer and then do a system call that touches
both those addresses (e.g. read), then you will go through do_debug (to
send_sigtrap) twice before returning to user mode.  When the syscall is
done, you'll have a pending SIGTRAP for the debugger to handle.  By looking
at your %dr6 the debugger can see that both watchpoints hit.  (gdb does not
handle this case, but it should.)  Am I wrong?

So this gets to the more complicated view of %dr6 handling that I had first
had in mind yesterday.  Each allocation "owns" one of the low 4 bits in
%dr6 too.  Only the dr6 bits owned by the userland "raw" allocation
(i.e. ptrace/utrace_regset) should appear nonzero in thread.debugreg[6].
So when kwatch swallows a debug exception, it should mask off its bit from
%dr6 in the CPU, but not clear %dr6 completely.  That way you can have a
sequence of user dr0 hit, kwatch dr3 hit, user dr1 hit, all inside one
system call (including interrupt handlers), and when it gets to the
userland debugger examining dr6 it sees the low 2 bits both set.

> It's really quite a tricky matter.  Should a register be allocated to
> kwatch only when no user process needs it?  Should we really go about
> checking the requirements of every single process whenever a kwatch
> allocation request comes in?  What if the processes which need a
> particular register aren't running -- should the register then be given to
> kwatch?  What if one of those processes then does start running on one
> CPU?

To "go about checking the requirements of every single process" is not so
hard as it sounds when they're recorded as a single global use count per
slot, as your original code does.  When you mentioned a "your allocation is
available" callback, I was thinking it might come to that being called
inside context switch.  It's all rather tricky, indeed.  

The obvious answer is to start simple.  If any user process anywhere uses
drN, kwatch has to give it up for all CPUs (watchpoints with less than
"break ptrace" priority do).  If anyone really cares about more flexibility
than that, we can change or extend it.  Some copious comments in the
interface descriptions can lead them in the right direction if the
situation comes up.  Probably with systemtap support in a while, we'll get
a lot more concrete uses of watchpoints and people finding out what really 
matters to them.


Thanks,
Roland

