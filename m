Return-Path: <linux-kernel-owner+w=401wt.eu-S1759824AbYENH7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759824AbYENH7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 03:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbYENH7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 03:59:38 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60723 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbYENH7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 03:59:37 -0400
Date: Wed, 14 May 2008 17:04:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "hugh@veritas.com" <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC/PATCH 1/6] memcg: drop_pages at force_empty.
Message-Id: <20080514170459.ec03d1fd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080514170236.23c9ddd7.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080514170236.23c9ddd7.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is NEW one ;)
==
Now, when we remove memcg, we call force_empty().
This call drops all page_cgroup accounting in this mem_cgroup but doesn't
drop pages. So, some page caches can be remaind as "not accounted" memory
while they are alive. (because it's accounted only when add_to_page_cache())
If they are not used by other memcg, global LRU will drop them.

This patch tries to drop pages at removing memcg. Other memcg will
reload and re-account page caches.

Consideration: should we add knob to drop pages or not?

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 include/linux/res_counter.h |   11 +++++++++++
 mm/memcontrol.c             |   21 ++++++++++++++++++---
 2 files changed, 29 insertions(+), 3 deletions(-)

Index: linux-2.6.26-rc2/mm/memcontrol.c
===================================================================
--- linux-2.6.26-rc2.orig/mm/memcontrol.c
+++ linux-2.6.26-rc2/mm/memcontrol.c
@@ -763,6 +763,20 @@ void mem_cgroup_end_migration(struct pag
 	mem_cgroup_uncharge_page(newpage);
 }
 
+
+static void mem_cgroup_drop_all_page(struct mem_cgroup *mem)
+{
+	int progress;
+	while (res_counter_check_empty(&mem->res)) {
+		progress = try_to_free_mem_cgroup_pages(mem,
+					GFP_HIGHUSER_MOVABLE);
+		if (!progress) /* we did as much as possible */
+			break;
+		cond_resched();
+	}
+	return;
+}
+
 /*
  * This routine traverse page_cgroup in given list and drop them all.
  * This routine ignores page_cgroup->ref_cnt.
@@ -820,7 +834,12 @@ static int mem_cgroup_force_empty(struct
 	if (mem_cgroup_subsys.disabled)
 		return 0;
 
+	if (atomic_read(&mem->css.cgroup->count) > 0)
+		goto out;
+
 	css_get(&mem->css);
+	/* drop pages as much as possible */
+	mem_cgroup_drop_all_pages(mem);
 	/*
 	 * page reclaim code (kswapd etc..) will move pages between
 	 * active_list <-> inactive_list while we don't take a lock.
Index: linux-2.6.26-rc2/include/linux/res_counter.h
===================================================================
--- linux-2.6.26-rc2.orig/include/linux/res_counter.h
+++ linux-2.6.26-rc2/include/linux/res_counter.h
@@ -151,4 +151,15 @@ static inline void res_counter_reset_fai
 	cnt->failcnt = 0;
 	spin_unlock_irqrestore(&cnt->lock, flags);
 }
+
+static inline int res_counter_check_empty(struct res_counter *cnt)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&cnt->lock, flags);
+	ret = (cnt->usage == 0);
+	spin_unlock_irqrestore(&cnt->lock, flags);
+	return ret;
+}
 #endif

