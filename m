Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbZESHjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbZESHjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 03:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753681AbZESHjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 03:39:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:4159 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968AbZESHjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 03:39:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,214,1241420400"; 
   d="scan'208";a="691632186"
Date: Tue, 19 May 2009 15:39:42 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: lenb@kernel.org, menage@google.com
Subject: [PATCH]cpuset: add new API to change cpuset top group's cpus
Message-ID: <20090519073942.GA10864@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI 4.0 defines processor aggregator device. The device can notify OS to idle
some CPUs to save power. This isn't to hot remove cpus, but just makes cpus
idle.

This patch adds one API to change cpuset top group's cpus. If we want to
make one cpu idle, simply remove the cpu from cpuset top group's cpu list,
then all tasks will be migrate to other cpus, and other tasks will not be
migrated to this cpu again. No functional changes.

We will use this API in new ACPI processor aggregator device driver later.

Signed-off-by: Shaohua Li<shaohua.li@intel.com>
---
 include/linux/cpuset.h |    5 +++++
 kernel/cpuset.c        |   27 ++++++++++++++++++++++++---
 2 files changed, 29 insertions(+), 3 deletions(-)

Index: linux/kernel/cpuset.c
===================================================================
--- linux.orig/kernel/cpuset.c	2009-05-12 16:27:16.000000000 +0800
+++ linux/kernel/cpuset.c	2009-05-19 10:05:36.000000000 +0800
@@ -929,14 +929,14 @@ static void update_tasks_cpumask(struct 
  * @buf: buffer of cpu numbers written to this cpuset
  */
 static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
-			  const char *buf)
+			  const char *buf, bool top_ok)
 {
 	struct ptr_heap heap;
 	int retval;
 	int is_load_balanced;
 
 	/* top_cpuset.cpus_allowed tracks cpu_online_map; it's read-only */
-	if (cs == &top_cpuset)
+	if (cs == &top_cpuset && !top_ok)
 		return -EACCES;
 
 	/*
@@ -1496,7 +1496,7 @@ static int cpuset_write_resmask(struct c
 
 	switch (cft->private) {
 	case FILE_CPULIST:
-		retval = update_cpumask(cs, trialcs, buf);
+		retval = update_cpumask(cs, trialcs, buf, false);
 		break;
 	case FILE_MEMLIST:
 		retval = update_nodemask(cs, trialcs, buf);
@@ -1511,6 +1511,27 @@ static int cpuset_write_resmask(struct c
 	return retval;
 }
 
+int cpuset_change_top_cpumask(const char *buf)
+{
+	int retval = 0;
+	struct cpuset *cs = &top_cpuset;
+	struct cpuset *trialcs;
+
+	if (!cgroup_lock_live_group(cs->css.cgroup))
+		return -ENODEV;
+
+	trialcs = alloc_trial_cpuset(cs);
+	if (!trialcs)
+		return -ENOMEM;
+
+	retval = update_cpumask(cs, trialcs, buf, true);
+
+	free_trial_cpuset(trialcs);
+	cgroup_unlock();
+	return retval;
+}
+EXPORT_SYMBOL(cpuset_change_top_cpumask);
+
 /*
  * These ascii lists should be read in a single call, by using a user
  * buffer large enough to hold the entire map.  If read in smaller
Index: linux/include/linux/cpuset.h
===================================================================
--- linux.orig/include/linux/cpuset.h	2009-05-12 16:27:15.000000000 +0800
+++ linux/include/linux/cpuset.h	2009-05-19 10:05:36.000000000 +0800
@@ -92,6 +92,7 @@ extern void rebuild_sched_domains(void);
 
 extern void cpuset_print_task_mems_allowed(struct task_struct *p);
 
+extern int cpuset_change_top_cpumask(const char *buf);
 #else /* !CONFIG_CPUSETS */
 
 static inline int cpuset_init_early(void) { return 0; }
@@ -188,6 +189,10 @@ static inline void cpuset_print_task_mem
 {
 }
 
+static inline int cpuset_change_top_cpumask(const char *buf)
+{
+	return -ENODEV;
+}
 #endif /* !CONFIG_CPUSETS */
 
 #endif /* _LINUX_CPUSET_H */
