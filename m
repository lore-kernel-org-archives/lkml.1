Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbZCAEBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbZCAEBx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 23:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755791AbZCAEBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 23:01:22 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:41961 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588AbZCAEBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 23:01:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:from:date:subject:to:cc;
        b=jsgJRtKhpepOUfoZrC9o4rzH8X67SbAsU5k+iuzqu6YCUZZ6c2TkhfURhx+AZpj2iF
         oun/dRNEMb9Dfwgq0DuuHSmmz1dniOO9jsF+I9/iOm6JkE6KU0C0Wl2SkAkYlQxANQI5
         bQSLQ3G11xZ2eqkVq2+G+BFv7WgbPFWHgKmpw=
Message-ID: <49aa088b.1c07d00a.4512.ffffe781@mx.google.com>
In-Reply-To: <20090228091305.GA20533@elte.hu>
References: <20090228091305.GA20533@elte.hu>
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Sat, 28 Feb 2009 22:30:16 +0100
Subject: [PATCH 3/5] ftrace: add ftrace_bprintk()
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Impact: Add a generic printk() for ftrace, like ftrace_printk()

ftrace_bprintk() use the infrastructure to record events on ring_buffer.

[fweisbec@gmail.com: ported to latest -tip and made it work if !CONFIG_MODULES]

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/asm-generic/vmlinux.lds.h |    3 +
 include/linux/ftrace.h            |   21 ++++++
 include/linux/module.h            |    5 ++
 kernel/module.c                   |    6 ++
 kernel/trace/trace.c              |   15 ++++
 kernel/trace/trace_bprintk.c      |  132 ++++++++++++++++++++++++++++++++++++-
 6 files changed, 181 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 9d97491..13f20f4 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -100,6 +100,9 @@
 		*(__vermagic)		/* Kernel version magic */	\
 		*(__markers_strings)	/* Markers: strings */		\
 		*(__tracepoints_strings)/* Tracepoints: strings */	\
+		VMLINUX_SYMBOL(__start___trace_bprintk_fmt) = .;	\
+		*(__trace_printk_fmt)	/* Trace_printk fmt' pointer */	\
+		VMLINUX_SYMBOL(__stop___trace_bprintk_fmt) = .;		\
 	}								\
 									\
 	.rodata1          : AT(ADDR(.rodata1) - LOAD_OFFSET) {		\
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 8ac2fac..f82b986 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -224,6 +224,27 @@ extern int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr);
 
 #ifdef CONFIG_TRACE_BPRINTK
 extern int trace_vbprintk(unsigned long ip, const char *fmt, va_list args);
