Return-Path: <linux-kernel-owner+w=401wt.eu-S1755140AbYKTL0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbYKTL0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754081AbYKTL0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:26:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59332 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068AbYKTL0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:26:41 -0500
Date: Thu, 20 Nov 2008 12:26:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [git pull] tracing fixes
Message-ID: <20081120112622.GA13067@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Julia Lawall (1):
      tracing: kernel/trace/trace.c: introduce missing kfree()

Steven Rostedt (3):
      ftrace: fix set_ftrace_filter
      ftrace: make filtered functions effective on setting
      ftrace: fix dyn ftrace filter selection

Vegard Nossum (1):
      trace: introduce missing mutex_unlock()


 kernel/trace/ftrace.c      |  113 +++++++++++++++++++++-----------------------
 kernel/trace/ring_buffer.c |    1 +
 kernel/trace/trace.c       |    1 +
 3 files changed, 56 insertions(+), 59 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e602057..78db083 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -326,96 +326,89 @@ ftrace_record_ip(unsigned long ip)
 
 static int
 __ftrace_replace_code(struct dyn_ftrace *rec,
-		      unsigned char *old, unsigned char *new, int enable)
+		      unsigned char *nop, int enable)
 {
 	unsigned long ip, fl;
+	unsigned char *call, *old, *new;
 
 	ip = rec->ip;
 
-	if (ftrace_filtered && enable) {
+	/*
+	 * If this record is not to be traced and
+	 * it is not enabled then do nothing.
+	 *
+	 * If this record is not to be traced and
+	 * it is enabled then disabled it.
+	 *
+	 */
+	if (rec->flags & FTRACE_FL_NOTRACE) {
+		if (rec->flags & FTRACE_FL_ENABLED)
+			rec->flags &= ~FTRACE_FL_ENABLED;
+		else
+			return 0;
+
+	} else if (ftrace_filtered && enable) {
 		/*
-		 * If filtering is on:
-		 *
-		 * If this record is set to be filtered and
-		 * is enabled then do nothing.
-		 *
-		 * If this record is set to be filtered and
-		 * it is not enabled, enable it.
-		 *
-		 * If this record is not set to be filtered
-		 * and it is not enabled do nothing.
-		 *
-		 * If this record is set not to trace then
-		 * do nothing.
-		 *
-		 * If this record is set not to trace and
-		 * it is enabled then disable it.
-		 *
-		 * If this record is not set to be filtered and
-		 * it is enabled, disable it.
+		 * Filtering is on:
 		 */
 
-		fl = rec->flags & (FTRACE_FL_FILTER | FTRACE_FL_NOTRACE |
-				   FTRACE_FL_ENABLED);
+		fl = rec->flags & (FTRACE_FL_FILTER | FTRACE_FL_ENABLED);
 
-		if ((fl ==  (FTRACE_FL_FILTER | FTRACE_FL_ENABLED)) ||
-		    (fl ==  (FTRACE_FL_FILTER | FTRACE_FL_NOTRACE)) ||
-		    !fl || (fl == FTRACE_FL_NOTRACE))
+		/* Record is filtered and enabled, do nothing */
+		if (fl == (FTRACE_FL_FILTER | FTRACE_FL_ENABLED))
 			return 0;
 
-		/*
-		 * If it is enabled disable it,
-		 * otherwise enable it!
-		 */
-		if (fl & FTRACE_FL_ENABLED) {
-			/* swap new and old */
-			new = old;
-			old = ftrace_call_replace(ip, FTRACE_ADDR);
+		/* Record is not filtered and is not enabled do nothing */
+		if (!fl)
+			return 0;
+
+		/* Record is not filtered but enabled, disable it */
+		if (fl == FTRACE_FL_ENABLED)
 			rec->flags &= ~FTRACE_FL_ENABLED;
-		} else {
-			new = ftrace_call_replace(ip, FTRACE_ADDR);
+		else
+		/* Otherwise record is filtered but not enabled, enable it */
 			rec->flags |= FTRACE_FL_ENABLED;
-		}
 	} else {
+		/* Disable or not filtered */
 
 		if (enable) {
-			/*
-			 * If this record is set not to trace and is
-			 * not enabled, do nothing.
-			 */
-			fl = rec->flags & (FTRACE_FL_NOTRACE | FTRACE_FL_ENABLED);
-			if (fl == FTRACE_FL_NOTRACE)
-				return 0;
-
-			new = ftrace_call_replace(ip, FTRACE_ADDR);
-		} else
-			old = ftrace_call_replace(ip, FTRACE_ADDR);
-
-		if (enable) {
+			/* if record is enabled, do nothing */
 			if (rec->flags & FTRACE_FL_ENABLED)
 				return 0;
+
 			rec->flags |= FTRACE_FL_ENABLED;
+
 		} else {
+
+			/* if record is not enabled do nothing */
 			if (!(rec->flags & FTRACE_FL_ENABLED))
 				return 0;
+
 			rec->flags &= ~FTRACE_FL_ENABLED;
 		}
 	}
 
+	call = ftrace_call_replace(ip, FTRACE_ADDR);
+
+	if (rec->flags & FTRACE_FL_ENABLED) {
+		old = nop;
+		new = call;
+	} else {
+		old = call;
+		new = nop;
+	}
+
 	return ftrace_modify_code(ip, old, new);
 }
 
 static void ftrace_replace_code(int enable)
 {
 	int i, failed;
-	unsigned char *new = NULL, *old = NULL;
+	unsigned char *nop = NULL;
 	struct dyn_ftrace *rec;
 	struct ftrace_page *pg;
 
-	if (enable)
-		old = ftrace_nop_replace();
-	else
-		new = ftrace_nop_replace();
+	nop = ftrace_nop_replace();
 
 	for (pg = ftrace_pages_start; pg; pg = pg->next) {
 		for (i = 0; i < pg->index; i++) {
@@ -433,7 +426,7 @@ static void ftrace_replace_code(int enable)
 				unfreeze_record(rec);
 			}
 
-			failed = __ftrace_replace_code(rec, old, new, enable);
+			failed = __ftrace_replace_code(rec, nop, enable);
 			if (failed && (rec->flags & FTRACE_FL_CONVERTED)) {
 				rec->flags |= FTRACE_FL_FAILED;
 				if ((system_state == SYSTEM_BOOTING) ||
@@ -534,8 +527,7 @@ static void ftrace_startup(void)
 
 	mutex_lock(&ftrace_start_lock);
 	ftrace_start++;
-	if (ftrace_start == 1)
-		command |= FTRACE_ENABLE_CALLS;
+	command |= FTRACE_ENABLE_CALLS;
 
 	if (saved_ftrace_func != ftrace_trace_function) {
 		saved_ftrace_func = ftrace_trace_function;
@@ -734,6 +726,9 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 		    ((iter->flags & FTRACE_ITER_FAILURES) &&
 		     !(rec->flags & FTRACE_FL_FAILED)) ||
 
+		    ((iter->flags & FTRACE_ITER_FILTER) &&
+		     !(rec->flags & FTRACE_FL_FILTER)) ||
+
 		    ((iter->flags & FTRACE_ITER_NOTRACE) &&
 		     !(rec->flags & FTRACE_FL_NOTRACE))) {
 			rec = NULL;
@@ -1186,7 +1181,7 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 
 	mutex_lock(&ftrace_sysctl_lock);
 	mutex_lock(&ftrace_start_lock);
-	if (iter->filtered && ftrace_start && ftrace_enabled)
+	if (ftrace_start && ftrace_enabled)
 		ftrace_run_update_code(FTRACE_ENABLE_CALLS);
 	mutex_unlock(&ftrace_start_lock);
 	mutex_unlock(&ftrace_sysctl_lock);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 036456c..f780e95 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -617,6 +617,7 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 		list_del_init(&page->list);
 		free_buffer_page(page);
 	}
+	mutex_unlock(&buffer->mutex);
 	return -ENOMEM;
 }
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 697eda3..d86e325 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1936,6 +1936,7 @@ __tracing_open(struct inode *inode, struct file *file, int *ret)
 			ring_buffer_read_finish(iter->buffer_iter[cpu]);
 	}
 	mutex_unlock(&trace_types_lock);
+	kfree(iter);
 
 	return ERR_PTR(-ENOMEM);
 }
