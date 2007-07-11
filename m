Return-Path: <linux-kernel-owner+w=401wt.eu-S1762706AbXGKJow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762706AbXGKJow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 05:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758566AbXGKJoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 05:44:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:33031 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759048AbXGKJof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 05:44:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=PsMaJTC1DLSvbSoq+LNio04m4u7Y+THu7p87qBLNQe4xa4ZkGRac+zpZkD20QARHYp24oly/8JgD1SH1O+PCTHwSNEt88IfQlhfclBCwdR9ckKn5fWsRGGc1gjBj1d+QpBFkOp97uac1qi1huOCCGUQVskO1FvZjqPV1zKDNPio=
Date: Wed, 11 Jul 2007 18:44:29 +0900
From: Tejun Heo <htejun@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.22-rc6-mm1] kallsyms: make KSYM_NAME_LEN include space for trailing '\0'
Message-ID: <20070711094429.GD23568@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KSYM_NAME_LEN is peculiar in that it does not include the space for
the trailing '\0', forcing all users to use KSYM_NAME_LEN + 1 when
allocating buffer.  This is nonsense and error-prone.  Moreover, when
the caller forgets that it's very likely to subtly bite back by
corrupting the stack because the last position of the buffer is always
cleared to zero.

This patch increments KSYM_NAME_LEN by one and updates code
accordingly.

* off-by-one bug in asm-powerpc/kprobes.h::kprobe_lookup_name() macro
  is fixed.

* Where MODULE_NAME_LEN and KSYM_NAME_LEN were used together,
  MODULE_NAME_LEN was treated as if it didn't include space for the
  trailing '\0'.  Fix it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 arch/parisc/kernel/unwind.c   |    2 +-
 fs/proc/base.c                |    2 +-
 include/asm-powerpc/kprobes.h |    4 ++--
 include/linux/kallsyms.h      |    6 +++---
 kernel/kallsyms.c             |   16 ++++++++--------
 kernel/lockdep.c              |    4 ++--
 kernel/module.c               |   10 +++++-----
 kernel/time/timer_list.c      |    2 +-
 kernel/time/timer_stats.c     |    2 +-
 mm/slab.c                     |    2 +-
 scripts/kallsyms.c            |    4 ++--
 11 files changed, 27 insertions(+), 27 deletions(-)

Index: tree0/arch/parisc/kernel/unwind.c
===================================================================
--- tree0.orig/arch/parisc/kernel/unwind.c
+++ tree0/arch/parisc/kernel/unwind.c
@@ -242,7 +242,7 @@ static void unwind_frame_regs(struct unw
 #ifdef CONFIG_KALLSYMS
 		/* Handle some frequent special cases.... */
 		{
-			char symname[KSYM_NAME_LEN+1];
+			char symname[KSYM_NAME_LEN];
 			char *modname;
 
 			kallsyms_lookup(info->ip, NULL, NULL, &modname,
Index: tree0/fs/proc/base.c
===================================================================
--- tree0.orig/fs/proc/base.c
+++ tree0/fs/proc/base.c
@@ -285,7 +285,7 @@ static int proc_pid_auxv(struct task_str
 static int proc_pid_wchan(struct task_struct *task, char *buffer)
 {
 	unsigned long wchan;
-	char symname[KSYM_NAME_LEN+1];
+	char symname[KSYM_NAME_LEN];
 
 	wchan = get_wchan(task);
 
Index: tree0/include/asm-powerpc/kprobes.h
===================================================================
--- tree0.orig/include/asm-powerpc/kprobes.h
+++ tree0/include/asm-powerpc/kprobes.h
@@ -65,10 +65,10 @@ typedef unsigned int kprobe_opcode_t;
 		} else if (name[0] != '.')				\
 			addr = *(kprobe_opcode_t **)addr;		\
 	} else {							\
-		char dot_name[KSYM_NAME_LEN+1];				\
+		char dot_name[KSYM_NAME_LEN];				\
 		dot_name[0] = '.';					\
 		dot_name[1] = '\0';					\
-		strncat(dot_name, name, KSYM_NAME_LEN);			\
+		strncat(dot_name, name, KSYM_NAME_LEN - 2);		\
 		addr = (kprobe_opcode_t *)kallsyms_lookup_name(dot_name); \
 	}								\
 }
Index: tree0/include/linux/kallsyms.h
===================================================================
--- tree0.orig/include/linux/kallsyms.h
+++ tree0/include/linux/kallsyms.h
@@ -6,9 +6,9 @@
 #define _LINUX_KALLSYMS_H
 
 
-#define KSYM_NAME_LEN 127
-#define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + KSYM_NAME_LEN +	\
-			 2*(BITS_PER_LONG*3/10) + MODULE_NAME_LEN + 1)
+#define KSYM_NAME_LEN 128
+#define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + (KSYM_NAME_LEN - 1) + \
+			 2*(BITS_PER_LONG*3/10) + (MODULE_NAME_LEN - 1) + 1)
 
 #ifdef CONFIG_KALLSYMS
 /* Lookup the address for a symbol. Returns 0 if not found. */
