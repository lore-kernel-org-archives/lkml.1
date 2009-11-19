Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbZKSRLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbZKSRLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:11:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbZKSRLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:11:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42835 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbZKSRLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:11:01 -0500
Message-Id: <20091119171106.365522470@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 19 Nov 2009 12:10:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Christoph Hellwig <hch@lst.de>,
       Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: [PATCH 1/4] [PATCH 1/4] tracing: Fix strstrip usage in set_ftrace_pid
References: <20091119171003.929771398@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Fix-strstrip-usage-in-set_ftrace_pid.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Javier Martinez Canillas <martinez.javier@gmail.com>

The code in writing to set_ftrace_pid crops off whitespace before and
after the passed in string. But the usage of strstrip is incorrect,
and does not do the intended job.

  # echo '  3431   ' > /debug/tracing/set_ftrace_pid
  -bash: echo: write error: Invalid argument

With this fix, the above line now succeeds.

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
LKML-Reference: <1256965563.4278.7.camel@laptop>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7f9b51e..b29ff29 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2987,6 +2987,7 @@ ftrace_pid_write(struct file *filp, const char __user *ubuf,
 {
 	char buf[64];
 	long val;
+	char *bufstr;
 	int ret;
 
 	if (cnt >= sizeof(buf))
@@ -3001,11 +3002,11 @@ ftrace_pid_write(struct file *filp, const char __user *ubuf,
 	 * Allow "echo > set_ftrace_pid" or "echo -n '' > set_ftrace_pid"
 	 * to clean the filter quietly.
 	 */
-	strstrip(buf);
-	if (strlen(buf) == 0)
+	bufstr = strstrip(buf);
+	if (strlen(bufstr) == 0)
 		return 1;
 
-	ret = strict_strtol(buf, 10, &val);
+	ret = strict_strtol(bufstr, 10, &val);
 	if (ret < 0)
 		return ret;
 
-- 
1.6.5


