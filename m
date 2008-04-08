Return-Path: <linux-kernel-owner+w=401wt.eu-S1757031AbYDHLZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbYDHLZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbYDHLTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:32 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:47756 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981AbYDHLT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:28 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 26/29] kernel: use non-racy method for proc entries creation
Date: Tue,  8 Apr 2008 15:19:33 +0400
Message-Id: <1207653576-12640-26-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create()/proc_create_data() to make sure that ->proc_fops and
->data be setup before gluing PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
---
 kernel/configs.c          |    4 ++--
 kernel/dma.c              |    7 +------
 kernel/kallsyms.c         |    6 +-----
 kernel/latencytop.c       |    9 +--------
 kernel/lockdep_proc.c     |   16 ++++------------
 kernel/profile.c          |    4 ++--
 kernel/resource.c         |   10 ++--------
 kernel/sched_debug.c      |    5 +----
 kernel/time/timer_list.c  |    5 +----
 kernel/time/timer_stats.c |    5 +----
 10 files changed, 16 insertions(+), 55 deletions(-)

diff --git a/kernel/configs.c b/kernel/configs.c
index d3a4b82..4c34521 100644
--- a/kernel/configs.c
+++ b/kernel/configs.c
@@ -79,11 +79,11 @@ static int __init ikconfig_init(void)
 	struct proc_dir_entry *entry;
 
 	/* create the current config file */
-	entry = create_proc_entry("config.gz", S_IFREG | S_IRUGO, NULL);
+	entry = proc_create("config.gz", S_IFREG | S_IRUGO, NULL,
+			    &ikconfig_file_ops);
 	if (!entry)
 		return -ENOMEM;
 
-	entry->proc_fops = &ikconfig_file_ops;
 	entry->size = kernel_config_data_size;
 
 	return 0;
