Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbYKVL3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbYKVL3l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 06:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757151AbYKVL25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 06:28:57 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:31342 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929AbYKVL2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 06:28:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=tBnU0QV2i7Tcj9h5PJMlCVrC19DxfYRe5emxvJ6+gLaA+HLA0E8NiyrslIy4lm02iG
         6lfb2H7LyfcwgWZxUuff+EmoAwCWmDJtO3UsNjIGIXMQT8qVXNPR7QCnmrDoktVG7d/b
         l3x7PGv2DvNsD50h2lRt/g7QAAb87UV2BmJtw=
From: =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
To: mingo@elte.hu
Cc: srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
Subject: [PATCH 2/2] tracing: identify which executable object the userspace address belongs to
Date: Sat, 22 Nov 2008 13:28:48 +0200
Message-Id: <1227353328-16104-3-git-send-email-edwintorok@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1227353328-16104-1-git-send-email-edwintorok@gmail.com>
References: <1227353328-16104-1-git-send-email-edwintorok@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: modify+improve the userstacktrace tracing visualization feature

Store thread group leader id, and use it to lookup the address in the
process's map. We could have looked up the address on thread's map,
but the thread might not exist by the time we are called. The process
might not exist either, but if you are reading trace_pipe, that is
unlikely.

Example usage:

 mount -t debugfs nodev /sys/kernel/debug
 cd /sys/kernel/debug/tracing
 echo userstacktrace >iter_ctrl
 echo sym-userobj >iter_ctrl
 echo sched_switch >current_tracer
 echo 1 >tracing_enabled
 cat trace_pipe >/tmp/trace&
 .... run application ...
 echo 0 >tracing_enabled
 cat /tmp/trace

You'll see stack entries like:

   /lib/libpthread-2.7.so[+0xd370]

You can convert them to function/line using:

   addr2line -fie /lib/libpthread-2.7.so 0xd370

Or:

   addr2line -fie /usr/lib/debug/libpthread-2.7.so 0xd370

For non-PIC/PIE executables this won't work:

   a.out[+0x73b]

You need to run the following: addr2line -fie a.out 0x40073b
(where 0x400000 is the default load address of a.out)

Signed-off-by: Török Edwin <edwintorok@gmail.com>
---
 Documentation/ftrace.txt |   13 ++++++-
 fs/seq_file.c            |   14 +++++++-
 include/linux/seq_file.h |    1 +
 kernel/trace/trace.c     |   86 ++++++++++++++++++++++++++++++++++++++++++----
 kernel/trace/trace.h     |    3 +-
 5 files changed, 107 insertions(+), 10 deletions(-)

diff --git a/Documentation/ftrace.txt b/Documentation/ftrace.txt
index 79a80f7..35a78bc 100644
--- a/Documentation/ftrace.txt
+++ b/Documentation/ftrace.txt
@@ -324,7 +324,7 @@ output. To see what is available, simply cat the file:
 
   cat /debug/tracing/trace_options
   print-parent nosym-offset nosym-addr noverbose noraw nohex nobin \
- noblock nostacktrace nosched-tree nouserstacktrace
+ noblock nostacktrace nosched-tree nouserstacktrace nosym-userobj
 
 To disable one of the options, echo in the option prepended with "no".
 
@@ -381,6 +381,17 @@ Here are the available options:
   userstacktrace - This option changes the trace.
 		   It records a stacktrace of the current userspace thread.
 
+  sym-userobj - when user stacktrace are enabled, look up which object the
+		address belongs to, and print a relative address
+		This is especially useful when ASLR is on, otherwise you don't
+		get a chance to resolve the address to object/file/line after the app is no
+		longer running
+
+		The lookup is performed when you read trace,trace_pipe,latency_trace. Example:
+
+		a.out-1623  [000] 40874.465068: /root/a.out[+0x480] <-/root/a.out[+0
+x494] <- /root/a.out[+0x4a8] <- /lib/libc-2.7.so[+0x1e1a6]
+
   sched-tree - TBD (any users??)
 
 
diff --git a/fs/seq_file.c b/fs/seq_file.c
index eba2eab..e063077 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -357,7 +357,18 @@ int seq_printf(struct seq_file *m, const char *f, ...)
 }
 EXPORT_SYMBOL(seq_printf);
 
-static char *mangle_path(char *s, char *p, char *esc)
+/**
+ * 	mangle_path - mangle and copy path to buffer beginning
+ * 	@s - buffer start
+ * 	@p - beginning of path in above buffer
+ *      @esc - set of characters that need escaping
+ *
+ *      Copy the path from @p to @s, replacing each occurrence of character from
+ *      @esc with usual octal escape.
+ *      Returns pointer past last written character in @s, or NULL in case of
+ *      failure.
+ */
+char *mangle_path(char *s, char *p, char *esc)
 {
 	while (s <= p) {
 		char c = *p++;
@@ -376,6 +387,7 @@ static char *mangle_path(char *s, char *p, char *esc)
 	}
 	return NULL;
 }
