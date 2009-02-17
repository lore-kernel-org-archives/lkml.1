Return-Path: <linux-kernel-owner+w=401wt.eu-S1754316AbZBQFOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbZBQFOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 00:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbZBQFOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 00:14:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41984 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbZBQFOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 00:14:06 -0500
Message-Id: <20090217051405.178826955@goodmis.org>
References: <20090217051227.957864159@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Feb 2009 00:12:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 01/15] ftrace: state that all functions are enabled in set_ftrace_filter
Content-Disposition: inline; filename=0001-ftrace-state-that-all-functions-are-enabled-in-set_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up, make set_ftrace_filter less confusing

The set_ftrace_filter shows only the functions that will be traced.
But when it is empty, it will trace all functions. This can be a bit
confusing.

This patch makes set_ftrace_filter show:

  #### all functions enabled ####

When all functions will be traced, and we do not filter only a select
few.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1796e01..369fb78 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -773,6 +773,7 @@ enum {
 	FTRACE_ITER_CONT	= (1 << 1),
 	FTRACE_ITER_NOTRACE	= (1 << 2),
 	FTRACE_ITER_FAILURES	= (1 << 3),
+	FTRACE_ITER_PRINTALL	= (1 << 4),
 };
 
 #define FTRACE_BUFF_MAX (KSYM_SYMBOL_LEN+4) /* room for wildcards */
@@ -794,6 +795,9 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 
 	(*pos)++;
 
+	if (iter->flags & FTRACE_ITER_PRINTALL)
+		return NULL;
+
 	/* should not be called from interrupt context */
 	spin_lock(&ftrace_lock);
  retry:
@@ -834,6 +838,19 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 	struct ftrace_iterator *iter = m->private;
 	void *p = NULL;
 
+	/*
+	 * For set_ftrace_filter reading, if we have the filter
+	 * off, we can short cut and just print out that all
+	 * functions are enabled.
+	 */
+	if (iter->flags & FTRACE_ITER_FILTER && !ftrace_filtered) {
+		if (*pos > 0)
+			return NULL;
+		iter->flags |= FTRACE_ITER_PRINTALL;
+		(*pos)++;
+		return iter;
+	}
+
 	if (*pos > 0) {
 		if (iter->idx < 0)
 			return p;
@@ -852,9 +869,15 @@ static void t_stop(struct seq_file *m, void *p)
 
 static int t_show(struct seq_file *m, void *v)
 {
+	struct ftrace_iterator *iter = m->private;
 	struct dyn_ftrace *rec = v;
 	char str[KSYM_SYMBOL_LEN];
 
+	if (iter->flags & FTRACE_ITER_PRINTALL) {
+		seq_printf(m, "#### all functions enabled ####\n");
+		return 0;
+	}
+
 	if (!rec)
 		return 0;
 
-- 
1.5.6.5

-- 
