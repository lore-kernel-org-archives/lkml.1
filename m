Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbXK0WjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbXK0WjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 17:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbXK0WjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 17:39:08 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46602 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752132AbXK0WjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 17:39:05 -0500
Date: Tue, 27 Nov 2007 14:38:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Arcangeli <andrea@suse.de>
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: /proc dcache deadlock in do_exit
Message-Id: <20071127143852.601509ac.akpm@linux-foundation.org>
In-Reply-To: <20071127132022.GW6840@v2.random>
References: <20071127132022.GW6840@v2.random>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007 14:20:22 +0100
Andrea Arcangeli <andrea@suse.de> wrote:

> Hi,
> 
> this patch fixes a sles9 system hang in start_this_handle from a
> customer with some heavy workload where all tasks are waiting on
> kjournald to commit the transaction, but kjournald waits on t_updates
> to go down to zero (it never does). This was reported as a lowmem
> shortage deadlock but when checking the debug data I noticed the VM
> wasn't under pressure at all (well it was really under vm pressure,
> because lots of tasks hanged in the VM prune_dcache methods trying to
> flush dirty inodes, but no task was hanging in GFP_NOFS mode, the
> holder of the journal handle should have if this was a vm issue in the
> first place). No task was apparently holding the leftover handle in
> the committing transaction, so I deduced t_updates was stuck to 1
> because a journal_stop was never run by some path (this turned out to
> be correct). With a debug patch adding proper reverse links and stack
> trace logging in ext3 deployed in production, I found journal_stop is
> never run because mark_inode_dirty_sync is called inside release_task
> called by do_exit. (that was quite fun because I would have never
> thought about this subtleness, I thought a regular path in ext3 had a
> bug and it forgot to call journal_stop)
> 
> do_exit->release_task->mark_inode_dirty_sync->schedule() (will never
> come back to run journal_stop)

I don't see why the schedule() will not return?  Because the task has
PF_EXITING set?  Doesn't TASK_DEAD do that?

> The reason is that shrink_dcache_parent is racy by design (feature not
> a bug) and it can do blocking I/O in some case, but the point is that
> calling shrink_dcache_parent at the last stage of do_exit isn't safe
> for self-reaping tasks.
> 
> I guess the memory pressure of the unbalanced highmem system allowed
> to trigger this more easily.
> 
> Now mainline doesn't have this line in iput (like sles9 has):
> 
>     	     if (inode->i_state & I_DIRTY_DELAYED)
> 	     			mark_inode_dirty_sync(inode);
> 
> so it will probably not crash with ext3, but for example ext2
> implements an I/O-blocking ext2_put_inode that will lead to similar
> screwups with ext2_free_blocks never coming back and it's definitely
> wrong to call blocking-IO paths inside do_exit. So this should fix a
> subtle bug in mainline too (not verified in practice though). The
> equivalent fix for ext3 is also not verified yet to fix the problem in
> sles9 but I don't have doubt it will (it usually takes days to crash,
> so it'll take weeks to be sure).
> 
> An alternate fix would be to offload that work to a kernel thread, but
> I don't think a reschedule for this is worth it, the vm should be able
> to collect those entries for the synchronous release_task.
> 
> Signed-off-by: Andrea Arcangeli <andrea@suse.de>
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2265,7 +2265,8 @@ static void proc_flush_task_mnt(struct v
>  	name.len = snprintf(buf, sizeof(buf), "%d", pid);
>  	dentry = d_hash_and_lookup(mnt->mnt_root, &name);
>  	if (dentry) {
> -		shrink_dcache_parent(dentry);
> +		if (!(current->flags & PF_EXITING))
> +			shrink_dcache_parent(dentry);
>  		d_drop(dentry);
>  		dput(dentry);
>  	}

What are the implications of not running shrink_dcache_parent() on the exit
path sometimes?  We'll leave procfs stuff behind?  Will they be reaped by
memory pressure later on?


