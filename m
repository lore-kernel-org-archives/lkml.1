Return-Path: <linux-kernel-owner+w=401wt.eu-S1761404AbYDNOVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761404AbYDNOVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757611AbYDNOUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:20:23 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:44696 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759490AbYDNOUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:20:21 -0400
Date: Mon, 14 Apr 2008 09:20:19 -0500
From: scameron@beardog.cca.cpqcorp.net
To: linux-kernel@vger.kernel.org, axboe@kernel.dk, mike.miller@hp.com,
       mikem@beardog.cca.cpqcorp.net
Subject: [patch] cciss: Fix race between disk-adding code and interrupt handler
Message-ID: <20080414142019.GG16584@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Fix race condition between cciss_init_one(), cciss_update_drive_info(),
and cciss_check_queues().  cciss_softirq_done would try to start
queues which were not quite ready to be started, as its checks for
readiness were not sufficiently synchronized with the queue initializing
code in cciss_init_one and cciss_update_drive_info.  Slow cpu and
large numbers of logical drives seem to make the race more likely 
to cause a problem.


Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>

---

 linux-2.6.25-rc9/drivers/block/cciss.c |   25 ++++++++++++++++++++++++-
 linux-2.6.25-rc9/drivers/block/cciss.h |    3 +++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff -puN linux-2.6.25-rc9/drivers/block/cciss.c~cciss_init_one_race linux-2.6.25-rc9/drivers/block/cciss.c
--- linux-2.6.25-rc9/linux-2.6.25-rc9/drivers/block/cciss.c~cciss_init_one_race	2008-04-14 08:21:03.000000000 -0500
+++ linux-2.6.25-rc9-scameron/linux-2.6.25-rc9/drivers/block/cciss.c	2008-04-14 08:22:04.000000000 -0500
@@ -1270,7 +1270,9 @@ static void cciss_check_queues(ctlr_info
 		/* make sure the disk has been added and the drive is real
 		 * because this can be called from the middle of init_one.
 		 */
-		if (!(h->drv[curr_queue].queue) || !(h->drv[curr_queue].heads))
+		if (!(h->drv[curr_queue].queue) ||
+			!(h->drv[curr_queue].heads) ||
+			!h->drv[curr_queue].queue_ready)
 			continue;
 		blk_start_queue(h->gendisk[curr_queue]->queue);
 
@@ -1394,6 +1396,11 @@ geo_inq:
 
 	/* if it's the controller it's already added */
 	if (drv_index) {
+
+		/* Prevent race with interrupt handler's queue starting code. */
+		h->drv[drv_index].queue_ready = 0;
+		wmb();
+
 		disk->queue = blk_init_queue(do_cciss_request, &h->lock);
 		sprintf(disk->disk_name, "cciss/c%dd%d", ctlr, drv_index);
 		disk->major = h->major;
@@ -1420,6 +1427,11 @@ geo_inq:
 					hba[ctlr]->drv[drv_index].block_size);
 
 		h->drv[drv_index].queue = disk->queue;
+
+		/* Prevent race with interrupt handler's queue starting code. */
+		wmb();
+		h->drv[drv_index].queue_ready = 1;
+
 		add_disk(disk);
 	}
 
@@ -3473,6 +3485,11 @@ static int __devinit cciss_init_one(stru
 		struct gendisk *disk = hba[i]->gendisk[j];
 		struct request_queue *q;
 
+		/* prevent race with interrupt handler's */
+		/* queue starting code. */
+		drv->queue_ready = 0;
+		wmb();
+
 		/* Check if the disk was allocated already */
 		if (!disk){
 			hba[i]->gendisk[j] = alloc_disk(1 << NWD_SHIFT);
@@ -3520,6 +3537,12 @@ static int __devinit cciss_init_one(stru
 			continue;
 		blk_queue_hardsect_size(q, drv->block_size);
 		set_capacity(disk, drv->nr_blocks);
+
+		/* prevent race with interrupt handler's */
+		/* queue starting code. */
+		wmb();
+		drv->queue_ready = 1;
+
 		add_disk(disk);
 		j++;
 	} while (j <= hba[i]->highest_lun);
diff -puN linux-2.6.25-rc9/drivers/block/cciss.h~cciss_init_one_race linux-2.6.25-rc9/drivers/block/cciss.h
--- linux-2.6.25-rc9/linux-2.6.25-rc9/drivers/block/cciss.h~cciss_init_one_race	2008-04-14 08:21:06.000000000 -0500
+++ linux-2.6.25-rc9-scameron/linux-2.6.25-rc9/drivers/block/cciss.h	2008-04-14 08:21:58.000000000 -0500
@@ -39,6 +39,9 @@ typedef struct _drive_info_struct
 				   *to prevent it from being opened or it's queue
 				   *from being started.
 				  */
+	int queue_ready; /* This is used to prevent the interrupt handler */
+			 /* from racing (while starting up queues) with */
+			 /* cciss_init_one() (while setting up new queues) */
 } drive_info_struct;
 
 #ifdef CONFIG_CISS_SCSI_TAPE
_
