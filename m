Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbZGVDXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbZGVDXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 23:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756488AbZGVDXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 23:23:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58602 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756478AbZGVDXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 23:23:46 -0400
Message-ID: <4A66863D.5090802@cn.fujitsu.com>
Date: Wed, 22 Jul 2009 11:23:41 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] tracing/ksym_tracer: fix write operation of ksym_trace_filter
References: <4A6685BB.2090809@cn.fujitsu.com>
In-Reply-To: <4A6685BB.2090809@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.6.1.2

