Return-Path: <linux-kernel-owner+w=401wt.eu-S1760907AbZDCIOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760907AbZDCIOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 04:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbZDCINq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 04:13:46 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36122 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbZDCINo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 04:13:44 -0400
Date: Fri, 3 Apr 2009 17:12:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: [RFC][PATCH 3/9] soft limit update filter
Message-Id: <20090403171202.cd7e094b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090403170835.a2d6cbc3.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090403170835.a2d6cbc3.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No changes from v1.
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Check/Update softlimit information at every charge is over-killing, so
we need some filter.

This patch tries to count events in the memcg and if events > threshold
tries to update memcg's soft limit status and reset event counter to 0.

Event counter is maintained by per-cpu which has been already used,
Then, no siginificant overhead(extra cache-miss etc..) in theory.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
Index: mmotm-2.6.29-Mar23/mm/memcontrol.c
===================================================================
--- mmotm-2.6.29-Mar23.orig/mm/memcontrol.c
+++ mmotm-2.6.29-Mar23/mm/memcontrol.c
@@ -66,6 +66,7 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
 	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
 
+	MEM_CGROUP_STAT_EVENTS,  /* sum of page-in/page-out for internal use */
 	MEM_CGROUP_STAT_NSTATS,
 };
 
@@ -105,6 +106,22 @@ static s64 mem_cgroup_local_usage(struct
 	return ret;
 }
 
+/* For intenal use of per-cpu event counting. */
+
+static inline void
+__mem_cgroup_stat_reset_safe(struct mem_cgroup_stat_cpu *stat,
+		enum mem_cgroup_stat_index idx)
+{
+	stat->count[idx] = 0;
+}
+
+static inline s64
+__mem_cgroup_stat_read_local(struct mem_cgroup_stat_cpu *stat,
+			    enum mem_cgroup_stat_index idx)
+{
+	return stat->count[idx];
+}
+
 /*
  * per-zone information in memory controller.
  */
@@ -235,6 +252,8 @@ static void mem_cgroup_charge_statistics
 	else
 		__mem_cgroup_stat_add_safe(cpustat,
 				MEM_CGROUP_STAT_PGPGOUT_COUNT, 1);
+	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_EVENTS, 1);
+
 	put_cpu();
 }
 
@@ -897,9 +916,26 @@ static void record_last_oom(struct mem_c
 	mem_cgroup_walk_tree(mem, NULL, record_last_oom_cb);
 }
 
+#define SOFTLIMIT_EVENTS_THRESH (1024) /* 1024 times of page-in/out */
+/*
+ * Returns true if sum of page-in/page-out events since last check is
+ * over SOFTLIMIT_EVENT_THRESH. (counter is per-cpu.)
+ */
 static bool mem_cgroup_soft_limit_check(struct mem_cgroup *mem)
 {
-	return false;
+	bool ret = false;
+	int cpu = get_cpu();
+	s64 val;
+	struct mem_cgroup_stat_cpu *cpustat;
+
+	cpustat = &mem->stat.cpustat[cpu];
+	val = __mem_cgroup_stat_read_local(cpustat, MEM_CGROUP_STAT_EVENTS);
+	if (unlikely(val > SOFTLIMIT_EVENTS_THRESH)) {
+		__mem_cgroup_stat_reset_safe(cpustat, MEM_CGROUP_STAT_EVENTS);
+		ret = true;
+	}
+	put_cpu();
+	return ret;
 }
 
 static void mem_cgroup_update_soft_limit(struct mem_cgroup *mem)

