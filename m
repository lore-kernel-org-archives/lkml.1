Return-Path: <linux-kernel-owner+w=401wt.eu-S934063AbXJRP6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934063AbXJRP6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765436AbXJRP43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:56:29 -0400
Received: from services.sin.cvut.cz ([147.32.110.2]:60461 "EHLO
	services.sin.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763519AbXJRP4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:56:17 -0400
From: Jaroslav Sykora <jara@sin.cvut.cz>
Reply-To: jaroslav.sykora@gmail.com
To: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/5] Shadow directories: core
Date: Thu, 18 Oct 2007 17:23:59 +0200
User-Agent: KMail/1.9.7
References: <200710181721.09201.jara@sin.cvut.cz>
In-Reply-To: <200710181721.09201.jara@sin.cvut.cz>
X-Face: >I|[{8s3:Ic!^A\YY'ktAfvq]K.-@B=!>(:.VX7_KNlZ@`l)vxL}2g~)k(#@=?utf-8?q?BN=24U+3MgB2=0A=097yR=5D=26tZ8PTc=3D=60?=<A%=5!.VCQ~(<-2#;/xmM4t6'MB7zDSm7i$nn/x^TC*adoyqd"{b0,=?utf-8?q?Hr=5F=0A=09?=<.yl<O}[Z[s.oX/:P917[b9QB%3f]{m=`7azOx[(.XW)"nW?N]jA5=%!<=?utf-8?q?=27ayW=5E!NQg6RcZ=0A=09vG?=@\&{XT%rV)u^hXq%ecRC;$jLBaa>ZZB_o
Cc: linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710181723.59193.jara@sin.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Implements two stage lookup with escape character filtering
and system calls for i386.
Changes lookup path, namely do_path_lookup. This function is split
into path_lookup_norm(), which performs standard name lookup,
and path_lookup_shdw(), which performs name lookup in an associated shadow directory.

Signed-off-by: Jaroslav Sykora <jaroslav.sykora@gmail.com>

 arch/i386/kernel/syscall_table.S |    6 
 fs/exec.c                        |    4 
 fs/file_table.c                  |   19 
 fs/namei.c                       |  610 ++++++++++++++++++++++++++++-
 fs/namespace.c                   |   13 
 include/linux/syscalls.h         |    6 
 kernel/exit.c                    |    8 
 kernel/fork.c                    |   20 
 8 files changed, 672 insertions(+), 14 deletions(-)

--- orig/fs/namei.c	2007-10-07 19:00:19.000000000 +0200
+++ new/fs/namei.c	2007-10-18 15:35:54.000000000 +0200
@@ -31,6 +31,7 @@
 #include <linux/file.h>
 #include <linux/fcntl.h>
 #include <linux/namei.h>
+#include <linux/ptrace.h>
 #include <asm/namei.h>
 #include <asm/uaccess.h>
 
@@ -515,6 +516,25 @@ static struct dentry * real_lookup(struc
 	return result;
 }
 
+static inline int use_shadow(struct fs_struct *fs, struct nameidata *nd)
+{
+	/* assert: fs->lock held */
+	return (fs->flags & SHDW_ENABLED) && (nd->flags & LOOKUP_INSHDW);
+}
+
+static inline struct dentry *fs_root(struct fs_struct *fs, struct nameidata *nd)
+{
+	/* assert: current->fs->lock held */
+	return (use_shadow(fs, nd)) ? fs->shdwroot : fs->root;
+}
+
+static inline struct vfsmount *fs_rootmnt(struct fs_struct *fs,
+			struct nameidata *nd)
+{
+	/* assert: current->fs->lock held */
+	return (use_shadow(fs, nd)) ? fs->shdwrootmnt : fs->rootmnt;
+}
+
 static int __emul_lookup_dentry(const char *, struct nameidata *);
 
 /* SMP-safe */
@@ -532,8 +552,8 @@ walk_init_root(const char *name, struct 
 			return 0;
 		read_lock(&fs->lock);
 	}
-	nd->mnt = mntget(fs->rootmnt);
-	nd->dentry = dget(fs->root);
+	nd->mnt = mntget(fs_rootmnt(fs, nd));
+	nd->dentry = dget(fs_root(fs, nd));
 	read_unlock(&fs->lock);
 	return 1;
 }
