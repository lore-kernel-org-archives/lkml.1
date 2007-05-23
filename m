Return-Path: <linux-kernel-owner+w=401wt.eu-S1764356AbXEWNrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764356AbXEWNrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 09:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760362AbXEWNq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 09:46:56 -0400
Received: from service1.sh.cvut.cz ([147.32.127.214]:49630 "EHLO
	service1.sh.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760308AbXEWNqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 09:46:53 -0400
X-Greylist: delayed 1570 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 May 2007 09:46:52 EDT
X-Spam-Score: -2.335
From: Jaroslav Sykora <jaroslav.sykora@sh.cvut.cz>
Reply-To: jaroslav.sykora@gmail.com
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC PATCH] file as directory
Date: Wed, 23 May 2007 15:20:26 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       torvalds@linux-foundation.org
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu>
X-Face: >I|[{8s3:Ic!^A\YY'ktAfvq]K.-@B=!>(:.VX7_KNlZ@`l)vxL}2g~)k(#@=?utf-8?q?BN=24U+3MgB2=0A=097yR=5D=26tZ8PTc=3D=60?=<A%=5!.VCQ~(<-2#;/xmM4t6'MB7zDSm7i$nn/x^TC*adoyqd"{b0,=?utf-8?q?Hr=5F=0A=09?=<.yl<O}[Z[s.oX/:P917[b9QB%3f]{m=`7azOx[(.XW)"nW?N]jA5=%!<=?utf-8?q?=27ayW=5E!NQg6RcZ=0A=09vG?=@\&{XT%rV)u^hXq%ecRC;$jLBaa>ZZB_o
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_a+DVG2HVJtJM5C7"
Message-Id: <200705231520.26789.jaroslav.sykora@sh.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_a+DVG2HVJtJM5C7
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

On Tuesday May 22, 2007, Miklos Szeredi wrote:
> Why do we want this?
> --------------------
> 
> That depends on who you ask.  My answer is this:
> 
>   'foo.tar.gz/foo/bar' or
>   'foo.tar.gz/contents/foo/bar'
> 
> or something similar.
> 

I work for a similir goal in my bachelor's theses. But my approach is 
a little bit different. Instead of:

>   'foo.tar.gz/foo/bar' or
>   'foo.tar.gz/contents/foo/bar'

I do:
   'foo.zip^/foo/bar' or
   'foo.zip^/contents/foo/bar'

where foo.zip is a ZIP file. See the little '^' in the pathname: it's an
escape character. I have a kernel patch which modifies a lookup 
resolution function and when a normal lookup fails ('foo.zip^/foo/bar'
dosn't exist) and the pathname contains '^' it *redirects* the lookup to 
a FUSE mount.

So say we have a FUSE vfs server (called 'RheaVFS') on '/tmp/shadow'. 
When a process tries to access '/home/xx/foo.zip^/foo/bar' 
it is in-kernel transparently redirected to 
'/tmp/shadow/home/xx/foo.zip^/foo/bar' and the vfs server handles all the
extraction/compresion/semi-mounting/semi-umounting/whatsoever...

Advantages:
* 99.9% imho backward compatible. No problems with clever programs 
  doing stat() before open()/opendir().
* you can easily and transparently stack filesystems one on top of another
  with a clear semantic. Say we have 'foo.tar.gz'; then:
	'foo.tar.gz^' is a decompressed TAR *file*;
	'foo.tar.gz^^' is a directory
* you can pass additional parameters to the vfs server after the '^', 
  eg. 'foo.zip^compresslevel=1/foo/bar'
* works with symlinks too

Drawbacks:
* users must/should be aware of the special escape char '^'
* usually only single vfs server per user handles all "virtual"
  directories --> single point of failure. (But I implemented a quirk
  which allows restarting the FUSE vfs server with only minor
  problems)
* probably tons of others I don't know....

The project tarball is at:

http://veverka.sh.cvut.cz/~sykora/prj/rheavfs-20070523-1239.tar.gz

The kernel patch is in the tarball and for your viewing pleasure 
I've attached it to this email.
The patch is againts 2.6.20.1 and works with 2.6.21.1 too.
There are two minor failed hunks for 2.6.22-rc2 which I hadn't time to correct.

My project is not completed, there's almost no documentation etc.
Maybe I will put together some simple README/HOWTO in a few days.
I wouldn't present the project at this time, but seeing your post
I've thought my approach might be interesting for the discussion.


	Jara

-- 
I find television very educating. Every time somebody turns on the set, 
I go into the other room and read a book.

--Boundary-00=_a+DVG2HVJtJM5C7
Content-Type: text/x-diff;
  charset="iso-8859-2";
  name="shdw-2.6.20.1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="shdw-2.6.20.1.patch"

--- orig/fs/file_table.c	2007-02-20 07:34:32.000000000 +0100
+++ new/fs/file_table.c	2007-05-09 20:49:52.000000000 +0200
@@ -152,8 +152,8 @@ EXPORT_SYMBOL(fput);
  */
 void fastcall __fput(struct file *file)
 {
-	struct dentry *dentry = file->f_path.dentry;
-	struct vfsmount *mnt = file->f_path.mnt;
+	struct dentry *dentry = file->f_path.dentry, *s_dentry = file->f_shdw;
+	struct vfsmount *mnt = file->f_path.mnt, *s_mnt = file->f_shdwmnt;
 	struct inode *inode = dentry->d_inode;
 
 	might_sleep();
@@ -178,15 +178,21 @@ void fastcall __fput(struct file *file)
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
@@ -202,6 +208,11 @@ struct file fastcall *fget(unsigned int 
 	return file;
 }
 
+struct file fastcall *fget(unsigned int fd)
+{
+	return __fget(current->files, fd);
+}
+
 EXPORT_SYMBOL(fget);
 
 /*
--- orig/fs/open.c	2007-02-20 07:34:32.000000000 +0100
+++ new/fs/open.c	2007-05-09 21:01:24.000000000 +0200
@@ -413,13 +413,51 @@ asmlinkage long sys_access(const char __
 	return sys_faccessat(AT_FDCWD, filename, mode);
 }
 
+static inline int read_fs_flags(void)
+{
+	int res;
+	read_lock(&current->fs->lock);
+	res = current->fs->flags;
+	read_unlock(&current->fs->lock);
+	return res;
+}
+
+void set_fs_shdwpwd(struct fs_struct *fs,
+			struct vfsmount *mnt, struct dentry *dentry)
+{
+	struct dentry *old_dentry;
+	struct vfsmount *old_mnt;
+
+	BUG_ON(dentry != NULL && mnt == NULL);
+	write_lock(&fs->lock);
+	/* set shadow pwd */
+	old_dentry = fs->shdwpwd;
+	old_mnt = fs->shdwpwdmnt;
+	fs->shdwpwd = dget(dentry);
+	if (dentry)
+		fs->shdwpwdmnt = mntget(mnt);
+	else
+		/* PTR_ERR flag */
+		fs->shdwpwdmnt = mnt;
+	write_unlock(&fs->lock);
+
+	if (old_dentry) {
+		mntput(old_mnt);
+		dput(old_dentry);
+	}
+}
+
 asmlinkage long sys_chdir(const char __user * filename)
 {
 	struct nameidata nd;
-	int error;
+	char *tmp = getname(filename);
+	int error = PTR_ERR(tmp);;
+
+	if (IS_ERR(tmp))
+		goto out_badname;
 
-	error = __user_walk(filename,
-			    LOOKUP_FOLLOW|LOOKUP_DIRECTORY|LOOKUP_CHDIR, &nd);
+	error = path_lookup(tmp, LOOKUP_FOLLOW | LOOKUP_DIRECTORY
+			| LOOKUP_CHDIR, &nd);
 	if (error)
 		goto out;
 
@@ -427,11 +465,23 @@ asmlinkage long sys_chdir(const char __u
 	if (error)
 		goto dput_and_out;
 
-	set_fs_pwd(current->fs, nd.mnt, nd.dentry);
+	if (!(read_fs_flags() & SHDW_ENABLED))
+		goto set_std;
 
+	if (!(nd.flags & LOOKUP_INSHDW)) {
+		set_fs_shdwpwd(current->fs, NULL, NULL);
+	} else
+		/* shadow == std */
+		set_fs_shdwpwd(current->fs, nd.mnt, nd.dentry);
+
+set_std:
+	/* set std cwd */
+	set_fs_pwd(current->fs, nd.mnt, nd.dentry);
 dput_and_out:
 	path_release(&nd);
 out:
+	putname(tmp);
+out_badname:
 	return error;
 }
 
@@ -457,8 +507,25 @@ asmlinkage long sys_fchdir(unsigned int 
 		goto out_putf;
 
 	error = file_permission(file, MAY_EXEC);
-	if (!error)
-		set_fs_pwd(current->fs, mnt, dentry);
+	if (error)
+		goto out_putf;
+
+	set_fs_pwd(current->fs, mnt, dentry);
+
+	if (!(read_fs_flags() & SHDW_ENABLED))
+		/* shadow dirs aren't enabled */
+		goto out_putf;
+
+	if (get_file_shdwdir(file, &dentry, &mnt))
+		/* some error ocured */
+		set_fs_shdwpwd(current->fs, NULL, NULL);
+	else {
+		/* ok */
+		set_fs_shdwpwd(current->fs, mnt, dentry);
+		mntput(mnt);
+		dput(dentry);
+	}
+
 out_putf:
 	fput(file);
 out:
--- orig/fs/namei.c	2007-02-20 07:34:32.000000000 +0100
+++ new/fs/namei.c	2007-05-09 21:01:50.000000000 +0200
@@ -1,4 +1,4 @@
-/*
+ /*
  *  linux/fs/namei.c
  *
  *  Copyright (C) 1991, 1992  Linus Torvalds
@@ -32,6 +32,7 @@
 #include <linux/file.h>
 #include <linux/fcntl.h>
 #include <linux/namei.h>
+#include <linux/ptrace.h>
 #include <asm/namei.h>
 #include <asm/uaccess.h>
 
@@ -514,6 +515,25 @@ static struct dentry * real_lookup(struc
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
@@ -531,8 +551,8 @@ walk_init_root(const char *name, struct 
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
@@ -729,9 +749,9 @@ static __always_inline void follow_dotdo
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
@@ -841,6 +861,11 @@ static fastcall int __link_path_walk(con
 
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
@@ -1099,8 +1124,8 @@ set_it:
 	}
 }
 
-/* Returns 0 and nd will be valid on success; Retuns error, otherwise. */
-static int fastcall do_path_lookup(int dfd, const char *name,
+/* Lookup @name, starting at @dfd, use normal (non-shadow) root and pwd */
+static int fastcall path_lookup_norm(int dfd, const char *name,
 				unsigned int flags, struct nameidata *nd)
 {
 	int retval = 0;
@@ -1159,7 +1184,7 @@ out:
 	if (likely(retval == 0)) {
 		if (unlikely(!audit_dummy_context() && nd && nd->dentry &&
 				nd->dentry->d_inode))
-		audit_inode(name, nd->dentry->d_inode);
+			audit_inode(name, nd->dentry->d_inode);
 	}
 out_fail:
 	return retval;
@@ -1169,6 +1194,313 @@ fput_fail:
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
+	buf = (char*)__get_free_page(GFP_KERNEL);
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
+	buf = (char*)__get_free_page(GFP_KERNEL);
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
@@ -1195,6 +1527,16 @@ static int __path_lookup_intent_open(int
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
 
@@ -2750,6 +3092,260 @@ struct inode_operations page_symlink_ino
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
+		ret = put_user((char)ret, (char __user*)data);
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
--- orig/fs/namespace.c	2007-02-20 07:34:32.000000000 +0100
+++ new/fs/namespace.c	2007-03-02 20:05:03.000000000 +0100
@@ -1448,6 +1448,7 @@ struct mnt_namespace *dup_mnt_ns(struct 
 	struct mnt_namespace *mnt_ns = tsk->nsproxy->mnt_ns;
 	struct mnt_namespace *new_ns;
 	struct vfsmount *rootmnt = NULL, *pwdmnt = NULL, *altrootmnt = NULL;
+	struct vfsmount *shdwrootmnt = NULL, *shdwpwdmnt = NULL;
 	struct vfsmount *p, *q;
 
 	new_ns = kmalloc(sizeof(struct mnt_namespace), GFP_KERNEL);
@@ -1494,6 +1495,14 @@ struct mnt_namespace *dup_mnt_ns(struct 
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
@@ -1506,6 +1515,10 @@ struct mnt_namespace *dup_mnt_ns(struct 
 		mntput(pwdmnt);
 	if (altrootmnt)
 		mntput(altrootmnt);
+	if (shdwrootmnt)
+		mntput(shdwrootmnt);
+	if (shdwpwdmnt)
+		mntput(shdwpwdmnt);
 
 	return new_ns;
 }
--- orig/fs/exec.c	2007-02-20 07:34:32.000000000 +0100
+++ new/fs/exec.c	2007-04-15 20:10:01.000000000 +0200
@@ -856,8 +856,11 @@ int flush_old_exec(struct linux_binprm *
 
 	if (current->euid == current->uid && current->egid == current->gid)
 		current->mm->dumpable = 1;
-	else
+	else {
 		current->mm->dumpable = suid_dumpable;
+		/* switch off the shadow directories for a suid exec */
+		current->fs->flags &= ~SHDW_ENABLED;
+	}
 
 	name = bprm->filename;
 
--- orig/fs/proc/base.c	2007-02-20 07:34:32.000000000 +0100
+++ new/fs/proc/base.c	2007-05-09 20:57:37.000000000 +0200
@@ -168,6 +168,32 @@ static int proc_cwd_link(struct inode *i
 	return result;
 }
 
+static int proc_shdwcwd_link(struct inode *inode, struct dentry **dentry,
+			     struct vfsmount **mnt)
+{
+	struct task_struct *task = get_proc_task(inode);
+	struct fs_struct *fs = NULL;
+	int result = -ENOENT;
+
+	if (task) {
+		fs = get_fs_struct(task);
+		put_task_struct(task);
+	}
+	if (fs) {
+		read_lock(&fs->lock);
+		*dentry = dget(fs->shdwpwd);
+		if (fs->shdwpwd)
+			*mnt = mntget(fs->shdwpwdmnt);
+		else
+			*mnt = NULL;
+		read_unlock(&fs->lock);
+		if (*dentry)
+			result = 0;
+		put_fs_struct(fs);
+	}
+	return result;
+}
+
 static int proc_root_link(struct inode *inode, struct dentry **dentry, struct vfsmount **mnt)
 {
 	struct task_struct *task = get_proc_task(inode);
@@ -189,6 +215,29 @@ static int proc_root_link(struct inode *
 	return result;
 }
 
+static int proc_shdwroot_link(struct inode *inode, struct dentry **dentry,
+			      struct vfsmount **mnt)
+{
+	struct task_struct *task = get_proc_task(inode);
+	struct fs_struct *fs = NULL;
+	int result = -ENOENT;
+
+	if (task) {
+		fs = get_fs_struct(task);
+		put_task_struct(task);
+	}
+	if (fs) {
+		read_lock(&fs->lock);
+		*mnt = mntget(fs->shdwrootmnt);
+		*dentry = dget(fs->shdwroot);
+		read_unlock(&fs->lock);
+		if (*dentry)
+			result = 0;
+		put_fs_struct(fs);
+	}
+	return result;
+}
+
 #define MAY_PTRACE(task) \
 	(task == current || \
 	(task->parent == current && \
@@ -1878,6 +1927,8 @@ static struct pid_entry tgid_base_stuff[
 #ifdef CONFIG_FAULT_INJECTION
 	REG("make-it-fail", S_IRUGO|S_IWUSR, fault_inject),
 #endif
+	LNK("root-shdw",  shdwroot),
+	LNK("cwd-shdw",   shdwcwd),
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 	INF("io",	S_IRUGO, pid_io_accounting),
 #endif
@@ -2159,6 +2210,8 @@ static struct pid_entry tid_base_stuff[]
 #ifdef CONFIG_FAULT_INJECTION
 	REG("make-it-fail", S_IRUGO|S_IWUSR, fault_inject),
 #endif
+	LNK("root-shdw", shdwroot),
+	LNK("cwd-shdw",  shdwcwd),
 };
 
 static int proc_tid_base_readdir(struct file * filp,
--- orig/fs/proc/array.c	2007-02-20 07:34:32.000000000 +0100
+++ new/fs/proc/array.c	2007-03-20 20:02:27.000000000 +0100
@@ -291,6 +291,28 @@ static inline char *task_cap(struct task
 			    cap_t(p->cap_effective));
 }
 
+static inline char *task_fsinfo(struct task_struct *p, char *buffer)
+{
+	int enabled = 0, use_esc = 0, esc_ch = 0;
+
+	rcu_read_lock();
+	task_lock(p);
+	if (p->fs) {
+		read_lock(&p->fs->lock);
+		enabled = (p->fs->flags & SHDW_ENABLED) ? 1 : 0;
+		use_esc = (p->fs->flags & SHDW_USE_ESC) ? 1 : 0;
+		esc_ch = p->fs->shdw_escch;
+		read_unlock(&p->fs->lock);
+	}
+	task_unlock(p);
+	rcu_read_unlock();
+
+	return buffer + sprintf(buffer, "Shdw_Enabled:\t%d\n"
+				"Shdw_UseEscChar: %d\n"
+				"Shdw_EscChar:\t%u\n",
+				enabled, use_esc, (unsigned int)esc_ch);
+}
+
 int proc_pid_status(struct task_struct *task, char * buffer)
 {
 	char * orig = buffer;
@@ -309,6 +331,7 @@ int proc_pid_status(struct task_struct *
 #if defined(CONFIG_S390)
 	buffer = task_show_regs(task, buffer);
 #endif
+	buffer = task_fsinfo(task, buffer);
 	return buffer - orig;
 }
 
--- orig/include/linux/fs.h	2007-02-20 07:34:32.000000000 +0100
+++ new/include/linux/fs.h	2007-03-02 20:05:03.000000000 +0100
@@ -263,6 +263,14 @@ extern int dir_notify_enable;
 #define SYNC_FILE_RANGE_WRITE		2
 #define SYNC_FILE_RANGE_WAIT_AFTER	4
 
+/* sys_setshdwinfo(), sys_getshdwinfo(): */
+#define FSI_SHDW_ENABLE		1	/* enable shadow directories */
+#define FSI_SHDW_ESC_EN		2	/* enable use of escape character */
+#define FSI_SHDW_ESC_CHAR	3	/* specify escape character */
+/* sys_setshdwpath */
+#define SHDW_FD_ROOT		-1	/* pseudo FD for root shadow dir */
+#define SHDW_FD_PWD		-2	/* pseudo FD for pwd shadow dir */
+
 #ifdef __KERNEL__
 
 #include <linux/linkage.h>
@@ -739,6 +747,16 @@ struct file {
 	spinlock_t		f_ep_lock;
 #endif /* #ifdef CONFIG_EPOLL */
 	struct address_space	*f_mapping;
+
+	/* the following fields are protected by f_owner.lock */
+	/* | f_shdw   | f_shdwmnt   | result
+	   +----------+-------------+------------
+	   | NULL     | NULL        | delayed
+	   | NULL     | !NULL       | invalid
+	   | !NULL    | NULL        | BUG
+	   | !NULL    | !NULL       | valid */
+	struct dentry		*f_shdw;
+	struct vfsmount		*f_shdwmnt;
 };
 extern spinlock_t files_lock;
 #define file_list_lock() spin_lock(&files_lock);
--- orig/include/linux/fs_struct.h	2007-02-20 07:34:32.000000000 +0100
+++ new/include/linux/fs_struct.h	2007-05-09 20:44:00.000000000 +0200
@@ -10,8 +10,31 @@ struct fs_struct {
 	int umask;
 	struct dentry * root, * pwd, * altroot;
 	struct vfsmount * rootmnt, * pwdmnt, * altrootmnt;
+
+	int flags;
+	/* shadow dirs: root and pwd */
+	/* | shdwroot | shdwrootmnt | result
+	   +----------+-------------+------------
+	   | NULL     | NULL        | BUG_ON(flags&SHDW_ENABLED)
+	   | !NULL    | !NULL       | ok
+	   +==========+=============+============
+	   | shdwpwd  | shdwpwdmnt  | result
+	   +----------+-------------+------------
+	   | NULL     | NULL        | delayed
+	   | NULL     | !NULL       | invalid
+	   | !NULL    | NULL        | BUG
+	   | !NULL    | !NULL       | valid */
+	struct dentry *shdwroot, *shdwpwd;
+	struct vfsmount *shdwrootmnt, *shdwpwdmnt;
+	/* shadow dirs: escape character */
+	unsigned char shdw_escch;
 };
 
+/* bitflags for fs_struct.flags */
+#define SHDW_ENABLED		1	/* are shadow dirs enabled? */
+#define SHDW_USE_ESC		2	/* use escape char in shadow dirs? */
+
+
 #define INIT_FS {				\
 	.count		= ATOMIC_INIT(1),	\
 	.lock		= RW_LOCK_UNLOCKED,	\
@@ -24,6 +47,8 @@ extern void exit_fs(struct task_struct *
 extern void set_fs_altroot(void);
 extern void set_fs_root(struct fs_struct *, struct vfsmount *, struct dentry *);
 extern void set_fs_pwd(struct fs_struct *, struct vfsmount *, struct dentry *);
+extern void set_fs_shdwpwd(struct fs_struct *fs,
+			   struct vfsmount *mnt, struct dentry *dentry);
 extern struct fs_struct *copy_fs_struct(struct fs_struct *);
 extern void put_fs_struct(struct fs_struct *);
 
--- orig/include/linux/namei.h	2007-02-20 07:34:32.000000000 +0100
+++ new/include/linux/namei.h	2007-05-09 20:58:43.000000000 +0200
@@ -22,6 +22,7 @@ struct nameidata {
 	int		last_type;
 	unsigned	depth;
 	char *saved_names[MAX_NESTED_LINKS + 1];
+	unsigned char	find_char;
 
 	/* Intent data */
 	union {
@@ -54,6 +55,16 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LA
 #define LOOKUP_PARENT		16
 #define LOOKUP_NOALT		32
 #define LOOKUP_REVAL		64
+
+/* don't fallback to lookup in shadow directory */
+#define LOOKUP_NOSHDW		128
+/* try to find nameidata.find_char in pathname,
+ * set LOOKUP_CHARFOUND in nameidata.flags if found */
+#define LOOKUP_FINDCHAR		(1<<16)
+#define LOOKUP_CHARFOUND	(1<<17)
+/* (dentry,mnt) was found in shadow dir */
+#define LOOKUP_INSHDW		(1<<18)
+
 /*
  * Intent data
  */
@@ -68,14 +79,19 @@ extern int FASTCALL(__user_walk_fd(int d
 	__user_walk_fd(AT_FDCWD, name, LOOKUP_FOLLOW, nd)
 #define user_path_walk_link(name,nd) \
 	__user_walk_fd(AT_FDCWD, name, 0, nd)
+
+extern int FASTCALL(path_lookup_shdw(int dfd, const char *name,
+			unsigned int flags, struct nameidata *nd));
 extern int FASTCALL(path_lookup(const char *, unsigned, struct nameidata *));
 extern int FASTCALL(path_walk(const char *, struct nameidata *));
 extern int FASTCALL(link_path_walk(const char *, struct nameidata *));
 extern void path_release(struct nameidata *);
 extern void path_release_on_umount(struct nameidata *);
 
-extern int __user_path_lookup_open(const char __user *, unsigned lookup_flags, struct nameidata *nd, int open_flags);
-extern int path_lookup_open(int dfd, const char *name, unsigned lookup_flags, struct nameidata *, int open_flags);
+extern int __user_path_lookup_open(const char __user *, unsigned lookup_flags,
+				   struct nameidata *nd, int open_flags);
+extern int path_lookup_open(int dfd, const char *name, unsigned lookup_flags,
+			    struct nameidata *, int open_flags);
 extern struct file *lookup_instantiate_filp(struct nameidata *nd, struct dentry *dentry,
 		int (*open)(struct inode *, struct file *));
 extern struct file *nameidata_to_filp(struct nameidata *nd, int flags);
@@ -89,6 +105,9 @@ extern int follow_up(struct vfsmount **,
 extern struct dentry *lock_rename(struct dentry *, struct dentry *);
 extern void unlock_rename(struct dentry *, struct dentry *);
 
+extern int get_file_shdwdir(struct file *file, struct dentry **dentry,
+			    struct vfsmount **mnt);
+
 static inline void nd_set_link(struct nameidata *nd, char *path)
 {
 	nd->saved_names[nd->depth] = path;
--- orig/include/linux/file.h	2007-02-20 07:34:32.000000000 +0100
+++ new/include/linux/file.h	2007-05-09 20:59:58.000000000 +0200
@@ -68,6 +68,8 @@ static inline void fput_light(struct fil
 		fput(file);
 }
 
+extern struct file * FASTCALL(__fget(struct files_struct *files,
+				unsigned int fd));
 extern struct file * FASTCALL(fget(unsigned int fd));
 extern struct file * FASTCALL(fget_light(unsigned int fd, int *fput_needed));
 extern void FASTCALL(set_close_on_exec(unsigned int fd, int flag));
--- orig/kernel/exit.c	2007-02-20 07:34:32.000000000 +0100
+++ new/kernel/exit.c	2007-03-02 20:05:03.000000000 +0100
@@ -515,6 +515,14 @@ static inline void __put_fs_struct(struc
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
--- orig/kernel/fork.c	2007-02-20 07:34:32.000000000 +0100
+++ new/kernel/fork.c	2007-03-02 20:05:03.000000000 +0100
@@ -581,6 +581,9 @@ static inline struct fs_struct *__copy_f
 		fs->root = dget(old->root);
 		fs->pwdmnt = mntget(old->pwdmnt);
 		fs->pwd = dget(old->pwd);
+		fs->flags = old->flags;
+		fs->shdw_escch = old->shdw_escch;
+
 		if (old->altroot) {
 			fs->altrootmnt = mntget(old->altrootmnt);
 			fs->altroot = dget(old->altroot);
@@ -588,6 +591,23 @@ static inline struct fs_struct *__copy_f
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
--- orig/include/linux/syscalls.h	2007-02-20 07:34:32.000000000 +0100
+++ new/include/linux/syscalls.h	2007-03-02 20:05:03.000000000 +0100
@@ -605,4 +605,10 @@ asmlinkage long sys_getcpu(unsigned __us
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
+asmlinkage long sys_getshdwinfo(pid_t pid, int func, int __user *data);
+
+asmlinkage long sys_setshdwinfo(pid_t pid, int func, int data);
+
+asmlinkage long sys_setshdwpath(pid_t pid, int fd, const char __user *path);
+
 #endif
--- orig/arch/i386/kernel/syscall_table.S	2007-02-20 07:34:32.000000000 +0100
+++ new/arch/i386/kernel/syscall_table.S	2007-03-02 20:56:40.000000000 +0100
@@ -319,3 +319,6 @@ ENTRY(sys_call_table)
 	.long sys_move_pages
 	.long sys_getcpu
 	.long sys_epoll_pwait
+	.long sys_getshdwinfo		/* 320 */
+	.long sys_setshdwinfo
+	.long sys_setshdwpath

--Boundary-00=_a+DVG2HVJtJM5C7--
