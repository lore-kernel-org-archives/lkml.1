Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbZIAMny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbZIAMny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 08:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbZIAMnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 08:43:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58827 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314AbZIAMnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 08:43:53 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] Allow changing max_sectors_kb above the default 512
Date: Tue, 1 Sep 2009 18:15:45 +0530
User-Agent: KMail/1.12.0 (Linux/2.6.27.29-0.1-default; KDE/4.3.0; x86_64; ; )
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200909011815.45979.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch "block: Use accessor functions for queue limits"
(ae03bf639a5027d27270123f5f6e3ee6a412781d) changed queue_max_sectors_store()
to use blk_queue_max_sectors() instead of directly assigning the value.

But blk_queue_max_sectors() differs a bit
1. It sets both max_sectors_kb, and max_hw_sectors_kb
2. Never allows one to change max_sectors_kb above BLK_DEF_MAX_SECTORS. If one
specifies a value greater then max_hw_sectors is set to that value but
max_sectors is set to BLK_DEF_MAX_SECTORS

I am not sure whether blk_queue_max_sectors() should be changed, as it seems
to be that way for a long time. And there may be callers dependent on that
behaviour.

This patch simply reverts to the older way of directly assigning the value to
max_sectors as it was before.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 418d636..d3aa2aa 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -133,7 +133,7 @@ queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
 		return -EINVAL;
 
 	spin_lock_irq(q->queue_lock);
-	blk_queue_max_sectors(q, max_sectors_kb << 1);
+	q->limits.max_sectors = max_sectors_kb << 1;
 	spin_unlock_irq(q->queue_lock);
 
 	return ret;
