Return-Path: <linux-kernel-owner+w=401wt.eu-S1761318AbXJLJhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761318AbXJLJhD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760737AbXJLJfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:35:42 -0400
Received: from sullivan.realtime.net ([205.238.132.226]:1334 "EHLO
	sullivan.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760706AbXJLJfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:35:41 -0400
Date: Fri, 12 Oct 2007 04:35:19 -0500 (CDT)
From: Milton Miller <miltonm@bga.com>
Subject: [PATCH] sched domain sysctl: don't bug on alloc failure
In-Reply-To: <mm-sched-0@bga.com>
Message-Id: <mm-sched-4@bga.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we are calling this at runtime, a more relaxed error path is
suggested.  If an allocation fails, we just register the partial table,
which will show empty directories.

Signed-off-by: Milton Miller <miltonm@bga.com>

Index: kernel/kernel/sched.c
===================================================================
--- kernel.orig/kernel/sched.c	2007-10-12 03:59:02.000000000 -0500
+++ kernel/kernel/sched.c	2007-10-12 03:59:07.000000000 -0500
@@ -5285,8 +5285,6 @@ static struct ctl_table *sd_alloc_ctl_en
 	struct ctl_table *entry =
 		kcalloc(n, sizeof(struct ctl_table), GFP_KERNEL);
 
-	BUG_ON(!entry);
-
 	return entry;
 }
 
@@ -5319,6 +5317,9 @@ sd_alloc_ctl_domain_table(struct sched_d
 {
 	struct ctl_table *table = sd_alloc_ctl_entry(14);
 
+	if (table == NULL)
+		return NULL;
+
 	set_table_entry(&table[0], "min_interval", &sd->min_interval,
 		sizeof(long), 0644, proc_doulongvec_minmax);
 	set_table_entry(&table[1], "max_interval", &sd->max_interval,
@@ -5356,6 +5357,8 @@ static ctl_table *sd_alloc_ctl_cpu_table
 	for_each_domain(cpu, sd)
 		domain_num++;
 	entry = table = sd_alloc_ctl_entry(domain_num + 1);
+	if (table == NULL)
+		return NULL;
 
 	i = 0;
 	for_each_domain(cpu, sd) {
@@ -5376,6 +5379,9 @@ static void register_sched_domain_sysctl
 	struct ctl_table *entry = sd_alloc_ctl_entry(cpu_num + 1);
 	char buf[32];
 
+	if (entry == NULL)
+		return;
+
 	sd_ctl_dir[0].child = entry;
 
 	for_each_online_cpu(i) {
