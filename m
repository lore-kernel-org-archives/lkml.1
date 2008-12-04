Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbYLDEs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbYLDEs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 23:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbYLDEsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 23:48:17 -0500
Received: from smtp-out.google.com ([216.239.45.13]:21198 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbYLDEsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 23:48:17 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:content-transfer-encoding;
	b=VTOSI/uRqQWCV179rwBSDxD0Ru3h0zDAzOu54AYIt/jsHn3pp45dYai9vQEVw2ZTq
	qozHOdHESlG7Kbg+AFMNw==
MIME-Version: 1.0
Date: Wed, 3 Dec 2008 20:48:13 -0800
Message-ID: <b040c32a0812032048x4a11dc26k184a4b279b509050@mail.gmail.com>
Subject: [patch] export percpu cpuacct cgroup stats
From: Ken Chen <kenchen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch export per-cpu CPU cycle usage for a given cpuacct cgroup.
There is a need for a user space monitor daemon to track group CPU
usage on per-cpu base.  It is also useful for monitor CFS load
balancer behavior by tracking per CPU group usage.


Signed-off-by: Ken Chen <kenchen@google.com>

diff --git a/kernel/sched.c b/kernel/sched.c
index b7480fb..cd78948 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9345,12 +9345,34 @@ out:
 	return err;
 }

+static int cpuacct_percpu_seq_read(struct cgroup *cgroup, struct cftype *cft,
+				   struct seq_file *m)
+{
+	struct cpuacct *ca = cgroup_ca(cgroup);
+	u64 percpu;
+	int i;
+
+	for_each_possible_cpu(i) {
+		spin_lock_irq(&cpu_rq(i)->lock);
+		percpu = *percpu_ptr(ca->cpuusage, i);
+		spin_unlock_irq(&cpu_rq(i)->lock);
+		seq_printf(m, "%lld ", percpu);
+	}
+	seq_printf(m, "\n");
+	return 0;
+}
+
 static struct cftype files[] = {
 	{
 		.name = "usage",
 		.read_u64 = cpuusage_read,
 		.write_u64 = cpuusage_write,
 	},
+	{
+		.name = "percpu",
+		.read_seq_string = cpuacct_percpu_seq_read,
+	},
+
 };

 static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
