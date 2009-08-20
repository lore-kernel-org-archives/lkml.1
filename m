Return-Path: <linux-kernel-owner+w=401wt.eu-S1752564AbZHTIPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbZHTIPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 04:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbZHTIO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 04:14:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51568 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbZHTIO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 04:14:58 -0400
Message-ID: <4A8D05AF.20103@cn.fujitsu.com>
Date: Thu, 20 Aug 2009 16:13:35 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/syscalls: Fix the output of syscalls with no arguments
References: <4A8CAE0C.9040107@cn.fujitsu.com>
In-Reply-To: <4A8CAE0C.9040107@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---

sorry for the repost, but I forgot to CC LKML.

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
-- 1.6.3 
