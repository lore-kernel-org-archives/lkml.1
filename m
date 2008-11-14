Return-Path: <linux-kernel-owner+w=401wt.eu-S1756855AbYKNBak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbYKNBak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 20:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756629AbYKNBXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 20:23:39 -0500
Received: from cobra.newdream.net ([66.33.216.30]:38151 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032AbYKNBVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 20:21:31 -0500
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sage Weil <sage@newdream.net>
Subject: [PATCH 18/19] ceph: debugging
Date: Thu, 13 Nov 2008 16:56:17 -0800
Message-Id: <1226624178-3761-19-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1226624178-3761-18-git-send-email-sage@newdream.net>
References: <1226624178-3761-1-git-send-email-sage@newdream.net>
 <1226624178-3761-2-git-send-email-sage@newdream.net>
 <1226624178-3761-3-git-send-email-sage@newdream.net>
 <1226624178-3761-4-git-send-email-sage@newdream.net>
 <1226624178-3761-5-git-send-email-sage@newdream.net>
 <1226624178-3761-6-git-send-email-sage@newdream.net>
 <1226624178-3761-7-git-send-email-sage@newdream.net>
 <1226624178-3761-8-git-send-email-sage@newdream.net>
 <1226624178-3761-9-git-send-email-sage@newdream.net>
 <1226624178-3761-10-git-send-email-sage@newdream.net>
 <1226624178-3761-11-git-send-email-sage@newdream.net>
 <1226624178-3761-12-git-send-email-sage@newdream.net>
 <1226624178-3761-13-git-send-email-sage@newdream.net>
 <1226624178-3761-14-git-send-email-sage@newdream.net>
 <1226624178-3761-15-git-send-email-sage@newdream.net>
 <1226624178-3761-16-git-send-email-sage@newdream.net>
 <1226624178-3761-17-git-send-email-sage@newdream.net>
 <1226624178-3761-18-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some debugging infrastructure, including the ability to adjust the
level of debug output on a per-file basis.  A memory leak check tool
can also be enabled via .config.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/ceph_debug.h |  130 +++++++++++++++++++++++++++++++++++
 fs/ceph/ceph_tools.c |  125 +++++++++++++++++++++++++++++++++
 fs/ceph/ceph_tools.h |   19 +++++
 fs/ceph/proc.c       |  186 ++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 460 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/ceph_debug.h
 create mode 100644 fs/ceph/ceph_tools.c
 create mode 100644 fs/ceph/ceph_tools.h
 create mode 100644 fs/ceph/proc.c

diff --git a/fs/ceph/ceph_debug.h b/fs/ceph/ceph_debug.h
new file mode 100644
index 0000000..275fffa
--- /dev/null
+++ b/fs/ceph/ceph_debug.h
@@ -0,0 +1,130 @@
+#ifndef _FS_CEPH_DEBUG_H
+#define _FS_CEPH_DEBUG_H
+
+#include <linux/string.h>
+
+#include "ceph_tools.h"
+
+extern int ceph_debug;               /* debug level. */
+extern int ceph_debug_console;       /* send debug output to console? */
+extern int ceph_debug_mask;
+
+/*
+ * different debug levels for different modules.  These default to -1.
+ * If they are >=, then they override the global ceph_debug value.
+ */
+extern int ceph_debug_addr;
+extern int ceph_debug_caps;
+extern int ceph_debug_dir;
+extern int ceph_debug_export;
+extern int ceph_debug_file;
+extern int ceph_debug_inode;
+extern int ceph_debug_ioctl;
+extern int ceph_debug_mdsc;
+extern int ceph_debug_mdsmap;
+extern int ceph_debug_msgr;
+extern int ceph_debug_mon;
+extern int ceph_debug_osdc;
+extern int ceph_debug_osdmap;
+extern int ceph_debug_snap;
+extern int ceph_debug_super;
+extern int ceph_debug_protocol;
+extern int ceph_debug_proc;
+extern int ceph_debug_tools;
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
+struct _debug_mask_name {
+	int mask;
+	char *name;
+};
+
+static struct _debug_mask_name _debug_mask_names[] = {
+		{DOUT_MASK_ADDR, "addr"},
+		{DOUT_MASK_CAPS, "caps"},
+		{DOUT_MASK_DIR, "dir"},
+		{DOUT_MASK_EXPORT, "export"},
+		{DOUT_MASK_FILE, "file"},
+		{DOUT_MASK_INODE, "inode"},
+		{DOUT_MASK_IOCTL, "ioctl"},
+		{DOUT_MASK_MDSC, "mdsc"},
+		{DOUT_MASK_MDSMAP, "mdsmap"},
+		{DOUT_MASK_MSGR, "msgr"},
+		{DOUT_MASK_MON, "mon"},
+		{DOUT_MASK_OSDC, "osdc"},
+		{DOUT_MASK_OSDMAP, "osdmap"},
+		{DOUT_MASK_SNAP, "snap"},
+		{DOUT_MASK_SUPER, "super"},
+		{DOUT_MASK_PROTOCOL, "protocol"},
+		{DOUT_MASK_PROC, "proc"},
+		{DOUT_MASK_TOOLS, "tools"},
+		{0, NULL}
+};
+
+static inline int ceph_get_debug_mask(char *name)
+{
+	int i = 0;
+
+	while (_debug_mask_names[i].name) {
+		if (strcmp(_debug_mask_names[i].name, name) == 0)
+			return _debug_mask_names[i].mask;
+		i++;
+	}
+	return 0;
+}
+
+#define dout_flag(x, mask, args...) do {				\
+		if (((ceph_debug_mask | DOUT_UNMASKABLE) & mask) &&	\
+		    ((DOUT_VAR >= 0 && x <= DOUT_VAR) ||		\
+		     (DOUT_VAR < 0 && x <= ceph_debug))) {		\
+			if (ceph_debug_console)				\
+				printk(KERN_ERR "ceph_" DOUT_PREFIX args); \
+			else						\
+				printk(KERN_DEBUG "ceph_" DOUT_PREFIX args); \
+		}							\
+	} while (0)
+
+#define dout(x, args...) dout_flag(x, DOUT_MASK, args)
+
+#define derr(x, args...) do {			\
+		printk(KERN_ERR "ceph_" DOUT_PREFIX args);	\
+	} while (0)
+
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
diff --git a/fs/ceph/ceph_tools.c b/fs/ceph/ceph_tools.c
new file mode 100644
index 0000000..9994af6
--- /dev/null
+++ b/fs/ceph/ceph_tools.c
@@ -0,0 +1,125 @@
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
+int ceph_debug_tools = -1;
+#define DOUT_VAR ceph_debug_tools
+#define DOUT_MASK DOUT_MASK_TOOLS
+#define DOUT_PREFIX "tools: "
+#include "super.h"
+
+static struct list_head _bk_allocs;
+
+static DEFINE_SPINLOCK(_bk_lock);
+
+static size_t _total_alloc;
+static size_t _total_free;
+
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
+struct stack_frame {
+	struct stack_frame *next_frame;
+	unsigned long return_address;
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
diff --git a/fs/ceph/ceph_tools.h b/fs/ceph/ceph_tools.h
new file mode 100644
index 0000000..c8850ee
--- /dev/null
+++ b/fs/ceph/ceph_tools.h
@@ -0,0 +1,19 @@
+#ifndef _FS_CEPH_TOOLS_H
+#define _FS_CEPH_TOOLS_H
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
diff --git a/fs/ceph/proc.c b/fs/ceph/proc.c
new file mode 100644
index 0000000..2ec01ea
--- /dev/null
+++ b/fs/ceph/proc.c
@@ -0,0 +1,186 @@
+#include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/ctype.h>
+#include <linux/uaccess.h>
+
+
+#include "ceph_debug.h"
+int ceph_debug_proc = -1;
+#define DOUT_MASK DOUT_MASK_PROC
+#define DOUT_VAR ceph_debug_proc
+#define DOUT_PREFIX "proc: "
+
+#include "super.h"
+
+
+static int ceph_debug_level_read(char *page, char **start, off_t off,
+		       int count, int *eof, void *data)
+{
+	int len;
+	int *debug = data;
+
+	len = sprintf(page, "%d\n", *debug);
+
+	if ((len < 0) || (len <= off)) {
+		*start = page;
+		*eof = 1;
+		return 0;
+	}
+
+	len -= off;
+
+	*start = page + off;
+
+	if (len > count)
+		len = count;
+	else
+		*eof = 1;
+
+	return len;
+}
+
+static int ceph_debug_mask_read(char *page, char **start, off_t off,
+		       int count, int *eof, void *data)
+{
+	int len;
+	int *debug = data;
+
+	len = sprintf(page, "0x%x\n", *debug);
+
+	if ((len < 0) || (len <= off)) {
+		*start = page;
+		*eof = 1;
+		return 0;
+	}
+
+	len -= off;
+
+	*start = page + off;
+
+	if (len > count)
+		len = count;
+	else
+		*eof = 1;
+
+	return len;
+}
+
+static int ceph_debug_level_write(struct file *file, const char __user *buffer,
+				unsigned long count, void *data)
+{
+#define PROC_STR_LEN	16
+	char level_str[PROC_STR_LEN];
+	int new_dl;
+	int *debug = data;
+
+	if ((count < 1) || (count > sizeof(level_str)-1))
+		return -EINVAL;
+
+	level_str[PROC_STR_LEN-1] = 0;
+
+	if (copy_from_user(level_str, buffer, count))
+		return -EFAULT;
+
+	level_str[count] = 0;
+
+	new_dl = simple_strtol(level_str, NULL, 0);
+
+	*debug = new_dl;
+
+	return count;
+}
+
+static int ceph_debug_mask_write(struct file *file, const char __user *buffer,
+				unsigned long count, void *data)
+{
+	char  *mask_str, *tok;
+	int new_dl;
+	int *debug = data;
+
+#define MAX_BUF	512
+	if ((count < 1) || (count > MAX_BUF))
+		return -EINVAL;
+
+	mask_str = kmalloc(count+1, GFP_KERNEL);
+
+	if (copy_from_user(mask_str, buffer, count))
+		return -EFAULT;
+
+	mask_str[count] = 0;
+
+	do {
+		tok = strsep(&mask_str, " \t\r\n");
+
+		if (isdigit(*tok)) {
+			new_dl = simple_strtol(tok, NULL, 0);
+			*debug = new_dl;
+		} else {
+			int remove = 0;
+			int mask;
+
+			if (*tok == '-') {
+				remove = 1;
+				tok++;
+			} else if (*tok == '+')
+				tok++;
+
+			mask = ceph_get_debug_mask(tok);
+
+			if (remove)
+				*debug &= ~mask;
+			else
+				*debug |= mask;
+
+		}
+	} while (mask_str);
+
+
+	kfree(mask_str);
+
+	return count;
+}
+
+static struct proc_dir_entry *proc_fs_ceph;
+
+int ceph_proc_init(void)
+{
+	struct proc_dir_entry *pde;
+
+	proc_fs_ceph = proc_mkdir("fs/ceph", NULL);
+	if (!proc_fs_ceph)
+		return -ENOMEM;
+
+	proc_fs_ceph->owner = THIS_MODULE;
+	pde = create_proc_read_entry("debug", 0,
+				     proc_fs_ceph, ceph_debug_level_read,
+				     &ceph_debug);
+	if (pde)
+		pde->write_proc = ceph_debug_level_write;
+	pde = create_proc_read_entry("debug_msgr", 0,
+				     proc_fs_ceph, ceph_debug_level_read,
+				     &ceph_debug_msgr);
+	if (pde)
+		pde->write_proc = ceph_debug_level_write;
+	pde = create_proc_read_entry("debug_console", 0,
+				     proc_fs_ceph, ceph_debug_level_read,
+				     &ceph_debug_console);
+	if (pde)
+		pde->write_proc = ceph_debug_level_write;
+
+	pde = create_proc_read_entry("debug_mask", 0,
+				     proc_fs_ceph, ceph_debug_mask_read,
+				     &ceph_debug_mask);
+	if (pde)
+		pde->write_proc = ceph_debug_mask_write;
+
+	return 0;
+}
+
+void ceph_proc_cleanup(void)
+{
+	remove_proc_entry("debug", proc_fs_ceph);
+	remove_proc_entry("debug_msgr", proc_fs_ceph);
+	remove_proc_entry("debug_console", proc_fs_ceph);
+	remove_proc_entry("debug_mask", proc_fs_ceph);
+	remove_proc_entry("fs/ceph", NULL);
+}
-- 
1.5.6.5

