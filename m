Return-Path: <linux-kernel-owner+w=401wt.eu-S1753093AbYIVKwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbYIVKwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 06:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYIVKvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 06:51:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45888 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbYIVKvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 06:51:52 -0400
Date: Mon, 22 Sep 2008 19:57:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/13] memcg: account fault-in swap under lock.
Message-Id: <20080922195741.b6a3e69d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080922195159.41a9d2bc.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080922195159.41a9d2bc.kamezawa.hiroyu@jp.fujitsu.com>
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
This is good for avoiding unnecessary slow-path in charge().

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 mm/memory.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: mmotm-2.6.27-rc6+/mm/memory.c
===================================================================
--- mmotm-2.6.27-rc6+.orig/mm/memory.c
+++ mmotm-2.6.27-rc6+/mm/memory.c
@@ -2320,15 +2320,14 @@ static int do_swap_page(struct mm_struct
 		count_vm_event(PGMAJFAULT);
 	}
 
+	lock_page(page);
+	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
+
 	if (mem_cgroup_charge(page, mm, GFP_KERNEL)) {
-		delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 		ret = VM_FAULT_OOM;
 		goto out;
 	}
-
 	mark_page_accessed(page);
-	lock_page(page);
-	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 
 	/*
 	 * Back out if somebody else already faulted in this pte.

