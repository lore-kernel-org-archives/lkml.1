Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab0BXUEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:04:25 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:55822 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab0BXUEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:04:23 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: paulmck@linux.vnet.ibm.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
Subject: [PATCH 04/10] credentials: rcu annotation
Date: Wed, 24 Feb 2010 21:04:00 +0100
Message-Id: <1267041846-10469-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267041846-10469-1-git-send-email-arnd@arndb.de>
References: <1267041846-10469-1-git-send-email-arnd@arndb.de>
In-Reply-To: <20100223180127.GF6700@linux.vnet.ibm.com>
References: <20100223180127.GF6700@linux.vnet.ibm.com>
X-Provags-ID: V01U2FsdGVkX18vOmA0X4+lgv/ppHhPYPL9hVm1ObGauttzgjr
 6rbPV4+OanLNBaHRTdUgI3frKZR6YLJZDIv0a0DukV10TsCgif
 /YSp3I7adRp/ndS8FEtWw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/cred.h  |    4 +-
 include/linux/sched.h |    4 +-
 kernel/cred.c         |   50 +++++++++++++++++++++++++-----------------------
 kernel/fork.c         |    4 +-
 4 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index 4e3387a..944fdfc 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -267,7 +267,7 @@ static inline void put_cred(const struct cred *_cred)
  * Access the subjective credentials of the current task.
  */
 #define current_cred() \
-	(current->cred)
+	__rcu_dereference(current->cred)
 
 /**
  * __task_cred - Access a task's objective credentials
@@ -356,7 +356,7 @@ static inline void put_cred(const struct cred *_cred)
 
 #define current_cred_xxx(xxx)			\
 ({						\
-	current->cred->xxx;			\
+	__rcu_dereference(current->cred)->xxx;	\
 })
 
 #define current_uid()		(current_cred_xxx(uid))
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 038e16f..52a33eb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1361,9 +1361,9 @@ struct task_struct {
 	struct list_head cpu_timers[3];
 
 /* process credentials */
-	const struct cred *real_cred;	/* objective and real subjective task
+	const struct cred __rcu *real_cred; /* objective and real subjective task
 					 * credentials (COW) */
