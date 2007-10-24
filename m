Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbXJXKt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbXJXKt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 06:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756413AbXJXKs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 06:48:56 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:37724 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756264AbXJXKsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 06:48:54 -0400
Date: Wed, 24 Oct 2007 19:48:30 +0900
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       James.Bottomley@SteelEye.com, jeff@garzik.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH -mm 09/11] call blk_queue_segment_boundary in
 __scsi_alloc_queue
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071024172611B.tomof@acm.org>
X-Dispatcher: imput version 20050308(IM148)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

request_queue and device struct must have the same value of a segment
size limit. This patch adds blk_queue_segment_boundary in
__scsi_alloc_queue so LLDs don't need to call both
blk_queue_segment_boundary and set_dma_max_seg_size. A LLD can change
the default value (64KB) can call device_dma_parameters accessors like
pci_set_dma_max_seg_size when allocating scsi_host.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_lib.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 61fdaf0..23a30ab 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1645,6 +1645,7 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 					 request_fn_proc *request_fn)
 {
 	struct request_queue *q;
+	struct device *dev = shost->shost_gendev.parent;
 
 	q = blk_init_queue(request_fn, NULL);
 	if (!q)
@@ -1673,6 +1674,8 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
 	blk_queue_segment_boundary(q, shost->dma_boundary);
 
+	blk_queue_max_segment_size(q, dma_get_max_seg_size(dev));
+
 	if (!shost->use_clustering)
 		clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
 	return q;
-- 
1.5.2.4

