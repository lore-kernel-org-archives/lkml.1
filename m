Return-Path: <linux-kernel-owner+w=401wt.eu-S1762106AbYCGDOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762106AbYCGDOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 22:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756488AbYCGDOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 22:14:07 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:46568 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196AbYCGDOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 22:14:06 -0500
Date: Fri, 7 Mar 2008 06:13:24 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 2/2] __group_complete_signal: fix? signal load-balancing
Message-ID: <20080307031324.GA214@tv-sign.ru>
References: <20080305224321.GA6345@tv-sign.ru> <20080306115710.186322700FD@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306115710.186322700FD@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06, Roland McGrath wrote:
>
> > The comment says about load-balancing, but this is not what happens?
> > Suppose that wants_signal(signal->curr_target) == T. In that case we
> > always choose the same ->curr_target thread. Isn't it better to try
> > to "spread" the signals over the thread group?
>
> The "load balancing" stuff was in the old multithreaded signals code (2.5)
> from before I rearranged a lot of code to fix the main parts of the MT
> semantics.  Maybe it was Ingo who originally put that code in?  I moved
> everything around it to change the deterministic semantics, but I never
> really gave any thought to the "performance feature".  Perhaps it did
> something different to begin with and bit-rot made it into the algorithm we
> have that seems not so optimal .
>
> The current behavior hammers all the unblocked signals onto one thread
> until it's scheduled out.  For getting the signal delivered as quickly as
> can be, it makes some sense to choose running threads (task_curr) over
> threads blocked without signals already pending.  So perhaps the same
> thread that just ran a signal handler (maybe is still setting it up) really
> is the preferable choice when it's on the CPU--at least in comparison to
> another candidate thread that is not on a CPU.  But it's not exactly doing
> "load balancing".  If several threads are running on CPUs, presumably it's
> intended to spread several near-simultaneous signals across those CPUs.
>
> Perhaps Ingo has some thoughts on what the original plan is, or on what
> desireable performance choices are now.

OK, thanks, please ignore this patch (it was more the question anyway).

So. currently the meaning of->curr_target is: remember the last thread
we sent a signal, may help to avoid iterating over the thread group when
the next signal is sent.

> If we're cleaning up, we can start by getting rid of the NULL check.
> There's no reason to have it in this hot path.  It should never come
> up if we make copy_signal initialize sig->curr_target = tsk.

Can't understand why I didn't realize this while reading the code.
Looks like a reasonable cleanup regardless.

Oleg.

