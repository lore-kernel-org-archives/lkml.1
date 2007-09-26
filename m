Return-Path: <linux-kernel-owner+w=401wt.eu-S1761041AbXIZOYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761041AbXIZOYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 10:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760283AbXIZOWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 10:22:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757400AbXIZOWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 10:22:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/24] CRED: Introduce a COW credentials record
To: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 26 Sep 2007 15:21:05 +0100
Message-ID: <20070926142104.2656.26389.stgit@warthog.procyon.org.uk>
In-Reply-To: <20070926142059.2656.27100.stgit@warthog.procyon.org.uk>
References: <20070926142059.2656.27100.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a copy on write credentials record (struct cred).  The fsuid, fsgid,
supplementary groups list move into it (DAC security).  The session, process
and thread keyrings are reflected in it, but don't primarily reside there as
they aren't per-thread and occasionally need to be instantiated or replaced by
other threads or processes.

The LSM security information (MAC security) does *not* migrate from task_struct
at this point, but will be addressed by a later patch.

task_struct then gains an RCU-governed pointer to the credentials as a
replacement to the members it lost.

struct file gains a pointer to (f_cred) and a reference on the cred struct that
the opener was using at the time the file was opened.  This replaces f_uid and
f_gid.

To alter the credentials record, a copy must be made.  This copy may then be
altered and then the pointer in the task_struct redirected to it.  From that
point on the new record should be considered immutable.

In addition, the default setting of i_uid and i_gid to fsuid and fsgid has been
moved from the callers of new_inode() into new_inode() itself.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86_64/kernel/sys_x86_64.c  |    4 +
 fs/aio.c                         |   25 +++++
 fs/anon_inodes.c                 |    2 
 fs/attr.c                        |    4 -
 fs/compat.c                      |   65 +++++++++++++
 fs/compat_ioctl.c                |    7 +
 fs/dcookies.c                    |   12 ++
 fs/devpts/inode.c                |    6 +
 fs/dquot.c                       |    2 
 fs/eventfd.c                     |    4 +
 fs/eventpoll.c                   |   16 +++
 fs/exec.c                        |   37 ++++++--
 fs/ext3/balloc.c                 |    2 
 fs/ext3/ialloc.c                 |    4 -
 fs/fcntl.c                       |   11 ++
 fs/file_table.c                  |    3 -
 fs/filesystems.c                 |    7 +
 fs/inode.c                       |    6 +
 fs/inotify_user.c                |   12 ++
 fs/ioctl.c                       |    7 +
 fs/locks.c                       |    6 +
 fs/namei.c                       |   48 ++++++++--
 fs/namespace.c                   |   12 ++
 fs/nfs/inode.c                   |    2 
 fs/nfsctl.c                      |    4 +
 fs/open.c                        |  103 ++++++++++++++++++++-
 fs/pipe.c                        |    2 
 fs/posix_acl.c                   |    4 -
 fs/proc/array.c                  |   12 +-
 fs/quota.c                       |    4 +
 fs/ramfs/inode.c                 |    2 
 fs/read_write.c                  |   54 ++++++++++-
 fs/readdir.c                     |    8 ++
 fs/select.c                      |    4 +
 fs/signalfd.c                    |    4 +
 fs/splice.c                      |   12 ++
 fs/stat.c                        |   19 ++++
 fs/super.c                       |    4 +
 fs/sync.c                        |   11 ++
 fs/timerfd.c                     |    4 +
 fs/utimes.c                      |    4 +
 fs/xattr.c                       |   60 ++++++++++++
 fs/xfs/linux-2.6/xfs_cred.h      |    4 -
 include/linux/binfmts.h          |    1 
 include/linux/cred.h             |  174 ++++++++++++++++++++++++++++++++++++
 include/linux/fs.h               |    5 +
 include/linux/init_task.h        |    4 -
 include/linux/sched.h            |    7 +
 include/linux/sunrpc/auth.h      |   18 +---
 kernel/Makefile                  |    2 
 kernel/auditsc.c                 |   13 ++-
 kernel/cred.c                    |  183 ++++++++++++++++++++++++++++++++++++++
 kernel/exit.c                    |    1 
 kernel/fork.c                    |   63 ++++++++++++-
 kernel/kernel-int.h              |   15 +++
 kernel/sys.c                     |  144 ++++++++++++++++++++++--------
 kernel/uid16.c                   |    7 +
 mm/fadvise.c                     |    4 +
 mm/filemap.c                     |    4 +
 mm/fremap.c                      |    7 +
 mm/madvise.c                     |    7 +
 mm/msync.c                       |    7 +
 mm/shmem.c                       |    6 -
 net/socket.c                     |    2 
 net/sunrpc/auth.c                |   25 +----
 net/sunrpc/auth_gss/auth_gss.c   |    6 +
 net/sunrpc/auth_null.c           |    4 -
 net/sunrpc/auth_unix.c           |    6 +
 security/dummy.c                 |   13 ++-
 security/keys/compat.c           |    6 +
 security/keys/key.c              |    3 -
 security/keys/keyctl.c           |   16 +++
 security/keys/permission.c       |   16 ++-
 security/keys/process_keys.c     |   58 ++++--------
 security/keys/request_key.c      |   14 +--
 security/keys/request_key_auth.c |    2 
 76 files changed, 1214 insertions(+), 252 deletions(-)

