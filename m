Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbZHFMnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbZHFMnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 08:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbZHFMnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 08:43:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:41314 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbZHFMnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 08:43:05 -0400
Date: Thu, 6 Aug 2009 12:42:34 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com
In-Reply-To: <4A6EEE5E.2000001@cn.fujitsu.com>
References: <4A6EEE5E.2000001@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing: Simplify print_graph_cpu()
Message-ID: <tip-0c9e6f639aed490202bbc79214f4495cf4bfde58@git.kernel.org>
Git-Commit-ID: 0c9e6f639aed490202bbc79214f4495cf4bfde58
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 06 Aug 2009 12:42:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0c9e6f639aed490202bbc79214f4495cf4bfde58
Gitweb:     http://git.kernel.org/tip/0c9e6f639aed490202bbc79214f4495cf4bfde58
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 28 Jul 2009 20:26:06 +0800
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Thu, 6 Aug 2009 07:28:04 +0200

tracing: Simplify print_graph_cpu()

print_graph_cpu() is little over-designed.

And "log10_all" may be wrong when there are holes in cpu_online_mask:
the max online cpu id > cpumask_weight(cpu_online_mask)

So change it by using a static column length for the cpu matching
nr_cpu_ids number of decimal characters.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4A6EEE5E.2000001@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>


---
 kernel/trace/trace_functions_graph.c |   30 ++++--------------------------
 1 files changed, 4 insertions(+), 26 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index abf7c4a..e30472d 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -183,43 +183,19 @@ static void graph_trace_reset(struct trace_array *tr)
 	unregister_ftrace_graph();
 }
 
-static inline int log10_cpu(int nb)
-{
-	if (nb / 100)
-		return 3;
-	if (nb / 10)
-		return 2;
-	return 1;
-}
+static int max_bytes_for_cpu;
 
 static enum print_line_t
 print_graph_cpu(struct trace_seq *s, int cpu)
 {
-	int i;
 	int ret;
-	int log10_this = log10_cpu(cpu);
-	int log10_all = log10_cpu(cpumask_weight(cpu_online_mask));
-
 
 	/*
 	 * Start with a space character - to make it stand out
 	 * to the right a bit when trace output is pasted into
 	 * email:
 	 */
-	ret = trace_seq_printf(s, " ");
-
-	/*
-	 * Tricky - we space the CPU field according to the max
-	 * number of online CPUs. On a 2-cpu system it would take
-	 * a maximum of 1 digit - on a 128 cpu system it would
-	 * take up to 3 digits:
-	 */
-	for (i = 0; i < log10_all - log10_this; i++) {
-		ret = trace_seq_printf(s, " ");
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
-	ret = trace_seq_printf(s, "%d) ", cpu);
+	ret = trace_seq_printf(s, " %*d) ", max_bytes_for_cpu, cpu);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
@@ -919,6 +895,8 @@ static struct tracer graph_trace __read_mostly = {
 
 static __init int init_graph_trace(void)
 {
+	max_bytes_for_cpu = snprintf(NULL, 0, "%d", nr_cpu_ids - 1);
+
 	return register_tracer(&graph_trace);
 }
 
