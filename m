Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbZLBUne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbZLBUne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 15:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbZLBUne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 15:43:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbZLBUnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 15:43:33 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH v2] [RFC] tracepoint: Add signal coredump tracepoint
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 02 Dec 2009 15:46:37 -0500
Message-ID: <20091202204637.25408.41195.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <4B128ECF.9020906@redhat.com>
References: <4B128ECF.9020906@redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add signal coredump tracepoint which shows signal number,
mm->flags, limits, pointer to file structure and core
file name.

This tracepoint requirement comes mainly from the viewpoint of
administrators. Since now we have introduced many coredump
configurations (e.g. dumpable, coredump_filter, core_pattern,
etc) and some of them can be modified by users, it will be hard
to know what was actually dumped (or not dumped) after some
problem happened on the system. For example, a process didn't
generated core, coredump doesn't have some sections, etc.
In those cases, the coredump tracepoint can help us to know
why the core file is so big or small, or not generated, by
recording all configurations for all processes on the system.
That will reduce system-administration cost.

Changes in v2:
 - Fix a bug to clear file local variable when
   call_usermodehelper_pipe() is failed.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---

 fs/exec.c                     |   23 ++++++++++++----------
 include/trace/events/signal.h |   43 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 10 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 2ec6973..be3ec5c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -56,6 +56,7 @@
 #include <linux/fsnotify.h>
 #include <linux/fs_struct.h>
 #include <linux/pipe_fs_i.h>
+#include <trace/events/signal.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1772,6 +1773,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	static atomic_t core_dump_count = ATOMIC_INIT(0);
 	struct coredump_params cprm = {
 		.signr = signr,
+		.file = NULL,
 		.regs = regs,
 		.limit = current->signal->rlim[RLIMIT_CORE].rlim_cur,
 		/*
@@ -1837,9 +1839,6 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	ispipe = format_corename(corename, signr);
 	unlock_kernel();
 
-	if ((!ispipe) && (cprm.limit < binfmt->min_coredump))
-		goto fail_unlock;
-
  	if (ispipe) {
 		if (cprm.limit == 0) {
 			/*
@@ -1860,7 +1859,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 				"Process %d(%s) has RLIMIT_CORE set to 0\n",
 				task_tgid_vnr(current), current->comm);
 			printk(KERN_WARNING "Aborting core\n");
-			goto fail_unlock;
+			goto end_open;
 		}
 
 		dump_count = atomic_inc_return(&core_dump_count);
@@ -1868,14 +1867,14 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 			printk(KERN_WARNING "Pid %d(%s) over core_pipe_limit\n",
 			       task_tgid_vnr(current), current->comm);
 			printk(KERN_WARNING "Skipping core dump\n");
-			goto fail_dropcount;
+			goto end_open;
 		}
 
 		helper_argv = argv_split(GFP_KERNEL, corename+1, &helper_argc);
 		if (!helper_argv) {
 			printk(KERN_WARNING "%s failed to allocate memory\n",
 			       __func__);
-			goto fail_dropcount;
+			goto end_open;
 		}
 
 		cprm.limit = RLIM_INFINITY;
@@ -1883,15 +1882,20 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 		/* SIGPIPE can happen, but it's just never processed */
 		if (call_usermodehelper_pipe(helper_argv[0], helper_argv, NULL,
 				&cprm.file)) {
+			cprm.file = NULL;
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       corename);
-			goto fail_dropcount;
+			goto end_open;
  		}
- 	} else
+	} else if (cprm.limit >= binfmt->min_coredump)
 		cprm.file = filp_open(corename,
 				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
 				 0600);
-	if (IS_ERR(cprm.file))
+
+end_open:
+	trace_signal_coredump(&cprm, corename);
+
+	if (!cprm.file || IS_ERR(cprm.file))
 		goto fail_dropcount;
 	inode = cprm.file->f_path.dentry->d_inode;
 	if (inode->i_nlink > 1)
@@ -1928,7 +1932,6 @@ close_fail:
 fail_dropcount:
 	if (dump_count)
 		atomic_dec(&core_dump_count);
-fail_unlock:
 	if (helper_argv)
 		argv_free(helper_argv);
 
diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
index a510b75..7feba6e 100644
--- a/include/trace/events/signal.h
+++ b/include/trace/events/signal.h
@@ -6,6 +6,7 @@
 
 #include <linux/signal.h>
 #include <linux/sched.h>
+#include <linux/binfmts.h>
 #include <linux/tracepoint.h>
 
 #define TP_STORE_SIGINFO(__entry, info)				\
@@ -167,6 +168,48 @@ TRACE_EVENT(signal_lose_info,
 	TP_printk("sig=%d group=%d errno=%d code=%d",
 		  __entry->sig, __entry->group, __entry->errno, __entry->code)
 );
+
+/**
+ * signal_coredump - called when dumping core by signal
+ * @cprm: pointer to struct coredump_params
+ * @core_name: core-name string
+ *
+ * Current process dumps core file to 'core_name' file, because 'cprm->signr'
+ * signal is delivered.
+ * 'cprm->file' is a pointer to file structure of core file, if it is NULL
+ * or an error number(IS_ERR(cprm->file)), coredump should be failed.
+ */
+TRACE_EVENT(signal_coredump,
+
+	TP_PROTO(struct coredump_params *cprm, const char *core_name),
+
+	TP_ARGS(cprm, core_name),
+
+	TP_STRUCT__entry(
+		__field(	int,		sig		)
+		__field(	unsigned long,	limit		)
+		__field(	unsigned long,	flags		)
+		__field(	unsigned long,	file		)
+		__string(	name,		core_name	)
+	),
+
+
+	TP_fast_assign(
+		__entry->sig	= (int)cprm->signr;
+		__entry->limit	= cprm->limit;
+		__entry->flags	= cprm->mm_flags;
+		__entry->file	= (unsigned long)cprm->file;
+		__assign_str(name,	core_name);
+	),
+
+	TP_printk("sig=%d limit=%lu dumpable=%lx dump_filter=%lx "
+		  "file=%lx corename=%s",
+		  __entry->sig, __entry->limit,
+		  __entry->flags & MMF_DUMPABLE_MASK,
+		  (__entry->flags & MMF_DUMP_FILTER_MASK) >>
+		  MMF_DUMP_FILTER_SHIFT,
+		  __entry->file, __get_str(name))
+);
 #endif /* _TRACE_SIGNAL_H */
 
 /* This part must be outside protection */


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
