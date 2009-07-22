Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbZGVDZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbZGVDZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 23:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756499AbZGVDZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 23:25:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62621 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756493AbZGVDZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 23:25:19 -0400
Message-ID: <4A66869A.9000106@cn.fujitsu.com>
Date: Wed, 22 Jul 2009 11:25:14 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] tracing/ksym_tracer: support quick clear for ksym_trace_filter
References: <4A6685BB.2090809@cn.fujitsu.com>
In-Reply-To: <4A6685BB.2090809@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's rather bored to clear symbol one by one in ksym_trace_filter
file, so, this patch can let ksym_trace_filter file support quick
clear, we can write "0" to this file, it can clear all symbols
 
for example:
 # cat ksym_trace_filter
 ksym_filter_head:rw-
 global_trace:rw-
 # echo 0 > ksym_trace_filter
 # cat ksym_trace_filter
 #

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 kernel/trace/trace_ksym.c |   45 +++++++++++++++++++++++++++------------------
 1 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index cd5cb65..96b9e19 100644
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
@@ -282,6 +299,13 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 	}
 	input_string[count] = '\0';
 
+	strstrip(input_string);
+	if (!strcmp(input_string, "0")) {
+		__ksym_trace_reset();
+		kfree(input_string);
+		return count;
+	}
+
 	ret = op = parse_ksym_trace_str(input_string, &ksymname, &ksym_addr);
 	if (ret < 0) {
 		kfree(input_string);
@@ -341,23 +365,8 @@ static const struct file_operations ksym_tracing_fops = {
 
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
1.6.1.2

