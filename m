Return-Path: <linux-kernel-owner+w=401wt.eu-S1760727AbXK1Qbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727AbXK1Qbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 11:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759401AbXK1Qbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 11:31:35 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:38700 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758934AbXK1Qbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 11:31:34 -0500
Date: Wed, 28 Nov 2007 19:30:34 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <andrea@suse.de>, linux-kernel@vger.kernel.org,
       jack@suse.cz, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: /proc dcache deadlock in do_exit
Message-ID: <20071128163034.GA144@tv-sign.ru>
References: <20071127132022.GW6840@v2.random> <20071127143852.601509ac.akpm@linux-foundation.org> <m1zlwzgn6h.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zlwzgn6h.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27, Eric W. Biederman wrote:
>
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > On Tue, 27 Nov 2007 14:20:22 +0100
> > Andrea Arcangeli <andrea@suse.de> wrote:
> >
> >> do_exit->release_task->mark_inode_dirty_sync->schedule() (will never
> >> come back to run journal_stop)
> >
> > I don't see why the schedule() will not return?  Because the task has
> > PF_EXITING set?  Doesn't TASK_DEAD do that?
> 
> Yes, why do we not come back from schedule?
> 
> If we are not allowed to schedule after setting PF_EXITING before
> we set TASK_DEAD that entire code path sounds brittle and
> error prone.

Yes, it is fine to schedule after release_task(). As Eric pointed out, we
don't race with call_rcu(delayed_put_task_struct), scheduler has another
reference

	dup_task_struct:
		/* One for us, one for whoever does the "release_task()" (usually parent) */
		atomic_set(&tsk->usage,2);



However, with CONFIG_HOTPLUG_CPU we do have the problem here, but this is
off-topic. Preemption is fine, but deactivate_task() is not. We can't migrate
the deactivated released task from the dead CPU.

	migrate_live_tasks() can't find the task after __unhash_process()

	migrate_dead_tasks() doesn't see it after deactivate_task().

And afaics try_to_wake_up() doesn't necessary change task_cpu() if it is
offline.

No? But again, this is offtopic even if I am right.

Oleg.

