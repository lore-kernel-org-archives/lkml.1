Return-Path: <linux-kernel-owner+w=401wt.eu-S1757015AbZFYSoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015AbZFYSoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 14:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbZFYSnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 14:43:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:56393 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbZFYSnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 14:43:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,292,1243839600"; 
   d="scan'208";a="425367199"
Message-Id: <20090625183601.300706000@intel.com>
References: <20090625183354.491259000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 25 Jun 2009 11:33:55 -0700
From: venkatesh.pallipadi@intel.com
To: "Dave Jones" <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       kernel-testers@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Dave Young" <hidave.darkstar@gmail.com>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Thomas Renninger" <trenn@suse.de>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>
Subject: [patch 1/3] cpufreq: remove rwsem lock from CPUFREQ_GOV_STOP call (second call site)
Content-Disposition: inline; filename=0001-remove-rwsem-lock-from-CPUFREQ_GOV_STOP-call-second.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

commit	42a06f2166f2f6f7bf04f32b4e823eacdceafdc9

Missed a call site for CPUFREQ_GOV_STOP to remove the rwlock taken around the
teardown. To make a long story short, the rwlock write-lock causes a circular
dependency with cancel_delayed_work_sync(), because the timer handler takes the
write lock.

Note that all callers to __cpufreq_set_policy are taking the rwsem. All sysfs
callers (writers) hold the write rwsem at the earliest sysfs calling stage.

However, the rwlock write-lock is not needed upon governor stop.

Change :
- Added comment from Venki at lock definition site.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 drivers/cpufreq/cpufreq.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 6e2ec0b..728656c 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -61,6 +61,8 @@ static DEFINE_SPINLOCK(cpufreq_driver_lock);
  *   are concerned with are online after they get the lock.
  * - Governor routines that can be called in cpufreq hotplug path should not
  *   take this sem as top level hotplug notifier handler takes this.
+ * - Lock should not be held across
+ *     __cpufreq_governor(data, CPUFREQ_GOV_STOP);
  */
 static DEFINE_PER_CPU(int, policy_cpu);
 static DEFINE_PER_CPU(struct rw_semaphore, cpu_policy_rwsem);
@@ -1697,8 +1699,17 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
 			dprintk("governor switch\n");
 
 			/* end old governor */
-			if (data->governor)
+			if (data->governor) {
+				/*
+				 * Need to release the rwsem around governor
+				 * stop due to lock dependency between
+				 * cancel_delayed_work_sync and the read lock
+				 * taken in the delayed work handler.
+				 */
+				unlock_policy_rwsem_write(data->cpu);
 				__cpufreq_governor(data, CPUFREQ_GOV_STOP);
+				lock_policy_rwsem_write(data->cpu);
+			}
 
 			/* start new governor */
 			data->governor = policy->governor;
-- 
1.6.0.6

-- 

