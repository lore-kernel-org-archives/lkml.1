Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbZG1XuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbZG1XuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbZG1XuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:50:11 -0400
Received: from kroah.org ([198.145.64.141]:35812 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349AbZG1XuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:07 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:57 2009
Message-Id: <20090728234157.065996220@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [patch 38/71] tracing/function: Fix the return value of ftrace_trace_onoff_callback()
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=tracing-function-fix-the-return-value-of-ftrace_trace_onoff_callback.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

commit 04aef32d39cc4ef80087c0ce8ed113c6d64f1a6b upstream.

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
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/trace_functions.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -364,7 +364,7 @@ ftrace_trace_onoff_callback(char *glob, 
  out_reg:
 	ret = register_ftrace_function_probe(glob, ops, count);
 
-	return ret;
+	return ret < 0 ? ret : 0;
 }
 
 static struct ftrace_func_command ftrace_traceon_cmd = {


