Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbZFHDLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbZFHDLx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 23:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbZFHDLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 23:11:46 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:59555 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbZFHDLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 23:11:46 -0400
Date: Mon, 8 Jun 2009 12:02:28 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH mmotm] vmscan: fix may_swap handling for memcg
Message-Id: <20090608120228.cb70e569.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Commit 2e2e425989080cc534fc0fca154cae515f971cf5 ("vmscan,memcg: reintroduce
sc->may_swap) add may_swap flag and handle it at get_scan_ratio().

But the result of get_scan_ratio() is ignored when priority == 0, and this
means, when memcg hits the mem+swap limit, anon pages can be swapped
just in vain. Especially when memcg causes oom by mem+swap limit,
we can see many and many pages are swapped out.

Instead of not scanning anon lru completely when priority == 0, this patch adds
a hook to handle may_swap flag in shrink_page_list() to avoid using useless swaps,
and calls try_to_free_swap() if needed because it can reduce
both mem.usage and memsw.usage if the page(SwapCache) is unused anymore.

Such unused-but-managed-under-memcg SwapCache can be made in some paths,
for example trylock_page() failure in free_swap_cache().

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 mm/vmscan.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2ddcfc8..d9a3f54 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -640,6 +640,25 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 					referenced && page_mapping_inuse(page))
 			goto activate_locked;
 
+		if (!sc->may_swap && PageSwapBacked(page)) {
+			/* SwapCache has already uses swap entry */
+			if (!PageSwapCache(page))
+				goto keep_locked;
+			/*
+			 * From the view point of memcg, may_swap is false when
+			 * memsw.usage hits the limit.
+			 * But swaping out SwapCache to disk doesn't reduce the
+			 * memsw.usage, so it is a waste of time.
+			 * Call try_to_free_swap() if the page isn't used,
+			 * because it can reduce both mem.usage and memsw.usage.
+			 */
+			if (!scanning_global_lru(sc)) {
+				if (!page_mapped(page))
+					try_to_free_swap(page);
+				goto keep_locked;
+			}
+		}
+
 		/*
 		 * Anonymous process memory has backing store?
 		 * Try to allocate it some swap space here.
