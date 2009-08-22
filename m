Return-Path: <linux-kernel-owner+w=401wt.eu-S1754385AbZHVNNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbZHVNNj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 09:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbZHVNNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 09:13:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbZHVNNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 09:13:38 -0400
Date: Sat, 22 Aug 2009 15:09:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Paul Menage <menage@google.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, bblum@google.com,
       ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com
Subject: Re: +
	cgroups-add-functionality-to-read-write-lock-clone_thread-forking-pe
	r-threadgroup.patch added to -mm tree
Message-ID: <20090822130952.GA4240@redhat.com>
References: <200908202114.n7KLEN5H026646@imap1.linux-foundation.org> <20090821102611.GA2611@redhat.com> <20090821104528.GA3487@redhat.com> <6599ad830908211637w6c9fd3a7tbe41bc106ada03d7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830908211637w6c9fd3a7tbe41bc106ada03d7@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21, Paul Menage wrote:
>
> On Fri, Aug 21, 2009 at 3:45 AM, Oleg Nesterov<oleg@redhat.com> wrote:
> > In case I wasn't clear.
> >
> > Let's suppose we have subthreads T1 and T2, and we have a reference to T1.
>
> In this case, T1 is also the thread group leader.

You forced me to take a look at the next patch,
cgroups-add-ability-to-move-all-threads-in-a-process-to-a-new-cgroup-atomically.patch
which uses this helper ;) please see below.

> And we hold tasklist_lock around the entire operation. (So the
> rcu_read_lock() call is probably a red herring - Li Zefan already
> suggested that it be removed).

Yes, rcu_read_lock() is not needed under tasklist to iterate over
->thread_group.

> But you're saying that could still be a problem if tsk exits  before
> we even get to this point?
>
> My impression was that if the thread group leader exits, it hangs
> around (still attached to its thread group list) until all its threads
> have exited.

Yes, unless the non-leader execs, in this case the leader can die before
sub-thread, the execing thread becomes the new leader.

IOW. Yes, ->group_leader dies last, but exec can change ->group_leader.

> In which case as long as we're holding tasklist_lock, the
> thread group list should remain valid.

Only if it was valid before we take tasklist.



OK, cgroups-add-ability-to-move-all-threads-in-a-process-to-a-new-cgroup-atomically.patch
does

	threadgroup_sighand = threadgroup_fork_lock(leader);

	rcu_read_lock();
	list_for_each_entry_rcu(tsk, &leader->thread_group, thread_group)

and this is equally wrong afais. Hmm, and other similar
list_for_each_entry_rcu's doesn't look right. This code can do something
like

	rcu_read_lock();
	if (!tsk->sighand)	// tsk is leader or not, doesn't matter
		fail;
	list_for_each_rcu(tsk->thread_group) {}
	rcu_read_unlock();

though.



And why do we need sighand->threadgroup_fork_lock ? I gueess, to protect
against clone(CLONE_THREAD).

But. threadgroup_fork_lock() has another problem. Even if the process
P is singlethreaded, I can't see how ->threadgroup_fork_lock work.

threadgroup_fork_lock() bumps P->sighand->count. If P exec, it will
notice sighand->count != 1 and switch to another ->sighand.

Oleg.

