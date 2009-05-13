Return-Path: <linux-kernel-owner+w=401wt.eu-S1760291AbZEMNLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291AbZEMNLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760176AbZEMNLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:11:24 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:51279 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759555AbZEMNLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:11:22 -0400
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 1/2] sched: add sched_max_capacity_pct
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 13 May 2009 18:41:12 +0530
Message-ID: <20090513131111.21440.68651.stgit@drishya.in.ibm.com>
In-Reply-To: <20090513130541.21440.33364.stgit@drishya.in.ibm.com>
References: <20090513130541.21440.33364.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new sysfs variable that can be used by user space
to pass the number of core to evacuate or force idle.

/sys/devices/system/cpu/sched_max_capacity_pct defaults to 100

This is percentage value that can be used to force idle cores.
The percentage number shall be in steps corresponding to number
of cores in the system.

On a 8 core system (dual socket quad core), each core step will
be 12.5% rounded to 12%.

Echoing 88 will use 7 cores in the system:

%	No of cores
100	8
87	7
75	6
62	5
50	4
...
...

This patch will evacuate only one package (50%) in ths case.

** This is a RFC patch for discussion ***

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 kernel/sched.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b902e58..f22b9f6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3291,6 +3291,9 @@ static inline int get_sd_load_idx(struct sched_domain *sd,
 
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
+
+int sched_evacuate_cores; /* No of forced-idle cores */
+
 /**
  * init_sd_power_savings_stats - Initialize power savings statistics for
  * the given sched_domain, during load balancing.
@@ -8604,6 +8607,37 @@ static ssize_t sched_mc_power_savings_store(struct sysdev_class *class,
 static SYSDEV_CLASS_ATTR(sched_mc_power_savings, 0644,
 			 sched_mc_power_savings_show,
 			 sched_mc_power_savings_store);
+
+static ssize_t sched_max_capacity_pct_show(struct sysdev_class *class,
+					   char *page)
+{
+	int capacity;
+	/* Convert no of cores to system capacity percentage */
+	/* FIXME: Will work only for non-threaded systems */
+	capacity = 100 - sched_evacuate_cores * 100 / nr_cpu_ids;
+	return sprintf(page, "%u\n", capacity);
+}
+static ssize_t sched_max_capacity_pct_store(struct sysdev_class *class,
+					    const char *buf, size_t count)
+{
+	int capacity;
+	if (!sscanf(buf, "%u", &capacity))
+		return -EINVAL;
+
+	if (capacity < 1 || capacity > 100)
+		return -EINVAL;
+
+	/* Convert user provided percentage into no-of-cores to evacuate */
+	/* FIXME: Will work only for non-threaded systems */
+	sched_evacuate_cores = (101 - capacity) * nr_cpu_ids / 100;
+	return count;
+}
+
+
+static SYSDEV_CLASS_ATTR(sched_max_capacity_pct, 0644,
+			 sched_max_capacity_pct_show,
+			 sched_max_capacity_pct_store);
+
 #endif
 
 #ifdef CONFIG_SCHED_SMT
@@ -8635,6 +8669,9 @@ int __init sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
 	if (!err && mc_capable())
 		err = sysfs_create_file(&cls->kset.kobj,
 					&attr_sched_mc_power_savings.attr);
+	if (!err)
+		err = sysfs_create_file(&cls->kset.kobj,
+					&attr_sched_max_capacity_pct.attr);
 #endif
 	return err;
 }

