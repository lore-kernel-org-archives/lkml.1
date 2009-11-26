Return-Path: <linux-kernel-owner+w=401wt.eu-S932481AbZKZDWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481AbZKZDWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 22:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932306AbZKZDWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 22:22:35 -0500
Received: from outbound.icp-qv1-irony-out6.iinet.net.au ([203.59.1.109]:22765
	"EHLO outbound.icp-qv1-irony-out6.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932308AbZKZDWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 22:22:06 -0500
X-IronPort-AV: E=Sophos;i="4.47,290,1257091200"; 
   d="scan'208";a="29940786"
From: Ian Kent <raven@themaw.net>
Subject: [RFC PATCH 2/3] autofs - rename autofs4 module to autofs
To: Sage Weil <sage@newdream.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Andreas Dilger <adilger@sun.com>, Yehuda Saheh <yehuda@newdream.net>,
       Jim Garlick <garlick@llnl.gov>
Date: Thu, 26 Nov 2009 11:22:01 +0800
Message-ID: <20091126032201.5691.53171.stgit@zeus.themaw.net>
In-Reply-To: <20091126030623.5691.33759.stgit@zeus.themaw.net>
References: <20091126030623.5691.33759.stgit@zeus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


---

 fs/autofs/Kconfig      |   12 
 fs/autofs/Makefile     |    2 
 fs/autofs/autofs_i.h   |  327 +++++++++---
 fs/autofs/dev-ioctl.c  |  766 ++++++++++++++++++++++++++++
 fs/autofs/dirhash.c    |  250 ---------
 fs/autofs/expire.c     |  534 ++++++++++++++++++++
 fs/autofs/init.c       |   38 +
 fs/autofs/inode.c      |  419 +++++++++++-----
 fs/autofs/root.c       | 1294 ++++++++++++++++++++++++++++++++++--------------
 fs/autofs/symlink.c    |   16 -
 fs/autofs/waitq.c      |  480 +++++++++++++++---
 fs/autofs4/Kconfig     |   10 
 fs/autofs4/Makefile    |   10 
 fs/autofs4/autofs_i.h  |  304 -----------
 fs/autofs4/dev-ioctl.c |  766 ----------------------------
 fs/autofs4/expire.c    |  534 --------------------
 fs/autofs4/init.c      |   48 --
 fs/autofs4/inode.c     |  473 ------------------
 fs/autofs4/root.c      | 1116 -----------------------------------------
 fs/autofs4/symlink.c   |   22 -
 fs/autofs4/waitq.c     |  525 -------------------
 21 files changed, 3195 insertions(+), 4751 deletions(-)
 create mode 100644 fs/autofs/dev-ioctl.c
 delete mode 100644 fs/autofs/dirhash.c
 create mode 100644 fs/autofs/expire.c
 delete mode 100644 fs/autofs4/autofs_i.h
 delete mode 100644 fs/autofs4/dev-ioctl.c
 delete mode 100644 fs/autofs4/expire.c
 delete mode 100644 fs/autofs4/init.c
 delete mode 100644 fs/autofs4/inode.c
 delete mode 100644 fs/autofs4/root.c
 delete mode 100644 fs/autofs4/symlink.c
 delete mode 100644 fs/autofs4/waitq.c

diff --git a/fs/autofs/Kconfig b/fs/autofs/Kconfig
index 5f3bea9..12bf6b5 100644
--- a/fs/autofs/Kconfig
+++ b/fs/autofs/Kconfig
@@ -1,18 +1,14 @@
 config AUTOFS_FS
-	tristate "Kernel automounter support"
+	tristate "Kernel automounter support (supports v3, v4 and v5)"
 	help
 	  The automounter is a tool to automatically mount remote file systems
 	  on demand. This implementation is partially kernel-based to reduce
 	  overhead in the already-mounted case; this is unlike the BSD
 	  automounter (amd), which is a pure user space daemon.
 
-	  To use the automounter you need the user-space tools from the autofs
-	  package; you can find the location in <file:Documentation/Changes>.
-	  You also want to answer Y to "NFS file system support", below.
-
-	  If you want to use the newer version of the automounter with more
-	  features, say N here and say Y to "Kernel automounter v4 support",
-	  below.
+	  To use the automounter you need the user-space tools from
+	  <ftp://ftp.kernel.org/pub/linux/daemons/autofs/>; you also want
+	  to answer Y to "NFS file system support", below.
 
 	  To compile this support as a module, choose M here: the module will be
 	  called autofs.
diff --git a/fs/autofs/Makefile b/fs/autofs/Makefile
index 453a60f..43fedde 100644
--- a/fs/autofs/Makefile
+++ b/fs/autofs/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_AUTOFS_FS) += autofs.o
 
-autofs-objs := dirhash.o init.o inode.o root.o symlink.o waitq.o
+autofs-objs := init.o inode.o root.o symlink.o waitq.o expire.o dev-ioctl.o
diff --git a/fs/autofs/autofs_i.h b/fs/autofs/autofs_i.h
index 901a3e6..b4a0d82 100644
--- a/fs/autofs/autofs_i.h
+++ b/fs/autofs/autofs_i.h
@@ -1,8 +1,6 @@
-/* -*- linux-c -*- ------------------------------------------------------- *
- *   
- * linux/fs/autofs/autofs_i.h
- *
+/*
  *   Copyright 1997-1998 Transmeta Corporation - All Rights Reserved
+ *   Copyright 2005-2006 Ian Kent <raven@themaw.net>
  *
  * This file is part of the Linux kernel and is made available under
  * the terms of the GNU General Public License, version 2, or at your
@@ -12,154 +10,295 @@
 
 /* Internal header file for autofs */
 
-#include <linux/auto_fs.h>
+#include <linux/auto_fs4.h>
+#include <linux/auto_dev-ioctl.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
 
 /* This is the range of ioctl() numbers we claim as ours */
 #define AUTOFS_IOC_FIRST     AUTOFS_IOC_READY
 #define AUTOFS_IOC_COUNT     32
 
+#define AUTOFS_DEV_IOCTL_IOC_FIRST	(AUTOFS_DEV_IOCTL_VERSION)
+#define AUTOFS_DEV_IOCTL_IOC_COUNT	(AUTOFS_IOC_COUNT - 11)
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/string.h>
 #include <linux/wait.h>
-#include <linux/dcache.h>
-#include <linux/namei.h>
-#include <linux/mount.h>
 #include <linux/sched.h>
-
+#include <linux/mount.h>
+#include <linux/namei.h>
 #include <asm/current.h>
 #include <asm/uaccess.h>
 
+/* #define DEBUG */
+
 #ifdef DEBUG
