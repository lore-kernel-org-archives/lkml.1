Return-Path: <linux-kernel-owner+w=401wt.eu-S1762607AbYGOVnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762607AbYGOVnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761296AbYGOVmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:42:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759164AbYGOVmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:42:51 -0400
Date: Tue, 15 Jul 2008 17:31:08 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, joe@perches.com, greg@kroah.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: [PATCH 1/7] dynamic debug v2 - infrastructure
Message-ID: <20080715213108.GB23331@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-infrastructure patch

Signed-off-by: Jason Baron <jbaron@redhat.com>

---

 Documentation/kernel-parameters.txt |    5 
 include/asm-generic/vmlinux.lds.h   |   10 -
 include/linux/device.h              |    6 
 include/linux/dynamic_printk.h      |  161 +++++++++
 include/linux/kernel.h              |   31 ++
 include/linux/module.h              |    4 
 kernel/module.c                     |   23 +
 lib/Kconfig.debug                   |   79 +++++
 lib/Makefile                        |    2 
 lib/dynamic_printk.c                |  599 +++++++++++++++++++++++++++++++++++
 net/netfilter/nf_conntrack_pptp.c   |    2 
 scripts/Makefile.lib                |   11 +
 scripts/basic/Makefile              |    2 
 scripts/basic/hash.c                |   60 ++++
 14 files changed, 986 insertions(+), 9 deletions(-)
 create mode 100644 include/linux/dynamic_printk.h
 create mode 100644 lib/dynamic_printk.c
 create mode 100644 scripts/basic/hash.c


diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index bf6303e..d9a1245 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1580,6 +1580,11 @@ and is between 256 and 4096 characters. It is defined in the file
 			autoconfiguration.
 			Ranges are in pairs (memory base and size).
 
+	dynamic_printk
+			Enables pr_debug()/dev_dbg() calls if 
+			CONFIG_PRINK_DYNAMIC has been enabled. These can also 
+			be switched on/off via <debugfs>/dynamic_printk/modules
+
 	print-fatal-signals=
 			[KNL] debug: print fatal signals
 			print-fatal-signals=1: print segfault info to
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f054778..799a8b5 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -167,7 +167,6 @@
         __ksymtab_strings : AT(ADDR(__ksymtab_strings) - LOAD_OFFSET) {	\
 		*(__ksymtab_strings)					\
 	}								\
