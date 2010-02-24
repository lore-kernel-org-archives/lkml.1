Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab0BXS70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 13:59:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757364Ab0BXS7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 13:59:25 -0500
Message-ID: <4B85770B.6010901@suse.com>
Date: Wed, 24 Feb 2010 13:59:23 -0500
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-1.5 Thunderbird/3.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: fix ftrace_event_call alignment for use with gcc
 4.5
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 include/linux/syscalls.h |    6 ++++--
 include/trace/ftrace.h   |    3 ++-
 kernel/trace/trace.h     |    3 ++-
 3 files changed, 8 insertions(+), 4 deletions(-)

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
@@ -154,7 +155,8 @@ struct perf_event_attr;
 
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
 	static const struct syscall_metadata __syscall_meta_##sname;	\
-	static struct ftrace_event_call event_exit_##sname;		\
+	static struct ftrace_event_call					\
+	__attribute__((__aligned__(4))) event_exit_##sname;		\
 	static struct trace_event exit_syscall_print_##sname = {	\
 		.trace                  = print_syscall_exit,		\
 	};								\
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
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -791,7 +791,8 @@ extern const char *__stop___trace_bprint
 
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, id, tstruct, print)		\
-	extern struct ftrace_event_call event_##call;
+	extern struct ftrace_event_call					\
+	__attribute__((__aligned__(4))) event_##call;
 #undef FTRACE_ENTRY_DUP
 #define FTRACE_ENTRY_DUP(call, struct_name, id, tstruct, print)		\
 	FTRACE_ENTRY(call, struct_name, id, PARAMS(tstruct), PARAMS(print))
-- 
Jeff Mahoney
SUSE Labs
