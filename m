Return-Path: <linux-kernel-owner+w=401wt.eu-S1759006AbXJ2RUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006AbXJ2RUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 13:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbXJ2RUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 13:20:06 -0400
Received: from smtp-out.google.com ([216.239.45.13]:56327 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbXJ2RUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 13:20:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:to:subject:cc:message-id:date:from;
	b=gKrt9OJFiRTmlosh2bSksIA1K+Q0gFElrgjJZgHMN9WGd5HNmJAXrOhhEtspeBrWl
	yoL4CdTYhNbeWxyb8DEWw==
To: akpm@linux-foundation.org, mingo@elte.hu, vatsa@in.ibm.com
Subject: [PATCH] Report usage in CFS cgroup
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Message-Id: <20071029171908.A4633465FDC@localhost>
Date: Mon, 29 Oct 2007 13:19:08 -0400 (EDT)
From: menage@google.com (Paul Menage)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Report CPU usage in CFS Cgroup directories

Adds a cpu.usage file to the CFS cgroup that reports CPU usage in
milliseconds for that cgroup's tasks

Signed-off-by: Paul Menage <menage@google.com>

---
 kernel/sched.c |   36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

Index: container-2.6.23-mm1/kernel/sched.c
===================================================================
--- container-2.6.23-mm1.orig/kernel/sched.c
+++ container-2.6.23-mm1/kernel/sched.c
@@ -7005,15 +7005,41 @@ static u64 cpu_shares_read_uint(struct c
 	return (u64) tg->shares;
 }
 
-static struct cftype cpu_shares = {
-	.name = "shares",
-	.read_uint = cpu_shares_read_uint,
-	.write_uint = cpu_shares_write_uint,
+static u64 cpu_usage_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	struct task_group *tg = cgroup_tg(cgrp);
+	int i;
+	u64 res = 0;
+	for_each_possible_cpu(i) {
+		unsigned long flags;
+		/*
+		 * Lock to prevent races with updating 64-bit counters
+		 * on 32-bit arches.
+		 */
+		spin_lock_irqsave(&cpu_rq(i)->lock, flags);
+		res += tg->se[i]->sum_exec_runtime;
+		spin_unlock_irqrestore(&cpu_rq(i)->lock, flags);
+	}
+	/* Convert from ns to ms */
+	do_div(res, 1000000);
+	return res;
+}
+
+static struct cftype cpu_files[] = {
+	{
+		.name = "shares",
+		.read_uint = cpu_shares_read_uint,
+		.write_uint = cpu_shares_write_uint,
+	},
+	{
+		.name = "usage",
+		.read_uint = cpu_usage_read,
+	},
 };
 
 static int cpu_cgroup_populate(struct cgroup_subsys *ss, struct cgroup *cont)
 {
-	return cgroup_add_file(cont, ss, &cpu_shares);
+	return cgroup_add_files(cont, ss, cpu_files, ARRAY_SIZE(cpu_files));
 }
 
 struct cgroup_subsys cpu_cgroup_subsys = {
