Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635Ab0AVBQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab0AVBQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932148Ab0AVBQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:16:46 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:57482 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab0AVBQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:16:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JRYgeXFziiTE5J1AKzTiN8qH55cGGFrRTwzv+m/C7Ic+jLgWZpNxOhePp+N5LjLKPJ
         XkO9FlAQlI4hP/r3zhFBZAaSvH3SFhneiWSgthNRyjCfaBA6KNGNFLsvsztMi8EiQtpv
         2Q8/+ii7EpHGvLdewugoQ7mi5Qob2kyvxjlKk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [RFC PATCH 06/10] ftrace: Release the function hlist if we don't need it anymore
Date: Fri, 22 Jan 2010 02:16:18 +0100
Message-Id: <1264122982-1553-7-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After we disable the function profiler, the function hashlist
stays in memory. This is wasteful as nobody needs it anymore,
until the next use if any.

Release it when we disable the function profiler instead of
resetting it in the next use.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/trace/ftrace.c          |    1 +
 kernel/trace/functions_hlist.c |   61 +++++++++++++++++-----------------------
 kernel/trace/functions_hlist.h |    1 +
 3 files changed, 28 insertions(+), 35 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index dfd8f7c..0ded01c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -509,6 +509,7 @@ ftrace_profile_write(struct file *filp, const char __user *ubuf,
 			 * so this acts like an synchronize_sched.
 			 */
 			unregister_ftrace_profiler();
+			function_hlist_release();
 		}
 	}
  out:
diff --git a/kernel/trace/functions_hlist.c b/kernel/trace/functions_hlist.c
index 37804c4..c79c4c5 100644
--- a/kernel/trace/functions_hlist.c
+++ b/kernel/trace/functions_hlist.c
@@ -21,20 +21,23 @@ DEFINE_PER_CPU(struct func_hlist, func_hlist_cpu);
 
 int functions_hash_bits __read_mostly;
 
-static void function_hlist_reset(struct func_hlist *hlist)
+static void __function_hlist_release(struct func_hlist *hlist)
 {
-	struct func_hlist_page *pg;
-
-	pg = hlist->pages = hlist->start;
+	struct func_hlist_page *pg = hlist->start;
 
 	while (pg) {
-		memset(pg->records, 0, FUNCTIONS_RECORDS_SIZE);
-		pg->index = 0;
+		unsigned long tmp = (unsigned long)pg;
+
 		pg = pg->next;
+		free_page(tmp);
 	}
 
-	memset(hlist->hash, 0,
-	       FUNCTIONS_HLIST_SIZE * sizeof(struct hlist_head));
+	free_page((unsigned long)hlist->pages);
+	hlist->pages = NULL;
+	hlist->start = NULL;
+
+	kfree(hlist->hash);
+	hlist->hash = NULL;
 }
 
 static int function_hlist_pages_init(struct func_hlist *hlist)
@@ -44,10 +47,6 @@ static int function_hlist_pages_init(struct func_hlist *hlist)
 	int pages;
 	int i;
 
-	/* If we already allocated, do nothing */
-	if (hlist->pages)
-		return 0;
-
 	hlist->pages = (void *)get_zeroed_page(GFP_KERNEL);
 	if (!hlist->pages)
 		return -ENOMEM;
@@ -72,26 +71,11 @@ static int function_hlist_pages_init(struct func_hlist *hlist)
 	for (i = 0; i < pages; i++) {
 		pg->next = (void *)get_zeroed_page(GFP_KERNEL);
 		if (!pg->next)
-			goto out_free;
+			return -ENOMEM;
 		pg = pg->next;
 	}
 
 	return 0;
-
- out_free:
-	pg = hlist->start;
-	while (pg) {
-		unsigned long tmp = (unsigned long)pg;
-
-		pg = pg->next;
-		free_page(tmp);
-	}
-
-	free_page((unsigned long)hlist->pages);
-	hlist->pages = NULL;
-	hlist->start = NULL;
-
-	return -ENOMEM;
 }
 
 static int function_hlist_init_cpu(int cpu)
@@ -101,11 +85,8 @@ static int function_hlist_init_cpu(int cpu)
 
 	hlist = &per_cpu(func_hlist_cpu, cpu);
 
-	if (hlist->hash) {
-		/* If the profile is already created, simply reset it */
-		function_hlist_reset(hlist);
-		return 0;
-	}
+	if (WARN_ON_ONCE(hlist->hash))
+		return -EBUSY;
 
 	/*
 	 * We are profiling all functions, but usually only a few thousand
@@ -127,14 +108,24 @@ static int function_hlist_init_cpu(int cpu)
 
 	/* Preallocate the function profiling pages */
 	if (function_hlist_pages_init(hlist) < 0) {
-		kfree(hlist->hash);
-		hlist->hash = NULL;
+		__function_hlist_release(hlist);
 		return -ENOMEM;
 	}
 
 	return 0;
 }
 
+void function_hlist_release(void)
+{
+	int cpu;
+	struct func_hlist *hlist;
+
+	for_each_online_cpu(cpu) {
+		hlist = &per_cpu(func_hlist_cpu, cpu);
+		__function_hlist_release(hlist);
+	}
+}
+
 int function_hlist_init(void)
 {
 	int cpu;
diff --git a/kernel/trace/functions_hlist.h b/kernel/trace/functions_hlist.h
index 3f4e485..8001f95 100644
--- a/kernel/trace/functions_hlist.h
+++ b/kernel/trace/functions_hlist.h
@@ -36,3 +36,4 @@ struct func_node *
 function_hlist_record_alloc(struct func_hlist *hlist, unsigned long ip);
 
 int function_hlist_init(void);
+void function_hlist_release(void);
-- 
1.6.2.3

