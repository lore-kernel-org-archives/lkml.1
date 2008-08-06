Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbYHFNN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbYHFNN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbYHFNNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:13:12 -0400
Received: from mail.free-electrons.com ([88.191.46.45]:38096 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbYHFNNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:13:08 -0400
Date: Wed, 6 Aug 2008 15:12:22 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com, Matt Mackall <mpm@selenic.com>,
       matthew@wil.cx, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch 2/4] Configure out file locking features
Message-ID: <20080806151222.618ae70a@surf>
In-Reply-To: <20080804181641.GE25940@fieldses.org>
References: <20080731092703.661994657@free-electrons.com>
	<20080731093220.969460336@free-electrons.com>
	<20080802163848.GB30454@fieldses.org>
	<20080804155237.1f64892d@surf>
	<20080804181641.GE25940@fieldses.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Mon, 4 Aug 2008 14:16:41 -0400,
"J. Bruce Fields" <bfields@fieldses.org> a écrit :

> OK by me, but again, why exactly?  Since you're replacing the locking
> calls they used by stubs that just return errors, in theory nfs, nfsd,
> gfs2, and the rest should still compile and run, just without locking
> support, right?

You're right, that was stupid. Either should I add the Kconfig
dependencies *OR* add the function stubs, not both. The following patch
implements the second solution. I've checked that NFS, CIFS, GFS2,
OCFS2, AFS and FUSE compile correctly. I've tested NFS only, though.

Here is the new patch. Comments and suggestions welcome.

Sincerly,

Thomas

---

Configure out file locking features

This patch adds the CONFIG_FILE_LOCKING option which allows to remove
support for advisory locks. With this patch enabled, the flock()
system call, the F_GETLK, F_SETLK and F_SETLKW operations of fcntl()
and NFS support are disabled. These features are not necessarly needed
on embedded systems. It allows to save ~11 Kb of kernel code and data:

   text	   data	    bss	    dec	    hex	filename
1125436	 118764	 212992	1457192	 163c28	vmlinux.old
1114299	 118564	 212992	1445855	 160fdf	vmlinux
 -11137    -200       0  -11337   -2C49 +/-

This patch has originally been written by Matt Mackall
<mpm@selenic.com>, and is part of the Linux Tiny project.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: matthew@wil.cx
Cc: linux-fsdevel@vger.kernel.org
Cc: mpm@selenic.com
Cc: akpm@linux-foundation.org

---
 fs/Kconfig          |    8 +++++++
 fs/Makefile         |    3 +-
 fs/proc/proc_misc.c |    4 +++
 include/linux/fs.h  |   55 +++++++++++++++++++++++++++++++++++++++++++++-------
 kernel/sys_ni.c     |    1 
 kernel/sysctl.c     |    6 ++++-
 6 files changed, 68 insertions(+), 9 deletions(-)

Index: linuxdev/fs/Kconfig
===================================================================
--- linuxdev.orig/fs/Kconfig
+++ linuxdev/fs/Kconfig
@@ -419,6 +419,14 @@
 	bool
 	default n
 
+config FILE_LOCKING
+	bool "Enable POSIX file locking API" if EMBEDDED
+	default y
+	help
+	  This option enables standard file locking support, required
+          for filesystems like NFS and for the flock() system
+          call. Disabling this option saves about 11k.
+
 source "fs/xfs/Kconfig"
 source "fs/gfs2/Kconfig"
 
Index: linuxdev/fs/Makefile
===================================================================
--- linuxdev.orig/fs/Makefile
+++ linuxdev/fs/Makefile
@@ -7,7 +7,7 @@
 
 obj-y :=	open.o read_write.o file_table.o super.o \
 		char_dev.o stat.o exec.o pipe.o namei.o fcntl.o \
-		ioctl.o readdir.o select.o fifo.o locks.o dcache.o inode.o \
+		ioctl.o readdir.o select.o fifo.o dcache.o inode.o \
 		attr.o bad_inode.o file.o filesystems.o namespace.o aio.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
@@ -27,6 +27,7 @@
 obj-$(CONFIG_SIGNALFD)		+= signalfd.o
 obj-$(CONFIG_TIMERFD)		+= timerfd.o
 obj-$(CONFIG_EVENTFD)		+= eventfd.o
