Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbYIDMa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbYIDMa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 08:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYIDMaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 08:30:16 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:18459 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbYIDMaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 08:30:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jdYIxiR6dTA/uBmObDiW1HFYg4WNqQ2CPCTyDjz6EZTeZ9x2fogN9nU1HnZ/4mqiDW
         embhUV63p8XmixAiAHhB5ObzzEHmk4czKC/ngPZuMIOitTEDEhXSBU2MPdY0kLw8+xcf
         QLoXkpHEY2FEbgP4mvh0N0esx0ZRTrSc7PjOA=
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Ian Molton <spyro@f2s.com>
Subject: [PATCH] tmio_nand: fix base address programming
Date: Thu,  4 Sep 2008 16:27:44 +0400
Message-Id: <1220531264-1006-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix offset of second word used for programming base address of memory
window. Also program tmio with offset of the FCR, not with physical
memory location.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Ian Molton <spyro@f2s.com>
---
 drivers/mtd/nand/tmio_nand.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/tmio_nand.c b/drivers/mtd/nand/tmio_nand.c
index cbab654..edb1e32 100644
--- a/drivers/mtd/nand/tmio_nand.c
+++ b/drivers/mtd/nand/tmio_nand.c
@@ -109,7 +109,7 @@ struct tmio_nand {
 
 	void __iomem *ccr;
 	void __iomem *fcr;
-	unsigned long fcr_phys;
+	unsigned long fcr_base;
 
 	unsigned int irq;
 
@@ -316,8 +316,8 @@ static int tmio_hw_init(struct platform_device *dev, struct tmio_nand *tmio)
 	tmio_iowrite8(0x81, tmio->ccr + CCR_ICC);
 
 	/* (10h)BaseAddress    0x1000 spba.spba2 */
-	tmio_iowrite16(tmio->fcr_phys, tmio->ccr + CCR_BASE);
-	tmio_iowrite16(tmio->fcr_phys >> 16, tmio->ccr + CCR_BASE + 16);
+	tmio_iowrite16(tmio->fcr_base, tmio->ccr + CCR_BASE);
+	tmio_iowrite16(tmio->fcr_base >> 16, tmio->ccr + CCR_BASE + 2);
 
 	/* (04h)Command Register I/O spcmd */
 	tmio_iowrite8(0x02, tmio->ccr + CCR_COMMAND);
@@ -395,7 +395,7 @@ static int tmio_probe(struct platform_device *dev)
 		goto err_iomap_ccr;
 	}
 
-	tmio->fcr_phys = (unsigned long)fcr->start;
+	tmio->fcr_base = fcr->start & 0xfffff;
 	tmio->fcr = ioremap(fcr->start, fcr->end - fcr->start + 1);
 	if (!tmio->fcr) {
 		retval = -EIO;
-- 
1.5.6.5

