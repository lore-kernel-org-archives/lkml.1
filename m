Return-Path: <linux-kernel-owner+w=401wt.eu-S1752762AbZDOFEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbZDOFEO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 01:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbZDOFD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 01:03:57 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1179 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZDOFD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 01:03:56 -0400
Subject: RFC: introduce struct ksymbol
From: Joe Perches <joe@perches.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1239753659-11790-1-git-send-email-fweisbec@gmail.com>
References: <1239753659-11790-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 22:03:11 -0700
Message-Id: <1239771791.32241.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-15 at 02:00 +0200, Frederic Weisbecker wrote:
> arch/blackfin/kernel/traps.c:   symname = kallsyms_lookup(address, &symsize, &offset, &modname, namebuf);
> arch/powerpc/xmon/xmon.c:               name = kallsyms_lookup(pc, &size, &offset, NULL, tmpstr);
> arch/sh/kernel/cpu/sh5/unwind.c:        sym = kallsyms_lookup(pc, NULL, &offset, NULL, namebuf);
> arch/x86/kernel/ftrace.c:       kallsyms_lookup((unsigned long) syscall, NULL, NULL, NULL, str);
> kernel/kprobes.c:               sym = kallsyms_lookup((unsigned long)p->addr, NULL,
> kernel/lockdep.c:       return kallsyms_lookup((unsigned long)key, NULL, NULL, NULL, str);
> kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
> kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
> kernel/trace/ftrace.c:  kallsyms_lookup((unsigned long)rec->ops->func, NULL, NULL, NULL, str);
> kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
> kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
> kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, &modname, str);
> kernel/trace/ftrace.c:  kallsyms_lookup(*ptr, NULL, NULL, NULL, str);
> kernel/trace/trace_functions.c: kallsyms_lookup(ip, NULL, NULL, NULL, str);
> kernel/trace/trace_output.c:    kallsyms_lookup(address, NULL, NULL, NULL, str);

Perhaps a conversion from

"char str[KSYM_SYMBOL_LEN]"
to
"struct ksymbol sym"?

could be useful.

There are a few places that use a hard coded length of 128
instead of KSYM_SYMBOL_LENGTH that are also converted.

Compile tested only

commit e79bca2dc1b0799ad3b2f310a79caabcb44ff338
Author: Joe Perches <joe@perches.com>
Date:   Tue Apr 14 21:53:34 2009 -0700

    tracing: Use struct ksymbol

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 7922742..6b4ee14 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -8,11 +8,16 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/stddef.h>
+#include <linux/module.h>
 
 #define KSYM_NAME_LEN 128
 #define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + (KSYM_NAME_LEN - 1) + \
 			 2*(BITS_PER_LONG*3/10) + (MODULE_NAME_LEN - 1) + 1)
 
+struct ksymbol {
+	char str[KSYM_SYMBOL_LEN];
+};
+
 struct module;
 
 #ifdef CONFIG_KALLSYMS
@@ -32,10 +37,11 @@ extern int kallsyms_lookup_size_offset(unsigned long addr,
 const char *kallsyms_lookup(unsigned long addr,
 			    unsigned long *symbolsize,
 			    unsigned long *offset,
-			    char **modname, char *namebuf);
+			    char **modname,
+			    struct ksymbol *sym);
 
 /* Look up a kernel symbol and return it in a text buffer. */
-extern int sprint_symbol(char *buffer, unsigned long address);
+extern int sprint_symbol(struct ksymbol *sym, unsigned long address);
 
 /* Look up a kernel symbol and print it to the kernel messages. */
 extern void __print_symbol(const char *fmt, unsigned long address);