+obj-$(CONFIG_FILE_LOCKING)      += locks.o
 obj-$(CONFIG_COMPAT)		+= compat.o compat_ioctl.o
 
 nfsd-$(CONFIG_NFSD)		:= nfsctl.o
Index: linuxdev/fs/proc/proc_misc.c
===================================================================
--- linuxdev.orig/fs/proc/proc_misc.c
+++ linuxdev/fs/proc/proc_misc.c
@@ -677,6 +677,7 @@
 	return proc_calc_metrics(page, start, off, count, eof, len);
 }
 
+#ifdef CONFIG_FILE_LOCKING
 static int locks_open(struct inode *inode, struct file *filp)
 {
 	return seq_open(filp, &locks_seq_operations);
@@ -688,6 +689,7 @@
 	.llseek		= seq_lseek,
 	.release	= seq_release,
 };
+#endif /* CONFIG_FILE_LOCKING */
 
 static int execdomains_read_proc(char *page, char **start, off_t off,
 				 int count, int *eof, void *data)
@@ -881,7 +883,9 @@
 #ifdef CONFIG_PRINTK
 	proc_create("kmsg", S_IRUSR, NULL, &proc_kmsg_operations);
 #endif
+#ifdef CONFIG_FILE_LOCKING
 	proc_create("locks", 0, NULL, &proc_locks_operations);
+#endif
 	proc_create("devices", 0, NULL, &proc_devinfo_operations);
 	proc_create("cpuinfo", 0, NULL, &proc_cpuinfo_operations);
 #ifdef CONFIG_BLOCK
Index: linuxdev/include/linux/fs.h
===================================================================
--- linuxdev.orig/include/linux/fs.h
+++ linuxdev/include/linux/fs.h
@@ -983,6 +983,13 @@
 
 #include <linux/fcntl.h>
 
+extern void send_sigio(struct fown_struct *fown, int fd, int band);
+
+/* fs/sync.c */
+extern int do_sync_mapping_range(struct address_space *mapping, loff_t offset,
+			loff_t endbyte, unsigned int flags);
+
+#ifdef CONFIG_FILE_LOCKING
 extern int fcntl_getlk(struct file *, struct flock __user *);
 extern int fcntl_setlk(unsigned int, struct file *, unsigned int,
 			struct flock __user *);
@@ -993,14 +1000,9 @@
 			struct flock64 __user *);
 #endif
 
-extern void send_sigio(struct fown_struct *fown, int fd, int band);
 extern int fcntl_setlease(unsigned int fd, struct file *filp, long arg);
 extern int fcntl_getlease(struct file *filp);
 
-/* fs/sync.c */
-extern int do_sync_mapping_range(struct address_space *mapping, loff_t offset,
-			loff_t endbyte, unsigned int flags);
-
 /* fs/locks.c */
 extern void locks_init_lock(struct file_lock *);
 extern void locks_copy_lock(struct file_lock *, struct file_lock *);
@@ -1023,6 +1025,35 @@
 extern int lock_may_read(struct inode *, loff_t start, unsigned long count);
 extern int lock_may_write(struct inode *, loff_t start, unsigned long count);
 extern struct seq_operations locks_seq_operations;
