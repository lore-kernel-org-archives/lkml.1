Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbZG2ROf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbZG2ROf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 13:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755966AbZG2ROe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 13:14:34 -0400
Received: from mail-ew0-f209.google.com ([209.85.219.209]:54531 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798AbZG2RNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 13:13:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Y4A+dSWqAxjc9gkuiZ4CcUa3fS7imjXnOf5agkQTj6LB7WxUEPphjUnYHGOjgT2VDg
         dsAIjRYWXwjisFG4xTfHHzDtDKFr15hU870LWhaAOoaZGoW36dsaRG0Y2/y88sELv+AH
         SbrQ1xE3t9627Q7qICViMu7KMThLftjqMkZic=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/6] tracing: Simplify print_graph_cpu()
Date: Wed, 29 Jul 2009 19:13:24 +0200
Message-Id: <1248887609-5147-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1248887609-5147-1-git-send-email-fweisbec@gmail.com>
References: <1248887609-5147-1-git-send-email-fweisbec@gmail.com>
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

