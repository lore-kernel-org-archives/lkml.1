Return-Path: <linux-kernel-owner+w=401wt.eu-S1752068AbZI1Pm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbZI1Pm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 11:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbZI1Pm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 11:42:27 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:57118 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbZI1Pm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 11:42:27 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] tracing: Fix infinite loop in ftrace_update_pid_func()
Date: Mon, 28 Sep 2009 16:43:01 +0100
Message-Id: <1254152581-18347-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.6.4.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matthew.fleming@imgtec.com>

When CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST is enabled
__ftrace_trace_function contains the current trace function, not
ftrace_trace_function. In ftrace_update_pid_func() we currently
incorrectly assign the value of ftrace_trace_function to
__ftrace_trace_funcion before returning.

Without this patch it is possible to execute an infinite loop whereby
ftrace_test_stop_func() calls __ftrace_trace_function, which was
assigned ftrace_test_stop_func() in ftrace_update_pid_func().

Signed-off-by: Matt Fleming <matthew.fleming@imgtec.com>
---
 kernel/trace/ftrace.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 25edd5c..d9ba6d9 100644
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
-- 
1.6.3.GIT

