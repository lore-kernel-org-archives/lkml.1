Return-Path: <linux-kernel-owner+w=401wt.eu-S1758480AbZBEP6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480AbZBEP6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 10:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbZBEP6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 10:58:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49189 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbZBEP6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 10:58:20 -0500
Date: Thu, 5 Feb 2009 16:54:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] posix-cpu-timers: use ->sighand instead of
	->signal to check the task is alive
Message-ID: <20090205155454.GD20953@redhat.com>
References: <20090203231717.GA5028@redhat.com> <20090205033120.2294BFC381@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205033120.2294BFC381@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04, Roland McGrath wrote:
>
> > It doesn't matter which pointer to check under tasklist to ensure the task
> > was not released, ->signal or ->sighand. But we are going to make ->signal
> > refcountable, change the code to use ->sighand.
>
> I haven't been following what that's about (signal_struct already has two
> atomic counts!).

We can't use them as refcounts. You can't bump ->live or ->count without
breaking group_dead or exec logic. Perhaps we can use ->count, but then
we need other changes. But this has nothing to do with this patch.

The goal is to keep task->signal after release_task(), it will be freed
by __put_task_struct(). This allows a lot of simplifications and we can
move some fields from task_struct to signal_struct.

But first we should change the code which does

	lock(tasklist);
	if (task->signal != NULL)
		/* Great! the task was not released */
		do_something(task);

This patch does not change the current behaviour, but makes possible
to change the "scope" of ->signal without breaking the current code.

> Uses here protecting cpu_clock_sample_group() e.g., are
> around looking at ->signal->foobar, so if ->signal is still there, why not
> look at it and be able to get the sample in whatever small window this is?

What if arm_timer() sees ->signal != NULL, proceeds, and attaches the
timer to the signal_struct of the already dead task? This signal_strcut
will be released with the pending timer.

Even cpu_clock_sample_group() is not safe, unless we add other changes.

> I don't really understand what this new case might mean though.  Most
> things that look at ->signal need to lock it, so access doesn't make any
> sense if there is no siglock because ->sighand is clear while ->signal is not.

For example. __sched_setscheduler() needs to read a single word,
signal->rlim[RLIMIT_RTPRIO].rlim_cur, but it has to lock ->siglock
to access ->signal.

Worse. Please look at __exit_signal()->task_rq_unlock_wait(). This hack
is absolutely stupid and mmust die.


But in any case. Even if we don't need the further changes, do you
agree this patch is correct and doesn't change the behaviour?

Oleg.

