Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbYLPGCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbYLPGCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 01:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbYLPGCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 01:02:09 -0500
Received: from smtp-out.google.com ([216.239.45.13]:3401 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbYLPGCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 01:02:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:content-transfer-encoding;
	b=FaI8N5UlivaAQSQ+gAE2HzhWSUYdqgjCDE9c6kYrM3hUXjran2Vu+IMVyKescwtRO
	ILXTFd1c7M5zOL8LH/1gg==
MIME-Version: 1.0
Date: Mon, 15 Dec 2008 22:02:01 -0800
Message-ID: <b040c32a0812152202y4914ba88gbf0c9137d50a296a@mail.gmail.com>
Subject: [patch 1/2] cpuacct: refactoring cpuusage_read / cpuusage_write
From: Ken Chen <kenchen@google.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the thread regarding to 'export percpu cpuacct cgroup stats'
http://lkml.org/lkml/2008/12/7/13

akpm pointed out that current cpuacct code is inefficient.  This patch
refactoring the following:

* make cpu_rq locking only on 32-bit
* change iterator to each_present_cpu instead of each_possible_cpu to
  make it hotplug friendly.

It's a bit of code churn, but I was rewarded with 160 byte code size saving
on x86-64 arch and zero code size change on i386.


Signed-off-by: Ken Chen <kenchen@google.com>

diff --git a/kernel/sched.c b/kernel/sched.c
index e4bb1dd..124bd7a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9302,6 +9302,41 @@ cpuacct_destroy
 	kfree(ca);
 }

+static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu)
+{
+	u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
+	u64 data;
+
+#ifndef CONFIG_64BIT
+	/*
+	 * Take rq->lock to make 64-bit read safe on 32-bit platforms.
+	 */
+	spin_lock_irq(&cpu_rq(cpu)->lock);
+	data = *cpuusage;
+	spin_unlock_irq(&cpu_rq(cpu)->lock);
+#else
+	data = *cpuusage;
+#endif
+
+	return data;
+}
+
+static void cpuacct_cpuusage_write(struct cpuacct *ca, int cpu, u64 val)
+{
+	u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
+
+#ifndef CONFIG_64BIT
+	/*
+	 * Take rq->lock to make 64-bit write safe on 32-bit platforms.
+	 */
+	spin_lock_irq(&cpu_rq(cpu)->lock);
+	*cpuusage = val;
+	spin_unlock_irq(&cpu_rq(cpu)->lock);
+#else
+	*cpuusage = val;
+#endif
+}
+
 /* return total cpu usage (in nanoseconds) of a group */
 static u64 cpuusage_read(struct cgroup *cgrp, struct cftype *cft)
 {
@@ -9309,17 +9344,8 @@ static u64 cpuusage_read
 	u64 totalcpuusage = 0;
 	int i;

-	for_each_possible_cpu(i) {
-		u64 *cpuusage = percpu_ptr(ca->cpuusage, i);
-
-		/*
-		 * Take rq->lock to make 64-bit addition safe on 32-bit
-		 * platforms.
-		 */
-		spin_lock_irq(&cpu_rq(i)->lock);
-		totalcpuusage += *cpuusage;
-		spin_unlock_irq(&cpu_rq(i)->lock);
-	}
+	for_each_present_cpu(i)
+		totalcpuusage += cpuacct_cpuusage_read(ca, i);

 	return totalcpuusage;
 }
@@ -9336,13 +9362,9 @@ static int cpuusage_write
 		goto out;
 	}

-	for_each_possible_cpu(i) {
-		u64 *cpuusage = percpu_ptr(ca->cpuusage, i);
+	for_each_present_cpu(i)
+		cpuacct_cpuusage_write(ca, i, 0);

-		spin_lock_irq(&cpu_rq(i)->lock);
-		*cpuusage = 0;
-		spin_unlock_irq(&cpu_rq(i)->lock);
-	}
 out:
 	return err;
 }