@@ -730,9 +750,9 @@ static __always_inline void follow_dotdo
 		struct vfsmount *parent;
 		struct dentry *old = nd->dentry;
 
-                read_lock(&fs->lock);
-		if (nd->dentry == fs->root &&
-		    nd->mnt == fs->rootmnt) {
+		read_lock(&fs->lock);
+		if (nd->dentry == fs_root(fs, nd) &&
+		    nd->mnt == fs_rootmnt(fs, nd)) {
                         read_unlock(&fs->lock);
 			break;
 		}
@@ -842,6 +862,11 @@ static fastcall int __link_path_walk(con
 
 		hash = init_name_hash();
 		do {
+			if (unlikely((nd->flags & LOOKUP_FINDCHAR) &&
+					(c == nd->find_char))) {
+				/* shadow control char found */
+				nd->flags |= LOOKUP_CHARFOUND;
+			}
 			name++;
 			hash = partial_name_hash(c, hash);
 			c = *(const unsigned char *)name;
@@ -1100,8 +1125,8 @@ set_it:
 	}
 }
 
-/* Returns 0 and nd will be valid on success; Retuns error, otherwise. */
-static int fastcall do_path_lookup(int dfd, const char *name,
+/* Lookup @name, starting at @dfd, use normal (non-shadow) root and pwd */
+static int fastcall path_lookup_norm(int dfd, const char *name,
 				unsigned int flags, struct nameidata *nd)
 {
 	int retval = 0;
@@ -1168,6 +1193,313 @@ fput_fail:
 	goto out_fail;
 }
 
+/*
+ * Set @filp->f_shdw, @filp->f_shdwmnt to @mnt,@dentry.
+ * Takes @filp->f_owner->lock.
+ * Note: if @dentry == NULL then @mnt may be ERR_PTR(-EINVAL).
+ */
+static void set_fileshdw(struct file *filp, struct vfsmount *mnt,
+			struct dentry *dentry)
+{
+	struct dentry *old_dentry;
+	struct vfsmount *old_mnt;
+
+	BUG_ON(dentry != NULL && mnt == NULL);
+	write_lock(&filp->f_owner.lock);
+	old_dentry = filp->f_shdw;
+	old_mnt = filp->f_shdwmnt;
+	filp->f_shdw = dget(dentry);
+	if (dentry)
+		filp->f_shdwmnt = mntget(mnt);
+	else
+		/* mnt is ERR_PTR */
+		filp->f_shdwmnt = mnt;
+	write_unlock(&filp->f_owner.lock);
+
+	if (old_dentry) {
+		dput(old_dentry);
+		mntput(old_mnt);
+	}
+}
+
+/*
+ * Determine @filp->f_shdw,f_shdwmnt from @filp->dentry,mnt
+ * and current->fs->shdwroot.
+ * Also check whether it's a directory and we have permisson.
+ * Called only from get_file_shdwdir().
+ */
+static int validate_shdwfile(struct file *filp)
+{
+	struct nameidata nd;
+	char *buf, *name;
+	int res = -ENOMEM;
+
+	buf = (char *)__get_free_page(GFP_KERNEL);
+	if (!buf)
+		goto fail;
+
+	/* doesn't need a lock for reading f_dentry, f_vfsmnt */
+	name = d_path(filp->f_dentry, filp->f_vfsmnt, buf, PAGE_SIZE);
+	res = PTR_ERR(name);
+	if (IS_ERR(name))
+		goto fail_free;
+
+	BUG_ON(*name != '/');
+	res = path_lookup_shdw(AT_FDCWD, name,
+				LOOKUP_FOLLOW|LOOKUP_DIRECTORY, &nd);
+	if (res)
+		goto fail_free;
+
+	res = permission(nd.dentry->d_inode, MAY_EXEC, NULL);
+	if (res)
+		goto fail_put;
+
+	/* ok -> valid */
+	set_fileshdw(filp, nd.mnt, nd.dentry);
+	path_release(&nd);
+	free_page((unsigned long)buf);
+out:
+	/* current->fs->lock is not held on exit */
+	return res;
+
+fail_put:
+	path_release(&nd);
+fail_free:
+	free_page((unsigned long)buf);
+fail:
+	/* error -> invalid */
+	set_fileshdw(filp, ERR_PTR(-EINVAL), NULL);
+	goto out;
+}
+
+/*
+ * Set *@dentry,*@mnt to @file->f_shdw,f_shdwmnt, try to validate
+ * them if needed.
+ */
+int get_file_shdwdir(struct file *file, struct dentry **dentry,
+		    struct vfsmount **mnt)
+{
+	int retval = -ENOENT;
+
+	read_lock(&file->f_owner.lock);
+	while (!file->f_shdw) {
+		if (!file->f_shdwmnt) {
+			/* delayed, try to validate */
+			read_unlock(&file->f_owner.lock);
+			if (validate_shdwfile(file))
+				goto out;
+			/* ok but continue loop to avoid races */
+			read_lock(&file->f_owner.lock);
+		} else
+			/* invalid */
+			goto out_unlock;
+		/* continue loop to avoid races */
+	}
+	/* get the shadow dir */
+	*dentry = dget(file->f_shdw);
+	*mnt = mntget(file->f_shdwmnt);
+	retval = 0;
+out_unlock:
+	read_unlock(&file->f_owner.lock);
+out:
+	return retval;
+}
+
+/*
+ * Determine current->fs->shdwpwd,shdwpwdmnt from current->fs->pwd,pwdmnt.
+ * Also check whether it's a directory and we have permisson.
+ */
+static int validate_shdwpwd(void)
+{
+	/* called with current->fs->lock held */
+	struct dentry *pwd = dget(current->fs->pwd);
+	struct vfsmount *mnt = mntget(current->fs->pwdmnt);
+	struct nameidata nd;
+	char *buf, *name;
+	int res = -ENOMEM;
+
+	read_unlock(&current->fs->lock);
+	buf = (char *)__get_free_page(GFP_KERNEL);
+	if (!buf)
+		goto fail;
+
+	name = d_path(pwd, mnt, buf, PAGE_SIZE);
+	res = PTR_ERR(name);
+	if (IS_ERR(name))
+		goto fail_free;
+
+	BUG_ON(*name != '/');
+	/* won't recurse here because @name starts with '/' */
+	res = path_lookup_shdw(AT_FDCWD, name,
+				LOOKUP_FOLLOW|LOOKUP_DIRECTORY, &nd);
+	if (res)
+		goto fail_free;
+
+	res = permission(nd.dentry->d_inode, MAY_EXEC, NULL);
+	if (res)
+		goto fail_put;
+
+	/* ok -> valid */
+	set_fs_shdwpwd(current->fs, nd.mnt, nd.dentry);
+	path_release(&nd);
+	free_page((unsigned long)buf);
+out:
+	dput(pwd);
+	mntput(mnt);
+	/* current->fs->lock is NOT held on exit */
+	return res;
+
+fail_put:
+	path_release(&nd);
+fail_free:
+	free_page((unsigned long)buf);
+fail:
+	/* error -> invalidate */
+	set_fs_shdwpwd(current->fs, ERR_PTR(-EINVAL), NULL);
+	goto out;
+}
+
+/*
+ * Set *@dentry,*@mnt to current->fs->shdwpwd,shdwpwdmnt, try to validate
+ * them if needed.
+ */
+static int get_shdwpwd(struct dentry **dentry, struct vfsmount **mnt)
+{
+	int retval = -ENOENT;
+	/* assert: current->fs->lock is held */
+	while (!current->fs->shdwpwd) {
+		if (current->fs->shdwpwdmnt)
+			/* ERR_PTR - invalid */
+			goto out_unlock;
+
+		/* it's delayed -> validate */
+		if (validate_shdwpwd())
+			/* (current->fs->lock is unlocked
+			 * in validate_shdwpwd()) */
+			goto out;
+
+		read_lock(&current->fs->lock);
+		/* continue loop to avoid races */
+	}
+
+	*mnt = mntget(current->fs->shdwpwdmnt);
+	*dentry = dget(current->fs->shdwpwd);
+	retval = 0;
+out_unlock:
+	read_unlock(&current->fs->lock);
+out:
+	/* current->fs->lock is NOT held on exit */
+	return retval;
+}
+
+/*
+ * Lookup @name, starting at @dfd, use shadow root and pwd.
+ * Try to validate current->fs->shdwpwd/filp->f_shdwmnt if needed.
+ */
+int fastcall path_lookup_shdw(int dfd, const char *name,
+			unsigned int flags, struct nameidata *nd)
+{
+	int retval = -ENOENT;
+
+	nd->last_type = LAST_ROOT; /* if there are only slashes... */
+	nd->flags = flags | LOOKUP_INSHDW | LOOKUP_NOALT;
+	nd->depth = 0;
+
+	read_lock(&current->fs->lock);
+	if (!(current->fs->flags & SHDW_ENABLED))
+		goto unlock_fail;
+
+	if (*name == '/') {
+		/* start at the shadow root */
+		if (!current->fs->shdwroot)
+			goto unlock_fail;
+		nd->mnt = mntget(current->fs->shdwrootmnt);
+		nd->dentry = dget(current->fs->shdwroot);
+		read_unlock(&current->fs->lock);
+	} else if (dfd == AT_FDCWD) {
+		/* start at the shadow pwd */
+		retval = get_shdwpwd(&nd->dentry, &nd->mnt);
+		/* current->fs->lock is not held here */
+		if (retval)
+			goto out_fail;
+	} else {
+		int fput_needed;
+		struct file *file;
+
+		read_unlock(&current->fs->lock);
+		/* start at file's shadow dir */
+		file = fget_light(dfd, &fput_needed);
+		retval = -EBADF;
+		if (!file)
+			goto out_fail;
+
+		retval = get_file_shdwdir(file, &nd->dentry, &nd->mnt);
+		fput_light(file, fput_needed);
+
+		if (retval)
+			goto out_fail;
+	}
+
+	current->total_link_count = 0;
+	retval = link_path_walk(name, nd);
+
+	if (likely(retval == 0)) {
+		if (unlikely(!audit_dummy_context() && nd && nd->dentry &&
+				nd->dentry->d_inode))
+			audit_inode(name, nd->dentry->d_inode);
+	}
+
+out_fail:
+	return retval;
+
+unlock_fail:
+	read_unlock(&current->fs->lock);
+	goto out_fail;
+}
+
+/*
+ * Perform full lookup of @name starting at @dfd.
+ * 1. do a normal lookup
+ * 2. if it fails try to lookup in shadow dir
+ * Returns 0 and nd will be valid on success; Retuns error, otherwise.
+ */
+static int fastcall do_path_lookup(int dfd, const char *name,
+				unsigned int flags, struct nameidata *nd)
+{
+	int retval;
+
+	if (!(flags & LOOKUP_NOSHDW)) {
+		/* shadow dir isn't disabled in the current lookup session */
+		read_lock(&current->fs->lock);
+		if (current->fs->flags & SHDW_ENABLED) {
+			/* shadow is enabled */
+			if (current->fs->flags & SHDW_USE_ESC) {
+				flags |= LOOKUP_FINDCHAR;
+				nd->find_char = current->fs->shdw_escch;
+			}
+		} else
+			/* shadow is disabled - disable it in lookup session */
+			flags |= LOOKUP_NOSHDW;
+		read_unlock(&current->fs->lock);
+	}
+
+	retval = path_lookup_norm(dfd, name, flags, nd);
+
+	/*
+	 * Do another lookup in the shadow dir iff:
+	 *    normal lookup failed
+	 * && shadow is enabled
+	 * && the last lookup was not already going within shadows
+	 * && user asked for the escape character and we found it
+	 */
+	if (unlikely(retval && !(nd->flags & (LOOKUP_NOSHDW|LOOKUP_INSHDW))
+	    && !((nd->flags & LOOKUP_FINDCHAR)
+	    && !(nd->flags & LOOKUP_CHARFOUND))))
+		retval = path_lookup_shdw(dfd, name, flags, nd);
+
+	return retval;
+}
+
 int fastcall path_lookup(const char *name, unsigned int flags,
 			struct nameidata *nd)
 {
@@ -1225,6 +1557,16 @@ static int __path_lookup_intent_open(int
 		}
 	} else if (err != 0)
 		release_open_intent(nd);
+	else if (!(nd->flags & LOOKUP_NOSHDW) &&
+			S_ISDIR(nd->dentry->d_inode->i_mode)) {
+		/* setup file's shadow dir */
+		/* default: filp->f_shdw = filp->f_shdwmnt = NULL */
+		if (nd->flags & LOOKUP_INSHDW) {
+			filp->f_shdw = dget(nd->dentry);
+			filp->f_shdwmnt = mntget(nd->mnt);
+		}
+	}
+
 	return err;
 }
 
@@ -2792,6 +3134,260 @@ const struct inode_operations page_symli
 	.put_link	= page_put_link,
 };
 
