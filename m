Return-Path: <linux-kernel-owner+w=401wt.eu-S1761288AbZATLam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761288AbZATLam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 06:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759136AbZATLaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 06:30:03 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53298 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758733AbZATLaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 06:30:00 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: Alexander Viro <aviro@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/2] vfs: Update fs.h to use inline functions when no file locking set
Date: Tue, 20 Jan 2009 10:29:45 +0000
Message-Id: <1232447386-11758-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1232447386-11758-1-git-send-email-swhiteho@redhat.com>
References: <1232447386-11758-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids various issues which might give rise to compiler warnings
about missing functions and/or unused variable with the previous
macros. This also fixes a bug where one of the macros was returning
0, but it should have been void.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Tested-by: Randy Dunlap <randy.dunlap@oracle.com>

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
 
 
-- 
1.6.0.3

