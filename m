Return-Path: <linux-kernel-owner+w=401wt.eu-S1030316AbXCCOiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030316AbXCCOiJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 09:38:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030295AbXCCOhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 09:37:42 -0500
Received: from thing.hostingexpert.com ([67.15.235.34]:47366 "EHLO
	thing.hostingexpert.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030292AbXCCOhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 09:37:00 -0500
Message-ID: <45E987D2.6050603@linuxtv.org>
Date: Sat, 03 Mar 2007 09:36:02 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: stable@kernel.org
CC: v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [2.6.20.y PATCH 3/7] V4L: pvrusb2: Handle larger cx2341x firmware
 images
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - thing.hostingexpert.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - linuxtv.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Isely <isely@pobox.com>
Date: Tue, 27 Feb 2007 13:12:15 -0500
Subject: [PATCH] V4L: pvrusb2: Handle larger cx2341x firmware images

Rework the cx23416 firmware loader so that it longer requires the
firmware size to be a multiple of 8KB.  Until recently all cx2341x
firmware images were exactly 256KB, but newer firmware is larger than
that and also appears to have arbitrary size.  We still must check
against a multiple of 4 bytes (because the cx23416 itself uses a 32
bit word size).

This fix is already in the upstream driver source and has proven
itself there; this is a backport for the 2.6.20.y kernel series.

Signed-off-by: Mike Isely <isely@pobox.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
(backported from commit 90060d32ca0a941b158994f78e60d0381871c84b)
---
 drivers/media/video/pvrusb2/pvrusb2-hdw.c |   33 +++++++++++++++-------------
 1 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
index d200496..2fbd24c 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -1041,7 +1041,7 @@ int pvr2_upload_firmware2(struct pvr2_hdw *hdw)
 {
 	const struct firmware *fw_entry = NULL;
 	void  *fw_ptr;
-	unsigned int pipe, fw_len, fw_done;
+	unsigned int pipe, fw_len, fw_done, bcnt, icnt;
 	int actual_length;
 	int ret = 0;
 	int fwidx;
@@ -1093,11 +1093,11 @@ int pvr2_upload_firmware2(struct pvr2_hdw *hdw)
 
 	fw_len = fw_entry->size;
 
-	if (fw_len % FIRMWARE_CHUNK_SIZE) {
+	if (fw_len % sizeof(u32)) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
 			   "size of %s firmware"
-			   " must be a multiple of 8192B",
-			   fw_files[fwidx]);
+			   " must be a multiple of %zu bytes",
+			   fw_files[fwidx],sizeof(u32));
 		release_firmware(fw_entry);
 		return -1;
 	}
@@ -1112,18 +1112,21 @@ int pvr2_upload_firmware2(struct pvr2_hdw *hdw)
 
 	pipe = usb_sndbulkpipe(hdw->usb_dev, PVR2_FIRMWARE_ENDPOINT);
 
-	for (fw_done = 0 ; (fw_done < fw_len) && !ret ;
-	     fw_done += FIRMWARE_CHUNK_SIZE ) {
-		int i;
-		memcpy(fw_ptr, fw_entry->data + fw_done, FIRMWARE_CHUNK_SIZE);
-		/* Usbsnoop log  shows that we must swap bytes... */
-		for (i = 0; i < FIRMWARE_CHUNK_SIZE/4 ; i++)
-			((u32 *)fw_ptr)[i] = ___swab32(((u32 *)fw_ptr)[i]);
-
-		ret |= usb_bulk_msg(hdw->usb_dev, pipe, fw_ptr,
-				    FIRMWARE_CHUNK_SIZE,
+	fw_done = 0;
+	for (fw_done = 0; fw_done < fw_len;) {
+		bcnt = fw_len - fw_done;
+		if (bcnt > FIRMWARE_CHUNK_SIZE) bcnt = FIRMWARE_CHUNK_SIZE;
+		memcpy(fw_ptr, fw_entry->data + fw_done, bcnt);
+		/* Usbsnoop log shows that we must swap bytes... */
+		for (icnt = 0; icnt < bcnt/4 ; icnt++)
+			((u32 *)fw_ptr)[icnt] =
+				___swab32(((u32 *)fw_ptr)[icnt]);
+
+		ret |= usb_bulk_msg(hdw->usb_dev, pipe, fw_ptr,bcnt,
 				    &actual_length, HZ);
-		ret |= (actual_length != FIRMWARE_CHUNK_SIZE);
+		ret |= (actual_length != bcnt);
+		if (ret) break;
+		fw_done += bcnt;
 	}
 
 	trace_firmware("upload of %s : %i / %i ",
