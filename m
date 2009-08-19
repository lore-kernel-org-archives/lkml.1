Return-Path: <linux-kernel-owner+w=401wt.eu-S1751605AbZHSHy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbZHSHy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 03:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZHSHy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 03:54:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55577 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbZHSHy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 03:54:26 -0400
Message-ID: <4A8BAF61.3060307@cn.fujitsu.com>
Date: Wed, 19 Aug 2009 15:53:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] tracing/syscalls: Add fields format for exit events
References: <4A8BAF16.8040504@cn.fujitsu.com>
In-Reply-To: <4A8BAF16.8040504@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "format" file for syscall exit events:

 # cat events/syscalls/sys_exit_open/format
 name: sys_exit_open
 ID: 344
 format:
         field:unsigned short common_type;       offset:0;       size:2;
         field:unsigned char common_flags;       offset:2;       size:1;
         field:unsigned char common_preempt_count;       offset:3;       size:1;
         field:int common_pid;   offset:4;       size:4;
         field:int common_tgid;  offset:8;       size:4;

         field:int nr;   offset:12;      size:4;
         field:unsigned long ret;        offset:16;      size:4;

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/syscalls.h      |    3 ++-
 include/trace/syscall.h       |    6 ++++--
 kernel/trace/trace_syscalls.c |   18 +++++++++++++++++-
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 87d06c1..8d57f77 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -189,7 +189,7 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *event_call) \
 		.system                 = "syscalls",			\
 		.event                  = &event_syscall_enter,		\
 		.raw_init		= init_enter_##sname,		\
-		.show_format		= ftrace_format_syscall,	\
+		.show_format		= syscall_enter_format,		\
 		.regfunc		= reg_event_syscall_enter,	\
 		.unregfunc		= unreg_event_syscall_enter,	\
 		.data			= "sys"#sname,			\
@@ -225,6 +225,7 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *event_call) \
 		.system                 = "syscalls",			\
 		.event                  = &event_syscall_exit,		\
 		.raw_init		= init_exit_##sname,		\
+		.show_format		= syscall_exit_format,		\
 		.regfunc		= reg_event_syscall_exit,	\
 		.unregfunc		= unreg_event_syscall_exit,	\
 		.data			= "sys"#sname,			\
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 0cb0362..5ce85d7 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -55,8 +55,10 @@ extern int reg_event_syscall_enter(void *ptr);
 extern void unreg_event_syscall_enter(void *ptr);
 extern int reg_event_syscall_exit(void *ptr);
 extern void unreg_event_syscall_exit(void *ptr);
-extern int
-ftrace_format_syscall(struct ftrace_event_call *call, struct trace_seq *s);
+extern int syscall_enter_format(struct ftrace_event_call *call,
+				struct trace_seq *s);
+extern int syscall_exit_format(struct ftrace_event_call *call,
+				struct trace_seq *s);
 enum print_line_t print_syscall_enter(struct trace_iterator *iter, int flags);
 enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flags);
 #endif
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index d10daf0..7336b6c 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -97,7 +97,7 @@ extern char *__bad_type_size(void);
 		__bad_type_size() :					\
 		#type, #name, offsetof(typeof(trace), name), sizeof(trace.name)
 
-int ftrace_format_syscall(struct ftrace_event_call *call, struct trace_seq *s)
+int syscall_enter_format(struct ftrace_event_call *call, struct trace_seq *s)
 {
 	int i;
 	int nr;
@@ -149,6 +149,22 @@ int ftrace_format_syscall(struct ftrace_event_call *call, struct trace_seq *s)
 	return ret;
 }
 
+int syscall_exit_format(struct ftrace_event_call *call, struct trace_seq *s)
+{
+	int ret;
+	struct syscall_trace_exit trace;
+
+	ret = trace_seq_printf(s,
+			       "\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
+			       "\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n",
+			       SYSCALL_FIELD(int, nr),
+			       SYSCALL_FIELD(unsigned long, ret));
+	if (!ret)
+		return 0;
+
+	return trace_seq_printf(s, "\nprint fmt: \"0x%%lx\", REC->ret\n");
+}
+
 void ftrace_syscall_enter(struct pt_regs *regs, long id)
 {
 	struct syscall_trace_enter *entry;
-- 
1.6.3