-									\
 	/* __*init sections */						\
 	__init_rodata : AT(ADDR(__init_rodata) - LOAD_OFFSET) {		\
 		*(.ref.rodata)						\
@@ -249,7 +248,14 @@
 	CPU_DISCARD(init.data)						\
 	CPU_DISCARD(init.rodata)					\
 	MEM_DISCARD(init.data)						\
-	MEM_DISCARD(init.rodata)
+	MEM_DISCARD(init.rodata)					\
+	VMLINUX_SYMBOL(__start___verbose_strings) = .;                  \
+	*(__verbose_strings)                                            \
+	VMLINUX_SYMBOL(__stop___verbose_strings) = .;                   \
+	. = ALIGN(8);							\
+	VMLINUX_SYMBOL(__start___verbose) = .;                          \
+	*(__verbose)                                                    \
+	VMLINUX_SYMBOL(__stop___verbose) = .;
 
 #define INIT_TEXT							\
 	*(.init.text)							\
diff --git a/include/linux/device.h b/include/linux/device.h
index 1a06026..fb03dbc 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -592,7 +592,11 @@ extern const char *dev_driver_string(struct device *dev);
 #define dev_info(dev, format, arg...)		\
 	dev_printk(KERN_INFO , dev , format , ## arg)
 
-#ifdef DEBUG
+#if defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
+#define dev_dbg(dev, format, ...) do { \
+	dynamic_dev_dbg(dev, format, ##__VA_ARGS__); \
+	} while (0)
+#elif defined(DEBUG)
 #define dev_dbg(dev, format, arg...)		\
 	dev_printk(KERN_DEBUG , dev , format , ## arg)
 #else
diff --git a/include/linux/dynamic_printk.h b/include/linux/dynamic_printk.h
new file mode 100644
index 0000000..4ed0c14
--- /dev/null
+++ b/include/linux/dynamic_printk.h
@@ -0,0 +1,161 @@
+#ifndef _DYNAMIC_PRINTK_H
+#define _DYNAMIC_PRINTK_H
+
+#ifdef __KERNEL__
+
+#include <linux/string.h>
+#include <linux/hash.h>
+
+#define DYNAMIC_DEBUG_HASH_BITS 6
+#define DEBUG_HASH_TABLE_SIZE (1 << DYNAMIC_DEBUG_HASH_BITS)
+
+#define TYPE_BOOLEAN 0
+#define TYPE_LEVEL 1
+#define TYPE_FLAG 2
+
+#define DYNAMIC_ENABLED_ALL 0
+#define DYNAMIC_ENABLED_NONE 1
+#define DYNAMIC_ENABLED_SOME 2
+
+extern int dynamic_enabled;
+extern long long dynamic_printk_enabled;
+extern long long dynamic_printk_enabled2;
+
+struct mod_debug {
+	char *modname;
+	char *logical_modname;
+	char *type;
+	char *num_flags;
+	char *flag_names;
+} __attribute__((aligned(8)));
+
+static inline unsigned int dynamic_djb2_hash(char *str)
+{
+	unsigned long hash = 5381;
+	int c;
+
+	c = *str;
+	while (c) {
+		hash = ((hash << 5) + hash) + c;
+		c = *++str;
+	}
+	return (unsigned int)(hash & ((1 << DYNAMIC_DEBUG_HASH_BITS) - 1));
+}
+
+static inline unsigned int dynamic_r5_hash(char *str)
+{
+	unsigned long hash = 0;
+	int c;
+
+	c = *str;
+	while (c) {
+		hash = (hash + (c << 4) + (c >> 4)) * 11;
+		c = *++str;
+	}
+	return (unsigned int)(hash & ((1 << DYNAMIC_DEBUG_HASH_BITS) - 1));
+}
+
+int register_debug_module(char *mod_name, int type, char *share_name,
+				int num_flags, char *flags);
+
+#if defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
+extern int unregister_debug_module(char *mod_name);
+int __dynamic_dbg_enabled_helper(char *modname, int type, int value, int level);
+
+#define __dynamic_dbg_enabled(module, type, value, level)  ({		  \
+	int ret = 0;							  \
+	if (dynamic_enabled == DYNAMIC_ENABLED_NONE)			  \
+		ret = 0;						  \
+	else if (dynamic_enabled == DYNAMIC_ENABLED_ALL)		  \
+		ret = 1;						  \
+	else {								  \
+		if ((dynamic_printk_enabled & (1LL << DEBUG_HASH)) &&	  \
+			(dynamic_printk_enabled2 & (1LL << DEBUG_HASH2))) \
+			ret = __dynamic_dbg_enabled_helper(module, type, value,\
+								    level);\
+	}								   \
+	ret; })
+
+#ifndef DYNAMIC_DEBUG_MODNAME
+#define DYNAMIC_DEBUG_MODNAME KBUILD_MODNAME
+#endif
+#ifndef DYNAMIC_DEBUG_NUM_FLAGS
+#define DYNAMIC_DEBUG_NUM_FLAGS "0"
+#endif
+#ifndef DYNAMIC_DEBUG_FLAG_NAMES
+#define DYNAMIC_DEBUG_FLAG_NAMES ""
+#endif
+#ifndef DYNAMIC_DEBUG_TYPE
+#define DYNAMIC_DEBUG_TYPE "0"
+#endif
+#define _dynamic_dbg_enabled(type, value, level)  ({	\
+	int ret;					\
+	static char mod_name[]				\
+	__attribute__((section("__verbose_strings")))	\
+	= KBUILD_MODNAME;				\
+	static char logical_mod_name[]			\
+	__attribute__((section("__verbose_strings")))	\
+	= DYNAMIC_DEBUG_MODNAME;			\
+	static char num_flags[]				\
+	__attribute__((section("__verbose_strings")))	\
+	= DYNAMIC_DEBUG_NUM_FLAGS;			\
+	static char flag_names[]			\
+	__attribute__((section("__verbose_strings")))	\
+	= DYNAMIC_DEBUG_FLAG_NAMES;			\
+	static char register_type[]			\
+	__attribute__((section("__verbose_strings")))	\
+	= DYNAMIC_DEBUG_TYPE;				\
+	static struct mod_debug descriptor		\
+	__used						\
+	__attribute__((section("__verbose"), aligned(8)))		       \
+	= { mod_name, logical_mod_name, register_type, num_flags, flag_names };\
+	ret = __dynamic_dbg_enabled(DYNAMIC_DEBUG_MODNAME, type, value, level);\
+	ret; })
+
+#define dynamic_pr_debug(fmt, ...) do {					\
+	static char mod_name[]						\
+	__attribute__((section("__verbose_strings")))			\
+	 = KBUILD_MODNAME;						\
+	static struct mod_debug descriptor				\
+	__used								\
+	__attribute__((section("__verbose"), aligned(8))) =		\
+	{ mod_name, mod_name, "0", "0", NULL };				\
+	if (__dynamic_dbg_enabled(KBUILD_MODNAME, TYPE_BOOLEAN, 0, 0))  \
+		printk(KERN_DEBUG KBUILD_MODNAME ":" fmt,		\
+				##__VA_ARGS__);				\
+	} while (0)
+
+#define dynamic_dev_dbg(dev, format, ...) do {				\
+	static char mod_name[]						\
+	__attribute__((section("__verbose_strings")))			\
+	 = KBUILD_MODNAME;						\
+	static struct mod_debug descriptor				\
+	__used								\
+	__attribute__((section("__verbose"), aligned(8))) =		\
+	{ mod_name, mod_name, "0", "0", NULL };				\
+	if (__dynamic_dbg_enabled(KBUILD_MODNAME, TYPE_BOOLEAN, 0, 0))	\
+			dev_printk(KERN_DEBUG, dev,			\
+					KBUILD_MODNAME ": " format,	\
+					##__VA_ARGS__);			\
+	} while (0)
+
+#else
+
+static inline int unregister_debug_module(const char *mod_name)
+{
+	return 0;
+}
+static inline int __dynamic_dbg_enabled_helper(char *modname, int type,
+						int value, int level)
+{
+	return 0;
+}
+
+#define __dynamic_dbg_enabled(module, type, value, level)  ({ 0; })
+#define _dynamic_dbg_enabled(type, value, level)  ({ 0; })
+#define dynamic_pr_debug(fmt, ...)  do { } while (0)
+#define dynamic_dev_dbg(dev, format, ...)  do { } while (0)
+#endif
+
+#endif
+#endif
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index cd6d02c..3f99327 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -14,6 +14,7 @@
 #include <linux/compiler.h>
 #include <linux/bitops.h>
 #include <linux/log2.h>