diff --git a/arch/x86_64/kernel/sys_x86_64.c b/arch/x86_64/kernel/sys_x86_64.c
index 4770b7a..6cb691e 100644
--- a/arch/x86_64/kernel/sys_x86_64.c
+++ b/arch/x86_64/kernel/sys_x86_64.c
@@ -43,6 +43,10 @@ asmlinkage long sys_mmap(unsigned long addr, unsigned long len, unsigned long pr
 	long error;
 	struct file * file;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = -EINVAL;
 	if (off & ~PAGE_MASK)
 		goto out;
diff --git a/fs/aio.c b/fs/aio.c
index dbe699e..4bfabc1 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1249,6 +1249,10 @@ asmlinkage long sys_io_setup(unsigned nr_events, aio_context_t __user *ctxp)
 	unsigned long ctx;
 	long ret;
 
+	ret = update_current_cred();
+	if (ret < 0)
+		goto out;
+
 	ret = get_user(ctx, ctxp);
 	if (unlikely(ret))
 		goto out;
@@ -1284,6 +1288,12 @@ out:
 asmlinkage long sys_io_destroy(aio_context_t ctx)
 {
 	struct kioctx *ioctx = lookup_ioctx(ctx);
+	int ret;
+
+	ret = update_current_cred();
+	if (ret < 0)
+		return ret;;
+
 	if (likely(NULL != ioctx)) {
 		io_destroy(ioctx);
 		return 0;
@@ -1634,6 +1644,10 @@ asmlinkage long sys_io_submit(aio_context_t ctx_id, long nr,
 	long ret = 0;
 	int i;
 
+	ret = update_current_cred();
+	if (ret < 0)
+		return ret;;
+
 	if (unlikely(nr < 0))
 		return -EINVAL;
 
@@ -1711,6 +1725,10 @@ asmlinkage long sys_io_cancel(aio_context_t ctx_id, struct iocb __user *iocb,
 	u32 key;
 	int ret;
 
+	ret = update_current_cred();
+	if (ret < 0)
+		return ret;;
+
 	ret = get_user(key, &iocb->aio_key);
 	if (unlikely(ret))
 		return -EFAULT;
@@ -1771,8 +1789,13 @@ asmlinkage long sys_io_getevents(aio_context_t ctx_id,
 				 struct timespec __user *timeout)
 {
 	struct kioctx *ioctx = lookup_ioctx(ctx_id);
-	long ret = -EINVAL;
+	long ret;
 
+	ret = update_current_cred();
+	if (ret < 0)
+		return ret;
+
+	ret = -EINVAL;
 	if (likely(ioctx)) {
 		if (likely(min_nr <= nr && min_nr >= 0 && nr >= 0))
 			ret = read_events(ioctx, min_nr, nr, events, timeout);
diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index b4a7588..921087b 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -163,8 +163,6 @@ static struct inode *anon_inode_mkinode(void)
 	 */
 	inode->i_state = I_DIRTY;
 	inode->i_mode = S_IRUSR | S_IWUSR;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 	return inode;
 }
diff --git a/fs/attr.c b/fs/attr.c
index f8dfc22..3e6b911 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -29,13 +29,13 @@ int inode_change_ok(struct inode *inode, struct iattr *attr)
 
 	/* Make sure a caller can chown. */
 	if ((ia_valid & ATTR_UID) &&
-	    (current->fsuid != inode->i_uid ||
+	    (current->cred->uid != inode->i_uid ||
 	     attr->ia_uid != inode->i_uid) && !capable(CAP_CHOWN))
 		goto error;
 
 	/* Make sure caller can chgrp. */
 	if ((ia_valid & ATTR_GID) &&
-	    (current->fsuid != inode->i_uid ||
+	    (current->cred->uid != inode->i_uid ||
 	    (!in_group_p(attr->ia_gid) && attr->ia_gid != inode->i_gid)) &&
 	    !capable(CAP_CHOWN))
 		goto error;
diff --git a/fs/compat.c b/fs/compat.c
index 15078ce..0d21573 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -238,6 +238,10 @@ asmlinkage long compat_sys_statfs(const char __user *path, struct compat_statfs
 	struct nameidata nd;
 	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = user_path_walk(path, &nd);
 	if (!error) {
 		struct kstatfs tmp;
@@ -255,6 +259,10 @@ asmlinkage long compat_sys_fstatfs(unsigned int fd, struct compat_statfs __user
 	struct kstatfs tmp;
 	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = -EBADF;
 	file = fget(fd);
 	if (!file)
@@ -303,6 +311,10 @@ asmlinkage long compat_sys_statfs64(const char __user *path, compat_size_t sz, s
 	struct nameidata nd;
 	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	if (sz != sizeof(*buf))
 		return -EINVAL;
 
@@ -326,6 +338,10 @@ asmlinkage long compat_sys_fstatfs64(unsigned int fd, compat_size_t sz, struct c
 	if (sz != sizeof(*buf))
 		return -EINVAL;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = -EBADF;
 	file = fget(fd);
 	if (!file)
@@ -397,6 +413,10 @@ asmlinkage long compat_sys_fcntl64(unsigned int fd, unsigned int cmd,
 	struct flock f;
 	long ret;
 
+	ret = update_current_cred();
+	if (ret < 0)
+		return ret;
+
 	switch (cmd) {
 	case F_GETLK:
 	case F_SETLK:
@@ -723,6 +743,10 @@ asmlinkage long compat_sys_mount(char __user * dev_name, char __user * dir_name,
 	char *dir_page;
 	int retval;
 
+	retval = update_current_cred();
+	if (retval < 0)
+		return retval;
+
 	retval = copy_mount_options (type, &type_page);
 	if (retval < 0)
 		goto out;
@@ -821,6 +845,10 @@ asmlinkage long compat_sys_old_readdir(unsigned int fd,
 	struct file *file;
 	struct compat_readdir_callback buf;
 
+	error = update_current_cred();
+	if (error < 0)
+		goto out;
+
 	error = -EBADF;
 	file = fget(fd);
 	if (!file)
@@ -900,6 +928,10 @@ asmlinkage long compat_sys_getdents(unsigned int fd,
 	struct compat_getdents_callback buf;
 	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		goto out;
+
 	error = -EFAULT;
 	if (!access_ok(VERIFY_WRITE, dirent, count))
 		goto out;
@@ -991,6 +1023,10 @@ asmlinkage long compat_sys_getdents64(unsigned int fd,
 	struct compat_getdents_callback64 buf;
 	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		goto out;
+
 	error = -EFAULT;
 	if (!access_ok(VERIFY_WRITE, dirent, count))
 		goto out;
@@ -1140,8 +1176,13 @@ asmlinkage ssize_t
 compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec, unsigned long vlen)
 {
 	struct file *file;
-	ssize_t ret = -EBADF;
+	ssize_t ret;
 
+	ret = update_current_cred();
+	if (ret < 0)
+		return ret;
+
+	ret = -EBADF;
 	file = fget(fd);
 	if (!file)
 		return -EBADF;
@@ -1164,8 +1205,13 @@ asmlinkage ssize_t
 compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec, unsigned long vlen)
 {
 	struct file *file;
-	ssize_t ret = -EBADF;
+	ssize_t ret;
 
+	ret = update_current_cred();
+	if (ret < 0)
+		return ret;
+
+	ret = -EBADF;
 	file = fget(fd);
 	if (!file)
 		return -EBADF;
@@ -1357,6 +1403,10 @@ int compat_do_execve(char * filename,
 	struct file *file;
 	int retval;
 
+	retval = update_current_cred();
+	if (retval < 0)
+		return retval;
+
 	retval = -ENOMEM;
 	bprm = kzalloc(sizeof(*bprm), GFP_KERNEL);
 	if (!bprm)
@@ -1523,10 +1573,15 @@ int compat_core_sys_select(int n, compat_ulong_t __user *inp,
 {
 	fd_set_bits fds;
 	void *bits;
-	int size, max_fds, ret = -EINVAL;
+	int size, max_fds, ret;
 	struct fdtable *fdt;
 	long stack_fds[SELECT_STACK_ALLOC/sizeof(long)];
 
+	ret = update_current_cred();
+	if (ret < 0)
+		return ret;
+
+	ret = -EINVAL;
 	if (n < 0)
 		goto out_nofds;
 
@@ -2019,6 +2074,10 @@ asmlinkage long compat_sys_nfsservctl(int cmd,
 	mm_segment_t oldfs;
 	int err;
 
+	err = update_current_cred();
+	if (err < 0)
+		return err;
+
 	karg = kmalloc(sizeof(*karg), GFP_USER);
 	kres = kmalloc(sizeof(*kres), GFP_USER);
 	if(!karg || !kres) {
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 5a5b711..3708b79 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -3567,10 +3567,15 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 				unsigned long arg)
 {
 	struct file *filp;
-	int error = -EBADF;
+	int error;
 	struct ioctl_trans *t;
 	int fput_needed;
 
+	error = update_current_cred();
+	if (error < 0)
+		goto out;
+
+	error = -EBADF;
 	filp = fget_light(fd, &fput_needed);
 	if (!filp)
 		goto out;
diff --git a/fs/dcookies.c b/fs/dcookies.c
index 792cbf5..87ac1fd 100644
--- a/fs/dcookies.c
+++ b/fs/dcookies.c
@@ -24,6 +24,7 @@
 #include <linux/errno.h>
 #include <linux/dcookies.h>
 #include <linux/mutex.h>
+#include <linux/cred.h>
 #include <asm/uaccess.h>
 
 /* The dcookies are allocated from a kmem_cache and
@@ -146,12 +147,16 @@ out:
 asmlinkage long sys_lookup_dcookie(u64 cookie64, char __user * buf, size_t len)
 {
 	unsigned long cookie = (unsigned long)cookie64;
-	int err = -EINVAL;
+	int err;
 	char * kbuf;
 	char * path;
 	size_t pathlen;
 	struct dcookie_struct * dcs;
 
+	err = update_current_cred();
+	if (err < 0)
+		return err;
+
 	/* we could leak path information to users
 	 * without dir read permission without this
 	 */
@@ -160,10 +165,9 @@ asmlinkage long sys_lookup_dcookie(u64 cookie64, char __user * buf, size_t len)
 
 	mutex_lock(&dcookie_mutex);
 
-	if (!is_live()) {
-		err = -EINVAL;
+	err = -EINVAL;
+	if (!is_live())
 		goto out;
-	}
 
 	if (!(dcs = find_dcookie(cookie)))
 		goto out;
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 06ef9a2..af6bcff 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -172,8 +172,10 @@ int devpts_pty_new(struct tty_struct *tty)
 		return -ENOMEM;
 
 	inode->i_ino = number+2;
-	inode->i_uid = config.setuid ? config.uid : current->fsuid;
-	inode->i_gid = config.setgid ? config.gid : current->fsgid;
+	if (config.setuid)
+		inode->i_uid = config.uid;
+	if (config.setgid)
+		inode->i_gid = config.gid;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	init_special_inode(inode, S_IFCHR|config.mode, device);
 	inode->i_private = tty;
diff --git a/fs/dquot.c b/fs/dquot.c
index de9a29f..f1748c6 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -832,7 +832,7 @@ static inline int need_print_warning(struct dquot *dquot)
 
 	switch (dquot->dq_type) {
 		case USRQUOTA:
-			return current->fsuid == dquot->dq_id;
+			return current->cred->uid == dquot->dq_id;
 		case GRPQUOTA:
 			return in_group_p(dquot->dq_id);
 	}
diff --git a/fs/eventfd.c b/fs/eventfd.c
index 2ce19c0..54621da 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -204,6 +204,10 @@ asmlinkage long sys_eventfd(unsigned int count)
 	struct file *file;
 	struct inode *inode;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 77b9953..1ec21ba 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1081,6 +1081,10 @@ asmlinkage long sys_epoll_create(int size)
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d)\n",
 		     current, size));
 
+	error = update_current_cred();
+	if (error < 0)
+		goto error_return;
+
 	/*
 	 * Sanity check on the size parameter, and create the internal data
 	 * structure ( "struct eventpoll" ).
@@ -1128,6 +1132,10 @@ asmlinkage long sys_epoll_ctl(int epfd, int op, int fd,
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_ctl(%d, %d, %d, %p)\n",
 		     current, epfd, op, fd, event));
 
+	error = update_current_cred();
+	if (error < 0)
+		goto error_return;
+
 	error = -EFAULT;
 	if (ep_op_has_event(op) &&
 	    copy_from_user(&epds, event, sizeof(struct epoll_event)))
@@ -1224,6 +1232,10 @@ asmlinkage long sys_epoll_wait(int epfd, struct epoll_event __user *events,
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_wait(%d, %p, %d, %d)\n",
 		     current, epfd, events, maxevents, timeout));
 
+	error = update_current_cred();
+	if (error < 0)
+		goto error_return;
+
 	/* The maximum number of event must be greater than zero */
 	if (maxevents <= 0 || maxevents > EP_MAX_EVENTS)
 		return -EINVAL;
@@ -1279,6 +1291,10 @@ asmlinkage long sys_epoll_pwait(int epfd, struct epoll_event __user *events,
 	int error;
 	sigset_t ksigmask, sigsaved;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	/*
 	 * If the caller wants a certain signal mask to be set during the wait,
 	 * we apply it here.
diff --git a/fs/exec.c b/fs/exec.c
index 073b0b8..9adc60b 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -130,6 +130,10 @@ asmlinkage long sys_uselib(const char __user * library)
 	struct nameidata nd;
 	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = __user_path_lookup_open(library, LOOKUP_FOLLOW, &nd, FMODE_READ|FMODE_EXEC);
 	if (error)
 		goto out;
@@ -1137,6 +1141,11 @@ int prepare_binprm(struct linux_binprm *bprm)
 		}
 	}
 
+	/* prepare the new credentials */
+	bprm->cred = dup_cred(current->cred);
+	if (!bprm->cred)
+		return -ENOMEM;
+
 	/* fill in binprm security blob */
 	retval = security_bprm_set(bprm);
 	if (retval)
@@ -1178,7 +1187,9 @@ void compute_creds(struct linux_binprm *bprm)
 	task_lock(current);
 	unsafe = unsafe_exec(current);
 	security_bprm_apply_creds(bprm, unsafe);
+	set_current_cred(bprm->cred);
 	task_unlock(current);
+	bprm->cred = NULL;
 	security_bprm_post_apply_creds(bprm);
 }
 EXPORT_SYMBOL(compute_creds);
@@ -1344,6 +1355,10 @@ int do_execve(char * filename,
 	unsigned long env_p;
 	int retval;
 
+	retval = update_current_cred();
+	if (retval < 0)
+		return retval;
+
 	retval = -ENOMEM;
 	bprm = kzalloc(sizeof(*bprm), GFP_KERNEL);
 	if (!bprm)
@@ -1409,6 +1424,8 @@ out:
 	free_arg_pages(bprm);
 	if (bprm->security)
 		security_bprm_free(bprm);
+	if (bprm->cred)
+		put_cred(bprm->cred);
 
 out_mm:
 	if (bprm->mm)
@@ -1716,8 +1733,8 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	struct linux_binfmt * binfmt;
 	struct inode * inode;
 	struct file * file;
+	struct cred *cred;
 	int retval = 0;
-	int fsuid = current->fsuid;
 	int flag = 0;
 	int ispipe = 0;
 
@@ -1732,6 +1749,10 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 		goto fail;
 	}
 
+	cred = dup_cred(current->cred);
+	if (!cred)
+		goto fail;
+
 	/*
 	 *	We cannot trust fsuid as being the "true" uid of the
 	 *	process nor do we know its entire history. We only know it
@@ -1739,13 +1760,13 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	 */
 	if (get_dumpable(mm) == 2) {	/* Setuid core dump mode */
 		flag = O_EXCL;		/* Stop rewrite attacks */
-		current->fsuid = 0;	/* Dump root private */
+		change_fsuid(cred, 0);	/* Dump root private */
 	}
 	set_dumpable(mm, 0);
 
 	retval = coredump_wait(exit_code);
 	if (retval < 0)
-		goto fail;
+		goto fail_cred;
 
 	/*
 	 * Clear any false indication of pending signals that might
@@ -1763,19 +1784,20 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
  	lock_kernel();
 	ispipe = format_corename(corename, core_pattern, signr);
 	unlock_kernel();
+	cred = __set_current_cred(cred);
  	if (ispipe) {
 		/* SIGPIPE can happen, but it's just never processed */
  		if(call_usermodehelper_pipe(corename+1, NULL, NULL, &file)) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       corename);
- 			goto fail_unlock;
+			goto fail_restore_cred;
  		}
  	} else
  		file = filp_open(corename,
 				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
 				 0600);
 	if (IS_ERR(file))
-		goto fail_unlock;
+		goto fail_restore_cred;
 	inode = file->f_path.dentry->d_inode;
 	if (inode->i_nlink > 1)
 		goto close_fail;	/* multiple links - don't dump */
@@ -1799,9 +1821,12 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 		current->signal->group_exit_code |= 0x80;
 close_fail:
 	filp_close(file, NULL);
+fail_restore_cred:
+	set_current_cred(cred);
 fail_unlock:
-	current->fsuid = fsuid;
 	complete_all(&mm->core_done);
+fail_cred:
+	put_cred(cred);
 fail:
 	return retval;
 }
diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index ca8aee6..6c4e82f 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -1360,7 +1360,7 @@ static int ext3_has_free_blocks(struct ext3_sb_info *sbi)
 	free_blocks = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
 	root_blocks = le32_to_cpu(sbi->s_es->s_r_blocks_count);
 	if (free_blocks < root_blocks + 1 && !capable(CAP_SYS_RESOURCE) &&
-		sbi->s_resuid != current->fsuid &&
+		sbi->s_resuid != current->cred->uid &&
 		(sbi->s_resgid == 0 || !in_group_p (sbi->s_resgid))) {
 		return 0;
 	}
diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index e45dbd6..c10ec0c 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -546,15 +546,13 @@ got:
 		percpu_counter_inc(&sbi->s_dirs_counter);
 	sb->s_dirt = 1;
 
-	inode->i_uid = current->fsuid;
 	if (test_opt (sb, GRPID))
 		inode->i_gid = dir->i_gid;
 	else if (dir->i_mode & S_ISGID) {
 		inode->i_gid = dir->i_gid;
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
-	} else
-		inode->i_gid = current->fsgid;
+	}
 	inode->i_mode = mode;
 
 	inode->i_ino = ino;
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 78b2ff0..042a52e 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -385,8 +385,13 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 asmlinkage long sys_fcntl(unsigned int fd, unsigned int cmd, unsigned long arg)
 {	
 	struct file *filp;
-	long err = -EBADF;
+	long err;
+
+	err = update_current_cred();
+	if (err < 0)
+		return err;
 
+	err = -EBADF;
 	filp = fget(fd);
 	if (!filp)
 		goto out;
@@ -410,6 +415,10 @@ asmlinkage long sys_fcntl64(unsigned int fd, unsigned int cmd, unsigned long arg
 	struct file * filp;
 	long err;
 
+	err = update_current_cred();
+	if (err < 0)
+		return err;
+
 	err = -EBADF;
 	filp = fget(fd);
 	if (!filp)
diff --git a/fs/file_table.c b/fs/file_table.c
index d17fd69..f4c772c 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -115,8 +115,7 @@ struct file *get_empty_filp(void)
 	INIT_LIST_HEAD(&f->f_u.fu_list);
 	atomic_set(&f->f_count, 1);
 	rwlock_init(&f->f_owner.lock);
-	f->f_uid = tsk->fsuid;
-	f->f_gid = tsk->fsgid;
+	f->f_cred = get_current_cred();
 	eventpoll_init_file(f);
 	/* f->f_version: 0 */
 	return f;
diff --git a/fs/filesystems.c b/fs/filesystems.c
index f37f872..93fa1be 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -179,8 +179,13 @@ static int fs_maxindex(void)
  */
 asmlinkage long sys_sysfs(int option, unsigned long arg1, unsigned long arg2)
 {
-	int retval = -EINVAL;
+	int retval;
 
+	retval = update_current_cred();
+	if (retval < 0)
+		return retval;
+
+	retval = -EINVAL;
 	switch (option) {
 		case 1:
 			retval = fs_index((const char __user *) arg1);
diff --git a/fs/inode.c b/fs/inode.c
index 29f5068..d69815e 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -531,6 +531,10 @@ repeat:
  *	mapping_set_gfp_mask() must be called with suitable flags on the
  *	newly created inode's mapping
  *
+ *	The inode's user and group IDs are set to the current task's fsuid and
+ *	fsgid respectively as a default, but this should be overridden by the
+ *	caller as appropriate.
+ *
  */
 struct inode *new_inode(struct super_block *sb)
 {
@@ -553,6 +557,8 @@ struct inode *new_inode(struct super_block *sb)
 		inode->i_ino = ++last_ino;
 		inode->i_state = 0;
 		spin_unlock(&inode_lock);
+		inode->i_uid = current->cred->uid;
+		inode->i_gid = current->cred->gid;
 	}
 	return inode;
 }
diff --git a/fs/inotify_user.c b/fs/inotify_user.c
index 9bf2f6c..cc89629 100644
--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -547,6 +547,10 @@ asmlinkage long sys_inotify_init(void)
 	struct file *filp;
 	int fd, ret;
 
+	ret = update_current_cred();
+	if (ret < 0)
+		return ret;
+
 	fd = get_unused_fd();
 	if (fd < 0)
 		return fd;
@@ -619,6 +623,10 @@ asmlinkage long sys_inotify_add_watch(int fd, const char __user *path, u32 mask)
 	int ret, fput_needed;
 	unsigned flags = 0;
 
+	ret = update_current_cred();
+	if (ret < 0)
+		return ret;
+
 	filp = fget_light(fd, &fput_needed);
 	if (unlikely(!filp))
 		return -EBADF;
@@ -660,6 +668,10 @@ asmlinkage long sys_inotify_rm_watch(int fd, u32 wd)
 	struct inotify_device *dev;
 	int ret, fput_needed;
 
+	ret = update_current_cred();
+	if (ret < 0)
+		return ret;
+
 	filp = fget_light(fd, &fput_needed);
 	if (unlikely(!filp))
 		return -EBADF;
diff --git a/fs/ioctl.c b/fs/ioctl.c
index c2a773e..7088480 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -157,9 +157,14 @@ int vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd, unsigned lon
 asmlinkage long sys_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg)
 {
 	struct file * filp;
-	int error = -EBADF;
+	int error;
 	int fput_needed;
 
+	error = update_current_cred();
+	if (error < 0)
+		goto out;
+
+	error = -EBADF;
 	filp = fget_light(fd, &fput_needed);
 	if (!filp)
 		goto out;
diff --git a/fs/locks.c b/fs/locks.c
index c795eaa..a6767e0 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1341,7 +1341,7 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
 	struct inode *inode = dentry->d_inode;
 	int error, rdlease_count = 0, wrlease_count = 0;
 
-	if ((current->fsuid != inode->i_uid) && !capable(CAP_LEASE))
+	if ((current->cred->uid != inode->i_uid) && !capable(CAP_LEASE))
 		return -EACCES;
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
@@ -1559,6 +1559,10 @@ asmlinkage long sys_flock(unsigned int fd, unsigned int cmd)
 	int can_sleep, unlock;
 	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = -EBADF;
 	filp = fget(fd);
 	if (!filp)
diff --git a/fs/namei.c b/fs/namei.c
index a83160a..59fcae5 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -185,7 +185,7 @@ int generic_permission(struct inode *inode, int mask,
 {
 	umode_t			mode = inode->i_mode;
 
-	if (current->fsuid == inode->i_uid)
+	if (current->cred->uid == inode->i_uid)
 		mode >>= 6;
 	else {
 		if (IS_POSIXACL(inode) && (mode & S_IRWXG) && check_acl) {
@@ -437,7 +437,7 @@ static int exec_permission_lite(struct inode *inode,
 	if (inode->i_op && inode->i_op->permission)
 		return -EAGAIN;
 
-	if (current->fsuid == inode->i_uid)
+	if (current->cred->uid == inode->i_uid)
 		mode >>= 6;
 	else if (in_group_p(inode->i_gid))
 		mode >>= 3;
@@ -1406,9 +1406,9 @@ static inline int check_sticky(struct inode *dir, struct inode *inode)
 {
 	if (!(dir->i_mode & S_ISVTX))
 		return 0;
-	if (inode->i_uid == current->fsuid)
+	if (inode->i_uid == current->cred->uid)
 		return 0;
-	if (dir->i_uid == current->fsuid)
+	if (dir->i_uid == current->cred->uid)
 		return 0;
 	return !capable(CAP_FOWNER);
 }
@@ -1914,11 +1914,15 @@ int vfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 asmlinkage long sys_mknodat(int dfd, const char __user *filename, int mode,
 				unsigned dev)
 {
-	int error = 0;
+	int error;
 	char * tmp;
 	struct dentry * dentry;
 	struct nameidata nd;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	if (S_ISDIR(mode))
 		return -EPERM;
 	tmp = getname(filename);
@@ -1990,11 +1994,15 @@ int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 
 asmlinkage long sys_mkdirat(int dfd, const char __user *pathname, int mode)
 {
-	int error = 0;
+	int error;
 	char * tmp;
 	struct dentry *dentry;
 	struct nameidata nd;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	tmp = getname(pathname);
 	error = PTR_ERR(tmp);
 	if (IS_ERR(tmp))
@@ -2088,11 +2096,15 @@ int vfs_rmdir(struct inode *dir, struct dentry *dentry)
 
 static long do_rmdir(int dfd, const char __user *pathname)
 {
-	int error = 0;
+	int error;
 	char * name;
 	struct dentry *dentry;
 	struct nameidata nd;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	name = getname(pathname);
 	if(IS_ERR(name))
 		return PTR_ERR(name);
@@ -2171,12 +2183,16 @@ int vfs_unlink(struct inode *dir, struct dentry *dentry)
  */
 static long do_unlinkat(int dfd, const char __user *pathname)
 {
-	int error = 0;
+	int error;
 	char * name;
 	struct dentry *dentry;
 	struct nameidata nd;
 	struct inode *inode = NULL;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	name = getname(pathname);
 	if(IS_ERR(name))
 		return PTR_ERR(name);
@@ -2256,12 +2272,16 @@ int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname, i
 asmlinkage long sys_symlinkat(const char __user *oldname,
 			      int newdfd, const char __user *newname)
 {
-	int error = 0;
+	int error;
 	char * from;
 	char * to;
 	struct dentry *dentry;
 	struct nameidata nd;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	from = getname(oldname);
 	if(IS_ERR(from))
 		return PTR_ERR(from);
@@ -2354,6 +2374,10 @@ asmlinkage long sys_linkat(int olddfd, const char __user *oldname,
 	if ((flags & ~AT_SYMLINK_FOLLOW) != 0)
 		return -EINVAL;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	to = getname(newname);
 	if (IS_ERR(to))
 		return PTR_ERR(to);
@@ -2541,12 +2565,16 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 static int do_rename(int olddfd, const char *oldname,
 			int newdfd, const char *newname)
 {
-	int error = 0;
+	int error;
 	struct dentry * old_dir, * new_dir;
 	struct dentry * old_dentry, *new_dentry;
 	struct dentry * trap;
 	struct nameidata oldnd, newnd;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = do_path_lookup(olddfd, oldname, LOOKUP_PARENT, &oldnd);
 	if (error)
 		goto exit;
diff --git a/fs/namespace.c b/fs/namespace.c
index ddbda13..62e2a07 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -633,6 +633,10 @@ asmlinkage long sys_umount(char __user * name, int flags)
 	struct nameidata nd;
 	int retval;
 
+	retval = update_current_cred();
+	if (retval < 0)
+		goto out;
+
 	retval = __user_walk(name, LOOKUP_FOLLOW, &nd);
 	if (retval)
 		goto out;
@@ -1537,6 +1541,10 @@ asmlinkage long sys_mount(char __user * dev_name, char __user * dir_name,
 	unsigned long dev_page;
 	char *dir_page;
 
+	retval = update_current_cred();
+	if (retval < 0)
+		return retval;
+
 	retval = copy_mount_options(type, &type_page);
 	if (retval < 0)
 		return retval;
@@ -1670,6 +1678,10 @@ asmlinkage long sys_pivot_root(const char __user * new_root,
 	struct nameidata new_nd, old_nd, parent_nd, root_parent, user_nd;
 	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 71a49c3..c99f654 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -285,8 +285,6 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr)
 			nfsi->change_attr = fattr->change_attr;
 		inode->i_size = nfs_size_to_loff_t(fattr->size);
 		inode->i_nlink = fattr->nlink;
-		inode->i_uid = fattr->uid;
-		inode->i_gid = fattr->gid;
 		if (fattr->valid & (NFS_ATTR_FATTR_V3 | NFS_ATTR_FATTR_V4)) {
 			/*
 			 * report the blocks in 512byte units
diff --git a/fs/nfsctl.c b/fs/nfsctl.c
index 51f1b31..c70c880 100644
--- a/fs/nfsctl.c
+++ b/fs/nfsctl.c
@@ -90,6 +90,10 @@ asmlinkage sys_nfsservctl(int cmd, struct nfsctl_arg __user *arg, void __user *r
 	int version;
 	int err;
 
+	err = update_current_cred();
+	if (err < 0)
+		return err;
+
 	if (copy_from_user(&version, &arg->ca_version, sizeof(int)))
 		return -EFAULT;
 
diff --git a/fs/open.c b/fs/open.c
index 1d9e5e9..0c05863 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -124,6 +124,10 @@ asmlinkage long sys_statfs(const char __user * path, struct statfs __user * buf)
 	struct nameidata nd;
 	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = user_path_walk(path, &nd);
 	if (!error) {
 		struct statfs tmp;
@@ -143,6 +147,11 @@ asmlinkage long sys_statfs64(const char __user *path, size_t sz, struct statfs64
 
 	if (sz != sizeof(*buf))
 		return -EINVAL;
+
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = user_path_walk(path, &nd);
 	if (!error) {
 		struct statfs64 tmp;
@@ -161,6 +170,10 @@ asmlinkage long sys_fstatfs(unsigned int fd, struct statfs __user * buf)
 	struct statfs tmp;
 	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = -EBADF;
 	file = fget(fd);
 	if (!file)
@@ -182,6 +195,10 @@ asmlinkage long sys_fstatfs64(unsigned int fd, size_t sz, struct statfs64 __user
 	if (sz != sizeof(*buf))
 		return -EINVAL;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = -EBADF;
 	file = fget(fd);
 	if (!file)
@@ -226,6 +243,10 @@ static long do_sys_truncate(const char __user * path, loff_t length)
 	struct inode * inode;
 	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		goto out;
+
 	error = -EINVAL;
 	if (length < 0)	/* sorry, but loff_t says... */
 		goto out;
@@ -295,6 +316,10 @@ static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 	struct file * file;
 	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = -EINVAL;
 	if (length < 0)
 		goto out;
@@ -364,6 +389,10 @@ asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)
 	if (offset < 0 || len <= 0)
 		goto out;
 
+	ret = update_current_cred();
+	if (ret < 0)
+		goto out;
+
 	/* Return error if mode is not supported */
 	ret = -EOPNOTSUPP;
 	if (mode && !(mode & FALLOC_FL_KEEP_SIZE))
@@ -421,19 +450,30 @@ out:
 asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 {
 	struct nameidata nd;
-	int old_fsuid, old_fsgid;
 	kernel_cap_t old_cap;
+	struct cred *cred;
 	int res;
 
 	if (mode & ~S_IRWXO)	/* where's F_OK, X_OK, W_OK, R_OK? */
 		return -EINVAL;
 
-	old_fsuid = current->fsuid;
-	old_fsgid = current->fsgid;
+	res = update_current_cred();
+	if (res < 0)
+		return res;
+
 	old_cap = current->cap_effective;
 
-	current->fsuid = current->uid;
-	current->fsgid = current->gid;
+	if (current->cred->uid != current->uid ||
+	    current->cred->gid != current->gid) {
+		cred = dup_cred(current->cred);
+		if (!cred)
+			return -ENOMEM;
+
+		change_fsuid(cred, current->uid);
+		change_fsgid(cred, current->gid);
+	} else {
+		cred = get_current_cred();
+	}
 
 	/*
 	 * Clear the capabilities if we switch to a non-root user
@@ -448,6 +488,7 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 	else
 		current->cap_effective = current->cap_permitted;
 
+	cred = __set_current_cred(cred);
 	res = __user_walk_fd(dfd, filename, LOOKUP_FOLLOW|LOOKUP_ACCESS, &nd);
 	if (res)
 		goto out;
@@ -464,8 +505,7 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 out_path_release:
 	path_release(&nd);
 out:
-	current->fsuid = old_fsuid;
-	current->fsgid = old_fsgid;
+	set_current_cred(cred);
 	current->cap_effective = old_cap;
 
 	return res;
@@ -481,6 +521,10 @@ asmlinkage long sys_chdir(const char __user * filename)
 	struct nameidata nd;
 	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		goto out;
+
 	error = __user_walk(filename,
 			    LOOKUP_FOLLOW|LOOKUP_DIRECTORY|LOOKUP_CHDIR, &nd);
 	if (error)
@@ -506,6 +550,10 @@ asmlinkage long sys_fchdir(unsigned int fd)
 	struct vfsmount *mnt;
 	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		goto out;
+
 	error = -EBADF;
 	file = fget(fd);
 	if (!file)
@@ -533,6 +581,10 @@ asmlinkage long sys_chroot(const char __user * filename)
 	struct nameidata nd;
 	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		goto out;
+
 	error = __user_walk(filename, LOOKUP_FOLLOW | LOOKUP_DIRECTORY | LOOKUP_NOALT, &nd);
 	if (error)
 		goto out;
@@ -559,9 +611,14 @@ asmlinkage long sys_fchmod(unsigned int fd, mode_t mode)
 	struct inode * inode;
 	struct dentry * dentry;
 	struct file * file;
-	int err = -EBADF;
+	int err;
 	struct iattr newattrs;
 
+	err = update_current_cred();
+	if (err < 0)
+		goto out;
+
+	err = -EBADF;
 	file = fget(fd);
 	if (!file)
 		goto out;
@@ -599,6 +656,10 @@ asmlinkage long sys_fchmodat(int dfd, const char __user *filename,
 	int error;
 	struct iattr newattrs;
 
+	error = update_current_cred();
+	if (error < 0)
+		goto out;
+
 	error = __user_walk_fd(dfd, filename, LOOKUP_FOLLOW, &nd);
 	if (error)
 		goto out;
@@ -671,6 +732,10 @@ asmlinkage long sys_chown(const char __user * filename, uid_t user, gid_t group)
 	struct nameidata nd;
 	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		goto out;
+
 	error = user_path_walk(filename, &nd);
 	if (error)
 		goto out;
@@ -690,6 +755,10 @@ asmlinkage long sys_fchownat(int dfd, const char __user *filename, uid_t user,
 	if ((flag & ~AT_SYMLINK_NOFOLLOW) != 0)
 		goto out;
 
+	error = update_current_cred();
+	if (error < 0)
+		goto out;
+
 	follow = (flag & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
 	error = __user_walk_fd(dfd, filename, follow, &nd);
 	if (error)
@@ -705,6 +774,10 @@ asmlinkage long sys_lchown(const char __user * filename, uid_t user, gid_t group
 	struct nameidata nd;
 	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		goto out;
+
 	error = user_path_walk_link(filename, &nd);
 	if (error)
 		goto out;
@@ -718,9 +791,14 @@ out:
 asmlinkage long sys_fchown(unsigned int fd, uid_t user, gid_t group)
 {
 	struct file * file;
-	int error = -EBADF;
+	int error;
 	struct dentry * dentry;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
+	error = -EBADF;
 	file = fget(fd);
 	if (!file)
 		goto out;
@@ -1026,6 +1104,11 @@ long do_sys_open(int dfd, const char __user *filename, int flags, int mode)
 {
 	char *tmp = getname(filename);
 	int fd = PTR_ERR(tmp);
+	int ret;
+
+	ret = update_current_cred();
+	if (ret < 0)
+		return ret;
 
 	if (!IS_ERR(tmp)) {
 		fd = get_unused_fd_flags(flags);
@@ -1121,6 +1204,8 @@ asmlinkage long sys_close(unsigned int fd)
 	struct fdtable *fdt;
 	int retval;
 
+	update_current_cred();
+
 	spin_lock(&files->file_lock);
 	fdt = files_fdtable(files);
 	if (fd >= fdt->max_fds)
diff --git a/fs/pipe.c b/fs/pipe.c
index 6b3d91a..18bf2ce 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -939,8 +939,6 @@ static struct inode * get_pipe_inode(void)
 	 */
 	inode->i_state = I_DIRTY;
 	inode->i_mode = S_IFIFO | S_IRUSR | S_IWUSR;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 
 	return inode;
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index aec931e..b36c79f 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -217,11 +217,11 @@ posix_acl_permission(struct inode *inode, const struct posix_acl *acl, int want)
                 switch(pa->e_tag) {
                         case ACL_USER_OBJ:
 				/* (May have been checked already) */
-                                if (inode->i_uid == current->fsuid)
+				if (inode->i_uid == current->cred->uid)
                                         goto check_perm;
                                 break;
                         case ACL_USER:
-                                if (pa->e_id == current->fsuid)
+				if (pa->e_id == current->cred->uid)
                                         goto mask;
 				break;
                         case ACL_GROUP_OBJ:
diff --git a/fs/proc/array.c b/fs/proc/array.c
index ee4814d..dc2f83a 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -159,10 +159,12 @@ static inline const char *get_task_state(struct task_struct *tsk)
 static inline char *task_state(struct task_struct *p, char *buffer)
 {
 	struct group_info *group_info;
+	struct cred *cred;
 	int g;
 	struct fdtable *fdt = NULL;
 
 	rcu_read_lock();
+	cred = get_task_cred(p);
 	buffer += sprintf(buffer,
 		"State:\t%s\n"
 		"Tgid:\t%d\n"
@@ -175,8 +177,8 @@ static inline char *task_state(struct task_struct *p, char *buffer)
 		p->tgid, p->pid,
 		pid_alive(p) ? rcu_dereference(p->real_parent)->tgid : 0,
 		pid_alive(p) && p->ptrace ? rcu_dereference(p->parent)->pid : 0,
-		p->uid, p->euid, p->suid, p->fsuid,
-		p->gid, p->egid, p->sgid, p->fsgid);
+		p->uid, p->euid, p->suid, cred->uid,
+		p->gid, p->egid, p->sgid, cred->gid);
 
 	task_lock(p);
 	if (p->files)
@@ -186,14 +188,12 @@ static inline char *task_state(struct task_struct *p, char *buffer)
 		"Groups:\t",
 		fdt ? fdt->max_fds : 0);
 	rcu_read_unlock();
-
-	group_info = p->group_info;
-	get_group_info(group_info);
 	task_unlock(p);
 
+	group_info = cred->group_info;
 	for (g = 0; g < min(group_info->ngroups, NGROUPS_SMALL); g++)
 		buffer += sprintf(buffer, "%d ", GROUP_AT(group_info, g));
-	put_group_info(group_info);
+	put_cred(cred);
 
 	buffer += sprintf(buffer, "\n");
 	return buffer;
diff --git a/fs/quota.c b/fs/quota.c
index 99b24b5..26983bc 100644
--- a/fs/quota.c
+++ b/fs/quota.c
@@ -369,6 +369,10 @@ asmlinkage long sys_quotactl(unsigned int cmd, const char __user *special, qid_t
 	struct super_block *sb = NULL;
 	int ret;
 
+	ret = update_current_cred();
+	if (ret < 0)
+		return ret;
+
 	cmds = cmd >> SUBCMDSHIFT;
 	type = cmd & SUBCMDMASK;
 
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index ef2b46d..8c92fe0 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -55,8 +55,6 @@ struct inode *ramfs_get_inode(struct super_block *sb, int mode, dev_t dev)
 
 	if (inode) {
 		inode->i_mode = mode;
-		inode->i_uid = current->fsuid;
-		inode->i_gid = current->fsgid;
 		inode->i_blocks = 0;
 		inode->i_mapping->a_ops = &ramfs_aops;
 		inode->i_mapping->backing_dev_info = &ramfs_backing_dev_info;
diff --git a/fs/read_write.c b/fs/read_write.c
index 507ddff..2c6aa3d 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -134,6 +134,10 @@ asmlinkage off_t sys_lseek(unsigned int fd, off_t offset, unsigned int origin)
 	struct file * file;
 	int fput_needed;
 
+	retval = update_current_cred();
+	if (retval < 0)
+		return retval;
+
 	retval = -EBADF;
 	file = fget_light(fd, &fput_needed);
 	if (!file)
@@ -161,6 +165,10 @@ asmlinkage long sys_llseek(unsigned int fd, unsigned long offset_high,
 	loff_t offset;
 	int fput_needed;
 
+	retval = update_current_cred();
+	if (retval < 0)
+		return retval;
+
 	retval = -EBADF;
 	file = fget_light(fd, &fput_needed);
 	if (!file)
@@ -357,9 +365,14 @@ static inline void file_pos_write(struct file *file, loff_t pos)
 asmlinkage ssize_t sys_read(unsigned int fd, char __user * buf, size_t count)
 {
 	struct file *file;
-	ssize_t ret = -EBADF;
+	ssize_t ret;
 	int fput_needed;
 
+	ret = update_current_cred();
+	if (ret < 0)
+		return ret;
+
+	ret = -EBADF;
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		loff_t pos = file_pos_read(file);
@@ -375,9 +388,14 @@ EXPORT_SYMBOL_GPL(sys_read);
 asmlinkage ssize_t sys_write(unsigned int fd, const char __user * buf, size_t count)
 {
 	struct file *file;
-	ssize_t ret = -EBADF;
+	ssize_t ret;
 	int fput_needed;
 
+	ret = update_current_cred();
+	if (ret < 0)
+		return ret;
+
+	ret = -EBADF;
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		loff_t pos = file_pos_read(file);
@@ -393,12 +411,17 @@ asmlinkage ssize_t sys_pread64(unsigned int fd, char __user *buf,
 			     size_t count, loff_t pos)
 {
 	struct file *file;
-	ssize_t ret = -EBADF;
+	ssize_t ret;
 	int fput_needed;
 
 	if (pos < 0)
 		return -EINVAL;
 
+	ret = update_current_cred();
+	if (ret < 0)
+		return ret;
+
+	ret = -EBADF;
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		ret = -ESPIPE;
@@ -414,12 +437,17 @@ asmlinkage ssize_t sys_pwrite64(unsigned int fd, const char __user *buf,
 			      size_t count, loff_t pos)
 {
 	struct file *file;
-	ssize_t ret = -EBADF;
+	ssize_t ret;
 	int fput_needed;
 
 	if (pos < 0)
 		return -EINVAL;
 
+	ret = update_current_cred();
+	if (ret < 0)
+		return ret;
+
+	ret = -EBADF;
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		ret = -ESPIPE;
@@ -664,9 +692,14 @@ asmlinkage ssize_t
 sys_readv(unsigned long fd, const struct iovec __user *vec, unsigned long vlen)
 {
 	struct file *file;
-	ssize_t ret = -EBADF;
+	ssize_t ret;
 	int fput_needed;
 
+	ret = update_current_cred();
+	if (ret < 0)
+		return ret;
+
+	ret = -EBADF;
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		loff_t pos = file_pos_read(file);
@@ -685,9 +718,14 @@ asmlinkage ssize_t
 sys_writev(unsigned long fd, const struct iovec __user *vec, unsigned long vlen)
 {
 	struct file *file;
-	ssize_t ret = -EBADF;
+	ssize_t ret;
 	int fput_needed;
 
+	ret = update_current_cred();
+	if (ret < 0)
+		return ret;
+
+	ret = -EBADF;
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		loff_t pos = file_pos_read(file);
@@ -711,6 +749,10 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 	ssize_t retval;
 	int fput_needed_in, fput_needed_out, fl;
 
+	retval = update_current_cred();
+	if (retval < 0)
+		return retval;
+
 	/*
 	 * Get input file, and verify that it is ok..
 	 */
diff --git a/fs/readdir.c b/fs/readdir.c
index efe52e6..57e6aa9 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -187,6 +187,10 @@ asmlinkage long sys_getdents(unsigned int fd, struct linux_dirent __user * diren
 	struct getdents_callback buf;
 	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		goto out;
+
 	error = -EFAULT;
 	if (!access_ok(VERIFY_WRITE, dirent, count))
 		goto out;
@@ -271,6 +275,10 @@ asmlinkage long sys_getdents64(unsigned int fd, struct linux_dirent64 __user * d
 	struct getdents_callback64 buf;
 	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		goto out;
+
 	error = -EFAULT;
 	if (!access_ok(VERIFY_WRITE, dirent, count))
 		goto out;
diff --git a/fs/select.c b/fs/select.c
index 46dca31..e2357c8 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -661,6 +661,10 @@ int do_sys_poll(struct pollfd __user *ufds, unsigned int nfds, s64 *timeout)
 	long stack_pps[POLL_STACK_ALLOC/sizeof(long)];
 	struct poll_list *stack_pp = NULL;
 
+	err = update_current_cred();
+	if (err < 0)
+		return err;
+
 	/* Do a sanity check on nfds ... */
 	if (nfds > current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
 		return -EINVAL;
diff --git a/fs/signalfd.c b/fs/signalfd.c
index aefb0be..a8316e3 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -207,6 +207,10 @@ asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemas
 	struct file *file;
 	struct inode *inode;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	if (sizemask != sizeof(sigset_t) ||
 	    copy_from_user(&sigmask, user_mask, sizeof(sigmask)))
 		return -EINVAL;
diff --git a/fs/splice.c b/fs/splice.c
index c010a72..ceb1f07 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1510,6 +1510,10 @@ asmlinkage long sys_vmsplice(int fd, const struct iovec __user *iov,
 	else if (unlikely(!nr_segs))
 		return 0;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = -EBADF;
 	file = fget_light(fd, &fput);
 	if (file) {
@@ -1535,6 +1539,10 @@ asmlinkage long sys_splice(int fd_in, loff_t __user *off_in,
 	if (unlikely(!len))
 		return 0;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = -EBADF;
 	in = fget_light(fd_in, &fput_in);
 	if (in) {
@@ -1752,6 +1760,10 @@ asmlinkage long sys_tee(int fdin, int fdout, size_t len, unsigned int flags)
 	if (unlikely(!len))
 		return 0;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = -EBADF;
 	in = fget_light(fdin, &fput_in);
 	if (in) {
diff --git a/fs/stat.c b/fs/stat.c
index 6851006..ea8e08d 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -60,6 +60,10 @@ int vfs_stat_fd(int dfd, char __user *name, struct kstat *stat)
 	struct nameidata nd;
 	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = __user_walk_fd(dfd, name, LOOKUP_FOLLOW, &nd);
 	if (!error) {
 		error = vfs_getattr(nd.mnt, nd.dentry, stat);
@@ -80,6 +84,10 @@ int vfs_lstat_fd(int dfd, char __user *name, struct kstat *stat)
 	struct nameidata nd;
 	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = __user_walk_fd(dfd, name, 0, &nd);
 	if (!error) {
 		error = vfs_getattr(nd.mnt, nd.dentry, stat);
@@ -98,8 +106,13 @@ EXPORT_SYMBOL(vfs_lstat);
 int vfs_fstat(unsigned int fd, struct kstat *stat)
 {
 	struct file *f = fget(fd);
-	int error = -EBADF;
+	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
+	error = -EBADF;
 	if (f) {
 		error = vfs_getattr(f->f_path.mnt, f->f_path.dentry, stat);
 		fput(f);
@@ -300,6 +313,10 @@ asmlinkage long sys_readlinkat(int dfd, const char __user *path,
 	if (bufsiz <= 0)
 		return -EINVAL;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = __user_walk_fd(dfd, path, 0, &nd);
 	if (!error) {
 		struct inode * inode = nd.dentry->d_inode;
diff --git a/fs/super.c b/fs/super.c
index fc8ebed..28e7370 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -540,6 +540,10 @@ asmlinkage long sys_ustat(unsigned dev, struct ustat __user * ubuf)
         struct kstatfs sbuf;
 	int err = -EINVAL;
 
+	err = update_current_cred();
+	if (err < 0)
+		return err;
+
         s = user_get_super(new_decode_dev(dev));
         if (s == NULL)
                 goto out;
diff --git a/fs/sync.c b/fs/sync.c
index 7cd005e..d5e2d5f 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -108,8 +108,13 @@ out:
 static long __do_fsync(unsigned int fd, int datasync)
 {
 	struct file *file;
-	int ret = -EBADF;
+	int ret;
+
+	ret = update_current_cred();
+	if (ret < 0)
+		return ret;
 
+	ret = -EBADF;
 	file = fget(fd);
 	if (file) {
 		ret = do_fsync(file, datasync);
@@ -183,6 +188,10 @@ asmlinkage long sys_sync_file_range(int fd, loff_t offset, loff_t nbytes,
 	int fput_needed;
 	umode_t i_mode;
 
+	ret = update_current_cred();
+	if (ret < 0)
+		goto out;
+
 	ret = -EINVAL;
 	if (flags & ~VALID_FLAGS)
 		goto out;
diff --git a/fs/timerfd.c b/fs/timerfd.c
index 61983f3..3f95c7d 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -159,6 +159,10 @@ asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
 	struct inode *inode;
 	struct itimerspec ktmr;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
 		return -EFAULT;
 
diff --git a/fs/utimes.c b/fs/utimes.c
index 682eb63..409e433 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -51,6 +51,10 @@ long do_utimes(int dfd, char __user *filename, struct timespec *times, int flags
 	struct iattr newattrs;
 	struct file *f = NULL;
 
+	error = update_current_cred();
+	if (error < 0)
+		goto out;
+
 	error = -EINVAL;
 	if (flags & ~AT_SYMLINK_NOFOLLOW)
 		goto out;
diff --git a/fs/xattr.c b/fs/xattr.c
index a44fd92..3137912 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -232,6 +232,10 @@ sys_setxattr(char __user *path, char __user *name, void __user *value,
 	struct nameidata nd;
 	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
@@ -247,6 +251,10 @@ sys_lsetxattr(char __user *path, char __user *name, void __user *value,
 	struct nameidata nd;
 	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
@@ -261,8 +269,13 @@ sys_fsetxattr(int fd, char __user *name, void __user *value,
 {
 	struct file *f;
 	struct dentry *dentry;
-	int error = -EBADF;
+	int error;
+
+	error = update_current_cred();
+	if (error < 0)
+		return error;
 
+	error = -EBADF;
 	f = fget(fd);
 	if (!f)
 		return error;
@@ -317,6 +330,10 @@ sys_getxattr(char __user *path, char __user *name, void __user *value,
 	struct nameidata nd;
 	ssize_t error;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
@@ -332,6 +349,10 @@ sys_lgetxattr(char __user *path, char __user *name, void __user *value,
 	struct nameidata nd;
 	ssize_t error;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
@@ -344,8 +365,13 @@ asmlinkage ssize_t
 sys_fgetxattr(int fd, char __user *name, void __user *value, size_t size)
 {
 	struct file *f;
-	ssize_t error = -EBADF;
+	ssize_t error;
+
+	error = update_current_cred();
+	if (error < 0)
+		return error;
 
+	error = -EBADF;
 	f = fget(fd);
 	if (!f)
 		return error;
@@ -391,6 +417,10 @@ sys_listxattr(char __user *path, char __user *list, size_t size)
 	struct nameidata nd;
 	ssize_t error;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
@@ -405,6 +435,10 @@ sys_llistxattr(char __user *path, char __user *list, size_t size)
 	struct nameidata nd;
 	ssize_t error;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
@@ -417,8 +451,13 @@ asmlinkage ssize_t
 sys_flistxattr(int fd, char __user *list, size_t size)
 {
 	struct file *f;
-	ssize_t error = -EBADF;
+	ssize_t error;
+
+	error = update_current_cred();
+	if (error < 0)
+		return error;
 
+	error = -EBADF;
 	f = fget(fd);
 	if (!f)
 		return error;
@@ -452,6 +491,10 @@ sys_removexattr(char __user *path, char __user *name)
 	struct nameidata nd;
 	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
@@ -466,6 +509,10 @@ sys_lremovexattr(char __user *path, char __user *name)
 	struct nameidata nd;
 	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
@@ -479,8 +526,13 @@ sys_fremovexattr(int fd, char __user *name)
 {
 	struct file *f;
 	struct dentry *dentry;
-	int error = -EBADF;
+	int error;
+
+	error = update_current_cred();
+	if (error < 0)
+		return error;
 
+	error = -EBADF;
 	f = fget(fd);
 	if (!f)
 		return error;
diff --git a/fs/xfs/linux-2.6/xfs_cred.h b/fs/xfs/linux-2.6/xfs_cred.h
index e7f3da6..957bbe3 100644
--- a/fs/xfs/linux-2.6/xfs_cred.h
+++ b/fs/xfs/linux-2.6/xfs_cred.h
@@ -23,9 +23,7 @@
 /*
  * Credentials
  */
-typedef struct cred {
-	/* EMPTY */
-} cred_t;
+typedef struct cred cred_t;
 
 extern struct cred *sys_cred;
 
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 91c8c07..f20f057 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -39,6 +39,7 @@ struct linux_binprm{
 	int e_uid, e_gid;
 	kernel_cap_t cap_inheritable, cap_permitted, cap_effective;
 	void *security;
+	struct cred *cred;
 	int argc, envc;
 	char * filename;	/* Name of binary as seen by procps */
 	char * interp;		/* Name of the binary really executed. Most
diff --git a/include/linux/cred.h b/include/linux/cred.h
new file mode 100644
index 0000000..0cc4400
--- /dev/null
+++ b/include/linux/cred.h
@@ -0,0 +1,174 @@
+/* Credentials management
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _LINUX_CRED_H
+#define _LINUX_CRED_H
+
+#include <linux/rcupdate.h>
+
+#ifdef __KERNEL__
+
+/*
+ * credentials record
+ * - COW semantics apply
+ */
+struct cred {
+	atomic_t		usage;
+	uid_t			uid;		/* fsuid as was */
+	gid_t			gid;		/* fsgid as was */
+	struct rcu_head		exterminate;	/* cred destroyer */
+	struct group_info	*group_info;
+
+	/* caches for references to the three task keyrings
+	 * - note that key_ref_t isn't typedef'd at this point, hence the odd
+	 *   types
+	 */
+#ifdef CONFIG_KEYS
+	struct __key_reference_with_attributes *session_keyring;
+	struct __key_reference_with_attributes *process_keyring;
+	struct __key_reference_with_attributes *thread_keyring;
+#endif
+};
+
+extern struct cred init_cred;
+
+struct inode;
+
+extern int update_current_cred(void);
+extern void put_cred(struct cred *);
+extern void change_fsuid(struct cred *, uid_t);
+extern void change_fsgid(struct cred *, gid_t);
+extern void change_groups(struct cred *, struct group_info *);
+extern struct cred *dup_cred(const struct cred *);
+
+/**
+ * get_cred - Get an extra reference on a credentials record
+ * @cred: The credentials record to reference
+ *
+ * Get an extra reference on a credentials record.  This must be released by
+ * calling put_cred().
+ */
+static inline struct cred *get_cred(struct cred *cred)
+{
+	atomic_inc(&cred->usage);
+	return cred;
+}
+
+/**
+ * get_current_cred - Get an extra reference on the current's credentials record
+ *
+ * Get an extra reference on the credentials record attached to the current
+ * task.  This must be released by calling put_cred().
+ */
+#define get_current_cred() \
+	({ get_cred(current->cred); })
+
+/**
+ * task_cred - Access the credentials of another task
+ * @tsk: The task to access
+ *
+ * Get a pointer to the credentials record of the given task.  The caller must
+ * have done rcu_read_lock() first.  The credentials record is can only be
+ * accessed as long as the RCU readlock is held by the caller.  If the
+ * credentials are required for longer, then a reference should be obtained on
+ * the cred struct.
+ *
+ * This is not required for the a task to access its own credentials.  Tasks
+ * may not alter the credentials of other tasks.
+ */
+#define task_cred(tsk) \
+	({ rcu_dereference((tsk)->cred); })
+
+/**
+ * __task_fsuid - Get the FSUID of another task (caller holds RCU read lock)
+ * task_fsuid - Get the FSUID of another task
+ * @tsk: The task to access
+ *
+ * Get the active filesystem access UID of another task.  __task_fsuid()
+ * requires the caller to hold the RCU read lock, task_fsuid() does not.
+ */
+#define __task_fsuid(tsk)	(task_cred(tsk)->uid)
+#define task_fsuid(tsk)				\
+({						\
+	uid_t ____x;				\
+	rcu_read_lock();			\
+	____x = __task_fsuid(tsk);		\
+	rcu_read_unlock();			\
+	____x;					\
+})
+
+/**
+ * __task_fsgid - Get the FSGID of another task (caller holds RCU read lock)
+ * task_fsgid - Get the FSGID of another task
+ * @tsk: The task to access
+ *
+ * Get the active filesystem access GID of another task.  __task_fsgid()
+ * requires the caller to hold the RCU read lock, task_fsgid() does not.
+ */
+#define __task_fsgid(tsk)	(task_cred(tsk)->gid)
+#define task_fsgid(tsk)				\
+({						\
+	gid_t ____x;				\
+	rcu_read_lock();			\
+	____x = __task_fsgid(tsk);		\
+	rcu_read_unlock();			\
+	____x;					\
+})
+
+/**
+ * get_task_cred - Get an extra reference on a credentials record of a task
+ * @tsk: The task to look in
+ *
+ * Get an extra reference on a credentials record of the given task and return
+ * a pointer to it.  This must be released by calling put_cred().  The caller
+ * must have done rcu_read_lock() first.
+ */
+#define get_task_cred(tsk) \
+	({ get_cred(task_cred((tsk))); })
+
+/**
+ * __set_current_cred - Swap the current credentials on the current task
+ * @cred: The revised credentials
+ *
+ * Exchange the credential record of the current task for an updated one.  This
+ * transfers a reference on the passed credential to the current task_struct,
+ * so the caller may need to get an extra reference first.  The old credentials
+ * are returned and must be disposed of appropriately.
+ *
+ * Write-locking is achieved by the fact that a thread's credentials may only
+ * be changed by that thread itself, so no explicit locking is required.
+ */
+#define __set_current_cred(CRED)			\
+({							\
+	struct cred *___old = current->cred;		\
+	rcu_assign_pointer(current->cred, (CRED));	\
+	___old;						\
+})
+
+/**
+ * set_current_cred - Change the current credentials on the current task
+ * @cred: The revised credentials
+ *
+ * Exchange the credential record of the current task for an updated one.  This
+ * transfers a reference on the passed credential to the current task_struct,
+ * so the caller may need to get an extra reference first.  The old credentials
+ * are released.
+ *
+ * Write-locking is achieved by the fact that a thread's credentials may only
+ * be changed by that thread itself, so no explicit locking is required.
+ */
+#define set_current_cred(CRED)				\
+do {							\
+	put_cred(__set_current_cred(CRED));		\
+} while (0)
+
+#endif /* __KERNEL__ */
+#endif /* _LINUX_CRED_H */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 16421f6..bf35441 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -285,6 +285,7 @@ extern int dir_notify_enable;
 #include <linux/mutex.h>
 #include <linux/sysctl.h>
 #include <linux/capability.h>
+#include <linux/cred.h>
 
 #include <asm/atomic.h>
 #include <asm/semaphore.h>
@@ -736,7 +737,7 @@ struct file {
 	mode_t			f_mode;
 	loff_t			f_pos;
 	struct fown_struct	f_owner;
-	unsigned int		f_uid, f_gid;
+	struct cred		*f_cred;
 	struct file_ra_state	f_ra;
 
 	unsigned long		f_version;
@@ -999,7 +1000,7 @@ enum {
 #define has_fs_excl() atomic_read(&current->fs_excl)
 
 #define is_owner_or_cap(inode)	\
-	((current->fsuid == (inode)->i_uid) || capable(CAP_FOWNER))
+	((current->cred->uid == (inode)->i_uid) || capable(CAP_FOWNER))
 
 /* not quite ready to be deprecated, but... */
 extern void lock_super(struct super_block *);
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index f8abfa3..5cb7931 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -89,8 +89,6 @@ extern struct nsproxy init_nsproxy;
 	.signalfd_wqh	= __WAIT_QUEUE_HEAD_INITIALIZER(sighand.signalfd_wqh),	\
 }
 
-extern struct group_info init_groups;
-
 #define INIT_STRUCT_PID {						\
 	.count 		= ATOMIC_INIT(1),				\
 	.nr		= 0, 						\
@@ -142,7 +140,7 @@ extern struct group_info init_groups;
 	.children	= LIST_HEAD_INIT(tsk.children),			\
 	.sibling	= LIST_HEAD_INIT(tsk.sibling),			\
 	.group_leader	= &tsk,						\
-	.group_info	= &init_groups,					\
+	.cred		= &init_cred,					\
 	.cap_effective	= CAP_INIT_EFF_SET,				\
 	.cap_inheritable = CAP_INIT_INH_SET,				\
 	.cap_permitted	= CAP_FULL_SET,					\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index a01ac6d..ca0d553 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -79,6 +79,7 @@ struct sched_param {
 #include <linux/rcupdate.h>
 #include <linux/futex.h>
 #include <linux/rtmutex.h>
+#include <linux/cred.h>
 
 #include <linux/time.h>
 #include <linux/param.h>
@@ -1033,9 +1034,9 @@ struct task_struct {
 	struct list_head cpu_timers[3];
 
 /* process credentials */
-	uid_t uid,euid,suid,fsuid;
-	gid_t gid,egid,sgid,fsgid;
-	struct group_info *group_info;
+	struct cred *cred;
+	uid_t uid,euid,suid;
+	gid_t gid,egid,sgid;
 	kernel_cap_t   cap_effective, cap_inheritable, cap_permitted;
 	unsigned keep_capabilities:1;
 	struct user_struct *user;
diff --git a/include/linux/sunrpc/auth.h b/include/linux/sunrpc/auth.h
index 7a69ca3..8f97f9a 100644
--- a/include/linux/sunrpc/auth.h
+++ b/include/linux/sunrpc/auth.h
@@ -21,13 +21,6 @@
 /* size of the nodename buffer */
 #define UNX_MAXNODENAME	32
 
-/* Work around the lack of a VFS credential */
-struct auth_cred {
-	uid_t	uid;
-	gid_t	gid;
-	struct group_info *group_info;
-};
-
 /*
  * Client user credentials
  */
@@ -94,6 +87,7 @@ struct rpc_auth {
 /*
  * Client authentication ops
  */
+struct cred;
 struct rpc_authops {
 	struct module		*owner;
 	rpc_authflavor_t	au_flavor;	/* flavor (RPC_AUTH_*) */
@@ -103,8 +97,8 @@ struct rpc_authops {
 	struct rpc_auth *	(*create)(struct rpc_clnt *, rpc_authflavor_t);
 	void			(*destroy)(struct rpc_auth *);
 
-	struct rpc_cred *	(*lookup_cred)(struct rpc_auth *, struct auth_cred *, int);
-	struct rpc_cred *	(*crcreate)(struct rpc_auth*, struct auth_cred *, int);
+	struct rpc_cred *	(*lookup_cred)(struct rpc_auth *, struct cred *, int);
+	struct rpc_cred *	(*crcreate)(struct rpc_auth*, struct cred *, int);
 };
 
 struct rpc_credops {
@@ -112,7 +106,7 @@ struct rpc_credops {
 	int			(*cr_init)(struct rpc_auth *, struct rpc_cred *);
 	void			(*crdestroy)(struct rpc_cred *);
 
-	int			(*crmatch)(struct auth_cred *, struct rpc_cred *, int);
+	int			(*crmatch)(struct cred *, struct rpc_cred *, int);
 	__be32 *		(*crmarshal)(struct rpc_task *, __be32 *);
 	int			(*crrefresh)(struct rpc_task *);
 	__be32 *		(*crvalidate)(struct rpc_task *, __be32 *);
@@ -133,8 +127,8 @@ int			rpcauth_register(const struct rpc_authops *);
 int			rpcauth_unregister(const struct rpc_authops *);
 struct rpc_auth *	rpcauth_create(rpc_authflavor_t, struct rpc_clnt *);
 void			rpcauth_release(struct rpc_auth *);
-struct rpc_cred *	rpcauth_lookup_credcache(struct rpc_auth *, struct auth_cred *, int);
-void			rpcauth_init_cred(struct rpc_cred *, const struct auth_cred *, struct rpc_auth *, const struct rpc_credops *);
+struct rpc_cred *	rpcauth_lookup_credcache(struct rpc_auth *, struct cred *, int);
+void			rpcauth_init_cred(struct rpc_cred *, const struct cred *, struct rpc_auth *, const struct rpc_credops *);
 struct rpc_cred *	rpcauth_lookupcred(struct rpc_auth *, int);
 struct rpc_cred *	rpcauth_bindcred(struct rpc_task *);
 void			rpcauth_holdcred(struct rpc_task *);
diff --git a/kernel/Makefile b/kernel/Makefile
index 2a99983..1f1f17b 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -9,7 +9,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o die_notifier.o \
-	    utsname.o
+	    utsname.o cred.o
 
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 04f3ffb..282e041 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -303,7 +303,8 @@ static int audit_filter_rules(struct task_struct *tsk,
 			result = audit_comparator(tsk->suid, f->op, f->val);
 			break;
 		case AUDIT_FSUID:
-			result = audit_comparator(tsk->fsuid, f->op, f->val);
+			result = audit_comparator(task_fsuid(tsk), f->op,
+						  f->val);
 			break;
 		case AUDIT_GID:
 			result = audit_comparator(tsk->gid, f->op, f->val);
@@ -315,7 +316,8 @@ static int audit_filter_rules(struct task_struct *tsk,
 			result = audit_comparator(tsk->sgid, f->op, f->val);
 			break;
 		case AUDIT_FSGID:
-			result = audit_comparator(tsk->fsgid, f->op, f->val);
+			result = audit_comparator(task_fsgid(tsk), f->op,
+						  f->val);
 			break;
 		case AUDIT_PERS:
 			result = audit_comparator(tsk->personality, f->op, f->val);
@@ -885,12 +887,15 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 	context->gid = tsk->gid;
 	context->euid = tsk->euid;
 	context->suid = tsk->suid;
-	context->fsuid = tsk->fsuid;
 	context->egid = tsk->egid;
 	context->sgid = tsk->sgid;
-	context->fsgid = tsk->fsgid;
 	context->personality = tsk->personality;
 
+	rcu_read_lock();
+	context->fsuid = __task_fsuid(tsk);
+	context->fsgid = __task_fsgid(tsk);
+	rcu_read_unlock();
+
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_SYSCALL);
 	if (!ab)
 		return;		/* audit_panic has been called */
diff --git a/kernel/cred.c b/kernel/cred.c
new file mode 100644
index 0000000..5b56b2b
--- /dev/null
+++ b/kernel/cred.c
@@ -0,0 +1,183 @@
+/* Credential caching/management
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/security.h>
+#include <linux/key.h>
+#include "kernel-int.h"
+
+/*
+ * the credentials for the init task
+ * - the usage count is elevated so that this is never freed
+ */
+struct cred init_cred = {
+	.usage		= ATOMIC_INIT(2),
+	.group_info	= &init_groups,
+};
+
+/**
+ * update_current_cred - Bring the current task's creds up to date
+ *
+ * Bring the current task's credentials up to date with respect to the keyrings
+ * they shadow.  The process and session level keyrings may get changed by
+ * sibling threads with the same process, but the change can't be applied back
+ * to this thread's cred struct except by this thread itself.
+ */
+int update_current_cred(void)
+{
+	struct cred *cred = current->cred;
+#ifdef CONFIG_KEYS
+	struct signal_struct *sig = current->signal;
+	struct key *keyring;
+#endif
+
+	if (
+#ifdef CONFIG_KEYS
+		key_ref_to_ptr(cred->session_keyring) == sig->session_keyring &&
+		key_ref_to_ptr(cred->process_keyring) == sig->process_keyring &&
+		key_ref_to_ptr(cred->thread_keyring) == current->thread_keyring &&
+#endif
+		true)
+		return 0;
+
+	cred = kmalloc(sizeof(struct cred), GFP_KERNEL);
+	if (!cred)
+		return -ENOMEM;
+
+	*cred = *current->cred;
+	atomic_set(&cred->usage, 1);
+	get_group_info(cred->group_info);
+
+#ifdef CONFIG_KEYS
+	rcu_read_lock();
+	keyring = key_get(rcu_dereference(sig->session_keyring));
+	rcu_read_unlock();
+	if (!keyring)
+		keyring = key_get(current->user->session_keyring);
+	cred->session_keyring = make_key_ref(keyring, 1);
+
+	keyring = key_get(sig->process_keyring);
+	if (keyring)
+		cred->process_keyring = make_key_ref(keyring, 1);
+	else
+		cred->process_keyring = NULL;
+
+	cred->thread_keyring = NULL;
+#endif
+
+	set_current_cred(cred);
+	return 0;
+}
+
+/**
+ * dup_cred - Duplicate a credentials structure
+ * @pcred: The credentials record to duplicate
+ *
+ * Duplicate and return a credentials structure so that the copy can be
+ * modified.  NULL is returned if there is insufficient memory to make the
+ * copy.
+ */
+struct cred *dup_cred(const struct cred *pcred)
+{
+	struct cred *cred;
+
+	cred = kmalloc(sizeof(struct cred), GFP_KERNEL);
+	if (likely(cred)) {
+		*cred = *pcred;
+		atomic_set(&cred->usage, 1);
+		get_group_info(cred->group_info);
+#ifdef CONFIG_KEYS
+		key_get(key_ref_to_ptr(cred->session_keyring));
+		key_get(key_ref_to_ptr(cred->process_keyring));
+		key_get(key_ref_to_ptr(cred->thread_keyring));
+#endif
+	}
+	return cred;
+}
+
+EXPORT_SYMBOL(dup_cred);
+
+/*
+ * RCU-based credentials destroyer
+ */
+static void put_cred_rcu(struct rcu_head *rcu)
+{
+	struct cred *cred = container_of(rcu, struct cred, exterminate);
+
+	put_group_info(cred->group_info);
+	key_ref_put(cred->session_keyring);
+	key_ref_put(cred->process_keyring);
+	key_ref_put(cred->thread_keyring);
+	kfree(cred);
+}
+
+/**
+ * put_cred - Release a reference to a credentials record
+ * cred: The credentials record to release
+ *
+ * Release a reference to a credentials record.  When the last reference is
+ * released, the record will be deleted with due care for RCU accesses still
+ * ongoing.
+ */
+void put_cred(struct cred *cred)
+{
+	if (atomic_dec_and_test(&cred->usage))
+		call_rcu(&cred->exterminate, put_cred_rcu);
+}
+
+EXPORT_SYMBOL(put_cred);
+
+/**
+ * change_fsuid - Change the VFS applicable UID in a new credential record
+ * @cred: The credential record to alter
+ * @uid: The user ID to set
+ *
+ * Change the VFS access and creation user ID in a new credential record.
+ */
+void change_fsuid(struct cred *cred, uid_t uid)
+{
+	cred->uid = uid;
+}
+
+EXPORT_SYMBOL(change_fsuid);
+
+/**
+ * change_fsgid - Change the VFS applicable GID in a new credential record
+ * @cred: The credential record to alter
+ * @gid: The group ID to set
+ *
+ * Change the VFS access and creation group ID in a new credential record.
+ */
+void change_fsgid(struct cred *cred, gid_t gid)
+{
+	cred->gid = gid;
+}
+
+EXPORT_SYMBOL(change_fsgid);
+
+/**
+ * change_groups - Change the supplementary groups in a new credential record
+ * @cred: The credential record to alter
+ * @group_info: The supplementary groups to attach
+ *
+ * Change the VFS access supplementary group list in a new credential record.
+ */
+void change_groups(struct cred *cred, struct group_info *group_info)
+{
+	struct group_info *old = cred->group_info;
+
+	get_group_info(group_info);
+	cred->group_info = group_info;
+	put_group_info(old);
+}
+
+EXPORT_SYMBOL(change_groups);
diff --git a/kernel/exit.c b/kernel/exit.c
index 993369e..c366ae7 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -288,6 +288,7 @@ static void reparent_to_kthreadd(void)
 	/* cpus_allowed? */
 	/* rt_priority? */
 	/* signals? */
+	set_current_cred(get_cred(&init_cred));
 	security_task_reparent_to_init(current);
 	memcpy(current->signal->rlim, init_task.signal->rlim,
 	       sizeof(current->signal->rlim));
diff --git a/kernel/fork.c b/kernel/fork.c
index 33f12f4..677c353 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -121,7 +121,7 @@ void __put_task_struct(struct task_struct *tsk)
 
 	security_task_free(tsk);
 	free_uid(tsk->user);
-	put_group_info(tsk->group_info);
+	put_cred(tsk->cred);
 	delayacct_tsk_free(tsk);
 
 	if (!profile_handoff_task(tsk))
@@ -949,6 +949,57 @@ static inline void rt_mutex_init_task(struct task_struct *p)
 }
 
 /*
+ * Copy a set of credentials
+ */
+static int copy_cred(struct task_struct *p)
+{
+	struct cred *cred;
+#ifdef CONFIG_KEYS
+	struct key *session_keyring, *process_keyring;
+#endif
+
+	/* share the credentials if we can */
+	if (
+#ifdef CONFIG_KEYS
+		!p->cred->thread_keyring &&
+#endif
+		true
+	    ) {
+		atomic_inc(&p->cred->usage);
+	} else {
+		cred = kmalloc(sizeof(struct cred), GFP_KERNEL);
+		if (!cred)
+			return -ENOMEM;
+
+		*cred = *p->cred;
+		atomic_set(&cred->usage, 1);
+		get_group_info(cred->group_info);
+
+#ifdef CONFIG_KEYS
+		rcu_read_lock();
+		session_keyring =
+			key_get(rcu_dereference(p->signal->session_keyring));
+		rcu_read_unlock();
+		if (!session_keyring)
+			session_keyring = key_get(p->user->session_keyring);
+		cred->session_keyring = make_key_ref(session_keyring, 1);
+
+		process_keyring = key_get(p->signal->process_keyring);
+		if (process_keyring)
+			cred->process_keyring =
+				make_key_ref(process_keyring, 1);
+		else
+			cred->process_keyring = NULL;
+
+		cred->thread_keyring = NULL;
+#endif
+
+		p->cred = cred;
+	}
+	return 0;
+}
+
+/*
  * This creates a new process as a copy of the old one,
  * but does not actually start it yet.
  *
@@ -1010,7 +1061,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	atomic_inc(&p->user->__count);
 	atomic_inc(&p->user->processes);
-	get_group_info(p->group_info);
+	if ((retval = copy_cred(p) < 0))
+		goto bad_fork_cleanup_count;
 
 	/*
 	 * If multiple threads are within copy_process(), then this check
@@ -1018,10 +1070,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	 * to stop root fork bombs.
 	 */
 	if (nr_threads >= max_threads)
-		goto bad_fork_cleanup_count;
+		goto bad_fork_cleanup_cred;
 
 	if (!try_module_get(task_thread_info(p)->exec_domain->module))
-		goto bad_fork_cleanup_count;
+		goto bad_fork_cleanup_cred;
 
 	if (p->binfmt && !try_module_get(p->binfmt->module))
 		goto bad_fork_cleanup_put_domain;
@@ -1309,8 +1361,9 @@ bad_fork_cleanup_delays_binfmt:
 		module_put(p->binfmt->module);
 bad_fork_cleanup_put_domain:
 	module_put(task_thread_info(p)->exec_domain->module);
+bad_fork_cleanup_cred:
+	put_cred(p->cred);
 bad_fork_cleanup_count:
-	put_group_info(p->group_info);
 	atomic_dec(&p->user->processes);
 	free_uid(p->user);
 bad_fork_free:
diff --git a/kernel/kernel-int.h b/kernel/kernel-int.h
new file mode 100644
index 0000000..16c68e3
--- /dev/null
+++ b/kernel/kernel-int.h
@@ -0,0 +1,15 @@
+/* kernel/ internal definitions
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+/*
+ * sys.c
+ */
+extern struct group_info init_groups;
diff --git a/kernel/sys.c b/kernel/sys.c
index 1b33b05..9bb591f 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -41,6 +41,7 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/unistd.h>
+#include "kernel-int.h"
 
 #ifndef SET_UNALIGN_CTL
 # define SET_UNALIGN_CTL(a,b)	(-EINVAL)
@@ -1011,6 +1012,7 @@ void ctrl_alt_del(void)
  */
 asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
 {
+	struct cred *cred;
 	int old_rgid = current->gid;
 	int old_egid = current->egid;
 	int new_rgid = old_rgid;
@@ -1038,6 +1040,11 @@ asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
 		else
 			return -EPERM;
 	}
+
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
+
 	if (new_egid != old_egid) {
 		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
@@ -1045,9 +1052,10 @@ asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
 	if (rgid != (gid_t) -1 ||
 	    (egid != (gid_t) -1 && egid != old_rgid))
 		current->sgid = new_egid;
-	current->fsgid = new_egid;
 	current->egid = new_egid;
 	current->gid = new_rgid;
+	change_fsgid(cred, new_egid);
+	set_current_cred(cred);
 	key_fsgid_changed(current);
 	proc_id_connector(current, PROC_EVENT_GID);
 	return 0;
@@ -1060,6 +1068,7 @@ asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
  */
 asmlinkage long sys_setgid(gid_t gid)
 {
+	struct cred *cred;
 	int old_egid = current->egid;
 	int retval;
 
@@ -1067,22 +1076,29 @@ asmlinkage long sys_setgid(gid_t gid)
 	if (retval)
 		return retval;
 
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
+
 	if (capable(CAP_SETGID)) {
 		if (old_egid != gid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->gid = current->egid = current->sgid = current->fsgid = gid;
+		current->gid = current->egid = current->sgid = gid;
 	} else if ((gid == current->gid) || (gid == current->sgid)) {
 		if (old_egid != gid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->egid = current->fsgid = gid;
-	}
-	else
+		current->egid = gid;
+	} else {
+		put_cred(cred);
 		return -EPERM;
+	}
 
+	change_fsgid(cred, gid);
+	set_current_cred(cred);
 	key_fsgid_changed(current);
 	proc_id_connector(current, PROC_EVENT_GID);
 	return 0;
@@ -1130,6 +1146,7 @@ static int set_user(uid_t new_ruid, int dumpclear)
  */
 asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
 {
+	struct cred *cred;
 	int old_ruid, old_euid, old_suid, new_ruid, new_euid;
 	int retval;
 
@@ -1158,19 +1175,26 @@ asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
 			return -EPERM;
 	}
 
-	if (new_ruid != old_ruid && set_user(new_ruid, new_euid != old_euid) < 0)
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
+
+	if (new_ruid != old_ruid && set_user(new_ruid, new_euid != old_euid) < 0) {
+		put_cred(cred);
 		return -EAGAIN;
+	}
 
 	if (new_euid != old_euid) {
 		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
 	}
-	current->fsuid = current->euid = new_euid;
+	current->euid = new_euid;
 	if (ruid != (uid_t) -1 ||
 	    (euid != (uid_t) -1 && euid != old_ruid))
 		current->suid = current->euid;
-	current->fsuid = current->euid;
 
+	change_fsuid(cred, new_euid);
+	set_current_cred(cred);
 	key_fsuid_changed(current);
 	proc_id_connector(current, PROC_EVENT_UID);
 
@@ -1192,6 +1216,7 @@ asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
  */
 asmlinkage long sys_setuid(uid_t uid)
 {
+	struct cred *cred;
 	int old_euid = current->euid;
 	int old_ruid, old_suid, new_suid;
 	int retval;
@@ -1200,24 +1225,33 @@ asmlinkage long sys_setuid(uid_t uid)
 	if (retval)
 		return retval;
 
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
+
 	old_ruid = current->uid;
 	old_suid = current->suid;
 	new_suid = old_suid;
 	
 	if (capable(CAP_SETUID)) {
-		if (uid != old_ruid && set_user(uid, old_euid != uid) < 0)
+		if (uid != old_ruid && set_user(uid, old_euid != uid) < 0) {
+			put_cred(cred);
 			return -EAGAIN;
+		}
 		new_suid = uid;
-	} else if ((uid != current->uid) && (uid != new_suid))
+	} else if ((uid != current->uid) && (uid != new_suid)) {
+		put_cred(cred);
 		return -EPERM;
+	}
 
 	if (old_euid != uid) {
 		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
 	}
-	current->fsuid = current->euid = uid;
+	current->euid = uid;
 	current->suid = new_suid;
-
+	change_fsuid(cred, uid);
+	set_current_cred(cred);
 	key_fsuid_changed(current);
 	proc_id_connector(current, PROC_EVENT_UID);
 
@@ -1231,6 +1265,7 @@ asmlinkage long sys_setuid(uid_t uid)
  */
 asmlinkage long sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 {
+	struct cred *cred;
 	int old_ruid = current->uid;
 	int old_euid = current->euid;
 	int old_suid = current->suid;
@@ -1251,9 +1286,16 @@ asmlinkage long sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 		    (suid != current->euid) && (suid != current->suid))
 			return -EPERM;
 	}
+
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
+
 	if (ruid != (uid_t) -1) {
-		if (ruid != current->uid && set_user(ruid, euid != current->euid) < 0)
+		if (ruid != current->uid && set_user(ruid, euid != current->euid) < 0) {
+			put_cred(cred);
 			return -EAGAIN;
+		}
 	}
 	if (euid != (uid_t) -1) {
 		if (euid != current->euid) {
@@ -1262,10 +1304,10 @@ asmlinkage long sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 		}
 		current->euid = euid;
 	}
-	current->fsuid = current->euid;
 	if (suid != (uid_t) -1)
 		current->suid = suid;
-
+	change_fsuid(cred, current->euid);
+	set_current_cred(cred);
 	key_fsuid_changed(current);
 	proc_id_connector(current, PROC_EVENT_UID);
 
@@ -1288,6 +1330,7 @@ asmlinkage long sys_getresuid(uid_t __user *ruid, uid_t __user *euid, uid_t __us
  */
 asmlinkage long sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 {
+	struct cred *cred;
 	int retval;
 
 	retval = security_task_setgid(rgid, egid, sgid, LSM_SETID_RES);
@@ -1305,6 +1348,11 @@ asmlinkage long sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 		    (sgid != current->egid) && (sgid != current->sgid))
 			return -EPERM;
 	}
+
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
+
 	if (egid != (gid_t) -1) {
 		if (egid != current->egid) {
 			set_dumpable(current->mm, suid_dumpable);
@@ -1312,12 +1360,13 @@ asmlinkage long sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 		}
 		current->egid = egid;
 	}
-	current->fsgid = current->egid;
 	if (rgid != (gid_t) -1)
 		current->gid = rgid;
 	if (sgid != (gid_t) -1)
 		current->sgid = sgid;
 
+	change_fsgid(cred, current->egid);
+	set_current_cred(cred);
 	key_fsgid_changed(current);
 	proc_id_connector(current, PROC_EVENT_GID);
 	return 0;
@@ -1343,23 +1392,31 @@ asmlinkage long sys_getresgid(gid_t __user *rgid, gid_t __user *egid, gid_t __us
  */
 asmlinkage long sys_setfsuid(uid_t uid)
 {
+	struct cred *cred;
 	int old_fsuid;
 
-	old_fsuid = current->fsuid;
+	old_fsuid = current->cred->uid;
 	if (security_task_setuid(uid, (uid_t)-1, (uid_t)-1, LSM_SETID_FS))
 		return old_fsuid;
 
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
+
 	if (uid == current->uid || uid == current->euid ||
-	    uid == current->suid || uid == current->fsuid || 
+	    uid == current->suid || uid == current->cred->uid ||
 	    capable(CAP_SETUID)) {
 		if (uid != old_fsuid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->fsuid = uid;
+		change_fsuid(cred, uid);
+		set_current_cred(cred);
+		key_fsuid_changed(current);
+	} else {
+		put_cred(cred);
 	}
 
-	key_fsuid_changed(current);
 	proc_id_connector(current, PROC_EVENT_UID);
 
 	security_task_post_setuid(old_fsuid, (uid_t)-1, (uid_t)-1, LSM_SETID_FS);
@@ -1372,22 +1429,30 @@ asmlinkage long sys_setfsuid(uid_t uid)
  */
 asmlinkage long sys_setfsgid(gid_t gid)
 {
+	struct cred *cred;
 	int old_fsgid;
 
-	old_fsgid = current->fsgid;
+	old_fsgid = current->cred->gid;
 	if (security_task_setgid(gid, (gid_t)-1, (gid_t)-1, LSM_SETID_FS))
 		return old_fsgid;
 
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
+
 	if (gid == current->gid || gid == current->egid ||
-	    gid == current->sgid || gid == current->fsgid || 
+	    gid == current->sgid || gid == current->cred->gid ||
 	    capable(CAP_SETGID)) {
 		if (gid != old_fsgid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->fsgid = gid;
+		change_fsgid(cred, gid);
+		set_current_cred(cred);
 		key_fsgid_changed(current);
 		proc_id_connector(current, PROC_EVENT_GID);
+	} else {
+		put_cred(cred);
 	}
 	return old_fsgid;
 }
@@ -1754,23 +1819,20 @@ int groups_search(struct group_info *group_info, gid_t grp)
 /* validate and set current->group_info */
 int set_current_groups(struct group_info *group_info)
 {
+	struct cred *cred;
 	int retval;
-	struct group_info *old_info;
 
 	retval = security_task_setgroups(group_info);
 	if (retval)
 		return retval;
 
-	groups_sort(group_info);
-	get_group_info(group_info);
-
-	task_lock(current);
-	old_info = current->group_info;
-	current->group_info = group_info;
-	task_unlock(current);
-
-	put_group_info(old_info);
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
 
+	groups_sort(group_info);
+	change_groups(cred, group_info);
+	set_current_cred(cred);
 	return 0;
 }
 
@@ -1778,24 +1840,24 @@ EXPORT_SYMBOL(set_current_groups);
 
 asmlinkage long sys_getgroups(int gidsetsize, gid_t __user *grouplist)
 {
+	struct group_info *group_info = current->cred->group_info;
 	int i = 0;
 
 	/*
-	 *	SMP: Nobody else can change our grouplist. Thus we are
-	 *	safe.
+	 *	SMP: Nobody else can change our credentials.  Thus we are safe.
 	 */
 
 	if (gidsetsize < 0)
 		return -EINVAL;
 
 	/* no need to grab task_lock here; it cannot change */
-	i = current->group_info->ngroups;
+	i = group_info->ngroups;
 	if (gidsetsize) {
 		if (i > gidsetsize) {
 			i = -EINVAL;
 			goto out;
 		}
-		if (groups_to_user(grouplist, current->group_info)) {
+		if (groups_to_user(grouplist, group_info)) {
 			i = -EFAULT;
 			goto out;
 		}
@@ -1839,9 +1901,11 @@ asmlinkage long sys_setgroups(int gidsetsize, gid_t __user *grouplist)
  */
 int in_group_p(gid_t grp)
 {
+	struct cred *cred = current->cred;
 	int retval = 1;
-	if (grp != current->fsgid)
-		retval = groups_search(current->group_info, grp);
+
+	if (grp != cred->gid)
+		retval = groups_search(cred->group_info, grp);
 	return retval;
 }
 
@@ -1851,7 +1915,7 @@ int in_egroup_p(gid_t grp)
 {
 	int retval = 1;
 	if (grp != current->egid)
-		retval = groups_search(current->group_info, grp);
+		retval = groups_search(current->cred->group_info, grp);
 	return retval;
 }
 
diff --git a/kernel/uid16.c b/kernel/uid16.c
index dd308ba..5a8b95e 100644
--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -161,25 +161,24 @@ static int groups16_from_user(struct group_info *group_info,
 
 asmlinkage long sys_getgroups16(int gidsetsize, old_gid_t __user *grouplist)
 {
+	struct group_info *group_info = current->cred->group_info;
 	int i = 0;
 
 	if (gidsetsize < 0)
 		return -EINVAL;
 
-	get_group_info(current->group_info);
-	i = current->group_info->ngroups;
+	i = group_info->ngroups;
 	if (gidsetsize) {
 		if (i > gidsetsize) {
 			i = -EINVAL;
 			goto out;
 		}
-		if (groups16_to_user(grouplist, current->group_info)) {
+		if (groups16_to_user(grouplist, group_info)) {
 			i = -EFAULT;
 			goto out;
 		}
 	}
 out:
-	put_group_info(current->group_info);
 	return i;
 }
 
diff --git a/mm/fadvise.c b/mm/fadvise.c
index 0df4c89..db3d602 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -35,6 +35,10 @@ asmlinkage long sys_fadvise64_64(int fd, loff_t offset, loff_t len, int advice)
 	unsigned long nrpages;
 	int ret = 0;
 
+	ret = update_current_cred();
+	if (ret < 0)
+		return ret;
+
 	if (!file)
 		return -EBADF;
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 90b657b..3257be2 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1235,6 +1235,10 @@ asmlinkage ssize_t sys_readahead(int fd, loff_t offset, size_t count)
 	ssize_t ret;
 	struct file *file;
 
+	ret = update_current_cred();
+	if (ret < 0)
+		return ret;
+
 	ret = -EBADF;
 	file = fget(fd);
 	if (file) {
diff --git a/mm/fremap.c b/mm/fremap.c
index c395b1a..a1a2088 100644
--- a/mm/fremap.c
+++ b/mm/fremap.c
@@ -122,9 +122,14 @@ asmlinkage long sys_remap_file_pages(unsigned long start, unsigned long size,
 	struct address_space *mapping;
 	unsigned long end = start + size;
 	struct vm_area_struct *vma;
-	int err = -EINVAL;
+	int err;
 	int has_write_lock = 0;
 
+	err = update_current_cred();
+	if (err < 0)
+		return err;
+
+	err = -EINVAL;
 	if (__prot)
 		return err;
 	/*
diff --git a/mm/madvise.c b/mm/madvise.c
index 93ee375..508a584 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -286,10 +286,15 @@ asmlinkage long sys_madvise(unsigned long start, size_t len_in, int behavior)
 	unsigned long end, tmp;
 	struct vm_area_struct * vma, *prev;
 	int unmapped_error = 0;
-	int error = -EINVAL;
+	int error;
 	int write;
 	size_t len;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
+	error = -EINVAL;
 	write = madvise_need_mmap_write(behavior);
 	if (write)
 		down_write(&current->mm->mmap_sem);
diff --git a/mm/msync.c b/mm/msync.c
index 144a757..f8c1b3b 100644
--- a/mm/msync.c
+++ b/mm/msync.c
@@ -34,8 +34,13 @@ asmlinkage long sys_msync(unsigned long start, size_t len, int flags)
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	int unmapped_error = 0;
-	int error = -EINVAL;
+	int error;
 
+	error = update_current_cred();
+	if (error < 0)
+		return error;
+
+	error = -EINVAL;
 	if (flags & ~(MS_ASYNC | MS_INVALIDATE | MS_SYNC))
 		goto out;
 	if (start & ~PAGE_MASK)
diff --git a/mm/shmem.c b/mm/shmem.c
index fcd19d3..40e835b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1394,8 +1394,6 @@ shmem_get_inode(struct super_block *sb, int mode, dev_t dev)
 	inode = new_inode(sb);
 	if (inode) {
 		inode->i_mode = mode;
-		inode->i_uid = current->fsuid;
-		inode->i_gid = current->fsgid;
 		inode->i_blocks = 0;
 		inode->i_mapping->a_ops = &shmem_aops;
 		inode->i_mapping->backing_dev_info = &shmem_backing_dev_info;
@@ -2212,8 +2210,8 @@ static int shmem_fill_super(struct super_block *sb,
 	struct inode *inode;
 	struct dentry *root;
 	int mode   = S_IRWXUGO | S_ISVTX;
-	uid_t uid = current->fsuid;
-	gid_t gid = current->fsgid;
+	uid_t uid = current->cred->uid;
+	gid_t gid = current->cred->gid;
 	int err = -ENOMEM;
 	struct shmem_sb_info *sbinfo;
 	unsigned long blocks = 0;
diff --git a/net/socket.c b/net/socket.c
index 7d44453..50bfeef 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -483,8 +483,6 @@ static struct socket *sock_alloc(void)
 	sock = SOCKET_I(inode);
 
 	inode->i_mode = S_IFSOCK | S_IRWXUGO;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
 
 	get_cpu_var(sockets_in_use)++;
 	put_cpu_var(sockets_in_use);
diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index 1ea2755..362a0de 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -267,7 +267,7 @@ rpcauth_cache_shrinker(int nr_to_scan, gfp_t gfp_mask)
  * Look up a process' credentials in the authentication cache
  */
 struct rpc_cred *
-rpcauth_lookup_credcache(struct rpc_auth *auth, struct auth_cred * acred,
+rpcauth_lookup_credcache(struct rpc_auth *auth, struct cred *acred,
 		int flags)
 {
 	LIST_HEAD(free);
@@ -336,23 +336,13 @@ out:
 struct rpc_cred *
 rpcauth_lookupcred(struct rpc_auth *auth, int flags)
 {
-	struct auth_cred acred = {
-		.uid = current->fsuid,
-		.gid = current->fsgid,
-		.group_info = current->group_info,
-	};
-	struct rpc_cred *ret;
-
 	dprintk("RPC:       looking up %s cred\n",
 		auth->au_ops->au_name);
-	get_group_info(acred.group_info);
-	ret = auth->au_ops->lookup_cred(auth, &acred, flags);
-	put_group_info(acred.group_info);
-	return ret;
+	return auth->au_ops->lookup_cred(auth, current->cred, flags);
 }
 
 void
-rpcauth_init_cred(struct rpc_cred *cred, const struct auth_cred *acred,
+rpcauth_init_cred(struct rpc_cred *cred, const struct cred *acred,
 		  struct rpc_auth *auth, const struct rpc_credops *ops)
 {
 	INIT_HLIST_NODE(&cred->cr_hash);
@@ -372,25 +362,18 @@ struct rpc_cred *
 rpcauth_bindcred(struct rpc_task *task)
 {
 	struct rpc_auth *auth = task->tk_client->cl_auth;
-	struct auth_cred acred = {
-		.uid = current->fsuid,
-		.gid = current->fsgid,
-		.group_info = current->group_info,
-	};
 	struct rpc_cred *ret;
 	int flags = 0;
 
 	dprintk("RPC: %5u looking up %s cred\n",
 		task->tk_pid, task->tk_client->cl_auth->au_ops->au_name);
-	get_group_info(acred.group_info);
 	if (task->tk_flags & RPC_TASK_ROOTCREDS)
 		flags |= RPCAUTH_LOOKUP_ROOTCREDS;
-	ret = auth->au_ops->lookup_cred(auth, &acred, flags);
+	ret = auth->au_ops->lookup_cred(auth, current->cred, flags);
 	if (!IS_ERR(ret))
 		task->tk_msg.rpc_cred = ret;
 	else
 		task->tk_status = PTR_ERR(ret);
-	put_group_info(acred.group_info);
 	return ret;
 }
 
diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index 53995af..bad2698 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -793,13 +793,13 @@ gss_destroy_cred(struct rpc_cred *cred)
  * Lookup RPCSEC_GSS cred for the current process
  */
 static struct rpc_cred *
-gss_lookup_cred(struct rpc_auth *auth, struct auth_cred *acred, int flags)
+gss_lookup_cred(struct rpc_auth *auth, struct cred *acred, int flags)
 {
 	return rpcauth_lookup_credcache(auth, acred, flags);
 }
 
 static struct rpc_cred *
-gss_create_cred(struct rpc_auth *auth, struct auth_cred *acred, int flags)
+gss_create_cred(struct rpc_auth *auth, struct cred *acred, int flags)
 {
 	struct gss_auth *gss_auth = container_of(auth, struct gss_auth, rpc_auth);
 	struct gss_cred	*cred = NULL;
@@ -840,7 +840,7 @@ gss_cred_init(struct rpc_auth *auth, struct rpc_cred *cred)
 }
 
 static int
-gss_match(struct auth_cred *acred, struct rpc_cred *rc, int flags)
+gss_match(struct cred *acred, struct rpc_cred *rc, int flags)
 {
 	struct gss_cred *gss_cred = container_of(rc, struct gss_cred, gc_base);
 
diff --git a/net/sunrpc/auth_null.c b/net/sunrpc/auth_null.c
index 537d0e8..c2fcefa 100644
--- a/net/sunrpc/auth_null.c
+++ b/net/sunrpc/auth_null.c
@@ -34,7 +34,7 @@ nul_destroy(struct rpc_auth *auth)
  * Lookup NULL creds for current process
  */
 static struct rpc_cred *
-nul_lookup_cred(struct rpc_auth *auth, struct auth_cred *acred, int flags)
+nul_lookup_cred(struct rpc_auth *auth, struct cred *acred, int flags)
 {
 	return get_rpccred(&null_cred);
 }
@@ -51,7 +51,7 @@ nul_destroy_cred(struct rpc_cred *cred)
  * Match cred handle against current process
  */
 static int
-nul_match(struct auth_cred *acred, struct rpc_cred *cred, int taskflags)
+nul_match(struct cred *acred, struct rpc_cred *cred, int taskflags)
 {
 	return 1;
 }
diff --git a/net/sunrpc/auth_unix.c b/net/sunrpc/auth_unix.c
index 5ed91e5..f5ab6d7 100644
--- a/net/sunrpc/auth_unix.c
+++ b/net/sunrpc/auth_unix.c
@@ -51,13 +51,13 @@ unx_destroy(struct rpc_auth *auth)
  * Lookup AUTH_UNIX creds for current process
  */
 static struct rpc_cred *
-unx_lookup_cred(struct rpc_auth *auth, struct auth_cred *acred, int flags)
+unx_lookup_cred(struct rpc_auth *auth, struct cred *acred, int flags)
 {
 	return rpcauth_lookup_credcache(auth, acred, flags);
 }
 
 static struct rpc_cred *
-unx_create_cred(struct rpc_auth *auth, struct auth_cred *acred, int flags)
+unx_create_cred(struct rpc_auth *auth, struct cred *acred, int flags)
 {
 	struct unx_cred	*cred;
 	int		i;
@@ -115,7 +115,7 @@ unx_destroy_cred(struct rpc_cred *cred)
  * request root creds (e.g. for NFS swapping).
  */
 static int
-unx_match(struct auth_cred *acred, struct rpc_cred *rcred, int flags)
+unx_match(struct cred *acred, struct rpc_cred *rcred, int flags)
 {
 	struct unx_cred	*cred = container_of(rcred, struct unx_cred, uc_base);
 	int		i;
diff --git a/security/dummy.c b/security/dummy.c
index 853ec22..62de89c 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -43,10 +43,12 @@ static int dummy_capget (struct task_struct *target, kernel_cap_t * effective,
 			*permitted |= (~0 & ~CAP_FS_MASK);
 			*effective |= (~0 & ~CAP_TO_MASK(CAP_SETPCAP) & ~CAP_FS_MASK);
 		}
-		if (target->fsuid == 0) {
+		rcu_read_lock();
+		if (task_cred(target)->uid == 0) {
 			*permitted |= CAP_FS_MASK;
 			*effective |= CAP_FS_MASK;
 		}
+		rcu_read_unlock();
 	}
 	return 0;
 }
@@ -138,8 +140,11 @@ static void dummy_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 		}
 	}
 
-	current->suid = current->euid = current->fsuid = bprm->e_uid;
-	current->sgid = current->egid = current->fsgid = bprm->e_gid;
+	current->suid = current->euid = bprm->e_uid;
+	current->sgid = current->egid = bprm->e_gid;
+
+	change_fsuid(bprm->cred, bprm->e_uid);
+	change_fsgid(bprm->cred, bprm->e_gid);
 
 	dummy_capget(current, &current->cap_effective, &current->cap_inheritable, &current->cap_permitted);
 }
@@ -572,7 +577,7 @@ static int dummy_task_prctl (int option, unsigned long arg2, unsigned long arg3,
 
 static void dummy_task_reparent_to_init (struct task_struct *p)
 {
-	p->euid = p->fsuid = 0;
+	p->euid = 0;
 	return;
 }
 
diff --git a/security/keys/compat.c b/security/keys/compat.c
index e10ec99..710f87a 100644
--- a/security/keys/compat.c
+++ b/security/keys/compat.c
@@ -25,6 +25,12 @@
 asmlinkage long compat_sys_keyctl(u32 option,
 				  u32 arg2, u32 arg3, u32 arg4, u32 arg5)
 {
+	int ret;
+
+	ret = update_current_cred();
+	if (ret < 0)
+		return ret;
+
 	switch (option) {
 	case KEYCTL_GET_KEYRING_ID:
 		return keyctl_get_keyring_ID(arg2, arg3);
diff --git a/security/keys/key.c b/security/keys/key.c
index 01bbc6d..a012e6c 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -817,7 +817,8 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 		perm |= KEY_USR_WRITE;
 
 	/* allocate a new key */
-	key = key_alloc(ktype, description, current->fsuid, current->fsgid,
+	key = key_alloc(ktype, description,
+			current->cred->uid, current->cred->gid,
 			current, perm, flags);
 	if (IS_ERR(key)) {
 		key_ref = ERR_PTR(PTR_ERR(key));
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index d9ca15c..2555c3b 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -67,6 +67,10 @@ asmlinkage long sys_add_key(const char __user *_type,
 	if (plen > 32767)
 		goto error;
 
+	ret = update_current_cred();
+	if (ret < 0)
+		goto error;
+
 	/* draw all the data into kernel space */
 	ret = key_get_type_from_user(type, _type, sizeof(type));
 	if (ret < 0)
@@ -143,6 +147,10 @@ asmlinkage long sys_request_key(const char __user *_type,
 	char type[32], *description, *callout_info;
 	long ret;
 
+	ret = update_current_cred();
+	if (ret < 0)
+		goto error;
+
 	/* pull the type into kernel space */
 	ret = key_get_type_from_user(type, _type, sizeof(type));
 	if (ret < 0)
@@ -794,7 +802,7 @@ long keyctl_setperm_key(key_serial_t id, key_perm_t perm)
 	down_write(&key->sem);
 
 	/* if we're not the sysadmin, we can only change a key that we own */
-	if (capable(CAP_SYS_ADMIN) || key->uid == current->fsuid) {
+	if (capable(CAP_SYS_ADMIN) || key->uid == current->cred->uid) {
 		key->perm = perm;
 		ret = 0;
 	}
@@ -1062,6 +1070,12 @@ error:
 asmlinkage long sys_keyctl(int option, unsigned long arg2, unsigned long arg3,
 			   unsigned long arg4, unsigned long arg5)
 {
+	int ret;
+
+	ret = update_current_cred();
+	if (ret < 0)
+		return ret;
+
 	switch (option) {
 	case KEYCTL_GET_KEYRING_ID:
 		return keyctl_get_keyring_ID((key_serial_t) arg2,
diff --git a/security/keys/permission.c b/security/keys/permission.c
index 3b41f9b..f0f0452 100644
--- a/security/keys/permission.c
+++ b/security/keys/permission.c
@@ -22,14 +22,19 @@ int key_task_permission(const key_ref_t key_ref,
 			struct task_struct *context,
 			key_perm_t perm)
 {
+	struct cred *cred;
 	struct key *key;
 	key_perm_t kperm;
 	int ret;
 
+	rcu_read_lock();
+	cred = get_task_cred(context);
+	rcu_read_unlock();
+
 	key = key_ref_to_ptr(key_ref);
 
 	/* use the second 8-bits of permissions for keys the caller owns */
-	if (key->uid == context->fsuid) {
+	if (key->uid == cred->uid) {
 		kperm = key->perm >> 16;
 		goto use_these_perms;
 	}
@@ -37,15 +42,12 @@ int key_task_permission(const key_ref_t key_ref,
 	/* use the third 8-bits of permissions for keys the caller has a group
 	 * membership in common with */
 	if (key->gid != -1 && key->perm & KEY_GRP_ALL) {
-		if (key->gid == context->fsgid) {
+		if (key->gid == cred->gid) {
 			kperm = key->perm >> 8;
 			goto use_these_perms;
 		}
 
-		task_lock(context);
-		ret = groups_search(context->group_info, key->gid);
-		task_unlock(context);
-
+		ret = groups_search(cred->group_info, key->gid);
 		if (ret) {
 			kperm = key->perm >> 8;
 			goto use_these_perms;
@@ -56,6 +58,8 @@ int key_task_permission(const key_ref_t key_ref,
 	kperm = key->perm;
 
 use_these_perms:
+	put_cred(cred);
+
 	/* use the top 8-bits of permissions for keys the caller possesses
 	 * - possessor permissions are additive with other permissions
 	 */
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index b6f8680..97c99d1 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -357,13 +357,14 @@ int suid_keys(struct task_struct *tsk)
 /*****************************************************************************/
 /*
  * the filesystem user ID changed
+ * - can only be used for current task
  */
 void key_fsuid_changed(struct task_struct *tsk)
 {
 	/* update the ownership of the thread keyring */
 	if (tsk->thread_keyring) {
 		down_write(&tsk->thread_keyring->sem);
-		tsk->thread_keyring->uid = tsk->fsuid;
+		tsk->thread_keyring->uid = tsk->cred->uid;
 		up_write(&tsk->thread_keyring->sem);
 	}
 
@@ -372,13 +373,14 @@ void key_fsuid_changed(struct task_struct *tsk)
 /*****************************************************************************/
 /*
  * the filesystem group ID changed
+ * - can only be used for current task
  */
 void key_fsgid_changed(struct task_struct *tsk)
 {
 	/* update the ownership of the thread keyring */
 	if (tsk->thread_keyring) {
 		down_write(&tsk->thread_keyring->sem);
-		tsk->thread_keyring->gid = tsk->fsgid;
+		tsk->thread_keyring->gid = tsk->cred->gid;
 		up_write(&tsk->thread_keyring->sem);
 	}
 
@@ -398,10 +400,13 @@ key_ref_t search_process_keyrings(struct key_type *type,
 				  struct task_struct *context)
 {
 	struct request_key_auth *rka;
+	struct cred *cred;
 	key_ref_t key_ref, ret, err;
 
 	might_sleep();
 
+	cred = get_current_cred();
+
 	/* we want to return -EAGAIN or -ENOKEY if any of the keyrings were
 	 * searchable, but we failed to find a key or we found a negative key;
 	 * otherwise we want to return a sample error (probably -EACCES) if
@@ -414,10 +419,9 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	err = ERR_PTR(-EAGAIN);
 
 	/* search the thread keyring first */
-	if (context->thread_keyring) {
-		key_ref = keyring_search_aux(
-			make_key_ref(context->thread_keyring, 1),
-			context, type, description, match);
+	if (cred->thread_keyring) {
+		key_ref = keyring_search_aux(cred->thread_keyring, context,
+					     type, description, match);
 		if (!IS_ERR(key_ref))
 			goto found;
 
@@ -435,10 +439,9 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	}
 
 	/* search the process keyring second */
-	if (context->signal->process_keyring) {
-		key_ref = keyring_search_aux(
-			make_key_ref(context->signal->process_keyring, 1),
-			context, type, description, match);
+	if (cred->process_keyring) {
+		key_ref = keyring_search_aux(cred->process_keyring, context,
+					     type, description, match);
 		if (!IS_ERR(key_ref))
 			goto found;
 
@@ -455,36 +458,10 @@ key_ref_t search_process_keyrings(struct key_type *type,
 		}
 	}
 
-	/* search the session keyring */
-	if (context->signal->session_keyring) {
-		rcu_read_lock();
-		key_ref = keyring_search_aux(
-			make_key_ref(rcu_dereference(
-					     context->signal->session_keyring),
-				     1),
-			context, type, description, match);
-		rcu_read_unlock();
-
-		if (!IS_ERR(key_ref))
-			goto found;
-
-		switch (PTR_ERR(key_ref)) {
-		case -EAGAIN: /* no key */
-			if (ret)
-				break;
-		case -ENOKEY: /* negative key */
-			ret = key_ref;
-			break;
-		default:
-			err = key_ref;
-			break;
-		}
-	}
-	/* or search the user-session keyring */
-	else {
-		key_ref = keyring_search_aux(
-			make_key_ref(context->user->session_keyring, 1),
-			context, type, description, match);
+	/* search the session or user-session keyring */
+	if (cred->session_keyring) {
+		key_ref = keyring_search_aux(cred->session_keyring, context,
+					     type, description, match);
 		if (!IS_ERR(key_ref))
 			goto found;
 
@@ -543,6 +520,7 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	key_ref = ret ? ret : err;
 
 found:
+	put_cred(cred);
 	return key_ref;
 
 } /* end search_process_keyrings() */
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 5575001..cf3a9da 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -49,8 +49,8 @@ static int call_sbin_request_key(struct key *key,
 	/* allocate a new session keyring */
 	sprintf(desc, "_req.%u", key->serial);
 
-	keyring = keyring_alloc(desc, current->fsuid, current->fsgid, current,
-				KEY_ALLOC_QUOTA_OVERRUN, NULL);
+	keyring = keyring_alloc(desc, current->cred->uid, current->cred->gid,
+				current, KEY_ALLOC_QUOTA_OVERRUN, NULL);
 	if (IS_ERR(keyring)) {
 		ret = PTR_ERR(keyring);
 		goto error_alloc;
@@ -62,8 +62,8 @@ static int call_sbin_request_key(struct key *key,
 		goto error_link;
 
 	/* record the UID and GID */
-	sprintf(uid_str, "%d", current->fsuid);
-	sprintf(gid_str, "%d", current->fsgid);
+	sprintf(uid_str, "%d", current->cred->uid);
+	sprintf(gid_str, "%d", current->cred->gid);
 
 	/* we say which key is under construction */
 	sprintf(key_str, "%d", key->serial);
@@ -142,8 +142,8 @@ static struct key *__request_key_construction(struct key_type *type,
 
 	/* create a key and add it to the queue */
 	key = key_alloc(type, description,
-			current->fsuid, current->fsgid, current, KEY_POS_ALL,
-			flags);
+			current->cred->uid, current->cred->gid, current,
+			KEY_POS_ALL, flags);
 	if (IS_ERR(key))
 		goto alloc_failed;
 
@@ -428,7 +428,7 @@ struct key *request_key_and_link(struct key_type *type,
 			goto error;
 
 		/* - get hold of the user's construction queue */
-		user = key_user_lookup(current->fsuid);
+		user = key_user_lookup(current->cred->uid);
 		if (!user)
 			goto nomem;
 
diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_auth.c
index cbf58a9..8644182 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -185,7 +185,7 @@ struct key *request_key_auth_new(struct key *target, const char *callout_info)
 	sprintf(desc, "%x", target->serial);
 
 	authkey = key_alloc(&key_type_request_key_auth, desc,
-			    current->fsuid, current->fsgid, current,
+			    current->cred->uid, current->cred->gid, current,
 			    KEY_POS_VIEW | KEY_POS_READ | KEY_POS_SEARCH |
 			    KEY_USR_VIEW, KEY_ALLOC_NOT_IN_QUOTA);
 	if (IS_ERR(authkey)) {

