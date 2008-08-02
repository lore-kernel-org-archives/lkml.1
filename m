Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbYHBPNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbYHBPNt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 11:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbYHBPNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 11:13:38 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:37793 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756771AbYHBPNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 11:13:37 -0400
Date: Sat, 2 Aug 2008 17:13:34 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 4/10] drivers/media/video: Use DIV_ROUND_UP
Message-ID: <Pine.LNX.4.64.0808021713100.20095@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
(d)) but is perhaps more readable.

An extract of the semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression n,d;
@@

(
- (n + d - 1) / d
+ DIV_ROUND_UP(n,d)
|
- (n + (d - 1)) / d
+ DIV_ROUND_UP(n,d)
)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP((n),d)
+ DIV_ROUND_UP(n,d)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP(n,(d))
+ DIV_ROUND_UP(n,d)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/video/bw-qcam.c       |    4 ++--
 drivers/media/video/uvc/uvc_video.c |    2 +-
 drivers/media/video/zoran_device.c  |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -u -p a/drivers/media/video/bw-qcam.c b/drivers/media/video/bw-qcam.c
--- a/drivers/media/video/bw-qcam.c
+++ b/drivers/media/video/bw-qcam.c
@@ -495,7 +495,7 @@ static void qc_set(struct qcam_device *q
 		val2 = (((q->port_mode & QC_MODE_MASK) == QC_BIDIR) ? 24 : 8) *
 		    q->transfer_scale;
 	}
-	val = (val + val2 - 1) / val2;
+	val = DIV_ROUND_UP(val, val2);
 	qc_command(q, 0x13);
 	qc_command(q, val);
 
@@ -651,7 +651,7 @@ static long qc_capture(struct qcam_devic
 	transperline = q->width * q->bpp;
 	divisor = (((q->port_mode & QC_MODE_MASK) == QC_BIDIR) ? 24 : 8) *
 	    q->transfer_scale;
-	transperline = (transperline + divisor - 1) / divisor;
+	transperline = DIV_ROUND_UP(transperline, divisor);
 
 	for (i = 0, yield = yieldlines; i < linestotrans; i++)
 	{
diff -u -p a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -644,7 +644,7 @@ static int uvc_init_video_isoc(struct uv
 	if (size > UVC_MAX_FRAME_SIZE)
 		return -EINVAL;
 
-	npackets = (size + psize - 1) / psize;
+	npackets = DIV_ROUND_UP(size, psize);
 	if (npackets > UVC_MAX_ISO_PACKETS)
 		npackets = UVC_MAX_ISO_PACKETS;
 
diff -u -p a/drivers/media/video/zoran_device.c b/drivers/media/video/zoran_device.c
--- a/drivers/media/video/zoran_device.c
+++ b/drivers/media/video/zoran_device.c
@@ -377,7 +377,7 @@ zr36057_set_vfe (struct zoran           
 
 	/* horizontal */
 	VidWinWid = video_width;
-	X = (VidWinWid * 64 + tvn->Wa - 1) / tvn->Wa;
+	X = DIV_ROUND_UP(VidWinWid * 64, tvn->Wa);
 	We = (VidWinWid * 64) / X;
 	HorDcm = 64 - X;
 	hcrop1 = 2 * ((tvn->Wa - We) / 4);
@@ -403,7 +403,7 @@ zr36057_set_vfe (struct zoran           
 	/* Vertical */
 	DispMode = !(video_height > BUZ_MAX_HEIGHT / 2);
 	VidWinHt = DispMode ? video_height : video_height / 2;
-	Y = (VidWinHt * 64 * 2 + tvn->Ha - 1) / tvn->Ha;
+	Y = DIV_ROUND_UP(VidWinHt * 64 * 2, tvn->Ha);
 	He = (VidWinHt * 64) / Y;
 	VerDcm = 64 - Y;
 	vcrop1 = (tvn->Ha / 2 - He) / 2;
