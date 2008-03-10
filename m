Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYCJSvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYCJSvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 14:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbYCJSux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 14:50:53 -0400
Received: from rv-cl-88-200-217-78.pool.tolcom.ru ([88.200.217.78]:55512 "EHLO
	const.mimas.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbYCJSuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:50:52 -0400
X-Greylist: delayed 703 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Mar 2008 14:50:51 EDT
Message-ID: <47D5804A.2020000@const.mimas.ru>
Date: Mon, 10 Mar 2008 22:39:06 +0400
From: Constantin Baranov <const@const.mimas.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.12) Gecko/20080212 SeaMonkey/1.1.8
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.25-rc4] usb: add support for Motorola ROKR Z6 cellphone
 in mass storage mode
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Constantin Baranov <const@tltsu.ru>

Motorola ROKR Z6 cellphone has bugs in its USB, so it is impossible to use
it as mass storage. Patch describes new "unusual" USB device for it with
FIX_INQUIRY and FIX_CAPACITY flags and new BULK_IGNORE_TAG flag.
Last flag relaxes check for equality of bcs->Tag and us->tag in
usb_stor_Bulk_transport routine.

Signed-off-by: Constantin Baranov <const@tltsu.ru>
---
 drivers/usb/storage/transport.c    |    3 ++-
 drivers/usb/storage/unusual_devs.h |   10 ++++++++++
 include/linux/usb_usual.h          |    4 +++-
 3 files changed, 15 insertions(+), 2 deletions(-)

diff -upr linux-2.6.25-rc4/drivers/usb/storage/transport.c
linux-2.6.25-rc4-motorokr_z6/drivers/usb/storage/transport.c
--- linux-2.6.25-rc4/drivers/usb/storage/transport.c	2008-03-10
22:09:11.000000000 +0400
+++ linux-2.6.25-rc4-motorokr_z6/drivers/usb/storage/transport.c
2008-03-10 22:11:24.000000000 +0400
@@ -1009,7 +1009,8 @@ int usb_stor_Bulk_transport(struct scsi_
 	US_DEBUGP("Bulk Status S 0x%x T 0x%x R %u Stat 0x%x\n",
 			le32_to_cpu(bcs->Signature), bcs->Tag,
 			residue, bcs->Status);
-	if (bcs->Tag != us->tag || bcs->Status > US_BULK_STAT_PHASE) {
+	if (!(bcs->Tag == us->tag || (us->flags & US_FL_BULK_IGNORE_TAG)) ||
+		bcs->Status > US_BULK_STAT_PHASE) {
 		US_DEBUGP("Bulk logical error\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
diff -upr linux-2.6.25-rc4/drivers/usb/storage/unusual_devs.h
linux-2.6.25-rc4-motorokr_z6/drivers/usb/storage/unusual_devs.h
--- linux-2.6.25-rc4/drivers/usb/storage/unusual_devs.h	2008-03-10
22:09:11.000000000 +0400
+++ linux-2.6.25-rc4-motorokr_z6/drivers/usb/storage/unusual_devs.h
2008-03-10 22:10:40.000000000 +0400
@@ -1589,6 +1589,16 @@ UNUSUAL_DEV(  0x22b8, 0x4810, 0x0001, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY),

+/*
+ * Patch by Constantin Baranov <const@tltsu.ru>
+ * Report by Andreas Koenecke
+ */
+UNUSUAL_DEV(  0x22b8, 0x6426, 0x0101, 0x0101,
+		"Motorola",
+		"MSnc.",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_FIX_INQUIRY | US_FL_FIX_CAPACITY | US_FL_BULK_IGNORE_TAG),
+
 /* Reported by Radovan Garabik <garabik@kassiopeia.juls.savba.sk> */
 UNUSUAL_DEV(  0x2735, 0x100b, 0x0000, 0x9999,
 		"MPIO",
diff -upr linux-2.6.25-rc4/include/linux/usb_usual.h
linux-2.6.25-rc4-motorokr_z6/include/linux/usb_usual.h
--- linux-2.6.25-rc4/include/linux/usb_usual.h	2008-03-10
22:09:12.000000000 +0400
+++ linux-2.6.25-rc4-motorokr_z6/include/linux/usb_usual.h	2008-03-10
22:10:40.000000000 +0400
@@ -50,7 +50,9 @@
 	US_FLAG(CAPACITY_HEURISTICS,	0x00001000)		\
 		/* sometimes sizes is too big */		\
 	US_FLAG(MAX_SECTORS_MIN,0x00002000)			\
-		/* Sets max_sectors to arch min */
+		/* Sets max_sectors to arch min */		\
+	US_FLAG(BULK_IGNORE_TAG,0x00004000)			\
+		/* Ignore tag mismatch in bulk operations */


 #define US_FLAG(name, value)	US_FL_##name = value ,

