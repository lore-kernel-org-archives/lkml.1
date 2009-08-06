Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbZHFG1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbZHFG1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 02:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbZHFG1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 02:27:49 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:53224 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276AbZHFG1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 02:27:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hRlCISVHjEd610ujmi+kf7PyczoRLMKy2nwAlTAuJp2YZB7Q2qRY1bdfEKFmt57mSX
         xU2Kc/XpdY9SzVbKUZDBZWX5Qvkx01UNRlnQvc5X8bfTfq97dKjq9F59PThgwmIbis1A
         /7TQZkK9OVxZ6pKA9duPUu0ijx6IZ9EWlFvK0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/7] tracing: Simplify print_graph_cpu()
Date: Thu,  6 Aug 2009 08:27:32 +0200
Message-Id: <1249540058-5528-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090802195312.GA18598@elte.hu>
References: <20090802195312.GA18598@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

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
 
-- 
1.6.2.3

