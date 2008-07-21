Return-Path: <linux-kernel-owner+w=401wt.eu-S1757301AbYGUAsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbYGUAsN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbYGUAr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:47:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577AbYGUAr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:47:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Mark McLoughlin <markmc@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] posix-timers: Do not modify an already queued timer signal
In-Reply-To: Oleg Nesterov's message of  Sunday, 20 July 2008 15:08:56 +0400 <20080720110856.GC143@tv-sign.ru>
References: <1216219846-663-1-git-send-email-markmc@redhat.com>
	<20080716162131.GA1785@tv-sign.ru>
	<1216292911.28332.12.camel@muff>
	<20080717135556.GA770@tv-sign.ru>
	<1216377558.12300.13.camel@muff>
	<20080719163734.GA389@tv-sign.ru>
	<20080720065240.B3D3715421D@magilla.localdomain>
	<20080720110856.GC143@tv-sign.ru>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080721004722.5869515421D@magilla.localdomain>
Date: Sun, 20 Jul 2008 17:47:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, thanks, I see. But does it have any meaning for the user-space?
[si_sys_private]

No, it's not part of the user ABI.  It's not even copied out (see
copy_siginfo_to_user).  (A spare siginfo_t field was just used as a handy
bit of storage in the signal queue element.  It's a kludge.)

> Let me repeat. Can't we make a simple fix for now for this nasty and
> ancient bug, before we do the more clever changes,

Probably.  I don't find it easy to be sure there aren't more bad
problems caused by trying to re-send the same sigqueue entry.

You do need to clear si_overrun there to be correct in the usual case
(not already queued).  The fields set explicitly in posix_timer_event,
plus si_overrun, are the only meaningful fields for SI_TIMER (again see
copy_siginfo_to_user).  The memset is already superfluous.

It would be a perfectly fine and worthwhile optimization/cleanup on its
own just to move all the initialization of sigq->info (everything but
si_sys_private) to alloc_posix_timer.  That would also happen to mask
the symptom of this double-queuing problem that's been observed.

Even if it's a fine stopgap, I'm not comfortable calling this a real "fix".
It seems likely this is the good choice for the stable branch.

> Suppose that the signal was already dequeued but sigq->info wasn't copied
> to the user-space. The thread which does dequeue_signal() unlocked siglock
> and waits for ->it_lock.

This is fine.  sigq->info is copied into a local (kernel stack) copy in
collect_signal(), i.e. inside dequeue_signal() long before the unlock.
In short, once __dequeue_signal() returns, the signal goes from "queued"
to "delivered".  The delivery is on its way to happening, and from the
instant that thread released the siglock it's no different from if it
had completed handler setup, returned to user, and had a long scheduling
delay before actually executing the first user instruction.  At this
point, any other event is not "racing", it's just "after".

> posix_timer_event() sees list_empty(), proceeds and calls send_sigqueue().
> Now we requeue this ->sigq instead of incrementing si_overrun.

It's not "requeue".  It's "queue" after it was no longer queued, with
semantics no different from the first time you queue it.

> The thread which does dequeue_signal() continues and re-schedules the
> timer while ->sigq is queued. Then it copies sigq->info to the user space.

The thread that dequeued the first timer signal had ceased all reference
to sigq by the time it unlocked siglock.  When its do_schedule_next_timer
call gets it_lock, it can do bookkeeping in struct k_itimer to figure out
what posix_timer_event or timer_settime has done lately.  (Like I said,
the ->fired flag alone might not really cover all the angles.  I was
expecting you to figure out the exactly details for me. ;-)

> While we are here, off-topics question. 

You know I hate those.  We aren't here.  We're in chairs reading email.
We'll be in the same places if you send a separate message for a separate
topic.

> Is it really useful to convert the SIGEV_THREAD_ID timer to the group-wide
> timer when the thread dies?

Not really.  I think the main intent there is just to be sure we never
hold on to an old task_struct pointer (which might have been the bug in
the past).


Thanks,
Roland
