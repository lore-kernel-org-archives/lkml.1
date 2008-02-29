Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbYB2Eij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbYB2Eij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 23:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbYB2Eia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 23:38:30 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:51281 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbYB2Eia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 23:38:30 -0500
Message-Id: <20080229043751.555866685@linux.vnet.ibm.com>
References: <20080229043242.110741439@linux.vnet.ibm.com>
User-Agent: quilt/0.45-1
Date: Fri, 29 Feb 2008 10:02:44 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: vatsa@linux.vnet.ibm.com, menage@google.com, balbir@linux.vnet.ibm.com,
       mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, skumar@linux.vnet.ibm.com
Subject: [patch 2/2] sched: allow cpuacct stats to be reset
Content-Disposition: inline; filename=allow-reset-of-sched-stats.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the schedstats implementation does not allow the statistics
to be reset. This patch aims to allow that.

echo 0 > cpuacct.usage

resets the usage. Any other value is not allowed and returns -EINVAL.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

---
 kernel/sched.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c	2008-02-28 20:05:27.000000000 +0530
+++ linux-2.6/kernel/sched.c	2008-02-28 20:05:30.000000000 +0530
@@ -8243,10 +8243,34 @@ static u64 cpuusage_read(struct cgroup *
 	return totalcpuusage;
 }
 
+static int cpuusage_write(struct cgroup *cgrp, struct cftype *cftype,
+								u64 reset)
+{
+	struct cpuacct *ca = cgroup_ca(cgrp);
+	int err = 0;
+	int i;
+
+	if (reset) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	for_each_possible_cpu(i) {
+		u64 *cpuusage = percpu_ptr(ca->cpuusage, i);
+
+		spin_lock_irq(&cpu_rq(i)->lock);
+		*cpuusage = 0;
+		spin_unlock_irq(&cpu_rq(i)->lock);
+	}
+out:
+	return err;
+}
+
 static struct cftype files[] = {
 	{
 		.name = "usage",
 		.read_uint = cpuusage_read,
+		.write_uint = cpuusage_write,
 	},
 };
 

--
regards,
Dhaval

