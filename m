Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbZJLHqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbZJLHqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 03:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbZJLHqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 03:46:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013AbZJLHqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 03:46:33 -0400
Message-ID: <4AD2DEB9.2@redhat.com>
Date: Mon, 12 Oct 2009 09:46:01 +0200
From: Stefan Assmann <sassmann@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: fweisbec@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: add kernel command line graph function filtering
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 894e934e782ddaa33eb6d156d8326cdf479b5f62 Mon Sep 17 00:00:00 2001
From: Stefan Assmann <sassmann@redhat.com>
Date: Mon, 12 Oct 2009 09:11:47 +0200
Subject: [PATCH] ftrace: add kernel command line graph function filtering

Add a command line parameter to allow limiting the function graphs that
are traced on boot up, when ftrace=function_graph is specified.

This patch adds the following command line option:
ftrace_graph_filter=function-list

Where function-list is a comma separated list of functions to filter.

Signed-off-by: Stefan Assmann <sassmann@redhat.com>
---
 Documentation/kernel-parameters.txt |    9 ++++++++-
 kernel/trace/ftrace.c               |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9107b38..144eb83 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -771,7 +771,14 @@ and is between 256 and 4096 characters. It is defined in the file
 			tracer at boot up. function-list is a comma separated
 			list of functions. This list can be changed at run
 			time by the set_ftrace_filter file in the debugfs
-			tracing directory.
+			tracing directory.
+
+	ftrace_graph_filter=[function-list]
+			[FTRACE] Limit the functions traced by the function
+			graph tracer at boot up. function-list is a comma
+			separated list of functions. This list can be changed
+			at run time by the set_graph_function file in the
+			debugfs tracing directory.

 	ftrace_notrace=[function-list]
 			[FTRACE] Do not trace the functions specified in
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 3724756..a5cae5c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -78,6 +78,10 @@ ftrace_func_t ftrace_trace_function __read_mostly = ftrace_stub;
 ftrace_func_t __ftrace_trace_function __read_mostly = ftrace_stub;
 ftrace_func_t ftrace_pid_function __read_mostly = ftrace_stub;

+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+static int ftrace_set_func(unsigned long *array, int *idx, char *buffer);
+#endif
+
 static void ftrace_list_func(unsigned long ip, unsigned long parent_ip)
 {
 	struct ftrace_ops *op = ftrace_list;
@@ -2302,6 +2306,7 @@ void ftrace_set_notrace(unsigned char *buf, int len, int reset)
 #define FTRACE_FILTER_SIZE		COMMAND_LINE_SIZE
 static char ftrace_notrace_buf[FTRACE_FILTER_SIZE] __initdata;
 static char ftrace_filter_buf[FTRACE_FILTER_SIZE] __initdata;
+static char ftrace_graph_buf[FTRACE_FILTER_SIZE] __initdata;

 static int __init set_ftrace_notrace(char *str)
 {
@@ -2317,6 +2322,31 @@ static int __init set_ftrace_filter(char *str)
 }
 __setup("ftrace_filter=", set_ftrace_filter);

+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+static int __init set_graph_function(char *str)
+{
+	strncpy(ftrace_graph_buf, str, FTRACE_FILTER_SIZE);
+	return 1;
+}
+__setup("ftrace_graph_filter=", set_graph_function);
+
+static void __init set_ftrace_early_graph(char *buf)
+{
+	int ret;
+	char *func;
+
+	while (buf) {
+		func = strsep(&buf, ",");
+		/* we allow only one expression at a time */
+		ret = ftrace_set_func(ftrace_graph_funcs, &ftrace_graph_count,
+				      func);
+		if (ret)
+			printk(KERN_DEBUG "ftrace: function %s not "
+					  "traceable\n", func);
+	}
+}
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
 static void __init set_ftrace_early_filter(char *buf, int enable)
 {
 	char *func;
@@ -2333,6 +2363,10 @@ static void __init set_ftrace_early_filters(void)
 		set_ftrace_early_filter(ftrace_filter_buf, 1);
 	if (ftrace_notrace_buf[0])
 		set_ftrace_early_filter(ftrace_notrace_buf, 0);
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	if (ftrace_graph_buf[0])
+		set_ftrace_early_graph(ftrace_graph_buf);
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 }

 static int
-- 
1.6.2.5

