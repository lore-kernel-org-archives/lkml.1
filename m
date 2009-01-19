Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbZASPSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbZASPSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 10:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbZASPSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 10:18:23 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50904 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbZASPSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 10:18:22 -0500
Subject: Re: mmotm 2009-01-14-20-31 uploaded (gfs2)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com
In-Reply-To: <20090116093550.ce7229d5.akpm@linux-foundation.org>
References: <200901150432.n0F4WI66023742@imap1.linux-foundation.org>
	 <496F8AED.3020604@oracle.com>
	 <1232101203.3554.3.camel@localhost.localdomain>
	 <20090116084352.9f35b822.akpm@linux-foundation.org>
	 <1232125371.9571.587.camel@quoit> <4970BE8F.9090705@oracle.com>
	 <20090116093550.ce7229d5.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 19 Jan 2009 15:16:40 +0000
Message-Id: <1232378200.9571.602.camel@quoit>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2009-01-16 at 09:35 -0800, Andrew Morton wrote:
> On Fri, 16 Jan 2009 09:06:23 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > >>> which is not ideal, but I don't see any easy way to avoid the #ifdef,
> > >>>
> > >> Take a look in fs.h:
> > >>
> > >> #define generic_setlease(a, b, c) ({ -EINVAL; })
> > >>
> > >> If that wasn't a stupid macro, your code would have compiled and ran
> > >> just as intended.
> > >>
> > > There doesn't seem to be an easy answer though. If I #define it to NULL,
> > > that upsets other parts of the code that rely on that macro, and if I
> > > turn it into a inline function which returns -EINVAL, then presumably I
> > > can't take its address for my file_operations.
> > 
> > No, gcc will allow &inline_func and out-of-line it if it is needed (AFAIK;
> > I've seen a few cases of that).
> > 
> 
> yup.  It measn that we'll get a separate private copy of the
> generic_setlease() code in each compilation unit which takes its
> address, but I don't think that would kill us.
> 
> The prevention is of course to put the stub function in a core kernel
> .c file and export it to modules.
> 
Having looked into this in a bit more detail now, it seems that this
particular function (generic_setlease) is one of a number appearing in
fs.h which are replaced by macros in the case that CONFIG_FILE_LOCKING
is not set.

So rather than just do the one function, it seemed to make sense to me
to make them all the same. So this uses inline functions as originally
proposed. If you'd prefer that we don't inline them and instead have a
fs/no-locks.c or something like that with stub functions in it, then I"m
happy to revise the patch accordingly.

This patch passes my compile tests, modulo a small change that I need to
make in GFS2 to suppress a warning (not attached). That seems to be
related to yet another set of macros which appear only with
CONFIG_FILE_LOCKING not set. Maybe I should update those to be inline
functions as well....

Steve.

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6022f44..392c18a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1057,34 +1057,147 @@ extern int lease_modify(struct file_lock **, int);
 extern int lock_may_read(struct inode *, loff_t start, unsigned long count);
 extern int lock_may_write(struct inode *, loff_t start, unsigned long count);
 #else /* !CONFIG_FILE_LOCKING */
-#define fcntl_getlk(a, b) ({ -EINVAL; })
-#define fcntl_setlk(a, b, c, d) ({ -EACCES; })
+static inline int fcntl_getlk(struct file *file, struct flock __user *user)
+{
+	return -EINVAL;
+}
+
+static inline int fcntl_setlk(unsigned int fd, struct file *file,
+			      unsigned int cmd, struct flock __user *user)
+{
+	return -EACCES;
+}
+
 #if BITS_PER_LONG == 32
-#define fcntl_getlk64(a, b) ({ -EINVAL; })
-#define fcntl_setlk64(a, b, c, d) ({ -EACCES; })
+static inline int fcntl_getlk64(struct file *file, struct flock64 __user *user)
+{
+	return -EINVAL;
+}
+
+static inline int fcntl_setlk64(unsigned int fd, struct file *file,
+				unsigned int cmd, struct flock64 __user *user)
+{
+	return -EACCES;
+}
 #endif
-#define fcntl_setlease(a, b, c) ({ 0; })
-#define fcntl_getlease(a) ({ 0; })
-#define locks_init_lock(a) ({ })
-#define __locks_copy_lock(a, b) ({ })
-#define locks_copy_lock(a, b) ({ })
-#define locks_remove_posix(a, b) ({ })
-#define locks_remove_flock(a) ({ })
-#define posix_test_lock(a, b) ({ 0; })
-#define posix_lock_file(a, b, c) ({ -ENOLCK; })
-#define posix_lock_file_wait(a, b) ({ -ENOLCK; })
-#define posix_unblock_lock(a, b) (-ENOENT)
-#define vfs_test_lock(a, b) ({ 0; })
-#define vfs_lock_file(a, b, c, d) (-ENOLCK)
-#define vfs_cancel_lock(a, b) ({ 0; })
-#define flock_lock_file_wait(a, b) ({ -ENOLCK; })
-#define __break_lease(a, b) ({ 0; })
-#define lease_get_mtime(a, b) ({ })
-#define generic_setlease(a, b, c) ({ -EINVAL; })
-#define vfs_setlease(a, b, c) ({ -EINVAL; })
-#define lease_modify(a, b) ({ -EINVAL; })
-#define lock_may_read(a, b, c) ({ 1; })
-#define lock_may_write(a, b, c) ({ 1; })
+static inline int fcntl_setlease(unsigned int fd, struct file *filp, long arg)
+{
+	return 0;
+}
+
+static inline int fcntl_getlease(struct file *filp)
+{
+	return 0;
+}
+
+static inline void locks_init_lock(struct file_lock *fl)
+{
+	return;
+}
+
+static inline void __locks_copy_lock(struct file_lock *new, struct file_lock *fl)
+{
+	return;
+}
+
+static inline void locks_copy_lock(struct file_lock *new, struct file_lock *fl)
+{
+	return;
+}
+
+static inline void locks_remove_posix(struct file *filp, fl_owner_t owner)
+{
+	return;
+}
+
+static inline void locks_remove_flock(struct file *filp)
+{
+	return;
+}
+
+static inline void posix_test_lock(struct file *filp, struct file_lock *fl)
+{
+	return;
+}
+
+static inline int posix_lock_file(struct file *filp, struct file_lock *fl,
+				  struct file_lock *conflock)
+{
+	return -ENOLCK;
+}
+
+static inline int posix_lock_file_wait(struct file *filp, struct file_lock *fl)
+{
+	return -ENOLCK;
+}
+
+static inline int posix_unblock_lock(struct file *filp,
+				     struct file_lock *waiter)
+{
+	return -ENOENT;
+}
+
+static inline int vfs_test_lock(struct file *filp, struct file_lock *fl)
+{
+	return 0;
+}
+
+static inline int vfs_lock_file(struct file *filp, unsigned int cmd,
+				struct file_lock *fl, struct file_lock *conf)
+{
+	return -ENOLCK;
+}
+
+static inline int vfs_cancel_lock(struct file *filp, struct file_lock *fl)
+{
+	return 0;
+}
+
+static inline int flock_lock_file_wait(struct file *filp,
+				       struct file_lock *request)
+{
+	return -ENOLCK;
+}
+
+static inline int __break_lease(struct inode *inode, unsigned int mode)
+{
+	return 0;
+}
+
+static inline void lease_get_mtime(struct inode *inode, struct timespec *time)
+{
+	return;
+}
+
+static inline int generic_setlease(struct file *filp, long arg,
+				    struct file_lock **flp)
+{
+	return -EINVAL;
+}
+
+static inline int vfs_setlease(struct file *filp, long arg,
+			       struct file_lock **lease)
+{
+	return -EINVAL;
+}
+
+static inline int lease_modify(struct file_lock **before, int arg)
+{
+	return -EINVAL;
+}
+
+static inline int lock_may_read(struct inode *inode, loff_t start,
+				unsigned long len)
+{
+	return 1;
+}
+
+static inline int lock_may_write(struct inode *inode, loff_t start,
+				 unsigned long len)
+{
+	return 1;
+}
+
 #endif /* !CONFIG_FILE_LOCKING */
 
 


