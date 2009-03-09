Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbZCIWrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbZCIWrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 18:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbZCIWlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 18:41:55 -0400
Received: from cobra.newdream.net ([66.33.216.30]:50092 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbZCIWk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 18:40:28 -0400
From: Sage Weil <sage@newdream.net>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 18/20] ceph: debugging
Date: Mon,  9 Mar 2009 15:40:37 -0700
Message-Id: <1236638439-6753-19-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1236638439-6753-18-git-send-email-sage@newdream.net>
References: <1236638439-6753-1-git-send-email-sage@newdream.net>
 <1236638439-6753-2-git-send-email-sage@newdream.net>
 <1236638439-6753-3-git-send-email-sage@newdream.net>
 <1236638439-6753-4-git-send-email-sage@newdream.net>
 <1236638439-6753-5-git-send-email-sage@newdream.net>
 <1236638439-6753-6-git-send-email-sage@newdream.net>
 <1236638439-6753-7-git-send-email-sage@newdream.net>
 <1236638439-6753-8-git-send-email-sage@newdream.net>
 <1236638439-6753-9-git-send-email-sage@newdream.net>
 <1236638439-6753-10-git-send-email-sage@newdream.net>
 <1236638439-6753-11-git-send-email-sage@newdream.net>
 <1236638439-6753-12-git-send-email-sage@newdream.net>
 <1236638439-6753-13-git-send-email-sage@newdream.net>
 <1236638439-6753-14-git-send-email-sage@newdream.net>
 <1236638439-6753-15-git-send-email-sage@newdream.net>
 <1236638439-6753-16-git-send-email-sage@newdream.net>
 <1236638439-6753-17-git-send-email-sage@newdream.net>
 <1236638439-6753-18-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some debugging infrastructure, including the ability to adjust the
level of debug output on a per-file basis.  A memory leak detection
tool can also be enabled via .config.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/bookkeeper.c |  117 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/bookkeeper.h |   19 ++++++++
 fs/ceph/ceph_debug.h |  103 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 239 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/bookkeeper.c
 create mode 100644 fs/ceph/bookkeeper.h
 create mode 100644 fs/ceph/ceph_debug.h

