Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbYEaQx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbYEaQx4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 12:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYEaQxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 12:53:49 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:38340 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999AbYEaQxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 12:53:48 -0400
Date: Sat, 31 May 2008 20:55:25 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] kill_something_info: don't take tasklist_lock for pid==-1 case
Message-ID: <20080531165525.GA5575@tv-sign.ru>
References: <47E87F2A.2040303@bk.jp.nec.com> <20080325135645.GA96@tv-sign.ru> <m18wy45nej.fsf@frodo.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m18wy45nej.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, sorry for the delay,

On 05/20, Eric W. Biederman wrote:
> 
> Oleg Nesterov <oleg@tv-sign.ru> writes:
> 
> > On 03/25, Atsushi Tsuji wrote:
> >> 
> >> This patch avoid taking tasklist_lock in kill_something_info() when
> >> the pid is -1. It can convert to rcu_read_lock() for this case because
> >> group_send_sig_info() doesn't need tasklist_lock.
> >> 
> >> This patch is for 2.6.25-rc5-mm1.
> >> 
> 
> > Hmm. Yes, group_send_sig_info() doesn't need tasklist_lock. But we
> > take tasklist_lock to "freeze" the tasks list, so that we can't miss
> > a new forked process.
> >
> > Same for __kill_pgrp_info(), we take tasklist to kill the whole group
> > "atomically".
> >
> >
> > However. Is it really needed? copy_process() returns -ERESTARTNOINTR
> > if signal_pending(), and the new task is always placed at the tail
> > of the list. Looks like nobody can escape the signal, at least fatal
> > or SIGSTOP.
> 
> 
> Call me paranoid but I don't think there is any guarantee without a lock
> that we will hit the -ERESTARTNOITR check for new processes.  I think we
> have a slight race where the fork process may not have received the signal
> (because it is near the tail of the list) but the new process would be
> added to the list immediately after we read it's pointer.

Hmm. could you clarify? I tend to always trust you, just can't understand
the text above...

However, I think this patch adds another subtle race which I missed before.

Let's suppose that the task has two threads, A (== main thread) and B. A has
already exited, B does exec.

In that case it is possible that (without tasklist_lock) kill_something_info()
sends the signal to the old leader (A), but before group_send_sig_info(A)
takes ->siglock B switches the leader and does release_task(A). In that
group_send_sig_info()->lock_task_sighand() fails and we miss the process.

> That is subtle.  Switching to the per task siglock for protection.
> 
> > Except: We don't send the signal to /sbin/init. This means that (say)
> > kill(-1, SIGKILL) can miss the task forked by init. Note that this
> > task could be forked even before we start kill_something_info(), but
> > without tasklist there is no guarantee we will see it on the ->tasks
> > list.
> 
> Actually we do sent the signal to init but we shouldn't,

Note the (broken) "p->pid > 1" check, kill_something_info() skips init.
Not that it matters though.

Oleg.

