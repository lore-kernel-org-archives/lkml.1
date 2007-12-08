Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbXLHXwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbXLHXwY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 18:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbXLHXwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 18:52:17 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50514 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbXLHXwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 18:52:16 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] will_become_orphaned_pgrp: we have threads
References: <20071208183800.GA9940@tv-sign.ru>
Date: Sat, 08 Dec 2007 16:50:04 -0700
In-Reply-To: <20071208183800.GA9940@tv-sign.ru> (Oleg Nesterov's message of
	"Sat, 8 Dec 2007 21:38:00 +0300")
Message-ID: <m11w9wpx03.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> p->exit_state != 0 doesn't mean this process is dead, it may have sub-threads.
>
> However, the new "p->exit_state && thread_group_empty(p)" check is not correct
> either, this is just the temporary hack. Perhaps we can just remove this check,
> but I don't understand orphaned process groups magic. At all. However, I think
> exit_notify() is obviously and completely wrong wrt this helper.

The problem that orphaned processes groups address is what happens if
an entire process group is stopped, and there is not a process that
can wake them up.

The rule for an unprivileged process sending a signal to a process
group is that it must be in the same session as the process group.

The rule for sending a signal to a process group is that the signal sender
must be in the same session.

So we are testing for a process group that does not have a living
member with a parent outside of the process that can send the process
group a signal.

The test for init seems bogus.  /sbin/init rarely if ever starts
processes in it's own session which is likely why this has not caused
problems.  If we keep the test for init we need to make the test
is_container_init rather the is global_init.

As for exit_notify I agree.  We need a thread_group_exit_notify.
That is responsible for performing work when we know the entire
thread group has exited.  Sending the exit_signal and performing
the through group orphaned check look like two of those tasks
that need to be performed only at thread group exit.

Oleg what do you see wrong with checking p->exit_state &&
thread_group_empty(p)?   Since non-leader threads all self reap
that seems to be a valid test for an dead thread group.

Eric


> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
>
> --- PT/kernel/exit.c~4_orphaned_pgrp	2007-12-06 18:06:09.000000000 +0300
> +++ PT/kernel/exit.c	2007-12-07 20:25:40.000000000 +0300
> @@ -219,9 +219,9 @@ static int will_become_orphaned_pgrp(str
>  	int ret = 1;
>  
>  	do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
> -		if (p == ignored_task
> -				|| p->exit_state
> -				|| is_global_init(p->real_parent))
> +		if ((p == ignored_task) ||
> +		    (p->exit_state && thread_group_empty(p)) ||
> +		    is_global_init(p->real_parent))
>  			continue;
>  		if (task_pgrp(p->real_parent) != pgrp &&
>  		    task_session(p->real_parent) == task_session(p)) {
