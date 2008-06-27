Return-Path: <linux-kernel-owner+w=401wt.eu-S1761612AbYF0PTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761612AbYF0PTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 11:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759950AbYF0PTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 11:19:05 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38540 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759860AbYF0PTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 11:19:02 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 27 Jun 2008 20:48:56 +0530
Message-Id: <20080627151856.31664.88305.sendpatchset@balbir-laptop>
In-Reply-To: <20080627151808.31664.36047.sendpatchset@balbir-laptop>
References: <20080627151808.31664.36047.sendpatchset@balbir-laptop>
Subject: [RFC 4/5] Memory controller soft limit resource counter additions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Add soft_limit is a parameter to the resource counters infrastructure.
Helper routines are also added to detect soft limit overflow.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 include/linux/res_counter.h |   35 +++++++++++++++++++++++++++++++----
 kernel/res_counter.c        |    2 ++
 mm/memcontrol.c             |    6 ++++++
 3 files changed, 39 insertions(+), 4 deletions(-)

diff -puN include/linux/res_counter.h~memory-controller-soft-limit-res-counter-updates include/linux/res_counter.h
--- linux-2.6.26-rc5/include/linux/res_counter.h~memory-controller-soft-limit-res-counter-updates	2008-06-27 20:43:10.000000000 +0530
+++ linux-2.6.26-rc5-balbir/include/linux/res_counter.h	2008-06-27 20:43:10.000000000 +0530
@@ -35,6 +35,12 @@ struct res_counter {
 	 */
 	unsigned long long limit;
 	/*
+	 * the limit that usage can exceed. When resource contention is
+	 * detected, the controller will try and pull back resources from
+	 * counters that have exceeded their soft limit.
+	 */
+	unsigned long long soft_limit;
+	/*
 	 * the number of unsuccessful attempts to consume the resource
 	 */
 	unsigned long long failcnt;
@@ -75,6 +81,7 @@ enum {
 	RES_USAGE,
 	RES_MAX_USAGE,
 	RES_LIMIT,
+	RES_SOFT_LIMIT,
 	RES_FAILCNT,
 };
 
@@ -113,11 +120,17 @@ int __must_check res_counter_charge(stru
 void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val);
 void res_counter_uncharge(struct res_counter *counter, unsigned long val);
 
-static inline bool res_counter_limit_check_locked(struct res_counter *cnt)
+static inline bool res_counter_limit_check_locked(struct res_counter *cnt,
+							int member)
 {
-	if (cnt->usage < cnt->limit)
+	switch (member) {
+	case RES_LIMIT:
+		if (cnt->usage < cnt->limit)
 		return true;
-
+	case RES_SOFT_LIMIT:
+		if (cnt->usage < cnt->soft_limit)
+		return true;
+	}
 	return false;
 }
 
@@ -131,7 +144,21 @@ static inline bool res_counter_check_und
 	unsigned long flags;
 
 	spin_lock_irqsave(&cnt->lock, flags);
-	ret = res_counter_limit_check_locked(cnt);
+	ret = res_counter_limit_check_locked(cnt, RES_LIMIT);
+	spin_unlock_irqrestore(&cnt->lock, flags);
+	return ret;
+}
+
+/*
+ * Helper function to detect if the cgroup is within it's soft limit
+ */
+static inline bool res_counter_check_under_soft_limit(struct res_counter *cnt)
+{
+	bool ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cnt->lock, flags);
+	ret = res_counter_limit_check_locked(cnt, RES_SOFT_LIMIT);
 	spin_unlock_irqrestore(&cnt->lock, flags);
 	return ret;
 }
diff -puN kernel/res_counter.c~memory-controller-soft-limit-res-counter-updates kernel/res_counter.c
--- linux-2.6.26-rc5/kernel/res_counter.c~memory-controller-soft-limit-res-counter-updates	2008-06-27 20:43:10.000000000 +0530
+++ linux-2.6.26-rc5-balbir/kernel/res_counter.c	2008-06-27 20:43:10.000000000 +0530
@@ -72,6 +72,8 @@ res_counter_member(struct res_counter *c
 		return &counter->max_usage;
 	case RES_LIMIT:
 		return &counter->limit;
+	case RES_SOFT_LIMIT:
+		return &counter->soft_limit;
 	case RES_FAILCNT:
 		return &counter->failcnt;
 	};
diff -puN mm/memcontrol.c~memory-controller-soft-limit-res-counter-updates mm/memcontrol.c
--- linux-2.6.26-rc5/mm/memcontrol.c~memory-controller-soft-limit-res-counter-updates	2008-06-27 20:43:10.000000000 +0530
+++ linux-2.6.26-rc5-balbir/mm/memcontrol.c	2008-06-27 20:43:10.000000000 +0530
@@ -972,6 +972,12 @@ static struct cftype mem_cgroup_files[] 
 		.read_u64 = mem_cgroup_read,
 	},
 	{
+		.name = "soft_limit_in_bytes",
+		.private = RES_SOFT_LIMIT,
+		.write = mem_cgroup_write,
+		.read_u64 = mem_cgroup_read,
+	},
+	{
 		.name = "failcnt",
 		.private = RES_FAILCNT,
 		.trigger = mem_cgroup_reset,
diff -puN include/linux/memcontrol.h~memory-controller-soft-limit-res-counter-updates include/linux/memcontrol.h
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
