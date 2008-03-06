Return-Path: <linux-kernel-owner+w=401wt.eu-S1765473AbYCFL6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765473AbYCFL6F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:58:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762614AbYCFL5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 06:57:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757938AbYCFL5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 06:57:47 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 2/2] __group_complete_signal: fix? signal load-balancing
In-Reply-To: Oleg Nesterov's message of  Thursday, 6 March 2008 01:43:21 +0300 <20080305224321.GA6345@tv-sign.ru>
References: <20080305224321.GA6345@tv-sign.ru>
X-Windows: the art of incompetence.
Message-Id: <20080306115710.186322700FD@magilla.localdomain>
Date: Thu,  6 Mar 2008 03:57:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The comment says about load-balancing, but this is not what happens?
> Suppose that wants_signal(signal->curr_target) == T. In that case we
> always choose the same ->curr_target thread. Isn't it better to try
> to "spread" the signals over the thread group?

The "load balancing" stuff was in the old multithreaded signals code (2.5)
from before I rearranged a lot of code to fix the main parts of the MT
semantics.  Maybe it was Ingo who originally put that code in?  I moved
everything around it to change the deterministic semantics, but I never
really gave any thought to the "performance feature".  Perhaps it did
something different to begin with and bit-rot made it into the algorithm we
have that seems not so optimal .

The current behavior hammers all the unblocked signals onto one thread
until it's scheduled out.  For getting the signal delivered as quickly as
can be, it makes some sense to choose running threads (task_curr) over
threads blocked without signals already pending.  So perhaps the same
thread that just ran a signal handler (maybe is still setting it up) really
is the preferable choice when it's on the CPU--at least in comparison to
another candidate thread that is not on a CPU.  But it's not exactly doing
"load balancing".  If several threads are running on CPUs, presumably it's
intended to spread several near-simultaneous signals across those CPUs.

Perhaps Ingo has some thoughts on what the original plan is, or on what
desireable performance choices are now.

> With this patch we are trying to find another suitable thread starting
> from next_thread(signal->curr_target), thus distributing the load over
> the whole thread group.

If we're cleaning up, we can start by getting rid of the NULL check.
There's no reason to have it in this hot path.  It should never come
up if we make copy_signal initialize sig->curr_target = tsk.
Then just:

		t = p->signal->curr_target;
		while (!wants_signal(sig, (t = next_thread(t)))) {
			if (t == p->signal->curr_target)
				/*
				 * No thread needs to be woken.
				 * Any eligible threads will see
				 * the signal in the queue soon.
				 */
				return;
		}
		p->signal->curr_target = t;

> Bad idea? If not, probably we can also remove the "if (wants_signal())"
> at the top of __group_complete_signal() ?

I don't think we should change that special case, or at least not soon.
The initial thread always takes the signal if it's not busy.  It's now,
and always has been, deterministic that in a slow steady situation with
no races, no signals blocked anywhere and no other signals sent but one
SIGALRM every hour, the handler always runs in the main thread.  Now if
you change this, it will round-robin among the threads in the process.
There aren't supposed to be any guarantees about this, any eligible
thread running the handler is kosher.  But like the comment there now
says, "least surprising".


Thanks,
Roland
