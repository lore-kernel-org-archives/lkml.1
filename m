Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbYDFWyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbYDFWyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 18:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYDFWyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 18:54:03 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:46495 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbYDFWyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 18:54:02 -0400
Date: Sun, 6 Apr 2008 23:56:57 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>,
       Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.ziljstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: fix sense_slab/bio swapping livelock
Message-ID: <Pine.LNX.4.64.0804062348001.19446@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 2.6.25-rc7, I've been seeing an occasional livelock on one
x86_64 machine, copying kernel trees to tmpfs, paging out to swap.

Signature: 6000 pages under writeback but never getting written;
most tasks of interest trying to reclaim, but each get_swap_bio
waiting for a bio in mempool_alloc's io_schedule_timeout(5*HZ);
every five seconds an atomic page allocation failure report from
kblockd failing to allocate a sense_buffer in __scsi_get_command.

__scsi_get_command has a (one item) free_list to protect against
this, but rc1's [SCSI] use dynamically allocated sense buffer
de25deb18016f66dcdede165d07654559bb332bc upset that slightly.
When it fails to allocate from the separate sense_slab, instead
of giving up, it must fall back to the command free_list, which
is sure to have a sense_buffer attached.

Either my earlier -rc testing missed this, or there's some recent
contributory factor.  One very significant factor is SLUB, which
merges slab caches when it can, and on 64-bit happens to merge
both bio cache and sense_slab cache into kmalloc's 128-byte cache:
so that under this swapping load, bios above are liable to gobble
up all the slots needed for scsi_cmnd sense_buffers below.

That's disturbing behaviour, and I tried a few things to fix it.
Adding a no-op constructor to the sense_slab inhibits SLUB from
merging it, and stops all the allocation failures I was seeing;
but it's rather a hack, and perhaps in different configurations
we have other caches on the swapout path which are ill-merged.

Another alternative is to revert the separate sense_slab, using
cache-line-aligned sense_buffer allocated beyond scsi_cmnd from
the one kmem_cache; but that might waste more memory, and is
only a way of diverting around the known problem.

While I don't like seeing the allocation failures, and hate the
idea of all those bios piled up above a scsi host working one by
one, it does seem to emerge fairly soon with the livelock fix.
So lacking better ideas, stick with that one clear fix for now.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 drivers/scsi/scsi.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- 2.6.25-rc8/drivers/scsi/scsi.c	2008-03-05 10:47:40.000000000 +0000
+++ linux/drivers/scsi/scsi.c	2008-04-05 22:23:40.000000000 +0100
@@ -181,6 +181,18 @@ struct scsi_cmnd *__scsi_get_command(str
 	cmd = kmem_cache_alloc(shost->cmd_pool->cmd_slab,
 			       gfp_mask | shost->cmd_pool->gfp_mask);
 
+	if (likely(cmd)) {
+		buf = kmem_cache_alloc(shost->cmd_pool->sense_slab,
+				       gfp_mask | shost->cmd_pool->gfp_mask);
+		if (likely(buf)) {
+			memset(cmd, 0, sizeof(*cmd));
+			cmd->sense_buffer = buf;
+		} else {
+			kmem_cache_free(shost->cmd_pool->cmd_slab, cmd);
+			cmd = NULL;
+		}
+	}
+
 	if (unlikely(!cmd)) {
 		unsigned long flags;
 
@@ -197,16 +209,6 @@ struct scsi_cmnd *__scsi_get_command(str
 			memset(cmd, 0, sizeof(*cmd));
 			cmd->sense_buffer = buf;
 		}
-	} else {
-		buf = kmem_cache_alloc(shost->cmd_pool->sense_slab,
-				       gfp_mask | shost->cmd_pool->gfp_mask);
-		if (likely(buf)) {
-			memset(cmd, 0, sizeof(*cmd));
-			cmd->sense_buffer = buf;
-		} else {
-			kmem_cache_free(shost->cmd_pool->cmd_slab, cmd);
-			cmd = NULL;
-		}
 	}
 
 	return cmd;
