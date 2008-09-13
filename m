Return-Path: <linux-kernel-owner+w=401wt.eu-S1758548AbYIME4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548AbYIME4D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 00:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757020AbYIMExF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 00:53:05 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:37682 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753851AbYIMExA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 00:53:00 -0400
From: Jeffrey Brian Arnold <jbarnold@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Tim Abbott <tabbott@MIT.EDU>, Anders Kaseorg <andersk@MIT.EDU>,
       Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: [RFC PATCH 5/9] Ksplice: Architecture-independent core
Date: Sat, 13 Sep 2008 00:49:51 -0400
Message-Id: <a827aed330aec871b73c468cf61c27048b26574d.1221280912.git.jbarnold@mit.edu>
X-Mailer: git-send-email 1.6.0
In-Reply-To: <401afda17296e380049b129c92a9ae27e8e47fc3.1221280912.git.jbarnold@mit.edu>
References: <1221281397-7045-1-git-send-email-jbarnold@mit.edu>
 <bfbae790a8f63d8697062036d47e0756e9f3ad5f.1221280912.git.jbarnold@mit.edu>
 <8cfda1c8f6c46e2f0fa9e9279aa2b2a213fba7a4.1221280912.git.jbarnold@mit.edu>
 <bdf8d7b52e2cb9ff3bbed52cedd28294086c9f56.1221280912.git.jbarnold@mit.edu>
 <401afda17296e380049b129c92a9ae27e8e47fc3.1221280912.git.jbarnold@mit.edu>
In-Reply-To: <bfbae790a8f63d8697062036d47e0756e9f3ad5f.1221280912.git.jbarnold@mit.edu>
References: <bfbae790a8f63d8697062036d47e0756e9f3ad5f.1221280912.git.jbarnold@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The architecture-independent core of Ksplice.  Ksplice makes it
possible to apply certain kinds of patches to the kernel without
having to reboot.

Signed-off-by: Jeffrey Brian Arnold <jbarnold@mit.edu>
Signed-off-by: Anders Kaseorg <andersk@mit.edu>
Signed-off-by: Tim Abbott <tabbott@mit.edu>
Tested-by: Waseem Daher <wdaher@mit.edu>
---
 MAINTAINERS             |   10 +
 arch/Kconfig            |   14 +
 include/linux/ksplice.h |  202 +++++
 kernel/Makefile         |    2 +
 kernel/ksplice.c        | 1997 +++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 2225 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/ksplice.h
 create mode 100644 kernel/ksplice.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 186be3b..bdc6dd7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2476,6 +2476,16 @@ W:	http://miguelojeda.es/auxdisplay.htm
 W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
 
+KSPLICE:
+P:	Jeffrey Brian Arnold
+M:	jbarnold@mit.edu
+P:	Anders Kaseorg
+M:	andersk@mit.edu
+P:	Tim Abbott
+M:	tabbott@mit.edu
+W:	http://web.mit.edu/ksplice
+S:	Maintained
+
 LAPB module
 L:	linux-x25@vger.kernel.org
 S:	Orphan
diff --git a/arch/Kconfig b/arch/Kconfig
index 364c6da..9d5a843 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -27,6 +27,17 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+config KSPLICE
+	bool "Ksplice rebootless kernel updates"
+	depends on KALLSYMS_ALL && MODULE_UNLOAD && SYSFS && \
+		   FUNCTION_DATA_SECTIONS
+	depends on HAVE_KSPLICE
+	help
+          Say Y here if you want to be able to apply certain kinds of
+          patches to your running kernel, without rebooting.
+
+          If unsure, say N.
+
 config HAVE_EFFICIENT_UNALIGNED_ACCESS
 	def_bool n
 	help
@@ -56,6 +67,9 @@ config HAVE_IOREMAP_PROT
 config HAVE_KPROBES
 	def_bool n
 
+config HAVE_KSPLICE
+	def_bool n
+
 config HAVE_KRETPROBES
 	def_bool n
 
diff --git a/include/linux/ksplice.h b/include/linux/ksplice.h
new file mode 100644
index 0000000..d60f14f
--- /dev/null
+++ b/include/linux/ksplice.h
@@ -0,0 +1,202 @@
+#include <linux/types.h>
+
+/**
+ * struct ksplice_symbol - Ksplice's analogue of an ELF symbol
+ * @name:	The ELF name of the symbol
+ * @label:	A unique Ksplice name for the symbol
+ **/
+struct ksplice_symbol {
+	const char *name;
+	const char *label;
+};
+
+/**
+ * struct ksplice_reloc - Ksplice's analogue of an ELF relocation
+ * @blank_addr:		The address of the relocation's storage unit
+ * @blank_offset:	The offset (from the start of the section) of the
+ * 			relocation's storage unit
+ * @symbol:		The ksplice_symbol associated with this relocation
+ * @pcrel:		Is the relocation PC relative?
+ * @addend:		The ELF addend of the relocation
+ * @size:		The size, in bytes, of the item to be relocated
+ * @dst_mask:		Bitmask for which parts of the instruction or data are
+ * 			replaced with the relocated value
+ * 			(based on dst_mask from GNU BFD's reloc_howto_struct)
+ * @rightshift:		The value the final relocation is shifted right by;
+ * 			used to drop unwanted data from the relocation
+ * 			(based on rightshift from GNU BFD's reloc_howto_struct)
+ * @signed_addend:	Should the addend be interpreted as a signed value?
+ **/
+struct ksplice_reloc {
+	unsigned long blank_addr;
+	long blank_offset;
+	const struct ksplice_symbol *symbol;
+	int pcrel;
+	long addend;
+	int size;
+	long dst_mask;
+	unsigned int rightshift;
+	int signed_addend;
+};
+
+#if BITS_PER_LONG == 32
+#define KSPLICE_CANARY 0x77777777UL
+#elif BITS_PER_LONG == 64
+#define KSPLICE_CANARY 0x7777777777777777UL
+#endif /* BITS_PER_LONG */
+
+/**
+ * struct ksplice_section - Ksplice's analogue of an ELF section
+ * @symbol:		The ksplice_symbol associated with this section
+ * @size:		The length, in bytes, of this section
+ * @address:		The address of the section
+ * @flags:		Specifies whether this section contains text, read-only
+ * 			data, or data
+ **/
+struct ksplice_section {
+	const struct ksplice_symbol *symbol;
+	unsigned long address;
+	unsigned long size;
+	unsigned int flags;
+};
+#define KSPLICE_SECTION_TEXT 0x00000001
+#define KSPLICE_SECTION_RODATA 0x00000002
+#define KSPLICE_SECTION_DATA 0x00000004
+
+#define MAX_TRAMPOLINE_SIZE 5
+
+/**
+ * struct ksplice_trampoline - A trampoline Ksplice should insert
+ * @repladdr:		The address of the replacement function
+ * @oldaddr:		The address of the obsolete function
+ * @trampoline:		The bytes of the trampoline itself
+ * @saved:		The bytes of the original function which were
+ * 			overwritten by the trampoline
+ * @size:		The size of the trampoline
+ **/
+struct ksplice_trampoline {
+	unsigned long repladdr;
+/* private: */
+	unsigned long oldaddr;
+	char trampoline[MAX_TRAMPOLINE_SIZE];
+	char saved[MAX_TRAMPOLINE_SIZE];
+	unsigned int size;
+};
+
+/**
+ * struct ksplice_patch - A function replacement that Ksplice should perform
+ * @label:		The unique Ksplice name for the obsolete function
+ * @trampoline:		A trampoline to insert over the obsolete function
+ * @reverse_trampoline:	Used to simplify Ksplice internal bookkeeping
+ **/
+struct ksplice_patch {
+	const char *label;
+	struct ksplice_trampoline trampoline;
+/* private: */
+	struct ksplice_trampoline reverse_trampoline;
+};
+
+/**
+ * struct ksplice_export - A change to be made to the exported symbol table
+ * @name:		The obsolete name of the exported symbol
+ * @new_name:		The new name of the exported symbol
+ * @sym:		The kernel_symbol being changed
+ * @saved_name:		The pointer to the original name of the kernel_symbol
+ **/
+struct ksplice_export {
+	const char *name;
+	const char *new_name;
+/* private: */
+	struct kernel_symbol *sym;
+	const char *saved_name;
+};
+
+#ifdef __KERNEL__
+#include <linux/module.h>
+
+#undef _STR
+#define _STR(x) #x
+#undef STR
+#define STR(x) _STR(x)
+#define _PASTE(x, y) x##y
+#define PASTE(x, y) _PASTE(x, y)
+#define KSPLICE_UNIQ(s) PASTE(s##_, KSPLICE_MID)
+#define KSPLICE_KID_UNIQ(s) PASTE(s##_, KSPLICE_KID)
+
+/**
+ * struct ksplice_module_list_entry - A record of a Ksplice pack's target
+ * @target:	A module that is patched
+ * @primary:	A Ksplice module that patches target
+ **/
+struct ksplice_module_list_entry {
+	struct module *target;
+	struct module *primary;
+/* private: */
+	struct list_head list;
+};
+
+/* List of all ksplice modules and the module they patch */
+extern struct list_head ksplice_module_list;
+
+/**
+ * struct ksplice_pack - Data for one module modified by a Ksplice update
+ * @name:			The name of the primary module for the pack
+ * @kid:			The Ksplice unique identifier for the pack
+ * @target_name:		The name of the module modified by the pack
+ * @primary:			The primary module associated with the pack
+ * @primary_relocs:		The relocations for the primary module
+ * @primary_relocs_end:		The end pointer for primary_relocs
+ * @primary_sections:		The sections in the primary module
+ * @primary_sections_end:	The end pointer for primary_sections array
+ * @helper_relocs:		The relocations for the helper module
+ * @helper_relocs_end:		The end pointer for helper_relocs array
+ * @helper_sections:		The sections in the helper module
+ * @helper_sections_end:	The end pointer for helper_sections array
+ * @patches:			The function replacements in the pack
+ * @patches_end:		The end pointer for patches array
+ * @exports:			The exported symbol changes in the pack
+ * @exports_end:		The end pointer for the exports array
+ * @update:			The atomic update the pack is part of
+ * @target:			The module modified by the pack
+ * @labelvals:			The mapping between Ksplice symbol labels and
+ *				their values
+ * @safety_records:		The ranges of addresses that must not be on a
+ *				kernel stack for the patch to apply safely
+ **/
+struct ksplice_pack {
+	const char *name;
+	const char *kid;
+	const char *target_name;
+	struct module *primary;
+	const struct ksplice_reloc *primary_relocs, *primary_relocs_end;
+	const struct ksplice_section *primary_sections, *primary_sections_end;
+	const struct ksplice_reloc *helper_relocs, *helper_relocs_end;
+	const struct ksplice_section *helper_sections, *helper_sections_end;
+	struct ksplice_patch *patches, *patches_end;
+	struct ksplice_export *exports, *exports_end;
+/* private: */
+	struct ksplice_module_list_entry module_list_entry;
+	struct update *update;
+	struct module *target;
+	struct list_head labelvals;
+	struct list_head safety_records;
+	struct list_head list;
+};
+
+
+/**
+ * init_ksplice_pack() - Initializes a pack
+ * @pack:	The pack to be initialized.  All of the public fields of the
+ * 		pack and its associated data structures should be populated
+ * 		before this function is called.  The values of the private
+ * 		fields will be ignored.
+ **/
+int init_ksplice_pack(struct ksplice_pack *pack);
+
+/**
+ * cleanup_ksplice_pack() - Cleans up a pack
+ * @pack:	The pack to be cleaned up
+ */
+void cleanup_ksplice_pack(struct ksplice_pack *pack);
+
+#endif /* __KERNEL__ */
diff --git a/kernel/Makefile b/kernel/Makefile
index 4e1d7df..26077f5 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -12,6 +12,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o
 
 CFLAGS_REMOVE_sched.o = -mno-spe
