Return-Path: <linux-kernel-owner+w=401wt.eu-S1758402AbYHZN70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402AbYHZN70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 09:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbYHZN7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 09:59:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:58636 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915AbYHZN7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 09:59:18 -0400
Message-ID: <48B40BD4.7040004@kernel.org>
Date: Tue, 26 Aug 2008 15:57:40 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Al Viro <viro@ZenIV.linux.org.uk>,
       hch@infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Ron Minnich <rminnich@sandia.gov>, v9fs-developer@lists.sourceforge.net
Subject: [PATCH 1/2] wait: kill is_sync_wait()
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 Aug 2008 13:58:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

is_sync_wait() is used to distinguish between sync and async waits.
Basically sync waits are the ones initialized with
init_waitqueue_entry() and async ones with init_waitqueue_func_entry().
The sync/async distinction is used only in prepare_to_wait[_exclusive]()
and its only function is to skip setting the current task state if the
wait is async.  This has a few problems.

* No one uses it.  None of func_entry users use prepare_to_wait()
  functions, so the code path never gets executed.

* The distinction is bogus.  Maybe back when func_entry is used only
  by aio but it's now also used by epoll and in future possibly by 9p
  and poll/select.

* Taking @state as argument and ignoring it silenly depending on how
  @wait is initialized is just a bad error-prone API.

* It prevents func_entry waits from using wait->private for no good
  reason.

This patch kills is_sync_wait() and the associated code paths from
prepare_to_wait[_exclusive]().  As there was no user of these code
paths, this patch doesn't cause any behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/wait.h |    9 ---------
 kernel/wait.c        |   14 ++------------
 2 files changed, 2 insertions(+), 21 deletions(-)

Index: work/kernel/wait.c
===================================================================
--- work.orig/kernel/wait.c
+++ work/kernel/wait.c
@@ -72,12 +72,7 @@ prepare_to_wait(wait_queue_head_t *q, wa
 	spin_lock_irqsave(&q->lock, flags);
 	if (list_empty(&wait->task_list))
 		__add_wait_queue(q, wait);
-	/*
-	 * don't alter the task state if this is just going to
-	 * queue an async wait queue callback
-	 */
-	if (is_sync_wait(wait))
-		set_current_state(state);
+	set_current_state(state);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 EXPORT_SYMBOL(prepare_to_wait);
@@ -91,12 +86,7 @@ prepare_to_wait_exclusive(wait_queue_hea
 	spin_lock_irqsave(&q->lock, flags);
 	if (list_empty(&wait->task_list))
 		__add_wait_queue_tail(q, wait);
-	/*
-	 * don't alter the task state if this is just going to
- 	 * queue an async wait queue callback
-	 */
-	if (is_sync_wait(wait))
-		set_current_state(state);
+	set_current_state(state);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 EXPORT_SYMBOL(prepare_to_wait_exclusive);
Index: work/include/linux/wait.h
===================================================================
--- work.orig/include/linux/wait.h
+++ work/include/linux/wait.h
@@ -108,15 +108,6 @@ static inline int waitqueue_active(wait_
 	return !list_empty(&q->task_list);
 }
 
-/*
- * Used to distinguish between sync and async io wait context:
- * sync i/o typically specifies a NULL wait queue entry or a wait
- * queue entry bound to a task (current task) to wake up.
- * aio specifies a wait queue entry with an async notification
- * callback routine, not associated with any task.
- */
-#define is_sync_wait(wait)	(!(wait) || ((wait)->private))
-
 extern void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);
 extern void add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait);
 extern void remove_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);
