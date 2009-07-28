Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbZG1MQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbZG1MQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 08:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbZG1MQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 08:16:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55424 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbZG1MQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 08:16:48 -0400
Message-ID: <4A6EEC52.90704@cn.fujitsu.com>
Date: Tue, 28 Jul 2009 20:17:22 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: fix missing function_graph events when we splice_read
 from trace_pipe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


About a half events are missing when we splice_read
from trace_pipe. They are consumed unexpected.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e30e6b1..41996fc 100644
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
@@ -4230,8 +4231,11 @@ static void __ftrace_dump(bool disable_tracing)
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


