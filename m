Return-Path: <linux-kernel-owner+w=401wt.eu-S932150AbYDUMge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbYDUMge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 08:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758889AbYDUMe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 08:34:59 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:14965 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757618AbYDUMez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 08:34:55 -0400
Message-ID: <480C89EC.2050103@de.ibm.com>
Date: Mon, 21 Apr 2008 14:34:52 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, ltp-list@lists.sourceforge.net,
       ltp-coverage@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 7/8] gcov: add gcov profiling infrastructure
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

gcov profiling infrastructure:

* change kbuild to include profiling flags
* provide functions needed by profiling code
* present profiling data as files in debugfs

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
---
 Makefile              |   10 
 kernel/Makefile       |    1 
 kernel/gcov/Kconfig   |   44 +++
 kernel/gcov/Makefile  |   11 
 kernel/gcov/base.c    |  152 +++++++++++
 kernel/gcov/fs.c      |  540 ++++++++++++++++++++++++++++++++++++++++
 kernel/gcov/gcc_3_4.c |  374 +++++++++++++++++++++++++++
 kernel/gcov/gcov.h    |  101 +++++++
 lib/Kconfig.debug     |    1 
 scripts/Makefile.lib  |   10 
 10 files changed, 1239 insertions(+), 5 deletions(-)

Index: linux-2.6.25/Makefile
===================================================================
--- linux-2.6.25.orig/Makefile
+++ linux-2.6.25/Makefile
@@ -320,6 +320,7 @@ AFLAGS_MODULE   = $(MODFLAGS)
 LDFLAGS_MODULE  =
 CFLAGS_KERNEL	=
 AFLAGS_KERNEL	=
+CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
 
 
 # Use LINUXINCLUDE when you must reference the include/ directory.
@@ -345,7 +346,7 @@ export CPP AR NM STRIP OBJCOPY OBJDUMP M
 export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
 
 export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS LDFLAGS
-export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE
+export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE CFLAGS_GCOV
 export KBUILD_AFLAGS AFLAGS_KERNEL AFLAGS_MODULE
 
 # When compiling out-of-tree modules, put MODVERDIR in the module
@@ -1126,7 +1127,8 @@ clean: archclean $(clean-dirs)
 	@find . $(RCS_FIND_IGNORE) \
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
-		-o -name '*.symtypes' -o -name 'modules.order' \) \
+		-o -name '*.symtypes' -o -name 'modules.order' \
+		-o -name '*.gcno' \) \
 		-type f -print | xargs rm -f
 
 # mrproper - Delete all generated files, including .config
@@ -1309,8 +1311,8 @@ clean: $(clean-dirs)
 	$(call cmd,rmfiles)
 	@find $(KBUILD_EXTMOD) $(RCS_FIND_IGNORE) \
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
-		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \) \
-		-type f -print | xargs rm -f
+		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
+		-o -name '*.gcno' \) -type f -print | xargs rm -f
 
 help:
 	@echo  '  Building external modules.'
