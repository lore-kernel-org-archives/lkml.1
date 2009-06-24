Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbZFXJr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbZFXJr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758654AbZFXJrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:47:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:59742 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758668AbZFXJrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:47:03 -0400
Date: Wed, 24 Jun 2009 09:46:28 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, liming.wang@windriver.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, liming.wang@windriver.com, mingo@elte.hu
In-Reply-To: <4A418738.7090401@cn.fujitsu.com>
References: <4A418738.7090401@cn.fujitsu.com>
Subject: [tip:tracing/urgent] ftrace: Don't increment @pos in g_start()
Message-ID: <tip-85951842a1020669f0a9eb0f0d1853b41341f097@git.kernel.org>
Git-Commit-ID: 85951842a1020669f0a9eb0f0d1853b41341f097
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 24 Jun 2009 09:46:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  85951842a1020669f0a9eb0f0d1853b41341f097
Gitweb:     http://git.kernel.org/tip/85951842a1020669f0a9eb0f0d1853b41341f097
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 24 Jun 2009 09:54:00 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 24 Jun 2009 11:02:52 +0200

ftrace: Don't increment @pos in g_start()

It's wrong to increment @pos in g_start(). It causes some entries
lost when reading set_graph_function, if the output of the file
is larger than PAGE_SIZE.

Reviewed-by: Liming Wang <liming.wang@windriver.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4A418738.7090401@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/ftrace.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 3718d55..cde74b9 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2500,32 +2500,31 @@ int ftrace_graph_count;
 unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS] __read_mostly;
 
 static void *
-g_next(struct seq_file *m, void *v, loff_t *pos)
+__g_next(struct seq_file *m, loff_t *pos)
 {
 	unsigned long *array = m->private;
-	int index = *pos;
-
-	(*pos)++;
 
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
 
 	/* Nothing, tell g_show to print all functions are enabled */
 	if (!ftrace_graph_count && !*pos)
 		return (void *)1;
 
-	p = g_next(m, p, pos);
-
-	return p;
+	return __g_next(m, pos);
 }
 
 static void g_stop(struct seq_file *m, void *p)
