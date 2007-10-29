Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbXJ2QZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbXJ2QZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 12:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758511AbXJ2QZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 12:25:27 -0400
Received: from smtp-out.google.com ([216.239.45.13]:45209 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbXJ2QZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 12:25:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:
	x-accept-language:mime-version:to:cc:subject:content-type:content-transfer-encoding;
	b=Q0wEvBvKBvxiBpCisO0tj1bRqqxnKECVpuTucliGMA3DXdjpUYpZa9RbT2DYayYi3
	XiCzdzbAR+DWQ8mBs4y7g==
Message-ID: <47260960.2050200@google.com>
Date: Mon, 29 Oct 2007 12:25:04 -0400
From: Paul Menage <menage@google.com>
User-Agent: Mozilla Thunderbird 1.0.8 (X11/20060725)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Report usage in CFS cgroup
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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
