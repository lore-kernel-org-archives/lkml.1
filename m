Return-Path: <linux-kernel-owner+w=401wt.eu-S932180AbZHMT7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbZHMT7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932140AbZHMT7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:39 -0400
Received: from kroah.org ([198.145.64.141]:41741 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110AbZHMT7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:36 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:29 2009
Message-Id: <20090813195129.165986932@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [patch 31/74] tracing: Fix missing function_graph events when we splice_read from trace_pipe
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=tracing-fix-missing-function_graph-events-when-we-splice_read-from-trace_pipe.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lai Jiangshan <laijs@cn.fujitsu.com>

commit 74e7ff8c50b6b022e6ffaa736b16a4dc161d3eaf upstream.

About a half events are missing when we splice_read
from trace_pipe. They are unexpectedly consumed because we ignore
the TRACE_TYPE_NO_CONSUME return value used by the function graph
tracer when it needs to consume the events by itself to walk on
the ring buffer.

The same problem appears with ftrace_dump()

Example of an output before this patch:

1)               |      ktime_get_real() {
1)   2.846 us    |          read_hpet();
1)   4.558 us    |        }
1)   6.195 us    |      }

After this patch:

0)               |      ktime_get_real() {
0)               |        getnstimeofday() {
0)   1.960 us    |          read_hpet();
0)   3.597 us    |        }
0)   5.196 us    |      }

The fix also applies on 2.6.30

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4A6EEC52.90704@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/trace.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2993,7 +2993,8 @@ tracing_fill_pipe_page(size_t rem, struc
 			break;
 		}
 
-		trace_consume(iter);
+		if (ret != TRACE_TYPE_NO_CONSUME)
+			trace_consume(iter);
 		rem -= count;
 		if (!find_next_entry_inc(iter))	{
 			rem = 0;
@@ -4122,8 +4123,11 @@ static void __ftrace_dump(bool disable_t
 		iter.pos = -1;
 
 		if (find_next_entry_inc(&iter) != NULL) {
-			print_trace_line(&iter);
-			trace_consume(&iter);
+			int ret;
+
+			ret = print_trace_line(&iter);
+			if (ret != TRACE_TYPE_NO_CONSUME)
+				trace_consume(&iter);
 		}
 
 		trace_printk_seq(&iter.seq);


