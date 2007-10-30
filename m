Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbXJ3Pft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbXJ3Pft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 11:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbXJ3Pfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 11:35:39 -0400
Received: from mail.fieldses.org ([66.93.2.214]:37181 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753757AbXJ3Pfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 11:35:37 -0400
Date: Tue, 30 Oct 2007 11:35:05 -0400
To: Jiri Kosina <jikos@jikos.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Wilcox <matthew@wil.cx>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC, PATCH] locks: remove posix deadlock detection
Message-ID: <20071030153505.GB21595@fieldses.org>
References: <20071028182732.GK27248@parisc-linux.org> <20071028184052.49abd092@the-village.bc.nu> <20071028201101.GA32359@parisc-linux.org> <1193608230.7561.11.camel@heimdal.trondhjem.org> <20071028224157.GC32359@parisc-linux.org> <20071028224833.66dc4243@the-village.bc.nu> <20071028225559.GD32359@parisc-linux.org> <20071028233826.24907fba@the-village.bc.nu> <20071029022922.GD10307@fieldses.org> <Pine.LNX.4.64.0710291011190.18815@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710291011190.18815@twin.jikos.cz>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 10:15:19AM +0100, Jiri Kosina wrote:
> On Sun, 28 Oct 2007, J. Bruce Fields wrote:
> 
> > But, OK, if we can identify unshared current->files at the time we put a 
> > task to sleep, then a slight modification of our current algorithm might 
> > be sufficient to detect any deadlock that involves purely posix file 
> > locks and processes.  And we can tell people that avoiding deadlock is 
> > their problem as soon as any task with a shared current->files is 
> > involved.  (Ditto, I assume, if nfsd/lockd acquires a lock.)
> 
> Don't forget that comparing file_lock->fl_owner (i.e. current->files) is 
> not the only way how lock ownership could be computed (there could be 
> specific file_lock->fl_lmops->fl_compare_owner() and all of them should 
> be teached this new semantics, right?).

Right.  So, for example, this would handle both cases as described
above.

We're turning off deadlock detection in the problematic cases just by
neglecting to add such waiting lockers to the blocked_list (which is
what we search to look for lock cycles).

(It'd be nice if we didn't have to search that list at all.  There
should be some way to set up the data structures so we can follow the
lock dependencies without having to scan through all the blocked locks
at each step.  But I haven't quite figured out how to do that yet.  And
perhaps it's not important to optimize cases where there are lots of
blocks.)

--b.

diff --git a/fs/locks.c b/fs/locks.c
index 8b8388e..5446305 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -512,6 +512,8 @@ static void locks_delete_block(struct file_lock *waiter)
 	unlock_kernel();
 }
 
