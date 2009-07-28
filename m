Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbZG1Vz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbZG1Vz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573AbZG1Vzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:55:52 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:44231 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728AbZG1Vzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:55:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=udssWs0g5DxLWiiidX4rf/IJyz/LlGVrwHfsbOFhlMAcbB/HSpWQYEWsUDDlhW72oS
         0rpEcVBCcaLYlJx1EnhjeUkoot2HOWjEwi2NCoclLxXKGJ0w7mDud+AUPopd9OaXcYKX
         PFG+SaZV/OEw+Pr7J2dIi9jz80vIfdtCb6V7k=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, stable@kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] tracing: Fix missing function_graph events when we splice_read from trace_pipe
Date: Tue, 28 Jul 2009 23:55:34 +0200
Message-Id: <1248818134-5231-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1248818134-5231-1-git-send-email-fweisbec@gmail.com>
References: <1248818134-5231-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

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
-- 
1.6.2.3

