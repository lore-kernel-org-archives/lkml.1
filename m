Return-Path: <linux-kernel-owner+w=401wt.eu-S1765179AbYHDVnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765179AbYHDVnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1770895AbYHDVma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:42:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759294AbYHDVm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:42:27 -0400
From: Eric Paris <eparis@redhat.com>
To: malware-list@lists.printk.net, linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>
Subject: [RFC 3/5] [TALPA] Access result caching
Date: Mon,  4 Aug 2008 17:00:38 -0400
Message-Id: <1217883640-29121-3-git-send-email-eparis@redhat.com>
X-Mailer: git-send-email 1.5.5.2
In-Reply-To: <1217883640-29121-2-git-send-email-eparis@redhat.com>
References: <1217883640-29121-1-git-send-email-eparis@redhat.com>
 <1217883640-29121-2-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cache both positive and negative access results.  All inode access starts
allowed in the cache for performance reasons.  Descriptions of the cache operation
can be found in Documentation/talpa/cache and in security/talpa/talpa_cache.c

Signed-off-by: Eric Paris <eparis@redhat.com>
---
 Documentation/talpa/cache               |   17 +++
 fs/inode.c                              |    6 +
 fs/namei.c                              |    2 +
 include/linux/fs.h                      |    5 +
 include/linux/talpa.h                   |   17 +++
 security/talpa/Kconfig                  |   13 ++
 security/talpa/Makefile                 |    2 +
 security/talpa/talpa.h                  |   10 ++
 security/talpa/talpa_allow_calls.h      |    7 +
 security/talpa/talpa_cache.c            |  207 +++++++++++++++++++++++++++++++
 security/talpa/talpa_cache.h            |   22 ++++
 security/talpa/talpa_common.c           |    2 +
 security/talpa/talpa_deny_calls.h       |    6 +
 security/talpa/talpa_evaluation_calls.h |   26 ++++-
 14 files changed, 341 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/talpa/cache
 create mode 100644 security/talpa/talpa_cache.c
 create mode 100644 security/talpa/talpa_cache.h

diff --git a/Documentation/talpa/cache b/Documentation/talpa/cache
new file mode 100644
index 0000000..8010b53
--- /dev/null
+++ b/Documentation/talpa/cache
@@ -0,0 +1,17 @@
+The cache mechanism of talpa is incredibly simple.
+
+Talpa maintains a global long called talpa_cache_seqno which is initially zero and monotomically increases either when there is a talpa configuration change or when userspace signals it should be increased.  Caching of inodes is done by adding a field to each inode, i_talpa_cache_seqno.  If talpa determines authoritatively that access to an inode should be allowed or denied the value of the global sequence number will be assigned to the inode.  When allowed the inode is assigned the same value as the global and when denied the inode is assigned the negative of the global value.
+
+When a future access is attempted on an inode the value in inode is compared to the global sequence number.  If they match the access is permitted.  If the inode value is the negative of the global the access is denied.  If the value of the inode is less than the global we can neither allow nor deny access and instead let other filters make the decision.
+
+Invalidating the cache is atomic and is as simple as incrementing the global talpa_cache_seqno.
+
+**********************
+
+/security/talpa/cache/*
+
+enabled: RW:	0 for caching disabled or 1 for caching enabled
+hits: RO:	number of cache hits since the system started
+misses: RO:	number of cache misses since the system started
+increment_seqno: WRONLY:  echo 1 into this file will increment the global sequence number and thus invalidate the cache
+seqno: RO:	the value of the global sequence number
diff --git a/fs/inode.c b/fs/inode.c
index b6726f6..2de5a35 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -17,6 +17,7 @@
 #include <linux/hash.h>
 #include <linux/swap.h>
 #include <linux/security.h>
+#include <linux/talpa.h>
 #include <linux/pagemap.h>
 #include <linux/cdev.h>
 #include <linux/bootmem.h>
@@ -182,6 +183,9 @@ static struct inode *alloc_inode(struct super_block *sb)
 		}
 		inode->i_private = NULL;
 		inode->i_mapping = mapping;
+#ifdef CONFIG_TALPA_CACHE
+		inode->i_talpa_cache_seqno = 0;
+#endif
 	}
 	return inode;
 }
@@ -1268,6 +1272,8 @@ void file_update_time(struct file *file)
 		sync_it = 1;
 	}
 
+	talpa_invalidate_inode(inode);
+
 	if (sync_it)
 		mark_inode_dirty_sync(inode);
 	mnt_drop_write(file->f_path.mnt);
diff --git a/fs/namei.c b/fs/namei.c
index 4ea63ed..0eef4ae 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -31,6 +31,7 @@
 #include <linux/file.h>
 #include <linux/fcntl.h>
 #include <linux/device_cgroup.h>
+#include <linux/talpa.h>
 #include <asm/uaccess.h>
 
 #define ACC_MODE(x) ("\000\004\002\006"[(x)&O_ACCMODE])
@@ -335,6 +336,7 @@ int get_write_access(struct inode * inode)
 		return -ETXTBSY;
 	}
 	atomic_inc(&inode->i_writecount);
+	talpa_invalidate_inode(inode);
 	spin_unlock(&inode->i_lock);
 
 	return 0;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 580b513..30bda8f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -680,6 +680,11 @@ struct inode {
 #ifdef CONFIG_SECURITY
 	void			*i_security;
 #endif
+
+#ifdef CONFIG_TALPA_CACHE
+	long			i_talpa_cache_seqno;
+#endif
+
 	void			*i_private; /* fs or device private pointer */
 };
 
