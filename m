Return-Path: <linux-kernel-owner+w=401wt.eu-S1759048AbZJMHjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048AbZJMHjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759021AbZJMHjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:39:46 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:45856 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758988AbZJMHjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:39:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ulgeVYoyqhDXSiS/SsMhHTV68uopC7/YXh1hUTnjNQp3QYXD2bGEEj2KPJg0QiKMHO
         HR/HyJHlWdE0FE/g1u2XuRj/wiOsZj4S5h+v98Sf64d0koRsVfDqiZvKCVhRc2incVzm
         HVYtG+VNmZPMHUBYbUBeo0XQnM7khqvGKv++o=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Stefan Assmann <sassmann@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/3] ftrace: add kernel command line graph function filtering
Date: Tue, 13 Oct 2009 09:38:58 +0200
Message-Id: <1255419540-5481-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1255419540-5481-1-git-send-email-fweisbec@gmail.com>
References: <1255419540-5481-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Assmann <sassmann@redhat.com>

Add a command line parameter to allow limiting the function graphs
that are traced on boot up from the given top-level callers , when
ftrace=function_graph is specified.

This patch adds the following command line option:
ftrace_graph_filter=function-list

Where function-list is a comma separated list of functions to filter.

[fweisbec@gmail.com: picked the documentation changes from the v2 patch]

Signed-off-by: Stefan Assmann <sassmann@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4AD2DEB9.2@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 Documentation/kernel-parameters.txt |    7 +++++++
 kernel/trace/ftrace.c               |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6fa7292..1dc4b9c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -778,6 +778,13 @@ and is between 256 and 4096 characters. It is defined in the file
 			by the set_ftrace_notrace file in the debugfs
 			tracing directory.
 
+	ftrace_graph_filter=[function-list]
+			[FTRACE] Limit the top level callers functions traced
+			by the function graph tracer at boot up.
+			function-list is a comma separated list of functions
+			that can be changed at run time by the
+			set_graph_function file in the debugfs tracing directory.
+
 	gamecon.map[2|3]=
 			[HW,JOY] Multisystem joystick and NES/SNES/PSX pad
 			support via parallel port (up to 5 devices per port)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 9a72853..91283d4 100644
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
@@ -2248,6 +2252,7 @@ void ftrace_set_notrace(unsigned char *buf, int len, int reset)
 #define FTRACE_FILTER_SIZE		COMMAND_LINE_SIZE
 static char ftrace_notrace_buf[FTRACE_FILTER_SIZE] __initdata;
 static char ftrace_filter_buf[FTRACE_FILTER_SIZE] __initdata;
+static char ftrace_graph_buf[FTRACE_FILTER_SIZE] __initdata;
 
 static int __init set_ftrace_notrace(char *str)
 {
@@ -2263,6 +2268,31 @@ static int __init set_ftrace_filter(char *str)
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
@@ -2279,6 +2309,10 @@ static void __init set_ftrace_early_filters(void)
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
1.6.2.3