+extern int __ftrace_bprintk(unsigned long ip, const char *fmt, ...)
+		__attribute__ ((format (printf, 2, 3)));
+
+static inline void  ____ftrace_bprintk_check_format(const char *fmt, ...)
+		__attribute__ ((format (printf, 1, 2)));
+static inline void ____ftrace_bprintk_check_format(const char *fmt, ...) {}
+#define __ftrace_bprintk_check_format(fmt, args...)			\
+do {									\
+	if (0)								\
+		____ftrace_bprintk_check_format(fmt, ##args);		\
+} while (0)
+
+#define ftrace_bprintk(fmt, args...)					\
+do {									\
+	static char *__attribute__((section("__trace_bprintk_fmt")))	\
+			ftrace_bprintk_fmt = fmt;			\
+	__ftrace_bprintk_check_format(fmt, ##args);			\
+	__ftrace_bprintk(_THIS_IP_, ftrace_bprintk_fmt, ##args);	\
+} while (0)
+#else
+#define ftrace_bprintk ftrace_printk
 #endif
 
 /* May be defined in arch */
diff --git a/include/linux/module.h b/include/linux/module.h
index 07b1cb4..c4f2845 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -347,6 +347,11 @@ struct module
 	unsigned int num_tracepoints;
 #endif
 
+#ifdef CONFIG_TRACE_BPRINTK
+	const char **trace_bprintk_fmt_start;
+	unsigned int num_trace_bprintk_fmt;
+#endif
+
 #ifdef CONFIG_MODULE_UNLOAD
 	/* What modules depend on me? */
 	struct list_head modules_which_use_me;
diff --git a/kernel/module.c b/kernel/module.c
index 90a6d63..fa96909 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2192,6 +2192,12 @@ static noinline struct module *load_module(void __user *umod,
 					&mod->num_tracepoints);
 #endif
 
+#ifdef CONFIG_TRACE_BPRINTK
+	mod->trace_bprintk_fmt_start = section_objs(hdr, sechdrs, secstrings,
+			"__trace_bprintk_fmt", sizeof(char *),
+			&mod->num_trace_bprintk_fmt);
+#endif
+
 #ifdef CONFIG_MODVERSIONS
 	if ((mod->num_syms && !mod->crcs)
 	    || (mod->num_gpl_syms && !mod->gpl_crcs)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3a3ae19..0e30dce 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3627,6 +3627,21 @@ out:
 }
 EXPORT_SYMBOL_GPL(trace_vbprintk);
 
+int __ftrace_bprintk(unsigned long ip, const char *fmt, ...)
+{
+	int ret;
+	va_list ap;
+
+	if (!fmt)
+		return 0;
+
+	va_start(ap, fmt);
+	ret = trace_vbprintk(ip, fmt, ap);
+	va_end(ap);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__ftrace_bprintk);
+
 static int trace_panic_handler(struct notifier_block *this,
 			       unsigned long event, void *unused)
 {
diff --git a/kernel/trace/trace_bprintk.c b/kernel/trace/trace_bprintk.c
index 1f8e532..28e6286 100644
--- a/kernel/trace/trace_bprintk.c
+++ b/kernel/trace/trace_bprintk.c
@@ -19,9 +19,23 @@
 
 #include "trace.h"
 
+#ifdef CONFIG_MODULES
+
 /* binary printk basic */
 static DEFINE_MUTEX(btrace_mutex);
 static int btrace_metadata_count;
+/*
+ * modules ftrace_bprintk()'s formats are autosaved in struct trace_bprintk_fmt
+ * which are queued on trace_bprintk_fmt_list.
+ */
+static LIST_HEAD(trace_bprintk_fmt_list);
+
+struct trace_bprintk_fmt {
+	struct list_head list;
+	int count;
+	char fmt[0];
+};
+
 
 static inline void lock_btrace(void)
 {
@@ -33,6 +47,93 @@ static inline void unlock_btrace(void)
 	mutex_unlock(&btrace_mutex);
 }
 
+/*
+ * If trace_bprintk() is not active, we release the trace_bprintk's
+ * formats that no modules has reference to.
+ */
+static inline void shrink_trace_bprintk_fmt(void)
+{
+	struct trace_bprintk_fmt *pos, *next;
+	list_for_each_entry_safe(pos, next, &trace_bprintk_fmt_list, list) {
+		if (!pos->count) {
+			list_del(&pos->list);
+			kfree(pos);
+		}
+	}
+}
+
+static inline struct trace_bprintk_fmt *lookup_format(const char *fmt)
+{
+	struct trace_bprintk_fmt *pos;
+	list_for_each_entry(pos, &trace_bprintk_fmt_list, list) {
+		if (!strcmp(pos->fmt, fmt))
+			return pos;
+	}
+	return NULL;
+}
+
+static
+void hold_module_trace_bprintk_format(const char **start, const char **end)
+{
+	const char **iter;
+	lock_btrace();
+	for (iter = start; iter < end; iter++) {
+		struct trace_bprintk_fmt *tb_fmt = lookup_format(*iter);
+		if (tb_fmt) {
+			tb_fmt->count++;
+			*iter = tb_fmt->fmt;
+			continue;
+		}
+
+		tb_fmt = kmalloc(offsetof(struct trace_bprintk_fmt, fmt)
+				+ strlen(*iter) + 1, GFP_KERNEL);
+		if (tb_fmt) {
+			list_add_tail(&tb_fmt->list, &trace_bprintk_fmt_list);
+			tb_fmt->count = 1;
+			strcpy(tb_fmt->fmt, *iter);
+			*iter = tb_fmt->fmt;
+		} else
+			*iter = NULL;
+	}
+	unlock_btrace();
+}
+
+static
+void release_module_trace_bprintk_format(const char **start, const char **end)
+{
+	const char **iter;
+	lock_btrace();
+	for (iter = start; iter < end; iter++) {
+		struct trace_bprintk_fmt *tb_fmt;
+		if (!*iter)
+			continue;
+
+		tb_fmt = container_of(*iter, struct trace_bprintk_fmt, fmt[0]);
+		tb_fmt->count--;
+		if (!tb_fmt->count && !btrace_metadata_count) {
+			list_del(&tb_fmt->list);
+			kfree(tb_fmt);
+		}
+	}
+	unlock_btrace();
+}
+
+static int module_trace_bprintk_format_notify(struct notifier_block *self,
+		unsigned long val, void *data)
+{
+	struct module *mod = data;
+	if (mod->num_trace_bprintk_fmt) {
+		const char **start = mod->trace_bprintk_fmt_start;
+		const char **end = start + mod->num_trace_bprintk_fmt;
+
+		if (val == MODULE_STATE_COMING)
+			hold_module_trace_bprintk_format(start, end);
+		else if (val == MODULE_STATE_GOING)
+			release_module_trace_bprintk_format(start, end);
+	}
+	return 0;
+}
+
 static void get_btrace_metadata(void)
 {
 	lock_btrace();
@@ -44,9 +145,31 @@ static void put_btrace_metadata(void)
 {
 	lock_btrace();
 	btrace_metadata_count--;
+
+	if (!btrace_metadata_count) {
+		shrink_trace_bprintk_fmt();
+	}
 	unlock_btrace();
 }
 
+#else /* !CONFIG_MODULES */
+__init static int
+module_trace_bprintk_format_notify(struct notifier_block *self,
+		unsigned long val, void *data)
+{
+	return 0;
+}
+
+static inline void get_btrace_metadata(void) { }
+static inline void put_btrace_metadata(void) { }
+#endif /* CONFIG_MODULES */
+
+
+__initdata_or_module static
+struct notifier_block module_trace_bprintk_format_nb = {
+	.notifier_call = module_trace_bprintk_format_notify,
+};
+
 /* events tracer */
 int trace_bprintk_enable;
 
@@ -81,7 +204,14 @@ static struct tracer bprintk_trace __read_mostly =
 
 static __init int init_bprintk(void)
 {
-	return register_tracer(&bprintk_trace);
+	int ret = register_module_notifier(&module_trace_bprintk_format_nb);
+	if (ret)
+		return ret;
+
+	ret = register_tracer(&bprintk_trace);
+	if (ret)
+		unregister_module_notifier(&module_trace_bprintk_format_nb);
+	return ret;
 }
 
 device_initcall(init_bprintk);
-- 
1.6.1


