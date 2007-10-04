Return-Path: <linux-kernel-owner+w=401wt.eu-S1761118AbXJDLjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761118AbXJDLjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 07:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757820AbXJDL3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 07:29:16 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:58206 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144AbXJDL2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 07:28:32 -0400
Message-Id: <20071004112834.252620858@de.ibm.com>
References: <20071004112706.574737175@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Oct 2007 13:27:39 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Michael Holzheu <holzheu@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 33/34] tape: Fix medium state handling
Content-Disposition: inline; filename=033-tape-state.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@de.ibm.com>

Currently there are situations, where the tape medium state (loaded, unloaded,
unknown) is not set correctly. The reason is that the medium association
field is used to determine the medium state. This not always leads to 
correct results. To fix that we use another field of the medium sense
data instead.

Signed-off-by: Michael Holzheu <holzheu@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/char/tape_3590.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

Index: quilt-2.6/drivers/s390/char/tape_3590.c
===================================================================
--- quilt-2.6.orig/drivers/s390/char/tape_3590.c
+++ quilt-2.6/drivers/s390/char/tape_3590.c
@@ -713,16 +713,22 @@ static void tape_3590_med_state_set(stru
 
 	c_info = &TAPE_3590_CRYPT_INFO(device);
 
-	if (sense->masst == MSENSE_UNASSOCIATED) {
+	DBF_EVENT(6, "medium state: %x:%x\n", sense->macst, sense->masst);
+	switch (sense->macst) {
+	case 0x04:
+	case 0x05:
+	case 0x06:
 		tape_med_state_set(device, MS_UNLOADED);
 		TAPE_3590_CRYPT_INFO(device).medium_status = 0;
 		return;
-	}
-	if (sense->masst != MSENSE_ASSOCIATED_MOUNT) {
-		PRINT_ERR("Unknown medium state: %x\n", sense->masst);
+	case 0x08:
+	case 0x09:
+		tape_med_state_set(device, MS_LOADED);
+		break;
+	default:
+		tape_med_state_set(device, MS_UNKNOWN);
 		return;
 	}
-	tape_med_state_set(device, MS_LOADED);
 	c_info->medium_status |= TAPE390_MEDIUM_LOADED_MASK;
 	if (sense->flags & MSENSE_CRYPT_MASK) {
 		PRINT_INFO("Medium is encrypted (%04x)\n", sense->flags);
@@ -840,15 +846,17 @@ tape_3590_unsolicited_irq(struct tape_de
 		/* Probably result of halt ssch */
 		return TAPE_IO_PENDING;
 	else if (irb->scsw.dstat == 0x85)
-		/* Device Ready -> check medium state */
-		tape_3590_schedule_work(device, TO_MSEN);
-	else if (irb->scsw.dstat & DEV_STAT_ATTENTION)
+		/* Device Ready */
+		DBF_EVENT(3, "unsol.irq! tape ready: %08x\n", device->cdev_id);
+	else if (irb->scsw.dstat & DEV_STAT_ATTENTION) {
 		tape_3590_schedule_work(device, TO_READ_ATTMSG);
-	else {
+	} else {
 		DBF_EVENT(3, "unsol.irq! dev end: %08x\n", device->cdev_id);
 		PRINT_WARN("Unsolicited IRQ (Device End) caught.\n");
 		tape_dump_sense(device, NULL, irb);
 	}
+	/* check medium state */
+	tape_3590_schedule_work(device, TO_MSEN);
 	return TAPE_IO_SUCCESS;
 }
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

