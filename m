Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbZBCWbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbZBCWbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 17:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbZBCWbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 17:31:06 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56294 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbZBCWbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 17:31:04 -0500
Date: Tue, 3 Feb 2009 23:28:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: do_each_pid_task() needs rcu lock
Message-ID: <20090203222803.GA31756@redhat.com>
References: <20090203193904.GA23695@redhat.com> <20090203194214.GA23703@redhat.com> <m1fxivw673.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1fxivw673.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > On 02/03, Oleg Nesterov wrote:
> >>
> >> "ftrace: use struct pid" commit 978f3a45d9499c7a447ca7615455cefb63d44165
> >> converted ftrace_pid_trace to "struct pid*". But we can't use
> >> do_each_pid_task() without rcu_read_lock() even if we know the pid
> >> itself can't go away (it was pinned in ftrace_pid_write). The exiting
> >> task can detach itself from this pid at any moment.
> >
> > Q: why do we use do_each_pid_task(PIDTYPE_PID) ? We can never have more
> > than 1 task in the loop. Perhaps,
>
> That is a bug in do_each_pid_task(PIDTYPE_PID).
> For ftrace we really want to grab all tasks with a given pid even
> in the crazy exec case.

Yes, I thought about de_thread() too. But we can't "fix" do_each_pid_task()
to avoid the race?

IOW. If we want to continue to trace the task with the same pid after
exec reliably, then we should do something like

	void ftrace_transfer_trace(struct task_struct *leader)
	{
		mutex_lock(&ftrace_start_lock);
		if (test_tsk_trace_trace(leader))
			set_tsk_trace_trace(current);
		mutex_unlock(&ftrace_start_lock);
	}

and, in de_thread,

		write_unlock_irq(&tasklist_lock);
	+
	+	ftrace_transfer_trace(leader);
	+
		release_task(leader);

No?

(the above is not right of course, we can race with clear_ftrace_pid(),
 just for illustration)

Oleg.

