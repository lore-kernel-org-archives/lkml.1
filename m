Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbYLBCtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbYLBCtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 21:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbYLBCs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 21:48:58 -0500
Received: from mail.windriver.com ([147.11.1.11]:33996 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbYLBCs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 21:48:57 -0500
From: Liming Wang <liming.wang@windriver.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Liming Wang <liming.wang@windriver.com>
Subject: [PATCH 1/1] function trace: fix a bug of single thread function trace
Date: Tue,  2 Dec 2008 10:33:08 +0800
Message-Id: <1228185188-10422-1-git-send-email-liming.wang@windriver.com>
X-Mailer: git-send-email 1.6.0.3
X-OriginalArrivalTime: 02 Dec 2008 02:48:40.0631 (UTC) FILETIME=[7BA07C70:01C95428]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix a bug in ftrace_update_pid_func

When disabling single thread function trace using
"echo -1 > set_ftrace_pid", the normal function trace
has to restore to original function, otherwise the normal
function trace will not work well.
Without this commit, something like below:

	$ ps |grep 850
	  850 root      2556 S    -/bin/sh
	$ echo 850 > /debug/tracing/set_ftrace_pid
	$ echo function > /debug/tracing/current_tracer
	$ echo 1 > /debug/tracing/tracing_enabled
	$ sleep 1
	$ echo 0 > /debug/tracing/tracing_enabled
	$ cat /debug/tracing/trace_pipe |wc -l
	59704
	$ echo -1 > /debug/tracing/set_ftrace_pid
	$ echo 1 > /debug/tracing/tracing_enabled
	$ sleep 1
	$ echo 0 > /debug/tracing/tracing_enabled
	$ more /debug/tracing/trace_pipe
		<====== nothing output now!
			it should output trace record.

Signed-off-by: Liming Wang <liming.wang@windriver.com>
---
 kernel/trace/ftrace.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index cbf8b09..7540ef1 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -243,10 +243,8 @@ static void ftrace_update_pid_func(void)
 		set_ftrace_pid_function(func);
 		func = ftrace_pid_func;
 	} else {
-		if (func != ftrace_pid_func)
-			goto out;
-
-		set_ftrace_pid_function(func);
+		if (func == ftrace_pid_func)
+			func = ftrace_pid_function;
 	}
 
 #ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
-- 
1.6.0.3

