Return-Path: <linux-kernel-owner+w=401wt.eu-S937259AbYEUUJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937259AbYEUUJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936303AbYEUUJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:09:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936154AbYEUUJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:09:32 -0400
Date: Wed, 21 May 2008 13:07:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] signals: sigqueue_free: don't free sigqueue if it
 is queued
In-Reply-To: <20080521193348.64E8C26FA24@magilla.localdomain>
Message-ID: <alpine.LFD.1.10.0805211245131.3081@woody.linux-foundation.org>
References: <20080517151420.GA9496@tv-sign.ru> <20080521022046.1501F26FA1C@magilla.localdomain> <20080521115414.GA147@tv-sign.ru> <20080521184245.5BABF26FA24@magilla.localdomain> <alpine.LFD.1.10.0805211146350.3081@woody.linux-foundation.org>
 <20080521193348.64E8C26FA24@magilla.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 21 May 2008, Roland McGrath wrote:
> 
> Removing the entry without fixing the pending set is the bug we're trying
> to fix.  That's what it does now, and it's wrong.

Well, I think we could/should look at the bigger picture.

The whole (and only!) reason for this problem in the first place is that 
the generic signal-handling code is simply not designed for signals going 
away. Because they simply don't. This whole sys_timer_delete() thing is 
purely based on that problem.

So we have a few options here, I think.

One is the approach that Oleg has taken, which is to try to remove the 
signals. Quite frankly, I don't much like it, because it's against all the 
normal signal handler behaviour. And being against all the normal signal 
handler behaviour, it violates the assumptions we have about signals being 
sticky, which is why it then has problems with both the task sigpending 
bit and the per-signal pending bits.

We can continue with that approach, but judging by the issues, I suspect 
it basically involves having to do back-pointers from the signal info to 
the queues they are on, and even then we'd always have the issues with 
code that simply assumes that signals are sticky. The simple fact is, we 
have lots of system call code that does

	if (signal_pending())
		return -ERESTARTNOHAND;

etc, so even if we don't actually *take* the signal, a cancelled signal 
would still result in a spurious restart or worse - an EINTR.

But there are other approaches. For example, afaik, this really is more 
about execve() than about anything else. How about we just do a special 
case in "flush_signal_handlers()" - rather than try to make it an issue of 
releasing the POSIX timer.

We know those posix timer things are special. We know they go away at 
execve() time. There's this unlucky race condition that only happens at 
execve time, and only because we must flush the pending signal handlers in 
a way that we normally *don't* flush any other signals.

So we could easily make the POSIX timer code just mark the signals it 
sends, and then at execve() time (in "flush_signal_handlers()") we walk 
the signal queues of that thread and get rid of those signal entries.

And at *that* point it is trivial to clear re-calculate the pending bit 
entirely for that thread, because we know there is nothing else going on.

But doing it in general, when there may be multiple active threads, and 
one of them does an "timer_delete()" system call, that's actually hard. 
The other threads may be doing other things, and may validly have that 
timer pending.

Hmm?

I bet there are other approaches to this. But I think "sigqueue_free()" is 
fundamentally hard to fix to do what we want to do, without making signals 
do something that they normally don't have to do.

		Linus
