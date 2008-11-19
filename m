Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbYKSFhC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbYKSFhC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 00:37:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbYKSFgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 00:36:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61145 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbYKSFgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 00:36:04 -0500
Message-Id: <20081119053603.270174822@goodmis.org>
References: <20081119053449.282336740@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 19 Nov 2008 00:34:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/3] ftrace: fix dyn ftrace filter selection
Content-Disposition: inline; filename=0003-ftrace-fix-dyn-ftrace-filter-selection.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: clean up and fix for dyn ftrace filter selection

The previous logic of the dynamic ftrace selection of enabling
or disabling functions was complex and incorrect. This patch simplifies
the code and corrects the usage. This simplification also makes the
code more robust.

Here is the correct logic:

  Given a function that can be traced by dynamic ftrace:

  If the function is not to be traced, disable it if it was enabled.
  (this is if the function is in the set_ftrace_notrace file)

  (filter is on if there exists any functions in set_ftrace_filter file)

  If the filter is on, and we are enabling functions:
    If the function is in set_ftrace_filter, enable it if it is not
      already enabled.
    If the function is not in set_ftrace_filter, disable it if it is not
      already disabled.

  Otherwise, if the filter is off and we are enabling function tracing:
    Enable the function if it is not already enabled.

  Otherwise, if we are disabling function tracing:
    Disable the function if it is not already disabled.

This code now sets or clears the ENABLED flag in the record, and at the
end it will enable the function if the flag is set, or disable the function
if the flag is cleared.

The parameters for the function that does the above logic is also
simplified. Instead of passing in confusing "new" and "old" where
they might be swapped if the "enabled" flag is not set. The old logic
even had one of the above always NULL and had to be filled in. The new
logic simply passes in one parameter called "nop". A "call" is calculated
in the code, and at the end of the logic, when we know we need to either
disable or enable the function, we can then use the "nop" and "call"
properly.

This code is more robust than the previous version.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/ftrace.c |  108 ++++++++++++++++++++++--------------------------
 1 files changed, 50 insertions(+), 58 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5cbddb5..fdaab04 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -327,96 +327,89 @@ ftrace_record_ip(unsigned long ip)
 
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
@@ -434,7 +427,7 @@ static void ftrace_replace_code(int enable)
 				unfreeze_record(rec);
 			}
 
-			failed = __ftrace_replace_code(rec, old, new, enable);
+			failed = __ftrace_replace_code(rec, nop, enable);
 			if (failed && (rec->flags & FTRACE_FL_CONVERTED)) {
 				rec->flags |= FTRACE_FL_FAILED;
 				if ((system_state == SYSTEM_BOOTING) ||
@@ -538,8 +531,7 @@ static void ftrace_startup(void)
 
 	mutex_lock(&ftrace_start_lock);
 	ftrace_start++;
-	if (ftrace_start == 1)
-		command |= FTRACE_ENABLE_CALLS;
+	command |= FTRACE_ENABLE_CALLS;
 
 	if (saved_ftrace_func != ftrace_trace_function) {
 		saved_ftrace_func = ftrace_trace_function;
-- 
1.5.6.5

-- 
