Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbZEFOSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbZEFOSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 10:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755975AbZEFOR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:17:56 -0400
Received: from wa4ehsobe003.messaging.microsoft.com ([216.32.181.13]:30689
	"EHLO WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753778AbZEFORz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:17:55 -0400
X-BigFish: VPS-15(zz1803O936eQ4015L1442Jzz1202hzzz32i6bh15fn61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KJ87PG-02-E0Y-01
Date: Wed, 6 May 2009 16:17:20 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: davej@redhat.com
CC: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: [PATCH] cpufreq: shorten names for cpufreq workqueues
Message-ID: <20090506141720.GU28728@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 06 May 2009 14:17:44.0629 (UTC) FILETIME=[6C992E50:01C9CE55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The names for workqueues are restricted to 15 characters (plus
terminating zero). Due to TASK_COMM_LEN==16, see
include/linux/sched.h.

This implies that for "kconservative"-workqueues for CPU numbers
greater than 10 the names get truncated, e.g.

 # ps x | grep kconservative
 1575 ?        S<     0:00 [kconservative/1]
 1576 ?        S<     0:00 [kconservative/2]
 1577 ?        S<     0:00 [kconservative/3]
 1578 ?        S<     0:00 [kconservative/4]
 1579 ?        S<     0:00 [kconservative/5]
 1580 ?        S<     0:00 [kconservative/6]
 1581 ?        S<     0:00 [kconservative/7]
 1582 ?        S<     0:00 [kconservative/8]
 1583 ?        S<     0:00 [kconservative/9]
 1584 ?        S<     0:00 [kconservative/1]
 1585 ?        S<     0:00 [kconservative/1]
 1586 ?        S<     0:00 [kconservative/1]
 1587 ?        S<     0:00 [kconservative/1]
 1588 ?        S<     0:00 [kconservative/1]
 1589 ?        S<     0:00 [kconservative/1]
 1590 ?        S<     0:00 [kconservative/1]
 1591 ?        S<     0:00 [kconservative/1]
 1592 ?        S<     0:00 [kconservative/1]
 1593 ?        S<     0:00 [kconservative/1]
 1594 ?        S<     0:00 [kconservative/2]
 1595 ?        S<     0:00 [kconservative/2]
 1597 ?        S<     0:00 [kconservative/2]

Same is true for top output and of course for information in
/proc/<pid> for those kernel threads. That is no big issue but
at least "unesthetic".

Instead of increasing TASK_COMM_LEN (and thus increasing size of
task_struct) I suggest to shorten the names of those workqueues by
ommitting the leading "k" which doesn't add much value to the
workqueue name anyway. This allows proper naming of workqueues up to
100 CPUs and should suffice for a while.

I also remove the leading "k" from the identifier of conservative
workqueue. And for uniformity I similarly change identifier and name
for ondemand workqueues. The new workqueue names are

 # ps x | grep "ond\|cons"
 1568 ?        S<     0:00 [ondemand/0]
 1569 ?        S<     0:00 [ondemand/1]
 ...
 1590 ?        S<     0:00 [ondemand/22]
 1591 ?        S<     0:00 [ondemand/23]
 1592 ?        S<     0:00 [conservative/0]
 1593 ?        S<     0:00 [conservative/1]
  ...
 1614 ?        S<     0:00 [conservative/22]
 1615 ?        S<     0:00 [conservative/23]

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 drivers/cpufreq/cpufreq_conservative.c |   16 ++++++++--------
 drivers/cpufreq/cpufreq_ondemand.c     |   16 ++++++++--------
 2 files changed, 16 insertions(+), 16 deletions(-)

Patch is against v2.6.30-rc4-289-g83e9854.
Please apply.

Thanks,
Andreas


diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 2ecd95e..38ac028 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -94,7 +94,7 @@ static unsigned int dbs_enable;	/* number of CPUs using this policy */
  */
 static DEFINE_MUTEX(dbs_mutex);
 
-static struct workqueue_struct	*kconservative_wq;
+static struct workqueue_struct	*conservative_wq;
 
 static struct dbs_tuners {
 	unsigned int sampling_rate;
@@ -523,7 +523,7 @@ static void do_dbs_timer(struct work_struct *work)
 
 	dbs_check_cpu(dbs_info);
 
-	queue_delayed_work_on(cpu, kconservative_wq, &dbs_info->work, delay);
+	queue_delayed_work_on(cpu, conservative_wq, &dbs_info->work, delay);
 	unlock_policy_rwsem_write(cpu);
 }
 
@@ -535,7 +535,7 @@ static inline void dbs_timer_init(struct cpu_dbs_info_s *dbs_info)
 
 	dbs_info->enable = 1;
 	INIT_DELAYED_WORK_DEFERRABLE(&dbs_info->work, do_dbs_timer);
-	queue_delayed_work_on(dbs_info->cpu, kconservative_wq, &dbs_info->work,
+	queue_delayed_work_on(dbs_info->cpu, conservative_wq, &dbs_info->work,
 				delay);
 }
 
@@ -664,15 +664,15 @@ static int __init cpufreq_gov_dbs_init(void)
 {
 	int err;
 
-	kconservative_wq = create_workqueue("kconservative");
-	if (!kconservative_wq) {
-		printk(KERN_ERR "Creation of kconservative failed\n");
+	conservative_wq = create_workqueue("conservative");
+	if (!conservative_wq) {
+		printk(KERN_ERR "Creation of conservative workqueue failed\n");
 		return -EFAULT;
 	}
 
 	err = cpufreq_register_governor(&cpufreq_gov_conservative);
 	if (err)
-		destroy_workqueue(kconservative_wq);
+		destroy_workqueue(conservative_wq);
 
 	return err;
 }
@@ -680,7 +680,7 @@ static int __init cpufreq_gov_dbs_init(void)
 static void __exit cpufreq_gov_dbs_exit(void)
 {
 	cpufreq_unregister_governor(&cpufreq_gov_conservative);
-	destroy_workqueue(kconservative_wq);
+	destroy_workqueue(conservative_wq);
 }
 
 
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 338f428..6ff3ca0 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -101,7 +101,7 @@ static unsigned int dbs_enable;	/* number of CPUs using this policy */
  */
 static DEFINE_MUTEX(dbs_mutex);
 
-static struct workqueue_struct	*kondemand_wq;
+static struct workqueue_struct	*ondemand_wq;
 
 static struct dbs_tuners {
 	unsigned int sampling_rate;
@@ -541,7 +541,7 @@ static void do_dbs_timer(struct work_struct *work)
 		__cpufreq_driver_target(dbs_info->cur_policy,
 			dbs_info->freq_lo, CPUFREQ_RELATION_H);
 	}
-	queue_delayed_work_on(cpu, kondemand_wq, &dbs_info->work, delay);
+	queue_delayed_work_on(cpu, ondemand_wq, &dbs_info->work, delay);
 	unlock_policy_rwsem_write(cpu);
 }
 
@@ -555,7 +555,7 @@ static inline void dbs_timer_init(struct cpu_dbs_info_s *dbs_info)
 	ondemand_powersave_bias_init();
 	dbs_info->sample_type = DBS_NORMAL_SAMPLE;
 	INIT_DELAYED_WORK_DEFERRABLE(&dbs_info->work, do_dbs_timer);
-	queue_delayed_work_on(dbs_info->cpu, kondemand_wq, &dbs_info->work,
+	queue_delayed_work_on(dbs_info->cpu, ondemand_wq, &dbs_info->work,
 		delay);
 }
 
@@ -677,14 +677,14 @@ static int __init cpufreq_gov_dbs_init(void)
 					MICRO_FREQUENCY_DOWN_DIFFERENTIAL;
 	}
 
-	kondemand_wq = create_workqueue("kondemand");
-	if (!kondemand_wq) {
-		printk(KERN_ERR "Creation of kondemand failed\n");
+	ondemand_wq = create_workqueue("ondemand");
+	if (!ondemand_wq) {
+		printk(KERN_ERR "Creation of ondemand workqueue failed\n");
 		return -EFAULT;
 	}
 	err = cpufreq_register_governor(&cpufreq_gov_ondemand);
 	if (err)
-		destroy_workqueue(kondemand_wq);
+		destroy_workqueue(ondemand_wq);
 
 	return err;
 }
@@ -692,7 +692,7 @@ static int __init cpufreq_gov_dbs_init(void)
 static void __exit cpufreq_gov_dbs_exit(void)
 {
 	cpufreq_unregister_governor(&cpufreq_gov_ondemand);
-	destroy_workqueue(kondemand_wq);
+	destroy_workqueue(ondemand_wq);
 }
 
 
-- 
1.6.2



