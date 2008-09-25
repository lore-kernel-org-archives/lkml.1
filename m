Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbYIYGK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbYIYGK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 02:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbYIYGIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 02:08:24 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39950 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbYIYGIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 02:08:23 -0400
Date: Thu, 25 Sep 2008 15:14:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
       ryov@valinux.co.jp
Subject: [PATCH 2/12] memcg move charege() call to swapped-in page under
 lock_page()
Message-Id: <20080925151457.0ad68293.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080925151124.25898d22.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080925151124.25898d22.kamezawa.hiroyu@jp.fujitsu.com>
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

This patch moves do_swap_page()'s charge() call under lock. This helps
us to avoid to charge already mapped one, unnecessary calls.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 mm/memory.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: mmotm-2.6.27-rc7+/mm/memory.c
===================================================================
--- mmotm-2.6.27-rc7+.orig/mm/memory.c
+++ mmotm-2.6.27-rc7+/mm/memory.c
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

