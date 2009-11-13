Return-Path: <linux-kernel-owner+w=401wt.eu-S932390AbZKMWwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390AbZKMWwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 17:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932272AbZKMWwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 17:52:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182AbZKMWwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 17:52:50 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 2/3] Add coredump tracepoint
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Roland McGrath <roland@redhat.com>
Date: Fri, 13 Nov 2009 17:52:34 -0500
Message-ID: <20091113225233.15079.41600.stgit@harusame>
In-Reply-To: <20091113225226.15079.90813.stgit@harusame>
References: <20091113225226.15079.90813.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add coredump tracepoint for tracing coredump event. This event shows coredump
caused signal, limit size, dumpable flag, dump-filter, and core name.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---

 fs/exec.c                    |    9 +++++++++
 include/trace/events/sched.h |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index dc418e3..6b77d10 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -56,6 +56,7 @@
 #include <linux/fsnotify.h>
 #include <linux/fs_struct.h>
 #include <linux/pipe_fs_i.h>
+#include <trace/events/sched.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1907,6 +1908,14 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	if (!ispipe && do_truncate(file->f_path.dentry, 0, 0, file) != 0)
 		goto close_fail;
 
+	/*
+	 * Trace core dump event.
+	 * Casting signr to int is safe because it comes from
+	 * si->signo int field.
+	 */
+	trace_sched_process_coredump((int)signr, core_limit, mm_flags,
+				     corename);
+
 	retval = binfmt->core_dump(signr, regs, file, core_limit, mm_flags);
 
 	if (retval)
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index b50b985..ff9d5fb 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -320,6 +320,40 @@ TRACE_EVENT(sched_process_fork,
 );
 
 /*
+ * Tracepoint for core_dump:
+ */
+TRACE_EVENT(sched_process_coredump,
+
+	TP_PROTO(int sig, unsigned long core_limit, unsigned long mm_flags,
+		 const char *core_name),
+
+	TP_ARGS(sig, core_limit, mm_flags, core_name),
+
+	TP_STRUCT__entry(
+		__field(	int,		sig		)
+		__field(	unsigned long,	limit		)
+		__field(	unsigned long,	flags		)
+		__string(	name,		core_name	)
+	),
+
+
+	TP_fast_assign(
+		__entry->sig	= sig;
+		__entry->limit	= core_limit;
+		__entry->flags	= mm_flags;
+		__assign_str(name,	core_name);
+	),
+
+	TP_printk("sig: %d limit: %lu dumpable: %lx dump_filter: %lx "
+		  "corename: %s",
+		  __entry->sig, __entry->limit,
+		  __entry->flags & MMF_DUMPABLE_MASK,
+		  (__entry->flags & MMF_DUMP_FILTER_MASK) >>
+		  MMF_DUMP_FILTER_SHIFT,
+		  __get_str(name))
+);
+
+/*
  * Tracepoint for sending a signal:
  */
 TRACE_EVENT(sched_signal_send,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
