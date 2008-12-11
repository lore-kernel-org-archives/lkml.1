Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbYLKDMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbYLKDMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 22:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbYLKDMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 22:12:35 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55541 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbYLKDMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 22:12:34 -0500
Date: Thu, 11 Dec 2008 12:11:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [RFC][PATCH] memcg: show real limit under hierarchy
Message-Id: <20081211121135.e00f6a2d.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wonder other people who debugs memcg's hierarchy may use similar patches.
this is my one.
comments ?
==
From:KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Show "real" limit of memcg.
This helps my debugging and maybe useful for users.

While testing hierarchy like this

	mount -t cgroup none /cgroup -t memory
	mkdir /cgroup/A
	set use_hierarchy==1 to "A"
	mkdir /cgroup/A/01
	mkdir /cgroup/A/01/02
	mkdir /cgroup/A/01/03
	mkdir /cgroup/A/01/03/04
	mkdir /cgroup/A/08
	mkdir /cgroup/A/08/01
	....
and set each own limit to them, "real" limit of each memcg is unclear.
This patch shows real limit by checking all ancestors in memory.stat.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

Index: mmotm-2.6.28-Dec09/mm/memcontrol.c
===================================================================
--- mmotm-2.6.28-Dec09.orig/mm/memcontrol.c
+++ mmotm-2.6.28-Dec09/mm/memcontrol.c
@@ -1758,6 +1758,36 @@ static int mem_cgroup_write(struct cgrou
 	return ret;
 }
 
+static void memcg_get_hierarchical_limit(struct mem_cgroup *memcg,
+		unsigned long long *mem_limit, unsigned long long *memsw_limit)
+{
+	struct cgroup *cgroup;
+	unsigned long long min_limit, min_memsw_limit, tmp;
+
+	min_limit = res_counter_read_u64(&memcg->res, RES_LIMIT);
+	min_memsw_limit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
+	cgroup = memcg->css.cgroup;
+	if (!memcg->use_hierarchy)
+		goto out;
+
+	while (cgroup->parent) {
+		cgroup = cgroup->parent;
+		memcg = mem_cgroup_from_cont(cgroup);
+		if (!memcg->use_hierarchy)
+			break;
+		tmp = res_counter_read_u64(&memcg->res, RES_LIMIT);
+		if (tmp < min_limit)
+			min_limit = tmp;
+		tmp = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
+		if (tmp < min_memsw_limit)
+			min_memsw_limit = tmp;
+	}
+out:
+	*mem_limit = min_limit;
+	*memsw_limit = min_memsw_limit;
+	return;
+}
+
 static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
 {
 	struct mem_cgroup *mem;
@@ -1831,6 +1861,13 @@ static int mem_control_stat_show(struct 
 		cb->fill(cb, "unevictable", unevictable * PAGE_SIZE);
 
 	}
+	{
+		unsigned long long limit, memsw_limit;
+		memcg_get_hierarchical_limit(mem_cont, &limit, &memsw_limit);
+		cb->fill(cb, "hierarchical_memory_limit", limit);
+		if (do_swap_account)
+			cb->fill(cb, "hierarchical_memsw_limit", memsw_limit);
+	}
 
 #ifdef CONFIG_DEBUG_VM
 	cb->fill(cb, "inactive_ratio", mem_cont->inactive_ratio);

