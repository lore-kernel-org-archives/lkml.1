Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbYHSId2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbYHSId2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 04:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbYHSIdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 04:33:18 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56051 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbYHSIdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 04:33:16 -0400
Date: Tue, 19 Aug 2008 17:39:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       ryov@valinux.co.jp
Subject: [PATCH -mm][preview] memcg: a patch series for next [3/9]
Message-Id: <20080819173935.dedae2b1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080819173721.750d489e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080819173014.17358c17.kamezawa.hiroyu@jp.fujitsu.com>
	<20080819173721.750d489e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Maybe coding style of this patch is not good. (I should use enum..etc.)
This will be rewritten.

This patch adds function to modify page_cgroup->flags with using
set_bit/clear_bit/test_bit.

set/clear/test_bit is an usual way to manipulate flags an will reduce
ugly if sentenses. "atomic" set_bit may increase overhead but will
allow us looser control of this flags. (flag modification without locks!)
Of course, we don't have to use "atomic" ops where we can convice there
is no race.

This is a base patch for adding new flags.
(FLAG names are a bit modified....they are too long for 80 columns.)


Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



---
 mm/memcontrol.c |   82 +++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 55 insertions(+), 27 deletions(-)

Index: linux-2.6.27-rc1-mm1/mm/memcontrol.c
===================================================================
--- linux-2.6.27-rc1-mm1.orig/mm/memcontrol.c
+++ linux-2.6.27-rc1-mm1/mm/memcontrol.c
@@ -166,12 +166,35 @@ struct page_cgroup {
 	struct list_head lru;		/* per cgroup LRU list */
 	struct page *page;
 	struct mem_cgroup *mem_cgroup;
-	int flags;
+	unsigned long flags;
 };
