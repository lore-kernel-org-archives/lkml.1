Return-Path: <linux-kernel-owner+w=401wt.eu-S1752960AbZJ2P4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbZJ2P4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 11:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbZJ2P4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 11:56:50 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:55440 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbZJ2P4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 11:56:49 -0400
To: serue@us.ibm.com, viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [TOMOYO #16 01/25] LSM: Add security_path_chmod() andsecurity_path_chown().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20091004124946.788396453@I-love.SAKURA.ne.jp>
	<20091004125327.105675949@I-love.SAKURA.ne.jp>
	<20091029051211.GB11558@us.ibm.com>
In-Reply-To: <20091029051211.GB11558@us.ibm.com>
Message-Id: <200910300056.IFD65194.MSOLHFOVJQtOFF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 30 Oct 2009 00:56:53 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Serge E. Hallyn wrote:
> Quoting Tetsuo Handa (penguin-kernel@I-love.SAKURA.ne.jp):
> > This patch allows pathname based LSM modules to check chmod()/chown()
> > operations. Since notify_change() does not receive "struct vfsmount *",
> > we add security_path_chmod() and security_path_chown() to the caller of
> > notify_change().
> > 
> > These hooks are used by TOMOYO.
> > 
> > Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > ---
> >  fs/open.c                |   24 ++++++++++++++++++++----
> >  include/linux/security.h |   30 ++++++++++++++++++++++++++++++
> >  security/capability.c    |   13 +++++++++++++
> >  security/security.c      |   15 +++++++++++++++
> >  4 files changed, 78 insertions(+), 4 deletions(-)
> > 
> > --- security-testing-2.6.orig/fs/open.c
> > +++ security-testing-2.6/fs/open.c
> > @@ -616,6 +616,9 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd
> >  	err = mnt_want_write_file(file);
> >  	if (err)
> >  		goto out_putf;
> > +	err = security_path_chmod(dentry, file->f_vfsmnt, mode);
> > +	if (err)
> > +		goto out_drop_write;
> >  	mutex_lock(&inode->i_mutex);
> 
> Isn't doing the security check before the mutex_lock racy?
> 
> Any reason not to move it into the lock?  (since you had
> considered putting a path hook in notify_change() I assume
> not?)
> 
None for security_path_chmod(). None for security_path_chown() if we are
allowed to pass "struct vfsmount" to chown_common().
> -serge
> 
Al, is it OK to pass "struct vfsmount" to chown_common() so that
security_path_chown() is called after mutex_lock()?
----------
[PATCH] LSM: Move security_path_chmod()/security_path_chown() to after mutex_lock().

We should call security_path_chmod()/security_path_chown() after mutex_lock()
in order to avoid races.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/open.c |   36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

--- security-testing-2.6.orig/fs/open.c
+++ security-testing-2.6/fs/open.c
@@ -619,17 +619,17 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd
 	err = mnt_want_write_file(file);
 	if (err)
 		goto out_putf;
+	mutex_lock(&inode->i_mutex);
 	err = security_path_chmod(dentry, file->f_vfsmnt, mode);
 	if (err)
-		goto out_drop_write;
-	mutex_lock(&inode->i_mutex);
+		goto out_unlock;
 	if (mode == (mode_t) -1)
 		mode = inode->i_mode;
 	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
 	err = notify_change(dentry, &newattrs);
+out_unlock:
 	mutex_unlock(&inode->i_mutex);
-out_drop_write:
 	mnt_drop_write(file->f_path.mnt);
 out_putf:
 	fput(file);
@@ -652,17 +652,17 @@ SYSCALL_DEFINE3(fchmodat, int, dfd, cons
 	error = mnt_want_write(path.mnt);
 	if (error)
 		goto dput_and_out;
+	mutex_lock(&inode->i_mutex);
 	error = security_path_chmod(path.dentry, path.mnt, mode);
 	if (error)
-		goto out_drop_write;
-	mutex_lock(&inode->i_mutex);
+		goto out_unlock;
 	if (mode == (mode_t) -1)
 		mode = inode->i_mode;
 	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
 	error = notify_change(path.dentry, &newattrs);
+out_unlock:
 	mutex_unlock(&inode->i_mutex);
-out_drop_write:
 	mnt_drop_write(path.mnt);
 dput_and_out:
 	path_put(&path);
@@ -675,9 +675,9 @@ SYSCALL_DEFINE2(chmod, const char __user
 	return sys_fchmodat(AT_FDCWD, filename, mode);
 }
 
-static int chown_common(struct dentry * dentry, uid_t user, gid_t group)
+static int chown_common(struct path *path, uid_t user, gid_t group)
 {
-	struct inode *inode = dentry->d_inode;
+	struct inode *inode = path->dentry->d_inode;
 	int error;
 	struct iattr newattrs;
 
@@ -694,7 +694,9 @@ static int chown_common(struct dentry * 
 		newattrs.ia_valid |=
 			ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
 	mutex_lock(&inode->i_mutex);
-	error = notify_change(dentry, &newattrs);
+	error = security_path_chown(path, user, group);
+	if (!error)
+		error = notify_change(path->dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
 
 	return error;
@@ -711,9 +713,7 @@ SYSCALL_DEFINE3(chown, const char __user
 	error = mnt_want_write(path.mnt);
 	if (error)
 		goto out_release;
-	error = security_path_chown(&path, user, group);
-	if (!error)
-		error = chown_common(path.dentry, user, group);
+	error = chown_common(&path, user, group);
 	mnt_drop_write(path.mnt);
 out_release:
 	path_put(&path);
@@ -738,9 +738,7 @@ SYSCALL_DEFINE5(fchownat, int, dfd, cons
 	error = mnt_want_write(path.mnt);
 	if (error)
 		goto out_release;
-	error = security_path_chown(&path, user, group);
-	if (!error)
-		error = chown_common(path.dentry, user, group);
+	error = chown_common(&path, user, group);
 	mnt_drop_write(path.mnt);
 out_release:
 	path_put(&path);
@@ -759,9 +757,7 @@ SYSCALL_DEFINE3(lchown, const char __use
 	error = mnt_want_write(path.mnt);
 	if (error)
 		goto out_release;
-	error = security_path_chown(&path, user, group);
-	if (!error)
-		error = chown_common(path.dentry, user, group);
+	error = chown_common(&path, user, group);
 	mnt_drop_write(path.mnt);
 out_release:
 	path_put(&path);
@@ -784,9 +780,7 @@ SYSCALL_DEFINE3(fchown, unsigned int, fd
 		goto out_fput;
 	dentry = file->f_path.dentry;
 	audit_inode(NULL, dentry);
-	error = security_path_chown(&file->f_path, user, group);
-	if (!error)
-		error = chown_common(dentry, user, group);
+	error = chown_common(&file->f_path, user, group);
 	mnt_drop_write(file->f_path.mnt);
 out_fput:
 	fput(file);
