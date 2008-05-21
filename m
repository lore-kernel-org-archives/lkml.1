Return-Path: <linux-kernel-owner+w=401wt.eu-S933676AbYEUCVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676AbYEUCVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 22:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756517AbYEUCVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 22:21:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755682AbYEUCVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 22:21:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] signals: sigqueue_free: don't free sigqueue if it is queued
In-Reply-To: Oleg Nesterov's message of  Saturday, 17 May 2008 19:14:20 +0400 <20080517151420.GA9496@tv-sign.ru>
References: <20080517151420.GA9496@tv-sign.ru>
X-Shopping-List: (1) Silent ignition inquisitions
   (2) Methodical pajamas
   (3) Ominous derision promotions
   (4) Bestial coolants
Message-Id: <20080521022046.1501F26FA1C@magilla.localdomain>
Date: Tue, 20 May 2008 19:20:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Currently sigqueue_free() removes sigqueue from list, but doesn't cancel the
> pending signal. This is not consistent, the task should either receive the
> "full" signal along with siginfo_t, or it shouldn't receive the signal at all.

Agreed.

> Change sigqueue_free() to clear SIGQUEUE_PREALLOC but leave sigqueue on list
> if it is queued.
> 
> This patch doesn't change the behaviour of sys_timer_delete() and friends,
> just makes it more correct and allows us to introduce other SIGQUEUE_ flags
> passed to the receiver.

To clarify, this certainly does change the behavior.  
There are two changes.  

Firstly, a pending timer-firing signal currently gets its siginfo_t
zeroed out synchronously by timer_delete and now will have its info
preserved.  That change alone is a potential problem for userland, so
it should not go in without the following changes to prevent userland
from seeing the signal at all.  (Currently userland may see a spurious
signal, but its si_code and si_value don't indicate a timer firing.
With the correct info, userland might try to use a pointer from
si_value that was freed around the time it called timer_delete.)

Second, a pending timer-firing signal currently stops counting towards
the RLIMIT_SIGPENDING limit immediately upon a timer_delete call and
now will keep counting toward that limit until it gets dequeued and
discarded.  This change is not necessarily a problem.  (POSIX does not
specify how we decide when resources are too short to create a new
timer or queue a signal.)  But it deserves mention somewhere.
Applications can just get fixed to always unblock the signal number or
flush old signals out with sigwait, if they are averse to timer
signals with intact siginfo_t arriving after timer_delete.

For this reason, I don't think this set of changes should be
considered for any -stable branch.


Thanks,
Roland
