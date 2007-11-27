Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbXK0DBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbXK0DBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 22:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbXK0DBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 22:01:31 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43462 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbXK0DBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 22:01:30 -0500
Date: Tue, 27 Nov 2007 12:04:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH][for -mm] per-zone and reclaim enhancements for memory
 controller take 3 [6/10] remember reclaim priority in memory cgroup
Message-Id: <20071127120442.895e4f1b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071127115525.e9779108.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071127115525.e9779108.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Functions to remember reclaim priority per cgroup (as zone->prev_priority)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 include/linux/memcontrol.h |   23 +++++++++++++++++++++++
 mm/memcontrol.c            |   20 ++++++++++++++++++++
 2 files changed, 43 insertions(+)

Index: linux-2.6.24-rc3-mm1/mm/memcontrol.c
===================================================================
--- linux-2.6.24-rc3-mm1.orig/mm/memcontrol.c	2007-11-27 11:19:51.000000000 +0900
+++ linux-2.6.24-rc3-mm1/mm/memcontrol.c	2007-11-27 11:22:14.000000000 +0900
@@ -132,6 +132,7 @@
 	 */
 	spinlock_t lru_lock;
 	unsigned long control_type;	/* control RSS or RSS+Pagecache */
+	int	prev_priority;	/* for recording reclaim priority */
 	/*
 	 * statistics.
 	 */
@@ -452,6 +453,25 @@
 	return (long) (active / (inactive + 1));
 }
 
+/*
+ * prev_priority control...this will be used in memory reclaim path.
+ */
+int mem_cgroup_get_reclaim_priority(struct mem_cgroup *mem)
+{
+	return mem->prev_priority;
+}
+
+void mem_cgroup_note_reclaim_priority(struct mem_cgroup *mem, int priority)
+{
+	if (priority < mem->prev_priority)
+		mem->prev_priority = priority;
+}
+
+void mem_cgroup_record_reclaim_priority(struct mem_cgroup *mem, int priority)
+{
+	mem->prev_priority = priority;
+}
+
 unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 					struct list_head *dst,
 					unsigned long *scanned, int order,
Index: linux-2.6.24-rc3-mm1/include/linux/memcontrol.h
===================================================================
--- linux-2.6.24-rc3-mm1.orig/include/linux/memcontrol.h	2007-11-27 11:19:00.000000000 +0900
+++ linux-2.6.24-rc3-mm1/include/linux/memcontrol.h	2007-11-27 11:22:14.000000000 +0900
@@ -67,6 +67,11 @@
 extern int mem_cgroup_calc_mapped_ratio(struct mem_cgroup *mem);
 extern long mem_cgroup_reclaim_imbalance(struct mem_cgroup *mem);
 
+extern int mem_cgroup_get_reclaim_priority(struct mem_cgroup *mem);
+extern void mem_cgroup_note_reclaim_priority(struct mem_cgroup *mem,
+							int priority);
+extern void mem_cgroup_record_reclaim_priority(struct mem_cgroup *mem,
+							int priority);
 
 
 #else /* CONFIG_CGROUP_MEM_CONT */
@@ -150,6 +155,24 @@
 	return 0;
 }
 
+static inline int mem_cgroup_get_reclaim_priority(struct mem_cgroup *mem,
+						int priority)
+{
+	return 0;
+}
+
+static inline void mem_cgroup_note_reclaim_priority(struct mem_cgroup *mem,
+						int priority)
+{
+	return 0;
+}
+
+static inline void mem_cgroup_record_reclaim_priority(struct mem_cgroup *mem,
+						int priority)
+{
+	return 0;
+}
+
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #endif /* _LINUX_MEMCONTROL_H */

