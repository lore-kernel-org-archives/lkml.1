Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbZAMKg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbZAMKg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 05:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbZAMKgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 05:36:51 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:59417 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbZAMKgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 05:36:50 -0500
Date: Tue, 13 Jan 2009 18:48:54 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, nishimura@mxp.nes.nec.co.jp
Subject: [PATCH 2/4] memcg: fix error path of mem_cgroup_move_parent
Message-Id: <20090113184854.87a37a88.nishimura@mxp.nes.nec.co.jp>
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
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---
 mm/memcontrol.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b665127..7be9b35 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -994,14 +994,15 @@ static int mem_cgroup_move_account(struct page_cgroup *pc,
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
@@ -1034,8 +1035,10 @@ static int mem_cgroup_move_parent(struct page_cgroup *pc,
 	if (ret || !parent)
 		return ret;
 
-	if (!get_page_unless_zero(page))
-		return -EBUSY;
+	if (!get_page_unless_zero(page)) {
+		ret = -EBUSY;
+		goto uncharge;
+	}
 
 	ret = isolate_lru_page(page);
 
@@ -1044,19 +1047,23 @@ static int mem_cgroup_move_parent(struct page_cgroup *pc,
 
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
 
