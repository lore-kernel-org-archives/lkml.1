Return-Path: <linux-kernel-owner+w=401wt.eu-S1762133AbZDCIUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762133AbZDCIUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 04:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbZDCIUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 04:20:23 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36439 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbZDCIUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 04:20:22 -0400
Date: Fri, 3 Apr 2009 17:18:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: [RFC][PATCH 9/9] more event filter depend on priority
Message-Id: <20090403171844.fb92308a.kamezawa.hiroyu@jp.fujitsu.com>
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

I'll revisit this one before v3...

==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reduce softlimit update ratio depends on its priority(usage).

After this.
  if priority=0,1 -> check once in 1024 page-in/out
  if priority=2,3 -> check once in 2048 page-in/out
  ...
  if priority=10,11 -> check once in 32k page-in/out

(Note: this is called only when the usage exceeds soft limit)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: softlimit-test2/mm/memcontrol.c
===================================================================
--- softlimit-test2.orig/mm/memcontrol.c
+++ softlimit-test2/mm/memcontrol.c
@@ -940,7 +940,7 @@ static void record_last_oom(struct mem_c
 	mem_cgroup_walk_tree(mem, NULL, record_last_oom_cb);
 }
 
-#define SOFTLIMIT_EVENTS_THRESH (1024) /* 1024 times of page-in/out */
+#define SOFTLIMIT_EVENTS_THRESH (512) /* 512 times of page-in/out */
 /*
  * Returns true if sum of page-in/page-out events since last check is
  * over SOFTLIMIT_EVENT_THRESH. (counter is per-cpu.)
@@ -950,11 +950,15 @@ static bool mem_cgroup_soft_limit_check(
 	bool ret = false;
 	int cpu = get_cpu();
 	s64 val;
+	int thresh;
 	struct mem_cgroup_stat_cpu *cpustat;
 
 	cpustat = &mem->stat.cpustat[cpu];
 	val = __mem_cgroup_stat_read_local(cpustat, MEM_CGROUP_STAT_EVENTS);
-	if (unlikely(val > SOFTLIMIT_EVENTS_THRESH)) {
+	/* If usage is big, this check can be rough */
+	thresh = SOFTLIMIT_EVENTS_THRESH;
+	thresh <<= ((mem->soft_limit_priority >> 1) + 1);
+	if (unlikely(val > thresh)) {
 		__mem_cgroup_stat_reset_safe(cpustat, MEM_CGROUP_STAT_EVENTS);
 		ret = true;
 	}

