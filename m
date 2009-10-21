Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbZJUQVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbZJUQVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 12:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbZJUQVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 12:21:31 -0400
Received: from smtp.nokia.com ([192.100.122.233]:60803 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbZJUQVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 12:21:31 -0400
Date: Wed, 21 Oct 2009 19:14:36 +0300
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [PATCH 2/2] Disk hot removal causing oopses and fixes
Message-ID: <20091021161436.GA17973@angel.research.nokia.com>
Reply-To: Jarkko Lavinen <jarkko.lavinen@nokia.com>
References: <20091021161201.GA16968@angel.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091021161201.GA16968@angel.research.nokia.com>
X-Operating-System: GNU/Linux angel.research.nokia.com
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 21 Oct 2009 16:21:25.0581 (UTC) FILETIME=[893A97D0:01CA526A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ff822af94f86dbe559b7649b7f71c464260ef353 Mon Sep 17 00:00:00 2001
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Date: Wed, 21 Oct 2009 18:53:20 +0300
Subject: [PATCH 2/2] block: Protect elevator from too early release

When a disk is being removed, blk_put_queue calls elevator exit function
which will release the elevator while the elevator may still be in use.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
---
 block/blk-core.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index ac0fa10..da56586 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1173,6 +1173,13 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 	 */
 	blk_queue_bounce(q, &bio);
 
+	mutex_lock(&q->elevator->sysfs_lock);
+	if (test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)) {
+		mutex_unlock(&q->elevator->sysfs_lock);
+		bio_endio(bio, -EIO);
+		return 0;
+	}
+
 	spin_lock_irq(q->queue_lock);
 
 	if (unlikely(bio_rw_flagged(bio, BIO_RW_BARRIER)) || elv_queue_empty(q))
@@ -1275,6 +1282,8 @@ out:
 	if (unplug || !queue_should_plug(q))
 		__generic_unplug_device(q);
 	spin_unlock_irq(q->queue_lock);
+	mutex_unlock(&q->elevator->sysfs_lock);
+
 	return 0;
 }
 
-- 
1.6.3.3