-	const struct cred *cred;	/* effective (overridable) subjective task
+	const struct cred __rcu *cred;	/* effective (overridable) subjective task
 					 * credentials (COW) */
 	struct mutex cred_guard_mutex;	/* guard against foreign influences on
 					 * credential calculations
diff --git a/kernel/cred.c b/kernel/cred.c
index 1ed8ca1..eed586d 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -171,8 +171,8 @@ void __put_cred(struct cred *cred)
 	cred->magic = CRED_MAGIC_DEAD;
 	cred->put_addr = __builtin_return_address(0);
 #endif
-	BUG_ON(cred == current->cred);
-	BUG_ON(cred == current->real_cred);
+	BUG_ON(cred == __rcu_dereference(current->cred));
+	BUG_ON(cred == __rcu_dereference(current->real_cred));
 
 	call_rcu(&cred->rcu, put_cred_rcu);
 }
@@ -183,23 +183,22 @@ EXPORT_SYMBOL(__put_cred);
  */
 void exit_creds(struct task_struct *tsk)
 {
-	struct cred *cred;
+	struct cred *cred = (struct cred *)rcu_dereference(tsk->cred);
+	struct cred *real_cred = (struct cred *)rcu_dereference(tsk->real_cred);
 
-	kdebug("exit_creds(%u,%p,%p,{%d,%d})", tsk->pid, tsk->real_cred, tsk->cred,
-	       atomic_read(&tsk->cred->usage),
-	       read_cred_subscribers(tsk->cred));
+	kdebug("exit_creds(%u,%p,%p,{%d,%d})", tsk->pid,
+	       real_cred, cred, atomic_read(&cred->usage),
+	       read_cred_subscribers(cred));
 
-	cred = (struct cred *) tsk->real_cred;
 	tsk->real_cred = NULL;
 	validate_creds(cred);
 	alter_cred_subscribers(cred, -1);
 	put_cred(cred);
 
-	cred = (struct cred *) tsk->cred;
 	tsk->cred = NULL;
-	validate_creds(cred);
-	alter_cred_subscribers(cred, -1);
-	put_cred(cred);
+	validate_creds(real_cred);
+	alter_cred_subscribers(real_cred, -1);
+	put_cred(real_cred);
 
 	cred = (struct cred *) tsk->replacement_session_keyring;
 	if (cred) {
@@ -273,7 +272,7 @@ struct cred *prepare_creds(void)
 
 	kdebug("prepare_creds() alloc %p", new);
 
-	old = task->cred;
+	old = rcu_dereference(task->cred);
 	memcpy(new, old, sizeof(struct cred));
 
 	atomic_set(&new->usage, 1);
@@ -415,23 +414,25 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 	struct thread_group_cred *tgcred;
 #endif
 	struct cred *new;
+	const struct cred *cred;
 	int ret;
 
 	mutex_init(&p->cred_guard_mutex);
 
+	cred = rcu_dereference(p->cred);
 	if (
 #ifdef CONFIG_KEYS
-		!p->cred->thread_keyring &&
+		!cred->thread_keyring &&
 #endif
 		clone_flags & CLONE_THREAD
 	    ) {
-		p->real_cred = get_cred(p->cred);
-		get_cred(p->cred);
-		alter_cred_subscribers(p->cred, 2);
+		rcu_assign_pointer(p->real_cred, get_cred(cred));
+		get_cred(cred);
+		alter_cred_subscribers(cred, 2);
 		kdebug("share_creds(%p{%d,%d})",
-		       p->cred, atomic_read(&p->cred->usage),
-		       read_cred_subscribers(p->cred));
-		atomic_inc(&p->cred->user->processes);
+		       cred, atomic_read(&cred->usage),
+		       read_cred_subscribers(cred));
+		atomic_inc(&cred->user->processes);
 		return 0;
 	}
 
@@ -475,7 +476,8 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 #endif
 
 	atomic_inc(&new->user->processes);
-	p->cred = p->real_cred = get_cred(new);
+	rcu_assign_pointer(p->cred, get_cred(new));
+	rcu_assign_pointer(p->real_cred, new);
 	alter_cred_subscribers(new, 2);
 	validate_creds(new);
 	return 0;
@@ -502,13 +504,13 @@ error_put:
 int commit_creds(struct cred *new)
 {
 	struct task_struct *task = current;
-	const struct cred *old = task->real_cred;
+	const struct cred *old = __rcu_dereference(task->real_cred);
 
 	kdebug("commit_creds(%p{%d,%d})", new,
 	       atomic_read(&new->usage),
 	       read_cred_subscribers(new));
 
-	BUG_ON(task->cred != old);
+	BUG_ON(__rcu_dereference(task->cred) != old);
 #ifdef CONFIG_DEBUG_CREDENTIALS
 	BUG_ON(read_cred_subscribers(old) < 2);
 	validate_creds(old);
@@ -605,7 +607,7 @@ EXPORT_SYMBOL(abort_creds);
  */
 const struct cred *override_creds(const struct cred *new)
 {
-	const struct cred *old = current->cred;
+	const struct cred *old = rcu_dereference(current->cred);
 
 	kdebug("override_creds(%p{%d,%d})", new,
 	       atomic_read(&new->usage),
@@ -634,7 +636,7 @@ EXPORT_SYMBOL(override_creds);
  */
 void revert_creds(const struct cred *old)
 {
-	const struct cred *override = current->cred;
+	const struct cred *override = rcu_dereference(current->cred);
 
 	kdebug("revert_creds(%p{%d,%d})", old,
 	       atomic_read(&old->usage),
diff --git a/kernel/fork.c b/kernel/fork.c
index f88bd98..ba7489b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1032,10 +1032,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	DEBUG_LOCKS_WARN_ON(!p->softirqs_enabled);
 #endif
 	retval = -EAGAIN;
-	if (atomic_read(&p->real_cred->user->processes) >=
+	if (atomic_read(&rcu_dereference(p->real_cred)->user->processes) >=
 			p->signal->rlim[RLIMIT_NPROC].rlim_cur) {
 		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
-		    p->real_cred->user != INIT_USER)
+		    rcu_dereference(p->real_cred)->user != INIT_USER)
 			goto bad_fork_free;
 	}
 
-- 
1.6.3.3

