Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbZHTNj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbZHTNj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbZHTNj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:39:28 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:13005
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754500AbZHTNj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:39:27 -0400
X-SpamScore: 14
X-BigFish: VPS14(z1857r34a4j8deizzz1202hzzz32i203h6bh63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KOOGLI-02-8DD-02
X-M-MSG: 
Date: Thu, 20 Aug 2009 15:39:14 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 8/15] sched: Add parameter sched_mn_power_savings to
	control MN domain sched policy
Message-ID: <20090820133914.GW29327@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090820131243.GO29327@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Aug 2009 13:39:15.0311 (UTC) FILETIME=[9BECB7F0:01CA219B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 include/linux/sched.h |    4 +++-
 kernel/sched.c        |   38 ++++++++++++++++++++++++++++++++------
 2 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3a1f8db..5755643 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -832,7 +832,9 @@ enum powersavings_balance_level {
 	MAX_POWERSAVINGS_BALANCE_LEVELS
 };
 
-extern int sched_mc_power_savings, sched_smt_power_savings;
+extern int sched_mn_power_savings;
+extern int sched_mc_power_savings;
+extern int sched_smt_power_savings;
 
 static inline int sd_balance_for_mc_power(void)
 {
diff --git a/kernel/sched.c b/kernel/sched.c
index 6cfc840..ebcda58 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8179,7 +8179,9 @@ static void sched_domain_node_span(int node, struct cpumask *span)
 }
 #endif /* CONFIG_NUMA */
 
-int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
+int sched_mn_power_savings = 0;
+int sched_mc_power_savings = 0;
+int sched_smt_power_savings = 0;
 
 /*
  * The cpus mask in sched_group and sched_domain hangs off the end.
@@ -9135,7 +9137,8 @@ static void arch_reinit_sched_domains(void)
 	put_online_cpus();
 }
 
-static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
+static ssize_t sched_power_savings_store(const char *buf, size_t count,
+					 enum sched_domain_level dl)
 {
 	unsigned int level = 0;
 
@@ -9152,16 +9155,34 @@ static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
 	if (level >= MAX_POWERSAVINGS_BALANCE_LEVELS)
 		return -EINVAL;
 
-	if (smt)
+	if (dl == SD_LV_SIBLING)
 		sched_smt_power_savings = level;
-	else
+	else if (dl == SD_LV_MC)
 		sched_mc_power_savings = level;
+	else if (dl == SD_LV_MN)
+		sched_mn_power_savings = level;
 
 	arch_reinit_sched_domains();
 
 	return count;
 }
 
+#ifdef CONFIG_SCHED_MN
+static ssize_t sched_mn_power_savings_show(struct sysdev_class *class,
+					   char *page)
+{
+	return sprintf(page, "%u\n", sched_mn_power_savings);
+}
+static ssize_t sched_mn_power_savings_store(struct sysdev_class *class,
+					    const char *buf, size_t count)
+{
+	return sched_power_savings_store(buf, count, SD_LV_MN);
+}
+static SYSDEV_CLASS_ATTR(sched_mn_power_savings, 0644,
+			 sched_mn_power_savings_show,
+			 sched_mn_power_savings_store);
+#endif
+
 #ifdef CONFIG_SCHED_MC
 static ssize_t sched_mc_power_savings_show(struct sysdev_class *class,
 					   char *page)
@@ -9171,7 +9192,7 @@ static ssize_t sched_mc_power_savings_show(struct sysdev_class *class,
 static ssize_t sched_mc_power_savings_store(struct sysdev_class *class,
 					    const char *buf, size_t count)
 {
-	return sched_power_savings_store(buf, count, 0);
+	return sched_power_savings_store(buf, count, SD_LV_MC);
 }
 static SYSDEV_CLASS_ATTR(sched_mc_power_savings, 0644,
 			 sched_mc_power_savings_show,
@@ -9187,7 +9208,7 @@ static ssize_t sched_smt_power_savings_show(struct sysdev_class *dev,
 static ssize_t sched_smt_power_savings_store(struct sysdev_class *dev,
 					     const char *buf, size_t count)
 {
-	return sched_power_savings_store(buf, count, 1);
+	return sched_power_savings_store(buf, count, SD_LV_SIBLING);
 }
 static SYSDEV_CLASS_ATTR(sched_smt_power_savings, 0644,
 		   sched_smt_power_savings_show,
@@ -9208,6 +9229,11 @@ int __init sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
 		err = sysfs_create_file(&cls->kset.kobj,
 					&attr_sched_mc_power_savings.attr);
 #endif
+#ifdef CONFIG_SCHED_MN
+	if (!err && mc_capable())
+		err = sysfs_create_file(&cls->kset.kobj,
+					&attr_sched_mn_power_savings.attr);
+#endif
 	return err;
 }
 #endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
-- 
1.6.0.4



