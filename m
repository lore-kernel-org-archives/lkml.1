Return-Path: <linux-kernel-owner+w=401wt.eu-S1759561AbYF2AU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561AbYF2AU1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 20:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbYF2AUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 20:20:19 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:36180 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYF2AUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 20:20:18 -0400
Date: Sun, 29 Jun 2008 01:20:13 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>, Lee Schermerhorn <lee.schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] splitlru: shmem_getpage SetPageSwapBacked sooner
Message-ID: <Pine.LNX.4.64.0806290117510.21758@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shmem_getpage must SetPageSwapBacked before the mem_cgroup_cache_charge,
otherwise try_to_free_mem_cgroup_pages cannot find the shmem/tmpfs pages
it needs to free, and OOMs result.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Should follow mmotm's define-page_file_cache-function.patch

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm/mm/shmem.c	2008-06-27 13:39:20.000000000 +0100
+++ linux/mm/shmem.c	2008-06-27 17:25:41.000000000 +0100
@@ -1369,6 +1369,7 @@ repeat:
 				error = -ENOMEM;
 				goto failed;
 			}
+			SetPageSwapBacked(filepage);
 
 			/* Precharge page while we can wait, compensate after */
 			error = mem_cgroup_cache_charge(filepage, current->mm,
@@ -1381,7 +1382,6 @@ repeat:
 				goto failed;
 			}
 
-			SetPageSwapBacked(filepage);
 			spin_lock(&info->lock);
 			entry = shmem_swp_alloc(info, idx, sgp);
 			if (IS_ERR(entry))