+#include <linux/dynamic_printk.h>
 #include <asm/byteorder.h>
 #include <asm/bug.h>
 
@@ -288,15 +289,39 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 #define pr_info(fmt, arg...) \
 	printk(KERN_INFO fmt, ##arg)
 
-#ifdef DEBUG
-/* If you are writing a driver, please use dev_dbg instead */
+#if defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
+#define pr_debug(fmt, ...) do { \
+	dynamic_pr_debug(fmt, ##__VA_ARGS__); \
+	} while (0)
+#elif defined(DEBUG)
 #define pr_debug(fmt, arg...) \
-	printk(KERN_DEBUG fmt, ##arg)
+	 printk(KERN_DEBUG fmt, ##arg)
 #else
 #define pr_debug(fmt, arg...) \
 	({ if (0) printk(KERN_DEBUG fmt, ##arg); 0; })
 #endif
 
+#if defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
+#define dynamic_dbg_enabled(call_type, value, level)  ({  \
+	int ret = _dynamic_dbg_enabled(call_type, value, level);\
+	ret; })
+#elif defined(DEBUG)
+#define dynamic_dbg_enabled(type, value, level) do { \
+	if (type == TYPE_LEVEL) {		 \
+		if (value < level)		 \
+			return 1;		 \
+	} else if (type == TYPE_FLAG) {		 \
+		if (value & level)		 \
+			return 1;		 \
+	} else if (type == TYPE_BOOLEAN)	 \
+		return 1;			 \
+	return 0;				 \
+	} while (0)
+#else
+#define dynamic_dbg_enabled(type, value, level) \
+	({ if (0) _dynamic_dbg_enabled(type, value, level); 0; })
+#endif
+
 /*
  *      Display an IP address in readable format.
  */
diff --git a/include/linux/module.h b/include/linux/module.h
index 819c4e8..74a2e32 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -359,6 +359,10 @@ struct module
 	struct marker *markers;
 	unsigned int num_markers;
 #endif
+#ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
+	struct mod_debug *start_verbose;
+	unsigned int num_verbose;
+#endif
 };
 #ifndef MODULE_ARCH_INIT
 #define MODULE_ARCH_INIT {}
diff --git a/kernel/module.c b/kernel/module.c
index 8d6cccc..5f36555 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -744,6 +744,7 @@ sys_delete_module(const char __user *name_user, unsigned int flags)
 	}
 	/* Store the name of the last unloaded module for diagnostic purposes */
 	strlcpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));
+	unregister_debug_module(mod->name);
 	free_module(mod);
 
  out:
@@ -1717,6 +1718,9 @@ static struct module *load_module(void __user *umod,
 	unsigned int unusedgplcrcindex;
 	unsigned int markersindex;
 	unsigned int markersstringsindex;
+	unsigned int verboseindex;
+	struct mod_debug *iter;
+	unsigned long value;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -1993,6 +1997,7 @@ static struct module *load_module(void __user *umod,
 	markersindex = find_sec(hdr, sechdrs, secstrings, "__markers");
  	markersstringsindex = find_sec(hdr, sechdrs, secstrings,
 					"__markers_strings");
+	verboseindex = find_sec(hdr, sechdrs, secstrings, "__verbose");
 
 	/* Now do relocations. */
 	for (i = 1; i < hdr->e_shnum; i++) {
@@ -2020,6 +2025,11 @@ static struct module *load_module(void __user *umod,
 	mod->num_markers =
 		sechdrs[markersindex].sh_size / sizeof(*mod->markers);
 #endif
+#ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
+	mod->start_verbose = (void *)sechdrs[verboseindex].sh_addr;
+	mod->num_verbose = sechdrs[verboseindex].sh_size /
+				sizeof(*mod->start_verbose);
+#endif
 
         /* Find duplicate symbols */
 	err = verify_export_symbols(mod);
@@ -2043,6 +2053,19 @@ static struct module *load_module(void __user *umod,
 		marker_update_probe_range(mod->markers,
 			mod->markers + mod->num_markers);
 #endif
+#ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
+	for (value = (unsigned long)mod->start_verbose;
+		value < (unsigned long)mod->start_verbose +
+		(unsigned long)(mod->num_verbose * sizeof(struct mod_debug));
+		value += sizeof(struct mod_debug)) {
+			iter = (struct mod_debug *)value;
+			register_debug_module(iter->modname,
+				simple_strtoul(iter->type, NULL, 10),
+				iter->logical_modname,
+				simple_strtoul(iter->num_flags, NULL, 10),
+				iter->flag_names);
+	}
+#endif
 	err = module_finalize(hdr, sechdrs, mod);
 	if (err < 0)
 		goto cleanup;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 623ef24..6f8d76e 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -632,6 +632,85 @@ config FIREWIRE_OHCI_REMOTE_DMA
 
 	  If unsure, say N.
 
+config DYNAMIC_PRINTK_DEBUG
+	bool "Enable dynamic printk() call support"
+	default n
+	depends on PRINTK
+	select PRINTK_DEBUG
+	help
+	 
+	  Compiles debug level messages into the kernel, which would not
+	  otherwise be available at runtime. These messages can then be
+	  enabled/disabled on a per module basis. This mechanism, implicitly 
+	  enables all pr_debug() and dev_dbg() calls. It also introduces a 
+	  'dynamic_dbg_enabled()' function which allows subsystems to implement 
+	  more complex dynamic debugging, including the use of per-subsystem 
+	  flags and and level controls. The impact of this compile option is a 
+	  larger kernel text size ~2%.
+
+	  Usage:
+
+	  Dynamic debugging is controlled by the debugfs file, 
+	  dynamic_printk/modules. This file contains a list of the modules that
+	  can be enabled. The format of the file is the module name, followed
+	  by a set of flags that can be enabled. The first flags is always the
+	  'enabled' flags. For example:
+
+		<module_name> <enabled=0/1> <level=[0-n]> <flag_name=0/1>....
+			<associated module names>
+				.
+				.
+				.
+
+	  <module_name> : Name of the module in which the debug call resides
+	  <enabled=0/1> : whether the the messages are enabled or not
+	  <level=[0-n]> : For modules that support levels
+	  <flag_name=0/1> : names of the flags that can be set
+	  <associated module names> : names of the modules that are part of 
+			group <module_name>
+
+	  From a live system:
+
+		snd_hda_intel enabled=0
+
+		fixup enabled=0
+
+		cpufreq_shared enabled=0 CPUFREQ_DEBUG_CORE=0 CPUFREQ_DEBUG_DRIVER=0 CPUFREQ_DEBUG_GOVERNOR=0
+        		acpi_cpufreq
+        		freq_table
+        		cpufreq_userspace
+        		cpufreq_performance
+        		cpufreq
+
+		driver enabled=0
+
+		dummy enabled=0
+
+		snd_seq enabled=0
+
+	  Enable a module:
+
+	  	$echo "set enabled=1 <module_name>" > dynamic_printk/modules
+
+	  Disable a module:
+
+	  	$echo "set enabled=0 <module_name>" > dynamic_printk/modules
+
+	  To set the level or flag value for type 'level' or 'flag': 
+
+	  	$echo "set level=<#> <module_name>" > dynamic_printk/modules
+
+	  Enable all modules:
+	
+		$echo "set enabled=1 all" > dynamic_printk/modules
+
+	  Disable all modules:
+
+		$echo "set enabled=0 all" > dynamic_printk/modules
+
+	  Finally, passing "dynamic_printk" at the command line enables all 
+	  modules. This mode can be turned off by disabling modules.
+	
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
diff --git a/lib/Makefile b/lib/Makefile
index bf8000f..78ab656 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -70,6 +70,8 @@ lib-$(CONFIG_GENERIC_BUG) += bug.o
 
 obj-$(CONFIG_HAVE_LMB) += lmb.o
 
+obj-$(CONFIG_DYNAMIC_PRINTK_DEBUG) += dynamic_printk.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff --git a/lib/dynamic_printk.c b/lib/dynamic_printk.c
new file mode 100644
index 0000000..326355d
--- /dev/null
+++ b/lib/dynamic_printk.c
@@ -0,0 +1,599 @@
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
+
+#define SHARING_NONE 0
+#define SHARING_MEMBER 1
+#define SHARING_LEADER 2
+
+extern struct mod_debug __start___verbose[];
+extern struct mod_debug __stop___verbose[];
+
+char *type_to_string[3] = {
+	"boolean",
+	"level",
+	"flag",
+};
+
+struct flags_descriptor {
+	int num;
+	char **flag_names;
+};
+
+struct debug_name {
+	struct hlist_node hlist;
+	struct hlist_node hlist2;
+	int hash1;
+	int hash2;
+	char *name;
+	int enable;
+	int type;
+	int level;
+	int ratelimit;
+	struct flags_descriptor *flags;
+	/* for sharing between modules */
+	int type_sharing;
+	struct debug_name *parent;
+	struct list_head shared_list;
+	int count;
+};
+
+static int num_enabled;
+int dynamic_enabled = DYNAMIC_ENABLED_NONE;
+EXPORT_SYMBOL_GPL(dynamic_enabled);
+static struct hlist_head module_table[DEBUG_HASH_TABLE_SIZE] =
+	{ [0 ... DEBUG_HASH_TABLE_SIZE-1] = HLIST_HEAD_INIT };
+static struct hlist_head module_table2[DEBUG_HASH_TABLE_SIZE] =
+	{ [0 ... DEBUG_HASH_TABLE_SIZE-1] = HLIST_HEAD_INIT };
+static DECLARE_MUTEX(debug_list_mutex);
+static int nr_entries;
+
+long long dynamic_printk_enabled;
+EXPORT_SYMBOL_GPL(dynamic_printk_enabled);
+long long dynamic_printk_enabled2;
+EXPORT_SYMBOL_GPL(dynamic_printk_enabled2);
+
+/* returns the debug module pointer. caller must locking */
+static struct debug_name *find_debug_module(char *module_name)
+{
+	int found = 0;
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct debug_name *element;
+
+	element = NULL;
+	head = &module_table[dynamic_djb2_hash(module_name)];
+	hlist_for_each_entry_rcu(element, node, head, hlist) {
+		if (!strcmp(element->name, module_name)) {
+			found = 1;
+			break;
+		}
+	}
+	if (found)
+		return element;
+	return NULL;
+}
+
+/* caller must hold mutex*/
+static int __add_debug_module(char *mod_name)
+{
+	struct debug_name *new;
+	char *module_name;
+	int ret = 0;
+
+	if (find_debug_module(mod_name)) {
+		ret = -EINVAL;
+		goto out;
+	}
+	module_name = kmalloc(strlen(mod_name) + 1, GFP_KERNEL);
+	if (!module_name) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	module_name = strcpy(module_name, mod_name);
+	module_name[strlen(mod_name)] = '\0';
+	new = kzalloc(sizeof(struct debug_name), GFP_KERNEL);
+	if (!new) {
+		kfree(module_name);
+		ret = -ENOMEM;
+		goto out;
+	}
+	INIT_HLIST_NODE(&new->hlist);
+	INIT_HLIST_NODE(&new->hlist2);
+	INIT_LIST_HEAD(&new->shared_list);
+	new->name = module_name;
+	new->hash1 = dynamic_djb2_hash(new->name);
+	new->hash2 = dynamic_r5_hash(new->name);
+	hlist_add_head_rcu(&new->hlist,
+				&module_table[dynamic_djb2_hash(new->name)]);
+	hlist_add_head_rcu(&new->hlist2,
+				&module_table2[dynamic_r5_hash(new->name)]);
+	nr_entries++;
+out:
+	return ret;
+}
+
+int add_debug_module(char *mod_name)
+{
+	int ret;
+
+	down(&debug_list_mutex);
+	ret = __add_debug_module(mod_name);
+	up(&debug_list_mutex);
+	return ret;
+}
+
+int unregister_debug_module(char *mod_name)
+{
+	struct debug_name *element;
+	struct debug_name *parent = NULL;
+	int ret = 0;
+	int i;
+
+	down(&debug_list_mutex);
+	element = find_debug_module(mod_name);
+	if (!element) {
+		ret = -EINVAL;
+		goto out;
+	}
+	hlist_del_rcu(&element->hlist);
+	hlist_del_rcu(&element->hlist2);
+	if (element->type_sharing == SHARING_MEMBER) {
+		list_del_rcu(&element->shared_list);
+		element->parent->count -= 1;
+		if (element->parent->count == 0) {
+			parent = element->parent;
+			hlist_del_rcu(&parent->hlist);
+			hlist_del_rcu(&parent->hlist2);
+		}
+	}
+	synchronize_rcu();
+	if (element->name)
+		kfree(element->name);
+	if (element->flags) {
+		for (i = 0; i < element->flags->num; i++)
+			kfree(element->flags->flag_names[i]);
+		kfree(element->flags->flag_names);
+		kfree(element->flags);
+	}
+	if (element->enable)
+		num_enabled--;
+	kfree(element);
+	if (parent) {
+		kfree(parent->name);
+		if (parent->flags) {
+			for (i = 0; i < element->flags->num; i++)
+				kfree(element->flags->flag_names[i]);
+			kfree(parent->flags->flag_names);
+			kfree(parent->flags);
+		}
+		if (parent->enable)
+			num_enabled--;
+		kfree(parent);
+		nr_entries--;
+	}
+	nr_entries--;
+out:
+	up(&debug_list_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(unregister_debug_module);
+
+int register_debug_module(char *mod_name, int type, char *share_name,
+				int num_flags, char *flags)
+{
+	struct debug_name *elem, *parent;
+	char *flag;
+	int i;
+
+	down(&debug_list_mutex);
+	elem = find_debug_module(mod_name);
+	if (!elem) {
+		__add_debug_module(mod_name);
+		elem = find_debug_module(mod_name);
+		if (dynamic_enabled == DYNAMIC_ENABLED_ALL &&
+				!strcmp(mod_name, share_name)) {
+			elem->enable = true;
+			num_enabled++;
+		}
+	}
+	if (strcmp(mod_name, share_name)) {
+		parent = find_debug_module(share_name);
+		if (!parent) {
+			__add_debug_module(share_name);
+			parent = find_debug_module(share_name);
+			parent->type_sharing = SHARING_LEADER;
+			parent->type = type;
+			if (dynamic_enabled == DYNAMIC_ENABLED_ALL) {
+				parent->enable = true;
+				num_enabled++;
+			}
+		}
+		parent->count += 1;
+		elem->parent = parent;
+		elem->type_sharing = SHARING_MEMBER;
+		list_add_rcu(&elem->shared_list, &parent->shared_list);
+	} else
+		elem->type = type;
+	if (num_flags > 0) {
+		if ((elem->type_sharing == SHARING_MEMBER) && elem->parent)
+			elem = elem->parent;
+		elem->flags = kzalloc(sizeof(struct flags_descriptor),
+					GFP_KERNEL);
+		elem->flags->flag_names = kmalloc(sizeof(char *) * num_flags,
+							GFP_KERNEL);
+		for (i = 0; i < num_flags; i++) {
+			flag = strsep(&flags, ",");
+			elem->flags->flag_names[i] = kstrdup(flag, GFP_KERNEL);
+		}
+		smp_wmb();
+		elem->flags->num = num_flags;
+	}
+	up(&debug_list_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(register_debug_module);
+
+int __dynamic_dbg_enabled_helper(char *mod_name, int type, int value, int level)
+{
+	struct debug_name *elem;
+	int ret = 0;
+
+	rcu_read_lock();
+	elem = find_debug_module(mod_name);
+	if (elem) {
+		if ((elem->type_sharing == SHARING_MEMBER) && elem->parent)
+			elem = elem->parent;
+		if (elem->enable) {
+			if (elem->type == TYPE_LEVEL) {
+				if (value < elem->level)
+					ret = 1;
+			} else if (elem->type == TYPE_FLAG) {
+				if (value & elem->level)
+					ret = 1;
+			} else if (elem->type == TYPE_BOOLEAN)
+				ret = 1;
+		}
+	}
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__dynamic_dbg_enabled_helper);
+
+static void set_all(bool enable)
+{
+	struct debug_name *e;
+	struct hlist_node *node;
+	int i;
+	long long enable_mask;
+
+	for (i = 0; i < DEBUG_HASH_TABLE_SIZE; i++) {
+		if (module_table[i].first != NULL) {
+			hlist_for_each_entry(e, node, &module_table[i], hlist) {
+				e->enable = enable;
+			}
+		}
+	}
+	if (enable)
+		enable_mask = ULLONG_MAX;
+	else
+		enable_mask = 0;
+	dynamic_printk_enabled = enable_mask;
+	dynamic_printk_enabled2 = enable_mask;
+}
+
+static int disabled_hash(int i)
+{
+       struct debug_name *e;
+       struct hlist_node *node;
+
+       hlist_for_each_entry(e, node, &module_table[i], hlist) {
+		if (e->enable)
+			return 0;
+       }
+       return 1;
+}
+
+static int disabled_hash2(int i)
+{
+       struct debug_name *e;
+       struct hlist_node *node;
+
+       hlist_for_each_entry(e, node, &module_table2[i], hlist2) {
+		if (e->enable)
+			return 0;
+       }
+       return 1;
+}
+
+static void set_children(bool enable, struct debug_name *parent)
+{
+	struct list_head *p;
+	struct debug_name *elem_shared;
+
+	if (parent->type_sharing == SHARING_LEADER) {
+		list_for_each_rcu(p, &parent->shared_list) {
+			elem_shared =
+				list_entry(p, struct debug_name, shared_list);
+			elem_shared->enable = enable;
+			if (enable) {
+				dynamic_printk_enabled |=
+						(1LL << elem_shared->hash1);
+				dynamic_printk_enabled2 |=
+						(1LL << elem_shared->hash2);
+			} else {
+				if (disabled_hash(elem_shared->hash1))
+					dynamic_printk_enabled |=
+						~(1LL << elem_shared->hash1);
+				if (disabled_hash2(elem_shared->hash2))
+					dynamic_printk_enabled2 |=
+						~(1LL << elem_shared->hash2);
+			}
+		}
+	}
+}
+
+static ssize_t pr_debug_write(struct file *file, const char __user *buf,
+				size_t length, loff_t *ppos)
+{
+	char *buffer, *s, *level, *value_str, *setting_str;
+	int err, hash, value, j;
+	struct debug_name *elem;
+	int all = 0;
+
+	if (length > PAGE_SIZE || length < 0)
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
+
+	if (strncmp("set", buffer, 3))
+		goto out_up;
+	s = buffer + 3;
+	setting_str = strsep(&s, "=");
+	if (s == NULL)
+		goto out_up;
+	setting_str = strstrip(setting_str);
+	value_str = strsep(&s, " ");
+	if (s == NULL)
+		goto out_up;
+	s = strstrip(s);
+	if (!strncmp(s, "all", 3))
+		all = 1;
+	else
+		elem = find_debug_module(s);
+	if (!strncmp(setting_str, "enable", 6)) {
+		value = !!simple_strtol(value_str, NULL, 10);
+		if (all) {
+			if (value) {
+				set_all(true);
+				num_enabled = nr_entries;
+				dynamic_enabled = DYNAMIC_ENABLED_ALL;
+			} else {
+				set_all(false);
+				num_enabled = 0;
+				dynamic_enabled = DYNAMIC_ENABLED_NONE;
+			}
+			err = 0;
+		} else {
+			if (elem && (elem->type_sharing != SHARING_MEMBER)) {
+				if (value && (elem->enable == 0)) {
+					hash = dynamic_djb2_hash(s);
+					dynamic_printk_enabled |=
+							(1LL << hash);
+					hash = dynamic_r5_hash(s);
+					dynamic_printk_enabled2 |=
+							(1LL << hash);
+					elem->enable = 1;
+					num_enabled++;
+					dynamic_enabled = DYNAMIC_ENABLED_SOME;
+					set_children(true, elem);
+					err = 0;
+				} else if (!value && (elem->enable == 1)) {
+					elem->enable = 0;
+					num_enabled--;
+					hash = dynamic_djb2_hash(s);
+					if (disabled_hash(hash))
+						dynamic_printk_enabled |=
+								~(1LL << hash);
+					hash = dynamic_r5_hash(s);
+					if (disabled_hash2(hash))
+						dynamic_printk_enabled2 |=
+								~(1LL << hash);
+					if (num_enabled)
+						dynamic_enabled =
+							DYNAMIC_ENABLED_SOME;
+					else
+						dynamic_enabled =
+							DYNAMIC_ENABLED_NONE;
+					set_children(false, elem);
+					err = 0;
+				}
+			}
+		}
+	} else if (!strncmp(setting_str, "level", 5)) {
+		elem = find_debug_module(s);
+		if (elem && (elem->type_sharing != SHARING_MEMBER)) {
+			if (elem->type == TYPE_LEVEL) {
+				elem->level =
+					simple_strtol(value_str, NULL, 10);
+				err = 0;
+			}
+		}
+	} else {
+		elem = find_debug_module(s);
+		if (elem && (elem->type_sharing != SHARING_MEMBER)) {
+			if ((elem->type == TYPE_FLAG) && elem->flags) {
+				value = !!simple_strtol(value_str, NULL, 10);
+				for (j = 0; j < elem->flags->num; j++) {
+					if (!strcmp(elem->flags->flag_names[j],
+								setting_str)) {
+						if (strstr(setting_str, "ALL")){
+							if (value)
+								elem->level =
+								UINT_MAX;
+							else
+								elem->level = 0;
+						} else {
+							if (value)
+								elem->level |=
+								       (1 << j);
+					 		else
+								elem->level |=
+								      ~(1 << j);
+						}
+						err = 0;
+					}
+				}
+			}
+		}
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
+	return (*pos < DEBUG_HASH_TABLE_SIZE) ? pos : NULL;
+}
+
+static void *pr_debug_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	(*pos)++;
+	if (*pos >= DEBUG_HASH_TABLE_SIZE)
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
+	struct debug_name *elem, *elem_shared;
+	struct list_head *p;
+	unsigned int i = *(loff_t *) v;
+	int j;
+
+	rcu_read_lock();
+	head = &module_table[i];
+	hlist_for_each_entry_rcu(elem, node, head, hlist) {
+		if (elem->type_sharing == SHARING_MEMBER)
+			continue;
+		seq_printf(s, "%s enabled=%d", elem->name, elem->enable);
+		if (elem->type == TYPE_LEVEL)
+			seq_printf(" level=%d", elem->level);
+		if ((elem->type == TYPE_FLAG) && elem->flags) {
+			for (j = 0; j < elem->flags->num; j++)
+				seq_printf(s, " %s=%d",
+						elem->flags->flag_names[j],
+						((elem->level >> j) & 1));
+		}
+		seq_printf(s, "\n");
+		if (elem->type_sharing == SHARING_LEADER) {
+			list_for_each_rcu(p, &elem->shared_list) {
+				elem_shared = list_entry(p, struct debug_name,
+								shared_list);
+				seq_printf(s, "\t%s\n", elem_shared->name);
+			}
+		}
+		seq_printf(s, "\n");
+	}
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
+	unsigned long value;
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
+	for (value = (unsigned long)__start___verbose;
+		value < (unsigned long)__stop___verbose;
+		value += sizeof(struct mod_debug)) {
+			iter = (struct mod_debug *)value;
+			register_debug_module(iter->modname,
+				simple_strtoul(iter->type, NULL, 10),
+				iter->logical_modname,
+				simple_strtoul(iter->num_flags, NULL, 10),
+				iter->flag_names);
+	}
+	return 0;
+}
+module_init(dynamic_printk_init);
+/* may want to move this earlier so we can get traces as early as possible */
+
+static int __init dynamic_printk_setup(char *str)
+{
+	if (str)
+		return -ENOENT;
+	set_all(true);
+	return 0;
+}
+/* Use early_param(), so we can get debug output as early as possible */
+early_param("dynamic_printk", dynamic_printk_setup);
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 97e54b0..7fea304 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -65,7 +65,7 @@ void
 			     struct nf_conntrack_expect *exp) __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_pptp_hook_expectfn);
 
-#ifdef DEBUG
+#if defined(DEBUG) || defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
 /* PptpControlMessageType names */
 const char *const pptp_msg_name[] = {
 	"UNKNOWN_MESSAGE",
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 8e44023..bb635ae 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -96,6 +96,14 @@ basename_flags = -D"KBUILD_BASENAME=KBUILD_STR($(call name-fix,$(basetarget)))"
 modname_flags  = $(if $(filter 1,$(words $(modname))),\
                  -D"KBUILD_MODNAME=KBUILD_STR($(call name-fix,$(modname)))")
 
+#hash values
+ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
+hash_flags = -D"DEBUG_HASH=$(shell ./scripts/basic/hash djb2 $(modname))"	\
+              -D"DEBUG_HASH2=$(shell ./scripts/basic/hash r5 $(modname))"
+else
+hash_flags =
+endif
+
 _c_flags       = $(KBUILD_CFLAGS) $(ccflags-y) $(CFLAGS_$(basetarget).o)
 _a_flags       = $(KBUILD_AFLAGS) $(asflags-y) $(AFLAGS_$(basetarget).o)
 _cpp_flags     = $(KBUILD_CPPFLAGS) $(cppflags-y) $(CPPFLAGS_$(@F))
@@ -120,7 +128,8 @@ endif
 
 c_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(KBUILD_CPPFLAGS) \
 		 $(__c_flags) $(modkern_cflags) \
-		 -D"KBUILD_STR(s)=\#s" $(basename_flags) $(modname_flags)
+		 -D"KBUILD_STR(s)=\#s" $(basename_flags) $(modname_flags) \
+		  $(hash_flags)
 
 a_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(KBUILD_CPPFLAGS) \
 		 $(__a_flags) $(modkern_aflags)
diff --git a/scripts/basic/Makefile b/scripts/basic/Makefile
index 4c324a1..0955995 100644
--- a/scripts/basic/Makefile
+++ b/scripts/basic/Makefile
@@ -9,7 +9,7 @@
 # fixdep: 	 Used to generate dependency information during build process
 # docproc:	 Used in Documentation/DocBook
 
-hostprogs-y	:= fixdep docproc
+hostprogs-y	:= fixdep docproc hash
 always		:= $(hostprogs-y)
 
 # fixdep is needed to compile other host programs
diff --git a/scripts/basic/hash.c b/scripts/basic/hash.c
new file mode 100644
index 0000000..8025d4b
--- /dev/null
+++ b/scripts/basic/hash.c
@@ -0,0 +1,60 @@
+/*
+ * Copyright (C) 2008 Red Hat, Inc., Jason Baron <jbaron@redhat.com>
+ *
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#define DYNAMIC_DEBUG_HASH_BITS 6
+
+static const char *program;
+
+static void usage(void)
+{
+	printf("Usage: %s <djb2|r5> <modname>\n", program);
+	exit(1);
+}
+
+unsigned int djb2_hash(char *str)
+{
+	unsigned long hash = 5381;
+	int c;
+
+	c = *str;
+	while (c) {
+		hash = ((hash << 5) + hash) + c;
+		c = *++str;
+	}
+	return (unsigned int)(hash & ((1 << DYNAMIC_DEBUG_HASH_BITS) - 1));
+}
+
+unsigned int r5_hash(char *str)
+{
+	unsigned long hash = 0;
+	int c;
+
+	c = *str;
+	while (c) {
+		hash = (hash + (c << 4) + (c >> 4)) * 11;
+		c = *++str;
+	}
+	return (unsigned int)(hash & ((1 << DYNAMIC_DEBUG_HASH_BITS) - 1));
+}
+
+int main(int argc, char *argv[])
+{
+	program = argv[0];
+
+	if (argc != 3)
+		usage();
+	if (!strcmp(argv[1], "djb2"))
+		printf("%d\n", djb2_hash(argv[2]));
+	else if (!strcmp(argv[1], "r5"))
+		printf("%d\n", r5_hash(argv[2]));
+	else
+		usage();
+	exit(0);
+}
+