+
+/*
+ * Find task by @pid, check permissions.
+ * @pid == 0 -> current.
+ */
+static struct task_struct *tsk_by_pid(pid_t pid)
+{
+	struct task_struct *tsk = current;
+
+	if (pid) {
+		read_lock(&tasklist_lock);
+		tsk = find_task_by_pid(pid);
+		if (tsk)
+			get_task_struct(tsk);
+		read_unlock(&tasklist_lock);
+		if (!tsk)
+			tsk = ERR_PTR(-ESRCH);
+		else if (!ptrace_may_attach(tsk)) {
+			put_task_struct(tsk);
+			tsk = ERR_PTR(-EPERM);
+		}
+	}
+	return tsk;
+}
+
+asmlinkage long sys_getshdwinfo(pid_t pid, int func, int __user *data)
+{
+	struct task_struct *tsk = tsk_by_pid(pid);
+	long ret = PTR_ERR(tsk);
+
+	if (IS_ERR(tsk))
+		goto out_noput;
+	ret = -EINVAL;
+
+	switch (func) {
+	case FSI_SHDW_ENABLE:
+		read_lock(&tsk->fs->lock);
+		ret = (tsk->fs->flags & SHDW_ENABLED) ? 1 : 0;
+		read_unlock(&tsk->fs->lock);
+		ret = put_user(ret, data);
+		break;
+
+	case FSI_SHDW_ESC_EN:
+		read_lock(&tsk->fs->lock);
+		ret = (tsk->fs->flags & SHDW_USE_ESC) ? 1 : 0;
+		read_unlock(&tsk->fs->lock);
+		ret = put_user(ret, data);
+		break;
+
+	case FSI_SHDW_ESC_CHAR:
+		read_lock(&tsk->fs->lock);
+		ret = tsk->fs->shdw_escch;
+		read_unlock(&tsk->fs->lock);
+		ret = put_user((char)ret, (char __user *)data);
+		break;
+	}
+
+	if (pid)
+		put_task_struct(tsk);
+out_noput:
+	/* avoid REGPARM breakage on x86: */
+	prevent_tail_call(ret);
+	return ret;
+}
+
+/*
+ * Set fs->shdwpwd,shdwpwdmnt according to @pathname.
+ * @pathname is NOT looked up in shadow dir.
+ */
+static int do_setshdwpwd(struct fs_struct *fs, const char __user *pathname)
+{
+	struct nameidata nd;
+	int error = __user_walk(pathname,
+			LOOKUP_FOLLOW|LOOKUP_DIRECTORY|LOOKUP_NOSHDW, &nd);
+	if (error)
+		goto out;
+
+	error = vfs_permission(&nd, MAY_EXEC);
+	if (error)
+		goto dput_and_out;
+
+	set_fs_shdwpwd(fs, nd.mnt, nd.dentry);
+
+dput_and_out:
+	path_release(&nd);
+out:
+	return error;
+}
+
+/*
+ * Set fs->shdwroot,shdwrootmnt according to @pathname.
+ * @pathname is NOT looked up in shadow dir.
+ * If @pathname == NULL then disable shadow dir.
+ */
+static int do_setshdwroot(struct fs_struct *fs, const char __user *pathname)
+{
+	struct dentry *old_dentry;
+	struct vfsmount *old_mnt;
+	struct nameidata nd;
+	int error = 0;
+
+	if (pathname) {
+		error = __user_walk(pathname,
+			LOOKUP_FOLLOW|LOOKUP_DIRECTORY|LOOKUP_NOSHDW, &nd);
+		if (error)
+			goto out;
+
+		error = vfs_permission(&nd, MAY_EXEC);
+		if (error)
+			goto dput_and_out;
+	} else {
+		/* remove shadow root */
+		nd.dentry = NULL;
+		nd.mnt = NULL;
+	}
+
+	write_lock(&fs->lock);
+	old_dentry = fs->shdwroot;
+	old_mnt = fs->shdwrootmnt;
+	fs->shdwroot = dget(nd.dentry);
+	fs->shdwrootmnt = mntget(nd.mnt);
+	if (!nd.dentry)
+		/* disable shadow dir */
+		fs->flags &= ~SHDW_ENABLED;
+	write_unlock(&fs->lock);
+
+	dput(old_dentry);
+	mntput(old_mnt);
+
+dput_and_out:
+	path_release(&nd);
+out:
+	return error;
+}
+
+/*
+ * Set file->f_shdw,f_shdwmnt according to @pathname.
+ * @pathname is NOT looked up in shadow dir.
+ * If @pathname == NULL then set file->f_shdw,f_shdwmnt as delayed.
+ */
+static int do_setshdwfd(struct task_struct *tsk, int fd,
+			const char __user *pathname)
+{
+	struct nameidata nd;
+	struct file *filp = __fget(tsk->files, fd);
+	int error = 0;
+
+	if (!filp)
+		return -EBADF;
+
+	if (pathname) {
+		error = __user_walk(pathname,
+			LOOKUP_FOLLOW|LOOKUP_DIRECTORY|LOOKUP_NOSHDW, &nd);
+		if (error)
+			goto out;
+
+		error = vfs_permission(&nd, MAY_EXEC);
+		if (!error) {
+			set_fileshdw(filp, nd.mnt, nd.dentry);
+			path_release(&nd);
+		}
+	} else {
+		/* set delayed */
+		set_fileshdw(filp, NULL, NULL);
+	}
+out:
+	fput(filp);
+	return error;
+}
+
+asmlinkage long sys_setshdwpath(pid_t pid, int fd, const char __user *path)
+{
+	struct task_struct *tsk = tsk_by_pid(pid);
+	long ret = PTR_ERR(tsk);
+
+	if (IS_ERR(tsk))
+		goto out_noput;
+
+	ret = -EINVAL;
+
+	if (fd >= 0)
+		/* a normal file's shadow */
+		ret = do_setshdwfd(tsk, fd, path);
+	else if (fd == SHDW_FD_ROOT)
+		/* root shadow */
+		ret = do_setshdwroot(tsk->fs, path);
+	else if (fd == SHDW_FD_PWD) {
+		/* pwd shadow */
+		if (path)
+			ret = do_setshdwpwd(tsk->fs, path);
+		else {
+			/* set delayed */
+			set_fs_shdwpwd(tsk->fs, NULL, NULL);
+			ret = 0;
+		}
+	}
+
+	if (pid)
+		put_task_struct(tsk);
+out_noput:
+	/* avoid REGPARM breakage on x86: */
+	prevent_tail_call(ret);
+	return ret;
+}
+
+asmlinkage long sys_setshdwinfo(pid_t pid, int func, int data)
+{
+	struct task_struct *tsk = tsk_by_pid(pid);
+	long ret = PTR_ERR(tsk);
+
+	if (IS_ERR(tsk))
+		goto out_noput;
+
+	ret = -EINVAL;
+	switch (func) {
+	case FSI_SHDW_ENABLE:
+		ret = 0;
+		write_lock(&tsk->fs->lock);
+		tsk->fs->flags &= ~SHDW_ENABLED;
+		if (data) {
+			/* may enable shadow? */
+			if (tsk->fs->shdwroot && tsk->fs->shdwrootmnt)
+				tsk->fs->flags |= SHDW_ENABLED;
+			else
+				ret = -EPERM;
+		}
+		write_unlock(&tsk->fs->lock);
+		break;
+
+	case FSI_SHDW_ESC_EN:
+		ret = 0;
+		write_lock(&tsk->fs->lock);
+		tsk->fs->flags &= ~SHDW_USE_ESC;
+		if (data)
+			tsk->fs->flags |= SHDW_USE_ESC;
+		write_unlock(&tsk->fs->lock);
+		break;
+
+	case FSI_SHDW_ESC_CHAR:
+		ret = 0;
+		write_lock(&tsk->fs->lock);
+		tsk->fs->shdw_escch = (unsigned char)data;
+		write_unlock(&tsk->fs->lock);
+		break;
+	}
+
+	if (pid)
+		put_task_struct(tsk);
+out_noput:
+	/* avoid REGPARM breakage on x86: */
+	prevent_tail_call(ret);
+	return ret;
+}
+
 EXPORT_SYMBOL(__user_walk);
 EXPORT_SYMBOL(__user_walk_fd);
 EXPORT_SYMBOL(follow_down);
