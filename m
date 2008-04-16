Return-Path: <linux-kernel-owner+w=401wt.eu-S932926AbYDPPii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926AbYDPPii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 11:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757432AbYDPPia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 11:38:30 -0400
Received: from nebensachen.de ([195.34.83.29]:39902 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756613AbYDPPi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:38:29 -0400
X-Hashcash: 1:20:080416:jens.axboe@oracle.com::UAsddI3BFIbEzX2m:00000000000000000000000000000000000000001KGq
X-Hashcash: 1:20:080416:linux-kernel@vger.kernel.org::Hh70Nx9BlpKWovef:0000000000000000000000000000000000HyV
X-Hashcash: 1:20:080416:stable@kernel.org::jYeNOt+U+IvBbYDI:0000000000000000000000000000000000000000000010Gc
From: Elias Oltmanns <eo@nebensachen.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Block: Prevent busy looping
Message-ID: <20080416151305.8788.63912.stgit@denkblock.local>
User-Agent: StGIT/0.12.1
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Date: Wed, 16 Apr 2008 17:37:48 +0200
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_run_queue() as well as blk_start_queue() plug the device on reentry
and schedule blk_unplug_work() right afterwards. However,
blk_plug_device() takes care of that already and makes sure that there is
a short delay before blk_unplug_work() is scheduled. This is important
to prevent busy looping and possibly system lockups as observed here:
<http://permalink.gmane.org/gmane.linux.ide/28351>.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
Cc: <stable@kernel.org>
---

 block/blk-core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2a438a9..e88a6f2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -344,7 +344,6 @@ void blk_start_queue(struct request_queue *q)
 		clear_bit(QUEUE_FLAG_REENTER, &q->queue_flags);
 	} else {
 		blk_plug_device(q);
-		kblockd_schedule_work(&q->unplug_work);
 	}
 }
 EXPORT_SYMBOL(blk_start_queue);
@@ -412,7 +411,6 @@ void blk_run_queue(struct request_queue *q)
 			clear_bit(QUEUE_FLAG_REENTER, &q->queue_flags);
 		} else {
 			blk_plug_device(q);
-			kblockd_schedule_work(&q->unplug_work);
 		}
 	}
 


