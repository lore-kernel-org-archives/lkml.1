Return-Path: <linux-kernel-owner+w=401wt.eu-S1763403AbYHFPxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763403AbYHFPxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759904AbYHFPi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:38:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759767AbYHFPic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:38:32 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 11/24] CRED: Use RCU to access another task's creds and to
	release a task's own creds [ver #7]
To: jmorris@namei.org, akpm@linux-foundation.org, morgan@kernel.org
Cc: sfr@canb.auug.org.au, dhowells@redhat.com, viro@ftp.linux.org.uk,
       casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2008 16:38:11 +0100
Message-ID: <20080806153810.14351.62266.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
References: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use RCU to access another task's creds and to release a task's own creds.
This means that it will be possible for the credentials of a task to be
replaced without another task (a) requiring a full lock to read them, and (b)
seeing deallocated memory.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---

 drivers/connector/cn_proc.c  |   16 +++++++----
 fs/binfmt_elf.c              |    8 ++++-
 fs/binfmt_elf_fdpic.c        |    8 ++++-
 fs/fcntl.c                   |   15 +++++++---
 fs/fuse/dir.c                |   23 ++++++++++-----
 fs/ioprio.c                  |   14 +++++++--
 fs/proc/array.c              |   32 ++++++++++++++-------
 fs/proc/base.c               |   32 ++++++++++++++++-----
 include/linux/cred.h         |    3 +-
 kernel/auditsc.c             |   33 ++++++++++++----------
 kernel/cgroup.c              |   16 +++++------
 kernel/exit.c                |   14 ++++++---
 kernel/futex.c               |   22 +++++++++-----
 kernel/futex_compat.c        |    7 +++--
 kernel/ptrace.c              |   22 +++++++++-----
 kernel/sched.c               |   31 ++++++++++++++------
 kernel/signal.c              |   49 ++++++++++++++++++++------------
 kernel/sys.c                 |   11 +++++--
 kernel/tsacct.c              |    6 +++-
 mm/mempolicy.c               |    8 +++--
 mm/migrate.c                 |    8 +++--
 mm/oom_kill.c                |    6 ++--
 security/commoncap.c         |   64 ++++++++++++++++++++++++++----------------
 security/keys/permission.c   |   10 ++++---
 security/keys/process_keys.c |   24 +++++++++-------
 security/selinux/selinuxfs.c |   13 ++++++---
 security/smack/smack_lsm.c   |   32 +++++++++++----------
 27 files changed, 335 insertions(+), 192 deletions(-)


diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 354c1ff..c5afc98 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -106,6 +106,7 @@ void proc_id_connector(struct task_struct *task, int which_id)
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE];
 	struct timespec ts;
+	const struct cred *cred;
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
@@ -115,14 +116,19 @@ void proc_id_connector(struct task_struct *task, int which_id)
 	ev->what = which_id;
 	ev->event_data.id.process_pid = task->pid;
 	ev->event_data.id.process_tgid = task->tgid;