-#define PAGE_CGROUP_FLAG_CACHE	   (0x1)	/* charged as cache */
-#define PAGE_CGROUP_FLAG_ACTIVE    (0x2)	/* page is active in this cgroup */
-#define PAGE_CGROUP_FLAG_FILE	   (0x4)	/* page is file system backed */
-#define PAGE_CGROUP_FLAG_UNEVICTABLE (0x8)	/* page is unevictableable */
+
+/* These 2 flags are unchanged during being used. */
+#define PAGE_CG_FLAG_CACHE	   (0)   /* charged as cache */
+#define PAGE_CG_FLAG_FILE	   (1)   /* page is file system backed */
+#define PAGE_CG_FLAG_ACTIVE    	   (2)       /* page is active in this cgroup */
+#define PAGE_CG_FLAG_UNEVICTABLE   (3)     /* page is unevictableable */
+
+static inline void page_cgroup_set_bit(struct page_cgroup *pc, int flag)
+{
+	set_bit(flag, &pc->flags);
+}
+
+static inline void __page_cgroup_set_bit(struct page_cgroup *pc, int flag)
+{
+	set_bit(flag, &pc->flags);
+	__set_bit(flag, &pc->flags);
+}
+
+static inline void page_cgroup_clear_bit(struct page_cgroup *pc, int flag)
+{
+	clear_bit(flag, &pc->flags);
+}
+
+static inline int page_cgroup_test_bit(struct page_cgroup *pc, int flag)
+{
+	return test_bit(flag, &pc->flags);
+}
 
 static int page_cgroup_nid(struct page_cgroup *pc)
 {
@@ -201,6 +224,9 @@ enum {
 
 /*
  * Always modified under lru lock. Then, not necessary to preempt_disable()
+ * "flags" passed to this function is a copy of pc->flags but flags checked
+ * in this function is permanent flags....means never being changed once
+ * being set. So, this is sage.
  */
 static void mem_cgroup_charge_statistics(struct mem_cgroup *mem, int flags,
 					bool charge)
@@ -209,7 +235,7 @@ static void mem_cgroup_charge_statistics
 	struct mem_cgroup_stat *stat = &mem->stat;
 
 	VM_BUG_ON(!irqs_disabled());
-	if (flags & PAGE_CGROUP_FLAG_CACHE)
+	if (flags & (1 << PAGE_CG_FLAG_CACHE))
 		__mem_cgroup_stat_add_safe(stat, MEM_CGROUP_STAT_CACHE, val);
 	else
 		__mem_cgroup_stat_add_safe(stat, MEM_CGROUP_STAT_RSS, val);
@@ -370,12 +396,12 @@ static void __mem_cgroup_remove_list(str
 {
 	int lru = LRU_BASE;
 
-	if (pc->flags & PAGE_CGROUP_FLAG_UNEVICTABLE)
+	if (page_cgroup_test_bit(pc, PAGE_CG_FLAG_UNEVICTABLE))
 		lru = LRU_UNEVICTABLE;
 	else {
-		if (pc->flags & PAGE_CGROUP_FLAG_ACTIVE)
+		if (page_cgroup_test_bit(pc, PAGE_CG_FLAG_ACTIVE))
 			lru += LRU_ACTIVE;
-		if (pc->flags & PAGE_CGROUP_FLAG_FILE)
+		if (page_cgroup_test_bit(pc, PAGE_CG_FLAG_FILE))
 			lru += LRU_FILE;
 	}
 
@@ -390,12 +416,12 @@ static void __mem_cgroup_add_list(struct
 {
 	int lru = LRU_BASE;
 
-	if (pc->flags & PAGE_CGROUP_FLAG_UNEVICTABLE)
+	if (page_cgroup_test_bit(pc, PAGE_CG_FLAG_UNEVICTABLE))
 		lru = LRU_UNEVICTABLE;
 	else {
-		if (pc->flags & PAGE_CGROUP_FLAG_ACTIVE)
+		if (page_cgroup_test_bit(pc, PAGE_CG_FLAG_ACTIVE))
 			lru += LRU_ACTIVE;
-		if (pc->flags & PAGE_CGROUP_FLAG_FILE)
+		if (page_cgroup_test_bit(pc, PAGE_CG_FLAG_FILE))
 			lru += LRU_FILE;
 	}
 
@@ -408,9 +434,9 @@ static void __mem_cgroup_add_list(struct
 static void __mem_cgroup_move_lists(struct page_cgroup *pc, enum lru_list lru)
 {
 	struct mem_cgroup_per_zone *mz = page_cgroup_zoneinfo(pc);
-	int active    = pc->flags & PAGE_CGROUP_FLAG_ACTIVE;
-	int file      = pc->flags & PAGE_CGROUP_FLAG_FILE;
-	int unevictable = pc->flags & PAGE_CGROUP_FLAG_UNEVICTABLE;
+	int active    = page_cgroup_test_bit(pc, PAGE_CG_FLAG_ACTIVE);
+	int file      = page_cgroup_test_bit(pc, PAGE_CG_FLAG_FILE);
+	int unevictable = page_cgroup_test_bit(pc, PAGE_CG_FLAG_UNEVICTABLE);
 	enum lru_list from = unevictable ? LRU_UNEVICTABLE :
 				(LRU_FILE * !!file + !!active);
 
@@ -420,14 +446,15 @@ static void __mem_cgroup_move_lists(stru
 	MEM_CGROUP_ZSTAT(mz, from) -= 1;
 
 	if (is_unevictable_lru(lru)) {
-		pc->flags &= ~PAGE_CGROUP_FLAG_ACTIVE;
-		pc->flags |= PAGE_CGROUP_FLAG_UNEVICTABLE;
+		page_cgroup_clear_bit(pc, PAGE_CG_FLAG_ACTIVE);
+		page_cgroup_set_bit(pc, PAGE_CG_FLAG_UNEVICTABLE);
 	} else {
 		if (is_active_lru(lru))
-			pc->flags |= PAGE_CGROUP_FLAG_ACTIVE;
-		else
-			pc->flags &= ~PAGE_CGROUP_FLAG_ACTIVE;
-		pc->flags &= ~PAGE_CGROUP_FLAG_UNEVICTABLE;
+			page_cgroup_set_bit(pc, PAGE_CG_FLAG_ACTIVE);
+		else if (active)
+			page_cgroup_clear_bit(pc, PAGE_CG_FLAG_ACTIVE);
+		if (unevictable)
+			page_cgroup_clear_bit(pc, PAGE_CG_FLAG_UNEVICTABLE);
 	}
 
 	MEM_CGROUP_ZSTAT(mz, lru) += 1;
@@ -655,18 +682,19 @@ static int mem_cgroup_charge_common(stru
 
 	pc->mem_cgroup = mem;
 	pc->page = page;
+	pc->flags = 0;
 	/*
 	 * If a page is accounted as a page cache, insert to inactive list.
 	 * If anon, insert to active list.
 	 */
 	if (ctype == MEM_CGROUP_CHARGE_TYPE_CACHE) {
-		pc->flags = PAGE_CGROUP_FLAG_CACHE;
+		__page_cgroup_set_bit(pc, PAGE_CG_FLAG_CACHE);
 		if (page_is_file_cache(page))
-			pc->flags |= PAGE_CGROUP_FLAG_FILE;
+			__page_cgroup_set_bit(pc, PAGE_CG_FLAG_FILE);
 		else
-			pc->flags |= PAGE_CGROUP_FLAG_ACTIVE;
+			__page_cgroup_set_bit(pc, PAGE_CG_FLAG_ACTIVE);
 	} else
-		pc->flags = PAGE_CGROUP_FLAG_ACTIVE;
+		__page_cgroup_set_bit(pc, PAGE_CG_FLAG_ACTIVE);
 
 	lock_page_cgroup(page);
 	if (unlikely(page_get_page_cgroup(page))) {
@@ -774,7 +802,7 @@ __mem_cgroup_uncharge_common(struct page
 	VM_BUG_ON(pc->page != page);
 
 	if ((ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED)
-	    && ((pc->flags & PAGE_CGROUP_FLAG_CACHE)
+	    && (page_cgroup_test_bit(pc, PAGE_CG_FLAG_CACHE)
 		|| page_mapped(page)))
 		goto unlock;
 
@@ -826,7 +854,7 @@ int mem_cgroup_prepare_migration(struct 
 	if (pc) {
 		mem = pc->mem_cgroup;
 		css_get(&mem->css);
-		if (pc->flags & PAGE_CGROUP_FLAG_CACHE)
+		if (page_cgroup_test_bit(pc, PAGE_CG_FLAG_CACHE))
 			ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
 	}
 	unlock_page_cgroup(page);

