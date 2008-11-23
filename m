Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbYKWB0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbYKWB0x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 20:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbYKWB0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 20:26:41 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:21501 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbYKWB0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 20:26:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Q0Q5j+j0LPxt8eITqnLw0qwskx2qa0xU4DPU3/05X8Cvwhfsw5s+yO0CRp2J8X8oac
         uaGDpjVHOwoRw4PUiMmL9qia5J80y9tNBkHVI2PQu/beXsz7abXtQjZv6cvO5tKstMLA
         TMn/PomcvRcpel2INnqcOlP9el/FF0izlOR8w=
Message-ID: <4928B162.9030404@gmail.com>
Date: Sun, 23 Nov 2008 10:26:58 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Matthew Wilcox <matthew@wil.cx>, Miklos Szeredi <miklos@szeredi.hu>,
       arjan@linux.intel.com, torvalds@linux-foundation.org, hch@infradead.org,
       mingo@elte.hu, rminnich@sandia.gov, ericvh@gmail.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: poll: allow f_op->poll to sleep, take #3
References: <E1L3oK1-0001Pz-J9@pomaz-ex.szeredi.hu>	<20081122123942.GF5707@parisc-linux.org>	<4927FE87.6050005@gmail.com> <20081122105356.87856d04.akpm@linux-foundation.org>
In-Reply-To: <20081122105356.87856d04.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
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
and is beneficial to userland filesystem implementations like FUSE, 9p
or peculiar fs like spufs as it's very difficult for those to
implement non-sleeping poll method.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>
---
@state dropped.

 Documentation/filesystems/Locking |    2 -
 drivers/media/video/v4l1-compat.c |    4 ---
 fs/select.c                       |   50 +++++++++++++++++++++++++++-----------
 include/linux/poll.h              |   15 +++++++++--
 4 files changed, 50 insertions(+), 21 deletions(-)

Index: work/fs/select.c
===================================================================
--- work.orig/fs/select.c
+++ work/fs/select.c
@@ -109,11 +109,11 @@ static void __pollwait(struct file *filp
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
@@ -142,12 +142,10 @@ void poll_freewait(struct poll_wqueues *
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
@@ -159,7 +157,6 @@ static struct poll_table_entry *poll_get
 		new_table = (struct poll_table_page *) __get_free_page(GFP_KERNEL);
 		if (!new_table) {
 			p->error = -ENOMEM;
-			__set_current_state(TASK_RUNNING);
 			return NULL;
 		}
 		new_table->entry = new_table->entries;
@@ -171,20 +168,50 @@ static struct poll_table_entry *poll_get
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
 
+int poll_schedule_timeout(struct poll_wqueues *pwq,
+			  ktime_t *expires, unsigned long slack)
+{
+	int rc = -EINTR;
+
+	set_current_state(TASK_INTERRUPTIBLE);
+	if (!pwq->triggered)
+		rc = schedule_hrtimeout_range(expires, slack, HRTIMER_MODE_ABS);
+	__set_current_state(TASK_RUNNING);
+
+	/* clear triggered for the next iteration */
+	pwq->triggered = 0;
+
+	return rc;
+}
+EXPORT_SYMBOL(poll_schedule_timeout);
+
 /**
  * poll_select_set_timeout - helper function to setup the timeout value
  * @to:		pointer to timespec variable for the final timeout
@@ -340,8 +367,6 @@ int do_select(int n, fd_set_bits *fds, s
 	for (;;) {
 		unsigned long *rinp, *routp, *rexp, *inp, *outp, *exp;
 
-		set_current_state(TASK_INTERRUPTIBLE);
-
 		inp = fds->in; outp = fds->out; exp = fds->ex;
 		rinp = fds->res_in; routp = fds->res_out; rexp = fds->res_ex;
 
@@ -411,10 +436,9 @@ int do_select(int n, fd_set_bits *fds, s
 			to = &expire;
 		}
 
-		if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS))
+		if (!poll_schedule_timeout(&table, to, slack))
 			timed_out = 1;
 	}
-	__set_current_state(TASK_RUNNING);
 
 	poll_freewait(&table);
 
@@ -666,7 +690,6 @@ static int do_poll(unsigned int nfds,  s
 	for (;;) {
 		struct poll_list *walk;
 
-		set_current_state(TASK_INTERRUPTIBLE);
 		for (walk = list; walk != NULL; walk = walk->next) {
 			struct pollfd * pfd, * pfd_end;
 
@@ -709,10 +732,9 @@ static int do_poll(unsigned int nfds,  s
 			to = &expire;
 		}
 
-		if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS))
+		if (!poll_schedule_timeout(wait, to, slack))
 			timed_out = 1;
 	}
-	__set_current_state(TASK_RUNNING);
 	return count;
 }
 
Index: work/include/linux/poll.h
===================================================================
--- work.orig/include/linux/poll.h
+++ work/include/linux/poll.h
@@ -46,9 +46,9 @@ static inline void init_poll_funcptr(pol
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
+extern int poll_schedule_timeout(struct poll_wqueues *pwq,
+				 ktime_t *expires, unsigned long slack);
+
+static inline int poll_schedule(struct poll_wqueues *pwq)
+{
+	return poll_schedule_timeout(pwq, NULL, 0);
+}
 
 /*
  * Scaleable version of the fd_set.
Index: work/drivers/media/video/v4l1-compat.c
===================================================================
--- work.orig/drivers/media/video/v4l1-compat.c
+++ work/drivers/media/video/v4l1-compat.c
@@ -203,7 +203,6 @@ static int poll_one(struct file *file, s
 	table = &pwq->pt;
 	for (;;) {
 		int mask;
-		set_current_state(TASK_INTERRUPTIBLE);
 		mask = file->f_op->poll(file, table);
 		if (mask & POLLIN)
 			break;
@@ -212,9 +211,8 @@ static int poll_one(struct file *file, s
 			retval = -ERESTARTSYS;
 			break;
 		}
-		schedule();
+		poll_schedule(pwq);
 	}
-	set_current_state(TASK_RUNNING);
 	poll_freewait(pwq);
 	return retval;
 }
Index: work/Documentation/filesystems/Locking
===================================================================
--- work.orig/Documentation/filesystems/Locking
+++ work/Documentation/filesystems/Locking
@@ -398,7 +398,7 @@ prototypes:
 };
 
 locking rules:
-	All except ->poll() may block.
+	All may block.
 			BKL
 llseek:			no	(see below)
 read:			no
