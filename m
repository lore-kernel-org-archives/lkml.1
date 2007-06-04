Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbXFDUeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbXFDUeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbXFDUd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:33:57 -0400
Received: from gw.goop.org ([64.81.55.164]:56906 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbXFDUd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:33:56 -0400
Message-ID: <4664772A.20602@goop.org>
Date: Mon, 04 Jun 2007 13:33:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Virtualization Mailing List <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [PATCH] xen: use iret directly where possible
References: <46646662.9020707@goop.org> <200706042145.30339.ak@suse.de>
In-Reply-To: <200706042145.30339.ak@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Not sure what a recursive exception is. You mean the interrupt?
>   

Yeah, though Xen calls them events, so I chose a completely different
third term.

> It looks ...very... ug^w^wcomplicated.
>   

I suppose, but you should look at the xen-unstable code by comparison...

But either way, the alternative is to always use the iret hypercall,
which effectively doubles the cost of entering and exiting the kernel,
so I think the extra code is worth it.

>>  - If the interrupt causes a softirq to be queued, we will return to
>>    userspace without processing it, since its already after the point at
>>    which we look for queued softirqs.  This means it could be an
>>    unbounded amount of time before it gets processed on next kernel
>>    entry.
>>     
>
> That doesn't make sense. softirqs get processed after interrupts,
> not on return to user space. So the nested interrupt should handle
> its own softirqs because the softirq counters are already decreased.
>   

Hm, yes, I guess so.  I'd assumed that softirq was in the WORK_NEEDED
path of entry.S without checking; but anything which can set one of the
WORK_NEEDED flags is an issue.

>>  - If the interrupt causes a signal to be delivered to the current process,
>>    the signal will be marked pending on the process, but it will not
>>    get delivered because we're past the point where pending signals
>>    are detected.  Again, it could be an unbounded amount of time
>>    before the signal gets delivered.
>>     
>
> It's still not clear to me why you can't do cli ; check again ; iret-equivalent
> to handle this.
>   

Well, we use the real iret instruction to actually transition into
userspace; obviously we can't do anything after that, and there's always
going to be an open window before it because we can't do anything
instruction-level atomic.

In your sequence, the event may become pending after "check again", even
though it won't be delivered.  And either way, we need to set the proper
event mask state before using "iret", so there's still a race where a
recursive interrupt could happen.

In other words, consider this hypothetical sequence:

   1. start with events masked
   2. check for pending -> handle if so
   3. unmask events
   4. check for pending -> handle if so
   5. iret

There's always a window after "check for pending" where a new event can
become pending.  If it happens between 2 & 3, then we miss it at 2; if 4
isn't done, we end up returning to userspace with a pending event.  That
is, 2 is insufficient on its own, and redundant when 4 is in place, so
there's no point in testing for pending while events are still masked.

If we do the check at 4, then there's a window at 4-5 where we can get a
recursive event/interrupt.   If that happens, then the nested interrupt
save nested register state on the stack.  At it leaves the nested
interrupt it will notice that its returning to kernel mode, and won't
bother testing any of the WORK_NEEDED flags, and it will end up
returning to just before the iret in step 5.  This will simply return to
usermode directly without re-testing the WORK_NEEDED flags, leaving them
set until the process enters and leaves the kernel again, possibly an
unbounded amount of time later.

(Despite the recursion window, the test at 4 is always necessary to mop
up any previously pending events from before step 1.)

This patch short-circuits this by noticing that there's a recursive
event in the 4-5 window, and just folds the recursive frame into the
current one and jumps back into interrupt handling, meaning that all the
work flags will be re-processed as it comes out again.

>>  - The recursion is, in theory, unbounded.  There's a small chance that
>>    a series of unfortunate events will cause the exception frames to
>>    build up and overrun the stack.  But that's very unlikely.
>>     
>
> Doesn't seem to be different to me than a normal interrupt anywhere
> else. If you're worried about overflow use interrupt stacks.
>   

No, I don't think this is really a concern at all.  But it was the only
rationale listed by the original Xen implementation.  I wasn't going to
bother with the critical region stuff at all, but I think the
signal/WORK_NEEDED issue is worth plugging.  Besides, if we were in that
situation, this patch just converts the stack overrun into a livelock,
which isn't much of an improvement.

    J
