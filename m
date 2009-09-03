Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbZICU0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbZICU0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 16:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756373AbZICU0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 16:26:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756287AbZICU0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 16:26:04 -0400
Date: Thu, 3 Sep 2009 16:25:53 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, roland@redhat.com, rth@redhat.com,
       mingo@elte.hu
Message-Id: <ab38df71fc02dca84cb0e477672862fd2c743bef.1252007851.git.jbaron@redhat.com>
In-Reply-To: <cover.1252007851.git.jbaron@redhat.com>
References: <cover.1252007851.git.jbaron@redhat.com>
Subject: [PATCH 1/4] RFC: basic jump label implementation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

introduce basic infrastructure for jump patching:

-STATIC_JUMP_IF() macro 
-jump table infrastructure
-jump/nop patching in the ftrace layer



Signed-off-by: Jason Baron <jbaron@redhat.com>

---
 arch/x86/kernel/ftrace.c          |   36 ++++++++++
 include/asm-generic/vmlinux.lds.h |   11 +++
 include/linux/ftrace.h            |    3 +
 include/linux/jump_label.h        |   45 ++++++++++++
 kernel/Makefile                   |    2 +-
 kernel/jump_label.c               |  138 +++++++++++++++++++++++++++++++++++++
 6 files changed, 234 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/jump_label.h
 create mode 100644 kernel/jump_label.c

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 9dbb527..0907b8c 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -67,6 +67,20 @@ static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 	return calc.code;
 }
 
+static unsigned char *ftrace_jump_replace(unsigned long ip, unsigned long addr)
+{
+	static union ftrace_code_union calc;
+
+	calc.e8		= 0xe9;
+	calc.offset	= ftrace_calc_offset(ip + MCOUNT_INSN_SIZE, addr);
+
+	/*
+	 * No locking needed, this must be called via kstop_machine
+	 * which in essence is like running on a uniprocessor machine.
+	 */
+	return calc.code;
+}
+
 /*
  * Modifying code must take extra care. On an SMP machine, if
  * the code being modified is also being executed on another CPU
@@ -278,6 +292,28 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	return ftrace_modify_code(rec->ip, old, new);
 }
 
+int ftrace_make_jump(struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned char *new, *old;
+	unsigned long ip = rec->ip;
+
+	old = ftrace_nop_replace();
+	new = ftrace_jump_replace(ip, addr);
+
+	return ftrace_modify_code(rec->ip, old, new);
+}
+
+int ftrace_make_jump_nop(struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned char *new, *old;
+	unsigned long ip = rec->ip;
+
+	old = ftrace_jump_replace(ip, addr);
+	new = ftrace_nop_replace();
+
+	return ftrace_modify_code(rec->ip, old, new);
+}
+
 int ftrace_update_ftrace_func(ftrace_func_t func)
 {
 	unsigned long ip = (unsigned long)(&ftrace_call);
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index a549465..d789646 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -212,6 +212,7 @@
 		*(__vermagic)		/* Kernel version magic */	\
 		*(__markers_strings)	/* Markers: strings */		\
 		*(__tracepoints_strings)/* Tracepoints: strings */	\
+		*(__jump_strings)/* Jump: strings */	\
 	}								\
 									\
 	.rodata1          : AT(ADDR(.rodata1) - LOAD_OFFSET) {		\
@@ -219,6 +220,8 @@
 	}								\
 									\
 	BUG_TABLE							\
