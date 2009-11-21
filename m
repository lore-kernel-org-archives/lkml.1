Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbZKUNgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbZKUNgL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:36:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbZKUNgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:36:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:41702 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203AbZKUNgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:36:03 -0500
Date: Sat, 21 Nov 2009 13:35:44 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, xiaoguangrong@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, xiaoguangrong@cn.fujitsu.com
In-Reply-To: <4A66863D.5090802@cn.fujitsu.com>
References: <4A66863D.5090802@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/ksym_tracer: fix write operation of ksym_trace_filter
Message-ID: <tip-8e068542a8d9efec55126284d2f5cb32f003d507@git.kernel.org>
Git-Commit-ID: 8e068542a8d9efec55126284d2f5cb32f003d507
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e068542a8d9efec55126284d2f5cb32f003d507
Gitweb:     http://git.kernel.org/tip/8e068542a8d9efec55126284d2f5cb32f003d507
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Wed, 22 Jul 2009 11:23:41 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 23 Jul 2009 20:52:05 -0400

tracing/ksym_tracer: fix write operation of ksym_trace_filter

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