+	rcu_read_lock();
+	cred = __task_cred(task);
 	if (which_id == PROC_EVENT_UID) {
-		ev->event_data.id.r.ruid = task->cred->uid;
-		ev->event_data.id.e.euid = task->cred->euid;
+		ev->event_data.id.r.ruid = cred->uid;
+		ev->event_data.id.e.euid = cred->euid;
 	} else if (which_id == PROC_EVENT_GID) {
-		ev->event_data.id.r.rgid = task->cred->gid;
-		ev->event_data.id.e.egid = task->cred->egid;
-	} else
+		ev->event_data.id.r.rgid = cred->gid;
+		ev->event_data.id.e.egid = cred->egid;
+	} else {
+		rcu_read_unlock();
 	     	return;
+	}
+	rcu_read_unlock();
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 8692d4a..8761e97 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1358,6 +1358,7 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
 static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 		       struct mm_struct *mm)
 {
+	const struct cred *cred;
 	unsigned int i, len;
 	
 	/* first copy the parameters from user space */
@@ -1385,8 +1386,11 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 	psinfo->pr_zomb = psinfo->pr_sname == 'Z';
 	psinfo->pr_nice = task_nice(p);
 	psinfo->pr_flag = p->flags;
-	SET_UID(psinfo->pr_uid, p->cred->uid);
-	SET_GID(psinfo->pr_gid, p->cred->gid);
+	rcu_read_lock();
+	cred = __task_cred(p);
+	SET_UID(psinfo->pr_uid, cred->uid);
+	SET_GID(psinfo->pr_gid, cred->gid);
+	rcu_read_unlock();
 	strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
 	
 	return 0;
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 6232e55..5625b23 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1380,6 +1380,7 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
 static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 		       struct mm_struct *mm)
 {
+	const struct cred *cred;
 	unsigned int i, len;
 
 	/* first copy the parameters from user space */
@@ -1407,8 +1408,11 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 	psinfo->pr_zomb = psinfo->pr_sname == 'Z';
 	psinfo->pr_nice = task_nice(p);
 	psinfo->pr_flag = p->flags;
-	SET_UID(psinfo->pr_uid, p->cred->uid);
-	SET_GID(psinfo->pr_gid, p->cred->gid);
+	rcu_read_lock();
+	cred = __task_cred(p);
+	SET_UID(psinfo->pr_uid, cred->uid);
+	SET_GID(psinfo->pr_gid, cred->gid);
+	rcu_read_unlock();
 	strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
 
 	return 0;
diff --git a/fs/fcntl.c b/fs/fcntl.c
index c594cc0..87c39f1 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -401,10 +401,17 @@ static const long band_table[NSIGPOLL] = {
 static inline int sigio_perm(struct task_struct *p,
                              struct fown_struct *fown, int sig)
 {
-	return (((fown->euid == 0) ||
-		 (fown->euid == p->cred->suid) || (fown->euid == p->cred->uid) ||
-		 (fown->uid == p->cred->suid) || (fown->uid == p->cred->uid)) &&
-		!security_file_send_sigiotask(p, fown, sig));
+	const struct cred *cred;
+	int ret;
+
+	rcu_read_lock();
+	cred = __task_cred(p);
+	ret = ((fown->euid == 0 ||
+		fown->euid == cred->suid || fown->euid == cred->uid ||
+		fown->uid  == cred->suid || fown->uid  == cred->uid) &&
+	       !security_file_send_sigiotask(p, fown, sig));
+	rcu_read_unlock();
+	return ret;
 }
 
 static void send_sigio_to_task(struct task_struct *p,
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index e97a989..95bc22b 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -869,18 +869,25 @@ int fuse_update_attributes(struct inode *inode, struct kstat *stat,
  */
 int fuse_allow_task(struct fuse_conn *fc, struct task_struct *task)
 {
+	const struct cred *cred;
+	int ret;
+
 	if (fc->flags & FUSE_ALLOW_OTHER)
 		return 1;
 
-	if (task->cred->euid == fc->user_id &&
-	    task->cred->suid == fc->user_id &&
-	    task->cred->uid == fc->user_id &&
-	    task->cred->egid == fc->group_id &&
-	    task->cred->sgid == fc->group_id &&
-	    task->cred->gid == fc->group_id)
-		return 1;
+	rcu_read_lock();
+	ret = 0;
+	cred = __task_cred(task);
+	if (cred->euid == fc->user_id &&
+	    cred->suid == fc->user_id &&
+	    cred->uid  == fc->user_id &&
+	    cred->egid == fc->group_id &&
+	    cred->sgid == fc->group_id &&
+	    cred->gid  == fc->group_id)
+		ret = 1;
+	rcu_read_unlock();
 
-	return 0;
+	return ret;
 }
 
 static int fuse_access(struct inode *inode, int mask)
diff --git a/fs/ioprio.c b/fs/ioprio.c
index 6d96eac..f716f8d 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -31,10 +31,16 @@ static int set_task_ioprio(struct task_struct *task, int ioprio)
 {
 	int err;
 	struct io_context *ioc;
+	const struct cred *cred = current_cred(), *tcred;
 
-	if (task->cred->uid != current_euid() &&
-	    task->cred->uid != current_uid() && !capable(CAP_SYS_NICE))
+	rcu_read_lock();
+	tcred = __task_cred(task);
+	if (tcred->uid != cred->euid &&
+	    tcred->uid != cred->uid && !capable(CAP_SYS_NICE)) {
+		rcu_read_unlock();
 		return -EPERM;
+	}
+	rcu_read_unlock();
 
 	err = security_task_setioprio(task, ioprio);
 	if (err)
@@ -131,7 +137,7 @@ asmlinkage long sys_ioprio_set(int which, int who, int ioprio)
 				break;
 
 			do_each_thread(g, p) {
-				if (p->cred->uid != who)
+				if (__task_cred(p)->uid != who)
 					continue;
 				ret = set_task_ioprio(p, ioprio);
 				if (ret)
@@ -224,7 +230,7 @@ asmlinkage long sys_ioprio_get(int which, int who)
 				break;
 
 			do_each_thread(g, p) {
-				if (p->cred->uid != user->uid)
+				if (__task_cred(p)->uid != user->uid)
 					continue;
 				tmpio = get_task_ioprio(p);
 				if (tmpio < 0)
diff --git a/fs/proc/array.c b/fs/proc/array.c
index af0962b..13944a3 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -164,6 +164,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 	struct group_info *group_info;
 	int g;
 	struct fdtable *fdt = NULL;
+	const struct cred *cred;
 	pid_t ppid, tpid;
 
 	rcu_read_lock();
@@ -175,6 +176,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		if (tracer)
 			tpid = task_pid_nr_ns(tracer, ns);
 	}
+	cred = get_cred((struct cred *) __task_cred(p));
 	seq_printf(m,
 		"State:\t%s\n"
 		"Tgid:\t%d\n"
@@ -187,8 +189,8 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		task_tgid_nr_ns(p, ns),
 		pid_nr_ns(pid, ns),
 		ppid, tpid,
-		p->cred->uid, p->cred->euid, p->cred->suid, p->cred->fsuid,
-		p->cred->gid, p->cred->egid, p->cred->sgid, p->cred->fsgid);
+		cred->uid, cred->euid, cred->suid, cred->fsuid,
+		cred->gid, cred->egid, cred->sgid, cred->fsgid);
 
 	task_lock(p);
 	if (p->files)
@@ -199,13 +201,12 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		fdt ? fdt->max_fds : 0);
 	rcu_read_unlock();
 
-	group_info = p->cred->group_info;
-	get_group_info(group_info);
+	group_info = cred->group_info;
 	task_unlock(p);
 
 	for (g = 0; g < min(group_info->ngroups, NGROUPS_SMALL); g++)
 		seq_printf(m, "%d ", GROUP_AT(group_info, g));
-	put_group_info(group_info);
+	put_cred(cred);
 
 	seq_printf(m, "\n");
 }
@@ -268,7 +269,7 @@ static inline void task_sig(struct seq_file *m, struct task_struct *p)
 		blocked = p->blocked;
 		collect_sigign_sigcatch(p, &ignored, &caught);
 		num_threads = atomic_read(&p->signal->count);
-		qsize = atomic_read(&p->cred->user->sigpending);
+		qsize = atomic_read(&__task_cred(p)->user->sigpending);
 		qlim = p->signal->rlim[RLIMIT_SIGPENDING].rlim_cur;
 		unlock_task_sighand(p, &flags);
 	}
@@ -300,12 +301,21 @@ static void render_cap_t(struct seq_file *m, const char *header,
 
 static inline void task_cap(struct seq_file *m, struct task_struct *p)
 {
-	struct cred *cred = p->cred;
+	const struct cred *cred;
+	kernel_cap_t cap_inheritable, cap_permitted, cap_effective, cap_bset;
 
-	render_cap_t(m, "CapInh:\t", &cred->cap_inheritable);
-	render_cap_t(m, "CapPrm:\t", &cred->cap_permitted);
-	render_cap_t(m, "CapEff:\t", &cred->cap_effective);
-	render_cap_t(m, "CapBnd:\t", &cred->cap_bset);
+	rcu_read_lock();
+	cred = __task_cred(p);
+	cap_inheritable	= cred->cap_inheritable;
+	cap_permitted	= cred->cap_permitted;
+	cap_effective	= cred->cap_effective;
+	cap_bset	= cred->cap_bset;
+	rcu_read_unlock();
+
+	render_cap_t(m, "CapInh:\t", &cap_inheritable);
+	render_cap_t(m, "CapPrm:\t", &cap_permitted);
+	render_cap_t(m, "CapEff:\t", &cap_effective);
+	render_cap_t(m, "CapBnd:\t", &cap_bset);
 }
 
 static inline void task_context_switch_counts(struct seq_file *m,
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 96fb315..74db376 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1414,6 +1414,7 @@ static struct inode *proc_pid_make_inode(struct super_block * sb, struct task_st
 {
 	struct inode * inode;
 	struct proc_inode *ei;
+	const struct cred *cred;
 
 	/* We need a new inode */
 
@@ -1436,8 +1437,11 @@ static struct inode *proc_pid_make_inode(struct super_block * sb, struct task_st
 	inode->i_uid = 0;
 	inode->i_gid = 0;
 	if (task_dumpable(task)) {
-		inode->i_uid = task->cred->euid;
-		inode->i_gid = task->cred->egid;
+		rcu_read_lock();
+		cred = __task_cred(task);
+		inode->i_uid = cred->euid;
+		inode->i_gid = cred->egid;
+		rcu_read_unlock();
 	}
 	security_task_to_inode(task, inode);
 
@@ -1453,6 +1457,8 @@ static int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat
 {
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *task;
+	const struct cred *cred;
+
 	generic_fillattr(inode, stat);
 
 	rcu_read_lock();
@@ -1462,8 +1468,9 @@ static int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat
 	if (task) {
 		if ((inode->i_mode == (S_IFDIR|S_IRUGO|S_IXUGO)) ||
 		    task_dumpable(task)) {
-			stat->uid = task->cred->euid;
-			stat->gid = task->cred->egid;
+			cred = __task_cred(task);
+			stat->uid = cred->euid;
+			stat->gid = cred->egid;
 		}
 	}
 	rcu_read_unlock();
@@ -1491,11 +1498,16 @@ static int pid_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *task = get_proc_task(inode);
+	const struct cred *cred;
+
 	if (task) {
 		if ((inode->i_mode == (S_IFDIR|S_IRUGO|S_IXUGO)) ||
 		    task_dumpable(task)) {
-			inode->i_uid = task->cred->euid;
-			inode->i_gid = task->cred->egid;
+			rcu_read_lock();
+			cred = __task_cred(task);
+			inode->i_uid = cred->euid;
+			inode->i_gid = cred->egid;
+			rcu_read_unlock();
 		} else {
 			inode->i_uid = 0;
 			inode->i_gid = 0;
@@ -1657,6 +1669,7 @@ static int tid_fd_revalidate(struct dentry *dentry, struct nameidata *nd)
 	struct task_struct *task = get_proc_task(inode);
 	int fd = proc_fd(inode);
 	struct files_struct *files;
+	const struct cred *cred;
 
 	if (task) {
 		files = get_files_struct(task);
@@ -1666,8 +1679,11 @@ static int tid_fd_revalidate(struct dentry *dentry, struct nameidata *nd)
 				rcu_read_unlock();
 				put_files_struct(files);
 				if (task_dumpable(task)) {
-					inode->i_uid = task->cred->euid;
-					inode->i_gid = task->cred->egid;
+					rcu_read_lock();
+					cred = __task_cred(task);
+					inode->i_uid = cred->euid;
+					inode->i_gid = cred->egid;
+					rcu_read_unlock();
 				} else {
 					inode->i_uid = 0;
 					inode->i_gid = 0;
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 45e954d..5c4e098 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -147,8 +147,9 @@ static inline struct cred *get_cred(struct cred *cred)
  * Release a reference to a set of credentials, deleting them when the last ref
  * is released.
  */
-static inline void put_cred(struct cred *cred)
+static inline void put_cred(const struct cred *_cred)
 {
+	struct cred *cred = (struct cred *) _cred;
 	if (atomic_dec_and_test(&(cred)->usage))
 		__put_cred(cred);
 }
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 9e817df..58c3854 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -413,7 +413,7 @@ static int audit_filter_rules(struct task_struct *tsk,
 			      struct audit_names *name,
 			      enum audit_state *state)
 {
-	struct cred *cred = tsk->cred;
+	const struct cred *cred = get_task_cred(tsk);
 	int i, j, need_sid = 1;
 	u32 sid;
 
@@ -608,8 +608,10 @@ static int audit_filter_rules(struct task_struct *tsk,
 			break;
 		}
 
-		if (!result)
+		if (!result) {
+			put_cred(cred);
 			return 0;
+		}
 	}
 	if (rule->filterkey && ctx)
 		ctx->filterkey = kstrdup(rule->filterkey, GFP_ATOMIC);
@@ -617,6 +619,7 @@ static int audit_filter_rules(struct task_struct *tsk,
 	case AUDIT_NEVER:    *state = AUDIT_DISABLED;	    break;
 	case AUDIT_ALWAYS:   *state = AUDIT_RECORD_CONTEXT; break;
 	}
+	put_cred(cred);
 	return 1;
 }
 
@@ -1166,7 +1169,7 @@ static void audit_log_execve_info(struct audit_context *context,
 
 static void audit_log_exit(struct audit_context *context, struct task_struct *tsk)
 {
-	struct cred *cred = tsk->cred;
+	const struct cred *cred;
 	int i, call_panic = 0;
 	struct audit_buffer *ab;
 	struct audit_aux_data *aux;
@@ -1176,13 +1179,14 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 	context->pid = tsk->pid;
 	if (!context->ppid)
 		context->ppid = sys_getppid();
-	context->uid = cred->uid;
-	context->gid = cred->gid;
-	context->euid = cred->euid;
-	context->suid = cred->suid;
+	cred = current_cred();
+	context->uid   = cred->uid;
+	context->gid   = cred->gid;
+	context->euid  = cred->euid;
+	context->suid  = cred->suid;
 	context->fsuid = cred->fsuid;
-	context->egid = cred->egid;
-	context->sgid = cred->sgid;
+	context->egid  = cred->egid;
+	context->sgid  = cred->sgid;
 	context->fsgid = cred->fsgid;
 	context->personality = tsk->personality;
 
@@ -1973,7 +1977,7 @@ int audit_set_loginuid(struct task_struct *task, uid_t loginuid)
 			audit_log_format(ab, "login pid=%d uid=%u "
 				"old auid=%u new auid=%u"
 				" old ses=%u new ses=%u",
-				task->pid, task->cred->uid,
+				task->pid, task_uid(task),
 				task->loginuid, loginuid,
 				task->sessionid, sessionid);
 			audit_log_end(ab);
@@ -2356,7 +2360,7 @@ void __audit_ptrace(struct task_struct *t)
 
 	context->target_pid = t->pid;
 	context->target_auid = audit_get_loginuid(t);
-	context->target_uid = t->cred->uid;
+	context->target_uid = task_uid(t);
 	context->target_sessionid = audit_get_sessionid(t);
 	security_task_getsecid(t, &context->target_sid);
 	memcpy(context->target_comm, t->comm, TASK_COMM_LEN);
@@ -2375,6 +2379,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 	struct audit_aux_data_pids *axp;
 	struct task_struct *tsk = current;
 	struct audit_context *ctx = tsk->audit_context;
+	uid_t uid = current_uid(), t_uid = task_uid(t);
 
 	if (audit_pid && t->tgid == audit_pid) {
 		if (sig == SIGTERM || sig == SIGHUP || sig == SIGUSR1 || sig == SIGUSR2) {
@@ -2382,7 +2387,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 			if (tsk->loginuid != -1)
 				audit_sig_uid = tsk->loginuid;
 			else
-				audit_sig_uid = tsk->cred->uid;
+				audit_sig_uid = uid;
 			security_task_getsecid(tsk, &audit_sig_sid);
 		}
 		if (!audit_signals || audit_dummy_context())
@@ -2394,7 +2399,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 	if (!ctx->target_pid) {
 		ctx->target_pid = t->tgid;
 		ctx->target_auid = audit_get_loginuid(t);
-		ctx->target_uid = t->cred->uid;
+		ctx->target_uid = t_uid;
 		ctx->target_sessionid = audit_get_sessionid(t);
 		security_task_getsecid(t, &ctx->target_sid);
 		memcpy(ctx->target_comm, t->comm, TASK_COMM_LEN);
@@ -2415,7 +2420,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 
 	axp->target_pid[axp->pid_count] = t->tgid;
 	axp->target_auid[axp->pid_count] = audit_get_loginuid(t);
-	axp->target_uid[axp->pid_count] = t->cred->uid;
+	axp->target_uid[axp->pid_count] = t_uid;
 	axp->target_sessionid[axp->pid_count] = audit_get_sessionid(t);
 	security_task_getsecid(t, &axp->target_sid[axp->pid_count]);
 	memcpy(axp->target_comm[axp->pid_count], t->comm, TASK_COMM_LEN);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5658dc3..3569fef 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1276,7 +1276,7 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 static int attach_task_by_pid(struct cgroup *cgrp, u64 pid)
 {
 	struct task_struct *tsk;
-	uid_t euid;
+	const struct cred *cred = current_cred(), *tcred;
 	int ret;
 
 	if (pid) {
@@ -1286,16 +1286,16 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid)
 			rcu_read_unlock();
 			return -ESRCH;
 		}
-		get_task_struct(tsk);
-		rcu_read_unlock();
 
-		euid = current_euid();
-		if (euid &&
-		    euid != tsk->cred->uid &&
-		    euid != tsk->cred->suid) {
-			put_task_struct(tsk);
+		tcred = __task_cred(tsk);
+		if (cred->euid &&
+		    cred->euid != tcred->uid &&
+		    cred->euid != tcred->suid) {
+			rcu_read_unlock();
 			return -EACCES;
 		}
+		get_task_struct(tsk);
+		rcu_read_unlock();
 	} else {
 		tsk = current;
 		get_task_struct(tsk);
diff --git a/kernel/exit.c b/kernel/exit.c
index 5ba3db3..9bce79b 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -159,7 +159,10 @@ void release_task(struct task_struct * p)
 	int zap_leader;
 repeat:
 	tracehook_prepare_release_task(p);
-	atomic_dec(&p->cred->user->processes);
+	/* don't need to get the RCU readlock here - the process is dead and
+	 * can't be modifying its own credentials */
+	atomic_dec(&__task_cred(p)->user->processes);
+
 	proc_flush_task(p);
 	write_lock_irq(&tasklist_lock);
 	tracehook_finish_release_task(p);
@@ -1267,12 +1270,12 @@ static int wait_task_zombie(struct task_struct *p, int options,
 	unsigned long state;
 	int retval, status, traced;
 	pid_t pid = task_pid_vnr(p);
+	uid_t uid = __task_cred(p)->uid;
 
 	if (!likely(options & WEXITED))
 		return 0;
 
 	if (unlikely(options & WNOWAIT)) {
-		uid_t uid = p->cred->uid;
 		int exit_code = p->exit_code;
 		int why, status;
 
@@ -1389,7 +1392,7 @@ static int wait_task_zombie(struct task_struct *p, int options,
 	if (!retval && infop)
 		retval = put_user(pid, &infop->si_pid);
 	if (!retval && infop)
-		retval = put_user(p->cred->uid, &infop->si_uid);
+		retval = put_user(uid, &infop->si_uid);
 	if (!retval)
 		retval = pid;
 
@@ -1454,7 +1457,8 @@ static int wait_task_stopped(int ptrace, struct task_struct *p,
 	if (!unlikely(options & WNOWAIT))
 		p->exit_code = 0;
 
-	uid = p->cred->uid;
+	/* don't need the RCU readlock here as we're holding a spinlock */
+	uid = __task_cred(p)->uid;
 unlock_sig:
 	spin_unlock_irq(&p->sighand->siglock);
 	if (!exit_code)
@@ -1528,10 +1532,10 @@ static int wait_task_continued(struct task_struct *p, int options,
 	}
 	if (!unlikely(options & WNOWAIT))
 		p->signal->flags &= ~SIGNAL_STOP_CONTINUED;
+	uid = __task_cred(p)->uid;
 	spin_unlock_irq(&p->sighand->siglock);
 
 	pid = task_pid_vnr(p);
-	uid = p->cred->uid;
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
 
diff --git a/kernel/futex.c b/kernel/futex.c
index 3f594ac..063795e 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -439,15 +439,20 @@ static void free_pi_state(struct futex_pi_state *pi_state)
 static struct task_struct * futex_find_get_task(pid_t pid)
 {
 	struct task_struct *p;
-	uid_t euid = current_euid();
+	const struct cred *cred = current_cred(), *pcred;
 
 	rcu_read_lock();
 	p = find_task_by_vpid(pid);
-	if (!p || (euid != p->cred->euid &&
-		   euid != p->cred->uid))
+	if (!p) {
 		p = ERR_PTR(-ESRCH);
-	else
-		get_task_struct(p);
+	} else {
+		pcred = __task_cred(p);
+		if (cred->euid != pcred->euid &&
+		    cred->euid != pcred->uid)
+			p = ERR_PTR(-ESRCH);
+		else
+			get_task_struct(p);
+	}
 
 	rcu_read_unlock();
 
@@ -1828,7 +1833,7 @@ sys_get_robust_list(int pid, struct robust_list_head __user * __user *head_ptr,
 {
 	struct robust_list_head __user *head;
 	unsigned long ret;
-	uid_t euid = current_euid();
+	const struct cred *cred = current_cred(), *pcred;
 
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
@@ -1844,8 +1849,9 @@ sys_get_robust_list(int pid, struct robust_list_head __user * __user *head_ptr,
 		if (!p)
 			goto err_unlock;
 		ret = -EPERM;
-		if (euid != p->cred->euid &&
-		    euid != p->cred->uid &&
+		pcred = __task_cred(p);
+		if (cred->euid != pcred->euid &&
+		    cred->euid != pcred->uid &&
 		    !capable(CAP_SYS_PTRACE))
 			goto err_unlock;
 		head = p->robust_list;
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 2c3fd5e..d607a5b 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -135,7 +135,7 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 {
 	struct compat_robust_list_head __user *head;
 	unsigned long ret;
-	uid_t euid = current_euid();
+	const struct cred *cred = current_cred(), *pcred;
 
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
@@ -151,8 +151,9 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 		if (!p)
 			goto err_unlock;
 		ret = -EPERM;
-		if (euid != p->cred->euid &&
-		    euid != p->cred->uid &&
+		pcred = __task_cred(p);
+		if (cred->euid != pcred->euid &&
+		    cred->euid != pcred->uid &&
 		    !capable(CAP_SYS_PTRACE))
 			goto err_unlock;
 		head = p->compat_robust_list;
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index efa4556..ed65d9f 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -115,7 +115,7 @@ int ptrace_check_attach(struct task_struct *child, int kill)
 
 int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 {
-	struct cred *cred = current->cred, *tcred = task->cred;
+	const struct cred *cred = current_cred(), *tcred;
 
 	/* May we inspect the given task?
 	 * This check is used both for attaching with ptrace
@@ -125,19 +125,23 @@ int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 	 * because setting up the necessary parent/child relationship
 	 * or halting the specified task is impossible.
 	 */
-	uid_t uid = cred->uid;
-	gid_t gid = cred->gid;
 	int dumpable = 0;
 	/* Don't let security modules deny introspection */
 	if (task == current)
 		return 0;
-	if ((uid != tcred->euid ||
-	     uid != tcred->suid ||
-	     uid != tcred->uid  ||
-	     gid != tcred->egid ||
-	     gid != tcred->sgid ||
-	     gid != tcred->gid) && !capable(CAP_SYS_PTRACE))
+	rcu_read_lock();
+	tcred = __task_cred(task);
+	if ((cred->uid != tcred->euid ||
+	     cred->uid != tcred->suid ||
+	     cred->uid != tcred->uid  ||
+	     cred->gid != tcred->egid ||
+	     cred->gid != tcred->sgid ||
+	     cred->gid != tcred->gid) &&
+	    !capable(CAP_SYS_PTRACE)) {
+		rcu_read_unlock();
 		return -EPERM;
+	}
+	rcu_read_unlock();
 	smp_rmb();
 	if (task->mm)
 		dumpable = get_dumpable(task->mm);
diff --git a/kernel/sched.c b/kernel/sched.c
index 152ea80..dd85fe0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -339,7 +339,9 @@ static inline struct task_group *task_group(struct task_struct *p)
 	struct task_group *tg;
 
 #ifdef CONFIG_USER_SCHED
-	tg = p->cred->user->tg;
+	rcu_read_lock();
+	tg = __task_cred(p)->user->tg;
+	rcu_read_unlock();
 #elif defined(CONFIG_CGROUP_SCHED)
 	tg = container_of(task_subsys_state(p, cpu_cgroup_subsys_id),
 				struct task_group, css);
@@ -4940,6 +4942,22 @@ __setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
 	set_load_weight(p);
 }
 
+/*
+ * check the target process has a UID that matches the current process's
+ */
+static bool check_same_owner(struct task_struct *p)
+{
+	const struct cred *cred = current_cred(), *pcred;
+	bool match;
+
+	rcu_read_lock();
+	pcred = __task_cred(p);
+	match = (cred->euid == pcred->euid ||
+		 cred->euid == pcred->uid);
+	rcu_read_unlock();
+	return match;
+}
+
 static int __sched_setscheduler(struct task_struct *p, int policy,
 				struct sched_param *param, bool user)
 {
@@ -4947,7 +4965,6 @@ static int __sched_setscheduler(struct task_struct *p, int policy,
 	unsigned long flags;
 	const struct sched_class *prev_class = p->sched_class;
 	struct rq *rq;
-	uid_t euid;
 
 	/* may grab non-irq protected spin_locks */
 	BUG_ON(in_interrupt());
@@ -5000,9 +5017,7 @@ recheck:
 			return -EPERM;
 
 		/* can't change other user's priorities */
-		euid = current_euid();
-		if (euid != p->cred->euid &&
-		    euid != p->cred->uid)
+		if (!check_same_owner(p))
 			return -EPERM;
 	}
 
@@ -5210,7 +5225,6 @@ long sched_setaffinity(pid_t pid, const cpumask_t *in_mask)
 	cpumask_t cpus_allowed;
 	cpumask_t new_mask = *in_mask;
 	struct task_struct *p;
-	uid_t euid;
 	int retval;
 
 	get_online_cpus();
@@ -5231,11 +5245,8 @@ long sched_setaffinity(pid_t pid, const cpumask_t *in_mask)
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
 
-	euid = current_euid();
 	retval = -EPERM;
-	if (euid != p->cred->euid &&
-	    euid != p->cred->uid &&
-	    !capable(CAP_SYS_NICE))
+	if (!check_same_owner(p) && !capable(CAP_SYS_NICE))
 		goto out_unlock;
 
 	retval = security_task_setscheduler(p, 0, NULL);
diff --git a/kernel/signal.c b/kernel/signal.c
index dfdbaaf..2632d94 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -176,6 +176,11 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
 	return sig;
 }
 
+/*
+ * allocate a new signal queue record
+ * - this may be called without locks if and only if t == current, otherwise an
+ *   appopriate lock must be held to protect t's user_struct
+ */
 static struct sigqueue *__sigqueue_alloc(struct task_struct *t, gfp_t flags,
 					 int override_rlimit)
 {
@@ -183,11 +188,12 @@ static struct sigqueue *__sigqueue_alloc(struct task_struct *t, gfp_t flags,
 	struct user_struct *user;
 
 	/*
-	 * In order to avoid problems with "switch_user()", we want to make
-	 * sure that the compiler doesn't re-load "t->user"
+	 * We won't get problems with the target's UID changing under us
+	 * because changing it requires RCU be used, and if t != current, the
+	 * caller must be holding the RCU readlock (by way of a spinlock) and
+	 * we use RCU protection here
 	 */
-	user = t->cred->user;
-	barrier();
+	user = __task_cred(t)->user;
 	atomic_inc(&user->sigpending);
 	if (override_rlimit ||
 	    atomic_read(&user->sigpending) <=
@@ -561,12 +567,13 @@ static int rm_from_queue(unsigned long mask, struct sigpending *s)
 
 /*
  * Bad permissions for sending the signal
+ * - the caller must hold at least the RCU read lock
  */
 static int check_kill_permission(int sig, struct siginfo *info,
 				 struct task_struct *t)
 {
+	const struct cred *cred = current_cred(), *tcred;
 	struct pid *sid;
-	uid_t uid, euid;
 	int error;
 
 	if (!valid_signal(sig))
@@ -579,10 +586,11 @@ static int check_kill_permission(int sig, struct siginfo *info,
 	if (error)
 		return error;
 
-	uid = current_uid();
-	euid = current_euid();
-	if ((euid ^ t->cred->suid) && (euid ^ t->cred->uid) &&
-	    (uid  ^ t->cred->suid) && (uid  ^ t->cred->uid) &&
+	tcred = __task_cred(t);
+	if ((cred->euid ^ tcred->suid) &&
+	    (cred->euid ^ tcred->uid) &&
+	    (cred->uid  ^ tcred->suid) &&
+	    (cred->uid  ^ tcred->uid) &&
 	    !capable(CAP_KILL)) {
 		switch (sig) {
 		case SIGCONT:
@@ -1008,6 +1016,10 @@ struct sighand_struct *lock_task_sighand(struct task_struct *tsk, unsigned long
 	return sighand;
 }
 
+/*
+ * send signal info to all the members of a group
+ * - the caller must hold the RCU read lock at least
+ */
 int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 {
 	unsigned long flags;
@@ -1029,8 +1041,8 @@ int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 /*
  * __kill_pgrp_info() sends a signal to a process group: this is what the tty
  * control characters do (^C, ^Z etc)
+ * - the caller must hold at least a readlock on tasklist_lock
  */
-
 int __kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp)
 {
 	struct task_struct *p = NULL;
@@ -1086,6 +1098,7 @@ int kill_pid_info_as_uid(int sig, struct siginfo *info, struct pid *pid,
 {
 	int ret = -EINVAL;
 	struct task_struct *p;
+	const struct cred *pcred;
 
 	if (!valid_signal(sig))
 		return ret;
@@ -1096,9 +1109,11 @@ int kill_pid_info_as_uid(int sig, struct siginfo *info, struct pid *pid,
 		ret = -ESRCH;
 		goto out_unlock;
 	}
-	if ((info == SEND_SIG_NOINFO || (!is_si_special(info) && SI_FROMUSER(info)))
-	    && (euid != p->cred->suid) && (euid != p->cred->uid)
-	    && (uid != p->cred->suid) && (uid != p->cred->uid)) {
+	pcred = __task_cred(p);
+	if ((info == SEND_SIG_NOINFO ||
+	     (!is_si_special(info) && SI_FROMUSER(info))) &&
+	    euid != pcred->suid && euid != pcred->uid &&
+	    uid  != pcred->suid && uid  != pcred->uid) {
 		ret = -EPERM;
 		goto out_unlock;
 	}
@@ -1365,10 +1380,9 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 	 */
 	rcu_read_lock();
 	info.si_pid = task_pid_nr_ns(tsk, tsk->parent->nsproxy->pid_ns);
+	info.si_uid = __task_cred(tsk)->uid;
 	rcu_read_unlock();
 
-	info.si_uid = tsk->cred->uid;
-
 	info.si_utime = cputime_to_clock_t(cputime_add(tsk->utime,
 						       tsk->signal->utime));
 	info.si_stime = cputime_to_clock_t(cputime_add(tsk->stime,
@@ -1437,10 +1451,9 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 	 */
 	rcu_read_lock();
 	info.si_pid = task_pid_nr_ns(tsk, tsk->parent->nsproxy->pid_ns);
+	info.si_uid = __task_cred(tsk)->uid;
 	rcu_read_unlock();
 
-	info.si_uid = tsk->cred->uid;
-
 	info.si_utime = cputime_to_clock_t(tsk->utime);
 	info.si_stime = cputime_to_clock_t(tsk->stime);
 
@@ -1707,7 +1720,7 @@ static int ptrace_signal(int signr, siginfo_t *info,
 		info->si_errno = 0;
 		info->si_code = SI_USER;
 		info->si_pid = task_pid_vnr(current->parent);
-		info->si_uid = current->parent->cred->uid;
+		info->si_uid = task_uid(current->parent);
 	}
 
 	/* If the (new) signal is now blocked, requeue it.  */
diff --git a/kernel/sys.c b/kernel/sys.c
index e2a16eb..4c4ac7a 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -112,14 +112,17 @@ EXPORT_SYMBOL(cad_pid);
 
 void (*pm_power_off_prepare)(void);
 
+/*
+ * set the priority of a task
+ * - the caller must hold the RCU read lock
+ */
 static int set_one_prio(struct task_struct *p, int niceval, int error)
 {
-	uid_t euid = current_euid();
+	const struct cred *cred = current_cred(), *pcred = __task_cred(p);
 	int no_nice;
 
-	if (p->cred->uid  != euid &&
-	    p->cred->euid != euid &&
-	    !capable(CAP_SYS_NICE)) {
+	if (pcred->uid  != cred->euid &&
+	    pcred->euid != cred->euid && !capable(CAP_SYS_NICE)) {
 		error = -EPERM;
 		goto out;
 	}
diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index 6d1ed07..2dc06ab 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -27,6 +27,7 @@
  */
 void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
 {
+	const struct cred *tcred;
 	struct timespec uptime, ts;
 	u64 ac_etime;
 
@@ -53,10 +54,11 @@ void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
 		stats->ac_flag |= AXSIG;
 	stats->ac_nice	 = task_nice(tsk);
 	stats->ac_sched	 = tsk->policy;
-	stats->ac_uid	 = tsk->cred->uid;
-	stats->ac_gid	 = tsk->cred->gid;
 	stats->ac_pid	 = tsk->pid;
 	rcu_read_lock();
+	tcred = __task_cred(tsk);
+	stats->ac_uid	 = tcred->uid;
+	stats->ac_gid	 = tcred->gid;
 	stats->ac_ppid	 = pid_alive(tsk) ?
 				rcu_dereference(tsk->real_parent)->tgid : 0;
 	rcu_read_unlock();
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4374a83..488d4f6 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1106,7 +1106,7 @@ asmlinkage long sys_migrate_pages(pid_t pid, unsigned long maxnode,
 		const unsigned long __user *old_nodes,
 		const unsigned long __user *new_nodes)
 {
-	struct cred *cred, *tcred;
+	const struct cred *cred = current_cred(), *tcred;
 	struct mm_struct *mm;
 	struct task_struct *task;
 	nodemask_t old;
@@ -1141,14 +1141,16 @@ asmlinkage long sys_migrate_pages(pid_t pid, unsigned long maxnode,
 	 * capabilities, superuser privileges or the same
 	 * userid as the target process.
 	 */
-	cred = current->cred;
-	tcred = task->cred;
+	rcu_read_lock();
+	tcred = __task_cred(task);
 	if (cred->euid != tcred->suid && cred->euid != tcred->uid &&
 	    cred->uid  != tcred->suid && cred->uid  != tcred->uid &&
 	    !capable(CAP_SYS_NICE)) {
+		rcu_read_unlock();
 		err = -EPERM;
 		goto out;
 	}
+	rcu_read_unlock();
 
 	task_nodes = cpuset_mems_allowed(task);
 	/* Is the user allowed to access the target nodes? */
diff --git a/mm/migrate.c b/mm/migrate.c
index 78af7fd..32b352d 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -984,7 +984,7 @@ asmlinkage long sys_move_pages(pid_t pid, unsigned long nr_pages,
 			const int __user *nodes,
 			int __user *status, int flags)
 {
-	struct cred *cred, *tcred;
+	const struct cred *cred = current_cred(), *tcred;
 	int err = 0;
 	int i;
 	struct task_struct *task;
@@ -1018,14 +1018,16 @@ asmlinkage long sys_move_pages(pid_t pid, unsigned long nr_pages,
 	 * capabilities, superuser privileges or the same
 	 * userid as the target process.
 	 */
-	cred = current->cred;
-	tcred = task->cred;
+	rcu_read_lock();
+	tcred = __task_cred(task);
 	if (cred->euid != tcred->suid && cred->euid != tcred->uid &&
 	    cred->uid  != tcred->suid && cred->uid  != tcred->uid &&
 	    !capable(CAP_SYS_NICE)) {
+		rcu_read_unlock();
 		err = -EPERM;
 		goto out2;
 	}
+	rcu_read_unlock();
 
  	err = security_task_movememory(task);
  	if (err)
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index c156ffb..235b7f7 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -298,9 +298,9 @@ static void dump_tasks(const struct mem_cgroup *mem)
 
 		task_lock(p);
 		printk(KERN_INFO "[%5d] %5d %5d %8lu %8lu %3d     %3d %s\n",
-		       p->pid, p->cred->uid, p->tgid, p->mm->total_vm,
-		       get_mm_rss(p->mm), (int)task_cpu(p), p->oomkilladj,
-		       p->comm);
+		       p->pid, __task_cred(p)->uid, p->tgid,
+		       p->mm->total_vm, get_mm_rss(p->mm), (int)task_cpu(p),
+		       p->oomkilladj, p->comm);
 		task_unlock(p);
 	} while_each_thread(g, p);
 }
diff --git a/security/commoncap.c b/security/commoncap.c
index 2de5cbe..d6456b0 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -50,10 +50,13 @@ EXPORT_SYMBOL(cap_netlink_recv);
  */
 int cap_capable (struct task_struct *tsk, int cap)
 {
+	__u32 cap_raised;
+
 	/* Derived from include/linux/sched.h:capable. */
-	if (cap_raised(tsk->cred->cap_effective, cap))
-		return 0;
-	return -EPERM;
+	rcu_read_lock();
+	cap_raised = cap_raised(__task_cred(tsk)->cap_effective, cap);
+	rcu_read_unlock();
+	return cap_raised ? 0 : -EPERM;
 }
 
 int cap_settime(struct timespec *ts, struct timezone *tz)
@@ -65,34 +68,42 @@ int cap_settime(struct timespec *ts, struct timezone *tz)
 
 int cap_ptrace_may_access(struct task_struct *child, unsigned int mode)
 {
-	/* Derived from arch/i386/kernel/ptrace.c:sys_ptrace. */
-	if (cap_issubset(child->cred->cap_permitted,
-			 current->cred->cap_permitted))
-		return 0;
-	if (capable(CAP_SYS_PTRACE))
-		return 0;
-	return -EPERM;
+	int ret = 0;
+
+	rcu_read_lock();
+	if (!cap_issubset(child->cred->cap_permitted,
+			  current->cred->cap_permitted) &&
+	    !capable(CAP_SYS_PTRACE))
+		ret = -EPERM;
+	rcu_read_unlock();
+	return ret;
 }
 
 int cap_ptrace_traceme(struct task_struct *parent)
 {
-	if (cap_issubset(current->cred->cap_permitted,
-			 parent->cred->cap_permitted))
-		return 0;
-	if (has_capability(parent, CAP_SYS_PTRACE))
-		return 0;
-	return -EPERM;
+	int ret = 0;
+
+	rcu_read_lock();
+	if (!cap_issubset(current->cred->cap_permitted,
+			 parent->cred->cap_permitted) &&
+	    !has_capability(parent, CAP_SYS_PTRACE))
+		ret = -EPERM;
+	rcu_read_unlock();
+	return ret;
 }
 
 int cap_capget (struct task_struct *target, kernel_cap_t *effective,
 		kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
-	struct cred *cred = target->cred;
+	const struct cred *cred;
 
 	/* Derived from kernel/capability.c:sys_capget. */
+	rcu_read_lock();
+	cred = __task_cred(target);
 	*effective   = cred->cap_effective;
 	*inheritable = cred->cap_inheritable;
 	*permitted   = cred->cap_permitted;
+	rcu_read_unlock();
 	return 0;
 }
 
@@ -398,7 +409,7 @@ void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 
 int cap_bprm_secureexec (struct linux_binprm *bprm)
 {
-	const struct cred *cred = current->cred;
+	const struct cred *cred = current_cred();
 
 	if (cred->uid != 0) {
 		if (bprm->cap_effective)
@@ -476,11 +487,11 @@ static inline void cap_emulate_setxuid (int old_ruid, int old_euid,
 	if ((old_ruid == 0 || old_euid == 0 || old_suid == 0) &&
 	    (cred->uid != 0 && cred->euid != 0 && cred->suid != 0) &&
 	    !issecure(SECURE_KEEP_CAPS)) {
-		cap_clear (cred->cap_permitted);
-		cap_clear (cred->cap_effective);
+		cap_clear(cred->cap_permitted);
+		cap_clear(cred->cap_effective);
 	}
 	if (old_euid == 0 && cred->euid != 0) {
-		cap_clear (cred->cap_effective);
+		cap_clear(cred->cap_effective);
 	}
 	if (old_euid != 0 && cred->euid == 0) {
 		cred->cap_effective = cred->cap_permitted;
@@ -547,9 +558,14 @@ int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
  */
 static inline int cap_safe_nice(struct task_struct *p)
 {
-	if (!cap_issubset(p->cred->cap_permitted,
-			  current->cred->cap_permitted) &&
-	    !capable(CAP_SYS_NICE))
+	int is_subset;
+
+	rcu_read_lock();
+	is_subset = cap_issubset(__task_cred(p)->cap_permitted,
+				 current_cred()->cap_permitted);
+	rcu_read_unlock();
+
+	if (!is_subset && !capable(CAP_SYS_NICE))
 		return -EPERM;
 	return 0;
 }
diff --git a/security/keys/permission.c b/security/keys/permission.c
index baf3d5f..13c3616 100644
--- a/security/keys/permission.c
+++ b/security/keys/permission.c
@@ -22,13 +22,16 @@ int key_task_permission(const key_ref_t key_ref,
 			struct task_struct *context,
 			key_perm_t perm)
 {
-	struct cred *cred = context->cred;
+	const struct cred *cred;
 	struct key *key;
 	key_perm_t kperm;
 	int ret;
 
 	key = key_ref_to_ptr(key_ref);
 
+	rcu_read_lock();
+	cred = __task_cred(context);
+
 	/* use the second 8-bits of permissions for keys the caller owns */
 	if (key->uid == cred->fsuid) {
 		kperm = key->perm >> 16;
@@ -43,10 +46,7 @@ int key_task_permission(const key_ref_t key_ref,
 			goto use_these_perms;
 		}
 
-		spin_lock(&cred->lock);
 		ret = groups_search(cred->group_info, key->gid);
-		spin_unlock(&cred->lock);
-
 		if (ret) {
 			kperm = key->perm >> 8;
 			goto use_these_perms;
@@ -57,6 +57,8 @@ int key_task_permission(const key_ref_t key_ref,
 	kperm = key->perm;
 
 use_these_perms:
+	rcu_read_lock();
+
 	/* use the top 8-bits of permissions for keys the caller possesses
 	 * - possessor permissions are additive with other permissions
 	 */
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index c9ccbdb..d3fa0ae 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -412,10 +412,13 @@ key_ref_t search_process_keyrings(struct key_type *type,
 				  struct task_struct *context)
 {
 	struct request_key_auth *rka;
+	struct cred *cred;
 	key_ref_t key_ref, ret, err;
 
 	might_sleep();
 
+	cred = get_task_cred(context);
+
 	/* we want to return -EAGAIN or -ENOKEY if any of the keyrings were
 	 * searchable, but we failed to find a key or we found a negative key;
 	 * otherwise we want to return a sample error (probably -EACCES) if
@@ -428,9 +431,9 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	err = ERR_PTR(-EAGAIN);
 
 	/* search the thread keyring first */
-	if (context->cred->thread_keyring) {
+	if (cred->thread_keyring) {
 		key_ref = keyring_search_aux(
-			make_key_ref(context->cred->thread_keyring, 1),
+			make_key_ref(cred->thread_keyring, 1),
 			context, type, description, match);
 		if (!IS_ERR(key_ref))
 			goto found;
@@ -495,9 +498,9 @@ key_ref_t search_process_keyrings(struct key_type *type,
 		}
 	}
 	/* or search the user-session keyring */
-	else if (context->cred->user->session_keyring) {
+	else if (cred->user->session_keyring) {
 		key_ref = keyring_search_aux(
-			make_key_ref(context->cred->user->session_keyring, 1),
+			make_key_ref(cred->user->session_keyring, 1),
 			context, type, description, match);
 		if (!IS_ERR(key_ref))
 			goto found;
@@ -519,20 +522,20 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	 * search the keyrings of the process mentioned there
 	 * - we don't permit access to request_key auth keys via this method
 	 */
-	if (context->cred->request_key_auth &&
+	if (cred->request_key_auth &&
 	    context == current &&
 	    type != &key_type_request_key_auth
 	    ) {
 		/* defend against the auth key being revoked */
-		down_read(&context->cred->request_key_auth->sem);
+		down_read(&cred->request_key_auth->sem);
 
-		if (key_validate(context->cred->request_key_auth) == 0) {
-			rka = context->cred->request_key_auth->payload.data;
+		if (key_validate(cred->request_key_auth) == 0) {
+			rka = cred->request_key_auth->payload.data;
 
 			key_ref = search_process_keyrings(type, description,
 							  match, rka->context);
 
-			up_read(&context->cred->request_key_auth->sem);
+			up_read(&cred->request_key_auth->sem);
 
 			if (!IS_ERR(key_ref))
 				goto found;
@@ -549,7 +552,7 @@ key_ref_t search_process_keyrings(struct key_type *type,
 				break;
 			}
 		} else {
-			up_read(&context->cred->request_key_auth->sem);
+			up_read(&cred->request_key_auth->sem);
 		}
 	}
 
@@ -557,6 +560,7 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	key_ref = ret ? ret : err;
 
 found:
+	put_cred(cred);
 	return key_ref;
 
 } /* end search_process_keyrings() */
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 10715d1..c863036 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -95,13 +95,18 @@ extern void selnl_notify_setenforce(int val);
 static int task_has_security(struct task_struct *tsk,
 			     u32 perms)
 {
-	struct task_security_struct *tsec;
-
-	tsec = tsk->cred->security;
+	const struct task_security_struct *tsec;
+	u32 sid = 0;
+
+	rcu_read_lock();
+	tsec = __task_cred(tsk)->security;
+	if (tsec)
+		sid = tsec->sid;
+	rcu_read_unlock();
 	if (!tsec)
 		return -EACCES;
 
-	return avc_has_perm(tsec->sid, SECINITSID_SECURITY,
+	return avc_has_perm(sid, SECINITSID_SECURITY,
 			    SECCLASS_SECURITY, perms, NULL);
 }
 
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 9d2e227..3e3dcbf 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -30,6 +30,8 @@
 
 #include "smack.h"
 
+#define task_security(task)	(task_cred_xxx((task), security))
+
 /*
  * I hope these are the hokeyist lines of code in the module. Casey.
  */
@@ -1012,7 +1014,7 @@ static void smack_cred_free(struct cred *cred)
  */
 static int smack_task_setpgid(struct task_struct *p, pid_t pgid)
 {
-	return smk_curacc(p->cred->security, MAY_WRITE);
+	return smk_curacc(task_security(p), MAY_WRITE);
 }
 
 /**
@@ -1023,7 +1025,7 @@ static int smack_task_setpgid(struct task_struct *p, pid_t pgid)
  */
 static int smack_task_getpgid(struct task_struct *p)
 {
-	return smk_curacc(p->cred->security, MAY_READ);
+	return smk_curacc(task_security(p), MAY_READ);
 }
 
 /**
@@ -1034,7 +1036,7 @@ static int smack_task_getpgid(struct task_struct *p)
  */
 static int smack_task_getsid(struct task_struct *p)
 {
-	return smk_curacc(p->cred->security, MAY_READ);
+	return smk_curacc(task_security(p), MAY_READ);
 }
 
 /**
@@ -1046,7 +1048,7 @@ static int smack_task_getsid(struct task_struct *p)
  */
 static void smack_task_getsecid(struct task_struct *p, u32 *secid)
 {
-	*secid = smack_to_secid(p->cred->security);
+	*secid = smack_to_secid(task_security(p));
 }
 
 /**
@@ -1062,7 +1064,7 @@ static int smack_task_setnice(struct task_struct *p, int nice)
 
 	rc = cap_task_setnice(p, nice);
 	if (rc == 0)
-		rc = smk_curacc(p->cred->security, MAY_WRITE);
+		rc = smk_curacc(task_security(p), MAY_WRITE);
 	return rc;
 }
 
@@ -1079,7 +1081,7 @@ static int smack_task_setioprio(struct task_struct *p, int ioprio)
 
 	rc = cap_task_setioprio(p, ioprio);
 	if (rc == 0)
-		rc = smk_curacc(p->cred->security, MAY_WRITE);
+		rc = smk_curacc(task_security(p), MAY_WRITE);
 	return rc;
 }
 
@@ -1091,7 +1093,7 @@ static int smack_task_setioprio(struct task_struct *p, int ioprio)
  */
 static int smack_task_getioprio(struct task_struct *p)
 {
-	return smk_curacc(p->cred->security, MAY_READ);
+	return smk_curacc(task_security(p), MAY_READ);
 }
 
 /**
@@ -1109,7 +1111,7 @@ static int smack_task_setscheduler(struct task_struct *p, int policy,
 
 	rc = cap_task_setscheduler(p, policy, lp);
 	if (rc == 0)
-		rc = smk_curacc(p->cred->security, MAY_WRITE);
+		rc = smk_curacc(task_security(p), MAY_WRITE);
 	return rc;
 }
 
@@ -1121,7 +1123,7 @@ static int smack_task_setscheduler(struct task_struct *p, int policy,
  */
 static int smack_task_getscheduler(struct task_struct *p)
 {
-	return smk_curacc(p->cred->security, MAY_READ);
+	return smk_curacc(task_security(p), MAY_READ);
 }
 
 /**
@@ -1132,7 +1134,7 @@ static int smack_task_getscheduler(struct task_struct *p)
  */
 static int smack_task_movememory(struct task_struct *p)
 {
-	return smk_curacc(p->cred->security, MAY_WRITE);
+	return smk_curacc(task_security(p), MAY_WRITE);
 }
 
 /**
@@ -1155,13 +1157,13 @@ static int smack_task_kill(struct task_struct *p, struct siginfo *info,
 	 * can write the receiver.
 	 */
 	if (secid == 0)
-		return smk_curacc(p->cred->security, MAY_WRITE);
+		return smk_curacc(task_security(p), MAY_WRITE);
 	/*
 	 * If the secid isn't 0 we're dealing with some USB IO
 	 * specific behavior. This is not clean. For one thing
 	 * we can't take privilege into account.
 	 */
-	return smk_access(smack_from_secid(secid), p->cred->security, MAY_WRITE);
+	return smk_access(smack_from_secid(secid), task_security(p), MAY_WRITE);
 }
 
 /**
@@ -1174,7 +1176,7 @@ static int smack_task_wait(struct task_struct *p)
 {
 	int rc;
 
-	rc = smk_access(current->cred->security, p->cred->security, MAY_WRITE);
+	rc = smk_access(current_security(), task_security(p), MAY_WRITE);
 	if (rc == 0)
 		return 0;
 
@@ -1205,7 +1207,7 @@ static int smack_task_wait(struct task_struct *p)
 static void smack_task_to_inode(struct task_struct *p, struct inode *inode)
 {
 	struct inode_smack *isp = inode->i_security;
-	isp->smk_inode = p->cred->security;
+	isp->smk_inode = task_security(p);
 }
 
 /*
@@ -2010,7 +2012,7 @@ static int smack_getprocattr(struct task_struct *p, char *name, char **value)
 	if (strcmp(name, "current") != 0)
 		return -EINVAL;
 
-	cp = kstrdup(p->cred->security, GFP_KERNEL);
+	cp = kstrdup(task_security(p), GFP_KERNEL);
 	if (cp == NULL)
 		return -ENOMEM;
 

