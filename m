Return-Path: <linux-kernel-owner+w=401wt.eu-S1760701AbYGKBCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760701AbYGKBCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757228AbYGKA75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 20:59:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60133 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746AbYGKA7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 20:59:52 -0400
Message-Id: <20080711005951.157927213@goodmis.org>
References: <20080711005808.316194101@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 20:58:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 7/8] ftrace: add ftrace_kill_atomic
Content-Disposition: inline; filename=ftrace-kill-atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has been suggested that I add a way to disable the function tracer
on an oops. This code adds a ftrace_kill_atomic. It is not meant to be
used in normal situations. It will disable the ftrace tracer, but will
not perform the nice shutdown that requires scheduling.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h |    1 +
 kernel/trace/ftrace.c  |   15 +++++++++++++++
 2 files changed, 16 insertions(+)

Index: linux-tip.git/include/linux/ftrace.h
===================================================================
--- linux-tip.git.orig/include/linux/ftrace.h	2008-07-03 17:30:24.000000000 -0400
+++ linux-tip.git/include/linux/ftrace.h	2008-07-10 11:55:15.000000000 -0400
@@ -89,6 +89,7 @@ void ftrace_enable_daemon(void);
 
 /* totally disable ftrace - can not re-enable after this */
 void ftrace_kill(void);
+void ftrace_kill_atomic(void);
 
 static inline void tracer_disable(void)
 {
Index: linux-tip.git/kernel/trace/ftrace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ftrace.c	2008-07-10 00:30:00.000000000 -0400
+++ linux-tip.git/kernel/trace/ftrace.c	2008-07-10 11:54:09.000000000 -0400
@@ -1602,6 +1602,21 @@ core_initcall(ftrace_dynamic_init);
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 /**
+ * ftrace_kill_atomic - kill ftrace from critical sections
+ *
+ * This function should be used by panic code. It stops ftrace
+ * but in a not so nice way. If you need to simply kill ftrace
+ * from a non-atomic section, use ftrace_kill.
+ */
+void ftrace_kill_atomic(void)
+{
+	ftrace_disabled = 1;
+	ftrace_enabled = 0;
+	ftraced_suspend = -1;
+	clear_ftrace_function();
+}
+
+/**
  * ftrace_kill - totally shutdown ftrace
  *
  * This is a safety measure. If something was detected that seems

-- 
