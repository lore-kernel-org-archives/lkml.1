Return-Path: <linux-kernel-owner+w=401wt.eu-S1761293AbXJLJgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761293AbXJLJgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760624AbXJLJfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:35:37 -0400
Received: from sullivan.realtime.net ([205.238.132.226]:1230 "EHLO
	sullivan.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760314AbXJLJfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:35:36 -0400
Date: Fri, 12 Oct 2007 04:35:18 -0500 (CDT)
From: Milton Miller <miltonm@bga.com>
Subject: [PATCH] sched domain sysctl: register online cpus
In-Reply-To: <mm-sched-0@bga.com>
Message-Id: <mm-sched-1@bga.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

init_sched_domain_sysctl was walking cpus 0-n and referencing per_cpu
variables.  If the cpus_possible mask is not contigious this will result
in a crash referencing unallocated data.  If the online mask is not
contigious then we would show offline cpus and miss online ones.

Signed-off-by: Milton Miller <miltonm@bga.com>

Index: kernel/kernel/sched.c
===================================================================
--- kernel.orig/kernel/sched.c	2007-10-11 23:48:10.000000000 -0500
+++ kernel/kernel/sched.c	2007-10-11 23:55:51.000000000 -0500
@@ -5367,11 +5367,12 @@ static void init_sched_domain_sysctl(voi
 
 	sd_ctl_dir[0].child = entry;
 
-	for (i = 0; i < cpu_num; i++, entry++) {
+	for_each_online_cpu(i) {
 		snprintf(buf, 32, "cpu%d", i);
 		entry->procname = kstrdup(buf, GFP_KERNEL);
 		entry->mode = 0555;
 		entry->child = sd_alloc_ctl_cpu_table(i);
+		entry++;
 	}
 	sd_sysctl_header = register_sysctl_table(sd_ctl_root);
 }