diff --git a/kernel/dma.c b/kernel/dma.c
index 6a82bb7..d2c60a8 100644
--- a/kernel/dma.c
+++ b/kernel/dma.c
@@ -149,12 +149,7 @@ static const struct file_operations proc_dma_operations = {
 
 static int __init proc_dma_init(void)
 {
-	struct proc_dir_entry *e;
-
-	e = create_proc_entry("dma", 0, NULL);
-	if (e)
-		e->proc_fops = &proc_dma_operations;
-
+	proc_create("dma", 0, NULL, &proc_dma_operations);
 	return 0;
 }
 
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index f091d13..6fc0040 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -472,11 +472,7 @@ static const struct file_operations kallsyms_operations = {
 
 static int __init kallsyms_init(void)
 {
-	struct proc_dir_entry *entry;
-
-	entry = create_proc_entry("kallsyms", 0444, NULL);
-	if (entry)
-		entry->proc_fops = &kallsyms_operations;
+	proc_create("kallsyms", 0444, NULL, &kallsyms_operations);
 	return 0;
 }
 __initcall(kallsyms_init);
diff --git a/kernel/latencytop.c b/kernel/latencytop.c
index 7c74dab..5e7b45c 100644
--- a/kernel/latencytop.c
+++ b/kernel/latencytop.c
@@ -233,14 +233,7 @@ static struct file_operations lstats_fops = {
 
 static int __init init_lstats_procfs(void)
 {
-	struct proc_dir_entry *pe;
-
-	pe = create_proc_entry("latency_stats", 0644, NULL);
-	if (!pe)
-		return -ENOMEM;
-
-	pe->proc_fops = &lstats_fops;
-
+	proc_create("latency_stats", 0644, NULL, &lstats_fops);
 	return 0;
 }
 __initcall(init_lstats_procfs);
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 8a135bd..dc5d296 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -660,20 +660,12 @@ static const struct file_operations proc_lock_stat_operations = {
 
 static int __init lockdep_proc_init(void)
 {
-	struct proc_dir_entry *entry;
-
-	entry = create_proc_entry("lockdep", S_IRUSR, NULL);
-	if (entry)
-		entry->proc_fops = &proc_lockdep_operations;
-
-	entry = create_proc_entry("lockdep_stats", S_IRUSR, NULL);
-	if (entry)
-		entry->proc_fops = &proc_lockdep_stats_operations;
+	proc_create("lockdep", S_IRUSR, NULL, &proc_lockdep_operations);
+	proc_create("lockdep_stats", S_IRUSR, NULL,
+		    &proc_lockdep_stats_operations);
 
 #ifdef CONFIG_LOCK_STAT
-	entry = create_proc_entry("lock_stat", S_IRUSR, NULL);
-	if (entry)
-		entry->proc_fops = &proc_lock_stat_operations;
+	proc_create("lock_stat", S_IRUSR, NULL, &proc_lock_stat_operations);
 #endif
 
 	return 0;
diff --git a/kernel/profile.c b/kernel/profile.c
index 3b7a1b0..1a21762 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -588,10 +588,10 @@ static int __init create_proc_profile(void)
 		return 0;
 	if (create_hash_tables())
 		return -1;
-	entry = create_proc_entry("profile", S_IWUSR | S_IRUGO, NULL);
+	entry = proc_create("profile", S_IWUSR | S_IRUGO,
+			    NULL, &proc_profile_operations);
 	if (!entry)
 		return 0;
-	entry->proc_fops = &proc_profile_operations;
 	entry->size = (1+prof_len) * sizeof(atomic_t);
 	hotcpu_notifier(profile_cpu_callback, 0);
 	return 0;
diff --git a/kernel/resource.c b/kernel/resource.c
index 46ad4f4..da8ee1b 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -131,14 +131,8 @@ static const struct file_operations proc_iomem_operations = {
 
 static int __init ioresources_init(void)
 {
-	struct proc_dir_entry *entry;
-
-	entry = create_proc_entry("ioports", 0, NULL);
-	if (entry)
-		entry->proc_fops = &proc_ioports_operations;
-	entry = create_proc_entry("iomem", 0, NULL);
-	if (entry)
-		entry->proc_fops = &proc_iomem_operations;
+	proc_create("ioports", 0, NULL, &proc_ioports_operations);
+	proc_create("iomem", 0, NULL, &proc_iomem_operations);
 	return 0;
 }
 __initcall(ioresources_init);
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 475b5ad..08dddd7 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -248,12 +248,9 @@ static int __init init_sched_debug_procfs(void)
 {
 	struct proc_dir_entry *pe;
 
-	pe = create_proc_entry("sched_debug", 0644, NULL);
+	pe = proc_create("sched_debug", 0644, NULL, &sched_debug_fops);
 	if (!pe)
 		return -ENOMEM;
-
-	pe->proc_fops = &sched_debug_fops;
-
 	return 0;
 }
 
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 67fe8fc..a40e20f 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -278,12 +278,9 @@ static int __init init_timer_list_procfs(void)
 {
 	struct proc_dir_entry *pe;
 
-	pe = create_proc_entry("timer_list", 0644, NULL);
+	pe = proc_create("timer_list", 0644, NULL, &timer_list_fops);
 	if (!pe)
 		return -ENOMEM;
-
-	pe->proc_fops = &timer_list_fops;
-
 	return 0;
 }
 __initcall(init_timer_list_procfs);
diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
index 417da8c..c994530 100644
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -415,12 +415,9 @@ static int __init init_tstats_procfs(void)
 {
 	struct proc_dir_entry *pe;
 
-	pe = create_proc_entry("timer_stats", 0644, NULL);
+	pe = proc_create("timer_stats", 0644, NULL, &tstats_fops);
 	if (!pe)
 		return -ENOMEM;
-
-	pe->proc_fops = &tstats_fops;
-
 	return 0;
 }
 __initcall(init_tstats_procfs);
-- 
1.5.3.rc5

