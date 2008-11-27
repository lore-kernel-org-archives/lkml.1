Return-Path: <linux-kernel-owner+w=401wt.eu-S1753056AbYK0Jhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbYK0Jhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 04:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbYK0Jhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 04:37:32 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:44263 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYK0Jha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 04:37:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=FlWpC4r/RjI/n626dIE05xJrzvzc0FU5vCw6okmZAkwSQa19ooZFlGa1cGQX/1newr
         KZmLeTKdBvphdl5BEx6c78/F3XrH8xnVxfWyM+aBG+pHMszvvcO7eooAAyyBUEsjZVsJ
         0Xc47AoJ12BlHKBWJw2PTMWgxXFm3h7PqoCIk=
Message-ID: <492E6A6E.9020000@gmail.com>
Date: Thu, 27 Nov 2008 18:37:50 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Oleg Nesterov <oleg@redhat.com>, Eric Van Hensbergen <ericvh@gmail.com>,
       Ron Minnich <rminnich@sandia.gov>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <mszeredi@suse.cz>, Brad Boyer <flar@allandria.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Roland McGrath <roland@redhat.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] poll: allow f_op->poll to sleep, take#6
References: <20081125173032.GA21539@redhat.com> <492CD1AB.3000802@kernel.org> <492CD358.2020603@gmail.com> <alpine.DEB.1.10.0811252148540.32523@alien.or.mcafeemobile.com> <492CEF04.6070100@gmail.com> <alpine.DEB.1.10.0811252313420.32523@alien.or.mcafeemobile.com> <492E65F9.30208@gmail.com>
In-Reply-To: <492E65F9.30208@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

f_op->poll is the only vfs operation which is not allowed to sleep.  It's
because poll and select implementation used task state to synchronize
against wake ups, which doesn't have to be the case anymore as wait/wake
interface can now use custom wake up functions.  The non-sleep restriction
can be a bit tricky because ->poll is not called from an atomic context
and the result of accidentally sleeping in ->poll only shows up as
temporary busy looping when the timing is right or rather wrong.

This patch converts poll/select to use custom wake up function and use
separate triggered variable to synchronize against wake up events.  The
only added overhead is an extra function call during wake up and
negligible.

This patch removes the one non-sleep exception from vfs locking rules and
is beneficial to userland filesystem implementations like FUSE, 9p or
peculiar fs like spufs as it's very difficult for those to implement
non-sleeping poll method.

While at it, make the following cosmetic changes to make poll.h and
select.c checkpatch friendly.

* s/type * symbol/type *symbol/		   : three places in poll.h
* remove blank line before EXPORT_SYMBOL() : two places in select.c

Oleg: spotted missing barrier in poll_schedule_timeout()
Davide: spotted missing write barrier in pollwake()

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Brad Boyer <flar@allandria.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Roland McGrath <roland@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 Documentation/filesystems/Locking |    2 -
 drivers/media/video/v4l1-compat.c |    4 --
 fs/select.c                       |   76 +++++++++++++++++++++++++++++++-------
 include/linux/poll.h              |   15 ++++++-
 4 files changed, 76 insertions(+), 21 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 23d2f44..250f3c4 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -398,7 +398,7 @@ prototypes:
 };
 
 locking rules:
-	All except ->poll() may block.
+	All may block.
 			BKL
 llseek:			no	(see below)
 read:			no
diff --git a/drivers/media/video/v4l1-compat.c b/drivers/media/video/v4l1-compat.c
index f13c0a9..d0253da 100644
--- a/drivers/media/video/v4l1-compat.c
+++ b/drivers/media/video/v4l1-compat.c
@@ -203,7 +203,6 @@ static int poll_one(struct file *file, struct poll_wqueues *pwq)
 	table = &pwq->pt;
 	for (;;) {
 		int mask;
-		set_current_state(TASK_INTERRUPTIBLE);
 		mask = file->f_op->poll(file, table);
 		if (mask & POLLIN)
 			break;
@@ -212,9 +211,8 @@ static int poll_one(struct file *file, struct poll_wqueues *pwq)
 			retval = -ERESTARTSYS;
 			break;
 		}
-		schedule();
+		poll_schedule(pwq, TASK_INTERRUPTIBLE);
 	}
-	set_current_state(TASK_RUNNING);
 	poll_freewait(pwq);
 	return retval;
 }
diff --git a/fs/select.c b/fs/select.c
index 87df51e..08b91be 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -109,11 +109,11 @@ static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
 void poll_initwait(struct poll_wqueues *pwq)
 {
 	init_poll_funcptr(&pwq->pt, __pollwait);
+	pwq->polling_task = current;
 	pwq->error = 0;
 	pwq->table = NULL;
 	pwq->inline_index = 0;
 }
-
 EXPORT_SYMBOL(poll_initwait);
 
 static void free_poll_entry(struct poll_table_entry *entry)
@@ -142,12 +142,10 @@ void poll_freewait(struct poll_wqueues *pwq)
 		free_page((unsigned long) old);
 	}
 }
-
 EXPORT_SYMBOL(poll_freewait);
 
