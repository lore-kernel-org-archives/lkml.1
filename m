Return-Path: <linux-kernel-owner+w=401wt.eu-S1758899AbYHULhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899AbYHULhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 07:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757701AbYHULg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 07:36:57 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:50798 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759198AbYHULg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 07:36:56 -0400
X-IronPort-AV: E=Sophos;i="4.32,245,1217822400"; 
   d="scan'208";a="16778564"
Message-ID: <48AD5373.201@citrix.com>
Date: Thu, 21 Aug 2008 12:37:23 +0100
From: Alex Nixon <alex.nixon@citrix.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Xen: Fix warning when hot-unplugging virtual block devices
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Aug 2008 11:36:50.0513 (UTC) FILETIME=[33B87C10:01C90382]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Nixon <alex.nixon@citrix.com>
Date: Thu, 21 Aug 2008 12:30:54 +0100
Subject: [PATCH] Xen: Fix warning when hot-unplugging virtual block devices

WARNING: at kernel/softirq.c:136 local_bh_enable+0x3f/0x8a()

del_gendisk needs IRQs enabled, as the code path eventually reaches local_bh_enable.
blk_stop_queue needs them disabled - so do so temporarily.

It shouldn't matter if an interrupt comes in whilst blkif_io_lock is held, as it will block on the lock.  Upon acquisition, it'll realise the device is down and exit cleanly.

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
---
 drivers/block/xen-blkfront.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index d5e7532..95cee2c 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -899,16 +899,18 @@ static void blkfront_closing(struct xenbus_device *dev)
 	if (info->rq == NULL)
 		goto out;
 
-	spin_lock_irqsave(&blkif_io_lock, flags);
+	spin_lock(&blkif_io_lock);
 
 	del_gendisk(info->gd);
 
+	local_irq_save(flags);
 	/* No more blkif_request(). */
 	blk_stop_queue(info->rq);
+	local_irq_restore(flags);
 
 	/* No more gnttab callback work. */
 	gnttab_cancel_free_callback(&info->callback);
-	spin_unlock_irqrestore(&blkif_io_lock, flags);
+	spin_unlock(&blkif_io_lock);
 
 	/* Flush gnttab callback work. Must be done with no locks held. */
 	flush_scheduled_work();
-- 
1.5.4.3

