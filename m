Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbZHDMNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbZHDMNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 08:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbZHDMNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 08:13:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:46081 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755267AbZHDMNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 08:13:17 -0400
Date: Tue, 4 Aug 2009 12:12:50 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com
In-Reply-To: <4A6EEC52.90704@cn.fujitsu.com>
References: <4A6EEC52.90704@cn.fujitsu.com>
Subject: [tip:tracing/urgent] tracing: Fix missing function_graph events when we splice_read from trace_pipe
Message-ID: <tip-74e7ff8c50b6b022e6ffaa736b16a4dc161d3eaf@git.kernel.org>
Git-Commit-ID: 74e7ff8c50b6b022e6ffaa736b16a4dc161d3eaf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 12:12:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74e7ff8c50b6b022e6ffaa736b16a4dc161d3eaf
Gitweb:     http://git.kernel.org/tip/74e7ff8c50b6b022e6ffaa736b16a4dc161d3eaf
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 28 Jul 2009 20:17:22 +0800
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Tue, 28 Jul 2009 23:17:23 +0200

tracing: Fix missing function_graph events when we splice_read from trace_pipe

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
Cc: stable@kernel.org
LKML-Reference: <4A6EEC52.90704@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>


---
 kernel/trace/trace.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8bc8d8a..da984ad 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3085,7 +3085,8 @@ tracing_fill_pipe_page(size_t rem, struct trace_iterator *iter)
 			break;
 		}
 
-		trace_consume(iter);
+		if (ret != TRACE_TYPE_NO_CONSUME)
+			trace_consume(iter);
 		rem -= count;
 		if (!find_next_entry_inc(iter))	{
 			rem = 0;
@@ -4233,8 +4234,11 @@ static void __ftrace_dump(bool disable_tracing)
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
