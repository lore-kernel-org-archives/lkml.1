Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbYFMTCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbYFMTCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 15:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbYFMTCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 15:02:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbYFMTB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 15:01:57 -0400
Date: Fri, 13 Jun 2008 15:00:39 -0400
From: Jason Baron <jbaron@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, joe@perches.com, greg@kroah.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: [PATCH 2/8] dynamic debug - core infrastructure
Message-ID: <20080613190039.GC8813@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the core patch that implements a new dynamic debug infrastructure.

Each kernel sub-system seems to have its own way of dealing with debugging
statements. Some of these methods include 'dprintk', 'pr_debug', 'dev_debug',
'DEBUGP'. There are also a myriad of ways of enabling these statements. Some
require CONFIG_ parameters to be set, some provide /proc interfaces, while
others require 'DEBUG' to be set in header files. Most of these methods also
require kernel re-compiles in order to set the appropriate knobs.

I've attempted to standardize how how the kernel deals with debugging
statements, both from the user as well as the kernel perspective. Why aren't
these debug statements made into printk(KERN_DEBUG), and be done with it? The
problem here is that 'dprintk', 'pr_debug', etc. were introduced b/c they
are often provide too verbose a level of output, could potentially adversly
affect system performance if they were always enabled, and they clutter up the
system logs.

I've introduced CONFIG_DYNAMIC_PRINTK_DEBUG, which when enabled centralizes
control of debugging statements on a per-module basis in one /proc file,
currently, <debugfs>/dynamic_printk/modules. When, CONFIG_DYNAMIC_PRINTK_DEBUG,
is not set, debugging statements can still be enabled as before, often by
defining 'DEBUG' for the proper compilation unit. Thus, this patch set has not
affect when CONFIG_DYNAMIC_PRINTK_DEBUG is not set. The rest of the discussion
deals with the case where CONFIG_DYNAMIC_PRINTK_DEBUG is set.


Signed-off-by: Jason Baron <jbaron@redhat.com>

