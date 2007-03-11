Return-Path: <linux-kernel-owner+w=401wt.eu-S932900AbXCKWJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900AbXCKWJR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 18:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932891AbXCKWJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 18:09:17 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:48853 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932900AbXCKWJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 18:09:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=S57q12F0R35R1yVm9AFF4Bgeyzyp/JxUMvtjlZMNMpLChFAmsspAN/sY/i/a0vlJkRXRmNiD4jmVMZAljlnVmhW+ok4SPiWpHcvqrOGgrPS/f7JslCNAHlSqGcHjE7wI5FzLRBFXHV4Fb15VQtKmc6WqXDvFAnSzB7/UjOJSFhA=
Date: Sun, 11 Mar 2007 15:09:10 -0700
From: Amit Choudhary <amit2030@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org
Subject: [PATCH] drivers/media/video/se401.c: check kmalloc() return value.
Message-Id: <20070311150910.0ec1e2e5.amit2030@gmail.com>
Organization: X
X-Mailer: Sylpheed version 2.2.9 (GTK+ 2.8.15; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Description: Check the return value of kmalloc() in function se401_start_stream(), in file drivers/media/video/se401.c.

Signed-off-by: Amit Choudhary <amit2030@gmail.com>

diff --git a/drivers/media/video/se401.c b/drivers/media/video/se401.c
index 7aeec57..006c818 100644
--- a/drivers/media/video/se401.c
+++ b/drivers/media/video/se401.c
@@ -450,6 +450,13 @@ static int se401_start_stream(struct usb
 	}
 	for (i=0; i<SE401_NUMSBUF; i++) {
 		se401->sbuf[i].data=kmalloc(SE401_PACKETSIZE, GFP_KERNEL);
+		if (!se401->sbuf[i].data) {
+			for(i = i - 1; i >= 0; i--) {
+				kfree(se401->sbuf[i].data);
+				se401->sbuf[i].data = NULL;
+			}
+			return -ENOMEM;
+		}
 	}
 
 	se401->bayeroffset=0;
@@ -458,13 +465,26 @@ static int se401_start_stream(struct usb
 	se401->scratch_overflow=0;
 	for (i=0; i<SE401_NUMSCRATCH; i++) {
 		se401->scratch[i].data=kmalloc(SE401_PACKETSIZE, GFP_KERNEL);
+		if (!se401->scratch[i].data) {
+			for(i = i - 1; i >= 0; i--) {
+				kfree(se401->scratch[i].data);
+				se401->scratch[i].data = NULL;
+			}
+			goto nomem_sbuf;
+		}
 		se401->scratch[i].state=BUFFER_UNUSED;
 	}
 
 	for (i=0; i<SE401_NUMSBUF; i++) {
 		urb=usb_alloc_urb(0, GFP_KERNEL);
-		if(!urb)
-			return -ENOMEM;
+		if(!urb) {
+			for(i = i - 1; i >= 0; i--) {
+				usb_kill_urb(se401->urb[i]);
+				usb_free_urb(se401->urb[i]);
+				se401->urb[i] = NULL;
+			}
+			goto nomem_scratch;
+		}
 
 		usb_fill_bulk_urb(urb, se401->dev,
 			usb_rcvbulkpipe(se401->dev, SE401_VIDEO_ENDPOINT),
@@ -482,6 +502,18 @@ static int se401_start_stream(struct usb
 	se401->framecount=0;
 
 	return 0;
+
+ nomem_scratch:
+	for (i=0; i<SE401_NUMSCRATCH; i++) {
+		kfree(se401->scratch[i].data);
+		se401->scratch[i].data = NULL;
+	}
+ nomem_sbuf:
+	for (i=0; i<SE401_NUMSBUF; i++) {
+		kfree(se401->sbuf[i].data);
+		se401->sbuf[i].data = NULL;
+	}
+	return -ENOMEM;
 }
 
 static int se401_stop_stream(struct usb_se401 *se401)
