Return-Path: <linux-kernel-owner+w=401wt.eu-S1758717AbYHZOAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717AbYHZOAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 10:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758648AbYHZOAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 10:00:24 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:61494 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758639AbYHZOAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 10:00:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=LwMR0eSr7MwKp1p5TudXBpHLuvg0SgeRK7XIftMH8avmBUjH5U6ZBdAcvzgCa/ca7G
         3EiW8Mkc6FVuvZ5ekAhbHoERfwO6w0njLovMuXXA8GxgEWfROnk3CemMoLZKLlvNa82V
         8QhBspmZw6fzpnv8vOMqYz9qxq7vUQiGnWO50=
Message-ID: <48B40C2F.3050700@gmail.com>
Date: Tue, 26 Aug 2008 15:59:11 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Al Viro <viro@ZenIV.linux.org.uk>,
       hch@infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Ron Minnich <rminnich@sandia.gov>, v9fs-developer@lists.sourceforge.net
Subject: [PATCH 2/2] poll: allow f_op->poll to sleep
References: <48B40BD4.7040004@kernel.org>
In-Reply-To: <48B40BD4.7040004@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

f_op->poll is the only vfs operation which is not allowed to sleep.
It's because poll and select implementation used task state to
synchronize against wake ups, which doesn't have to be the case
anymore as wait/wake interface can now use custom wake up functions.
The non-sleep restriction can be a bit tricky because ->poll is not
called from an atomic context and the result of accidentally sleeping
in ->poll only shows up as temporary busy looping when the timing is
right or rather wrong.

This patch converts poll/select to use custom wake up function and use
separate triggered variable to synchronize against wake up events.
The only added overhead is an extra function call during wake up and
negligible.

This patch removes the one non-sleep exception from vfs locking rules
and is especially beneficial to userland filesystem implementations
like FUSE or 9p as it's very difficult for those to implement
non-sleeping poll method.

All the existing poll users except for net/9p/trans_fd.c are converted
to use the new poll wait.  The 9p trans_fd is difficult to convert as
it currently stands but the following patchset solves the problem
nicely.

  http://thread.gmane.org/gmane.linux.kernel/726098

With or without the above patchset, this patch doesn't break anything
as all current ->poll implementations don't sleep anyway but the claim
that any ->poll implementation can sleep doesn't hold without the
above patchset.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
---
 Documentation/filesystems/Locking |    2 -
 drivers/media/video/v4l1-compat.c |    3 --
 fs/select.c                       |   50 ++++++++++++++++++++++++++++----------
 include/linux/poll.h              |    9 ++++++
 4 files changed, 49 insertions(+), 15 deletions(-)

