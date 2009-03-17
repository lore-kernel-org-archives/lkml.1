Return-Path: <linux-kernel-owner+w=401wt.eu-S1760591AbZCQDt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760591AbZCQDt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 23:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbZCQDtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 23:49:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41212 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbZCQDtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 23:49:31 -0400
Message-Id: <20090317034928.628506731@goodmis.org>
References: <20090317034820.400357912@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 16 Mar 2009 23:48:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/3] tracing/ftrace: fix the check on nopped sites
Content-Disposition: inline; filename=0001-tracing-ftrace-fix-the-check-on-nopped-sites.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Impact: fix a dynamic tracing failure

Recently, the function and function graph tracers failed to use dynamic
tracing after the following commit:

fa9d13cf135efbd454453a53b6299976bea245a9
(ftrace: don't try to __ftrace_replace_code on !FTRACE_FL_CONVERTED rec)

The patch is right except a mistake on the check for the FTRACE_FL_CONVERTED
flag. The code patching is aborted in case of successfully nopped sites.
What we want is the opposite: ignore the callsites that haven't been nopped.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 90d5729..7847806 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -537,7 +537,7 @@ static void ftrace_replace_code(int enable)
 		 */
 		if (rec->flags & FTRACE_FL_FREE ||
 		    rec->flags & FTRACE_FL_FAILED ||
-		    rec->flags & FTRACE_FL_CONVERTED)
+		    !(rec->flags & FTRACE_FL_CONVERTED))
 			continue;
 
 		/* ignore updates to this record's mcount site */
-- 
1.6.2

-- 
