Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbZCFG3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbZCFG3x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbZCFG3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:29:15 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58639 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbZCFG3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:29:13 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH for tip][bugfix] ftrace: fix deadlock when setting set_ftrace_pid
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090306151155.0778.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri,  6 Mar 2009 15:29:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix deadlock bug

reproduce way:
	# cd /sys/kernel/debug/tracing
	# echo $$ > set_ftrace_pid

	then, console become hangup.

detail:
when writing set_ftracepid, kernel callstack is following

	ftrace_pid_write()
		mutex_lock(&ftrace_lock);
		ftrace_update_pid_func()
			mutex_lock(&ftrace_lock);
			mutex_unlock(&ftrace_lock);
		mutex_unlock(&ftrace_lock);

then, system alaways deadlock when ftrace_pid_write() is called.

In past days, ftrace_pid_write() use ftrace_start_lock, but
commit e6ea44e9b4c12325337cd1c06103cd515a1c02b2 consolidate
ftrace_start_lock to ftrace_lock.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5a3a06b..0d3b393 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -218,10 +218,8 @@ static void ftrace_update_pid_func(void)
 {
 	ftrace_func_t func;
 
-	mutex_lock(&ftrace_lock);
-
 	if (ftrace_trace_function == ftrace_stub)
-		goto out;
+		return;
 
 	func = ftrace_trace_function;
 
@@ -238,9 +236,6 @@ static void ftrace_update_pid_func(void)
 #else
 	__ftrace_trace_function = func;
 #endif
-
- out:
-	mutex_unlock(&ftrace_lock);
 }
 
 /* set when tracing only a pid */


