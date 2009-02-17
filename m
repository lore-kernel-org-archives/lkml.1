Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbZBQFSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbZBQFSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 00:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbZBQFOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 00:14:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42043 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbZBQFOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 00:14:09 -0500
Message-Id: <20090217051407.859963646@goodmis.org>
References: <20090217051227.957864159@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Feb 2009 00:12:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 14/15] ftrace: add pretty print to selected fuction traces
Content-Disposition: inline; filename=0014-ftrace-add-pretty-print-to-selected-fuction-traces.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds a call back for the tracers that have hooks to
selected functions. This allows the tracer to show better output
in the set_ftrace_filter file.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h |    6 ++++++
 kernel/trace/ftrace.c  |    3 +++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 13918c4..b331e21 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -106,12 +106,18 @@ struct ftrace_func_command {
 /* asm/ftrace.h must be defined for archs supporting dynamic ftrace */
 #include <asm/ftrace.h>
 
+struct seq_file;
+
 struct ftrace_hook_ops {
 	void			(*func)(unsigned long ip,
 					unsigned long parent_ip,
 					void **data);
 	int			(*callback)(unsigned long ip, void **data);
 	void			(*free)(void **data);
+	int			(*print)(struct seq_file *m,
+					 unsigned long ip,
+					 struct ftrace_hook_ops *ops,
+					 void *data);
 };
 
 extern int
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1e05884..6533c1d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -834,6 +834,9 @@ static int t_hash_show(struct seq_file *m, void *v)
 
 	rec = hlist_entry(hnd, struct ftrace_func_hook, node);
 
+	if (rec->ops->print)
+		return rec->ops->print(m, rec->ip, rec->ops, rec->data);
+
 	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
 	seq_printf(m, "%s:", str);
 
-- 
1.5.6.5

-- 
