Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbYHTKAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbYHTKAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 06:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbYHTJ7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 05:59:44 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49270 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbYHTJ7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 05:59:43 -0400
Date: Wed, 20 Aug 2008 19:05:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       ryov@valinux.co.jp, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [RFC][PATCH -mm 5/7] memcg: prefetch mem cgroup per zone
Message-Id: <20080820190555.438aad2b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080820185306.e897c512.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080819173014.17358c17.kamezawa.hiroyu@jp.fujitsu.com>
	<20080820185306.e897c512.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Address of "mz" can be calculated in early stage.
prefetch it (we always do spin_lock later.)


Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: mmtom-2.6.27-rc3+/mm/memcontrol.c
===================================================================
--- mmtom-2.6.27-rc3+.orig/mm/memcontrol.c
+++ mmtom-2.6.27-rc3+/mm/memcontrol.c
@@ -694,6 +694,8 @@ static int mem_cgroup_charge_common(stru
 		}
 	}
 
+	mz = mem_cgroup_zoneinfo(mem, page_to_nid(page), page_zonenum(page));
+	prefetchw(mz);
 	pc->mem_cgroup = mem;
 	pc->page = page;
 	pc->flags = 0;
@@ -716,7 +718,6 @@ static int mem_cgroup_charge_common(stru
 
 	page_assign_page_cgroup(page, pc);
 
-	mz = page_cgroup_zoneinfo(pc);
 	spin_lock_irqsave(&mz->lru_lock, flags);
 	__mem_cgroup_add_list(mz, pc);
 	spin_unlock_irqrestore(&mz->lru_lock, flags);

