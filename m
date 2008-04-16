Return-Path: <linux-kernel-owner+w=401wt.eu-S1755028AbYDPS7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbYDPS7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755326AbYDPS70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:59:26 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:19562 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbYDPS7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:59:25 -0400
Date: Wed, 16 Apr 2008 13:59:24 -0500
From: scameron@beardog.cca.cpqcorp.net
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, mike.miller@hp.com,
       mikem@beardog.cca.cpqcorp.net
Subject: Re: [patch] cciss: Fix race between disk-adding code and interrupt handler
Message-ID: <20080416185924.GP16584@beardog.cca.cpqcorp.net>
References: <20080414142019.GG16584@beardog.cca.cpqcorp.net> <20080414170505.GO12774@kernel.dk> <20080414172716.GM16584@beardog.cca.cpqcorp.net> <20080414173720.GQ12774@kernel.dk> <20080414174540.GO16584@beardog.cca.cpqcorp.net> <20080414175219.GR12774@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414175219.GR12774@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix race condition between cciss_init_one(), cciss_update_drive_info(),
and cciss_check_queues(). 

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>

---

 linux-2.6.25-rc9/drivers/block/cciss.c |   17 ++++++++++++++++-
 drivers/block/cciss.h                  |    0 
 2 files changed, 16 insertions(+), 1 deletion(-)

diff -puN linux-2.6.25-rc9/drivers/block/cciss.c~cciss_init_one_race linux-2.6.25-rc9/drivers/block/cciss.c
--- linux-2.6.25-rc9/linux-2.6.25-rc9/drivers/block/cciss.c~cciss_init_one_race	2008-04-14 08:21:03.000000000 -0500
+++ linux-2.6.25-rc9-scameron/linux-2.6.25-rc9/drivers/block/cciss.c	2008-04-16 08:15:38.000000000 -0500
@@ -1349,6 +1349,10 @@ static void cciss_update_drive_info(int 
 		spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
 		h->drv[drv_index].busy_configuring = 1;
 		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+
+		/* deregister_disk sets h->drv[drv_index].queue = NULL */
+		/* which keeps the interrupt handler from starting */
+		/* the queue. */
 		ret = deregister_disk(h->gendisk[drv_index],
 				      &h->drv[drv_index], 0);
 		h->drv[drv_index].busy_configuring = 0;
@@ -1419,6 +1423,10 @@ geo_inq:
 		blk_queue_hardsect_size(disk->queue,
 					hba[ctlr]->drv[drv_index].block_size);
 
+		/* Make sure all queue data is written out before */
+		/* setting h->drv[drv_index].queue, as setting this */
+		/* allows the interrupt handler to start the queue */
+		wmb();
 		h->drv[drv_index].queue = disk->queue;
 		add_disk(disk);
 	}
@@ -3520,10 +3528,17 @@ static int __devinit cciss_init_one(stru
 			continue;
 		blk_queue_hardsect_size(q, drv->block_size);
 		set_capacity(disk, drv->nr_blocks);
-		add_disk(disk);
 		j++;
 	} while (j <= hba[i]->highest_lun);
 
+	/* Make sure all queue data is written out before */
+	/* interrupt handler, triggered by add_disk,  */
+	/* is allowed to start them. */
+	wmb();
+
+	for (j = 0; j <= hba[i]->highest_lun; j++)
+		add_disk(hba[i]->gendisk[j]);
+
 	return 1;
 
       clean4:
diff -puN linux-2.6.25-rc9/drivers/block/cciss.h~cciss_init_one_race linux-2.6.25-rc9/drivers/block/cciss.h
_

