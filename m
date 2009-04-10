Return-Path: <linux-kernel-owner+w=401wt.eu-S938606AbZDJH05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938606AbZDJH05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 03:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938125AbZDJHS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 03:18:27 -0400
Received: from mfbichi11.ns.itscom.net ([219.110.2.189]:61516 "EHLO
	mfbichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938100AbZDJHSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 03:18:07 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, linux-fsdevel@vger.kernel.org,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #5 02/29] aufs module global
Date: Fri, 10 Apr 2009 16:02:16 +0900
Message-Id: <1239346963-30953-3-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

initial commit
common header file
module initialization and module global vars

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/Kconfig  |   91 ++++++++++++++++++++++++++++++
 fs/aufs/Makefile |   20 +++++++
 fs/aufs/aufs.h   |   44 ++++++++++++++
 fs/aufs/module.c |  164 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/aufs/module.h |   66 ++++++++++++++++++++++
 fs/aufs/rwsem.h  |   52 +++++++++++++++++
 fs/aufs/spl.h    |   47 +++++++++++++++
 7 files changed, 484 insertions(+), 0 deletions(-)
 create mode 100644 fs/aufs/Kconfig
 create mode 100644 fs/aufs/Makefile
 create mode 100644 fs/aufs/aufs.h
 create mode 100644 fs/aufs/module.c
 create mode 100644 fs/aufs/module.h
 create mode 100644 fs/aufs/rwsem.h
 create mode 100644 fs/aufs/spl.h

diff --git a/fs/aufs/Kconfig b/fs/aufs/Kconfig
new file mode 100644
index 0000000..bffbec5
--- /dev/null
+++ b/fs/aufs/Kconfig
@@ -0,0 +1,91 @@
+config AUFS_FS
+	bool "Aufs (Advanced multi layered unification filesystem) support"
+	depends on EXPERIMENTAL
+	help
+	Aufs is a stackable unification filesystem such as Unionfs,
+	which unifies several directories and provides a merged single
+	directory.
+	In the early days, aufs was entirely re-designed and
+	re-implemented Unionfs Version 1.x series. Introducing many
+	original ideas, approaches and improvements, it becomes totally
+	different from Unionfs while keeping the basic features.
+
+if AUFS_FS
+choice
+	prompt "Maximum number of branches"
+	default AUFS_BRANCH_MAX_127
+	help
+	Specifies the maximum number of branches (or member directories)
+	in a single aufs. The larger value consumes more system
+	resources and has a minor impact to performance.
+config AUFS_BRANCH_MAX_127
+	bool "127"
+	help
+	Specifies the maximum number of branches (or member directories)
+	in a single aufs. The larger value consumes more system
+	resources and has a minor impact to performance.
+config AUFS_BRANCH_MAX_511
+	bool "511"
+	help
+	Specifies the maximum number of branches (or member directories)
+	in a single aufs. The larger value consumes more system
+	resources and has a minor impact to performance.
+config AUFS_BRANCH_MAX_1023
+	bool "1023"
+	help
+	Specifies the maximum number of branches (or member directories)
+	in a single aufs. The larger value consumes more system
+	resources and has a minor impact to performance.
+config AUFS_BRANCH_MAX_32767
+	bool "32767"
+	help
+	Specifies the maximum number of branches (or member directories)
+	in a single aufs. The larger value consumes more system
+	resources and has a minor impact to performance.
+endchoice
+
+config AUFS_HINOTIFY
+	bool "Use inotify to detect actions on a branch"
+	depends on INOTIFY
+	help
+	If you want to modify files on branches directly, eg. bypassing aufs,
+	and want aufs to detect the changes of them fully, then enable this
+	option and use 'udba=inotify' mount option.
+	It will have a negative impact to the performance.
+	See detail in aufs.5.
+
+config AUFS_BR_RAMFS
+	bool "Ramfs (initramfs/rootfs) as an aufs branch"
+	help
+	If you want to use ramfs as an aufs branch fs, then enable this
+	option. Generally tmpfs is recommended.
+	Aufs prohibited them to be a branch fs by default, because
+	initramfs becomes unusable after switch_root or something
+	generally. If you sets initramfs as an aufs branch and boot your
+	system by switch_root, you will meet a problem easily since the
+	files in initramfs may be inaccessible.
+	Unless you are going to use ramfs as an aufs branch fs without
+	switch_root or something, leave it N.
+
+config AUFS_DEBUG
+	bool "Debug aufs"
+	help
+	Enable this to compile aufs internal debug code.
+	It will have a negative impact to the performance.
+
+config AUFS_MAGIC_SYSRQ
+	bool
+	depends on AUFS_DEBUG && MAGIC_SYSRQ
+	default y
+	help
+	Automatic configuration for internal use.
+	When aufs supports Magic SysRq, enabled automatically.
+
+config AUFS_BDEV_LOOP
+	bool
+	depends on BLK_DEV_LOOP
+	default y
+	help
+	Automatic configuration for internal use.
+	Convert =[ym] into =y.
+endif
diff --git a/fs/aufs/Makefile b/fs/aufs/Makefile
new file mode 100644
index 0000000..52d8498
--- /dev/null
+++ b/fs/aufs/Makefile
@@ -0,0 +1,20 @@
+
+include ${srctree}/${src}/magic.mk
+
+obj-$(CONFIG_AUFS_FS) += aufs.o
+aufs-y := module.o sbinfo.o super.o branch.o xino.o sysaufs.o opts.o \
+	wkq.o vfsub.o dcsub.o \
+	cpup.o whout.o plink.o wbr_policy.o \
+	dinfo.o dentry.o \
+	finfo.o file.o f_op.o \
+	dir.o vdir.o \
+	iinfo.o inode.o i_op.o i_op_add.o i_op_del.o i_op_ren.o \
+	ioctl.o
+
+# all are boolean
+aufs-$(CONFIG_SYSFS) += sysfs.o
+aufs-$(CONFIG_DEBUG_FS) += dbgaufs.o
+aufs-$(CONFIG_AUFS_BDEV_LOOP) += loop.o
+aufs-$(CONFIG_AUFS_HINOTIFY) += hinotify.o
+aufs-$(CONFIG_AUFS_DEBUG) += debug.o
+aufs-$(CONFIG_AUFS_MAGIC_SYSRQ) += sysrq.o
diff --git a/fs/aufs/aufs.h b/fs/aufs/aufs.h
new file mode 100644
index 0000000..132e84e
--- /dev/null
+++ b/fs/aufs/aufs.h
@@ -0,0 +1,44 @@
+/*
+ * Copyright (C) 2005-2009 Junjiro R. Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
+ * all header files
+ */
+
+#ifndef __AUFS_H__
+#define __AUFS_H__
+
+#ifdef __KERNEL__
+
+#include <linux/bug.h>
+
+#include "debug.h"
+
+#include "branch.h"
+#include "cpup.h"
+#include "dcsub.h"
+#include "dbgaufs.h"
+#include "dentry.h"
+#include "dir.h"
+#include "file.h"
+#include "fstype.h"
+#include "inode.h"
+#include "loop.h"
+#include "module.h"
+#include "opts.h"
+#include "rwsem.h"
+#include "spl.h"
+#include "super.h"
+#include "sysaufs.h"
+#include "vfsub.h"
+#include "whout.h"
+#include "wkq.h"
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_H__ */
diff --git a/fs/aufs/module.c b/fs/aufs/module.c
new file mode 100644
index 0000000..c2219d3
--- /dev/null
+++ b/fs/aufs/module.c
@@ -0,0 +1,164 @@
+/*
+ * Copyright (C) 2005-2009 Junjiro R. Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
+ * module global variables and operations
+ */
+
+#include <linux/module.h>
+#include <linux/seq_file.h>
+#include "aufs.h"
+
+void *au_kzrealloc(void *p, unsigned int nused, unsigned int new_sz, gfp_t gfp)
+{
+	if (new_sz <= nused)
+		return p;
+
+	p = krealloc(p, new_sz, gfp);
+	if (p)
+		memset(p + nused, 0, new_sz - nused);
+	return p;
+}
+
+/* ---------------------------------------------------------------------- */
+
+/*
+ * aufs caches
+ */
+struct kmem_cache *au_cachep[AuCache_Last];
+static int __init au_cache_init(void)
+{
+	au_cachep[AuCache_DINFO] = AuCache(au_dinfo);
+	if (au_cachep[AuCache_DINFO])
+		au_cachep[AuCache_ICNTNR] = AuCache(au_icntnr);
+	if (au_cachep[AuCache_ICNTNR])
+		au_cachep[AuCache_FINFO] = AuCache(au_finfo);
+	if (au_cachep[AuCache_FINFO])
+		au_cachep[AuCache_VDIR] = AuCache(au_vdir);
+	if (au_cachep[AuCache_VDIR])
+		au_cachep[AuCache_DEHSTR] = AuCache(au_vdir_dehstr);
+	if (au_cachep[AuCache_DEHSTR])
+		return 0;
+
+	return -ENOMEM;
+}
+
+static void au_cache_fin(void)
+{
+	int i;
+	for (i = 0; i < AuCache_Last; i++)
+		if (au_cachep[i]) {
+			kmem_cache_destroy(au_cachep[i]);
+			au_cachep[i] = NULL;
+		}
+}
+
+/* ---------------------------------------------------------------------- */
+
+int au_dir_roflags;
+
+/*
+ * functions for module interface.
+ */
+MODULE_LICENSE("GPL");
+/* MODULE_LICENSE("GPL v2"); */
+MODULE_AUTHOR("Junjiro R. Okajima");
+MODULE_DESCRIPTION(AUFS_NAME
+	" -- Advanced multi layered unification filesystem");
+MODULE_VERSION(AUFS_VERSION);
+
+/* it should be 'byte', but param_set_byte() prints it by "%c" */
+short aufs_nwkq = AUFS_NWKQ_DEF;
+MODULE_PARM_DESC(nwkq, "the number of workqueue thread, " AUFS_WKQ_NAME);
+module_param_named(nwkq, aufs_nwkq, short, S_IRUGO);
+
+/* this module parameter has no meaning when SYSFS is disabled */
+int sysaufs_brs = 1;
+MODULE_PARM_DESC(brs, "use <sysfs>/fs/aufs/si_*/brN");
+module_param_named(brs, sysaufs_brs, int, S_IRUGO);
+
+/* ---------------------------------------------------------------------- */
+
+static char au_esc_chars[0x20 + 3]; /* 0x01-0x20, backslash, del, and NULL */
+
+int au_seq_path(struct seq_file *seq, struct path *path)
+{
+	return seq_path(seq, path, au_esc_chars);
+}
+
+/* ---------------------------------------------------------------------- */
+
+static int __init aufs_init(void)
+{
+	int err, i;
+	char *p;
+
+	p = au_esc_chars;
+	for (i = 1; i <= ' '; i++)
+		*p++ = i;
+	*p++ = '\\';
+	*p++ = '\x7f';
+	*p = 0;
+
+	au_dir_roflags = au_file_roflags(O_DIRECTORY | O_LARGEFILE);
+
+	sysaufs_brs_init();
+	au_debug_init();
+
+	err = -EINVAL;
+	if (unlikely(aufs_nwkq <= 0))
+		goto out;
+
+	err = sysaufs_init();
+	if (unlikely(err))
+		goto out;
+	err = au_wkq_init();
+	if (unlikely(err))
+		goto out_sysaufs;
+	err = au_hinotify_init();
+	if (unlikely(err))
+		goto out_wkq;
+	err = au_sysrq_init();
+	if (unlikely(err))
+		goto out_hin;
+	err = au_cache_init();
+	if (unlikely(err))
+		goto out_sysrq;
+	err = register_filesystem(&aufs_fs_type);
+	if (unlikely(err))
+		goto out_cache;
+	pr_info(AUFS_NAME " " AUFS_VERSION "\n");
+	goto out; /* success */
+
+ out_cache:
+	au_cache_fin();
+ out_sysrq:
+	au_sysrq_fin();
+ out_hin:
+	au_hinotify_fin();
+ out_wkq:
+	au_wkq_fin();
+ out_sysaufs:
+	sysaufs_fin();
+ out:
+	return err;
+}
+
+static void __exit aufs_exit(void)
+{
+	unregister_filesystem(&aufs_fs_type);
+	au_cache_fin();
+	au_sysrq_fin();
+	au_hinotify_fin();
+	au_wkq_fin();
+	sysaufs_fin();
+}
+
+module_init(aufs_init);
+module_exit(aufs_exit);
diff --git a/fs/aufs/module.h b/fs/aufs/module.h
new file mode 100644
index 0000000..85e397a
--- /dev/null
+++ b/fs/aufs/module.h
@@ -0,0 +1,66 @@
+/*
+ * Copyright (C) 2005-2009 Junjiro R. Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
+ * module initialization and module-global
+ */
+
+#ifndef __AUFS_MODULE_H__
+#define __AUFS_MODULE_H__
+
+#ifdef __KERNEL__
+
+#include <linux/slab.h>
+
+/* module parameters */
+extern short aufs_nwkq;
+extern int sysaufs_brs;
+
+/* ---------------------------------------------------------------------- */
+
+extern int au_dir_roflags;
+
+void *au_kzrealloc(void *p, unsigned int nused, unsigned int new_sz, gfp_t gfp);
+int au_seq_path(struct seq_file *seq, struct path *path);
+
+/* ---------------------------------------------------------------------- */
+
+/* kmem cache */
+enum {
+	AuCache_DINFO,
+	AuCache_ICNTNR,
+	AuCache_FINFO,
+	AuCache_VDIR,
+	AuCache_DEHSTR,
+#ifdef CONFIG_AUFS_HINOTIFY
+	AuCache_HINOTIFY,
+#endif
+	AuCache_Last
+};
+
+#define AuCache(type)	KMEM_CACHE(type, SLAB_RECLAIM_ACCOUNT)
+
+extern struct kmem_cache *au_cachep[];
+
+#define AuCacheFuncs(name, index) \
+static inline void *au_cache_alloc_##name(void) \
+{ return kmem_cache_alloc(au_cachep[AuCache_##index], GFP_NOFS); } \
+static inline void au_cache_free_##name(void *p) \
+{ kmem_cache_free(au_cachep[AuCache_##index], p); }
+
+AuCacheFuncs(dinfo, DINFO);
+AuCacheFuncs(icntnr, ICNTNR);
+AuCacheFuncs(finfo, FINFO);
+AuCacheFuncs(vdir, VDIR);
+AuCacheFuncs(dehstr, DEHSTR);
+
+/*  ---------------------------------------------------------------------- */
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_MODULE_H__ */
diff --git a/fs/aufs/rwsem.h b/fs/aufs/rwsem.h
new file mode 100644
index 0000000..d569243
--- /dev/null
+++ b/fs/aufs/rwsem.h
@@ -0,0 +1,52 @@
+/*
+ * Copyright (C) 2005-2009 Junjiro R. Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
+ * simple read-write semaphore wrappers
+ */
+
+#ifndef __AUFS_RWSEM_H__
+#define __AUFS_RWSEM_H__
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+
+#define au_rwsem_destroy(rw)	AuDebugOn(rwsem_is_locked(rw))
+#define AuRwMustNoWaiters(rw)	AuDebugOn(!list_empty(&(rw)->wait_list))
+
+#define AuSimpleLockRwsemFuncs(prefix, param, rwsem) \
+static inline void prefix##_read_lock(param) \
+{ down_read(rwsem); } \
+static inline void prefix##_write_lock(param) \
+{ down_write(rwsem); } \
+static inline int prefix##_read_trylock(param) \
+{ return down_read_trylock(rwsem); } \
+static inline int prefix##_write_trylock(param) \
+{ return down_write_trylock(rwsem); }
+/* why is not _nested version defined */
+/* static inline void prefix##_read_trylock_nested(param, lsc)
+{ down_write_trylock_nested(rwsem, lsc)); }
+static inline void prefix##_write_trylock_nestd(param, lsc)
+{ down_write_trylock_nested(rwsem, lsc); } */
+
+#define AuSimpleUnlockRwsemFuncs(prefix, param, rwsem) \
+static inline void prefix##_read_unlock(param) \
+{ up_read(rwsem); } \
+static inline void prefix##_write_unlock(param) \
+{ up_write(rwsem); } \
+static inline void prefix##_downgrade_lock(param) \
+{ downgrade_write(rwsem); }
+
+#define AuSimpleRwsemFuncs(prefix, param, rwsem) \
+	AuSimpleLockRwsemFuncs(prefix, param, rwsem) \
+	AuSimpleUnlockRwsemFuncs(prefix, param, rwsem)
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_RWSEM_H__ */
diff --git a/fs/aufs/spl.h b/fs/aufs/spl.h
new file mode 100644
index 0000000..89ea7a2
--- /dev/null
+++ b/fs/aufs/spl.h
@@ -0,0 +1,47 @@
+/*
+ * Copyright (C) 2005-2009 Junjiro R. Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
+ * simple list protected by a spinlock
+ */
+
+#ifndef __AUFS_SPL_H__
+#define __AUFS_SPL_H__
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+
+struct au_splhead {
+	spinlock_t		spin;
+	struct list_head	head;
+};
+
+static inline void au_spl_init(struct au_splhead *spl)
+{
+	spin_lock_init(&spl->spin);
+	INIT_LIST_HEAD(&spl->head);
+}
+
+static inline void au_spl_add(struct list_head *list, struct au_splhead *spl)
+{
+	spin_lock(&spl->spin);
+	list_add(list, &spl->head);
+	spin_unlock(&spl->spin);
+}
+
+static inline void au_spl_del(struct list_head *list, struct au_splhead *spl)
+{
+	spin_lock(&spl->spin);
+	list_del(list);
+	spin_unlock(&spl->spin);
+}
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_SPL_H__ */
-- 
1.6.1.284.g5dc13