+#else /* !CONFIG_FILE_LOCKING */
+#define fcntl_getlk(a, b) ({ -EINVAL; })
+#define fcntl_setlk(a, b, c, d) ({ -EACCES; })
+#if BITS_PER_LONG == 32
+#define fcntl_getlk64(a, b) ({ -EINVAL; })
+#define fcntl_setlk64(a, b, c, d) ({ -EACCES; })
+#endif
+#define fcntl_setlease(a, b, c) ({ 0; })
+#define fcntl_getlease(a) ({ 0; })
+#define locks_init_lock(a) ({ })
+#define __locks_copy_lock(a, b) ({ })
+#define locks_copy_lock(a, b) ({ })
+#define locks_remove_posix(a, b) ({ })
+#define locks_remove_flock(a) ({ })
+#define posix_test_lock(a, b) ({ 0; })
+#define posix_lock_file(a, b, c) ({ -ENOLCK; })
+#define posix_lock_file_wait(a, b) ({ -ENOLCK; })
+#define posix_unblock_lock(a, b) (-ENOENT)
+#define vfs_test_lock(a, b) ({ 0; })
+#define vfs_lock_file(a, b, c, d) (-ENOLCK)
+#define vfs_cancel_lock(a, b) ({ 0; })
+#define flock_lock_file_wait(a, b) ({ -ENOLCK; })
+#define __break_lease(a, b) ({ 0; })
+#define lease_get_mtime(a, b) ({ })
+#define generic_setlease(a, b, c) ({ -EINVAL; })
+#define lock_may_read(a, b, c) ({ 1; })
+#define lock_may_write(a, b, c) ({ 1; })
+#endif /* !CONFIG_FILE_LOCKING */
+
 
 struct fasync_struct {
 	int	magic;
@@ -1554,9 +1585,12 @@
 /* /sys/fs */
 extern struct kobject *fs_kobj;
 
+extern int rw_verify_area(int, struct file *, loff_t *, size_t);
+
 #define FLOCK_VERIFY_READ  1
 #define FLOCK_VERIFY_WRITE 2
 
+#ifdef CONFIG_FILE_LOCKING
 extern int locks_mandatory_locked(struct inode *);
 extern int locks_mandatory_area(int, struct inode *, struct file *, loff_t, size_t);
 
@@ -1587,8 +1621,6 @@
 	return 0;
 }
 
-extern int rw_verify_area(int, struct file *, loff_t *, size_t);
-
 static inline int locks_verify_truncate(struct inode *inode,
 				    struct file *filp,
 				    loff_t size)
@@ -1609,6 +1641,15 @@
 		return __break_lease(inode, mode);
 	return 0;
 }
+#else /* !CONFIG_FILE_LOCKING */
+#define locks_mandatory_locked(a) ({ 0; })
+#define locks_mandatory_area(a, b, c, d, e) ({ 0; })
+#define __mandatory_lock(a) ({ 0; })
+#define mandatory_lock(a) ({ 0; })
+#define locks_verify_locked(a) ({ 0; })
+#define locks_verify_truncate(a, b, c) ({ 0; })
+#define break_lease(a, b) ({ 0; })
+#endif /* CONFIG_FILE_LOCKING */
 
 /* fs/open.c */
 
Index: linuxdev/kernel/sys_ni.c
===================================================================
--- linuxdev.orig/kernel/sys_ni.c
+++ linuxdev/kernel/sys_ni.c
@@ -125,6 +125,7 @@
 cond_syscall(sys_vm86);
 cond_syscall(compat_sys_ipc);
 cond_syscall(compat_sys_sysctl);
+cond_syscall(sys_flock);
 
 /* arch-specific weak syscall entries */
 cond_syscall(sys_pciconfig_read);
Index: linuxdev/kernel/sysctl.c
===================================================================
--- linuxdev.orig/kernel/sysctl.c
+++ linuxdev/kernel/sysctl.c
@@ -97,7 +97,7 @@
 static int neg_one = -1;
 #endif
 
-#ifdef CONFIG_MMU
+#if defined(CONFIG_MMU) && defined(CONFIG_FILE_LOCKING)
 static int two = 2;
 #endif
 
@@ -1260,6 +1260,7 @@
 		.extra1		= &minolduid,
 		.extra2		= &maxolduid,
 	},
+#ifdef CONFIG_FILE_LOCKING
 	{
 		.ctl_name	= FS_LEASES,
 		.procname	= "leases-enable",
@@ -1268,6 +1269,7 @@
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+#endif
 #ifdef CONFIG_DNOTIFY
 	{
 		.ctl_name	= FS_DIR_NOTIFY,
@@ -1279,6 +1281,7 @@
 	},
 #endif
 #ifdef CONFIG_MMU
+#ifdef CONFIG_FILE_LOCKING
 	{
 		.ctl_name	= FS_LEASE_TIME,
 		.procname	= "lease-break-time",
@@ -1290,6 +1293,7 @@
 		.extra1		= &zero,
 		.extra2		= &two,
 	},
+#endif
 	{
 		.procname	= "aio-nr",
 		.data		= &aio_nr,


-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com
