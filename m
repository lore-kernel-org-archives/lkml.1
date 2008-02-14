Return-Path: <linux-kernel-owner+w=401wt.eu-S1760863AbYBOJJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760863AbYBOJJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 04:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbYBOJJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 04:09:33 -0500
Received: from mga03.intel.com ([143.182.124.21]:11576 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbYBOJJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 04:09:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,357,1199692800"; 
   d="scan'208";a="379392771"
Subject: [PATCH 2.6.25-rc1] cpufreq: fix cpufreq policy refcount imbalance
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, gregkh@suse.de, davej@codemonkey.org.uk,
       mingo@elte.hu, cpufreq@lists.linux.org.uk,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <1201043126.3861.5.camel@yangyi-dev.bj.intel.com>
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>
	 <1201043126.3861.5.camel@yangyi-dev.bj.intel.com>
Content-Type: text/plain
Organization: Intel
Date: Fri, 15 Feb 2008 07:48:41 +0800
Message-Id: <1203032921.3897.10.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When one cpu is set to offline, the caller process will hang, according to
the trace data, the problem lies in the refcount error in cpufreq driver,
cpufreq_cpu_callback will wait for completion policy->kobj_unregister
which is nerver completed because a refcount error in function
__cpufreq_remove_dev in file driver/cpufreq/cpufreq.c results in not
calling kobject release method.

In driver/cpufreq/cpufreq.c, the refcount of data->kobj isn't 1 when it
will be unregistered, this problem didn't exist in 2.6.24 and earlier.

The root cause is kobject API switch, kobject_init_and_add and kobject_put
replace older kobject_register and kobject_unregister in 2.6.25-rc1,
compared to 2.6.24, kobject_unregister is deleted in function
__cpufreq_remove_dev but it isn't replaced with kobject_put.

This patch adds kobject_put to balance refcount. I noticed Greg suggests
it will fix a power-off issue to remove kobject_get statement block, but i
think that isn't the best way because those code block has existed very long
and it is helpful because the successive statements are invoking relevant
data.


Signed-off-by: Yi Yang <yi.y.yang@intel.com>
---
 cpufreq.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/cpufreq/cpufreq.c	2008-02-15 04:41:29.000000000 +0800
+++ b/drivers/cpufreq/cpufreq.c	2008-02-15 06:56:56.000000000 +0800
@@ -1057,12 +1057,17 @@ static int __cpufreq_remove_dev (struct 
 
 	unlock_policy_rwsem_write(cpu);
 
+	/* it matches the previous kobject_get */
 	kobject_put(&data->kobj);
 
 	/* we need to make sure that the underlying kobj is actually
 	 * not referenced anymore by anybody before we proceed with
 	 * unloading.
 	 */
+
+	/* unregister data->kobj, it matches kobject_init_and_add */
+	kobject_put(&data->kobj);
+
 	dprintk("waiting for dropping of refcount\n");
 	wait_for_completion(&data->kobj_unregister);
 	dprintk("wait complete\n");


