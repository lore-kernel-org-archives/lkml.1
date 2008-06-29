Return-Path: <linux-kernel-owner+w=401wt.eu-S1759317AbYF2AOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbYF2AOf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 20:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbYF2AO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 20:14:27 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:33992 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbYF2AO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 20:14:26 -0400
Date: Sun, 29 Jun 2008 01:14:30 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] memcg: shmem_getpage release page sooner
In-Reply-To: <Pine.LNX.4.64.0806290108110.20280@blonde.site>
Message-ID: <Pine.LNX.4.64.0806290113350.20280@blonde.site>
References: <Pine.LNX.4.64.0806290108110.20280@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No big deal, but since mem_cgroup_shrink_usage doesn't require a page to
operate upon, page_cache_release the swappage before calling it, so it's
not pinned across the reclaim.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Should follow mmotm's memcg-helper-function-for-relcaim-from-shmem.patch

 mm/shmem.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- mmotm/mm/shmem.c	2008-06-27 13:39:20.000000000 +0100
+++ linux/mm/shmem.c	2008-06-27 17:25:41.000000000 +0100
@@ -1315,16 +1315,14 @@ repeat:
 			shmem_swp_unmap(entry);
 			spin_unlock(&info->lock);
 			unlock_page(swappage);
+			page_cache_release(swappage);
 			if (error == -ENOMEM) {
 				/* allow reclaim from this memory cgroup */
 				error = mem_cgroup_shrink_usage(current->mm,
-					gfp & ~__GFP_HIGHMEM);
-				if (error) {
-					page_cache_release(swappage);
+								gfp);
+				if (error)
 					goto failed;
-				}
 			}
-			page_cache_release(swappage);
 			goto repeat;
 		}
 	} else if (sgp == SGP_READ && !filepage) {