Index: tree0/kernel/kallsyms.c
===================================================================
--- tree0.orig/kernel/kallsyms.c
+++ tree0/kernel/kallsyms.c
@@ -152,7 +152,7 @@ static unsigned int get_symbol_offset(un
 /* Lookup the address for this symbol. Returns 0 if not found. */
 unsigned long kallsyms_lookup_name(const char *name)
 {
-	char namebuf[KSYM_NAME_LEN+1];
+	char namebuf[KSYM_NAME_LEN];
 	unsigned long i;
 	unsigned int off;
 
@@ -248,7 +248,7 @@ const char *kallsyms_lookup(unsigned lon
 {
 	const char *msym;
 
-	namebuf[KSYM_NAME_LEN] = 0;
+	namebuf[KSYM_NAME_LEN - 1] = 0;
 	namebuf[0] = 0;
 
 	if (is_ksym_addr(addr)) {
@@ -265,7 +265,7 @@ const char *kallsyms_lookup(unsigned lon
 	/* see if it's in a module */
 	msym = module_address_lookup(addr, symbolsize, offset, modname);
 	if (msym)
-		return strncpy(namebuf, msym, KSYM_NAME_LEN);
+		return strncpy(namebuf, msym, KSYM_NAME_LEN - 1);
 
 	return NULL;
 }
@@ -273,7 +273,7 @@ const char *kallsyms_lookup(unsigned lon
 int lookup_symbol_name(unsigned long addr, char *symname)
 {
 	symname[0] = '\0';
-	symname[KSYM_NAME_LEN] = '\0';
+	symname[KSYM_NAME_LEN - 1] = '\0';
 
 	if (is_ksym_addr(addr)) {
 		unsigned long pos;
@@ -291,7 +291,7 @@ int lookup_symbol_attrs(unsigned long ad
 			unsigned long *offset, char *modname, char *name)
 {
 	name[0] = '\0';
-	name[KSYM_NAME_LEN] = '\0';
+	name[KSYM_NAME_LEN - 1] = '\0';
 
 	if (is_ksym_addr(addr)) {
 		unsigned long pos;
@@ -312,7 +312,7 @@ int sprint_symbol(char *buffer, unsigned
 	char *modname;
 	const char *name;
 	unsigned long offset, size;
-	char namebuf[KSYM_NAME_LEN+1];
+	char namebuf[KSYM_NAME_LEN];
 
 	name = kallsyms_lookup(address, &size, &offset, &modname, namebuf);
 	if (!name)
@@ -342,8 +342,8 @@ struct kallsym_iter
 	unsigned long value;
 	unsigned int nameoff; /* If iterating in core kernel symbols */
 	char type;
-	char name[KSYM_NAME_LEN+1];
-	char module_name[MODULE_NAME_LEN + 1];
+	char name[KSYM_NAME_LEN];
+	char module_name[MODULE_NAME_LEN];
 	int exported;
 };
 
Index: tree0/kernel/lockdep.c
===================================================================
--- tree0.orig/kernel/lockdep.c
+++ tree0/kernel/lockdep.c
@@ -463,7 +463,7 @@ get_usage_chars(struct lock_class *class
 
 static void print_lock_name(struct lock_class *class)
 {
-	char str[KSYM_NAME_LEN + 1], c1, c2, c3, c4;
+	char str[KSYM_NAME_LEN], c1, c2, c3, c4;
 	const char *name;
 
 	get_usage_chars(class, &c1, &c2, &c3, &c4);
@@ -485,7 +485,7 @@ static void print_lock_name(struct lock_
 static void print_lockdep_cache(struct lockdep_map *lock)
 {
 	const char *name;
-	char str[KSYM_NAME_LEN + 1];
+	char str[KSYM_NAME_LEN];
 
 	name = lock->name;
 	if (!name)
Index: tree0/kernel/module.c
===================================================================
--- tree0.orig/kernel/module.c
+++ tree0/kernel/module.c
@@ -2196,7 +2196,7 @@ int lookup_module_symbol_name(unsigned l
 			sym = get_ksymbol(mod, addr, NULL, NULL);
 			if (!sym)
 				goto out;
-			strlcpy(symname, sym, KSYM_NAME_LEN + 1);
+			strlcpy(symname, sym, KSYM_NAME_LEN);
 			mutex_unlock(&module_mutex);
 			return 0;
 		}
@@ -2221,9 +2221,9 @@ int lookup_module_symbol_attrs(unsigned 
 			if (!sym)
 				goto out;
 			if (modname)
-				strlcpy(modname, mod->name, MODULE_NAME_LEN + 1);
+				strlcpy(modname, mod->name, MODULE_NAME_LEN);
 			if (name)
-				strlcpy(name, sym, KSYM_NAME_LEN + 1);
+				strlcpy(name, sym, KSYM_NAME_LEN);
 			mutex_unlock(&module_mutex);
 			return 0;
 		}
@@ -2244,8 +2244,8 @@ int module_get_kallsym(unsigned int symn
 			*value = mod->symtab[symnum].st_value;
 			*type = mod->symtab[symnum].st_info;
 			strlcpy(name, mod->strtab + mod->symtab[symnum].st_name,
-				KSYM_NAME_LEN + 1);
-			strlcpy(module_name, mod->name, MODULE_NAME_LEN + 1);
+				KSYM_NAME_LEN);
+			strlcpy(module_name, mod->name, MODULE_NAME_LEN);
 			*exported = is_exported(name, mod);
 			mutex_unlock(&module_mutex);
 			return 0;
Index: tree0/kernel/time/timer_list.c
===================================================================
--- tree0.orig/kernel/time/timer_list.c
+++ tree0/kernel/time/timer_list.c
@@ -38,7 +38,7 @@ DECLARE_PER_CPU(struct hrtimer_cpu_base,
 
 static void print_name_offset(struct seq_file *m, void *sym)
 {
-	char symname[KSYM_NAME_LEN+1];
+	char symname[KSYM_NAME_LEN];
 
 	if (lookup_symbol_name((unsigned long)sym, symname) < 0)
 		SEQ_printf(m, "<%p>", sym);
Index: tree0/kernel/time/timer_stats.c
===================================================================
--- tree0.orig/kernel/time/timer_stats.c
+++ tree0/kernel/time/timer_stats.c
@@ -269,7 +269,7 @@ void timer_stats_update_stats(void *time
 
 static void print_name_offset(struct seq_file *m, unsigned long addr)
 {
-	char symname[KSYM_NAME_LEN+1];
+	char symname[KSYM_NAME_LEN];
 
 	if (lookup_symbol_name(addr, symname) < 0)
 		seq_printf(m, "<%p>", (void *)addr);
Index: tree0/mm/slab.c
===================================================================
--- tree0.orig/mm/slab.c
+++ tree0/mm/slab.c
@@ -4349,7 +4349,7 @@ static void show_symbol(struct seq_file 
 {
 #ifdef CONFIG_KALLSYMS
 	unsigned long offset, size;
-	char modname[MODULE_NAME_LEN + 1], name[KSYM_NAME_LEN + 1];
+	char modname[MODULE_NAME_LEN], name[KSYM_NAME_LEN];
 
 	if (lookup_symbol_attrs(address, &size, &offset, modname, name) == 0) {
 		seq_printf(m, "%s+%#lx/%#lx", name, offset, size);
Index: tree0/scripts/kallsyms.c
===================================================================
--- tree0.orig/scripts/kallsyms.c
+++ tree0/scripts/kallsyms.c
@@ -31,7 +31,7 @@
 #include <string.h>
 #include <ctype.h>
 
-#define KSYM_NAME_LEN		127
+#define KSYM_NAME_LEN		128
 
 
 struct sym_entry {
@@ -254,7 +254,7 @@ static void write_src(void)
 	unsigned int i, k, off;
 	unsigned int best_idx[256];
 	unsigned int *markers;
-	char buf[KSYM_NAME_LEN+1];
+	char buf[KSYM_NAME_LEN];
 
 	printf("#include <asm/types.h>\n");
 	printf("#if BITS_PER_LONG == 64\n");
