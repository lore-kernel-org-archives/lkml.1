Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab0CDIYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 03:24:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796Ab0CDIYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 03:24:18 -0500
Date: Thu, 4 Mar 2010 03:23:36 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       Amerigo Wang <amwang@redhat.com>,
       Johannes Berg <johannes@sipsolutions.net>, akpm@linux-foundation.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Message-Id: <20100304082712.5251.72928.sendpatchset@localhost.localdomain>
Subject: [Patch 1/2] cpufreq: unexport (un)lock_policy_rwsem* functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


lock_policy_rwsem_* and unlock_policy_rwsem_* functions are scheduled
to be unexported when 2.6.33. Now there are no other callers of them
out of cpufreq.c, unexport them and make them static.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@redhat.com>

---
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 73ef30d..13b338f 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -381,16 +381,6 @@ Who:	Eric Paris <eparis@redhat.com>
 
 ----------------------------
 
-What:	lock_policy_rwsem_* and unlock_policy_rwsem_* will not be
-	exported interface anymore.
-When:	2.6.33
-Why:	cpu_policy_rwsem has a new cleaner definition making it local to
-	cpufreq core and contained inside cpufreq.c. Other dependent
-	drivers should not use it in order to safely avoid lockdep issues.
-Who:	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
-
-----------------------------
-
 What:	sound-slot/service-* module aliases and related clutters in
 	sound/sound_core.c
 When:	August 2010
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 67bc2ec..4de1e5f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -68,7 +68,7 @@ static DEFINE_PER_CPU(int, cpufreq_policy_cpu);
 static DEFINE_PER_CPU(struct rw_semaphore, cpu_policy_rwsem);
 
 #define lock_policy_rwsem(mode, cpu)					\
-int lock_policy_rwsem_##mode						\
+static int lock_policy_rwsem_##mode					\
 (int cpu)								\
 {									\
 	int policy_cpu = per_cpu(cpufreq_policy_cpu, cpu);		\
@@ -83,26 +83,22 @@ int lock_policy_rwsem_##mode						\
 }
 
 lock_policy_rwsem(read, cpu);
-EXPORT_SYMBOL_GPL(lock_policy_rwsem_read);
 
 lock_policy_rwsem(write, cpu);
-EXPORT_SYMBOL_GPL(lock_policy_rwsem_write);
 
-void unlock_policy_rwsem_read(int cpu)
+static void unlock_policy_rwsem_read(int cpu)
 {
 	int policy_cpu = per_cpu(cpufreq_policy_cpu, cpu);
 	BUG_ON(policy_cpu == -1);
 	up_read(&per_cpu(cpu_policy_rwsem, policy_cpu));
 }
-EXPORT_SYMBOL_GPL(unlock_policy_rwsem_read);
 
-void unlock_policy_rwsem_write(int cpu)
+static void unlock_policy_rwsem_write(int cpu)
 {
 	int policy_cpu = per_cpu(cpufreq_policy_cpu, cpu);
 	BUG_ON(policy_cpu == -1);
 	up_write(&per_cpu(cpu_policy_rwsem, policy_cpu));
 }
-EXPORT_SYMBOL_GPL(unlock_policy_rwsem_write);
 
 
 /* internal prototypes */
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 4de02b1..7a4a5ff 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -196,11 +196,6 @@ extern int __cpufreq_driver_getavg(struct cpufreq_policy *policy,
 int cpufreq_register_governor(struct cpufreq_governor *governor);
 void cpufreq_unregister_governor(struct cpufreq_governor *governor);
 
-int lock_policy_rwsem_read(int cpu);
-int lock_policy_rwsem_write(int cpu);
-void unlock_policy_rwsem_read(int cpu);
-void unlock_policy_rwsem_write(int cpu);
-
 
 /*********************************************************************
  *                      CPUFREQ DRIVER INTERFACE                     *
