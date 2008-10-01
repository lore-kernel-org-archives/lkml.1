Return-Path: <linux-kernel-owner+w=401wt.eu-S1755031AbYJAI73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbYJAI73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 04:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbYJAI5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 04:57:23 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:35806 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbYJAI5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 04:57:13 -0400
Message-Id: <20081001084130.116866217@de.ibm.com>
References: <20081001083317.782967473@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 01 Oct 2008 10:33:36 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Stefan Haberland <stefan.haberland@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 19/21] dasd: fix message flood for unsolicited interrupts
Content-Disposition: inline; filename=118-dasd-flooding.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Haberland <stefan.haberland@de.ibm.com>

In the unsolicited interupt handler fake IRBs from CIO have to be
ignored because there is nothing to do. 
The function dump_sense should not be called if there is no sense 
data available.

Signed-off-by: Stefan Haberland <stefan.haberland@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/block/dasd_eckd.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

Index: quilt-2.6/drivers/s390/block/dasd_eckd.c
===================================================================
--- quilt-2.6.orig/drivers/s390/block/dasd_eckd.c
+++ quilt-2.6/drivers/s390/block/dasd_eckd.c
@@ -1501,12 +1501,27 @@ static void dasd_eckd_handle_unsolicited
 		return;
 	}
 
-	/* just report other unsolicited interrupts */
-	DEV_MESSAGE(KERN_DEBUG, device, "%s",
-		    "unsolicited interrupt received");
-	device->discipline->dump_sense(device, NULL, irb);
-	dasd_schedule_device_bh(device);
+	if ((irb->scsw.cmd.cc == 1) &&
+	    (irb->scsw.cmd.fctl & SCSW_FCTL_START_FUNC) &&
+	    (irb->scsw.cmd.actl & SCSW_ACTL_START_PEND) &&
+	    (irb->scsw.cmd.stctl & SCSW_STCTL_STATUS_PEND)) {
+		/* fake irb do nothing, they are handled elsewhere */
+		dasd_schedule_device_bh(device);
+		return;
+	}
 
+	if (!(irb->esw.esw0.erw.cons)) {
+		/* just report other unsolicited interrupts */
+		DEV_MESSAGE(KERN_ERR, device, "%s",
+			    "unsolicited interrupt received");
+	} else {
+		DEV_MESSAGE(KERN_ERR, device, "%s",
+			    "unsolicited interrupt received "
+			    "(sense available)");
+		device->discipline->dump_sense(device, NULL, irb);
+	}
+
+	dasd_schedule_device_bh(device);
 	return;
 };
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

