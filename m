Return-Path: <linux-kernel-owner+w=401wt.eu-S1753080AbYLBHLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbYLBHLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 02:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbYLBHLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 02:11:12 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50806 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbYLBHLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 02:11:12 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] memcg: mem_cgroup->prev_priority protected by lock.
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081202160949.1CFE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue,  2 Dec 2008 16:11:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently, mem_cgroup doesn't have own lock and almost its member doesn't need.
 (e.g. info is protected by zone lock, stat is per cpu variable)

However, there is one explict exception. mem_cgroup->prev_priorit need lock,
but doesn't protect.
Luckly, this is NOT bug because prev_priority isn't used for current reclaim code.

However, we plan to use prev_priority future again.
Therefore, fixing is better.


In addision, we plan to reuse this lock for another member.
Then "misc_lock" name is better than "prev_priority_lock".



Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/memcontrol.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

Index: b/mm/memcontrol.c
===================================================================
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -142,6 +142,13 @@ struct mem_cgroup {
 	 */
 	struct mem_cgroup_lru_info info;
 
+	/*
+	  Almost mem_cgroup member doesn't need lock.
+	  (e.g. info is protected by zone lock, stat is per cpu variable)
+	  However, rest few member need explict lock.
+	*/
+	spinlock_t misc_lock;
+
 	int	prev_priority;	/* for recording reclaim priority */
 
 	/*
@@ -393,18 +400,28 @@ int mem_cgroup_calc_mapped_ratio(struct 
  */
 int mem_cgroup_get_reclaim_priority(struct mem_cgroup *mem)
 {
-	return mem->prev_priority;
+	int prev_priority;
+
+	spin_lock(&mem->misc_lock);
+	prev_priority = mem->prev_priority;
+	spin_unlock(&mem->misc_lock);
+
+	return prev_priority;
 }
 
 void mem_cgroup_note_reclaim_priority(struct mem_cgroup *mem, int priority)
 {
+	spin_lock(&mem->misc_lock);
 	if (priority < mem->prev_priority)
 		mem->prev_priority = priority;
+	spin_unlock(&mem->misc_lock);
 }
 
 void mem_cgroup_record_reclaim_priority(struct mem_cgroup *mem, int priority)
 {
+	spin_lock(&mem->misc_lock);
 	mem->prev_priority = priority;
+	spin_unlock(&mem->misc_lock);
 }
 
 /*
@@ -1967,6 +1984,7 @@ mem_cgroup_create(struct cgroup_subsys *
 	}
 
 	mem->last_scanned_child = NULL;
+	spin_lock_init(&mem->misc_lock);
 
 	return &mem->css;
 free_out:


