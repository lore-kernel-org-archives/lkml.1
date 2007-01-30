Return-Path: <linux-kernel-owner+w=401wt.eu-S1751731AbXA3Vjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbXA3Vjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 16:39:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbXA3Vjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 16:39:48 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:46902 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbXA3Vjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 16:39:47 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 4] Introduce per_call_chain()
X-Mercurial-Node: 26e278468209e9be26ffdcea39e6c168a5fce710
Message-Id: <26e278468209e9be26ff.1170193182@tetsuo.zabbo.net>
In-Reply-To: <patchbomb.1170193181@tetsuo.zabbo.net>
Date: Tue, 30 Jan 2007 13:39:42 -0700
From: Zach Brown <zach.brown@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are members of task_struct which are only used by a given call chain to
pass arguments up and down the chain itself.  They are logically thread-local
storage.

The patches later in the series want to have multiple calls pending for a given
task, though only one will be executing at a given time.  By putting these
thread-local members of task_struct in a seperate storage structure we're able
to trivially swap them in and out as their calls are swapped in and out.

per_call_chain() doesn't have a terribly great name. It was chosen in the
spirit of per_cpu().

The storage was left inline in task_struct to avoid introducing indirection for
the vast majority of uses which will never have multiple calls executing in a
task.

I chose a few members of task_struct to migrate under per_call_chain() along
with the introduction as an example of what it looks like.  These would be
seperate patches in a patch series that was suitable for merging.

diff -r b1128b48dc99 -r 26e278468209 fs/jbd/journal.c
--- a/fs/jbd/journal.c	Fri Jan 12 20:00:03 2007 +0000
+++ b/fs/jbd/journal.c	Mon Jan 29 15:36:13 2007 -0800
@@ -471,7 +471,7 @@ int journal_force_commit_nested(journal_
 	tid_t tid;
 
 	spin_lock(&journal->j_state_lock);
-	if (journal->j_running_transaction && !current->journal_info) {
+	if (journal->j_running_transaction && !per_call_chain(journal_info)) {
 		transaction = journal->j_running_transaction;
 		__log_start_commit(journal, transaction->t_tid);
 	} else if (journal->j_committing_transaction)
diff -r b1128b48dc99 -r 26e278468209 fs/jbd/transaction.c
--- a/fs/jbd/transaction.c	Fri Jan 12 20:00:03 2007 +0000
+++ b/fs/jbd/transaction.c	Mon Jan 29 15:36:13 2007 -0800
@@ -279,12 +279,12 @@ handle_t *journal_start(journal_t *journ
 	if (!handle)
 		return ERR_PTR(-ENOMEM);
 
-	current->journal_info = handle;
+	per_call_chain(journal_info) = handle;
 
 	err = start_this_handle(journal, handle);
 	if (err < 0) {
 		jbd_free_handle(handle);
-		current->journal_info = NULL;
+		per_call_chain(journal_info) = NULL;
 		handle = ERR_PTR(err);
 	}
 	return handle;
@@ -1368,7 +1368,7 @@ int journal_stop(handle_t *handle)
 		} while (old_handle_count != transaction->t_handle_count);
 	}
 
-	current->journal_info = NULL;
+	per_call_chain(journal_info) = NULL;
 	spin_lock(&journal->j_state_lock);
 	spin_lock(&transaction->t_handle_lock);
 	transaction->t_outstanding_credits -= handle->h_buffer_credits;
diff -r b1128b48dc99 -r 26e278468209 fs/namei.c
--- a/fs/namei.c	Fri Jan 12 20:00:03 2007 +0000
+++ b/fs/namei.c	Mon Jan 29 15:36:13 2007 -0800
@@ -628,20 +628,20 @@ static inline int do_follow_link(struct 
 static inline int do_follow_link(struct path *path, struct nameidata *nd)
 {
 	int err = -ELOOP;
-	if (current->link_count >= MAX_NESTED_LINKS)
+	if (per_call_chain(link_count) >= MAX_NESTED_LINKS)
 		goto loop;
-	if (current->total_link_count >= 40)
+	if (per_call_chain(total_link_count) >= 40)
 		goto loop;
 	BUG_ON(nd->depth >= MAX_NESTED_LINKS);
 	cond_resched();
 	err = security_inode_follow_link(path->dentry, nd);
 	if (err)
 		goto loop;
-	current->link_count++;
-	current->total_link_count++;
+	per_call_chain(link_count)++;
+	per_call_chain(total_link_count)++;
 	nd->depth++;
 	err = __do_follow_link(path, nd);
-	current->link_count--;
+	per_call_chain(link_count)--;
 	nd->depth--;
 	return err;
 loop:
@@ -1025,7 +1025,7 @@ int fastcall link_path_walk(const char *
 
 int fastcall path_walk(const char * name, struct nameidata *nd)
 {
-	current->total_link_count = 0;
+	per_call_chain(total_link_count) = 0;
 	return link_path_walk(name, nd);
 }
 
@@ -1153,7 +1153,7 @@ static int fastcall do_path_lookup(int d
 
 		fput_light(file, fput_needed);
 	}
-	current->total_link_count = 0;
+	per_call_chain(total_link_count) = 0;
 	retval = link_path_walk(name, nd);
 out:
 	if (likely(retval == 0)) {
diff -r b1128b48dc99 -r 26e278468209 include/linux/init_task.h
--- a/include/linux/init_task.h	Fri Jan 12 20:00:03 2007 +0000
+++ b/include/linux/init_task.h	Mon Jan 29 15:36:13 2007 -0800
@@ -88,6 +88,11 @@ extern struct nsproxy init_nsproxy;
 
 extern struct group_info init_groups;
 
+#define INIT_PER_CALL_CHAIN(tsk)					\
+{									\
+	.journal_info	= NULL,						\
+}
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -124,6 +129,7 @@ extern struct group_info init_groups;
 	.keep_capabilities = 0,						\
 	.user		= INIT_USER,					\
 	.comm		= "swapper",					\
+	.per_call	= INIT_PER_CALL_CHAIN(tsk),			\
 	.thread		= INIT_THREAD,					\
 	.fs		= &init_fs,					\
 	.files		= &init_files,					\
@@ -135,7 +141,6 @@ extern struct group_info init_groups;
 		.signal = {{0}}},					\
 	.blocked	= {{0}},					\
 	.alloc_lock	= __SPIN_LOCK_UNLOCKED(tsk.alloc_lock),		\
-	.journal_info	= NULL,						\
 	.cpu_timers	= INIT_CPU_TIMERS(tsk.cpu_timers),		\
 	.fs_excl	= ATOMIC_INIT(0),				\
 	.pi_lock	= SPIN_LOCK_UNLOCKED,				\
diff -r b1128b48dc99 -r 26e278468209 include/linux/jbd.h
--- a/include/linux/jbd.h	Fri Jan 12 20:00:03 2007 +0000
+++ b/include/linux/jbd.h	Mon Jan 29 15:36:13 2007 -0800
@@ -883,7 +883,7 @@ extern void		__wait_on_journal (journal_
 
 static inline handle_t *journal_current_handle(void)
 {
-	return current->journal_info;
+	return per_call_chain(journal_info);
 }
 
 /* The journaling code user interface:
diff -r b1128b48dc99 -r 26e278468209 include/linux/sched.h
--- a/include/linux/sched.h	Fri Jan 12 20:00:03 2007 +0000
+++ b/include/linux/sched.h	Mon Jan 29 15:36:13 2007 -0800
@@ -784,6 +784,20 @@ static inline void prefetch_stack(struct
 static inline void prefetch_stack(struct task_struct *t) { }
 #endif
 
+/*
+ * Members of this structure are used to pass arguments down call chains
+ * without specific arguments.  Historically they lived on task_struct,
+ * putting them in one place gives us some flexibility.  They're accessed
+ * with per_call_chain(name).
+ */
+struct per_call_chain_storage {
+	int link_count;		/* number of links in one symlink */
+	int total_link_count;	/* total links followed in a lookup */
+	void *journal_info;	/* journalling filesystem info */
+};
+
+#define per_call_chain(foo) current->per_call.foo
+
 struct audit_context;		/* See audit.c */
 struct mempolicy;
 struct pipe_inode_info;
@@ -920,7 +934,7 @@ struct task_struct {
 				       it with task_lock())
 				     - initialized normally by flush_old_exec */
 /* file system info */
-	int link_count, total_link_count;
+	struct per_call_chain_storage per_call;
 #ifdef CONFIG_SYSVIPC
 /* ipc stuff */
 	struct sysv_sem sysvsem;
@@ -993,9 +1007,6 @@ struct task_struct {
 	struct held_lock held_locks[MAX_LOCK_DEPTH];
 	unsigned int lockdep_recursion;
 #endif
-
-/* journalling filesystem info */
-	void *journal_info;
 
 /* VM state */
 	struct reclaim_state *reclaim_state;
