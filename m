Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbZFSJXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbZFSJXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 05:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbZFSJXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 05:23:25 -0400
Received: from mail.windriver.com ([147.11.1.11]:58293 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbZFSJXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 05:23:24 -0400
From: Liming Wang <liming.wang@windriver.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Liming Wang <liming.wang@windriver.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] ftrace: don't increment @pos in g_start()
Date: Fri, 19 Jun 2009 16:59:28 +0800
Message-Id: <1245401968-25235-1-git-send-email-liming.wang@windriver.com>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <4A3B347B.8090904@cn.fujitsu.com>
References: <4A3B347B.8090904@cn.fujitsu.com>
X-OriginalArrivalTime: 19 Jun 2009 09:23:13.0064 (UTC) FILETIME=[91B35A80:01C9F0BF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

how about this one?

It's wrong to increment @pos in g_start(). It causes some entries
lost when reading set_graph_function, if the output of the file
is large than PAGE_SIZE.

[ Impact: fix missing entries when reading set_graph_function ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Liming Wang <liming.wang@windriver.com>
---
 kernel/trace/ftrace.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 134e580..1beaac6 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2495,29 +2495,25 @@ static void *
 g_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	unsigned long *array = m->private;
-	int index = *pos;
 
-	(*pos)++;
+	if (v)
+		(*pos)++;
 
-	if (index >= ftrace_graph_count)
+	if (*pos >= ftrace_graph_count)
 		return NULL;
 
-	return &array[index];
+	return &array[*pos];
 }
 
 static void *g_start(struct seq_file *m, loff_t *pos)
 {
-	void *p = NULL;
-
 	mutex_lock(&graph_lock);
 
 	/* Nothing, tell g_show to print all functions are enabled */
 	if (!ftrace_graph_count && !*pos)
 		return (void *)1;
 
-	p = g_next(m, p, pos);
-
-	return p;
+	return g_next(m, NULL, pos);
 }
 
 static void g_stop(struct seq_file *m, void *p)
-- 
1.6.0.3

