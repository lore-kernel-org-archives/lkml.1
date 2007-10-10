Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbXJJLvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbXJJLvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 07:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbXJJLvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 07:51:06 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:59972 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbXJJLvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 07:51:05 -0400
Date: Wed, 10 Oct 2007 07:50:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Kravetz <kravetz@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: -rt more realtime scheduling issues
Message-ID: <20071010115052.GA21391@goodmis.org>
References: <20071006021548.GE4587@monkey.ibm.com> <20071008184523.GA29656@monkey.ibm.com> <20071009030412.GB12915@goodmis.org> <20071009184953.GA3285@monkey.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071009184953.GA3285@monkey.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 11:49:53AM -0700, Mike Kravetz wrote:
> The more I try understand the IPI handling the more confused I get. :(
> At fist I was concerned about an IPI happening in the middle of the
> __schedule routine.  But, then it occurred to me that interrupts are
> disabled when in this routine (when holding the runqueue lock).  So, IPIs
> are not delivered during __schedule processing.  Right?
> 
> But, if this is case then I don't understand the following code in
> schedule():
> 
>         local_irq_disable();
> 
>         do {
>                 __schedule();
>         } while (unlikely(test_thread_flag(TIF_NEED_RESCHED) ||
>                           test_thread_flag(TIF_NEED_RESCHED_DELAYED)));
> 
>         local_irq_enable();
> 
> How can the reschedule flags possibly be set AFTER running __schedule.
> Especially when the call is explicitly surrounded by local_irq_disable/
> local_irq_enable.
> 
> Can someone help me?
> 

Sure, another CPU can set the tasks NEED_RESCHED flag. In try_to_wake_up,
if the process that is waking up is on a runqueue on another CPU and it
is of higher priority than the current running task, the process that is
doing the waking will set the NEED_RESCHED flag for that task.

So to prevent a race where we have called schedule and after getting to
the new running task, a higher priority process just got scheduled in,
we will catch that here.

Now if this is really needed? I don't know. It seems that it just wants
to check here so we don't need to jump to the interrupt and then
schedule while coming back out of the interrupt handler as a preemption
schedule. This way we just schedule again and save a little overhead
from doing that through the interrupt.

But this brings up an interesting point. Since the IRQ handlers are run
as threads, and the interrupt is what will wake them, this seems to add
a bit of latency to interrupts.

For example:

  We schedule in process A of prio 1

  before exiting __schedule process B is woken up on that same rq
  with a prio of 2 and sets A's NEED_RESCHED flag.

  Also an interrupt goes off and sent to this CPU. But since interrupts
  are disabled, we wait.

  leaving __schedule() we see that A's NEED_RESCHED flag is set, so we
  continue the do while loop and call __schedule again.

  We schedule in B of prio 2.

  Leave __schedule as well as the do while loop and then enable
  interrupts.

  The interrupt that was pending is now triggered.

  Wakes up the handler of prio 90 and since it is higher in priority
  than process B of prio 2 it sets B's NEED_RESCHED flag.

  On return from the interrupt we call schedule again.

This seems strange. I can imagine on a large # of CPUs box that this can
happen quite often, and have the interrupts disabled for several rounds
through schedule.

I say we ax that while loop.

Ingo?

-- Steve