Index: work/fs/select.c
===================================================================
--- work.orig/fs/select.c
+++ work/fs/select.c
@@ -54,6 +54,7 @@ static void __pollwait(struct file *filp
 void poll_initwait(struct poll_wqueues *pwq)
 {
 	init_poll_funcptr(&pwq->pt, __pollwait);
+	pwq->polling_task = current;
 	pwq->error = 0;
 	pwq->table = NULL;
 	pwq->inline_index = 0;
@@ -90,9 +91,8 @@ void poll_freewait(struct poll_wqueues *
 
 EXPORT_SYMBOL(poll_freewait);
 
-static struct poll_table_entry *poll_get_entry(poll_table *_p)
+static struct poll_table_entry *poll_get_entry(struct poll_wqueues *p)
 {
-	struct poll_wqueues *p = container_of(_p, struct poll_wqueues, pt);
 	struct poll_table_page *table = p->table;
 
 	if (p->inline_index < N_INLINE_POLL_ENTRIES)
@@ -104,7 +104,6 @@ static struct poll_table_entry *poll_get
 		new_table = (struct poll_table_page *) __get_free_page(GFP_KERNEL);
 		if (!new_table) {
 			p->error = -ENOMEM;
-			__set_current_state(TASK_RUNNING);
 			return NULL;
 		}
 		new_table->entry = new_table->entries;
@@ -116,20 +115,50 @@ static struct poll_table_entry *poll_get
 	return table->entry++;
 }
 
+static int pollwake(wait_queue_t *wait, unsigned mode, int sync, void *key)
+{
+	struct poll_wqueues *pwq = wait->private;
+	DECLARE_WAITQUEUE(dummy_wait, pwq->polling_task);
+
+	set_mb(pwq->triggered, 1);
+
+	/* perform the default wake up operation */
+	return default_wake_function(&dummy_wait, mode, sync, key);
+}
+
 /* Add a new entry */
 static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
 				poll_table *p)
 {
-	struct poll_table_entry *entry = poll_get_entry(p);
+	struct poll_wqueues *pwq = container_of(p, struct poll_wqueues, pt);
+	struct poll_table_entry *entry = poll_get_entry(pwq);
 	if (!entry)
 		return;
 	get_file(filp);
 	entry->filp = filp;
 	entry->wait_address = wait_address;
-	init_waitqueue_entry(&entry->wait, current);
+	init_waitqueue_func_entry(&entry->wait, pollwake);
+	entry->wait.private = pwq;
 	add_wait_queue(wait_address, &entry->wait);
 }
 
+long poll_schedule_timeout(struct poll_wqueues *pwq, int state, long timeout)
+{
+	DEFINE_WAIT(wait);
+
+	set_current_state(TASK_INTERRUPTIBLE);
+	if (!pwq->triggered)
+		timeout = schedule_timeout(timeout);
+	__set_current_state(TASK_RUNNING);
+
+	/* clear triggered for the next iteration */
+	pwq->triggered = 0;
+
+	return timeout;
+}
+
+EXPORT_SYMBOL(poll_schedule_timeout);
+
 #define FDS_IN(fds, n)		(fds->in + n)
 #define FDS_OUT(fds, n)		(fds->out + n)
 #define FDS_EX(fds, n)		(fds->ex + n)
@@ -205,8 +234,6 @@ int do_select(int n, fd_set_bits *fds, s
 		unsigned long *rinp, *routp, *rexp, *inp, *outp, *exp;
 		long __timeout;
 
-		set_current_state(TASK_INTERRUPTIBLE);
-
 		inp = fds->in; outp = fds->out; exp = fds->ex;
 		rinp = fds->res_in; routp = fds->res_out; rexp = fds->res_ex;
 
@@ -277,11 +304,11 @@ int do_select(int n, fd_set_bits *fds, s
 			__timeout = *timeout;
 			*timeout = 0;
 		}
-		__timeout = schedule_timeout(__timeout);
+		__timeout = poll_schedule_timeout(&table, TASK_INTERRUPTIBLE,
+						  __timeout);
 		if (*timeout >= 0)
 			*timeout += __timeout;
 	}
-	__set_current_state(TASK_RUNNING);
 
 	poll_freewait(&table);
 
@@ -587,7 +614,6 @@ static int do_poll(unsigned int nfds,  s
 		struct poll_list *walk;
 		long __timeout;
 
-		set_current_state(TASK_INTERRUPTIBLE);
 		for (walk = list; walk != NULL; walk = walk->next) {
 			struct pollfd * pfd, * pfd_end;
 
@@ -635,11 +661,11 @@ static int do_poll(unsigned int nfds,  s
 			*timeout = 0;
 		}
 
-		__timeout = schedule_timeout(__timeout);
+		__timeout = poll_schedule_timeout(wait, TASK_INTERRUPTIBLE,
+						  __timeout);
 		if (*timeout >= 0)
 			*timeout += __timeout;
 	}
-	__set_current_state(TASK_RUNNING);
 	return count;
 }
 
Index: work/include/linux/poll.h
===================================================================
--- work.orig/include/linux/poll.h
+++ work/include/linux/poll.h
@@ -57,6 +57,8 @@ struct poll_table_entry {
 struct poll_wqueues {
 	poll_table pt;
 	struct poll_table_page * table;
+	struct task_struct * polling_task;
+	int triggered;
 	int error;
 	int inline_index;
 	struct poll_table_entry inline_entries[N_INLINE_POLL_ENTRIES];
@@ -64,6 +66,13 @@ struct poll_wqueues {
 
 extern void poll_initwait(struct poll_wqueues *pwq);
 extern void poll_freewait(struct poll_wqueues *pwq);
+extern long poll_schedule_timeout(struct poll_wqueues *pwq, int state,
+				  long timeout);
+
+static inline long poll_schedule(struct poll_wqueues *pwq, int state)
+{
+	return poll_schedule_timeout(pwq, state, MAX_SCHEDULE_TIMEOUT);
+}
 
 /*
  * Scaleable version of the fd_set.
Index: work/drivers/media/video/v4l1-compat.c
===================================================================
--- work.orig/drivers/media/video/v4l1-compat.c
+++ work/drivers/media/video/v4l1-compat.c
@@ -209,7 +209,6 @@ static int poll_one(struct file *file, s
 	table = &pwq->pt;
 	for (;;) {
 		int mask;
-		set_current_state(TASK_INTERRUPTIBLE);
 		mask = file->f_op->poll(file, table);
 		if (mask & POLLIN)
 			break;
@@ -218,7 +217,7 @@ static int poll_one(struct file *file, s
 			retval = -ERESTARTSYS;
 			break;
 		}
-		schedule();
+		poll_schedule(pwq, TASK_INTERRUPTIBLE);
 	}
 	set_current_state(TASK_RUNNING);
 	poll_freewait(pwq);
Index: work/Documentation/filesystems/Locking
===================================================================
--- work.orig/Documentation/filesystems/Locking
+++ work/Documentation/filesystems/Locking
@@ -396,7 +396,7 @@ prototypes:
 };
 
 locking rules:
-	All except ->poll() may block.
+	All may block.
 			BKL
 llseek:			no	(see below)
 read:			no
