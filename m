Return-Path: <linux-kernel-owner+w=401wt.eu-S1764650AbZGAA4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764650AbZGAA4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761444AbZGAAek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:40 -0400
Received: from kroah.org ([198.145.64.141]:60270 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761435AbZGAAeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:37 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:23 2009
Message-Id: <20090701002423.713660817@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Isely <isely@pobox.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Michael Krufky <mkrufky@linuxtv.org>
Subject: [patch 034/108] V4L: pvrusb2: Fix hardware scaling when used with cx25840
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=v4l-pvrusb2-fix-hardware-scaling-when-used-with-cx25840.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Isely <isely@pobox.com>

(cherry picked from commit e17d787c513f41f59969247062561fff6340f211)

The cx25840 module requires that its VBI initialization entry point be
called in order for hardware-scaled video capture to work properly -
even if we don't care about VBI.  Making this behavior even more
subtle is that if the capture resolution is set to 720x480 - which is
the default that the pvrusb2 driver sets up - then the cx25840
bypasses the hardware scaler.  Therefore this problem does not
manifest itself until some other resolution, e.g. 640x480, is tried.
MythTV typically defaults to 640x480 or 480x480, which means that
things break whenever the driver is used with MythTV.

This all has been known for a while (since at least Nov 2006), but
recent changes in the pvrusb2 driver (specifically in regards to
sub-device support) caused this to break again.  VBI initialization
must happen *after* the chip's firmware is loaded, not before.  With
this fix, 24xxx devices work correctly again.

A related fix that is part of this changeset is that now we
re-initialize VBI any time after we issue a reset to the cx25840
driver.  Issuing a chip reset erases the state that the VBI setup
previously did.  Until the HVR-1950 came along this subtlety went
unnoticed, because the pvrusb2 driver previously never issued such a
reset.  But with the HVR-1950 we have to do that reset in order to
correctly transition from digital back to analog mode - and since the
HVR-1950 always starts in digital mode (required for the DVB side to
initialize correctly) then this device has never had a chance to work
correctly in analog mode!  Analog capture on the HVR-1950 has been
broken this *ENTIRE* time.  I had missed it until now because I've
usually been testing at the default 720x480 resolution which does not
require scaling...  What fun.  By re-initializing VBI after a cx25840
chip reset, correct behavior is restored.

Signed-off-by: Mike Isely <isely@pobox.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/pvrusb2/pvrusb2-hdw.c |   55 ++++++++++++++++--------------
 1 file changed, 31 insertions(+), 24 deletions(-)

--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -1978,6 +1978,34 @@ static unsigned int pvr2_copy_i2c_addr_l
 }
 
 
+static void pvr2_hdw_cx25840_vbi_hack(struct pvr2_hdw *hdw)
+{
+	/*
+	  Mike Isely <isely@pobox.com> 19-Nov-2006 - This bit of nuttiness
+	  for cx25840 causes that module to correctly set up its video
+	  scaling.  This is really a problem in the cx25840 module itself,
+	  but we work around it here.  The problem has not been seen in
+	  ivtv because there VBI is supported and set up.  We don't do VBI
+	  here (at least not yet) and thus we never attempted to even set
+	  it up.
+	*/
+	struct v4l2_format fmt;
+	if (hdw->decoder_client_id != PVR2_CLIENT_ID_CX25840) {
+		/* We're not using a cx25840 so don't enable the hack */
+		return;
+	}
+
+	pvr2_trace(PVR2_TRACE_INIT,
+		   "Module ID %u:"
+		   " Executing cx25840 VBI hack",
+		   hdw->decoder_client_id);
+	memset(&fmt, 0, sizeof(fmt));
+	fmt.type = V4L2_BUF_TYPE_SLICED_VBI_CAPTURE;
+	v4l2_device_call_all(&hdw->v4l2_dev, hdw->decoder_client_id,
+			     video, s_fmt, &fmt);
+}
+
+
 static int pvr2_hdw_load_subdev(struct pvr2_hdw *hdw,
 				const struct pvr2_device_client_desc *cd)
 {
@@ -2069,30 +2097,6 @@ static int pvr2_hdw_load_subdev(struct p
 	/* client-specific setup... */
 	switch (mid) {
 	case PVR2_CLIENT_ID_CX25840:
-		hdw->decoder_client_id = mid;
-		{
-			/*
-			  Mike Isely <isely@pobox.com> 19-Nov-2006 - This
-			  bit of nuttiness for cx25840 causes that module
-			  to correctly set up its video scaling.  This is
-			  really a problem in the cx25840 module itself,
-			  but we work around it here.  The problem has not
-			  been seen in ivtv because there VBI is supported
-			  and set up.  We don't do VBI here (at least not
-			  yet) and thus we never attempted to even set it
-			  up.
-			*/
-			struct v4l2_format fmt;
-			pvr2_trace(PVR2_TRACE_INIT,
-				   "Module ID %u:"
-				   " Executing cx25840 VBI hack",
-				   mid);
-			memset(&fmt, 0, sizeof(fmt));
-			fmt.type = V4L2_BUF_TYPE_SLICED_VBI_CAPTURE;
-			v4l2_device_call_all(&hdw->v4l2_dev, mid,
-					     video, s_fmt, &fmt);
-		}
-		break;
 	case PVR2_CLIENT_ID_SAA7115:
 		hdw->decoder_client_id = mid;
 		break;
@@ -2193,6 +2197,8 @@ static void pvr2_hdw_setup_low(struct pv
 		cptr->info->set_value(cptr,~0,cptr->info->default_value);
 	}
 
+	pvr2_hdw_cx25840_vbi_hack(hdw);
+
 	/* Set up special default values for the television and radio
 	   frequencies here.  It's not really important what these defaults
 	   are, but I set them to something usable in the Chicago area just
@@ -4066,6 +4072,7 @@ int pvr2_hdw_cmd_decoder_reset(struct pv
 	if (hdw->decoder_client_id) {
 		v4l2_device_call_all(&hdw->v4l2_dev, hdw->decoder_client_id,
 				     core, reset, 0);
+		pvr2_hdw_cx25840_vbi_hack(hdw);
 		return 0;
 	}
 	pvr2_trace(PVR2_TRACE_INIT,