@@ -68,7 +74,8 @@ static inline int kallsyms_lookup_size_offset(unsigned long addr,
 static inline const char *kallsyms_lookup(unsigned long addr,
 					  unsigned long *symbolsize,
 					  unsigned long *offset,
-					  char **modname, char *namebuf)
+					  char **modname,
+					  struct ksymbol *sym)
 {
 	return NULL;
 }
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 18dfa30..3198499 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -480,15 +480,15 @@ static struct syscall_metadata *find_syscall_meta(unsigned long *syscall)
 {
 	struct syscall_metadata *start;
 	struct syscall_metadata *stop;
-	char str[KSYM_SYMBOL_LEN];
+	struct ksymbol sym;
 
 
 	start = (struct syscall_metadata *)__start_syscalls_metadata;
 	stop = (struct syscall_metadata *)__stop_syscalls_metadata;
-	kallsyms_lookup((unsigned long) syscall, NULL, NULL, NULL, str);
+	kallsyms_lookup((unsigned long) syscall, NULL, NULL, NULL, &sym);
 
 	for ( ; start < stop; start++) {
-		if (start->name && !strcmp(start->name, str))
+		if (start->name && !strcmp(start->name, sym.str))
 			return start;
 	}
 	return NULL;
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 3984e47..e7e0ae8 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1544,10 +1544,10 @@ static const char *hflags2str(char *buf, unsigned flags, unsigned long iflags)
 static int dump_holder(struct seq_file *seq, const struct gfs2_holder *gh)
 {
 	struct task_struct *gh_owner = NULL;
-	char buffer[KSYM_SYMBOL_LEN];
+	struct ksymbol sym;
 	char flags_buf[32];
 
-	sprint_symbol(buffer, gh->gh_ip);
+	sprint_symbol(&sym, gh->gh_ip);
 	if (gh->gh_owner_pid)
 		gh_owner = pid_task(gh->gh_owner_pid, PIDTYPE_PID);
 	gfs2_print_dbg(seq, " H: s:%s f:%s e:%d p:%ld [%s] %s\n",
@@ -1555,7 +1555,7 @@ static int dump_holder(struct seq_file *seq, const struct gfs2_holder *gh)
 		  hflags2str(flags_buf, gh->gh_flags, gh->gh_iflags),
 		  gh->gh_error, 
 		  gh->gh_owner_pid ? (long)pid_nr(gh->gh_owner_pid) : -1,
-		  gh_owner ? gh_owner->comm : "(ended)", buffer);
+		  gh_owner ? gh_owner->comm : "(ended)", sym.str);
 	return 0;
 }
 
diff --git a/fs/proc/base.c b/fs/proc/base.c
index f715597..d777461 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -390,17 +390,17 @@ static int lstats_show_proc(struct seq_file *m, void *v)
 				task->latency_record[i].time,
 				task->latency_record[i].max);
 			for (q = 0; q < LT_BACKTRACEDEPTH; q++) {
-				char sym[KSYM_SYMBOL_LEN];
+				struct ksymbol sym;
 				char *c;
 				if (!task->latency_record[i].backtrace[q])
 					break;
 				if (task->latency_record[i].backtrace[q] == ULONG_MAX)
 					break;
-				sprint_symbol(sym, task->latency_record[i].backtrace[q]);
-				c = strchr(sym, '+');
+				sprint_symbol(&sym, task->latency_record[i].backtrace[q]);
+				c = strchr(sym.str, '+');
 				if (c)
 					*c = 0;
-				seq_printf(m, "%s ", sym);
+				seq_printf(m, "%s ", sym.str);
 			}
 			seq_printf(m, "\n");
 		}
diff --git a/include/trace/boot.h b/include/trace/boot.h
index 088ea08..ff59d54 100644
--- a/include/trace/boot.h
+++ b/include/trace/boot.h
@@ -13,7 +13,7 @@
  */
 struct boot_trace_call {
 	pid_t			caller;
-	char			func[KSYM_SYMBOL_LEN];
+	struct ksymbol		func;
 };
 
 /*
@@ -21,8 +21,8 @@ struct boot_trace_call {
  * while it returns.
  */
 struct boot_trace_ret {
-	char			func[KSYM_SYMBOL_LEN];
-	int				result;
+	struct ksymbol		func;
+	int			result;
 	unsigned long long	duration;		/* nsecs */
 };
 
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 374faf9..7434504 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -260,25 +260,26 @@ int kallsyms_lookup_size_offset(unsigned long addr, unsigned long *symbolsize,
 const char *kallsyms_lookup(unsigned long addr,
 			    unsigned long *symbolsize,
 			    unsigned long *offset,
-			    char **modname, char *namebuf)
+			    char **modname,
+			    struct ksymbol *sym)
 {
-	namebuf[KSYM_NAME_LEN - 1] = 0;
-	namebuf[0] = 0;
+	sym->str[sizeof(sym->str) - 1] = 0;
+	sym->str[0] = 0;
 
 	if (is_ksym_addr(addr)) {
 		unsigned long pos;
 
 		pos = get_symbol_pos(addr, symbolsize, offset);
 		/* Grab name */
-		kallsyms_expand_symbol(get_symbol_offset(pos), namebuf);
+		kallsyms_expand_symbol(get_symbol_offset(pos), sym->str);
 		if (modname)
 			*modname = NULL;
-		return namebuf;
+		return sym->str;
 	}
 
 	/* see if it's in a module */
 	return module_address_lookup(addr, symbolsize, offset, modname,
-				     namebuf);
+				     sym->str);
 }
 
 int lookup_symbol_name(unsigned long addr, char *symname)
