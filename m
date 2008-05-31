Return-Path: <linux-kernel-owner+w=401wt.eu-S1756346AbYFAABR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbYFAABR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 20:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbYFAABI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 20:01:08 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41175 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbYFAABG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 20:01:06 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>
References: <47E87F2A.2040303@bk.jp.nec.com> <20080325135645.GA96@tv-sign.ru>
	<m18wy45nej.fsf@frodo.ebiederm.org> <20080531165525.GA5575@tv-sign.ru>
Date: Sat, 31 May 2008 16:55:16 -0700
In-Reply-To: <20080531165525.GA5575@tv-sign.ru> (Oleg Nesterov's message of
	"Sat, 31 May 2008 20:55:25 +0400")
Message-ID: <m1hccexc4b.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@tv-sign.ru>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0834]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] kill_something_info: don't take tasklist_lock for pid==-1 case
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> Sorry, sorry for the delay,
>
> On 05/20, Eric W. Biederman wrote:
>> 
>> Oleg Nesterov <oleg@tv-sign.ru> writes:
>> 
>> > On 03/25, Atsushi Tsuji wrote:
>> >> 
>> >> This patch avoid taking tasklist_lock in kill_something_info() when
>> >> the pid is -1. It can convert to rcu_read_lock() for this case because
>> >> group_send_sig_info() doesn't need tasklist_lock.
>> >> 
>> >> This patch is for 2.6.25-rc5-mm1.
>> >> 
>> 
>> > Hmm. Yes, group_send_sig_info() doesn't need tasklist_lock. But we
>> > take tasklist_lock to "freeze" the tasks list, so that we can't miss
>> > a new forked process.
>> >
>> > Same for __kill_pgrp_info(), we take tasklist to kill the whole group
>> > "atomically".
>> >
>> >
>> > However. Is it really needed? copy_process() returns -ERESTARTNOINTR
>> > if signal_pending(), and the new task is always placed at the tail
>> > of the list. Looks like nobody can escape the signal, at least fatal
>> > or SIGSTOP.
>> 
>> 
>> Call me paranoid but I don't think there is any guarantee without a lock
>> that we will hit the -ERESTARTNOITR check for new processes.  I think we
>> have a slight race where the fork process may not have received the signal
>> (because it is near the tail of the list) but the new process would be
>> added to the list immediately after we read it's pointer.
>
> Hmm. could you clarify? I tend to always trust you, just can't understand
> the text above...

We can read old next values when walking the task list under the rcu
lock.  So I don't believe we are guaranteed to see additions that
happen while we hold the rcu lock.

If a new process spawns, passes the check for the parent having the
signal, the signal is delivered the signal, and then appends to the
task list.  We might miss it.  I'm not certain, but that feels right.

> However, I think this patch adds another subtle race which I missed before.
>
> Let's suppose that the task has two threads, A (== main thread) and B. A has
> already exited, B does exec.
>
> In that case it is possible that (without tasklist_lock) kill_something_info()
> sends the signal to the old leader (A), but before group_send_sig_info(A)
> takes ->siglock B switches the leader and does release_task(A). In that
> group_send_sig_info()->lock_task_sighand() fails and we miss the process.

Hmm.  Does that problem affect normal signal deliver.  I seem to recall
being careful and doing something to make that case work.

Does that fix only apply when we have a specific pid, not when we have
a task and are walking the task_list.  Because kill_pid_info can retry
if we receive -ESRCH?

To fix the pid namespace case we need to start walking the list of
pids, not the task list for kill -1.

>> That is subtle.  Switching to the per task siglock for protection.
>> 
>> > Except: We don't send the signal to /sbin/init. This means that (say)
>> > kill(-1, SIGKILL) can miss the task forked by init. Note that this
>> > task could be forked even before we start kill_something_info(), but
>> > without tasklist there is no guarantee we will see it on the ->tasks
>> > list.
>> 
>> Actually we do sent the signal to init but we shouldn't,
>
> Note the (broken) "p->pid > 1" check, kill_something_info() skips init.
> Not that it matters though.

Oh right.  I had forgotten about that special case.  Grr Special cases
suck!

We have a hole with init spawning new children, during kill -1.
Ugh.  Or are those tasks indistinguishable from children spawned by
init just after the signal was sent?

A practical question.  I need to rework the signal delivery for
the case of kill -1 to be based on find_ge_pid.  So that it
works with pid namespaces.  That kills our nice in order list
property. :(  A rework does give the opportunity to investigate
these properties in detail, and see if there is a way to drop
the tasklist_lock.  Especially since we are already discussing it.

The guarantee is that the signal delivery needs to appear atomic
so that we don't miss any processes in the group of processes
the signal is sent to.  The rcu list gives us an effectively atomic
snapshot of the list.  However new processes can be added while we
walk that list.

To prevent the current visible DOS we need to only hold processes
in fork for the duration of our traversal of the set of all processes
in the system and then let them go.

The -ERESTARTNOINTR trick ensures the signal is delivered to the
parent before a fork executes.

Init only receives signals that it wants (the rest are effectively
ignored and discared) so it can be said to have forked after signal
delivery when there is a race.

We grab sighand lock on each process that we are delivering the signal
to.

This almost feels like a recipe for atomic signal delivery.  Without
an ordered list.  I just don't see it yet.  I will keep picking at it
since it sounds like we are close to the point where the tasklist is
a problem even on small systems.


Eric
