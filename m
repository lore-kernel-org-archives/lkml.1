Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbZBPASs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbZBPASs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 19:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756127AbZBPANw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 19:13:52 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:41106 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587AbZBPANu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 19:13:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=jnSgIv0Cj91gNBxHkj9LzsADLYZsTaR8MHIK4Ti5O6QbPXltss48/fbA06VDT2M0Ip
         duLos1Zzzw6H2voOA8KWW/aJFZBj3qVD290Ny/1E8YPz+Mtnp/gkDGfZmu9R7CfFaAc0
         Jq8zt1q6NEEymashYTkg4Uya/6AbIpdiebttQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 16 Feb 2009 01:15:15 +0100
Message-Id: <20090216001515.27491.83644.sendpatchset@localhost.localdomain>
In-Reply-To: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
References: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
Subject: [PATCH 19/20] ide-cd: use common completion path for DMA requests in cdrom_newpc_intr()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-cd: use common completion path for DMA requests in cdrom_newpc_intr()

Use the following facts:

- rq->nr_sectors should now be always equal to (non-zero)
  rq->hard_nr_sectors for fs requests

- REQ_TYPE_ATA_PC requests have never bio attached to them

- rq->hard_nr_sectors == 0 for REQ_TYPE_ATA_PC requests

- DMA is used only for fs, pc and REQ_TYPE_ATA_PC requests

- 'uptodate' is ignored for pc requests ('rc == 0' case)

and use the common completion path also for DMA requests.

There should be no functional changes caused by this patch

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
drivers/ide/ide-cd.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -660,16 +660,7 @@ static ide_startstop_t cdrom_newpc_intr(
 	if (dma) {
 		if (dma_error)
 			return ide_error(drive, "dma error", stat);
-		if (blk_fs_request(rq)) {
-			ide_complete_rq(drive, 0, rq->nr_sectors
-				? (rq->nr_sectors << 9) : ide_rq_bytes(rq));
-			return ide_stopped;
-		} else if (rq->cmd_type == REQ_TYPE_ATA_PC && !rq->bio) {
-			ide_complete_rq(drive, 0, 512);
-			return ide_stopped;
-		}
-		if (blk_pc_request(rq) == 0 && uptodate == 0)
-			rq->cmd_flags |= REQ_FAILED;
+		uptodate = 1;
 		goto out_end;
 	}
 
