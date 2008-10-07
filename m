Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbYJGKEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbYJGKEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 06:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYJGKDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 06:03:55 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35288 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbYJGKDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 06:03:54 -0400
Date: Tue, 7 Oct 2008 19:03:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 1/6] memcg: move charge swapin under lock
Message-Id: <20081007190331.b770a592.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081007190121.d96e58a6.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081007190121.d96e58a6.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While page-cache's charge/uncharge is done under page_lock(), swap-cache
isn't. (anonymous page is charged when it's newly allocated.)

This patch moves do_swap_page()'s charge() call under lock.
I don't see any bad problem *now* but this fix will be good for future
for avoiding unneccesary racy state.


Changelog: (v6) -> (v7)
 - no changes.
Changelog: (v5) -> (v6)
 - mark_page_accessed() is moved before lock_page().
 - fixed missing unlock_page()
(no changes in previous version)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com> 


 mm/memory.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: mmotm-2.6.27-rc7+/mm/memory.c
===================================================================
--- mmotm-2.6.27-rc7+.orig/mm/memory.c
+++ mmotm-2.6.27-rc7+/mm/memory.c
@@ -2326,16 +2326,17 @@ static int do_swap_page(struct mm_struct
 		count_vm_event(PGMAJFAULT);
 	}
 
+	mark_page_accessed(page);
+
+	lock_page(page);
+	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
+
 	if (mem_cgroup_charge(page, mm, GFP_KERNEL)) {
-		delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 		ret = VM_FAULT_OOM;
+		unlock_page(page);
 		goto out;
 	}
 
-	mark_page_accessed(page);
-	lock_page(page);
-	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
-
 	/*
 	 * Back out if somebody else already faulted in this pte.
 	 */

