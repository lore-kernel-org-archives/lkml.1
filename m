Return-Path: <linux-kernel-owner+w=401wt.eu-S934683AbYEUDsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934683AbYEUDsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 23:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934348AbYEUDex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 23:34:53 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:44138 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765463AbYEUDdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 23:33:08 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [AUFS PATCH v2.6.26-rc2-mm1 04/39] aufs module global
Date: Wed, 21 May 2008 12:22:34 +0900
Message-Id: <1211340189-11813-5-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.5.5.1.308.g1fbb5.dirty
In-Reply-To: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

initial commit
main header file
module initialization and module global vars

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/aufs.h   |   52 ++++++++++++++++++
 fs/aufs/module.c |  153 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/aufs/module.h |   72 +++++++++++++++++++++++++
 3 files changed, 277 insertions(+), 0 deletions(-)
 create mode 100644 fs/aufs/aufs.h
 create mode 100644 fs/aufs/module.c
 create mode 100644 fs/aufs/module.h

diff --git a/fs/aufs/aufs.h b/fs/aufs/aufs.h
new file mode 100644
index 0000000..fbca615
--- /dev/null
+++ b/fs/aufs/aufs.h
@@ -0,0 +1,52 @@
+/*
+ * Copyright (C) 2005-2008 Junjiro Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+/*
+ * main header files
+ */
+
+#ifndef __AUFS_H__
+#define __AUFS_H__
+
+#ifdef __KERNEL__
+
+#include <linux/version.h>
+
+#include "debug.h"
+
+#include "branch.h"
+#include "cpup.h"
+#include "dcsub.h"
+#include "dentry.h"
+#include "dir.h"
+#include "file.h"
+#include "hinode.h"
+#include "inode.h"
+#include "misc.h"
+#include "module.h"
+#include "opts.h"
+#include "super.h"
+#include "sysaufs.h"
+#include "vfsub.h"
+#include "whout.h"
+#include "wkq.h"
+/* reserved for future use */
+/* #include "xattr.h" */
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_H__ */
diff --git a/fs/aufs/module.c b/fs/aufs/module.c
new file mode 100644
index 0000000..f5464f7
--- /dev/null
+++ b/fs/aufs/module.c
@@ -0,0 +1,153 @@
+/*
+ * Copyright (C) 2007 Junjiro Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+/*
+ * module global variables and operations
+ */
+
+#include <linux/module.h>
+#include "aufs.h"
+
+/* ---------------------------------------------------------------------- */
+
+/*
+ * aufs caches
+ */
+struct kmem_cache *au_cachep[AuCache_Last];
+static int __init create_cache(void)
+{
+	au_cachep[AuCache_DINFO] = AuCache(au_dinfo);
+	if (au_cachep[AuCache_DINFO])
+		au_cachep[AuCache_ICNTNR] = AuCache(aufs_icntnr);
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
+static void destroy_cache(void)
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
+char au_esc_chars[0x20 + 3]; /* 0x01-0x20, backslash, del, and NULL */
+int au_dir_roflags;
+
+/*
+ * functions for module interface.
+ */
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Junjiro Okajima");
+MODULE_DESCRIPTION(AUFS_NAME " -- Another unionfs");
+MODULE_VERSION(AUFS_VERSION);
+
+/* it should be 'byte', but param_set_byte() prints it by "%c" */
+short aufs_nwkq = AUFS_NWKQ_DEF;
+MODULE_PARM_DESC(nwkq, "the number of workqueue thread, " AUFS_WKQ_NAME);
+module_param_named(nwkq, aufs_nwkq, short, S_IRUGO);
+
+int sysaufs_brs;
+MODULE_PARM_DESC(brs, "use <sysfs>/fs/aufs/si_*/brN");
+module_param_named(brs, sysaufs_brs, int, S_IRUGO);
+
+/* ---------------------------------------------------------------------- */
+
+static int __init aufs_init(void)
+{
+	int err, i;
+	char *p;
+
+	au_debug_init();
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
+	err = au_inotify_init();
+	if (unlikely(err))
+		goto out_wkq;
+	err = au_sysrq_init();
+	if (unlikely(err))
+		goto out_inotify;
+
+	err = create_cache();
+	if (unlikely(err))
+		goto out_sysrq;
+
+	err = register_filesystem(&aufs_fs_type);
+	if (unlikely(err))
+		goto out_cache;
+	pr_info(AUFS_NAME " " AUFS_VERSION "\n");
+	return 0; /* success */
+
+ out_cache:
+	destroy_cache();
+ out_sysrq:
+	au_sysrq_fin();
+ out_inotify:
+	au_inotify_fin();
+ out_wkq:
+	au_wkq_fin();
+ out_sysaufs:
+	sysaufs_fin();
+ out:
+	AuTraceErr(err);
+	return err;
+}
+
+static void __exit aufs_exit(void)
+{
+	unregister_filesystem(&aufs_fs_type);
+	destroy_cache();
+
+	au_sysrq_fin();
+	au_inotify_fin();
+	au_wkq_fin();
+	sysaufs_fin();
+}
+
+module_init(aufs_init);
+module_exit(aufs_exit);
diff --git a/fs/aufs/module.h b/fs/aufs/module.h
new file mode 100644
index 0000000..fad7472
--- /dev/null
+++ b/fs/aufs/module.h
@@ -0,0 +1,72 @@
+/*
+ * Copyright (C) 2007-2008 Junjiro Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
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
+/* module parameters */
+extern short aufs_nwkq;
+extern int sysaufs_brs;
+
+/* ---------------------------------------------------------------------- */
+
+extern char au_esc_chars[];
+extern int au_dir_roflags;
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
+extern struct kmem_cache *au_cachep[];
+
+#define AuCacheArgs(type, sz)	(type), (sz), 0, SLAB_RECLAIM_ACCOUNT, NULL
+#define AuCacheX(type, extra) \
+	kmem_cache_create(AuCacheArgs(#type, sizeof(struct type) + extra))
+#define AuCache(type)		AuCacheX(type, 0)
+
+/* ---------------------------------------------------------------------- */
+
+#define AuCacheFuncs(name, index) \
+static inline void *au_cache_alloc_##name(void) \
+{ return kmem_cache_alloc(au_cachep[index], GFP_KERNEL); } \
+static inline void au_cache_free_##name(void *p) \
+{ kmem_cache_free(au_cachep[index], p); }
+
+AuCacheFuncs(dinfo, AuCache_DINFO);
+AuCacheFuncs(icntnr, AuCache_ICNTNR);
+AuCacheFuncs(finfo, AuCache_FINFO);
+AuCacheFuncs(vdir, AuCache_VDIR);
+AuCacheFuncs(dehstr, AuCache_DEHSTR);
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_MODULE_H__ */
-- 
1.5.5.1.308.g1fbb5.dirty

