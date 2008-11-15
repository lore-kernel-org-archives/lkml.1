Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbYKOVtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbYKOVtU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 16:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbYKOVsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 16:48:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46017 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbYKOVsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 16:48:00 -0500
Message-Id: <20081115214758.525598677@goodmis.org>
References: <20081115214705.363808961@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 15 Nov 2008 16:47:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/5] ftrace: fix dyn ftrace filter
Content-Disposition: inline; filename=0004-ftrace-fix-dyn-ftrace-filter.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: correct implementation of dyn ftrace filter

The old decisions made by the filter algorithm was complex and incorrect.
This lead to inconsistent enabling or disabling of functions when
the filter was used.

This patch simplifies that code and in doing so, corrects the usage
of the filters.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |   83 +++++++++++++++++++++---------------------------
 1 files changed, 36 insertions(+), 47 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2384a9c..3ef0ee6 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -395,72 +395,62 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 
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
-			enable = 0;
+		/* Record is not filtered and is not enabled do nothing */
+		if (!fl)
+			return 0;
+
+		/* Record is not filtered but enabled, disable it */
+		if (fl == FTRACE_FL_ENABLED)
 			rec->flags &= ~FTRACE_FL_ENABLED;
-		} else {
-			enable = 1;
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
-		}
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
 
-	if (enable)
+	if (rec->flags & FTRACE_FL_ENABLED)
 		return ftrace_make_call(rec, FTRACE_ADDR);
 	else
 		return ftrace_make_nop(NULL, rec, FTRACE_ADDR);
@@ -555,8 +545,7 @@ static void ftrace_startup(void)
 
 	mutex_lock(&ftrace_start_lock);
 	ftrace_start_up++;
-	if (ftrace_start_up == 1)
-		command |= FTRACE_ENABLE_CALLS;
+	command |= FTRACE_ENABLE_CALLS;
 
 	if (saved_ftrace_func != ftrace_trace_function) {
 		saved_ftrace_func = ftrace_trace_function;
-- 
1.5.6.5

-- 
