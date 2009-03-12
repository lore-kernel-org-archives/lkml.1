Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbZCLBAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbZCLBAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 21:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbZCLA75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 20:59:57 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42155 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbZCLA74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 20:59:56 -0400
Date: Thu, 12 Mar 2009 09:58:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: [RFC][PATCH 4/5] memcg softlimit_priority
Message-Id: <20090312095831.e88b4556.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090312095247.bf338fe8.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090312095247.bf338fe8.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

An iterface to set/read softlimit priority of cgroup.

Changelog: v2->v3
 - removed complicated handling of hierarchy.
   i.e. Changes in priority doesn't affect children.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

Index: mmotm-2.6.29-Mar10/mm/memcontrol.c
===================================================================
--- mmotm-2.6.29-Mar10.orig/mm/memcontrol.c
+++ mmotm-2.6.29-Mar10/mm/memcontrol.c
@@ -217,6 +217,8 @@ pcg_default_flags[NR_CHARGE_TYPE] = {
 #define MEMFILE_TYPE(val)	(((val) >> 16) & 0xffff)
 #define MEMFILE_ATTR(val)	((val) & 0xffff)
 
+#define MEM_SOFTLIMIT_PRIO     (0x10)
+
 static void mem_cgroup_get(struct mem_cgroup *mem);
 static void mem_cgroup_put(struct mem_cgroup *mem);
 static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem);
@@ -2187,7 +2189,14 @@ static u64 mem_cgroup_read(struct cgroup
 	name = MEMFILE_ATTR(cft->private);
 	switch (type) {
 	case _MEM:
-		val = res_counter_read_u64(&mem->res, name);
+		switch (name) {
+		case MEM_SOFTLIMIT_PRIO:
+			val = mem->softlimit_priority;
+			break;
+		default:
+			val = res_counter_read_u64(&mem->res, name);
+			break;
+		}
 		break;
 	case _MEMSWAP:
 		if (do_swap_account)
@@ -2290,6 +2299,18 @@ static int mem_cgroup_reset(struct cgrou
 	return 0;
 }
 
+static int mem_cgroup_write_softlimit_priority(struct cgroup *cgrp,
+					struct cftype *cft,
+					u64 val)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
+	int priority = (int)val;
+
+	if ((priority < 0) || (priority > SOFTLIMIT_MAXPRI))
+		return -EINVAL;
+	memcg_softlimit_requeue(memcg, priority);
+	return 0;
+}
 
 /* For read statistics */
 enum {
@@ -2485,6 +2506,12 @@ static struct cftype mem_cgroup_files[] 
 		.read_u64 = mem_cgroup_read,
 	},
 	{
+		.name = "softlimit_priority",
+		.private = MEMFILE_PRIVATE(_MEM, MEM_SOFTLIMIT_PRIO),
+		.write_u64 = mem_cgroup_write_softlimit_priority,
+		.read_u64 = mem_cgroup_read,
+	},
+	{
 		.name = "failcnt",
 		.private = MEMFILE_PRIVATE(_MEM, RES_FAILCNT),
 		.trigger = mem_cgroup_reset,
@@ -2711,8 +2738,8 @@ mem_cgroup_create(struct cgroup_subsys *
 		res_counter_init(&mem->res, NULL);
 		res_counter_init(&mem->memsw, NULL);
 	}
-	mem->last_scanned_child = 0;
 	mem->softlimit_priority = SOFTLIMIT_MAXPRI;
+	mem->last_scanned_child = 0;
 	mutex_init(&mem->softlimit_mutex);
 	spin_lock_init(&mem->reclaim_param_lock);
 

