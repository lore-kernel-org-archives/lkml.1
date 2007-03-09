Return-Path: <linux-kernel-owner+w=401wt.eu-S2993037AbXCIHTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993037AbXCIHTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993038AbXCIHTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:19:16 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:35215 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993037AbXCIHTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:19:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=adOPTVWw7CrTrEdpv30Srb3MjpzxHkxvQaZOEpiM8YWsIreRyFKx3bDJMkJlf+c2RJVIGYWq+B8XeincOx7kP0shj9xCKSolXMD0ROoWqNFRC545EfaX4JWpLCUpd2MwGwNYdx8AZVGHtFOt6l2dZxB8o9b5Lg6CBoJq2Uc/hJQ=
Date: Thu, 8 Mar 2007 23:18:54 -0800
From: Amit Choudhary <amit2030@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/media/video/stv680.c: check kmalloc() return value.
Message-Id: <20070308231854.4ea313eb.amit2030@gmail.com>
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
index 6d1ef1e..a1ec3ac 100644
--- a/drivers/media/video/stv680.c
+++ b/drivers/media/video/stv680.c
@@ -687,7 +687,7 @@ static int stv680_start_stream (struct u
 		stv680->sbuf[i].data = kmalloc (stv680->rawbufsize, GFP_KERNEL);
 		if (stv680->sbuf[i].data == NULL) {
 			PDEBUG (0, "STV(e): Could not kmalloc raw data buffer %i", i);
-			return -1;
+			goto nomem_err;
 		}
 	}
 
@@ -698,7 +698,7 @@ static int stv680_start_stream (struct u
 		stv680->scratch[i].data = kmalloc (stv680->rawbufsize, GFP_KERNEL);
 		if (stv680->scratch[i].data == NULL) {
 			PDEBUG (0, "STV(e): Could not kmalloc raw scratch buffer %i", i);
-			return -1;
+			goto nomem_err;
 		}
 		stv680->scratch[i].state = BUFFER_UNUSED;
 	}
@@ -706,7 +706,7 @@ static int stv680_start_stream (struct u
 	for (i = 0; i < STV680_NUMSBUF; i++) {
 		urb = usb_alloc_urb (0, GFP_KERNEL);
 		if (!urb)
-			return -ENOMEM;
+			goto nomem_err;
 
 		/* sbuf is urb->transfer_buffer, later gets memcpyed to scratch */
 		usb_fill_bulk_urb (urb, stv680->udev,
@@ -721,6 +721,21 @@ static int stv680_start_stream (struct u
 
 	stv680->framecount = 0;
 	return 0;
+
+ nomem_err:
+	for (i = 0; i < STV680_NUMSCRATCH; i++) {
+		kfree(stv680->scratch[i].data);
+		stv680->scratch[i].data = NULL;
+	}
+	for (i = 0; i < STV680_NUMSBUF; i++) {
+		usb_kill_urb(stv680->urb[i]);
+		usb_free_urb(stv680->urb[i]);
+		stv680->urb[i] = NULL;
+		kfree(stv680->sbuf[i].data);
+		stv680->sbuf[i].data = NULL;
+	}
+	return -ENOMEM;
+
 }
 
 static int stv680_stop_stream (struct usb_stv *stv680)
