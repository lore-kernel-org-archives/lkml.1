Return-Path: <linux-kernel-owner+w=401wt.eu-S1751865AbZGXCPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbZGXCPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 22:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbZGXCPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 22:15:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59968 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbZGXCPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 22:15:11 -0400
Message-Id: <20090724021510.881289541@goodmis.org>
References: <20090724021403.694891838@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 23 Jul 2009 22:14:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 2/3] tracing/ksym_tracer: fix write operation of ksym_trace_filter
Content-Disposition: inline; filename=0002-tracing-ksym_tracer-fix-write-operation-of-ksym_trac.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

This patch fix 2 bugs:
- fix the return value of ksym_trace_filter_write() when we want to
  clear symbol in ksym_trace_filter file
  for example:
  # echo global_trace:rw- > /debug/tracing/ksym_trace_filter
  # echo global_trace:--- > /debug/tracing/ksym_trace_filter
  -bash: echo: write error: Invalid argument
  # cat /debug/tracing/ksym_trace_filter
  #
  We want to clear 'global_trace' in ksym_trace_filter, it complain
  with "Invalid argument", but the operation is successful

- the "r--" access types is not allowed, but ksym_trace_filter file think
  it OK
  for example:
  # echo ksym_tracer_mutex:r-- > ksym_trace_filter
  -bash: echo: write error: Resource temporarily unavailable
  # dmesg
  ksym_tracer request failed. Try again later!!

  The error occur at register_kernel_hw_breakpoint(), but It's should
  at access types parser

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
LKML-Reference: <4A66863D.5090802@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_ksym.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index fbf3a8e..cd5cb65 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -135,6 +135,9 @@ static int ksym_trace_get_access_type(char *str)
 	case 6:
 		access = HW_BREAKPOINT_RW;
 		break;
+	case 4:
+		access = -EINVAL;
+		break;
 	case 2:
 		access = HW_BREAKPOINT_WRITE;
 		break;
@@ -312,6 +315,7 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 		kfree(entry->ksym_hbp->info.name);
 		kfree(entry->ksym_hbp);
 		kfree(entry);
+		ret = 0;
 		goto out;
 	} else {
 		/* Check for malformed request: (4) */
-- 
1.6.3.3

-- 
