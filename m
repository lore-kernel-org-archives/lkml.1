Return-Path: <linux-kernel-owner+w=401wt.eu-S1762545AbXHVMec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762545AbXHVMec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 08:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760803AbXHVMdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 08:33:05 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:57084 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760050AbXHVMc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 08:32:57 -0400
Message-Id: <20070822123642.759669672@de.ibm.com>
References: <20070822123603.501231302@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 14:36:07 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: "Klaus D. Wacker" <kdwacker@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 04/10] qdio: Refresh buffer states for IQDIO Asynchronous output queue
Content-Disposition: inline; filename=004-qdio-hang.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Klaus D. Wacker <kdwacker@de.ibm.com>

Hipersocket Multicast queue works asynchronously. When sending buffers,
the buffer state change may happen delayed. The tasklet for checking
changes in the outbound queue excluded IQDIO async queues from this
process. This created either a hang situation when the queue ran full,
or presented a hang situation a interface close time.
The tasklet processing is changed to include IQDIO async queues when
requesting buffer state refresh.

Signed-off-by: Klaus D. Wacker <kdwacker@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/qdio.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: quilt-2.6/drivers/s390/cio/qdio.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/qdio.c
+++ quilt-2.6/drivers/s390/cio/qdio.c
@@ -742,7 +742,8 @@ qdio_get_outbound_buffer_frontier(struct
 	first_not_to_check=f+qdio_min(atomic_read(&q->number_of_buffers_used),
 				      (QDIO_MAX_BUFFERS_PER_Q-1));
 
-	if ((!q->is_iqdio_q)&&(!q->hydra_gives_outbound_pcis))
+	if (((!q->is_iqdio_q) && (!q->hydra_gives_outbound_pcis)) ||
+		 (q->queue_type == QDIO_IQDIO_QFMT_ASYNCH))
 		SYNC_MEMORY;
 
 check_next:

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

