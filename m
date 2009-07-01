Return-Path: <linux-kernel-owner+w=401wt.eu-S1755651AbZGACqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbZGACqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 22:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbZGACqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 22:46:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65367 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752955AbZGACqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 22:46:12 -0400
Message-ID: <4A4ACE29.3010407@cn.fujitsu.com>
Date: Wed, 01 Jul 2009 10:47:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/events: add trace_event boot option
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already have ftrace= boot option, and this adds a similar
boot option for trace events, so allow trace events to be
enabled at boot, for boot debugging purpose.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 Documentation/kernel-parameters.txt |    5 ++++
 Documentation/trace/events.txt      |    9 ++++++++
 kernel/trace/trace.c                |    4 +-
 kernel/trace/trace.h                |    3 ++
 kernel/trace/trace_events.c         |   37 +++++++++++++++++++++++++++++++---
 5 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index d77fbd8..6f98ed7 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2476,6 +2476,11 @@ and is between 256 and 4096 characters. It is defined in the file
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
index 206cb7d..61b4e94 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -538,6 +538,9 @@ extern unsigned long ftrace_update_tot_cnt;
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
-- 
1.5.4.rc3