+EXPORT_SYMBOL(mangle_path);
 
 /*
  * return the absolute path of 'dentry' residing in mount 'mnt'.
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index dc50bcc..b3dfa72 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -34,6 +34,7 @@ struct seq_operations {
 
 #define SEQ_SKIP 1
 
+char *mangle_path(char *s, char *p, char *esc);
 int seq_open(struct file *, const struct seq_operations *);
 ssize_t seq_read(struct file *, char __user *, size_t, loff_t *);
 loff_t seq_lseek(struct file *, loff_t, int);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ced8b4f..62776b7 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -30,6 +30,7 @@
 #include <linux/gfp.h>
 #include <linux/fs.h>
 #include <linux/kprobes.h>
+#include <linux/seq_file.h>
 #include <linux/writeback.h>
 
 #include <linux/stacktrace.h>
@@ -276,6 +277,7 @@ static const char *trace_options[] = {
 	"branch",
 	"annotate",
 	"userstacktrace",
+	"sym-userobj",
 	NULL
 };
 
@@ -422,6 +424,28 @@ trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len)
 	return trace_seq_putmem(s, hex, j);
 }
 
+static int
+trace_seq_path(struct trace_seq *s, struct path *path)
+{
+	unsigned char *p;
+
+	if (s->len >= (PAGE_SIZE - 1))
+		return 0;
+	p = d_path(path, s->buffer + s->len, PAGE_SIZE - s->len);
+	if (!IS_ERR(p)) {
+		p = mangle_path(s->buffer + s->len, p, "\n");
+		if (p) {
+			s->len = p - s->buffer;
+			return 1;
+		}
+	} else {
+		s->buffer[s->len++] = '?';
+		return 1;
+	}
+
+	return 0;
+}
+
 static void
 trace_seq_reset(struct trace_seq *s)
 {
@@ -802,6 +826,7 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
 
 	entry->preempt_count		= pc & 0xff;
 	entry->pid			= (tsk) ? tsk->pid : 0;
+	entry->tgid               	= (tsk) ? tsk->tgid : 0;
 	entry->flags =
 #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
 		(irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
@@ -1429,28 +1454,73 @@ seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
 	return ret;
 }
 
+static inline int seq_print_user_ip(struct trace_seq *s, struct mm_struct *mm,
+				    unsigned long ip, unsigned long sym_flags)
+{
+	struct file *file = NULL;
+	unsigned long vmstart = 0;
+	int ret = 1;
+
+	if (mm) {
+		const struct vm_area_struct *vma = find_vma(mm, ip);
+		if (vma) {
+			file = vma->vm_file;
+			vmstart = vma->vm_start;
+		}
+	}
+	if (file) {
+		ret = trace_seq_path(s, &file->f_path);
+		if (ret)
+			ret = trace_seq_printf(s, "[+0x%lx]",
+					ip - vmstart);
+	}
+	if (ret && ((sym_flags & TRACE_ITER_SYM_ADDR) || !file))
+		ret = trace_seq_printf(s, " <" IP_FMT ">", ip);
+	return ret;
+}
+
 static int
 seq_print_userip_objs(const struct userstack_entry *entry, struct trace_seq *s,
-		unsigned long sym_flags)
+		      unsigned long sym_flags)
 {
+	struct mm_struct *mm = NULL;
 	int ret = 1;
 	unsigned i;
 
+	if (trace_flags & TRACE_ITER_SYM_USEROBJ) {
+		struct task_struct *task;
+		/*
+		 * we do the lookup on the thread group leader,
+		 * since individual threads might have already quit!
+		 */
+		rcu_read_lock();
+		task = find_task_by_vpid(entry->ent.tgid);
+		rcu_read_unlock();
+
+		if (task)
+			mm = get_task_mm(task);
+	}
+
 	for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
 		unsigned long ip = entry->caller[i];
 
 		if (ip == ULONG_MAX || !ret)
 			break;
-		if (i)
+		if (i && ret)
 			ret = trace_seq_puts(s, " <- ");
 		if (!ip) {
-			ret = trace_seq_puts(s, "??");
+			if (ret)
+				ret = trace_seq_puts(s, "??");
 			continue;
 		}
-		if (ret /*&& (sym_flags & TRACE_ITER_SYM_ADDR)*/)
-			ret = trace_seq_printf(s, " <" IP_FMT ">", ip);
+		if (!ret)
+			break;
+		if (ret)
+			ret = seq_print_user_ip(s, mm, ip, sym_flags);
 	}
 
+	if (mm)
+		mmput(mm);
 	return ret;
 }
 
@@ -1775,8 +1845,7 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 		trace_assign_type(field, entry);
 
 		seq_print_userip_objs(field, s, sym_flags);
-		if (entry->flags & TRACE_FLAG_CONT)
-			trace_seq_print_cont(s, iter);
+		trace_seq_putc(s, '\n');
 		break;
 	}
 	default:
@@ -3581,6 +3650,9 @@ void ftrace_dump(void)
 		atomic_inc(&global_trace.data[cpu]->disabled);
 	}
 
+	/* don't look at user memory in panic mode */
+	trace_flags &= ~TRACE_ITER_SYM_USEROBJ;
+
 	printk(KERN_TRACE "Dumping ftrace buffer:\n");
 
 	iter.tr = &global_trace;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 17bb4c8..28c15c2 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -508,7 +508,8 @@ enum trace_iterator_flags {
 	TRACE_ITER_PREEMPTONLY		= 0x800,
 	TRACE_ITER_BRANCH		= 0x1000,
 	TRACE_ITER_ANNOTATE		= 0x2000,
-	TRACE_ITER_USERSTACKTRACE       = 0x4000
+	TRACE_ITER_USERSTACKTRACE       = 0x4000,
+	TRACE_ITER_SYM_USEROBJ          = 0x8000
 };
 
 /*
-- 
1.5.6.5

