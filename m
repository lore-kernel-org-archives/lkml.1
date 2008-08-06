Return-Path: <linux-kernel-owner+w=401wt.eu-S932135AbYHFPwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbYHFPwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758103AbYHFPim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:38:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757599AbYHFPia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:38:30 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 10/24] CRED: Wrap current->cred and a few other accessors [ver
	#7]
To: jmorris@namei.org, akpm@linux-foundation.org, morgan@kernel.org
Cc: sfr@canb.auug.org.au, dhowells@redhat.com, viro@ftp.linux.org.uk,
       casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2008 16:38:05 +0100
Message-ID: <20080806153805.14351.92208.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
References: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap current->cred and a few other accessors to hide their actual
implementation.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---

 drivers/net/tun.c             |    8 +-
 drivers/usb/core/devio.c      |   10 +-
 fs/binfmt_elf.c               |   10 +-
 fs/binfmt_elf_fdpic.c         |    9 +-
 fs/exec.c                     |    5 +
 fs/fcntl.c                    |    3 -
 fs/file_table.c               |    7 +-
 fs/hugetlbfs/inode.c          |    5 +
 fs/ioprio.c                   |    4 -
 fs/smbfs/dir.c                |    3 -
 include/linux/cred.h          |  187 +++++++++++++++++++++++++++++++----------
 include/linux/securebits.h    |    2 
 ipc/mqueue.c                  |    2 
 ipc/shm.c                     |    4 -
 kernel/sys.c                  |   59 ++++++-------
 kernel/uid16.c                |   31 ++++---
 net/core/scm.c                |    2 
 net/sunrpc/auth.c             |   14 ++-
 security/commoncap.c          |    2 
 security/keys/process_keys.c  |    4 -
 security/keys/request_key.c   |   11 +-
 security/selinux/exports.c    |    8 +-
 security/selinux/xfrm.c       |    6 +
 security/smack/smack_access.c |    2 
 security/smack/smack_lsm.c    |   26 +++---
 security/smack/smackfs.c      |    4 -
 26 files changed, 269 insertions(+), 159 deletions(-)


diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 4174855..0b618bb 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -644,6 +644,7 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 	struct tun_net *tn;
 	struct tun_struct *tun;
 	struct net_device *dev;
+	const struct cred *cred = current_cred();
 	int err;
 
 	tn = net_generic(net, tun_net_id);
@@ -654,11 +655,12 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 
 		/* Check permissions */
 		if (((tun->owner != -1 &&
-		      current_euid() != tun->owner) ||
+		      cred->euid != tun->owner) ||
 		     (tun->group != -1 &&
-		      current_egid() != tun->group)) &&
-		     !capable(CAP_NET_ADMIN))
+		      cred->egid != tun->group)) &&
+		    !capable(CAP_NET_ADMIN)) {
 			return -EPERM;
+		}
 	}
 	else if (__dev_get_by_name(net, ifr->ifr_name))
 		return -EINVAL;
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 6c7c115..70829cd 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -573,6 +573,7 @@ static int usbdev_open(struct inode *inode, struct file *file)
 {
 	struct usb_device *dev = NULL;
 	struct dev_state *ps;
+	const struct cred *cred = current_cred();
 	int ret;
 
 	lock_kernel();
@@ -616,8 +617,8 @@ static int usbdev_open(struct inode *inode, struct file *file)
 	init_waitqueue_head(&ps->wait);
 	ps->discsignr = 0;
 	ps->disc_pid = get_pid(task_pid(current));
-	ps->disc_uid = current_uid();
-	ps->disc_euid = current_euid();
+	ps->disc_uid = cred->uid;
+	ps->disc_euid = cred->euid;
 	ps->disccontext = NULL;
 	ps->ifclaimed = 0;
 	security_task_getsecid(current, &ps->secid);
@@ -964,6 +965,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 	struct usb_host_endpoint *ep;
 	struct async *as;
 	struct usb_ctrlrequest *dr = NULL;
+	const struct cred *cred = current_cred();
 	unsigned int u, totlen, isofrmlen;
 	int ret, ifnum = -1;
 	int is_in;
@@ -1171,8 +1173,8 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 	as->signr = uurb->signr;
 	as->ifnum = ifnum;
 	as->pid = get_pid(task_pid(current));
-	as->uid = current_uid();
-	as->euid = current_euid();
+	as->uid = cred->uid;
+	as->euid = cred->euid;
 	security_task_getsecid(current, &as->secid);
 	if (!is_in) {
 		if (copy_from_user(as->urb->transfer_buffer, uurb->buffer,
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 0bf141e..8692d4a 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -157,7 +157,7 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	int items;
 	elf_addr_t *elf_info;
 	int ei_index = 0;
-	struct task_struct *tsk = current;
+	const struct cred *cred = current_cred();
 	struct vm_area_struct *vma;
 
 	/*
@@ -223,10 +223,10 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	NEW_AUX_ENT(AT_BASE, interp_load_addr);
 	NEW_AUX_ENT(AT_FLAGS, 0);
 	NEW_AUX_ENT(AT_ENTRY, exec->e_entry);
-	NEW_AUX_ENT(AT_UID, tsk->cred->uid);
-	NEW_AUX_ENT(AT_EUID, tsk->cred->euid);
-	NEW_AUX_ENT(AT_GID, tsk->cred->gid);
-	NEW_AUX_ENT(AT_EGID, tsk->cred->egid);
+	NEW_AUX_ENT(AT_UID, cred->uid);
+	NEW_AUX_ENT(AT_EUID, cred->euid);
+	NEW_AUX_ENT(AT_GID, cred->gid);
+	NEW_AUX_ENT(AT_EGID, cred->egid);
  	NEW_AUX_ENT(AT_SECURE, security_bprm_secureexec(bprm));
 	NEW_AUX_ENT(AT_EXECFN, bprm->exec);
 	if (k_platform) {
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 779423e..6232e55 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -465,6 +465,7 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 {
 	unsigned long sp, csp, nitems;
 	elf_caddr_t __user *argv, *envp;
+	const struct cred *cred = current_cred();
 	size_t platform_len = 0, len;
 	char *k_platform;
 	char __user *u_platform, *p;
@@ -586,10 +587,10 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	NEW_AUX_ENT(AT_BASE,	interp_params->elfhdr_addr);
 	NEW_AUX_ENT(AT_FLAGS,	0);
 	NEW_AUX_ENT(AT_ENTRY,	exec_params->entry_addr);
-	NEW_AUX_ENT(AT_UID,	(elf_addr_t) current->cred->uid);
-	NEW_AUX_ENT(AT_EUID,	(elf_addr_t) current->cred->euid);
-	NEW_AUX_ENT(AT_GID,	(elf_addr_t) current->cred->gid);
-	NEW_AUX_ENT(AT_EGID,	(elf_addr_t) current->cred->egid);
+	NEW_AUX_ENT(AT_UID,	(elf_addr_t) cred->uid);
+	NEW_AUX_ENT(AT_EUID,	(elf_addr_t) cred->euid);
+	NEW_AUX_ENT(AT_GID,	(elf_addr_t) cred->gid);
+	NEW_AUX_ENT(AT_EGID,	(elf_addr_t) cred->egid);
 
 #ifdef ARCH_DLINFO
 	nr = 0;
diff --git a/fs/exec.c b/fs/exec.c
index 93e9b1c..4867ee1 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1393,6 +1393,7 @@ EXPORT_SYMBOL(set_binfmt);
  */
 static int format_corename(char *corename, int nr_threads, long signr)
 {
+	const struct cred *cred = current_cred();
 	const char *pat_ptr = core_pattern;
 	int ispipe = (*pat_ptr == '|');
 	char *out_ptr = corename;
@@ -1429,7 +1430,7 @@ static int format_corename(char *corename, int nr_threads, long signr)
 			/* uid */
 			case 'u':
 				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%d", current_uid());
+					      "%d", cred->uid);
 				if (rc > out_end - out_ptr)
 					goto out;
 				out_ptr += rc;
@@ -1437,7 +1438,7 @@ static int format_corename(char *corename, int nr_threads, long signr)
 			/* gid */
 			case 'g':
 				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%d", current_gid());
+					      "%d", cred->gid);
 				if (rc > out_end - out_ptr)
 					goto out;
 				out_ptr += rc;
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 63964d8..c594cc0 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -205,13 +205,14 @@ static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
 int __f_setown(struct file *filp, struct pid *pid, enum pid_type type,
 		int force)
 {
+	const struct cred *cred = current_cred();
 	int err;
 	
 	err = security_file_set_fowner(filp);
 	if (err)
 		return err;
 
-	f_modown(filp, pid, type, current_uid(), current_euid(), force);
+	f_modown(filp, pid, type, cred->uid, cred->euid, force);
 	return 0;
 }
 EXPORT_SYMBOL(__f_setown);
diff --git a/fs/file_table.c b/fs/file_table.c
index a807eb0..4183190 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -94,7 +94,7 @@ int proc_nr_files(ctl_table *table, int write, struct file *filp,
  */
 struct file *get_empty_filp(void)
 {
-	struct task_struct *tsk;
+	const struct cred *cred = current_cred();
 	static int old_max;
 	struct file * f;
 
@@ -118,12 +118,11 @@ struct file *get_empty_filp(void)
 	if (security_file_alloc(f))
 		goto fail_sec;
 
-	tsk = current;
 	INIT_LIST_HEAD(&f->f_u.fu_list);
 	atomic_long_set(&f->f_count, 1);
 	rwlock_init(&f->f_owner.lock);
-	f->f_uid = tsk->cred->fsuid;
-	f->f_gid = tsk->cred->fsgid;
+	f->f_uid = cred->fsuid;
+	f->f_gid = cred->fsgid;
 	eventpoll_init_file(f);
 	/* f->f_version: 0 */
 	return f;
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 0cecb9e..9f32c1d 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -951,6 +951,7 @@ struct file *hugetlb_file_setup(const char *name, size_t size)
 	struct inode *inode;
 	struct dentry *dentry, *root;
 	struct qstr quick_string;
+	struct user_struct *user = current_user();
 
 	if (!hugetlbfs_vfsmount)
 		return ERR_PTR(-ENOENT);
@@ -958,7 +959,7 @@ struct file *hugetlb_file_setup(const char *name, size_t size)
 	if (!can_do_hugetlb_shm())
 		return ERR_PTR(-EPERM);
 
-	if (!user_shm_lock(size, current->cred->user))
+	if (!user_shm_lock(size, user))
 		return ERR_PTR(-ENOMEM);
 
 	root = hugetlbfs_vfsmount->mnt_root;
@@ -998,7 +999,7 @@ out_inode:
 out_dentry:
 	dput(dentry);
 out_shm_unlock:
-	user_shm_unlock(size, current->cred->user);
+	user_shm_unlock(size, user);
 	return ERR_PTR(error);
 }
 
diff --git a/fs/ioprio.c b/fs/ioprio.c
index fa55afc..6d96eac 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -123,7 +123,7 @@ asmlinkage long sys_ioprio_set(int which, int who, int ioprio)
 			break;
 		case IOPRIO_WHO_USER:
 			if (!who)
-				user = current->cred->user;
+				user = current_user();
 			else
 				user = find_user(who);
 
@@ -216,7 +216,7 @@ asmlinkage long sys_ioprio_get(int which, int who)
 			break;
 		case IOPRIO_WHO_USER:
 			if (!who)
-				user = current->cred->user;
+				user = current_user();
 			else
 				user = find_user(who);
 
diff --git a/fs/smbfs/dir.c b/fs/smbfs/dir.c
index 9e9bb0d..e7ddd03 100644
--- a/fs/smbfs/dir.c
+++ b/fs/smbfs/dir.c
@@ -667,8 +667,7 @@ smb_make_node(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 
 	attr.ia_valid = ATTR_MODE | ATTR_UID | ATTR_GID;
 	attr.ia_mode = mode;
-	attr.ia_uid = current_euid();
-	attr.ia_gid = current_egid();
+	current_euid_egid(&attr.ia_uid, &attr.ia_gid);
 
 	if (!new_valid_dev(dev))
 		return -EINVAL;
diff --git a/include/linux/cred.h b/include/linux/cred.h
index a0fefc0..45e954d 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -37,15 +37,16 @@ struct group_info {
  * get_group_info - Get a reference to a group info structure
  * @group_info: The group info to reference
  *
- * This must be called with the owning task locked (via task_lock()) when task
- * != current.  The reason being that the vast majority of callers are looking
- * at current->group_info, which can not be changed except by the current task.
- * Changing current->group_info requires the task lock, too.
+ * This gets a reference to a set of supplementary groups.
+ *
+ * If the caller is accessing a task's credentials, they must hold the RCU read
+ * lock when reading.
  */
-#define get_group_info(group_info)		\
-do {						\
-	atomic_inc(&(group_info)->usage);	\
-} while (0)
+static inline struct group_info *get_group_info(struct group_info *gi)
+{
+	atomic_inc(&gi->usage);
+	return gi;
+}
 
 /**
  * put_group_info - Release a reference to a group info structure
@@ -61,7 +62,7 @@ extern struct group_info *groups_alloc(int);
 extern void groups_free(struct group_info *);
 extern int set_current_groups(struct group_info *);
 extern int set_groups(struct cred *, struct group_info *);
-extern int groups_search(struct group_info *, gid_t);
+extern int groups_search(const struct group_info *, gid_t);
 
 /* access the groups "array" with this macro */
 #define GROUP_AT(gi, i) \
@@ -123,41 +124,6 @@ struct cred {
 	spinlock_t	lock;		/* lock for pointer changes */
 };
 
-#define get_current_user()	(get_uid(current->cred->user))
-
-#define task_uid(task)		((task)->cred->uid)
-#define task_gid(task)		((task)->cred->gid)
-#define task_euid(task)		((task)->cred->euid)
-#define task_egid(task)		((task)->cred->egid)
-
-#define current_uid()		(current->cred->uid)
-#define current_gid()		(current->cred->gid)
-#define current_euid()		(current->cred->euid)
-#define current_egid()		(current->cred->egid)
-#define current_suid()		(current->cred->suid)
-#define current_sgid()		(current->cred->sgid)
-#define current_fsuid()		(current->cred->fsuid)
-#define current_fsgid()		(current->cred->fsgid)
-#define current_cap()		(current->cred->cap_effective)
-
-#define current_uid_gid(_uid, _gid)		\
-do {						\
-	*(_uid) = current->cred->uid;		\
-	*(_gid) = current->cred->gid;		\
-} while(0)
-
-#define current_euid_egid(_uid, _gid)		\
-do {						\
-	*(_uid) = current->cred->euid;		\
-	*(_gid) = current->cred->egid;		\
-} while(0)
-
-#define current_fsuid_fsgid(_uid, _gid)		\
-do {						\
-	*(_uid) = current->cred->fsuid;		\
-	*(_gid) = current->cred->fsgid;		\
-} while(0)
-
 extern void __put_cred(struct cred *);
 extern int copy_creds(struct task_struct *, unsigned long);
 
@@ -187,4 +153,137 @@ static inline void put_cred(struct cred *cred)
 		__put_cred(cred);
 }
 
+/**
+ * current_cred - Access the current task's credentials
+ *
+ * Access the credentials of the current task.
+ */
+#define current_cred() \
+	(current->cred)
+
+/**
+ * __task_cred - Access another task's credentials
+ * @task: The task to query
+ *
+ * Access the credentials of another task.  The caller must hold the
+ * RCU readlock.
+ *
+ * The caller must make sure task doesn't go away, either by holding a ref on
+ * task or by holding tasklist_lock to prevent it from being unlinked.
+ */
+#define __task_cred(task) \
+	((const struct cred *)(rcu_dereference((task)->cred)))
+
+/**
+ * get_task_cred - Get another task's credentials
+ * @task: The task to query
+ *
+ * Get the credentials of a task, pinning them so that they can't go away.
+ * Accessing a task's credentials directly is not permitted.
+ *
+ * The caller must make sure task doesn't go away, either by holding a ref on
+ * task or by holding tasklist_lock to prevent it from being unlinked.
+ */
+#define get_task_cred(task)				\
+({							\
+	struct cred *__cred;				\
+	rcu_read_lock();				\
+	__cred = (struct cred *) __task_cred((task));	\
+	get_cred(__cred);				\
+	rcu_read_unlock();				\
+	__cred;						\
+})
+
+/**
+ * get_current_cred - Get the current task's credentials
+ *
+ * Get the credentials of the current task, pinning them so that they can't go
+ * away.  Accessing the current task's credentials directly is not permitted.
+ */
+#define get_current_cred()				\
+	(get_cred(current_cred()))
+
+/**
+ * get_current_user - Get the current task's user_struct
+ *
+ * Get the user record of the current task, pinning it so that it can't go
+ * away.
+ */
+#define get_current_user()				\
+({							\
+	struct user_struct *__u;			\
+	struct cred *__cred;				\
+	__cred = (struct cred *) current_cred();	\
+	__u = get_uid(__cred->user);			\
+	__u;						\
+})
+
+/**
+ * get_current_groups - Get the current task's supplementary group list
+ *
+ * Get the supplementary group list of the current task, pinning it so that it
+ * can't go away.
+ */
+#define get_current_groups()				\
+({							\
+	struct group_info *__groups;			\
+	struct cred *__cred;				\
+	__cred = (struct cred *) current_cred();	\
+	__groups = get_group_info(__cred->group_info);	\
+	__groups;					\
+})
+
+#define task_cred_xxx(task, xxx)		\
+({						\
+	__typeof__(task->cred->xxx) ___val;	\
+	rcu_read_lock();			\
+	___val = __task_cred((task))->xxx;	\
+	rcu_read_unlock();			\
+	___val;					\
+})
+
+#define task_uid(task)		(task_cred_xxx((task), uid))
+#define task_euid(task)		(task_cred_xxx((task), euid))
+
+#define current_cred_xxx(xxx)			\
+({						\
+	current->cred->xxx;			\
+})
+
+#define current_uid()		(current_cred_xxx(uid))
+#define current_gid()		(current_cred_xxx(gid))
+#define current_euid()		(current_cred_xxx(euid))
+#define current_egid()		(current_cred_xxx(egid))
+#define current_suid()		(current_cred_xxx(suid))
+#define current_sgid()		(current_cred_xxx(sgid))
+#define current_fsuid() 	(current_cred_xxx(fsuid))
+#define current_fsgid() 	(current_cred_xxx(fsgid))
+#define current_cap()		(current_cred_xxx(cap_effective))
+#define current_user()		(current_cred_xxx(user))
+#define current_security()	(current_cred_xxx(security))
+
+#define current_uid_gid(_uid, _gid)		\
+do {						\
+	const struct cred *__cred;		\
+	__cred = current_cred();		\
+	*(_uid) = __cred->uid;			\
+	*(_gid) = __cred->gid;			\
+} while(0)
+
+#define current_euid_egid(_euid, _egid)		\
+do {						\
+	const struct cred *__cred;		\
+	__cred = current_cred();		\
+	*(_euid) = __cred->euid;		\
+	*(_egid) = __cred->egid;		\
+} while(0)
+
+#define current_fsuid_fsgid(_fsuid, _fsgid)	\
+do {						\
+	const struct cred *__cred;		\
+	__cred = current_cred();		\
+	*(_fsuid) = __cred->fsuid;		\
+	*(_fsgid) = __cred->fsgid;		\
+} while(0)
+
 #endif /* _LINUX_CRED_H */
diff --git a/include/linux/securebits.h b/include/linux/securebits.h
index 6d38949..d2c5ed8 100644
--- a/include/linux/securebits.h
+++ b/include/linux/securebits.h
@@ -32,7 +32,7 @@
    setting is locked or not. A setting which is locked cannot be
    changed from user-level. */
 #define issecure_mask(X)	(1 << (X))
-#define issecure(X)		(issecure_mask(X) & current->cred->securebits)
+#define issecure(X)		(issecure_mask(X) & current_cred_xxx(securebits))
 
 #define SECURE_ALL_BITS		(issecure_mask(SECURE_NOROOT) | \
 				 issecure_mask(SECURE_NO_SETUID_FIXUP) | \
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 4d5c116..f020a77 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -104,6 +104,7 @@ static inline struct mqueue_inode_info *MQUEUE_I(struct inode *inode)
 static struct inode *mqueue_get_inode(struct super_block *sb, int mode,
 							struct mq_attr *attr)
 {
+	struct user_struct *u = current_user();
 	struct inode *inode;
 
 	inode = new_inode(sb);
@@ -118,7 +119,6 @@ static struct inode *mqueue_get_inode(struct super_block *sb, int mode,
 		if (S_ISREG(mode)) {
 			struct mqueue_inode_info *info;
 			struct task_struct *p = current;
-			struct user_struct *u = p->cred->user;
 			unsigned long mq_bytes, mq_msg_tblsz;
 
 			inode->i_fop = &mqueue_file_operations;
diff --git a/ipc/shm.c b/ipc/shm.c
index da04353..327347b 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -366,7 +366,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	if (shmflg & SHM_HUGETLB) {
 		/* hugetlb_file_setup takes care of mlock user accounting */
 		file = hugetlb_file_setup(name, size);
-		shp->mlock_user = current->cred->user;
+		shp->mlock_user = current_user();
 	} else {
 		int acctflag = VM_ACCOUNT;
 		/*
@@ -763,7 +763,7 @@ asmlinkage long sys_shmctl(int shmid, int cmd, struct shmid_ds __user *buf)
 			goto out_unlock;
 		
 		if(cmd==SHM_LOCK) {
-			struct user_struct *user = current->cred->user;
+			struct user_struct *user = current_user();
 			if (!is_file_hugepages(shp->shm_file)) {
 				err = shmem_lock(shp->shm_file, 1, user);
 				if (!err && !(shp->shm_perm.mode & SHM_LOCKED)){
diff --git a/kernel/sys.c b/kernel/sys.c
index 48cbb5b..e2a16eb 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -143,6 +143,7 @@ asmlinkage long sys_setpriority(int which, int who, int niceval)
 {
 	struct task_struct *g, *p;
 	struct user_struct *user;
+	const struct cred *cred = current_cred();
 	int error = -EINVAL;
 	struct pid *pgrp;
 
@@ -176,18 +177,18 @@ asmlinkage long sys_setpriority(int which, int who, int niceval)
 			} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
 			break;
 		case PRIO_USER:
-			user = current->cred->user;
+			user = cred->user;
 			if (!who)
-				who = current_uid();
-			else
-				if (who != current_uid() && !(user = find_user(who)))
-					goto out_unlock;	/* No processes for this user */
+				who = cred->uid;
+			else if ((who != cred->uid) &&
+				 !(user = find_user(who)))
+				goto out_unlock;	/* No processes for this user */
 
 			do_each_thread(g, p)
-				if (p->cred->uid == who)
+				if (__task_cred(p)->uid == who)
 					error = set_one_prio(p, niceval, error);
 			while_each_thread(g, p);
-			if (who != current_uid())
+			if (who != cred->uid)
 				free_uid(user);		/* For find_user() */
 			break;
 	}
@@ -207,6 +208,7 @@ asmlinkage long sys_getpriority(int which, int who)
 {
 	struct task_struct *g, *p;
 	struct user_struct *user;
+	const struct cred *cred = current_cred();
 	long niceval, retval = -ESRCH;
 	struct pid *pgrp;
 
@@ -238,21 +240,21 @@ asmlinkage long sys_getpriority(int which, int who)
 			} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
 			break;
 		case PRIO_USER:
-			user = current->cred->user;
+			user = (struct user_struct *) cred->user;
 			if (!who)
-				who = current_uid();
-			else
-				if (who != current_uid() && !(user = find_user(who)))
-					goto out_unlock;	/* No processes for this user */
+				who = cred->uid;
+			else if ((who != cred->uid) &&
+				 !(user = find_user(who)))
+				goto out_unlock;	/* No processes for this user */
 
 			do_each_thread(g, p)
-				if (p->cred->uid == who) {
+				if (__task_cred(p)->uid == who) {
 					niceval = 20 - task_nice(p);
 					if (niceval > retval)
 						retval = niceval;
 				}
 			while_each_thread(g, p);
-			if (who != current_uid())
+			if (who != cred->uid)
 				free_uid(user);		/* for find_user() */
 			break;
 	}
@@ -743,11 +745,11 @@ asmlinkage long sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 
 asmlinkage long sys_getresuid(uid_t __user *ruid, uid_t __user *euid, uid_t __user *suid)
 {
-	struct cred *cred = current->cred;
+	const struct cred *cred = current_cred();
 	int retval;
 
-	if (!(retval = put_user(cred->uid, ruid)) &&
-	    !(retval = put_user(cred->euid, euid)))
+	if (!(retval   = put_user(cred->uid,  ruid)) &&
+	    !(retval   = put_user(cred->euid, euid)))
 		retval = put_user(cred->suid, suid);
 
 	return retval;
@@ -796,11 +798,11 @@ asmlinkage long sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 
 asmlinkage long sys_getresgid(gid_t __user *rgid, gid_t __user *egid, gid_t __user *sgid)
 {
-	struct cred *cred = current->cred;
+	const struct cred *cred = current_cred();
 	int retval;
 
-	if (!(retval = put_user(cred->gid, rgid)) &&
-	    !(retval = put_user(cred->egid, egid)))
+	if (!(retval   = put_user(cred->gid,  rgid)) &&
+	    !(retval   = put_user(cred->egid, egid)))
 		retval = put_user(cred->sgid, sgid);
 
 	return retval;
@@ -1211,7 +1213,7 @@ static void groups_sort(struct group_info *group_info)
 }
 
 /* a simple bsearch */
-int groups_search(struct group_info *group_info, gid_t grp)
+int groups_search(const struct group_info *group_info, gid_t grp)
 {
 	unsigned int left, right;
 
@@ -1280,13 +1282,8 @@ EXPORT_SYMBOL(set_current_groups);
 
 asmlinkage long sys_getgroups(int gidsetsize, gid_t __user *grouplist)
 {
-	struct cred *cred = current->cred;
-	int i = 0;
-
-	/*
-	 *	SMP: Nobody else can change our grouplist. Thus we are
-	 *	safe.
-	 */
+	const struct cred *cred = current_cred();
+	int i;
 
 	if (gidsetsize < 0)
 		return -EINVAL;
@@ -1342,8 +1339,9 @@ asmlinkage long sys_setgroups(int gidsetsize, gid_t __user *grouplist)
  */
 int in_group_p(gid_t grp)
 {
-	struct cred *cred = current->cred;
+	const struct cred *cred = current_cred();
 	int retval = 1;
+
 	if (grp != cred->fsgid)
 		retval = groups_search(cred->group_info, grp);
 	return retval;
@@ -1353,8 +1351,9 @@ EXPORT_SYMBOL(in_group_p);
 
 int in_egroup_p(gid_t grp)
 {
-	struct cred *cred = current->cred;
+	const struct cred *cred = current_cred();
 	int retval = 1;
+
 	if (grp != cred->egid)
 		retval = groups_search(cred->group_info, grp);
 	return retval;
diff --git a/kernel/uid16.c b/kernel/uid16.c
index 71f07fc..2460c31 100644
--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -84,11 +84,12 @@ asmlinkage long sys_setresuid16(old_uid_t ruid, old_uid_t euid, old_uid_t suid)
 
 asmlinkage long sys_getresuid16(old_uid_t __user *ruid, old_uid_t __user *euid, old_uid_t __user *suid)
 {
+	const struct cred *cred = current_cred();
 	int retval;
 
-	if (!(retval = put_user(high2lowuid(current->cred->uid), ruid)) &&
-	    !(retval = put_user(high2lowuid(current->cred->euid), euid)))
-		retval = put_user(high2lowuid(current->cred->suid), suid);
+	if (!(retval   = put_user(high2lowuid(cred->uid),  ruid)) &&
+	    !(retval   = put_user(high2lowuid(cred->euid), euid)))
+		retval = put_user(high2lowuid(cred->suid), suid);
 
 	return retval;
 }
@@ -104,11 +105,12 @@ asmlinkage long sys_setresgid16(old_gid_t rgid, old_gid_t egid, old_gid_t sgid)
 
 asmlinkage long sys_getresgid16(old_gid_t __user *rgid, old_gid_t __user *egid, old_gid_t __user *sgid)
 {
+	const struct cred *cred = current_cred();
 	int retval;
 
-	if (!(retval = put_user(high2lowgid(current->cred->gid), rgid)) &&
-	    !(retval = put_user(high2lowgid(current->cred->egid), egid)))
-		retval = put_user(high2lowgid(current->cred->sgid), sgid);
+	if (!(retval   = put_user(high2lowgid(cred->gid),  rgid)) &&
+	    !(retval   = put_user(high2lowgid(cred->egid), egid)))
+		retval = put_user(high2lowgid(cred->sgid), sgid);
 
 	return retval;
 }
@@ -161,25 +163,24 @@ static int groups16_from_user(struct group_info *group_info,
 
 asmlinkage long sys_getgroups16(int gidsetsize, old_gid_t __user *grouplist)
 {
-	int i = 0;
+	const struct cred *cred = current_cred();
+	int i;
 
 	if (gidsetsize < 0)
 		return -EINVAL;
 
-	get_group_info(current->cred->group_info);
-	i = current->cred->group_info->ngroups;
+	i = cred->group_info->ngroups;
 	if (gidsetsize) {
 		if (i > gidsetsize) {
 			i = -EINVAL;
 			goto out;
 		}
-		if (groups16_to_user(grouplist, current->cred->group_info)) {
+		if (groups16_to_user(grouplist, cred->group_info)) {
 			i = -EFAULT;
 			goto out;
 		}
 	}
 out:
-	put_group_info(current->cred->group_info);
 	return i;
 }
 
@@ -210,20 +211,20 @@ asmlinkage long sys_setgroups16(int gidsetsize, old_gid_t __user *grouplist)
 
 asmlinkage long sys_getuid16(void)
 {
-	return high2lowuid(current->cred->uid);
+	return high2lowuid(current_uid());
 }
 
 asmlinkage long sys_geteuid16(void)
 {
-	return high2lowuid(current->cred->euid);
+	return high2lowuid(current_euid());
 }
 
 asmlinkage long sys_getgid16(void)
 {
-	return high2lowgid(current->cred->gid);
+	return high2lowgid(current_gid());
 }
 
 asmlinkage long sys_getegid16(void)
 {
-	return high2lowgid(current->cred->egid);
+	return high2lowgid(current_egid());
 }
diff --git a/net/core/scm.c b/net/core/scm.c
index c28ca32..f73c44b 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -44,7 +44,7 @@
 
 static __inline__ int scm_check_creds(struct ucred *creds)
 {
-	struct cred *cred = current->cred;
+	const struct cred *cred = current_cred();
 
 	if ((creds->pid == task_tgid_vnr(current) || capable(CAP_SYS_ADMIN)) &&
 	    ((creds->uid == cred->uid   || creds->uid == cred->euid ||
diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index 9515fef..d218553 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -350,16 +350,18 @@ EXPORT_SYMBOL_GPL(rpcauth_lookup_credcache);
 struct rpc_cred *
 rpcauth_lookupcred(struct rpc_auth *auth, int flags)
 {
-	struct auth_cred acred = {
-		.uid = current_fsuid(),
-		.gid = current_fsgid(),
-		.group_info = current->cred->group_info,
-	};
+	struct auth_cred acred;
 	struct rpc_cred *ret;
+	const struct cred *cred = current_cred();
 
 	dprintk("RPC:       looking up %s cred\n",
 		auth->au_ops->au_name);
-	get_group_info(acred.group_info);
+
+	memset(&acred, 0, sizeof(acred));
+	acred.uid = cred->fsuid;
+	acred.gid = cred->fsgid;
+	acred.group_info = get_group_info(((struct cred *)cred)->group_info);
+
 	ret = auth->au_ops->lookup_cred(auth, &acred, flags);
 	put_group_info(acred.group_info);
 	return ret;
diff --git a/security/commoncap.c b/security/commoncap.c
index cb4da7d..2de5cbe 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -606,7 +606,7 @@ int cap_task_setnice (struct task_struct *p, int nice)
 int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 		   unsigned long arg4, unsigned long arg5, long *rc_p)
 {
-	struct cred *cred = current->cred;
+	struct cred *cred = current_cred();
 	long error = 0;
 
 	switch (option) {
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 248ad13..c9ccbdb 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -42,7 +42,7 @@ struct key_user root_key_user = {
  */
 static int install_user_keyrings(void)
 {
-	struct user_struct *user = current->cred->user;
+	struct user_struct *user = current_user();
 	struct key *uid_keyring, *session_keyring;
 	char buf[20];
 	int ret;
@@ -582,7 +582,7 @@ key_ref_t lookup_user_key(key_serial_t id, int create, int partial,
 {
 	struct request_key_auth *rka;
 	struct task_struct *t = current;
-	struct cred *cred = t->cred;
+	struct cred *cred = current_cred();
 	struct key *key;
 	key_ref_t key_ref, skey_ref;
 	int ret;
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 8ffd86e..650cc3e 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -67,6 +67,7 @@ static int call_sbin_request_key(struct key_construction *cons,
 				 void *aux)
 {
 	struct task_struct *tsk = current;
+	const struct cred *cred = current_cred();
 	key_serial_t prkey, sskey;
 	struct key *key = cons->key, *authkey = cons->authkey, *keyring;
 	char *argv[9], *envp[3], uid_str[12], gid_str[12];
@@ -92,16 +93,16 @@ static int call_sbin_request_key(struct key_construction *cons,
 		goto error_link;
 
 	/* record the UID and GID */
-	sprintf(uid_str, "%d", current_fsuid());
-	sprintf(gid_str, "%d", current_fsgid());
+	sprintf(uid_str, "%d", cred->fsuid);
+	sprintf(gid_str, "%d", cred->fsgid);
 
 	/* we say which key is under construction */
 	sprintf(key_str, "%d", key->serial);
 
 	/* we specify the process's default keyrings */
 	sprintf(keyring_str[0], "%d",
-		tsk->cred->thread_keyring ?
-		tsk->cred->thread_keyring->serial : 0);
+		cred->thread_keyring ?
+		cred->thread_keyring->serial : 0);
 
 	prkey = 0;
 	if (tsk->signal->process_keyring)
@@ -114,7 +115,7 @@ static int call_sbin_request_key(struct key_construction *cons,
 		sskey = rcu_dereference(tsk->signal->session_keyring)->serial;
 		rcu_read_unlock();
 	} else {
-		sskey = tsk->cred->user->session_keyring->serial;
+		sskey = cred->user->session_keyring->serial;
 	}
 
 	sprintf(keyring_str[2], "%d", sskey);
diff --git a/security/selinux/exports.c b/security/selinux/exports.c
index cf02490..c73aeaa 100644
--- a/security/selinux/exports.c
+++ b/security/selinux/exports.c
@@ -39,9 +39,13 @@ EXPORT_SYMBOL_GPL(selinux_string_to_sid);
 int selinux_secmark_relabel_packet_permission(u32 sid)
 {
 	if (selinux_enabled) {
-		struct task_security_struct *tsec = current->cred->security;
+		const struct task_security_struct *__tsec;
+		u32 tsid;
 
-		return avc_has_perm(tsec->sid, sid, SECCLASS_PACKET,
+		__tsec = current_security();
+		tsid = __tsec->sid;
+
+		return avc_has_perm(tsid, sid, SECCLASS_PACKET,
 				    PACKET__RELABELTO, NULL);
 	}
 	return 0;
diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index d7db766..c0eb720 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -197,7 +197,7 @@ static int selinux_xfrm_sec_ctx_alloc(struct xfrm_sec_ctx **ctxp,
 	struct xfrm_user_sec_ctx *uctx, u32 sid)
 {
 	int rc = 0;
-	struct task_security_struct *tsec = current->cred->security;
+	const struct task_security_struct *tsec = current_security();
 	struct xfrm_sec_ctx *ctx = NULL;
 	char *ctx_str = NULL;
 	u32 str_len;
@@ -333,7 +333,7 @@ void selinux_xfrm_policy_free(struct xfrm_sec_ctx *ctx)
  */
 int selinux_xfrm_policy_delete(struct xfrm_sec_ctx *ctx)
 {
-	struct task_security_struct *tsec = current->cred->security;
+	const struct task_security_struct *tsec = current_security();
 	int rc = 0;
 
 	if (ctx) {
@@ -378,7 +378,7 @@ void selinux_xfrm_state_free(struct xfrm_state *x)
   */
 int selinux_xfrm_state_delete(struct xfrm_state *x)
 {
-	struct task_security_struct *tsec = current->cred->security;
+	const struct task_security_struct *tsec = current_security();
 	struct xfrm_sec_ctx *ctx = x->security;
 	int rc = 0;
 
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index b6dd4fc..247cec3 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -164,7 +164,7 @@ int smk_curacc(char *obj_label, u32 mode)
 {
 	int rc;
 
-	rc = smk_access(current->cred->security, obj_label, mode);
+	rc = smk_access(current_security(), obj_label, mode);
 	if (rc == 0)
 		return 0;
 
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 7da592f..9d2e227 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -143,7 +143,7 @@ static int smack_ptrace_traceme(struct task_struct *ptp)
 static int smack_syslog(int type)
 {
 	int rc;
-	char *sp = current->cred->security;
+	char *sp = current_security();
 
 	rc = cap_syslog(type);
 	if (rc != 0)
@@ -375,7 +375,7 @@ static int smack_sb_umount(struct vfsmount *mnt, int flags)
  */
 static int smack_inode_alloc_security(struct inode *inode)
 {
-	inode->i_security = new_inode_smack(current->cred->security);
+	inode->i_security = new_inode_smack(current_security());
 	if (inode->i_security == NULL)
 		return -ENOMEM;
 	return 0;
@@ -820,7 +820,7 @@ static int smack_file_permission(struct file *file, int mask)
  */
 static int smack_file_alloc_security(struct file *file)
 {
-	file->f_security = current->cred->security;
+	file->f_security = current_security();
 	return 0;
 }
 
@@ -918,7 +918,7 @@ static int smack_file_fcntl(struct file *file, unsigned int cmd,
  */
 static int smack_file_set_fowner(struct file *file)
 {
-	file->f_security = current->cred->security;
+	file->f_security = current_security();
 	return 0;
 }
 
@@ -986,8 +986,7 @@ static int smack_file_receive(struct file *file)
  */
 static int smack_cred_alloc_security(struct cred *cred)
 {
-	cred->security = current->cred->security;
-
+	cred->security = current_security();
 	return 0;
 }
 
@@ -1225,7 +1224,7 @@ static void smack_task_to_inode(struct task_struct *p, struct inode *inode)
  */
 static int smack_sk_alloc_security(struct sock *sk, int family, gfp_t gfp_flags)
 {
-	char *csp = current->cred->security;
+	char *csp = current_security();
 	struct socket_smack *ssp;
 
 	ssp = kzalloc(sizeof(struct socket_smack), gfp_flags);
@@ -1450,7 +1449,7 @@ static int smack_flags_to_may(int flags)
  */
 static int smack_msg_msg_alloc_security(struct msg_msg *msg)
 {
-	msg->security = current->cred->security;
+	msg->security = current_security();
 	return 0;
 }
 
@@ -1486,7 +1485,7 @@ static int smack_shm_alloc_security(struct shmid_kernel *shp)
 {
 	struct kern_ipc_perm *isp = &shp->shm_perm;
 
-	isp->security = current->cred->security;
+	isp->security = current_security();
 	return 0;
 }
 
@@ -1595,7 +1594,7 @@ static int smack_sem_alloc_security(struct sem_array *sma)
 {
 	struct kern_ipc_perm *isp = &sma->sem_perm;
 
-	isp->security = current->cred->security;
+	isp->security = current_security();
 	return 0;
 }
 
@@ -1699,7 +1698,7 @@ static int smack_msg_queue_alloc_security(struct msg_queue *msq)
 {
 	struct kern_ipc_perm *kisp = &msq->q_perm;
 
-	kisp->security = current->cred->security;
+	kisp->security = current_security();
 	return 0;
 }
 
@@ -1854,7 +1853,7 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 	struct super_block *sbp;
 	struct superblock_smack *sbsp;
 	struct inode_smack *isp;
-	char *csp = current->cred->security;
+	char *csp = current_security();
 	char *fetched;
 	char *final;
 	struct dentry *dp;
@@ -2287,8 +2286,7 @@ static void smack_sock_graft(struct sock *sk, struct socket *parent)
 		return;
 
 	ssp = sk->sk_security;
-	ssp->smk_in = current->cred->security;
-	ssp->smk_out = current->cred->security;
+	ssp->smk_in = ssp->smk_out = current_security();
 	ssp->smk_packet[0] = '\0';
 
 	rc = smack_netlabel(sk);
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 7f84906..037236e 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -336,7 +336,7 @@ static void smk_cipso_doi(void)
 
 	audit_info.loginuid = audit_get_loginuid(current);
 	audit_info.sessionid = audit_get_sessionid(current);
-	audit_info.secid = smack_to_secid(current->cred->security);
+	audit_info.secid = smack_to_secid(current_security());
 
 	rc = netlbl_cfg_map_del(NULL, &audit_info);
 	if (rc != 0)
@@ -369,7 +369,7 @@ static void smk_unlbl_ambient(char *oldambient)
 
 	audit_info.loginuid = audit_get_loginuid(current);
 	audit_info.sessionid = audit_get_sessionid(current);
-	audit_info.secid = smack_to_secid(current->cred->security);
+	audit_info.secid = smack_to_secid(current_security());
 
 	if (oldambient != NULL) {
 		rc = netlbl_cfg_map_del(oldambient, &audit_info);

