Return-Path: <linux-kernel-owner+w=401wt.eu-S932886AbXCKWCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886AbXCKWCP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 18:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932891AbXCKWCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 18:02:15 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:46471 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932886AbXCKWCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 18:02:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=rKSceF2pxiwKcU8JD4bpleiimCZ47JrxmMKe+Qvs0XWXtN9bvC1cUePTVe9iplS/e4GhXYPv556uLxeMSnPG/Dt25QJdwfI/JKjQ1d7NsV1fj/+xl2ihUyzRoECjPQSjJeVyv57G1GO31BLDjrRCJtqhiSL98k3ng8eUBNW2tq4=
Date: Sun, 11 Mar 2007 15:02:05 -0700
From: Amit Choudhary <amit2030@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-usb-devel@lists.sourceforge.net, video4linux-list@redhat.com
Subject: [PATCH] [REVISED] drivers/media/video/stv680.c: check kmalloc()
 return value.
Message-Id: <20070311150205.89b4c6db.amit2030@gmail.com>
Organization: X
X-Mailer: Sylpheed version 2.2.9 (GTK+ 2.8.15; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Description: Check the return value of kmalloc() in function stv680_start_stream(), in file drivers/media/video/stv680.c.

Signed-off-by: Amit Choudhary <amit2030@gmail.com>

diff --git a/drivers/media/video/stv680.c b/drivers/media/video/stv680.c
index 6d1ef1e..f35c664 100644
--- a/drivers/media/video/stv680.c
+++ b/drivers/media/video/stv680.c
@@ -687,7 +687,11 @@ static int stv680_start_stream (struct u
 		stv680->sbuf[i].data = kmalloc (stv680->rawbufsize, GFP_KERNEL);
 		if (stv680->sbuf[i].data == NULL) {
 			PDEBUG (0, "STV(e): Could not kmalloc raw data buffer %i", i);
-			return -1;
+			for (i = i - 1; i >= 0; i--) {
+				kfree(stv680->sbuf[i].data);
+				stv680->sbuf[i].data = NULL;
+			}
+			return -ENOMEM;
 		}
 	}
 
@@ -698,15 +702,25 @@ static int stv680_start_stream (struct u
 		stv680->scratch[i].data = kmalloc (stv680->rawbufsize, GFP_KERNEL);
 		if (stv680->scratch[i].data == NULL) {
 			PDEBUG (0, "STV(e): Could not kmalloc raw scratch buffer %i", i);
-			return -1;
+			for (i = i - 1; i >= 0; i--) {
+				kfree(stv680->scratch[i].data);
+				stv680->scratch[i].data = NULL;
+			}
+			goto nomem_sbuf;
 		}
 		stv680->scratch[i].state = BUFFER_UNUSED;
 	}
 
 	for (i = 0; i < STV680_NUMSBUF; i++) {
 		urb = usb_alloc_urb (0, GFP_KERNEL);
-		if (!urb)
-			return -ENOMEM;
+		if (!urb) {
+			for (i = i - 1; i >= 0; i--) {
+				usb_kill_urb(stv680->urb[i]);
+				usb_free_urb(stv680->urb[i]);
+				stv680->urb[i] = NULL;
+			}
+			goto nomem_scratch;
+		}
 
 		/* sbuf is urb->transfer_buffer, later gets memcpyed to scratch */
 		usb_fill_bulk_urb (urb, stv680->udev,
@@ -721,6 +735,18 @@ static int stv680_start_stream (struct u
 
 	stv680->framecount = 0;
 	return 0;
+
+ nomem_scratch:
+	for (i=0; i<STV680_NUMSCRATCH; i++) {
+		kfree(stv680->scratch[i].data);
+		stv680->scratch[i].data = NULL;
+	}
+ nomem_sbuf:
+	for (i=0; i<STV680_NUMSBUF; i++) {
+		kfree(stv680->sbuf[i].data);
+		stv680->sbuf[i].data = NULL;
+	}
+	return -ENOMEM;
 }
 
 static int stv680_stop_stream (struct usb_stv *stv680)