diff --git a/fs/ceph/bookkeeper.c b/fs/ceph/bookkeeper.c
new file mode 100644
index 0000000..5f05509
--- /dev/null
+++ b/fs/ceph/bookkeeper.c
@@ -0,0 +1,117 @@
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/kallsyms.h>
+
+#define CEPH_OVERRIDE_BOOKKEEPER /* avoid kmalloc/kfree recursion */
+
+#define CEPH_BK_MAGIC 0x140985AC
+
+#include "ceph_debug.h"
+
+int ceph_debug_tools __read_mostly = -1;
+#define DOUT_VAR ceph_debug_tools
+#define DOUT_MASK DOUT_MASK_TOOLS
+#include "super.h"
+
+static struct list_head _bk_allocs;
+
+static DEFINE_SPINLOCK(_bk_lock);
+
+static size_t _total_alloc;
+static size_t _total_free;
+
+struct alloc_data {
+	u32 prefix_magic;
+	struct list_head node;
+	size_t size;
+	char *fname;
+	int line;
+	u32 suffix_magic;
+};
+
+void *ceph_kmalloc(char *fname, int line, size_t size, gfp_t flags)
+{
+	struct alloc_data *p = kmalloc(size+sizeof(struct alloc_data), flags);
+
+	if (!p)
+		return NULL;
+
+	p->prefix_magic = CEPH_BK_MAGIC;
+	p->size = size;
+	p->fname = fname;
+	p->line = line;
+	p->suffix_magic = CEPH_BK_MAGIC;
+
+	spin_lock(&_bk_lock);
+	_total_alloc += size;
+
+	list_add_tail(&p->node, &_bk_allocs);
+	spin_unlock(&_bk_lock);
+
+	return ((void *)p)+sizeof(struct alloc_data);
+}
+
+void ceph_kfree(void *ptr)
+{
+	struct alloc_data *p = (struct alloc_data *)(ptr -
+						     sizeof(struct alloc_data));
+	int overrun = 0;
+
+	if (!ptr)
+		return;
+
+	if (p->prefix_magic != CEPH_BK_MAGIC) {
+		derr(0, "ERROR: memory overrun (under)!\n");
+		overrun = 1;
+	}
+
+	if (p->suffix_magic != CEPH_BK_MAGIC) {
+		derr(0, "ERROR: Memory overrun (over)!\n");
+		overrun = 1;
+	}
+
+	if (overrun) {
+		derr(0, "Memory allocated at %s(%d): p=%p (%zu bytes)\n", p->fname,
+			p->line,
+			((void *)p)+sizeof(struct alloc_data),
+			p->size);
+	}
+
+	BUG_ON(overrun);
+
+	spin_lock(&_bk_lock);
+	_total_free += p->size;
+	list_del(&p->node);
+	spin_unlock(&_bk_lock);
+
+	kfree(p);
+
+	return;
+}
+
+void ceph_bookkeeper_init(void)
+{
+	dout(10, "bookkeeper: start\n");
+	INIT_LIST_HEAD(&_bk_allocs);
+}
+
+void ceph_bookkeeper_finalize(void)
+{
+	struct list_head *p;
+	struct alloc_data *entry;
+
+	dout(1, "bookkeeper: total bytes alloc: %zu\n", _total_alloc);
+	dout(1, "bookkeeper: total bytes free: %zu\n", _total_free);
+
+	if (_total_alloc != _total_free) {
+		list_for_each(p, &_bk_allocs) {
+			entry = list_entry(p, struct alloc_data, node);
+			dout(1, "%s(%d): p=%p (%zu bytes)\n", entry->fname,
+			     entry->line,
+			     ((void *)entry)+sizeof(struct alloc_data),
+			     entry->size);
+		}
+	} else {
+		dout(1, "No leaks found! Yay!\n");
+	}
+}
diff --git a/fs/ceph/bookkeeper.h b/fs/ceph/bookkeeper.h
new file mode 100644
index 0000000..e7124f1
--- /dev/null
+++ b/fs/ceph/bookkeeper.h
@@ -0,0 +1,19 @@
+#ifndef _FS_CEPH_BOOKKEEPER_H
+#define _FS_CEPH_BOOKKEEPER_H
+
+#ifdef CONFIG_CEPH_BOOKKEEPER
+extern void ceph_bookkeeper_init(void);
+extern void ceph_bookkeeper_finalize(void);
+extern void *ceph_kmalloc(char *fname, int line, size_t size, gfp_t flags);
+extern void ceph_kfree(void *ptr);
+
+#ifndef CEPH_OVERRIDE_BOOKKEEPER
+#define kmalloc(size, flags)	ceph_kmalloc(__FILE__, __LINE__, size, flags)
+#define kzalloc(size, flags)	ceph_kmalloc(__FILE__, __LINE__, size, \
+					     flags | __GFP_ZERO)
+#define kfree	ceph_kfree
+#endif
+
+#endif
+
+#endif
diff --git a/fs/ceph/ceph_debug.h b/fs/ceph/ceph_debug.h
new file mode 100644
index 0000000..e06ec3d
--- /dev/null
+++ b/fs/ceph/ceph_debug.h
@@ -0,0 +1,103 @@
+#ifndef _FS_CEPH_DEBUG_H
+#define _FS_CEPH_DEBUG_H
+
+#include <linux/string.h>
+
+#include "bookkeeper.h"
+
+extern int ceph_debug __read_mostly;         /* debug level. */
+extern int ceph_debug_console __read_mostly; /* send debug output to console? */
+extern int ceph_debug_mask __read_mostly;
+
+/*
+ * different debug levels for different modules.  These default to -1.
+ * If they are >= 0, then they override the global ceph_debug value.
+ */
+extern int ceph_debug_addr __read_mostly;
+extern int ceph_debug_caps __read_mostly;
+extern int ceph_debug_dir __read_mostly;
+extern int ceph_debug_export __read_mostly;
+extern int ceph_debug_file __read_mostly;
+extern int ceph_debug_inode __read_mostly;
+extern int ceph_debug_ioctl __read_mostly;
+extern int ceph_debug_mdsc __read_mostly;
+extern int ceph_debug_mdsmap __read_mostly;
+extern int ceph_debug_msgr __read_mostly;
+extern int ceph_debug_mon __read_mostly;
+extern int ceph_debug_osdc __read_mostly;
+extern int ceph_debug_osdmap __read_mostly;
+extern int ceph_debug_snap __read_mostly;
+extern int ceph_debug_super __read_mostly;
+extern int ceph_debug_protocol __read_mostly;
+extern int ceph_debug_proc __read_mostly;
+extern int ceph_debug_tools __read_mostly;
+
+#define DOUT_MASK_ADDR		0x00000001
+#define DOUT_MASK_CAPS		0x00000002
+#define DOUT_MASK_DIR		0x00000004
+#define DOUT_MASK_EXPORT	0x00000008
+#define DOUT_MASK_FILE		0x00000010
+#define DOUT_MASK_INODE		0x00000020
+#define DOUT_MASK_IOCTL		0x00000040
+#define DOUT_MASK_MDSC		0x00000080
+#define DOUT_MASK_MDSMAP	0x00000100
+#define DOUT_MASK_MSGR		0x00000200
+#define DOUT_MASK_MON		0x00000400
+#define DOUT_MASK_OSDC		0x00000800
+#define DOUT_MASK_OSDMAP	0x00001000
+#define DOUT_MASK_SNAP		0x00002000
+#define DOUT_MASK_SUPER		0x00004000
+#define DOUT_MASK_PROTOCOL	0x00008000
+#define DOUT_MASK_PROC		0x00010000
+#define DOUT_MASK_TOOLS		0x00020000
+
+#define DOUT_UNMASKABLE	0x80000000
+
+#define _STRINGIFY(x) #x
+#define STRINGIFY(x) _STRINGIFY(x)
+
+#define FMT_PREFIX "%-30.30s: "
+#define FMT_SUFFIX "%s"
+#define LOG_ARGS __FILE__ ":" STRINGIFY(__LINE__)
+#define TRAIL_PARAM ""
+
+#define LOG_LINE FMT_PREFIX fmt, LOG_ARGS, args
+
+#define dout_flag(x, mask, fmt, args...) do {				\
+		if (((ceph_debug_mask | DOUT_UNMASKABLE) & mask) &&	\
+		    ((DOUT_VAR >= 0 && x <= DOUT_VAR) ||		\
+		     (DOUT_VAR < 0 && x <= ceph_debug))) {		\
+			if (ceph_debug_console)				\
+				printk(KERN_ERR FMT_PREFIX fmt, LOG_ARGS, args);	\
+			else						\
+				printk(KERN_DEBUG FMT_PREFIX fmt, LOG_ARGS, args);	\
+		}							\
+	} while (0)
+
+#define _dout(x, fmt, args...) dout_flag(x, DOUT_MASK, fmt FMT_SUFFIX, args)
+
+#define _derr(x, fmt, args...) do {					\
+		printk(KERN_ERR FMT_PREFIX fmt FMT_SUFFIX, LOG_ARGS, args);	\
+	} while (0)
+
+#define dout(x, args...) _dout(x, args, TRAIL_PARAM)
+#define derr(x, args...) _derr(x, args, TRAIL_PARAM)
+
+/* dcache d_count debugging */
+#if 0
+# define dput(dentry)				       \
+	do {					       \
+		dout(20, "dput %p %d -> %d\n", dentry, \
+		     atomic_read(&dentry->d_count),    \
+		     atomic_read(&dentry->d_count)-1); \
+		dput(dentry);			       \
+	} while (0)
+# define d_drop(dentry)				       \
+	do {					       \
+		dout(20, "d_drop %p\n", dentry);       \
+		d_drop(dentry);			       \
+	} while (0)
+#endif
+
+
+#endif
-- 
1.5.6.5

