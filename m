Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab0COEcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 00:32:47 -0400
Received: from rcpt-expgw.biglobe.ne.jp ([133.205.19.66]:46392 "EHLO
	rcpt-expgw.biglobe.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab0COEco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 00:32:44 -0400
X-Biglobe-Sender: <d-nishimura@mtf.biglobe.ne.jp>
Date: Mon, 15 Mar 2010 13:35:50 +0900
From: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@in.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH -rc] memcg: disable move charge in no mmu case
Message-Id: <20100315133550.50e1393c.d-nishimura@mtf.biglobe.ne.jp>
Reply-To: nishimura@mxp.nes.nec.co.jp
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 02491447(memcg: move charges of anonymous swap), I tried to disable
move charge feature in no mmu case by enclosing all the related functions
with "#ifdef CONFIG_MMU", but the commit places these ifdefs in wrong place.
(it seems that it's mangled while handling some fixes...)

This patch fixes it up.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 mm/memcontrol.c |   44 ++++++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7973b52..00dda35 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3946,28 +3946,6 @@ one_by_one:
 	}
 	return ret;
 }
-#else	/* !CONFIG_MMU */
-static int mem_cgroup_can_attach(struct cgroup_subsys *ss,
-				struct cgroup *cgroup,
-				struct task_struct *p,
-				bool threadgroup)
-{
-	return 0;
-}
-static void mem_cgroup_cancel_attach(struct cgroup_subsys *ss,
-				struct cgroup *cgroup,
-				struct task_struct *p,
-				bool threadgroup)
-{
-}
-static void mem_cgroup_move_task(struct cgroup_subsys *ss,
-				struct cgroup *cont,
-				struct cgroup *old_cont,
-				struct task_struct *p,
-				bool threadgroup)
-{
-}
-#endif
 
 /**
  * is_target_pte_for_mc - check a pte whether it is valid for move charge
@@ -4330,6 +4308,28 @@ static void mem_cgroup_move_task(struct cgroup_subsys *ss,
 	}
 	mem_cgroup_clear_mc();
 }
+#else	/* !CONFIG_MMU */
+static int mem_cgroup_can_attach(struct cgroup_subsys *ss,
+				struct cgroup *cgroup,
+				struct task_struct *p,
+				bool threadgroup)
+{
+	return 0;
+}
+static void mem_cgroup_cancel_attach(struct cgroup_subsys *ss,
+				struct cgroup *cgroup,
+				struct task_struct *p,
+				bool threadgroup)
+{
+}
+static void mem_cgroup_move_task(struct cgroup_subsys *ss,
+				struct cgroup *cont,
+				struct cgroup *old_cont,
+				struct task_struct *p,
+				bool threadgroup)
+{
+}
+#endif
 
 struct cgroup_subsys mem_cgroup_subsys = {
 	.name = "memory",
-- 
1.6.3.3




