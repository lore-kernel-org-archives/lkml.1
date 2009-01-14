Return-Path: <linux-kernel-owner+w=401wt.eu-S1760910AbZANI6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760910AbZANI6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 03:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755736AbZANI6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 03:58:10 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:36900 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709AbZANI6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 03:58:08 -0500
Date: Wed, 14 Jan 2009 17:51:21 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, nishimura@mxp.nes.nec.co.jp
Subject: [RFC][PATCH 5/4] memcg: don't call res_counter_uncharge when
 obsolete
Message-Id: <20090114175121.275ecd59.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090113184533.6ffd2af9.nishimura@mxp.nes.nec.co.jp>
References: <20090113184533.6ffd2af9.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a new one. Please review.

===
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

mem_cgroup_get ensures that the memcg that has been got can be accessed
even after the directory has been removed, but it doesn't ensure that parents
of it can be accessed: parents might have been freed already by rmdir.

This causes a bug in case of use_hierarchy==1, because res_counter_uncharge
climb up the tree.

Check if the memcg is obsolete, and don't call res_counter_uncharge when obsole.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 mm/memcontrol.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index fb62b43..4ee95a8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1182,7 +1182,8 @@ int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 		/* avoid double counting */
 		mem = swap_cgroup_record(ent, NULL);
 		if (mem) {
-			res_counter_uncharge(&mem->memsw, PAGE_SIZE);
+			if (!mem_cgroup_is_obsolete(mem))
+				res_counter_uncharge(&mem->memsw, PAGE_SIZE);
 			mem_cgroup_put(mem);
 		}
 	}
@@ -1252,7 +1253,8 @@ void mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *ptr)
 		struct mem_cgroup *memcg;
 		memcg = swap_cgroup_record(ent, NULL);
 		if (memcg) {
-			res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
+			if (!mem_cgroup_is_obsolete(memcg))
+				res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
 			mem_cgroup_put(memcg);
 		}
 
@@ -1397,7 +1399,8 @@ void mem_cgroup_uncharge_swap(swp_entry_t ent)
 
 	memcg = swap_cgroup_record(ent, NULL);
 	if (memcg) {
-		res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
+		if (!mem_cgroup_is_obsolete(memcg))
+			res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
 		mem_cgroup_put(memcg);
 	}
 }
