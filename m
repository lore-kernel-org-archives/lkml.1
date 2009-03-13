Return-Path: <linux-kernel-owner+w=401wt.eu-S1757793AbZCMCnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793AbZCMCnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758560AbZCMCik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:38:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56604 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758543AbZCMCia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:38:30 -0400
Message-Id: <20090313023827.173173817@goodmis.org>
References: <20090313023704.971438367@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 12 Mar 2009 22:37:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 11/16] tracing: explain why stack tracer is empty
Content-Disposition: inline; filename=0011-tracing-explain-why-stack-tracer-is-empty.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If the stack tracing is disabled (by default) the stack_trace file
will only contain the header:

 # cat /debug/tracing/stack_trace
        Depth    Size      Location    (0 entries)
        -----    ----      --------

This can be frustrating to a developer that does not realize that the
stack tracer is disabled. This patch adds the following text:

  # cat /debug/tracing/stack_trace
        Depth    Size      Location    (0 entries)
        -----    ----      --------
 #
 #  Stack tracer disabled
 #
 # To enable the stack tracer, either add 'stacktrace' to the
 # kernel command line
 # or 'echo 1 > /proc/sys/kernel/stack_tracer_enabled'
 #

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_stack.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 4564fd9..91ccbf3 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -245,6 +245,17 @@ static int trace_lookup_stack(struct seq_file *m, long i)
 #endif
 }
 
+static void print_disabled(struct seq_file *m)
+{
+	seq_puts(m, "#\n"
+		 "#  Stack tracer disabled\n"
+		 "#\n"
+		 "# To enable the stack tracer, either add 'stacktrace' to the\n"
+		 "# kernel command line\n"
+		 "# or 'echo 1 > /proc/sys/kernel/stack_tracer_enabled'\n"
+		 "#\n");
+}
+
 static int t_show(struct seq_file *m, void *v)
 {
 	long i;
@@ -255,6 +266,10 @@ static int t_show(struct seq_file *m, void *v)
 			   "    (%d entries)\n"
 			   "        -----    ----      --------\n",
 			   max_stack_trace.nr_entries);
+
+		if (!stack_tracer_enabled && !max_stack_size)
+			print_disabled(m);
+
 		return 0;
 	}
 
-- 
1.6.1.3

-- 