@@ -317,18 +318,20 @@ int lookup_symbol_attrs(unsigned long addr, unsigned long *size,
 	return lookup_module_symbol_attrs(addr, size, offset, modname, name);
 }
 
-/* Look up a kernel symbol and return it in a text buffer. */
-int sprint_symbol(char *buffer, unsigned long address)
+/* Look up a kernel symbol and return it. */
+int sprint_symbol(struct ksymbol *sym, unsigned long address)
 {
 	char *modname;
 	const char *name;
 	unsigned long offset, size;
 	int len;
+	char *buffer;
 
-	name = kallsyms_lookup(address, &size, &offset, &modname, buffer);
+	name = kallsyms_lookup(address, &size, &offset, &modname, sym);
 	if (!name)
-		return sprintf(buffer, "0x%lx", address);
+		return sprintf(sym->str, "0x%lx", address);
 
+	buffer = sym->str;
 	if (name != buffer)
 		strcpy(buffer, name);
 	len = strlen(buffer);
@@ -346,11 +349,11 @@ int sprint_symbol(char *buffer, unsigned long address)
 /* Look up a kernel symbol and print it to the kernel messages. */
 void __print_symbol(const char *fmt, unsigned long address)
 {
-	char buffer[KSYM_SYMBOL_LEN];
+	struct ksymbol sym;
 
-	sprint_symbol(buffer, address);
+	sprint_symbol(&sym, address);
 
-	printk(fmt, buffer);
+	printk(fmt, sym.str);
 }
 
 /* To avoid using get_symbol_offset for every symbol, we carry prefix along. */
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index a5e74dd..5316609 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1188,7 +1188,8 @@ static int __init init_kprobes(void)
 {
 	int i, err = 0;
 	unsigned long offset = 0, size = 0;
-	char *modname, namebuf[128];
+	char *modname;
+	struct ksymbol sym;
 	const char *symbol_name;
 	void *addr;
 	struct kprobe_blackpoint *kb;
@@ -1216,7 +1217,7 @@ static int __init init_kprobes(void)
 
 		kb->start_addr = (unsigned long)addr;
 		symbol_name = kallsyms_lookup(kb->start_addr,
-				&size, &offset, &modname, namebuf);
+				&size, &offset, &modname, &sym);
 		if (!symbol_name)
 			kb->range = 0;
 		else
@@ -1303,13 +1304,14 @@ static int __kprobes show_kprobe_addr(struct seq_file *pi, void *v)
 	const char *sym = NULL;
 	unsigned int i = *(loff_t *) v;
 	unsigned long offset = 0;
-	char *modname, namebuf[128];
+	char *modname;
+	struct ksymbol symbol;
 
 	head = &kprobe_table[i];
 	preempt_disable();
 	hlist_for_each_entry_rcu(p, node, head, hlist) {
 		sym = kallsyms_lookup((unsigned long)p->addr, NULL,
-					&offset, &modname, namebuf);
+					&offset, &modname, &symbol);
 		if (p->pre_handler == aggr_pre_handler) {
 			list_for_each_entry_rcu(kp, &p->list, list)
 				report_probe(pi, kp, sym, offset, modname);
diff --git a/kernel/latencytop.c b/kernel/latencytop.c
index ca07c5c..d27c4bf 100644
--- a/kernel/latencytop.c
+++ b/kernel/latencytop.c
@@ -250,17 +250,17 @@ static int lstats_show(struct seq_file *m, void *v)
 				latency_record[i].time,
 				latency_record[i].max);
 			for (q = 0; q < LT_BACKTRACEDEPTH; q++) {
-				char sym[KSYM_SYMBOL_LEN];
+				struct ksymbol sym;
 				char *c;
 				if (!latency_record[i].backtrace[q])
 					break;
 				if (latency_record[i].backtrace[q] == ULONG_MAX)
 					break;
-				sprint_symbol(sym, latency_record[i].backtrace[q]);
-				c = strchr(sym, '+');
+				sprint_symbol(&sym, latency_record[i].backtrace[q]);
+				c = strchr(sym.str, '+');
 				if (c)
 					*c = 0;
-				seq_printf(m, "%s ", sym);
+				seq_printf(m, "%s ", sym.str);
 			}
 			seq_printf(m, "\n");
 		}
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index b0f0118..792a87d 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -454,9 +454,9 @@ static const char *usage_str[] =
 	[LOCK_USED] = "INITIAL USE",
 };
 
