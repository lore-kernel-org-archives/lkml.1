Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242Ab0AVBQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab0AVBQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755085Ab0AVBQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:16:38 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:37480 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab0AVBQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:16:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fqCKxM4TMYFxCV7lxznrofXpSVeAc+Oldt9EZRQKR6rmJi3LyVwZoDPNK1JglSpJC+
         SDSXfFupermBOIrSscOxg6qjv88i0CSP9ouBGnzcMWLqb74Tee+eau7P6sutSeI5O7qe
         bxfevmRIEU5pZJIPQpg/yo+NP8leWITQ1BdlU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [RFC PATCH 07/10] ftrace: Make the function hashlist concurrently usable
Date: Fri, 22 Jan 2010 02:16:19 +0100
Message-Id: <1264122982-1553-8-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the function hashlist to be usable by simultaneous users.
The function tracers can then plug in for their own needs.

This introduces a get/put_function_hlist() that keeps track
of the hashlist users for allocation and release.

We also introduce function_hlist_reset_profile() that resets
the function profiling statistics on a function hashlist already
in use.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/trace/ftrace.c          |    5 ++-
 kernel/trace/functions_hlist.c |   56 ++++++++++++++++++++++++++++++++++++++-
 kernel/trace/functions_hlist.h |    5 ++-
 3 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0ded01c..027743c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -490,11 +490,12 @@ ftrace_profile_write(struct file *filp, const char __user *ubuf,
 	mutex_lock(&ftrace_profile_lock);
 	if (ftrace_profile_enabled ^ val) {
 		if (val) {
-			ret = function_hlist_init();
+			ret = get_function_hlist();
 			if (ret < 0) {
 				cnt = ret;
 				goto out;
 			}
+			function_hlist_reset_profile();
 
 			ret = register_ftrace_profiler();
 			if (ret < 0) {
@@ -509,7 +510,7 @@ ftrace_profile_write(struct file *filp, const char __user *ubuf,
 			 * so this acts like an synchronize_sched.
 			 */
 			unregister_ftrace_profiler();
-			function_hlist_release();
+			put_function_hlist();
 		}
 	}
  out:
diff --git a/kernel/trace/functions_hlist.c b/kernel/trace/functions_hlist.c
index c79c4c5..d682213 100644
--- a/kernel/trace/functions_hlist.c
+++ b/kernel/trace/functions_hlist.c
@@ -20,6 +20,39 @@
 DEFINE_PER_CPU(struct func_hlist, func_hlist_cpu);
 
 int functions_hash_bits __read_mostly;
+static atomic_t hlist_refcount;
+
+
+static void function_hlist_reset_profile_cpu(int cpu)
+{
+	struct func_hlist *hlist = &per_cpu(func_hlist_cpu, cpu);
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct func_node *rec;
+	int i;
+
+	for (i = 0; i < FUNCTIONS_HLIST_SIZE; i++) {
+		head = &hlist->hash[i];
+
+		if (hlist_empty(head))
+			continue;
+
+		hlist_for_each_entry(rec, node, head, node) {
+			rec->counter = 0;
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+			rec->time = 0;
+#endif
+		}
+	}
+}
+
+void function_hlist_reset_profile(void)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		function_hlist_reset_profile_cpu(cpu);
+}
 
 static void __function_hlist_release(struct func_hlist *hlist)
 {
@@ -115,7 +148,7 @@ static int function_hlist_init_cpu(int cpu)
 	return 0;
 }
 
-void function_hlist_release(void)
+static void function_hlist_release(void)
 {
 	int cpu;
 	struct func_hlist *hlist;
@@ -126,7 +159,7 @@ void function_hlist_release(void)
 	}
 }
 
-int function_hlist_init(void)
+static int function_hlist_init(void)
 {
 	int cpu;
 	int ret = 0;
@@ -140,6 +173,25 @@ int function_hlist_init(void)
 	return ret;
 }
 
+int get_function_hlist(void)
+{
+	int ret = 0;
+
+	if (atomic_inc_return(&hlist_refcount) == 1) {
+		ret = function_hlist_init();
+		if (ret < 0)
+			atomic_dec(&hlist_refcount);
+	}
+
+	return ret;
+}
+
+void put_function_hlist(void)
+{
+	if (!atomic_dec_return(&hlist_refcount))
+		function_hlist_release();
+}
+
 struct func_node *
 function_find_hlist_node(struct func_hlist *hlist, unsigned long ip)
 {
diff --git a/kernel/trace/functions_hlist.h b/kernel/trace/functions_hlist.h
index 8001f95..a4655c7 100644
--- a/kernel/trace/functions_hlist.h
+++ b/kernel/trace/functions_hlist.h
@@ -35,5 +35,6 @@ function_find_hlist_node(struct func_hlist *hlist, unsigned long ip);
 struct func_node *
 function_hlist_record_alloc(struct func_hlist *hlist, unsigned long ip);
 
-int function_hlist_init(void);
-void function_hlist_release(void);
+int get_function_hlist(void);
+void put_function_hlist(void);
+void function_hlist_reset_profile(void);
-- 
1.6.2.3

