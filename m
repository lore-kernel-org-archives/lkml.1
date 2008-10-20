Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbYJTXBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbYJTXBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYJTXBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:01:39 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:35744 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbYJTXBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:01:38 -0400
Date: Mon, 20 Oct 2008 18:01:30 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael Halcrow <mhalcrow@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] User namespaces: set of cleanups (v2)
Message-ID: <20081020230130.GA31304@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The user_ns is moved from nsproxy to user_struct, so that a struct
cred by itself is sufficient to determine access (which it otherwise
would not be).  Corresponding ecryptfs fixes (by David Howells) are
here as well.

Fix refcounting.  The following rules now apply:
        1. The task pins the user struct.
        2. The user struct pins its user namespace.
        3. The user namespace pins the struct user which created it.

User namespaces are cloned during copy_creds().  Unsharing a new user_ns
is no longer possible.  (We could re-add that, but it'll cause code
duplication and doesn't seem useful if PAM doesn't need to clone user
namespaces).

When a user namespace is created, its first user (uid 0) gets empty
keyrings and a clean group_info.

This incorporates a previous patch by David Howells.  Here
is his original patch description:

>I suggest adding the attached incremental patch.  It makes the following
>changes:
>
> (1) Provides a current_user_ns() macro to wrap accesses to current's user
>     namespace.
>
> (2) Fixes eCryptFS.
>
> (3) Renames create_new_userns() to create_user_ns() to be more consistent
>     with the other associated functions and because the 'new' in the name is
>     superfluous.
>
> (4) Moves the argument and permission checks made for CLONE_NEWUSER to the
>     beginning of do_fork() so that they're done prior to making any attempts
>     at allocation.
>
> (5) Calls create_user_ns() after prepare_creds(), and gives it the new creds
>     to fill in rather than have it return the new root user.  I don't imagine
>     the new root user being used for anything other than filling in a cred
>     struct.
>
>     This also permits me to get rid of a get_uid() and a free_uid(), as the
>     reference the creds were holding on the old user_struct can just be
>     transferred to the new namespace's creator pointer.
>
> (6) Makes create_user_ns() reset the UIDs and GIDs of the creds under
>     preparation rather than doing it in copy_creds().
>
>David

>Signed-off-by: David Howells <dhowells@redhat.com>

Changelog:
	Oct 20: integrate dhowells comments
		1. leave thread_keyring alone
		2. use current_user_ns() in set_user()

Signed-off-by: Serge Hallyn <serue@us.ibm.com>

---

 fs/ecryptfs/messaging.c        |   13 +++----
 fs/ecryptfs/miscdev.c          |   19 ++++------
 include/linux/cred.h           |    2 +
 include/linux/init_task.h      |    1 -
 include/linux/nsproxy.h        |    1 -
 include/linux/sched.h          |    1 +
 include/linux/user_namespace.h |   13 ++-----
 kernel/cred.c                  |   15 +++++++-
 kernel/fork.c                  |   19 +++++++++-
 kernel/nsproxy.c               |   15 +-------
 kernel/sys.c                   |    4 +-
 kernel/user.c                  |   47 +++++++------------------
 kernel/user_namespace.c        |   75 ++++++++++++++++------------------------
 13 files changed, 96 insertions(+), 129 deletions(-)

