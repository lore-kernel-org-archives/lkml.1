Return-Path: <linux-kernel-owner+w=401wt.eu-S1765562AbYEVVRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765562AbYEVVRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765079AbYEVVQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:16:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764939AbYEVVQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:16:37 -0400
Date: Thu, 22 May 2008 17:14:53 -0400
From: Jason Baron <jbaron@redhat.com>
To: akpm@linux-foundation.org, joe@perches.com, greg@kroah.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] debug printk infrastructure -base patch
Message-ID: <20080522211453.GB28070@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/asm-generic/vmlinux.lds.h |   14 ++-
 include/linux/device.h            |   16 ++
 include/linux/dynamic_printk.h    |   44 +++++
 include/linux/kernel.h            |   16 ++
 include/linux/module.h            |    5 +
 kernel/module.c                   |   20 +++
 lib/Kconfig.debug                 |   46 +++++
 lib/Makefile                      |    2 +
 lib/dynamic_printk.c              |  327 +++++++++++++++++++++++++++++++++++++
 9 files changed, 489 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/dynamic_printk.h
 create mode 100644 lib/dynamic_printk.c

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f054778..9516de4 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -168,6 +168,18 @@
 		*(__ksymtab_strings)					\
 	}								\
 									\
+	/* dynamic printk sections: strings */				\
+	__verbose_strings : AT(ADDR(__verbose_strings) - LOAD_OFFSET) { \
+		*(__verbose_strings)					\
+	}								\
+									\
+	/* dynamic printk sections: strings */				\
+	__verbose : AT(ADDR(__verbose) - LOAD_OFFSET) { 		\
+		VMLINUX_SYMBOL(__start___verbose) = .;			\
+		*(__verbose)						\
+		VMLINUX_SYMBOL(__stop___verbose) = .;			\
+	}								\
+									\
 	/* __*init sections */						\
 	__init_rodata : AT(ADDR(__init_rodata) - LOAD_OFFSET) {		\
 		*(.ref.rodata)						\
diff --git a/include/linux/device.h b/include/linux/device.h
index 1a06026..8f3ca1f 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -595,6 +595,22 @@ extern const char *dev_driver_string(struct device *dev);
 #ifdef DEBUG
 #define dev_dbg(dev, format, arg...)		\
 	dev_printk(KERN_DEBUG , dev , format , ## arg)
+#elif defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
+#define dev_dbg(dev, format, ...) do {				    	     \
+	static char bar[]						     \
+	__attribute__((section("__verbose_strings")))			     \
+	 = KBUILD_MODNAME;						     \
+	static struct mod_debug foobar					     \
+	__used								     \
+	__attribute__((section("__verbose"), unused)) =			     \
+	{ bar };							     \
+	int hash = dynamic_name_hash(KBUILD_MODNAME);			     \
+	if (dynamic_printk_enabled[smp_processor_id()] & (1 << hash))	     \
+		dynamic_printk(KBUILD_MODNAME,				     \
+				KERN_DEBUG KBUILD_MODNAME ": %s %s: " format,\
+				dev_driver_string(dev), (dev)->bus_id,	     \
+				##__VA_ARGS__);				     \
+	} while (0)
 #else
 #define dev_dbg(dev, format, arg...)		\
 	({ if (0) dev_printk(KERN_DEBUG, dev, format, ##arg); 0; })
diff --git a/include/linux/dynamic_printk.h b/include/linux/dynamic_printk.h
new file mode 100644
index 0000000..b1afef3
--- /dev/null
+++ b/include/linux/dynamic_printk.h
@@ -0,0 +1,44 @@
+#ifndef _DYNAMIC_PRINTK_H
+#define _DYNAMIC_PRINTK_H
+
+#ifdef __KERNEL__
+
+#include <linux/string.h>
+
+#define DYNAMIC_HASH_BITS 5
+#define FILE_TABLE_SIZE (1 << DYNAMIC_HASH_BITS)
+
+struct mod_debug {
+	char *modname;
+};
+
+void add_module(char *);
+int remove_module(char *);
+
+extern int dynamic_printk_enabled[];
+extern void dynamic_printk(char *, char *, ...);
+
+static inline unsigned long
+dynamic_partial_name_hash(unsigned long c, unsigned long prevhash)
+{
+        return (prevhash + (c << 4) + (c >> 4)) * 11;
+}
+
+
+static inline unsigned int
+dynamic_full_name_hash(const unsigned char *name, unsigned int len)
+{
+        unsigned long hash = 0;
+        while (len--)
+                hash = dynamic_partial_name_hash(*name++, hash);
+        return hash;
+}
+
+static inline unsigned int dynamic_name_hash(char *name)
+{
+        unsigned int hash = dynamic_full_name_hash(name, strlen(name));
+        return (hash & ((1 << DYNAMIC_HASH_BITS) - 1));
+}
+
+#endif
+#endif
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index cd6d02c..8acf1fc 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -14,6 +14,7 @@
 #include <linux/compiler.h>
 #include <linux/bitops.h>
 #include <linux/log2.h>
+#include <linux/dynamic_printk.h>
 #include <asm/byteorder.h>
 #include <asm/bug.h>
 
@@ -292,6 +293,21 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 /* If you are writing a driver, please use dev_dbg instead */
 #define pr_debug(fmt, arg...) \
 	printk(KERN_DEBUG fmt, ##arg)
+#elif defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
+#define pr_debug(fmt, ...) do { \
+	static char bar[]	           		   	   \
+	__attribute__((section("__verbose_strings")))		   \
+	 = KBUILD_MODNAME;					   \
+	static struct mod_debug foobar 	   		   	   \
+	__used							   \
+	__attribute__((section("__verbose"), unused)) =		   \
+	{ bar };			   			   \
+	int hash = dynamic_name_hash(KBUILD_MODNAME);		   \
+	if (dynamic_printk_enabled[smp_processor_id()] & (1 << hash)) \
+		dynamic_printk(KBUILD_MODNAME,			   \
+				KERN_DEBUG KBUILD_MODNAME ": " fmt,\
+				##__VA_ARGS__);			   \
+	} while (0)						   
 #else
 #define pr_debug(fmt, arg...) \
 	({ if (0) printk(KERN_DEBUG fmt, ##arg); 0; })
diff --git a/include/linux/module.h b/include/linux/module.h
index 819c4e8..5536f2d 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -16,6 +16,7 @@
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
 #include <linux/marker.h>
+#include <linux/dynamic_printk.h>
 #include <asm/local.h>
 
 #include <asm/module.h>
@@ -359,6 +360,10 @@ struct module
 	struct marker *markers;
 	unsigned int num_markers;
 #endif
+#ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
+	struct mod_debug *verbose;
+	unsigned int num_verbose;
+#endif
 };
 #ifndef MODULE_ARCH_INIT
 #define MODULE_ARCH_INIT {}
diff --git a/kernel/module.c b/kernel/module.c
index 8d6cccc..2dd2ef6 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -42,6 +42,7 @@
 #include <linux/string.h>
 #include <linux/mutex.h>
 #include <linux/unwind.h>
+#include <linux/dynamic_printk.h>
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
 #include <linux/license.h>
@@ -744,6 +745,9 @@ sys_delete_module(const char __user *name_user, unsigned int flags)
 	}
 	/* Store the name of the last unloaded module for diagnostic purposes */
 	strlcpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));
+#ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
+	remove_module(mod->name);	
+#endif
 	free_module(mod);
 
  out:
@@ -1717,6 +1721,9 @@ static struct module *load_module(void __user *umod,
 	unsigned int unusedgplcrcindex;
 	unsigned int markersindex;
 	unsigned int markersstringsindex;
+	unsigned int verboseindex;
+	unsigned int verbosestringsindex;
+	struct mod_debug *iter;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -1993,6 +2000,9 @@ static struct module *load_module(void __user *umod,
 	markersindex = find_sec(hdr, sechdrs, secstrings, "__markers");
  	markersstringsindex = find_sec(hdr, sechdrs, secstrings,
 					"__markers_strings");
+	verboseindex = find_sec(hdr, sechdrs, secstrings, "__verbose");
+	verbosestringsindex = find_sec(hdr, sechdrs, secstrings,
+					"__verbose_strings");
 
 	/* Now do relocations. */
 	for (i = 1; i < hdr->e_shnum; i++) {
@@ -2020,6 +2030,11 @@ static struct module *load_module(void __user *umod,
 	mod->num_markers =
 		sechdrs[markersindex].sh_size / sizeof(*mod->markers);
 #endif
+#ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
+	mod->verbose = (void *)sechdrs[verboseindex].sh_addr;
+	mod->num_verbose =
+		sechdrs[verboseindex].sh_size / sizeof(*mod->verbose);
+#endif
 
         /* Find duplicate symbols */
 	err = verify_export_symbols(mod);
@@ -2043,6 +2058,11 @@ static struct module *load_module(void __user *umod,
 		marker_update_probe_range(mod->markers,
 			mod->markers + mod->num_markers);
 #endif
+#ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
+	for (iter = mod->verbose; iter < mod->verbose+mod->num_verbose; iter++) {
+		add_module(iter->modname);
+        }
+#endif
 	err = module_finalize(hdr, sechdrs, mod);
 	if (err < 0)
 		goto cleanup;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 623ef24..a6f6d8f 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -632,6 +632,52 @@ config FIREWIRE_OHCI_REMOTE_DMA
 
 	  If unsure, say N.
 
+config PRINTK_DEBUG
+	bool "Enable centralized debug printk() call support"
+	default n
+	depends on PRINTK
+
+config DYNAMIC_PRINTK_DEBUG
+	bool "Enable dynamic printk() call support"
+	default n
+	depends on PRINTK
+	select PRINTK_DEBUG
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
index bf8000f..ff1e3eb 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -66,6 +66,8 @@ obj-$(CONFIG_SWIOTLB) += swiotlb.o
 obj-$(CONFIG_IOMMU_HELPER) += iommu-helper.o
 obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
 
+obj-$(CONFIG_PRINTK_DEBUG) += dynamic_printk.o
+
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
 obj-$(CONFIG_HAVE_LMB) += lmb.o
diff --git a/lib/dynamic_printk.c b/lib/dynamic_printk.c
new file mode 100644
index 0000000..3eaf874
--- /dev/null
+++ b/lib/dynamic_printk.c
@@ -0,0 +1,327 @@
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
+#include <linux/dynamic_printk.h>
+
+extern struct mod_debug __start___verbose[];
+extern struct mod_debug __stop___verbose[];
+
+static int num_enabled;
+static struct hlist_head module_table[FILE_TABLE_SIZE] =
+	{ [0 ... FILE_TABLE_SIZE-1] = HLIST_HEAD_INIT };
+static DECLARE_MUTEX(debug_list_mutex);
+static int nr_entries;
+
+int dynamic_printk_enabled[NR_CPUS];
+EXPORT_SYMBOL_GPL(dynamic_printk_enabled);
+
+struct debug_name {
+	struct hlist_node hlist;
+	char *name;
+	unsigned int num_uses;
+	int enable;
+	int flags;
+	int level;
+	int ratelimit;
+};
+
+static struct debug_name *find_debug_file(char *module_name)
+{
+	int found = 0;
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct debug_name *element;
+
+	head = &module_table[dynamic_name_hash(module_name)];
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
+	new = kzalloc(sizeof(struct debug_name), GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+	INIT_HLIST_NODE(&new->hlist);
+	new->name = module_name;
+	hlist_add_head_rcu(&new->hlist,
+			&module_table[dynamic_name_hash(new->name)]);
+	nr_entries++;
+	return 0;
+}
+
+void add_module(char *mod_name)
+{
+	struct debug_name *elem;
+	char *module_name;
+
+	module_name = kmalloc(strlen(mod_name) + 1, GFP_KERNEL);
+	module_name = strcpy(module_name, mod_name);
+	module_name[strlen(mod_name)] = '\0';
+	/* add error checking */
+	down(&debug_list_mutex);
+	add_debug_file(module_name);
+	elem = find_debug_file(module_name);
+	elem->num_uses++;
+	up(&debug_list_mutex);
+}
+EXPORT_SYMBOL_GPL(add_module);
+
+int remove_debug_file(char *module_name)
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
+int remove_module(char *mod_name)
+{
+	down(&debug_list_mutex);
+	remove_debug_file(mod_name);
+	up(&debug_list_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(remove_module);
+
+#ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
+
+void dynamic_printk(char *module_name, char *fmt, ...)
+{
+	va_list args;
+	struct debug_name *elem;
+
+	va_start(args, fmt);
+	if (elem = find_debug_file(module_name)) {
+		if (elem->enable)
+			vprintk(fmt, args);
+	}
+	va_end(args);
+}
+EXPORT_SYMBOL_GPL(dynamic_printk);
+
+static void set_all(int enable) 
+{	
+	struct debug_name *e;
+	struct hlist_node *node;		
+	int i, cpu, enable_mask;
+
+	for (i = 0; i < FILE_TABLE_SIZE; i++) {
+		if (module_table[i].first != NULL) {
+			hlist_for_each_entry(e, node, &module_table[i], hlist) {
+				e->enable = enable;
+			}
+		}
+	}
+	if (enable)
+		enable_mask = UINT_MAX;
+	else
+		enable_mask = 0;
+	for (i = 0; i < NR_CPUS; i++)
+		dynamic_printk_enabled[i] = enable_mask;
+}
+
+#define enable_all() set_all(1)
+#define disable_all() set_all(0)
+
+static int disabled_hash(int i)
+{
+	struct debug_name *e;
+	struct hlist_node *node;	
+
+	hlist_for_each_entry(e, node, &module_table[i], hlist) {
+		if (e->enable)
+			return 0;
+	}
+	return 1;
+}
+
+static ssize_t pr_debug_write(struct file *file, const char __user *buf,
+				size_t length, loff_t *ppos)
+{
+	char *buffer, *s;
+	int err, hash, i;
+	struct debug_name *elem;
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
+	if (!strncmp("enable all", buffer, 10)) {
+		if (nr_entries) {
+			enable_all();
+			num_enabled = nr_entries;
+			err = 0;
+		}
+	} else if (!strncmp("disable all", buffer, 11)) {
+		disable_all();
+		num_enabled = 0;
+		err = 0;
+	} else if (!strncmp("enable ", buffer, 7)) {
+		s = strstrip(buffer + 7);
+		if (elem = find_debug_file(s)) {
+			if (elem->enable == 0) {
+				hash = dynamic_name_hash(s);
+				for (i = 0; i < NR_CPUS; i++)
+					dynamic_printk_enabled[i] |= (1 << hash);
+				elem->enable = 1;
+				num_enabled++;
+			}
+			err = 0;
+		}	
+	} else if (!strncmp("disable ", buffer, 8)) {
+		s = strstrip(buffer + 8);
+		if (elem = find_debug_file(s)) {
+			if (elem->enable == 1) {
+				elem->enable = 0;
+				num_enabled--;
+				if (disabled_hash(dynamic_name_hash(s))) {
+					for (i = 0; i < NR_CPUS; i++)
+						dynamic_printk_enabled[i] |= ~(1 << hash);
+				}
+			}
+			err = 0;
+		}
+	}
+	if (!err)
+		err = length;
+
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
+	rcu_read_lock();
+	head = &module_table[i];
+	hlist_for_each_entry_rcu(element, node, head, hlist)
+		seq_printf(s, "%s %d %d\n", element->name, element->enable,
+				 element->num_uses);
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
+	struct mod_debug *iter;
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
+	for (iter = __start___verbose; iter < __stop___verbose; iter++) {
+		add_module(iter->modname);
+	}
+	return 0;
+}
+__initcall(dynamic_printk_init);
+
+static int __init dynamic_printk_setup(char *str)
+{
+	if (str)
+		return -ENOENT;
+	set_all(1);
+	return 0;
+}
+early_param("dynamic_printk", dynamic_printk_setup);
+
+#endif /* CONFIG_DYNAMIC_PRINTK_DEBUG */
-- 
1.5.4.5

