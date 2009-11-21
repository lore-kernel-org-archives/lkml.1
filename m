Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbZKUNfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbZKUNfu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbZKUNft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:35:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:41674 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026AbZKUNfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:35:48 -0500
Date: Sat, 21 Nov 2009 13:35:09 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stern@rowland.harvard.edu, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
In-Reply-To: <4A52E328.8010200@cn.fujitsu.com>
References: <4A52E328.8010200@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ksym_tracer: Fix memory leak
Message-ID: <tip-558df6c8f74ac4a0b9026ef85b0028280f364d96@git.kernel.org>
Git-Commit-ID: 558df6c8f74ac4a0b9026ef85b0028280f364d96
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  558df6c8f74ac4a0b9026ef85b0028280f364d96
Gitweb:     http://git.kernel.org/tip/558df6c8f74ac4a0b9026ef85b0028280f364d96
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 7 Jul 2009 13:54:48 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 11:59:43 +0200

ksym_tracer: Fix memory leak

- When remove a filter, we leak entry->ksym_hbp->info.name.

- With CONFIG_FTRAC_SELFTEST enabled, we leak ->info.name:
    # echo ksym_tracer > current_tracer
    # echo 'ksym_selftest_dummy:rw-' > ksym_trace_filter
    # echo nop > current_tracer

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4A52E328.8010200@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
