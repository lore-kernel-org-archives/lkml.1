Return-Path: <linux-kernel-owner+w=401wt.eu-S1422832AbXCGRmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422832AbXCGRmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422823AbXCGRmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:42:15 -0500
Received: from mail.suse.de ([195.135.220.2]:43885 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422820AbXCGRPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:15:34 -0500
Message-Id: <20070307171355.304129698@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Mike Isely <isely@pobox.com>
Subject: [patch 048/101] V4L: pvrusb2: Handle larger cx2341x firmware images
Content-Disposition: inline; filename=v4l-pvrusb2-handle-larger-cx2341x-firmware-images.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Isely <isely@pobox.com>

Rework the cx23416 firmware loader so that it longer requires the
firmware size to be a multiple of 8KB.  Until recently all cx2341x
firmware images were exactly 256KB, but newer firmware is larger than
that and also appears to have arbitrary size.  We still must check
against a multiple of 4 bytes (because the cx23416 itself uses a 32
bit word size).

This fix is already in the upstream driver source and has proven
itself there; this is a backport for the 2.6.20.y kernel series.

(backported from commit 90060d32ca0a941b158994f78e60d0381871c84b)

Signed-off-by: Mike Isely <isely@pobox.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/pvrusb2/pvrusb2-hdw.c |   31 ++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

--- linux-2.6.20.1.orig/drivers/media/video/pvrusb2/pvrusb2-hdw.c
+++ linux-2.6.20.1/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -1041,7 +1041,7 @@ int pvr2_upload_firmware2(struct pvr2_hd
 {
 	const struct firmware *fw_entry = NULL;
 	void  *fw_ptr;
-	unsigned int pipe, fw_len, fw_done;
+	unsigned int pipe, fw_len, fw_done, bcnt, icnt;
 	int actual_length;
 	int ret = 0;
 	int fwidx;
@@ -1093,11 +1093,11 @@ int pvr2_upload_firmware2(struct pvr2_hd
 
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
@@ -1112,18 +1112,21 @@ int pvr2_upload_firmware2(struct pvr2_hd
 
 	pipe = usb_sndbulkpipe(hdw->usb_dev, PVR2_FIRMWARE_ENDPOINT);
 
-	for (fw_done = 0 ; (fw_done < fw_len) && !ret ;
-	     fw_done += FIRMWARE_CHUNK_SIZE ) {
-		int i;
-		memcpy(fw_ptr, fw_entry->data + fw_done, FIRMWARE_CHUNK_SIZE);
-		/* Usbsnoop log  shows that we must swap bytes... */
-		for (i = 0; i < FIRMWARE_CHUNK_SIZE/4 ; i++)
-			((u32 *)fw_ptr)[i] = ___swab32(((u32 *)fw_ptr)[i]);
+	fw_done = 0;
+	for (fw_done = 0; fw_done < fw_len;) {
+		bcnt = fw_len - fw_done;
+		if (bcnt > FIRMWARE_CHUNK_SIZE) bcnt = FIRMWARE_CHUNK_SIZE;
+		memcpy(fw_ptr, fw_entry->data + fw_done, bcnt);
+		/* Usbsnoop log shows that we must swap bytes... */
+		for (icnt = 0; icnt < bcnt/4 ; icnt++)
+			((u32 *)fw_ptr)[icnt] =
+				___swab32(((u32 *)fw_ptr)[icnt]);
 
-		ret |= usb_bulk_msg(hdw->usb_dev, pipe, fw_ptr,
-				    FIRMWARE_CHUNK_SIZE,
+		ret |= usb_bulk_msg(hdw->usb_dev, pipe, fw_ptr,bcnt,
 				    &actual_length, HZ);
-		ret |= (actual_length != FIRMWARE_CHUNK_SIZE);
+		ret |= (actual_length != bcnt);
+		if (ret) break;
+		fw_done += bcnt;
 	}
 
 	trace_firmware("upload of %s : %i / %i ",

--
