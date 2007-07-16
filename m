Return-Path: <linux-kernel-owner+w=401wt.eu-S1764103AbXGPNcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764103AbXGPNcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 09:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbXGPNck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 09:32:40 -0400
Received: from mfo11.iij4u.or.jp ([210.138.174.81]:47427 "EHLO
	mfo11.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbXGPNcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 09:32:39 -0400
X-Greylist: delayed 762 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jul 2007 09:32:38 EDT
Message-Id: <200707161319.l6GDJd07027464@mbox.iij4u.or.jp>
To: mark_salyzyn@adaptec.com, jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 00/33] SG table chaining support
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Date: Mon, 16 Jul 2007 22:19:38 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 00/33] SG table chaining support
Date: Mon, 16 Jul 2007 11:47:14 +0200

> Changes since last post:
> 
> - Rebase to current -git. Lots of SCSI drivers have been converted
>   to use the sg accessor helpers, which nicely shrinks this patchset
>   from 70 to 33 patches. Great!

---
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ips: sg chaining support

ips properly uses scsi_for_each_sg for the normal I/O path, however,
the breakup path doesn't.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/ips.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 9f8ed6b..cc5ac4f 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -3251,7 +3251,7 @@ ips_done(ips_ha_t * ha, ips_scb_t * scb)
 		 */
 		if ((scb->breakup) || (scb->sg_break)) {
                         struct scatterlist *sg;
-                        int sg_dma_index, ips_sg_index = 0;
+                        int i, sg_dma_index, ips_sg_index = 0;
 
 			/* we had a data breakup */
 			scb->data_len = 0;
@@ -3260,20 +3260,22 @@ ips_done(ips_ha_t * ha, ips_scb_t * scb)
 
                         /* Spin forward to last dma chunk */
                         sg_dma_index = scb->breakup;
+                        for (i = 0; i < scb->breakup; i++)
+                                sg = sg_next(sg);
 
 			/* Take care of possible partial on last chunk */
                         ips_fill_scb_sg_single(ha,
-                                               sg_dma_address(&sg[sg_dma_index]),
+                                               sg_dma_address(sg),
                                                scb, ips_sg_index++,
-                                               sg_dma_len(&sg[sg_dma_index]));
+                                               sg_dma_len(sg));
 
                         for (; sg_dma_index < scsi_sg_count(scb->scsi_cmd);
-                             sg_dma_index++) {
+                             sg_dma_index++, sg = sg_next(sg)) {
                                 if (ips_fill_scb_sg_single
                                     (ha,
-                                     sg_dma_address(&sg[sg_dma_index]),
+                                     sg_dma_address(sg),
                                      scb, ips_sg_index++,
-                                     sg_dma_len(&sg[sg_dma_index])) < 0)
+                                     sg_dma_len(sg)) < 0)
                                         break;
                         }
 
-- 
1.4.3.2

