Return-Path: <linux-kernel-owner+w=401wt.eu-S1030288AbXCCOgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030288AbXCCOgy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 09:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030291AbXCCOgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 09:36:54 -0500
Received: from thing.hostingexpert.com ([67.15.235.34]:47363 "EHLO
	thing.hostingexpert.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030288AbXCCOgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 09:36:52 -0500
Message-ID: <45E987CA.90407@linuxtv.org>
Date: Sat, 03 Mar 2007 09:35:54 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: stable@kernel.org
CC: v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [2.6.20.y PATCH 2/7] V4L: pvrusb2: Fix video corruption on stream
 start
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
Date: Tue, 27 Feb 2007 13:11:33 -0500
Subject: [PATCH] V4L: pvrusb2: Fix video corruption on stream start

This introduces some extra cx23416 commands when streaming is
started.  The addition of these commands fix random sporadic video
corruption that can take place when the video stream is temporarily
disrupted through loss of signal (e.g. changing the channel in the RF
tuner).

This fix is already in the upstream driver source and has proven
itself there; this is a backport for the 2.6.20.y kernel series.

Signed-off-by: Mike Isely <isely@pobox.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
(backported from commit 6fe7d2c4660174110c6872cacc4fc2acb6e00acf)
---
 drivers/media/video/pvrusb2/pvrusb2-encoder.c |   40 +++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/pvrusb2/pvrusb2-encoder.c b/drivers/media/video/pvrusb2/pvrusb2-encoder.c
index c94f97b..aec1a00 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-encoder.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-encoder.c
@@ -288,6 +288,44 @@ static int pvr2_encoder_vcmd(struct pvr2_hdw *hdw, int cmd,
 	return pvr2_encoder_cmd(hdw,cmd,args,0,data);
 }
 
+
+/* This implements some extra setup for the encoder that seems to be
+   specific to the PVR USB2 hardware. */
+int pvr2_encoder_prep_config(struct pvr2_hdw *hdw)
+{
+	int ret = 0;
+	int encMisc3Arg = 0;
+
+	/* Mike Isely <isely@pobox.com> 22-Feb-2007 The windows driver
+	   sends the following list of ENC_MISC commands (for both
+	   24xxx and 29xxx devices).  Meanings are not entirely clear,
+	   however without the ENC_MISC(3,encMisc3Arg) command then we risk
+	   random perpetual video corruption whenever the video input
+	   breaks up for a moment (like when switching channels). */
+
+
+	/* This ENC_MISC(3,encMisc3Arg) command is critical - without
+	   it there will eventually be video corruption.  Also, the
+	   29xxx case is strange - the Windows driver is passing 1
+	   regardless of device type but if we have 1 for 29xxx device
+	   the video turns sluggish.  */
+	switch (hdw->hdw_type) {
+	case PVR2_HDW_TYPE_24XXX: encMisc3Arg = 1; break;
+	case PVR2_HDW_TYPE_29XXX: encMisc3Arg = 0; break;
+	default: break;
+	}
+	ret |= pvr2_encoder_vcmd(hdw, CX2341X_ENC_MISC,4, 3,
+				 encMisc3Arg,0,0);
+
+	ret |= pvr2_encoder_vcmd(hdw, CX2341X_ENC_MISC,4, 8,0,0,0);
+
+	ret |= pvr2_encoder_vcmd(hdw, CX2341X_ENC_MISC,4, 0,3,0,0);
+	ret |= pvr2_encoder_vcmd(hdw, CX2341X_ENC_MISC,4,15,0,0,0);
+
+	return ret;
+}
+
+
 int pvr2_encoder_configure(struct pvr2_hdw *hdw)
 {
 	int ret;
@@ -302,6 +340,8 @@ int pvr2_encoder_configure(struct pvr2_hdw *hdw)
 
 	ret = 0;
 
+	ret |= pvr2_encoder_prep_config(hdw);
+
 	if (!ret) ret = pvr2_encoder_vcmd(
 		hdw,CX2341X_ENC_SET_NUM_VSYNC_LINES, 2,
 		0xf0, 0xf0);
