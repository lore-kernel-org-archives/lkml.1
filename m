Return-Path: <linux-kernel-owner+w=401wt.eu-S1760697AbXJLJfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697AbXJLJfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759519AbXJLJfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:35:30 -0400
Received: from sullivan.realtime.net ([205.238.132.226]:4462 "EHLO
	sullivan.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758024AbXJLJf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:35:29 -0400
Date: Fri, 12 Oct 2007 04:35:19 -0500 (CDT)
From: Milton Miller <miltonm@bga.com>
Subject: [PATCH] sched domain sysctl: free and rebuild when changing domains
In-Reply-To: <mm-sched-0@bga.com>
Message-Id: <mm-sched-2@bga.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Unregister and free the sysctl table before destroying domains, then
rebuild and register after creating the new domains.  This prevents the
sysctl table from pointing to freed memory for root to write.

Signed-off-by: Milton Miller <miltonm@bga.com>

Index: kernel/kernel/sched.c
===================================================================
--- kernel.orig/kernel/sched.c	2007-10-12 03:55:19.000000000 -0500
+++ kernel/kernel/sched.c	2007-10-12 03:58:35.000000000 -0500
@@ -5291,6 +5291,18 @@ static struct ctl_table *sd_alloc_ctl_en
 	return entry;
 }
 
+static void sd_free_ctl_entry(struct ctl_table **tablep)
+{
+	struct ctl_table *entry = *tablep;
+
+	for (entry = *tablep; entry->procname; entry++)
+		if (entry->child)
+			sd_free_ctl_entry(&entry->child);
+
+	kfree(*tablep);
+	*tablep = NULL;
+}
+
 static void
 set_table_entry(struct ctl_table *entry,
 		const char *procname, void *data, int maxlen,
@@ -5359,7 +5371,7 @@ static ctl_table *sd_alloc_ctl_cpu_table
 }
 
 static struct ctl_table_header *sd_sysctl_header;
-static void init_sched_domain_sysctl(void)
+static void register_sched_domain_sysctl(void)
 {
 	int i, cpu_num = num_online_cpus();
 	struct ctl_table *entry = sd_alloc_ctl_entry(cpu_num + 1);
@@ -5376,8 +5388,18 @@ static void init_sched_domain_sysctl(voi
 	}
 	sd_sysctl_header = register_sysctl_table(sd_ctl_root);
 }
+
+static void unregister_sched_domain_sysctl(void)
+{
+	unregister_sysctl_table(sd_sysctl_header);
+	sd_sysctl_header = NULL;
+	sd_free_ctl_entry(&sd_ctl_dir[0].child);
+}
 #else
-static void init_sched_domain_sysctl(void)
+static void register_sched_domain_sysctl(void)
+{
+}
+static void unregister_sched_domain_sysctl(void)
 {
 }
 #endif
@@ -6311,6 +6333,8 @@ static int arch_init_sched_domains(const
 
 	err = build_sched_domains(&cpu_default_map);
 
+	register_sched_domain_sysctl();
+
 	return err;
 }
 
@@ -6327,6 +6351,8 @@ static void detach_destroy_domains(const
 {
 	int i;
 
+	unregister_sched_domain_sysctl();
+
 	for_each_cpu_mask(i, *cpu_map)
 		cpu_attach_domain(NULL, i);
 	synchronize_sched();
@@ -6357,6 +6383,8 @@ int partition_sched_domains(cpumask_t *p
 	if (!err && !cpus_empty(*partition2))
 		err = build_sched_domains(partition2);
 
+	register_sched_domain_sysctl();
+
 	return err;
 }
 
@@ -6488,8 +6516,6 @@ void __init sched_init_smp(void)
 	/* XXX: Theoretical race here - CPU may be hotplugged now */
 	hotcpu_notifier(update_sched_domains, 0);
 
-	init_sched_domain_sysctl();
-
 	/* Move init over to a non-isolated CPU */
 	if (set_cpus_allowed(current, non_isolated_cpus) < 0)
 		BUG();
