Return-Path: <linux-kernel-owner+w=401wt.eu-S1762812AbYD2NFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762812AbYD2NFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbYD2NFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:05:23 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:51133 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbYD2NFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:05:22 -0400
Date: Tue, 29 Apr 2008 18:35:05 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: linux-kernel@vger.kernel.org, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: [PATCH 8/8] cpufreq: Nest down_write/read(cpufreq_rwsem) within
	get_online_cpus()/put_online_cpus()
Message-ID: <20080429130505.GI23562@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080429125659.GA23562@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429125659.GA23562@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq: Nest down_write/read(cpufreq_rwsem) with get_online_cpus()

From: Gautham R Shenoy <ego@in.ibm.com>

On the CPU-Hotplug callback path, the cpufreq_rwsem has a dependency
with the cpu_hotplug lock. However on the read-path, this dependency is not
honoured resulting in a possible deadlock when one tries to change
the cpufreq governor when a CPU-Hotplug is in progress.

This patch nests the down_write/read(cpufreq_rwsem) with
get_online_cpus()/put_online_cpus() pair.

Also, it introduces a try_get_online_cpus() in the do_dbs_timer() work-item
code, since we cannot do get_online_cpus() from within work items.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 drivers/cpufreq/cpufreq.c          |   11 +++++++++--
 drivers/cpufreq/cpufreq_ondemand.c |    9 +++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 35a26a3..087f8fc 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -71,11 +71,12 @@ int lock_policy_rwsem_##mode						\
 {									\
 	int policy_cpu = per_cpu(policy_cpu, cpu);			\
 	BUG_ON(policy_cpu == -1);					\
-	down_##mode(&per_cpu(cpu_policy_rwsem, policy_cpu));		\
+	get_online_cpus();						\
 	if (unlikely(!cpu_online(cpu))) {				\
-		up_##mode(&per_cpu(cpu_policy_rwsem, policy_cpu));	\
+		put_online_cpus();					\
 		return -1;						\
 	}								\
+	down_##mode(&per_cpu(cpu_policy_rwsem, policy_cpu));		\
 									\
 	return 0;							\
 }
@@ -91,6 +92,7 @@ void unlock_policy_rwsem_read(int cpu)
 	int policy_cpu = per_cpu(policy_cpu, cpu);
 	BUG_ON(policy_cpu == -1);
 	up_read(&per_cpu(cpu_policy_rwsem, policy_cpu));
+	put_online_cpus();
 }
 EXPORT_SYMBOL_GPL(unlock_policy_rwsem_read);
 
@@ -99,6 +101,7 @@ void unlock_policy_rwsem_write(int cpu)
 	int policy_cpu = per_cpu(policy_cpu, cpu);
 	BUG_ON(policy_cpu == -1);
 	up_write(&per_cpu(cpu_policy_rwsem, policy_cpu));
+	put_online_cpus();
 }
 EXPORT_SYMBOL_GPL(unlock_policy_rwsem_write);
 
@@ -1818,7 +1821,9 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	cpufreq_driver = driver_data;
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
+	get_online_cpus();
 	ret = sysdev_driver_register(&cpu_sysdev_class,&cpufreq_sysdev_driver);
+	put_online_cpus();
 
 	if ((!ret) && !(cpufreq_driver->flags & CPUFREQ_STICKY)) {
 		int i;
@@ -1833,8 +1838,10 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 		if (ret) {
 			dprintk("no CPU initialized for driver %s\n",
 							driver_data->name);
+			get_online_cpus();
 			sysdev_driver_unregister(&cpu_sysdev_class,
 						&cpufreq_sysdev_driver);
+			put_online_cpus();
 
 			spin_lock_irqsave(&cpufreq_driver_lock, flags);
 			cpufreq_driver = NULL;
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index d2af20d..9428f7e 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -446,12 +446,15 @@ static void do_dbs_timer(struct work_struct *work)
 
 	delay -= jiffies % delay;
 
-	if (lock_policy_rwsem_write(cpu) < 0)
+	if (!try_get_online_cpus())
 		return;
 
+	if (lock_policy_rwsem_write(cpu) < 0)
+		goto out;
+
 	if (!dbs_info->enable) {
 		unlock_policy_rwsem_write(cpu);
-		return;
+		goto out;
 	}
 
 	/* Common NORMAL_SAMPLE setup */
@@ -471,6 +474,8 @@ static void do_dbs_timer(struct work_struct *work)
 	}
 	queue_delayed_work_on(cpu, kondemand_wq, &dbs_info->work, delay);
 	unlock_policy_rwsem_write(cpu);
+out:
+	put_online_cpus();
 }
 
 static inline void dbs_timer_init(struct cpu_dbs_info_s *dbs_info)
-- 
Thanks and Regards
gautham