+static int posix_owner_shared(struct file_lock *caller_fl);
+
 /* Insert waiter into blocker's block list.
  * We use a circular list so that processes can be easily woken up in
  * the order they blocked. The documentation doesn't require this but
@@ -523,7 +525,7 @@ static void locks_insert_block(struct file_lock *blocker,
 	BUG_ON(!list_empty(&waiter->fl_block));
 	list_add_tail(&waiter->fl_block, &blocker->fl_block);
 	waiter->fl_next = blocker;
-	if (IS_POSIX(blocker))
+	if (IS_POSIX(blocker) && !posix_owner_shared(waiter))
 		list_add(&waiter->fl_link, &blocked_list);
 }
 
@@ -683,46 +685,79 @@ posix_test_lock(struct file *filp, struct file_lock *fl)
 
 EXPORT_SYMBOL(posix_test_lock);
 
-/* This function tests for deadlock condition before putting a process to
- * sleep. The detection scheme is no longer recursive. Recursive was neat,
- * but dangerous - we risked stack corruption if the lock data was bad, or
- * if the recursion was too deep for any other reason.
- *
- * We rely on the fact that a task can only be on one lock's wait queue
- * at a time. When we find blocked_task on a wait queue we can re-search
- * with blocked_task equal to that queue's owner, until either blocked_task
- * isn't found, or blocked_task is found on a queue owned by my_task.
- *
- * Note: the above assumption may not be true when handling lock requests
- * from a broken NFS client. But broken NFS clients have a lot more to
- * worry about than proper deadlock detection anyway... --okir
- *
- * However, the failure of this assumption (also possible in the case of
- * multiple tasks sharing the same open file table) also means there's no
- * guarantee that the loop below will terminate.  As a hack, we give up
- * after a few iterations.
+/*
+ * Deadlock detection: 
+ *
+ * We attempt to detect deadlocks that are due purely to posix file
+ * locks.
+ *
+ * We assume that a task can be waiting for at most one lock at a time.
+ * So for any acquired lock, the process holding that lock may be
+ * waiting on at most one other lock.  That lock in turns may be held by
+ * someone waiting for at most one other lock.  Given a requested lock
+ * caller_fl which is about to wait for a conflicting lock block_fl, we
+ * follow this chain of waiters to ensure we are not about to create a
+ * cycle.
+ *
+ * Since we do this before we ever put a process to sleep on a lock, we
+ * are ensured that there is never a cycle; that is what guarantees that
+ * the while() loop in posix_locks_deadlock() eventually completes.
+ *
+ * Note: the above assumption may not be true when handling lock
+ * requests from a broken NFS client. It may also fail in the presence
+ * of tasks (such as posix threads) sharing the same open file table.
+ *
+ * We don't necessarily care about returning EDEALK correctly in such
+ * cases, but we do need to avoid cycles in the lock dependency graph in
+ * order to ensure the loop in posix_locks_deadlock eventually
+ * terminates.  To that end, we enforce the assumption above by refusing
+ * to return EDEADLK or add to the list of blocked locks in any case
+ * where a lock owner might be able to block on more than one lock.
  */
 
-#define MAX_DEADLK_ITERATIONS 10
+static int posix_owner_shared(struct file_lock *caller_fl)
+{
+	/*
+	 * The caller is a lock manager (lockd/nfsd), and won't
+	 * necessarily guarantee that a single lock owner won't block on
+	 * two locks at once:
+	 */
+	if (caller_fl->fl_lmops && caller_fl->fl_lmops->fl_compare_owner)
+		return 1;
+	/*
+	 * Multiple tasks share current->files, also allowing the same
+	 * "owner" to block on two locks at once:
+	 */
+	if (current->files == NULL || atomic_read(&current->files->count) > 1)
+		return 1;
+	/*
+	 * The lock is not on behalf of a file manager, and no other
+	 * tasks share this file owner (and, as long as this task is
+	 * stuck waiting for a lock, that's not going to change):
+	 */
+	return 0;
+}
+
+/* Find a lock that the owner of the given block_fl is blocking on. */
+static struct file_lock * what_owner_is_waiting_for(struct file_lock *block_fl)
+{
+	struct file_lock *fl;
+
+	list_for_each_entry(fl, &blocked_list, fl_link)
+		if (posix_same_owner(fl, block_fl))
+			return fl->fl_next;
+	return NULL;
+}
 
 static int posix_locks_deadlock(struct file_lock *caller_fl,
 				struct file_lock *block_fl)
 {
-	struct file_lock *fl;
-	int i = 0;
+	if (posix_owner_shared(caller_fl))
+		return 0;
 
-next_task:
-	if (posix_same_owner(caller_fl, block_fl))
-		return 1;
-	list_for_each_entry(fl, &blocked_list, fl_link) {
-		if (posix_same_owner(fl, block_fl)) {
-			if (i++ > MAX_DEADLK_ITERATIONS)
-				return 0;
-			fl = fl->fl_next;
-			block_fl = fl;
-			goto next_task;
-		}
-	}
+	while ((block_fl = what_owner_is_waiting_for(block_fl)))
+		if (posix_same_owner(caller_fl, block_fl))
+			return 1;
 	return 0;
 }
 
