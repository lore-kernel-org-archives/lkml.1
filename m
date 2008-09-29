Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbYI2KPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbYI2KPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 06:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbYI2KPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 06:15:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51521 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbYI2KPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 06:15:30 -0400
Date: Mon, 29 Sep 2008 19:21:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH 1/4] memcg: account swap cache under lock
Message-Id: <20080929192123.5ce60c24.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080929191927.caabec89.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080929191927.caabec89.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
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


Changelog: (v5) -> (v6)
 - mark_page_accessed() is moved before lock_page().
 - fixed missing unlock_page()
(no changes in previous version)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

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

