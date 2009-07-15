Return-Path: <linux-kernel-owner+w=401wt.eu-S1751287AbZGOE3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbZGOE3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 00:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbZGOE3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 00:29:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49211 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbZGOE3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 00:29:15 -0400
Message-ID: <4A5D5B12.2050802@cn.fujitsu.com>
Date: Wed, 15 Jul 2009 12:29:06 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] tracing/function: fix the return value of ftrace_trace_onoff_callback()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ftrace_trace_onoff_callback() will return error even if we do the
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

We want to set _spin_*:traceon:10 to set_ftrace_filter, it complain
with "Invalid argument", but the operation is successful.
So, this patch fix it.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
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
1.6.1.2

