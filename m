Return-Path: <linux-kernel-owner+w=401wt.eu-S1757844AbZGCPcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844AbZGCPcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 11:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755914AbZGCPcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 11:32:45 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:51152 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492AbZGCPco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 11:32:44 -0400
X-Greylist: delayed 1044 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jul 2009 11:30:36 EDT
Message-Id: <20090703144351.012414124@polymtl.ca>
References: <20090703143705.997230857@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 03 Jul 2009 10:37:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@redhat.com>, Thomas Renninger <trenn@suse.de>,
       cpufreq@vger.kernel.org, kernel-testers@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, rjw@sisk.pl,
       Dave Young <hidave.darkstar@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Shaohua Li <shaohua.li@intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>, sven.wegener@stealer.net
Subject: [patch 2.6.30 1/4] remove rwsem lock from CPUFREQ_GOV_STOP call (second call site)
Content-Disposition: inline; filename=cpufreq-remove-rwsem-lock-from-CPUFREQ_GOV_STOP-call-missing-modification.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri,  3 Jul 2009 15:11:52 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit	42a06f2166f2f6f7bf04f32b4e823eacdceafdc9

Missed a call site for CPUFREQ_GOV_STOP to remove the rwlock taken around the
teardown. To make a long story short, the rwlock write-lock causes a circular
dependency with cancel_delayed_work_sync(), because the timer handler takes the
read lock.

Note that all callers to __cpufreq_set_policy are taking the rwsem. All sysfs
callers (writers) hold the write rwsem at the earliest sysfs calling stage.

However, the rwlock write-lock is not needed upon governor stop.

Change :
- Added comment from Venkyi at lock definition site.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
CC: rjw@sisk.pl
CC: mingo@elte.hu
CC: Shaohua Li <shaohua.li@intel.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Dave Young <hidave.darkstar@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: trenn@suse.de
CC: sven.wegener@stealer.net
CC: cpufreq@vger.kernel.org
---
 drivers/cpufreq/cpufreq.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/drivers/cpufreq/cpufreq.c
===================================================================
--- linux-2.6-lttng.orig/drivers/cpufreq/cpufreq.c	2009-06-08 12:47:22.000000000 -0400
+++ linux-2.6-lttng/drivers/cpufreq/cpufreq.c	2009-06-08 12:48:38.000000000 -0400
@@ -61,6 +61,8 @@ static DEFINE_SPINLOCK(cpufreq_driver_lo
  *   are concerned with are online after they get the lock.
  * - Governor routines that can be called in cpufreq hotplug path should not
  *   take this sem as top level hotplug notifier handler takes this.
+ * - Lock should not be held across
+ *     __cpufreq_governor(data, CPUFREQ_GOV_STOP);
  */
 static DEFINE_PER_CPU(int, policy_cpu);
 static DEFINE_PER_CPU(struct rw_semaphore, cpu_policy_rwsem);
@@ -1697,8 +1699,17 @@ static int __cpufreq_set_policy(struct c
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
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
