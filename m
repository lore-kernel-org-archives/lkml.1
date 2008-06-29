Return-Path: <linux-kernel-owner+w=401wt.eu-S1758514AbYF2ARS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514AbYF2ARS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 20:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbYF2ARK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 20:17:10 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:36123 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbYF2ARJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 20:17:09 -0400
Date: Sun, 29 Jun 2008 01:17:17 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@in.ibm.com>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] memcg: further checking of disabled flag
In-Reply-To: <Pine.LNX.4.64.0806290108110.20280@blonde.site>
Message-ID: <Pine.LNX.4.64.0806290115440.20280@blonde.site>
References: <Pine.LNX.4.64.0806290108110.20280@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further adjustments to the mem_cgroup_subsys.disabled tests: add one to
mem_cgroup_shrink_usage; move mem_cgroup_charge_common's into its callers,
before they've done any work; and add one to mem_cgroup_move_lists, to
avoid the overhead of its bit spin locking and unlocking.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Should follow mmotm's memcg-clean-up-checking-of-the-disabled-flag.patch

 mm/memcontrol.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- mmotm/mm/memcontrol.c	2008-06-27 13:39:20.000000000 +0100
+++ linux/mm/memcontrol.c	2008-06-27 17:32:29.000000000 +0100
@@ -354,6 +354,9 @@ void mem_cgroup_move_lists(struct page *
 	struct mem_cgroup_per_zone *mz;
 	unsigned long flags;
 
+	if (mem_cgroup_subsys.disabled)
+		return;
+
 	/*
 	 * We cannot lock_page_cgroup while holding zone's lru_lock,
 	 * because other holders of lock_page_cgroup can be interrupted
@@ -533,9 +536,6 @@ static int mem_cgroup_charge_common(stru
 	unsigned long nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
 	struct mem_cgroup_per_zone *mz;
 
-	if (mem_cgroup_subsys.disabled)
-		return 0;
-
 	pc = kmem_cache_alloc(page_cgroup_cache, gfp_mask);
 	if (unlikely(pc == NULL))
 		goto err;
@@ -620,6 +620,9 @@ err:
 
 int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
 {
+	if (mem_cgroup_subsys.disabled)
+		return 0;
+
 	/*
 	 * If already mapped, we don't have to account.
 	 * If page cache, page->mapping has address_space.
@@ -638,6 +641,9 @@ int mem_cgroup_charge(struct page *page,
 int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask)
 {
+	if (mem_cgroup_subsys.disabled)
+		return 0;
+
 	/*
 	 * Corner case handling. This is called from add_to_page_cache()
 	 * in usual. But some FS (shmem) precharges this page before calling it
@@ -789,6 +795,9 @@ int mem_cgroup_shrink_usage(struct mm_st
 	int progress = 0;
 	int retry = MEM_CGROUP_RECLAIM_RETRIES;
 
+	if (mem_cgroup_subsys.disabled)
+		return 0;
+
 	rcu_read_lock();
 	mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
 	css_get(&mem->css);
