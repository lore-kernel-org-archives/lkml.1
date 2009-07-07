Return-Path: <linux-kernel-owner+w=401wt.eu-S1757174AbZGGFyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbZGGFyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 01:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756471AbZGGFyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 01:54:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50539 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755414AbZGGFyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 01:54:43 -0400
Message-ID: <4A52E328.8010200@cn.fujitsu.com>
Date: Tue, 07 Jul 2009 13:54:48 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/8] ksym_tracer: Fix memory leak
References: <4A52E291.1020408@cn.fujitsu.com>
In-Reply-To: <4A52E291.1020408@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- When remove a filter, we leak entry->ksym_hbp->info.name.

- With CONFIG_FTRAC_SELFTEST enabled, we leak ->info.name:
    # echo ksym_tracer > current_tracer
    # echo 'ksym_selftest_dummy:rw-' > ksym_trace_filter
    # echo nop > current_tracer

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_ksym.c |   61 ++++++++++++++++++++-------------------------
 1 files changed, 27 insertions(+), 34 deletions(-)

diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index 891e3b8..7d349d3 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -179,7 +179,7 @@ static int parse_ksym_trace_str(char *input_string, char **ksymname,
 int process_new_ksym_entry(char *ksymname, int op, unsigned long addr)
 {
 	struct trace_ksym *entry;
-	int ret;
+	int ret = -ENOMEM;
 
 	if (ksym_filter_entry_count >= KSYM_TRACER_MAX) {
 		printk(KERN_ERR "ksym_tracer: Maximum limit:(%d) reached. No"
@@ -193,12 +193,13 @@ int process_new_ksym_entry(char *ksymname, int op, unsigned long addr)
 		return -ENOMEM;
 
 	entry->ksym_hbp = kzalloc(sizeof(struct hw_breakpoint), GFP_KERNEL);
-	if (!entry->ksym_hbp) {
-		kfree(entry);
-		return -ENOMEM;
-	}
+	if (!entry->ksym_hbp)
+		goto err;
+
+	entry->ksym_hbp->info.name = kstrdup(ksymname, GFP_KERNEL);
+	if (!entry->ksym_hbp->info.name)
+		goto err;
 
-	entry->ksym_hbp->info.name = ksymname;
 	entry->ksym_hbp->info.type = op;
 	entry->ksym_addr = entry->ksym_hbp->info.address = addr;
 #ifdef CONFIG_X86
@@ -210,14 +211,18 @@ int process_new_ksym_entry(char *ksymname, int op, unsigned long addr)
 	if (ret < 0) {
 		printk(KERN_INFO "ksym_tracer request failed. Try again"
 					" later!!\n");
-		kfree(entry->ksym_hbp);
-		kfree(entry);
-		return -EAGAIN;
+		ret = -EAGAIN;
+		goto err;
 	}
 	hlist_add_head_rcu(&(entry->ksym_hlist), &ksym_filter_head);
 	ksym_filter_entry_count++;
-
 	return 0;
+err:
+	if (entry->ksym_hbp)
+		kfree(entry->ksym_hbp->info.name);
+	kfree(entry->ksym_hbp);
+	kfree(entry);
+	return ret;
 }
 
 static ssize_t ksym_trace_filter_read(struct file *filp, char __user *ubuf,
@@ -289,7 +294,7 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 			if (entry->ksym_hbp->info.type != op)
 				changed = 1;
 			else
-				goto err_ret;
+				goto out;
 			break;
 		}
 	}
@@ -298,34 +303,29 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 		entry->ksym_hbp->info.type = op;
 		if (op > 0) {
 			ret = register_kernel_hw_breakpoint(entry->ksym_hbp);
-			if (ret == 0) {
-				ret = count;
-				goto unlock_ret_path;
-			}
-		} else
-			ret = count;
+			if (ret == 0)
+				goto out;
+		}
 		ksym_filter_entry_count--;
 		hlist_del_rcu(&(entry->ksym_hlist));
 		synchronize_rcu();
+		kfree(entry->ksym_hbp->info.name);
 		kfree(entry->ksym_hbp);
 		kfree(entry);
-		goto err_ret;
+		goto out;
 	} else {
 		/* Check for malformed request: (4) */
 		if (op == 0)
-			goto err_ret;
+			goto out;
 		ret = process_new_ksym_entry(ksymname, op, ksym_addr);
-		if (ret)
-			goto err_ret;
 	}
-	ret = count;
-	goto unlock_ret_path;
+out:
+	mutex_unlock(&ksym_tracer_mutex);
 
-err_ret:
 	kfree(input_string);
 
-unlock_ret_path:
-	mutex_unlock(&ksym_tracer_mutex);
+	if (!ret)
+		ret = count;
 	return ret;
 }
 
@@ -349,14 +349,7 @@ static void ksym_trace_reset(struct trace_array *tr)
 		ksym_filter_entry_count--;
 		hlist_del_rcu(&(entry->ksym_hlist));
 		synchronize_rcu();
-		/* Free the 'input_string' only if reset
-		 * after startup self-test
-		 */
-#ifdef CONFIG_FTRACE_SELFTEST
-		if (strncmp(entry->ksym_hbp->info.name, KSYM_SELFTEST_ENTRY,
-					strlen(KSYM_SELFTEST_ENTRY)) != 0)
-#endif /* CONFIG_FTRACE_SELFTEST*/
-			kfree(entry->ksym_hbp->info.name);
+		kfree(entry->ksym_hbp->info.name);
 		kfree(entry->ksym_hbp);
 		kfree(entry);
 	}
-- 
1.5.4.rc3
