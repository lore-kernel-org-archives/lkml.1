Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbXK0NUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbXK0NUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 08:20:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757237AbXK0NU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 08:20:27 -0500
Received: from ns.suse.de ([195.135.220.2]:37030 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750AbXK0NUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 08:20:25 -0500
Date: Tue, 27 Nov 2007 14:20:22 +0100
From: Andrea Arcangeli <andrea@suse.de>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: /proc dcache deadlock in do_exit
Message-ID: <20071127132022.GW6840@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch fixes a sles9 system hang in start_this_handle from a
customer with some heavy workload where all tasks are waiting on
kjournald to commit the transaction, but kjournald waits on t_updates
to go down to zero (it never does). This was reported as a lowmem
shortage deadlock but when checking the debug data I noticed the VM
wasn't under pressure at all (well it was really under vm pressure,
because lots of tasks hanged in the VM prune_dcache methods trying to
flush dirty inodes, but no task was hanging in GFP_NOFS mode, the
holder of the journal handle should have if this was a vm issue in the
first place). No task was apparently holding the leftover handle in
the committing transaction, so I deduced t_updates was stuck to 1
because a journal_stop was never run by some path (this turned out to
be correct). With a debug patch adding proper reverse links and stack
trace logging in ext3 deployed in production, I found journal_stop is
never run because mark_inode_dirty_sync is called inside release_task
called by do_exit. (that was quite fun because I would have never
thought about this subtleness, I thought a regular path in ext3 had a
bug and it forgot to call journal_stop)

do_exit->release_task->mark_inode_dirty_sync->schedule() (will never
come back to run journal_stop)

The reason is that shrink_dcache_parent is racy by design (feature not
a bug) and it can do blocking I/O in some case, but the point is that
calling shrink_dcache_parent at the last stage of do_exit isn't safe
for self-reaping tasks.

I guess the memory pressure of the unbalanced highmem system allowed
to trigger this more easily.

Now mainline doesn't have this line in iput (like sles9 has):

    	     if (inode->i_state & I_DIRTY_DELAYED)
	     			mark_inode_dirty_sync(inode);

so it will probably not crash with ext3, but for example ext2
implements an I/O-blocking ext2_put_inode that will lead to similar
screwups with ext2_free_blocks never coming back and it's definitely
wrong to call blocking-IO paths inside do_exit. So this should fix a
subtle bug in mainline too (not verified in practice though). The
equivalent fix for ext3 is also not verified yet to fix the problem in
sles9 but I don't have doubt it will (it usually takes days to crash,
so it'll take weeks to be sure).

An alternate fix would be to offload that work to a kernel thread, but
I don't think a reschedule for this is worth it, the vm should be able
to collect those entries for the synchronous release_task.

Signed-off-by: Andrea Arcangeli <andrea@suse.de>

diff --git a/fs/proc/base.c b/fs/proc/base.c
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2265,7 +2265,8 @@ static void proc_flush_task_mnt(struct v
 	name.len = snprintf(buf, sizeof(buf), "%d", pid);
 	dentry = d_hash_and_lookup(mnt->mnt_root, &name);
 	if (dentry) {
-		shrink_dcache_parent(dentry);
+		if (!(current->flags & PF_EXITING))
+			shrink_dcache_parent(dentry);
 		d_drop(dentry);
 		dput(dentry);
 	}


here the debugging code I written to track this deadlock down if
anyone is interested. (I should really have used unsigned long _stack
to make life easier).

Index: sles9/fs/jbd/transaction.c
--- sles9/fs/jbd/transaction.c.~1~	2007-10-26 00:18:21.000000000 +0200
+++ sles9/fs/jbd/transaction.c	2007-11-19 19:49:30.000000000 +0100
@@ -222,7 +222,19 @@ repeat_locked:
 	handle->h_transaction = transaction;
 	transaction->t_outstanding_credits += nblocks;
 	transaction->t_updates++;
-	transaction->t_handle_count++;
+	handle->id = transaction->t_handle_count++;
+	if (handle->id < NR_HANDLES)
+		transaction->handles[handle->id] = handle;
+	{
+		char _stack;
+		char * start = &_stack, * end, * stack;
+		end = (char *) (((unsigned long) start+THREAD_SIZE-1) & (-THREAD_SIZE));
+		stack = (char *) ((unsigned long) start + 2048);
+		if (stack > end)
+			stack = end;
+		memcpy(handle->stack, start, stack-start);
+	}
+	
 	jbd_debug(4, "Handle %p given %d credits (total %d, free %d)\n",
 		  handle, nblocks, transaction->t_outstanding_credits,
 		  __log_space_left(journal));
@@ -398,6 +410,8 @@ int journal_restart(handle_t *handle, in
 	spin_lock(&transaction->t_handle_lock);
 	transaction->t_outstanding_credits -= handle->h_buffer_credits;
 	transaction->t_updates--;
+	if (handle->id < NR_HANDLES)
+		transaction->handles[handle->id] = NULL;
 
 	if (!transaction->t_updates)
 		wake_up(&journal->j_wait_updates);
@@ -1362,6 +1376,8 @@ int journal_stop(handle_t *handle)
 	spin_lock(&transaction->t_handle_lock);
 	transaction->t_outstanding_credits -= handle->h_buffer_credits;
 	transaction->t_updates--;
+	if (handle->id < NR_HANDLES)
+		transaction->handles[handle->id] = NULL;
 	if (!transaction->t_updates) {
 		wake_up(&journal->j_wait_updates);
 		if (journal->j_barrier_count)
Index: sles9/include/linux/jbd.h
--- sles9/include/linux/jbd.h.~1~	2007-10-26 00:18:21.000000000 +0200
+++ sles9/include/linux/jbd.h	2007-11-19 19:40:34.000000000 +0100
@@ -386,6 +386,8 @@ struct handle_s 
 {
 	/* Which compound transaction is this update a part of? */
 	transaction_t		*h_transaction;
+	int id;
+	char stack[2048];
 
 	/* Number of remaining buffers we are allowed to dirty: */
 	int			h_buffer_credits;
@@ -569,6 +571,8 @@ struct transaction_s 
 	 * How many handles used this transaction? [t_handle_lock]
 	 */
 	int t_handle_count;
+#define NR_HANDLES 400
+	handle_t * handles[NR_HANDLES];
 
 	/*
 	 * Protects the callback list
