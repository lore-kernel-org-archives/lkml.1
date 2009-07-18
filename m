Return-Path: <linux-kernel-owner+w=401wt.eu-S932582AbZGRHRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582AbZGRHRj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 03:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932510AbZGRHRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 03:17:32 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:49617 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932496AbZGRHRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 03:17:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wPDnPLp4WfJxAt6WyLUkS/1FIprtVEUsn4zhzr0ErK0UTCaYU972wbv2aRugresh7W
         iPy/9PuGJhg906OC5rnEHU0aoG/H24Sak2Z1Hc9irWXmEOyka+bNEplrBYp7WoPSBxrU
         y5xCArqdXYkNuCrr7u8HEkPq3Q/+KFp2A7tzc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/4] tracing/function: Simplify __ftrace_replace_code()
Date: Sat, 18 Jul 2009 03:16:59 -0400
Message-Id: <1247901421-6389-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1247901421-6389-1-git-send-email-fweisbec@gmail.com>
References: <1247901421-6389-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Rewrite the __ftrace_replace_code() function, simplify it, but don't
change the code's logic.

First, we get the state we want to set, if the record has the same
state, then do nothing, otherwise enable/disable it.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/ftrace.c |   72 ++++++++++++------------------------------------
 1 files changed, 18 insertions(+), 54 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index bce9e01..217caec 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1017,71 +1017,35 @@ static int
 __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 {
 	unsigned long ftrace_addr;
-	unsigned long ip, fl;
+	unsigned long flag = 0UL;
 
 	ftrace_addr = (unsigned long)FTRACE_ADDR;
 
-	ip = rec->ip;
-
 	/*
-	 * If this record is not to be traced and
-	 * it is not enabled then do nothing.
+	 * If this record is not to be traced or we want to disable it,
+	 * then disable it.
 	 *
-	 * If this record is not to be traced and
-	 * it is enabled then disable it.
+	 * If we want to enable it and filtering is off, then enable it.
 	 *
+	 * If we want to enable it and filtering is on, enable it only if
+	 * it's filtered
 	 */
-	if (rec->flags & FTRACE_FL_NOTRACE) {
-		if (rec->flags & FTRACE_FL_ENABLED)
-			rec->flags &= ~FTRACE_FL_ENABLED;
-		else
-			return 0;
-
-	} else if (ftrace_filtered && enable) {
-		/*
-		 * Filtering is on:
-		 */
-
-		fl = rec->flags & (FTRACE_FL_FILTER | FTRACE_FL_ENABLED);
-
-		/* Record is filtered and enabled, do nothing */
-		if (fl == (FTRACE_FL_FILTER | FTRACE_FL_ENABLED))
-			return 0;
-
-		/* Record is not filtered or enabled, do nothing */
-		if (!fl)
-			return 0;
-
-		/* Record is not filtered but enabled, disable it */
-		if (fl == FTRACE_FL_ENABLED)
-			rec->flags &= ~FTRACE_FL_ENABLED;
-		else
-		/* Otherwise record is filtered but not enabled, enable it */
-			rec->flags |= FTRACE_FL_ENABLED;
-	} else {
-		/* Disable or not filtered */
-
-		if (enable) {
-			/* if record is enabled, do nothing */
-			if (rec->flags & FTRACE_FL_ENABLED)
-				return 0;
-
-			rec->flags |= FTRACE_FL_ENABLED;
-
-		} else {
+	if (enable && !(rec->flags & FTRACE_FL_NOTRACE)) {
+		if (!ftrace_filtered || (rec->flags & FTRACE_FL_FILTER))
+			flag = FTRACE_FL_ENABLED;
+	}
 
-			/* if record is not enabled, do nothing */
-			if (!(rec->flags & FTRACE_FL_ENABLED))
-				return 0;
+	/* If the state of this record hasn't changed, then do nothing */
+	if ((rec->flags & FTRACE_FL_ENABLED) == flag)
+		return 0;
 
-			rec->flags &= ~FTRACE_FL_ENABLED;
-		}
+	if (flag) {
+		rec->flags |= FTRACE_FL_ENABLED;
+		return ftrace_make_call(rec, ftrace_addr);
 	}
 
-	if (rec->flags & FTRACE_FL_ENABLED)
-		return ftrace_make_call(rec, ftrace_addr);
-	else
-		return ftrace_make_nop(NULL, rec, ftrace_addr);
+	rec->flags &= ~FTRACE_FL_ENABLED;
+	return ftrace_make_nop(NULL, rec, ftrace_addr);
 }
 
 static void ftrace_replace_code(int enable)
-- 
1.6.2.3

