Return-Path: <linux-kernel-owner+w=401wt.eu-S1758240AbYJLNMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbYJLNMY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 09:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbYJLNMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 09:12:14 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:46654 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbYJLNMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 09:12:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=v7CA1SqNZLkAek4aiq17EXGlh3XwgzF1XLzKlZO4gCs9I9xlNVKQsfuvVG+RGmz/fB
         UAZNSgs+kweQnODpMuS/NluhUGHVo/kjvr4+uVFy6tqsiU7bveGovHWV0hR3OkQ632R2
         9MDKpY8GwXy/sySGsEW+39zkZUcTbNa/6APO8=
From: =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
To: mingo@elte.hu, srostedt@redhat.com
Cc: a.p.zijlstra@chello.nl, sandmann@daimi.au.dk, linux-kernel@vger.kernel.org,
       =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
Subject: [PATCH 2/4] Identify which executable object the userspace address belongs to.
Date: Sun, 12 Oct 2008 16:12:02 +0300
Message-Id: <1223817124-27239-4-git-send-email-edwintorok@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1223817124-27239-1-git-send-email-edwintorok@gmail.com>
References: <1223817124-27239-1-git-send-email-edwintorok@gmail.com>
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
 kernel/trace/trace.c |   48 +++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/trace/trace.h |    3 ++-
 2 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4c17453..722ab74 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -213,6 +213,7 @@ static const char *trace_options[] = {
 	"sched-tree",
 	"ftrace_printk",
 	"userstacktrace",
+	"sym-userobj",
 	NULL
 };
 
@@ -359,6 +360,20 @@ trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len)
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
@@ -655,6 +670,7 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
 
 	entry->preempt_count		= pc & 0xff;
 	entry->pid			= (tsk) ? tsk->pid : 0;
+	entry->tgid               	= (tsk) ? tsk->tgid : 0;
 	entry->flags =
 		(irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
 		((pc & HARDIRQ_MASK) ? TRACE_FLAG_HARDIRQ : 0) |
@@ -1179,11 +1195,26 @@ static int
 seq_print_userip_objs(const struct trace_entry *entry, struct trace_seq *s,
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
+		task = find_task_by_vpid(entry->field.tgid);
+		rcu_read_unlock();
+
+		if (task)
+			mm = get_task_mm(task);
+	}
+
 	for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
 		unsigned long ip = entry->field.stack.caller[i];
+		unsigned long vmstart = 0;
+		struct file *file = NULL;
 
 		if (ip == ULONG_MAX || !ret)
 			break;
@@ -1193,10 +1224,25 @@ seq_print_userip_objs(const struct trace_entry *entry, struct trace_seq *s,
 			ret = trace_seq_puts(s, "??");
 			continue;
 		}
-		if (sym_flags & TRACE_ITER_SYM_ADDR)
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
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 3ad6343..59d3b17 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -414,7 +414,8 @@ enum trace_iterator_flags {
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

