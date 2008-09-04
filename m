Return-Path: <linux-kernel-owner+w=401wt.eu-S1757226AbYIDNx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbYIDNx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 09:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYIDNwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 09:52:49 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:59141
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756163AbYIDNws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 09:52:48 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/4] Revert "[PATCH] sched: remove cache_hot_time"
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: peterz@infradead.org, Lin Ming <ming.m.lin@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, mingo@elte.hu
Date: Thu, 04 Sep 2008 09:50:23 -0400
Message-ID: <20080904135023.26109.82702.stgit@dev.haskins.net>
In-Reply-To: <20080904134959.26109.90529.stgit@dev.haskins.net>
References: <20080904134959.26109.90529.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 362a7016637648c6aefc98b706298baedfaa1543.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/sched.h    |    1 +
 include/linux/topology.h |    1 +
 kernel/sched.c           |    8 +++++---
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index cfb0d87..5619f3c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -777,6 +777,7 @@ struct sched_domain {
 	unsigned long max_interval;	/* Maximum balance interval ms */
 	unsigned int busy_factor;	/* less balancing by factor if busy */
 	unsigned int imbalance_pct;	/* No balance until over watermark */
+	unsigned long long cache_hot_time; /* Task considered cache hot (ns) */
 	unsigned int cache_nice_tries;	/* Leave cache hot tasks for # tries */
 	unsigned int busy_idx;
 	unsigned int idle_idx;
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 2158fc0..f6a7928 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -162,6 +162,7 @@ void arch_update_cpu_topology(void);
 	.max_interval		= 64*num_online_cpus(),	\
 	.busy_factor		= 128,			\
 	.imbalance_pct		= 133,			\
+	.cache_hot_time		= (10*1000000),		\
 	.cache_nice_tries	= 1,			\
 	.busy_idx		= 3,			\
 	.idle_idx		= 3,			\
diff --git a/kernel/sched.c b/kernel/sched.c
index 9a1ddb8..0ca5218 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6223,7 +6223,7 @@ set_table_entry(struct ctl_table *entry,
 static struct ctl_table *
 sd_alloc_ctl_domain_table(struct sched_domain *sd)
 {
-	struct ctl_table *table = sd_alloc_ctl_entry(12);
+	struct ctl_table *table = sd_alloc_ctl_entry(13);
 
 	if (table == NULL)
 		return NULL;
@@ -6249,9 +6249,11 @@ sd_alloc_ctl_domain_table(struct sched_domain *sd)
 	set_table_entry(&table[9], "cache_nice_tries",
 		&sd->cache_nice_tries,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[10], "flags", &sd->flags,
+	set_table_entry(&table[10], "cache_hot_time", &sd->cache_hot_time,
+		sizeof(long long), 0644, proc_doulongvec_minmax);
+	set_table_entry(&table[11], "flags", &sd->flags,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	/* &table[11] is terminator */
+	/* &table[12] is terminator */
 
 	return table;
 }

