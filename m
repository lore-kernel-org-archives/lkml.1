Return-Path: <linux-kernel-owner+w=401wt.eu-S1758620AbXHWDHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbXHWDHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 23:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755944AbXHWDHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 23:07:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51053 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998AbXHWDHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 23:07:13 -0400
Date: Thu, 23 Aug 2007 08:50:02 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Zou Nan hai <nanhai.zou@intel.com>
cc: Dave Jones <davej@codemonkey.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpufreq_stats: Misc cpuinit section annotations
Message-ID: <alpine.LFD.0.999.0708230841060.2049@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Stop referencing the callback directly from the __init and __exit
  functions of this driver, and instead explicitly call
  cpufreq_update_policy() et al. This enables the callback function
  to be marked as __cpuinit (and the notifier_block __cpuinitdata),
  thereby saving space when HOTPLUG_CPU=n. This also enables us to
  use other tricks to replace __cpuinit{data} in future.

* cpufreq_stats_free_table() is only called from __cpuinit or __exit
  marked functions, making it an ideal candidate for __cpuexit.

* Undo some 80-column extremism which was leading to the description
  of this module to being incorrectly printed with /sbin/modinfo :-(

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 drivers/cpufreq/cpufreq_stats.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 917b9ba..ed08157 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -164,8 +164,7 @@ freq_table_get_index(struct cpufreq_stats *stat, unsigned int freq)
 	return -1;
 }
 
-static void
-cpufreq_stats_free_table (unsigned int cpu)
+static void __cpuexit cpufreq_stats_free_table(unsigned int cpu)
 {
 	struct cpufreq_stats *stat = cpufreq_stats_table[cpu];
 	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
@@ -305,8 +304,9 @@ cpufreq_stat_notifier_trans (struct notifier_block *nb, unsigned long val,
 	return 0;
 }
 
-static int cpufreq_stat_cpu_callback(struct notifier_block *nfb,
-					unsigned long action, void *hcpu)
+static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
+					       unsigned long action,
+					       void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
 
@@ -323,7 +323,7 @@ static int cpufreq_stat_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block cpufreq_stat_cpu_notifier =
+static struct notifier_block cpufreq_stat_cpu_notifier __cpuinitdata =
 {
 	.notifier_call = cpufreq_stat_cpu_callback,
 };
@@ -356,8 +356,7 @@ __init cpufreq_stats_init(void)
 
 	register_hotcpu_notifier(&cpufreq_stat_cpu_notifier);
 	for_each_online_cpu(cpu) {
-		cpufreq_stat_cpu_callback(&cpufreq_stat_cpu_notifier,
-				CPU_ONLINE, (void *)(long)cpu);
+		cpufreq_update_policy(cpu);
 	}
 	return 0;
 }
@@ -372,14 +371,12 @@ __exit cpufreq_stats_exit(void)
 			CPUFREQ_TRANSITION_NOTIFIER);
 	unregister_hotcpu_notifier(&cpufreq_stat_cpu_notifier);
 	for_each_online_cpu(cpu) {
-		cpufreq_stat_cpu_callback(&cpufreq_stat_cpu_notifier,
-						CPU_DEAD, (void *)(long)cpu);
+		cpufreq_stats_free_table(cpu);
 	}
 }
 
 MODULE_AUTHOR ("Zou Nan hai <nanhai.zou@intel.com>");
-MODULE_DESCRIPTION ("'cpufreq_stats' - A driver to export cpufreq stats"
-				"through sysfs filesystem");
+MODULE_DESCRIPTION ("'cpufreq_stats' - A driver to export cpufreq stats through sysfs filesystem");
 MODULE_LICENSE ("GPL");
 
 module_init(cpufreq_stats_init);