-const char * __get_key_name(struct lockdep_subclass_key *key, char *str)
+const char * __get_key_name(struct lockdep_subclass_key *key, struct ksymbol *sym)
 {
-	return kallsyms_lookup((unsigned long)key, NULL, NULL, NULL, str);
+	return kallsyms_lookup((unsigned long)key, NULL, NULL, NULL, sym);
 }
 
 static inline unsigned long lock_flag(enum lock_usage_bit bit)
@@ -494,14 +494,15 @@ void get_usage_chars(struct lock_class *class, char usage[LOCK_USAGE_CHARS])
 
 static void print_lock_name(struct lock_class *class)
 {
-	char str[KSYM_NAME_LEN], usage[LOCK_USAGE_CHARS];
+	struct ksymbol sym;
+	char usage[LOCK_USAGE_CHARS];
 	const char *name;
 
 	get_usage_chars(class, usage);
 
 	name = class->name;
 	if (!name) {
-		name = __get_key_name(class->key, str);
+		name = __get_key_name(class->key, &sym);
 		printk(" (%s", name);
 	} else {
 		printk(" (%s", name);
@@ -516,11 +517,11 @@ static void print_lock_name(struct lock_class *class)
 static void print_lockdep_cache(struct lockdep_map *lock)
 {
 	const char *name;
-	char str[KSYM_NAME_LEN];
+	struct ksymbol sym;
 
 	name = lock->name;
 	if (!name)
-		name = __get_key_name(lock->key->subkeys, str);
+		name = __get_key_name(lock->key->subkeys, &sym);
 
 	printk("%s", name);
 }
diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index a2cc7e9..e370d21 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -75,7 +75,8 @@ extern struct lock_chain lock_chains[];
 extern void get_usage_chars(struct lock_class *class,
 			    char usage[LOCK_USAGE_CHARS]);
 
-extern const char * __get_key_name(struct lockdep_subclass_key *key, char *str);
+extern const char * __get_key_name(struct lockdep_subclass_key *key,
+				   struct ksymbol *sym);
 
 struct lock_class *lock_chain_get_class(struct lock_chain *chain, int i);
 
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index d7135aa..0108812 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -65,11 +65,11 @@ static void l_stop(struct seq_file *m, void *v)
 
 static void print_name(struct seq_file *m, struct lock_class *class)
 {
-	char str[128];
+	struct ksymbol sym;
 	const char *name = class->name;
 
 	if (!name) {
-		name = __get_key_name(class->key, str);
+		name = __get_key_name(class->key, &sym);
 		seq_printf(m, "%s", name);
 	} else{
 		seq_printf(m, "%s", name);
@@ -511,10 +511,10 @@ static void seq_stats(struct seq_file *m, struct lock_stat_data *data)
 		namelen -= 2;
 
 	if (!class->name) {
-		char str[KSYM_NAME_LEN];
+		struct ksymbol sym;
 		const char *key_name;
 
-		key_name = __get_key_name(class->key, str);
+		key_name = __get_key_name(class->key, &sym);
 		snprintf(name, namelen, "%s", key_name);
 	} else {
 		snprintf(name, namelen, "%s", class->name);
@@ -558,7 +558,7 @@ static void seq_stats(struct seq_file *m, struct lock_stat_data *data)
 		namelen += 2;
 
 	for (i = 0; i < LOCKSTAT_POINTS; i++) {
-		char sym[KSYM_SYMBOL_LEN];
+		struct ksymbol sym;
 		char ip[32];
 
 		if (class->contention_point[i] == 0)
@@ -567,15 +567,15 @@ static void seq_stats(struct seq_file *m, struct lock_stat_data *data)
 		if (!i)
 			seq_line(m, '-', 40-namelen, namelen);
 
-		sprint_symbol(sym, class->contention_point[i]);
+		sprint_symbol(&sym, class->contention_point[i]);
 		snprintf(ip, sizeof(ip), "[<%p>]",
 				(void *)class->contention_point[i]);
 		seq_printf(m, "%40s %14lu %29s %s\n", name,
 				stats->contention_point[i],
-				ip, sym);
+				ip, sym.str);
 	}
 	for (i = 0; i < LOCKSTAT_POINTS; i++) {
-		char sym[KSYM_SYMBOL_LEN];
+		struct ksymbol sym;
 		char ip[32];
 
 		if (class->contending_point[i] == 0)
@@ -584,12 +584,12 @@ static void seq_stats(struct seq_file *m, struct lock_stat_data *data)
 		if (!i)
 			seq_line(m, '-', 40-namelen, namelen);
 
-		sprint_symbol(sym, class->contending_point[i]);
+		sprint_symbol(&sym, class->contending_point[i]);
 		snprintf(ip, sizeof(ip), "[<%p>]",
 				(void *)class->contending_point[i]);
 		seq_printf(m, "%40s %14lu %29s %s\n", name,
 				stats->contending_point[i],
-				ip, sym);
+				ip, sym.str);
 	}
 	if (i) {
 		seq_puts(m, "\n");
diff --git a/kernel/panic.c b/kernel/panic.c
index 934fb37..fd4750d 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -343,15 +343,15 @@ void oops_exit(void)
 void warn_slowpath(const char *file, int line, const char *fmt, ...)
 {
 	va_list args;
-	char function[KSYM_SYMBOL_LEN];
+	struct ksymbol function;
 	unsigned long caller = (unsigned long)__builtin_return_address(0);
 	const char *board;
 
-	sprint_symbol(function, caller);
+	sprint_symbol(&function, caller);
 
 	printk(KERN_WARNING "------------[ cut here ]------------\n");
 	printk(KERN_WARNING "WARNING: at %s:%d %s()\n", file,
-		line, function);
+		line, function.str);
 	board = dmi_get_system_info(DMI_PRODUCT_NAME);
 	if (board)
 		printk(KERN_WARNING "Hardware name: %s\n", board);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f1ed080..02d7703 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -869,18 +869,18 @@ static int t_hash_show(struct seq_file *m, void *v)
 {
 	struct ftrace_func_probe *rec;
 	struct hlist_node *hnd = v;
-	char str[KSYM_SYMBOL_LEN];
+	struct ksymbol sym;
 
 	rec = hlist_entry(hnd, struct ftrace_func_probe, node);
 
 	if (rec->ops->print)
 		return rec->ops->print(m, rec->ip, rec->ops, rec->data);
 
-	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
-	seq_printf(m, "%s:", str);
+	kallsyms_lookup(rec->ip, NULL, NULL, NULL, &sym);
+	seq_printf(m, "%s:", sym.str);
 
-	kallsyms_lookup((unsigned long)rec->ops->func, NULL, NULL, NULL, str);
-	seq_printf(m, "%s", str);
+	kallsyms_lookup((unsigned long)rec->ops->func, NULL, NULL, NULL, &sym);
+	seq_printf(m, "%s", sym.str);
 
 	if (rec->data)
 		seq_printf(m, ":%p", rec->data);
@@ -981,7 +981,7 @@ static int t_show(struct seq_file *m, void *v)
 {
 	struct ftrace_iterator *iter = m->private;
 	struct dyn_ftrace *rec = v;
-	char str[KSYM_SYMBOL_LEN];
+	struct ksymbol sym;
 
 	if (iter->flags & FTRACE_ITER_HASH)
 		return t_hash_show(m, v);
@@ -994,9 +994,9 @@ static int t_show(struct seq_file *m, void *v)
 	if (!rec)
 		return 0;
 
-	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
+	kallsyms_lookup(rec->ip, NULL, NULL, NULL, &sym);
 
-	seq_printf(m, "%s\n", str);
+	seq_printf(m, "%s\n", sym.str);
 
 	return 0;
 }
@@ -1227,10 +1227,10 @@ static int ftrace_match(char *str, char *regex, int len, int type)
 static int
 ftrace_match_record(struct dyn_ftrace *rec, char *regex, int len, int type)
 {
-	char str[KSYM_SYMBOL_LEN];
+	struct ksymbol sym;
 
-	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
-	return ftrace_match(str, regex, len, type);
+	kallsyms_lookup(rec->ip, NULL, NULL, NULL, &sym);
+	return ftrace_match(sym.str, regex, len, type);
 }
 
 static void ftrace_match_records(char *buff, int len, int enable)
@@ -1274,17 +1274,17 @@ static int
 ftrace_match_module_record(struct dyn_ftrace *rec, char *mod,
 			   char *regex, int len, int type)
 {
-	char str[KSYM_SYMBOL_LEN];
+	struct ksymbol sym;
 	char *modname;
 
-	kallsyms_lookup(rec->ip, NULL, NULL, &modname, str);
+	kallsyms_lookup(rec->ip, NULL, NULL, &modname, &sym);
 
 	if (!modname || strcmp(modname, mod))
 		return 0;
 
 	/* blank search means to match all funcs in the mod */
 	if (len)
-		return ftrace_match(str, regex, len, type);
+		return ftrace_match(sym.str, regex, len, type);
 	else
 		return 1;
 }
@@ -1544,7 +1544,7 @@ __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 {
 	struct ftrace_func_probe *entry;
 	struct hlist_node *n, *tmp;
-	char str[KSYM_SYMBOL_LEN];
+	struct ksymbol sym;
 	int type = MATCH_FULL;
 	int i, len = 0;
 	char *search;
@@ -1578,8 +1578,8 @@ __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 			/* do this last, since it is the most expensive */
 			if (glob) {
 				kallsyms_lookup(entry->ip, NULL, NULL,
-						NULL, str);
-				if (!ftrace_match(str, glob, len, type))
+						NULL, &sym);
+				if (!ftrace_match(sym.str, glob, len, type))
 					continue;
 			}
 
@@ -1939,7 +1939,7 @@ static void g_stop(struct seq_file *m, void *p)
 static int g_show(struct seq_file *m, void *v)
 {
 	unsigned long *ptr = v;
-	char str[KSYM_SYMBOL_LEN];
+	struct ksymbol sym;
 
 	if (!ptr)
 		return 0;
@@ -1949,9 +1949,9 @@ static int g_show(struct seq_file *m, void *v)
 		return 0;
 	}
 
-	kallsyms_lookup(*ptr, NULL, NULL, NULL, str);
+	kallsyms_lookup(*ptr, NULL, NULL, NULL, &sym);
 
-	seq_printf(m, "%s\n", str);
+	seq_printf(m, "%s\n", sym.str);
 
 	return 0;
 }
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index 7a30fc4..c75bcf2 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -70,7 +70,8 @@ initcall_call_print_line(struct trace_iterator *iter)
 	nsec_rem = do_div(ts, 1000000000);
 
 	ret = trace_seq_printf(s, "[%5ld.%09ld] calling  %s @ %i\n",
-			(unsigned long)ts, nsec_rem, call->func, call->caller);
+			       (unsigned long)ts, nsec_rem, call->func.str,
+			       call->caller);
 
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
@@ -98,7 +99,8 @@ initcall_ret_print_line(struct trace_iterator *iter)
 			"returned %d after %llu msecs\n",
 			(unsigned long) ts,
 			nsec_rem,
-			init_ret->func, init_ret->result, init_ret->duration);
+			init_ret->func.str,
+			init_ret->result, init_ret->duration);
 
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
@@ -140,7 +142,7 @@ void trace_boot_call(struct boot_trace_call *bt, initcall_t fn)
 	/* Get its name now since this function could
 	 * disappear because it is in the .init section.
 	 */
-	sprint_symbol(bt->func, (unsigned long)fn);
+	sprint_symbol(&bt->func, (unsigned long)fn);
 	preempt_disable();
 
 	event = trace_buffer_lock_reserve(tr, TRACE_BOOT_CALL,
@@ -163,7 +165,7 @@ void trace_boot_ret(struct boot_trace_ret *bt, initcall_t fn)
 	if (!tr || !pre_initcalls_finished)
 		return;
 
-	sprint_symbol(bt->func, (unsigned long)fn);
+	sprint_symbol(&bt->func, (unsigned long)fn);
 	preempt_disable();
 
 	event = trace_buffer_lock_reserve(tr, TRACE_BOOT_RET,
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index c9a0b7d..2917374 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -286,11 +286,11 @@ static int
 ftrace_trace_onoff_print(struct seq_file *m, unsigned long ip,
 			 struct ftrace_probe_ops *ops, void *data)
 {
-	char str[KSYM_SYMBOL_LEN];
+	struct ksymbol sym;
 	long count = (long)data;
 
-	kallsyms_lookup(ip, NULL, NULL, NULL, str);
-	seq_printf(m, "%s:", str);
+	kallsyms_lookup(ip, NULL, NULL, NULL, &sym);
+	seq_printf(m, "%s:", sym.str);
 
 	if (ops == &traceon_probe_ops)
 		seq_printf(m, "traceon");
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 64b54a5..d8a984b 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -202,19 +202,19 @@ int trace_seq_path(struct trace_seq *s, struct path *path)
 }
 
 #ifdef CONFIG_KRETPROBES
-static inline const char *kretprobed(const char *name)
+static inline const char *kretprobed(const struct ksymbol *sym)
 {
 	static const char tramp_name[] = "kretprobe_trampoline";
 	int size = sizeof(tramp_name);
 
-	if (strncmp(tramp_name, name, size) == 0)
+	if (strncmp(tramp_name, sym->str, size) == 0)
 		return "[unknown/kretprobe'd]";
-	return name;
+	return sym->str;
 }
 #else
-static inline const char *kretprobed(const char *name)
+static inline const char *kretprobed(const struct ksymbol *name)
 {
-	return name;
+	return name->str;
 }
 #endif /* CONFIG_KRETPROBES */
 
@@ -222,12 +222,12 @@ static int
 seq_print_sym_short(struct trace_seq *s, const char *fmt, unsigned long address)
 {
 #ifdef CONFIG_KALLSYMS
-	char str[KSYM_SYMBOL_LEN];
+	struct ksymbol sym;
 	const char *name;
 
-	kallsyms_lookup(address, NULL, NULL, NULL, str);
+	kallsyms_lookup(address, NULL, NULL, NULL, &sym);
 
-	name = kretprobed(str);
+	name = kretprobed(&sym);
 
 	return trace_seq_printf(s, fmt, name);
 #endif
@@ -239,11 +239,11 @@ seq_print_sym_offset(struct trace_seq *s, const char *fmt,
 		     unsigned long address)
 {
 #ifdef CONFIG_KALLSYMS
-	char str[KSYM_SYMBOL_LEN];
+	struct ksymbol sym;
 	const char *name;
 
-	sprint_symbol(str, address);
-	name = kretprobed(str);
+	sprint_symbol(&sym, address);
+	name = kretprobed(&sym);
 
 	return trace_seq_printf(s, fmt, name);
 #endif
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index c750f65..9c09b35 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -235,11 +235,11 @@ static int trace_lookup_stack(struct seq_file *m, long i)
 {
 	unsigned long addr = stack_dump_trace[i];
 #ifdef CONFIG_KALLSYMS
-	char str[KSYM_SYMBOL_LEN];
+	struct ksymbol sym;
 
-	sprint_symbol(str, addr);
+	sprint_symbol(&sym, addr);
 
-	return seq_printf(m, "%s\n", str);
+	return seq_printf(m, "%s\n", sym.str);
 #else
 	return seq_printf(m, "%p\n", (void*)addr);
 #endif
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 7536ace..eb4c2f7 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -577,9 +577,9 @@ static char *symbol_string(char *buf, char *end, void *ptr,
 {
 	unsigned long value = (unsigned long) ptr;
 #ifdef CONFIG_KALLSYMS
-	char sym[KSYM_SYMBOL_LEN];
-	sprint_symbol(sym, value);
-	return string(buf, end, sym, spec);
+	struct ksymbol sym;
+	sprint_symbol(&sym, value);
+	return string(buf, end, sym.str, spec);
 #else
 	spec.field_width = 2*sizeof(void *);
 	spec.flags |= SPECIAL | SMALL | ZEROPAD;
diff --git a/mm/slub.c b/mm/slub.c
index 7ab54ec..d8fe23e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3682,9 +3682,12 @@ static int list_locations(struct kmem_cache *s, char *buf,
 			break;
 		len += sprintf(buf + len, "%7ld ", l->count);
 
-		if (l->addr)
-			len += sprint_symbol(buf + len, (unsigned long)l->addr);
-		else
+		if (l->addr) {
+			struct ksymbol sym;
+			sprint_symbol(&sym, (unsigned long)l->addr);
+			strcpy(buf + len, sym.str);
+			len += strlen(buf + len);
+		} else
 			len += sprintf(buf + len, "<not-available>");
 
 		if (l->sum_time != l->min_time) {
@@ -3922,8 +3925,9 @@ SLAB_ATTR(min_partial);
 static ssize_t ctor_show(struct kmem_cache *s, char *buf)
 {
 	if (s->ctor) {
-		int n = sprint_symbol(buf, (unsigned long)s->ctor);
-
+		struct ksymbol sym;
+		int n = sprint_symbol(&sym, (unsigned long)s->ctor);
+		strcpy(buf, sym.str);
 		return n + sprintf(buf + n, "\n");
 	}
 	return 0;
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index fab1987..4863291 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1854,11 +1854,11 @@ static int s_show(struct seq_file *m, void *p)
 		v->addr, v->addr + v->size, v->size);
 
 	if (v->caller) {
-		char buff[KSYM_SYMBOL_LEN];
+		struct ksymbol sym;
 
 		seq_putc(m, ' ');
-		sprint_symbol(buff, (unsigned long)v->caller);
-		seq_puts(m, buff);
+		sprint_symbol(&sym, (unsigned long)v->caller);
+		seq_puts(m, sym.str);
 	}
 
 	if (v->nr_pages)
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 5abab09..30711b1 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1565,15 +1565,16 @@ static void rpc_show_task(const struct rpc_clnt *clnt,
 			  const struct rpc_task *task)
 {
 	const char *rpc_waitq = "none";
-	char *p, action[KSYM_SYMBOL_LEN];
+	char *p;
+	struct ksymbol action;
 
 	if (RPC_IS_QUEUED(task))
 		rpc_waitq = rpc_qname(task->tk_waitqueue);
 
 	/* map tk_action pointer to a function name; then trim off
 	 * the "+0x0 [sunrpc]" */
-	sprint_symbol(action, (unsigned long)task->tk_action);
-	p = strchr(action, '+');
+	sprint_symbol(&action, (unsigned long)task->tk_action);
+	p = strchr(action.str, '+');
 	if (p)
 		*p = '\0';
 
@@ -1581,7 +1582,7 @@ static void rpc_show_task(const struct rpc_clnt *clnt,
 		task->tk_pid, task->tk_flags, task->tk_status,
 		clnt, task->tk_rqstp, task->tk_timeout, task->tk_ops,
 		clnt->cl_protname, clnt->cl_vers, rpc_proc_name(task),
-		action, rpc_waitq);
+		action.str, rpc_waitq);
 }
 
 void rpc_show_tasks(void)