---

 Documentation/kernel-parameters.txt |    5 
 include/asm-generic/vmlinux.lds.h   |   10 +
 include/linux/device.h              |   16 +
 include/linux/dynamic_printk.h      |   49 +++
 include/linux/kernel.h              |   78 +++++-
 include/linux/module.h              |    5 
 kernel/module.c                     |   24 ++
 lib/Kconfig.debug                   |   67 +++++
 lib/Makefile                        |    2 
 lib/dynamic_printk.c                |  492 +++++++++++++++++++++++++++++++++++
 net/netfilter/nf_conntrack_pptp.c   |    2 
 11 files changed, 744 insertions(+), 6 deletions(-)
 create mode 100644 include/linux/dynamic_printk.h
 create mode 100644 lib/dynamic_printk.c


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
index 1a06026..9521f14 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -595,6 +595,22 @@ extern const char *dev_driver_string(struct device *dev);
 #ifdef DEBUG
 #define dev_dbg(dev, format, arg...)		\
 	dev_printk(KERN_DEBUG , dev , format , ## arg)
+#elif defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
+#define dev_dbg(dev, format, ...) do {				    	     \
+	static char mod_name[]						     \
+	__attribute__((section("__verbose_strings")))			     \
+	 = KBUILD_MODNAME;						     \
+	static struct mod_debug foobar					     \
+	__used								     \
+	__attribute__((section("__verbose"), aligned(8))) =		     \
+	{ mod_name, mod_name, "0", "0", NULL };				     \
+	int hash = dynamic_name_hash(KBUILD_MODNAME);			     \
+	if (dynamic_printk_enabled[raw_smp_processor_id()] & (1 << hash))    \
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
index 0000000..d44f1bc
--- /dev/null
+++ b/include/linux/dynamic_printk.h
@@ -0,0 +1,49 @@
+#ifndef _DYNAMIC_PRINTK_H
+#define _DYNAMIC_PRINTK_H
+
+#ifdef __KERNEL__
+
+#include <linux/string.h>
+#include <linux/hash.h>
+
+#define DYNAMIC_DEBUG_HASH_BITS 5
+#define DEBUG_HASH_TABLE_SIZE (1 << DYNAMIC_DEBUG_HASH_BITS)
+
+#define TYPE_BOOLEAN 0
+#define TYPE_LEVEL 1
+#define TYPE_FLAG 2
+
+struct device;
+
+struct mod_debug {
+	char *modname;
+	char *logical_modname;
+	char *type;
+	char *num_flags;
+	char *flag_names;
+} __attribute__((aligned(8)));
+
+#if defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
+extern int unregister_debug_module(char *mod_name);
+#else
+static inline int unregister_debug_module(const char *mod_name)
+{
+	return 0;
+}
+#endif
+
+extern int dynamic_printk_enabled[];
+extern void dynamic_printk(char *, char *, ...);
+
+static inline unsigned int dynamic_name_hash(char *name)
+{
+	unsigned int hash = full_name_hash(name, strlen(name));
+	return (hash & ((1 << DYNAMIC_DEBUG_HASH_BITS) - 1));
+}
+
+int __dynamic_dbg_enabled(char *modname, int type, int value, int level);
+int register_debug_module(char *mod_name, int type, char *share_name,
+				int num_flags, char *flags);
+
+#endif
+#endif
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index cd6d02c..1e0c1ed 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -14,6 +14,7 @@
 #include <linux/compiler.h>
 #include <linux/bitops.h>
 #include <linux/log2.h>
+#include <linux/dynamic_printk.h>
 #include <asm/byteorder.h>
 #include <asm/bug.h>
 
@@ -288,15 +289,86 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 #define pr_info(fmt, arg...) \
 	printk(KERN_INFO fmt, ##arg)
 
-#ifdef DEBUG
-/* If you are writing a driver, please use dev_dbg instead */
+#if defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
+#define pr_debug(fmt, ...) do { \
+	static char bar[]	           		   	   \
+	__attribute__((section("__verbose_strings")))		   \
+	 = KBUILD_MODNAME;					   \
+	static struct mod_debug foobar 	   		   	   \
+	__used							   \
+	__attribute__((section("__verbose"), aligned(8))) =	   \
+	{ bar, bar, "0", "0", NULL };		   		   \
+	int hash = dynamic_name_hash(KBUILD_MODNAME);		   \
+	if (dynamic_printk_enabled[raw_smp_processor_id()] & (1 << hash)) \
+		dynamic_printk(KBUILD_MODNAME,			   \
+				KERN_DEBUG KBUILD_MODNAME ": " fmt,\
+				##__VA_ARGS__);			   \
+	} while (0)
+#elif defined(DEBUG)
 #define pr_debug(fmt, arg...) \
-	printk(KERN_DEBUG fmt, ##arg)
+	 printk(KERN_DEBUG fmt, ##arg)
 #else
 #define pr_debug(fmt, arg...) \
 	({ if (0) printk(KERN_DEBUG fmt, ##arg); 0; })
 #endif
 
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
+#if defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
+#define dynamic_dbg_enabled(call_type, value, level)  ({  \
+	int ret = 0;			      	      \
+	int hash;				      \
+	static char mod_name[]			      \
+	__attribute__((section("__verbose_strings"))) \
+	= KBUILD_MODNAME;			      \
+	static  char logical_mod_name[]		      \
+	__attribute__((section("__verbose_strings"))) \
+	= DYNAMIC_DEBUG_MODNAME;		      \
+	static char num_flags[]			      \
+	__attribute__((section("__verbose_strings"))) \
+	= DYNAMIC_DEBUG_NUM_FLAGS;		      \
+	static char flag_names[]		      \
+	__attribute__((section("__verbose_strings"))) \
+	= DYNAMIC_DEBUG_FLAG_NAMES;		      \
+	static char register_type[]		      \
+	__attribute__((section("__verbose_strings"))) \
+	= DYNAMIC_DEBUG_TYPE;			      \
+	static struct mod_debug descriptor	      \
+	__used					      \
+	__attribute__((section("__verbose"), aligned(8)))		       \
+	= { mod_name, logical_mod_name, register_type, num_flags, flag_names };\
+	hash = dynamic_name_hash(DYNAMIC_DEBUG_MODNAME);		       \
+	if (dynamic_printk_enabled[raw_smp_processor_id()] & (1 << hash))      \
+		ret = __dynamic_dbg_enabled(DYNAMIC_DEBUG_MODNAME, call_type,  \
+						value, level);		       \
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
+	({ if (0) __dev_dbg_enabled(KBUILD_MODNAME, type, value, level); 0; })
+#endif
+
 /*
  *      Display an IP address in readable format.
  */
diff --git a/include/linux/module.h b/include/linux/module.h
index 819c4e8..267dba5 100644
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
+	struct mod_debug *start_verbose;
+	unsigned int num_verbose;
+#endif
 };
 #ifndef MODULE_ARCH_INIT
 #define MODULE_ARCH_INIT {}
diff --git a/kernel/module.c b/kernel/module.c
index 8d6cccc..b8a19bb 100644
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
@@ -744,6 +745,7 @@ sys_delete_module(const char __user *name_user, unsigned int flags)
 	}
 	/* Store the name of the last unloaded module for diagnostic purposes */
 	strlcpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));
+	unregister_debug_module(mod->name);
 	free_module(mod);
 
  out:
@@ -1717,6 +1719,9 @@ static struct module *load_module(void __user *umod,
 	unsigned int unusedgplcrcindex;
 	unsigned int markersindex;
 	unsigned int markersstringsindex;
+	unsigned int verboseindex;
+	struct mod_debug *iter;
+	unsigned long value;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -1993,6 +1998,7 @@ static struct module *load_module(void __user *umod,
 	markersindex = find_sec(hdr, sechdrs, secstrings, "__markers");
  	markersstringsindex = find_sec(hdr, sechdrs, secstrings,
 					"__markers_strings");
+	verboseindex = find_sec(hdr, sechdrs, secstrings, "__verbose");
 
 	/* Now do relocations. */
 	for (i = 1; i < hdr->e_shnum; i++) {
@@ -2020,6 +2026,11 @@ static struct module *load_module(void __user *umod,
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
@@ -2043,6 +2054,19 @@ static struct module *load_module(void __user *umod,
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
index 623ef24..412a089 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -632,6 +632,73 @@ config FIREWIRE_OHCI_REMOTE_DMA
 
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
+	  dynamic_printk/modules. This file contains a list of the active 
+	  modules. For example:
+
+		<module_name> <enabled/disabled> <debug type> <level setting>
+		<flags> <module names>
+
+		uhci_hcd 0 boolean 0
+		dock 0 boolean 0
+		mount 0 boolean 0
+		main 0 boolean 0
+		driver 0 boolean 0
+		cpufreq_shared 0 flag 0 
+		  CPUFREQ_DEBUG_CORE CPUFREQ_DEBUG_DRIVER CPUFREQ_DEBUG_GOVERNOR
+        	  acpi_cpufreq freq_table cpufreq_userspace cpufreq
+
+	  <module_name> : Name of the module in which the debug call resides
+	  <enabled/disabled> : whether the the messages are enabled or not
+	  <debug type> : types are 'boolean', 'flag', or 'level'. 'boolean' is
+		is simply on/off. 'Flag' allows different flags to be turned on or
+		off. 'Level' means that all messages above a certain level are
+		enabled.
+	  <level setting> : This the current value if 'flag' or 'level' is set
+	  <flags> : names of the flags that can be set if 'flag' type is set
+	  <module names> : name of modules in the grouping.
+
+	  Enable a module:
+
+	  	$echo "enable <module_name>" > dynamic_printk/modules
+
+	  Disable a module:
+
+	  	$echo "disable <module_name>" > dynamic_printk/modules
+
+	  To set the level or flag value for type 'level' or 'flag': 
+
+	  	$echo "set level=<#> <module_name>" > dynamic_printk/modules
+
+	  Enable all modules:
+	
+		$echo "add all" > dynamic_printk/modules
+
+	  Disable all modules:
+
+		$echo "remove all" > dynamic_printk/modules
+
+	  Finally, passing "dynamic_printk" at the command line enables all 
+	  modules. This mode can be disabled via a "remove all".
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
index 0000000..dd4157b
--- /dev/null
+++ b/lib/dynamic_printk.c
@@ -0,0 +1,492 @@
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
+static int num_enabled;
+static struct hlist_head module_table[DEBUG_HASH_TABLE_SIZE] =
+	{ [0 ... DEBUG_HASH_TABLE_SIZE-1] = HLIST_HEAD_INIT };
+static DECLARE_MUTEX(debug_list_mutex);
+static int nr_entries;
+
+int dynamic_printk_enabled[NR_CPUS];
+EXPORT_SYMBOL_GPL(dynamic_printk_enabled);
+
+struct flags_descriptor {
+	int num;
+	char **flag_names;
+};
+
+struct debug_name {
+	struct hlist_node hlist;
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
+/* returns the debug module pointer. caller must locking */
+static struct debug_name *find_debug_module(char *module_name)
+{
+	int found = 0;
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct debug_name *element;
+
+	element = NULL;
+	head = &module_table[dynamic_name_hash(module_name)];
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
+	INIT_LIST_HEAD(&new->shared_list);
+	new->name = module_name;
+	hlist_add_head_rcu(&new->hlist,
+				&module_table[dynamic_name_hash(new->name)]);
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
+	if (element->type_sharing == SHARING_MEMBER) {
+		list_del_rcu(&element->shared_list);
+		element->parent->count -= 1;
+		if (element->parent->count == 0)
+			parent = element->parent;
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
+	kfree(element);
+	if (parent) {
+		kfree(parent->name);
+		if (parent->flags) {
+			for (i = 0; i < element->flags->num; i++)
+				kfree(element->flags->flag_names[i]);
+			kfree(parent->flags->flag_names);
+			kfree(parent->flags);
+		}
+		kfree(parent);
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
+	}
+	if (strcmp(mod_name, share_name)) {
+		parent = find_debug_module(share_name);
+		if (!parent) {
+			__add_debug_module(share_name);
+			parent = find_debug_module(share_name);
+			parent->type_sharing = SHARING_LEADER;
+			parent->type = type;
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
+int __dynamic_dbg_enabled(char *mod_name, int type, int value, int level)
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
+EXPORT_SYMBOL_GPL(__dynamic_dbg_enabled);
+
+void dynamic_printk(char *module_name, char *fmt, ...)
+{
+	va_list args;
+	struct debug_name *elem;
+	int enable = 0;
+
+	va_start(args, fmt);
+	rcu_read_lock();
+	elem = find_debug_module(module_name);
+	if (elem && elem->enable)
+		enable = 1;
+	rcu_read_unlock();
+	if (enable)
+		vprintk(fmt, args);
+	va_end(args);
+}
+EXPORT_SYMBOL_GPL(dynamic_printk);
+
+static void set_all(bool enable)
+{
+	struct debug_name *e;
+	struct hlist_node *node;
+	int i, enable_mask;
+
+	for (i = 0; i < DEBUG_HASH_TABLE_SIZE; i++) {
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
+	char *buffer, *s, *level;
+	int err, i, hash;
+	struct debug_name *elem;
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
+	if (!strncmp("enable all", buffer, 10)) {
+		if (nr_entries) {
+			set_all(true);
+			num_enabled = nr_entries;
+			err = 0;
+		}
+	} else if (!strncmp("disable all", buffer, 11)) {
+		set_all(false);
+		num_enabled = 0;
+		err = 0;
+	} else if (!strncmp("enable ", buffer, 7)) {
+		s = strstrip(buffer + 7);
+		elem = find_debug_module(s);
+		if (elem) {
+			if (elem->enable == 0) {
+				hash = dynamic_name_hash(s);
+				for (i = 0; i < NR_CPUS; i++)
+					dynamic_printk_enabled[i] |=
+								(1 << hash);
+				elem->enable = 1;
+				num_enabled++;
+			}
+			err = 0;
+		}
+	} else if (!strncmp("disable ", buffer, 8)) {
+		s = strstrip(buffer + 8);
+		elem = find_debug_module(s);
+		if (elem) {
+			if (elem->enable == 1) {
+				elem->enable = 0;
+				num_enabled--;
+				hash = dynamic_name_hash(s);
+				if (disabled_hash(hash)) {
+					for (i = 0; i < NR_CPUS; i++)
+						dynamic_printk_enabled[i] |=
+								~(1 << hash);
+				}
+			}
+			err = 0;
+		}
+	} else if (!strncmp("set level=", buffer, 10)) {
+		s = buffer + 10;
+		level = strsep(&s, " ");
+		s = strstrip(s);
+		elem = find_debug_module(s);
+		if (elem) {
+			elem->level = simple_strtol(level, NULL, 10);
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
+		seq_printf(s, "%s %d %s %d", elem->name, elem->enable,
+				type_to_string[elem->type], elem->level);
+		if ((elem->type == TYPE_FLAG) && elem->flags) {
+			for (j = 0; j < elem->flags->num; j++)
+				seq_printf(s, " %s",
+						elem->flags->flag_names[j]);
+		}
+		seq_printf(s, "\n");
+		if (elem->type_sharing == SHARING_LEADER) {
+			list_for_each_rcu(p, &elem->shared_list) {
+				elem_shared = list_entry(p, struct debug_name,
+								shared_list);
+				seq_printf(s, "\t%s", elem_shared->name);
+			}
+			seq_printf(s, "\n");
+		}
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