baaa8d300c8f21a77c323ab41616c865c4f04a20
diff --git a/fs/ecryptfs/messaging.c b/fs/ecryptfs/messaging.c
index 92bf606..eecb8b5 100644
--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -376,7 +376,7 @@ int ecryptfs_process_response(struct ecr
 	struct ecryptfs_msg_ctx *msg_ctx;
 	size_t msg_size;
 	struct nsproxy *nsproxy;
-	struct user_namespace *current_user_ns;
+	struct user_namespace *tsk_user_ns;
 	uid_t ctx_euid;
 	int rc;
 
@@ -401,9 +401,9 @@ int ecryptfs_process_response(struct ecr
 		mutex_unlock(&ecryptfs_daemon_hash_mux);
 		goto wake_up;
 	}
-	current_user_ns = nsproxy->user_ns;
+	tsk_user_ns = __task_cred(msg_ctx->task)->user->user_ns;
 	ctx_euid = task_euid(msg_ctx->task);
-	rc = ecryptfs_find_daemon_by_euid(&daemon, ctx_euid, current_user_ns);
+	rc = ecryptfs_find_daemon_by_euid(&daemon, ctx_euid, tsk_user_ns);
 	rcu_read_unlock();
 	mutex_unlock(&ecryptfs_daemon_hash_mux);
 	if (rc) {
@@ -421,11 +421,11 @@ int ecryptfs_process_response(struct ecr
 		       euid, ctx_euid);
 		goto unlock;
 	}
-	if (current_user_ns != user_ns) {
+	if (tsk_user_ns != user_ns) {
 		rc = -EBADMSG;
 		printk(KERN_WARNING "%s: Received message from user_ns "
 		       "[0x%p]; expected message from user_ns [0x%p]\n",
-		       __func__, user_ns, nsproxy->user_ns);
+		       __func__, user_ns, tsk_user_ns);
 		goto unlock;
 	}
 	if (daemon->pid != pid) {
@@ -486,8 +486,7 @@ ecryptfs_send_message_locked(unsigned in
 	uid_t euid = current_euid();
 	int rc;
 
-	rc = ecryptfs_find_daemon_by_euid(&daemon, euid,
-					  current->nsproxy->user_ns);
+	rc = ecryptfs_find_daemon_by_euid(&daemon, euid, current_user_ns());
 	if (rc || !daemon) {
 		rc = -ENOTCONN;
 		printk(KERN_ERR "%s: User [%d] does not have a daemon "
diff --git a/fs/ecryptfs/miscdev.c b/fs/ecryptfs/miscdev.c
index 047ac60..efd95a0 100644
--- a/fs/ecryptfs/miscdev.c
+++ b/fs/ecryptfs/miscdev.c
@@ -47,8 +47,7 @@ ecryptfs_miscdev_poll(struct file *file,
 
 	mutex_lock(&ecryptfs_daemon_hash_mux);
 	/* TODO: Just use file->private_data? */
-	rc = ecryptfs_find_daemon_by_euid(&daemon, euid,
-					  current->nsproxy->user_ns);
+	rc = ecryptfs_find_daemon_by_euid(&daemon, euid, current_user_ns());
 	BUG_ON(rc || !daemon);
 	mutex_lock(&daemon->mux);
 	mutex_unlock(&ecryptfs_daemon_hash_mux);
@@ -95,11 +94,9 @@ ecryptfs_miscdev_open(struct inode *inod
 		       "count; rc = [%d]\n", __func__, rc);
 		goto out_unlock_daemon_list;
 	}
-	rc = ecryptfs_find_daemon_by_euid(&daemon, euid,
-					  current->nsproxy->user_ns);
+	rc = ecryptfs_find_daemon_by_euid(&daemon, euid, current_user_ns());
 	if (rc || !daemon) {
-		rc = ecryptfs_spawn_daemon(&daemon, euid,
-					   current->nsproxy->user_ns,
+		rc = ecryptfs_spawn_daemon(&daemon, euid, current_user_ns(),
 					   task_pid(current));
 		if (rc) {
 			printk(KERN_ERR "%s: Error attempting to spawn daemon; "
@@ -153,8 +150,7 @@ ecryptfs_miscdev_release(struct inode *i
 	int rc;
 
 	mutex_lock(&ecryptfs_daemon_hash_mux);
-	rc = ecryptfs_find_daemon_by_euid(&daemon, euid,
-					  current->nsproxy->user_ns);
+	rc = ecryptfs_find_daemon_by_euid(&daemon, euid, current_user_ns());
 	BUG_ON(rc || !daemon);
 	mutex_lock(&daemon->mux);
 	BUG_ON(daemon->pid != task_pid(current));
@@ -254,8 +250,7 @@ ecryptfs_miscdev_read(struct file *file,
 
 	mutex_lock(&ecryptfs_daemon_hash_mux);
 	/* TODO: Just use file->private_data? */
-	rc = ecryptfs_find_daemon_by_euid(&daemon, euid,
-					  current->nsproxy->user_ns);
+	rc = ecryptfs_find_daemon_by_euid(&daemon, euid, current_user_ns());
 	BUG_ON(rc || !daemon);
 	mutex_lock(&daemon->mux);
 	if (daemon->flags & ECRYPTFS_DAEMON_ZOMBIE) {
@@ -295,7 +290,7 @@ check_list:
 		goto check_list;
 	}
 	BUG_ON(euid != daemon->euid);
-	BUG_ON(current->nsproxy->user_ns != daemon->user_ns);
+	BUG_ON(current_user_ns() != daemon->user_ns);
 	BUG_ON(task_pid(current) != daemon->pid);
 	msg_ctx = list_first_entry(&daemon->msg_ctx_out_queue,
 				   struct ecryptfs_msg_ctx, daemon_out_list);
@@ -468,7 +463,7 @@ ecryptfs_miscdev_write(struct file *file
 			goto out_free;
 		}
 		rc = ecryptfs_miscdev_response(&data[i], packet_size,
-					       euid, current->nsproxy->user_ns,
+					       euid, current_user_ns(),
 					       task_pid(current), seq);
 		if (rc)
 			printk(KERN_WARNING "%s: Failed to deliver miscdev "
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 26c1ab1..3282ee4 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -60,6 +60,7 @@ do {							\
 } while (0)
 
 extern struct group_info *groups_alloc(int);
+extern struct group_info init_groups;
 extern void groups_free(struct group_info *);
 extern int set_current_groups(struct group_info *);
 extern int set_groups(struct cred *, struct group_info *);
@@ -315,6 +316,7 @@ static inline void put_cred(const struct
 #define current_fsgid() 	(current_cred_xxx(fsgid))
 #define current_cap()		(current_cred_xxx(cap_effective))
 #define current_user()		(current_cred_xxx(user))
+#define current_user_ns()	(current_cred_xxx(user)->user_ns)
 #define current_security()	(current_cred_xxx(security))
 
 #define current_uid_gid(_uid, _gid)		\
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index edf0285..126c3c4 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -57,7 +57,6 @@ extern struct nsproxy init_nsproxy;
 	.mnt_ns		= NULL,						\
 	INIT_NET_NS(net_ns)                                             \
 	INIT_IPC_NS(ipc_ns)						\
-	.user_ns	= &init_user_ns,				\
 }
 
 #define INIT_SIGHAND(sighand) {						\
diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index c8a768e..afad7de 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -27,7 +27,6 @@ struct nsproxy {
 	struct ipc_namespace *ipc_ns;
 	struct mnt_namespace *mnt_ns;
 	struct pid_namespace *pid_ns;
-	struct user_namespace *user_ns;
 	struct net 	     *net_ns;
 };
 extern struct nsproxy init_nsproxy;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0812cfd..02693db 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -595,6 +595,7 @@ struct user_struct {
 	/* Hash table maintenance information */
 	struct hlist_node uidhash_node;
 	uid_t uid;
+	struct user_namespace *user_ns;
 
 #ifdef CONFIG_USER_SCHED
 	struct task_group *tg;
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index b5f41d4..315bcd3 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -12,7 +12,7 @@
 struct user_namespace {
 	struct kref		kref;
 	struct hlist_head	uidhash_table[UIDHASH_SZ];
-	struct user_struct	*root_user;
+	struct user_struct	*creator;
 };
 
 extern struct user_namespace init_user_ns;
@@ -26,8 +26,7 @@ static inline struct user_namespace *get
 	return ns;
 }
 
-extern struct user_namespace *copy_user_ns(int flags,
-					   struct user_namespace *old_ns);
+extern int create_user_ns(struct cred *new);
 extern void free_user_ns(struct kref *kref);
 
 static inline void put_user_ns(struct user_namespace *ns)
@@ -43,13 +42,9 @@ static inline struct user_namespace *get
 	return &init_user_ns;
 }
 
-static inline struct user_namespace *copy_user_ns(int flags,
-						  struct user_namespace *old_ns)
+static inline int create_user_ns(struct cred *new)
 {
-	if (flags & CLONE_NEWUSER)
-		return ERR_PTR(-EINVAL);
-
-	return old_ns;
+	return -EINVAL;
 }
 
 static inline void put_user_ns(struct user_namespace *ns)
diff --git a/kernel/cred.c b/kernel/cred.c
index 13697ca..ff7bc07 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -274,6 +274,7 @@ int copy_creds(struct task_struct *p, un
 	struct thread_group_cred *tgcred;
 #endif
 	struct cred *new;
+	int ret;
 
 	mutex_init(&p->cred_exec_mutex);
 
@@ -293,6 +294,12 @@ int copy_creds(struct task_struct *p, un
 	if (!new)
 		return -ENOMEM;
 
+	if (clone_flags & CLONE_NEWUSER) {
+		ret = create_user_ns(new);
+		if (ret < 0)
+			goto error_put;
+	}
+
 #ifdef CONFIG_KEYS
 	/* new threads get their own thread keyrings if their parent already
 	 * had one */
@@ -309,8 +316,8 @@ int copy_creds(struct task_struct *p, un
 	if (!(clone_flags & CLONE_THREAD)) {
 		tgcred = kmalloc(sizeof(*tgcred), GFP_KERNEL);
 		if (!tgcred) {
-			put_cred(new);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto error_put;
 		}
 		atomic_set(&tgcred->usage, 1);
 		spin_lock_init(&tgcred->lock);
@@ -325,6 +332,10 @@ int copy_creds(struct task_struct *p, un
 	atomic_inc(&new->user->processes);
 	p->cred = p->real_cred = get_cred(new);
 	return 0;
+
+error_put:
+	put_cred(new);
+	return ret;
 }
 
 /**
diff --git a/kernel/fork.c b/kernel/fork.c
index e392e5a..c71f3c1 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -935,7 +935,7 @@ static struct task_struct *copy_process(
 	if (atomic_read(&p->real_cred->user->processes) >=
 			p->signal->rlim[RLIMIT_NPROC].rlim_cur) {
 		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
-		    p->real_cred->user != current->nsproxy->user_ns->root_user)
+		    p->real_cred->user != INIT_USER)
 			goto bad_fork_free;
 	}
 
@@ -1312,6 +1312,20 @@ long do_fork(unsigned long clone_flags,
 	long nr;
 
 	/*
+	 * Do some preliminary argument and permissions checking before we
+	 * actually start allocating stuff
+	 */
+	if (clone_flags & CLONE_NEWUSER) {
+		if (clone_flags & CLONE_THREAD)
+			return -EINVAL;
+		/* hopefully this check will go away when userns support is
+		 * complete
+		 */
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+	}
+
+	/*
 	 * We hope to recycle these flags after 2.6.26
 	 */
 	if (unlikely(clone_flags & CLONE_STOPPED)) {
@@ -1556,8 +1570,7 @@ asmlinkage long sys_unshare(unsigned lon
 	err = -EINVAL;
 	if (unshare_flags & ~(CLONE_THREAD|CLONE_FS|CLONE_NEWNS|CLONE_SIGHAND|
 				CLONE_VM|CLONE_FILES|CLONE_SYSVSEM|
-				CLONE_NEWUTS|CLONE_NEWIPC|CLONE_NEWUSER|
-				CLONE_NEWNET))
+				CLONE_NEWUTS|CLONE_NEWIPC|CLONE_NEWNET))
 		goto bad_unshare_out;
 
 	/*
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 1d3ef29..63598dc 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -80,12 +80,6 @@ static struct nsproxy *create_new_namesp
 		goto out_pid;
 	}
 
-	new_nsp->user_ns = copy_user_ns(flags, tsk->nsproxy->user_ns);
-	if (IS_ERR(new_nsp->user_ns)) {
-		err = PTR_ERR(new_nsp->user_ns);
-		goto out_user;
-	}
-
 	new_nsp->net_ns = copy_net_ns(flags, tsk->nsproxy->net_ns);
 	if (IS_ERR(new_nsp->net_ns)) {
 		err = PTR_ERR(new_nsp->net_ns);
@@ -95,9 +89,6 @@ static struct nsproxy *create_new_namesp
 	return new_nsp;
 
 out_net:
-	if (new_nsp->user_ns)
-		put_user_ns(new_nsp->user_ns);
-out_user:
 	if (new_nsp->pid_ns)
 		put_pid_ns(new_nsp->pid_ns);
 out_pid:
@@ -130,7 +121,7 @@ int copy_namespaces(unsigned long flags,
 	get_nsproxy(old_ns);
 
 	if (!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
-				CLONE_NEWUSER | CLONE_NEWPID | CLONE_NEWNET)))
+				CLONE_NEWPID | CLONE_NEWNET)))
 		return 0;
 
 	if (!capable(CAP_SYS_ADMIN)) {
@@ -173,8 +164,6 @@ void free_nsproxy(struct nsproxy *ns)
 		put_ipc_ns(ns->ipc_ns);
 	if (ns->pid_ns)
 		put_pid_ns(ns->pid_ns);
-	if (ns->user_ns)
-		put_user_ns(ns->user_ns);
 	put_net(ns->net_ns);
 	kmem_cache_free(nsproxy_cachep, ns);
 }
@@ -189,7 +178,7 @@ int unshare_nsproxy_namespaces(unsigned 
 	int err = 0;
 
 	if (!(unshare_flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
-			       CLONE_NEWUSER | CLONE_NEWNET)))
+			       CLONE_NEWNET)))
 		return 0;
 
 	if (!capable(CAP_SYS_ADMIN))
diff --git a/kernel/sys.c b/kernel/sys.c
index 6bc3899..5f8cc0e 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -565,13 +565,13 @@ static int set_user(struct cred *new)
 {
 	struct user_struct *new_user;
 
-	new_user = alloc_uid(current->nsproxy->user_ns, new->uid);
+	new_user = alloc_uid(current_user_ns(), new->uid);
 	if (!new_user)
 		return -EAGAIN;
 
 	if (atomic_read(&new_user->processes) >=
 				current->signal->rlim[RLIMIT_NPROC].rlim_cur &&
-			new_user != current->nsproxy->user_ns->root_user) {
+			new_user != INIT_USER) {
 		free_uid(new_user);
 		return -EAGAIN;
 	}
diff --git a/kernel/user.c b/kernel/user.c
index d476307..c0ef3a4 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -20,9 +20,9 @@
 
 struct user_namespace init_user_ns = {
 	.kref = {
-		.refcount	= ATOMIC_INIT(2),
+		.refcount	= ATOMIC_INIT(1),
 	},
-	.root_user = &root_user,
+	.creator = &root_user,
 };
 EXPORT_SYMBOL_GPL(init_user_ns);
 
@@ -48,12 +48,14 @@ static struct kmem_cache *uid_cachep;
  */
 static DEFINE_SPINLOCK(uidhash_lock);
 
+/* root_user.__count is 2, 1 for init task cred, 1 for init_user_ns->creator */
 struct user_struct root_user = {
-	.__count	= ATOMIC_INIT(1),
+	.__count	= ATOMIC_INIT(2),
 	.processes	= ATOMIC_INIT(1),
 	.files		= ATOMIC_INIT(0),
 	.sigpending	= ATOMIC_INIT(0),
 	.locked_shm     = 0,
+	.user_ns	= &init_user_ns,
 #ifdef CONFIG_USER_SCHED
 	.tg		= &init_task_group,
 #endif
@@ -314,12 +316,13 @@ done:
  * IRQ state (as stored in flags) is restored and uidhash_lock released
  * upon function exit.
  */
-static inline void free_user(struct user_struct *up, unsigned long flags)
+static void free_user(struct user_struct *up, unsigned long flags)
 {
 	/* restore back the count */
 	atomic_inc(&up->__count);
 	spin_unlock_irqrestore(&uidhash_lock, flags);
 
+	put_user_ns(up->user_ns);
 	INIT_WORK(&up->work, remove_user_sysfs_dir);
 	schedule_work(&up->work);
 }
@@ -335,13 +338,14 @@ static inline void uids_mutex_unlock(voi
  * IRQ state (as stored in flags) is restored and uidhash_lock released
  * upon function exit.
  */
-static inline void free_user(struct user_struct *up, unsigned long flags)
+static void free_user(struct user_struct *up, unsigned long flags)
 {
 	uid_hash_remove(up);
 	spin_unlock_irqrestore(&uidhash_lock, flags);
 	sched_destroy_user(up);
 	key_put(up->uid_keyring);
 	key_put(up->session_keyring);
+	put_user_ns(up->user_ns);
 	kmem_cache_free(uid_cachep, up);
 }
 
@@ -357,7 +361,7 @@ struct user_struct *find_user(uid_t uid)
 {
 	struct user_struct *ret;
 	unsigned long flags;
-	struct user_namespace *ns = current->nsproxy->user_ns;
+	struct user_namespace *ns = current_user()->user_ns;
 
 	spin_lock_irqsave(&uidhash_lock, flags);
 	ret = uid_hash_find(uid, uidhashentry(ns, uid));
@@ -404,6 +408,8 @@ struct user_struct *alloc_uid(struct use
 		if (sched_create_user(new) < 0)
 			goto out_free_user;
 
+		new->user_ns = get_user_ns(ns);
+
 		if (uids_user_create(new))
 			goto out_destoy_sched;
 
@@ -427,7 +433,6 @@ struct user_struct *alloc_uid(struct use
 			up = new;
 		}
 		spin_unlock_irq(&uidhash_lock);
-
 	}
 
 	uids_mutex_unlock();
@@ -436,6 +441,7 @@ struct user_struct *alloc_uid(struct use
 
 out_destoy_sched:
 	sched_destroy_user(new);
+	put_user_ns(new->user_ns);
 out_free_user:
 	kmem_cache_free(uid_cachep, new);
 out_unlock:
@@ -443,33 +449,6 @@ out_unlock:
 	return NULL;
 }
 
-#ifdef CONFIG_USER_NS
-void release_uids(struct user_namespace *ns)
-{
-	int i;
-	unsigned long flags;
-	struct hlist_head *head;
-	struct hlist_node *nd;
-
-	spin_lock_irqsave(&uidhash_lock, flags);
-	/*
-	 * collapse the chains so that the user_struct-s will
-	 * be still alive, but not in hashes. subsequent free_uid()
-	 * will free them.
-	 */
-	for (i = 0; i < UIDHASH_SZ; i++) {
-		head = ns->uidhash_table + i;
-		while (!hlist_empty(head)) {
-			nd = head->first;
-			hlist_del_init(nd);
-		}
-	}
-	spin_unlock_irqrestore(&uidhash_lock, flags);
-
-	free_uid(ns->root_user);
-}
-#endif
-
 static int __init uid_cache_init(void)
 {
 	int n;
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 0d9c51d..7908431 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -9,70 +9,55 @@
 #include <linux/nsproxy.h>
 #include <linux/slab.h>
 #include <linux/user_namespace.h>
+#include <linux/cred.h>
 
 /*
- * Clone a new ns copying an original user ns, setting refcount to 1
- * @old_ns: namespace to clone
- * Return NULL on error (failure to kmalloc), new ns otherwise
+ * Create a new user namespace, deriving the creator from the user in the
+ * passed credentials, and replacing that user with the new root user for the
+ * new namespace.
+ *
+ * This is called by copy_creds(), which will finish setting the target task's
+ * credentials.
  */
-static struct user_namespace *clone_user_ns(struct user_namespace *old_ns)
+int create_user_ns(struct cred *new)
 {
 	struct user_namespace *ns;
-	struct user_struct *new_user;
-	struct cred *new;
+	struct user_struct *root_user;
 	int n;
 
 	ns = kmalloc(sizeof(struct user_namespace), GFP_KERNEL);
 	if (!ns)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 
 	kref_init(&ns->kref);
 
 	for (n = 0; n < UIDHASH_SZ; ++n)
 		INIT_HLIST_HEAD(ns->uidhash_table + n);
 
-	/* Insert new root user.  */
-	ns->root_user = alloc_uid(ns, 0);
-	if (!ns->root_user) {
+	/* Alloc new root user.  */
+	root_user = alloc_uid(ns, 0);
+	if (!root_user) {
 		kfree(ns);
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 	}
 
-	/* Reset current->user with a new one */
-	new_user = alloc_uid(ns, current_uid());
-	if (!new_user) {
-		free_uid(ns->root_user);
-		kfree(ns);
-		return ERR_PTR(-ENOMEM);
-	}
-
-	/* Install the new user */
-	new = prepare_creds();
-	if (!new) {
-		free_uid(new_user);
-		free_uid(ns->root_user);
-		kfree(ns);
-	}
-	free_uid(new->user);
-	new->user = new_user;
-	commit_creds(new);
-	return ns;
-}
-
-struct user_namespace * copy_user_ns(int flags, struct user_namespace *old_ns)
-{
-	struct user_namespace *new_ns;
-
-	BUG_ON(!old_ns);
-	get_user_ns(old_ns);
-
-	if (!(flags & CLONE_NEWUSER))
-		return old_ns;
+	/* set the new root user in the credentials under preparation */
+	ns->creator = new->user;
+	new->user = root_user;
+	new->uid = new->euid = new->suid = new->fsuid = 0;
+	new->gid = new->egid = new->sgid = new->fsgid = 0;
+	put_group_info(new->group_info);
+	new->group_info = get_group_info(&init_groups);
+#ifdef CONFIG_KEYS
+	key_put(new->request_key_auth);
+	new->request_key_auth = NULL;
+#endif
+	/* tgcred will be cleared in our caller bc CLONE_THREAD won't be set */
 
-	new_ns = clone_user_ns(old_ns);
+	/* alloc_uid() incremented the userns refcount.  Just set it to 1 */
+	kref_set(&ns->kref, 1);
 
-	put_user_ns(old_ns);
-	return new_ns;
+	return 0;
 }
 
 void free_user_ns(struct kref *kref)
@@ -80,7 +65,7 @@ void free_user_ns(struct kref *kref)
 	struct user_namespace *ns;
 
 	ns = container_of(kref, struct user_namespace, kref);
-	release_uids(ns);
+	free_uid(ns->creator);
 	kfree(ns);
 }
 EXPORT_SYMBOL(free_user_ns);
-- 
1.1.6
