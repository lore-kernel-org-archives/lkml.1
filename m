Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbYLPGDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbYLPGDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 01:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbYLPGDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 01:03:04 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50639 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbYLPGDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 01:03:02 -0500
Date: Tue, 16 Dec 2008 15:02:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: [BUGFIX][RFT][PATCH] memcg: fix double free in error route
Message-Id: <20081216150202.bf6408ac.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you test this ?
This includes a fix and a cleanup.

After this, the kernel will panic if handling of refcnt is bad.
This is against mmotom-dec-15.

==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 1. Fix double-free BUG in error route of mem_cgroup_create().
    mem_cgroup_free() itself frees per-zone-info.
 2. Making refcnt of memcg simple.
    Add 1 refcnt at creation and call free when refcnt goes down to 0.

Singed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
Index: mmotm-2.6.28-Dec15/mm/memcontrol.c
===================================================================
--- mmotm-2.6.28-Dec15.orig/mm/memcontrol.c
+++ mmotm-2.6.28-Dec15/mm/memcontrol.c
@@ -2087,14 +2087,10 @@ static struct mem_cgroup *mem_cgroup_all
  * Removal of cgroup itself succeeds regardless of refs from swap.
  */
 
-static void mem_cgroup_free(struct mem_cgroup *mem)
+static void __mem_cgroup_free(struct mem_cgroup *mem)
 {
 	int node;
 
-	if (atomic_read(&mem->refcnt) > 0)
-		return;
-
-
 	for_each_node_state(node, N_POSSIBLE)
 		free_mem_cgroup_per_zone_info(mem, node);
 
@@ -2111,11 +2107,8 @@ static void mem_cgroup_get(struct mem_cg
 
 static void mem_cgroup_put(struct mem_cgroup *mem)
 {
-	if (atomic_dec_and_test(&mem->refcnt)) {
-		if (!mem->obsolete)
-			return;
-		mem_cgroup_free(mem);
-	}
+	if (atomic_dec_and_test(&mem->refcnt))
+		__mem_cgroup_free(mem);
 }
 
 
@@ -2165,12 +2158,10 @@ mem_cgroup_create(struct cgroup_subsys *
 
 	if (parent)
 		mem->swappiness = get_swappiness(parent);
-
+	atomic_set(&mem->refcnt, 1);
 	return &mem->css;
 free_out:
-	for_each_node_state(node, N_POSSIBLE)
-		free_mem_cgroup_per_zone_info(mem, node);
-	mem_cgroup_free(mem);
+	__mem_cgroup_free(mem);
 	return ERR_PTR(-ENOMEM);
 }
 
@@ -2185,7 +2176,7 @@ static void mem_cgroup_pre_destroy(struc
 static void mem_cgroup_destroy(struct cgroup_subsys *ss,
 				struct cgroup *cont)
 {
-	mem_cgroup_free(mem_cgroup_from_cont(cont));
+	mem_cgroup_put(mem_cgroup_from_cont(cont));
 }
 
 static int mem_cgroup_populate(struct cgroup_subsys *ss,

