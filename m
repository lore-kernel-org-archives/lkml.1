Return-Path: <linux-kernel-owner+w=401wt.eu-S1760516AbZAGSmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760516AbZAGSmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 13:42:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758217AbZAGSl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 13:41:29 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:59736 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354AbZAGSlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 13:41:25 -0500
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 08 Jan 2009 00:11:23 +0530
Message-Id: <20090107184123.18062.81916.sendpatchset@localhost.localdomain>
In-Reply-To: <20090107184110.18062.41459.sendpatchset@localhost.localdomain>
References: <20090107184110.18062.41459.sendpatchset@localhost.localdomain>
Subject: [RFC][PATCH 2/4] Memory controller soft limit interface
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Balbir Singh <balbir@linux.vnet.ibm.com>

Add an interface to allow get/set of soft limits. Soft limits for memory plus
swap controller (memsw) is currently not supported. Resource counters have
been enhanced to support soft limits and new type RES_SOFT_LIMIT has been
added. Unlike hard limits, soft limits can be directly set and do not
need any reclaim or checks before setting them to a newer value.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 include/linux/res_counter.h |   39 ++++++++++++++++++++++++++++++++++
 kernel/res_counter.c        |    3 ++
 mm/memcontrol.c             |   20 +++++++++++++++++
 3 files changed, 62 insertions(+)

diff -puN mm/memcontrol.c~memcg-add-soft-limit-interface mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-soft-limit-interface
+++ a/mm/memcontrol.c
@@ -1811,6 +1811,20 @@ static int mem_cgroup_write(struct cgrou
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
@@ -2010,6 +2024,12 @@ static struct cftype mem_cgroup_files[] 
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
diff -puN include/linux/res_counter.h~memcg-add-soft-limit-interface include/linux/res_counter.h
--- a/include/linux/res_counter.h~memcg-add-soft-limit-interface
+++ a/include/linux/res_counter.h
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
@@ -130,6 +135,28 @@ static inline bool res_counter_limit_che
 	return false;
 }
 
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
@@ -178,4 +205,16 @@ static inline int res_counter_set_limit(
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
diff -puN kernel/res_counter.c~memcg-add-soft-limit-interface kernel/res_counter.c
--- a/kernel/res_counter.c~memcg-add-soft-limit-interface
+++ a/kernel/res_counter.c
@@ -19,6 +19,7 @@ void res_counter_init(struct res_counter
 {
 	spin_lock_init(&counter->lock);
 	counter->limit = (unsigned long long)LLONG_MAX;
+	counter->soft_limit = (unsigned long long)LLONG_MAX;
 	counter->parent = parent;
 }
 
@@ -101,6 +102,8 @@ res_counter_member(struct res_counter *c
 		return &counter->limit;
 	case RES_FAILCNT:
 		return &counter->failcnt;
+	case RES_SOFT_LIMIT:
+		return &counter->soft_limit;
 	};
 
 	BUG();
_

-- 
	Balbir
