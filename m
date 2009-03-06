Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbZCFLKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbZCFLKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 06:10:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbZCFLJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 06:09:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:36521 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbZCFLJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 06:09:58 -0500
Date: Fri, 6 Mar 2009 11:09:23 GMT
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       srostedt@redhat.com, tglx@linutronix.de, laijs@cn.fujitsu.com,
       kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       srostedt@redhat.com, tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com,
       laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <20090306151155.0778.A69D9226@jp.fujitsu.com>
References: <20090306151155.0778.A69D9226@jp.fujitsu.com>
Subject: [tip:tracing/ftrace] tracing: fix deadlock when setting set_ftrace_pid
Message-ID: <tip-10dd3ebe213c31bff14b4dae3c5d32a76b1fad7c@git.kernel.org>
Git-Commit-ID: 10dd3ebe213c31bff14b4dae3c5d32a76b1fad7c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 11:09:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  10dd3ebe213c31bff14b4dae3c5d32a76b1fad7c
Gitweb:     http://git.kernel.org/tip/10dd3ebe213c31bff14b4dae3c5d32a76b1fad7c
Author:     "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
AuthorDate: Fri, 6 Mar 2009 15:29:04 +0900
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 Mar 2009 12:07:38 +0100

tracing: fix deadlock when setting set_ftrace_pid

Impact: fix deadlock while using set_ftrace_pid

Reproducer:

	# cd /sys/kernel/debug/tracing
	# echo $$ > set_ftrace_pid

	then, console becomes hung.

Details:

when writing set_ftracepid, kernel callstack is following

	ftrace_pid_write()
		mutex_lock(&ftrace_lock);
		ftrace_update_pid_func()
			mutex_lock(&ftrace_lock);
			mutex_unlock(&ftrace_lock);
		mutex_unlock(&ftrace_lock);

then, system always deadlocks when ftrace_pid_write() is called.

In past days, ftrace_pid_write() used ftrace_start_lock, but
commit e6ea44e9b4c12325337cd1c06103cd515a1c02b2 consolidated
ftrace_start_lock to ftrace_lock.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <srostedt@redhat.com>
LKML-Reference: <20090306151155.0778.A69D9226@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/ftrace.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d7a06a0..d33d306 100644
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