+	JUMP_TABLE							\
+									\
 									\
 	/* PCI quirks */						\
 	.pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {	\
@@ -563,6 +566,14 @@
 #define BUG_TABLE
 #endif
 
+#define JUMP_TABLE							\
+	. = ALIGN(8);							\
+	__jump_table : AT(ADDR(__jump_table) - LOAD_OFFSET) {		\
+		VMLINUX_SYMBOL(__start___jump_table) = .;		\
+		*(__jump_table)						\
+		VMLINUX_SYMBOL(__stop___jump_table) = .;			\
+	}
+
 #ifdef CONFIG_PM_TRACE
 #define TRACEDATA							\
 	. = ALIGN(4);							\
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index dc3b132..cf3d995 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -227,6 +227,9 @@ extern int ftrace_make_nop(struct module *mod,
  * Any other value will be considered a failure.
  */
 extern int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr);
+extern int ftrace_make_jump(struct dyn_ftrace *rec, unsigned long addr);
+extern int ftrace_make_jump_nop(struct dyn_ftrace *rec, unsigned long addr);
+
 
 /* May be defined in arch */
 extern int ftrace_arch_read_dyn_info(char *buf, int size);
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
new file mode 100644
index 0000000..1b80bbe
--- /dev/null
+++ b/include/linux/jump_label.h
@@ -0,0 +1,45 @@
+#ifndef _LINUX_JUMP_LABEL_H
+#define _LINUX_JUMP_LABEL_H
+
+#include <asm/nops.h>
+
+/* this will change to a compiler dependency that supports 'asm goto' */
+#define HAVE_JUMP_LABEL
+
+#ifdef HAVE_JUMP_LABEL
+
+#define JUMP_LABEL_NAME(tag)						\
+	const char __sjstrtab_##tag[]					\
+	__used __attribute__((section("__jump_strings")))  = #tag;
+
+#define JUMP_LABEL_IF(tag, label, cond)					\
+	asm goto ("1:"   /* 5-byte insn */				\
+	   P6_NOP5							\
+		".pushsection __jump_table,  \"a\" \n\t"		\
+		_ASM_PTR "1b, %l[" #label "], %c0 \n\t"			\
+		".popsection \n\t"					\
+		: :  "i" (__sjstrtab_##tag) :  : label)
+
+int run_make_nop(char *name);
+int run_make_jump(char *name);
+
+#else
+
+#define JUMP_LABEL_NAME(tag)
+#define JUMP_LABEL_IF(tag, label, cond)		\
+	if (unlikely(cond))			\
+		goto label;
+
+static inline int run_make_nop(char *name)
+{
+	return 0;
+}
+
+static inline int run_make_jump(char *name)
+{
+	return 0;
+}
+
+#endif
+
+#endif
diff --git a/kernel/Makefile b/kernel/Makefile
index ef1011b..d29ae98 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
-	    async.o
+	    async.o jump_label.o
 obj-y += groups.o
 
 ifdef CONFIG_FUNCTION_TRACER
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
new file mode 100644
index 0000000..f6be1eb
--- /dev/null
+++ b/kernel/jump_label.c
@@ -0,0 +1,138 @@
+#include <linux/init.h>
+#include <linux/debugfs.h>
+#include <linux/jump_label.h>
+#include <linux/stop_machine.h>
+#include <linux/ftrace.h>
+#include <linux/uaccess.h>
+
+#include <asm/cacheflush.h>
+
+JUMP_LABEL_NAME(trace);
+JUMP_LABEL_NAME(trace2);
+
+static int jump_enabled;
+static int jump_enabled2;
+
+#ifdef HAVE_JUMP_LABEL
+
+extern int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr);
+
+struct jump_entry {
+	unsigned long code;
+	unsigned long target;
+	char *name;
+};
+
+extern struct jump_entry __start___jump_table[];
+extern struct jump_entry __stop___jump_table[];
+
+struct jump_entry *find_jump_entry(char *name)
+{
+
+	struct jump_entry *iter;
+
+	for (iter = __start___jump_table; iter < __stop___jump_table; iter++) {
+		if (!strcmp(name, iter->name)) {
+			printk("find_jump_entry matched: %s\n", iter->name);
+			return iter;
+		}
+	}
+	return NULL;
+}
+
+/* hard coded for testing */
+static int enable_jump(void *ptr)
+{
+	struct dyn_ftrace rec;
+	struct jump_entry *jentry;
+	unsigned long code, target;
+	int ret;
+
+	jentry = ((struct jump_entry *)ptr);
+	code = jentry->code;
+	target = jentry->target;
+	rec.ip = code;
+	ret = ftrace_make_jump(&rec, target);
+
+	return 0;
+}
+
+/* hard coded for testing */
+static int enable_nop(void *ptr)
+{
+	struct dyn_ftrace rec;
+	struct jump_entry *jentry;
+	unsigned long code, target;
+	int ret;
+
+	jentry = ((struct jump_entry *)ptr);
+	code = jentry->code;
+	target = jentry->target;
+	rec.ip = code;
+	ret = ftrace_make_jump_nop(&rec, target);
+
+	return 0;
+}
+
+int run_make_jump(char *name)
+{
+	int ret;
+	struct jump_entry *jentry;
+
+	jentry = find_jump_entry(name);
+	if (!jentry)
+		return -ENOENT;
+
+	ret = ftrace_arch_code_modify_prepare();
+	WARN_ON(ret);
+	if (ret)
+		return -1;
+
+	stop_machine(enable_jump, (void *)jentry, NULL);
+
+	ret = ftrace_arch_code_modify_post_process();
+	WARN_ON(ret);
+
+	return 0;
+}
+
+int run_make_nop(char *name)
+{
+	int ret;
+	struct jump_entry *jentry;
+
+	jentry = find_jump_entry(name);
+	if (!jentry)
+		return -ENOENT;
+
+	ret = ftrace_arch_code_modify_prepare();
+	WARN_ON(ret);
+	if (ret)
+		return -1;
+
+	stop_machine(enable_nop, (void *)jentry, NULL);
+
+	ret = ftrace_arch_code_modify_post_process();
+	WARN_ON(ret);
+
+	return 0;
+}
+
+#endif
+
+static int __jump_label_init(void)
+{
+	struct jump_entry *iter;
+
+
+#ifdef HAVE_STATIC_JUMP
+	printk("__start___jump_table is: %p\n", __start___jump_table);
+	printk("__stop___jump_table is: %p\n", __stop___jump_table);
+	for(iter = __start___jump_table; iter < __stop___jump_table; iter++)
+		printk("jump label: code: %p, target: %p, name: %s\n", iter->code, iter->target, iter->name);
+#endif
+
+	return 0;
+}
+late_initcall(__jump_label_init);
+
-- 
1.6.2.5

