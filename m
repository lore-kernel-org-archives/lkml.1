Return-Path: <linux-kernel-owner+w=401wt.eu-S1763771AbZE1Sep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763771AbZE1Sep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 14:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbZE1Seh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 14:34:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52465 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757345AbZE1Seg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 14:34:36 -0400
Date: Thu, 28 May 2009 14:34:36 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][GIT PULL] ftrace: add kernel command line function
 filtering
Message-ID: <alpine.DEB.2.00.0905281420590.11238@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (1):
      ftrace: add kernel command line function filtering

----
 Documentation/kernel-parameters.txt |   17 ++++++++++++-
 kernel/trace/ftrace.c               |   42 +++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+), 2 deletions(-)
---------------------------
commit 3481535dc7351d3a45f67d8016bd78fc5c537628
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Thu May 28 13:37:24 2009 -0400

    ftrace: add kernel command line function filtering
    
    When using ftrace=function on the command line to trace functions
    on boot up, one can not filter out functions that are commonly called.
    
    This patch adds two new ftrace command line commands.
    
      ftrace_notrace=function-list
      ftrace_filter=function-list
    
    Where function-list is a comma separated list of functions to filter.
    The ftrace_notrace will make the functions listed not be included
    in the function tracing, and ftrace_filter will only trace the functions
    listed.
    
    These two act the same as the debugfs/tracing/set_ftrace_notrace and
    debugfs/tracing/set_ftrace_filter respectively.
    
    The simple glob expressions that are allowed by the filter files can also
    be used by the command line interface.
    
    	ftrace_notrace=rcu*,*lock,*spin*
    
    Will not trace any function that starts with rcu, ends with lock, or has
    the word spin in it.
    
    Note, if the self tests are enabled, they may interfere with the filtering
    set by the command lines.
    
    [ Imact: allow filtering of function tracing at boot up ]
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9243dd8..fcd3bfb 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -751,12 +751,25 @@ and is between 256 and 4096 characters. It is defined in the file
 			ia64_pal_cache_flush instead of SAL_CACHE_FLUSH.
 
 	ftrace=[tracer]
-			[ftrace] will set and start the specified tracer
+			[FTRACE] will set and start the specified tracer
 			as early as possible in order to facilitate early
 			boot debugging.
 
 	ftrace_dump_on_oops
-			[ftrace] will dump the trace buffers on oops.
+			[FTRACE] will dump the trace buffers on oops.
+
+	ftrace_filter=[function-list]
+			[FTRACE] Limit the functions traced by the function
+			tracer at boot up. function-list is a comma separated
+			list of functions. This list can be changed at run
+			time by the set_ftrace_filter file in the debugfs
+			tracing directory. 
+
+	ftrace_notrace=[function-list]
+			[FTRACE] Do not trace the functions specified in
+			function-list. This list can be changed at run time
+			by the set_ftrace_notrace file in the debugfs
+			tracing directory.
 
 	gamecon.map[2|3]=
 			[HW,JOY] Multisystem joystick and NES/SNES/PSX pad
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 140699a..2074e5b 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -32,6 +32,7 @@
 #include <trace/events/sched.h>
 
 #include <asm/ftrace.h>
+#include <asm/setup.h>
 
 #include "trace_output.h"
 #include "trace_stat.h"
@@ -2369,6 +2370,45 @@ void ftrace_set_notrace(unsigned char *buf, int len, int reset)
 	ftrace_set_regex(buf, len, reset, 0);
 }
 
+/*
+ * command line interface to allow users to set filters on boot up.
+ */
+#define FTRACE_FILTER_SIZE		COMMAND_LINE_SIZE
+static char ftrace_notrace_buf[FTRACE_FILTER_SIZE] __initdata;
+static char ftrace_filter_buf[FTRACE_FILTER_SIZE] __initdata;
+
+static int __init set_ftrace_notrace(char *str)
+{
+	strncpy(ftrace_notrace_buf, str, FTRACE_FILTER_SIZE);
+	return 1;
+}
+__setup("ftrace_notrace=", set_ftrace_notrace);
+
+static int __init set_ftrace_filter(char *str)
+{
+	strncpy(ftrace_filter_buf, str, FTRACE_FILTER_SIZE);
+	return 1;
+}
+__setup("ftrace_filter=", set_ftrace_filter);
+
+static void __init set_ftrace_early_filter(char *buf, int enable)
+{
+	char *func;
+
+	while (buf) {
+		func = strsep(&buf, ",");
+		ftrace_set_regex(func, strlen(func), 0, enable);
+	}
+}
+
+static void __init set_ftrace_early_filters(void)
+{
+	if (ftrace_filter_buf[0])
+		set_ftrace_early_filter(ftrace_filter_buf, 1);
+	if (ftrace_notrace_buf[0])
+		set_ftrace_early_filter(ftrace_notrace_buf, 0);
+}
+
 static int
 ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 {
@@ -2829,6 +2869,8 @@ void __init ftrace_init(void)
 	if (ret)
 		pr_warning("Failed to register trace ftrace module notifier\n");
 
+	set_ftrace_early_filters();
+
 	return;
  failed:
 	ftrace_disabled = 1;