-static struct poll_table_entry *poll_get_entry(poll_table *_p)
+static struct poll_table_entry *poll_get_entry(struct poll_wqueues *p)
 {
-	struct poll_wqueues *p = container_of(_p, struct poll_wqueues, pt);
 	struct poll_table_page *table = p->table;
 
 	if (p->inline_index < N_INLINE_POLL_ENTRIES)
@@ -159,7 +157,6 @@ static struct poll_table_entry *poll_get_entry(poll_table *_p)
 		new_table = (struct poll_table_page *) __get_free_page(GFP_KERNEL);
 		if (!new_table) {
 			p->error = -ENOMEM;
-			__set_current_state(TASK_RUNNING);
 			return NULL;
 		}
 		new_table->entry = new_table->entries;
@@ -171,20 +168,75 @@ static struct poll_table_entry *poll_get_entry(poll_table *_p)
 	return table->entry++;
 }
 
+static int pollwake(wait_queue_t *wait, unsigned mode, int sync, void *key)
+{
+	struct poll_wqueues *pwq = wait->private;
+	DECLARE_WAITQUEUE(dummy_wait, pwq->polling_task);
+
+	/*
+	 * Although this function is called under waitqueue lock, LOCK
+	 * doesn't imply write barrier and the users expect write
+	 * barrier semantics on wakeup functions.  The following
+	 * smp_wmb() is equivalent to smp_wmb() in try_to_wake_up()
+	 * and is paired with set_mb() in poll_schedule_timeout.
+	 */
+	smp_wmb();
+	pwq->triggered = 1;
+
+	/*
+	 * Perform the default wake up operation using a dummy
+	 * waitqueue.
+	 *
+	 * TODO: This is hacky but there currently is no interface to
+	 * pass in @sync.  @sync is scheduled to be removed and once
+	 * that happens, wake_up_process() can be used directly.
+	 */
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
 
+int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
+			  ktime_t *expires, unsigned long slack)
+{
+	int rc = -EINTR;
+
+	set_current_state(state);
+	if (!pwq->triggered)
+		rc = schedule_hrtimeout_range(expires, slack, HRTIMER_MODE_ABS);
+	__set_current_state(TASK_RUNNING);
+
+	/*
+	 * Prepare for the next iteration.
+	 *
+	 * The following set_mb() serves two purposes.  First, it's
+	 * the counterpart rmb of the wmb in pollwake() such that data
+	 * written before wake up is always visible after wake up.
+	 * Second, the full barrier guarantees that triggered clearing
+	 * doesn't pass event check of the next iteration.  Note that
+	 * this problem doesn't exist for the first iteration as
+	 * add_wait_queue() has full barrier semantics.
+	 */
+	set_mb(pwq->triggered, 0);
+
+	return rc;
+}
+EXPORT_SYMBOL(poll_schedule_timeout);
+
 /**
  * poll_select_set_timeout - helper function to setup the timeout value
  * @to:		pointer to timespec variable for the final timeout
@@ -340,8 +392,6 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
 	for (;;) {
 		unsigned long *rinp, *routp, *rexp, *inp, *outp, *exp;
 
-		set_current_state(TASK_INTERRUPTIBLE);
-
 		inp = fds->in; outp = fds->out; exp = fds->ex;
 		rinp = fds->res_in; routp = fds->res_out; rexp = fds->res_ex;
 
@@ -411,10 +461,10 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
 			to = &expire;
 		}
 
-		if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS))
+		if (!poll_schedule_timeout(&table, TASK_INTERRUPTIBLE,
+					   to, slack))
 			timed_out = 1;
 	}
-	__set_current_state(TASK_RUNNING);
 
 	poll_freewait(&table);
 
@@ -666,7 +716,6 @@ static int do_poll(unsigned int nfds,  struct poll_list *list,
 	for (;;) {
 		struct poll_list *walk;
 
-		set_current_state(TASK_INTERRUPTIBLE);
 		for (walk = list; walk != NULL; walk = walk->next) {
 			struct pollfd * pfd, * pfd_end;
 
@@ -709,10 +758,9 @@ static int do_poll(unsigned int nfds,  struct poll_list *list,
 			to = &expire;
 		}
 
-		if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS))
+		if (!poll_schedule_timeout(wait, TASK_INTERRUPTIBLE, to, slack))
 			timed_out = 1;
 	}
-	__set_current_state(TASK_RUNNING);
 	return count;
 }
 
diff --git a/include/linux/poll.h b/include/linux/poll.h
index badd98a..8c24ef8 100644
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -46,9 +46,9 @@ static inline void init_poll_funcptr(poll_table *pt, poll_queue_proc qproc)
 }
 
 struct poll_table_entry {
-	struct file * filp;
+	struct file *filp;
 	wait_queue_t wait;
-	wait_queue_head_t * wait_address;
+	wait_queue_head_t *wait_address;
 };
 
 /*
@@ -56,7 +56,9 @@ struct poll_table_entry {
  */
 struct poll_wqueues {
 	poll_table pt;
-	struct poll_table_page * table;
+	struct poll_table_page *table;
+	struct task_struct *polling_task;
+	int triggered;
 	int error;
 	int inline_index;
 	struct poll_table_entry inline_entries[N_INLINE_POLL_ENTRIES];
@@ -64,6 +66,13 @@ struct poll_wqueues {
 
 extern void poll_initwait(struct poll_wqueues *pwq);
 extern void poll_freewait(struct poll_wqueues *pwq);
+extern int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
+				 ktime_t *expires, unsigned long slack);
+
+static inline int poll_schedule(struct poll_wqueues *pwq, int state)
+{
+	return poll_schedule_timeout(pwq, state, NULL, 0);
+}
 
 /*
  * Scaleable version of the fd_set.
