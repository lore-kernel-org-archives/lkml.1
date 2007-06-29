Return-Path: <linux-kernel-owner+w=401wt.eu-S932107AbXF2OOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbXF2OOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 10:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932379AbXF2ON1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 10:13:27 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:4824 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766010AbXF2ONZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 10:13:25 -0400
Message-Id: <20070629141527.557443600@de.ibm.com>
References: <20070629135530.912094590@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Jun 2007 15:55:31 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 1/5] avoid tlb gather restarts.
Content-Disposition: inline; filename=002-flush-restarts.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

If need_resched() is false it is unnecessary to call tlb_finish_mmu()
and tlb_gather_mmu() for each vma in unmap_vmas(). Moving the tlb gather
restart under the if that contains the cond_resched() will avoid
unnecessary tlb flush operations that are triggered by tlb_finish_mmu() 
and tlb_gather_mmu().

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 mm/memory.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff -urpN linux-2.6/mm/memory.c linux-2.6-patched/mm/memory.c
--- linux-2.6/mm/memory.c	2007-06-29 15:44:08.000000000 +0200
+++ linux-2.6-patched/mm/memory.c	2007-06-29 15:44:08.000000000 +0200
@@ -851,19 +851,18 @@ unsigned long unmap_vmas(struct mmu_gath
 				break;
 			}
 
-			tlb_finish_mmu(*tlbp, tlb_start, start);
-
 			if (need_resched() ||
 				(i_mmap_lock && need_lockbreak(i_mmap_lock))) {
+				tlb_finish_mmu(*tlbp, tlb_start, start);
 				if (i_mmap_lock) {
 					*tlbp = NULL;
 					goto out;
 				}
 				cond_resched();
+				*tlbp = tlb_gather_mmu(vma->vm_mm, fullmm);
+				tlb_start_valid = 0;
 			}
 
-			*tlbp = tlb_gather_mmu(vma->vm_mm, fullmm);
-			tlb_start_valid = 0;
 			zap_work = ZAP_BLOCK_SIZE;
 		}
 	}

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

