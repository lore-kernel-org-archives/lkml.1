Return-Path: <linux-kernel-owner+w=401wt.eu-S1759309AbZFSGpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309AbZFSGpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 02:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758357AbZFSGpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 02:45:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60727 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758186AbZFSGpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 02:45:39 -0400
Message-ID: <4A3B347B.8090904@cn.fujitsu.com>
Date: Fri, 19 Jun 2009 14:47:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] ftrace: don't increment @pos in g_start()
References: <4A3B3372.4040608@cn.fujitsu.com>
In-Reply-To: <4A3B3372.4040608@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's wrong to increment @pos in g_start(). It causes some entries
lost when reading set_graph_function, if the output of the file
is large than PAGE_SIZE.

[ Impact: fix missing entries when reading set_graph_function ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/ftrace.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index ec18bb4..2c1c761 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2492,32 +2492,30 @@ int ftrace_graph_count;
 unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS] __read_mostly;
 
 static void *
-g_next(struct seq_file *m, void *v, loff_t *pos)
+__g_next(struct seq_file *m, loff_t *pos)
 {
 	unsigned long *array = m->private;
-	int index = *pos;
 
-	(*pos)++;
+	/* Nothing, tell g_show to print all functions are enabled */
+	if (!ftrace_graph_count && !*pos)
+		return (void *)1;
 
-	if (index >= ftrace_graph_count)
+	if (*pos >= ftrace_graph_count)
 		return NULL;
+	return &array[*pos];
+}
 
-	return &array[index];
+static void *
+g_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	(*pos)++;
+	return __g_next(m, pos);
 }
 
 static void *g_start(struct seq_file *m, loff_t *pos)
 {
-	void *p = NULL;
-
 	mutex_lock(&graph_lock);
-
-	/* Nothing, tell g_show to print all functions are enabled */
-	if (!ftrace_graph_count && !*pos)
-		return (void *)1;
-
-	p = g_next(m, p, pos);
-
-	return p;
+	return __g_next(m, pos);
 }
 
 static void g_stop(struct seq_file *m, void *p)
-- 
1.5.4.rc3



