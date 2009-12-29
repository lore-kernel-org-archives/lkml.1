Return-Path: <linux-kernel-owner+w=401wt.eu-S1752967AbZL2Q1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbZL2Q1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 11:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbZL2Q1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 11:27:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34838 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbZL2Q0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 11:26:41 -0500
X-Authority-Analysis: v=1.0 c=1 a=5GKIi1lQWDkA:10 a=20KFwNOVAAAA:8 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=3nUBdAsL6-1fCVhU8cIA:9 a=iSXxyZsAMGop8dkH1ky0r5to5D0A:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20091229162638.963250308@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 29 Dec 2009 11:22:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 08/10] tracing: Have syscall tracing call its own init function
References: <20091229162231.441352392@goodmis.org>
Content-Disposition: inline; filename=0008-tracing-Have-syscall-tracing-call-its-own-init-funct.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

In the clean up of having all events call one specific function,
the syscall event init was changed to call this helper function.

With the new print_fmt updates, the syscalls need to do special
initializations. This patch converts the syscall events to call
its own init function again.

Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/syscalls.h      |    4 ++--
 kernel/trace/trace_syscalls.c |   12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 207466a..ed353d2 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -143,7 +143,7 @@ struct perf_event_attr;
 		.name                   = "sys_enter"#sname,		\
 		.system                 = "syscalls",			\
 		.event                  = &enter_syscall_print_##sname,	\
-		.raw_init		= trace_event_raw_init,		\
+		.raw_init		= init_syscall_trace,		\
 		.show_format		= syscall_enter_format,		\
 		.define_fields		= syscall_enter_define_fields,	\
 		.regfunc		= reg_event_syscall_enter,	\
@@ -165,7 +165,7 @@ struct perf_event_attr;
 		.name                   = "sys_exit"#sname,		\
 		.system                 = "syscalls",			\
 		.event                  = &exit_syscall_print_##sname,	\
-		.raw_init		= trace_event_raw_init,		\
+		.raw_init		= init_syscall_trace,		\
 		.show_format		= syscall_exit_format,		\
 		.define_fields		= syscall_exit_define_fields,	\
 		.regfunc		= reg_event_syscall_exit,	\
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 1352b0a..a78e863 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -450,14 +450,14 @@ int init_syscall_trace(struct ftrace_event_call *call)
 	if (set_syscall_print_fmt(call) < 0)
 		return -ENOMEM;
 
-	id = register_ftrace_event(call->event);
-	if (!id) {
+	id = trace_event_raw_init(call);
+
+	if (id < 0) {
 		free_syscall_print_fmt(call);
-		return -ENODEV;
+		return id;
 	}
-	call->id = id;
-	INIT_LIST_HEAD(&call->fields);
-	return 0;
+
+	return id;
 }
 
 int __init init_ftrace_syscalls(void)
-- 
1.6.5


