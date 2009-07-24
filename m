Return-Path: <linux-kernel-owner+w=401wt.eu-S1751975AbZGXCPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbZGXCPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 22:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbZGXCPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 22:15:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42338 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbZGXCPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 22:15:11 -0400
Message-Id: <20090724021511.111857408@goodmis.org>
References: <20090724021403.694891838@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 23 Jul 2009 22:14:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3/3] tracing/ksym_tracer: support quick clear for ksym_trace_filter -- v2
Content-Disposition: inline; filename=0003-tracing-ksym_tracer-support-quick-clear-for-ksym_tra.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

It's rather boring to clear symbol one by one in ksym_trace_filter
file, so, this patch will let ksym_trace_filter file support quickly
clear all break points. We can write "0" to this file and it will clear
all symbols

for example:
 # cat ksym_trace_filter
 ksym_filter_head:rw-
 global_trace:rw-
 # echo 0 > ksym_trace_filter
 # cat ksym_trace_filter
 #

Changelog v1->v2:
Add other ways to clear all breakpoints by writing NULL or "*:---"
to ksym_trace_filter file base on K.Prasad's suggestion

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
LKML-Reference: <4A67E092.3080202@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_ksym.c |   53 +++++++++++++++++++++++++++++---------------
 1 files changed, 35 insertions(+), 18 deletions(-)

diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index cd5cb65..2fde875 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -163,8 +163,6 @@ static int parse_ksym_trace_str(char *input_string, char **ksymname,
 {
 	int ret;
 
-	strstrip(input_string);
-
 	*ksymname = strsep(&input_string, ":");
 	*addr = kallsyms_lookup_name(*ksymname);
 
@@ -262,6 +260,25 @@ static ssize_t ksym_trace_filter_read(struct file *filp, char __user *ubuf,
 	return cnt;
 }
 
+static void __ksym_trace_reset(void)
+{
+	struct trace_ksym *entry;
+	struct hlist_node *node, *node1;
+
+	mutex_lock(&ksym_tracer_mutex);
+	hlist_for_each_entry_safe(entry, node, node1, &ksym_filter_head,
+								ksym_hlist) {
+		unregister_kernel_hw_breakpoint(entry->ksym_hbp);
+		ksym_filter_entry_count--;
+		hlist_del_rcu(&(entry->ksym_hlist));
+		synchronize_rcu();
+		kfree(entry->ksym_hbp->info.name);
+		kfree(entry->ksym_hbp);
+		kfree(entry);
+	}
+	mutex_unlock(&ksym_tracer_mutex);
+}
+
 static ssize_t ksym_trace_filter_write(struct file *file,
 					const char __user *buffer,
 						size_t count, loff_t *ppos)
@@ -282,6 +299,21 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 	}
 	input_string[count] = '\0';
 
+	strstrip(input_string);
+
+	/*
+	 * Clear all breakpoints if:
+	 * 1: echo > ksym_trace_filter
+	 * 2: echo 0 > ksym_trace_filter
+	 * 3: echo "*:---" > ksym_trace_filter
+	 */
+	if (!input_string[0] || !strcmp(input_string, "0") ||
+	    !strcmp(input_string, "*:---")) {
+		__ksym_trace_reset();
+		kfree(input_string);
+		return count;
+	}
+
 	ret = op = parse_ksym_trace_str(input_string, &ksymname, &ksym_addr);
 	if (ret < 0) {
 		kfree(input_string);
@@ -341,23 +373,8 @@ static const struct file_operations ksym_tracing_fops = {
 
 static void ksym_trace_reset(struct trace_array *tr)
 {
-	struct trace_ksym *entry;
-	struct hlist_node *node, *node1;
-
 	ksym_tracing_enabled = 0;
-
-	mutex_lock(&ksym_tracer_mutex);
-	hlist_for_each_entry_safe(entry, node, node1, &ksym_filter_head,
-								ksym_hlist) {
-		unregister_kernel_hw_breakpoint(entry->ksym_hbp);
-		ksym_filter_entry_count--;
-		hlist_del_rcu(&(entry->ksym_hlist));
-		synchronize_rcu();
-		kfree(entry->ksym_hbp->info.name);
-		kfree(entry->ksym_hbp);
-		kfree(entry);
-	}
-	mutex_unlock(&ksym_tracer_mutex);
+	__ksym_trace_reset();
 }
 
 static int ksym_trace_init(struct trace_array *tr)
-- 
1.6.3.3

-- 
