Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbYKBVSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbYKBVSn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 16:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbYKBVSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 16:18:23 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:33892 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbYKBVSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 16:18:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=v6zYsybowF0Cru/ei0a82iHN8lQQtp+66c7M4jhlR/iGDmhklEG68277mmZOOswLfV
         ihPvhrTEF4e1O8T1sAQUOIZINcQBBLszhSTUmkBy5PM9Evq2dBskDa1ac3cDWVgTBkf3
         Y2KQf+BXylCQF2ub1TZg3fyOot6k+j5Bsz7uk=
From: =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
To: mingo@elte.hu
Cc: srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org, edwintorok@gmail.com
Subject: [PATCH] Identify which executable object the userspace address belongs to. Store thread group leader id, and use it to lookup the address in the process's map. We could have looked up the address on thread's map, but the thread might not exist by the time we are called. The process might not exist either, but if you are reading trace_pipe, that is unlikely.
Date: Sun,  2 Nov 2008 23:18:14 +0200
Message-Id: <1225660694-19765-3-git-send-email-edwintorok@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1225660694-19765-2-git-send-email-edwintorok@gmail.com>
References: <1225660694-19765-1-git-send-email-edwintorok@gmail.com>
 <1225660694-19765-2-git-send-email-edwintorok@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Or
 addr2line -fie /usr/lib/debug/libpthread-2.7.so 0xd370

For non-PIC/PIE executables this won't work:
 a.out[+0x73b]
You need to run the following: addr2line -fie a.out 0x40073b
(where 0x400000 is the default load address of a.out)

Signed-off-by: Török Edwin <edwintorok@gmail.com>
---
 Documentation/ftrace.txt |   13 ++++++++++-
 kernel/trace/trace.c     |   51 +++++++++++++++++++++++++++++++++++++++++++++-
 kernel/trace/trace.h     |    3 +-
 3 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/Documentation/ftrace.txt b/Documentation/ftrace.txt
index b81618e..c5670a9 100644
--- a/Documentation/ftrace.txt
+++ b/Documentation/ftrace.txt
@@ -330,7 +330,7 @@ output. To see what is available, simply cat the file:
 
   cat /debug/tracing/iter_ctrl
   print-parent nosym-offset nosym-addr noverbose noraw nohex nobin \
- noblock nostacktrace nosched-tree nouserstacktrace
+ noblock nostacktrace nosched-tree nouserstacktrace nosym-userobj
 
 To disable one of the options, echo in the option prepended with "no".
 
@@ -387,6 +387,17 @@ Here are the available options:
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
 
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index bb965af..b5f4068 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -236,6 +236,7 @@ static const char *trace_options[] = {
 	"sched-tree",
 	"ftrace_printk",
 	"userstacktrace",
+	"sym-userobj",
 	NULL
 };
 
@@ -382,6 +383,20 @@ trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len)
 	return trace_seq_putmem(s, hex, j);
 }
 
+static int
+trace_seq_path(struct trace_seq *s, struct path *path)
+{
+	int ret;
+	struct seq_file m;
+	m.count = s->len;
+	m.size = PAGE_SIZE;
+	m.buf = s->buffer;
+	ret = seq_path(&m, path, "\n");
+	if (ret)
+		s->len = m.count;
+	return ret;
+}
+
 static void
 trace_seq_reset(struct trace_seq *s)
 {
@@ -678,6 +693,7 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
 
 	entry->preempt_count		= pc & 0xff;
 	entry->pid			= (tsk) ? tsk->pid : 0;
+	entry->tgid               	= (tsk) ? tsk->tgid : 0;
 	entry->flags =
 #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
 		(irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
@@ -1221,11 +1237,26 @@ static int
 seq_print_userip_objs(const struct userstack_entry *entry, struct trace_seq *s,
 		unsigned long sym_flags)
 {
+	struct mm_struct *mm = NULL;
 	int ret = 1;
 	unsigned i;
 
+	if (trace_flags & TRACE_ITER_SYM_USEROBJ) {
+		struct task_struct *task;
+		/* we do the lookup on the thread group leader,
+		 * since individual threads might have already quit! */
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
+		unsigned long vmstart = 0;
+		struct file *file = NULL;
 
 		if (ip == ULONG_MAX || !ret)
 			break;
@@ -1235,10 +1266,25 @@ seq_print_userip_objs(const struct userstack_entry *entry, struct trace_seq *s,
 			ret = trace_seq_puts(s, "??");
 			continue;
 		}
-		if (ret /*&& (sym_flags & TRACE_ITER_SYM_ADDR)*/)
+		if (mm) {
+			const struct vm_area_struct *vma = find_vma(mm, ip);
+			if (vma) {
+				file = vma->vm_file;
+				vmstart = vma->vm_start;
+			}
+		}
+		if (file) {
+			ret = trace_seq_path(s, &file->f_path);
+			if (ret)
+				ret = trace_seq_printf(s, "[+0x%lx]",
+						ip - vmstart);
+		}
+		if (ret && ((sym_flags & TRACE_ITER_SYM_ADDR) || !file))
 			ret = trace_seq_printf(s, " <" IP_FMT ">", ip);
 	}
 
+	if (mm)
+		mmput(mm);
 	return ret;
 }
 
@@ -3239,6 +3285,9 @@ void ftrace_dump(void)
 		atomic_inc(&global_trace.data[cpu]->disabled);
 	}
 
+	/* don't look at user memory in panic mode */
+	trace_flags &= ~TRACE_ITER_SYM_USEROBJ;
+
 	printk(KERN_TRACE "Dumping ftrace buffer:\n");
 
 	iter.tr = &global_trace;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 4c81642..5f94aed 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -423,7 +423,8 @@ enum trace_iterator_flags {
 	TRACE_ITER_STACKTRACE		= 0x100,
 	TRACE_ITER_SCHED_TREE		= 0x200,
 	TRACE_ITER_PRINTK		= 0x400,
-	TRACE_ITER_USERSTACKTRACE       = 0x800
+	TRACE_ITER_USERSTACKTRACE       = 0x800,
+	TRACE_ITER_SYM_USEROBJ          = 0x1000
 };
 
 extern struct tracer nop_trace;
-- 
1.5.6.5

