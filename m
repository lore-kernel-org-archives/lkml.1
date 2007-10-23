Return-Path: <linux-kernel-owner+w=401wt.eu-S1751635AbXJWAuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbXJWAuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 20:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbXJWAtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 20:49:53 -0400
Received: from smtp-out.google.com ([216.239.45.13]:24608 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbXJWAtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 20:49:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:content-type:content-transfer-encoding;
	b=OI5JA5NwvUB8NYMx1ZEX8xyi1OJSCDIUjAXosuVQnnS5VLGu618Gaf9zX3gDaKwyE
	p/TiArQRJ8eHv6qDVZhgA==
Message-ID: <471D4523.4040509@google.com>
Date: Mon, 22 Oct 2007 17:49:39 -0700
From: Paul Menage <menage@google.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
CC: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] CFS CGroup: Report usage
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Report CPU usage in CFS Cgroup directories

Adds a cpu.usage file to the CFS cgroup that reports CPU usage in
milliseconds for that cgroup's tasks

This replaces the "example CPU Accounting CGroup subsystem" that
was merged into mainline last week.

Signed-off-by: Paul Menage <menage@google.com>

---
 kernel/sched.c |   32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

Index: container-2.6.23-mm1/kernel/sched.c
===================================================================
--- container-2.6.23-mm1.orig/kernel/sched.c
+++ container-2.6.23-mm1/kernel/sched.c
@@ -7005,15 +7005,37 @@ static u64 cpu_shares_read_uint(struct c
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
+		spin_lock_irqsave(&tg->cfs_rq[i]->rq->lock, flags);
+		res += tg->se[i]->sum_exec_runtime;
+		spin_unlock_irqrestore(&tg->cfs_rq[i]->rq->lock, flags);
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
