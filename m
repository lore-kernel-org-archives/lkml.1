Return-Path: <linux-kernel-owner+w=401wt.eu-S1763201AbYBNNHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763201AbYBNNHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 08:07:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYBNNGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 08:06:50 -0500
Received: from pat.uio.no ([129.240.10.15]:33213 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbYBNNGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 08:06:49 -0500
Subject: Re: [PATCH] Add MS_BIND_FLAGS mount flag
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: menage@google.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <E1JPZUb-00013Z-0U@pomaz-ex.szeredi.hu>
References: <47B283EB.8070209@google.com>
	 <E1JPZUb-00013Z-0U@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 08:06:25 -0500
Message-Id: <1202994385.8343.16.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: 9F8EE8DCF3C21568DDB06B0447C2DA09A1719B9D
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 206 total 6882382 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-14 at 09:30 +0100, Miklos Szeredi wrote:

> And this is where we usually conclude, that a new userspace mount API
> is long overdue.  So for starters, how about a new syscall for bind
> mounts:
> 
> int mount_bind(const char *src, const char *dst, unsigned flags,
> 		 unsigned mnt_flags);

If you're going to add a new bind mount interface, then please consider
adding 'openat'-like file descriptors. I'm already looking into doing
this for the main 'mount' interface in order to solve the automounting
problem when dealing with arbitrary namespaces.

Cheers
  Trond

---
From: Trond Myklebust <Trond.Myklebust@netapp.com>
VFS: Add support for a new mountat() system call

sys_mountat() basically adds an openat()-like 'dirfd' argument to the mount
system call interface.
This is needed in order to support automounting in the presence of
arbitrary user namespaces. It does so by allowing the kernel to encode the
namespace+directory information in a directory file descriptor that may be
passed to an automounter daemon that is running in a different namespace.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/namespace.c           |   47 ++++++++++++++++++++++++++++++++++------------
 include/linux/syscalls.h |    5 +++++
 2 files changed, 40 insertions(+), 12 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 9025d22..53b5943 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -670,7 +670,7 @@ static int do_umount(struct vfsmount *mnt, int flags)
  * unixes. Our API is identical to OSF/1 to avoid making a mess of AMD
  */
 
-asmlinkage long sys_umount(char __user * name, int flags)
+asmlinkage long sys_umountat(int dfd, char __user * name, int flags)
 {
 	struct nameidata nd;
 	int retval;
@@ -695,6 +695,11 @@ out:
 	return retval;
 }
 
+asmlinkage long sys_umount(char __user * name, int flags)
+{
+	return sys_umountat(AT_FDCWD, name, flags);
+}
+
 #ifdef __ARCH_WANT_SYS_OLDUMOUNT
 
 /*
@@ -963,7 +968,7 @@ static noinline int do_change_type(struct nameidata *nd, int flag)
  * do loopback mount.
  * noinline this do_mount helper to save do_mount stack space.
  */
-static noinline int do_loopback(struct nameidata *nd, char *old_name,
+static noinline int do_loopback(struct nameidata *nd, int dfd, char *old_name,
 				int recurse)
 {
 	struct nameidata old_nd;
@@ -973,7 +978,7 @@ static noinline int do_loopback(struct nameidata *nd, char *old_name,
 		return err;
 	if (!old_name || !*old_name)
 		return -EINVAL;
-	err = path_lookup(old_name, LOOKUP_FOLLOW, &old_nd);
+	err = path_lookup_fd(dfd, old_name, LOOKUP_FOLLOW, &old_nd);
 	if (err)
 		return err;
 
@@ -1053,7 +1058,7 @@ static inline int tree_contains_unbindable(struct vfsmount *mnt)
 /*
  * noinline this do_mount helper to save do_mount stack space.
  */
-static noinline int do_move_mount(struct nameidata *nd, char *old_name)
+static noinline int do_move_mount(struct nameidata *nd, int dfd, char *old_name)
 {
 	struct nameidata old_nd, parent_nd;
 	struct vfsmount *p;
@@ -1062,7 +1067,7 @@ static noinline int do_move_mount(struct nameidata *nd, char *old_name)
 		return -EPERM;
 	if (!old_name || !*old_name)
 		return -EINVAL;
-	err = path_lookup(old_name, LOOKUP_FOLLOW, &old_nd);
+	err = path_lookup_fd(dfd, old_name, LOOKUP_FOLLOW, &old_nd);
 	if (err)
 		return err;
 
@@ -1445,7 +1450,8 @@ int copy_mount_options(const void __user * data, unsigned long *where)
  * Therefore, if this magic number is present, it carries no information
  * and must be discarded.
  */
-long do_mount(char *dev_name, char *dir_name, char *type_page,
+static long do_mountat(int devdfd, char *dev_name,
+		  int dirdfd, char *dir_name, char *type_page,
 		  unsigned long flags, void *data_page)
 {
 	struct nameidata nd;
@@ -1484,7 +1490,8 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
 		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT);
 
 	/* ... and get the mountpoint */
-	retval = path_lookup(dir_name, LOOKUP_FOLLOW|LOOKUP_MOUNT, &nd);
+	retval = path_lookup_fd(dirdfd, dir_name, LOOKUP_FOLLOW|LOOKUP_MOUNT,
+				&nd);
 	if (retval)
 		return retval;
 
@@ -1496,11 +1503,11 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
 		retval = do_remount(&nd, flags & ~MS_REMOUNT, mnt_flags,
 				    data_page);
 	else if (flags & MS_BIND)
-		retval = do_loopback(&nd, dev_name, flags & MS_REC);
+		retval = do_loopback(&nd, devdfd, dev_name, flags & MS_REC);
 	else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
 		retval = do_change_type(&nd, flags);
 	else if (flags & MS_MOVE)
-		retval = do_move_mount(&nd, dev_name);
+		retval = do_move_mount(&nd, devdfd, dev_name);
 	else
 		retval = do_new_mount(&nd, type_page, flags, mnt_flags,
 				      dev_name, data_page);
@@ -1509,6 +1516,13 @@ dput_out:
 	return retval;
 }
 
+long do_mount(char *dev_name, char *dir_name, char *type_page,
+		  unsigned long flags, void *data_page)
+{
+	return do_mountat(AT_FDCWD, dev_name, AT_FDCWD, dir_name,
+			type_page, flags, data_page);
+}
+
 /*
  * Allocate a new namespace structure and populate it with contents
  * copied from the namespace of the passed in task structure.
@@ -1597,7 +1611,8 @@ struct mnt_namespace *copy_mnt_ns(unsigned long flags, struct mnt_namespace *ns,
 	return new_ns;
 }
 
-asmlinkage long sys_mount(char __user * dev_name, char __user * dir_name,
+asmlinkage long sys_mountat(int devdfd, char __user * dev_name,
+			  int dirdfd, char __user * dir_name,
 			  char __user * type, unsigned long flags,
 			  void __user * data)
 {
@@ -1625,8 +1640,8 @@ asmlinkage long sys_mount(char __user * dev_name, char __user * dir_name,
 		goto out3;
 
 	lock_kernel();
-	retval = do_mount((char *)dev_page, dir_page, (char *)type_page,
-			  flags, (void *)data_page);
+	retval = do_mountat(devdfd, (char *)dev_page, dirdfd, dir_page,
+			  (char *)type_page, flags, (void *)data_page);
 	unlock_kernel();
 	free_page(data_page);
 
@@ -1639,6 +1654,14 @@ out1:
 	return retval;
 }
 
+asmlinkage long sys_mount(char __user * dev_name, char __user * dir_name,
+			  char __user * type, unsigned long flags,
+			  void __user * data)
+{
+	return sys_mountat(AT_FDCWD, dev_name, AT_FDCWD, dir_name,
+			type, flags, data);
+}
+
 /*
  * Replace the fs->{rootmnt,root} with {mnt,dentry}. Put the old values.
  * It can block. Requires the big lock held.
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 4c2577b..de1dc02 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -614,6 +614,11 @@ asmlinkage long sys_timerfd_settime(int ufd, int flags,
 asmlinkage long sys_timerfd_gettime(int ufd, struct itimerspec __user *otmr);
 asmlinkage long sys_eventfd(unsigned int count);
 asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
+asmlinkage long sys_mountat(int devdfd, char __user *dev_name,
+				int dirdfd, char __user *dir_name,
+				char __user *type, unsigned long flags,
+				void __user *data);
+asmlinkage long sys_umountat(int dfd, char __user *name, int flags);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 


