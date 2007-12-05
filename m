Return-Path: <linux-kernel-owner+w=401wt.eu-S1753474AbXLEDaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbXLEDaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 22:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXLEDaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 22:30:04 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:54710 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbXLEDaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 22:30:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=f3St2lGCkVJpo+94bjZCM3Rgocf9U5ZQre3GYg/rGPiGiyWUG5pUoiIBoZhRlCgYHOo9RHe+s6K0zGxWLoxUD7fFqvBV59om6W8Ts/059QA7AMfFksjvEGzg13mtDZneRlQpOwqWtrX1cxFxK28VCKFQtupO/aGo7DXaymMFqqk=
Message-ID: <47561B33.3050607@gmail.com>
Date: Wed, 05 Dec 2007 12:29:55 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] block: use jiffies conversion functions in scsi_ioctl.c
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use msecs_to_jiffies() and jiffies_to_msecs() in scsi_ioctl().
Sometimes callers use very large values for e.g. vendor specific media
clear command and calculation can overflow.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 block/scsi_ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 91c7322..9675b34 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -230,7 +230,7 @@ static int blk_fill_sghdr_rq(struct request_queue *q, struct request *rq,
 	rq->cmd_len = hdr->cmd_len;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 
-	rq->timeout = (hdr->timeout * HZ) / 1000;
+	rq->timeout = msecs_to_jiffies(hdr->timeout);
 	if (!rq->timeout)
 		rq->timeout = q->sg_timeout;
 	if (!rq->timeout)
@@ -366,7 +366,7 @@ static int sg_io(struct file *file, struct request_queue *q,
 	 */
 	blk_execute_rq(q, bd_disk, rq, 0);
 
-	hdr->duration = ((jiffies - start_time) * 1000) / HZ;
+	hdr->duration = jiffies_to_msecs(jiffies - start_time);
 
 	return blk_complete_sghdr_rq(rq, hdr, bio);
 out:

