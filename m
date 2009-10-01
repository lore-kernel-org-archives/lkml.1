Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbZJAGtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbZJAGtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 02:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbZJAGtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 02:49:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:55380 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbZJAGtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 02:49:14 -0400
Date: Thu, 1 Oct 2009 06:48:50 GMT
From: tip-bot for Matt Fleming <matthew.fleming@imgtec.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       matthew.fleming@imgtec.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       matthew.fleming@imgtec.com, mingo@elte.hu
In-Reply-To: <1254152581-18347-1-git-send-email-matt@console-pimps.org>
References: <1254152581-18347-1-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing: Fix infinite recursion in ftrace_update_pid_func()
Message-ID: <tip-33974093c024f08caadd2fc71a83bd811ed1831d@git.kernel.org>
Git-Commit-ID: 33974093c024f08caadd2fc71a83bd811ed1831d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 06:48:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  33974093c024f08caadd2fc71a83bd811ed1831d
Gitweb:     http://git.kernel.org/tip/33974093c024f08caadd2fc71a83bd811ed1831d
Author:     Matt Fleming <matthew.fleming@imgtec.com>
AuthorDate: Mon, 28 Sep 2009 16:43:01 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 1 Oct 2009 08:19:24 +0200

tracing: Fix infinite recursion in ftrace_update_pid_func()

When CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST is enabled
__ftrace_trace_function contains the current trace function, not
ftrace_trace_function.

In ftrace_update_pid_func() we currently incorrectly assign the
value of ftrace_trace_function to __ftrace_trace_funcion before
returning.

Without this patch it is possible to execute an infinite recursion
whereby ftrace_test_stop_func() calls __ftrace_trace_function,
which was assigned ftrace_test_stop_func() in
ftrace_update_pid_func().

Signed-off-by: Matt Fleming <matthew.fleming@imgtec.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1254152581-18347-1-git-send-email-matt@console-pimps.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/ftrace.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 46592fe..3724756 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -225,7 +225,11 @@ static void ftrace_update_pid_func(void)
 	if (ftrace_trace_function == ftrace_stub)
 		return;
 
+#ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	func = ftrace_trace_function;
+#else
+	func = __ftrace_trace_function;
+#endif
 
 	if (ftrace_pid_trace) {
 		set_ftrace_pid_function(func);
