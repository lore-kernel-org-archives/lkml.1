Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbYH2UL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbYH2UL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 16:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbYH2ULs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 16:11:48 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3774 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbYH2ULr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 16:11:47 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5373"; a="6151522"
From: Max Krasnyansky <maxk@qualcomm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Max Krasnyansky <maxk@qualcomm.com>,
       svaidy@linux.vnet.ibm.com, peterz@infradead.org
Subject: [PATCH] sched: arch_reinit_sched_domains() must destroy domains to force rebuild
Date: Fri, 29 Aug 2008 13:11:41 -0700
Message-Id: <1220040701-3139-1-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What I realized recently is that calling rebuild_sched_domains() in
arch_reinit_sched_domains() by itself is not enough when cpusets are enabled.
partition_sched_domains() code is trying to avoid unnecessary domain rebuilds
and will not actually rebuild anything if new domain masks match the old ones.

What this means is that doing
     echo 1 > /sys/devices/system/cpu/sched_mc_power_savings
on a system with cpusets enabled will not take affect untill something changes
in the cpuset setup (ie new sets created or deleted).

This patch fixes restore correct behaviour where domains must be rebuilt in
order to enable MC powersaving flags.

Test on quad-core Core2 box with both CONFIG_CPUSETS and !CONFIG_CPUSETS.
Also tested on dual-core Core2 laptop. Lockdep is happy and things are working
as expected.

Ingo, please apply.
btw We also need to push my other cpuset patch into mainline. We currently
calling rebuild_sched_domains() without cgroup lock which is bad. When I made
original sched: changes the assumption was that cpuset patch will also go in.
I'm talking about
	"cpuset: Rework sched domains and CPU hotplug handling"
It's been ACKed by Paul has been in the -tip for awhile now.

Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
Cc: svaidy@linux.vnet.ibm.com
Cc: peterz@infradead.org
Cc: mingo@elte.hu
---
 include/linux/cpuset.h |    2 +-
 kernel/sched.c         |   19 +++++++++++++------
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index e8f450c..2691926 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -160,7 +160,7 @@ static inline int current_cpuset_is_being_rebound(void)
 
 static inline void rebuild_sched_domains(void)
 {
-	partition_sched_domains(0, NULL, NULL);
+	partition_sched_domains(1, NULL, NULL);
 }
 
 #endif /* !CONFIG_CPUSETS */
diff --git a/kernel/sched.c b/kernel/sched.c
index 9a1ddb8..5a38540 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7637,24 +7637,27 @@ static int dattrs_equal(struct sched_domain_attr *cur, int idx_cur,
  * and partition_sched_domains() will fallback to the single partition
  * 'fallback_doms', it also forces the domains to be rebuilt.
  *
+ * If doms_new==NULL it will be replaced with cpu_online_map.
+ * ndoms_new==0 is a special case for destroying existing domains.
+ * It will not create the default domain.
+ *
  * Call with hotplug lock held
  */
 void partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
 			     struct sched_domain_attr *dattr_new)
 {
-	int i, j;
+	int i, j, n;
 
 	mutex_lock(&sched_domains_mutex);
 
 	/* always unregister in case we don't destroy any domains */
 	unregister_sched_domain_sysctl();
 
-	if (doms_new == NULL)
-		ndoms_new = 0;
+	n = doms_new ? ndoms_new : 0;
 
 	/* Destroy deleted domains */
 	for (i = 0; i < ndoms_cur; i++) {
-		for (j = 0; j < ndoms_new; j++) {
+		for (j = 0; j < n; j++) {
 			if (cpus_equal(doms_cur[i], doms_new[j])
 			    && dattrs_equal(dattr_cur, i, dattr_new, j))
 				goto match1;
@@ -7667,7 +7670,6 @@ match1:
 
 	if (doms_new == NULL) {
 		ndoms_cur = 0;
-		ndoms_new = 1;
 		doms_new = &fallback_doms;
 		cpus_andnot(doms_new[0], cpu_online_map, cpu_isolated_map);
 		dattr_new = NULL;
@@ -7704,8 +7706,13 @@ match2:
 int arch_reinit_sched_domains(void)
 {
 	get_online_cpus();
+
+	/* Destroy domains first to force the rebuild */
+	partition_sched_domains(0, NULL, NULL);
+
 	rebuild_sched_domains();
 	put_online_cpus();
+
 	return 0;
 }
 
@@ -7789,7 +7796,7 @@ static int update_sched_domains(struct notifier_block *nfb,
 	case CPU_ONLINE_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		partition_sched_domains(0, NULL, NULL);
+		partition_sched_domains(1, NULL, NULL);
 		return NOTIFY_OK;
 
 	default:
-- 
1.5.5.1