+CFLAGS_ksplice.o += -Iarch/$(SRCARCH)/kernel
 
 ifdef CONFIG_FTRACE
 # Do not trace debug files and internal ftrace files
@@ -68,6 +69,7 @@ obj-$(CONFIG_AUDIT) += audit.o auditfilter.o
 obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
 obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 obj-$(CONFIG_KPROBES) += kprobes.o
+obj-$(CONFIG_KSPLICE) += ksplice.o
 obj-$(CONFIG_KGDB) += kgdb.o
 obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
diff --git a/kernel/ksplice.c b/kernel/ksplice.c
new file mode 100644
index 0000000..b2e840a
--- /dev/null
+++ b/kernel/ksplice.c
@@ -0,0 +1,1997 @@
+/*  Copyright (C) 2007-2008  Jeffrey Brian Arnold <jbarnold@mit.edu>
+ *  Copyright (C) 2008  Anders Kaseorg <andersk@mit.edu>,
+ *                      Tim Abbott <tabbott@mit.edu>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License, version 2.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin Street - Fifth Floor, Boston, MA
+ *  02110-1301, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/debugfs.h>
+#include <linux/errno.h>
+#include <linux/kallsyms.h>
+#include <linux/kobject.h>
+#include <linux/kthread.h>
+#include <linux/pagemap.h>
+#include <linux/sched.h>
+#include <linux/stop_machine.h>
+#include <linux/sysfs.h>
+#include <linux/time.h>
+#include <linux/uaccess.h>
+#include <linux/vmalloc.h>
+#include <linux/ksplice.h>
+
+enum stage {
+	STAGE_PREPARING, STAGE_APPLIED, STAGE_REVERSED
+};
+
+enum run_pre_mode {
+	RUN_PRE_INITIAL, RUN_PRE_DEBUG, RUN_PRE_FINAL
+};
+
+typedef int __bitwise__ abort_t;
+
+#define OK ((__force abort_t) 0)
+#define NO_MATCH ((__force abort_t) 1)
+#define CODE_BUSY ((__force abort_t) 2)
+#define MODULE_BUSY ((__force abort_t) 3)
+#define OUT_OF_MEMORY ((__force abort_t) 4)
+#define FAILED_TO_FIND ((__force abort_t) 5)
+#define ALREADY_REVERSED ((__force abort_t) 6)
+#define MISSING_EXPORT ((__force abort_t) 7)
+#define UNEXPECTED_RUNNING_TASK ((__force abort_t) 8)
+#define UNEXPECTED ((__force abort_t) 9)
+
+struct update {
+	const char *kid;
+	const char *name;
+	struct kobject kobj;
+	enum stage stage;
+	abort_t abort_cause;
+	int debug;
+#ifdef CONFIG_DEBUG_FS
+	struct debugfs_blob_wrapper debug_blob;
+	struct dentry *debugfs_dentry;
+#else /* !CONFIG_DEBUG_FS */
+	bool debug_continue_line;
+#endif /* CONFIG_DEBUG_FS */
+	struct list_head packs;
+	struct list_head conflicts;
+	struct list_head list;
+};
+
+struct conflict {
+	const char *process_name;
+	pid_t pid;
+	struct list_head stack;
+	struct list_head list;
+};
+
+struct conflict_addr {
+	unsigned long addr;
+	bool has_conflict;
+	const char *label;
+	struct list_head list;
+};
+
+struct labelval {
+	struct list_head list;
+	const char *label;
+	unsigned long val;
+	enum { NOVAL, TEMP, VAL } status;
+};
+
+struct safety_record {
+	struct list_head list;
+	const char *label;
+	unsigned long addr;
+	unsigned long size;
+	bool first_byte_safe;
+};
+
+struct candidate_val {
+	struct list_head list;
+	unsigned long val;
+};
+
+struct accumulate_struct {
+	struct ksplice_pack *pack;
+	const char *desired_name;
+	struct list_head *vals;
+};
+
+static LIST_HEAD(updates);
+LIST_HEAD(ksplice_module_list);
+EXPORT_SYMBOL_GPL(ksplice_module_list);
+static struct kobject *ksplice_kobj;
+
+static struct kobj_type ksplice_ktype;
+
+static struct update *init_ksplice_update(const char *kid);
+static void cleanup_ksplice_update(struct update *update);
+static void add_to_update(struct ksplice_pack *pack, struct update *update);
+static int ksplice_sysfs_init(struct update *update);
+
+/* Preparing the relocations and patches for application */
+static abort_t apply_update(struct update *update);
+static abort_t prepare_pack(struct ksplice_pack *pack);
+static abort_t finalize_pack(struct ksplice_pack *pack);
+static abort_t finalize_exports(struct ksplice_pack *pack);
+static abort_t finalize_patches(struct ksplice_pack *pack);
+static abort_t add_dependency_on_address(struct ksplice_pack *pack,
+					 unsigned long addr);
+static abort_t apply_relocs(struct ksplice_pack *pack,
+			    const struct ksplice_reloc *relocs,
+			    const struct ksplice_reloc *relocs_end);
+static abort_t apply_reloc(struct ksplice_pack *pack,
+			   const struct ksplice_reloc *r);
+static abort_t read_reloc_value(struct ksplice_pack *pack,
+				const struct ksplice_reloc *r,
+				unsigned long addr, unsigned long *valp);
+static abort_t write_reloc_value(struct ksplice_pack *pack,
+				 const struct ksplice_reloc *r,
+				 unsigned long addr, unsigned long sym_addr);
+static void __attribute__((noreturn)) ksplice_deleted(void);
+
+/* run-pre matching */
+static abort_t match_pack_sections(struct ksplice_pack *pack,
+				   bool consider_data_sections);
+static abort_t find_section(struct ksplice_pack *pack,
+			    const struct ksplice_section *sect);
+static abort_t try_addr(struct ksplice_pack *pack,
+			const struct ksplice_section *sect,
+			unsigned long run_addr,
+			struct list_head *safety_records,
+			enum run_pre_mode mode);
+static abort_t run_pre_cmp(struct ksplice_pack *pack,
+			   const struct ksplice_section *sect,
+			   unsigned long run_addr,
+			   struct list_head *safety_records,
+			   enum run_pre_mode mode);
+static void print_bytes(struct ksplice_pack *pack,
+			const unsigned char *run, int runc,
+			const unsigned char *pre, int prec);
+static abort_t lookup_reloc(struct ksplice_pack *pack, unsigned long addr,
+			    const struct ksplice_reloc **relocp);
+static abort_t handle_reloc(struct ksplice_pack *pack,
+			    const struct ksplice_reloc *r,
+			    unsigned long run_addr, enum run_pre_mode mode);
+
+/* Computing possible addresses for symbols */
+static abort_t lookup_symbol(struct ksplice_pack *pack,
+			     const struct ksplice_symbol *ksym,
+			     struct list_head *vals);
+static abort_t lookup_symbol_kallsyms(struct ksplice_pack *pack,
+				      const char *name, struct list_head *vals);
+static int accumulate_matching_names(void *data, const char *sym_name,
+				     struct module *sym_owner,
+				     unsigned long sym_val);
+static abort_t exported_symbol_lookup(const char *name, struct list_head *vals);
+static abort_t new_export_lookup(struct update *update,
+				 const char *name, struct list_head *vals);
+
+/* Atomic update insertion and removal */
+static abort_t apply_patches(struct update *update);
+static abort_t reverse_patches(struct update *update);
+static int __apply_patches(void *update);
+static int __reverse_patches(void *update);
+static abort_t check_each_task(struct update *update);
+static abort_t check_task(struct update *update,
+			  const struct task_struct *t, bool rerun);
+static abort_t check_stack(struct update *update, struct conflict *conf,
+			   const struct thread_info *tinfo,
+			   const unsigned long *stack);
+static abort_t check_address(struct update *update,
+			     struct conflict *conf, unsigned long addr);
+static abort_t check_record(struct conflict_addr *ca,
+			    const struct safety_record *rec,
+			    unsigned long addr);
+static bool is_stop_machine(const struct task_struct *t);
+static void cleanup_conflicts(struct update *update);
+static void print_conflicts(struct update *update);
+static void insert_trampoline(struct ksplice_trampoline *t);
+static abort_t verify_trampoline(struct ksplice_pack *pack,
+				 const struct ksplice_trampoline *t);
+static void remove_trampoline(const struct ksplice_trampoline *t);
+
+static struct labelval *find_labelval(struct ksplice_pack *pack,
+				      const char *label);
+static abort_t create_labelval(struct ksplice_pack *pack, const char *label,
+			       unsigned long val, int status);
+static abort_t create_safety_record(struct ksplice_pack *pack,
+				    const struct ksplice_section *sect,
+				    struct list_head *record_list,
+				    unsigned long run_addr,
+				    unsigned long run_size);
+static abort_t add_candidate_val(struct list_head *vals, unsigned long val);
+static void prune_trampoline_vals(struct ksplice_pack *pack,
+				  struct list_head *vals);
+static void release_vals(struct list_head *vals);
+static void set_temp_labelvals(struct ksplice_pack *pack, int status_val);
+
+static int contains_canary(struct ksplice_pack *pack, unsigned long blank_addr,
+			   int size, long dst_mask);
+static unsigned long follow_trampolines(struct ksplice_pack *pack,
+					unsigned long addr);
+static bool patches_module(const struct module *a, const struct module *b);
+static bool starts_with(const char *str, const char *prefix);
+static bool singular(struct list_head *list);
+
+/* Debugging */
+static abort_t init_debug_buf(struct update *update);
+static void clear_debug_buf(struct update *update);
+static int __attribute__((format(printf, 2, 3)))
+_ksdebug(struct update *update, const char *fmt, ...);
+#define ksdebug(pack, fmt, ...) \
+	_ksdebug(pack->update, fmt, ## __VA_ARGS__)
+
+/* Architecture-specific functions defined in arch/ARCH/kernel/ksplice-arch.c */
+static abort_t prepare_trampoline(struct ksplice_pack *pack,
+				  struct ksplice_trampoline *t);
+static abort_t trampoline_target(struct ksplice_pack *pack, unsigned long addr,
+				 unsigned long *new_addr);
+static abort_t handle_paravirt(struct ksplice_pack *pack, unsigned long pre,
+			       unsigned long run, int *matched);
+static bool valid_stack_ptr(const struct thread_info *tinfo, const void *p);
+
+#include "ksplice-arch.c"
+
+#define clear_list(head, type, member)				\
+	do {							\
+		struct list_head *_pos, *_n;			\
+		list_for_each_safe(_pos, _n, head) {		\
+			list_del(_pos);				\
+			kfree(list_entry(_pos, type, member));	\
+		}						\
+	} while (0)
+
+int init_ksplice_pack(struct ksplice_pack *pack)
+{
+	struct update *update;
+	int ret = 0;
+
+	INIT_LIST_HEAD(&pack->labelvals);
+	INIT_LIST_HEAD(&pack->safety_records);
+
+	mutex_lock(&module_mutex);
+	if (strcmp(pack->target_name, "vmlinux") == 0) {
+		pack->target = NULL;
+	} else {
+		pack->target = find_module(pack->target_name);
+		if (pack->target == NULL || !module_is_live(pack->target)) {
+			ret = -ENODEV;
+			goto out;
+		}
+		ret = use_module(pack->primary, pack->target);
+		if (ret != 1) {
+			ret = -ENODEV;
+			goto out;
+		}
+	}
+	list_for_each_entry(update, &updates, list) {
+		if (strcmp(pack->kid, update->kid) == 0) {
+			if (update->stage != STAGE_PREPARING) {
+				ret = -EPERM;
+				goto out;
+			}
+			add_to_update(pack, update);
+			goto out;
+		}
+	}
+	update = init_ksplice_update(pack->kid);
+	if (update == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	ret = ksplice_sysfs_init(update);
+	if (ret != 0) {
+		cleanup_ksplice_update(update);
+		goto out;
+	}
+	add_to_update(pack, update);
+out:
+	mutex_unlock(&module_mutex);
+	return ret;
+}
+EXPORT_SYMBOL(init_ksplice_pack);
+
+void cleanup_ksplice_pack(struct ksplice_pack *pack)
+{
+	if (pack->update == NULL || pack->update->stage == STAGE_APPLIED)
+		return;
+	mutex_lock(&module_mutex);
+	list_del(&pack->list);
+	mutex_unlock(&module_mutex);
+	if (list_empty(&pack->update->packs))
+		kobject_put(&pack->update->kobj);
+	pack->update = NULL;
+}
+EXPORT_SYMBOL_GPL(cleanup_ksplice_pack);
+
+static struct update *init_ksplice_update(const char *kid)
+{
+	struct update *update;
+	update = kcalloc(1, sizeof(struct update), GFP_KERNEL);
+	if (update == NULL)
+		return NULL;
+	update->name = kasprintf(GFP_KERNEL, "ksplice_%s", kid);
+	if (update->name == NULL) {
+		kfree(update);
+		return NULL;
+	}
+	update->kid = kstrdup(kid, GFP_KERNEL);
+	if (update->kid == NULL) {
+		kfree(update->name);
+		kfree(update);
+		return NULL;
+	}
+	INIT_LIST_HEAD(&update->packs);
+	if (init_debug_buf(update) != OK) {
+		kfree(update->kid);
+		kfree(update->name);
+		kfree(update);
+		return NULL;
+	}
+	list_add(&update->list, &updates);
+	update->stage = STAGE_PREPARING;
+	update->abort_cause = OK;
+	INIT_LIST_HEAD(&update->conflicts);
+	return update;
+}
+
+static void cleanup_ksplice_update(struct update *update)
+{
+	mutex_lock(&module_mutex);
+	list_del(&update->list);
+	mutex_unlock(&module_mutex);
+	cleanup_conflicts(update);
+	clear_debug_buf(update);
+	kfree(update->kid);
+	kfree(update->name);
+	kfree(update);
+}
+
+static void add_to_update(struct ksplice_pack *pack, struct update *update)
+{
+	pack->update = update;
+	list_add(&pack->list, &update->packs);
+	pack->module_list_entry.target = pack->target;
+	pack->module_list_entry.primary = pack->primary;
+}
+
+static int ksplice_sysfs_init(struct update *update)
+{
+	int ret = 0;
+	memset(&update->kobj, 0, sizeof(update->kobj));
+	ret = kobject_init_and_add(&update->kobj, &ksplice_ktype,
+				   ksplice_kobj, "%s", update->kid);
+	if (ret != 0)
+		return ret;
+	kobject_uevent(&update->kobj, KOBJ_ADD);
+	return 0;
+}
+
+static abort_t apply_update(struct update *update)
+{
+	struct ksplice_pack *pack;
+	abort_t ret;
+
+	mutex_lock(&module_mutex);
+
+	list_for_each_entry(pack, &update->packs, list) {
+		ret = prepare_pack(pack);
+		if (ret != OK)
+			goto out;
+	}
+	ret = apply_patches(update);
+out:
+	list_for_each_entry(pack, &update->packs, list) {
+		clear_list(&pack->labelvals, struct labelval, list);
+		if (update->stage == STAGE_PREPARING)
+			clear_list(&pack->safety_records, struct safety_record,
+				   list);
+	}
+	mutex_unlock(&module_mutex);
+	return ret;
+}
+
+
+static abort_t prepare_pack(struct ksplice_pack *pack)
+{
+	abort_t ret;
+
+	ksdebug(pack, "Preparing and checking %s\n", pack->name);
+	ret = match_pack_sections(pack, false);
+	if (ret == NO_MATCH) {
+		/* It is possible that by using relocations from .data sections
+		   we can successfully run-pre match the rest of the sections.
+		   To avoid using any symbols obtained from .data sections
+		   (which may be unreliable) in the post code, we first prepare
+		   the post code and then try to run-pre match the remaining
+		   sections with the help of .data sections.
+		 */
+		ksdebug(pack, "Continuing without some sections; we might "
+			"find them later.\n");
+		ret = finalize_pack(pack);
+		if (ret != OK) {
+			ksdebug(pack, "Aborted.  Unable to continue without "
+				"the unmatched sections.\n");
+			return ret;
+		}
+
+		ksdebug(pack, "run-pre: Considering .data sections to find the "
+			"unmatched sections\n");
+		ret = match_pack_sections(pack, true);
+		if (ret != OK)
+			return ret;
+
+		ksdebug(pack, "run-pre: Found all previously unmatched "
+			"sections\n");
+		return OK;
+	} else if (ret != OK) {
+		return ret;
+	}
+
+	return finalize_pack(pack);
+}
+
+static abort_t finalize_pack(struct ksplice_pack *pack)
+{
+	abort_t ret;
+	ret = apply_relocs(pack, pack->primary_relocs,
+			   pack->primary_relocs_end);
+	if (ret != OK)
+		return ret;
+
+	ret = finalize_patches(pack);
+	if (ret != OK)
+		return ret;
+
+	ret = finalize_exports(pack);
+	if (ret != OK)
+		return ret;
+
+	return OK;
+}
+
+static abort_t finalize_exports(struct ksplice_pack *pack)
+{
+	struct ksplice_export *exp;
+	struct module *m;
+	const struct kernel_symbol *sym;
+
+	for (exp = pack->exports; exp < pack->exports_end; exp++) {
+		sym = find_symbol(exp->name, &m, NULL, true, false);
+		if (sym == NULL) {
+			ksdebug(pack, "Could not find kernel_symbol struct for "
+				"%s\n", exp->name);
+			return MISSING_EXPORT;
+		}
+
+		/* Cast away const since we are planning to mutate the
+		 * kernel_symbol structure. */
+		exp->sym = (struct kernel_symbol *)sym;
+		exp->saved_name = exp->sym->name;
+		if (m != pack->primary && use_module(pack->primary, m) != 1) {
+			ksdebug(pack, "Aborted.  Could not add dependency on "
+				"symbol %s from module %s.\n", sym->name,
+				m->name);
+			return UNEXPECTED;
+		}
+	}
+	return OK;
+}
+
+static abort_t finalize_patches(struct ksplice_pack *pack)
+{
+	struct ksplice_patch *p;
+	struct safety_record *rec;
+	abort_t ret;
+
+	for (p = pack->patches; p < pack->patches_end; p++) {
+		struct labelval *lv = find_labelval(pack, p->label);
+		bool found = false;
+		if (lv == NULL) {
+			ksdebug(pack, "Failed to find %s for oldaddr\n",
+				p->label);
+			return FAILED_TO_FIND;
+		}
+		p->trampoline.oldaddr = lv->val;
+
+		list_for_each_entry(rec, &pack->safety_records, list) {
+			if (strcmp(rec->label, p->label) == 0 &&
+			    follow_trampolines(pack, p->trampoline.oldaddr)
+			    == rec->addr) {
+				found = true;
+				break;
+			}
+		}
+		if (!found) {
+			ksdebug(pack, "No safety record for patch %s\n",
+				p->label);
+			return NO_MATCH;
+		}
+		if (rec->size < p->trampoline.size) {
+			ksdebug(pack, "Symbol %s is too short for trampoline\n",
+				p->label);
+			return UNEXPECTED;
+		}
+
+		if (p->trampoline.repladdr == 0)
+			p->trampoline.repladdr = (unsigned long)ksplice_deleted;
+		else
+			rec->first_byte_safe = true;
+
+		ret = prepare_trampoline(pack, &p->trampoline);
+		if (ret != OK)
+			return ret;
+
+		if (p->trampoline.oldaddr != rec->addr) {
+			/* If there's already a trampoline at oldaddr, prepare
+			   a reverse trampoline to install there */
+			p->reverse_trampoline.oldaddr = rec->addr;
+			p->reverse_trampoline.repladdr = p->trampoline.oldaddr;
+			ret = prepare_trampoline(pack, &p->reverse_trampoline);
+			if (ret != OK)
+				return ret;
+		} else {
+			p->reverse_trampoline.size = 0;
+		}
+
+		ret = add_dependency_on_address(pack, p->trampoline.oldaddr);
+		if (ret != OK)
+			return ret;
+	}
+	return OK;
+}
+
+static abort_t add_dependency_on_address(struct ksplice_pack *pack,
+					 unsigned long addr)
+{
+	struct module *m =
+	    __module_text_address(follow_trampolines(pack, addr));
+	if (m == NULL || m == pack->primary)
+		return OK;
+	if (use_module(pack->primary, m) != 1)
+		return MODULE_BUSY;
+	return OK;
+}
+
+static abort_t apply_relocs(struct ksplice_pack *pack,
+			    const struct ksplice_reloc *relocs,
+			    const struct ksplice_reloc *relocs_end)
+{
+	const struct ksplice_reloc *r;
+	for (r = relocs; r < relocs_end; r++) {
+		abort_t ret = apply_reloc(pack, r);
+		if (ret != OK)
+			return ret;
+	}
+	return OK;
+}
+
+static abort_t apply_reloc(struct ksplice_pack *pack,
+			   const struct ksplice_reloc *r)
+{
+	abort_t ret;
+	int canary_ret;
+	unsigned long sym_addr;
+	LIST_HEAD(vals);
+
+	canary_ret = contains_canary(pack, r->blank_addr, r->size, r->dst_mask);
+	if (canary_ret < 0)
+		return UNEXPECTED;
+	if (canary_ret == 0) {
+		ksdebug(pack, "reloc: skipped %s:%lx (altinstr)\n",
+			r->symbol->label, r->blank_offset);
+		return OK;
+	}
+
+	ret = lookup_symbol(pack, r->symbol, &vals);
+	if (ret != OK) {
+		release_vals(&vals);
+		return ret;
+	}
+	if (!singular(&vals)) {
+		release_vals(&vals);
+		ksdebug(pack, "Failed to find %s for reloc\n",
+			r->symbol->label);
+		return FAILED_TO_FIND;
+	}
+	sym_addr = list_entry(vals.next, struct candidate_val, list)->val;
+	release_vals(&vals);
+
+	ret = write_reloc_value(pack, r, r->blank_addr,
+				r->pcrel ? sym_addr - r->blank_addr : sym_addr);
+	if (ret != OK)
+		return ret;
+
+	ksdebug(pack, "reloc: %s:%lx", r->symbol->label, r->blank_offset);
+	ksdebug(pack, "(S=%lx A=%lx ", sym_addr, r->addend);
+	switch (r->size) {
+	case 1:
+		ksdebug(pack, "aft=%02x)\n", *(uint8_t *)r->blank_addr);
+		break;
+	case 2:
+		ksdebug(pack, "aft=%04x)\n", *(uint16_t *)r->blank_addr);
+		break;
+	case 4:
+		ksdebug(pack, "aft=%08x)\n", *(uint32_t *)r->blank_addr);
+		break;
+#if BITS_PER_LONG >= 64
+	case 8:
+		ksdebug(pack, "aft=%016llx)\n", *(uint64_t *)r->blank_addr);
+		break;
+#endif /* BITS_PER_LONG */
+	default:
+		ksdebug(pack, "Aborted.  Invalid relocation size.\n");
+		return UNEXPECTED;
+	}
+	/* Create labelvals so that we can verify our choices in the second
+	   round of run-pre matching that considers data sections. */
+	ret = create_labelval(pack, r->symbol->label, sym_addr, VAL);
+	if (ret != OK)
+		return ret;
+	return add_dependency_on_address(pack, sym_addr);
+}
+
+static abort_t read_reloc_value(struct ksplice_pack *pack,
+				const struct ksplice_reloc *r,
+				unsigned long addr, unsigned long *valp)
+{
+	unsigned char bytes[sizeof(long)];
+	unsigned long val;
+
+	if (probe_kernel_read(bytes, (void *)addr, r->size) == -EFAULT)
+		return NO_MATCH;
+
+	switch (r->size) {
+	case 1:
+		val = *(uint8_t *)bytes;
+		break;
+	case 2:
+		val = *(uint16_t *)bytes;
+		break;
+	case 4:
+		val = *(uint32_t *)bytes;
+		break;
+#if BITS_PER_LONG >= 64
+	case 8:
+		val = *(uint64_t *)bytes;
+		break;
+#endif /* BITS_PER_LONG */
+	default:
+		ksdebug(pack, "Aborted.  Invalid relocation size.\n");
+		return UNEXPECTED;
+	}
+
+	val &= r->dst_mask;
+	if (r->signed_addend)
+		val |= -(val & (r->dst_mask & ~(r->dst_mask >> 1)));
+	val <<= r->rightshift;
+	val -= r->addend;
+	*valp = val;
+	return OK;
+}
+
+static abort_t write_reloc_value(struct ksplice_pack *pack,
+				 const struct ksplice_reloc *r,
+				 unsigned long addr, unsigned long sym_addr)
+{
+	unsigned long val = sym_addr + r->addend;
+	val >>= r->rightshift;
+	switch (r->size) {
+	case 1:
+		*(uint8_t *)addr =
+		    (*(uint8_t *)addr & ~r->dst_mask) | (val & r->dst_mask);
+		break;
+	case 2:
+		*(uint16_t *)addr =
+		    (*(uint16_t *)addr & ~r->dst_mask) | (val & r->dst_mask);
+		break;
+	case 4:
+		*(uint32_t *)addr =
+		    (*(uint32_t *)addr & ~r->dst_mask) | (val & r->dst_mask);
+		break;
+#if BITS_PER_LONG >= 64
+	case 8:
+		*(uint64_t *)addr =
+		    (*(uint64_t *)addr & ~r->dst_mask) | (val & r->dst_mask);
+		break;
+#endif /* BITS_PER_LONG */
+	default:
+		ksdebug(pack, "Aborted.  Invalid relocation size.\n");
+		return UNEXPECTED;
+	}
+
+	if (read_reloc_value(pack, r, addr, &val) != OK || val != sym_addr) {
+		ksdebug(pack, "Aborted.  Relocation overflow.\n");
+		return UNEXPECTED;
+	}
+
+	return OK;
+}
+
+static void __attribute__((noreturn)) ksplice_deleted(void)
+{
+	printk(KERN_CRIT "Called a kernel function deleted by Ksplice!\n");
+	BUG();
+}
+
+static abort_t match_pack_sections(struct ksplice_pack *pack,
+				   bool consider_data_sections)
+{
+	const struct ksplice_section *sect;
+	abort_t ret;
+	char *finished;
+	int i, remaining = 0;
+	bool progress;
+
+	finished = kcalloc(pack->helper_sections_end - pack->helper_sections,
+			   sizeof(*finished), GFP_KERNEL);
+	if (finished == NULL)
+		return OUT_OF_MEMORY;
+	for (sect = pack->helper_sections; sect < pack->helper_sections_end;
+	     sect++) {
+		if ((sect->flags & KSPLICE_SECTION_DATA) == 0)
+			remaining++;
+	}
+
+	while (remaining > 0) {
+		progress = false;
+		for (sect = pack->helper_sections;
+		     sect < pack->helper_sections_end; sect++) {
+			i = sect - pack->helper_sections;
+			if (finished[i])
+				continue;
+			if (!consider_data_sections &&
+			    (sect->flags & KSPLICE_SECTION_DATA) != 0)
+				continue;
+			ret = find_section(pack, sect);
+			if (ret == OK) {
+				finished[i] = 1;
+				if ((sect->flags & KSPLICE_SECTION_DATA) == 0)
+					remaining--;
+				progress = true;
+			} else if (ret != NO_MATCH) {
+				kfree(finished);
+				return ret;
+			}
+		}
+
+		if (progress)
+			continue;
+
+		for (sect = pack->helper_sections;
+		     sect < pack->helper_sections_end; sect++) {
+			i = sect - pack->helper_sections;
+			if (finished[i] == 0)
+				ksdebug(pack, "run-pre: could not match "
+					"section %s\n", sect->symbol->label);
+		}
+		ksdebug(pack, "Aborted.  run-pre: could not match some "
+			"sections.\n");
+		kfree(finished);
+		return NO_MATCH;
+	}
+	kfree(finished);
+	return OK;
+}
+
+static abort_t find_section(struct ksplice_pack *pack,
+			    const struct ksplice_section *sect)
+{
+	int i;
+	abort_t ret;
+	unsigned long run_addr;
+	LIST_HEAD(vals);
+	struct candidate_val *v, *n;
+
+	ret = lookup_symbol(pack, sect->symbol, &vals);
+	if (ret != OK) {
+		release_vals(&vals);
+		return ret;
+	}
+
+	ksdebug(pack, "run-pre: starting sect search for %s\n",
+		sect->symbol->label);
+
+	list_for_each_entry_safe(v, n, &vals, list) {
+		run_addr = v->val;
+
+		yield();
+		ret = try_addr(pack, sect, run_addr, NULL, RUN_PRE_INITIAL);
+		if (ret == NO_MATCH) {
+			list_del(&v->list);
+			kfree(v);
+		} else if (ret != OK) {
+			release_vals(&vals);
+			return ret;
+		}
+	}
+
+	prune_trampoline_vals(pack, &vals);
+	if (singular(&vals)) {
+		LIST_HEAD(safety_records);
+		run_addr = list_entry(vals.next, struct candidate_val,
+				      list)->val;
+		ret = try_addr(pack, sect, run_addr, &safety_records,
+			       RUN_PRE_FINAL);
+		release_vals(&vals);
+		if (ret != OK) {
+			clear_list(&safety_records, struct safety_record, list);
+			ksdebug(pack, "run-pre: Final run failed for sect "
+				"%s:\n", sect->symbol->label);
+		} else {
+			list_splice(&safety_records, &pack->safety_records);
+		}
+		return ret;
+	} else if (!list_empty(&vals)) {
+		struct candidate_val *val;
+		ksdebug(pack, "run-pre: multiple candidates for sect %s:\n",
+			sect->symbol->label);
+		i = 0;
+		list_for_each_entry(val, &vals, list) {
+			i++;
+			ksdebug(pack, "%lx\n", val->val);
+			if (i > 5) {
+				ksdebug(pack, "...\n");
+				break;
+			}
+		}
+		release_vals(&vals);
+		return NO_MATCH;
+	}
+	release_vals(&vals);
+	return NO_MATCH;
+}
+
+static abort_t try_addr(struct ksplice_pack *pack,
+			const struct ksplice_section *sect,
+			unsigned long run_addr,
+			struct list_head *safety_records,
+			enum run_pre_mode mode)
+{
+	abort_t ret;
+	const struct module *run_module;
+
+	if ((sect->flags & KSPLICE_SECTION_RODATA) != 0 ||
+	    (sect->flags & KSPLICE_SECTION_DATA) != 0)
+		run_module = __module_data_address(run_addr);
+	else
+		run_module = __module_text_address(run_addr);
+	if (!patches_module(run_module, pack->target)) {
+		ksdebug(pack, "run-pre: ignoring address %lx in other module "
+			"%s for sect %s\n", run_addr, run_module == NULL ?
+			"vmlinux" : run_module->name, sect->symbol->label);
+		return NO_MATCH;
+	}
+
+	ret = create_labelval(pack, sect->symbol->label, run_addr, TEMP);
+	if (ret != OK)
+		return ret;
+
+	ret = run_pre_cmp(pack, sect, run_addr, safety_records, mode);
+	if (ret == NO_MATCH && mode != RUN_PRE_FINAL) {
+		set_temp_labelvals(pack, NOVAL);
+		ksdebug(pack, "run-pre: %s sect %s does not match (r_a=%lx "
+			"p_a=%lx s=%lx)\n",
+			(sect->flags & KSPLICE_SECTION_RODATA) != 0 ? "data" :
+			"text", sect->symbol->label, run_addr, sect->address,
+			sect->size);
+		ksdebug(pack, "run-pre: ");
+		if (pack->update->debug >= 1) {
+			ret = run_pre_cmp(pack, sect, run_addr, safety_records,
+					  RUN_PRE_DEBUG);
+			set_temp_labelvals(pack, NOVAL);
+		}
+		ksdebug(pack, "\n");
+		return ret;
+	} else if (ret != OK) {
+		set_temp_labelvals(pack, NOVAL);
+		return ret;
+	}
+
+	if (mode != RUN_PRE_FINAL) {
+		set_temp_labelvals(pack, NOVAL);
+		ksdebug(pack, "run-pre: candidate for sect %s=%lx\n",
+			sect->symbol->label, run_addr);
+		return OK;
+	}
+
+	set_temp_labelvals(pack, VAL);
+	ksdebug(pack, "run-pre: found sect %s=%lx\n", sect->symbol->label,
+		run_addr);
+	return OK;
+}
+
+static abort_t run_pre_cmp(struct ksplice_pack *pack,
+			   const struct ksplice_section *sect,
+			   unsigned long run_addr,
+			   struct list_head *safety_records,
+			   enum run_pre_mode mode)
+{
+	int matched = 0;
+	abort_t ret;
+	const struct ksplice_reloc *r;
+	const unsigned char *pre, *run, *pre_start, *run_start;
+	unsigned char runval;
+
+	if ((sect->flags & KSPLICE_SECTION_TEXT) != 0)
+		run_addr = follow_trampolines(pack, run_addr);
+
+	pre_start = (const unsigned char *)sect->address;
+	run_start = (const unsigned char *)run_addr;
+
+	pre = pre_start;
+	run = run_start;
+	while (pre < pre_start + sect->size) {
+		unsigned long offset = pre - pre_start;
+		ret = lookup_reloc(pack, (unsigned long)pre, &r);
+		if (ret == OK) {
+			ret = handle_reloc(pack, r, (unsigned long)run, mode);
+			if (ret != OK) {
+				if (mode == RUN_PRE_INITIAL)
+					ksdebug(pack, "reloc in sect does not "
+						"match after %lx/%lx bytes\n",
+						offset, sect->size);
+				return ret;
+			}
+			if (mode == RUN_PRE_DEBUG)
+				print_bytes(pack, run, r->size, pre, r->size);
+			pre += r->size;
+			run += r->size;
+			continue;
+		} else if (ret != NO_MATCH) {
+			return ret;
+		}
+
+		if ((sect->flags & KSPLICE_SECTION_TEXT) != 0) {
+			ret = handle_paravirt(pack, (unsigned long)pre,
+					      (unsigned long)run, &matched);
+			if (ret != OK)
+				return ret;
+			if (matched != 0) {
+				if (mode == RUN_PRE_DEBUG)
+					print_bytes(pack, run, matched, pre,
+						    matched);
+				pre += matched;
+				run += matched;
+				continue;
+			}
+		}
+
+		if (probe_kernel_read(&runval, (void *)run, 1) == -EFAULT) {
+			if (mode == RUN_PRE_INITIAL)
+				ksdebug(pack, "sect unmapped after %lx/%lx "
+					"bytes\n", offset, sect->size);
+			return NO_MATCH;
+		}
+
+		if (runval != *pre &&
+		    (sect->flags & KSPLICE_SECTION_DATA) == 0) {
+			if (mode == RUN_PRE_INITIAL)
+				ksdebug(pack, "sect does not match after "
+					"%lx/%lx bytes\n", offset, sect->size);
+			if (mode == RUN_PRE_DEBUG) {
+				print_bytes(pack, run, 1, pre, 1);
+				ksdebug(pack, "[p_o=%lx] ! ", offset);
+				print_bytes(pack, run + 1, 2, pre + 1, 2);
+			}
+			return NO_MATCH;
+		}
+		if (mode == RUN_PRE_DEBUG)
+			print_bytes(pack, run, 1, pre, 1);
+		pre++;
+		run++;
+	}
+	return create_safety_record(pack, sect, safety_records, run_addr,
+				    run - run_start);
+}
+
+static void print_bytes(struct ksplice_pack *pack,
+			const unsigned char *run, int runc,
+			const unsigned char *pre, int prec)
+{
+	int o;
+	int matched = min(runc, prec);
+	for (o = 0; o < matched; o++) {
+		if (run[o] == pre[o])
+			ksdebug(pack, "%02x ", run[o]);
+		else
+			ksdebug(pack, "%02x/%02x ", run[o], pre[o]);
+	}
+	for (o = matched; o < runc; o++)
+		ksdebug(pack, "%02x/ ", run[o]);
+	for (o = matched; o < prec; o++)
+		ksdebug(pack, "/%02x ", pre[o]);
+}
+
+static abort_t lookup_reloc(struct ksplice_pack *pack, unsigned long addr,
+			    const struct ksplice_reloc **relocp)
+{
+	const struct ksplice_reloc *r;
+	int canary_ret;
+	for (r = pack->helper_relocs; r < pack->helper_relocs_end; r++) {
+		if (addr >= r->blank_addr && addr < r->blank_addr + r->size) {
+			canary_ret = contains_canary(pack, r->blank_addr,
+						     r->size, r->dst_mask);
+			if (canary_ret < 0)
+				return UNEXPECTED;
+			if (canary_ret == 0) {
+				ksdebug(pack, "reloc: skipped %s:%lx "
+					"(altinstr)\n", r->symbol->label,
+					r->blank_offset);
+				return NO_MATCH;
+			}
+			if (addr != r->blank_addr) {
+				ksdebug(pack, "Invalid nonzero relocation "
+					"offset\n");
+				return UNEXPECTED;
+			}
+			*relocp = r;
+			return OK;
+		}
+	}
+	return NO_MATCH;
+}
+
+static abort_t handle_reloc(struct ksplice_pack *pack,
+			    const struct ksplice_reloc *r,
+			    unsigned long run_addr, enum run_pre_mode mode)
+{
+	unsigned long val;
+	abort_t ret;
+
+	ret = read_reloc_value(pack, r, run_addr, &val);
+	if (ret != OK)
+		return ret;
+	if (r->pcrel)
+		val += run_addr;
+
+	if (mode == RUN_PRE_INITIAL)
+		ksdebug(pack, "run-pre: reloc at r_a=%lx p_a=%lx to %s+%lx: "
+			"found %s = %lx\n", run_addr, r->blank_addr,
+			r->symbol->label, r->addend, r->symbol->label, val);
+
+	if (starts_with(r->symbol->label, ".rodata.str"))
+		return OK;
+
+	if (contains_canary(pack, run_addr, r->size, r->dst_mask) != 0) {
+		ksdebug(pack, "Aborted.  Unexpected canary in run code at %lx"
+			"\n", run_addr);
+		return UNEXPECTED;
+	}
+
+	ret = create_labelval(pack, r->symbol->label, val, TEMP);
+	if (ret == NO_MATCH && mode == RUN_PRE_INITIAL) {
+		struct labelval *lv = find_labelval(pack, r->symbol->label);
+		ksdebug(pack, "run-pre: reloc at r_a=%lx p_a=%lx: labelval %s "
+			"= %lx(%d) does not match expected %lx\n", run_addr,
+			r->blank_addr, r->symbol->label, lv->val, lv->status,
+			val);
+	}
+	return ret;
+}
+
+static abort_t lookup_symbol(struct ksplice_pack *pack,
+			     const struct ksplice_symbol *ksym,
+			     struct list_head *vals)
+{
+	abort_t ret;
+	struct labelval *lv;
+
+	lv = find_labelval(pack, ksym->label);
+	if (lv != NULL) {
+		release_vals(vals);
+		ksdebug(pack, "using detected sym %s=%lx\n", ksym->label,
+			lv->val);
+		return add_candidate_val(vals, lv->val);
+	}
+
+	if (starts_with(ksym->label, ".rodata.str"))
+		return OK;
+
+	if (strcmp(ksym->label, "cleanup_module") == 0 && pack->target != NULL
+	    && pack->target->exit != NULL) {
+		ret = add_candidate_val(vals,
+					(unsigned long)pack->target->exit);
+		if (ret != OK)
+			return ret;
+	}
+
+	ret = exported_symbol_lookup(ksym->name, vals);
+	if (ret != OK)
+		return ret;
+
+	ret = new_export_lookup(pack->update, ksym->name, vals);
+	if (ret != OK)
+		return ret;
+
+	ret = lookup_symbol_kallsyms(pack, ksym->name, vals);
+	if (ret != OK)
+		return ret;
+
+	return OK;
+}
+
+static abort_t lookup_symbol_kallsyms(struct ksplice_pack *pack,
+				      const char *name, struct list_head *vals)
+{
+	struct accumulate_struct acc = { pack, name, vals };
+	return (__force abort_t)
+	    kallsyms_on_each_symbol(accumulate_matching_names, &acc);
+}
+
+static int accumulate_matching_names(void *data, const char *sym_name,
+				     struct module *sym_owner,
+				     unsigned long sym_val)
+{
+	struct accumulate_struct *acc = data;
+	if (strcmp(sym_name, acc->desired_name) == 0 &&
+	    patches_module(sym_owner, acc->pack->target) &&
+	    sym_owner != acc->pack->primary)
+		return (__force int)add_candidate_val(acc->vals, sym_val);
+	return (__force int)OK;
+}
+
+static abort_t exported_symbol_lookup(const char *name, struct list_head *vals)
+{
+	const struct kernel_symbol *sym;
+	sym = find_symbol(name, NULL, NULL, true, false);
+	if (sym == NULL)
+		return OK;
+	return add_candidate_val(vals, sym->value);
+}
+
+static abort_t new_export_lookup(struct update *update,
+				 const char *name, struct list_head *vals)
+{
+	struct ksplice_pack *pack;
+	struct ksplice_export *exp;
+	list_for_each_entry(pack, &update->packs, list) {
+		for (exp = pack->exports; exp < pack->exports_end; exp++) {
+			if (strcmp(exp->new_name, name) == 0 &&
+			    exp->sym != NULL &&
+			    contains_canary(pack,
+					    (unsigned long)&exp->sym->value,
+					    sizeof(unsigned long), -1) == 0)
+				return add_candidate_val(vals, exp->sym->value);
+		}
+	}
+	return OK;
+}
+
+static abort_t apply_patches(struct update *update)
+{
+	int i;
+	abort_t ret;
+	struct ksplice_pack *pack;
+	const struct ksplice_section *sect;
+
+	list_for_each_entry(pack, &update->packs, list) {
+		for (sect = pack->primary_sections;
+		     sect < pack->primary_sections_end; sect++) {
+			ret = create_safety_record(pack, sect,
+						   &pack->safety_records,
+						   sect->address, sect->size);
+			if (ret != OK)
+				return ret;
+		}
+	}
+
+	for (i = 0; i < 5; i++) {
+		cleanup_conflicts(update);
+		ret = (__force abort_t)stop_machine(__apply_patches, update,
+						    NULL);
+		if (ret != CODE_BUSY)
+			break;
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(msecs_to_jiffies(1000));
+	}
+
+	if (ret == CODE_BUSY) {
+		print_conflicts(update);
+		_ksdebug(update, "Aborted %s.  stack check: to-be-replaced "
+			 "code is busy.\n", update->kid);
+	} else if (ret == ALREADY_REVERSED) {
+		_ksdebug(update, "Aborted %s.  Ksplice update %s is already "
+			 "reversed.\n", update->kid, update->kid);
+	}
+
+	if (ret != OK)
+		return ret;
+
+	_ksdebug(update, "Atomic patch insertion for %s complete\n",
+		 update->kid);
+	return OK;
+}
+
+static abort_t reverse_patches(struct update *update)
+{
+	int i;
+	abort_t ret;
+	struct ksplice_pack *pack;
+
+	clear_debug_buf(update);
+	ret = init_debug_buf(update);
+	if (ret != OK)
+		return ret;
+
+	_ksdebug(update, "Preparing to reverse %s\n", update->kid);
+
+	for (i = 0; i < 5; i++) {
+		cleanup_conflicts(update);
+		clear_list(&update->conflicts, struct conflict, list);
+		ret = (__force abort_t)stop_machine(__reverse_patches, update,
+						    NULL);
+		if (ret != CODE_BUSY)
+			break;
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(msecs_to_jiffies(1000));
+	}
+	list_for_each_entry(pack, &update->packs, list)
+		clear_list(&pack->safety_records, struct safety_record, list);
+
+	if (ret == CODE_BUSY) {
+		print_conflicts(update);
+		_ksdebug(update, "Aborted %s.  stack check: to-be-reversed "
+			 "code is busy.\n", update->kid);
+	} else if (ret == MODULE_BUSY) {
+		_ksdebug(update, "Update %s is in use by another module\n",
+			 update->kid);
+	}
+
+	if (ret != OK)
+		return ret;
+
+	_ksdebug(update, "Atomic patch removal for %s complete\n", update->kid);
+	return OK;
+}
+
+static int __apply_patches(void *updateptr)
+{
+	struct update *update = updateptr;
+	struct ksplice_pack *pack;
+	struct ksplice_patch *p;
+	struct ksplice_export *exp;
+	abort_t ret;
+
+	if (update->stage == STAGE_APPLIED)
+		return (__force int)OK;
+
+	if (update->stage != STAGE_PREPARING)
+		return (__force int)UNEXPECTED;
+
+	ret = check_each_task(update);
+	if (ret != OK)
+		return (__force int)ret;
+
+	list_for_each_entry(pack, &update->packs, list) {
+		if (try_module_get(pack->primary) != 1) {
+			struct ksplice_pack *pack1;
+			list_for_each_entry(pack1, &update->packs, list) {
+				if (pack1 == pack)
+					break;
+				module_put(pack1->primary);
+			}
+			return (__force int)UNEXPECTED;
+		}
+	}
+
+	update->stage = STAGE_APPLIED;
+
+	list_for_each_entry(pack, &update->packs, list)
+		list_add(&pack->module_list_entry.list, &ksplice_module_list);
+
+	list_for_each_entry(pack, &update->packs, list) {
+		for (exp = pack->exports; exp < pack->exports_end; exp++)
+			exp->sym->name = exp->new_name;
+	}
+
+	list_for_each_entry(pack, &update->packs, list) {
+		for (p = pack->patches; p < pack->patches_end; p++) {
+			insert_trampoline(&p->trampoline);
+			insert_trampoline(&p->reverse_trampoline);
+		}
+	}
+	return (__force int)OK;
+}
+
+static int __reverse_patches(void *updateptr)
+{
+	struct update *update = updateptr;
+	struct ksplice_pack *pack;
+	const struct ksplice_patch *p;
+	struct ksplice_export *exp;
+	abort_t ret;
+
+	if (update->stage != STAGE_APPLIED)
+		return (__force int)OK;
+
+	list_for_each_entry(pack, &update->packs, list) {
+		if (module_refcount(pack->primary) != 1)
+			return (__force int)MODULE_BUSY;
+	}
+
+	ret = check_each_task(update);
+	if (ret != OK)
+		return (__force int)ret;
+
+	list_for_each_entry(pack, &update->packs, list) {
+		for (p = pack->patches; p < pack->patches_end; p++) {
+			ret = verify_trampoline(pack, &p->trampoline);
+			if (ret != OK)
+				return (__force int)ret;
+			ret = verify_trampoline(pack, &p->reverse_trampoline);
+			if (ret != OK)
+				return (__force int)ret;
+		}
+	}
+
+	update->stage = STAGE_REVERSED;
+
+	list_for_each_entry(pack, &update->packs, list)
+		module_put(pack->primary);
+
+	list_for_each_entry(pack, &update->packs, list)
+		list_del(&pack->module_list_entry.list);
+
+	list_for_each_entry(pack, &update->packs, list) {
+		for (exp = pack->exports; exp < pack->exports_end; exp++)
+			exp->sym->name = exp->saved_name;
+	}
+
+	list_for_each_entry(pack, &update->packs, list) {
+		for (p = pack->patches; p < pack->patches_end; p++) {
+			remove_trampoline(&p->trampoline);
+			remove_trampoline(&p->reverse_trampoline);
+		}
+	}
+	return (__force int)OK;
+}
+
+static abort_t check_each_task(struct update *update)
+{
+	const struct task_struct *g, *p;
+	abort_t status = OK, ret;
+	do_each_thread(g, p) {
+		/* do_each_thread is a double loop! */
+		ret = check_task(update, p, false);
+		if (ret != OK) {
+			check_task(update, p, true);
+			status = ret;
+		}
+		if (ret != OK && ret != CODE_BUSY)
+			return ret;
+	} while_each_thread(g, p);
+	return status;
+}
+
+static abort_t check_task(struct update *update,
+			  const struct task_struct *t, bool rerun)
+{
+	abort_t status, ret;
+	struct conflict *conf = NULL;
+
+	if (rerun) {
+		conf = kmalloc(sizeof(*conf), GFP_ATOMIC);
+		if (conf == NULL)
+			return OUT_OF_MEMORY;
+		conf->process_name = kstrdup(t->comm, GFP_ATOMIC);
+		if (conf->process_name == NULL) {
+			kfree(conf);
+			return OUT_OF_MEMORY;
+		}
+		conf->pid = t->pid;
+		INIT_LIST_HEAD(&conf->stack);
+		list_add(&conf->list, &update->conflicts);
+	}
+
+	status = check_address(update, conf, KSPLICE_IP(t));
+	if (t == current) {
+		ret = check_stack(update, conf, task_thread_info(t),
+				  (unsigned long *)__builtin_frame_address(0));
+		if (status == OK)
+			status = ret;
+	} else if (!task_curr(t)) {
+		ret = check_stack(update, conf, task_thread_info(t),
+				  (unsigned long *)KSPLICE_SP(t));
+		if (status == OK)
+			status = ret;
+	} else if (!is_stop_machine(t)) {
+		status = UNEXPECTED_RUNNING_TASK;
+	}
+	return status;
+}
+
+static abort_t check_stack(struct update *update, struct conflict *conf,
+			   const struct thread_info *tinfo,
+			   const unsigned long *stack)
+{
+	abort_t status = OK, ret;
+	unsigned long addr;
+
+	while (valid_stack_ptr(tinfo, stack)) {
+		addr = *stack++;
+		ret = check_address(update, conf, addr);
+		if (ret != OK)
+			status = ret;
+	}
+	return status;
+}
+
+static abort_t check_address(struct update *update,
+			     struct conflict *conf, unsigned long addr)
+{
+	abort_t status = OK, ret;
+	const struct safety_record *rec;
+	struct ksplice_pack *pack;
+	struct conflict_addr *ca = NULL;
+
+	if (conf != NULL) {
+		ca = kmalloc(sizeof(*ca), GFP_ATOMIC);
+		if (ca == NULL)
+			return OUT_OF_MEMORY;
+		ca->addr = addr;
+		ca->has_conflict = false;
+		ca->label = NULL;
+		list_add(&ca->list, &conf->stack);
+	}
+
+	list_for_each_entry(pack, &update->packs, list) {
+		list_for_each_entry(rec, &pack->safety_records, list) {
+			ret = check_record(ca, rec, addr);
+			if (ret != OK)
+				status = ret;
+		}
+	}
+	return status;
+}
+
+static abort_t check_record(struct conflict_addr *ca,
+			    const struct safety_record *rec, unsigned long addr)
+{
+	if ((addr > rec->addr && addr < rec->addr + rec->size) ||
+	    (addr == rec->addr && !rec->first_byte_safe)) {
+		if (ca != NULL) {
+			ca->label = rec->label;
+			ca->has_conflict = true;
+		}
+		return CODE_BUSY;
+	}
+	return OK;
+}
+
+static bool is_stop_machine(const struct task_struct *t)
+{
+	const char *num;
+	if (!starts_with(t->comm, "kstop"))
+		return false;
+	num = t->comm + strlen("kstop");
+	return num[strspn(num, "0123456789")] == '\0';
+}
+
+static void cleanup_conflicts(struct update *update)
+{
+	struct conflict *conf;
+	list_for_each_entry(conf, &update->conflicts, list) {
+		clear_list(&conf->stack, struct conflict_addr, list);
+		kfree(conf->process_name);
+	}
+	clear_list(&update->conflicts, struct conflict, list);
+}
+
+static void print_conflicts(struct update *update)
+{
+	const struct conflict *conf;
+	const struct conflict_addr *ca;
+	list_for_each_entry(conf, &update->conflicts, list) {
+		_ksdebug(update, "stack check: pid %d (%s):", conf->pid,
+			 conf->process_name);
+		list_for_each_entry(ca, &conf->stack, list) {
+			_ksdebug(update, " %lx", ca->addr);
+			if (ca->has_conflict)
+				_ksdebug(update, " [<-CONFLICT]");
+		}
+		_ksdebug(update, "\n");
+	}
+}
+
+static void insert_trampoline(struct ksplice_trampoline *t)
+{
+	mm_segment_t old_fs = get_fs();
+	set_fs(KERNEL_DS);
+	memcpy((void *)t->saved, (void *)t->oldaddr, t->size);
+	memcpy((void *)t->oldaddr, (void *)t->trampoline, t->size);
+	flush_icache_range(t->oldaddr, t->oldaddr + t->size);
+	set_fs(old_fs);
+}
+
+static abort_t verify_trampoline(struct ksplice_pack *pack,
+				 const struct ksplice_trampoline *t)
+{
+	if (memcmp((void *)t->oldaddr, (void *)t->trampoline, t->size) != 0) {
+		ksdebug(pack, "Aborted.  Trampoline at %lx has been "
+			"overwritten.\n", t->oldaddr);
+		return CODE_BUSY;
+	}
+	return OK;
+}
+
+static void remove_trampoline(const struct ksplice_trampoline *t)
+{
+	mm_segment_t old_fs = get_fs();
+	set_fs(KERNEL_DS);
+	memcpy((void *)t->oldaddr, (void *)t->saved, t->size);
+	flush_icache_range(t->oldaddr, t->oldaddr + t->size);
+	set_fs(old_fs);
+}
+
+static struct labelval *find_labelval(struct ksplice_pack *pack,
+				      const char *label)
+{
+	struct labelval *lv;
+	list_for_each_entry(lv, &pack->labelvals, list) {
+		if (strcmp(lv->label, label) == 0)
+			return lv;
+	}
+	return NULL;
+}
+
+static abort_t create_labelval(struct ksplice_pack *pack, const char *label,
+			       unsigned long val, int status)
+{
+	struct labelval *lv = find_labelval(pack, label);
+	if (lv != NULL)
+		return lv->val == val ? OK : NO_MATCH;
+
+	lv = kmalloc(sizeof(*lv), GFP_KERNEL);
+	if (lv == NULL)
+		return OUT_OF_MEMORY;
+	lv->label = label;
+	lv->val = val;
+	lv->status = status;
+	list_add(&lv->list, &pack->labelvals);
+	return OK;
+}
+
+static abort_t create_safety_record(struct ksplice_pack *pack,
+				    const struct ksplice_section *sect,
+				    struct list_head *record_list,
+				    unsigned long run_addr,
+				    unsigned long run_size)
+{
+	struct safety_record *rec;
+	struct ksplice_patch *p;
+
+	if (record_list == NULL)
+		return OK;
+
+	for (p = pack->patches; p < pack->patches_end; p++) {
+		if (strcmp(sect->symbol->label, p->label) == 0)
+			break;
+	}
+	if (p >= pack->patches_end)
+		return OK;
+
+	if ((sect->flags & KSPLICE_SECTION_TEXT) == 0 &&
+	    p->trampoline.repladdr != 0) {
+		ksdebug(pack, "Error: ksplice_patch %s is matched to a "
+			"non-deleted non-text section!\n", sect->symbol->label);
+		return UNEXPECTED;
+	}
+
+	rec = kmalloc(sizeof(*rec), GFP_KERNEL);
+	if (rec == NULL)
+		return OUT_OF_MEMORY;
+	rec->addr = run_addr;
+	rec->size = run_size;
+	rec->label = sect->symbol->label;
+	rec->first_byte_safe = false;
+
+	list_add(&rec->list, record_list);
+	return OK;
+}
+
+static abort_t add_candidate_val(struct list_head *vals, unsigned long val)
+{
+	struct candidate_val *tmp, *new;
+
+	list_for_each_entry(tmp, vals, list) {
+		if (tmp->val == val)
+			return OK;
+	}
+	new = kmalloc(sizeof(*new), GFP_KERNEL);
+	if (new == NULL)
+		return OUT_OF_MEMORY;
+	new->val = val;
+	list_add(&new->list, vals);
+	return OK;
+}
+
+/* If there are only two candidates and their addresses are related by
+   a trampoline, then we have successfully found a function patched by a
+   previous update.  We remove the endpoint of the trampoline from the vals
+   list, so that this update uses the patched function's original address. */
+static void prune_trampoline_vals(struct ksplice_pack *pack,
+				  struct list_head *vals)
+{
+	struct candidate_val *val1, *val2;
+
+	if (list_empty(vals) || singular(vals))
+		return;
+	if (vals->next->next->next != vals)
+		return;
+
+	val1 = list_entry(vals->next, struct candidate_val, list);
+	val2 = list_entry(vals->next->next, struct candidate_val, list);
+
+	if (val1->val == follow_trampolines(pack, val2->val)) {
+		list_del(&val1->list);
+		kfree(val1);
+		return;
+	}
+	if (val2->val == follow_trampolines(pack, val1->val)) {
+		list_del(&val2->list);
+		kfree(val2);
+		return;
+	}
+}
+
+static void release_vals(struct list_head *vals)
+{
+	clear_list(vals, struct candidate_val, list);
+}
+
+static void set_temp_labelvals(struct ksplice_pack *pack, int status)
+{
+	struct labelval *lv, *n;
+	list_for_each_entry_safe(lv, n, &pack->labelvals, list) {
+		if (lv->status == TEMP) {
+			if (status == NOVAL) {
+				list_del(&lv->list);
+				kfree(lv);
+			} else {
+				lv->status = status;
+			}
+		}
+	}
+}
+
+static int contains_canary(struct ksplice_pack *pack, unsigned long blank_addr,
+			   int size, long dst_mask)
+{
+	switch (size) {
+	case 1:
+		return (*(uint8_t *)blank_addr & dst_mask) ==
+		    (KSPLICE_CANARY & dst_mask);
+	case 2:
+		return (*(uint16_t *)blank_addr & dst_mask) ==
+		    (KSPLICE_CANARY & dst_mask);
+	case 4:
+		return (*(uint32_t *)blank_addr & dst_mask) ==
+		    (KSPLICE_CANARY & dst_mask);
+#if BITS_PER_LONG >= 64
+	case 8:
+		return (*(uint64_t *)blank_addr & dst_mask) ==
+		    (KSPLICE_CANARY & dst_mask);
+#endif /* BITS_PER_LONG */
+	default:
+		ksdebug(pack, "Aborted.  Invalid relocation size.\n");
+		return -1;
+	}
+}
+
+static unsigned long follow_trampolines(struct ksplice_pack *pack,
+					unsigned long addr)
+{
+	unsigned long new_addr;
+	struct module *m;
+
+	if (trampoline_target(pack, addr, &new_addr) != OK)
+		return addr;
+
+	/* Confirm that it is a jump into a ksplice module */
+	m = __module_text_address(new_addr);
+	if (m != NULL && m != pack->target && starts_with(m->name, "ksplice")) {
+		ksdebug(pack, "Following trampoline %lx %lx(%s)\n", addr,
+			new_addr, m->name);
+		return new_addr;
+	}
+	return addr;
+}
+
+/* Does module a patch module b? */
+static bool patches_module(const struct module *a, const struct module *b)
+{
+	struct ksplice_module_list_entry *entry;
+	if (a == b)
+		return true;
+	list_for_each_entry(entry, &ksplice_module_list, list) {
+		if (entry->target == b && entry->primary == a)
+			return true;
+	}
+	return false;
+}
+
+static bool starts_with(const char *str, const char *prefix)
+{
+	return strncmp(str, prefix, strlen(prefix)) == 0;
+}
+
+static bool singular(struct list_head *list)
+{
+	return !list_empty(list) && list->next->next == list;
+}
+
+#ifdef CONFIG_DEBUG_FS
+
+static abort_t init_debug_buf(struct update *update)
+{
+	update->debug_blob.size = 0;
+	update->debug_blob.data = NULL;
+	update->debugfs_dentry =
+	    debugfs_create_blob(update->name, S_IFREG | S_IRUSR, NULL,
+				&update->debug_blob);
+	if (update->debugfs_dentry == NULL)
+		return OUT_OF_MEMORY;
+	return OK;
+}
+
+static void clear_debug_buf(struct update *update)
+{
+	if (update->debugfs_dentry == NULL)
+		return;
+	debugfs_remove(update->debugfs_dentry);
+	update->debugfs_dentry = NULL;
+	update->debug_blob.size = 0;
+	vfree(update->debug_blob.data);
+	update->debug_blob.data = NULL;
+}
+
+static int _ksdebug(struct update *update, const char *fmt, ...)
+{
+	va_list args;
+	unsigned long size, old_size, new_size;
+
+	if (update->debug == 0)
+		return 0;
+
+	/* size includes the trailing '\0' */
+	va_start(args, fmt);
+	size = 1 + vsnprintf(update->debug_blob.data, 0, fmt, args);
+	va_end(args);
+	old_size = update->debug_blob.size == 0 ? 0 :
+	    max(PAGE_SIZE, roundup_pow_of_two(update->debug_blob.size));
+	new_size = update->debug_blob.size + size == 0 ? 0 :
+	    max(PAGE_SIZE, roundup_pow_of_two(update->debug_blob.size + size));
+	if (new_size > old_size) {
+		char *buf = vmalloc(new_size);
+		if (buf == NULL)
+			return -ENOMEM;
+		memcpy(buf, update->debug_blob.data, update->debug_blob.size);
+		vfree(update->debug_blob.data);
+		update->debug_blob.data = buf;
+	}
+	va_start(args, fmt);
+	update->debug_blob.size += vsnprintf(update->debug_blob.data +
+					     update->debug_blob.size,
+					     size, fmt, args);
+	va_end(args);
+	return 0;
+}
+#else /* CONFIG_DEBUG_FS */
+static abort_t init_debug_buf(struct update *update)
+{
+	return OK;
+}
+
+static void clear_debug_buf(struct update *update)
+{
+	return;
+}
+
+static int _ksdebug(struct update *update, const char *fmt, ...)
+{
+	va_list args;
+
+	if (update->debug == 0)
+		return 0;
+
+	if (!update->debug_continue_line)
+		printk(KERN_DEBUG "ksplice: ");
+
+	va_start(args, fmt);
+	vprintk(fmt, args);
+	va_end(args);
+
+	update->debug_continue_line =
+	    fmt[0] == '\0' || fmt[strlen(fmt) - 1] != '\n';
+	return 0;
+}
+#endif /* CONFIG_DEBUG_FS */
+
+struct ksplice_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct update *update, char *buf);
+	ssize_t (*store)(struct update *update, const char *buf, size_t len);
+};
+
+static ssize_t ksplice_attr_show(struct kobject *kobj, struct attribute *attr,
+				 char *buf)
+{
+	struct ksplice_attribute *attribute =
+	    container_of(attr, struct ksplice_attribute, attr);
+	struct update *update = container_of(kobj, struct update, kobj);
+	if (attribute->show == NULL)
+		return -EIO;
+	return attribute->show(update, buf);
+}
+
+static ssize_t ksplice_attr_store(struct kobject *kobj, struct attribute *attr,
+				  const char *buf, size_t len)
+{
+	struct ksplice_attribute *attribute =
+	    container_of(attr, struct ksplice_attribute, attr);
+	struct update *update = container_of(kobj, struct update, kobj);
+	if (attribute->store == NULL)
+		return -EIO;
+	return attribute->store(update, buf, len);
+}
+
+static struct sysfs_ops ksplice_sysfs_ops = {
+	.show = ksplice_attr_show,
+	.store = ksplice_attr_store,
+};
+
+static void ksplice_release(struct kobject *kobj)
+{
+	struct update *update;
+	update = container_of(kobj, struct update, kobj);
+	cleanup_ksplice_update(update);
+}
+
+static ssize_t stage_show(struct update *update, char *buf)
+{
+	switch (update->stage) {
+	case STAGE_PREPARING:
+		return snprintf(buf, PAGE_SIZE, "preparing\n");
+	case STAGE_APPLIED:
+		return snprintf(buf, PAGE_SIZE, "applied\n");
+	case STAGE_REVERSED:
+		return snprintf(buf, PAGE_SIZE, "reversed\n");
+	}
+	return 0;
+}
+
+static ssize_t abort_cause_show(struct update *update, char *buf)
+{
+	switch (update->abort_cause) {
+	case OK:
+		return snprintf(buf, PAGE_SIZE, "ok\n");
+	case NO_MATCH:
+		return snprintf(buf, PAGE_SIZE, "no_match\n");
+	case CODE_BUSY:
+		return snprintf(buf, PAGE_SIZE, "code_busy\n");
+	case MODULE_BUSY:
+		return snprintf(buf, PAGE_SIZE, "module_busy\n");
+	case OUT_OF_MEMORY:
+		return snprintf(buf, PAGE_SIZE, "out_of_memory\n");
+	case FAILED_TO_FIND:
+		return snprintf(buf, PAGE_SIZE, "failed_to_find\n");
+	case ALREADY_REVERSED:
+		return snprintf(buf, PAGE_SIZE, "already_reversed\n");
+	case MISSING_EXPORT:
+		return snprintf(buf, PAGE_SIZE, "missing_export\n");
+	case UNEXPECTED_RUNNING_TASK:
+		return snprintf(buf, PAGE_SIZE, "unexpected_running_task\n");
+	case UNEXPECTED:
+		return snprintf(buf, PAGE_SIZE, "unexpected\n");
+	}
+	return 0;
+}
+
+static ssize_t conflict_show(struct update *update, char *buf)
+{
+	const struct conflict *conf;
+	const struct conflict_addr *ca;
+	int used = 0;
+	list_for_each_entry(conf, &update->conflicts, list) {
+		used += snprintf(buf + used, PAGE_SIZE - used, "%s %d",
+				 conf->process_name, conf->pid);
+		list_for_each_entry(ca, &conf->stack, list) {
+			if (!ca->has_conflict)
+				continue;
+			used += snprintf(buf + used, PAGE_SIZE - used, " %s",
+					 ca->label);
+		}
+		used += snprintf(buf + used, PAGE_SIZE - used, "\n");
+	}
+	return used;
+}
+
+static ssize_t stage_store(struct update *update, const char *buf, size_t len)
+{
+	if ((strncmp(buf, "applied", len) == 0 ||
+	     strncmp(buf, "applied\n", len) == 0) &&
+	    update->stage == STAGE_PREPARING)
+		update->abort_cause = apply_update(update);
+	else if ((strncmp(buf, "reversed", len) == 0 ||
+		  strncmp(buf, "reversed\n", len) == 0) &&
+		 update->stage == STAGE_APPLIED)
+		update->abort_cause = reverse_patches(update);
+	if (update->abort_cause == OK)
+		printk(KERN_INFO "ksplice: Update %s %s successfully\n",
+		       update->kid,
+		       update->stage == STAGE_APPLIED ? "applied" : "reversed");
+	return len;
+}
+
+static ssize_t debug_show(struct update *update, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", update->debug);
+}
+
+static ssize_t debug_store(struct update *update, const char *buf, size_t len)
+{
+	unsigned long l;
+	int ret = strict_strtoul(buf, 10, &l);
+	if (ret != 0)
+		return ret;
+	update->debug = l;
+	return len;
+}
+
+static struct ksplice_attribute stage_attribute =
+	__ATTR(stage, 0600, stage_show, stage_store);
+static struct ksplice_attribute abort_cause_attribute =
+	__ATTR(abort_cause, 0400, abort_cause_show, NULL);
+static struct ksplice_attribute debug_attribute =
+	__ATTR(debug, 0600, debug_show, debug_store);
+static struct ksplice_attribute conflict_attribute =
+	__ATTR(conflicts, 0400, conflict_show, NULL);
+
+static struct attribute *ksplice_attrs[] = {
+	&stage_attribute.attr,
+	&abort_cause_attribute.attr,
+	&debug_attribute.attr,
+	&conflict_attribute.attr,
+	NULL
+};
+
+static struct kobj_type ksplice_ktype = {
+	.sysfs_ops = &ksplice_sysfs_ops,
+	.release = ksplice_release,
+	.default_attrs = ksplice_attrs,
+};
+
+static int init_ksplice(void)
+{
+	ksplice_kobj = kobject_create_and_add("ksplice", kernel_kobj);
+	if (ksplice_kobj == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+static void cleanup_ksplice(void)
+{
+	kobject_put(ksplice_kobj);
+}
+
+module_init(init_ksplice);
+module_exit(cleanup_ksplice);
+
+MODULE_AUTHOR("Jeffrey Brian Arnold <jbarnold@mit.edu>");
+MODULE_DESCRIPTION("Ksplice rebootless update system");
+MODULE_LICENSE("GPL v2");
-- 
1.5.4.3

