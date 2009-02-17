Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbZBQFPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbZBQFPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 00:15:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbZBQFOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 00:14:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33850 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbZBQFOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 00:14:07 -0500
Message-Id: <20090217051406.189453081@goodmis.org>
References: <20090217051227.957864159@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Feb 2009 00:12:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 06/15] ftrace: enable filtering only when a function is filtered on
Content-Disposition: inline; filename=0006-ftrace-enable-filtering-only-when-a-function-is-fil.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix to prevent empty set_ftrace_filter and no ftrace output

The function filter is used to only trace a given set of functions.
The filter is enabled when a function name is echoed into the
set_ftrace_filter file. But if the name has a typo and the function
is not found, the filter is enabled, but no function is listed.

This makes a confusing situation where set_ftrace_filter is empty
but no functions ever get enabled for tracing.

For example:

 # cat /debug/tracing/set_ftrace_filter

  #### all functions enabled ####

 # echo bad_name > set_ftrace_filter
 # cat /debug/tracing/set_ftrace_filter

 # echo function > current_tracer
 # cat trace

  # tracer: nop
  #
  #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
  #              | |       |          |         |

This patch changes that to only enable filtering if a function
is set to be filtered on. Now, the filter is not enabled if
a bad name is echoed into set_ftrace_filter.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 9e60ae4..340f88b 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1153,8 +1153,6 @@ static void ftrace_match_records(char *buff, int len, int enable)
 
 	/* should not be called from interrupt context */
 	spin_lock(&ftrace_lock);
-	if (enable)
-		ftrace_filtered = 1;
 	do_for_each_ftrace_rec(pg, rec) {
 
 		if (rec->flags & FTRACE_FL_FAILED)
@@ -1166,7 +1164,12 @@ static void ftrace_match_records(char *buff, int len, int enable)
 			else
 				rec->flags |= flag;
 		}
-
+		/*
+		 * Only enable filtering if we have a function that
+		 * is filtered on.
+		 */
+		if (enable && (rec->flags & FTRACE_FL_FILTER))
+			ftrace_filtered = 1;
 	} while_for_each_ftrace_rec();
 	spin_unlock(&ftrace_lock);
 }
@@ -1217,9 +1220,6 @@ static void ftrace_match_module_records(char *buff, char *mod, int enable)
 
 	/* should not be called from interrupt context */
 	spin_lock(&ftrace_lock);
-	if (enable)
-		ftrace_filtered = 1;
-
 	do_for_each_ftrace_rec(pg, rec) {
 
 		if (rec->flags & FTRACE_FL_FAILED)
@@ -1232,6 +1232,8 @@ static void ftrace_match_module_records(char *buff, char *mod, int enable)
 			else
 				rec->flags |= flag;
 		}
+		if (enable && (rec->flags & FTRACE_FL_FILTER))
+			ftrace_filtered = 1;
 
 	} while_for_each_ftrace_rec();
 	spin_unlock(&ftrace_lock);
-- 
1.5.6.5

-- 