diff --git a/include/linux/talpa.h b/include/linux/talpa.h
index 4ae05ba..52750b7 100644
--- a/include/linux/talpa.h
+++ b/include/linux/talpa.h
@@ -47,6 +47,23 @@ enum talpa_operation {
 
 #include <linux/fs.h>
 
+#if defined CONFIG_TALPA && defined CONFIG_TALPA_CACHE
+/**
+ * talpa_invalidate_inode - marks inode status as unknown
+ * @inode:inode to mark
+ *
+ * When write access for an inode is taken cache status must be
+ * invalidated which is what this helper function does.
+ */
+static inline void talpa_invalidate_inode(struct inode *inode)
+{
+	inode->i_talpa_cache_seqno = 0;
+}
+#else
+static inline void talpa_invalidate_inode(struct inode *inode)
+{ }
+#endif
+
 #ifdef CONFIG_TALPA
 
 /* Internal interface. */
diff --git a/security/talpa/Kconfig b/security/talpa/Kconfig
index 0b8449e..7910cc1 100644
--- a/security/talpa/Kconfig
+++ b/security/talpa/Kconfig
@@ -7,3 +7,16 @@ config TALPA
           to 'vet' filesystem operations before they are executed.
 
 	  If you are unsure how to answer this question, answer Y.
+
+
+config TALPA_CACHE
+	bool "Caching of vetting decisions"
+	depends on TALPA
+	default y
+	help
+	  Caching of vetting decisions is crucial for minimising effect
+	  of vetting operations on system performance.
+
+	  By default all block device backed filesystems are cached.
+
+	  If you are unsure how to answer this question, answer Y.
diff --git a/security/talpa/Makefile b/security/talpa/Makefile
index 41045d7..8da21b9 100644
--- a/security/talpa/Makefile
+++ b/security/talpa/Makefile
@@ -7,3 +7,5 @@ obj-$(CONFIG_TALPA) := talpa.o
 talpa-y :=	talpa_interceptor.o \
 		talpa_common.o \
 		talpa_configuration.o
+
+talpa-$(CONFIG_TALPA_CACHE) += talpa_cache.o
diff --git a/security/talpa/talpa.h b/security/talpa/talpa.h
index 871b6d4..8a93512 100644
--- a/security/talpa/talpa.h
+++ b/security/talpa/talpa.h
@@ -60,6 +60,7 @@ struct talpa_file_vetting {
 	int flags;
 	unsigned int authoritative;
 	int code;
+	long cache_seqno;
 };
 
 /**
@@ -97,6 +98,15 @@ struct talpa_configuration {
  */
 extern struct dentry *talpa_register_configuration(char *name, struct talpa_configuration *cfg);
 
+#ifdef CONFIG_TALPA_CACHE
+extern ssize_t talpa_increment_seqno(struct talpa_configuration *cfg, char *buf, size_t len);
+#else /* CONFIG_TALPA_CACHE */
+static inline ssize_t talpa_increment_seqno(struct talpa_configuration *cfg, char *buf, size_t len)
+{
+	return 0;
+}
+#endif /* CONFIG_TALPA_CACHE */
+
 /* Generic configuration get and set methods which can be used in simple cases. */
 extern ssize_t talpa_generic_get_ulong(struct talpa_configuration *cfg, char *buf, size_t len);
 extern ssize_t talpa_generic_set_ulong(struct talpa_configuration *cfg, char *buf, size_t len);
diff --git a/security/talpa/talpa_allow_calls.h b/security/talpa/talpa_allow_calls.h
index eb24482..1f4b309 100644
--- a/security/talpa/talpa_allow_calls.h
+++ b/security/talpa/talpa_allow_calls.h
@@ -1,5 +1,12 @@
 #include "talpa.h"
+#include "talpa_cache.h"
 
 static inline void talpa_allow_calls(struct talpa_file_vetting *tfv)
 {
+	enum talpa_action ret;
+
+#ifdef CONFIG_TALPA_CACHE
+	ret = talpa_cache_allow(tfv);
+#endif /* CONFIG_TALPA_CACHE */
+
 }
diff --git a/security/talpa/talpa_cache.c b/security/talpa/talpa_cache.c
new file mode 100644
index 0000000..239c494
--- /dev/null
+++ b/security/talpa/talpa_cache.c
@@ -0,0 +1,207 @@
+/*
+ *  Copyright 2008 Sophos Plc
+ *  Copyright (C) 2008 Red Hat, Inc., Eric Paris <eparis@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2, or (at your option)
+ *  any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/talpa.h>
+#include <linux/kdev_t.h>
+
+#include "talpa.h"
+
+
+/*
+ * Cache filter caches both positive and negative outcomes of vetting
+ * if they were made based on file content (authoritative).
+ * What is actually cached are inodes which are marked with a positive
+ * or negative seqno number. Token number is a serial number which
+ * can be incremented from outside with the purpose of invalidating
+ * the cache when external entity decides that the set of rules has
+ * changed sufficiently to require that. There is a limit on maximum
+ * number of seqno increases (LONG_MAX) after which it is impossible
+ * to invalidate the cache in this way. However, due to the size of
+ * LONG_MAX it is hard to imagine how this limit would be a problem.
+ * Inode cache status is cleared as soon as write access for that
+ * inode is obtained.
+ * Inodes which are opened for writing elsewhere are not cached at
+ * the time authoritative positive response is received.
+ */
+
+static unsigned long talpa_cache_enbl = 1;
+/*
+ * lock all read/write of auth_seqno.  inside inc_seqno() is could go
+ * negative and then be assigned to an inode incorrectly inside the allow/deny
+ * functions or could cause a BUG in the examine function.
+ */
+DEFINE_MUTEX(talpa_cache_seqno_lock);
+long talpa_cache_seqno;
+static unsigned long talpa_cache_hits;
+static unsigned long talpa_cache_misses;
+
+
+enum talpa_action talpa_cache_examine(struct talpa_file_vetting *tfv)
+{
+	int ret = TALPA_NEXT;
+
+	/*
+	 * order here probably doesn't matter but just to be safe grab
+	 * the serial first.  The race I'm scared of (but probably
+	 * impossible is:
+	 *   Task A          Task B          Task C
+	 *   -Collect seqno
+	 *                   -increment seqno
+	 *                                   -update ino with new seqno
+	 *   -collect serial from ino
+	 *   -BUG()
+	 * Collecting serial first just means we might scan a couple
+	 * extra times, but at least its safe.
+	 */
+	long serial = tfv->file->f_dentry->d_inode->i_talpa_cache_seqno;
+	long seqno;
+
+	mutex_lock(&talpa_cache_seqno_lock);
+	seqno  = talpa_cache_seqno;
+	mutex_unlock(&talpa_cache_seqno_lock);
+
+	BUG_ON(serial > seqno);
+	BUG_ON(serial < -seqno);
+	/* If serial == seqno we already approved this inode.
+	   Opposite rules are valid for negative cachings. */
+	if (serial == seqno) {
+		ret = TALPA_ALLOW;
+		talpa_cache_hits++;
+	} else if (serial == -seqno) {
+		ret = TALPA_DENY;
+		talpa_cache_hits++;
+	} else {
+		talpa_cache_misses++;
+	}
+
+	return ret;
+}
+
+static inline int writable_elsewhere(struct inode *inode, unsigned long flags)
+{
+	if (atomic_read(&inode->i_writecount) <= 0)
+		return 0;
+
+	if (atomic_read(&inode->i_writecount) == 1 && flags&(O_WRONLY|O_RDWR|O_APPEND|O_CREAT|O_TRUNC))
+		return 0;
+
+	return 1;
+}
+
+enum talpa_action talpa_cache_allow(struct talpa_file_vetting *tfv)
+{
+	struct inode *inode = tfv->file->f_dentry->d_inode;
+
+	/* Only block device backed filesystem are cached. */
+	if (inode->i_sb->s_type->fs_flags & FS_REQUIRES_DEV) {
+		spin_lock(&inode->i_lock);
+		/* Cache inode on authoritative allow if it is
+		   not writable elsewhere, we could cache here,
+		   but we really don't know if we raced between this
+		   scan and the last write operation.... */
+		if (tfv->authoritative && !writable_elsewhere(inode, tfv->flags))
+			inode->i_talpa_cache_seqno = tfv->cache_seqno;
+		spin_unlock(&inode->i_lock);
+	}
+
+	return TALPA_NEXT;
+}
+
+enum talpa_action talpa_cache_deny(struct talpa_file_vetting *tfv)
+{
+	struct inode *inode = tfv->file->f_dentry->d_inode;
+
+	/* Cache inode on authoritative deny if it is
+	   not writable elsewhere. */
+	spin_lock(&inode->i_lock);
+	if (tfv->authoritative && !writable_elsewhere(inode, tfv->flags))
+		inode->i_talpa_cache_seqno = -tfv->cache_seqno;
+	spin_unlock(&inode->i_lock);
+
+	return TALPA_NEXT;
+}
+
+ssize_t talpa_increment_seqno(struct talpa_configuration *cfg, char *buf, size_t len)
+{
+	int ret = len;
+
+	mutex_lock(&talpa_cache_seqno_lock);
+	talpa_cache_seqno++;
+	if (talpa_cache_seqno < 0) {
+		talpa_cache_seqno = LONG_MAX;
+		ret = -ERANGE;
+	}
+	mutex_unlock(&talpa_cache_seqno_lock);
+
+	return ret;
+}
+
+static struct talpa_configuration talpa_cache_cfg[] = {
+	{
+		.name = "enabled",
+		.mode = S_IRUSR|S_IWUSR|S_IRGRP,
+		.data = &talpa_cache_enbl,
+		.get = talpa_generic_get_ulong,
+		.set = talpa_generic_set_ulong,
+	},
+	{
+		.name = "seqno",
+		.mode = S_IRUSR,
+		.data = &talpa_cache_seqno,
+		.get = talpa_generic_get_long,
+	},
+	{
+		.name = "increment_seqno",
+		.mode = S_IWUSR,
+		.set = talpa_increment_seqno,
+	},
+	{
+		.name = "hits",
+		.mode = S_IRUSR|S_IRGRP,
+		.data = &talpa_cache_hits,
+		.get = talpa_generic_get_ulong,
+	},
+	{
+		.name = "misses",
+		.mode = S_IRUSR|S_IRGRP,
+		.data = &talpa_cache_misses,
+		.get = talpa_generic_get_ulong,
+	},
+	{
+	},
+};
+
+static __init int talpa_cache_init(void)
+{
+	struct dentry *dentry = 0;
+
+	mutex_init(&talpa_cache_seqno_lock);
+
+	dentry = talpa_register_configuration("cache", talpa_cache_cfg);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+
+	return 0;
+}
+
+__initcall(talpa_cache_init);
diff --git a/security/talpa/talpa_cache.h b/security/talpa/talpa_cache.h
new file mode 100644
index 0000000..aa23dd8
--- /dev/null
+++ b/security/talpa/talpa_cache.h
@@ -0,0 +1,22 @@
+#include "talpa.h"
+
+#ifdef CONFIG_TALPA_CACHE
+extern enum talpa_action talpa_cache_deny(struct talpa_file_vetting *tfv);
+extern enum talpa_action talpa_cache_allow(struct talpa_file_vetting *tfv);
+extern enum talpa_action talpa_cache_examine(struct talpa_file_vetting *tfv);
+#else /* CONFIG_TALPA_CACHE */
+static inline enum talpa_action talpa_cache_deny(struct talpa_file_vetting *tfv)
+{
+	return TALPA_NEXT;
+}
+
+static inline enum talpa_action talpa_cache_allow(struct talpa_file_vetting *tfv)
+{
+	return TALPA_NEXT;
+}
+
+static inline enum talpa_action talpa_cache_examine(struct talpa_file_vetting *tfv)
+{
+	return TALPA_NEXT;
+}
+#endif /* CONFIG_TALPA_CACHE */
diff --git a/security/talpa/talpa_common.c b/security/talpa/talpa_common.c
index 2dd3eb1..7ee4254 100644
--- a/security/talpa/talpa_common.c
+++ b/security/talpa/talpa_common.c
@@ -40,6 +40,8 @@ ssize_t talpa_generic_set_ulong(struct talpa_configuration *cfg, char *buf, size
 	if (strict_strtoul(buf, 10, (unsigned long *)cfg->data))
 		return -EINVAL;
 
+	ret = talpa_increment_seqno(cfg, buf, len);
+
 	return ret;
 
 }
diff --git a/security/talpa/talpa_deny_calls.h b/security/talpa/talpa_deny_calls.h
index 011d5c2..e3b404e 100644
--- a/security/talpa/talpa_deny_calls.h
+++ b/security/talpa/talpa_deny_calls.h
@@ -1,5 +1,11 @@
 #include "talpa.h"
+#include "talpa_cache.h"
 
 static inline void talpa_deny_calls(struct talpa_file_vetting *tfv)
 {
+	enum talpa_action ret;
+
+#ifdef CONFIG_TALPA_CACHE
+	ret = talpa_cache_deny(tfv);
+#endif /* CONFIG_TALPA_CACHE */
 }
diff --git a/security/talpa/talpa_evaluation_calls.h b/security/talpa/talpa_evaluation_calls.h
index 367a149..24d0955 100644
--- a/security/talpa/talpa_evaluation_calls.h
+++ b/security/talpa/talpa_evaluation_calls.h
@@ -1,6 +1,30 @@
+#include <linux/mutex.h>
+
 #include "talpa.h"
+#include "talpa_cache.h"
 
 static inline int talpa_evaluation_calls(struct talpa_file_vetting *tfv)
 {
-	return TALPA_NEXT;
+	enum talpa_action ret = TALPA_NEXT;
+
+#ifdef CONFIG_TALPA_CACHE
+	/*
+	 * collect the seqno number before decision is made.  Thus later during
+	 * allow/deny handling we won't possibly set a seqno number newer than
+	 * the object in question was analyzed with.  We might set one too low,
+	 * but that will just be a cache miss.
+	 */
+	extern struct mutex talpa_cache_seqno_lock;
+	extern long talpa_cache_seqno;
+
+	mutex_lock(&talpa_cache_seqno_lock);
+	tfv->cache_seqno = talpa_cache_seqno;
+	mutex_unlock(&talpa_cache_seqno_lock);
+
+	ret = talpa_cache_examine(tfv);
+	if (ret != TALPA_NEXT)
+		return ret;
+#endif /* CONFIG_TALPA_CACHE */
+
+	return ret;
 }
-- 
1.5.2.1

