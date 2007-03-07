Return-Path: <linux-kernel-owner+w=401wt.eu-S965620AbXCGRoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965620AbXCGRoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965589AbXCGRoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:44:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43280 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422827AbXCGRPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:15:34 -0500
Message-Id: <20070307171352.068065684@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:22 -0800
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
Subject: [patch 047/101] V4L: pvrusb2: Fix video corruption on stream start
Content-Disposition: inline; filename=v4l-pvrusb2-fix-video-corruption-on-stream-start.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Isely <isely@pobox.com>

This introduces some extra cx23416 commands when streaming is
started.  The addition of these commands fix random sporadic video
corruption that can take place when the video stream is temporarily
disrupted through loss of signal (e.g. changing the channel in the RF
tuner).

This fix is already in the upstream driver source and has proven
itself there; this is a backport for the 2.6.20.y kernel series.

(backported from commit 6fe7d2c4660174110c6872cacc4fc2acb6e00acf)

Signed-off-by: Mike Isely <isely@pobox.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/pvrusb2/pvrusb2-encoder.c |   40 ++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

--- linux-2.6.20.1.orig/drivers/media/video/pvrusb2/pvrusb2-encoder.c
+++ linux-2.6.20.1/drivers/media/video/pvrusb2/pvrusb2-encoder.c
@@ -288,6 +288,44 @@ static int pvr2_encoder_vcmd(struct pvr2
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
@@ -302,6 +340,8 @@ int pvr2_encoder_configure(struct pvr2_h
 
 	ret = 0;
 
+	ret |= pvr2_encoder_prep_config(hdw);
+
 	if (!ret) ret = pvr2_encoder_vcmd(
 		hdw,CX2341X_ENC_SET_NUM_VSYNC_LINES, 2,
 		0xf0, 0xf0);

--
