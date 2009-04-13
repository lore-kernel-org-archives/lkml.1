Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211AbZDMIDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbZDMIDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 04:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbZDMICz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 04:02:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59742 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbZDMICy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 04:02:54 -0400
Message-ID: <49E2F19A.3040006@cn.fujitsu.com>
Date: Mon, 13 Apr 2009 16:02:34 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] tracing: Make branch trace display correct header
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before patch:
  # tracer: branch
  #
  #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
  #              | |       |          |         |
             <...>-2981  [000] 24008.872738: [  ok  ] trace_irq_handler_exit:irq_event_types.h:41
             <...>-2981  [000] 24008.872742: [  ok  ] note_interrupt:spurious.c:229
  ...

After patch:
# tracer: branch
#
#           TASK-PID    CPU#    TIMESTAMP  CORRECT  FUNC:FILE:LINE
#              | |       |          |         |       |
           <...>-2985  [000] 26329.142970: [  ok  ] slab_free:slub.c:1776
           <...>-2985  [000] 26329.142972: [  ok  ] trace_kmem_cache_free:kmem_event_types.h:191
  ...

But it is not the best fix way.
When format(length) of TASK-PID, CPU and TIMESTAMP chanegd in trace.c,
other files who uses there fields need to changed for print right header line.

Maybe we can make a function to print header line of these 3 field:
print_common_head()
{
	seq_puts(s, "#           TASK-PID    CPU#    TIMESTAMP");
}

and call this function in other files' print_header:
static void branch_print_header(struct seq_file *s)
{
	print_common_head();
	seq_puts(s, "  CORRECT  FUNC:FILE:LINE\n");
}

But if header line is multi-line, this way can't work.

Another way is to export specific header-line content in other files:
static void branch_print_header(char *buf, int len)
{
	strcpy(buf, "  CORRECT  FUNC:FILE:LINE\n"
		    "     |            |\n"
		    );
}
And combile common-header and specific header in trace.c, then do seq_puts.
But this seems too complex for tracing framework.

Similar problem exists in other tracers as sched_switch.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 kernel/trace/trace_branch.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 8e64e60..7a7a9fd 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -157,6 +157,13 @@ static enum print_line_t trace_branch_print(struct trace_iterator *iter,
 	return TRACE_TYPE_HANDLED;
 }
 
+static void branch_print_header(struct seq_file *s)
+{
+	seq_puts(s, "#           TASK-PID    CPU#    TIMESTAMP  CORRECT"
+		"  FUNC:FILE:LINE\n");
+	seq_puts(s, "#              | |       |          |         |   "
+		"    |\n");
+}
 
 static struct trace_event trace_branch_event = {
 	.type		= TRACE_BRANCH,
@@ -171,6 +178,7 @@ static struct tracer branch_trace __read_mostly =
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest	= trace_selftest_startup_branch,
 #endif /* CONFIG_FTRACE_SELFTEST */
+	.print_header	= branch_print_header,
 };
 
 __init static int init_branch_tracer(void)
-- 1.5.5.3 