--- orig/fs/exec.c	2007-10-07 19:00:18.000000000 +0200
+++ new/fs/exec.c	2007-10-07 19:53:16.000000000 +0200
@@ -1076,11 +1076,15 @@ int flush_old_exec(struct linux_binprm *
 	if (bprm->e_uid != current->euid || bprm->e_gid != current->egid) {
 		suid_keys(current);
 		set_dumpable(current->mm, suid_dumpable);
+		/* switch off the shadow directories for a suid exec */
+		current->fs->flags &= ~SHDW_ENABLED;
 		current->pdeath_signal = 0;
 	} else if (file_permission(bprm->file, MAY_READ) ||
 			(bprm->interp_flags & BINPRM_FLAGS_ENFORCE_NONDUMP)) {
 		suid_keys(current);
 		set_dumpable(current->mm, suid_dumpable);
+		/* switch off the shadow directories for a suid exec */
+		current->fs->flags &= ~SHDW_ENABLED;
 	}
 
 	/* An exec changes our domain. We are no longer part of the thread
--- orig/fs/namespace.c	2007-10-07 19:00:19.000000000 +0200
+++ new/fs/namespace.c	2007-10-07 13:39:08.000000000 +0200
@@ -1448,6 +1448,7 @@ static struct mnt_namespace *dup_mnt_ns(
 {
 	struct mnt_namespace *new_ns;
 	struct vfsmount *rootmnt = NULL, *pwdmnt = NULL, *altrootmnt = NULL;
+	struct vfsmount *shdwrootmnt = NULL, *shdwpwdmnt = NULL;
 	struct vfsmount *p, *q;
 
 	new_ns = kmalloc(sizeof(struct mnt_namespace), GFP_KERNEL);
@@ -1494,6 +1495,14 @@ static struct mnt_namespace *dup_mnt_ns(
 				altrootmnt = p;
 				fs->altrootmnt = mntget(q);
 			}
+			if (p == fs->shdwrootmnt) {
+				shdwrootmnt = p;
+				fs->shdwrootmnt = mntget(q);
+			}
+			if (p == fs->shdwpwdmnt) {
+				shdwpwdmnt = p;
+				fs->shdwpwdmnt = mntget(q);
+			}
 		}
 		p = next_mnt(p, mnt_ns->root);
 		q = next_mnt(q, new_ns->root);
@@ -1506,6 +1515,10 @@ static struct mnt_namespace *dup_mnt_ns(
 		mntput(pwdmnt);
 	if (altrootmnt)
 		mntput(altrootmnt);
+	if (shdwrootmnt)
+		mntput(shdwrootmnt);
+	if (shdwpwdmnt)
+		mntput(shdwpwdmnt);
 
 	return new_ns;
 }
--- orig/fs/file_table.c	2007-07-09 01:32:17.000000000 +0200
+++ new/fs/file_table.c	2007-10-07 13:39:08.000000000 +0200
@@ -151,8 +151,8 @@ EXPORT_SYMBOL(fput);
  */
 void fastcall __fput(struct file *file)
 {
-	struct dentry *dentry = file->f_path.dentry;
-	struct vfsmount *mnt = file->f_path.mnt;
+	struct dentry *dentry = file->f_path.dentry, *s_dentry = file->f_shdw;
+	struct vfsmount *mnt = file->f_path.mnt, *s_mnt = file->f_shdwmnt;
 	struct inode *inode = dentry->d_inode;
 
 	might_sleep();
@@ -177,15 +177,21 @@ void fastcall __fput(struct file *file)
 	file_kill(file);
 	file->f_path.dentry = NULL;
 	file->f_path.mnt = NULL;
+	file->f_shdw = NULL;
+	file->f_shdwmnt = NULL;
 	file_free(file);
 	dput(dentry);
 	mntput(mnt);
+	if (s_dentry) {
+		/* NOTE: if s_dentry == NULL then s_mnt may be ERR_PTR */
+		dput(s_dentry);
+		mntput(s_mnt);
+	}
 }
 
-struct file fastcall *fget(unsigned int fd)
+struct file fastcall *__fget(struct files_struct *files, unsigned int fd)
 {
 	struct file *file;
-	struct files_struct *files = current->files;
 
 	rcu_read_lock();
 	file = fcheck_files(files, fd);
@@ -201,6 +207,11 @@ struct file fastcall *fget(unsigned int 
 	return file;
 }
 
+struct file fastcall *fget(unsigned int fd)
+{
+	return __fget(current->files, fd);
+}
+
 EXPORT_SYMBOL(fget);
 
 /*
--- orig/kernel/exit.c	2007-10-07 19:00:26.000000000 +0200
+++ new/kernel/exit.c	2007-10-07 13:39:08.000000000 +0200
@@ -522,6 +522,14 @@ static inline void __put_fs_struct(struc
 			dput(fs->altroot);
 			mntput(fs->altrootmnt);
 		}
+		if (fs->shdwroot) {
+			dput(fs->shdwroot);
+			mntput(fs->shdwrootmnt);
+		}
+		if (fs->shdwpwd) {
+			dput(fs->shdwpwd);
+			mntput(fs->shdwpwdmnt);
+		}
 		kmem_cache_free(fs_cachep, fs);
 	}
 }
--- orig/kernel/fork.c	2007-10-07 19:00:26.000000000 +0200
+++ new/kernel/fork.c	2007-10-07 13:39:08.000000000 +0200
@@ -586,6 +586,9 @@ static inline struct fs_struct *__copy_f
 		fs->root = dget(old->root);
 		fs->pwdmnt = mntget(old->pwdmnt);
 		fs->pwd = dget(old->pwd);
+		fs->flags = old->flags;
+		fs->shdw_escch = old->shdw_escch;
+
 		if (old->altroot) {
 			fs->altrootmnt = mntget(old->altrootmnt);
 			fs->altroot = dget(old->altroot);
@@ -593,6 +596,23 @@ static inline struct fs_struct *__copy_f
 			fs->altrootmnt = NULL;
 			fs->altroot = NULL;
 		}
+
+		if (old->shdwroot) {
+			fs->shdwrootmnt = mntget(old->shdwrootmnt);
+			fs->shdwroot = dget(old->shdwroot);
+		} else {
+			fs->shdwrootmnt = NULL;
+			fs->shdwroot = NULL;
+		}
+
+		if (old->shdwpwd) {
+			fs->shdwpwdmnt = mntget(old->shdwpwdmnt);
+			fs->shdwpwd = dget(old->shdwpwd);
+		} else {
+			fs->shdwpwdmnt = NULL;
+			fs->shdwpwd = NULL;
+		}
+
 		read_unlock(&old->lock);
 	}
 	return fs;
--- orig/include/linux/syscalls.h	2007-10-07 19:00:26.000000000 +0200
+++ new/include/linux/syscalls.h	2007-10-07 13:39:08.000000000 +0200
@@ -614,4 +614,10 @@ asmlinkage long sys_fallocate(int fd, in
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
+asmlinkage long sys_getshdwinfo(pid_t pid, int func, int __user *data);
+
+asmlinkage long sys_setshdwinfo(pid_t pid, int func, int data);
+
+asmlinkage long sys_setshdwpath(pid_t pid, int fd, const char __user *path);
+
 #endif
--- orig/arch/i386/kernel/syscall_table.S	2007-10-07 18:59:54.000000000 +0200
+++ new/arch/i386/kernel/syscall_table.S	2007-10-07 20:40:40.000000000 +0200
@@ -222,7 +222,7 @@ ENTRY(sys_call_table)
 	.long sys_getdents64	/* 220 */
 	.long sys_fcntl64
 	.long sys_ni_syscall	/* reserved for TUX */
-	.long sys_ni_syscall
+	.long sys_getshdwinfo
 	.long sys_gettid
 	.long sys_readahead	/* 225 */
 	.long sys_setxattr
@@ -250,7 +250,7 @@ ENTRY(sys_call_table)
 	.long sys_io_submit
 	.long sys_io_cancel
 	.long sys_fadvise64	/* 250 */
-	.long sys_ni_syscall
+	.long sys_setshdwinfo
 	.long sys_exit_group
 	.long sys_lookup_dcookie
 	.long sys_epoll_create
@@ -284,7 +284,7 @@ ENTRY(sys_call_table)
 	.long sys_mq_getsetattr
 	.long sys_kexec_load
 	.long sys_waitid
-	.long sys_ni_syscall		/* 285 */ /* available */
+	.long sys_setshdwpath		/* 285 */
 	.long sys_add_key
 	.long sys_request_key
 	.long sys_keyctl
