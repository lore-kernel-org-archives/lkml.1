Return-Path: <linux-kernel-owner+w=401wt.eu-S1767824AbXEDKqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767824AbXEDKqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 06:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767831AbXEDKpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 06:45:11 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:46698 "EHLO
	amsfep12-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S2993226AbXEDKfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 06:35:46 -0400
Message-Id: <20070504103202.718545249@chello.nl>
References: <20070504102651.923946304@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 04 May 2007 12:27:22 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>
Subject: [PATCH 31/40] mm: balance_dirty_pages() vs throttle_vm_writeout() deadlock
Content-Disposition: inline; filename=nfs_mm-throttle_vm_writeout.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If we have a lot of dirty memory and hit the throttle in balance_dirty_pages()
we (potentially) generate a lot of writeback and unstable pages, if however
during this writeback we need to reclaim a bit, we might hit
throttle_vm_writeout(), which might delay us until the combined total of
NR_UNSTABLE_NFS + NR_WRITEBACK falls below the dirty limit.

However unstable pages don't go away automagickally, they need a push. While
balance_dirty_pages() does this push, throttle_vm_writeout() doesn't. So we can
sit here ad infintum.

Hence I propose to remove the NR_UNSTABLE_NFS count from throttle_vm_writeout().

Akpm's recent GFP checks don't much change this picture, any __GFP_IO|__GFP_FS
alloc can still get stalled by this. It turns into a deadlock when swapping
over NFS.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/page-writeback.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6-git/mm/page-writeback.c
===================================================================
--- linux-2.6-git.orig/mm/page-writeback.c	2007-03-06 17:44:23.000000000 +0100
+++ linux-2.6-git/mm/page-writeback.c	2007-03-15 15:09:16.000000000 +0100
@@ -320,8 +320,7 @@ void throttle_vm_writeout(gfp_t gfp_mask
                  */
                 dirty_thresh += dirty_thresh / 10;      /* wheeee... */
 
-                if (global_page_state(NR_UNSTABLE_NFS) +
-			global_page_state(NR_WRITEBACK) <= dirty_thresh)
+                if (global_page_state(NR_WRITEBACK) <= dirty_thresh)
                         	break;
                 congestion_wait(WRITE, HZ/10);
         }

--

