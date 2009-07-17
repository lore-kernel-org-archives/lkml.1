Return-Path: <linux-kernel-owner+w=401wt.eu-S934124AbZGQG1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934124AbZGQG1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 02:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934107AbZGQG1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 02:27:30 -0400
Received: from mail-qy0-f190.google.com ([209.85.221.190]:48028 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934105AbZGQG1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 02:27:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wtu6q++cNKM2RZF1GsD1KHhMveuQmERExGuv6S23/Q9USXb9f0kKaVMOzABr9gvl+S
         YDYvahYmxotOoIOZT3LLdlmPo7Rtc+OJKIM0mfSRv5aiXlLNJ3g1ftYmopPcpqkcayOq
         JsDFHdURHmbAyWYBc9pl0nkMX+WutfbRIhxMY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, stable@kernel.org,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [GIT PULL] tracing fix
Date: Fri, 17 Jul 2009 02:27:24 -0400
Message-Id: <1247812044-6460-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Thomas,

Please pull this tracing fix for 2.6.31. The patch is also relevant
in .30 and there is the appropriate Cc to request the backport.

Thanks,
Frederic.

The following changes since commit 4b0a84043e0c14088958fddb62f416d050368011:
  Linus Torvalds (1):
        Merge branch 'sched-fixes-for-linus' of git://git.kernel.org/.../peterz/linux-2.6-sched

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/urgent

Xiao Guangrong (1):
      tracing/function: Fix the return value of ftrace_trace_onoff_callback()

 kernel/trace/trace_functions.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

--

>From 04aef32d39cc4ef80087c0ce8ed113c6d64f1a6b Mon Sep 17 00:00:00 2001
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Date: Wed, 15 Jul 2009 12:29:06 +0800
Subject: [PATCH] tracing/function: Fix the return value of ftrace_trace_onoff_callback()

ftrace_trace_onoff_callback() will return an error even if we do the
right operation, for example:

 # echo _spin_*:traceon:10 > set_ftrace_filter
 -bash: echo: write error: Invalid argument
 # cat set_ftrace_filter
 #### all functions enabled ####
 _spin_trylock_bh:traceon:count=10
 _spin_unlock_irq:traceon:count=10
 _spin_unlock_bh:traceon:count=10
 _spin_lock_irq:traceon:count=10
 _spin_unlock:traceon:count=10
 _spin_trylock:traceon:count=10
 _spin_unlock_irqrestore:traceon:count=10
 _spin_lock_irqsave:traceon:count=10
 _spin_lock_bh:traceon:count=10
 _spin_lock:traceon:count=10

We want to set _spin_*:traceon:10 to set_ftrace_filter, it complains
with "Invalid argument", but the operation is successful.

This is because ftrace_process_regex() returns the number of functions that
matched the pattern. If the number is not 0, this value is returned
by ftrace_regex_write() whereas we want to return the number of bytes
virtually written.
Also the file offset pointer is not updated in this case.

If the number of matched functions is lower than the number of bytes written
by the user, this results to a reprocessing of the string given by the user with
a lower size, leading to a malformed ftrace regex and then a -EINVAL returned.

So, this patch fixes it by returning 0 if no error occured.
The fix also applies on 2.6.30

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: stable@kernel.org
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_functions.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 7402144..75ef000 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -363,7 +363,7 @@ ftrace_trace_onoff_callback(char *glob, char *cmd, char *param, int enable)
  out_reg:
 	ret = register_ftrace_function_probe(glob, ops, count);
 
-	return ret;
+	return ret < 0 ? ret : 0;
 }
 
 static struct ftrace_func_command ftrace_traceon_cmd = {
-- 
1.6.2.3


