Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbYD2Sl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbYD2Sl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636AbYD2Sls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:41:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755631AbYD2Slr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:41:47 -0400
Date: Tue, 29 Apr 2008 14:41:43 -0400
From: Jason Baron <jbaron@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 1/3] dynamic_printk: core
Message-ID: <20080429184143.GB8717@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add the ability to dynamically enable/disable pr_debug()/dev_dbg() in the
kernel. Yes, these calls could be converted to printk(KERN_DEBUG), but there
are enough to cause overhead. Additionally, the logs become difficult to read.
Here, one can turn these messages on/off per module via:

echo "add module_name" >  <debugfs>/dynamic_printk/modules
echo "remove module_name" >  <debugfs>/dynamic_printk/modules

There is also a special 'all' value that turns on all the debugging messages.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---

 include/linux/device.h |   10 ++
 include/linux/kernel.h |    9 ++
 lib/Kconfig.debug      |   40 ++++++++
 lib/Makefile           |    2 
 lib/dynamic_printk.c   |  251 ++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 312 insertions(+), 0 deletions(-)
 create mode 100644 lib/dynamic_printk.c


diff --git a/include/linux/device.h b/include/linux/device.h
index 1a06026..e2739f6 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -595,6 +595,16 @@ extern const char *dev_driver_string(struct device *dev);
 #ifdef DEBUG
 #define dev_dbg(dev, format, arg...)		\
 	dev_printk(KERN_DEBUG , dev , format , ## arg)
+#elif defined(CONFIG_DYNAMIC_PRINTK)
+extern void dynamic_printk(char *, char *, ...);
+extern int dynamic_debug_on;
+#define dev_dbg(dev, format, ...) do {				    	     \
+	if (unlikely(dynamic_debug_on))					     \
+		dynamic_printk(KBUILD_MODNAME,				     \
+				KERN_DEBUG KBUILD_MODNAME ": %s %s: " format,\
+				dev_driver_string(dev), (dev)->bus_id,	     \
+				##__VA_ARGS__);				     \
+	} while (0)
 #else
 #define dev_dbg(dev, format, arg...)		\
 	({ if (0) dev_printk(KERN_DEBUG, dev, format, ##arg); 0; })
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index cd6d02c..1895331 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -292,6 +292,15 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 /* If you are writing a driver, please use dev_dbg instead */
 #define pr_debug(fmt, arg...) \
 	printk(KERN_DEBUG fmt, ##arg)
+#elif defined(CONFIG_DYNAMIC_PRINTK)
+extern void dynamic_printk(char *, char *, ...);
+extern int dynamic_debug_on;
+#define pr_debug(fmt, ...) do { \
+	if (unlikely(dynamic_debug_on))				   \
+		dynamic_printk(KBUILD_MODNAME,			   \
+				KERN_DEBUG KBUILD_MODNAME ": " fmt,\
+				##__VA_ARGS__);			   \
+	} while (0)
 #else
 #define pr_debug(fmt, arg...) \
 	({ if (0) printk(KERN_DEBUG fmt, ##arg); 0; })
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 623ef24..63e5229 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -632,6 +632,46 @@ config FIREWIRE_OHCI_REMOTE_DMA
 
 	  If unsure, say N.
 
+config DYNAMIC_PRINTK
+	bool "Enable dynamic printk() call support"
+	default n
+	depends on PRINTK
+	help
+	  
+	  Allows pr_debug() and dev_dbg() calls to be dynamically enabled based
+	  upon their source module. Traditionally, these calls are only
+	  enabled if one set #define DEBUG and recompiled the kernel. This
+	  option obviates time consuming re-compiles.
+
+	  The impact of this compile option is a larger kerenl text size ~1%.
+	  However, if CONFIG_IMMEDIATE is set, the run-time impact is 
+	  negligible. Without CONFIG_IMMEDIATE set, a global variable is
+	  referenced for each pr_debug() and dev_dbg() calls.
+
+	  Usage:
+
+	  The printing of pr_debug() and dev_dbg() is controlled by the
+	  debugfs file, dynamic_printk/modules. This file contains a list of
+	  the active modules. To add and remove modules:
+
+		echo "add <module_name>" > dynamic_printk/modules
+		echo "remove <module_name>" > dynamic_printk/modules
+
+	  For example:
+
+		 echo "add kobject" > dynamic_printk/modules
+		 /sbin/modprobe <module>
+	
+	  This will cause kobject debug messages to spew out. Also, a special 
+	  "all" value will print all pr_debug() and dev_dbg() calls. I.e.:
+
+		echo "add all" > dynamic_printk/modules
+		echo "remove all" > dynamic_printk/modules
+
+	  Finally, passing "dynamic_printk" at the command line enables all
+	  pr_debug() and dev_dbg() call to come out (same as "all"). This mode
+	  can be disabled via a "remove all".
+	
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
diff --git a/lib/Makefile b/lib/Makefile
index bf8000f..5916731 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -66,6 +66,8 @@ obj-$(CONFIG_SWIOTLB) += swiotlb.o
 obj-$(CONFIG_IOMMU_HELPER) += iommu-helper.o
 obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
 
+obj-$(CONFIG_DYNAMIC_PRINTK) += dynamic_printk.o
+
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
 obj-$(CONFIG_HAVE_LMB) += lmb.o
diff --git a/lib/dynamic_printk.c b/lib/dynamic_printk.c
new file mode 100644
index 0000000..7fab61f
--- /dev/null
+++ b/lib/dynamic_printk.c
@@ -0,0 +1,251 @@
+/*
+ * lib/dynamic_printk.c
+ *
+ * make pr_debug()/dev_dbg() calls runtime configurable based upon their
+ * their source module.
+ *
+ * Copyright (C) 2008 Red Hat, Inc., Jason Baron <jbaron@redhat.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
+#include <linux/fs.h>
+#include <linux/hash.h>
+
+#define FILE_HASH_BITS 5
+#define FILE_TABLE_SIZE (1 << FILE_HASH_BITS)
+
+int dynamic_debug_on;
+EXPORT_SYMBOL_GPL(dynamic_debug_on);
+static int all;
+static struct hlist_head module_table[FILE_TABLE_SIZE] =
+	{ [0 ... FILE_TABLE_SIZE-1] = HLIST_HEAD_INIT };
+static DECLARE_MUTEX(debug_list_mutex);
+static int nr_entries;
+
+struct debug_name {
+	struct hlist_node hlist;
+	char *name;
+};
+
+static inline unsigned int name_hash(char *name)
+{
+	unsigned int hash = full_name_hash(name, strlen(name));
+	return (hash & ((1 << FILE_HASH_BITS) - 1));
+}
+
+static struct debug_name *find_debug_file(char *module_name)
+{
+	int found = 0;
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct debug_name *element;
+
+	head = &module_table[name_hash(module_name)];
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(element, node, head, hlist) {
+		if (!strcmp(element->name, module_name)) {
+			found = 1;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	if (found)
+		return element;
+	return NULL;
+}
+
+static int add_debug_file(char *module_name)
+{
+	struct debug_name *new;
+
+	if (find_debug_file(module_name))
+		return -EINVAL;
+	new = kmalloc(sizeof(struct debug_name), GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+	INIT_HLIST_NODE(&new->hlist);
+	new->name = module_name;
+	hlist_add_head_rcu(&new->hlist,
+			&module_table[name_hash(new->name)]);
+	nr_entries++;
+	return 0;
+}
+
+static int remove_debug_file(char *module_name)
+{
+	struct debug_name *element;
+
+	element = find_debug_file(module_name);
+	if (element == NULL)
+		return -EINVAL;
+	hlist_del_rcu(&element->hlist);
+	synchronize_rcu();
+	kfree(element->name);
+	kfree(element);
+	nr_entries--;
+	return 0;
+}
+
+void dynamic_printk(char *module_name, char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	if (all)
+		vprintk(fmt, args);
+	else {
+		if (find_debug_file(module_name))
+			vprintk(fmt, args);
+	}
+	va_end(args);
+}
+EXPORT_SYMBOL_GPL(dynamic_printk);
+
+static ssize_t pr_debug_write(struct file *file, const char __user *buf,
+				size_t length, loff_t *ppos)
+{
+	char *buffer, *module_name, *s;
+	int err;
+
+	if (!buf || length > PAGE_SIZE || length < 0)
+		return -EINVAL;
+
+	buffer = (char *)__get_free_page(GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+
+	err = -EFAULT;
+	if (copy_from_user(buffer, buf, length))
+		goto out;
+
+	err = -EINVAL;
+	if (length < PAGE_SIZE)
+		buffer[length] = '\0';
+	else if (buffer[PAGE_SIZE-1])
+		goto out;
+
+	err = -EINVAL;
+	down(&debug_list_mutex);
+	if (!strncmp("add all", buffer, 7)) {
+		if (!all && (nr_entries == 0))
+			dynamic_debug_on = 1;
+		all = 1;
+		err = 0;
+	} else if (!strncmp("remove all", buffer, 10)) {
+		if (all && (nr_entries == 0))
+			dynamic_debug_on = 0;
+		all = 0;
+		err = 0;
+	} else if (!strncmp("add ", buffer, 4)) {
+		s = strstrip(buffer + 4);
+		module_name = kmalloc(strlen(s) + 1, GFP_KERNEL);
+		if (!module_name) {
+			err = -ENOMEM;
+			goto out_up;
+		}
+		module_name = strcpy(module_name, s);
+		err = add_debug_file(module_name);
+		if (err && err != -ENOMEM)
+			kfree(module_name);
+		if (!err && (nr_entries == 1) && !all)
+			dynamic_debug_on = 1;
+	} else if (!strncmp("remove ", buffer, 7)) {
+		s = strstrip(buffer + 7);
+		err = remove_debug_file(s);
+		if (!err && (nr_entries == 0) && !all)
+			dynamic_debug_on = 0;
+	}
+	if (!err)
+		err = length;
+out_up:
+	up(&debug_list_mutex);
+out:
+	free_page((unsigned long)buffer);
+	return err;
+}
+
+static void *pr_debug_seq_start(struct seq_file *f, loff_t *pos)
+{
+	return (*pos < FILE_TABLE_SIZE) ? pos : NULL;
+}
+
+static void *pr_debug_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	(*pos)++;
+	if (*pos >= FILE_TABLE_SIZE)
+		return NULL;
+	return pos;
+}
+
+static void pr_debug_seq_stop(struct seq_file *s, void *v)
+{
+	/* Nothing to do */
+}
+
+static int pr_debug_seq_show(struct seq_file *s, void *v)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct debug_name *element;
+	unsigned int i = *(loff_t *) v;
+
+	if (i == 0 && all)
+		seq_printf(s, "all\n");
+	rcu_read_lock();
+	head = &module_table[i];
+	hlist_for_each_entry_rcu(element, node, head, hlist)
+		seq_printf(s, "%s\n", element->name);
+	rcu_read_unlock();
+	return 0;
+}
+
+static struct seq_operations pr_debug_seq_ops = {
+	.start = pr_debug_seq_start,
+	.next  = pr_debug_seq_next,
+	.stop  = pr_debug_seq_stop,
+	.show  = pr_debug_seq_show
+};
+
+static int pr_debug_open(struct inode *inode, struct file *filp)
+{
+	return seq_open(filp, &pr_debug_seq_ops);
+}
+
+static const struct file_operations pr_debug_operations = {
+	.open           = pr_debug_open,
+	.read           = seq_read,
+	.write          = pr_debug_write,
+	.llseek         = seq_lseek,
+	.release        = seq_release,
+};
+
+int __init dynamic_printk_init(void)
+{
+	struct dentry *dir, *file;
+
+	dir = debugfs_create_dir("dynamic_printk", NULL);
+	if (!dir)
+		return -ENOMEM;
+	file = debugfs_create_file("modules", 0644, dir, NULL,
+					&pr_debug_operations);
+	if (!file) {
+		debugfs_remove(dir);
+		return -ENOMEM;
+	}
+	return 0;
+}
+__initcall(dynamic_printk_init);
+
+static int __init dynamic_printk_setup(char *str)
+{
+	if (str)
+		return -ENOENT;
+	all = 1;
+	dynamic_debug_on = 1;
+	return 0;
+}
+early_param("dynamic_printk", dynamic_printk_setup);
