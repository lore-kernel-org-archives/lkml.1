Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935700Ab0BZJ2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 04:28:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:58518 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935668Ab0BZJ2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 04:28:18 -0500
Date: Fri, 26 Feb 2010 09:27:50 GMT
From: tip-bot for Jeff Mahoney <jeffm@suse.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, jeffm@suse.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, jeffm@suse.com, tglx@linutronix.de
In-Reply-To: <4B85770B.6010901@suse.com>
References: <4B85770B.6010901@suse.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Fix ftrace_event_call alignment for use with gcc 4.5
Message-ID: <tip-86c38a31aa7f2dd6e74a262710bf8ebf7455acc5@git.kernel.org>
Git-Commit-ID: 86c38a31aa7f2dd6e74a262710bf8ebf7455acc5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 09:27:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  86c38a31aa7f2dd6e74a262710bf8ebf7455acc5
Gitweb:     http://git.kernel.org/tip/86c38a31aa7f2dd6e74a262710bf8ebf7455acc5
Author:     Jeff Mahoney <jeffm@suse.com>
AuthorDate: Wed, 24 Feb 2010 13:59:23 -0500
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 25 Feb 2010 09:38:11 -0500

tracing: Fix ftrace_event_call alignment for use with gcc 4.5

GCC 4.5 introduces behavior that forces the alignment of structures to
 use the largest possible value. The default value is 32 bytes, so if
 some structures are defined with a 4-byte alignment and others aren't
 declared with an alignment constraint at all - it will align at 32-bytes.

 For things like the ftrace events, this results in a non-standard array.
 When initializing the ftrace subsystem, we traverse the _ftrace_events
 section and call the initialization callback for each event. When the
 structures are misaligned, we could be treating another part of the
 structure (or the zeroed out space between them) as a function pointer.

 This patch forces the alignment for all the ftrace_event_call structures
 to 4 bytes.

 Without this patch, the kernel fails to boot very early when built with
 gcc 4.5.

 It's trivial to check the alignment of the members of the array, so it
 might be worthwhile to add something to the build system to do that
 automatically. Unfortunately, that only covers this case. I've asked one
 of the gcc developers about adding a warning when this condition is seen.

Cc: stable@kernel.org
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
LKML-Reference: <4B85770B.6010901@suse.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/syscalls.h |    6 ++++--
 include/trace/ftrace.h   |    3 ++-
 kernel/trace/trace.h     |    3 ++-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 7b21969..91bd7d7 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -132,7 +132,8 @@ struct perf_event_attr;
 
 #define SYSCALL_TRACE_ENTER_EVENT(sname)				\
 	static const struct syscall_metadata __syscall_meta_##sname;	\
-	static struct ftrace_event_call event_enter_##sname;		\
+	static struct ftrace_event_call					\
+	__attribute__((__aligned__(4))) event_enter_##sname;		\
 	static struct trace_event enter_syscall_print_##sname = {	\
 		.trace                  = print_syscall_enter,		\
 	};								\
@@ -153,7 +154,8 @@ struct perf_event_attr;
 
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
 	static const struct syscall_metadata __syscall_meta_##sname;	\
-	static struct ftrace_event_call event_exit_##sname;		\
+	static struct ftrace_event_call					\
+	__attribute__((__aligned__(4))) event_exit_##sname;		\
 	static struct trace_event exit_syscall_print_##sname = {	\
 		.trace                  = print_syscall_exit,		\
 	};								\
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 09fd9af..f23a0ca 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -65,7 +65,8 @@
 	};
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, name, proto, args)	\
-	static struct ftrace_event_call event_##name
+	static struct ftrace_event_call			\
+	__attribute__((__aligned__(4))) event_##name
 
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index b477fce..fd05bca 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -792,7 +792,8 @@ extern const char *__stop___trace_bprintk_fmt[];
 
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, id, tstruct, print)		\
-	extern struct ftrace_event_call event_##call;
+	extern struct ftrace_event_call					\
+	__attribute__((__aligned__(4))) event_##call;
 #undef FTRACE_ENTRY_DUP
 #define FTRACE_ENTRY_DUP(call, struct_name, id, tstruct, print)		\
 	FTRACE_ENTRY(call, struct_name, id, PARAMS(tstruct), PARAMS(print))
