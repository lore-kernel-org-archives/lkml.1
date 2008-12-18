Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752298AbYLRI7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbYLRI7V (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 03:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbYLRI7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 03:59:11 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41586 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbYLRI7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 03:59:10 -0500
Date: Thu, 18 Dec 2008 17:58:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "menage@google.com" <menage@google.com>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: [PATCH 1/2] memcg: fix double free and make refcnt sane
Message-Id: <20081218175810.63f743a9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081218175403.40ad184a.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081218175403.40ad184a.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 1. Fix double-free BUG in error route of mem_cgroup_create().
    mem_cgroup_free() itself frees per-zone-info.
 2. Making refcnt of memcg simple.
    Add 1 refcnt at creation and call free when refcnt goes down to 0.

Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Singed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
Index: mmotm-2.6.28-Dec16/mm/memcontrol.c
===================================================================
--- mmotm-2.6.28-Dec16.orig/mm/memcontrol.c
+++ mmotm-2.6.28-Dec16/mm/memcontrol.c
@@ -2085,14 +2085,10 @@ static struct mem_cgroup *mem_cgroup_all
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
 
@@ -2109,11 +2105,8 @@ static void mem_cgroup_get(struct mem_cg
 
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
 
 
@@ -2163,12 +2156,10 @@ mem_cgroup_create(struct cgroup_subsys *
 
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
 
@@ -2183,7 +2174,7 @@ static void mem_cgroup_pre_destroy(struc
 static void mem_cgroup_destroy(struct cgroup_subsys *ss,
 				struct cgroup *cont)
 {
-	mem_cgroup_free(mem_cgroup_from_cont(cont));
+	mem_cgroup_put(mem_cgroup_from_cont(cont));
 }
 
 static int mem_cgroup_populate(struct cgroup_subsys *ss,

