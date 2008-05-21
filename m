Return-Path: <linux-kernel-owner+w=401wt.eu-S934746AbYEUMzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934746AbYEUMzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 08:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbYEUMzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 08:55:39 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:38959 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594AbYEUMzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 08:55:38 -0400
Date: Wed, 21 May 2008 15:54:14 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] signals: sigqueue_free: don't free sigqueue if it is queued
Message-ID: <20080521115414.GA147@tv-sign.ru>
References: <20080517151420.GA9496@tv-sign.ru> <20080521022046.1501F26FA1C@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521022046.1501F26FA1C@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20, Roland McGrath wrote:
>
> > This patch doesn't change the behaviour of sys_timer_delete() and friends,
> > just makes it more correct and allows us to introduce other SIGQUEUE_ flags
> > passed to the receiver.
>
> To clarify, this certainly does change the behavior.
> There are two changes.
>
> Firstly, a pending timer-firing signal currently gets its siginfo_t
> zeroed out synchronously by timer_delete and now will have its info
> preserved.  That change alone is a potential problem for userland, so
> it should not go in without the following changes to prevent userland
> from seeing the signal at all.  (Currently userland may see a spurious
> signal, but its si_code and si_value don't indicate a timer firing.
> With the correct info, userland might try to use a pointer from
> si_value that was freed around the time it called timer_delete.)

Yes, yes, I meant doesn't change the behaviour in a sense that the
signal is still "visible" to the application.

> Second, a pending timer-firing signal currently stops counting towards
> the RLIMIT_SIGPENDING limit immediately upon a timer_delete call and
> now will keep counting toward that limit until it gets dequeued and
> discarded.  This change is not necessarily a problem.  (POSIX does not
> specify how we decide when resources are too short to create a new
> timer or queue a signal.)  But it deserves mention somewhere.
> Applications can just get fixed to always unblock the signal number or
> flush old signals out with sigwait, if they are averse to timer
> signals with intact siginfo_t arriving after timer_delete.

Yes, thanks, I didn't think about this.

> For this reason, I don't think this set of changes should be
> considered for any -stable branch.

Yes sure.


> > 	q->flags |= SIGQUEUE_CANCELLED;
> > 	spin_lock_irqsave(lock, flags);
> > 	q->flags &= ~SIGQUEUE_PREALLOC;
>
> Just make it:
>
> 	spin_lock_irqsave(lock, flags);
> 	q->flags |= SIGQUEUE_CANCELLED;
> 	q->flags &= ~SIGQUEUE_PREALLOC;
>
> and we needn't wax philosophical about the meaning of locking rules.  That
> patch would have my ACK, but I concur with Linus about the undesireability
> of the plain = version.

OK, will do tomorrow, but...

Oh well. I just realized SIGQUEUE_CANCELLED breaks sys_sigpending() ?

Oleg.

