Return-Path: <linux-kernel-owner+w=401wt.eu-S1759353AbZAHKSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353AbZAHKSD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 05:18:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbZAHKRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 05:17:51 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:44442 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZAHKRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 05:17:50 -0500
Date: Thu, 8 Jan 2009 19:14:45 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
       balbir@linux.vnet.ibm.com, lizf@cn.fujitsu.com, menage@google.com,
       nishimura@mxp.nes.nec.co.jp
Subject: [RFC][PATCH 2/4] memcg: fix error path of mem_cgroup_move_parent
Message-Id: <20090108191445.cd860c37.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090108190818.b663ce20.nishimura@mxp.nes.nec.co.jp>
References: <20090108190818.b663ce20.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a bug in error path of mem_cgroup_move_parent.

Extra refcnt got from try_charge should be dropped, and usages incremented
by try_charge should be decremented in both error paths:

    A: failure at get_page_unless_zero
    B: failure at isolate_lru_page

This bug makes this parent directory unremovable.

In case of A, rmdir doesn't return, because res.usage doesn't go
down to 0 at mem_cgroup_force_empty even after all the pc in
lru are removed.
In case of B, rmdir fails and returns -EBUSY, because it has
extra ref counts even after res.usage goes down to 0.


Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 mm/memcontrol.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 62e69d8..288e22c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -983,14 +983,15 @@ static int mem_cgroup_move_account(struct page_cgroup *pc,
 	if (pc->mem_cgroup != from)
 		goto out;
 
-	css_put(&from->css);
 	res_counter_uncharge(&from->res, PAGE_SIZE);
 	mem_cgroup_charge_statistics(from, pc, false);
 	if (do_swap_account)
 		res_counter_uncharge(&from->memsw, PAGE_SIZE);
+	css_put(&from->css);
+
+	css_get(&to->css);
 	pc->mem_cgroup = to;
 	mem_cgroup_charge_statistics(to, pc, true);
-	css_get(&to->css);
 	ret = 0;
 out:
 	unlock_page_cgroup(pc);
@@ -1023,8 +1024,10 @@ static int mem_cgroup_move_parent(struct page_cgroup *pc,
 	if (ret || !parent)
 		return ret;
 
-	if (!get_page_unless_zero(page))
-		return -EBUSY;
+	if (!get_page_unless_zero(page)) {
+		ret = -EBUSY;
+		goto uncharge;
+	}
 
 	ret = isolate_lru_page(page);
 
@@ -1033,19 +1036,23 @@ static int mem_cgroup_move_parent(struct page_cgroup *pc,
 
 	ret = mem_cgroup_move_account(pc, child, parent);
 
-	/* drop extra refcnt by try_charge() (move_account increment one) */
-	css_put(&parent->css);
 	putback_lru_page(page);
 	if (!ret) {
 		put_page(page);
+		/* drop extra refcnt by try_charge() */
+		css_put(&parent->css);
 		return 0;
 	}
-	/* uncharge if move fails */
+
 cancel:
+	put_page(page);
+uncharge:
+	/* drop extra refcnt by try_charge() */
+	css_put(&parent->css);
+	/* uncharge if move fails */
 	res_counter_uncharge(&parent->res, PAGE_SIZE);
 	if (do_swap_account)
 		res_counter_uncharge(&parent->memsw, PAGE_SIZE);
-	put_page(page);
 	return ret;
 }
 
