Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbYLCEx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbYLCEx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 23:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbYLCExs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 23:53:48 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59458 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbYLCExr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 23:53:47 -0500
Date: Wed, 3 Dec 2008 13:52:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       lizf@cn.fujitsu.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH  4/21] memcg-swapout-refcnt-fix.patch
Message-Id: <20081203135249.d599a93a.kamezawa.hiroyu@jp.fujitsu.com>
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

Fix for memcg-memswap-controller-core.patch

css's refcnt is dropped before end of following access.
Hold it until end of access.

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 mm/memcontrol.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: mmotm-2.6.28-Dec01-2/mm/memcontrol.c
===================================================================
--- mmotm-2.6.28-Dec01-2.orig/mm/memcontrol.c
+++ mmotm-2.6.28-Dec01-2/mm/memcontrol.c
@@ -1171,7 +1171,9 @@ __mem_cgroup_uncharge_common(struct page
 	mz = page_cgroup_zoneinfo(pc);
 	unlock_page_cgroup(pc);
 
-	css_put(&mem->css);
+	/* at swapout, this memcg will be accessed to record to swap */
+	if (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
+		css_put(&mem->css);
 
 	return mem;
 
@@ -1212,6 +1214,8 @@ void mem_cgroup_uncharge_swapcache(struc
 		swap_cgroup_record(ent, memcg);
 		mem_cgroup_get(memcg);
 	}
+	if (memcg)
+		css_put(&memcg->css);
 }
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP

