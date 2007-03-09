Return-Path: <linux-kernel-owner+w=401wt.eu-S2993015AbXCIGwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993015AbXCIGwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 01:52:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993016AbXCIGwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 01:52:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993015AbXCIGwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 01:52:12 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
X-Fcc: ~/Mail/utrace
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: Alan Stern's message of  Wednesday, 7 March 2007 14:11:00 -0500 <Pine.LNX.4.44L0.0703071127530.6624-100000@iolanthe.rowland.org>
X-Zippy-Says: I'm having a RELIGIOUS EXPERIENCE..  and I don't take any DRUGS
Message-Id: <20070309065203.3A81A180063@magilla.sf.frob.com>
Date: Thu,  8 Mar 2007 22:52:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> That sounds like a rather fragile approach to avoiding a minimal amount of 
> work.  Debug exceptions don't occur very often, and when they do it won't 
> matter too much if we go through some extra notifier-chain callouts.

When single-stepping occurs it happens repeatedly many times, and that
doesn't need any more overhead than it already has.  

> It turns out that this won't work correctly unless I use something
> stronger, like a spinlock or RCU.  Either one seems like overkill.

What is the problem with just clearing TIF_DEBUG?  It just means that in
the SIGKILL case, the dying thread won't switch in its local debugregs.
The global kernel allocations will already be set in the processor from the
previous context, and old user-address allocations do no harm since we
won't run in user mode again before switching out at the end of do_exit.

> Is there any way to find out from within the
> switch_to_thread_hw_breakpoint routine whether the task is in this unusual
> state?  (By which I mean the task is being debugged and the debugger
> hasn't told it to start running.)  Would (tsk->exit_code == SIGKILL) work?  

That won't necessarily work.  There isn't any cheap check that won't also
catch a task preempted on its way to stopping for the debugger.  

> If not, can we add a TIF_DEBUG_STOPPED flag?  

I'm not clear on what that would mean, but it's probably not an idea I like.

> Or should I just go with a spinlock?

If it's really necessary, but it hasn't proved so for any other switched
per-thread state.  As long as you aren't doing per-thread kernel-mode
allocations, I don't see why you need anything other than TIF_DEBUG.

> Is SIGKILL the only way this can happen?

It should be, but there might be some stray wake_up_process calls in the
kernel that can violate [up]trace's supposed monopoly on TASK_TRACED (or
duopoly with SIGKILL, I suppose I should say).  If there is no SIGKILL,
then the task will just call schedule again nearly immediately to go back
to blocking, which will switch out unless there is a second wakeup right
then.

> In a similar vein, I need a reliable way to know whether a task has gone 
> through exit_thread().  If it has, then its hw_breakpoint area has been 
> deallocated and a new one must not be allocated.  Will (tsk->flags & 
> PF_EXITING) always be true once that happens?

PF_EXITING it set after there is no possibility of returning to user mode,
but a while before exit_thread, when you might still want kernel-mode
breakpoints.  If the only per-thread allocations you support are for user
mode, then you can certainly refuse to do any when PF_EXITING is set.


Thanks,
Roland

