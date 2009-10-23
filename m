Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbZJWXhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbZJWXhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 19:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbZJWXgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 19:36:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60660 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbZJWXgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 19:36:42 -0400
Message-Id: <20091023233646.631787612@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 23 Oct 2009 19:36:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/4] [PATCH 2/4] tracing: fix trace_seq_printf return value
References: <20091023233615.661789185@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-fix-trace_seq_printf-return-value.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

trace_seq_printf return value is a little ambiguous. It currently
returns the length of the space available in the buffer. printf
usually returns the amount written. This is not adequate here, because

  trace_seq_printf(s, "");

is perfectly legal, and returning 0 would indicate that it failed.

We can always see the amount written by looking at the before and after
values of s->len. This is not quite the same use as printf. We only care
if the string was successfully written to the buffer or not.

Making trace_seq_printf return 0 if the trace oversizes the buffer's free
space, 1 otherwise.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
LKML-Reference: <20091022120958.GB2311@jolsa.redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_output.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index ed17565..b6c12c6 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -69,6 +69,9 @@ enum print_line_t trace_print_printk_msg_only(struct trace_iterator *iter)
  * @s: trace sequence descriptor
  * @fmt: printf format string
  *
+ * It returns 0 if the trace oversizes the buffer's free
+ * space, 1 otherwise.
+ *
  * The tracer may use either sequence operations or its own
  * copy to user routines. To simplify formating of a trace
  * trace_seq_printf is used to store strings into a special
@@ -95,7 +98,7 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 
 	s->len += ret;
 
-	return len;
+	return 1;
 }
 EXPORT_SYMBOL_GPL(trace_seq_printf);
 
-- 
1.6.3.3


