Return-Path: <linux-kernel-owner+w=401wt.eu-S1756457AbXJ1Rng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457AbXJ1Rng (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 13:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbXJ1Rn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 13:43:27 -0400
Received: from mail.fieldses.org ([66.93.2.214]:54160 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376AbXJ1Rn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 13:43:26 -0400
Date: Sun, 28 Oct 2007 13:43:21 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: [RFC, PATCH] locks: remove posix deadlock detection
Message-ID: <20071028174321.GB16905@fieldses.org>
References: <20071017185157.GC3785@mvista.com> <20071018185759.GU3785@mvista.com> <20071026170750.GC13033@fieldses.org> <20071026224707.GO13033@fieldses.org> <20071028173136.GA16905@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071028173136.GA16905@fieldses.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@citi.umich.edu>

We currently attempt to return -EDEALK to blocking fcntl() file locking
requests that would create a cycle in the graph of tasks waiting on
locks.

This is inefficient: in the general case it requires us determining
whether we're adding a cycle to an arbitrary directed acyclic graph.
And this calculation has to be performed while holding a lock (currently
the BKL) that prevents that graph from changing.

It has historically been a source of bugs; most recently it was noticed
that it could loop indefinitely while holding the BKL.

It seems unlikely to be useful to applications:
	- The difficulty of implementation has kept standards from
	  requiring it.  (E.g. SUSv3 : "Since implementation of full
	  deadlock detection is not always feasible, the [EDEADLK] error
	  was made optional.")  So portable applications may not be able to
	  depend on it.
	- It only detects deadlocks that involve nothing but local posix
	  file locks; deadlocks involving network filesystems or other kinds
	  of locks or resources are missed.

It therefore seems best to remove deadlock detection.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---
 fs/locks.c |   48 ------------------------------------------------
 1 files changed, 0 insertions(+), 48 deletions(-)

This also solves the problem addressed by the previous patch.  But this
patch would require more discussion, and the problem needs to be fixed
now.

Of course, we shouldn't apply this if there's a chance that real
applications may depend on the existing (imperfect) deadlock detection.

diff --git a/fs/locks.c b/fs/locks.c
index 131aa88..564b85d 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -683,50 +683,6 @@ posix_test_lock(struct file *filp, struct file_lock *fl)
 
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
- * after a few iterations.  We don't bother returning EDEADLK in that case;
- * the deadlock has probably already happened anyway.
- */
-
-#define MAX_DEADLK_ITERATIONS 10
-
-static int posix_locks_deadlock(struct file_lock *caller_fl,
-				struct file_lock *block_fl)
-{
-	struct file_lock *fl;
-	int i = 0;
-
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
-	return 0;
-}
-
 /* Try to create a FLOCK lock on filp. We always insert new FLOCK locks
  * after any leases, but before any posix locks.
  *
@@ -846,10 +802,6 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 			error = -EAGAIN;
 			if (!(request->fl_flags & FL_SLEEP))
 				goto out;
-			error = -EDEADLK;
-			if (posix_locks_deadlock(request, fl))
-				goto out;
-			error = -EAGAIN;
 			locks_insert_block(fl, request);
 			goto out;
   		}
-- 
1.5.3.4.208.gc990

