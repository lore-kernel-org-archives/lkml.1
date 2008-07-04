Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbYGDJK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbYGDJK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 05:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756875AbYGDJKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 05:10:38 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52571 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290AbYGDJKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 05:10:36 -0400
Date: Fri, 4 Jul 2008 18:16:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "menage@google.com" <menage@google.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
Subject: [PATCH 2/2] memcg: check limit change
Message-Id: <20080704181606.4e9187e7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080704181204.44070413.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080704181204.44070413.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shrinking memory usage at limit change.

Changelog: v1 -> v2
  - adjusted to be based on write_string() patch set
  fixed pointed out styles (below)
  - removed backword goto.
  - removed unneccesary cond_resched().

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 Documentation/controllers/memory.txt |    3 --
 mm/memcontrol.c                      |   43 +++++++++++++++++++++++++++++++----
 2 files changed, 40 insertions(+), 6 deletions(-)

Index: test-2.6.26-rc8-mm1/mm/memcontrol.c
===================================================================
--- test-2.6.26-rc8-mm1.orig/mm/memcontrol.c
+++ test-2.6.26-rc8-mm1/mm/memcontrol.c
@@ -836,6 +836,26 @@ int mem_cgroup_shrink_usage(struct mm_st
 	return 0;
 }
 
+int mem_cgroup_resize_limit(struct mem_cgroup *memcg, unsigned long long val)
+{
+
+	int retry_count = MEM_CGROUP_RECLAIM_RETRIES;
+	int progress;
+	int ret = 0;
+
+	while (res_counter_set_limit(&memcg->res, val)) {
+		if (!retry_count) {
+			ret = -EBUSY;
+			break;
+		}
+		progress = try_to_free_mem_cgroup_pages(memcg, GFP_KERNEL);
+		if (!progress)
+			retry_count--;
+	}
+	return ret;
+}
+
+
 /*
  * This routine traverse page_cgroup in given list and drop them all.
  * *And* this routine doesn't reclaim page itself, just removes page_cgroup.
@@ -916,13 +936,29 @@ static u64 mem_cgroup_read(struct cgroup
 	return res_counter_read_u64(&mem_cgroup_from_cont(cont)->res,
 				    cft->private);
 }
-
+/*
+ * The user of this function is...
+ * RES_LIMIT.
+ */
 static int mem_cgroup_write(struct cgroup *cont, struct cftype *cft,
 			    const char *buffer)
 {
-	return res_counter_write(&mem_cgroup_from_cont(cont)->res,
-				 cft->private, buffer,
-				 res_counter_memparse_write_strategy);
+	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
+	unsigned long long val;
+	int ret;
+
+        switch (cft->private) {
+	case RES_LIMIT:
+		/* This function does all necessary parse...reuse it */
+		ret = res_counter_memparse_write_strategy(buffer, &val);
+		if (!ret)
+			ret = mem_cgroup_resize_limit(memcg, val);
+		break;
+	default:
+		ret = -EINVAL; /* should be BUG() ? */
+		break;
+	}
+	return ret;
 }
 
 static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
Index: test-2.6.26-rc8-mm1/Documentation/controllers/memory.txt
===================================================================
--- test-2.6.26-rc8-mm1.orig/Documentation/controllers/memory.txt
+++ test-2.6.26-rc8-mm1/Documentation/controllers/memory.txt
@@ -242,8 +242,7 @@ rmdir() if there are no tasks.
 1. Add support for accounting huge pages (as a separate controller)
 2. Make per-cgroup scanner reclaim not-shared pages first
 3. Teach controller to account for shared-pages
-4. Start reclamation when the limit is lowered
-5. Start reclamation in the background when the limit is
+4. Start reclamation in the background when the limit is
    not yet hit but the usage is getting closer
 
 Summary

