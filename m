Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbYLCFJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbYLCFJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 00:09:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbYLCFJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 00:09:20 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52802 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbYLCFJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 00:09:19 -0500
Date: Wed, 3 Dec 2008 14:08:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH  17/21] memcg_prev_priority_protect.patch
Message-Id: <20081203140828.c02bf20f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081203134718.6b60986f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081203134718.6b60986f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, mem_cgroup doesn't have own lock and almost its member doesn't need.
 (e.g. mem_cgroup->info is protected by zone lock, mem_cgroup->stat is
  per cpu variable)

However, there is one explict exception. mem_cgroup->prev_priorit need lock,
but doesn't protect.
Luckly, this is NOT bug because prev_priority isn't used for current reclaim code.

However, we plan to use prev_priority future again.
Therefore, fixing is better.


In addision, we plan to reuse this lock for another member.
Then "reclaim_param_lock" name is better than "prev_priority_lock".


Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
 mm/memcontrol.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

Index: mmotm-2.6.28-Dec02/mm/memcontrol.c
===================================================================
--- mmotm-2.6.28-Dec02.orig/mm/memcontrol.c
+++ mmotm-2.6.28-Dec02/mm/memcontrol.c
@@ -144,6 +144,11 @@ struct mem_cgroup {
 	 */
 	struct mem_cgroup_lru_info info;
 
+	/*
+	  protect against reclaim related member.
+	*/
+	spinlock_t reclaim_param_lock;
+
 	int	prev_priority;	/* for recording reclaim priority */
 
 	/*
@@ -400,18 +405,28 @@ int mem_cgroup_calc_mapped_ratio(struct 
  */
 int mem_cgroup_get_reclaim_priority(struct mem_cgroup *mem)
 {
-	return mem->prev_priority;
+	int prev_priority;
+
+	spin_lock(&mem->reclaim_param_lock);
+	prev_priority = mem->prev_priority;
+	spin_unlock(&mem->reclaim_param_lock);
+
+	return prev_priority;
 }
 
 void mem_cgroup_note_reclaim_priority(struct mem_cgroup *mem, int priority)
 {
+	spin_lock(&mem->reclaim_param_lock);
 	if (priority < mem->prev_priority)
 		mem->prev_priority = priority;
+	spin_unlock(&mem->reclaim_param_lock);
 }
 
 void mem_cgroup_record_reclaim_priority(struct mem_cgroup *mem, int priority)
 {
+	spin_lock(&mem->reclaim_param_lock);
 	mem->prev_priority = priority;
+	spin_unlock(&mem->reclaim_param_lock);
 }
 
 int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg, struct zone *zone)
@@ -2070,6 +2085,7 @@ mem_cgroup_create(struct cgroup_subsys *
 	}
 	mem_cgroup_set_inactive_ratio(mem);
 	mem->last_scanned_child = NULL;
+	spin_lock_init(&mem->reclaim_param_lock);
 
 	return &mem->css;
 free_out:

