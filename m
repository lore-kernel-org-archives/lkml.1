Return-Path: <linux-kernel-owner+w=401wt.eu-S1758098AbXLUVVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbXLUVVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 16:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbXLUVVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 16:21:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:44834 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbXLUVVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 16:21:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=kRW357IeQ+2/PBBrzmY+aXAR5YYcaxVBvi9lWJe6/JZ8EW2gIueAbRwsPaFjLSyt72tte6sx3ySqI3DygQllEMHM0sJ9f3pKSO7sUseigWluP/BARG8HTtWL9m/X531TSg0DLaXn6XugEXJVmcQo4wGDMrQ5Ili3SC4wlNKWHNQ=
Date: Fri, 21 Dec 2007 15:21:30 -0600
From: David Hilvert <dhilvert@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: dmitri@users.sourceforge.net
Subject: Regarding request for IBM camera patch to be applied to the main
 tree
Message-Id: <20071221152130.bf2d745d.dhilvert@gmail.com>
In-Reply-To: <20071221201629.GG22989@kroah.com>
References: <47587359.7000200@rogers.com>
	<20071221201629.GG22989@kroah.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > http://www.linux-usb.org/ibmcam/

> > http://auricle.dyndns.org/xvp610/

[Remainder of private e-mail context snipped; message has been blind-CC'ed to
the original recipients.  Please CC any replies intended for me.]

As the author of the second patch noted, I had avoided sending it to lkml due
to the difficulty of determining whether the patch is correct (e.g., having no
ill effect on other cameras), due, in turn, to lack of documentation for this
series of cameras.  Perhaps dmitri could comment further on this, if he has
time and access to test on any other cameras that might fall under the 'model
3' designation (whatever this designation might mean).  The (rather old, now)
patch in question (against 2.6.1 or so, and perhaps other versions) follows; if
I recall correctly, it was designed to minimize change lines rather than
provide for overall clarity, so that a clearer final implementation is probably
possible.


diff -urN linux-2.6.1/drivers/usb/media/ibmcam.c linux-2.6.1-patched/drivers/usb/media/ibmcam.c
--- linux-2.6.1/drivers/usb/media/ibmcam.c	Fri Jan  9 00:59:19 2004
+++ linux-2.6.1-patched/drivers/usb/media/ibmcam.c	Fri Feb  6 14:54:33 2004
@@ -803,6 +803,21 @@
 		return scan_Continue;
 }
 
+/*
+ * ibmcam_model3_parse_lines()
+ *
+ * | Even lines |     Odd Lines       |
+ * -----------------------------------|
+ * |YYY........Y|UYVYUYVY.........UYVY|
+ * |YYY........Y|UYVYUYVY.........UYVY| 
+ * |............|.....................|
+ * |YYY........Y|UYVYUYVY.........UYVY| 
+ * |------------+---------------------|
+ *
+ * There is one (U, V) chroma pair for every four luma (Y) values.  This
+ * function reads a pair of lines at a time and obtains missing chroma values
+ * from adjacent pixels.
+ */
 static enum ParseState ibmcam_model3_parse_lines(
 	struct uvd *uvd,
 	struct usbvideo_frame *frame,
@@ -817,6 +832,7 @@
 	const int ccm = 128; /* Color correction median - see below */
 	int i, u, v, rw, data_w=0, data_h=0, color_corr;
 	static unsigned char lineBuffer[640*3];
+	int line;
 
 	color_corr = (uvd->vpic.colour - 0x8000) >> 8; /* -128..+127 = -ccm..+(ccm-1)*/
 	RESTRICT_TO_RANGE(color_corr, -ccm, ccm+1);
@@ -870,15 +886,15 @@
 		return scan_NextFrame;
 	}
 
-	/* Make sure there's enough data for the entire line */
-	len = 3 * data_w; /* <y-data> <uv-data> */
+	/* Make sure that lineBuffer can store two lines of data */
+	len = 3 * data_w; /* <y-data> <uyvy-data> */
 	assert(len <= sizeof(lineBuffer));
 
-	/* Make sure there's enough data for the entire line */
+	/* Make sure there's enough data for two lines */
 	if (RingQueue_GetLength(&uvd->dp) < len)
 		return scan_Out;
 
-	/* Suck one line out of the ring queue */
+	/* Suck two lines of data out of the ring queue */
 	RingQueue_Dequeue(&uvd->dp, lineBuffer, len);
 
 	data = lineBuffer;
@@ -888,15 +904,23 @@
 	rw = (int)VIDEOSIZE_Y(frame->request) - (int)(frame->curline) - 1;
 	RESTRICT_TO_RANGE(rw, 0, VIDEOSIZE_Y(frame->request)-1);
 
-	for (i = 0; i < VIDEOSIZE_X(frame->request); i++) {
-		int y, rv, gv, bv;	/* RGB components */
+	/* Iterate over two lines. */
+	for (line = 0; line < 2; line++) {
+		for (i = 0; i < VIDEOSIZE_X(frame->request); i++) {
+			int y;
+			int rv, gv, bv;	/* RGB components */
+
+			if (i >= data_w) {
+				RGB24_PUTPIXEL(frame, i, rw, 0, 0, 0);
+				continue;
+			}
 
-		if (i < data_w) {
-			y = data[i];	/* Luminosity is the first line */
+			/* first line is YYY...Y; second is UYVY...UYVY */
+			y = data[(line == 0) ? i : (i*2 + 1)];
 
 			/* Apply static color correction */
-			u = color[i*2] + hue_corr;
-			v = color[i*2 + 1] + hue2_corr;
+			u = color[(i/2)*4] + hue_corr;
+			v = color[(i/2)*4 + 2] + hue2_corr;
 
 			/* Apply color correction */
 			if (color_corr != 0) {
@@ -904,13 +928,21 @@
 				u = 128 + ((ccm + color_corr) * (u - 128)) / ccm;
 				v = 128 + ((ccm + color_corr) * (v - 128)) / ccm;
 			}
-		} else
-			y = 0, u = v = 128;
 
-		YUV_TO_RGB_BY_THE_BOOK(y, u, v, rv, gv, bv);
-		RGB24_PUTPIXEL(frame, i, rw, rv, gv, bv); /* Done by deinterlacing now */
+
+			YUV_TO_RGB_BY_THE_BOOK(y, u, v, rv, gv, bv);
+			RGB24_PUTPIXEL(frame, i, rw, rv, gv, bv);  /* No deinterlacing */
+		}
+
+		/* Check for the end of requested data */
+		if (rw == 0)
+			break;
+
+		/* Prepare for the second line */
+		rw--;
+		data = lineBuffer + data_w;
 	}
-	frame->deinterlace = Deinterlace_FillEvenLines;
+	frame->deinterlace = Deinterlace_None;
 
 	/*
 	 * Account for number of bytes that we wrote into output V4L frame.


