Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbYFAQ2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbYFAQ2T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 12:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbYFAQ2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 12:28:06 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:53818 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbYFAQ2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 12:28:03 -0400
Date: Sun, 1 Jun 2008 20:29:42 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] kill_something_info: don't take tasklist_lock for pid==-1 case
Message-ID: <20080601162942.GA8254@tv-sign.ru>
References: <47E87F2A.2040303@bk.jp.nec.com> <20080325135645.GA96@tv-sign.ru> <m18wy45nej.fsf@frodo.ebiederm.org> <20080531165525.GA5575@tv-sign.ru> <m1hccexc4b.fsf@frodo.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hccexc4b.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31, Eric W. Biederman wrote:
>
> We can read old next values when walking the task list under the rcu
> lock.  So I don't believe we are guaranteed to see additions that
> happen while we hold the rcu lock.
>
> If a new process spawns, passes the check for the parent having the
> signal, the signal is delivered the signal, and then appends to the
> task list.  We might miss it.  I'm not certain, but that feels right.

I don't think we can miss it. To simplify, let's consider kill(-1, SIGKILL)
and the forking process is P.

When P forks, copy_process() adds the child to the end of the init_task.tasks
list under ->siglock.

When kill_something_info()->group_send_sig_info(P) suceeds, we must see the
child, because we locked the same ->siglock and thus we have the necessary
barrier. (more precisely, we must see the new next values once we locked
->siglock). And P can't fork again.

Yes, kill(-1, /*say*/ SIGCONT) is different, we can miss the child which was
forked _after_ P has recieved/handled the signal, but probably this is OK,
we can pretend it was forked after kill(-1) has returned.


The more interesting case: P forks and exits _before_ we send the signal
to it. Can we miss the child? I don't think so, but I'm not sure.
fork() + exit() means list_add_rcu() + wmb() + list_del_rcu().

If we see the result of list_del_rcu() (ie, we don't see P on list), we
must see the result of list_add_rcu(), because of smp_read_barrier_depends()
in next_task().

But again, I'm not sure.

> > However, I think this patch adds another subtle race which I missed before.
> >
> > Let's suppose that the task has two threads, A (== main thread) and B. A has
> > already exited, B does exec.
> >
> > In that case it is possible that (without tasklist_lock) kill_something_info()
> > sends the signal to the old leader (A), but before group_send_sig_info(A)
> > takes ->siglock B switches the leader and does release_task(A). In that
> > group_send_sig_info()->lock_task_sighand() fails and we miss the process.
>
> Hmm.  Does that problem affect normal signal deliver.  I seem to recall
> being careful and doing something to make that case work.
>
> Does that fix only apply when we have a specific pid, not when we have
> a task and are walking the task_list.  Because kill_pid_info can retry
> if we receive -ESRCH?

Yes, kill_pid_info() is fine, and other users call group_send_sig_info()
under tasklist.

> To fix the pid namespace case we need to start walking the list of
> pids, not the task list for kill -1.

Or, we can make somthing like

	/* needs rcu lock */
	int kill_group(int sig, struct siginfo *info, struct task_struct *g)
	{
		struct task_struct *p = g;

		do {
			ret = group_send_sig_info(sig, info, p);
			if (ret != -ESRCH)
				break;
		} while_each_thread(g, p);

		return ret;
	}

> > Note the (broken) "p->pid > 1" check, kill_something_info() skips init.
> > Not that it matters though.
>
> Oh right.  I had forgotten about that special case.  Grr Special cases
> suck!
>
> We have a hole with init spawning new children, during kill -1.

Yes, I was wondering about this too.

> Ugh.  Or are those tasks indistinguishable from children spawned by
> init just after the signal was sent?

Oh, I don't know what is supposed semantics. Perhaps this works in
practice during shutdown? we can change the state of /sbin/init so
that it won't spawn the new tasks, and then we can do kill(-1).
I don't know.

> A practical question.  I need to rework the signal delivery for
> the case of kill -1 to be based on find_ge_pid.  So that it
> works with pid namespaces.

Hmm... not sure I understand why do we need find_ge_pid(). In fact,
I can't see which problems we have with kill_something_info() wrt
pid namespaces. I mean it should be changed of course, but these
changes should be relatively simple/straightforward? However I didn't
really think about this, may be wrong.

Oleg.

