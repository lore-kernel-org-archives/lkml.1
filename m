Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbZHTKzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbZHTKzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbZHTKzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:55:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:47370 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbZHTKzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:55:07 -0400
Date: Thu, 20 Aug 2009 10:54:35 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, jbaron@redhat.com, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, jbaron@redhat.com, mhiramat@redhat.com,
       mingo@elte.hu
In-Reply-To: <4A8D05AF.20103@cn.fujitsu.com>
References: <4A8D05AF.20103@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing/syscalls: Fix the output of syscalls with no arguments
Message-ID: <tip-4539f07701b3f743580d19dc5d655fb8d21b0a3c@git.kernel.org>
Git-Commit-ID: 4539f07701b3f743580d19dc5d655fb8d21b0a3c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 20 Aug 2009 10:54:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4539f07701b3f743580d19dc5d655fb8d21b0a3c
Gitweb:     http://git.kernel.org/tip/4539f07701b3f743580d19dc5d655fb8d21b0a3c
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 20 Aug 2009 16:13:35 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 20 Aug 2009 12:12:22 +0200

tracing/syscalls: Fix the output of syscalls with no arguments

Before:

  # echo 1 > events/syscalls/sys_enter_sync/enable
  # cat events/syscalls/sys_enter_sync/format
  ...
        field:int nr;   offset:12;      size:4;

  print fmt: "# sync
  # cat trace
  ...
            sync-8950  [000]  2366.087670: sys_sync(

After:

  # echo 1 > events/syscalls/sys_enter_sync/enable
  # cat events/syscalls/sys_enter_sync/format
  ...
        field:int nr;   offset:12;      size:4;

  print fmt: ""
  # sync
  # cat trace
            sync-2134  [001]   136.780735: sys_sync()

Reported-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
LKML-Reference: <4A8D05AF.20103@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_syscalls.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 28e4dae..46c1b97 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -46,15 +46,22 @@ print_syscall_enter(struct trace_iterator *iter, int flags)
 				return TRACE_TYPE_PARTIAL_LINE;
 		}
 		/* parameter values */
-		ret = trace_seq_printf(s, "%s: %lx%s ", entry->args[i],
+		ret = trace_seq_printf(s, "%s: %lx%s", entry->args[i],
 				       trace->args[i],
-				       i == entry->nb_args - 1 ? ")" : ",");
+				       i == entry->nb_args - 1 ? "" : ", ");
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
+	ret = trace_seq_putc(s, ')');
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
 end:
-	trace_seq_printf(s, "\n");
+	ret =  trace_seq_putc(s, '\n');
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
 	return TRACE_TYPE_HANDLED;
 }
 
@@ -129,24 +136,24 @@ int syscall_enter_format(struct ftrace_event_call *call, struct trace_seq *s)
 		offset += sizeof(unsigned long);
 	}
 
-	trace_seq_printf(s, "\nprint fmt: \"");
+	trace_seq_puts(s, "\nprint fmt: \"");
 	for (i = 0; i < entry->nb_args; i++) {
 		ret = trace_seq_printf(s, "%s: 0x%%0%zulx%s", entry->args[i],
 				        sizeof(unsigned long),
-					i == entry->nb_args - 1 ? "\", " : ", ");
+					i == entry->nb_args - 1 ? "" : ", ");
 		if (!ret)
 			return 0;
 	}
+	trace_seq_putc(s, '"');
 
 	for (i = 0; i < entry->nb_args; i++) {
-		ret = trace_seq_printf(s, "((unsigned long)(REC->%s))%s",
-				        entry->args[i],
-					i == entry->nb_args - 1 ? "\n" : ", ");
+		ret = trace_seq_printf(s, ", ((unsigned long)(REC->%s))",
+				       entry->args[i]);
 		if (!ret)
 			return 0;
 	}
 
-	return ret;
+	return trace_seq_putc(s, '\n');
 }
 
 int syscall_exit_format(struct ftrace_event_call *call, struct trace_seq *s)