-#define DPRINTK(D) (printk D)
+#define DPRINTK(fmt, args...)				\
+do {							\
+	printk(KERN_DEBUG "pid %d: %s: " fmt "\n",	\
+		current->pid, __func__, ##args);	\
+} while (0)
 #else
-#define DPRINTK(D) ((void)0)
+#define DPRINTK(fmt, args...) do {} while (0)
 #endif
 
-/*
- * If the daemon returns a negative response (AUTOFS_IOC_FAIL) then the
- * kernel will keep the negative response cached for up to the time given
- * here, although the time can be shorter if the kernel throws the dcache
- * entry away.  This probably should be settable from user space.
- */
-#define AUTOFS_NEGATIVE_TIMEOUT (60*HZ)	/* 1 minute */
-
-/* Structures associated with the root directory hash table */
-
-#define AUTOFS_HASH_SIZE 67
-
-struct autofs_dir_ent {
-	int hash;
-	char *name;
-	int len;
-	ino_t ino;
-	struct dentry *dentry;
-	/* Linked list of entries */
-	struct autofs_dir_ent *next;
-	struct autofs_dir_ent **back;
-	/* The following entries are for the expiry system */
-	unsigned long last_usage;
-	struct list_head exp;
+#define AUTOFS_WARN(fmt, args...)			\
+do {							\
+	printk(KERN_WARNING "pid %d: %s: " fmt "\n",	\
+		current->pid, __func__, ##args);	\
+} while (0)
+
+#define AUTOFS_ERROR(fmt, args...)			\
+do {							\
+	printk(KERN_ERR "pid %d: %s: " fmt "\n",	\
+		current->pid, __func__, ##args);	\
+} while (0)
+
+struct rehash_entry {
+	struct task_struct *task;
+	struct list_head list;
 };
 
-struct autofs_dirhash {
-	struct autofs_dir_ent *h[AUTOFS_HASH_SIZE];
-	struct list_head expiry_head;
+/* Unified info structure.  This is pointed to by both the dentry and
+   inode structures.  Each file in the filesystem has an instance of this
+   structure.  It holds a reference to the dentry, so dentries are never
+   flushed while the file exists.  All name lookups are dealt with at the
+   dentry level, although the filesystem can interfere in the validation
+   process.  Readdir is implemented by traversing the dentry lists. */
+struct autofs_info {
+	struct dentry	*dentry;
+	struct inode	*inode;
+
+	int		flags;
+
+	struct completion expire_complete;
+
+	struct list_head active;
+	int active_count;
+	struct list_head rehash_list;
+
+	struct list_head expiring;
+
+	struct autofs_sb_info *sbi;
+	unsigned long last_used;
+	atomic_t count;
+
+	uid_t uid;
+	gid_t gid;
+
+	mode_t	mode;
+	size_t	size;
+
+	void (*free)(struct autofs_info *);
+	union {
+		const char *symlink;
+	} u;
 };
 
+#define AUTOFS_INF_EXPIRING	(1<<0) /* dentry in the process of expiring */
+#define AUTOFS_INF_MOUNTPOINT	(1<<1) /* mountpoint status for direct expire */
+#define AUTOFS_INF_PENDING	(1<<2) /* dentry pending mount */
+#define AUTOFS_INF_REHASH	(1<<3) /* dentry in transit to ->lookup() */
+
 struct autofs_wait_queue {
 	wait_queue_head_t queue;
 	struct autofs_wait_queue *next;
 	autofs_wqt_t wait_queue_token;
 	/* We use the following to see what we are waiting for */
-	int hash;
-	int len;
-	char *name;
+	struct qstr name;
+	u32 dev;
+	u64 ino;
+	uid_t uid;
+	gid_t gid;
+	pid_t pid;
+	pid_t tgid;
 	/* This is for status reporting upon return */
 	int status;
-	int wait_ctr;
+	unsigned int wait_ctr;
 };
 
-struct autofs_symlink {
-	char *data;
-	int len;
-	time_t mtime;
-};
-
-#define AUTOFS_MAX_SYMLINKS 256
-
-#define AUTOFS_ROOT_INO      1
-#define AUTOFS_FIRST_SYMLINK 2
-#define AUTOFS_FIRST_DIR_INO (AUTOFS_FIRST_SYMLINK+AUTOFS_MAX_SYMLINKS)
-
-#define AUTOFS_SYMLINK_BITMAP_LEN \
-	((AUTOFS_MAX_SYMLINKS+((sizeof(long)*1)-1))/(sizeof(long)*8))
-
 #define AUTOFS_SBI_MAGIC 0x6d4a556d
 
 struct autofs_sb_info {
 	u32 magic;
+	int pipefd;
 	struct file *pipe;
-	struct pid *oz_pgrp;
+	pid_t oz_pgrp;
 	int catatonic;
-	struct super_block *sb;
+	int version;
+	int sub_version;
+	int min_proto;
+	int max_proto;
 	unsigned long exp_timeout;
-	ino_t next_dir_ino;
+	unsigned int type;
+	int reghost_enabled;
+	int needs_reghost;
+	struct super_block *sb;
+	struct mutex wq_mutex;
+	spinlock_t fs_lock;
 	struct autofs_wait_queue *queues; /* Wait queue pointer */
-	struct autofs_dirhash dirhash; /* Root directory hash */
-	struct autofs_symlink symlink[AUTOFS_MAX_SYMLINKS];
-	unsigned long symlink_bitmap[AUTOFS_SYMLINK_BITMAP_LEN];
+	spinlock_t lookup_lock;
+	struct list_head active_list;
+	struct list_head expiring_list;
 };
 
-static inline struct autofs_sb_info *autofs_sbi(struct super_block *sb)
+static inline struct autofs_sb_info *autofs4_sbi(struct super_block *sb)
 {
 	return (struct autofs_sb_info *)(sb->s_fs_info);
 }
 
-/* autofs_oz_mode(): do we see the man behind the curtain?  (The
-   processes which do manipulations for us in user space sees the raw
-   filesystem without "magic".) */
+static inline struct autofs_info *autofs4_dentry_ino(struct dentry *dentry)
+{
+	return (struct autofs_info *)(dentry->d_fsdata);
+}
 
-static inline int autofs_oz_mode(struct autofs_sb_info *sbi) {
-	return sbi->catatonic || task_pgrp(current) == sbi->oz_pgrp;
+/*
+ * autofs4_oz_mode(): do we see the man behind the curtain?  (The
+ * processes which do manipulations for us in user space sees the raw
+ * filesystem without "magic".)
+ */
+static inline int autofs4_oz_mode(struct autofs_sb_info *sbi)
+{
+	return sbi->catatonic || task_pgrp_nr(current) == sbi->oz_pgrp;
 }
 
-/* Hash operations */
+/* Does a dentry have some pending activity? */
+static inline int autofs4_ispending(struct dentry *dentry)
+{
+	struct autofs_info *inf = autofs4_dentry_ino(dentry);
+
+	if (inf->flags & AUTOFS_INF_PENDING)
+		return 1;
+
+	if (inf->flags & AUTOFS_INF_EXPIRING)
+		return 1;
 
-void autofs_initialize_hash(struct autofs_dirhash *);
-struct autofs_dir_ent *autofs_hash_lookup(const struct autofs_dirhash *,struct qstr *);
-void autofs_hash_insert(struct autofs_dirhash *,struct autofs_dir_ent *);
-void autofs_hash_delete(struct autofs_dir_ent *);
-struct autofs_dir_ent *autofs_hash_enum(const struct autofs_dirhash *,off_t *,struct autofs_dir_ent *);
-void autofs_hash_dputall(struct autofs_dirhash *);
-void autofs_hash_nuke(struct autofs_sb_info *);
+	return 0;
+}
 
-/* Expiration-handling functions */
+static inline void autofs4_copy_atime(struct file *src, struct file *dst)
+{
+	dst->f_path.dentry->d_inode->i_atime =
+		src->f_path.dentry->d_inode->i_atime;
+	return;
+}
 
-void autofs_update_usage(struct autofs_dirhash *,struct autofs_dir_ent *);
-struct autofs_dir_ent *autofs_expire(struct super_block *,struct autofs_sb_info *, struct vfsmount *mnt);
+struct inode *autofs4_get_inode(struct super_block *, struct autofs_info *);
+void autofs4_free_ino(struct autofs_info *);
+
+/* Expiration */
+int is_autofs4_dentry(struct dentry *);
+int autofs4_expire_wait(struct dentry *dentry);
+int autofs4_expire_run(struct super_block *, struct vfsmount *,
+			struct autofs_sb_info *,
+			struct autofs_packet_expire __user *);
+int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
+			    struct autofs_sb_info *sbi, int when);
+int autofs4_expire_multi(struct super_block *, struct vfsmount *,
+			struct autofs_sb_info *, int __user *);
+struct dentry *autofs4_expire_direct(struct super_block *sb,
+				     struct vfsmount *mnt,
+				     struct autofs_sb_info *sbi, int how);
+struct dentry *autofs4_expire_indirect(struct super_block *sb,
+				       struct vfsmount *mnt,
+				       struct autofs_sb_info *sbi, int how);
+
+/* Device node initialization */
+
+int autofs_dev_ioctl_init(void);
+void autofs_dev_ioctl_exit(void);
 
 /* Operations structures */
 
-extern const struct inode_operations autofs_root_inode_operations;
-extern const struct inode_operations autofs_symlink_inode_operations;
-extern const struct file_operations autofs_root_operations;
+extern const struct inode_operations autofs4_symlink_inode_operations;
+extern const struct inode_operations autofs4_dir_inode_operations;
+extern const struct inode_operations autofs4_root_inode_operations;
+extern const struct inode_operations autofs4_indirect_root_inode_operations;
+extern const struct inode_operations autofs4_direct_root_inode_operations;
+extern const struct file_operations autofs4_dir_operations;
+extern const struct file_operations autofs4_root_operations;
 
 /* Initializing function */
 
-int autofs_fill_super(struct super_block *, void *, int);
-void autofs_kill_sb(struct super_block *sb);
-struct inode *autofs_iget(struct super_block *, unsigned long);
+int autofs4_fill_super(struct super_block *, void *, int);
+struct autofs_info *autofs4_init_ino(struct autofs_info *,
+				     struct autofs_sb_info *, mode_t);
 
 /* Queue management functions */
 
-int autofs_wait(struct autofs_sb_info *,struct qstr *);
-int autofs_wait_release(struct autofs_sb_info *,autofs_wqt_t,int);
-void autofs_catatonic_mode(struct autofs_sb_info *);
+int autofs4_wait(struct autofs_sb_info *, struct dentry *, enum autofs_notify);
+int autofs4_wait_release(struct autofs_sb_info *, autofs_wqt_t, int);
+void autofs4_catatonic_mode(struct autofs_sb_info *);
 
-#ifdef DEBUG
-void autofs_say(const char *name, int len);
-#else
-#define autofs_say(n,l) ((void)0)
-#endif
+static inline int autofs4_follow_mount(struct path *path)
+{
+	int res = 0;
+
+	while (d_mountpoint(path->dentry)) {
+		int followed = follow_down(path);
+		if (!followed)
+			break;
+		res = 1;
+	}
+	return res;
+}
+
+static inline u32 autofs4_get_dev(struct autofs_sb_info *sbi)
+{
+	return new_encode_dev(sbi->sb->s_dev);
+}
+
+static inline u64 autofs4_get_ino(struct autofs_sb_info *sbi)
+{
+	return sbi->sb->s_root->d_inode->i_ino;
+}
+
+static inline int simple_positive(struct dentry *dentry)
+{
+	return dentry->d_inode && !d_unhashed(dentry);
+}
+
+static inline int __simple_empty(struct dentry *dentry)
+{
+	struct dentry *child;
+	int ret = 0;
+
+	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child)
+		if (simple_positive(child))
+			goto out;
+	ret = 1;
+out:
+	return ret;
+}
+
+static inline void autofs4_add_expiring(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	if (ino) {
+		spin_lock(&sbi->lookup_lock);
+		if (list_empty(&ino->expiring))
+			list_add(&ino->expiring, &sbi->expiring_list);
+		spin_unlock(&sbi->lookup_lock);
+	}
+	return;
+}
+
+static inline void autofs4_del_expiring(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	if (ino) {
+		spin_lock(&sbi->lookup_lock);
+		if (!list_empty(&ino->expiring))
+			list_del_init(&ino->expiring);
+		spin_unlock(&sbi->lookup_lock);
+	}
+	return;
+}
+
+void autofs4_dentry_release(struct dentry *);
+extern void autofs4_kill_sb(struct super_block *);
diff --git a/fs/autofs/dev-ioctl.c b/fs/autofs/dev-ioctl.c
new file mode 100644
index 0000000..a0dcc5b
--- /dev/null
+++ b/fs/autofs/dev-ioctl.c
@@ -0,0 +1,766 @@
+/*
+ * Copyright 2008 Red Hat, Inc. All rights reserved.
+ * Copyright 2008 Ian Kent <raven@themaw.net>
+ *
+ * This file is part of the Linux kernel and is made available under
+ * the terms of the GNU General Public License, version 2, or at your
+ * option, any later version, incorporated herein by reference.
+ */
+
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+#include <linux/miscdevice.h>
+#include <linux/init.h>
+#include <linux/wait.h>
+#include <linux/namei.h>
+#include <linux/fcntl.h>
+#include <linux/file.h>
+#include <linux/fdtable.h>
+#include <linux/sched.h>
+#include <linux/compat.h>
+#include <linux/syscalls.h>
+#include <linux/magic.h>
+#include <linux/dcache.h>
+#include <linux/uaccess.h>
+
+#include "autofs_i.h"
+
+/*
+ * This module implements an interface for routing autofs ioctl control
+ * commands via a miscellaneous device file.
+ *
+ * The alternate interface is needed because we need to be able open
+ * an ioctl file descriptor on an autofs mount that may be covered by
+ * another mount. This situation arises when starting automount(8)
+ * or other user space daemon which uses direct mounts or offset
+ * mounts (used for autofs lazy mount/umount of nested mount trees),
+ * which have been left busy at at service shutdown.
+ */
+
+#define AUTOFS_DEV_IOCTL_SIZE	sizeof(struct autofs_dev_ioctl)
+
+typedef int (*ioctl_fn)(struct file *, struct autofs_sb_info *,
+			struct autofs_dev_ioctl *);
+
+static int check_name(const char *name)
+{
+	if (!strchr(name, '/'))
+		return -EINVAL;
+	return 0;
+}
+
+/*
+ * Check a string doesn't overrun the chunk of
+ * memory we copied from user land.
+ */
+static int invalid_str(char *str, size_t size)
+{
+	if (memchr(str, 0, size))
+		return 0;
+	return -EINVAL;
+}
+
+/*
+ * Check that the user compiled against correct version of autofs
+ * misc device code.
+ *
+ * As well as checking the version compatibility this always copies
+ * the kernel interface version out.
+ */
+static int check_dev_ioctl_version(int cmd, struct autofs_dev_ioctl *param)
+{
+	int err = 0;
+
+	if ((AUTOFS_DEV_IOCTL_VERSION_MAJOR != param->ver_major) ||
+	    (AUTOFS_DEV_IOCTL_VERSION_MINOR < param->ver_minor)) {
+		AUTOFS_WARN("ioctl control interface version mismatch: "
+		     "kernel(%u.%u), user(%u.%u), cmd(%d)",
+		     AUTOFS_DEV_IOCTL_VERSION_MAJOR,
+		     AUTOFS_DEV_IOCTL_VERSION_MINOR,
+		     param->ver_major, param->ver_minor, cmd);
+		err = -EINVAL;
+	}
+
+	/* Fill in the kernel version. */
+	param->ver_major = AUTOFS_DEV_IOCTL_VERSION_MAJOR;
+	param->ver_minor = AUTOFS_DEV_IOCTL_VERSION_MINOR;
+
+	return err;
+}
+
+/*
+ * Copy parameter control struct, including a possible path allocated
+ * at the end of the struct.
+ */
+static struct autofs_dev_ioctl *copy_dev_ioctl(struct autofs_dev_ioctl __user *in)
+{
+	struct autofs_dev_ioctl tmp, *ads;
+
+	if (copy_from_user(&tmp, in, sizeof(tmp)))
+		return ERR_PTR(-EFAULT);
+
+	if (tmp.size < sizeof(tmp))
+		return ERR_PTR(-EINVAL);
+
+	ads = kmalloc(tmp.size, GFP_KERNEL);
+	if (!ads)
+		return ERR_PTR(-ENOMEM);
+
+	if (copy_from_user(ads, in, tmp.size)) {
+		kfree(ads);
+		return ERR_PTR(-EFAULT);
+	}
+
+	return ads;
+}
+
+static inline void free_dev_ioctl(struct autofs_dev_ioctl *param)
+{
+	kfree(param);
+	return;
+}
+
+/*
+ * Check sanity of parameter control fields and if a path is present
+ * check that it is terminated and contains at least one "/".
+ */
+static int validate_dev_ioctl(int cmd, struct autofs_dev_ioctl *param)
+{
+	int err;
+
+	err = check_dev_ioctl_version(cmd, param);
+	if (err) {
+		AUTOFS_WARN("invalid device control module version "
+		     "supplied for cmd(0x%08x)", cmd);
+		goto out;
+	}
+
+	if (param->size > sizeof(*param)) {
+		err = invalid_str(param->path, param->size - sizeof(*param));
+		if (err) {
+			AUTOFS_WARN(
+			  "path string terminator missing for cmd(0x%08x)",
+			  cmd);
+			goto out;
+		}
+
+		err = check_name(param->path);
+		if (err) {
+			AUTOFS_WARN("invalid path supplied for cmd(0x%08x)",
+				    cmd);
+			goto out;
+		}
+	}
+
+	err = 0;
+out:
+	return err;
+}
+
+/*
+ * Get the autofs super block info struct from the file opened on
+ * the autofs mount point.
+ */
+static struct autofs_sb_info *autofs_dev_ioctl_sbi(struct file *f)
+{
+	struct autofs_sb_info *sbi = NULL;
+	struct inode *inode;
+
+	if (f) {
+		inode = f->f_path.dentry->d_inode;
+		sbi = autofs4_sbi(inode->i_sb);
+	}
+	return sbi;
+}
+
+/* Return autofs module protocol version */
+static int autofs_dev_ioctl_protover(struct file *fp,
+				     struct autofs_sb_info *sbi,
+				     struct autofs_dev_ioctl *param)
+{
+	param->protover.version = sbi->version;
+	return 0;
+}
+
+/* Return autofs module protocol sub version */
+static int autofs_dev_ioctl_protosubver(struct file *fp,
+					struct autofs_sb_info *sbi,
+					struct autofs_dev_ioctl *param)
+{
+	param->protosubver.sub_version = sbi->sub_version;
+	return 0;
+}
+
+static int find_autofs_mount(const char *pathname,
+			     struct path *res,
+			     int test(struct path *path, void *data),
+			     void *data)
+{
+	struct path path;
+	int err = kern_path(pathname, 0, &path);
+	if (err)
+		return err;
+	err = -ENOENT;
+	while (path.dentry == path.mnt->mnt_root) {
+		if (path.mnt->mnt_sb->s_magic == AUTOFS_SUPER_MAGIC) {
+			if (test(&path, data)) {
+				path_get(&path);
+				if (!err) /* already found some */
+					path_put(res);
+				*res = path;
+				err = 0;
+			}
+		}
+		if (!follow_up(&path))
+			break;
+	}
+	path_put(&path);
+	return err;
+}
+
+static int test_by_dev(struct path *path, void *p)
+{
+	return path->mnt->mnt_sb->s_dev == *(dev_t *)p;
+}
+
+static int test_by_type(struct path *path, void *p)
+{
+	struct autofs_info *ino = autofs4_dentry_ino(path->dentry);
+	return ino && ino->sbi->type & *(unsigned *)p;
+}
+
+static void autofs_dev_ioctl_fd_install(unsigned int fd, struct file *file)
+{
+	struct files_struct *files = current->files;
+	struct fdtable *fdt;
+
+	spin_lock(&files->file_lock);
+	fdt = files_fdtable(files);
+	BUG_ON(fdt->fd[fd] != NULL);
+	rcu_assign_pointer(fdt->fd[fd], file);
+	FD_SET(fd, fdt->close_on_exec);
+	spin_unlock(&files->file_lock);
+}
+
+
+/*
+ * Open a file descriptor on the autofs mount point corresponding
+ * to the given path and device number (aka. new_encode_dev(sb->s_dev)).
+ */
+static int autofs_dev_ioctl_open_mountpoint(const char *name, dev_t devid)
+{
+	int err, fd;
+
+	fd = get_unused_fd();
+	if (likely(fd >= 0)) {
+		struct file *filp;
+		struct path path;
+
+		err = find_autofs_mount(name, &path, test_by_dev, &devid);
+		if (err)
+			goto out;
+
+		/*
+		 * Find autofs super block that has the device number
+		 * corresponding to the autofs fs we want to open.
+		 */
+
+		filp = dentry_open(path.dentry, path.mnt, O_RDONLY,
+				   current_cred());
+		if (IS_ERR(filp)) {
+			err = PTR_ERR(filp);
+			goto out;
+		}
+
+		autofs_dev_ioctl_fd_install(fd, filp);
+	}
+
+	return fd;
+
+out:
+	put_unused_fd(fd);
+	return err;
+}
+
+/* Open a file descriptor on an autofs mount point */
+static int autofs_dev_ioctl_openmount(struct file *fp,
+				      struct autofs_sb_info *sbi,
+				      struct autofs_dev_ioctl *param)
+{
+	const char *path;
+	dev_t devid;
+	int err, fd;
+
+	/* param->path has already been checked */
+	if (!param->openmount.devid)
+		return -EINVAL;
+
+	param->ioctlfd = -1;
+
+	path = param->path;
+	devid = new_decode_dev(param->openmount.devid);
+
+	err = 0;
+	fd = autofs_dev_ioctl_open_mountpoint(path, devid);
+	if (unlikely(fd < 0)) {
+		err = fd;
+		goto out;
+	}
+
+	param->ioctlfd = fd;
+out:
+	return err;
+}
+
+/* Close file descriptor allocated above (user can also use close(2)). */
+static int autofs_dev_ioctl_closemount(struct file *fp,
+				       struct autofs_sb_info *sbi,
+				       struct autofs_dev_ioctl *param)
+{
+	return sys_close(param->ioctlfd);
+}
+
+/*
+ * Send "ready" status for an existing wait (either a mount or an expire
+ * request).
+ */
+static int autofs_dev_ioctl_ready(struct file *fp,
+				  struct autofs_sb_info *sbi,
+				  struct autofs_dev_ioctl *param)
+{
+	autofs_wqt_t token;
+
+	token = (autofs_wqt_t) param->ready.token;
+	return autofs4_wait_release(sbi, token, 0);
+}
+
+/*
+ * Send "fail" status for an existing wait (either a mount or an expire
+ * request).
+ */
+static int autofs_dev_ioctl_fail(struct file *fp,
+				 struct autofs_sb_info *sbi,
+				 struct autofs_dev_ioctl *param)
+{
+	autofs_wqt_t token;
+	int status;
+
+	token = (autofs_wqt_t) param->fail.token;
+	status = param->fail.status ? param->fail.status : -ENOENT;
+	return autofs4_wait_release(sbi, token, status);
+}
+
+/*
+ * Set the pipe fd for kernel communication to the daemon.
+ *
+ * Normally this is set at mount using an option but if we
+ * are reconnecting to a busy mount then we need to use this
+ * to tell the autofs mount about the new kernel pipe fd. In
+ * order to protect mounts against incorrectly setting the
+ * pipefd we also require that the autofs mount be catatonic.
+ *
+ * This also sets the process group id used to identify the
+ * controlling process (eg. the owning automount(8) daemon).
+ */
+static int autofs_dev_ioctl_setpipefd(struct file *fp,
+				      struct autofs_sb_info *sbi,
+				      struct autofs_dev_ioctl *param)
+{
+	int pipefd;
+	int err = 0;
+
+	if (param->setpipefd.pipefd == -1)
+		return -EINVAL;
+
+	pipefd = param->setpipefd.pipefd;
+
+	mutex_lock(&sbi->wq_mutex);
+	if (!sbi->catatonic) {
+		mutex_unlock(&sbi->wq_mutex);
+		return -EBUSY;
+	} else {
+		struct file *pipe = fget(pipefd);
+		if (!pipe->f_op || !pipe->f_op->write) {
+			err = -EPIPE;
+			fput(pipe);
+			goto out;
+		}
+		sbi->oz_pgrp = task_pgrp_nr(current);
+		sbi->pipefd = pipefd;
+		sbi->pipe = pipe;
+		sbi->catatonic = 0;
+	}
+out:
+	mutex_unlock(&sbi->wq_mutex);
+	return err;
+}
+
+/*
+ * Make the autofs mount point catatonic, no longer responsive to
+ * mount requests. Also closes the kernel pipe file descriptor.
+ */
+static int autofs_dev_ioctl_catatonic(struct file *fp,
+				      struct autofs_sb_info *sbi,
+				      struct autofs_dev_ioctl *param)
+{
+	autofs4_catatonic_mode(sbi);
+	return 0;
+}
+
+/* Set the autofs mount timeout */
+static int autofs_dev_ioctl_timeout(struct file *fp,
+				    struct autofs_sb_info *sbi,
+				    struct autofs_dev_ioctl *param)
+{
+	unsigned long timeout;
+
+	timeout = param->timeout.timeout;
+	param->timeout.timeout = sbi->exp_timeout / HZ;
+	sbi->exp_timeout = timeout * HZ;
+	return 0;
+}
+
+/*
+ * Return the uid and gid of the last request for the mount
+ *
+ * When reconstructing an autofs mount tree with active mounts
+ * we need to re-connect to mounts that may have used the original
+ * process uid and gid (or string variations of them) for mount
+ * lookups within the map entry.
+ */
+static int autofs_dev_ioctl_requester(struct file *fp,
+				      struct autofs_sb_info *sbi,
+				      struct autofs_dev_ioctl *param)
+{
+	struct autofs_info *ino;
+	struct path path;
+	dev_t devid;
+	int err = -ENOENT;
+
+	if (param->size <= sizeof(*param)) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	devid = sbi->sb->s_dev;
+
+	param->requester.uid = param->requester.gid = -1;
+
+	err = find_autofs_mount(param->path, &path, test_by_dev, &devid);
+	if (err)
+		goto out;
+
+	ino = autofs4_dentry_ino(path.dentry);
+	if (ino) {
+		err = 0;
+		autofs4_expire_wait(path.dentry);
+		spin_lock(&sbi->fs_lock);
+		param->requester.uid = ino->uid;
+		param->requester.gid = ino->gid;
+		spin_unlock(&sbi->fs_lock);
+	}
+	path_put(&path);
+out:
+	return err;
+}
+
+/*
+ * Call repeatedly until it returns -EAGAIN, meaning there's nothing
+ * more that can be done.
+ */
+static int autofs_dev_ioctl_expire(struct file *fp,
+				   struct autofs_sb_info *sbi,
+				   struct autofs_dev_ioctl *param)
+{
+	struct vfsmount *mnt;
+	int how;
+
+	how = param->expire.how;
+	mnt = fp->f_path.mnt;
+
+	return autofs4_do_expire_multi(sbi->sb, mnt, sbi, how);
+}
+
+/* Check if autofs mount point is in use */
+static int autofs_dev_ioctl_askumount(struct file *fp,
+				      struct autofs_sb_info *sbi,
+				      struct autofs_dev_ioctl *param)
+{
+	param->askumount.may_umount = 0;
+	if (may_umount(fp->f_path.mnt))
+		param->askumount.may_umount = 1;
+	return 0;
+}
+
+/*
+ * Check if the given path is a mountpoint.
+ *
+ * If we are supplied with the file descriptor of an autofs
+ * mount we're looking for a specific mount. In this case
+ * the path is considered a mountpoint if it is itself a
+ * mountpoint or contains a mount, such as a multi-mount
+ * without a root mount. In this case we return 1 if the
+ * path is a mount point and the super magic of the covering
+ * mount if there is one or 0 if it isn't a mountpoint.
+ *
+ * If we aren't supplied with a file descriptor then we
+ * lookup the nameidata of the path and check if it is the
+ * root of a mount. If a type is given we are looking for
+ * a particular autofs mount and if we don't find a match
+ * we return fail. If the located nameidata path is the
+ * root of a mount we return 1 along with the super magic
+ * of the mount or 0 otherwise.
+ *
+ * In both cases the the device number (as returned by
+ * new_encode_dev()) is also returned.
+ */
+static int autofs_dev_ioctl_ismountpoint(struct file *fp,
+					 struct autofs_sb_info *sbi,
+					 struct autofs_dev_ioctl *param)
+{
+	struct path path;
+	const char *name;
+	unsigned int type;
+	unsigned int devid, magic;
+	int err = -ENOENT;
+
+	if (param->size <= sizeof(*param)) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	name = param->path;
+	type = param->ismountpoint.in.type;
+
+	param->ismountpoint.out.devid = devid = 0;
+	param->ismountpoint.out.magic = magic = 0;
+
+	if (!fp || param->ioctlfd == -1) {
+		if (autofs_type_any(type))
+			err = kern_path(name, LOOKUP_FOLLOW, &path);
+		else
+			err = find_autofs_mount(name, &path, test_by_type, &type);
+		if (err)
+			goto out;
+		devid = new_encode_dev(path.mnt->mnt_sb->s_dev);
+		err = 0;
+		if (path.dentry->d_inode &&
+		    path.mnt->mnt_root == path.dentry) {
+			err = 1;
+			magic = path.dentry->d_inode->i_sb->s_magic;
+		}
+	} else {
+		dev_t dev = sbi->sb->s_dev;
+
+		err = find_autofs_mount(name, &path, test_by_dev, &dev);
+		if (err)
+			goto out;
+
+		devid = new_encode_dev(dev);
+
+		err = have_submounts(path.dentry);
+
+		if (path.mnt->mnt_mountpoint != path.mnt->mnt_root) {
+			if (follow_down(&path))
+				magic = path.mnt->mnt_sb->s_magic;
+		}
+	}
+
+	param->ismountpoint.out.devid = devid;
+	param->ismountpoint.out.magic = magic;
+	path_put(&path);
+out:
+	return err;
+}
+
+/*
+ * Our range of ioctl numbers isn't 0 based so we need to shift
+ * the array index by _IOC_NR(AUTOFS_CTL_IOC_FIRST) for the table
+ * lookup.
+ */
+#define cmd_idx(cmd)	(cmd - _IOC_NR(AUTOFS_DEV_IOCTL_IOC_FIRST))
+
+static ioctl_fn lookup_dev_ioctl(unsigned int cmd)
+{
+	static struct {
+		int cmd;
+		ioctl_fn fn;
+	} _ioctls[] = {
+		{cmd_idx(AUTOFS_DEV_IOCTL_VERSION_CMD), NULL},
+		{cmd_idx(AUTOFS_DEV_IOCTL_PROTOVER_CMD),
+			 autofs_dev_ioctl_protover},
+		{cmd_idx(AUTOFS_DEV_IOCTL_PROTOSUBVER_CMD),
+			 autofs_dev_ioctl_protosubver},
+		{cmd_idx(AUTOFS_DEV_IOCTL_OPENMOUNT_CMD),
+			 autofs_dev_ioctl_openmount},
+		{cmd_idx(AUTOFS_DEV_IOCTL_CLOSEMOUNT_CMD),
+			 autofs_dev_ioctl_closemount},
+		{cmd_idx(AUTOFS_DEV_IOCTL_READY_CMD),
+			 autofs_dev_ioctl_ready},
+		{cmd_idx(AUTOFS_DEV_IOCTL_FAIL_CMD),
+			 autofs_dev_ioctl_fail},
+		{cmd_idx(AUTOFS_DEV_IOCTL_SETPIPEFD_CMD),
+			 autofs_dev_ioctl_setpipefd},
+		{cmd_idx(AUTOFS_DEV_IOCTL_CATATONIC_CMD),
+			 autofs_dev_ioctl_catatonic},
+		{cmd_idx(AUTOFS_DEV_IOCTL_TIMEOUT_CMD),
+			 autofs_dev_ioctl_timeout},
+		{cmd_idx(AUTOFS_DEV_IOCTL_REQUESTER_CMD),
+			 autofs_dev_ioctl_requester},
+		{cmd_idx(AUTOFS_DEV_IOCTL_EXPIRE_CMD),
+			 autofs_dev_ioctl_expire},
+		{cmd_idx(AUTOFS_DEV_IOCTL_ASKUMOUNT_CMD),
+			 autofs_dev_ioctl_askumount},
+		{cmd_idx(AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD),
+			 autofs_dev_ioctl_ismountpoint}
+	};
+	unsigned int idx = cmd_idx(cmd);
+
+	return (idx >= ARRAY_SIZE(_ioctls)) ? NULL : _ioctls[idx].fn;
+}
+
+/* ioctl dispatcher */
+static int
+_autofs_dev_ioctl(unsigned int command, struct autofs_dev_ioctl __user *user)
+{
+	struct autofs_dev_ioctl *param;
+	struct file *fp;
+	struct autofs_sb_info *sbi;
+	unsigned int cmd_first, cmd;
+	ioctl_fn fn = NULL;
+	int err = 0;
+
+	/* only root can play with this */
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	cmd_first = _IOC_NR(AUTOFS_DEV_IOCTL_IOC_FIRST);
+	cmd = _IOC_NR(command);
+
+	if (_IOC_TYPE(command) != _IOC_TYPE(AUTOFS_DEV_IOCTL_IOC_FIRST) ||
+	    cmd - cmd_first >= AUTOFS_DEV_IOCTL_IOC_COUNT) {
+		return -ENOTTY;
+	}
+
+	/* Copy the parameters into kernel space. */
+	param = copy_dev_ioctl(user);
+	if (IS_ERR(param))
+		return PTR_ERR(param);
+
+	err = validate_dev_ioctl(command, param);
+	if (err)
+		goto out;
+
+	/* The validate routine above always sets the version */
+	if (cmd == AUTOFS_DEV_IOCTL_VERSION_CMD)
+		goto done;
+
+	fn = lookup_dev_ioctl(cmd);
+	if (!fn) {
+		AUTOFS_WARN("unknown command 0x%08x", command);
+		return -ENOTTY;
+	}
+
+	fp = NULL;
+	sbi = NULL;
+
+	/*
+	 * For obvious reasons the openmount can't have a file
+	 * descriptor yet. We don't take a reference to the
+	 * file during close to allow for immediate release.
+	 */
+	if (cmd != AUTOFS_DEV_IOCTL_OPENMOUNT_CMD &&
+	    cmd != AUTOFS_DEV_IOCTL_CLOSEMOUNT_CMD) {
+		fp = fget(param->ioctlfd);
+		if (!fp) {
+			if (cmd == AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD)
+				goto cont;
+			err = -EBADF;
+			goto out;
+		}
+
+		if (!fp->f_op) {
+			err = -ENOTTY;
+			fput(fp);
+			goto out;
+		}
+
+		sbi = autofs_dev_ioctl_sbi(fp);
+		if (!sbi || sbi->magic != AUTOFS_SBI_MAGIC) {
+			err = -EINVAL;
+			fput(fp);
+			goto out;
+		}
+
+		/*
+		 * Admin needs to be able to set the mount catatonic in
+		 * order to be able to perform the re-open.
+		 */
+		if (!autofs4_oz_mode(sbi) &&
+		    cmd != AUTOFS_DEV_IOCTL_CATATONIC_CMD) {
+			err = -EACCES;
+			fput(fp);
+			goto out;
+		}
+	}
+cont:
+	err = fn(fp, sbi, param);
+
+	if (fp)
+		fput(fp);
+done:
+	if (err >= 0 && copy_to_user(user, param, AUTOFS_DEV_IOCTL_SIZE))
+		err = -EFAULT;
+out:
+	free_dev_ioctl(param);
+	return err;
+}
+
+static long autofs_dev_ioctl(struct file *file, uint command, ulong u)
+{
+	int err;
+	err = _autofs_dev_ioctl(command, (struct autofs_dev_ioctl __user *) u);
+	return (long) err;
+}
+
+#ifdef CONFIG_COMPAT
+static long autofs_dev_ioctl_compat(struct file *file, uint command, ulong u)
+{
+	return (long) autofs_dev_ioctl(file, command, (ulong) compat_ptr(u));
+}
+#else
+#define autofs_dev_ioctl_compat NULL
+#endif
+
+static const struct file_operations _dev_ioctl_fops = {
+	.unlocked_ioctl	 = autofs_dev_ioctl,
+	.compat_ioctl = autofs_dev_ioctl_compat,
+	.owner	 = THIS_MODULE,
+};
+
+static struct miscdevice _autofs_dev_ioctl_misc = {
+	.minor 		= MISC_DYNAMIC_MINOR,
+	.name  		= AUTOFS_DEVICE_NAME,
+	.fops  		= &_dev_ioctl_fops
+};
+
+/* Register/deregister misc character device */
+int autofs_dev_ioctl_init(void)
+{
+	int r;
+
+	r = misc_register(&_autofs_dev_ioctl_misc);
+	if (r) {
+		AUTOFS_ERROR("misc_register failed for control device");
+		return r;
+	}
+
+	return 0;
+}
+
+void autofs_dev_ioctl_exit(void)
+{
+	misc_deregister(&_autofs_dev_ioctl_misc);
+	return;
+}
+
diff --git a/fs/autofs/dirhash.c b/fs/autofs/dirhash.c
deleted file mode 100644
index e947915..0000000
--- a/fs/autofs/dirhash.c
+++ /dev/null
@@ -1,250 +0,0 @@
-/* -*- linux-c -*- --------------------------------------------------------- *
- *
- * linux/fs/autofs/dirhash.c
- *
- *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
- *
- * This file is part of the Linux kernel and is made available under
- * the terms of the GNU General Public License, version 2, or at your
- * option, any later version, incorporated herein by reference.
- *
- * ------------------------------------------------------------------------- */
-
-#include "autofs_i.h"
-
-/* Functions for maintenance of expiry queue */
-
-static void autofs_init_usage(struct autofs_dirhash *dh,
-			      struct autofs_dir_ent *ent)
-{
-	list_add_tail(&ent->exp, &dh->expiry_head);
-	ent->last_usage = jiffies;
-}
-
-static void autofs_delete_usage(struct autofs_dir_ent *ent)
-{
-	list_del(&ent->exp);
-}
-
-void autofs_update_usage(struct autofs_dirhash *dh,
-			 struct autofs_dir_ent *ent)
-{
-	autofs_delete_usage(ent);   /* Unlink from current position */
-	autofs_init_usage(dh,ent);  /* Relink at queue tail */
-}
-
-struct autofs_dir_ent *autofs_expire(struct super_block *sb,
-				     struct autofs_sb_info *sbi,
-				     struct vfsmount *mnt)
-{
-	struct autofs_dirhash *dh = &sbi->dirhash;
-	struct autofs_dir_ent *ent;
-	unsigned long timeout = sbi->exp_timeout;
-
-	while (1) {
-		struct path path;
-		int umount_ok;
-
-		if ( list_empty(&dh->expiry_head) || sbi->catatonic )
-			return NULL;	/* No entries */
-		/* We keep the list sorted by last_usage and want old stuff */
-		ent = list_entry(dh->expiry_head.next, struct autofs_dir_ent, exp);
-		if (jiffies - ent->last_usage < timeout)
-			break;
-		/* Move to end of list in case expiry isn't desirable */
-		autofs_update_usage(dh, ent);
-
-		/* Check to see that entry is expirable */
-		if ( ent->ino < AUTOFS_FIRST_DIR_INO )
-			return ent; /* Symlinks are always expirable */
-
-		/* Get the dentry for the autofs subdirectory */
-		path.dentry = ent->dentry;
-
-		if (!path.dentry) {
-			/* Should only happen in catatonic mode */
-			printk("autofs: dentry == NULL but inode range is directory, entry %s\n", ent->name);
-			autofs_delete_usage(ent);
-			continue;
-		}
-
-		if (!path.dentry->d_inode) {
-			dput(path.dentry);
-			printk("autofs: negative dentry on expiry queue: %s\n",
-			       ent->name);
-			autofs_delete_usage(ent);
-			continue;
-		}
-
-		/* Make sure entry is mounted and unused; note that dentry will
-		   point to the mounted-on-top root. */
-		if (!S_ISDIR(path.dentry->d_inode->i_mode) ||
-		    !d_mountpoint(path.dentry)) {
-			DPRINTK(("autofs: not expirable (not a mounted directory): %s\n", ent->name));
-			continue;
-		}
-		path.mnt = mnt;
-		path_get(&path);
-		if (!follow_down(&path)) {
-			path_put(&path);
-			DPRINTK(("autofs: not expirable (not a mounted directory): %s\n", ent->name));
-			continue;
-		}
-		while (d_mountpoint(path.dentry) && follow_down(&path))
-			;
-		umount_ok = may_umount(path.mnt);
-		path_put(&path);
-
-		if (umount_ok) {
-			DPRINTK(("autofs: signaling expire on %s\n", ent->name));
-			return ent; /* Expirable! */
-		}
-		DPRINTK(("autofs: didn't expire due to may_umount: %s\n", ent->name));
-	}
-	return NULL;		/* No expirable entries */
-}
-
-void autofs_initialize_hash(struct autofs_dirhash *dh) {
-	memset(&dh->h, 0, AUTOFS_HASH_SIZE*sizeof(struct autofs_dir_ent *));
-	INIT_LIST_HEAD(&dh->expiry_head);
-}
-
-struct autofs_dir_ent *autofs_hash_lookup(const struct autofs_dirhash *dh, struct qstr *name)
-{
-	struct autofs_dir_ent *dhn;
-
-	DPRINTK(("autofs_hash_lookup: hash = 0x%08x, name = ", name->hash));
-	autofs_say(name->name,name->len);
-
-	for ( dhn = dh->h[(unsigned) name->hash % AUTOFS_HASH_SIZE] ; dhn ; dhn = dhn->next ) {
-		if ( name->hash == dhn->hash &&
-		     name->len == dhn->len &&
-		     !memcmp(name->name, dhn->name, name->len) )
-			break;
-	}
-
-	return dhn;
-}
-
-void autofs_hash_insert(struct autofs_dirhash *dh, struct autofs_dir_ent *ent)
-{
-	struct autofs_dir_ent **dhnp;
-
-	DPRINTK(("autofs_hash_insert: hash = 0x%08x, name = ", ent->hash));
-	autofs_say(ent->name,ent->len);
-
-	autofs_init_usage(dh,ent);
-	if (ent->dentry)
-		dget(ent->dentry);
-
-	dhnp = &dh->h[(unsigned) ent->hash % AUTOFS_HASH_SIZE];
-	ent->next = *dhnp;
-	ent->back = dhnp;
-	*dhnp = ent;
-	if ( ent->next )
-		ent->next->back = &(ent->next);
-}
-
-void autofs_hash_delete(struct autofs_dir_ent *ent)
-{
-	*(ent->back) = ent->next;
-	if ( ent->next )
-		ent->next->back = ent->back;
-
-	autofs_delete_usage(ent);
-
-	if ( ent->dentry )
-		dput(ent->dentry);
-	kfree(ent->name);
-	kfree(ent);
-}
-
-/*
- * Used by readdir().  We must validate "ptr", so we can't simply make it
- * a pointer.  Values below 0xffff are reserved; calling with any value
- * <= 0x10000 will return the first entry found.
- *
- * "last" can be NULL or the value returned by the last search *if* we
- * want the next sequential entry.
- */
-struct autofs_dir_ent *autofs_hash_enum(const struct autofs_dirhash *dh,
-					off_t *ptr, struct autofs_dir_ent *last)
-{
-	int bucket, ecount, i;
-	struct autofs_dir_ent *ent;
-
-	bucket = (*ptr >> 16) - 1;
-	ecount = *ptr & 0xffff;
-
-	if ( bucket < 0 ) {
-		bucket = ecount = 0;
-	} 
-
-	DPRINTK(("autofs_hash_enum: bucket %d, entry %d\n", bucket, ecount));
-
-	ent = last ? last->next : NULL;
-
-	if ( ent ) {
-		ecount++;
-	} else {
-		while  ( bucket < AUTOFS_HASH_SIZE ) {
-			ent = dh->h[bucket];
-			for ( i = ecount ; ent && i ; i-- )
-				ent = ent->next;
-			
-			if (ent) {
-				ecount++; /* Point to *next* entry */
-				break;
-			}
-			
-			bucket++; ecount = 0;
-		}
-	}
-
-#ifdef DEBUG
-	if ( !ent )
-		printk("autofs_hash_enum: nothing found\n");
-	else {
-		printk("autofs_hash_enum: found hash %08x, name", ent->hash);
-		autofs_say(ent->name,ent->len);
-	}
-#endif
-
-	*ptr = ((bucket+1) << 16) + ecount;
-	return ent;
-}
-
-/* Iterate over all the ents, and remove all dentry pointers.  Used on
-   entering catatonic mode, in order to make the filesystem unmountable. */
-void autofs_hash_dputall(struct autofs_dirhash *dh)
-{
-	int i;
-	struct autofs_dir_ent *ent;
-
-	for ( i = 0 ; i < AUTOFS_HASH_SIZE ; i++ ) {
-		for ( ent = dh->h[i] ; ent ; ent = ent->next ) {
-			if ( ent->dentry ) {
-				dput(ent->dentry);
-				ent->dentry = NULL;
-			}
-		}
-	}
-}
-
-/* Delete everything.  This is used on filesystem destruction, so we
-   make no attempt to keep the pointers valid */
-void autofs_hash_nuke(struct autofs_sb_info *sbi)
-{
-	int i;
-	struct autofs_dir_ent *ent, *nent;
-
-	for ( i = 0 ; i < AUTOFS_HASH_SIZE ; i++ ) {
-		for ( ent = sbi->dirhash.h[i] ; ent ; ent = nent ) {
-			nent = ent->next;
-			if ( ent->dentry )
-				dput(ent->dentry);
-			kfree(ent->name);
-			kfree(ent);
-		}
-	}
-}
diff --git a/fs/autofs/expire.c b/fs/autofs/expire.c
new file mode 100644
index 0000000..204c4fe
--- /dev/null
+++ b/fs/autofs/expire.c
@@ -0,0 +1,534 @@
+/*
+ *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
+ *  Copyright 1999-2000 Jeremy Fitzhardinge <jeremy@goop.org>
+ *  Copyright 2001-2006 Ian Kent <raven@themaw.net>
+ *
+ * This file is part of the Linux kernel and is made available under
+ * the terms of the GNU General Public License, version 2, or at your
+ * option, any later version, incorporated herein by reference.
+ *
+ * ------------------------------------------------------------------------- */
+
+#include "autofs_i.h"
+
+static unsigned long now;
+
+/* Check if a dentry can be expired */
+static inline int autofs4_can_expire(struct dentry *dentry,
+					unsigned long timeout, int do_now)
+{
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+
+	/* dentry in the process of being deleted */
+	if (ino == NULL)
+		return 0;
+
+	/* No point expiring a pending mount */
+	if (ino->flags & AUTOFS_INF_PENDING)
+		return 0;
+
+	if (!do_now) {
+		/* Too young to die */
+		if (!timeout || time_after(ino->last_used + timeout, now))
+			return 0;
+
+		/* update last_used here :-
+		   - obviously makes sense if it is in use now
+		   - less obviously, prevents rapid-fire expire
+		     attempts if expire fails the first time */
+		ino->last_used = now;
+	}
+	return 1;
+}
+
+/* Check a mount point for busyness */
+static int autofs4_mount_busy(struct vfsmount *mnt, struct dentry *dentry)
+{
+	struct dentry *top = dentry;
+	struct path path = {.mnt = mnt, .dentry = dentry};
+	int status = 1;
+
+	DPRINTK("dentry %p %.*s",
+		dentry, (int)dentry->d_name.len, dentry->d_name.name);
+
+	path_get(&path);
+
+	if (!follow_down(&path))
+		goto done;
+
+	if (is_autofs4_dentry(path.dentry)) {
+		struct autofs_sb_info *sbi = autofs4_sbi(path.dentry->d_sb);
+
+		/* This is an autofs submount, we can't expire it */
+		if (autofs_type_indirect(sbi->type))
+			goto done;
+
+		/*
+		 * Otherwise it's an offset mount and we need to check
+		 * if we can umount its mount, if there is one.
+		 */
+		if (!d_mountpoint(path.dentry)) {
+			status = 0;
+			goto done;
+		}
+	}
+
+	/* Update the expiry counter if fs is busy */
+	if (!may_umount_tree(path.mnt)) {
+		struct autofs_info *ino = autofs4_dentry_ino(top);
+		ino->last_used = jiffies;
+		goto done;
+	}
+
+	status = 0;
+done:
+	DPRINTK("returning = %d", status);
+	path_put(&path);
+	return status;
+}
+
+/*
+ * Calculate next entry in top down tree traversal.
+ * From next_mnt in namespace.c - elegant.
+ */
+static struct dentry *next_dentry(struct dentry *p, struct dentry *root)
+{
+	struct list_head *next = p->d_subdirs.next;
+
+	if (next == &p->d_subdirs) {
+		while (1) {
+			if (p == root)
+				return NULL;
+			next = p->d_u.d_child.next;
+			if (next != &p->d_parent->d_subdirs)
+				break;
+			p = p->d_parent;
+		}
+	}
+	return list_entry(next, struct dentry, d_u.d_child);
+}
+
+/*
+ * Check a direct mount point for busyness.
+ * Direct mounts have similar expiry semantics to tree mounts.
+ * The tree is not busy iff no mountpoints are busy and there are no
+ * autofs submounts.
+ */
+static int autofs4_direct_busy(struct vfsmount *mnt,
+				struct dentry *top,
+				unsigned long timeout,
+				int do_now)
+{
+	DPRINTK("top %p %.*s",
+		top, (int) top->d_name.len, top->d_name.name);
+
+	/* If it's busy update the expiry counters */
+	if (!may_umount_tree(mnt)) {
+		struct autofs_info *ino = autofs4_dentry_ino(top);
+		if (ino)
+			ino->last_used = jiffies;
+		return 1;
+	}
+
+	/* Timeout of a direct mount is determined by its top dentry */
+	if (!autofs4_can_expire(top, timeout, do_now))
+		return 1;
+
+	return 0;
+}
+
+/* Check a directory tree of mount points for busyness
+ * The tree is not busy iff no mountpoints are busy
+ */
+static int autofs4_tree_busy(struct vfsmount *mnt,
+			     struct dentry *top,
+			     unsigned long timeout,
+			     int do_now)
+{
+	struct autofs_info *top_ino = autofs4_dentry_ino(top);
+	struct dentry *p;
+
+	DPRINTK("top %p %.*s",
+		top, (int)top->d_name.len, top->d_name.name);
+
+	/* Negative dentry - give up */
+	if (!simple_positive(top))
+		return 1;
+
+	spin_lock(&dcache_lock);
+	for (p = top; p; p = next_dentry(p, top)) {
+		/* Negative dentry - give up */
+		if (!simple_positive(p))
+			continue;
+
+		DPRINTK("dentry %p %.*s",
+			p, (int) p->d_name.len, p->d_name.name);
+
+		p = dget(p);
+		spin_unlock(&dcache_lock);
+
+		/*
+		 * Is someone visiting anywhere in the subtree ?
+		 * If there's no mount we need to check the usage
+		 * count for the autofs dentry.
+		 * If the fs is busy update the expiry counter.
+		 */
+		if (d_mountpoint(p)) {
+			if (autofs4_mount_busy(mnt, p)) {
+				top_ino->last_used = jiffies;
+				dput(p);
+				return 1;
+			}
+		} else {
+			struct autofs_info *ino = autofs4_dentry_ino(p);
+			unsigned int ino_count = atomic_read(&ino->count);
+
+			/*
+			 * Clean stale dentries below that have not been
+			 * invalidated after a mount fail during lookup
+			 */
+			d_invalidate(p);
+
+			/* allow for dget above and top is already dgot */
+			if (p == top)
+				ino_count += 2;
+			else
+				ino_count++;
+
+			if (atomic_read(&p->d_count) > ino_count) {
+				top_ino->last_used = jiffies;
+				dput(p);
+				return 1;
+			}
+		}
+		dput(p);
+		spin_lock(&dcache_lock);
+	}
+	spin_unlock(&dcache_lock);
+
+	/* Timeout of a tree mount is ultimately determined by its top dentry */
+	if (!autofs4_can_expire(top, timeout, do_now))
+		return 1;
+
+	return 0;
+}
+
+static struct dentry *autofs4_check_leaves(struct vfsmount *mnt,
+					   struct dentry *parent,
+					   unsigned long timeout,
+					   int do_now)
+{
+	struct dentry *p;
+
+	DPRINTK("parent %p %.*s",
+		parent, (int)parent->d_name.len, parent->d_name.name);
+
+	spin_lock(&dcache_lock);
+	for (p = parent; p; p = next_dentry(p, parent)) {
+		/* Negative dentry - give up */
+		if (!simple_positive(p))
+			continue;
+
+		DPRINTK("dentry %p %.*s",
+			p, (int) p->d_name.len, p->d_name.name);
+
+		p = dget(p);
+		spin_unlock(&dcache_lock);
+
+		if (d_mountpoint(p)) {
+			/* Can we umount this guy */
+			if (autofs4_mount_busy(mnt, p))
+				goto cont;
+
+			/* Can we expire this guy */
+			if (autofs4_can_expire(p, timeout, do_now))
+				return p;
+		}
+cont:
+		dput(p);
+		spin_lock(&dcache_lock);
+	}
+	spin_unlock(&dcache_lock);
+	return NULL;
+}
+
+/* Check if we can expire a direct mount (possibly a tree) */
+struct dentry *autofs4_expire_direct(struct super_block *sb,
+				     struct vfsmount *mnt,
+				     struct autofs_sb_info *sbi,
+				     int how)
+{
+	unsigned long timeout;
+	struct dentry *root = dget(sb->s_root);
+	int do_now = how & AUTOFS_EXP_IMMEDIATE;
+
+	if (!root)
+		return NULL;
+
+	now = jiffies;
+	timeout = sbi->exp_timeout;
+
+	spin_lock(&sbi->fs_lock);
+	if (!autofs4_direct_busy(mnt, root, timeout, do_now)) {
+		struct autofs_info *ino = autofs4_dentry_ino(root);
+		if (d_mountpoint(root)) {
+			ino->flags |= AUTOFS_INF_MOUNTPOINT;
+			root->d_mounted--;
+		}
+		ino->flags |= AUTOFS_INF_EXPIRING;
+		autofs4_add_expiring(root);
+		init_completion(&ino->expire_complete);
+		spin_unlock(&sbi->fs_lock);
+		return root;
+	}
+	spin_unlock(&sbi->fs_lock);
+	dput(root);
+
+	return NULL;
+}
+
+/*
+ * Find an eligible tree to time-out
+ * A tree is eligible if :-
+ *  - it is unused by any user process
+ *  - it has been unused for exp_timeout time
+ */
+struct dentry *autofs4_expire_indirect(struct super_block *sb,
+				       struct vfsmount *mnt,
+				       struct autofs_sb_info *sbi,
+				       int how)
+{
+	unsigned long timeout;
+	struct dentry *root = sb->s_root;
+	struct dentry *expired = NULL;
+	struct list_head *next;
+	int do_now = how & AUTOFS_EXP_IMMEDIATE;
+	int exp_leaves = how & AUTOFS_EXP_LEAVES;
+	struct autofs_info *ino;
+	unsigned int ino_count;
+
+	if (!root)
+		return NULL;
+
+	now = jiffies;
+	timeout = sbi->exp_timeout;
+
+	spin_lock(&dcache_lock);
+	next = root->d_subdirs.next;
+
+	/*
+	 * On exit from the loop expire is set to a dgot dentry
+	 * to expire or it's NULL
+	 */
+	while (next != &root->d_subdirs) {
+		struct dentry *dentry;
+
+		dentry = list_entry(next, struct dentry, d_u.d_child);
+
+		/* Negative dentry - give up */
+		if (!simple_positive(dentry)) {
+			next = next->next;
+			continue;
+		}
+
+		dentry = dget(dentry);
+		spin_unlock(&dcache_lock);
+
+		spin_lock(&sbi->fs_lock);
+		ino = autofs4_dentry_ino(dentry);
+
+		/*
+		 * Case 1: (i) indirect mount or top level pseudo direct mount
+		 *	   (autofs-4.1).
+		 *	   (ii) indirect mount with offset mount, check the "/"
+		 *	   offset (autofs-5.0+).
+		 */
+		if (d_mountpoint(dentry)) {
+			DPRINTK("checking mountpoint %p %.*s", dentry,
+				(int)dentry->d_name.len, dentry->d_name.name);
+
+			/* Path walk currently on this dentry? */
+			ino_count = atomic_read(&ino->count) + 2;
+			if (atomic_read(&dentry->d_count) > ino_count)
+				goto next;
+
+			/* Can we umount this guy */
+			if (autofs4_mount_busy(mnt, dentry))
+				goto next;
+
+			/* Can we expire this guy */
+			if (autofs4_can_expire(dentry, timeout, do_now)) {
+				expired = dentry;
+				goto found;
+			}
+			goto next;
+		}
+
+		if (simple_empty(dentry))
+			goto next;
+
+		/* Case 2: tree mount, expire iff entire tree is not busy */
+		if (!exp_leaves) {
+			/* Path walk currently on this dentry? */
+			ino_count = atomic_read(&ino->count) + 1;
+			if (atomic_read(&dentry->d_count) > ino_count)
+				goto next;
+
+			if (!autofs4_tree_busy(mnt, dentry, timeout, do_now)) {
+				expired = dentry;
+				goto found;
+			}
+		/*
+		 * Case 3: pseudo direct mount, expire individual leaves
+		 *	   (autofs-4.1).
+		 */
+		} else {
+			/* Path walk currently on this dentry? */
+			ino_count = atomic_read(&ino->count) + 1;
+			if (atomic_read(&dentry->d_count) > ino_count)
+				goto next;
+
+			expired = autofs4_check_leaves(mnt, dentry, timeout, do_now);
+			if (expired) {
+				dput(dentry);
+				goto found;
+			}
+		}
+next:
+		spin_unlock(&sbi->fs_lock);
+		dput(dentry);
+		spin_lock(&dcache_lock);
+		next = next->next;
+	}
+	spin_unlock(&dcache_lock);
+	return NULL;
+
+found:
+	DPRINTK("returning %p %.*s",
+		expired, (int)expired->d_name.len, expired->d_name.name);
+	ino = autofs4_dentry_ino(expired);
+	ino->flags |= AUTOFS_INF_EXPIRING;
+	autofs4_add_expiring(expired);
+	init_completion(&ino->expire_complete);
+	spin_unlock(&sbi->fs_lock);
+	spin_lock(&dcache_lock);
+	list_move(&expired->d_parent->d_subdirs, &expired->d_u.d_child);
+	spin_unlock(&dcache_lock);
+	return expired;
+}
+
+int autofs4_expire_wait(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	int status;
+
+	/* Block on any pending expire */
+	spin_lock(&sbi->fs_lock);
+	if (ino->flags & AUTOFS_INF_EXPIRING) {
+		spin_unlock(&sbi->fs_lock);
+
+		DPRINTK("waiting for expire %p name=%.*s",
+			 dentry, dentry->d_name.len, dentry->d_name.name);
+
+		status = autofs4_wait(sbi, dentry, NFY_NONE);
+		wait_for_completion(&ino->expire_complete);
+
+		DPRINTK("expire done status=%d", status);
+
+		if (d_unhashed(dentry) && IS_DEADDIR(dentry->d_inode))
+			return -EAGAIN;
+
+		return status;
+	}
+	spin_unlock(&sbi->fs_lock);
+
+	return 0;
+}
+
+/* Perform an expiry operation */
+int autofs4_expire_run(struct super_block *sb,
+		      struct vfsmount *mnt,
+		      struct autofs_sb_info *sbi,
+		      struct autofs_packet_expire __user *pkt_p)
+{
+	struct autofs_packet_expire pkt;
+	struct autofs_info *ino;
+	struct dentry *dentry;
+	int ret = 0;
+
+	memset(&pkt, 0, sizeof pkt);
+
+	pkt.hdr.proto_version = sbi->version;
+	pkt.hdr.type = autofs_ptype_expire;
+
+	dentry = autofs4_expire_indirect(sb, mnt, sbi, 0);
+	if (dentry == NULL)
+		return -EAGAIN;
+
+	pkt.len = dentry->d_name.len;
+	memcpy(pkt.name, dentry->d_name.name, pkt.len);
+	pkt.name[pkt.len] = '\0';
+	dput(dentry);
+
+	if (copy_to_user(pkt_p, &pkt, sizeof(struct autofs_packet_expire)))
+		ret = -EFAULT;
+
+	spin_lock(&sbi->fs_lock);
+	ino = autofs4_dentry_ino(dentry);
+	ino->flags &= ~AUTOFS_INF_EXPIRING;
+	autofs4_del_expiring(dentry);
+	complete_all(&ino->expire_complete);
+	spin_unlock(&sbi->fs_lock);
+
+	return ret;
+}
+
+int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
+			    struct autofs_sb_info *sbi, int when)
+{
+	struct dentry *dentry;
+	int ret = -EAGAIN;
+
+	if (autofs_type_trigger(sbi->type))
+		dentry = autofs4_expire_direct(sb, mnt, sbi, when);
+	else
+		dentry = autofs4_expire_indirect(sb, mnt, sbi, when);
+
+	if (dentry) {
+		struct autofs_info *ino = autofs4_dentry_ino(dentry);
+
+		/*
+		 * This is synchronous because it makes the daemon a
+		 * little easier
+		 */
+		ret = autofs4_wait(sbi, dentry, NFY_EXPIRE);
+
+		spin_lock(&sbi->fs_lock);
+		if (ino->flags & AUTOFS_INF_MOUNTPOINT) {
+			sb->s_root->d_mounted++;
+			ino->flags &= ~AUTOFS_INF_MOUNTPOINT;
+		}
+		ino->flags &= ~AUTOFS_INF_EXPIRING;
+		autofs4_del_expiring(dentry);
+		complete_all(&ino->expire_complete);
+		spin_unlock(&sbi->fs_lock);
+		dput(dentry);
+	}
+
+	return ret;
+}
+
+/* Call repeatedly until it returns -EAGAIN, meaning there's nothing
+   more to be done */
+int autofs4_expire_multi(struct super_block *sb, struct vfsmount *mnt,
+			struct autofs_sb_info *sbi, int __user *arg)
+{
+	int do_now = 0;
+
+	if (arg && get_user(do_now, arg))
+		return -EFAULT;
+
+	return autofs4_do_expire_multi(sb, mnt, sbi, do_now);
+}
+
diff --git a/fs/autofs/init.c b/fs/autofs/init.c
index cea5219..11cc42b 100644
--- a/fs/autofs/init.c
+++ b/fs/autofs/init.c
@@ -1,7 +1,4 @@
-/* -*- linux-c -*- --------------------------------------------------------- *
- *
- * linux/fs/autofs/init.c
- *
+/*
  *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
  *
  * This file is part of the Linux kernel and is made available under
@@ -17,36 +14,35 @@
 static int autofs_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
 {
-	return get_sb_nodev(fs_type, flags, data, autofs_fill_super, mnt);
+	return get_sb_nodev(fs_type, flags, data, autofs4_fill_super, mnt);
 }
 
 static struct file_system_type autofs_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "autofs",
 	.get_sb		= autofs_get_sb,
-	.kill_sb	= autofs_kill_sb,
+	.kill_sb	= autofs4_kill_sb,
 };
 
-static int __init init_autofs_fs(void)
+static int __init init_autofs4_fs(void)
 {
-	return register_filesystem(&autofs_fs_type);
+	int err;
+
+	err = register_filesystem(&autofs_fs_type);
+	if (err)
+		return err;
+
+	autofs_dev_ioctl_init();
+
+	return err;
 }
 
-static void __exit exit_autofs_fs(void)
+static void __exit exit_autofs4_fs(void)
 {
+	autofs_dev_ioctl_exit();
 	unregister_filesystem(&autofs_fs_type);
 }
 
-module_init(init_autofs_fs);
-module_exit(exit_autofs_fs);
-
-#ifdef DEBUG
-void autofs_say(const char *name, int len)
-{
-	printk("(%d: ", len);
-	while ( len-- )
-		printk("%c", *name++);
-	printk(")\n");
-}
-#endif
+module_init(init_autofs4_fs)
+module_exit(exit_autofs4_fs)
 MODULE_LICENSE("GPL");
diff --git a/fs/autofs/inode.c b/fs/autofs/inode.c
index e1734f2..5b006db 100644
--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -1,8 +1,6 @@
-/* -*- linux-c -*- --------------------------------------------------------- *
- *
- * linux/fs/autofs/inode.c
- *
+/*
  *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
+ *  Copyright 2005-2006 Ian Kent <raven@themaw.net>
  *
  * This file is part of the Linux kernel and is made available under
  * the terms of the GNU General Public License, version 2, or at your
@@ -11,19 +9,153 @@
  * ------------------------------------------------------------------------- */
 
 #include <linux/kernel.h>
-#include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/file.h>
+#include <linux/seq_file.h>
+#include <linux/pagemap.h>
 #include <linux/parser.h>
 #include <linux/bitops.h>
 #include <linux/magic.h>
 #include "autofs_i.h"
 #include <linux/module.h>
 
-void autofs_kill_sb(struct super_block *sb)
+static void ino_lnkfree(struct autofs_info *ino)
+{
+	if (ino->u.symlink) {
+		kfree(ino->u.symlink);
+		ino->u.symlink = NULL;
+	}
+}
+
+struct autofs_info *autofs4_init_ino(struct autofs_info *ino,
+				     struct autofs_sb_info *sbi, mode_t mode)
+{
+	int reinit = 1;
+
+	if (ino == NULL) {
+		reinit = 0;
+		ino = kmalloc(sizeof(*ino), GFP_KERNEL);
+	}
+
+	if (ino == NULL)
+		return NULL;
+
+	if (!reinit) {
+		ino->flags = 0;
+		ino->inode = NULL;
+		ino->dentry = NULL;
+		ino->size = 0;
+		INIT_LIST_HEAD(&ino->active);
+		INIT_LIST_HEAD(&ino->rehash_list);
+		ino->active_count = 0;
+		INIT_LIST_HEAD(&ino->expiring);
+		atomic_set(&ino->count, 0);
+	}
+
+	ino->uid = 0;
+	ino->gid = 0;
+	ino->mode = mode;
+	ino->last_used = jiffies;
+
+	ino->sbi = sbi;
+
+	if (reinit && ino->free)
+		(ino->free)(ino);
+
+	memset(&ino->u, 0, sizeof(ino->u));
+
+	ino->free = NULL;
+
+	if (S_ISLNK(mode))
+		ino->free = ino_lnkfree;
+
+	return ino;
+}
+
+void autofs4_free_ino(struct autofs_info *ino)
+{
+	struct autofs_info *p_ino;
+
+	if (ino->dentry) {
+		ino->dentry->d_fsdata = NULL;
+		if (ino->dentry->d_inode) {
+			struct dentry *parent = ino->dentry->d_parent;
+			if (atomic_dec_and_test(&ino->count)) {
+				p_ino = autofs4_dentry_ino(parent);
+				if (p_ino && parent != ino->dentry)
+					atomic_dec(&p_ino->count);
+			}
+			dput(ino->dentry);
+		}
+		ino->dentry = NULL;
+	}
+	if (ino->free)
+		(ino->free)(ino);
+	kfree(ino);
+}
+
+/*
+ * Deal with the infamous "Busy inodes after umount ..." message.
+ *
+ * Clean up the dentry tree. This happens with autofs if the user
+ * space program goes away due to a SIGKILL, SIGSEGV etc.
+ */
+static void autofs4_force_release(struct autofs_sb_info *sbi)
+{
+	struct dentry *this_parent = sbi->sb->s_root;
+	struct list_head *next;
+
+	if (!sbi->sb->s_root)
+		return;
+
+	spin_lock(&dcache_lock);
+repeat:
+	next = this_parent->d_subdirs.next;
+resume:
+	while (next != &this_parent->d_subdirs) {
+		struct dentry *dentry;
+
+		dentry = list_entry(next, struct dentry, d_u.d_child);
+
+		/* Negative dentry - don`t care */
+		if (!simple_positive(dentry)) {
+			next = next->next;
+			continue;
+		}
+
+		if (!list_empty(&dentry->d_subdirs)) {
+			this_parent = dentry;
+			goto repeat;
+		}
+
+		next = next->next;
+		spin_unlock(&dcache_lock);
+
+		DPRINTK("dentry %p %.*s",
+			dentry, (int)dentry->d_name.len, dentry->d_name.name);
+
+		dput(dentry);
+		spin_lock(&dcache_lock);
+	}
+
+	if (this_parent != sbi->sb->s_root) {
+		struct dentry *dentry = this_parent;
+
+		next = this_parent->d_u.d_child.next;
+		this_parent = this_parent->d_parent;
+		spin_unlock(&dcache_lock);
+		DPRINTK("parent dentry %p %.*s",
+			dentry, (int)dentry->d_name.len, dentry->d_name.name);
+		dput(dentry);
+		spin_lock(&dcache_lock);
+		goto resume;
+	}
+	spin_unlock(&dcache_lock);
+}
+
+void autofs4_kill_sb(struct super_block *sb)
 {
-	struct autofs_sb_info *sbi = autofs_sbi(sb);
-	unsigned int n;
+	struct autofs_sb_info *sbi = autofs4_sbi(sb);
 
 	/*
 	 * In the event of a failure in get_sb_nodev the superblock
@@ -34,43 +166,71 @@ void autofs_kill_sb(struct super_block *sb)
 	if (!sbi)
 		goto out_kill_sb;
 
-	if (!sbi->catatonic)
-		autofs_catatonic_mode(sbi); /* Free wait queues, close pipe */
+	/* Free wait queues, close pipe */
+	autofs4_catatonic_mode(sbi);
 
-	put_pid(sbi->oz_pgrp);
+	/* Clean up and release dangling references */
+	autofs4_force_release(sbi);
 
-	autofs_hash_nuke(sbi);
-	for (n = 0; n < AUTOFS_MAX_SYMLINKS; n++) {
-		if (test_bit(n, sbi->symlink_bitmap))
-			kfree(sbi->symlink[n].data);
-	}
-
-	kfree(sb->s_fs_info);
+	sb->s_fs_info = NULL;
+	kfree(sbi);
 
 out_kill_sb:
-	DPRINTK(("autofs: shutting down\n"));
+	DPRINTK("shutting down");
 	kill_anon_super(sb);
 }
 
-static const struct super_operations autofs_sops = {
+static int autofs4_show_options(struct seq_file *m, struct vfsmount *mnt)
+{
+	struct autofs_sb_info *sbi = autofs4_sbi(mnt->mnt_sb);
+	struct inode *root_inode = mnt->mnt_sb->s_root->d_inode;
+
+	if (!sbi)
+		return 0;
+
+	seq_printf(m, ",fd=%d", sbi->pipefd);
+	if (root_inode->i_uid != 0)
+		seq_printf(m, ",uid=%u", root_inode->i_uid);
+	if (root_inode->i_gid != 0)
+		seq_printf(m, ",gid=%u", root_inode->i_gid);
+	seq_printf(m, ",pgrp=%d", sbi->oz_pgrp);
+	seq_printf(m, ",timeout=%lu", sbi->exp_timeout/HZ);
+	seq_printf(m, ",minproto=%d", sbi->min_proto);
+	seq_printf(m, ",maxproto=%d", sbi->max_proto);
+
+	if (autofs_type_offset(sbi->type))
+		seq_printf(m, ",offset");
+	else if (autofs_type_direct(sbi->type))
+		seq_printf(m, ",direct");
+	else
+		seq_printf(m, ",indirect");
+
+	return 0;
+}
+
+static const struct super_operations autofs4_sops = {
 	.statfs		= simple_statfs,
-	.show_options	= generic_show_options,
+	.show_options	= autofs4_show_options,
 };
 
-enum {Opt_err, Opt_fd, Opt_uid, Opt_gid, Opt_pgrp, Opt_minproto, Opt_maxproto};
+enum {Opt_err, Opt_fd, Opt_uid, Opt_gid, Opt_pgrp, Opt_minproto, Opt_maxproto,
+	Opt_indirect, Opt_direct, Opt_offset};
 
-static const match_table_t autofs_tokens = {
+static const match_table_t tokens = {
 	{Opt_fd, "fd=%u"},
 	{Opt_uid, "uid=%u"},
 	{Opt_gid, "gid=%u"},
 	{Opt_pgrp, "pgrp=%u"},
 	{Opt_minproto, "minproto=%u"},
 	{Opt_maxproto, "maxproto=%u"},
+	{Opt_indirect, "indirect"},
+	{Opt_direct, "direct"},
+	{Opt_offset, "offset"},
 	{Opt_err, NULL}
 };
 
 static int parse_options(char *options, int *pipefd, uid_t *uid, gid_t *gid,
-		pid_t *pgrp, int *minproto, int *maxproto)
+		pid_t *pgrp, unsigned int *type, int *minproto, int *maxproto)
 {
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
@@ -80,7 +240,8 @@ static int parse_options(char *options, int *pipefd, uid_t *uid, gid_t *gid,
 	*gid = current_gid();
 	*pgrp = task_pgrp_nr(current);
 
-	*minproto = *maxproto = AUTOFS_PROTO_VERSION;
+	*minproto = AUTOFS_MIN_PROTO_VERSION;
+	*maxproto = AUTOFS_MAX_PROTO_VERSION;
 
 	*pipefd = -1;
 
@@ -92,38 +253,46 @@ static int parse_options(char *options, int *pipefd, uid_t *uid, gid_t *gid,
 		if (!*p)
 			continue;
 
-		token = match_token(p, autofs_tokens, args);
+		token = match_token(p, tokens, args);
 		switch (token) {
 		case Opt_fd:
-			if (match_int(&args[0], &option))
+			if (match_int(args, pipefd))
 				return 1;
-			*pipefd = option;
 			break;
 		case Opt_uid:
-			if (match_int(&args[0], &option))
+			if (match_int(args, &option))
 				return 1;
 			*uid = option;
 			break;
 		case Opt_gid:
-			if (match_int(&args[0], &option))
+			if (match_int(args, &option))
 				return 1;
 			*gid = option;
 			break;
 		case Opt_pgrp:
-			if (match_int(&args[0], &option))
+			if (match_int(args, &option))
 				return 1;
 			*pgrp = option;
 			break;
 		case Opt_minproto:
-			if (match_int(&args[0], &option))
+			if (match_int(args, &option))
 				return 1;
 			*minproto = option;
 			break;
 		case Opt_maxproto:
-			if (match_int(&args[0], &option))
+			if (match_int(args, &option))
 				return 1;
 			*maxproto = option;
 			break;
+		case Opt_indirect:
+			set_autofs_type_indirect(type);
+			break;
+		case Opt_direct:
+			set_autofs_type_direct(type);
+			break;
+		case Opt_offset:
+			set_autofs_type_offset(type);
+			break;
 		default:
 			return 1;
 		}
@@ -131,81 +300,120 @@ static int parse_options(char *options, int *pipefd, uid_t *uid, gid_t *gid,
 	return (*pipefd < 0);
 }
 
-int autofs_fill_super(struct super_block *s, void *data, int silent)
+static struct autofs_info *autofs4_mkroot(struct autofs_sb_info *sbi)
+{
+	struct autofs_info *ino;
+
+	ino = autofs4_init_ino(NULL, sbi, S_IFDIR | 0755);
+	if (!ino)
+		return NULL;
+
+	return ino;
+}
+
+static const struct dentry_operations autofs4_sb_dentry_operations = {
+	.d_release      = autofs4_dentry_release,
+};
+
+int autofs4_fill_super(struct super_block *s, void *data, int silent)
 {
 	struct inode * root_inode;
 	struct dentry * root;
 	struct file * pipe;
 	int pipefd;
 	struct autofs_sb_info *sbi;
-	int minproto, maxproto;
-	pid_t pgid;
-
-	save_mount_options(s, data);
+	struct autofs_info *ino;
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		goto fail_unlock;
-	DPRINTK(("autofs: starting up, sbi = %p\n",sbi));
+	DPRINTK("starting up, sbi = %p", sbi);
 
 	s->s_fs_info = sbi;
 	sbi->magic = AUTOFS_SBI_MAGIC;
+	sbi->pipefd = -1;
 	sbi->pipe = NULL;
 	sbi->catatonic = 1;
 	sbi->exp_timeout = 0;
-	autofs_initialize_hash(&sbi->dirhash);
+	sbi->oz_pgrp = task_pgrp_nr(current);
+	sbi->sb = s;
+	sbi->version = 0;
+	sbi->sub_version = 0;
+	set_autofs_type_indirect(&sbi->type);
+	sbi->min_proto = 0;
+	sbi->max_proto = 0;
+	mutex_init(&sbi->wq_mutex);
+	spin_lock_init(&sbi->fs_lock);
 	sbi->queues = NULL;
-	memset(sbi->symlink_bitmap, 0, sizeof(long)*AUTOFS_SYMLINK_BITMAP_LEN);
-	sbi->next_dir_ino = AUTOFS_FIRST_DIR_INO;
+	spin_lock_init(&sbi->lookup_lock);
+	INIT_LIST_HEAD(&sbi->active_list);
+	INIT_LIST_HEAD(&sbi->expiring_list);
 	s->s_blocksize = 1024;
 	s->s_blocksize_bits = 10;
 	s->s_magic = AUTOFS_SUPER_MAGIC;
-	s->s_op = &autofs_sops;
+	s->s_op = &autofs4_sops;
 	s->s_time_gran = 1;
-	sbi->sb = s;
 
-	root_inode = autofs_iget(s, AUTOFS_ROOT_INO);
-	if (IS_ERR(root_inode))
+	/*
+	 * Get the root inode and dentry, but defer checking for errors.
+	 */
+	ino = autofs4_mkroot(sbi);
+	if (!ino)
 		goto fail_free;
-	root = d_alloc_root(root_inode);
-	pipe = NULL;
+	root_inode = autofs4_get_inode(s, ino);
+	if (!root_inode)
+		goto fail_ino;
 
+	root = d_alloc_root(root_inode);
 	if (!root)
 		goto fail_iput;
+	pipe = NULL;
 
-	/* Can this call block?  - WTF cares? s is locked. */
-	if (parse_options(data, &pipefd, &root_inode->i_uid,
-				&root_inode->i_gid, &pgid, &minproto,
-				&maxproto)) {
-		printk("autofs: called with bogus options\n");
-		goto fail_dput;
-	}
+	root->d_op = &autofs4_sb_dentry_operations;
+	root->d_fsdata = ino;
 
-	/* Couldn't this be tested earlier? */
-	if (minproto > AUTOFS_PROTO_VERSION ||
-	     maxproto < AUTOFS_PROTO_VERSION) {
-		printk("autofs: kernel does not match daemon version\n");
+	/* Can this call block? */
+	if (parse_options(data, &pipefd, &root_inode->i_uid, &root_inode->i_gid,
+				&sbi->oz_pgrp, &sbi->type, &sbi->min_proto,
+				&sbi->max_proto)) {
+		printk(KERN_ERR "autofs: called with bogus options\n");
 		goto fail_dput;
 	}
 
-	DPRINTK(("autofs: pipe fd = %d, pgrp = %u\n", pipefd, pgid));
-	sbi->oz_pgrp = find_get_pid(pgid);
+	root_inode->i_fop = &autofs4_root_operations;
+	root_inode->i_op = autofs_type_trigger(sbi->type) ?
+			&autofs4_direct_root_inode_operations :
+			&autofs4_indirect_root_inode_operations;
 
-	if (!sbi->oz_pgrp) {
-		printk("autofs: could not find process group %d\n", pgid);
+	/* Couldn't this be tested earlier? */
+	if (sbi->max_proto < AUTOFS_MIN_PROTO_VERSION ||
+	    sbi->min_proto > AUTOFS_MAX_PROTO_VERSION) {
+		printk(KERN_ERR "autofs: kernel does not match daemon "
+		       "version (%d, %d) kernel (%d, %d)\n",
+			sbi->min_proto, sbi->max_proto,
+			AUTOFS_MIN_PROTO_VERSION, AUTOFS_MAX_PROTO_VERSION);
 		goto fail_dput;
 	}
 
+	/* Establish highest kernel protocol version */
+	if (sbi->max_proto > AUTOFS_MAX_PROTO_VERSION)
+		sbi->version = AUTOFS_MAX_PROTO_VERSION;
+	else
+		sbi->version = sbi->max_proto;
+	sbi->sub_version = AUTOFS_PROTO_SUBVERSION;
+
+	DPRINTK("pipe fd = %d, pgrp = %u", pipefd, sbi->oz_pgrp);
 	pipe = fget(pipefd);
 	
 	if (!pipe) {
-		printk("autofs: could not open pipe file descriptor\n");
-		goto fail_put_pid;
+		printk(KERN_ERR
+		      "autofs: could not open pipe file descriptor\n");
+		goto fail_dput;
 	}
-
 	if (!pipe->f_op || !pipe->f_op->write)
 		goto fail_fput;
 	sbi->pipe = pipe;
+	sbi->pipefd = pipefd;
 	sbi->catatonic = 0;
 
 	/*
@@ -214,17 +422,21 @@ int autofs_fill_super(struct super_block *s, void *data, int silent)
 	s->s_root = root;
 	return 0;
 
+	/*
+	 * Failure ... clean up.
+	 */
 fail_fput:
 	printk("autofs: pipe file descriptor does not contain proper ops\n");
 	fput(pipe);
-fail_put_pid:
-	put_pid(sbi->oz_pgrp);
+	/* fall through */
 fail_dput:
 	dput(root);
 	goto fail_free;
 fail_iput:
 	printk("autofs: get root dentry failed\n");
 	iput(root_inode);
+fail_ino:
+	kfree(ino);
 fail_free:
 	kfree(sbi);
 	s->s_fs_info = NULL;
@@ -232,57 +444,30 @@ fail_unlock:
 	return -EINVAL;
 }
 
-struct inode *autofs_iget(struct super_block *sb, unsigned long ino)
+struct inode *autofs4_get_inode(struct super_block *sb,
+				struct autofs_info *inf)
 {
-	unsigned int n;
-	struct autofs_sb_info *sbi = autofs_sbi(sb);
-	struct inode *inode;
-
-	inode = iget_locked(sb, ino);
-	if (!inode)
-		return ERR_PTR(-ENOMEM);
-	if (!(inode->i_state & I_NEW))
-		return inode;
-
-	/* Initialize to the default case (stub directory) */
-
-	inode->i_op = &simple_dir_inode_operations;
-	inode->i_fop = &simple_dir_operations;
-	inode->i_mode = S_IFDIR | S_IRUGO | S_IXUGO;
-	inode->i_nlink = 2;
-	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
-
-	if (ino == AUTOFS_ROOT_INO) {
-		inode->i_mode = S_IFDIR | S_IRUGO | S_IXUGO | S_IWUSR;
-		inode->i_op = &autofs_root_inode_operations;
-		inode->i_fop = &autofs_root_operations;
-		goto done;
-	} 
-	
-	inode->i_uid = inode->i_sb->s_root->d_inode->i_uid;
-	inode->i_gid = inode->i_sb->s_root->d_inode->i_gid;
-	
-	if (ino >= AUTOFS_FIRST_SYMLINK && ino < AUTOFS_FIRST_DIR_INO) {
-		/* Symlink inode - should be in symlink list */
-		struct autofs_symlink *sl;
-
-		n = ino - AUTOFS_FIRST_SYMLINK;
-		if (n >= AUTOFS_MAX_SYMLINKS || !test_bit(n,sbi->symlink_bitmap)) {
-			printk("autofs: Looking for bad symlink inode %u\n", (unsigned int) ino);
-			goto done;
-		}
-		
-		inode->i_op = &autofs_symlink_inode_operations;
-		sl = &sbi->symlink[n];
-		inode->i_private = sl;
-		inode->i_mode = S_IFLNK | S_IRWXUGO;
-		inode->i_mtime.tv_sec = inode->i_ctime.tv_sec = sl->mtime;
-		inode->i_mtime.tv_nsec = inode->i_ctime.tv_nsec = 0;
-		inode->i_size = sl->len;
-		inode->i_nlink = 1;
+	struct inode *inode = new_inode(sb);
+
+	if (inode == NULL)
+		return NULL;
+
+	inf->inode = inode;
+	inode->i_mode = inf->mode;
+	if (sb->s_root) {
+		inode->i_uid = sb->s_root->d_inode->i_uid;
+		inode->i_gid = sb->s_root->d_inode->i_gid;
+	}
+	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+
+	if (S_ISDIR(inf->mode)) {
+		inode->i_nlink = 2;
+		inode->i_op = &autofs4_dir_inode_operations;
+		inode->i_fop = &autofs4_dir_operations;
+	} else if (S_ISLNK(inf->mode)) {
+		inode->i_size = inf->size;
+		inode->i_op = &autofs4_symlink_inode_operations;
 	}
 
-done:
-	unlock_new_inode(inode);
 	return inode;
 }
diff --git a/fs/autofs/root.c b/fs/autofs/root.c
index 4a1401c..c7bb36f 100644
--- a/fs/autofs/root.c
+++ b/fs/autofs/root.c
@@ -1,8 +1,7 @@
-/* -*- linux-c -*- --------------------------------------------------------- *
- *
- * linux/fs/autofs/root.c
- *
+/*
  *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
+ *  Copyright 1999-2000 Jeremy Fitzhardinge <jeremy@goop.org>
+ *  Copyright 2001-2006 Ian Kent <raven@themaw.net>
  *
  * This file is part of the Linux kernel and is made available under
  * the terms of the GNU General Public License, version 2, or at your
@@ -15,129 +14,342 @@
 #include <linux/stat.h>
 #include <linux/param.h>
 #include <linux/time.h>
-#include <linux/smp_lock.h>
 #include "autofs_i.h"
 
-static int autofs_root_readdir(struct file *,void *,filldir_t);
-static struct dentry *autofs_root_lookup(struct inode *,struct dentry *, struct nameidata *);
-static int autofs_root_symlink(struct inode *,struct dentry *,const char *);
-static int autofs_root_unlink(struct inode *,struct dentry *);
-static int autofs_root_rmdir(struct inode *,struct dentry *);
-static int autofs_root_mkdir(struct inode *,struct dentry *,int);
-static int autofs_root_ioctl(struct inode *, struct file *,unsigned int,unsigned long);
+static int autofs4_dir_symlink(struct inode *, struct dentry *, const char *);
+static int autofs4_dir_unlink(struct inode *, struct dentry *);
+static int autofs4_dir_rmdir(struct inode *, struct dentry *);
+static int autofs4_dir_mkdir(struct inode *, struct dentry *, int);
+static int autofs4_root_ioctl(struct inode *, struct file *,
+			      unsigned int, unsigned long);
+static int autofs4_dir_open(struct inode *inode, struct file *file);
+static struct dentry *autofs4_lookup(struct inode *,
+				     struct dentry *, struct nameidata *);
+static void *autofs4_follow_link(struct dentry *, struct nameidata *);
+
+#define TRIGGER_FLAGS   (LOOKUP_CONTINUE | LOOKUP_DIRECTORY)
+#define TRIGGER_INTENTS (LOOKUP_OPEN | LOOKUP_CREATE)
+
+const struct file_operations autofs4_root_operations = {
+	.open		= dcache_dir_open,
+	.release	= dcache_dir_close,
+	.read		= generic_read_dir,
+	.readdir	= dcache_readdir,
+	.llseek		= dcache_dir_lseek,
+	.ioctl		= autofs4_root_ioctl,
+};
 
-const struct file_operations autofs_root_operations = {
+const struct file_operations autofs4_dir_operations = {
+	.open		= autofs4_dir_open,
+	.release	= dcache_dir_close,
 	.read		= generic_read_dir,
-	.readdir	= autofs_root_readdir,
-	.ioctl		= autofs_root_ioctl,
+	.readdir	= dcache_readdir,
+	.llseek		= dcache_dir_lseek,
+};
+
+const struct inode_operations autofs4_indirect_root_inode_operations = {
+	.lookup		= autofs4_lookup,
+	.unlink		= autofs4_dir_unlink,
+	.symlink	= autofs4_dir_symlink,
+	.mkdir		= autofs4_dir_mkdir,
+	.rmdir		= autofs4_dir_rmdir,
 };
 
-const struct inode_operations autofs_root_inode_operations = {
-        .lookup		= autofs_root_lookup,
-        .unlink		= autofs_root_unlink,
-        .symlink	= autofs_root_symlink,
-        .mkdir		= autofs_root_mkdir,
-        .rmdir		= autofs_root_rmdir,
+const struct inode_operations autofs4_direct_root_inode_operations = {
+	.lookup		= autofs4_lookup,
+	.unlink		= autofs4_dir_unlink,
+	.mkdir		= autofs4_dir_mkdir,
+	.rmdir		= autofs4_dir_rmdir,
+	.follow_link	= autofs4_follow_link,
 };
 
-static int autofs_root_readdir(struct file *filp, void *dirent, filldir_t filldir)
+const struct inode_operations autofs4_dir_inode_operations = {
+	.lookup		= autofs4_lookup,
+	.unlink		= autofs4_dir_unlink,
+	.symlink	= autofs4_dir_symlink,
+	.mkdir		= autofs4_dir_mkdir,
+	.rmdir		= autofs4_dir_rmdir,
+};
+
+static void autofs4_add_active(struct dentry *dentry)
 {
-	struct autofs_dir_ent *ent = NULL;
-	struct autofs_dirhash *dirhash;
-	struct autofs_sb_info *sbi;
-	struct inode * inode = filp->f_path.dentry->d_inode;
-	off_t onr, nr;
-
-	lock_kernel();
-
-	sbi = autofs_sbi(inode->i_sb);
-	dirhash = &sbi->dirhash;
-	nr = filp->f_pos;
-
-	switch(nr)
-	{
-	case 0:
-		if (filldir(dirent, ".", 1, nr, inode->i_ino, DT_DIR) < 0)
-			goto out;
-		filp->f_pos = ++nr;
-		/* fall through */
-	case 1:
-		if (filldir(dirent, "..", 2, nr, inode->i_ino, DT_DIR) < 0)
-			goto out;
-		filp->f_pos = ++nr;
-		/* fall through */
-	default:
-		while (onr = nr, ent = autofs_hash_enum(dirhash,&nr,ent)) {
-			if (!ent->dentry || d_mountpoint(ent->dentry)) {
-				if (filldir(dirent,ent->name,ent->len,onr,ent->ino,DT_UNKNOWN) < 0)
-					goto out;
-				filp->f_pos = nr;
-			}
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	if (ino) {
+		spin_lock(&sbi->lookup_lock);
+		if (!ino->active_count) {
+			if (list_empty(&ino->active))
+				list_add(&ino->active, &sbi->active_list);
 		}
-		break;
+		ino->active_count++;
+		spin_unlock(&sbi->lookup_lock);
 	}
+	return;
+}
 
-out:
-	unlock_kernel();
-	return 0;
+static void autofs4_del_active(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	if (ino) {
+		spin_lock(&sbi->lookup_lock);
+		ino->active_count--;
+		if (!ino->active_count) {
+			if (!list_empty(&ino->active))
+				list_del_init(&ino->active);
+		}
+		spin_unlock(&sbi->lookup_lock);
+	}
+	return;
 }
 
-static int try_to_fill_dentry(struct dentry *dentry, struct super_block *sb, struct autofs_sb_info *sbi)
+static void autofs4_add_rehash_entry(struct autofs_info *ino,
+				     struct rehash_entry *entry)
 {
-	struct inode * inode;
-	struct autofs_dir_ent *ent;
-	int status = 0;
+	entry->task = current;
+	INIT_LIST_HEAD(&entry->list);
+	list_add(&entry->list, &ino->rehash_list);
+	return;
+}
 
-	if (!(ent = autofs_hash_lookup(&sbi->dirhash, &dentry->d_name))) {
-		do {
-			if (status && dentry->d_inode) {
-				if (status != -ENOENT)
-					printk("autofs warning: lookup failure on positive dentry, status = %d, name = %s\n", status, dentry->d_name.name);
-				return 0; /* Try to get the kernel to invalidate this dentry */
-			}
+static void autofs4_remove_rehash_entry(struct autofs_info *ino)
+{
+	struct list_head *head = &ino->rehash_list;
+	struct rehash_entry *entry;
+	list_for_each_entry(entry, head, list) {
+		if (entry->task == current) {
+			list_del(&entry->list);
+			kfree(entry);
+			break;
+		}
+	}
+	return;
+}
 
-			/* Turn this into a real negative dentry? */
-			if (status == -ENOENT) {
-				dentry->d_time = jiffies + AUTOFS_NEGATIVE_TIMEOUT;
-				dentry->d_flags &= ~DCACHE_AUTOFS_PENDING;
-				return 1;
-			} else if (status) {
-				/* Return a negative dentry, but leave it "pending" */
-				return 1;
-			}
-			status = autofs_wait(sbi, &dentry->d_name);
-		} while (!(ent = autofs_hash_lookup(&sbi->dirhash, &dentry->d_name)));
+static void autofs4_remove_rehash_entrys(struct autofs_info *ino)
+{
+	struct autofs_sb_info *sbi = ino->sbi;
+	struct rehash_entry *entry, *next;
+	struct list_head *head;
+
+	spin_lock(&sbi->fs_lock);
+	spin_lock(&sbi->lookup_lock);
+	if (!(ino->flags & AUTOFS_INF_REHASH)) {
+		spin_unlock(&sbi->lookup_lock);
+		spin_unlock(&sbi->fs_lock);
+		return;
+	}
+	ino->flags &= ~AUTOFS_INF_REHASH;
+	head = &ino->rehash_list;
+	list_for_each_entry_safe(entry, next, head, list) {
+		list_del(&entry->list);
+		kfree(entry);
 	}
+	spin_unlock(&sbi->lookup_lock);
+	spin_unlock(&sbi->fs_lock);
+	dput(ino->dentry);
 
-	/* Abuse this field as a pointer to the directory entry, used to
-	   find the expire list pointers */
-	dentry->d_time = (unsigned long) ent;
-	
-	if (!dentry->d_inode) {
-		inode = autofs_iget(sb, ent->ino);
-		if (IS_ERR(inode)) {
-			/* Failed, but leave pending for next time */
-			return 1;
-		}
-		dentry->d_inode = inode;
+	return;
+}
+
+static void autofs4_revalidate_drop(struct dentry *dentry,
+				    struct rehash_entry *entry)
+{
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	/*
+	 * Add to the active list so we can pick this up in
+	 * ->lookup(). Also add an entry to a rehash list so
+	 * we know when there are no dentrys in flight so we
+	 * know when we can rehash the dentry.
+	 */
+	spin_lock(&sbi->lookup_lock);
+	if (list_empty(&ino->active))
+		list_add(&ino->active, &sbi->active_list);
+	autofs4_add_rehash_entry(ino, entry);
+	spin_unlock(&sbi->lookup_lock);
+	if (!(ino->flags & AUTOFS_INF_REHASH)) {
+		ino->flags |= AUTOFS_INF_REHASH;
+		dget(dentry);
+		spin_lock(&dentry->d_lock);
+		__d_drop(dentry);
+		spin_unlock(&dentry->d_lock);
 	}
+	return;
+}
 
-	/* If this is a directory that isn't a mount point, bitch at the
-	   daemon and fix it in user space */
-	if (S_ISDIR(dentry->d_inode->i_mode) && !d_mountpoint(dentry)) {
-		return !autofs_wait(sbi, &dentry->d_name);
+static void autofs4_revalidate_rehash(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	if (ino->flags & AUTOFS_INF_REHASH) {
+		spin_lock(&sbi->lookup_lock);
+		autofs4_remove_rehash_entry(ino);
+		if (list_empty(&ino->rehash_list)) {
+			spin_unlock(&sbi->lookup_lock);
+			ino->flags &= ~AUTOFS_INF_REHASH;
+			d_rehash(dentry);
+			dput(ino->dentry);
+		} else
+			spin_unlock(&sbi->lookup_lock);
 	}
+	return;
+}
+
+static unsigned int autofs4_need_mount(unsigned int flags)
+{
+	unsigned int res = 0;
+	if (flags & (TRIGGER_FLAGS | TRIGGER_INTENTS))
+		res = 1;
+	return res;
+}
+
+static int autofs4_dir_open(struct inode *inode, struct file *file)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+
+	DPRINTK("file=%p dentry=%p %.*s",
+		file, dentry, dentry->d_name.len, dentry->d_name.name);
+
+	if (autofs4_oz_mode(sbi))
+		goto out;
 
-	/* We don't update the usages for the autofs daemon itself, this
-	   is necessary for recursive autofs mounts */
-	if (!autofs_oz_mode(sbi)) {
-		autofs_update_usage(&sbi->dirhash,ent);
+	/*
+	 * An empty directory in an autofs file system is always a
+	 * mount point. The daemon must have failed to mount this
+	 * during lookup so it doesn't exist. This can happen, for
+	 * example, if user space returns an incorrect status for a
+	 * mount request. Otherwise we're doing a readdir on the
+	 * autofs file system so just let the libfs routines handle
+	 * it.
+	 */
+	spin_lock(&dcache_lock);
+	if (!d_mountpoint(dentry) && list_empty(&dentry->d_subdirs)) {
+		spin_unlock(&dcache_lock);
+		return -ENOENT;
 	}
+	spin_unlock(&dcache_lock);
 
-	dentry->d_flags &= ~DCACHE_AUTOFS_PENDING;
-	return 1;
+out:
+	return dcache_dir_open(inode, file);
+}
+
+static int try_to_fill_dentry(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	int status;
+
+	DPRINTK("dentry=%p %.*s ino=%p",
+		dentry, dentry->d_name.len, dentry->d_name.name,
+		dentry->d_inode);
+
+	/*
+	 * Wait for a pending mount, triggering one if there
+	 * isn't one already
+	 */
+	DPRINTK("waiting for mount name=%.*s",
+		 dentry->d_name.len, dentry->d_name.name);
+
+	status = autofs4_wait(sbi, dentry, NFY_MOUNT);
+
+	DPRINTK("mount done status=%d", status);
+
+	/* Update expiry counter */
+	ino->last_used = jiffies;
+
+	return status;
 }
 
+/* For autofs direct mounts the follow link triggers the mount */
+static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
+{
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	int oz_mode = autofs4_oz_mode(sbi);
+	unsigned int lookup_type;
+	int status;
+
+	DPRINTK("dentry=%p %.*s oz_mode=%d nd->flags=%d",
+		dentry, dentry->d_name.len, dentry->d_name.name, oz_mode,
+		nd->flags);
+	/*
+	 * For an expire of a covered direct or offset mount we need
+	 * to break out of follow_down() at the autofs mount trigger
+	 * (d_mounted--), so we can see the expiring flag, and manage
+	 * the blocking and following here until the expire is completed.
+	 */
+	if (oz_mode) {
+		spin_lock(&sbi->fs_lock);
+		if (ino->flags & AUTOFS_INF_EXPIRING) {
+			spin_unlock(&sbi->fs_lock);
+			/* Follow down to our covering mount. */
+			if (!follow_down(&nd->path))
+				goto done;
+			goto follow;
+		}
+		spin_unlock(&sbi->fs_lock);
+		goto done;
+	}
+
+	/* If an expire request is pending everyone must wait. */
+	autofs4_expire_wait(dentry);
+
+	/* We trigger a mount for almost all flags */
+	lookup_type = autofs4_need_mount(nd->flags);
+	spin_lock(&sbi->fs_lock);
+	spin_lock(&dcache_lock);
+	if (!(lookup_type || ino->flags & AUTOFS_INF_PENDING)) {
+		spin_unlock(&dcache_lock);
+		spin_unlock(&sbi->fs_lock);
+		goto follow;
+	}
+
+	/*
+	 * If the dentry contains directories then it is an autofs
+	 * multi-mount with no root mount offset. So don't try to
+	 * mount it again.
+	 */
+	if (ino->flags & AUTOFS_INF_PENDING ||
+	    (!d_mountpoint(dentry) && list_empty(&dentry->d_subdirs))) {
+		ino->flags |= AUTOFS_INF_PENDING;
+		spin_unlock(&dcache_lock);
+		spin_unlock(&sbi->fs_lock);
+
+		status = try_to_fill_dentry(dentry);
+
+		spin_lock(&sbi->fs_lock);
+		ino->flags &= ~AUTOFS_INF_PENDING;
+		spin_unlock(&sbi->fs_lock);
+
+		if (status)
+			goto out_error;
+
+		goto follow;
+	}
+	spin_unlock(&dcache_lock);
+	spin_unlock(&sbi->fs_lock);
+follow:
+	/*
+	 * If there is no root mount it must be an autofs
+	 * multi-mount with no root offset so we don't need
+	 * to follow it.
+	 */
+	if (d_mountpoint(dentry)) {
+		if (!autofs4_follow_mount(&nd->path)) {
+			status = -ENOENT;
+			goto out_error;
+		}
+	}
+
+done:
+	return NULL;
+
+out_error:
+	path_put(&nd->path);
+	return ERR_PTR(status);
+}
 
 /*
  * Revalidate is called on every cache lookup.  Some of those
@@ -145,200 +357,520 @@ static int try_to_fill_dentry(struct dentry *dentry, struct super_block *sb, str
  * yet completely filled in, and revalidate has to delay such
  * lookups..
  */
-static int autofs_revalidate(struct dentry * dentry, struct nameidata *nd)
+static int autofs4_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
-	struct inode * dir;
-	struct autofs_sb_info *sbi;
-	struct autofs_dir_ent *ent;
-	int res;
+	struct inode *dir = dentry->d_parent->d_inode;
+	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct rehash_entry *entry;
+	int flags = nd ? nd->flags : 0;
+	unsigned int mutex_aquired;
+
+	DPRINTK("name = %.*s oz_mode = %d",
+		dentry->d_name.len, dentry->d_name.name, oz_mode);
 
-	lock_kernel();
-	dir = dentry->d_parent->d_inode;
-	sbi = autofs_sbi(dir->i_sb);
+	/* Daemon never causes a mount to trigger */
+	if (autofs4_oz_mode(sbi))
+		return 1;
 
+	entry = kmalloc(sizeof(struct rehash_entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+
+	mutex_aquired = mutex_trylock(&dir->i_mutex);
+
+	spin_lock(&sbi->fs_lock);
+	spin_lock(&dcache_lock);
 	/* Pending dentry */
-	if (dentry->d_flags & DCACHE_AUTOFS_PENDING) {
-		if (autofs_oz_mode(sbi))
-			res = 1;
-		else
-			res = try_to_fill_dentry(dentry, dir->i_sb, sbi);
-		unlock_kernel();
-		return res;
+	if (autofs4_ispending(dentry)) {
+		int status;
+
+		/*
+		 * We can only unhash and send this to ->lookup() if
+		 * the directory mutex is held over d_revalidate() and
+		 * ->lookup(). This prevents the VFS from incorrectly
+		 * seeing the dentry as non-existent.
+		 */
+		ino->flags |= AUTOFS_INF_PENDING;
+		if (!mutex_aquired) {
+			autofs4_revalidate_drop(dentry, entry);
+			spin_unlock(&dcache_lock);
+			spin_unlock(&sbi->fs_lock);
+			return 0;
+		}
+		spin_unlock(&dcache_lock);
+		spin_unlock(&sbi->fs_lock);
+		mutex_unlock(&dir->i_mutex);
+		kfree(entry);
+
+		/*
+		 * If the directory has gone away due to an expire
+		 * we have been called as ->d_revalidate() and so
+		 * we need to return false and proceed to ->lookup().
+		 */
+		if (autofs4_expire_wait(dentry) == -EAGAIN)
+			return 0;
+
+		/*
+		 * A zero status is success otherwise we have a
+		 * negative error code.
+		 */
+		status = try_to_fill_dentry(dentry);
+
+		spin_lock(&sbi->fs_lock);
+		ino->flags &= ~AUTOFS_INF_PENDING;
+		spin_unlock(&sbi->fs_lock);
+
+		if (status == 0)
+			return 1;
+
+		return status;
 	}
 
-	/* Negative dentry.. invalidate if "old" */
-	if (!dentry->d_inode) {
-		unlock_kernel();
-		return (dentry->d_time - jiffies <= AUTOFS_NEGATIVE_TIMEOUT);
+	/* Check for a non-mountpoint directory with no contents */
+	if (S_ISDIR(dentry->d_inode->i_mode) &&
+	    !d_mountpoint(dentry) && list_empty(&dentry->d_subdirs)) {
+		DPRINTK("dentry=%p %.*s, emptydir",
+			 dentry, dentry->d_name.len, dentry->d_name.name);
+
+		if (autofs4_need_mount(flags) || current->link_count) {
+			int status;
+
+			/*
+			 * We can only unhash and send this to ->lookup() if
+			 * the directory mutex is held over d_revalidate() and
+			 * ->lookup(). This prevents the VFS from incorrectly
+			 * seeing the dentry as non-existent.
+			 */
+			ino->flags |= AUTOFS_INF_PENDING;
+			if (!mutex_aquired) {
+				autofs4_revalidate_drop(dentry, entry);
+				spin_unlock(&dcache_lock);
+				spin_unlock(&sbi->fs_lock);
+				return 0;
+			}
+			spin_unlock(&dcache_lock);
+			spin_unlock(&sbi->fs_lock);
+			mutex_unlock(&dir->i_mutex);
+			kfree(entry);
+
+			/*
+			 * A zero status is success otherwise we have a
+			 * negative error code.
+			 */
+			status = try_to_fill_dentry(dentry);
+
+			spin_lock(&sbi->fs_lock);
+			ino->flags &= ~AUTOFS_INF_PENDING;
+			spin_unlock(&sbi->fs_lock);
+
+			if (status == 0)
+				return 1;
+
+			return status;
+		}
 	}
-		
-	/* Check for a non-mountpoint directory */
-	if (S_ISDIR(dentry->d_inode->i_mode) && !d_mountpoint(dentry)) {
-		if (autofs_oz_mode(sbi))
-			res = 1;
-		else
-			res = try_to_fill_dentry(dentry, dir->i_sb, sbi);
-		unlock_kernel();
-		return res;
+	spin_unlock(&dcache_lock);
+	spin_unlock(&sbi->fs_lock);
+
+	if (mutex_aquired)
+		mutex_unlock(&dir->i_mutex);
+
+	kfree(entry);
+
+	return 1;
+}
+
+static void autofs4_free_rehash_entrys(struct autofs_info *inf)
+{
+	struct list_head *head = &inf->rehash_list;
+	struct rehash_entry *entry, *next;
+	list_for_each_entry_safe(entry, next, head, list) {
+		list_del(&entry->list);
+		kfree(entry);
 	}
+}
+
+void autofs4_dentry_release(struct dentry *de)
+{
+	struct autofs_info *inf;
+
+	DPRINTK("releasing %p", de);
+
+	inf = autofs4_dentry_ino(de);
+	de->d_fsdata = NULL;
+
+	if (inf) {
+		struct autofs_sb_info *sbi = autofs4_sbi(de->d_sb);
+
+		if (sbi) {
+			spin_lock(&sbi->lookup_lock);
+			if (!list_empty(&inf->active))
+				list_del(&inf->active);
+			if (!list_empty(&inf->expiring))
+				list_del(&inf->expiring);
+			if (!list_empty(&inf->rehash_list))
+				autofs4_free_rehash_entrys(inf);
+			spin_unlock(&sbi->lookup_lock);
+		}
+
+		inf->dentry = NULL;
+		inf->inode = NULL;
 
-	/* Update the usage list */
-	if (!autofs_oz_mode(sbi)) {
-		ent = (struct autofs_dir_ent *) dentry->d_time;
-		if (ent)
-			autofs_update_usage(&sbi->dirhash,ent);
+		autofs4_free_ino(inf);
 	}
-	unlock_kernel();
-	return 1;
 }
 
-static const struct dentry_operations autofs_dentry_operations = {
-	.d_revalidate	= autofs_revalidate,
+/* For dentries of directories in the root dir */
+static const struct dentry_operations autofs4_root_dentry_operations = {
+	.d_revalidate	= autofs4_revalidate,
+	.d_release	= autofs4_dentry_release,
+};
+
+/* For other dentries */
+static const struct dentry_operations autofs4_dentry_operations = {
+	.d_revalidate	= autofs4_revalidate,
+	.d_release	= autofs4_dentry_release,
 };
 
-static struct dentry *autofs_root_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *autofs4_lookup_active(struct dentry *dentry)
 {
-	struct autofs_sb_info *sbi;
-	int oz_mode;
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct dentry *parent = dentry->d_parent;
+	struct qstr *name = &dentry->d_name;
+	unsigned int len = name->len;
+	unsigned int hash = name->hash;
+	const unsigned char *str = name->name;
+	struct list_head *p, *head;
+
+restart:
+	spin_lock(&dcache_lock);
+	spin_lock(&sbi->lookup_lock);
+	head = &sbi->active_list;
+	list_for_each(p, head) {
+		struct autofs_info *ino;
+		struct dentry *active;
+		struct qstr *qstr;
+
+		ino = list_entry(p, struct autofs_info, active);
+		active = ino->dentry;
+
+		spin_lock(&active->d_lock);
+
+		/* Already gone? */
+		if (atomic_read(&active->d_count) == 0)
+			goto next;
+
+		if (active->d_inode && IS_DEADDIR(active->d_inode)) {
+			if (!list_empty(&ino->rehash_list)) {
+				dget(active);
+				spin_unlock(&active->d_lock);
+				spin_unlock(&sbi->lookup_lock);
+				spin_unlock(&dcache_lock);
+				autofs4_remove_rehash_entrys(ino);
+				dput(active);
+				goto restart;
+			}
+			goto next;
+		}
+
+		qstr = &active->d_name;
+
+		if (active->d_name.hash != hash)
+			goto next;
+		if (active->d_parent != parent)
+			goto next;
+
+		if (qstr->len != len)
+			goto next;
+		if (memcmp(qstr->name, str, len))
+			goto next;
+
+		dget(active);
+		spin_unlock(&active->d_lock);
+		spin_unlock(&sbi->lookup_lock);
+		spin_unlock(&dcache_lock);
+		return active;
+next:
+		spin_unlock(&active->d_lock);
+	}
+	spin_unlock(&sbi->lookup_lock);
+	spin_unlock(&dcache_lock);
 
-	DPRINTK(("autofs_root_lookup: name = "));
-	lock_kernel();
-	autofs_say(dentry->d_name.name,dentry->d_name.len);
+	return NULL;
+}
 
-	if (dentry->d_name.len > NAME_MAX) {
-		unlock_kernel();
-		return ERR_PTR(-ENAMETOOLONG);/* File name too long to exist */
+static struct dentry *autofs4_lookup_expiring(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct dentry *parent = dentry->d_parent;
+	struct qstr *name = &dentry->d_name;
+	unsigned int len = name->len;
+	unsigned int hash = name->hash;
+	const unsigned char *str = name->name;
+	struct list_head *p, *head;
+
+	spin_lock(&dcache_lock);
+	spin_lock(&sbi->lookup_lock);
+	head = &sbi->expiring_list;
+	list_for_each(p, head) {
+		struct autofs_info *ino;
+		struct dentry *expiring;
+		struct qstr *qstr;
+
+		ino = list_entry(p, struct autofs_info, expiring);
+		expiring = ino->dentry;
+
+		spin_lock(&expiring->d_lock);
+
+		/* Bad luck, we've already been dentry_iput */
+		if (!expiring->d_inode)
+			goto next;
+
+		qstr = &expiring->d_name;
+
+		if (expiring->d_name.hash != hash)
+			goto next;
+		if (expiring->d_parent != parent)
+			goto next;
+
+		if (qstr->len != len)
+			goto next;
+		if (memcmp(qstr->name, str, len))
+			goto next;
+
+		dget(expiring);
+		spin_unlock(&expiring->d_lock);
+		spin_unlock(&sbi->lookup_lock);
+		spin_unlock(&dcache_lock);
+		return expiring;
+next:
+		spin_unlock(&expiring->d_lock);
 	}
+	spin_unlock(&sbi->lookup_lock);
+	spin_unlock(&dcache_lock);
 
-	sbi = autofs_sbi(dir->i_sb);
+	return NULL;
+}
 
-	oz_mode = autofs_oz_mode(sbi);
-	DPRINTK(("autofs_lookup: pid = %u, pgrp = %u, catatonic = %d, "
-				"oz_mode = %d\n", task_pid_nr(current),
-				task_pgrp_nr(current), sbi->catatonic,
-				oz_mode));
+static struct autofs_info *init_new_dentry(struct autofs_sb_info *sbi,
+					   struct dentry *dentry, int oz_mode)
+{
+	struct autofs_info *ino;
 
 	/*
-	 * Mark the dentry incomplete, but add it. This is needed so
-	 * that the VFS layer knows about the dentry, and we can count
-	 * on catching any lookups through the revalidate.
-	 *
-	 * Let all the hard work be done by the revalidate function that
-	 * needs to be able to do this anyway..
-	 *
-	 * We need to do this before we release the directory semaphore.
+	 * Mark the dentry incomplete but don't hash it. We do this
+	 * to serialize our inode creation operations (symlink and
+	 * mkdir) which prevents deadlock during the callback to
+	 * the daemon. Subsequent user space lookups for the same
+	 * dentry are placed on the wait queue while the daemon
+	 * itself is allowed passage unresticted so the create
+	 * operation itself can then hash the dentry. Finally,
+	 * we check for the hashed dentry and return the newly
+	 * hashed dentry.
 	 */
-	dentry->d_op = &autofs_dentry_operations;
-	dentry->d_flags |= DCACHE_AUTOFS_PENDING;
-	d_add(dentry, NULL);
+	dentry->d_op = &autofs4_root_dentry_operations;
 
-	mutex_unlock(&dir->i_mutex);
-	autofs_revalidate(dentry, nd);
-	mutex_lock(&dir->i_mutex);
+	/*
+	 * And we need to ensure that the same dentry is used for
+	 * all following lookup calls until it is hashed so that
+	 * the dentry flags are persistent throughout the request.
+	 */
+	ino = autofs4_init_ino(NULL, sbi, 0555);
+	if (!ino)
+		return ERR_PTR(-ENOMEM);
+
+	dentry->d_fsdata = ino;
+	ino->dentry = dentry;
 
 	/*
-	 * If we are still pending, check if we had to handle
+	 * Only set the mount pending flag for new dentrys not created
+	 * by the daemon.
+	 */
+	if (!oz_mode)
+		ino->flags |= AUTOFS_INF_PENDING;
+
+	d_instantiate(dentry, NULL);
+
+	return ino;
+}
+
+/* Lookups in the root directory */
+static struct dentry *autofs4_lookup(struct inode *dir,
+				     struct dentry *dentry,
+				     struct nameidata *nd)
+{
+	struct autofs_sb_info *sbi;
+	struct autofs_info *ino;
+	struct dentry *expiring, *active;
+	int oz_mode;
+	int status = 0;
+
+	DPRINTK("name = %.*s",
+		dentry->d_name.len, dentry->d_name.name);
+
+	/* File name too long to exist */
+	if (dentry->d_name.len > NAME_MAX)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	sbi = autofs4_sbi(dir->i_sb);
+	oz_mode = autofs4_oz_mode(sbi);
+
+	DPRINTK("pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d",
+		 current->pid, task_pgrp_nr(current), sbi->catatonic, oz_mode);
+
+	spin_lock(&sbi->fs_lock);
+	active = autofs4_lookup_active(dentry);
+	if (active) {
+		dentry = active;
+		ino = autofs4_dentry_ino(dentry);
+		/* If this came from revalidate, rehash it */
+		autofs4_revalidate_rehash(dentry);
+		spin_unlock(&sbi->fs_lock);
+	} else {
+		spin_unlock(&sbi->fs_lock);
+		ino = init_new_dentry(sbi, dentry, oz_mode);
+		if (IS_ERR(ino))
+			return (struct dentry *) ino;
+	}
+
+	autofs4_add_active(dentry);
+
+	if (!oz_mode) {
+		expiring = autofs4_lookup_expiring(dentry);
+		mutex_unlock(&dir->i_mutex);
+		if (expiring) {
+			/*
+			 * If we are racing with expire the request might not
+			 * be quite complete but the directory has been removed
+			 * so it must have been successful, so just wait for it.
+			 */
+			autofs4_expire_wait(expiring);
+			dput(expiring);
+		}
+		status = try_to_fill_dentry(dentry);
+		mutex_lock(&dir->i_mutex);
+		spin_lock(&sbi->fs_lock);
+		ino->flags &= ~AUTOFS_INF_PENDING;
+		spin_unlock(&sbi->fs_lock);
+	}
+
+	autofs4_del_active(dentry);
+
+	/*
+	 * If we had a mount fail, check if we had to handle
 	 * a signal. If so we can force a restart..
 	 */
-	if (dentry->d_flags & DCACHE_AUTOFS_PENDING) {
+	if (status) {
 		/* See if we were interrupted */
 		if (signal_pending(current)) {
 			sigset_t *sigset = &current->pending.signal;
-			if (sigismember (sigset, SIGKILL) ||
-			    sigismember (sigset, SIGQUIT) ||
-			    sigismember (sigset, SIGINT)) {
-				unlock_kernel();
-				return ERR_PTR(-ERESTARTNOINTR);
+			if (sigismember(sigset, SIGKILL) ||
+			    sigismember(sigset, SIGQUIT) ||
+			    sigismember(sigset, SIGINT)) {
+			    if (active)
+				dput(active);
+			    return ERR_PTR(-ERESTARTNOINTR);
 			}
 		}
 	}
-	unlock_kernel();
 
 	/*
-	 * If this dentry is unhashed, then we shouldn't honour this
-	 * lookup even if the dentry is positive.  Returning ENOENT here
-	 * doesn't do the right thing for all system calls, but it should
-	 * be OK for the operations we permit from an autofs.
+	 * User space can (and has done in the past) remove and re-create
+	 * this directory during the callback. This can leave us with an
+	 * unhashed dentry, but a successful mount!  So we need to
+	 * perform another cached lookup in case the dentry now exists.
+	 */
+	if (!oz_mode && !have_submounts(dentry)) {
+		struct dentry *new;
+		new = d_lookup(dentry->d_parent, &dentry->d_name);
+		if (new) {
+			if (active)
+				dput(active);
+			return new;
+		} else {
+			if (!status)
+				status = -ENOENT;
+		}
+	}
+
+	/*
+	 * If we had a mount failure, return status to user space.
+	 * If the mount succeeded and we used a dentry from the active queue
+	 * return it.
 	 */
-	if (dentry->d_inode && d_unhashed(dentry))
-		return ERR_PTR(-ENOENT);
+	if (status) {
+		dentry = ERR_PTR(status);
+		if (active)
+			dput(active);
+		return dentry;
+	} else {
+		/*
+		 * Valid successful mount, return active dentry or NULL
+		 * for a new dentry.
+		 */
+		if (active)
+			return active;
+	}
 
 	return NULL;
 }
 
-static int autofs_root_symlink(struct inode *dir, struct dentry *dentry, const char *symname)
+static int autofs4_dir_symlink(struct inode *dir,
+			       struct dentry *dentry,
+			       const char *symname)
 {
-	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
-	struct autofs_dirhash *dh = &sbi->dirhash;
-	struct autofs_dir_ent *ent;
-	unsigned int n;
-	int slsize;
-	struct autofs_symlink *sl;
+	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_info *p_ino;
 	struct inode *inode;
+	char *cp;
 
-	DPRINTK(("autofs_root_symlink: %s <- ", symname));
-	autofs_say(dentry->d_name.name,dentry->d_name.len);
+	DPRINTK("%s <- %.*s", symname,
+		dentry->d_name.len, dentry->d_name.name);
 
-	lock_kernel();
-	if (!autofs_oz_mode(sbi)) {
-		unlock_kernel();
+	if (!autofs4_oz_mode(sbi))
 		return -EACCES;
-	}
 
-	if (autofs_hash_lookup(dh, &dentry->d_name)) {
-		unlock_kernel();
-		return -EEXIST;
-	}
+	ino = autofs4_init_ino(ino, sbi, S_IFLNK | 0555);
+	if (!ino)
+		return -ENOMEM;
 
-	n = find_first_zero_bit(sbi->symlink_bitmap,AUTOFS_MAX_SYMLINKS);
-	if (n >= AUTOFS_MAX_SYMLINKS) {
-		unlock_kernel();
-		return -ENOSPC;
+	ino->size = strlen(symname);
+	cp = kmalloc(ino->size + 1, GFP_KERNEL);
+	if (!cp) {
+		if (!dentry->d_fsdata)
+			kfree(ino);
+		return -ENOMEM;
 	}
 
-	set_bit(n,sbi->symlink_bitmap);
-	sl = &sbi->symlink[n];
-	sl->len = strlen(symname);
-	sl->data = kmalloc(slsize = sl->len+1, GFP_KERNEL);
-	if (!sl->data) {
-		clear_bit(n,sbi->symlink_bitmap);
-		unlock_kernel();
-		return -ENOSPC;
-	}
+	strcpy(cp, symname);
 
-	ent = kmalloc(sizeof(struct autofs_dir_ent), GFP_KERNEL);
-	if (!ent) {
-		kfree(sl->data);
-		clear_bit(n,sbi->symlink_bitmap);
-		unlock_kernel();
-		return -ENOSPC;
+	inode = autofs4_get_inode(dir->i_sb, ino);
+	if (!inode) {
+		kfree(cp);
+		if (!dentry->d_fsdata)
+			kfree(ino);
+		return -ENOMEM;
 	}
+	d_add(dentry, inode);
 
-	ent->name = kmalloc(dentry->d_name.len+1, GFP_KERNEL);
-	if (!ent->name) {
-		kfree(sl->data);
-		kfree(ent);
-		clear_bit(n,sbi->symlink_bitmap);
-		unlock_kernel();
-		return -ENOSPC;
-	}
-
-	memcpy(sl->data,symname,slsize);
-	sl->mtime = get_seconds();
-
-	ent->ino = AUTOFS_FIRST_SYMLINK + n;
-	ent->hash = dentry->d_name.hash;
-	memcpy(ent->name, dentry->d_name.name, 1+(ent->len = dentry->d_name.len));
-	ent->dentry = NULL;	/* We don't keep the dentry for symlinks */
+	if (dir == dir->i_sb->s_root->d_inode)
+		dentry->d_op = &autofs4_root_dentry_operations;
+	else
+		dentry->d_op = &autofs4_dentry_operations;
 
-	autofs_hash_insert(dh,ent);
+	dentry->d_fsdata = ino;
+	ino->dentry = dget(dentry);
+	atomic_inc(&ino->count);
+	p_ino = autofs4_dentry_ino(dentry->d_parent);
+	if (p_ino && dentry->d_parent != dentry)
+		atomic_inc(&p_ino->count);
+	ino->inode = inode;
 
-	inode = autofs_iget(dir->i_sb, ent->ino);
-	if (IS_ERR(inode))
-		return PTR_ERR(inode);
+	ino->u.symlink = cp;
+	dir->i_mtime = CURRENT_TIME;
 
-	d_instantiate(dentry, inode);
-	unlock_kernel();
 	return 0;
 }
 
@@ -347,157 +879,137 @@ static int autofs_root_symlink(struct inode *dir, struct dentry *dentry, const c
  *
  * Normal filesystems would do a "d_delete()" to tell the VFS dcache
  * that the file no longer exists. However, doing that means that the
- * VFS layer can turn the dentry into a negative dentry, which we
- * obviously do not want (we're dropping the entry not because it
- * doesn't exist, but because it has timed out).
+ * VFS layer can turn the dentry into a negative dentry.  We don't want
+ * this, because the unlink is probably the result of an expire.
+ * We simply d_drop it and add it to a expiring list in the super block,
+ * which allows the dentry lookup to check for an incomplete expire.
+ *
+ * If a process is blocked on the dentry waiting for the expire to finish,
+ * it will invalidate the dentry and try to mount with a new one.
  *
- * Also see autofs_root_rmdir()..
+ * Also see autofs4_dir_rmdir()..
  */
-static int autofs_root_unlink(struct inode *dir, struct dentry *dentry)
+static int autofs4_dir_unlink(struct inode *dir, struct dentry *dentry)
 {
-	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
-	struct autofs_dirhash *dh = &sbi->dirhash;
-	struct autofs_dir_ent *ent;
-	unsigned int n;
+	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_info *p_ino;
 
 	/* This allows root to remove symlinks */
-	lock_kernel();
-	if (!autofs_oz_mode(sbi) && !capable(CAP_SYS_ADMIN)) {
-		unlock_kernel();
+	if (!autofs4_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
 		return -EACCES;
-	}
 
-	ent = autofs_hash_lookup(dh, &dentry->d_name);
-	if (!ent) {
-		unlock_kernel();
-		return -ENOENT;
+	if (atomic_dec_and_test(&ino->count)) {
+		p_ino = autofs4_dentry_ino(dentry->d_parent);
+		if (p_ino && dentry->d_parent != dentry)
+			atomic_dec(&p_ino->count);
 	}
+	dput(ino->dentry);
+
+	dentry->d_inode->i_size = 0;
+	clear_nlink(dentry->d_inode);
+
+	dir->i_mtime = CURRENT_TIME;
+
+	spin_lock(&dcache_lock);
+	spin_lock(&dentry->d_lock);
+	__d_drop(dentry);
+	spin_unlock(&dentry->d_lock);
+	spin_unlock(&dcache_lock);
 
-	n = ent->ino - AUTOFS_FIRST_SYMLINK;
-	if (n >= AUTOFS_MAX_SYMLINKS) {
-		unlock_kernel();
-		return -EISDIR;	/* It's a directory, dummy */
-	}
-	if (!test_bit(n,sbi->symlink_bitmap)) {
-		unlock_kernel();
-		return -EINVAL;	/* Nonexistent symlink?  Shouldn't happen */
-	}
-	
-	dentry->d_time = (unsigned long)(struct autofs_dirhash *)NULL;
-	autofs_hash_delete(ent);
-	clear_bit(n,sbi->symlink_bitmap);
-	kfree(sbi->symlink[n].data);
-	d_drop(dentry);
-	
-	unlock_kernel();
 	return 0;
 }
 
-static int autofs_root_rmdir(struct inode *dir, struct dentry *dentry)
+static int autofs4_dir_rmdir(struct inode *dir, struct dentry *dentry)
 {
-	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
-	struct autofs_dirhash *dh = &sbi->dirhash;
-	struct autofs_dir_ent *ent;
+	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_info *p_ino;
 
-	lock_kernel();
-	if (!autofs_oz_mode(sbi)) {
-		unlock_kernel();
-		return -EACCES;
-	}
+	DPRINTK("dentry %p, removing %.*s",
+		dentry, dentry->d_name.len, dentry->d_name.name);
 
-	ent = autofs_hash_lookup(dh, &dentry->d_name);
-	if (!ent) {
-		unlock_kernel();
-		return -ENOENT;
-	}
+	if (!autofs4_oz_mode(sbi))
+		return -EACCES;
 
-	if ((unsigned int)ent->ino < AUTOFS_FIRST_DIR_INO) {
-		unlock_kernel();
-		return -ENOTDIR; /* Not a directory */
+	spin_lock(&dcache_lock);
+	if (!list_empty(&dentry->d_subdirs)) {
+		spin_unlock(&dcache_lock);
+		return -ENOTEMPTY;
 	}
-
-	if (ent->dentry != dentry) {
-		printk("autofs_rmdir: odentry != dentry for entry %s\n", dentry->d_name.name);
+	spin_lock(&dentry->d_lock);
+	__d_drop(dentry);
+	spin_unlock(&dentry->d_lock);
+	spin_unlock(&dcache_lock);
+
+	if (atomic_dec_and_test(&ino->count)) {
+		p_ino = autofs4_dentry_ino(dentry->d_parent);
+		if (p_ino && dentry->d_parent != dentry)
+			atomic_dec(&p_ino->count);
 	}
+	dput(ino->dentry);
+	dentry->d_inode->i_size = 0;
+	clear_nlink(dentry->d_inode);
 
-	dentry->d_time = (unsigned long)(struct autofs_dir_ent *)NULL;
-	autofs_hash_delete(ent);
-	drop_nlink(dir);
-	d_drop(dentry);
-	unlock_kernel();
+	if (dir->i_nlink)
+		drop_nlink(dir);
 
 	return 0;
 }
 
-static int autofs_root_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
-	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
-	struct autofs_dirhash *dh = &sbi->dirhash;
-	struct autofs_dir_ent *ent;
+	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_info *p_ino;
 	struct inode *inode;
-	ino_t ino;
 
-	lock_kernel();
-	if (!autofs_oz_mode(sbi)) {
-		unlock_kernel();
+	if (!autofs4_oz_mode(sbi))
 		return -EACCES;
-	}
 
-	ent = autofs_hash_lookup(dh, &dentry->d_name);
-	if (ent) {
-		unlock_kernel();
-		return -EEXIST;
-	}
+	DPRINTK("dentry %p, creating %.*s",
+		dentry, dentry->d_name.len, dentry->d_name.name);
 
-	if (sbi->next_dir_ino < AUTOFS_FIRST_DIR_INO) {
-		printk("autofs: Out of inode numbers -- what the heck did you do??\n");
-		unlock_kernel();
-		return -ENOSPC;
-	}
-	ino = sbi->next_dir_ino++;
+	ino = autofs4_init_ino(ino, sbi, S_IFDIR | 0555);
+	if (!ino)
+		return -ENOMEM;
 
-	ent = kmalloc(sizeof(struct autofs_dir_ent), GFP_KERNEL);
-	if (!ent) {
-		unlock_kernel();
-		return -ENOSPC;
+	inode = autofs4_get_inode(dir->i_sb, ino);
+	if (!inode) {
+		if (!dentry->d_fsdata)
+			kfree(ino);
+		return -ENOMEM;
 	}
+	d_add(dentry, inode);
 
-	ent->name = kmalloc(dentry->d_name.len+1, GFP_KERNEL);
-	if (!ent->name) {
-		kfree(ent);
-		unlock_kernel();
-		return -ENOSPC;
-	}
-
-	ent->hash = dentry->d_name.hash;
-	memcpy(ent->name, dentry->d_name.name, 1+(ent->len = dentry->d_name.len));
-	ent->ino = ino;
-	ent->dentry = dentry;
-	autofs_hash_insert(dh,ent);
-
+	if (dir == dir->i_sb->s_root->d_inode)
+		dentry->d_op = &autofs4_root_dentry_operations;
+	else
+		dentry->d_op = &autofs4_dentry_operations;
+
+	dentry->d_fsdata = ino;
+	ino->dentry = dget(dentry);
+	atomic_inc(&ino->count);
+	p_ino = autofs4_dentry_ino(dentry->d_parent);
+	if (p_ino && dentry->d_parent != dentry)
+		atomic_inc(&p_ino->count);
+	ino->inode = inode;
 	inc_nlink(dir);
-
-	inode = autofs_iget(dir->i_sb, ino);
-	if (IS_ERR(inode)) {
-		drop_nlink(dir);
-		return PTR_ERR(inode);
-	}
-
-	d_instantiate(dentry, inode);
-	unlock_kernel();
+	dir->i_mtime = CURRENT_TIME;
 
 	return 0;
 }
 
 /* Get/set timeout ioctl() operation */
-static inline int autofs_get_set_timeout(struct autofs_sb_info *sbi,
+static inline int autofs4_get_set_timeout(struct autofs_sb_info *sbi,
 					 unsigned long __user *p)
 {
+	int rv;
 	unsigned long ntimeout;
 
-	if (get_user(ntimeout, p) ||
-	    put_user(sbi->exp_timeout / HZ, p))
-		return -EFAULT;
+	if ((rv = get_user(ntimeout, p)) ||
+	     (rv = put_user(sbi->exp_timeout/HZ, p)))
+		return rv;
 
 	if (ntimeout > ULONG_MAX/HZ)
 		sbi->exp_timeout = 0;
@@ -508,72 +1020,96 @@ static inline int autofs_get_set_timeout(struct autofs_sb_info *sbi,
 }
 
 /* Return protocol version */
-static inline int autofs_get_protover(int __user *p)
+static inline int
+autofs4_get_protover(struct autofs_sb_info *sbi, int __user *p)
 {
-	return put_user(AUTOFS_PROTO_VERSION, p);
+	return put_user(sbi->version, p);
 }
 
-/* Perform an expiry operation */
-static inline int autofs_expire_run(struct super_block *sb,
-				    struct autofs_sb_info *sbi,
-				    struct vfsmount *mnt,
-				    struct autofs_packet_expire __user *pkt_p)
+/* Return protocol sub version */
+static inline int
+autofs4_get_protosubver(struct autofs_sb_info *sbi, int __user *p)
 {
-	struct autofs_dir_ent *ent;
-	struct autofs_packet_expire pkt;
+	return put_user(sbi->sub_version, p);
+}
 
-	memset(&pkt,0,sizeof pkt);
+/*
+* Tells the daemon whether it can umount the autofs mount.
+*/
+static inline int autofs4_ask_umount(struct vfsmount *mnt, int __user *p)
+{
+	int status = 0;
 
-	pkt.hdr.proto_version = AUTOFS_PROTO_VERSION;
-	pkt.hdr.type = autofs_ptype_expire;
+	if (may_umount(mnt))
+		status = 1;
 
-	if (!sbi->exp_timeout || !(ent = autofs_expire(sb,sbi,mnt)))
-		return -EAGAIN;
+	DPRINTK("returning %d", status);
 
-	pkt.len = ent->len;
-	memcpy(pkt.name, ent->name, pkt.len);
-	pkt.name[pkt.len] = '\0';
+	status = put_user(status, p);
 
-	if (copy_to_user(pkt_p, &pkt, sizeof(struct autofs_packet_expire)))
-		return -EFAULT;
+	return status;
+}
 
-	return 0;
+/* Identify autofs4_dentries - this is so we can tell if there's
+   an extra dentry refcount or not.  We only hold a refcount on the
+   dentry if its non-negative (ie, d_inode != NULL)
+*/
+int is_autofs4_dentry(struct dentry *dentry)
+{
+	return dentry && dentry->d_inode &&
+		(dentry->d_op == &autofs4_root_dentry_operations ||
+		 dentry->d_op == &autofs4_dentry_operations) &&
+		dentry->d_fsdata != NULL;
 }
 
 /*
  * ioctl()'s on the root directory is the chief method for the daemon to
  * generate kernel reactions
  */
-static int autofs_root_ioctl(struct inode *inode, struct file *filp,
+static int autofs4_root_ioctl(struct inode *inode, struct file *filp,
 			     unsigned int cmd, unsigned long arg)
 {
-	struct autofs_sb_info *sbi = autofs_sbi(inode->i_sb);
-	void __user *argp = (void __user *)arg;
+	struct autofs_sb_info *sbi = autofs4_sbi(inode->i_sb);
+	void __user *p = (void __user *)arg;
 
-	DPRINTK(("autofs_ioctl: cmd = 0x%08x, arg = 0x%08lx, sbi = %p, pgrp = %u\n",cmd,arg,sbi,task_pgrp_nr(current)));
+	DPRINTK("cmd = 0x%08x, arg = 0x%08lx, sbi = %p, pgrp = %u",
+		cmd, arg, sbi, task_pgrp_nr(current));
 
 	if (_IOC_TYPE(cmd) != _IOC_TYPE(AUTOFS_IOC_FIRST) ||
 	     _IOC_NR(cmd) - _IOC_NR(AUTOFS_IOC_FIRST) >= AUTOFS_IOC_COUNT)
 		return -ENOTTY;
 	
-	if (!autofs_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
+	if (!autofs4_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	
 	switch(cmd) {
 	case AUTOFS_IOC_READY:	/* Wait queue: go ahead and retry */
-		return autofs_wait_release(sbi,(autofs_wqt_t)arg,0);
+		return autofs4_wait_release(sbi, (autofs_wqt_t)arg, 0);
 	case AUTOFS_IOC_FAIL:	/* Wait queue: fail with ENOENT */
-		return autofs_wait_release(sbi,(autofs_wqt_t)arg,-ENOENT);
+		return autofs4_wait_release(sbi, (autofs_wqt_t)arg, -ENOENT);
 	case AUTOFS_IOC_CATATONIC: /* Enter catatonic mode (daemon shutdown) */
-		autofs_catatonic_mode(sbi);
+		autofs4_catatonic_mode(sbi);
 		return 0;
 	case AUTOFS_IOC_PROTOVER: /* Get protocol version */
-		return autofs_get_protover(argp);
+		return autofs4_get_protover(sbi, p);
+	case AUTOFS_IOC_PROTOSUBVER: /* Get protocol sub version */
+		return autofs4_get_protosubver(sbi, p);
 	case AUTOFS_IOC_SETTIMEOUT:
-		return autofs_get_set_timeout(sbi, argp);
+		return autofs4_get_set_timeout(sbi, p);
+
+	case AUTOFS_IOC_ASKUMOUNT:
+		return autofs4_ask_umount(filp->f_path.mnt, p);
+
+	/* return a single thing to expire */
 	case AUTOFS_IOC_EXPIRE:
-		return autofs_expire_run(inode->i_sb, sbi, filp->f_path.mnt,
-					 argp);
+		return autofs4_expire_run(inode->i_sb,
+					  filp->f_path.mnt, sbi, p);
+
+	/* same as above, but can send multiple expires through pipe */
+	case AUTOFS_IOC_EXPIRE_MULTI:
+		return autofs4_expire_multi(inode->i_sb,
+					    filp->f_path.mnt, sbi, p);
+
 	default:
 		return -ENOSYS;
 	}
diff --git a/fs/autofs/symlink.c b/fs/autofs/symlink.c
index 7ce9cb2..296fbd9 100644
--- a/fs/autofs/symlink.c
+++ b/fs/autofs/symlink.c
@@ -1,7 +1,4 @@
-/* -*- linux-c -*- --------------------------------------------------------- *
- *
- * linux/fs/autofs/symlink.c
- *
+/*
  *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
  *
  * This file is part of the Linux kernel and is made available under
@@ -12,15 +9,14 @@
 
 #include "autofs_i.h"
 
-/* Nothing to release.. */
-static void *autofs_follow_link(struct dentry *dentry, struct nameidata *nd)
+static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
-	char *s=((struct autofs_symlink *)dentry->d_inode->i_private)->data;
-	nd_set_link(nd, s);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	nd_set_link(nd, (char *)ino->u.symlink);
 	return NULL;
 }
 
-const struct inode_operations autofs_symlink_inode_operations = {
+const struct inode_operations autofs4_symlink_inode_operations = {
 	.readlink	= generic_readlink,
-	.follow_link	= autofs_follow_link
+	.follow_link	= autofs4_follow_link
 };
diff --git a/fs/autofs/waitq.c b/fs/autofs/waitq.c
index be46805..a4e55da 100644
--- a/fs/autofs/waitq.c
+++ b/fs/autofs/waitq.c
@@ -1,8 +1,6 @@
-/* -*- linux-c -*- --------------------------------------------------------- *
- *
- * linux/fs/autofs/waitq.c
- *
+/*
  *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
+ *  Copyright 2001-2006 Ian Kent <raven@themaw.net>
  *
  * This file is part of the Linux kernel and is made available under
  * the terms of the GNU General Public License, version 2, or at your
@@ -18,34 +16,44 @@
 
 /* We make this a static variable rather than a part of the superblock; it
    is better if we don't reassign numbers easily even across filesystems */
-static autofs_wqt_t autofs_next_wait_queue = 1;
+static autofs_wqt_t autofs4_next_wait_queue = 1;
 
 /* These are the signals we allow interrupting a pending mount */
 #define SHUTDOWN_SIGS	(sigmask(SIGKILL) | sigmask(SIGINT) | sigmask(SIGQUIT))
 
-void autofs_catatonic_mode(struct autofs_sb_info *sbi)
+void autofs4_catatonic_mode(struct autofs_sb_info *sbi)
 {
 	struct autofs_wait_queue *wq, *nwq;
 
-	DPRINTK(("autofs: entering catatonic mode\n"));
+	mutex_lock(&sbi->wq_mutex);
+	if (sbi->catatonic) {
+		mutex_unlock(&sbi->wq_mutex);
+		return;
+	}
+
+	DPRINTK("entering catatonic mode");
 
 	sbi->catatonic = 1;
 	wq = sbi->queues;
 	sbi->queues = NULL;	/* Erase all wait queues */
-	while ( wq ) {
+	while (wq) {
 		nwq = wq->next;
 		wq->status = -ENOENT; /* Magic is gone - report failure */
-		kfree(wq->name);
-		wq->name = NULL;
-		wake_up(&wq->queue);
+		if (wq->name.name) {
+			kfree(wq->name.name);
+			wq->name.name = NULL;
+		}
+		wq->wait_ctr--;
+		wake_up_interruptible(&wq->queue);
 		wq = nwq;
 	}
 	fput(sbi->pipe);	/* Close the pipe */
 	sbi->pipe = NULL;
-	autofs_hash_dputall(&sbi->dirhash); /* Remove all dentry pointers */
+	sbi->pipefd = -1;
+	mutex_unlock(&sbi->wq_mutex);
 }
 
-static int autofs_write(struct file *file, const void *addr, int bytes)
+static int autofs4_write(struct file *file, const void *addr, int bytes)
 {
 	unsigned long sigpipe, flags;
 	mm_segment_t fs;
@@ -80,125 +88,437 @@ static int autofs_write(struct file *file, const void *addr, int bytes)
 	return (bytes > 0);
 }
 	
-static void autofs_notify_daemon(struct autofs_sb_info *sbi, struct autofs_wait_queue *wq)
+static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
+				 struct autofs_wait_queue *wq,
+				 int type)
 {
-	struct autofs_packet_missing pkt;
+	union {
+		struct autofs_packet_hdr hdr;
+		union autofs_packet_union v4_pkt;
+		union autofs_v5_packet_union v5_pkt;
+	} pkt;
+	struct file *pipe = NULL;
+	size_t pktsz;
 
-	DPRINTK(("autofs_wait: wait id = 0x%08lx, name = ", wq->wait_queue_token));
-	autofs_say(wq->name,wq->len);
+	DPRINTK("wait id = 0x%08lx, name = %.*s, type=%d",
+		wq->wait_queue_token, wq->name.len, wq->name.name, type);
 
 	memset(&pkt,0,sizeof pkt); /* For security reasons */
 
-	pkt.hdr.proto_version = AUTOFS_PROTO_VERSION;
-	pkt.hdr.type = autofs_ptype_missing;
-	pkt.wait_queue_token = wq->wait_queue_token;
-	pkt.len = wq->len;
-        memcpy(pkt.name, wq->name, pkt.len);
-	pkt.name[pkt.len] = '\0';
+	pkt.hdr.proto_version = sbi->version;
+	pkt.hdr.type = type;
+	switch (type) {
+	/* Kernel protocol v4 missing and expire packets */
+	case autofs_ptype_missing:
+	{
+		struct autofs_packet_missing *mp;
+
+		mp = &pkt.v4_pkt.missing;
+		pktsz = sizeof(*mp);
+
+		mp->wait_queue_token = wq->wait_queue_token;
+		mp->len = wq->name.len;
+		memcpy(mp->name, wq->name.name, wq->name.len);
+		mp->name[wq->name.len] = '\0';
+		break;
+	}
+	case autofs_ptype_expire_multi:
+	{
+		struct autofs_packet_expire_multi *ep;
+
+		ep = &pkt.v4_pkt.expire_multi;
+		pktsz = sizeof(*ep);
+
+		ep->wait_queue_token = wq->wait_queue_token;
+		ep->len = wq->name.len;
+		memcpy(ep->name, wq->name.name, wq->name.len);
+		ep->name[wq->name.len] = '\0';
+		break;
+	}
+	/*
+	 * Kernel protocol v5 packet for handling indirect and direct
+	 * mount missing and expire requests
+	 */
+	case autofs_ptype_missing_indirect:
+	case autofs_ptype_expire_indirect:
+	case autofs_ptype_missing_direct:
+	case autofs_ptype_expire_direct:
+	{
+		struct autofs_v5_packet *packet;
+
+		packet = &pkt.v5_pkt.v5_packet;
+		pktsz = sizeof(*packet);
+
+		packet->wait_queue_token = wq->wait_queue_token;
+		packet->len = wq->name.len;
+		memcpy(packet->name, wq->name.name, wq->name.len);
+		packet->name[wq->name.len] = '\0';
+		packet->dev = wq->dev;
+		packet->ino = wq->ino;
+		packet->uid = wq->uid;
+		packet->gid = wq->gid;
+		packet->pid = wq->pid;
+		packet->tgid = wq->tgid;
+		break;
+	}
+	default:
+		printk(KERN_ERR "autofs4_notify_daemon: bad type %d!\n", type);
+		return;
+	}
+
+	/* Check if we have become catatonic */
+	mutex_lock(&sbi->wq_mutex);
+	if (!sbi->catatonic) {
+		pipe = sbi->pipe;
+		get_file(pipe);
+	}
+	mutex_unlock(&sbi->wq_mutex);
+
+	if (pipe) {
+		if (autofs4_write(pipe, &pkt, pktsz))
+			autofs4_catatonic_mode(sbi);
+		fput(pipe);
+	}
+}
+
+static int autofs4_getpath(struct autofs_sb_info *sbi,
+			   struct dentry *dentry, char **name)
+{
+	struct dentry *root = sbi->sb->s_root;
+	struct dentry *tmp;
+	char *buf = *name;
+	char *p;
+	int len = 0;
+
+	spin_lock(&dcache_lock);
+	for (tmp = dentry ; tmp != root ; tmp = tmp->d_parent)
+		len += tmp->d_name.len + 1;
+
+	if (!len || --len > NAME_MAX) {
+		spin_unlock(&dcache_lock);
+		return 0;
+	}
+
+	*(buf + len) = '\0';
+	p = buf + len - dentry->d_name.len;
+	strncpy(p, dentry->d_name.name, dentry->d_name.len);
+
+	for (tmp = dentry->d_parent; tmp != root ; tmp = tmp->d_parent) {
+		*(--p) = '/';
+		p -= tmp->d_name.len;
+		strncpy(p, tmp->d_name.name, tmp->d_name.len);
+	}
+	spin_unlock(&dcache_lock);
+
+	return len;
+}
+
+static struct autofs_wait_queue *
+autofs4_find_wait(struct autofs_sb_info *sbi, struct qstr *qstr)
+{
+	struct autofs_wait_queue *wq;
+
+	for (wq = sbi->queues; wq; wq = wq->next) {
+		if (wq->name.hash == qstr->hash &&
+		    wq->name.len == qstr->len &&
+		    wq->name.name &&
+			 !memcmp(wq->name.name, qstr->name, qstr->len))
+			break;
+	}
+	return wq;
+}
+
+/*
+ * Check if we have a valid request.
+ * Returns
+ * 1 if the request should continue.
+ *   In this case we can return an autofs_wait_queue entry if one is
+ *   found or NULL to idicate a new wait needs to be created.
+ * 0 or a negative errno if the request shouldn't continue.
+ */
+static int validate_request(struct autofs_wait_queue **wait,
+			    struct autofs_sb_info *sbi,
+			    struct qstr *qstr,
+			    struct dentry *dentry, enum autofs_notify notify)
+{
+	struct autofs_wait_queue *wq;
+	struct autofs_info *ino;
+
+	/* Wait in progress, continue; */
+	wq = autofs4_find_wait(sbi, qstr);
+	if (wq) {
+		*wait = wq;
+		return 1;
+	}
+
+	*wait = NULL;
+
+	/* If we don't yet have any info this is a new request */
+	ino = autofs4_dentry_ino(dentry);
+	if (!ino)
+		return 1;
+
+	/*
+	 * If we've been asked to wait on an existing expire (NFY_NONE)
+	 * but there is no wait in the queue ...
+	 */
+	if (notify == NFY_NONE) {
+		/*
+		 * Either we've betean the pending expire to post it's
+		 * wait or it finished while we waited on the mutex.
+		 * So we need to wait till either, the wait appears
+		 * or the expire finishes.
+		 */
+
+		while (ino->flags & AUTOFS_INF_EXPIRING) {
+			mutex_unlock(&sbi->wq_mutex);
+			schedule_timeout_interruptible(HZ/10);
+			if (mutex_lock_interruptible(&sbi->wq_mutex))
+				return -EINTR;
+
+			wq = autofs4_find_wait(sbi, qstr);
+			if (wq) {
+				*wait = wq;
+				return 1;
+			}
+		}
+
+		/*
+		 * Not ideal but the status has already gone. Of the two
+		 * cases where we wait on NFY_NONE neither depend on the
+		 * return status of the wait.
+		 */
+		return 0;
+	}
+
+	/*
+	 * If we've been asked to trigger a mount and the request
+	 * completed while we waited on the mutex ...
+	 */
+	if (notify == NFY_MOUNT) {
+		/*
+		 * If the dentry was successfully mounted while we slept
+		 * on the wait queue mutex we can return success. If it
+		 * isn't mounted (doesn't have submounts for the case of
+		 * a multi-mount with no mount at it's base) we can
+		 * continue on and create a new request.
+		 */
+		if (have_submounts(dentry))
+			return 0;
+	}
 
-	if ( autofs_write(sbi->pipe,&pkt,sizeof(struct autofs_packet_missing)) )
-		autofs_catatonic_mode(sbi);
+	return 1;
 }
 
-int autofs_wait(struct autofs_sb_info *sbi, struct qstr *name)
+int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
+		enum autofs_notify notify)
 {
 	struct autofs_wait_queue *wq;
-	int status;
+	struct qstr qstr;
+	char *name;
+	int status, ret, type;
 
 	/* In catatonic mode, we don't wait for nobody */
-	if ( sbi->catatonic )
-		return -ENOENT;
-	
-	/* We shouldn't be able to get here, but just in case */
-	if ( name->len > NAME_MAX )
+	if (sbi->catatonic)
 		return -ENOENT;
 
-	for ( wq = sbi->queues ; wq ; wq = wq->next ) {
-		if ( wq->hash == name->hash &&
-		     wq->len == name->len &&
-		     wq->name && !memcmp(wq->name,name->name,name->len) )
-			break;
+	if (!dentry->d_inode) {
+		/*
+		 * A wait for a negative dentry is invalid for certain
+		 * cases. A direct or offset mount "always" has its mount
+		 * point directory created and so the request dentry must
+		 * be positive or the map key doesn't exist. The situation
+		 * is very similar for indirect mounts except only dentrys
+		 * in the root of the autofs file system may be negative.
+		 */
+		if (autofs_type_trigger(sbi->type))
+			return -ENOENT;
+		else if (!IS_ROOT(dentry->d_parent))
+			return -ENOENT;
 	}
-	
-	if ( !wq ) {
+
+	name = kmalloc(NAME_MAX + 1, GFP_KERNEL);
+	if (!name)
+		return -ENOMEM;
+
+	/* If this is a direct mount request create a dummy name */
+	if (IS_ROOT(dentry) && autofs_type_trigger(sbi->type))
+		qstr.len = sprintf(name, "%p", dentry);
+	else {
+		qstr.len = autofs4_getpath(sbi, dentry, &name);
+		if (!qstr.len) {
+			kfree(name);
+			return -ENOENT;
+		}
+	}
+	qstr.name = name;
+	qstr.hash = full_name_hash(name, qstr.len);
+
+	if (mutex_lock_interruptible(&sbi->wq_mutex)) {
+		kfree(qstr.name);
+		return -EINTR;
+	}
+
+	ret = validate_request(&wq, sbi, &qstr, dentry, notify);
+	if (ret <= 0) {
+		if (ret == 0)
+			mutex_unlock(&sbi->wq_mutex);
+		kfree(qstr.name);
+		return ret;
+	}
+
+	if (!wq) {
 		/* Create a new wait queue */
 		wq = kmalloc(sizeof(struct autofs_wait_queue),GFP_KERNEL);
-		if ( !wq )
-			return -ENOMEM;
-
-		wq->name = kmalloc(name->len,GFP_KERNEL);
-		if ( !wq->name ) {
-			kfree(wq);
+		if (!wq) {
+			kfree(qstr.name);
+			mutex_unlock(&sbi->wq_mutex);
 			return -ENOMEM;
 		}
-		wq->wait_queue_token = autofs_next_wait_queue++;
-		init_waitqueue_head(&wq->queue);
-		wq->hash = name->hash;
-		wq->len = name->len;
-		wq->status = -EINTR; /* Status return if interrupted */
-		memcpy(wq->name, name->name, name->len);
+
+		wq->wait_queue_token = autofs4_next_wait_queue;
+		if (++autofs4_next_wait_queue == 0)
+			autofs4_next_wait_queue = 1;
 		wq->next = sbi->queues;
 		sbi->queues = wq;
-
-		/* autofs_notify_daemon() may block */
+		init_waitqueue_head(&wq->queue);
+		memcpy(&wq->name, &qstr, sizeof(struct qstr));
+		wq->dev = autofs4_get_dev(sbi);
+		wq->ino = autofs4_get_ino(sbi);
+		wq->uid = current_uid();
+		wq->gid = current_gid();
+		wq->pid = current->pid;
+		wq->tgid = current->tgid;
+		wq->status = -EINTR; /* Status return if interrupted */
 		wq->wait_ctr = 2;
-		autofs_notify_daemon(sbi,wq);
-	} else
-		wq->wait_ctr++;
+		mutex_unlock(&sbi->wq_mutex);
+
+		if (sbi->version < 5) {
+			if (notify == NFY_MOUNT)
+				type = autofs_ptype_missing;
+			else
+				type = autofs_ptype_expire_multi;
+		} else {
+			if (notify == NFY_MOUNT)
+				type = autofs_type_trigger(sbi->type) ?
+					autofs_ptype_missing_direct :
+					 autofs_ptype_missing_indirect;
+			else
+				type = autofs_type_trigger(sbi->type) ?
+					autofs_ptype_expire_direct :
+					autofs_ptype_expire_indirect;
+		}
 
-	/* wq->name is NULL if and only if the lock is already released */
+		DPRINTK("new wait id = 0x%08lx, name = %.*s, nfy=%d\n",
+			(unsigned long) wq->wait_queue_token, wq->name.len,
+			wq->name.name, notify);
 
-	if ( sbi->catatonic ) {
-		/* We might have slept, so check again for catatonic mode */
-		wq->status = -ENOENT;
-		kfree(wq->name);
-		wq->name = NULL;
+		/* autofs4_notify_daemon() may block */
+		autofs4_notify_daemon(sbi, wq, type);
+	} else {
+		wq->wait_ctr++;
+		mutex_unlock(&sbi->wq_mutex);
+		kfree(qstr.name);
+		DPRINTK("existing wait id = 0x%08lx, name = %.*s, nfy=%d",
+			(unsigned long) wq->wait_queue_token, wq->name.len,
+			wq->name.name, notify);
 	}
 
-	if ( wq->name ) {
+	/*
+	 * wq->name.name is NULL iff the lock is already released
+	 * or the mount has been made catatonic.
+	 */
+	if (wq->name.name) {
 		/* Block all but "shutdown" signals while waiting */
-		sigset_t sigmask;
+		sigset_t oldset;
+		unsigned long irqflags;
 
-		siginitsetinv(&sigmask, SHUTDOWN_SIGS);
-		sigprocmask(SIG_BLOCK, &sigmask, &sigmask);
+		spin_lock_irqsave(&current->sighand->siglock, irqflags);
+		oldset = current->blocked;
+		siginitsetinv(&current->blocked, SHUTDOWN_SIGS & ~oldset.sig[0]);
+		recalc_sigpending();
+		spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
 
-		interruptible_sleep_on(&wq->queue);
+		wait_event_interruptible(wq->queue, wq->name.name == NULL);
 
-		sigprocmask(SIG_SETMASK, &sigmask, NULL);
+		spin_lock_irqsave(&current->sighand->siglock, irqflags);
+		current->blocked = oldset;
+		recalc_sigpending();
+		spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
 	} else {
-		DPRINTK(("autofs_wait: skipped sleeping\n"));
+		DPRINTK("skipped sleeping");
 	}
 
 	status = wq->status;
 
-	if ( ! --wq->wait_ctr )	/* Are we the last process to need status? */
+	/*
+	 * For direct and offset mounts we need to track the requester's
+	 * uid and gid in the dentry info struct. This is so it can be
+	 * supplied, on request, by the misc device ioctl interface.
+	 * This is needed during daemon resatart when reconnecting
+	 * to existing, active, autofs mounts. The uid and gid (and
+	 * related string values) may be used for macro substitution
+	 * in autofs mount maps.
+	 */
+	if (!status) {
+		struct autofs_info *ino;
+		struct dentry *de = NULL;
+
+		/* direct mount or browsable map */
+		ino = autofs4_dentry_ino(dentry);
+		if (!ino) {
+			/* If not lookup actual dentry used */
+			de = d_lookup(dentry->d_parent, &dentry->d_name);
+			if (de)
+				ino = autofs4_dentry_ino(de);
+		}
+
+		/* Set mount requester */
+		if (ino) {
+			spin_lock(&sbi->fs_lock);
+			ino->uid = wq->uid;
+			ino->gid = wq->gid;
+			spin_unlock(&sbi->fs_lock);
+		}
+
+		if (de)
+			dput(de);
+	}
+
+	/* Are we the last process to need status? */
+	mutex_lock(&sbi->wq_mutex);
+	if (!--wq->wait_ctr)
 		kfree(wq);
+	mutex_unlock(&sbi->wq_mutex);
 
 	return status;
 }
 
 
-int autofs_wait_release(struct autofs_sb_info *sbi, autofs_wqt_t wait_queue_token, int status)
+int autofs4_wait_release(struct autofs_sb_info *sbi,
+			 autofs_wqt_t wait_queue_token, int status)
 {
 	struct autofs_wait_queue *wq, **wql;
 
+	mutex_lock(&sbi->wq_mutex);
 	for (wql = &sbi->queues; (wq = *wql) != NULL; wql = &wq->next) {
-		if ( wq->wait_queue_token == wait_queue_token )
+		if (wq->wait_queue_token == wait_queue_token)
 			break;
 	}
-	if ( !wq )
+
+	if (!wq) {
+		mutex_unlock(&sbi->wq_mutex);
 		return -EINVAL;
+	}
 
 	*wql = wq->next;	/* Unlink from chain */
-	kfree(wq->name);
-	wq->name = NULL;	/* Do not wait on this queue */
-
+	kfree(wq->name.name);
+	wq->name.name = NULL;	/* Do not wait on this queue */
 	wq->status = status;
-
-	if ( ! --wq->wait_ctr )	/* Is anyone still waiting for this guy? */
+	wake_up_interruptible(&wq->queue);
+	if (!--wq->wait_ctr)
 		kfree(wq);
-	else
-		wake_up(&wq->queue);
+	mutex_unlock(&sbi->wq_mutex);
 
 	return 0;
 }
diff --git a/fs/autofs4/Kconfig b/fs/autofs4/Kconfig
index 1204d63..4c8bc1f 100644
--- a/fs/autofs4/Kconfig
+++ b/fs/autofs4/Kconfig
@@ -1,5 +1,6 @@
 config AUTOFS4_FS
-	tristate "Kernel automounter version 4 support (also supports v3)"
+	tristate "Kernel automounter version 4 support (also supports v3 and v5)"
+	depends on !AUTOFS_FS
 	help
 	  The automounter is a tool to automatically mount remote file systems
 	  on demand. This implementation is partially kernel-based to reduce
@@ -7,9 +8,14 @@ config AUTOFS4_FS
 	  automounter (amd), which is a pure user space daemon.
 
 	  To use the automounter you need the user-space tools from
-	  <ftp://ftp.kernel.org/pub/linux/daemons/autofs/v4/>; you also
+	  <ftp://ftp.kernel.org/pub/linux/daemons/autofs/>; you also
 	  want to answer Y to "NFS file system support", below.
 
+	  This module is in the process of replacing the autofs module. It is
+	  now built from the source located in fs/autofs and this directory
+	  will be removed at some future time. Plaese use AUTOFS_FS instead
+	  of this one.
+
 	  To compile this support as a module, choose M here: the module will be
 	  called autofs4.  You will need to add "alias autofs autofs4" to your
 	  modules configuration file.
diff --git a/fs/autofs4/Makefile b/fs/autofs4/Makefile
index a811c1f..bd4a535 100644
--- a/fs/autofs4/Makefile
+++ b/fs/autofs4/Makefile
@@ -4,4 +4,12 @@
 
 obj-$(CONFIG_AUTOFS4_FS) += autofs4.o
 
-autofs4-objs := init.o inode.o root.o symlink.o waitq.o expire.o dev-ioctl.o
+autofs4-y := ../autofs/init.o
+autofs4-y += ../autofs/inode.o
+autofs4-y += ../autofs/root.o
+autofs4-y += ../autofs/symlink.o
+autofs4-y += ../autofs/waitq.o
+autofs4-y += ../autofs/expire.o
+autofs4-y += ../autofs/dev-ioctl.o
+
+EXTRA_CFLAGS := -I$(src)/../autofs
diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
deleted file mode 100644
index b4a0d82..0000000
--- a/fs/autofs4/autofs_i.h
+++ /dev/null
@@ -1,304 +0,0 @@
-/*
- *   Copyright 1997-1998 Transmeta Corporation - All Rights Reserved
- *   Copyright 2005-2006 Ian Kent <raven@themaw.net>
- *
- * This file is part of the Linux kernel and is made available under
- * the terms of the GNU General Public License, version 2, or at your
- * option, any later version, incorporated herein by reference.
- *
- * ----------------------------------------------------------------------- */
-
-/* Internal header file for autofs */
-
-#include <linux/auto_fs4.h>
-#include <linux/auto_dev-ioctl.h>
-#include <linux/mutex.h>
-#include <linux/list.h>
-
-/* This is the range of ioctl() numbers we claim as ours */
-#define AUTOFS_IOC_FIRST     AUTOFS_IOC_READY
-#define AUTOFS_IOC_COUNT     32
-
-#define AUTOFS_DEV_IOCTL_IOC_FIRST	(AUTOFS_DEV_IOCTL_VERSION)
-#define AUTOFS_DEV_IOCTL_IOC_COUNT	(AUTOFS_IOC_COUNT - 11)
-
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/time.h>
-#include <linux/string.h>
-#include <linux/wait.h>
-#include <linux/sched.h>
-#include <linux/mount.h>
-#include <linux/namei.h>
-#include <asm/current.h>
-#include <asm/uaccess.h>
-
-/* #define DEBUG */
-
-#ifdef DEBUG
-#define DPRINTK(fmt, args...)				\
-do {							\
-	printk(KERN_DEBUG "pid %d: %s: " fmt "\n",	\
-		current->pid, __func__, ##args);	\
-} while (0)
-#else
-#define DPRINTK(fmt, args...) do {} while (0)
-#endif
-
-#define AUTOFS_WARN(fmt, args...)			\
-do {							\
-	printk(KERN_WARNING "pid %d: %s: " fmt "\n",	\
-		current->pid, __func__, ##args);	\
-} while (0)
-
-#define AUTOFS_ERROR(fmt, args...)			\
-do {							\
-	printk(KERN_ERR "pid %d: %s: " fmt "\n",	\
-		current->pid, __func__, ##args);	\
-} while (0)
-
-struct rehash_entry {
-	struct task_struct *task;
-	struct list_head list;
-};
-
-/* Unified info structure.  This is pointed to by both the dentry and
-   inode structures.  Each file in the filesystem has an instance of this
-   structure.  It holds a reference to the dentry, so dentries are never
-   flushed while the file exists.  All name lookups are dealt with at the
-   dentry level, although the filesystem can interfere in the validation
-   process.  Readdir is implemented by traversing the dentry lists. */
-struct autofs_info {
-	struct dentry	*dentry;
-	struct inode	*inode;
-
-	int		flags;
-
-	struct completion expire_complete;
-
-	struct list_head active;
-	int active_count;
-	struct list_head rehash_list;
-
-	struct list_head expiring;
-
-	struct autofs_sb_info *sbi;
-	unsigned long last_used;
-	atomic_t count;
-
-	uid_t uid;
-	gid_t gid;
-
-	mode_t	mode;
-	size_t	size;
-
-	void (*free)(struct autofs_info *);
-	union {
-		const char *symlink;
-	} u;
-};
-
-#define AUTOFS_INF_EXPIRING	(1<<0) /* dentry in the process of expiring */
-#define AUTOFS_INF_MOUNTPOINT	(1<<1) /* mountpoint status for direct expire */
-#define AUTOFS_INF_PENDING	(1<<2) /* dentry pending mount */
-#define AUTOFS_INF_REHASH	(1<<3) /* dentry in transit to ->lookup() */
-
-struct autofs_wait_queue {
-	wait_queue_head_t queue;
-	struct autofs_wait_queue *next;
-	autofs_wqt_t wait_queue_token;
-	/* We use the following to see what we are waiting for */
-	struct qstr name;
-	u32 dev;
-	u64 ino;
-	uid_t uid;
-	gid_t gid;
-	pid_t pid;
-	pid_t tgid;
-	/* This is for status reporting upon return */
-	int status;
-	unsigned int wait_ctr;
-};
-
-#define AUTOFS_SBI_MAGIC 0x6d4a556d
-
-struct autofs_sb_info {
-	u32 magic;
-	int pipefd;
-	struct file *pipe;
-	pid_t oz_pgrp;
-	int catatonic;
-	int version;
-	int sub_version;
-	int min_proto;
-	int max_proto;
-	unsigned long exp_timeout;
-	unsigned int type;
-	int reghost_enabled;
-	int needs_reghost;
-	struct super_block *sb;
-	struct mutex wq_mutex;
-	spinlock_t fs_lock;
-	struct autofs_wait_queue *queues; /* Wait queue pointer */
-	spinlock_t lookup_lock;
-	struct list_head active_list;
-	struct list_head expiring_list;
-};
-
-static inline struct autofs_sb_info *autofs4_sbi(struct super_block *sb)
-{
-	return (struct autofs_sb_info *)(sb->s_fs_info);
-}
-
-static inline struct autofs_info *autofs4_dentry_ino(struct dentry *dentry)
-{
-	return (struct autofs_info *)(dentry->d_fsdata);
-}
-
-/*
- * autofs4_oz_mode(): do we see the man behind the curtain?  (The
- * processes which do manipulations for us in user space sees the raw
- * filesystem without "magic".)
- */
-static inline int autofs4_oz_mode(struct autofs_sb_info *sbi)
-{
-	return sbi->catatonic || task_pgrp_nr(current) == sbi->oz_pgrp;
-}
-
-/* Does a dentry have some pending activity? */
-static inline int autofs4_ispending(struct dentry *dentry)
-{
-	struct autofs_info *inf = autofs4_dentry_ino(dentry);
-
-	if (inf->flags & AUTOFS_INF_PENDING)
-		return 1;
-
-	if (inf->flags & AUTOFS_INF_EXPIRING)
-		return 1;
-
-	return 0;
-}
-
-static inline void autofs4_copy_atime(struct file *src, struct file *dst)
-{
-	dst->f_path.dentry->d_inode->i_atime =
-		src->f_path.dentry->d_inode->i_atime;
-	return;
-}
-
-struct inode *autofs4_get_inode(struct super_block *, struct autofs_info *);
-void autofs4_free_ino(struct autofs_info *);
-
-/* Expiration */
-int is_autofs4_dentry(struct dentry *);
-int autofs4_expire_wait(struct dentry *dentry);
-int autofs4_expire_run(struct super_block *, struct vfsmount *,
-			struct autofs_sb_info *,
-			struct autofs_packet_expire __user *);
-int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
-			    struct autofs_sb_info *sbi, int when);
-int autofs4_expire_multi(struct super_block *, struct vfsmount *,
-			struct autofs_sb_info *, int __user *);
-struct dentry *autofs4_expire_direct(struct super_block *sb,
-				     struct vfsmount *mnt,
-				     struct autofs_sb_info *sbi, int how);
-struct dentry *autofs4_expire_indirect(struct super_block *sb,
-				       struct vfsmount *mnt,
-				       struct autofs_sb_info *sbi, int how);
-
-/* Device node initialization */
-
-int autofs_dev_ioctl_init(void);
-void autofs_dev_ioctl_exit(void);
-
-/* Operations structures */
-
-extern const struct inode_operations autofs4_symlink_inode_operations;
-extern const struct inode_operations autofs4_dir_inode_operations;
-extern const struct inode_operations autofs4_root_inode_operations;
-extern const struct inode_operations autofs4_indirect_root_inode_operations;
-extern const struct inode_operations autofs4_direct_root_inode_operations;
-extern const struct file_operations autofs4_dir_operations;
-extern const struct file_operations autofs4_root_operations;
-
-/* Initializing function */
-
-int autofs4_fill_super(struct super_block *, void *, int);
-struct autofs_info *autofs4_init_ino(struct autofs_info *,
-				     struct autofs_sb_info *, mode_t);
-
-/* Queue management functions */
-
-int autofs4_wait(struct autofs_sb_info *, struct dentry *, enum autofs_notify);
-int autofs4_wait_release(struct autofs_sb_info *, autofs_wqt_t, int);
-void autofs4_catatonic_mode(struct autofs_sb_info *);
-
-static inline int autofs4_follow_mount(struct path *path)
-{
-	int res = 0;
-
-	while (d_mountpoint(path->dentry)) {
-		int followed = follow_down(path);
-		if (!followed)
-			break;
-		res = 1;
-	}
-	return res;
-}
-
-static inline u32 autofs4_get_dev(struct autofs_sb_info *sbi)
-{
-	return new_encode_dev(sbi->sb->s_dev);
-}
-
-static inline u64 autofs4_get_ino(struct autofs_sb_info *sbi)
-{
-	return sbi->sb->s_root->d_inode->i_ino;
-}
-
-static inline int simple_positive(struct dentry *dentry)
-{
-	return dentry->d_inode && !d_unhashed(dentry);
-}
-
-static inline int __simple_empty(struct dentry *dentry)
-{
-	struct dentry *child;
-	int ret = 0;
-
-	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child)
-		if (simple_positive(child))
-			goto out;
-	ret = 1;
-out:
-	return ret;
-}
-
-static inline void autofs4_add_expiring(struct dentry *dentry)
-{
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
-	if (ino) {
-		spin_lock(&sbi->lookup_lock);
-		if (list_empty(&ino->expiring))
-			list_add(&ino->expiring, &sbi->expiring_list);
-		spin_unlock(&sbi->lookup_lock);
-	}
-	return;
-}
-
-static inline void autofs4_del_expiring(struct dentry *dentry)
-{
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
-	if (ino) {
-		spin_lock(&sbi->lookup_lock);
-		if (!list_empty(&ino->expiring))
-			list_del_init(&ino->expiring);
-		spin_unlock(&sbi->lookup_lock);
-	}
-	return;
-}
-
-void autofs4_dentry_release(struct dentry *);
-extern void autofs4_kill_sb(struct super_block *);
diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
deleted file mode 100644
index a0dcc5b..0000000
--- a/fs/autofs4/dev-ioctl.c
+++ /dev/null
@@ -1,766 +0,0 @@
-/*
- * Copyright 2008 Red Hat, Inc. All rights reserved.
- * Copyright 2008 Ian Kent <raven@themaw.net>
- *
- * This file is part of the Linux kernel and is made available under
- * the terms of the GNU General Public License, version 2, or at your
- * option, any later version, incorporated herein by reference.
- */
-
-#include <linux/module.h>
-#include <linux/vmalloc.h>
-#include <linux/miscdevice.h>
-#include <linux/init.h>
-#include <linux/wait.h>
-#include <linux/namei.h>
-#include <linux/fcntl.h>
-#include <linux/file.h>
-#include <linux/fdtable.h>
-#include <linux/sched.h>
-#include <linux/compat.h>
-#include <linux/syscalls.h>
-#include <linux/magic.h>
-#include <linux/dcache.h>
-#include <linux/uaccess.h>
-
-#include "autofs_i.h"
-
-/*
- * This module implements an interface for routing autofs ioctl control
- * commands via a miscellaneous device file.
- *
- * The alternate interface is needed because we need to be able open
- * an ioctl file descriptor on an autofs mount that may be covered by
- * another mount. This situation arises when starting automount(8)
- * or other user space daemon which uses direct mounts or offset
- * mounts (used for autofs lazy mount/umount of nested mount trees),
- * which have been left busy at at service shutdown.
- */
-
-#define AUTOFS_DEV_IOCTL_SIZE	sizeof(struct autofs_dev_ioctl)
-
-typedef int (*ioctl_fn)(struct file *, struct autofs_sb_info *,
-			struct autofs_dev_ioctl *);
-
-static int check_name(const char *name)
-{
-	if (!strchr(name, '/'))
-		return -EINVAL;
-	return 0;
-}
-
-/*
- * Check a string doesn't overrun the chunk of
- * memory we copied from user land.
- */
-static int invalid_str(char *str, size_t size)
-{
-	if (memchr(str, 0, size))
-		return 0;
-	return -EINVAL;
-}
-
-/*
- * Check that the user compiled against correct version of autofs
- * misc device code.
- *
- * As well as checking the version compatibility this always copies
- * the kernel interface version out.
- */
-static int check_dev_ioctl_version(int cmd, struct autofs_dev_ioctl *param)
-{
-	int err = 0;
-
-	if ((AUTOFS_DEV_IOCTL_VERSION_MAJOR != param->ver_major) ||
-	    (AUTOFS_DEV_IOCTL_VERSION_MINOR < param->ver_minor)) {
-		AUTOFS_WARN("ioctl control interface version mismatch: "
-		     "kernel(%u.%u), user(%u.%u), cmd(%d)",
-		     AUTOFS_DEV_IOCTL_VERSION_MAJOR,
-		     AUTOFS_DEV_IOCTL_VERSION_MINOR,
-		     param->ver_major, param->ver_minor, cmd);
-		err = -EINVAL;
-	}
-
-	/* Fill in the kernel version. */
-	param->ver_major = AUTOFS_DEV_IOCTL_VERSION_MAJOR;
-	param->ver_minor = AUTOFS_DEV_IOCTL_VERSION_MINOR;
-
-	return err;
-}
-
-/*
- * Copy parameter control struct, including a possible path allocated
- * at the end of the struct.
- */
-static struct autofs_dev_ioctl *copy_dev_ioctl(struct autofs_dev_ioctl __user *in)
-{
-	struct autofs_dev_ioctl tmp, *ads;
-
-	if (copy_from_user(&tmp, in, sizeof(tmp)))
-		return ERR_PTR(-EFAULT);
-
-	if (tmp.size < sizeof(tmp))
-		return ERR_PTR(-EINVAL);
-
-	ads = kmalloc(tmp.size, GFP_KERNEL);
-	if (!ads)
-		return ERR_PTR(-ENOMEM);
-
-	if (copy_from_user(ads, in, tmp.size)) {
-		kfree(ads);
-		return ERR_PTR(-EFAULT);
-	}
-
-	return ads;
-}
-
-static inline void free_dev_ioctl(struct autofs_dev_ioctl *param)
-{
-	kfree(param);
-	return;
-}
-
-/*
- * Check sanity of parameter control fields and if a path is present
- * check that it is terminated and contains at least one "/".
- */
-static int validate_dev_ioctl(int cmd, struct autofs_dev_ioctl *param)
-{
-	int err;
-
-	err = check_dev_ioctl_version(cmd, param);
-	if (err) {
-		AUTOFS_WARN("invalid device control module version "
-		     "supplied for cmd(0x%08x)", cmd);
-		goto out;
-	}
-
-	if (param->size > sizeof(*param)) {
-		err = invalid_str(param->path, param->size - sizeof(*param));
-		if (err) {
-			AUTOFS_WARN(
-			  "path string terminator missing for cmd(0x%08x)",
-			  cmd);
-			goto out;
-		}
-
-		err = check_name(param->path);
-		if (err) {
-			AUTOFS_WARN("invalid path supplied for cmd(0x%08x)",
-				    cmd);
-			goto out;
-		}
-	}
-
-	err = 0;
-out:
-	return err;
-}
-
-/*
- * Get the autofs super block info struct from the file opened on
- * the autofs mount point.
- */
-static struct autofs_sb_info *autofs_dev_ioctl_sbi(struct file *f)
-{
-	struct autofs_sb_info *sbi = NULL;
-	struct inode *inode;
-
-	if (f) {
-		inode = f->f_path.dentry->d_inode;
-		sbi = autofs4_sbi(inode->i_sb);
-	}
-	return sbi;
-}
-
-/* Return autofs module protocol version */
-static int autofs_dev_ioctl_protover(struct file *fp,
-				     struct autofs_sb_info *sbi,
-				     struct autofs_dev_ioctl *param)
-{
-	param->protover.version = sbi->version;
-	return 0;
-}
-
-/* Return autofs module protocol sub version */
-static int autofs_dev_ioctl_protosubver(struct file *fp,
-					struct autofs_sb_info *sbi,
-					struct autofs_dev_ioctl *param)
-{
-	param->protosubver.sub_version = sbi->sub_version;
-	return 0;
-}
-
-static int find_autofs_mount(const char *pathname,
-			     struct path *res,
-			     int test(struct path *path, void *data),
-			     void *data)
-{
-	struct path path;
-	int err = kern_path(pathname, 0, &path);
-	if (err)
-		return err;
-	err = -ENOENT;
-	while (path.dentry == path.mnt->mnt_root) {
-		if (path.mnt->mnt_sb->s_magic == AUTOFS_SUPER_MAGIC) {
-			if (test(&path, data)) {
-				path_get(&path);
-				if (!err) /* already found some */
-					path_put(res);
-				*res = path;
-				err = 0;
-			}
-		}
-		if (!follow_up(&path))
-			break;
-	}
-	path_put(&path);
-	return err;
-}
-
-static int test_by_dev(struct path *path, void *p)
-{
-	return path->mnt->mnt_sb->s_dev == *(dev_t *)p;
-}
-
-static int test_by_type(struct path *path, void *p)
-{
-	struct autofs_info *ino = autofs4_dentry_ino(path->dentry);
-	return ino && ino->sbi->type & *(unsigned *)p;
-}
-
-static void autofs_dev_ioctl_fd_install(unsigned int fd, struct file *file)
-{
-	struct files_struct *files = current->files;
-	struct fdtable *fdt;
-
-	spin_lock(&files->file_lock);
-	fdt = files_fdtable(files);
-	BUG_ON(fdt->fd[fd] != NULL);
-	rcu_assign_pointer(fdt->fd[fd], file);
-	FD_SET(fd, fdt->close_on_exec);
-	spin_unlock(&files->file_lock);
-}
-
-
-/*
- * Open a file descriptor on the autofs mount point corresponding
- * to the given path and device number (aka. new_encode_dev(sb->s_dev)).
- */
-static int autofs_dev_ioctl_open_mountpoint(const char *name, dev_t devid)
-{
-	int err, fd;
-
-	fd = get_unused_fd();
-	if (likely(fd >= 0)) {
-		struct file *filp;
-		struct path path;
-
-		err = find_autofs_mount(name, &path, test_by_dev, &devid);
-		if (err)
-			goto out;
-
-		/*
-		 * Find autofs super block that has the device number
-		 * corresponding to the autofs fs we want to open.
-		 */
-
-		filp = dentry_open(path.dentry, path.mnt, O_RDONLY,
-				   current_cred());
-		if (IS_ERR(filp)) {
-			err = PTR_ERR(filp);
-			goto out;
-		}
-
-		autofs_dev_ioctl_fd_install(fd, filp);
-	}
-
-	return fd;
-
-out:
-	put_unused_fd(fd);
-	return err;
-}
-
-/* Open a file descriptor on an autofs mount point */
-static int autofs_dev_ioctl_openmount(struct file *fp,
-				      struct autofs_sb_info *sbi,
-				      struct autofs_dev_ioctl *param)
-{
-	const char *path;
-	dev_t devid;
-	int err, fd;
-
-	/* param->path has already been checked */
-	if (!param->openmount.devid)
-		return -EINVAL;
-
-	param->ioctlfd = -1;
-
-	path = param->path;
-	devid = new_decode_dev(param->openmount.devid);
-
-	err = 0;
-	fd = autofs_dev_ioctl_open_mountpoint(path, devid);
-	if (unlikely(fd < 0)) {
-		err = fd;
-		goto out;
-	}
-
-	param->ioctlfd = fd;
-out:
-	return err;
-}
-
-/* Close file descriptor allocated above (user can also use close(2)). */
-static int autofs_dev_ioctl_closemount(struct file *fp,
-				       struct autofs_sb_info *sbi,
-				       struct autofs_dev_ioctl *param)
-{
-	return sys_close(param->ioctlfd);
-}
-
-/*
- * Send "ready" status for an existing wait (either a mount or an expire
- * request).
- */
-static int autofs_dev_ioctl_ready(struct file *fp,
-				  struct autofs_sb_info *sbi,
-				  struct autofs_dev_ioctl *param)
-{
-	autofs_wqt_t token;
-
-	token = (autofs_wqt_t) param->ready.token;
-	return autofs4_wait_release(sbi, token, 0);
-}
-
-/*
- * Send "fail" status for an existing wait (either a mount or an expire
- * request).
- */
-static int autofs_dev_ioctl_fail(struct file *fp,
-				 struct autofs_sb_info *sbi,
-				 struct autofs_dev_ioctl *param)
-{
-	autofs_wqt_t token;
-	int status;
-
-	token = (autofs_wqt_t) param->fail.token;
-	status = param->fail.status ? param->fail.status : -ENOENT;
-	return autofs4_wait_release(sbi, token, status);
-}
-
-/*
- * Set the pipe fd for kernel communication to the daemon.
- *
- * Normally this is set at mount using an option but if we
- * are reconnecting to a busy mount then we need to use this
- * to tell the autofs mount about the new kernel pipe fd. In
- * order to protect mounts against incorrectly setting the
- * pipefd we also require that the autofs mount be catatonic.
- *
- * This also sets the process group id used to identify the
- * controlling process (eg. the owning automount(8) daemon).
- */
-static int autofs_dev_ioctl_setpipefd(struct file *fp,
-				      struct autofs_sb_info *sbi,
-				      struct autofs_dev_ioctl *param)
-{
-	int pipefd;
-	int err = 0;
-
-	if (param->setpipefd.pipefd == -1)
-		return -EINVAL;
-
-	pipefd = param->setpipefd.pipefd;
-
-	mutex_lock(&sbi->wq_mutex);
-	if (!sbi->catatonic) {
-		mutex_unlock(&sbi->wq_mutex);
-		return -EBUSY;
-	} else {
-		struct file *pipe = fget(pipefd);
-		if (!pipe->f_op || !pipe->f_op->write) {
-			err = -EPIPE;
-			fput(pipe);
-			goto out;
-		}
-		sbi->oz_pgrp = task_pgrp_nr(current);
-		sbi->pipefd = pipefd;
-		sbi->pipe = pipe;
-		sbi->catatonic = 0;
-	}
-out:
-	mutex_unlock(&sbi->wq_mutex);
-	return err;
-}
-
-/*
- * Make the autofs mount point catatonic, no longer responsive to
- * mount requests. Also closes the kernel pipe file descriptor.
- */
-static int autofs_dev_ioctl_catatonic(struct file *fp,
-				      struct autofs_sb_info *sbi,
-				      struct autofs_dev_ioctl *param)
-{
-	autofs4_catatonic_mode(sbi);
-	return 0;
-}
-
-/* Set the autofs mount timeout */
-static int autofs_dev_ioctl_timeout(struct file *fp,
-				    struct autofs_sb_info *sbi,
-				    struct autofs_dev_ioctl *param)
-{
-	unsigned long timeout;
-
-	timeout = param->timeout.timeout;
-	param->timeout.timeout = sbi->exp_timeout / HZ;
-	sbi->exp_timeout = timeout * HZ;
-	return 0;
-}
-
-/*
- * Return the uid and gid of the last request for the mount
- *
- * When reconstructing an autofs mount tree with active mounts
- * we need to re-connect to mounts that may have used the original
- * process uid and gid (or string variations of them) for mount
- * lookups within the map entry.
- */
-static int autofs_dev_ioctl_requester(struct file *fp,
-				      struct autofs_sb_info *sbi,
-				      struct autofs_dev_ioctl *param)
-{
-	struct autofs_info *ino;
-	struct path path;
-	dev_t devid;
-	int err = -ENOENT;
-
-	if (param->size <= sizeof(*param)) {
-		err = -EINVAL;
-		goto out;
-	}
-
-	devid = sbi->sb->s_dev;
-
-	param->requester.uid = param->requester.gid = -1;
-
-	err = find_autofs_mount(param->path, &path, test_by_dev, &devid);
-	if (err)
-		goto out;
-
-	ino = autofs4_dentry_ino(path.dentry);
-	if (ino) {
-		err = 0;
-		autofs4_expire_wait(path.dentry);
-		spin_lock(&sbi->fs_lock);
-		param->requester.uid = ino->uid;
-		param->requester.gid = ino->gid;
-		spin_unlock(&sbi->fs_lock);
-	}
-	path_put(&path);
-out:
-	return err;
-}
-
-/*
- * Call repeatedly until it returns -EAGAIN, meaning there's nothing
- * more that can be done.
- */
-static int autofs_dev_ioctl_expire(struct file *fp,
-				   struct autofs_sb_info *sbi,
-				   struct autofs_dev_ioctl *param)
-{
-	struct vfsmount *mnt;
-	int how;
-
-	how = param->expire.how;
-	mnt = fp->f_path.mnt;
-
-	return autofs4_do_expire_multi(sbi->sb, mnt, sbi, how);
-}
-
-/* Check if autofs mount point is in use */
-static int autofs_dev_ioctl_askumount(struct file *fp,
-				      struct autofs_sb_info *sbi,
-				      struct autofs_dev_ioctl *param)
-{
-	param->askumount.may_umount = 0;
-	if (may_umount(fp->f_path.mnt))
-		param->askumount.may_umount = 1;
-	return 0;
-}
-
-/*
- * Check if the given path is a mountpoint.
- *
- * If we are supplied with the file descriptor of an autofs
- * mount we're looking for a specific mount. In this case
- * the path is considered a mountpoint if it is itself a
- * mountpoint or contains a mount, such as a multi-mount
- * without a root mount. In this case we return 1 if the
- * path is a mount point and the super magic of the covering
- * mount if there is one or 0 if it isn't a mountpoint.
- *
- * If we aren't supplied with a file descriptor then we
- * lookup the nameidata of the path and check if it is the
- * root of a mount. If a type is given we are looking for
- * a particular autofs mount and if we don't find a match
- * we return fail. If the located nameidata path is the
- * root of a mount we return 1 along with the super magic
- * of the mount or 0 otherwise.
- *
- * In both cases the the device number (as returned by
- * new_encode_dev()) is also returned.
- */
-static int autofs_dev_ioctl_ismountpoint(struct file *fp,
-					 struct autofs_sb_info *sbi,
-					 struct autofs_dev_ioctl *param)
-{
-	struct path path;
-	const char *name;
-	unsigned int type;
-	unsigned int devid, magic;
-	int err = -ENOENT;
-
-	if (param->size <= sizeof(*param)) {
-		err = -EINVAL;
-		goto out;
-	}
-
-	name = param->path;
-	type = param->ismountpoint.in.type;
-
-	param->ismountpoint.out.devid = devid = 0;
-	param->ismountpoint.out.magic = magic = 0;
-
-	if (!fp || param->ioctlfd == -1) {
-		if (autofs_type_any(type))
-			err = kern_path(name, LOOKUP_FOLLOW, &path);
-		else
-			err = find_autofs_mount(name, &path, test_by_type, &type);
-		if (err)
-			goto out;
-		devid = new_encode_dev(path.mnt->mnt_sb->s_dev);
-		err = 0;
-		if (path.dentry->d_inode &&
-		    path.mnt->mnt_root == path.dentry) {
-			err = 1;
-			magic = path.dentry->d_inode->i_sb->s_magic;
-		}
-	} else {
-		dev_t dev = sbi->sb->s_dev;
-
-		err = find_autofs_mount(name, &path, test_by_dev, &dev);
-		if (err)
-			goto out;
-
-		devid = new_encode_dev(dev);
-
-		err = have_submounts(path.dentry);
-
-		if (path.mnt->mnt_mountpoint != path.mnt->mnt_root) {
-			if (follow_down(&path))
-				magic = path.mnt->mnt_sb->s_magic;
-		}
-	}
-
-	param->ismountpoint.out.devid = devid;
-	param->ismountpoint.out.magic = magic;
-	path_put(&path);
-out:
-	return err;
-}
-
-/*
- * Our range of ioctl numbers isn't 0 based so we need to shift
- * the array index by _IOC_NR(AUTOFS_CTL_IOC_FIRST) for the table
- * lookup.
- */
-#define cmd_idx(cmd)	(cmd - _IOC_NR(AUTOFS_DEV_IOCTL_IOC_FIRST))
-
-static ioctl_fn lookup_dev_ioctl(unsigned int cmd)
-{
-	static struct {
-		int cmd;
-		ioctl_fn fn;
-	} _ioctls[] = {
-		{cmd_idx(AUTOFS_DEV_IOCTL_VERSION_CMD), NULL},
-		{cmd_idx(AUTOFS_DEV_IOCTL_PROTOVER_CMD),
-			 autofs_dev_ioctl_protover},
-		{cmd_idx(AUTOFS_DEV_IOCTL_PROTOSUBVER_CMD),
-			 autofs_dev_ioctl_protosubver},
-		{cmd_idx(AUTOFS_DEV_IOCTL_OPENMOUNT_CMD),
-			 autofs_dev_ioctl_openmount},
-		{cmd_idx(AUTOFS_DEV_IOCTL_CLOSEMOUNT_CMD),
-			 autofs_dev_ioctl_closemount},
-		{cmd_idx(AUTOFS_DEV_IOCTL_READY_CMD),
-			 autofs_dev_ioctl_ready},
-		{cmd_idx(AUTOFS_DEV_IOCTL_FAIL_CMD),
-			 autofs_dev_ioctl_fail},
-		{cmd_idx(AUTOFS_DEV_IOCTL_SETPIPEFD_CMD),
-			 autofs_dev_ioctl_setpipefd},
-		{cmd_idx(AUTOFS_DEV_IOCTL_CATATONIC_CMD),
-			 autofs_dev_ioctl_catatonic},
-		{cmd_idx(AUTOFS_DEV_IOCTL_TIMEOUT_CMD),
-			 autofs_dev_ioctl_timeout},
-		{cmd_idx(AUTOFS_DEV_IOCTL_REQUESTER_CMD),
-			 autofs_dev_ioctl_requester},
-		{cmd_idx(AUTOFS_DEV_IOCTL_EXPIRE_CMD),
-			 autofs_dev_ioctl_expire},
-		{cmd_idx(AUTOFS_DEV_IOCTL_ASKUMOUNT_CMD),
-			 autofs_dev_ioctl_askumount},
-		{cmd_idx(AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD),
-			 autofs_dev_ioctl_ismountpoint}
-	};
-	unsigned int idx = cmd_idx(cmd);
-
-	return (idx >= ARRAY_SIZE(_ioctls)) ? NULL : _ioctls[idx].fn;
-}
-
-/* ioctl dispatcher */
-static int
-_autofs_dev_ioctl(unsigned int command, struct autofs_dev_ioctl __user *user)
-{
-	struct autofs_dev_ioctl *param;
-	struct file *fp;
-	struct autofs_sb_info *sbi;
-	unsigned int cmd_first, cmd;
-	ioctl_fn fn = NULL;
-	int err = 0;
-
-	/* only root can play with this */
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	cmd_first = _IOC_NR(AUTOFS_DEV_IOCTL_IOC_FIRST);
-	cmd = _IOC_NR(command);
-
-	if (_IOC_TYPE(command) != _IOC_TYPE(AUTOFS_DEV_IOCTL_IOC_FIRST) ||
-	    cmd - cmd_first >= AUTOFS_DEV_IOCTL_IOC_COUNT) {
-		return -ENOTTY;
-	}
-
-	/* Copy the parameters into kernel space. */
-	param = copy_dev_ioctl(user);
-	if (IS_ERR(param))
-		return PTR_ERR(param);
-
-	err = validate_dev_ioctl(command, param);
-	if (err)
-		goto out;
-
-	/* The validate routine above always sets the version */
-	if (cmd == AUTOFS_DEV_IOCTL_VERSION_CMD)
-		goto done;
-
-	fn = lookup_dev_ioctl(cmd);
-	if (!fn) {
-		AUTOFS_WARN("unknown command 0x%08x", command);
-		return -ENOTTY;
-	}
-
-	fp = NULL;
-	sbi = NULL;
-
-	/*
-	 * For obvious reasons the openmount can't have a file
-	 * descriptor yet. We don't take a reference to the
-	 * file during close to allow for immediate release.
-	 */
-	if (cmd != AUTOFS_DEV_IOCTL_OPENMOUNT_CMD &&
-	    cmd != AUTOFS_DEV_IOCTL_CLOSEMOUNT_CMD) {
-		fp = fget(param->ioctlfd);
-		if (!fp) {
-			if (cmd == AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD)
-				goto cont;
-			err = -EBADF;
-			goto out;
-		}
-
-		if (!fp->f_op) {
-			err = -ENOTTY;
-			fput(fp);
-			goto out;
-		}
-
-		sbi = autofs_dev_ioctl_sbi(fp);
-		if (!sbi || sbi->magic != AUTOFS_SBI_MAGIC) {
-			err = -EINVAL;
-			fput(fp);
-			goto out;
-		}
-
-		/*
-		 * Admin needs to be able to set the mount catatonic in
-		 * order to be able to perform the re-open.
-		 */
-		if (!autofs4_oz_mode(sbi) &&
-		    cmd != AUTOFS_DEV_IOCTL_CATATONIC_CMD) {
-			err = -EACCES;
-			fput(fp);
-			goto out;
-		}
-	}
-cont:
-	err = fn(fp, sbi, param);
-
-	if (fp)
-		fput(fp);
-done:
-	if (err >= 0 && copy_to_user(user, param, AUTOFS_DEV_IOCTL_SIZE))
-		err = -EFAULT;
-out:
-	free_dev_ioctl(param);
-	return err;
-}
-
-static long autofs_dev_ioctl(struct file *file, uint command, ulong u)
-{
-	int err;
-	err = _autofs_dev_ioctl(command, (struct autofs_dev_ioctl __user *) u);
-	return (long) err;
-}
-
-#ifdef CONFIG_COMPAT
-static long autofs_dev_ioctl_compat(struct file *file, uint command, ulong u)
-{
-	return (long) autofs_dev_ioctl(file, command, (ulong) compat_ptr(u));
-}
-#else
-#define autofs_dev_ioctl_compat NULL
-#endif
-
-static const struct file_operations _dev_ioctl_fops = {
-	.unlocked_ioctl	 = autofs_dev_ioctl,
-	.compat_ioctl = autofs_dev_ioctl_compat,
-	.owner	 = THIS_MODULE,
-};
-
-static struct miscdevice _autofs_dev_ioctl_misc = {
-	.minor 		= MISC_DYNAMIC_MINOR,
-	.name  		= AUTOFS_DEVICE_NAME,
-	.fops  		= &_dev_ioctl_fops
-};
-
-/* Register/deregister misc character device */
-int autofs_dev_ioctl_init(void)
-{
-	int r;
-
-	r = misc_register(&_autofs_dev_ioctl_misc);
-	if (r) {
-		AUTOFS_ERROR("misc_register failed for control device");
-		return r;
-	}
-
-	return 0;
-}
-
-void autofs_dev_ioctl_exit(void)
-{
-	misc_deregister(&_autofs_dev_ioctl_misc);
-	return;
-}
-
diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
deleted file mode 100644
index 204c4fe..0000000
--- a/fs/autofs4/expire.c
+++ /dev/null
@@ -1,534 +0,0 @@
-/*
- *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
- *  Copyright 1999-2000 Jeremy Fitzhardinge <jeremy@goop.org>
- *  Copyright 2001-2006 Ian Kent <raven@themaw.net>
- *
- * This file is part of the Linux kernel and is made available under
- * the terms of the GNU General Public License, version 2, or at your
- * option, any later version, incorporated herein by reference.
- *
- * ------------------------------------------------------------------------- */
-
-#include "autofs_i.h"
-
-static unsigned long now;
-
-/* Check if a dentry can be expired */
-static inline int autofs4_can_expire(struct dentry *dentry,
-					unsigned long timeout, int do_now)
-{
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
-
-	/* dentry in the process of being deleted */
-	if (ino == NULL)
-		return 0;
-
-	/* No point expiring a pending mount */
-	if (ino->flags & AUTOFS_INF_PENDING)
-		return 0;
-
-	if (!do_now) {
-		/* Too young to die */
-		if (!timeout || time_after(ino->last_used + timeout, now))
-			return 0;
-
-		/* update last_used here :-
-		   - obviously makes sense if it is in use now
-		   - less obviously, prevents rapid-fire expire
-		     attempts if expire fails the first time */
-		ino->last_used = now;
-	}
-	return 1;
-}
-
-/* Check a mount point for busyness */
-static int autofs4_mount_busy(struct vfsmount *mnt, struct dentry *dentry)
-{
-	struct dentry *top = dentry;
-	struct path path = {.mnt = mnt, .dentry = dentry};
-	int status = 1;
-
-	DPRINTK("dentry %p %.*s",
-		dentry, (int)dentry->d_name.len, dentry->d_name.name);
-
-	path_get(&path);
-
-	if (!follow_down(&path))
-		goto done;
-
-	if (is_autofs4_dentry(path.dentry)) {
-		struct autofs_sb_info *sbi = autofs4_sbi(path.dentry->d_sb);
-
-		/* This is an autofs submount, we can't expire it */
-		if (autofs_type_indirect(sbi->type))
-			goto done;
-
-		/*
-		 * Otherwise it's an offset mount and we need to check
-		 * if we can umount its mount, if there is one.
-		 */
-		if (!d_mountpoint(path.dentry)) {
-			status = 0;
-			goto done;
-		}
-	}
-
-	/* Update the expiry counter if fs is busy */
-	if (!may_umount_tree(path.mnt)) {
-		struct autofs_info *ino = autofs4_dentry_ino(top);
-		ino->last_used = jiffies;
-		goto done;
-	}
-
-	status = 0;
-done:
-	DPRINTK("returning = %d", status);
-	path_put(&path);
-	return status;
-}
-
-/*
- * Calculate next entry in top down tree traversal.
- * From next_mnt in namespace.c - elegant.
- */
-static struct dentry *next_dentry(struct dentry *p, struct dentry *root)
-{
-	struct list_head *next = p->d_subdirs.next;
-
-	if (next == &p->d_subdirs) {
-		while (1) {
-			if (p == root)
-				return NULL;
-			next = p->d_u.d_child.next;
-			if (next != &p->d_parent->d_subdirs)
-				break;
-			p = p->d_parent;
-		}
-	}
-	return list_entry(next, struct dentry, d_u.d_child);
-}
-
-/*
- * Check a direct mount point for busyness.
- * Direct mounts have similar expiry semantics to tree mounts.
- * The tree is not busy iff no mountpoints are busy and there are no
- * autofs submounts.
- */
-static int autofs4_direct_busy(struct vfsmount *mnt,
-				struct dentry *top,
-				unsigned long timeout,
-				int do_now)
-{
-	DPRINTK("top %p %.*s",
-		top, (int) top->d_name.len, top->d_name.name);
-
-	/* If it's busy update the expiry counters */
-	if (!may_umount_tree(mnt)) {
-		struct autofs_info *ino = autofs4_dentry_ino(top);
-		if (ino)
-			ino->last_used = jiffies;
-		return 1;
-	}
-
-	/* Timeout of a direct mount is determined by its top dentry */
-	if (!autofs4_can_expire(top, timeout, do_now))
-		return 1;
-
-	return 0;
-}
-
-/* Check a directory tree of mount points for busyness
- * The tree is not busy iff no mountpoints are busy
- */
-static int autofs4_tree_busy(struct vfsmount *mnt,
-			     struct dentry *top,
-			     unsigned long timeout,
-			     int do_now)
-{
-	struct autofs_info *top_ino = autofs4_dentry_ino(top);
-	struct dentry *p;
-
-	DPRINTK("top %p %.*s",
-		top, (int)top->d_name.len, top->d_name.name);
-
-	/* Negative dentry - give up */
-	if (!simple_positive(top))
-		return 1;
-
-	spin_lock(&dcache_lock);
-	for (p = top; p; p = next_dentry(p, top)) {
-		/* Negative dentry - give up */
-		if (!simple_positive(p))
-			continue;
-
-		DPRINTK("dentry %p %.*s",
-			p, (int) p->d_name.len, p->d_name.name);
-
-		p = dget(p);
-		spin_unlock(&dcache_lock);
-
-		/*
-		 * Is someone visiting anywhere in the subtree ?
-		 * If there's no mount we need to check the usage
-		 * count for the autofs dentry.
-		 * If the fs is busy update the expiry counter.
-		 */
-		if (d_mountpoint(p)) {
-			if (autofs4_mount_busy(mnt, p)) {
-				top_ino->last_used = jiffies;
-				dput(p);
-				return 1;
-			}
-		} else {
-			struct autofs_info *ino = autofs4_dentry_ino(p);
-			unsigned int ino_count = atomic_read(&ino->count);
-
-			/*
-			 * Clean stale dentries below that have not been
-			 * invalidated after a mount fail during lookup
-			 */
-			d_invalidate(p);
-
-			/* allow for dget above and top is already dgot */
-			if (p == top)
-				ino_count += 2;
-			else
-				ino_count++;
-
-			if (atomic_read(&p->d_count) > ino_count) {
-				top_ino->last_used = jiffies;
-				dput(p);
-				return 1;
-			}
-		}
-		dput(p);
-		spin_lock(&dcache_lock);
-	}
-	spin_unlock(&dcache_lock);
-
-	/* Timeout of a tree mount is ultimately determined by its top dentry */
-	if (!autofs4_can_expire(top, timeout, do_now))
-		return 1;
-
-	return 0;
-}
-
-static struct dentry *autofs4_check_leaves(struct vfsmount *mnt,
-					   struct dentry *parent,
-					   unsigned long timeout,
-					   int do_now)
-{
-	struct dentry *p;
-
-	DPRINTK("parent %p %.*s",
-		parent, (int)parent->d_name.len, parent->d_name.name);
-
-	spin_lock(&dcache_lock);
-	for (p = parent; p; p = next_dentry(p, parent)) {
-		/* Negative dentry - give up */
-		if (!simple_positive(p))
-			continue;
-
-		DPRINTK("dentry %p %.*s",
-			p, (int) p->d_name.len, p->d_name.name);
-
-		p = dget(p);
-		spin_unlock(&dcache_lock);
-
-		if (d_mountpoint(p)) {
-			/* Can we umount this guy */
-			if (autofs4_mount_busy(mnt, p))
-				goto cont;
-
-			/* Can we expire this guy */
-			if (autofs4_can_expire(p, timeout, do_now))
-				return p;
-		}
-cont:
-		dput(p);
-		spin_lock(&dcache_lock);
-	}
-	spin_unlock(&dcache_lock);
-	return NULL;
-}
-
-/* Check if we can expire a direct mount (possibly a tree) */
-struct dentry *autofs4_expire_direct(struct super_block *sb,
-				     struct vfsmount *mnt,
-				     struct autofs_sb_info *sbi,
-				     int how)
-{
-	unsigned long timeout;
-	struct dentry *root = dget(sb->s_root);
-	int do_now = how & AUTOFS_EXP_IMMEDIATE;
-
-	if (!root)
-		return NULL;
-
-	now = jiffies;
-	timeout = sbi->exp_timeout;
-
-	spin_lock(&sbi->fs_lock);
-	if (!autofs4_direct_busy(mnt, root, timeout, do_now)) {
-		struct autofs_info *ino = autofs4_dentry_ino(root);
-		if (d_mountpoint(root)) {
-			ino->flags |= AUTOFS_INF_MOUNTPOINT;
-			root->d_mounted--;
-		}
-		ino->flags |= AUTOFS_INF_EXPIRING;
-		autofs4_add_expiring(root);
-		init_completion(&ino->expire_complete);
-		spin_unlock(&sbi->fs_lock);
-		return root;
-	}
-	spin_unlock(&sbi->fs_lock);
-	dput(root);
-
-	return NULL;
-}
-
-/*
- * Find an eligible tree to time-out
- * A tree is eligible if :-
- *  - it is unused by any user process
- *  - it has been unused for exp_timeout time
- */
-struct dentry *autofs4_expire_indirect(struct super_block *sb,
-				       struct vfsmount *mnt,
-				       struct autofs_sb_info *sbi,
-				       int how)
-{
-	unsigned long timeout;
-	struct dentry *root = sb->s_root;
-	struct dentry *expired = NULL;
-	struct list_head *next;
-	int do_now = how & AUTOFS_EXP_IMMEDIATE;
-	int exp_leaves = how & AUTOFS_EXP_LEAVES;
-	struct autofs_info *ino;
-	unsigned int ino_count;
-
-	if (!root)
-		return NULL;
-
-	now = jiffies;
-	timeout = sbi->exp_timeout;
-
-	spin_lock(&dcache_lock);
-	next = root->d_subdirs.next;
-
-	/*
-	 * On exit from the loop expire is set to a dgot dentry
-	 * to expire or it's NULL
-	 */
-	while (next != &root->d_subdirs) {
-		struct dentry *dentry;
-
-		dentry = list_entry(next, struct dentry, d_u.d_child);
-
-		/* Negative dentry - give up */
-		if (!simple_positive(dentry)) {
-			next = next->next;
-			continue;
-		}
-
-		dentry = dget(dentry);
-		spin_unlock(&dcache_lock);
-
-		spin_lock(&sbi->fs_lock);
-		ino = autofs4_dentry_ino(dentry);
-
-		/*
-		 * Case 1: (i) indirect mount or top level pseudo direct mount
-		 *	   (autofs-4.1).
-		 *	   (ii) indirect mount with offset mount, check the "/"
-		 *	   offset (autofs-5.0+).
-		 */
-		if (d_mountpoint(dentry)) {
-			DPRINTK("checking mountpoint %p %.*s", dentry,
-				(int)dentry->d_name.len, dentry->d_name.name);
-
-			/* Path walk currently on this dentry? */
-			ino_count = atomic_read(&ino->count) + 2;
-			if (atomic_read(&dentry->d_count) > ino_count)
-				goto next;
-
-			/* Can we umount this guy */
-			if (autofs4_mount_busy(mnt, dentry))
-				goto next;
-
-			/* Can we expire this guy */
-			if (autofs4_can_expire(dentry, timeout, do_now)) {
-				expired = dentry;
-				goto found;
-			}
-			goto next;
-		}
-
-		if (simple_empty(dentry))
-			goto next;
-
-		/* Case 2: tree mount, expire iff entire tree is not busy */
-		if (!exp_leaves) {
-			/* Path walk currently on this dentry? */
-			ino_count = atomic_read(&ino->count) + 1;
-			if (atomic_read(&dentry->d_count) > ino_count)
-				goto next;
-
-			if (!autofs4_tree_busy(mnt, dentry, timeout, do_now)) {
-				expired = dentry;
-				goto found;
-			}
-		/*
-		 * Case 3: pseudo direct mount, expire individual leaves
-		 *	   (autofs-4.1).
-		 */
-		} else {
-			/* Path walk currently on this dentry? */
-			ino_count = atomic_read(&ino->count) + 1;
-			if (atomic_read(&dentry->d_count) > ino_count)
-				goto next;
-
-			expired = autofs4_check_leaves(mnt, dentry, timeout, do_now);
-			if (expired) {
-				dput(dentry);
-				goto found;
-			}
-		}
-next:
-		spin_unlock(&sbi->fs_lock);
-		dput(dentry);
-		spin_lock(&dcache_lock);
-		next = next->next;
-	}
-	spin_unlock(&dcache_lock);
-	return NULL;
-
-found:
-	DPRINTK("returning %p %.*s",
-		expired, (int)expired->d_name.len, expired->d_name.name);
-	ino = autofs4_dentry_ino(expired);
-	ino->flags |= AUTOFS_INF_EXPIRING;
-	autofs4_add_expiring(expired);
-	init_completion(&ino->expire_complete);
-	spin_unlock(&sbi->fs_lock);
-	spin_lock(&dcache_lock);
-	list_move(&expired->d_parent->d_subdirs, &expired->d_u.d_child);
-	spin_unlock(&dcache_lock);
-	return expired;
-}
-
-int autofs4_expire_wait(struct dentry *dentry)
-{
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
-	int status;
-
-	/* Block on any pending expire */
-	spin_lock(&sbi->fs_lock);
-	if (ino->flags & AUTOFS_INF_EXPIRING) {
-		spin_unlock(&sbi->fs_lock);
-
-		DPRINTK("waiting for expire %p name=%.*s",
-			 dentry, dentry->d_name.len, dentry->d_name.name);
-
-		status = autofs4_wait(sbi, dentry, NFY_NONE);
-		wait_for_completion(&ino->expire_complete);
-
-		DPRINTK("expire done status=%d", status);
-
-		if (d_unhashed(dentry) && IS_DEADDIR(dentry->d_inode))
-			return -EAGAIN;
-
-		return status;
-	}
-	spin_unlock(&sbi->fs_lock);
-
-	return 0;
-}
-
-/* Perform an expiry operation */
-int autofs4_expire_run(struct super_block *sb,
-		      struct vfsmount *mnt,
-		      struct autofs_sb_info *sbi,
-		      struct autofs_packet_expire __user *pkt_p)
-{
-	struct autofs_packet_expire pkt;
-	struct autofs_info *ino;
-	struct dentry *dentry;
-	int ret = 0;
-
-	memset(&pkt, 0, sizeof pkt);
-
-	pkt.hdr.proto_version = sbi->version;
-	pkt.hdr.type = autofs_ptype_expire;
-
-	dentry = autofs4_expire_indirect(sb, mnt, sbi, 0);
-	if (dentry == NULL)
-		return -EAGAIN;
-
-	pkt.len = dentry->d_name.len;
-	memcpy(pkt.name, dentry->d_name.name, pkt.len);
-	pkt.name[pkt.len] = '\0';
-	dput(dentry);
-
-	if (copy_to_user(pkt_p, &pkt, sizeof(struct autofs_packet_expire)))
-		ret = -EFAULT;
-
-	spin_lock(&sbi->fs_lock);
-	ino = autofs4_dentry_ino(dentry);
-	ino->flags &= ~AUTOFS_INF_EXPIRING;
-	autofs4_del_expiring(dentry);
-	complete_all(&ino->expire_complete);
-	spin_unlock(&sbi->fs_lock);
-
-	return ret;
-}
-
-int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
-			    struct autofs_sb_info *sbi, int when)
-{
-	struct dentry *dentry;
-	int ret = -EAGAIN;
-
-	if (autofs_type_trigger(sbi->type))
-		dentry = autofs4_expire_direct(sb, mnt, sbi, when);
-	else
-		dentry = autofs4_expire_indirect(sb, mnt, sbi, when);
-
-	if (dentry) {
-		struct autofs_info *ino = autofs4_dentry_ino(dentry);
-
-		/*
-		 * This is synchronous because it makes the daemon a
-		 * little easier
-		 */
-		ret = autofs4_wait(sbi, dentry, NFY_EXPIRE);
-
-		spin_lock(&sbi->fs_lock);
-		if (ino->flags & AUTOFS_INF_MOUNTPOINT) {
-			sb->s_root->d_mounted++;
-			ino->flags &= ~AUTOFS_INF_MOUNTPOINT;
-		}
-		ino->flags &= ~AUTOFS_INF_EXPIRING;
-		autofs4_del_expiring(dentry);
-		complete_all(&ino->expire_complete);
-		spin_unlock(&sbi->fs_lock);
-		dput(dentry);
-	}
-
-	return ret;
-}
-
-/* Call repeatedly until it returns -EAGAIN, meaning there's nothing
-   more to be done */
-int autofs4_expire_multi(struct super_block *sb, struct vfsmount *mnt,
-			struct autofs_sb_info *sbi, int __user *arg)
-{
-	int do_now = 0;
-
-	if (arg && get_user(do_now, arg))
-		return -EFAULT;
-
-	return autofs4_do_expire_multi(sb, mnt, sbi, do_now);
-}
-
diff --git a/fs/autofs4/init.c b/fs/autofs4/init.c
deleted file mode 100644
index 11cc42b..0000000
--- a/fs/autofs4/init.c
+++ /dev/null
@@ -1,48 +0,0 @@
-/*
- *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
- *
- * This file is part of the Linux kernel and is made available under
- * the terms of the GNU General Public License, version 2, or at your
- * option, any later version, incorporated herein by reference.
- *
- * ------------------------------------------------------------------------- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include "autofs_i.h"
-
-static int autofs_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
-{
-	return get_sb_nodev(fs_type, flags, data, autofs4_fill_super, mnt);
-}
-
-static struct file_system_type autofs_fs_type = {
-	.owner		= THIS_MODULE,
-	.name		= "autofs",
-	.get_sb		= autofs_get_sb,
-	.kill_sb	= autofs4_kill_sb,
-};
-
-static int __init init_autofs4_fs(void)
-{
-	int err;
-
-	err = register_filesystem(&autofs_fs_type);
-	if (err)
-		return err;
-
-	autofs_dev_ioctl_init();
-
-	return err;
-}
-
-static void __exit exit_autofs4_fs(void)
-{
-	autofs_dev_ioctl_exit();
-	unregister_filesystem(&autofs_fs_type);
-}
-
-module_init(init_autofs4_fs)
-module_exit(exit_autofs4_fs)
-MODULE_LICENSE("GPL");
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
deleted file mode 100644
index 5b006db..0000000
--- a/fs/autofs4/inode.c
+++ /dev/null
@@ -1,473 +0,0 @@
-/*
- *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
- *  Copyright 2005-2006 Ian Kent <raven@themaw.net>
- *
- * This file is part of the Linux kernel and is made available under
- * the terms of the GNU General Public License, version 2, or at your
- * option, any later version, incorporated herein by reference.
- *
- * ------------------------------------------------------------------------- */
-
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/file.h>
-#include <linux/seq_file.h>
-#include <linux/pagemap.h>
-#include <linux/parser.h>
-#include <linux/bitops.h>
-#include <linux/magic.h>
-#include "autofs_i.h"
-#include <linux/module.h>
-
-static void ino_lnkfree(struct autofs_info *ino)
-{
-	if (ino->u.symlink) {
-		kfree(ino->u.symlink);
-		ino->u.symlink = NULL;
-	}
-}
-
-struct autofs_info *autofs4_init_ino(struct autofs_info *ino,
-				     struct autofs_sb_info *sbi, mode_t mode)
-{
-	int reinit = 1;
-
-	if (ino == NULL) {
-		reinit = 0;
-		ino = kmalloc(sizeof(*ino), GFP_KERNEL);
-	}
-
-	if (ino == NULL)
-		return NULL;
-
-	if (!reinit) {
-		ino->flags = 0;
-		ino->inode = NULL;
-		ino->dentry = NULL;
-		ino->size = 0;
-		INIT_LIST_HEAD(&ino->active);
-		INIT_LIST_HEAD(&ino->rehash_list);
-		ino->active_count = 0;
-		INIT_LIST_HEAD(&ino->expiring);
-		atomic_set(&ino->count, 0);
-	}
-
-	ino->uid = 0;
-	ino->gid = 0;
-	ino->mode = mode;
-	ino->last_used = jiffies;
-
-	ino->sbi = sbi;
-
-	if (reinit && ino->free)
-		(ino->free)(ino);
-
-	memset(&ino->u, 0, sizeof(ino->u));
-
-	ino->free = NULL;
-
-	if (S_ISLNK(mode))
-		ino->free = ino_lnkfree;
-
-	return ino;
-}
-
-void autofs4_free_ino(struct autofs_info *ino)
-{
-	struct autofs_info *p_ino;
-
-	if (ino->dentry) {
-		ino->dentry->d_fsdata = NULL;
-		if (ino->dentry->d_inode) {
-			struct dentry *parent = ino->dentry->d_parent;
-			if (atomic_dec_and_test(&ino->count)) {
-				p_ino = autofs4_dentry_ino(parent);
-				if (p_ino && parent != ino->dentry)
-					atomic_dec(&p_ino->count);
-			}
-			dput(ino->dentry);
-		}
-		ino->dentry = NULL;
-	}
-	if (ino->free)
-		(ino->free)(ino);
-	kfree(ino);
-}
-
-/*
- * Deal with the infamous "Busy inodes after umount ..." message.
- *
- * Clean up the dentry tree. This happens with autofs if the user
- * space program goes away due to a SIGKILL, SIGSEGV etc.
- */
-static void autofs4_force_release(struct autofs_sb_info *sbi)
-{
-	struct dentry *this_parent = sbi->sb->s_root;
-	struct list_head *next;
-
-	if (!sbi->sb->s_root)
-		return;
-
-	spin_lock(&dcache_lock);
-repeat:
-	next = this_parent->d_subdirs.next;
-resume:
-	while (next != &this_parent->d_subdirs) {
-		struct dentry *dentry;
-
-		dentry = list_entry(next, struct dentry, d_u.d_child);
-
-		/* Negative dentry - don`t care */
-		if (!simple_positive(dentry)) {
-			next = next->next;
-			continue;
-		}
-
-		if (!list_empty(&dentry->d_subdirs)) {
-			this_parent = dentry;
-			goto repeat;
-		}
-
-		next = next->next;
-		spin_unlock(&dcache_lock);
-
-		DPRINTK("dentry %p %.*s",
-			dentry, (int)dentry->d_name.len, dentry->d_name.name);
-
-		dput(dentry);
-		spin_lock(&dcache_lock);
-	}
-
-	if (this_parent != sbi->sb->s_root) {
-		struct dentry *dentry = this_parent;
-
-		next = this_parent->d_u.d_child.next;
-		this_parent = this_parent->d_parent;
-		spin_unlock(&dcache_lock);
-		DPRINTK("parent dentry %p %.*s",
-			dentry, (int)dentry->d_name.len, dentry->d_name.name);
-		dput(dentry);
-		spin_lock(&dcache_lock);
-		goto resume;
-	}
-	spin_unlock(&dcache_lock);
-}
-
-void autofs4_kill_sb(struct super_block *sb)
-{
-	struct autofs_sb_info *sbi = autofs4_sbi(sb);
-
-	/*
-	 * In the event of a failure in get_sb_nodev the superblock
-	 * info is not present so nothing else has been setup, so
-	 * just call kill_anon_super when we are called from
-	 * deactivate_super.
-	 */
-	if (!sbi)
-		goto out_kill_sb;
-
-	/* Free wait queues, close pipe */
-	autofs4_catatonic_mode(sbi);
-
-	/* Clean up and release dangling references */
-	autofs4_force_release(sbi);
-
-	sb->s_fs_info = NULL;
-	kfree(sbi);
-
-out_kill_sb:
-	DPRINTK("shutting down");
-	kill_anon_super(sb);
-}
-
-static int autofs4_show_options(struct seq_file *m, struct vfsmount *mnt)
-{
-	struct autofs_sb_info *sbi = autofs4_sbi(mnt->mnt_sb);
-	struct inode *root_inode = mnt->mnt_sb->s_root->d_inode;
-
-	if (!sbi)
-		return 0;
-
-	seq_printf(m, ",fd=%d", sbi->pipefd);
-	if (root_inode->i_uid != 0)
-		seq_printf(m, ",uid=%u", root_inode->i_uid);
-	if (root_inode->i_gid != 0)
-		seq_printf(m, ",gid=%u", root_inode->i_gid);
-	seq_printf(m, ",pgrp=%d", sbi->oz_pgrp);
-	seq_printf(m, ",timeout=%lu", sbi->exp_timeout/HZ);
-	seq_printf(m, ",minproto=%d", sbi->min_proto);
-	seq_printf(m, ",maxproto=%d", sbi->max_proto);
-
-	if (autofs_type_offset(sbi->type))
-		seq_printf(m, ",offset");
-	else if (autofs_type_direct(sbi->type))
-		seq_printf(m, ",direct");
-	else
-		seq_printf(m, ",indirect");
-
-	return 0;
-}
-
-static const struct super_operations autofs4_sops = {
-	.statfs		= simple_statfs,
-	.show_options	= autofs4_show_options,
-};
-
-enum {Opt_err, Opt_fd, Opt_uid, Opt_gid, Opt_pgrp, Opt_minproto, Opt_maxproto,
-	Opt_indirect, Opt_direct, Opt_offset};
-
-static const match_table_t tokens = {
-	{Opt_fd, "fd=%u"},
-	{Opt_uid, "uid=%u"},
-	{Opt_gid, "gid=%u"},
-	{Opt_pgrp, "pgrp=%u"},
-	{Opt_minproto, "minproto=%u"},
-	{Opt_maxproto, "maxproto=%u"},
-	{Opt_indirect, "indirect"},
-	{Opt_direct, "direct"},
-	{Opt_offset, "offset"},
-	{Opt_err, NULL}
-};
-
-static int parse_options(char *options, int *pipefd, uid_t *uid, gid_t *gid,
-		pid_t *pgrp, unsigned int *type, int *minproto, int *maxproto)
-{
-	char *p;
-	substring_t args[MAX_OPT_ARGS];
-	int option;
-
-	*uid = current_uid();
-	*gid = current_gid();
-	*pgrp = task_pgrp_nr(current);
-
-	*minproto = AUTOFS_MIN_PROTO_VERSION;
-	*maxproto = AUTOFS_MAX_PROTO_VERSION;
-
-	*pipefd = -1;
-
-	if (!options)
-		return 1;
-
-	while ((p = strsep(&options, ",")) != NULL) {
-		int token;
-		if (!*p)
-			continue;
-
-		token = match_token(p, tokens, args);
-		switch (token) {
-		case Opt_fd:
-			if (match_int(args, pipefd))
-				return 1;
-			break;
-		case Opt_uid:
-			if (match_int(args, &option))
-				return 1;
-			*uid = option;
-			break;
-		case Opt_gid:
-			if (match_int(args, &option))
-				return 1;
-			*gid = option;
-			break;
-		case Opt_pgrp:
-			if (match_int(args, &option))
-				return 1;
-			*pgrp = option;
-			break;
-		case Opt_minproto:
-			if (match_int(args, &option))
-				return 1;
-			*minproto = option;
-			break;
-		case Opt_maxproto:
-			if (match_int(args, &option))
-				return 1;
-			*maxproto = option;
-			break;
-		case Opt_indirect:
-			set_autofs_type_indirect(type);
-			break;
-		case Opt_direct:
-			set_autofs_type_direct(type);
-			break;
-		case Opt_offset:
-			set_autofs_type_offset(type);
-			break;
-		default:
-			return 1;
-		}
-	}
-	return (*pipefd < 0);
-}
-
-static struct autofs_info *autofs4_mkroot(struct autofs_sb_info *sbi)
-{
-	struct autofs_info *ino;
-
-	ino = autofs4_init_ino(NULL, sbi, S_IFDIR | 0755);
-	if (!ino)
-		return NULL;
-
-	return ino;
-}
-
-static const struct dentry_operations autofs4_sb_dentry_operations = {
-	.d_release      = autofs4_dentry_release,
-};
-
-int autofs4_fill_super(struct super_block *s, void *data, int silent)
-{
-	struct inode * root_inode;
-	struct dentry * root;
-	struct file * pipe;
-	int pipefd;
-	struct autofs_sb_info *sbi;
-	struct autofs_info *ino;
-
-	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
-	if (!sbi)
-		goto fail_unlock;
-	DPRINTK("starting up, sbi = %p", sbi);
-
-	s->s_fs_info = sbi;
-	sbi->magic = AUTOFS_SBI_MAGIC;
-	sbi->pipefd = -1;
-	sbi->pipe = NULL;
-	sbi->catatonic = 1;
-	sbi->exp_timeout = 0;
-	sbi->oz_pgrp = task_pgrp_nr(current);
-	sbi->sb = s;
-	sbi->version = 0;
-	sbi->sub_version = 0;
-	set_autofs_type_indirect(&sbi->type);
-	sbi->min_proto = 0;
-	sbi->max_proto = 0;
-	mutex_init(&sbi->wq_mutex);
-	spin_lock_init(&sbi->fs_lock);
-	sbi->queues = NULL;
-	spin_lock_init(&sbi->lookup_lock);
-	INIT_LIST_HEAD(&sbi->active_list);
-	INIT_LIST_HEAD(&sbi->expiring_list);
-	s->s_blocksize = 1024;
-	s->s_blocksize_bits = 10;
-	s->s_magic = AUTOFS_SUPER_MAGIC;
-	s->s_op = &autofs4_sops;
-	s->s_time_gran = 1;
-
-	/*
-	 * Get the root inode and dentry, but defer checking for errors.
-	 */
-	ino = autofs4_mkroot(sbi);
-	if (!ino)
-		goto fail_free;
-	root_inode = autofs4_get_inode(s, ino);
-	if (!root_inode)
-		goto fail_ino;
-
-	root = d_alloc_root(root_inode);
-	if (!root)
-		goto fail_iput;
-	pipe = NULL;
-
-	root->d_op = &autofs4_sb_dentry_operations;
-	root->d_fsdata = ino;
-
-	/* Can this call block? */
-	if (parse_options(data, &pipefd, &root_inode->i_uid, &root_inode->i_gid,
-				&sbi->oz_pgrp, &sbi->type, &sbi->min_proto,
-				&sbi->max_proto)) {
-		printk(KERN_ERR "autofs: called with bogus options\n");
-		goto fail_dput;
-	}
-
-	root_inode->i_fop = &autofs4_root_operations;
-	root_inode->i_op = autofs_type_trigger(sbi->type) ?
-			&autofs4_direct_root_inode_operations :
-			&autofs4_indirect_root_inode_operations;
-
-	/* Couldn't this be tested earlier? */
-	if (sbi->max_proto < AUTOFS_MIN_PROTO_VERSION ||
-	    sbi->min_proto > AUTOFS_MAX_PROTO_VERSION) {
-		printk(KERN_ERR "autofs: kernel does not match daemon "
-		       "version (%d, %d) kernel (%d, %d)\n",
-			sbi->min_proto, sbi->max_proto,
-			AUTOFS_MIN_PROTO_VERSION, AUTOFS_MAX_PROTO_VERSION);
-		goto fail_dput;
-	}
-
-	/* Establish highest kernel protocol version */
-	if (sbi->max_proto > AUTOFS_MAX_PROTO_VERSION)
-		sbi->version = AUTOFS_MAX_PROTO_VERSION;
-	else
-		sbi->version = sbi->max_proto;
-	sbi->sub_version = AUTOFS_PROTO_SUBVERSION;
-
-	DPRINTK("pipe fd = %d, pgrp = %u", pipefd, sbi->oz_pgrp);
-	pipe = fget(pipefd);
-	
-	if (!pipe) {
-		printk(KERN_ERR
-		      "autofs: could not open pipe file descriptor\n");
-		goto fail_dput;
-	}
-	if (!pipe->f_op || !pipe->f_op->write)
-		goto fail_fput;
-	sbi->pipe = pipe;
-	sbi->pipefd = pipefd;
-	sbi->catatonic = 0;
-
-	/*
-	 * Success! Install the root dentry now to indicate completion.
-	 */
-	s->s_root = root;
-	return 0;
-
-	/*
-	 * Failure ... clean up.
-	 */
-fail_fput:
-	printk("autofs: pipe file descriptor does not contain proper ops\n");
-	fput(pipe);
-	/* fall through */
-fail_dput:
-	dput(root);
-	goto fail_free;
-fail_iput:
-	printk("autofs: get root dentry failed\n");
-	iput(root_inode);
-fail_ino:
-	kfree(ino);
-fail_free:
-	kfree(sbi);
-	s->s_fs_info = NULL;
-fail_unlock:
-	return -EINVAL;
-}
-
-struct inode *autofs4_get_inode(struct super_block *sb,
-				struct autofs_info *inf)
-{
-	struct inode *inode = new_inode(sb);
-
-	if (inode == NULL)
-		return NULL;
-
-	inf->inode = inode;
-	inode->i_mode = inf->mode;
-	if (sb->s_root) {
-		inode->i_uid = sb->s_root->d_inode->i_uid;
-		inode->i_gid = sb->s_root->d_inode->i_gid;
-	}
-	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-
-	if (S_ISDIR(inf->mode)) {
-		inode->i_nlink = 2;
-		inode->i_op = &autofs4_dir_inode_operations;
-		inode->i_fop = &autofs4_dir_operations;
-	} else if (S_ISLNK(inf->mode)) {
-		inode->i_size = inf->size;
-		inode->i_op = &autofs4_symlink_inode_operations;
-	}
-
-	return inode;
-}
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
deleted file mode 100644
index c7bb36f..0000000
--- a/fs/autofs4/root.c
+++ /dev/null
@@ -1,1116 +0,0 @@
-/*
- *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
- *  Copyright 1999-2000 Jeremy Fitzhardinge <jeremy@goop.org>
- *  Copyright 2001-2006 Ian Kent <raven@themaw.net>
- *
- * This file is part of the Linux kernel and is made available under
- * the terms of the GNU General Public License, version 2, or at your
- * option, any later version, incorporated herein by reference.
- *
- * ------------------------------------------------------------------------- */
-
-#include <linux/capability.h>
-#include <linux/errno.h>
-#include <linux/stat.h>
-#include <linux/param.h>
-#include <linux/time.h>
-#include "autofs_i.h"
-
-static int autofs4_dir_symlink(struct inode *, struct dentry *, const char *);
-static int autofs4_dir_unlink(struct inode *, struct dentry *);
-static int autofs4_dir_rmdir(struct inode *, struct dentry *);
-static int autofs4_dir_mkdir(struct inode *, struct dentry *, int);
-static int autofs4_root_ioctl(struct inode *, struct file *,
-			      unsigned int, unsigned long);
-static int autofs4_dir_open(struct inode *inode, struct file *file);
-static struct dentry *autofs4_lookup(struct inode *,
-				     struct dentry *, struct nameidata *);
-static void *autofs4_follow_link(struct dentry *, struct nameidata *);
-
-#define TRIGGER_FLAGS   (LOOKUP_CONTINUE | LOOKUP_DIRECTORY)
-#define TRIGGER_INTENTS (LOOKUP_OPEN | LOOKUP_CREATE)
-
-const struct file_operations autofs4_root_operations = {
-	.open		= dcache_dir_open,
-	.release	= dcache_dir_close,
-	.read		= generic_read_dir,
-	.readdir	= dcache_readdir,
-	.llseek		= dcache_dir_lseek,
-	.ioctl		= autofs4_root_ioctl,
-};
-
-const struct file_operations autofs4_dir_operations = {
-	.open		= autofs4_dir_open,
-	.release	= dcache_dir_close,
-	.read		= generic_read_dir,
-	.readdir	= dcache_readdir,
-	.llseek		= dcache_dir_lseek,
-};
-
-const struct inode_operations autofs4_indirect_root_inode_operations = {
-	.lookup		= autofs4_lookup,
-	.unlink		= autofs4_dir_unlink,
-	.symlink	= autofs4_dir_symlink,
-	.mkdir		= autofs4_dir_mkdir,
-	.rmdir		= autofs4_dir_rmdir,
-};
-
-const struct inode_operations autofs4_direct_root_inode_operations = {
-	.lookup		= autofs4_lookup,
-	.unlink		= autofs4_dir_unlink,
-	.mkdir		= autofs4_dir_mkdir,
-	.rmdir		= autofs4_dir_rmdir,
-	.follow_link	= autofs4_follow_link,
-};
-
-const struct inode_operations autofs4_dir_inode_operations = {
-	.lookup		= autofs4_lookup,
-	.unlink		= autofs4_dir_unlink,
-	.symlink	= autofs4_dir_symlink,
-	.mkdir		= autofs4_dir_mkdir,
-	.rmdir		= autofs4_dir_rmdir,
-};
-
-static void autofs4_add_active(struct dentry *dentry)
-{
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
-	if (ino) {
-		spin_lock(&sbi->lookup_lock);
-		if (!ino->active_count) {
-			if (list_empty(&ino->active))
-				list_add(&ino->active, &sbi->active_list);
-		}
-		ino->active_count++;
-		spin_unlock(&sbi->lookup_lock);
-	}
-	return;
-}
-
-static void autofs4_del_active(struct dentry *dentry)
-{
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
-	if (ino) {
-		spin_lock(&sbi->lookup_lock);
-		ino->active_count--;
-		if (!ino->active_count) {
-			if (!list_empty(&ino->active))
-				list_del_init(&ino->active);
-		}
-		spin_unlock(&sbi->lookup_lock);
-	}
-	return;
-}
-
-static void autofs4_add_rehash_entry(struct autofs_info *ino,
-				     struct rehash_entry *entry)
-{
-	entry->task = current;
-	INIT_LIST_HEAD(&entry->list);
-	list_add(&entry->list, &ino->rehash_list);
-	return;
-}
-
-static void autofs4_remove_rehash_entry(struct autofs_info *ino)
-{
-	struct list_head *head = &ino->rehash_list;
-	struct rehash_entry *entry;
-	list_for_each_entry(entry, head, list) {
-		if (entry->task == current) {
-			list_del(&entry->list);
-			kfree(entry);
-			break;
-		}
-	}
-	return;
-}
-
-static void autofs4_remove_rehash_entrys(struct autofs_info *ino)
-{
-	struct autofs_sb_info *sbi = ino->sbi;
-	struct rehash_entry *entry, *next;
-	struct list_head *head;
-
-	spin_lock(&sbi->fs_lock);
-	spin_lock(&sbi->lookup_lock);
-	if (!(ino->flags & AUTOFS_INF_REHASH)) {
-		spin_unlock(&sbi->lookup_lock);
-		spin_unlock(&sbi->fs_lock);
-		return;
-	}
-	ino->flags &= ~AUTOFS_INF_REHASH;
-	head = &ino->rehash_list;
-	list_for_each_entry_safe(entry, next, head, list) {
-		list_del(&entry->list);
-		kfree(entry);
-	}
-	spin_unlock(&sbi->lookup_lock);
-	spin_unlock(&sbi->fs_lock);
-	dput(ino->dentry);
-
-	return;
-}
-
-static void autofs4_revalidate_drop(struct dentry *dentry,
-				    struct rehash_entry *entry)
-{
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
-	/*
-	 * Add to the active list so we can pick this up in
-	 * ->lookup(). Also add an entry to a rehash list so
-	 * we know when there are no dentrys in flight so we
-	 * know when we can rehash the dentry.
-	 */
-	spin_lock(&sbi->lookup_lock);
-	if (list_empty(&ino->active))
-		list_add(&ino->active, &sbi->active_list);
-	autofs4_add_rehash_entry(ino, entry);
-	spin_unlock(&sbi->lookup_lock);
-	if (!(ino->flags & AUTOFS_INF_REHASH)) {
-		ino->flags |= AUTOFS_INF_REHASH;
-		dget(dentry);
-		spin_lock(&dentry->d_lock);
-		__d_drop(dentry);
-		spin_unlock(&dentry->d_lock);
-	}
-	return;
-}
-
-static void autofs4_revalidate_rehash(struct dentry *dentry)
-{
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
-	if (ino->flags & AUTOFS_INF_REHASH) {
-		spin_lock(&sbi->lookup_lock);
-		autofs4_remove_rehash_entry(ino);
-		if (list_empty(&ino->rehash_list)) {
-			spin_unlock(&sbi->lookup_lock);
-			ino->flags &= ~AUTOFS_INF_REHASH;
-			d_rehash(dentry);
-			dput(ino->dentry);
-		} else
-			spin_unlock(&sbi->lookup_lock);
-	}
-	return;
-}
-
-static unsigned int autofs4_need_mount(unsigned int flags)
-{
-	unsigned int res = 0;
-	if (flags & (TRIGGER_FLAGS | TRIGGER_INTENTS))
-		res = 1;
-	return res;
-}
-
-static int autofs4_dir_open(struct inode *inode, struct file *file)
-{
-	struct dentry *dentry = file->f_path.dentry;
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-
-	DPRINTK("file=%p dentry=%p %.*s",
-		file, dentry, dentry->d_name.len, dentry->d_name.name);
-
-	if (autofs4_oz_mode(sbi))
-		goto out;
-
-	/*
-	 * An empty directory in an autofs file system is always a
-	 * mount point. The daemon must have failed to mount this
-	 * during lookup so it doesn't exist. This can happen, for
-	 * example, if user space returns an incorrect status for a
-	 * mount request. Otherwise we're doing a readdir on the
-	 * autofs file system so just let the libfs routines handle
-	 * it.
-	 */
-	spin_lock(&dcache_lock);
-	if (!d_mountpoint(dentry) && list_empty(&dentry->d_subdirs)) {
-		spin_unlock(&dcache_lock);
-		return -ENOENT;
-	}
-	spin_unlock(&dcache_lock);
-
-out:
-	return dcache_dir_open(inode, file);
-}
-
-static int try_to_fill_dentry(struct dentry *dentry)
-{
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
-	int status;
-
-	DPRINTK("dentry=%p %.*s ino=%p",
-		dentry, dentry->d_name.len, dentry->d_name.name,
-		dentry->d_inode);
-
-	/*
-	 * Wait for a pending mount, triggering one if there
-	 * isn't one already
-	 */
-	DPRINTK("waiting for mount name=%.*s",
-		 dentry->d_name.len, dentry->d_name.name);
-
-	status = autofs4_wait(sbi, dentry, NFY_MOUNT);
-
-	DPRINTK("mount done status=%d", status);
-
-	/* Update expiry counter */
-	ino->last_used = jiffies;
-
-	return status;
-}
-
-/* For autofs direct mounts the follow link triggers the mount */
-static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
-{
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
-	int oz_mode = autofs4_oz_mode(sbi);
-	unsigned int lookup_type;
-	int status;
-
-	DPRINTK("dentry=%p %.*s oz_mode=%d nd->flags=%d",
-		dentry, dentry->d_name.len, dentry->d_name.name, oz_mode,
-		nd->flags);
-	/*
-	 * For an expire of a covered direct or offset mount we need
-	 * to break out of follow_down() at the autofs mount trigger
-	 * (d_mounted--), so we can see the expiring flag, and manage
-	 * the blocking and following here until the expire is completed.
-	 */
-	if (oz_mode) {
-		spin_lock(&sbi->fs_lock);
-		if (ino->flags & AUTOFS_INF_EXPIRING) {
-			spin_unlock(&sbi->fs_lock);
-			/* Follow down to our covering mount. */
-			if (!follow_down(&nd->path))
-				goto done;
-			goto follow;
-		}
-		spin_unlock(&sbi->fs_lock);
-		goto done;
-	}
-
-	/* If an expire request is pending everyone must wait. */
-	autofs4_expire_wait(dentry);
-
-	/* We trigger a mount for almost all flags */
-	lookup_type = autofs4_need_mount(nd->flags);
-	spin_lock(&sbi->fs_lock);
-	spin_lock(&dcache_lock);
-	if (!(lookup_type || ino->flags & AUTOFS_INF_PENDING)) {
-		spin_unlock(&dcache_lock);
-		spin_unlock(&sbi->fs_lock);
-		goto follow;
-	}
-
-	/*
-	 * If the dentry contains directories then it is an autofs
-	 * multi-mount with no root mount offset. So don't try to
-	 * mount it again.
-	 */
-	if (ino->flags & AUTOFS_INF_PENDING ||
-	    (!d_mountpoint(dentry) && list_empty(&dentry->d_subdirs))) {
-		ino->flags |= AUTOFS_INF_PENDING;
-		spin_unlock(&dcache_lock);
-		spin_unlock(&sbi->fs_lock);
-
-		status = try_to_fill_dentry(dentry);
-
-		spin_lock(&sbi->fs_lock);
-		ino->flags &= ~AUTOFS_INF_PENDING;
-		spin_unlock(&sbi->fs_lock);
-
-		if (status)
-			goto out_error;
-
-		goto follow;
-	}
-	spin_unlock(&dcache_lock);
-	spin_unlock(&sbi->fs_lock);
-follow:
-	/*
-	 * If there is no root mount it must be an autofs
-	 * multi-mount with no root offset so we don't need
-	 * to follow it.
-	 */
-	if (d_mountpoint(dentry)) {
-		if (!autofs4_follow_mount(&nd->path)) {
-			status = -ENOENT;
-			goto out_error;
-		}
-	}
-
-done:
-	return NULL;
-
-out_error:
-	path_put(&nd->path);
-	return ERR_PTR(status);
-}
-
-/*
- * Revalidate is called on every cache lookup.  Some of those
- * cache lookups may actually happen while the dentry is not
- * yet completely filled in, and revalidate has to delay such
- * lookups..
- */
-static int autofs4_revalidate(struct dentry *dentry, struct nameidata *nd)
-{
-	struct inode *dir = dentry->d_parent->d_inode;
-	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
-	struct rehash_entry *entry;
-	int flags = nd ? nd->flags : 0;
-	unsigned int mutex_aquired;
-
-	DPRINTK("name = %.*s oz_mode = %d",
-		dentry->d_name.len, dentry->d_name.name, oz_mode);
-
-	/* Daemon never causes a mount to trigger */
-	if (autofs4_oz_mode(sbi))
-		return 1;
-
-	entry = kmalloc(sizeof(struct rehash_entry), GFP_KERNEL);
-	if (!entry)
-		return -ENOMEM;
-
-	mutex_aquired = mutex_trylock(&dir->i_mutex);
-
-	spin_lock(&sbi->fs_lock);
-	spin_lock(&dcache_lock);
-	/* Pending dentry */
-	if (autofs4_ispending(dentry)) {
-		int status;
-
-		/*
-		 * We can only unhash and send this to ->lookup() if
-		 * the directory mutex is held over d_revalidate() and
-		 * ->lookup(). This prevents the VFS from incorrectly
-		 * seeing the dentry as non-existent.
-		 */
-		ino->flags |= AUTOFS_INF_PENDING;
-		if (!mutex_aquired) {
-			autofs4_revalidate_drop(dentry, entry);
-			spin_unlock(&dcache_lock);
-			spin_unlock(&sbi->fs_lock);
-			return 0;
-		}
-		spin_unlock(&dcache_lock);
-		spin_unlock(&sbi->fs_lock);
-		mutex_unlock(&dir->i_mutex);
-		kfree(entry);
-
-		/*
-		 * If the directory has gone away due to an expire
-		 * we have been called as ->d_revalidate() and so
-		 * we need to return false and proceed to ->lookup().
-		 */
-		if (autofs4_expire_wait(dentry) == -EAGAIN)
-			return 0;
-
-		/*
-		 * A zero status is success otherwise we have a
-		 * negative error code.
-		 */
-		status = try_to_fill_dentry(dentry);
-
-		spin_lock(&sbi->fs_lock);
-		ino->flags &= ~AUTOFS_INF_PENDING;
-		spin_unlock(&sbi->fs_lock);
-
-		if (status == 0)
-			return 1;
-
-		return status;
-	}
-
-	/* Check for a non-mountpoint directory with no contents */
-	if (S_ISDIR(dentry->d_inode->i_mode) &&
-	    !d_mountpoint(dentry) && list_empty(&dentry->d_subdirs)) {
-		DPRINTK("dentry=%p %.*s, emptydir",
-			 dentry, dentry->d_name.len, dentry->d_name.name);
-
-		if (autofs4_need_mount(flags) || current->link_count) {
-			int status;
-
-			/*
-			 * We can only unhash and send this to ->lookup() if
-			 * the directory mutex is held over d_revalidate() and
-			 * ->lookup(). This prevents the VFS from incorrectly
-			 * seeing the dentry as non-existent.
-			 */
-			ino->flags |= AUTOFS_INF_PENDING;
-			if (!mutex_aquired) {
-				autofs4_revalidate_drop(dentry, entry);
-				spin_unlock(&dcache_lock);
-				spin_unlock(&sbi->fs_lock);
-				return 0;
-			}
-			spin_unlock(&dcache_lock);
-			spin_unlock(&sbi->fs_lock);
-			mutex_unlock(&dir->i_mutex);
-			kfree(entry);
-
-			/*
-			 * A zero status is success otherwise we have a
-			 * negative error code.
-			 */
-			status = try_to_fill_dentry(dentry);
-
-			spin_lock(&sbi->fs_lock);
-			ino->flags &= ~AUTOFS_INF_PENDING;
-			spin_unlock(&sbi->fs_lock);
-
-			if (status == 0)
-				return 1;
-
-			return status;
-		}
-	}
-	spin_unlock(&dcache_lock);
-	spin_unlock(&sbi->fs_lock);
-
-	if (mutex_aquired)
-		mutex_unlock(&dir->i_mutex);
-
-	kfree(entry);
-
-	return 1;
-}
-
-static void autofs4_free_rehash_entrys(struct autofs_info *inf)
-{
-	struct list_head *head = &inf->rehash_list;
-	struct rehash_entry *entry, *next;
-	list_for_each_entry_safe(entry, next, head, list) {
-		list_del(&entry->list);
-		kfree(entry);
-	}
-}
-
-void autofs4_dentry_release(struct dentry *de)
-{
-	struct autofs_info *inf;
-
-	DPRINTK("releasing %p", de);
-
-	inf = autofs4_dentry_ino(de);
-	de->d_fsdata = NULL;
-
-	if (inf) {
-		struct autofs_sb_info *sbi = autofs4_sbi(de->d_sb);
-
-		if (sbi) {
-			spin_lock(&sbi->lookup_lock);
-			if (!list_empty(&inf->active))
-				list_del(&inf->active);
-			if (!list_empty(&inf->expiring))
-				list_del(&inf->expiring);
-			if (!list_empty(&inf->rehash_list))
-				autofs4_free_rehash_entrys(inf);
-			spin_unlock(&sbi->lookup_lock);
-		}
-
-		inf->dentry = NULL;
-		inf->inode = NULL;
-
-		autofs4_free_ino(inf);
-	}
-}
-
-/* For dentries of directories in the root dir */
-static const struct dentry_operations autofs4_root_dentry_operations = {
-	.d_revalidate	= autofs4_revalidate,
-	.d_release	= autofs4_dentry_release,
-};
-
-/* For other dentries */
-static const struct dentry_operations autofs4_dentry_operations = {
-	.d_revalidate	= autofs4_revalidate,
-	.d_release	= autofs4_dentry_release,
-};
-
-static struct dentry *autofs4_lookup_active(struct dentry *dentry)
-{
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct dentry *parent = dentry->d_parent;
-	struct qstr *name = &dentry->d_name;
-	unsigned int len = name->len;
-	unsigned int hash = name->hash;
-	const unsigned char *str = name->name;
-	struct list_head *p, *head;
-
-restart:
-	spin_lock(&dcache_lock);
-	spin_lock(&sbi->lookup_lock);
-	head = &sbi->active_list;
-	list_for_each(p, head) {
-		struct autofs_info *ino;
-		struct dentry *active;
-		struct qstr *qstr;
-
-		ino = list_entry(p, struct autofs_info, active);
-		active = ino->dentry;
-
-		spin_lock(&active->d_lock);
-
-		/* Already gone? */
-		if (atomic_read(&active->d_count) == 0)
-			goto next;
-
-		if (active->d_inode && IS_DEADDIR(active->d_inode)) {
-			if (!list_empty(&ino->rehash_list)) {
-				dget(active);
-				spin_unlock(&active->d_lock);
-				spin_unlock(&sbi->lookup_lock);
-				spin_unlock(&dcache_lock);
-				autofs4_remove_rehash_entrys(ino);
-				dput(active);
-				goto restart;
-			}
-			goto next;
-		}
-
-		qstr = &active->d_name;
-
-		if (active->d_name.hash != hash)
-			goto next;
-		if (active->d_parent != parent)
-			goto next;
-
-		if (qstr->len != len)
-			goto next;
-		if (memcmp(qstr->name, str, len))
-			goto next;
-
-		dget(active);
-		spin_unlock(&active->d_lock);
-		spin_unlock(&sbi->lookup_lock);
-		spin_unlock(&dcache_lock);
-		return active;
-next:
-		spin_unlock(&active->d_lock);
-	}
-	spin_unlock(&sbi->lookup_lock);
-	spin_unlock(&dcache_lock);
-
-	return NULL;
-}
-
-static struct dentry *autofs4_lookup_expiring(struct dentry *dentry)
-{
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct dentry *parent = dentry->d_parent;
-	struct qstr *name = &dentry->d_name;
-	unsigned int len = name->len;
-	unsigned int hash = name->hash;
-	const unsigned char *str = name->name;
-	struct list_head *p, *head;
-
-	spin_lock(&dcache_lock);
-	spin_lock(&sbi->lookup_lock);
-	head = &sbi->expiring_list;
-	list_for_each(p, head) {
-		struct autofs_info *ino;
-		struct dentry *expiring;
-		struct qstr *qstr;
-
-		ino = list_entry(p, struct autofs_info, expiring);
-		expiring = ino->dentry;
-
-		spin_lock(&expiring->d_lock);
-
-		/* Bad luck, we've already been dentry_iput */
-		if (!expiring->d_inode)
-			goto next;
-
-		qstr = &expiring->d_name;
-
-		if (expiring->d_name.hash != hash)
-			goto next;
-		if (expiring->d_parent != parent)
-			goto next;
-
-		if (qstr->len != len)
-			goto next;
-		if (memcmp(qstr->name, str, len))
-			goto next;
-
-		dget(expiring);
-		spin_unlock(&expiring->d_lock);
-		spin_unlock(&sbi->lookup_lock);
-		spin_unlock(&dcache_lock);
-		return expiring;
-next:
-		spin_unlock(&expiring->d_lock);
-	}
-	spin_unlock(&sbi->lookup_lock);
-	spin_unlock(&dcache_lock);
-
-	return NULL;
-}
-
-static struct autofs_info *init_new_dentry(struct autofs_sb_info *sbi,
-					   struct dentry *dentry, int oz_mode)
-{
-	struct autofs_info *ino;
-
-	/*
-	 * Mark the dentry incomplete but don't hash it. We do this
-	 * to serialize our inode creation operations (symlink and
-	 * mkdir) which prevents deadlock during the callback to
-	 * the daemon. Subsequent user space lookups for the same
-	 * dentry are placed on the wait queue while the daemon
-	 * itself is allowed passage unresticted so the create
-	 * operation itself can then hash the dentry. Finally,
-	 * we check for the hashed dentry and return the newly
-	 * hashed dentry.
-	 */
-	dentry->d_op = &autofs4_root_dentry_operations;
-
-	/*
-	 * And we need to ensure that the same dentry is used for
-	 * all following lookup calls until it is hashed so that
-	 * the dentry flags are persistent throughout the request.
-	 */
-	ino = autofs4_init_ino(NULL, sbi, 0555);
-	if (!ino)
-		return ERR_PTR(-ENOMEM);
-
-	dentry->d_fsdata = ino;
-	ino->dentry = dentry;
-
-	/*
-	 * Only set the mount pending flag for new dentrys not created
-	 * by the daemon.
-	 */
-	if (!oz_mode)
-		ino->flags |= AUTOFS_INF_PENDING;
-
-	d_instantiate(dentry, NULL);
-
-	return ino;
-}
-
-/* Lookups in the root directory */
-static struct dentry *autofs4_lookup(struct inode *dir,
-				     struct dentry *dentry,
-				     struct nameidata *nd)
-{
-	struct autofs_sb_info *sbi;
-	struct autofs_info *ino;
-	struct dentry *expiring, *active;
-	int oz_mode;
-	int status = 0;
-
-	DPRINTK("name = %.*s",
-		dentry->d_name.len, dentry->d_name.name);
-
-	/* File name too long to exist */
-	if (dentry->d_name.len > NAME_MAX)
-		return ERR_PTR(-ENAMETOOLONG);
-
-	sbi = autofs4_sbi(dir->i_sb);
-	oz_mode = autofs4_oz_mode(sbi);
-
-	DPRINTK("pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d",
-		 current->pid, task_pgrp_nr(current), sbi->catatonic, oz_mode);
-
-	spin_lock(&sbi->fs_lock);
-	active = autofs4_lookup_active(dentry);
-	if (active) {
-		dentry = active;
-		ino = autofs4_dentry_ino(dentry);
-		/* If this came from revalidate, rehash it */
-		autofs4_revalidate_rehash(dentry);
-		spin_unlock(&sbi->fs_lock);
-	} else {
-		spin_unlock(&sbi->fs_lock);
-		ino = init_new_dentry(sbi, dentry, oz_mode);
-		if (IS_ERR(ino))
-			return (struct dentry *) ino;
-	}
-
-	autofs4_add_active(dentry);
-
-	if (!oz_mode) {
-		expiring = autofs4_lookup_expiring(dentry);
-		mutex_unlock(&dir->i_mutex);
-		if (expiring) {
-			/*
-			 * If we are racing with expire the request might not
-			 * be quite complete but the directory has been removed
-			 * so it must have been successful, so just wait for it.
-			 */
-			autofs4_expire_wait(expiring);
-			dput(expiring);
-		}
-		status = try_to_fill_dentry(dentry);
-		mutex_lock(&dir->i_mutex);
-		spin_lock(&sbi->fs_lock);
-		ino->flags &= ~AUTOFS_INF_PENDING;
-		spin_unlock(&sbi->fs_lock);
-	}
-
-	autofs4_del_active(dentry);
-
-	/*
-	 * If we had a mount fail, check if we had to handle
-	 * a signal. If so we can force a restart..
-	 */
-	if (status) {
-		/* See if we were interrupted */
-		if (signal_pending(current)) {
-			sigset_t *sigset = &current->pending.signal;
-			if (sigismember(sigset, SIGKILL) ||
-			    sigismember(sigset, SIGQUIT) ||
-			    sigismember(sigset, SIGINT)) {
-			    if (active)
-				dput(active);
-			    return ERR_PTR(-ERESTARTNOINTR);
-			}
-		}
-	}
-
-	/*
-	 * User space can (and has done in the past) remove and re-create
-	 * this directory during the callback. This can leave us with an
-	 * unhashed dentry, but a successful mount!  So we need to
-	 * perform another cached lookup in case the dentry now exists.
-	 */
-	if (!oz_mode && !have_submounts(dentry)) {
-		struct dentry *new;
-		new = d_lookup(dentry->d_parent, &dentry->d_name);
-		if (new) {
-			if (active)
-				dput(active);
-			return new;
-		} else {
-			if (!status)
-				status = -ENOENT;
-		}
-	}
-
-	/*
-	 * If we had a mount failure, return status to user space.
-	 * If the mount succeeded and we used a dentry from the active queue
-	 * return it.
-	 */
-	if (status) {
-		dentry = ERR_PTR(status);
-		if (active)
-			dput(active);
-		return dentry;
-	} else {
-		/*
-		 * Valid successful mount, return active dentry or NULL
-		 * for a new dentry.
-		 */
-		if (active)
-			return active;
-	}
-
-	return NULL;
-}
-
-static int autofs4_dir_symlink(struct inode *dir,
-			       struct dentry *dentry,
-			       const char *symname)
-{
-	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
-	struct autofs_info *p_ino;
-	struct inode *inode;
-	char *cp;
-
-	DPRINTK("%s <- %.*s", symname,
-		dentry->d_name.len, dentry->d_name.name);
-
-	if (!autofs4_oz_mode(sbi))
-		return -EACCES;
-
-	ino = autofs4_init_ino(ino, sbi, S_IFLNK | 0555);
-	if (!ino)
-		return -ENOMEM;
-
-	ino->size = strlen(symname);
-	cp = kmalloc(ino->size + 1, GFP_KERNEL);
-	if (!cp) {
-		if (!dentry->d_fsdata)
-			kfree(ino);
-		return -ENOMEM;
-	}
-
-	strcpy(cp, symname);
-
-	inode = autofs4_get_inode(dir->i_sb, ino);
-	if (!inode) {
-		kfree(cp);
-		if (!dentry->d_fsdata)
-			kfree(ino);
-		return -ENOMEM;
-	}
-	d_add(dentry, inode);
-
-	if (dir == dir->i_sb->s_root->d_inode)
-		dentry->d_op = &autofs4_root_dentry_operations;
-	else
-		dentry->d_op = &autofs4_dentry_operations;
-
-	dentry->d_fsdata = ino;
-	ino->dentry = dget(dentry);
-	atomic_inc(&ino->count);
-	p_ino = autofs4_dentry_ino(dentry->d_parent);
-	if (p_ino && dentry->d_parent != dentry)
-		atomic_inc(&p_ino->count);
-	ino->inode = inode;
-
-	ino->u.symlink = cp;
-	dir->i_mtime = CURRENT_TIME;
-
-	return 0;
-}
-
-/*
- * NOTE!
- *
- * Normal filesystems would do a "d_delete()" to tell the VFS dcache
- * that the file no longer exists. However, doing that means that the
- * VFS layer can turn the dentry into a negative dentry.  We don't want
- * this, because the unlink is probably the result of an expire.
- * We simply d_drop it and add it to a expiring list in the super block,
- * which allows the dentry lookup to check for an incomplete expire.
- *
- * If a process is blocked on the dentry waiting for the expire to finish,
- * it will invalidate the dentry and try to mount with a new one.
- *
- * Also see autofs4_dir_rmdir()..
- */
-static int autofs4_dir_unlink(struct inode *dir, struct dentry *dentry)
-{
-	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
-	struct autofs_info *p_ino;
-
-	/* This allows root to remove symlinks */
-	if (!autofs4_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
-	if (atomic_dec_and_test(&ino->count)) {
-		p_ino = autofs4_dentry_ino(dentry->d_parent);
-		if (p_ino && dentry->d_parent != dentry)
-			atomic_dec(&p_ino->count);
-	}
-	dput(ino->dentry);
-
-	dentry->d_inode->i_size = 0;
-	clear_nlink(dentry->d_inode);
-
-	dir->i_mtime = CURRENT_TIME;
-
-	spin_lock(&dcache_lock);
-	spin_lock(&dentry->d_lock);
-	__d_drop(dentry);
-	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
-
-	return 0;
-}
-
-static int autofs4_dir_rmdir(struct inode *dir, struct dentry *dentry)
-{
-	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
-	struct autofs_info *p_ino;
-
-	DPRINTK("dentry %p, removing %.*s",
-		dentry, dentry->d_name.len, dentry->d_name.name);
-
-	if (!autofs4_oz_mode(sbi))
-		return -EACCES;
-
-	spin_lock(&dcache_lock);
-	if (!list_empty(&dentry->d_subdirs)) {
-		spin_unlock(&dcache_lock);
-		return -ENOTEMPTY;
-	}
-	spin_lock(&dentry->d_lock);
-	__d_drop(dentry);
-	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
-
-	if (atomic_dec_and_test(&ino->count)) {
-		p_ino = autofs4_dentry_ino(dentry->d_parent);
-		if (p_ino && dentry->d_parent != dentry)
-			atomic_dec(&p_ino->count);
-	}
-	dput(ino->dentry);
-	dentry->d_inode->i_size = 0;
-	clear_nlink(dentry->d_inode);
-
-	if (dir->i_nlink)
-		drop_nlink(dir);
-
-	return 0;
-}
-
-static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, int mode)
-{
-	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
-	struct autofs_info *p_ino;
-	struct inode *inode;
-
-	if (!autofs4_oz_mode(sbi))
-		return -EACCES;
-
-	DPRINTK("dentry %p, creating %.*s",
-		dentry, dentry->d_name.len, dentry->d_name.name);
-
-	ino = autofs4_init_ino(ino, sbi, S_IFDIR | 0555);
-	if (!ino)
-		return -ENOMEM;
-
-	inode = autofs4_get_inode(dir->i_sb, ino);
-	if (!inode) {
-		if (!dentry->d_fsdata)
-			kfree(ino);
-		return -ENOMEM;
-	}
-	d_add(dentry, inode);
-
-	if (dir == dir->i_sb->s_root->d_inode)
-		dentry->d_op = &autofs4_root_dentry_operations;
-	else
-		dentry->d_op = &autofs4_dentry_operations;
-
-	dentry->d_fsdata = ino;
-	ino->dentry = dget(dentry);
-	atomic_inc(&ino->count);
-	p_ino = autofs4_dentry_ino(dentry->d_parent);
-	if (p_ino && dentry->d_parent != dentry)
-		atomic_inc(&p_ino->count);
-	ino->inode = inode;
-	inc_nlink(dir);
-	dir->i_mtime = CURRENT_TIME;
-
-	return 0;
-}
-
-/* Get/set timeout ioctl() operation */
-static inline int autofs4_get_set_timeout(struct autofs_sb_info *sbi,
-					 unsigned long __user *p)
-{
-	int rv;
-	unsigned long ntimeout;
-
-	if ((rv = get_user(ntimeout, p)) ||
-	     (rv = put_user(sbi->exp_timeout/HZ, p)))
-		return rv;
-
-	if (ntimeout > ULONG_MAX/HZ)
-		sbi->exp_timeout = 0;
-	else
-		sbi->exp_timeout = ntimeout * HZ;
-
-	return 0;
-}
-
-/* Return protocol version */
-static inline int
-autofs4_get_protover(struct autofs_sb_info *sbi, int __user *p)
-{
-	return put_user(sbi->version, p);
-}
-
-/* Return protocol sub version */
-static inline int
-autofs4_get_protosubver(struct autofs_sb_info *sbi, int __user *p)
-{
-	return put_user(sbi->sub_version, p);
-}
-
-/*
-* Tells the daemon whether it can umount the autofs mount.
-*/
-static inline int autofs4_ask_umount(struct vfsmount *mnt, int __user *p)
-{
-	int status = 0;
-
-	if (may_umount(mnt))
-		status = 1;
-
-	DPRINTK("returning %d", status);
-
-	status = put_user(status, p);
-
-	return status;
-}
-
-/* Identify autofs4_dentries - this is so we can tell if there's
-   an extra dentry refcount or not.  We only hold a refcount on the
-   dentry if its non-negative (ie, d_inode != NULL)
-*/
-int is_autofs4_dentry(struct dentry *dentry)
-{
-	return dentry && dentry->d_inode &&
-		(dentry->d_op == &autofs4_root_dentry_operations ||
-		 dentry->d_op == &autofs4_dentry_operations) &&
-		dentry->d_fsdata != NULL;
-}
-
-/*
- * ioctl()'s on the root directory is the chief method for the daemon to
- * generate kernel reactions
- */
-static int autofs4_root_ioctl(struct inode *inode, struct file *filp,
-			     unsigned int cmd, unsigned long arg)
-{
-	struct autofs_sb_info *sbi = autofs4_sbi(inode->i_sb);
-	void __user *p = (void __user *)arg;
-
-	DPRINTK("cmd = 0x%08x, arg = 0x%08lx, sbi = %p, pgrp = %u",
-		cmd, arg, sbi, task_pgrp_nr(current));
-
-	if (_IOC_TYPE(cmd) != _IOC_TYPE(AUTOFS_IOC_FIRST) ||
-	     _IOC_NR(cmd) - _IOC_NR(AUTOFS_IOC_FIRST) >= AUTOFS_IOC_COUNT)
-		return -ENOTTY;
-	
-	if (!autofs4_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
-		return -EPERM;
-	
-	switch(cmd) {
-	case AUTOFS_IOC_READY:	/* Wait queue: go ahead and retry */
-		return autofs4_wait_release(sbi, (autofs_wqt_t)arg, 0);
-	case AUTOFS_IOC_FAIL:	/* Wait queue: fail with ENOENT */
-		return autofs4_wait_release(sbi, (autofs_wqt_t)arg, -ENOENT);
-	case AUTOFS_IOC_CATATONIC: /* Enter catatonic mode (daemon shutdown) */
-		autofs4_catatonic_mode(sbi);
-		return 0;
-	case AUTOFS_IOC_PROTOVER: /* Get protocol version */
-		return autofs4_get_protover(sbi, p);
-	case AUTOFS_IOC_PROTOSUBVER: /* Get protocol sub version */
-		return autofs4_get_protosubver(sbi, p);
-	case AUTOFS_IOC_SETTIMEOUT:
-		return autofs4_get_set_timeout(sbi, p);
-
-	case AUTOFS_IOC_ASKUMOUNT:
-		return autofs4_ask_umount(filp->f_path.mnt, p);
-
-	/* return a single thing to expire */
-	case AUTOFS_IOC_EXPIRE:
-		return autofs4_expire_run(inode->i_sb,
-					  filp->f_path.mnt, sbi, p);
-
-	/* same as above, but can send multiple expires through pipe */
-	case AUTOFS_IOC_EXPIRE_MULTI:
-		return autofs4_expire_multi(inode->i_sb,
-					    filp->f_path.mnt, sbi, p);
-
-	default:
-		return -ENOSYS;
-	}
-}
diff --git a/fs/autofs4/symlink.c b/fs/autofs4/symlink.c
deleted file mode 100644
index 296fbd9..0000000
--- a/fs/autofs4/symlink.c
+++ /dev/null
@@ -1,22 +0,0 @@
-/*
- *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
- *
- * This file is part of the Linux kernel and is made available under
- * the terms of the GNU General Public License, version 2, or at your
- * option, any later version, incorporated herein by reference.
- *
- * ------------------------------------------------------------------------- */
-
-#include "autofs_i.h"
-
-static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
-{
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
-	nd_set_link(nd, (char *)ino->u.symlink);
-	return NULL;
-}
-
-const struct inode_operations autofs4_symlink_inode_operations = {
-	.readlink	= generic_readlink,
-	.follow_link	= autofs4_follow_link
-};
diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
deleted file mode 100644
index a4e55da..0000000
--- a/fs/autofs4/waitq.c
+++ /dev/null
@@ -1,525 +0,0 @@
-/*
- *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
- *  Copyright 2001-2006 Ian Kent <raven@themaw.net>
- *
- * This file is part of the Linux kernel and is made available under
- * the terms of the GNU General Public License, version 2, or at your
- * option, any later version, incorporated herein by reference.
- *
- * ------------------------------------------------------------------------- */
-
-#include <linux/slab.h>
-#include <linux/time.h>
-#include <linux/signal.h>
-#include <linux/file.h>
-#include "autofs_i.h"
-
-/* We make this a static variable rather than a part of the superblock; it
-   is better if we don't reassign numbers easily even across filesystems */
-static autofs_wqt_t autofs4_next_wait_queue = 1;
-
-/* These are the signals we allow interrupting a pending mount */
-#define SHUTDOWN_SIGS	(sigmask(SIGKILL) | sigmask(SIGINT) | sigmask(SIGQUIT))
-
-void autofs4_catatonic_mode(struct autofs_sb_info *sbi)
-{
-	struct autofs_wait_queue *wq, *nwq;
-
-	mutex_lock(&sbi->wq_mutex);
-	if (sbi->catatonic) {
-		mutex_unlock(&sbi->wq_mutex);
-		return;
-	}
-
-	DPRINTK("entering catatonic mode");
-
-	sbi->catatonic = 1;
-	wq = sbi->queues;
-	sbi->queues = NULL;	/* Erase all wait queues */
-	while (wq) {
-		nwq = wq->next;
-		wq->status = -ENOENT; /* Magic is gone - report failure */
-		if (wq->name.name) {
-			kfree(wq->name.name);
-			wq->name.name = NULL;
-		}
-		wq->wait_ctr--;
-		wake_up_interruptible(&wq->queue);
-		wq = nwq;
-	}
-	fput(sbi->pipe);	/* Close the pipe */
-	sbi->pipe = NULL;
-	sbi->pipefd = -1;
-	mutex_unlock(&sbi->wq_mutex);
-}
-
-static int autofs4_write(struct file *file, const void *addr, int bytes)
-{
-	unsigned long sigpipe, flags;
-	mm_segment_t fs;
-	const char *data = (const char *)addr;
-	ssize_t wr = 0;
-
-	/** WARNING: this is not safe for writing more than PIPE_BUF bytes! **/
-
-	sigpipe = sigismember(&current->pending.signal, SIGPIPE);
-
-	/* Save pointer to user space and point back to kernel space */
-	fs = get_fs();
-	set_fs(KERNEL_DS);
-
-	while (bytes &&
-	       (wr = file->f_op->write(file,data,bytes,&file->f_pos)) > 0) {
-		data += wr;
-		bytes -= wr;
-	}
-
-	set_fs(fs);
-
-	/* Keep the currently executing process from receiving a
-	   SIGPIPE unless it was already supposed to get one */
-	if (wr == -EPIPE && !sigpipe) {
-		spin_lock_irqsave(&current->sighand->siglock, flags);
-		sigdelset(&current->pending.signal, SIGPIPE);
-		recalc_sigpending();
-		spin_unlock_irqrestore(&current->sighand->siglock, flags);
-	}
-
-	return (bytes > 0);
-}
-	
-static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
-				 struct autofs_wait_queue *wq,
-				 int type)
-{
-	union {
-		struct autofs_packet_hdr hdr;
-		union autofs_packet_union v4_pkt;
-		union autofs_v5_packet_union v5_pkt;
-	} pkt;
-	struct file *pipe = NULL;
-	size_t pktsz;
-
-	DPRINTK("wait id = 0x%08lx, name = %.*s, type=%d",
-		wq->wait_queue_token, wq->name.len, wq->name.name, type);
-
-	memset(&pkt,0,sizeof pkt); /* For security reasons */
-
-	pkt.hdr.proto_version = sbi->version;
-	pkt.hdr.type = type;
-	switch (type) {
-	/* Kernel protocol v4 missing and expire packets */
-	case autofs_ptype_missing:
-	{
-		struct autofs_packet_missing *mp;
-
-		mp = &pkt.v4_pkt.missing;
-		pktsz = sizeof(*mp);
-
-		mp->wait_queue_token = wq->wait_queue_token;
-		mp->len = wq->name.len;
-		memcpy(mp->name, wq->name.name, wq->name.len);
-		mp->name[wq->name.len] = '\0';
-		break;
-	}
-	case autofs_ptype_expire_multi:
-	{
-		struct autofs_packet_expire_multi *ep;
-
-		ep = &pkt.v4_pkt.expire_multi;
-		pktsz = sizeof(*ep);
-
-		ep->wait_queue_token = wq->wait_queue_token;
-		ep->len = wq->name.len;
-		memcpy(ep->name, wq->name.name, wq->name.len);
-		ep->name[wq->name.len] = '\0';
-		break;
-	}
-	/*
-	 * Kernel protocol v5 packet for handling indirect and direct
-	 * mount missing and expire requests
-	 */
-	case autofs_ptype_missing_indirect:
-	case autofs_ptype_expire_indirect:
-	case autofs_ptype_missing_direct:
-	case autofs_ptype_expire_direct:
-	{
-		struct autofs_v5_packet *packet;
-
-		packet = &pkt.v5_pkt.v5_packet;
-		pktsz = sizeof(*packet);
-
-		packet->wait_queue_token = wq->wait_queue_token;
-		packet->len = wq->name.len;
-		memcpy(packet->name, wq->name.name, wq->name.len);
-		packet->name[wq->name.len] = '\0';
-		packet->dev = wq->dev;
-		packet->ino = wq->ino;
-		packet->uid = wq->uid;
-		packet->gid = wq->gid;
-		packet->pid = wq->pid;
-		packet->tgid = wq->tgid;
-		break;
-	}
-	default:
-		printk(KERN_ERR "autofs4_notify_daemon: bad type %d!\n", type);
-		return;
-	}
-
-	/* Check if we have become catatonic */
-	mutex_lock(&sbi->wq_mutex);
-	if (!sbi->catatonic) {
-		pipe = sbi->pipe;
-		get_file(pipe);
-	}
-	mutex_unlock(&sbi->wq_mutex);
-
-	if (pipe) {
-		if (autofs4_write(pipe, &pkt, pktsz))
-			autofs4_catatonic_mode(sbi);
-		fput(pipe);
-	}
-}
-
-static int autofs4_getpath(struct autofs_sb_info *sbi,
-			   struct dentry *dentry, char **name)
-{
-	struct dentry *root = sbi->sb->s_root;
-	struct dentry *tmp;
-	char *buf = *name;
-	char *p;
-	int len = 0;
-
-	spin_lock(&dcache_lock);
-	for (tmp = dentry ; tmp != root ; tmp = tmp->d_parent)
-		len += tmp->d_name.len + 1;
-
-	if (!len || --len > NAME_MAX) {
-		spin_unlock(&dcache_lock);
-		return 0;
-	}
-
-	*(buf + len) = '\0';
-	p = buf + len - dentry->d_name.len;
-	strncpy(p, dentry->d_name.name, dentry->d_name.len);
-
-	for (tmp = dentry->d_parent; tmp != root ; tmp = tmp->d_parent) {
-		*(--p) = '/';
-		p -= tmp->d_name.len;
-		strncpy(p, tmp->d_name.name, tmp->d_name.len);
-	}
-	spin_unlock(&dcache_lock);
-
-	return len;
-}
-
-static struct autofs_wait_queue *
-autofs4_find_wait(struct autofs_sb_info *sbi, struct qstr *qstr)
-{
-	struct autofs_wait_queue *wq;
-
-	for (wq = sbi->queues; wq; wq = wq->next) {
-		if (wq->name.hash == qstr->hash &&
-		    wq->name.len == qstr->len &&
-		    wq->name.name &&
-			 !memcmp(wq->name.name, qstr->name, qstr->len))
-			break;
-	}
-	return wq;
-}
-
-/*
- * Check if we have a valid request.
- * Returns
- * 1 if the request should continue.
- *   In this case we can return an autofs_wait_queue entry if one is
- *   found or NULL to idicate a new wait needs to be created.
- * 0 or a negative errno if the request shouldn't continue.
- */
-static int validate_request(struct autofs_wait_queue **wait,
-			    struct autofs_sb_info *sbi,
-			    struct qstr *qstr,
-			    struct dentry *dentry, enum autofs_notify notify)
-{
-	struct autofs_wait_queue *wq;
-	struct autofs_info *ino;
-
-	/* Wait in progress, continue; */
-	wq = autofs4_find_wait(sbi, qstr);
-	if (wq) {
-		*wait = wq;
-		return 1;
-	}
-
-	*wait = NULL;
-
-	/* If we don't yet have any info this is a new request */
-	ino = autofs4_dentry_ino(dentry);
-	if (!ino)
-		return 1;
-
-	/*
-	 * If we've been asked to wait on an existing expire (NFY_NONE)
-	 * but there is no wait in the queue ...
-	 */
-	if (notify == NFY_NONE) {
-		/*
-		 * Either we've betean the pending expire to post it's
-		 * wait or it finished while we waited on the mutex.
-		 * So we need to wait till either, the wait appears
-		 * or the expire finishes.
-		 */
-
-		while (ino->flags & AUTOFS_INF_EXPIRING) {
-			mutex_unlock(&sbi->wq_mutex);
-			schedule_timeout_interruptible(HZ/10);
-			if (mutex_lock_interruptible(&sbi->wq_mutex))
-				return -EINTR;
-
-			wq = autofs4_find_wait(sbi, qstr);
-			if (wq) {
-				*wait = wq;
-				return 1;
-			}
-		}
-
-		/*
-		 * Not ideal but the status has already gone. Of the two
-		 * cases where we wait on NFY_NONE neither depend on the
-		 * return status of the wait.
-		 */
-		return 0;
-	}
-
-	/*
-	 * If we've been asked to trigger a mount and the request
-	 * completed while we waited on the mutex ...
-	 */
-	if (notify == NFY_MOUNT) {
-		/*
-		 * If the dentry was successfully mounted while we slept
-		 * on the wait queue mutex we can return success. If it
-		 * isn't mounted (doesn't have submounts for the case of
-		 * a multi-mount with no mount at it's base) we can
-		 * continue on and create a new request.
-		 */
-		if (have_submounts(dentry))
-			return 0;
-	}
-
-	return 1;
-}
-
-int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
-		enum autofs_notify notify)
-{
-	struct autofs_wait_queue *wq;
-	struct qstr qstr;
-	char *name;
-	int status, ret, type;
-
-	/* In catatonic mode, we don't wait for nobody */
-	if (sbi->catatonic)
-		return -ENOENT;
-
-	if (!dentry->d_inode) {
-		/*
-		 * A wait for a negative dentry is invalid for certain
-		 * cases. A direct or offset mount "always" has its mount
-		 * point directory created and so the request dentry must
-		 * be positive or the map key doesn't exist. The situation
-		 * is very similar for indirect mounts except only dentrys
-		 * in the root of the autofs file system may be negative.
-		 */
-		if (autofs_type_trigger(sbi->type))
-			return -ENOENT;
-		else if (!IS_ROOT(dentry->d_parent))
-			return -ENOENT;
-	}
-
-	name = kmalloc(NAME_MAX + 1, GFP_KERNEL);
-	if (!name)
-		return -ENOMEM;
-
-	/* If this is a direct mount request create a dummy name */
-	if (IS_ROOT(dentry) && autofs_type_trigger(sbi->type))
-		qstr.len = sprintf(name, "%p", dentry);
-	else {
-		qstr.len = autofs4_getpath(sbi, dentry, &name);
-		if (!qstr.len) {
-			kfree(name);
-			return -ENOENT;
-		}
-	}
-	qstr.name = name;
-	qstr.hash = full_name_hash(name, qstr.len);
-
-	if (mutex_lock_interruptible(&sbi->wq_mutex)) {
-		kfree(qstr.name);
-		return -EINTR;
-	}
-
-	ret = validate_request(&wq, sbi, &qstr, dentry, notify);
-	if (ret <= 0) {
-		if (ret == 0)
-			mutex_unlock(&sbi->wq_mutex);
-		kfree(qstr.name);
-		return ret;
-	}
-
-	if (!wq) {
-		/* Create a new wait queue */
-		wq = kmalloc(sizeof(struct autofs_wait_queue),GFP_KERNEL);
-		if (!wq) {
-			kfree(qstr.name);
-			mutex_unlock(&sbi->wq_mutex);
-			return -ENOMEM;
-		}
-
-		wq->wait_queue_token = autofs4_next_wait_queue;
-		if (++autofs4_next_wait_queue == 0)
-			autofs4_next_wait_queue = 1;
-		wq->next = sbi->queues;
-		sbi->queues = wq;
-		init_waitqueue_head(&wq->queue);
-		memcpy(&wq->name, &qstr, sizeof(struct qstr));
-		wq->dev = autofs4_get_dev(sbi);
-		wq->ino = autofs4_get_ino(sbi);
-		wq->uid = current_uid();
-		wq->gid = current_gid();
-		wq->pid = current->pid;
-		wq->tgid = current->tgid;
-		wq->status = -EINTR; /* Status return if interrupted */
-		wq->wait_ctr = 2;
-		mutex_unlock(&sbi->wq_mutex);
-
-		if (sbi->version < 5) {
-			if (notify == NFY_MOUNT)
-				type = autofs_ptype_missing;
-			else
-				type = autofs_ptype_expire_multi;
-		} else {
-			if (notify == NFY_MOUNT)
-				type = autofs_type_trigger(sbi->type) ?
-					autofs_ptype_missing_direct :
-					 autofs_ptype_missing_indirect;
-			else
-				type = autofs_type_trigger(sbi->type) ?
-					autofs_ptype_expire_direct :
-					autofs_ptype_expire_indirect;
-		}
-
-		DPRINTK("new wait id = 0x%08lx, name = %.*s, nfy=%d\n",
-			(unsigned long) wq->wait_queue_token, wq->name.len,
-			wq->name.name, notify);
-
-		/* autofs4_notify_daemon() may block */
-		autofs4_notify_daemon(sbi, wq, type);
-	} else {
-		wq->wait_ctr++;
-		mutex_unlock(&sbi->wq_mutex);
-		kfree(qstr.name);
-		DPRINTK("existing wait id = 0x%08lx, name = %.*s, nfy=%d",
-			(unsigned long) wq->wait_queue_token, wq->name.len,
-			wq->name.name, notify);
-	}
-
-	/*
-	 * wq->name.name is NULL iff the lock is already released
-	 * or the mount has been made catatonic.
-	 */
-	if (wq->name.name) {
-		/* Block all but "shutdown" signals while waiting */
-		sigset_t oldset;
-		unsigned long irqflags;
-
-		spin_lock_irqsave(&current->sighand->siglock, irqflags);
-		oldset = current->blocked;
-		siginitsetinv(&current->blocked, SHUTDOWN_SIGS & ~oldset.sig[0]);
-		recalc_sigpending();
-		spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
-
-		wait_event_interruptible(wq->queue, wq->name.name == NULL);
-
-		spin_lock_irqsave(&current->sighand->siglock, irqflags);
-		current->blocked = oldset;
-		recalc_sigpending();
-		spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
-	} else {
-		DPRINTK("skipped sleeping");
-	}
-
-	status = wq->status;
-
-	/*
-	 * For direct and offset mounts we need to track the requester's
-	 * uid and gid in the dentry info struct. This is so it can be
-	 * supplied, on request, by the misc device ioctl interface.
-	 * This is needed during daemon resatart when reconnecting
-	 * to existing, active, autofs mounts. The uid and gid (and
-	 * related string values) may be used for macro substitution
-	 * in autofs mount maps.
-	 */
-	if (!status) {
-		struct autofs_info *ino;
-		struct dentry *de = NULL;
-
-		/* direct mount or browsable map */
-		ino = autofs4_dentry_ino(dentry);
-		if (!ino) {
-			/* If not lookup actual dentry used */
-			de = d_lookup(dentry->d_parent, &dentry->d_name);
-			if (de)
-				ino = autofs4_dentry_ino(de);
-		}
-
-		/* Set mount requester */
-		if (ino) {
-			spin_lock(&sbi->fs_lock);
-			ino->uid = wq->uid;
-			ino->gid = wq->gid;
-			spin_unlock(&sbi->fs_lock);
-		}
-
-		if (de)
-			dput(de);
-	}
-
-	/* Are we the last process to need status? */
-	mutex_lock(&sbi->wq_mutex);
-	if (!--wq->wait_ctr)
-		kfree(wq);
-	mutex_unlock(&sbi->wq_mutex);
-
-	return status;
-}
-
-
-int autofs4_wait_release(struct autofs_sb_info *sbi,
-			 autofs_wqt_t wait_queue_token, int status)
-{
-	struct autofs_wait_queue *wq, **wql;
-
-	mutex_lock(&sbi->wq_mutex);
-	for (wql = &sbi->queues; (wq = *wql) != NULL; wql = &wq->next) {
-		if (wq->wait_queue_token == wait_queue_token)
-			break;
-	}
-
-	if (!wq) {
-		mutex_unlock(&sbi->wq_mutex);
-		return -EINVAL;
-	}
-
-	*wql = wq->next;	/* Unlink from chain */
-	kfree(wq->name.name);
-	wq->name.name = NULL;	/* Do not wait on this queue */
-	wq->status = status;
-	wake_up_interruptible(&wq->queue);
-	if (!--wq->wait_ctr)
-		kfree(wq);
-	mutex_unlock(&sbi->wq_mutex);
-
-	return 0;
-}
-

