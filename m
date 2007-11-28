Return-Path: <linux-kernel-owner+w=401wt.eu-S1760370AbXK1BzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760370AbXK1BzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 20:55:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbXK1Byu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 20:54:50 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38550 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbXK1Byt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 20:54:49 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrea Arcangeli <andrea@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jack@suse.cz, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: /proc dcache deadlock in do_exit
References: <20071127132022.GW6840@v2.random>
	<20071127143852.601509ac.akpm@linux-foundation.org>
	<20071128012129.GD6840@v2.random>
Date: Tue, 27 Nov 2007 18:53:29 -0700
In-Reply-To: <20071128012129.GD6840@v2.random> (Andrea Arcangeli's message of
	"Wed, 28 Nov 2007 02:21:29 +0100")
Message-ID: <m1ve7ngmp2.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli <andrea@suse.de> writes:

> On Tue, Nov 27, 2007 at 02:38:52PM -0800, Andrew Morton wrote:
>> I don't see why the schedule() will not return?  Because the task has
>> PF_EXITING set?  Doesn't TASK_DEAD do that?
>
> Ouch, I assumed you couldn't sleep safely anymore in release_task
> given it's the function that will free the task structure itself and
> there was no preempt related action anywhere close to it!
> delayed_put_task_struct can be called if a quiescent point is reached
> and any scheduling would exactly allow it to run (it requires quite a
> bit of a race, with local irq triggering a reschedule and the timer
> irq invoking the tasklet to run to free the task struct before do_exit
> finishes and all other cpus in quiescent state too).
>
> So a corollary question is how can it be safe to call
> preempt_disable() after call_rcu(delayed_put_task_struct)?


> Back in sles9 preempt_disable was implemented as
> _raw_write_unlock(&tasklist_lock) and it happened _before_
> release_task, and scheduling there wouldn't return because PF_DEAD was
> already set. If mainline can come back, it will crash for a different
> reason because the task struct is long gone by the time
> release_task+schedule() runs. Either ways, still a kernel crashing bug
> there is. Or is there some magic that prevents call_rcu + schedule to
> invoke the rcu callback?

I don't quite see where it comes from but there is another reference
on the task struct held by the scheduler  That we don't drop until
finish_task_switch with exit_state == TASK_DEAD.

So since we have one additional reference the task_struct won't
get freed.

We don't set TASK_DEAD until much later.

> So you may need to apply this one too (this one is needed to fix the
> second bug, my previous patch is needed after applying this one):

No.  We should be fine.

In fact it looks like this is just a sles9 issue and mainline is
fine, as we can safely schedule until just before the end of do_exit.

Eric
