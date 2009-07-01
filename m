Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbZGAOB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbZGAOB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbZGAOBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:01:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:43301 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755871AbZGAOBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:01:43 -0400
Date: Wed, 1 Jul 2009 14:01:06 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A4ACE29.3010407@cn.fujitsu.com>
References: <4A4ACE29.3010407@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing/events: Add trace_event boot option
Message-ID: <tip-020e5f85cb087a40572c8b8b2dd06292a14fa212@git.kernel.org>
Git-Commit-ID: 020e5f85cb087a40572c8b8b2dd06292a14fa212
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Jul 2009 14:01:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  020e5f85cb087a40572c8b8b2dd06292a14fa212
Gitweb:     http://git.kernel.org/tip/020e5f85cb087a40572c8b8b2dd06292a14fa212
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 1 Jul 2009 10:47:05 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 15:44:24 +0200

tracing/events: Add trace_event boot option

We already have ftrace= boot option, and this adds a similar
boot option for trace events, so allow trace events to be
enabled at boot, for boot debugging purpose.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4A4ACE29.3010407@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/kernel-parameters.txt |    5 ++++
 Documentation/trace/events.txt      |    9 ++++++++
 kernel/trace/trace.c                |    4 +-
 kernel/trace/trace.h                |    3 ++
 kernel/trace/trace_events.c         |   37 +++++++++++++++++++++++++++++++---
 5 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index d3f41db..2582e7a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2478,6 +2478,11 @@ and is between 256 and 4096 characters. It is defined in the file
 	trace_buf_size=nn[KMG]
 			[FTRACE] will set tracing buffer size.
 
+	trace_event=[event-list]
+			[FTRACE] Set and start specified trace events in order
+			to facilitate early boot debugging.
+			See also Documentation/trace/events.txt
+
 	trix=		[HW,OSS] MediaTrix AudioTrix Pro
 			Format:
 			<io>,<irq>,<dma>,<dma2>,<sb_io>,<sb_irq>,<sb_dma>,<mpu_io>,<mpu_irq>
diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
index f157d75..2bcc8d4 100644
--- a/Documentation/trace/events.txt
+++ b/Documentation/trace/events.txt
@@ -83,6 +83,15 @@ When reading one of these enable files, there are four results:
  X - there is a mixture of events enabled and disabled
  ? - this file does not affect any event
 
+2.3 Boot option
+---------------
+
+In order to facilitate early boot debugging, use boot option:
+
+	trace_event=[event-list]
+
+The format of this boot option is the same as described in section 2.1.
+
 3. Defining an event-enabled tracepoint
 =======================================
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3aa0a0d..bdb3afc 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -49,7 +49,7 @@ unsigned long __read_mostly	tracing_thresh;
  * On boot up, the ring buffer is set to the minimum size, so that
  * we do not waste memory on systems that are not using tracing.
  */
-static int ring_buffer_expanded;
+int ring_buffer_expanded;
 
 /*
  * We need to change this state when a selftest is running.
@@ -63,7 +63,7 @@ static bool __read_mostly tracing_selftest_running;
 /*
  * If a tracer is running, we do not want to run SELFTEST.
  */
-static bool __read_mostly tracing_selftest_disabled;
+bool __read_mostly tracing_selftest_disabled;
 
 /* For tracers that don't implement custom flags */
 static struct tracer_opt dummy_tracer_opt[] = {
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 3548ae5..52eb0d8 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -517,6 +517,9 @@ extern unsigned long ftrace_update_tot_cnt;
 extern int DYN_FTRACE_TEST_NAME(void);
 #endif
 
+extern int ring_buffer_expanded;
+extern bool tracing_selftest_disabled;
+
 #ifdef CONFIG_FTRACE_STARTUP_TEST
 extern int trace_selftest_startup_function(struct tracer *trace,
 					   struct trace_array *tr);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 53c8fd3..fecac13 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -17,6 +17,8 @@
 #include <linux/ctype.h>
 #include <linux/delay.h>
 
+#include <asm/setup.h>
+
 #include "trace_output.h"
 
 #define TRACE_SYSTEM "TRACE_SYSTEM"
@@ -1133,6 +1135,18 @@ struct notifier_block trace_module_nb = {
 extern struct ftrace_event_call __start_ftrace_events[];
 extern struct ftrace_event_call __stop_ftrace_events[];
 
+static char bootup_event_buf[COMMAND_LINE_SIZE] __initdata;
+
+static __init int setup_trace_event(char *str)
+{
+	strlcpy(bootup_event_buf, str, COMMAND_LINE_SIZE);
+	ring_buffer_expanded = 1;
+	tracing_selftest_disabled = 1;
+
+	return 1;
+}
+__setup("trace_event=", setup_trace_event);
+
 static __init int event_trace_init(void)
 {
 	struct ftrace_event_call *call;
@@ -1140,6 +1154,8 @@ static __init int event_trace_init(void)
 	struct dentry *entry;
 	struct dentry *d_events;
 	int ret;
+	char *buf = bootup_event_buf;
+	char *token;
 
 	d_tracer = tracing_init_dentry();
 	if (!d_tracer)
@@ -1185,6 +1201,19 @@ static __init int event_trace_init(void)
 				 &ftrace_event_format_fops);
 	}
 
+	while (true) {
+		token = strsep(&buf, ",");
+
+		if (!token)
+			break;
+		if (!*token)
+			continue;
+
+		ret = ftrace_set_clr_event(token, 1);
+		if (ret)
+			pr_warning("Failed to enable trace event: %s\n", token);
+	}
+
 	ret = register_module_notifier(&trace_module_nb);
 	if (ret)
 		pr_warning("Failed to register trace events module notifier\n");
@@ -1392,10 +1421,10 @@ static __init void event_trace_self_test_with_function(void)
 
 static __init int event_trace_self_tests_init(void)
 {
-
-	event_trace_self_tests();
-
-	event_trace_self_test_with_function();
+	if (!tracing_selftest_disabled) {
+		event_trace_self_tests();
+		event_trace_self_test_with_function();
+	}
 
 	return 0;
 }
