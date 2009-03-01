Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbZCAGbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbZCAGbA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 01:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbZCAGaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 01:30:21 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:37607 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbZCAGaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 01:30:19 -0500
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Bharata B Rao <bharata@in.ibm.com>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Sun, 01 Mar 2009 12:00:11 +0530
Message-Id: <20090301063011.31557.42094.sendpatchset@localhost.localdomain>
In-Reply-To: <20090301062959.31557.31079.sendpatchset@localhost.localdomain>
References: <20090301062959.31557.31079.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/4] Memory controller soft limit interface (v3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Balbir Singh <balbir@linux.vnet.ibm.com>

Changelog v2...v1
1. Add support for res_counter_check_soft_limit_locked. This is used
   by the hierarchy code.

Add an interface to allow get/set of soft limits. Soft limits for memory plus
swap controller (memsw) is currently not supported. Resource counters have
been enhanced to support soft limits and new type RES_SOFT_LIMIT has been
added. Unlike hard limits, soft limits can be directly set and do not
need any reclaim or checks before setting them to a newer value.

Kamezawa-San raised a question as to whether soft limit should belong
to res_counter. Since all resources understand the basic concepts of
hard and soft limits, it is justified to add soft limits here. Soft limits
are a generic resource usage feature, even file system quotas support
soft limits.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 include/linux/res_counter.h |   47 +++++++++++++++++++++++++++++++++++++++++++
 kernel/res_counter.c        |    3 +++
 mm/memcontrol.c             |   20 ++++++++++++++++++
 3 files changed, 70 insertions(+), 0 deletions(-)


diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index 4c5bcf6..b5f14fa 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -35,6 +35,10 @@ struct res_counter {
 	 */
 	unsigned long long limit;
 	/*
+	 * the limit that usage can be exceed
+	 */
+	unsigned long long soft_limit;
+	/*
 	 * the number of unsuccessful attempts to consume the resource
 	 */
 	unsigned long long failcnt;
@@ -85,6 +89,7 @@ enum {
 	RES_MAX_USAGE,
 	RES_LIMIT,
 	RES_FAILCNT,
+	RES_SOFT_LIMIT,
 };
 
 /*
@@ -130,6 +135,36 @@ static inline bool res_counter_limit_check_locked(struct res_counter *cnt)
 	return false;
 }
 
+static inline bool res_counter_soft_limit_check_locked(struct res_counter *cnt)
+{
+	if (cnt->usage < cnt->soft_limit)
+		return true;
+
+	return false;
+}
+
+/**
+ * Get the difference between the usage and the soft limit
+ * @cnt: The counter
+ *
+ * Returns 0 if usage is less than or equal to soft limit
+ * The difference between usage and soft limit, otherwise.
+ */
+static inline unsigned long long
+res_counter_soft_limit_excess(struct res_counter *cnt)
+{
+	unsigned long long excess;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cnt->lock, flags);
+	if (cnt->usage <= cnt->soft_limit)
+		excess = 0;
+	else
+		excess = cnt->usage - cnt->soft_limit;
+	spin_unlock_irqrestore(&cnt->lock, flags);
+	return excess;
+}
+
 /*
  * Helper function to detect if the cgroup is within it's limit or
  * not. It's currently called from cgroup_rss_prepare()
@@ -178,4 +213,16 @@ static inline int res_counter_set_limit(struct res_counter *cnt,
 	return ret;
 }
 
+static inline int
+res_counter_set_soft_limit(struct res_counter *cnt,
+				unsigned long long soft_limit)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cnt->lock, flags);
+	cnt->soft_limit = soft_limit;
+	spin_unlock_irqrestore(&cnt->lock, flags);
+	return 0;
+}
+
 #endif
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index bf8e753..4e6dafe 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -19,6 +19,7 @@ void res_counter_init(struct res_counter *counter, struct res_counter *parent)
 {
 	spin_lock_init(&counter->lock);
 	counter->limit = (unsigned long long)LLONG_MAX;
+	counter->soft_limit = (unsigned long long)LLONG_MAX;
 	counter->parent = parent;
 }
 
@@ -101,6 +102,8 @@ res_counter_member(struct res_counter *counter, int member)
 		return &counter->limit;
 	case RES_FAILCNT:
 		return &counter->failcnt;
+	case RES_SOFT_LIMIT:
+		return &counter->soft_limit;
 	};
 
 	BUG();
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7bb14fd..75a7b1a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1939,6 +1939,20 @@ static int mem_cgroup_write(struct cgroup *cont, struct cftype *cft,
 		else
 			ret = mem_cgroup_resize_memsw_limit(memcg, val);
 		break;
+	case RES_SOFT_LIMIT:
+		ret = res_counter_memparse_write_strategy(buffer, &val);
+		if (ret)
+			break;
+		/*
+		 * For memsw, soft limits are hard to implement in terms
+		 * of semantics, for now, we support soft limits for
+		 * control without swap
+		 */
+		if (type == _MEM)
+			ret = res_counter_set_soft_limit(&memcg->res, val);
+		else
+			ret = -EINVAL;
+		break;
 	default:
 		ret = -EINVAL; /* should be BUG() ? */
 		break;
@@ -2188,6 +2202,12 @@ static struct cftype mem_cgroup_files[] = {
 		.read_u64 = mem_cgroup_read,
 	},
 	{
+		.name = "soft_limit_in_bytes",
+		.private = MEMFILE_PRIVATE(_MEM, RES_SOFT_LIMIT),
+		.write_string = mem_cgroup_write,
+		.read_u64 = mem_cgroup_read,
+	},
+	{
 		.name = "failcnt",
 		.private = MEMFILE_PRIVATE(_MEM, RES_FAILCNT),
 		.trigger = mem_cgroup_reset,

-- 
	Balbir