Index: linux-2.6.25/scripts/Makefile.lib
===================================================================
--- linux-2.6.25.orig/scripts/Makefile.lib
+++ linux-2.6.25/scripts/Makefile.lib
@@ -100,10 +100,18 @@ _c_flags       = $(KBUILD_CFLAGS) $(ccfl
 _a_flags       = $(KBUILD_AFLAGS) $(asflags-y) $(AFLAGS_$(basetarget).o)
 _cpp_flags     = $(KBUILD_CPPFLAGS) $(cppflags-y) $(CPPFLAGS_$(@F))
 
+# Enable profiling flags for a file, directory or for all files depending on
+# variables GCOV_obj.o, GCOV and CONFIG_GCOV_PROFILE_ALL (in this order)
+ifeq ($(CONFIG_GCOV_PROFILE),y)
+_c_flags += $(if $(patsubst n%,, \
+		$(GCOV_$(basetarget).o)$(GCOV)$(CONFIG_GCOV_PROFILE_ALL)), \
+		$(CFLAGS_GCOV))
+endif
+
 # If building the kernel in a separate objtree expand all occurrences
 # of -Idir to -I$(srctree)/dir except for absolute paths (starting with '/').
 
-ifeq ($(KBUILD_SRC),)
+ifeq ($(KBUILD_SRC)$(CONFIG_GCOV_PROFILE),)
 __c_flags	= $(_c_flags)
 __a_flags	= $(_a_flags)
 __cpp_flags     = $(_cpp_flags)
Index: linux-2.6.25/kernel/gcov/Kconfig
===================================================================
--- /dev/null
+++ linux-2.6.25/kernel/gcov/Kconfig
@@ -0,0 +1,45 @@
+menu "GCOV profiling"
+
+config GCOV_PROFILE
+	bool "Activate gcov-based profiling"
+	depends on DEBUG_FS
+	---help---
+	This option enables gcov-based code profiling (e.g. for code coverage
+	measurements).
+
+	If unsure, say N.
+
+	Additionally specify CONFIG_GCOV_PROFILE_ALL=y to get profiling data
+	for the entire kernel. To enable profiling for specific files or
+	directories, add a line similar to the following to the respective
+	Makefile:
+
+	For a single file (e.g. main.o):
+	        GCOV_main.o := y
+
+	For all files in one directory:
+	        GCOV := y
+
+	To exclude files from being profiled even when CONFIG_GCOV_PROFILE_ALL
+	is specified, use:
+
+	        GCOV_main.o := n
+	and:
+	        GCOV := n
+
+	Note that the debugfs filesystem has to be mounted to access
+	profiling data.
+
+config GCOV_PROFILE_ALL
+	bool "Profile entire Kernel"
+	depends on GCOV_PROFILE
+	---help---
+	This options activates profiling for the entire kernel.
+
+	If unsure, say Y.
+
+	Note that a kernel compiled with profiling flags will be larger and
+	slower. Also be sure to exclude files from profiling which are not
+	linked to the kernel image to prevent linker errors.
+
+endmenu
Index: linux-2.6.25/kernel/gcov/base.c
===================================================================
--- /dev/null
+++ linux-2.6.25/kernel/gcov/base.c
@@ -0,0 +1,152 @@
+/*
+ *  Base functions for profiling.
+ *
+ *    Copyright IBM Corp. 2008
+ *    Author(s): Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
+ *
+ *    Uses gcc-internal data definitions.
+ *    Based on the gcov-kernel patch by:
+ *		 Hubertus Franke <frankeh@us.ibm.com>
+ *		 Nigel Hinds <nhinds@us.ibm.com>
+ *		 Rajan Ravindran <rajancr@us.ibm.com>
+ *		 Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
+ *		 Paul Larson
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/syscalls.h>
+#include "gcov.h"
+
+static gcov_callback_t gcov_callback;
+static struct gcov_info *gcov_info_head;
+static DEFINE_MUTEX(gcov_lock);
+
+static void gcov_register_info(struct gcov_info *info)
+{
+	info->next = gcov_info_head;
+	gcov_info_head = info;
+	if (gcov_callback)
+		gcov_callback(gcov_add, info);
+}
+
+#if GCC_VERSION_LOWER(3, 4)
+
+#error "GCOV profiling support for gcc versions below 3.4 not included"
+
+#else
+/* Functions needed by profiling code for gcc 3.4 and above. */
+
+unsigned int gcov_version;
+
+void __gcov_init(struct gcov_info *info)
+{
+	mutex_lock(&gcov_lock);
+	/* Check for compatible gcc version. */
+	if (gcov_version == 0) {
+		gcov_version = info->version;
+		printk(KERN_INFO TAG "gcc version %x\n", gcov_version);
+	} else if (info->version != gcov_version) {
+		printk(KERN_WARNING TAG "version mismatch in %s\n",
+		       info->filename);
+		goto out;
+	}
+	gcov_register_info(info);
+out:
+	mutex_unlock(&gcov_lock);
+}
+EXPORT_SYMBOL(__gcov_init);
+
+/* These functions may be referenced by profiling code but serve no function
+ * for kernel profiling. */
+void __gcov_flush(void)
+{
+	/* Unused. */
+}
+EXPORT_SYMBOL(__gcov_flush);
+
+void __gcov_merge_add(gcov_type *counters, unsigned int n_counters)
+{
+	/* Unused. */
+}
+EXPORT_SYMBOL(__gcov_merge_add);
+
+void __gcov_merge_single(gcov_type *counters, unsigned int n_counters)
+{
+	/* Unused. */
+}
+EXPORT_SYMBOL(__gcov_merge_single);
+
+void __gcov_merge_delta(gcov_type *counters, unsigned int n_counters)
+{
+	/* Unused. */
+}
+EXPORT_SYMBOL(__gcov_merge_delta);
+
+int __gcov_execve(const char *path, char *const argv[], char *const envp[])
+{
+	return kernel_execve(path, argv, envp);
+}
+EXPORT_SYMBOL(__gcov_execve);
+
+#endif /* GCC_VERSION */
+
+int gcov_register_callback(gcov_callback_t callback)
+{
+	struct gcov_info *info;
+	int rc;
+
+	mutex_lock(&gcov_lock);
+	if (gcov_callback) {
+		rc = -EBUSY;
+		goto out;
+	}
+	rc = 0;
+	gcov_callback = callback;
+	/* Perform callback for previously registered entries. */
+	for (info = gcov_info_head; info; info = info->next)
+		gcov_callback(gcov_add, info);
+out:
+	mutex_unlock(&gcov_lock);
+
+	return rc;
+}
+
+static int gcov_module_notifier(struct notifier_block *nb, unsigned long event,
+				void *data)
+{
+	struct module *mod = data;
+	struct gcov_info *info;
+	struct gcov_info *prev;
+
+	if (event != MODULE_STATE_GOING)
+		return NOTIFY_OK;
+	mutex_lock(&gcov_lock);
+	prev = NULL;
+	/* Remove entries located in module from linked list. */
+	for (info = gcov_info_head; info; info = info->next) {
+		if (mod == module_address((unsigned long) info)) {
+			if (prev)
+				prev->next = info->next;
+			else
+				gcov_info_head = info->next;
+			if (gcov_callback)
+				gcov_callback(gcov_remove, info);
+		} else
+			prev = info;
+	}
+	mutex_unlock(&gcov_lock);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block gcov_nb = {
+	.notifier_call	= gcov_module_notifier,
+};
+
+static int __init gcov_init(void)
+{
+	return register_module_notifier(&gcov_nb);
+}
+__initcall(gcov_init);
Index: linux-2.6.25/kernel/gcov/gcov.h
===================================================================
--- /dev/null
+++ linux-2.6.25/kernel/gcov/gcov.h
@@ -0,0 +1,101 @@
+/*
+ *  Profiling infrastructure declarations.
+ *
+ *    Copyright IBM Corp. 2008
+ *    Author(s): Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
+ *
+ *    Uses gcc-internal data definitions.
+ */
+
+#ifndef GCOV_H
+#define GCOV_H GCOV_H
+
+#include <linux/types.h>
+
+#define TAG	"gcov: "
+#define GCC_VERSION_LOWER(major, minor) ((__GNUC__ < major) || \
+					 (__GNUC__ == major) && \
+					 (__GNUC_MINOR__ < minor))
+#if GCC_VERSION_LOWER(3, 4)
+
+#error "GCOV profiling support for gcc versions below 3.4 not included"
+
+#else
+/* Profiling data types used for gcc 3.4 and above. */
+
+#define GCOV_COUNTERS		5
+#define GCOV_DATA_MAGIC		((unsigned int) 0x67636461)
+#define GCOV_TAG_FUNCTION	((unsigned int) 0x01000000)
+#define GCOV_TAG_COUNTER_BASE	((unsigned int) 0x01a10000)
+#define GCOV_TAG_FOR_COUNTER(count)					\
+	(GCOV_TAG_COUNTER_BASE + ((unsigned int) (count) << 17))
+
+#if BITS_PER_LONG >= 64
+typedef long gcov_type;
+#else
+typedef long long gcov_type;
+#endif
+
+struct gcov_fn_info {
+	unsigned int ident;
+	unsigned int checksum;
+	unsigned int n_ctrs[0];
+};
+
+struct gcov_ctr_info {
+	unsigned int num;
+	gcov_type *values;
+	void (*merge)(gcov_type *, unsigned int);
+};
+
+struct gcov_info {
+	unsigned int version;
+	struct gcov_info *next;
+	unsigned int stamp;
+	const char *filename;
+	unsigned int n_functions;
+	const struct gcov_fn_info *functions;
+	unsigned int ctr_mask;
+	struct gcov_ctr_info counts[0];
+};
+
+extern unsigned int gcov_version;
+
+#endif /* GCC_VERSION_LOWER */
+
+/* Base interface. */
+enum gcov_action {
+	gcov_add,
+	gcov_remove,
+};
+
+typedef void (*gcov_callback_t)(enum gcov_action, struct gcov_info *);
+
+int gcov_register_callback(gcov_callback_t);
+
+/* Iterator control. */
+struct seq_file;
+
+void *gcov_iter_new(struct gcov_info *);
+void gcov_iter_start(void *);
+int gcov_iter_next(void *);
+int gcov_iter_write(void *, struct seq_file *);
+struct gcov_info *gcov_iter_get_info(void *);
+
+/* gcov_info control. */
+void gcov_info_reset(struct gcov_info *);
+int gcov_info_is_compatible(struct gcov_info *, struct gcov_info *);
+void gcov_info_add(struct gcov_info *, struct gcov_info *);
+struct gcov_info *gcov_info_dup(struct gcov_info *);
+void gcov_info_free(struct gcov_info *);
+
+struct gcov_link_t {
+	enum {
+		obj_tree,
+		src_tree,
+	} dir;
+	const char *ext;
+};
+extern const struct gcov_link_t gcov_link[];
+
+#endif /* GCOV_H */
Index: linux-2.6.25/lib/Kconfig.debug
===================================================================
--- linux-2.6.25.orig/lib/Kconfig.debug
+++ linux-2.6.25/lib/Kconfig.debug
@@ -622,3 +622,4 @@ config PROVIDE_OHCI1394_DMA_INIT
 	  See Documentation/debugging-via-ohci1394.txt for more information.
 
 source "samples/Kconfig"
+source "kernel/gcov/Kconfig"
Index: linux-2.6.25/kernel/Makefile
===================================================================
--- linux-2.6.25.orig/kernel/Makefile
+++ linux-2.6.25/kernel/Makefile
@@ -68,6 +68,7 @@ obj-$(CONFIG_TASK_DELAY_ACCT) += delayac
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_MARKERS) += marker.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
+obj-$(CONFIG_GCOV_PROFILE) += gcov/
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
Index: linux-2.6.25/kernel/gcov/Makefile
===================================================================
--- /dev/null
+++ linux-2.6.25/kernel/gcov/Makefile
@@ -0,0 +1,11 @@
+EXTRA_CFLAGS := -DSRCTREE='"$(srctree)"' -DOBJTREE='"$(objtree)"'
+
+gcc-ver-lower-3.4 := $(call cc-ifversion, -lt, 0304, y)
+
+obj-$(CONFIG_GCOV_PROFILE) := base.o fs.o
+
+ifeq ($(gcc-ver-lower-3.4),y)
+$(error GCOV profiling support for gcc versions below 3.4 not included)
+else
+obj-$(CONFIG_GCOV_PROFILE) += gcc_3_4.o
+endif
Index: linux-2.6.25/kernel/gcov/fs.c
===================================================================
--- /dev/null
+++ linux-2.6.25/kernel/gcov/fs.c
@@ -0,0 +1,542 @@
+/*
+ *  Filesystem for exporting profiling data to userspace.
+ *
+ *    Copyright IBM Corp. 2008
+ *    Author(s): Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
+ *
+ *    Uses gcc-internal data definitions.
+ *    Based on the gcov-kernel patch by:
+ *		 Hubertus Franke <frankeh@us.ibm.com>
+ *		 Nigel Hinds <nhinds@us.ibm.com>
+ *		 Rajan Ravindran <rajancr@us.ibm.com>
+ *		 Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
+ *		 Paul Larson
+ *		 Yi CDL Yang
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/debugfs.h>
+#include <linux/fs.h>
+#include <linux/list.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/seq_file.h>
+#include "gcov.h"
+
+struct node_t {
+	struct list_head list;
+	struct list_head children;
+	struct list_head all;
+	struct node_t *parent;
+	struct gcov_info *info;
+	struct gcov_info *ghost;
+	struct dentry *dentry;
+	struct dentry **links;
+	char name[0];
+};
+
+static const char objtree[] = OBJTREE;
+static const char srctree[] = SRCTREE;
+static struct node_t root_node;
+static struct list_head all_head;
+static struct dentry *reset_dentry;
+static DEFINE_MUTEX(node_lock);
+
+/* If non-zero, keep copies of profiling data for unloaded modules. */
+static int gcov_persist = 1;
+
+static int __init gcov_persist_setup(char *str)
+{
+	int val;
+	char delim;
+
+	if (sscanf(str, "%d %c", &val, &delim) != 1) {
+		printk(KERN_WARNING TAG "invalid gcov_persist parameter '%s'\n",
+		       str);
+		return 0;
+	}
+	printk(KERN_INFO TAG "setting gcov_persist to %d\n", val);
+	gcov_persist = val;
+
+	return 1;
+}
+__setup("gcov_persist=", gcov_persist_setup);
+
+static void *gcov_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	loff_t i;
+
+	gcov_iter_start(seq->private);
+	for (i = 0; i < *pos; i++)
+		if (gcov_iter_next(seq->private))
+			return NULL;
+
+	return seq->private;
+}
+
+static void *gcov_seq_next(struct seq_file *seq, void *data, loff_t *pos)
+{
+	struct iterator_t *iter = data;
+
+	if (gcov_iter_next(iter))
+		return NULL;
+	(*pos)++;
+
+	return iter;
+}
+
+static int gcov_seq_show(struct seq_file *seq, void *data)
+{
+	struct iterator_t *iter = data;
+
+	return gcov_iter_write(iter, seq);
+}
+
+static void gcov_seq_stop(struct seq_file *seq, void *data)
+{
+	/* Unused. */
+}
+
+static struct seq_operations seq_ops = {
+	.start = gcov_seq_start,
+	.next = gcov_seq_next,
+	.show = gcov_seq_show,
+	.stop = gcov_seq_stop,
+};
+
+struct gcov_info *get_node_info(struct node_t *node)
+{
+	if (node->info)
+		return node->info;
+
+	return node->ghost;
+}
+
+static int gcov_seq_open(struct inode *inode, struct file *file)
+{
+	struct node_t *node = inode->i_private;
+	struct iterator_t *iter;
+	struct seq_file *seq;
+	struct gcov_info *info;
+	int rc;
+
+	mutex_lock(&node_lock);
+	/* Read from a profiling data copy to minimize reference tracking
+	 * complexity and concurrent access. */
+	info = gcov_info_dup(get_node_info(node));
+	if (!info) {
+		rc = -ENOMEM;
+		goto out_unlock;
+	}
+	iter = gcov_iter_new(info);
+	if (!iter) {
+		rc = -ENOMEM;
+		goto out_free;
+	}
+	rc = seq_open(file, &seq_ops);
+	if (rc)
+		goto out_free2;
+	seq = file->private_data;
+	seq->private = iter;
+	goto out_unlock;
+
+out_free2:
+	kfree(iter);
+out_free:
+	kfree(info);
+out_unlock:
+	mutex_unlock(&node_lock);
+
+	return rc;
+}
+
+static int gcov_seq_release(struct inode *inode, struct file *file)
+{
+	struct gcov_info *info;
+	struct seq_file *seq = file->private_data;
+
+	info = gcov_iter_get_info(seq->private);
+	kfree(info);
+	kfree(seq->private);
+	seq_release(inode, file);
+
+	return 0;
+}
+
+static struct node_t *get_node_by_name(const char *name)
+{
+	struct node_t *node;
+	struct gcov_info *info;
+
+	list_for_each_entry(node, &all_head, all) {
+		info = get_node_info(node);
+		if (info && (strcmp(info->filename, name) == 0))
+			return node;
+	}
+
+	return NULL;
+}
+
+static void remove_node(struct node_t *node);
+
+static ssize_t gcov_seq_write(struct file *file, const char __user *addr,
+			      size_t len, loff_t *pos)
+{
+	struct seq_file *seq = file->private_data;
+	struct gcov_info *info = gcov_iter_get_info(seq->private);
+	struct node_t *node;
+
+	mutex_lock(&node_lock);
+	node = get_node_by_name(info->filename);
+	if (node) {
+		/* Reset counts or remove node for unloaded modules. */
+		if (node->ghost)
+			remove_node(node);
+		else
+			gcov_info_reset(node->info);
+	}
+	/* Reset counts for open file. */
+	gcov_info_reset(info);
+	mutex_unlock(&node_lock);
+
+	return len;
+}
+
+static char *build_target(const char *dir, const char *rel, const char *ext)
+{
+	char *target;
+	char *old_ext;
+
+	if (dir) {
+		/* DIR + '/' + REL + '.' + EXT + '\0' */
+		target = kmalloc(strlen(dir) + strlen(rel) + strlen(ext) + 3,
+				 GFP_KERNEL);
+		if (!target)
+			return NULL;
+		sprintf(target, "%s/%s", dir, rel);
+	} else {
+		/* REL + '.' + EXT + '\0' */
+		target = kmalloc(strlen(rel) + strlen(ext) + 2, GFP_KERNEL);
+		if (!target)
+			return NULL;
+		sprintf(target, "%s", rel);
+	}
+	old_ext = strrchr(target, '.');
+	if (!old_ext)
+		old_ext = target + strlen(target);
+	sprintf(old_ext, ".%s", ext);
+
+	return target;
+}
+
+char *get_link_target(const char *filename, const struct gcov_link_t *ext)
+{
+	const char *rel;
+	char *result;
+
+	if (strncmp(filename, objtree, strlen(objtree)) == 0) {
+		rel = filename + strlen(objtree) + 1;
+		if (ext->dir == src_tree)
+			result = build_target(srctree, rel, ext->ext);
+		else
+			result = build_target(objtree, rel, ext->ext);
+	} else {
+		/* External compilation. */
+		result = build_target(NULL, filename, ext->ext);
+	}
+	return result;
+}
+
+static void add_links(struct node_t *node, struct dentry *parent)
+{
+	char *basename;
+	char *target;
+	int num;
+	int i;
+
+	for (num = 0; gcov_link[num].ext; num++)
+		/* Nothing. */;
+	node->links = kcalloc(num, sizeof(struct dentry *), GFP_KERNEL);
+	if (!node->links)
+		return;
+	for (i = 0; i < num; i++) {
+		target = get_link_target(get_node_info(node)->filename,
+					 &gcov_link[i]);
+		if (!target)
+			goto out_err;
+		basename = strrchr(target, '/');
+		if (!basename)
+			goto out_err;
+		basename++;
+		node->links[i] = debugfs_create_symlink(basename, parent,
+							target);
+		if (!node->links[i])
+			goto out_err;
+		kfree(target);
+	}
+
+	return;
+out_err:
+	kfree(target);
+	while (i-- > 0)
+		debugfs_remove(node->links[i]);
+	kfree(node->links);
+	node->links = NULL;
+}
+
+static struct file_operations data_fops = {
+	.open = gcov_seq_open,
+	.release = gcov_seq_release,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.write = gcov_seq_write,
+};
+
+static void init_node(struct node_t *node, struct gcov_info *info,
+		      const char *name)
+{
+	INIT_LIST_HEAD(&node->list);
+	INIT_LIST_HEAD(&node->children);
+	INIT_LIST_HEAD(&node->all);
+	node->info = info;
+	if (name)
+		strcpy(node->name, name);
+}
+
+static struct node_t *new_node(struct node_t *parent, struct gcov_info *info,
+			       const char *name)
+{
+	struct node_t *node;
+
+	node = kzalloc(sizeof(struct node_t) + strlen(name) + 1, GFP_KERNEL);
+	if (!node) {
+		printk(KERN_WARNING TAG "out of memory\n");
+		return NULL;
+	}
+	init_node(node, info, name);
+	if (info) {
+		node->dentry = debugfs_create_file(node->name, 0600,
+					parent->dentry, node, &data_fops);
+	} else
+		node->dentry = debugfs_create_dir(node->name, parent->dentry);
+	if (!node->dentry) {
+		printk(KERN_WARNING TAG "could not create file\n");
+		kfree(node);
+		return NULL;
+	}
+	if (info)
+		add_links(node, parent->dentry);
+	list_add(&node->list, &parent->children);
+	list_add(&node->all, &all_head);
+
+	return node;
+}
+
+static void remove_links(struct node_t *node)
+{
+	int i;
+
+	if (!node->links)
+		return;
+	for (i = 0; gcov_link[i].ext; i++)
+		debugfs_remove(node->links[i]);
+	kfree(node->links);
+	node->links = NULL;
+}
+
+static void release_node(struct node_t *node)
+{
+	list_del(&node->list);
+	list_del(&node->all);
+	debugfs_remove(node->dentry);
+	remove_links(node);
+	kfree(node->ghost);
+	kfree(node);
+}
+
+static void remove_node(struct node_t *node)
+{
+	struct node_t *parent;
+
+	while ((node != &root_node) && list_empty(&node->children)) {
+		parent = node->parent;
+		release_node(node);
+		node = parent;
+	}
+}
+
+static struct node_t *get_child_by_name(struct node_t *parent, const char *name)
+{
+	struct node_t *node;
+
+	list_for_each_entry(node, &parent->children, list) {
+		if (strcmp(node->name, name) == 0)
+			return node;
+	}
+
+	return NULL;
+}
+
+static ssize_t reset_write(struct file *file, const char __user *addr,
+			   size_t len, loff_t *pos)
+{
+	struct node_t *node;
+	struct node_t *r;
+
+	mutex_lock(&node_lock);
+	list_for_each_entry_safe(node, r, &all_head, all) {
+		if (node->info)
+			gcov_info_reset(node->info);
+		else
+			remove_node(node);
+	}
+	mutex_unlock(&node_lock);
+
+	return len;
+}
+
+static ssize_t reset_read(struct file *file, char __user *addr, size_t len,
+			  loff_t *pos)
+{
+	/* Allow read operation so that a recursive copy won't fail. */
+	return 0;
+}
+
+static struct file_operations reset_fops = {
+	.write = reset_write,
+	.read = reset_read,
+};
+
+static void add_node(struct gcov_info *info)
+{
+	char *filename;
+	char *curr;
+	char *next;
+	struct node_t *parent;
+	struct node_t *node;
+
+	filename = kstrdup(info->filename, GFP_KERNEL);
+	if (!filename)
+		return;
+	parent = &root_node;
+	/* Create path nodes. */
+	for (curr = filename; (next = strchr(curr, '/')); curr = next + 1) {
+		if (curr == next)
+			continue;
+		*next = 0;
+		node = get_child_by_name(parent, curr);
+		if (!node) {
+			node = new_node(parent, NULL, curr);
+			if (!node)
+				goto out_err;
+		}
+		parent = node;
+	}
+	/* Create file node. */
+	node = new_node(parent, info, curr);
+	if (node)
+		goto out;
+out_err:
+	remove_node(parent);
+out:
+	kfree(filename);
+}
+
+static int ghost_node(struct node_t *node)
+{
+	node->ghost = gcov_info_dup(node->info);
+	if (!node->ghost) {
+		printk(KERN_WARNING TAG "could not save data for '%s' (out of "
+		       "memory)\n", node->info->filename);
+		return -ENOMEM;
+	}
+	node->info = NULL;
+
+	return 0;
+}
+
+static void revive_node(struct node_t *node, struct gcov_info *info)
+{
+	if (gcov_info_is_compatible(node->ghost, info))
+		gcov_info_add(info, node->ghost);
+	else {
+		printk(KERN_WARNING TAG "could not add data for '%s' "
+		       "(incompatible data)\n", info->filename);
+	}
+	kfree(node->ghost);
+	node->ghost = NULL;
+	node->info = info;
+}
+
+static void gcov_cb(enum gcov_action action, struct gcov_info *info)
+{
+	struct node_t *node;
+
+	mutex_lock(&node_lock);
+	node = get_node_by_name(info->filename);
+	switch (action) {
+	case gcov_add:
+		if (!node) {
+			add_node(info);
+			break;
+		}
+		if (gcov_persist)
+			revive_node(node, info);
+		else
+			printk(KERN_WARNING TAG "could not add '%s' "
+			       "(already exists)\n", info->filename);
+		break;
+	case gcov_remove:
+		if (!node) {
+			printk(KERN_WARNING TAG "could not remove '%s' (not "
+			       "found)\n", info->filename);
+			break;
+		}
+		if (gcov_persist) {
+			if (!ghost_node(node))
+				break;
+		}
+		remove_node(node);
+		break;
+	}
+	mutex_unlock(&node_lock);
+}
+
+static __init int gcov_fs_init(void)
+{
+	int rc;
+
+	INIT_LIST_HEAD(&all_head);
+	init_node(&root_node, NULL, NULL);
+	root_node.dentry = debugfs_create_dir("gcov", NULL);
+	if (!root_node.dentry) {
+		printk(KERN_WARNING TAG "could not create root dir\n");
+		rc = -EIO;
+		goto out_remove;
+	}
+	reset_dentry = debugfs_create_file("reset", 0600, root_node.dentry,
+					   NULL, &reset_fops);
+	if (!reset_dentry) {
+		printk(KERN_WARNING TAG "could not create reset file\n");
+		rc = -EIO;
+		goto out_remove;
+	}
+	rc = gcov_register_callback(gcov_cb);
+	if (rc) {
+		printk(KERN_WARNING TAG "could not register callback (rc=%d)\n",
+		       rc);
+		goto out_remove;
+	}
+
+	return 0;
+out_remove:
+	if (reset_dentry)
+		debugfs_remove(reset_dentry);
+	if (root_node.dentry)
+		debugfs_remove(root_node.dentry);
+
+	return rc;
+}
+__initcall(gcov_fs_init);
Index: linux-2.6.25/kernel/gcov/gcc_3_4.c
===================================================================
--- /dev/null
+++ linux-2.6.25/kernel/gcov/gcc_3_4.c
@@ -0,0 +1,374 @@
+/*
+ *  Handling of profiling data.
+ *
+ *    Copyright IBM Corp. 2008
+ *    Author(s): Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
+ *
+ *    Uses gcc-internal data definitions.
+ */
+
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/seq_file.h>
+#include "gcov.h"
+
+const struct gcov_link_t gcov_link[] = {
+	{ src_tree, "c" },
+	{ obj_tree, "gcno" },
+	{ 0, NULL},
+};
+
+/* Determine whether counter type is active in info. */
+static int counter_active(struct gcov_info *info, unsigned int type)
+{
+	return (1 << type) & info->ctr_mask;
+}
+
+/* Return the number of active counter types for info. */
+static unsigned int num_counter_active(struct gcov_info *info)
+{
+	unsigned int i;
+	unsigned int result = 0;
+
+	for (i = 0; i < GCOV_COUNTERS; i++)
+		if (counter_active(info, i))
+			result++;
+	return result;
+}
+
+/**
+ * gcov_info_reset - reset profiling data
+ * @info: profiling data address
+ */
+void gcov_info_reset(struct gcov_info *info)
+{
+	struct gcov_ctr_info *ctr = info->counts;
+	unsigned int i;
+
+	for (i = 0; i < GCOV_COUNTERS; i++) {
+		if (counter_active(info, i)) {
+			memset(ctr->values, 0, ctr->num * sizeof(gcov_type));
+			ctr++;
+		}
+	}
+}
+
+/**
+ * gcov_info_is_compatible - return whether profiling data can be added
+ * @info1: address of first profiling data set
+ * @info2: address of second profiling data set
+ *
+ * Returns non-zero if profiling data can be added, zero otherwise.
+ */
+int gcov_info_is_compatible(struct gcov_info *info1, struct gcov_info *info2)
+{
+	return (info1->stamp == info2->stamp);
+}
+
+/**
+ * gcov_info_add - add up profiling data
+ * @dest: address of profiling data to which data is added
+ * @source: address of profiling data which is added
+ *
+ * Adds profiling counts of @source to @dest.
+ */
+void gcov_info_add(struct gcov_info *dest, struct gcov_info *source)
+{
+	unsigned int i;
+	unsigned int j;
+
+	for (i = 0; i < num_counter_active(dest); i++)
+		for (j = 0; j < dest->counts[i].num; j++)
+			dest->counts[i].values[j] +=
+				source->counts[i].values[j];
+}
+
+/* Get size of function info entry. */
+static size_t get_fn_size(struct gcov_info *info)
+{
+	size_t size;
+
+	size = sizeof(struct gcov_fn_info) + num_counter_active(info) *
+	       sizeof(unsigned int);
+	if (__alignof__(struct gcov_fn_info) > sizeof(unsigned int))
+		size = ALIGN(size, __alignof__(struct gcov_fn_info));
+	return size;
+}
+
+/* Get address of function info entry. */
+static struct gcov_fn_info *get_fn_info(struct gcov_info *info, unsigned int fn)
+{
+	return (struct gcov_fn_info *)
+		((char *) info->functions + fn * get_fn_size(info));
+}
+
+/**
+ * gcov_info_dup - duplicate profiling data
+ * @info: address of profiling data to duplicate
+ *
+ * Return the address of the newly allocated duplicate on success, %NULL on
+ * error.
+ */
+struct gcov_info *gcov_info_dup(struct gcov_info *info)
+{
+	struct gcov_info *result;
+	size_t len;
+	unsigned int active;
+	unsigned int i;
+	char *name;
+	struct gcov_fn_info *func;
+	gcov_type *values;
+
+	/* Allocate memory for struct gcov_info */
+	active = num_counter_active(info);
+	len = sizeof(struct gcov_info) + sizeof(struct gcov_ctr_info) * active +
+	      strlen(info->filename) + 1;
+	for (i = 0; i < active; i++)
+		len += sizeof(gcov_type) * info->counts[i].num;
+	result = kzalloc(len, GFP_KERNEL);
+	if (!result)
+		return NULL;
+	/* Allocate memory for array of struct gcov_fn_info */
+	len = info->n_functions * get_fn_size(info);
+	func = kmalloc(len, GFP_KERNEL);
+	if (!func) {
+		kfree(result);
+		return NULL;
+	}
+	/* Copy function data */
+	memcpy(func, info->functions, len);
+	result->functions = func;
+	/* Copy counts */
+	values = (gcov_type *) &result->counts[active];
+	for (i = 0; i < active; i++) {
+		result->counts[i].num = info->counts[i].num;
+		result->counts[i].merge = info->counts[i].merge;
+		result->counts[i].values = values;
+		memcpy(values, info->counts[i].values,
+		       sizeof(gcov_type) * info->counts[i].num);
+		values += info->counts[i].num;
+	}
+	/* Copy rest */
+	result->stamp = info->stamp;
+	name = (char *) values;
+	strcpy(name, info->filename);
+	result->filename = name;
+	result->n_functions = info->n_functions;
+	result->ctr_mask = info->ctr_mask;
+
+	return result;
+}
+
+/**
+ * gcov_info_free - release memory for profiling data duplicate
+ * @info: address of profiling data to free
+ */
+void gcov_info_free(struct gcov_info *info)
+{
+	kfree(info->functions);
+	kfree(info);
+}
+
+struct type_info {
+	int num;
+	unsigned int offset;
+};
+
+struct iterator_t {
+	struct gcov_info *info;
+
+	int record;
+	unsigned int function;
+	unsigned int type;
+	unsigned int count;
+
+	int num_types;
+	struct type_info type_info[0];
+};
+
+static struct gcov_fn_info *get_func(struct iterator_t *iter)
+{
+	return get_fn_info(iter->info, iter->function);
+}
+
+static struct type_info *get_type(struct iterator_t *iter)
+{
+	return &iter->type_info[iter->type];
+}
+
+/**
+ * gcov_iter_new - allocate and initialize profiling data iterator
+ * @info: address of profiling data to be iterated
+ *
+ * Return address of iterator on success, %NULL otherwise.
+ */
+void *gcov_iter_new(struct gcov_info *info)
+{
+	struct iterator_t *iter;
+
+	iter = kzalloc(sizeof(struct iterator_t) +
+		       num_counter_active(info) * sizeof(struct type_info),
+		       GFP_KERNEL);
+	if (iter)
+		iter->info = info;
+
+	return iter;
+}
+
+/**
+ * gcov_iter_get_info - return address of profiling data for iterator
+ * @data: iterator address
+ */
+struct gcov_info *gcov_iter_get_info(void *data)
+{
+	struct iterator_t *iter = data;
+
+	return iter->info;
+}
+
+/**
+ * gcov_iter_start - reset iterator to starting position
+ * @data: iterator address
+ */
+void gcov_iter_start(void *data)
+{
+	struct iterator_t *iter = data;
+	int i;
+
+	iter->record = 0;
+	iter->function = 0;
+	iter->type = 0;
+	iter->count = 0;
+	iter->num_types = 0;
+	for (i = 0; i < GCOV_COUNTERS; i++) {
+		if (counter_active(iter->info, i)) {
+			iter->type_info[iter->num_types].num = i;
+			iter->type_info[iter->num_types++].offset = 0;
+		}
+	}
+}
+
+/**
+ * gcov_iter_next - advance iterator to next pos
+ * @data: iterator address
+ *
+ * Return zero if new position is valid, non-zero if iterator has reached end.
+ */
+int gcov_iter_next(void *data)
+{
+	struct iterator_t *iter = data;
+
+	switch (iter->record) {
+	case 0:
+	case 1:
+	case 3:
+	case 4:
+	case 5:
+	case 7:
+		/* Advance to next record */
+		iter->record++;
+		break;
+	case 9:
+		/* Advance to next count */
+		iter->count++;
+		/* fall through */
+	case 8:
+		if (iter->count < get_func(iter)->n_ctrs[iter->type]) {
+			iter->record = 9;
+			break;
+		}
+		/* Advance to next counter type */
+		get_type(iter)->offset += iter->count;
+		iter->count = 0;
+		iter->type++;
+		/* fall through */
+	case 6:
+		if (iter->type < iter->num_types) {
+			iter->record = 7;
+			break;
+		}
+		/* Advance to next function */
+		iter->type = 0;
+		iter->function++;
+		/* fall through */
+	case 2:
+		if (iter->function < iter->info->n_functions)
+			iter->record = 3;
+		else
+			iter->record = -1;
+		break;
+	}
+	/* Check for EOF. */
+	if (iter->record == -1)
+		return -EINVAL;
+	else
+		return 0;
+}
+
+static int seq_write_gcov_int(struct seq_file *seq, size_t size, u64 v)
+{
+	u32 data[2];
+
+	switch (size) {
+	case 8:
+		data[1] = (u32) (v >> 32);
+		/* fall through */
+	case 4:
+		data[0] = (u32) (v & 0xffffffffUL);
+		return seq_write(seq, data, size);
+	}
+	return -EINVAL;
+}
+
+/**
+ * gcov_iter_write - write data for current pos to seq_file
+ * @data: iterator address
+ * @seq: seq_file address
+ *
+ * Return zero on success, non-zero otherwise.
+ */
+int gcov_iter_write(void *data, struct seq_file *seq)
+{
+	struct iterator_t *iter = data;
+	int rc;
+
+	rc = -EINVAL;
+	switch (iter->record) {
+	case 0: /* file magic */
+		rc = seq_write_gcov_int(seq, 4, GCOV_DATA_MAGIC);
+		break;
+	case 1: /* gcov_version */
+		rc = seq_write_gcov_int(seq, 4, gcov_version);
+		break;
+	case 2: /* time stamp */
+		rc = seq_write_gcov_int(seq, 4, iter->info->stamp);
+		break;
+	case 3: /* function tag */
+		rc = seq_write_gcov_int(seq, 4, GCOV_TAG_FUNCTION);
+		break;
+	case 4: /* function tag length */
+		rc = seq_write_gcov_int(seq, 4, 2);
+		break;
+	case 5: /* function ident*/
+		rc = seq_write_gcov_int(seq, 4, get_func(iter)->ident);
+		break;
+	case 6: /* function checksum */
+		rc = seq_write_gcov_int(seq, 4, get_func(iter)->checksum);
+		break;
+	case 7: /* count tag */
+		rc = seq_write_gcov_int(seq, 4,
+			GCOV_TAG_FOR_COUNTER(get_type(iter)->num));
+		break;
+	case 8: /* count length */
+		rc = seq_write_gcov_int(seq, 4,
+				get_func(iter)->n_ctrs[iter->type] * 2);
+		break;
+	case 9: /* count */
+		rc = seq_write_gcov_int(seq, 8,
+			iter->info->counts[iter->type].
+				values[iter->count + get_type(iter)->offset]);
+		break;
+	}
+	return rc;
+}




