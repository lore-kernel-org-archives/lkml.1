Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbZKUNgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbZKUNgL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:36:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbZKUNgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:36:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:41704 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632AbZKUNgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:36:04 -0500
Date: Sat, 21 Nov 2009 13:35:56 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, xiaoguangrong@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, xiaoguangrong@cn.fujitsu.com
In-Reply-To: <4A67E092.3080202@cn.fujitsu.com>
References: <4A67E092.3080202@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/ksym_tracer: support quick clear for ksym_trace_filter -- v2
Message-ID: <tip-75e33751ca8bbb72dd6f1a74d2810ddc8cbe4bdf@git.kernel.org>
Git-Commit-ID: 75e33751ca8bbb72dd6f1a74d2810ddc8cbe4bdf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  75e33751ca8bbb72dd6f1a74d2810ddc8cbe4bdf
Gitweb:     http://git.kernel.org/tip/75e33751ca8bbb72dd6f1a74d2810ddc8cbe4bdf
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Thu, 23 Jul 2009 12:01:22 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 23 Jul 2009 20:54:40 -0400

tracing/ksym_tracer: support quick clear for ksym_trace_filter -- v2

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
